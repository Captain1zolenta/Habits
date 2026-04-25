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

    // Регистрация типов для QML
    qmlRegisterType<HabitModel>("Habits", 1, 0, "HabitModel");
    qmlRegisterType<Habit>("Habits", 1, 0, "Habit");

    QQmlApplicationEngine engine;
    // Создаем модель и добавляем тестовые данные
    HabitModel model;

    // Добавляем тестовую привычку 1
    model.addHabit("Зарядка", "Делать зарядку каждое утро");
    // Добавляем тестовую привычку 2
    model.addHabit("Чтение", "Читать 30 минут перед сном");
    // Получаем доступ к первой привычке и отмечаем сегодня и вчера (для теста серий)
    if (Habit* h = model.getHabit(0)) {
        h->toggleDayCompletion(QDate::currentDate());
        h->toggleDayCompletion(QDate::currentDate().addDays(-1));
        h->toggleDayCompletion(QDate::currentDate().addDays(-2));
    }

     // Передаем модель в QML
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
