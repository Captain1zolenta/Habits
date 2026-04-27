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

        nameTask.text = ""
        describeTask.text = ""
        dateTask.text = ""
        taskDialog.close()
    }

    onRejected: {
        nameTask.text = ""
        describeTask.text = ""
        dateTask.text = ""
        taskDialog.close()
    }

    ColumnLayout {
        anchors.fill: parent;
        spacing: 10;

        TextField {
            id: nameTask;
            placeholderText: "Название";
            Layout.fillWidth: true
            maximumLength: 250
        }
        TextField {
            id: describeTask;
            placeholderText: "Описание";
            Layout.fillWidth: true
            maximumLength: 250
        }
        TextField {
            id: dateTask;
            placeholderText: "Дата";
            Layout.fillWidth: true
            inputMask: "99:99:9999"
        }
    }

    function addTask() {
        if (nameTask.text.trim() === "") return
        db.insertTask(nameTask.text, describeTask.text, dateTask.text)
    }
}
