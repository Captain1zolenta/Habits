import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

// Основной контейнер секции "Привычки"
ColumnLayout {
    id: habitsSection
    Layout.fillWidth: true
    spacing: 10

    // Флаг для отображения/скрытия списка (аналог showDetails в Tasks)
    property bool showDetails: true

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
                // Вызываем метод refresh() у модели, если он существует
                if (habitModel && typeof habitModel.refresh === 'function') {
                    habitModel.refresh();
                } else {
                    console.log("Метод refresh() не найден в модели, пробуем перезагрузку данных...");
                    // Если метода нет, можно просто эмулировать изменение или ничего не делать
                    // Данные обновятся автоматически при изменении модели
                }
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
                // Открываем диалог добавления
                addHabitDialog.openDialog();
            }
        }

        // Кнопка скрытия/раскрытия (▼ / ▶)
        Label {
            text: showDetails ? "▼" : "▶"
            font.pixelSize: 12
            color: "#888888"

            TapHandler {
                onTapped: {
                    showDetails = !showDetails;
                }
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

        // Анимация плавного появления
        Behavior on opacity { NumberAnimation { duration: 200 } }

        model: habitModel // Берем модель из глобального контекста

        delegate: HabitCard {
            width: habitsListView.width
            habitIndex: index
            habitName: model.habitName
            description: model.description
            currentStreakValue: model.currentStreak
            bestStreakValue: model.bestStreak
            completedDates: model.completedDates
            habitModel: habitModel // Передаем модель для действий

            // Обработка сигнала редактирования
            onEditRequested: function(index, name, desc) {
                editHabitDialog.openForEdit(index, name, desc);
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
    // Явно передаем habitModel в свойство required property диалогов
    AddHabitDialog {
        id: addHabitDialog
        habitModel: habitModel
    }

    EditHabitDialog {
        id: editHabitDialog
        habitModel: habitModel
    }

    Component.onCompleted: {
        console.log("HabitsView загружен");
    }
}
