import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

// Основной контейнер секции "Привычки"
ColumnLayout {
    id: habitsSection
    Layout.fillWidth: true
    spacing: 10

    // --- Заголовок с кнопками управления ---
    RowLayout {
        Layout.fillWidth: true

        Label {
            text: "Привычки"
            font.pixelSize: 22
            font.bold: true
            color: "#ffffff"
        }

        Item { Layout.fillWidth: true } // Распорка

        // Кнопка "Обновить"
        ToolButton {
            id: refreshBtn
            icon.name: "view-refresh"
            icon.width: 20
            icon.height: 20
            icon.color: "#cccccc"
            implicitWidth: 32
            implicitHeight: 32

            background: Rectangle {
                color: refreshBtn.hovered ? "#444444" :
                       refreshBtn.pressed ? "#222222" : "transparent"
                radius: 16
            }

            ToolTip.visible: hovered
            ToolTip.text: "Обновить список"
            ToolTip.delay: 500

            onClicked: {
                // QAbstractListModel обновляется автоматически через сигналы.
                // Принудительная перезагрузка не требуется, но если нужно:
                // habitModel.loadHabitsFromDb() - если бы этот метод был public
                console.log("Список привычек актуален (обновляется автоматически)")
            }
        }

        // Кнопка "Добавить"
        ToolButton {
            id: addBtn
            icon.name: "list-add"
            icon.width: 20
            icon.height: 20
            icon.color: "#cccccc"
            implicitWidth: 32
            implicitHeight: 32

            background: Rectangle {
                color: addBtn.hovered ? "#444444" :
                       addBtn.pressed ? "#222222" : "transparent"
                radius: 16
            }

            ToolTip.visible: hovered
            ToolTip.text: "Добавить привычку"
            ToolTip.delay: 500

            onClicked: {
                addHabitDialog.open()
            }
        }

        // Кнопка скрытия/раскрытия
        Label {
            text: showDetails ? "▼" : "▶"
            font.pixelSize: 12
            color: "#888888"

            TapHandler {
                onTapped: showDetails = !showDetails
            }
        }
    }

    // --- Список привычек ---
    ListView {
        id: habitsListView
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 12
        clip: true
        visible: showDetails
        opacity: visible ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 200 } }

        model: habitModel

        delegate: HabitCard {
            width: habitsListView.width
            habitIndex: index
            habitName: model.name
            description: model.description
            currentStreakValue: model.currentStreak
            bestStreakValue: model.bestStreak
            completedDates: model.completedDates
            habitModel: habitsSection.habitModel

            // Обработка сигнала редактирования
            onEditRequested: function(index, name, desc) {
                editHabitDialog.openForEdit(index, name, desc)
            }
        }

        // Подсказка, если список пуст
        Label {
            anchors.centerIn: parent
            text: "Список привычек пуст"
            color: "#666666"
            visible: habitsListView.count === 0 && showDetails
        }
    }

    // --- Диалоги ---
    AddHabitDialog {
        id: addHabitDialog
        // Передаем глобальную модель в диалог
        habitModel: habitModel
    }

    EditHabitDialog {
        id: editHabitDialog
        // Передаем глобальную модель в диалог
        habitModel: habitModel
    }
}
