#ifndef HABITMODEL_H
#define HABITMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include "habit.h"

class HabitModel : public QAbstractListModel
{
    Q_OBJECT    

public:
    enum HabitRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        DescriptionRole,
        CurrentStreakRole,
        BestStreakRole,
        CompletedDatesRole,
        CompletedDaysListRole
    };

    explicit HabitModel(QObject *parent = nullptr);

    // Базовые методы модели
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;

    // Методы для управления привычками
    Q_INVOKABLE void addHabit(const QString& name, const QString& description);
    Q_INVOKABLE void removeHabit(int index);
    Q_INVOKABLE void updateHabit(int index, const QString& name, const QString& description);
    Q_INVOKABLE void toggleDayCompletion(int index, const QDate& date);

    // Доступ к объекту Habit по индексу
    Q_INVOKABLE Habit* getHabit(int index) const;

signals:
    void habitAdded(int index);
    void habitRemoved(int index);
    void habitUpdated(int index);

private:
    QList<Habit*> m_habits;
};

#endif // HABITMODEL_H
