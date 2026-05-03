pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: addHabitDialog
    title: "Новая привычка"
    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel
    anchors.centerIn: parent

    // Обязательное свойство: модель данных (инициализируется в HabitsView)
    required property var habitModel

    onAccepted: {
        if (nameField.text.trim() !== "") {
            habitModel.addHabit(nameField.text.trim(), descField.text.trim());
        }
        // Очистка полей
        nameField.text = "";
        descField.text = "";
        close(); // Стандартный метод закрытия Dialog
    }

    onRejected: {
        nameField.text = "";
        descField.text = "";
        close();
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
            placeholderText: "Например: Читать книгу"
            Layout.fillWidth: true
            color: "#ffffff"
            focus: true

            background: Rectangle {
                color: "#2a2a2a"
                radius: 8
                border.color: nameField.activeFocus ? "#4ecdc4" : "#444444"
                border.width: 1
                height: nameField.implicitHeight + 10
            }
        }

        Label {
            text: "Описание (необязательно):"
            font.pixelSize: 14
            color: "#ffffff"
            Layout.fillWidth: true
        }

        TextArea {
            id: descField
            placeholderText: "Опишите вашу цель..."
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

    // Пользовательская функция открытия (чтобы не конфликтовать с внутренними методами)
    function openDialog() {
        nameField.text = "";
        descField.text = "";
        open(); // Вызываем стандартный метод open() базового класса Dialog
    }
}
