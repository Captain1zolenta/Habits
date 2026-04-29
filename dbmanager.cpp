#include "dbmanager.h"
#include <QDir>
#include <QDebug>
#include <QDate>

DbManager::DbManager(QObject *parent)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE", "main_habits_connection");
}

DbManager::~DbManager()
{
    if (m_db.isOpen()) {m_db.close();}
    // Удаляем подключение только если оно существует в списке
    if (QSqlDatabase::contains("main_habits_connection")) {
    QSqlDatabase::removeDatabase("main_habits_connection");
    }
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

bool DbManager::createTableHabits()
{
    if (!m_db.isOpen()) return false;
    QSqlQuery query(m_db);

    // Таблица самих привычек
    bool habitsTable = query.exec(R"(
        CREATE TABLE IF NOT EXISTS habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            createdDate TEXT DEFAULT CURRENT_DATE
        )
    )");

    if (!habitsTable) {
        qWarning() << "Create table Habits error:" << query.lastError().text();
        return false;
    }

    // Таблица выполнений (связь привычки и даты)
    // Уникальный индекс предотвращает дублирование записей на одну дату
    bool completionsTable = query.exec(R"(
        CREATE TABLE IF NOT EXISTS habit_completions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY(habit_id) REFERENCES habits(id) ON DELETE CASCADE,
            UNIQUE(habit_id, date)
        )
    )");

    if (!completionsTable) {
        qWarning() << "Create table HabitCompletions error:" << query.lastError().text();
        return false;
    }

    return true;
}

QVariantList DbManager::getAllHabits()
{
    QVariantList result;
    if (!m_db.isOpen()) return result;

    QSqlQuery query("SELECT id, name, description, createdDate FROM habits ORDER BY id DESC", m_db);

    while(query.next())
    {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["name"] = query.value(1).toString();
        map["description"] = query.value(2).toString();
        map["createdDate"] = query.value(3).toString();

        // Получаем статистику сразу для удобства (или можно запрашивать отдельно в QML)
        // Но для производительности лучше загружать только список, а статусы дат грузить по требованию или отдельным запросом
        // Здесь возвращаем чистый список, статусы дней будем проверять через isHabitCompleted

        result.append(map);
    }
    return result;
}

bool DbManager::insertHabit(const QString name, const QString description)
{
    if (!m_db.isOpen()) return false;
    QSqlQuery query(m_db);
    query.prepare("INSERT INTO habits (name, description) VALUES (:name, :desc)");
    query.bindValue(":name", name);
    query.bindValue(":desc", description);

    bool execResult = query.exec();

    if (execResult) emit habitsDataChanged();
    else qWarning() << "Insert Habit error:" << query.lastError().text();
    return execResult;
}

bool DbManager::updateHabit(int id, const QString name, const QString description)
{
    if (!m_db.isOpen()) return false;
    QSqlQuery query(m_db);
    query.prepare("UPDATE habits SET name = :name, description = :desc WHERE id = :id");
    query.bindValue(":name", name);
    query.bindValue(":desc", description);
    query.bindValue(":id", id);

    bool execResult = query.exec();

    if (execResult) emit habitsDataChanged();
    else qWarning() << "Update Habit error:" << query.lastError().text();
    return execResult;
}

bool DbManager::deleteHabit(int id)
{
    if (!m_db.isOpen()) return false;
    QSqlQuery query(m_db);
    // Каскадное удаление сработает благодаря FOREIGN KEY, но явно удалим записи из completions для надежности
    query.prepare("DELETE FROM habit_completions WHERE habit_id = :id");
    query.bindValue(":id", id);
    query.exec();

    query.prepare("DELETE FROM habits WHERE id = :id");
    query.bindValue(":id", id);

    bool execResult = query.exec();

    if (execResult) emit habitsDataChanged();
    else qWarning() << "Delete Habit error:" << query.lastError().text();
    return execResult;
}

