import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


// Секция "Задачи"
ColumnLayout {
    Layout.fillWidth: true
    spacing: 10

    property bool showDetails: false

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: "Задачи"
            font.pixelSize: 22
            font.bold: true
            color: "#ffffff"
        }

        Item { Layout.fillWidth: true }

        Text {
            text: "▼"
            font.pixelSize: 12
            color: "#888888"

            TapHandler {
                onTapped: {
                    bar.visible = !bar.visible
                    tasks.visible = !tasks.visible
                }
            }
        }
    }

    /*// Табы
    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        Rectangle {
            implicitWidth: 100
            implicitHeight: 36
            radius: 18
            color: "#333333"

            Text {
                text: "Сегодня"
                anchors.centerIn: parent
                color: "#ffffff"
                font.pixelSize: 13
            }
        }

        Rectangle {
            implicitWidth: 100
            implicitHeight: 36
            radius: 18
            color: "transparent"

            Text {
                text: "Завтра"
                anchors.centerIn: parent
                color: "#888888"
                font.pixelSize: 13
            }
        }

        Rectangle {
            implicitWidth: 120
            implicitHeight: 36
            radius: 18
            color: "transparent"

            Text {
                text: "Без срока"
                anchors.centerIn: parent
                color: "#888888"
                font.pixelSize: 13
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            text: "🔍"
            font.pixelSize: 18
            color: "#888888"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "⇅"
            font.pixelSize: 18
            color: "#888888"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "📅"
            font.pixelSize: 18
            color: "#888888"
            anchors.verticalCenter: parent.verticalCenter
        }
    }*/

    TabBar {
        id: bar
        width: parent.width
        visible: true

        // Опционально: анимация появления
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }


        background: Rectangle {
            color: "transparent"
        }

        TabButton {
            text: qsTr("Сегодня")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                radius: 18
                color: "#333333"
            }
        }
        TabButton {
            text: qsTr("Завтра")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                radius: 18
                color: "#333333"
            }
        }
        TabButton {
            text: qsTr("Без срока")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                radius: 18
                color: "#333333"
            }
        }
    }

    StackLayout {
        id: tasks
        width: parent.width
        currentIndex: bar.currentIndex
        visible: true

        // Опционально: анимация появления
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        /*Rectangle {
            id: homeTab
            color: "red"
        }
        Rectangle {
            id: discoverTab
            color: "blue"
        }
        Rectangle {
            id: activityTab
            color: "green"
        }*/

        TasksLayout{
            id: oneone
        }

        TasksLayout{
            id: twoto
        }

        TasksLayout{
            id: threeee
        }
    }

    /*Text {
        text: "Нет задач"
        color: "#666666"
        font.pixelSize: 14
        Layout.topMargin: 5
    }*/
}
