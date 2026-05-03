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

    QList<Habit*> habitsFromDb = m_dbManager->getAllHabits();

    for (Habit *h : habitsFromDb) {
        calculateStreaks(h);
        m_habits.append(h);
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

    Habit *newHabit = m_dbManager->addHabitToDb(name, description);
    if (!newHabit) return;

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

    m_dbManager->removeHabitFromDb(habit->id());

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

    m_dbManager->updateHabitInDb(habit);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {NameRole, DescriptionRole});
    emit habitUpdated(index);
}

void HabitModel::toggleDayCompletion(int index, const QDate &date)
{
    if (index < 0 || index >= m_habits.count() || !m_dbManager) return;

    Habit *habit = m_habits.at(index);
    bool wasCompleted = habit->completedDates().contains(date);

    if (wasCompleted) {
        habit->removeCompletedDate(date);
        m_dbManager->removeHabitCompletion(habit->id(), date);
    } else {
        habit->addCompletedDate(date);
        m_dbManager->addHabitCompletion(habit->id(), date);
    }

    calculateStreaks(habit);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0),
                     {CurrentStreakRole, BestStreakRole, CompletedDaysListRole, CompletedDatesRole});
}

int HabitModel::getHabitId(int index) const
{
    if (index < 0 || index >= m_habits.count()) return -1;
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