bool DbManager::toggleHabitCompletion(int habitId, const QString &dateStr)
{
    if (!m_db.isOpen()) return false;

    // Проверяем, есть ли запись
    bool completed = isHabitCompleted(habitId, dateStr);

    QSqlQuery query(m_db);
    bool execResult = false;

    if (completed) {
        // Если выполнено -> удаляем запись (снимаем галочку)
        query.prepare("DELETE FROM habit_completions WHERE habit_id = :id AND date = :date");
        query.bindValue(":id", habitId);
        query.bindValue(":date", dateStr);
        execResult = query.exec();
    } else {
        // Если не выполнено -> добавляем запись
        query.prepare("INSERT OR IGNORE INTO habit_completions (habit_id, date) VALUES (:id, :date)");
        query.bindValue(":id", habitId);
        query.bindValue(":date", dateStr);
        execResult = query.exec();
    }

    if (execResult) emit habitsDataChanged();
    else qWarning() << "Toggle Habit Completion error:" << query.lastError().text();

    return execResult;
}

bool DbManager::isHabitCompleted(int habitId, const QString &dateStr)
{
    if (!m_db.isOpen()) return false;

    QSqlQuery query(m_db);
    query.prepare("SELECT COUNT(*) FROM habit_completions WHERE habit_id = :id AND date = :date");
    query.bindValue(":id", habitId);
    query.bindValue(":date", dateStr);

    if (query.exec() && query.next()) {
        return query.value(0).toInt() > 0;
    }
    return false;
}

QVariantMap DbManager::getHabitStats(int habitId)
{
    QVariantMap stats;
    stats["currentStreak"] = calculateStreak(habitId, true);  // Считаем от сегодня назад
    stats["bestStreak"] = calculateStreak(habitId, false);    // Считаем максимальную серию за все время
    return stats;
}

int DbManager::calculateStreak(int habitId, bool backward)
{
    if (!m_db.isOpen()) return 0;

    // Получаем все даты выполнения для этой привычки, отсортированные по убыванию
    QSqlQuery query(m_db);
    query.prepare("SELECT date FROM habit_completions WHERE habit_id = :id ORDER BY date DESC");
    query.bindValue(":id", habitId);

    if (!query.exec()) return 0;

    QList<QDate> dates;
    while(query.next()) {
        dates.append(QDate::fromString(query.value(0).toString(), Qt::ISODate));
    }

    if (dates.isEmpty()) return 0;

    if (backward) {
        // Расчет текущей серии (должна начинаться с сегодня или вчера, если сегодня еще не отмечено)
        QDate today = QDate::currentDate();
        QDate expectedDate = today;

        // Если сегодня еще не выполнено, проверяем, выполнена ли вчерашняя (серия продолжается)
        if (dates.first() != today) {
            if (dates.first() == today.addDays(-1)) {
                expectedDate = today.addDays(-1);
            } else {
                return 0; // Серия прервалась
            }
        }

        int streak = 0;
        for (const QDate &d : dates) {
            if (d == expectedDate) {
                streak++;
                expectedDate = expectedDate.addDays(-1);
            } else if (d < expectedDate) {
                // Пропуск дней, серия кончилась
                break;
            }
        }
        return streak;

    } else {
        // Расчет лучшей серии за все время
        if (dates.isEmpty()) return 0;

        int maxStreak = 1;
        int currentStreak = 1;

        // Даты уже отсортированы от новых к старым
        for (int i = 0; i < dates.size() - 1; ++i) {
            QDate current = dates[i];
            QDate next = dates[i+1];

            if (current.daysTo(next) == -1) { // Следующая дата ровно на 1 день меньше (вчера)
                currentStreak++;
            } else {
                if (currentStreak > maxStreak) maxStreak = currentStreak;
                currentStreak = 1;
            }
        }
        if (currentStreak > maxStreak) maxStreak = currentStreak;

        return maxStreak;
    }
}
