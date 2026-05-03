#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QFileInfo>
#include "dbmanager.h"
#include <QQmlContext>
#include "src/habitmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Habits.db";
    QDir().mkpath(QFileInfo(dbPath).absolutePath());

    DbManager dbManager;
    dbManager.open(dbPath);
    dbManager.createTableTasks();
    dbManager.createTableHabits();

    HabitModel habitModel(&dbManager);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("habitModel", &habitModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Habits", "Main");

    return app.exec();
}
