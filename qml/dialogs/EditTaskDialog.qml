pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: editTaskDialog
    title: "Редактирование задачи"
    modal: true
    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel


    property var onConfirmCallback: null
    required property var db
    required property int idTask
    required property string nameTask
    required property string dateTask
    required property string describeTask

    onAccepted: {

        editTask()


        nameIdTask.text = ""
        describeIdTask.text = ""
        dateIdTask.text = ""
        editTaskDialog.close()
    }

    onRejected: {
        nameIdTask.text = ""
        describeIdTask.text = ""
        dateIdTask.text = ""
        editTaskDialog.close()
    }

    ColumnLayout {
        anchors.fill: parent;
        spacing: 10;

        TextField {
            id: nameIdTask;
            placeholderText: "Название";
            Layout.fillWidth: true
            maximumLength: 250
            text: nameTask
        }
        TextField {
            id: describeIdTask;
            placeholderText: "Описание";
            Layout.fillWidth: true
            maximumLength: 250
            text: describeTask
        }
        TextField {
            id: dateIdTask;
            placeholderText: "Дата";
            Layout.fillWidth: true
            inputMask: "99:99:9999"
            text: dateTask
        }
    }

    function editTask() {
        if (nameIdTask.text.trim() === "") return
        db.updateTask(idTask, nameIdTask.text, describeIdTask.text, dateIdTask.text)
    }
}
