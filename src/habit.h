#ifndef HABIT_H
#define HABIT_H

#include <QObject>
#include <QString>
#include <QList>
#include <QDate>
#include <QUuid>
#include <QMap>
#include <QVariant>

class Habit : public QObject
{
    Q_OBJECT

    // Основные свойства
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

    // Счётчики серий
    Q_PROPERTY(int currentStreak READ currentStreak WRITE setCurrentStreak NOTIFY currentStreakChanged)
    Q_PROPERTY(int bestStreak READ bestStreak WRITE setBestStreak NOTIFY bestStreakChanged)

    // Дни недели (completedDays хранит даты завершений)
    Q_PROPERTY(QList<QDate> completedDates READ completedDates WRITE setCompletedDates NOTIFY completedDatesChanged)

    // Для QML: массив строк с датами в формате "DD"
    Q_PROPERTY(QStringList completedDaysList READ completedDaysList NOTIFY completedDatesChanged)

public:
    explicit Habit(QObject *parent = nullptr);
    Habit(const QString& name, const QString& description, QObject *parent = nullptr);

    // Getters
    QString id() const { return m_id; }
    QString name() const { return m_name; }
    QString description() const { return m_description; }
    int currentStreak() const { return m_currentStreak; }
    int bestStreak() const { return m_bestStreak; }
    QList<QDate> completedDates() const { return m_completedDates; }
    QStringList completedDaysList() const;

    // Setters
    void setId(const QString& id);
    void setName(const QString& name);
    void setDescription(const QString& description);
    void setCurrentStreak(int streak);
    void setBestStreak(int streak);
    void setCompletedDates(const QList<QDate>& dates);

    // Методы для работы с привычкой
    Q_INVOKABLE void toggleDayCompletion(const QDate& date);
    Q_INVOKABLE void calculateStreaks();

signals:
    void idChanged();
    void nameChanged();
    void descriptionChanged();
    void currentStreakChanged();
    void bestStreakChanged();
    void completedDatesChanged();

private:
    QString m_id;
    QString m_name;
    QString m_description;
    int m_currentStreak = 0;
    int m_bestStreak = 0;
    QList<QDate> m_completedDates;

    // Вспомогательный метод для подсчёта серии
    int countConsecutiveDays(const QList<QDate>& sortedDates) const;
};

#endif // HABIT_H
