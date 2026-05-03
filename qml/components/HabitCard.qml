import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: habitCard
    width: parent ? parent.width : 300
    height: contentColumn.implicitHeight + 2 * anchors.margins
    radius: 16
    color: "#1a2f2f"
    border.color: "#4ecdc4"
    border.width: 1

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
                text: habitCard.habitName
                font.pixelSize: 16
                font.bold: true
                color: "#4ecdc4"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Column {
                spacing: 2
                Text {
                    text: currentStreakValue + " дн."
                    font.pixelSize: 12
                    color: "#4ecdc4"
                    font.bold: true
                }
                Text {
                    text: "Макс: " + bestStreakValue
                    font.pixelSize: 10
                    color: "#888888"
                }
            }
        }

        Text {
            id: descText
            text: habitCard.description
            font.pixelSize: 13
            color: "#aaaaaa"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            visible: text.length > 0
        }

        // Дни недели с кружками
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Repeater {
                model: 7 // 0=Пн, 1=Вт, ..., 6=Вс

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    // Название дня (Пн, Вт...)
                    Text {
                        text: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"][index]
                        font.pixelSize: 10
                        color: "#888888"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Кружок с числом месяца
                    Rectangle {
                        implicitWidth: 32
                        implicitHeight: 32
                        radius: 16

                        // Вычисляем дату для этого дня недели
                        property date targetDate: {
                            var today = new Date();
                            var currentDayOfWeek = today.getDay(); // 0=Sun, 1=Mon...
                            var normalizedCurrent = currentDayOfWeek === 0 ? 7 : currentDayOfWeek;
                            var targetDay = index + 1;
                            var diff = targetDay - normalizedCurrent;
                            var target = new Date(today);
                            target.setDate(today.getDate() + diff);
                            return target;
                        }

                        property string dateStr: Qt.formatDate(targetDate, "yyyy-MM-dd")
                        property string dayNumber: targetDate.getDate().toString()

                        // Проверяем, есть ли эта дата в массиве completedDates
                        property bool isCompleted: {
                            for (var i = 0; i < habitCard.completedDates.length; i++) {
                                var d = habitCard.completedDates[i];
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

                        // Число месяца внутри кружка
                        Text {
                            text: dayNumber
                            anchors.centerIn: parent
                            color: isCompleted ? "#ffffff" : "#cccccc"
                            font.pixelSize: 12
                            font.bold: true
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

        // Кнопки редактирования и удаления
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4
            spacing: 8

            Button {
                text: "Ред."
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                font.pixelSize: 12

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
                onClicked: {
                    if (habitCard.habitIndex >= 0 && habitCard.habitModel) {
                        root.openEditHabitDialog(habitCard.habitIndex, habitCard.habitName, habitCard.description);
                    }
                }
            }

            Button {
                text: "Удалить"
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                font.pixelSize: 12

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
