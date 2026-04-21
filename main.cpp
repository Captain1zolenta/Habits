#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QQmlContext>
#include "src/habitmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<HabitModel>("Habits", 1, 0, "HabitModel");
    qmlRegisterType<Habit>("Habits", 1, 0, "Habit");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Habits", "Main");

    return app.exec();
}
