#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>
#include <QVariantMap>

class DbManager : public QObject {

    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionChanged)

public:

    DbManager(QObject *parent = nullptr);
    ~DbManager();

    bool isConnected() const {return m_db.isOpen();}
    bool open(const QString &dbPath);

    Q_INVOKABLE QVariantList getAllTasks();
    Q_INVOKABLE bool insertTask(const QString nameTask, const QString describeTask = nullptr, const QString date = nullptr);
    Q_INVOKABLE bool deleteTask(int id);
    Q_INVOKABLE bool createTableTasks();

signals:
    void connectionChanged(bool connected);
    void dataChanged();

private:
    QSqlDatabase m_db;
};
#endif // DBMANAGER_H
