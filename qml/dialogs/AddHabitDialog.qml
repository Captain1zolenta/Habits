pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: habitDialog
    title: "Добавление новой привычки"
    modal: true
    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    required property var habitModel

    onAccepted: {
        if (nameField.text.trim() !== "") {
            habitModel.addHabit(nameField.text.trim(), descField.text.trim())
        }
        // Сброс полей
        nameField.text = ""
        descField.text = ""
        periodBox.currentIndex = 0
    }

    onRejected: {
        nameField.text = ""
        descField.text = ""
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        Label {
            text: "Название привычки"
            Layout.fillWidth: true
            font.bold: true
        }

        TextField {
            id: nameField
            placeholderText: "Например: Зарядка по утрам"
            Layout.fillWidth: true
            focus: true
        }

        Label {
            text: "Описание (опционально)"
            Layout.fillWidth: true
            font.bold: true
        }

        TextField {
            id: descField
            placeholderText: "Зачем я это делаю?"
            Layout.fillWidth: true
        }

        Label {
            text: "Периодичность"
            Layout.fillWidth: true
            font.bold: true
        }

        ComboBox {
            id: periodBox
            Layout.fillWidth: true
            model: ["Ежедневно", "Еженедельно", "Ежемесячно"]
        }
    }
}
