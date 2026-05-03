#include "habitmodel.h"
#include "dbmanager.h"
#include <algorithm>

HabitModel::HabitModel(DbManager *dbManager, QObject *parent)
    : QAbstractListModel(parent), m_dbManager(dbManager)
{
    loadHabitsFromDb();
}

HabitModel::~HabitModel()
{
    qDeleteAll(m_habits);
}

void HabitModel::loadHabitsFromDb()
{
    if (!m_dbManager) return;

    beginResetModel();
    qDeleteAll(m_habits);
    m_habits.clear();

    QVariantList habitsFromDb = m_dbManager->getAllHabits();

    for (const QVariant &h : habitsFromDb) {
        QVariantMap habitMap = h.toMap();
        Habit *habit = new Habit(this);
        habit->setId(QString::number(habitMap["id"].toInt()));
        habit->setName(habitMap["name"].toString());
        habit->setDescription(habitMap["description"].toString());

        // Загружаем даты выполнения для этой привычки
        QList<QDate> completedDates;
        QDate today = QDate::currentDate();
        for (int i = 0; i < 365; ++i) {
            QDate date = today.addDays(-i);
            if (m_dbManager->isHabitCompleted(habitMap["id"].toInt(), date.toString(Qt::ISODate))) {
                completedDates.append(date);
            }
        }
        habit->setCompletedDates(completedDates);

        calculateStreaks(habit);
        m_habits.append(habit);
    }
    endResetModel();
}

int HabitModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_habits.count();
}

QVariant HabitModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_habits.count())
        return QVariant();

    Habit *habit = m_habits.at(index.row());

    switch (role) {
    case IdRole:
        return habit->id();
    case NameRole:
        return habit->name();
    case DescriptionRole:
        return habit->description();
    case CurrentStreakRole:
        return habit->currentStreak();
    case BestStreakRole:
        return habit->bestStreak();
    case CompletedDatesRole:
        return QVariant::fromValue(habit->completedDates());
    case CompletedDaysListRole: {
        QList<QVariant> days;
        QDate today = QDate::currentDate();
        for (int i = 6; i >= 0; --i) {
            QDate d = today.addDays(-i);
            days.append(habit->completedDates().contains(d));
        }
        return days;
    }
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> HabitModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "habitId";
    roles[NameRole] = "name";
    roles[DescriptionRole] = "description";
    roles[CurrentStreakRole] = "currentStreak";
    roles[BestStreakRole] = "bestStreak";
    roles[CompletedDatesRole] = "completedDates";
    roles[CompletedDaysListRole] = "completedDaysList";
    return roles;
}

void HabitModel::addHabit(const QString &name, const QString &description)
{
    if (!m_dbManager) return;

    if (!m_dbManager->insertHabit(name, description)) return;

    // Получаем ID только что добавленной привычки
    QVariantList habits = m_dbManager->getAllHabits();
    if (habits.isEmpty()) return;

    QVariantMap habitMap = habits.first().toMap();

    Habit *newHabit = new Habit(this);
    newHabit->setId(QString::number(habitMap["id"].toInt()));
    newHabit->setName(name);
    newHabit->setDescription(description);

    calculateStreaks(newHabit);

    beginInsertRows(QModelIndex(), m_habits.count(), m_habits.count());
    m_habits.append(newHabit);
    endInsertRows();

    emit habitAdded(m_habits.count() - 1);
}

void HabitModel::removeHabit(int index)
{
    if (index < 0 || index >= m_habits.count() || !m_dbManager) return;

    Habit *habit = m_habits.at(index);
    int habitId = habit->id().toInt();

    m_dbManager->deleteHabit(habitId);

    beginRemoveRows(QModelIndex(), index, index);
    m_habits.removeAt(index);
    delete habit;
    endRemoveRows();

    emit habitRemoved(index);
}

void HabitModel::updateHabit(int index, const QString &name, const QString &description)
{
    if (index < 0 || index >= m_habits.count() || !m_dbManager) return;

    Habit *habit = m_habits.at(index);
    habit->setName(name);
    habit->setDescription(description);

    int habitId = habit->id().toInt();
    m_dbManager->updateHabit(habitId, name, description);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {NameRole, DescriptionRole});
    emit habitUpdated(index);
}

void HabitModel::toggleDayCompletion(int index, const QDate &date)
{
    if (index < 0 || index >= m_habits.count() || !m_dbManager) return;

    Habit *habit = m_habits.at(index);
    int habitId = habit->id().toInt();

    bool wasCompleted = habit->completedDates().contains(date);

    if (wasCompleted) {
        QList<QDate> dates = habit->completedDates();
        dates.removeAll(date);
        habit->setCompletedDates(dates);
        m_dbManager->toggleHabitCompletion(habitId, date.toString(Qt::ISODate));
    } else {
        QList<QDate> dates = habit->completedDates();
        dates.append(date);
        habit->setCompletedDates(dates);
        m_dbManager->toggleHabitCompletion(habitId, date.toString(Qt::ISODate));
    }

    calculateStreaks(habit);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0),
                     {CurrentStreakRole, BestStreakRole, CompletedDaysListRole, CompletedDatesRole});
}

QString HabitModel::getHabitId(int index) const
{
    if (index < 0 || index >= m_habits.count()) return QString();
    return m_habits.at(index)->id();
}

void HabitModel::calculateStreaks(Habit *habit)
{
    if (!habit) return;

    QList<QDate> dates = habit->completedDates();
    if (dates.isEmpty()) {
        habit->setCurrentStreak(0);
        habit->setBestStreak(0);
        return;
    }

    std::sort(dates.begin(), dates.end(), std::greater<QDate>());

    int currentStreak = 0;
    QDate today = QDate::currentDate();
    QDate expectedDate = today;

    if (dates.first() == today) {
        currentStreak = 1;
        expectedDate = today.addDays(-1);
    } else if (dates.first() == today.addDays(-1)) {
        currentStreak = 1;
        expectedDate = today.addDays(-2);
    } else {
        currentStreak = 0;
        expectedDate = QDate();
    }

    if (currentStreak > 0) {
        for (int i = 1; i < dates.size(); ++i) {
            if (dates[i] == expectedDate) {
                currentStreak++;
                expectedDate = expectedDate.addDays(-1);
            } else if (dates[i] < expectedDate) {
                break;
            }
        }
    }

    int bestStreak = currentStreak;
    int tempStreak = 1;
    for (int i = 0; i < dates.size() - 1; ++i) {
        if (dates[i].addDays(-1) == dates[i+1]) {
            tempStreak++;
        } else {
            if (tempStreak > bestStreak) bestStreak = tempStreak;
            tempStreak = 1;
        }
    }
    if (tempStreak > bestStreak) bestStreak = tempStreak;

    habit->setCurrentStreak(currentStreak);
    habit->setBestStreak(bestStreak);
}

bool HabitModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_habits.count())
        return false;

    Habit *habit = m_habits.at(index.row());

    switch (role) {
    case NameRole:
        habit->setName(value.toString());
        break;
    case DescriptionRole:
        habit->setDescription(value.toString());
        break;
    case CompletedDatesRole:
        habit->setCompletedDates(value.value<QList<QDate>>());
        calculateStreaks(habit);
        break;
    default:
        return false;
    }

    emit dataChanged(index, index, {role});
    return true;
}
