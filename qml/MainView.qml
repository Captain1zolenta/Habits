import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Habits

Rectangle {
    id: root
    color: "#0a0a0a"

    // Заголовок
    Text {
        id: headerTitle
        text: "Мои Цели"
        font.pixelSize: 24
        font.bold: true
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ColumnLayout {
        anchors.top: headerTitle.bottom
        anchors.bottom: bottomNav.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        //spacing: 200

        Tasks {
            Layout.fillWidth: true
        }

        // Секция "Привычки"
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Привычки"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#ffffff"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: ""
                    font.pixelSize: 12
                    color: "#888888"
                }
            }

            // Список привычек
            ListView {
                id: habitsListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12
                clip: true

                // Используем модель из C++
                model: habitModel

                delegate: HabitCard {
                    id: habitDelegate
                    width: habitsListView.width

                    // Передаем индекс и ссылку на модель для действий
                    habitIndex: index
                    habitModel: root.habitModel // или просто habitModel, если видно контекст

                    // Привязка свойств из модели
                    habitId: model.habitId
                    habitName: model.habitName
                    description: model.description
                    currentStreakValue: model.currentStreak
                    bestStreakValue: model.bestStreak

                    // САМОЕ ВАЖНОЕ: Передаем список дат (QList<QDate>) напрямую
                    // В HabitCard нужно свойство property var completedDates
                    completedDates: model.completedDates

                    // Старые свойства day1..day7 больше не нужны, если мы передаем весь список дат
                    // и вычисляем состояние круга внутри HabitCard на основе даты.
                }

                // Подсказка, если список пуст
                Label {
                    anchors.centerIn: parent
                    text: "Список привычек пуст. Нажмите +, чтобы добавить."
                    color: "#666666"
                    horizontalAlignment: Text.AlignHCenter
                    visible: habitsListView.count === 0
                }
            }
        }
    }

    // Нижняя навигация
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: "#1a1a1a"
        radius: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        RowLayout {
            anchors.centerIn: parent
            spacing: 60

            // Кнопка "+" (Добавить)
            ColumnLayout {
                spacing: 4

                Rectangle {
                    id: addButton
                    width: 60
                    height: 60
                    radius: 30
                    color: "#8b5cf6"
                    Label {
                        text: "+"
                        font.pixelSize: 36
                        color: "#ffffff"
                        anchors.centerIn: parent
                        font.bold: true
                    }

                    TapHandler {
                        onTapped: {
                            console.log("Add new habit clicked")
                            // Добавляем тестовую привычку при клике
                            if (root.habitModel) {
                                root.habitModel.addHabit("Новая цель", "Описание цели");
                            }
                        }
                    }
                }

                Label {
                    text: qsTr("Добавить")
                    font.pixelSize: 10
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Кнопка "Цели" (Tasks)
            ColumnLayout {
                spacing: 4
                Label {
                    text: "✓"
                    font.pixelSize: 22
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: qsTr("Цели")
                    font.pixelSize: 12
                    color: "#ffffff"
                }
                TapHandler {
                    onTapped: console.log("Open Tasks")
                }
            }

            // Кнопка "Привычки" (Habits) - Активная
            ColumnLayout {
                spacing: 4
                Label {
                    text: "●" // Или другая иконка активной вкладки
                    font.pixelSize: 22
                    color: "#4ecdc4" // Выделенный цвет
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: qsTr("Привычки")
                    font.pixelSize: 12
                    color: "#4ecdc4"
                }
                TapHandler {
                    onTapped: console.log("Open Habits (Current)")
                }
            }

            // Кнопка "Настройки"
            ColumnLayout {
                spacing: 4
                Text {
                    text: "⚙"
                    font.pixelSize: 22
                    color: "#888888"
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: qsTr("Настройки")
                    font.pixelSize: 12
                    color: "#888888"
                }
                TapHandler {
                    onTapped: console.log("Open Preference")
                }
            }
        }
    }
}
