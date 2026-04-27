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

        Label {
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

        Label {
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
            text: qsTr("Все")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                color: "#333333"
            }
        }

        TabButton {
            text: qsTr("Прошлые")

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 36
                color: "#333333"
            }
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
            text: qsTr("Будущие")

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

        // анимация появления
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        ListView {
            id: allTasksListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {id: allTasksListModel}
            delegate: TaskDelegate {db: dbManager}
            clip: true
        }

        ListView {
            id: overdueTasksListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {id: overdueTasksListModel}
            delegate: TaskDelegate {db: dbManager}
            clip: true
        }

        ListView {
            id: todayTasksListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {id: todayTasksListModel}
            delegate: TaskDelegate {db: dbManager}
            clip: true
        }

        ListView {
            id: futureTasksListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {id: futureTasksListModel}
            delegate: TaskDelegate {db: dbManager}
            clip: true
        }

        ListView {
            id: noTimeTasksListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {id: noTimeTasksListModel}
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

    /*Label {
        text: "Нет задач"
        color: "#666666"
        font.pixelSize: 14
        Layout.topMargin: 5
        visible: allTasksListView ? false : true
    }*/

    /*

    function loadData() {
        listModel.clear()
        let tasks = dbManager.getAllTasks()
        for (let r of tasks) listModel.append(r)
    }
    */

    function loadData() {
        allTasksListModel.clear()
        noTimeTasksListModel.clear()
        todayTasksListModel.clear()
        futureTasksListModel.clear()
        overdueTasksListModel.clear()

        let tasks = dbManager.getAllTasks()
        console.log("📦 Loaded tasks count:", tasks.length)
        for (let i = 0; i < tasks.length; i++) {
            let r = tasks[i]
            console.log("📋 Task[" + i + "] keys:", Object.keys(r))
            console.log("   id:", r.id, "| nameTask:", r.nameTask, "| describeTask:", r.describeTask, "| dateTask:", r.dateTask)

            allTasksListModel.append(r)

            if (r.dateTask === "::") {
                noTimeTasksListModel.append(r)
            } else if (compareСurrentDate(r.dateTask)){
                todayTasksListModel.append(r)
            } else if (compareFutureDate(r.dateTask)){
                futureTasksListModel.append(r)
            } else {
                overdueTasksListModel.append(r)
            }
        }
    }

    function compareСurrentDate(dateStr) {
        // 1. Разбиваем строку по символу ':'
        var parts = dateStr.split(':');
        if (parts.length !== 3) return "Ошибка формата: ожидается ДД:ММ:ГГГГ";

        // 2. Преобразуем части в числа
        var day   = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10) - 1; // В JS месяцы нумеруются с 0
        var year  = parseInt(parts[2], 10);

        // 3. Создаём объект Date
        var inputDate = new Date(year, month, day);

        // 4. Проверяем, не изменил ли Date числа (защита от 32.01.2023 и т.п.)
        if (inputDate.getFullYear() !== year ||
            inputDate.getMonth() !== month ||
            inputDate.getDate() !== day) {
            return "Некорректная дата";
        }

        // 5. Получаем "сегодня" без времени
        var today = new Date();
        today.setHours(0, 0, 0, 0);

        // 6. Сравниваем
        var inputTime = inputDate.getTime();
        var todayTime = today.getTime();

        console.log("Полученная дата:", inputTime, "Сегодня:", todayTime)

        if (inputTime === todayTime) return true

        return false
    }

    function compareFutureDate(dateStr) {
        // 1. Разбиваем строку по символу ':'
        var parts = dateStr.split(':');
        if (parts.length !== 3) return "Ошибка формата: ожидается ДД:ММ:ГГГГ";

        // 2. Преобразуем части в числа
        var day   = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10) - 1; // В JS месяцы нумеруются с 0
        var year  = parseInt(parts[2], 10);

        // 3. Создаём объект Date
        var inputDate = new Date(year, month, day);

        // 4. Проверяем, не изменил ли Date числа (защита от 32.01.2023 и т.п.)
        if (inputDate.getFullYear() !== year ||
            inputDate.getMonth() !== month ||
            inputDate.getDate() !== day) {
            return "Некорректная дата";
        }

        // 5. Получаем "сегодня" без времени
        var today = new Date();
        today.setHours(0, 0, 0, 0);

        // 6. Сравниваем
        var inputTime = inputDate.getTime();
        var todayTime = today.getTime();

        if (inputTime > todayTime) return true

        return false
    }

    function compareLastDate(dateStr) {
        // 1. Разбиваем строку по символу ':'
        var parts = dateStr.split(':');
        if (parts.length !== 3) return "Ошибка формата: ожидается ДД:ММ:ГГГГ";

        // 2. Преобразуем части в числа
        var day   = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10) - 1; // В JS месяцы нумеруются с 0
        var year  = parseInt(parts[2], 10);

        // 3. Создаём объект Date
        var inputDate = new Date(year, month, day);

        // 4. Проверяем, не изменил ли Date числа (защита от 32.01.2023 и т.п.)
        if (inputDate.getFullYear() !== year ||
            inputDate.getMonth() !== month ||
            inputDate.getDate() !== day) {
            return "Некорректная дата";
        }

        // 5. Получаем "сегодня" без времени
        var today = new Date();
        today.setHours(0, 0, 0, 0);

        // 6. Сравниваем
        var inputTime = inputDate.getTime();
        var todayTime = today.getTime();

        if (inputTime < todayTime) return true

        return false
    }

    Component.onCompleted: loadData()
    // Автообновление при изменении данных извне
    Connections {
        target: dbManager
        function onDataChanged() { loadData() }
    }
}
