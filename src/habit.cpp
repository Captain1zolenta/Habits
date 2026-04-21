#include "habit.h"
#include <QDateTime>
#include <algorithm>

Habit::Habit(QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString())
    , m_currentStreak(0)
    , m_bestStreak(0)
{
}

Habit::Habit(const QString& name, const QString& description, QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString())
    , m_name(name)
    , m_description(description)
    , m_currentStreak(0)
    , m_bestStreak(0)
{
}

void Habit::setId(const QString& id)
{
    if (m_id != id) {
        m_id = id;
        emit idChanged();
    }
}

void Habit::setName(const QString& name)
{
    if (m_name != name) {
        m_name = name;
        emit nameChanged();
    }
}

void Habit::setDescription(const QString& description)
{
    if (m_description != description) {
        m_description = description;
        emit descriptionChanged();
    }
}

void Habit::setCurrentStreak(int streak)
{
    if (m_currentStreak != streak) {
        m_currentStreak = streak;
        emit currentStreakChanged();
    }
}

void Habit::setBestStreak(int streak)
{
    if (m_bestStreak != streak) {
        m_bestStreak = streak;
        emit bestStreakChanged();
    }
}

void Habit::setCompletedDates(const QList<QDate>& dates)
{
    if (m_completedDates != dates) {
        m_completedDates = dates;
        calculateStreaks();
        emit completedDatesChanged();
    }
}

QStringList Habit::completedDaysList() const
{
    QStringList result;
    for (const QDate& date : m_completedDates) {
        result << date.toString("dd");
    }
    return result;
}

void Habit::toggleDayCompletion(const QDate& date)
{
    QDate normalizedDate = date.startOfDay();

    int index = -1;
    for (int i = 0; i < m_completedDates.size(); ++i) {
        if (m_completedDates[i] == normalizedDate) {
            index = i;
            break;
        }
    }

    if (index >= 0) {
        m_completedDates.removeAt(index);
    } else {
        m_completedDates.append(normalizedDate);
        std::sort(m_completedDates.begin(), m_completedDates.end());
    }

    calculateStreaks();
    emit completedDatesChanged();
}

int Habit::countConsecutiveDays(const QList<QDate>& sortedDates) const
{
    if (sortedDates.isEmpty()) {
        return 0;
    }

    int streak = 1;
    QDate currentDate = sortedDates.last();

    for (int i = sortedDates.size() - 2; i >= 0; --i) {
        QDate expectedPrevDate = currentDate.addDays(-1);
        if (sortedDates[i] == expectedPrevDate) {
            streak++;
            currentDate = sortedDates[i];
        } else if (sortedDates[i] < expectedPrevDate) {
            // Прерывание серии
            break;
        }
        // Если дата равна текущей (дубликат), пропускаем
    }

    return streak;
}

void Habit::calculateStreaks()
{
    if (m_completedDates.isEmpty()) {
        setCurrentStreak(0);
        return;
    }

    // Сортируем даты
    QList<QDate> sortedDates = m_completedDates;
    std::sort(sortedDates.begin(), sortedDates.end());

    // Подсчитываем текущую серию (от последней даты назад)
    int current = countConsecutiveDays(sortedDates);
    setCurrentStreak(current);

    // Подсчитываем лучшую серию
    int best = 0;
    int tempStreak = 1;

    for (int i = 1; i < sortedDates.size(); ++i) {
        QDate expectedPrevDate = sortedDates[i].addDays(-1);
        if (sortedDates[i-1] == expectedPrevDate) {
            tempStreak++;
        } else if (sortedDates[i-1] < expectedPrevDate) {
            // Прерывание серии
            if (tempStreak > best) {
                best = tempStreak;
            }
            tempStreak = 1;
        }
        // Если даты равны (дубликат), пропускаем
    }

    if (tempStreak > best) {
        best = tempStreak;
    }

    setBestStreak(best);
}
