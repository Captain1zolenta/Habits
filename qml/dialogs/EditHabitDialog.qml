pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: editHabitDialog
    title: "Редактировать привычку"
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel

    required property var habitModel
    property int habitIndex: -1

    onAccepted: {
        let name = nameField.text.trim()
        let desc = descField.text.trim()

        if (name !== "" && habitModel && habitIndex >= 0) {
            habitModel.updateHabit(habitIndex, name, desc)
        }
        close()
    }

    onRejected: {
        close()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        Label {
            text: "Название привычки:"
            font.pixelSize: 14
            color: "#ffffff"
            Layout.fillWidth: true
        }

        TextField {
            id: nameField
            placeholderText: "Название"
            Layout.fillWidth: true
            color: "#ffffff"
            background: Rectangle {
                color: "#2a2a2a"
                radius: 8
                border.color: nameField.activeFocus ? "#4ecdc4" : "#444444"
                border.width: 1
                height: nameField.implicitHeight + 10
            }
        }

        Label {
            text: "Описание:"
            font.pixelSize: 14
            color: "#ffffff"
            Layout.fillWidth: true
        }

        TextArea {
            id: descField
            placeholderText: "Описание"
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            wrapMode: TextArea.Wrap
            color: "#ffffff"
            background: Rectangle {
                color: "#2a2a2a"
                radius: 8
                border.color: descField.activeFocus ? "#4ecdc4" : "#444444"
                border.width: 1
            }
        }
    }

    function openForEdit(index, name, description) {
        habitIndex = index
        nameField.text = name
        descField.text = description
        open()
    }
}
