#ifndef HABITMODEL_H
#define HABITMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QDate>
#include "habit.h"

class DbManager;

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

    explicit HabitModel(DbManager *dbManager, QObject *parent = nullptr);
    ~HabitModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addHabit(const QString& name, const QString& description);
    Q_INVOKABLE void removeHabit(int index);
    Q_INVOKABLE void updateHabit(int index, const QString& name, const QString& description);
    Q_INVOKABLE void toggleDayCompletion(int index, const QDate& date);
    Q_INVOKABLE QString getHabitId(int index) const;

signals:
    void habitAdded(int index);
    void habitRemoved(int index);
    void habitUpdated(int index);

private:
    void loadHabitsFromDb();
    void calculateStreaks(Habit *habit);

    QList<Habit*> m_habits;
    DbManager *m_dbManager;
};

#endif // HABITMODEL_H
