import QtQuick
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
        anchors.margins: 16
        spacing: 20


        Tasks {

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
                        currentStreak: "33 дня подряд"
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"
                    }
                    ListElement {
                        habitName: "Физ занятия"
                        currentStreak: "0 дней подряд"
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"
                    }
                    ListElement {
                        habitName: "Кодить"
                        currentStreak: "1 день подряд"
                        day01: "09"; day02: "10"; day03: "11"
                        day04: "12"; day05: "13"; day06: "14"; day07: "15"
                    }
                }

                delegate: Rectangle {
                    width: habitsListView.width
                    height: habitContent.implicitHeight + 24
                    radius: 16
                    color: "#1a2f2f"

                    ColumnLayout {
                        id: habitContent
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        // Название и счетчик
                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: model.habitName
                                font.pixelSize: 16
                                font.bold: true
                                color: "#4ecdc4"
                                Layout.fillWidth: true
                            }

                            Text {
                                text: model.currentStreak
                                font.pixelSize: 12
                                color: "#888888"
                            }
                        }

                        // Дни недели
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Repeater {
                                model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData
                                        font.pixelSize: 11
                                        color: "#888888"
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Rectangle {
                                        implicitWidth: 38
                                        implicitHeight: 38
                                        radius: 19
                                        color: "#2a4a4a"

                                        Text {
                                            text: {
                                                if (index === 0) return model.day01
                                                if (index === 1) return model.day02
                                                if (index === 2) return model.day03
                                                if (index === 3) return model.day04
                                                if (index === 4) return model.day05
                                                if (index === 5) return model.day06
                                                return model.day07
                                            }
                                            anchors.centerIn: parent
                                            color: "#ffffff"
                                            font.pixelSize: 13
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }

                        // Кнопки управления
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            spacing: 8

                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 32
                                radius: 8
                                color: "#2a4a4a"

                                Text {
                                    text: "Редактировать"
                                    anchors.centerIn: parent
                                    color: "#4ecdc4"
                                    font.pixelSize: 12
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: console.log("Edit:", model.habitName)
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 32
                                radius: 8
                                color: "#3a1a1a"

                                Text {
                                    text: "Удалить"
                                    anchors.centerIn: parent
                                    color: "#ff6b6b"
                                    font.pixelSize: 12
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: console.log("Delete:", model.habitName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Кнопка "+"
    Rectangle {
        id: addButton
        width: 60
        height: 60
        radius: 30
        color: "#8b5cf6"
        anchors.right: parent.right
        anchors.bottom: bottomNav.top
        anchors.rightMargin: 24
        anchors.bottomMargin: 80

        Text {
            text: "+"
            font.pixelSize: 36
            color: "#ffffff"
            anchors.centerIn: parent
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Add new habit")
                // addEditDialog.open()
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

                Text {
                    text: "✓"
                    font.pixelSize: 22
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Цели"
                    font.pixelSize: 12
                    color: "#ffffff"
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
                    text: "Настройки"
                    font.pixelSize: 12
                    color: "#888888"
                }
            }
        }
    }
}
