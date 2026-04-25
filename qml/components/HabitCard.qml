import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Habits

Rectangle {
    id: habitCard

    // --- Свойства ---
    property string habitId: ""
    property alias habitName: nameText.text
    property alias description: descText.text

    property int currentStreakValue: 0
    property int bestStreakValue: 0

    // Список дат завершений (приходит из модели как QList<QDate>)
    property var completedDates: []

    property int habitIndex: -1
    property var habitModel: null

    width: parent ? parent.width : 300
    height: contentColumn.implicitHeight + 2 * anchors.margins
    radius: 16
    color: "#1a2f2f"
    border.color: "#4ecdc4"
    border.width: 1

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Header: Имя и счетчики
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                id: nameText
                font.pixelSize: 16
                font.bold: true
                color: "#4ecdc4"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: currentStreakValue + " дн."
                font.pixelSize: 12
                color: "#4ecdc4"
                font.bold: true
                ToolTip.visible: hovered
                ToolTip.text: "Текущая серия"
            }

            Text {
                text: "Макс: " + bestStreakValue
                font.pixelSize: 11
                color: "#888888"
                ToolTip.visible: hovered
                ToolTip.text: "Лучшая серия"
            }
        }

        Text {
            id: descText
            font.pixelSize: 13
            color: "#aaaaaa"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            visible: text.length > 0
        }

        // Дни недели
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: 7 // 0=Пн, 1=Вт, ..., 6=Вс

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    // Название дня (Пн, Вт...)
                    Text {
                        text: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"][index]
                        font.pixelSize: 11
                        color: "#888888"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        implicitWidth: 36
                        implicitHeight: 36
                        radius: 18

                        // Вычисляем дату для этого дня недели (берем текущую неделю)
                        // Qt.Day.Monday = 1, ..., Sunday = 7
                        // index у нас 0..6, значит день недели = index + 1
                        property date targetDate: {
                            var today = new Date();
                            var currentDayOfWeek = today.getDay(); // 0=Sun, 1=Mon...
                            // Нормализуем: пусть Пн=1, Вс=7
                            var normalizedCurrent = currentDayOfWeek === 0 ? 7 : currentDayOfWeek;
                            var targetDay = index + 1;

                            var diff = targetDay - normalizedCurrent;
                            var target = new Date(today);
                            target.setDate(today.getDate() + diff);
                            return target;
                        }

                        // Форматируем дату для сравнения "YYYY-MM-DD"
                        property string dateStr: Qt.formatDate(targetDate, "yyyy-MM-dd")

                        // Проверяем, есть ли эта дата в массиве completedDates
                        // completedDates приходит как список объектов QDate, нужно сравнить строки
                        property bool isCompleted: {
                            for (var i = 0; i < habitCard.completedDates.length; i++) {
                                var d = habitCard.completedDates[i];
                                // d может быть объектом Date или QVariant
                                if (Qt.formatDate(d, "yyyy-MM-dd") === dateStr) {
                                    return true;
                                }
                            }
                            return false;
                        }

                        color: isCompleted ? "#2a7f2a" : "#2a4a4a"

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }

                        // Галочка
                        Text {
                            text: isCompleted ? "✓" : ""
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.pixelSize: 20
                            font.bold: true
                            visible: isCompleted
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (habitCard.habitIndex >= 0 && habitCard.habitModel) {
                                    habitCard.habitModel.toggleDayCompletion(habitCard.habitIndex, targetDate);
                                }
                            }
                        }
                    }
                }
            }
        }

        // Кнопки
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4
            spacing: 8

            Button {
                text: "Ред."
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                background: Rectangle {
                    color: parent.hovered || parent.pressed ? "#3a5a5a" : "#2a4a4a"
                    radius: 8
                }

                contentItem: Text {
                    text: parent.text
                    color: "#4ecdc4"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                }
                onClicked: console.log("Edit", habitIndex)
            }

            Button {
                text: "Удалить"
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                background: Rectangle {
                    color: parent.hovered || parent.pressed ? "#5a2a2a" : "#3a1a1a"
                    radius: 8
                }

                contentItem: Text {
                    text: parent.text
                    color: "#ff6b6b"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    if (habitCard.habitIndex >= 0 && habitCard.habitModel) {
                        habitCard.habitModel.removeHabit(habitCard.habitIndex);
                    }
                }
            }
        }
    }
}
