import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Habits

// Rectangle serves as the main container for the habit card
Rectangle {
    id: habitCard

    // --- User properties ---
    property string habitId: ""
    property alias habitName: nameText.text
    property alias description: descText.text

    // Счётчики серий (привязываются к модели)
    property int currentStreakValue: 0
    property int bestStreakValue: 0

    // Для отображения
    property string currentStreakDisplay: currentStreakValue + " дн. подряд"
    property string bestStreakDisplay: "Лучшая: " + bestStreakValue + " дн."

    // Массив дат завершений (строки в формате "DD")
    property var completedDaysList: []

    // Дни недели для отображения (передаются из модели или вычисляются)
    property string day1: ""
    property string day2: ""
    property string day3: ""
    property string day4: ""
    property string day5: ""
    property string day6: ""
    property string day7: ""

    // Индекс в модели (для вызова методов)
    property int habitIndex: -1

    // Ссылка на модель
    property var habitModel: null

    // --- Default parameters ---
    width: parent ? parent.width : 300
    height: contentColumn.implicitHeight + 2 * anchors.margins
    radius: 16
    color: "#1a2f2f"
    border.color: "#4ecdc4"
    border.width: 1

    // --- Card content ---
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Header row: Name and streak counters (top right)
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

            // Current streak counter (top right)
            Text {
                id: currentStreakText
                text: habitCard.currentStreakDisplay // Binding to calculated property
                font.pixelSize: 12
                color: "#4ecdc4"
                font.bold: true
            }

            // Best streak counter (top right, after current)
            Text {
                id: bestStreakText
                text: habitCard.bestStreakDisplay
                font.pixelSize: 11
                color: "#888888"
            }
        }

        // Description (shown if not empty)
        Text {
            id: descText            
            font.pixelSize: 13
            color: "#aaaaaa"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            visible: text.length > 0
        }

        // Days of the week row with circles
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: modelData
                        font.pixelSize: 11
                        color: "#888888"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        implicitWidth: 38
                        implicitHeight: 38
                        radius: 19
                        // Color depends on whether this day is completed
                        color: habitCard.completedDaysList.includes(habitCard["day" + (index + 1)])
                                   ? "#2a7f2a"  // green - completed
                                   : "#2a4a4a"  // gray - not completed

                        // Checkmark icon when completed
                        Text {
                            text: habitCard.completedDaysList.includes(habitCard["day" + (index + 1)]) ? "✓" : ""
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.pixelSize: 20
                            font.bold: true
                        }

                        // Day number (small, at bottom)
                                                Text {
                                                    text: habitCard["day" + (index + 1)] || ""
                                                    anchors.bottom: parent.bottom
                                                    anchors.bottomMargin: 2
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    color: "#ffffff"
                                                    font.pixelSize: 9
                                                }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (habitCard.habitIndex >= 0 && habitCard.habitModel) {
                                    // Вызываем метод модели для переключения дня
                                    let dayNum = parseInt(habitCard["day" + (index + 1)]);
                                    if (!isNaN(dayNum)) {
                                        // Создаём дату (предполагаем текущий месяц/год для примера)
                                        let today = new Date();
                                        let clickDate = new Date(today.getFullYear(), today.getMonth(), dayNum);
                                        habitCard.habitModel.toggleDayCompletion(habitCard.habitIndex, Qt.formatDate(clickDate, "yyyy-MM-dd"));
                                    }
                                } else {
                                    // Демо-режим без модели
                                    console.log("Toggle day:", index + 1,
                                    habitCard["day" + (index + 1)]);
                                }
                            }
                        }
                    }
                }
            }
        }

        // Control buttons (edit, delete) - inside the card container
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4
            spacing: 8

            Button {
                text: "Редактировать"
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
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Редактировать привычку:", habitCard.habitName)
                    // emit editRequested(habitCard.habitIndex)
                    }
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
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Удалить привычку:", habitCard.habitName)
                    if (habitCard.habitIndex >= 0 && habitCard.habitModel) {
                        habitCard.habitModel.removeHabit(habitCard.habitIndex);
                    }
                }
            }
        }
    }
}
