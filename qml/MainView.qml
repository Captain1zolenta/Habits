import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Habits

Rectangle {
    id: root
    color: "#0a0a0a"

    // Модель привычек единый экземпляр
        HabitModel {
            id: habitModel
        }

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
                    text: "▼"
                    font.pixelSize: 12
                    color: "#888888"
                }
            }

            // Список привычек с использованием модели
            ListView {
                id: habitsListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12
                clip: true                

                model: habitModel

                delegate: HabitCard {
                    width: habitsListView.width                    
                    habitIndex: index
                    habitModel: habitModel

                    habitId: model.habitId
                    habitName: model.habitName
                    description: model.description
                    currentStreakValue: model.currentStreak
                    bestStreakValue: model.bestStreak

                    // Передаём дни из completedDaysList (массив строк "DD")
                    day1: model.completedDaysList && model.completedDaysList.length > 0 ? model.completedDaysList[0] : ""
                    day2: model.completedDaysList && model.completedDaysList.length > 1 ? model.completedDaysList[1] : ""
                    day3: model.completedDaysList && model.completedDaysList.length > 2 ? model.completedDaysList[2] : ""
                    day4: model.completedDaysList && model.completedDaysList.length > 3 ? model.completedDaysList[3] : ""
                    day5: model.completedDaysList && model.completedDaysList.length > 4 ? model.completedDaysList[4] : ""
                    day6: model.completedDaysList && model.completedDaysList.length > 5 ? model.completedDaysList[5] : ""
                    day7: model.completedDaysList && model.completedDaysList.length > 6 ? model.completedDaysList[6] : ""

                    completedDaysList: model.completedDaysList || []
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

            ColumnLayout {
                spacing: 4

                // Кнопка "+"
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
                            console.log("Add new habit")
                            habitModel.addHabit("Новая привычка", "Описание")
                        }
                    }
                }
            }

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

            ColumnLayout {
                spacing: 4

                Label {
                    text: "✓"
                    font.pixelSize: 22
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: qsTr("Привычки")
                    font.pixelSize: 12
                    color: "#ffffff"
                }

                TapHandler {
                    onTapped: console.log("Open Habits")
                }
            }

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
