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
                    text: "▼"
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

                model: ListModel {
                    ListElement {
                        habitName: "Учить языки"
                        description: "Изучать английский по 30 минут"
                        currentStreak: 33
                        bestStreak: 0
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"
                    }
                    ListElement {
                        habitName: "Физ занятия"
                        description: "Пробежка 20 минут"
                        currentStreak: 0
                        bestStreak: 0
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"                        
                    }
                    ListElement {
                        habitName: "Кодить"
                        description: "Писать код на Qt/QML"
                        currentStreak: 1
                        bestStreak: 0
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"                        
                    }
                }

                // ИСПРАВЛЕНО: delegate использует HabitCard
                delegate: HabitCard {
                    width: habitsListView.width
                    habitName: modelData.habitName
                    description: modelData.description
                    currentStreakValue: modelData.currentStreak
                    bestStreakValue: modelData.bestStreak
                    // Передаём дни и выполненные дни в HabitCard
                    day1: modelData.day01; day2: modelData.day02; day3: modelData.day03
                    day4: modelData.day04; day5: modelData.day05; day6: modelData.day06; day7: modelData.day07
                    completedDays: modelData.completedDays || [] // если есть в модели
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
                        onTapped: console.log("Add new habit")
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
