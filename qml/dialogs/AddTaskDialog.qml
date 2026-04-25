pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: taskDialog
    title: "Добавление новой задачи"
    modal: true
    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel


    property var onConfirmCallback: null
    required property var db

    onAccepted: {
        if (nameTask.text) {
            addTask()
        }
    }

    onRejected: taskDialog.close()

    ColumnLayout {
        anchors.fill: parent;
        spacing: 10;

        TextField { id: nameTask; placeholderText: "Название"; Layout.fillWidth: true }
        TextField { id: describeTask; placeholderText: "Описание"; Layout.fillWidth: true }
        TextField { id: dateTask; placeholderText: "Дата"; Layout.fillWidth: true }
    }

    function addTask() {
        if (nameTask.text.trim() === "") return
        db.insertTask(nameTask.text, describeTask.text, dateTask.text)
    }
}
