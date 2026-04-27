#include "dbmanager.h"
#include <QDir>
#include <QDebug>

DbManager::DbManager(QObject *parent)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE", "main_habits_connection");
}

DbManager::~DbManager()
{
    if (m_db.isOpen()) m_db.close();
    QSqlDatabase::removeDatabase("main_habits_connection");
}

bool DbManager::open(const QString &dbPath)
{
    m_db.setDatabaseName(dbPath);
    bool openDbResult = m_db.open();
    if (!openDbResult) qWarning () << "DB open error:" << m_db.lastError().text();
    emit connectionChanged(openDbResult);
    return openDbResult;

}

QVariantList DbManager::getAllTasks()
{
    QVariantList result;
    QSqlQuery query("SELECT id, nameTask, describeTask, dateTask FROM tasks", m_db);

    while(query.next())
    {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["nameTask"] = query.value(1).toString();
        map["describeTask"] = query.value(2).toString();
        map["dateTask"] = query.value(3).toString();
        result.append(map);
    }
    return result;
}

bool DbManager::insertTask(const QString nameTask, const QString describeTask, const QString dateTask)
{
    QSqlQuery query(m_db);
    query.prepare("INSERT INTO tasks (nameTask, describeTask, dateTask) VALUES (:nameTask, :describeTask, :dateTask)");
    query.bindValue(":nameTask", nameTask);
    query.bindValue(":describeTask", describeTask);
    query.bindValue(":dateTask", dateTask);

    bool openDbResult = query.exec();

    if (openDbResult) emit dataChanged();
    else qWarning() << "Insert error:" << query.lastError().text();
    return openDbResult;
}

bool DbManager::deleteTask(int id)
{
    QSqlQuery query(m_db);
    query.prepare("DELETE FROM tasks WHERE id = :id");
    query.bindValue(":id", id);

    bool openDbResult = query.exec();

    if (openDbResult) emit dataChanged();
    else qWarning() << "Delete error:" << query.lastError().text();
    return openDbResult;
}

bool DbManager::createTableTasks()
{
    QSqlQuery query(m_db);
    bool openDbResult = query.exec(R"(
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nameTask TEXT NOT NULL,
            describeTask TEXT,
            dateTask TEXT
        )
    )");
    if (!openDbResult) qWarning() << "Create table error:" << query.lastError().text();
    return openDbResult;
}

bool DbManager::updateTask(int id, const QString nameTask, const QString describeTask, const QString dateTask)
{
    QSqlQuery query(m_db);
    query.prepare("UPDATE tasks SET nameTask = :nameTask, describeTask = :describeTask, dateTask = :dateTask WHERE id = :id");
    query.bindValue(":nameTask", nameTask);
    query.bindValue(":describeTask", describeTask);
    query.bindValue(":dateTask", dateTask);
    query.bindValue(":id", id);

    bool openDbResult = query.exec();

    if (openDbResult) emit dataChanged();
    else qWarning() << "Delete error:" << query.lastError().text();
    return openDbResult;
}


