import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Dialog {
    id: editHabitDialog
    title: editingMode ? "Редактировать привычку" : "Новая привычка"
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel
    anchors.centerIn: parent

    property bool editingMode: false
    property int habitIndex: -1
    property var habitModel: null

    // Данные для редактирования/создания
    property string habitName: ""
    property string habitDescription: ""

    signal saveClicked(string name, string description)
    signal cancelClicked()

    ColumnLayout {
        width: 300
        spacing: 15

        Label {
            text: "Название привычки:"
            font.pixelSize: 14
            color: "#ffffff"
        }

        TextField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: "Например: Читать книгу"
            text: habitName
            onTextChanged: habitName = text

            background: Rectangle {
                color: "#2a2a2a"
                radius: 8
                border.color: nameField.activeFocus ? "#4ecdc4" : "#444444"
                border.width: 1
            }
        }

        Label {
            text: "Описание (необязательно):"
            font.pixelSize: 14
            color: "#ffffff"
        }

        TextArea {
            id: descField
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            placeholderText: "Опишите вашу цель..."
            text: habitDescription
            onTextChanged: habitDescription = text
            wrapMode: TextArea.Wrap

            background: Rectangle {
                color: "#2a2a2a"
                radius: 8
                border.color: descField.activeFocus ? "#4ecdc4" : "#444444"
                border.width: 1
            }
        }
    }

    onAccepted: {
        if (nameField.text.trim().length > 0) {
            saveClicked(nameField.text.trim(), descField.text.trim());
            if (editingMode && habitModel && habitIndex >= 0) {
                habitModel.updateHabit(habitIndex, nameField.text.trim(), descField.text.trim());
            } else if (!editingMode && habitModel) {
                habitModel.addHabit(nameField.text.trim(), descField.text.trim());
            }
        }
    }

    onRejected: {
        cancelClicked();
    }

    function openForEdit(index, model, name, description) {
        editingMode = true;
        habitIndex = index;
        habitModel = model;
        habitName = name;
        habitDescription = description;
        nameField.text = name;
        descField.text = description;
        open();
    }

    function openForAdd(model) {
        editingMode = false;
        habitIndex = -1;
        habitModel = model;
        habitName = "";
        habitDescription = "";
        nameField.text = "";
        descField.text = "";
        open();
    }
}
