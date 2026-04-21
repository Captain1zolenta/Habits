#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QQmlContext>
#include "src/habitmodel.h"

Q_DECLARE_METATYPE(Habit*)

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);    

    qRegisterMetaType<Habit*>();

    qmlRegisterType<HabitModel>("Habits", 1, 0, "HabitModel");
    qmlRegisterType<Habit>("Habits", 1, 0, "Habit");

    QQmlApplicationEngine engine;
    HabitModel model;
    engine.rootContext()->setContextProperty("habitModel", &model);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Habits", "Main");

    return app.exec();
}
