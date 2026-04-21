#include "habitmodel.h"
#include <QUuid>

HabitModel::HabitModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int HabitModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_habits.size();
}

QVariant HabitModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_habits.size()) {
        return QVariant();
    }

    Habit* habit = m_habits[index.row()];

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
    case CompletedDaysListRole:
        return habit->completedDaysList();
    default:
        return QVariant();
    }
}

bool HabitModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() < 0 || index.row() >= m_habits.size()) {
        return false;
    }

    Habit* habit = m_habits[index.row()];

    switch (role) {
    case NameRole:
        habit->setName(value.toString());
        break;
    case DescriptionRole:
        habit->setDescription(value.toString());
        break;
    case CurrentStreakRole:
        habit->setCurrentStreak(value.toInt());
        break;
    case BestStreakRole:
        habit->setBestStreak(value.toInt());
        break;
    case CompletedDatesRole:
        habit->setCompletedDates(value.value<QList<QDate>>());
        break;
    default:
        return false;
    }

    emit dataChanged(index, index, {role});
    return true;
}

QHash<int, QByteArray> HabitModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "habitId";
    roles[NameRole] = "habitName";
    roles[DescriptionRole] = "description";
    roles[CurrentStreakRole] = "currentStreak";
    roles[BestStreakRole] = "bestStreak";
    roles[CompletedDatesRole] = "completedDates";
    roles[CompletedDaysListRole] = "completedDaysList";
    return roles;
}

void HabitModel::addHabit(const QString& name, const QString& description)
{
    beginInsertRows(QModelIndex(), m_habits.size(), m_habits.size());
    Habit* newHabit = new Habit(name, description, this);
    m_habits.append(newHabit);
    endInsertRows();
    emit habitAdded(m_habits.size() - 1);
}

void HabitModel::removeHabit(int index)
{
    if (index < 0 || index >= m_habits.size()) {
        return;
    }

    beginRemoveRows(QModelIndex(), index, index);
    Habit* habit = m_habits.takeAt(index);
    habit->deleteLater();
    endRemoveRows();
    emit habitRemoved(index);
}

void HabitModel::updateHabit(int index, const QString& name, const QString& description)
{
    if (index < 0 || index >= m_habits.size()) {
        return;
    }

    Habit* habit = m_habits[index];
    habit->setName(name);
    habit->setDescription(description);

    QModelIndex idx = createIndex(index, 0);
    emit dataChanged(idx, idx, {NameRole, DescriptionRole});
    emit habitUpdated(index);
}

void HabitModel::toggleDayCompletion(int index, const QDate& date)
{
    if (index < 0 || index >= m_habits.size()) {
        return;
    }

    Habit* habit = m_habits[index];
    habit->toggleDayCompletion(date);

    QModelIndex idx = createIndex(index, 0);
    emit dataChanged(idx, idx, {CurrentStreakRole, BestStreakRole, CompletedDatesRole, CompletedDaysListRole});
}

Habit* HabitModel::getHabit(int index) const
{
    if (index < 0 || index >= m_habits.size()) {
        return nullptr;
    }
    return m_habits[index];
}
