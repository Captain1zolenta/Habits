import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import Habits


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



        ToolButton {
            id: refreshBtn

            icon.name: "view-refresh"
            icon.width: 20
            icon.height: 20
            icon.color: "#cccccc"

            // Компактный размер
            implicitWidth: 32
            implicitHeight: 32

            // Круглый фон
            background: Rectangle {
                color: refreshBtn.hovered ? "#444444" :
                       refreshBtn.pressed ? "#222222" : "transparent"
                radius: 16
            }

            // Подсказка при наведении
            ToolTip.visible: hovered
            ToolTip.text: "Обновить список"
            ToolTip.delay: 500

            onClicked: loadData()
        }

        ToolButton {
            id: listAdd

            icon.name: "list-add"
            icon.width: 20
            icon.height: 20
            icon.color: "#cccccc"

            // Компактный размер
            implicitWidth: 32
            implicitHeight: 32

            // Круглый фон
            background: Rectangle {
                color: listAdd.hovered ? "#444444" :
                       listAdd.pressed ? "#222222" : "transparent"
                radius: 16
            }

            // Подсказка при наведении
            ToolTip.visible: hovered
            ToolTip.text: "Добавить задачу"
            ToolTip.delay: 500

            onClicked: taskDialog.open()
        }

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
                color: "#333333"
            }
        }
        TabButton {
            text: qsTr("Завтра")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                color: "#333333"
            }
        }
        TabButton {
            text: qsTr("Без срока")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
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

        ListView {
            id: tasksListView
            Layout.fillHeight: true  // Занять всё доступное свободное место
            Layout.fillWidth: true
            model: ListModel {id: listModel}
            delegate: TaskDelegate {db: dbManager}
            clip: true
        }

    }

    AddTaskDialog {
        id: taskDialog
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        db: dbManager
    }

    /*Text {
        text: "Нет задач"
        color: "#666666"
        font.pixelSize: 14
        Layout.topMargin: 5
    }*/

    /*

    function loadData() {
        listModel.clear()
        let tasks = dbManager.getAllTasks()
        for (let r of tasks) listModel.append(r)
    }
    */

    function loadData() {
        listModel.clear()
        let tasks = dbManager.getAllTasks()
        console.log("📦 Loaded tasks count:", tasks.length)
        for (let i = 0; i < tasks.length; i++) {
            let r = tasks[i]
            console.log("📋 Task[" + i + "] keys:", Object.keys(r))
            console.log("   id:", r.id, "| nameTask:", r.nameTask, "| dateTask:", r.dateTask) // dateTask, не date
            listModel.append(r)
        }
    }

    Component.onCompleted: loadData()
    // Автообновление при изменении данных извне
    Connections {
        target: dbManager
        function onDataChanged() { loadData() }
    }
}
