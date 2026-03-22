import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Rectangle serves as the main container for the habit card
Rectangle {
    id: habitCard

    // --- User properties ---
    // These properties will be set from outside (e.g., in ListView delegate)
    property alias habitName: nameText.text
    property alias description: descText.text
    // currentStreakValue and bestStreakValue will be displayed, but not directly via alias,
    // but through internal logic or binding to the model data.
    // For example, you can pass numeric values:
    property int currentStreakValue: 0 // Internal numeric value of the current streak
    property int bestStreakValue: 0   // Internal numeric value of the best streak
    // For display strings:
    property string currentStreakDisplay: currentStreakValue + " дней подряд"
    property string bestStreakDisplay: "Лучшая серия: " + bestStreakValue + " дней"
    // Property to track today's completion (can be managed internally or externally)
    property bool completedToday: false

    // Array of completed days (e.g., ["09", "10", "11"] or [] if none completed)
    property var completedDays: [] // array of day strings like "DD"
    // Properties for day values (passed from model)
    property string day1: ""
    property string day2: ""
    property string day3: ""
    property string day4: ""
    property string day5: ""
    property string day6: ""
    property string day7: ""

    // Internal state for interactivity
    property bool hoveredEdit: false
    property bool hoveredDelete: false
    property bool pressedEdit: false
    property bool pressedDelete: false

    // --- Default parameters ---
    width: parent ? parent.width : 300 // Width based on parent's width
    height: contentColumn.implicitHeight + 2 * anchors.margins // Height based on content
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

        // Name and streak counter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                id: nameText
                // Text will be set via property alias
                font.pixelSize: 16
                font.bold: true
                color: "#4ecdc4"
                Layout.fillWidth: true
                elide: Text.ElideRight // Truncate text if it doesn't fit
            }

            Text {
                id: currentStreakText
                text: habitCard.currentStreakDisplay // Binding to calculated property
                font.pixelSize: 12
                color: "#888888"
            }
        }

        // Description (shown if not empty)
        Text {
            id: descText
            // Text will be set via property alias
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
                        color: habitCard.completedDays.includes(habitCard["day" + (index + 1)])
                                   ? "#2a7f2a"  // green - completed
                                   : "#2a4a4a"  // gray - not completed

                        Text {
                            text: habitCard["day" + (index + 1)] || "" // e.g., day1 = "09"
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.pixelSize: 13
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Toggle completion status for this day
                                let dayKey = "day" + (index + 1);
                                let dayValue = habitCard[dayKey];
                                if (habitCard.completedDays.includes(dayValue)) {
                                    habitCard.completedDays = habitCard.completedDays.filter(d => d !== dayValue);
                                } else {
                                    habitCard.completedDays = [...habitCard.completedDays, dayValue];
                                }
                                // Update streak (simplified - real logic counts consecutive days)
                                // Here just update currentStreak as the length of completedDays (for demo)
                                habitCard.currentStreakValue = habitCard.completedDays.length;
                                if (habitCard.currentStreakValue > habitCard.bestStreakValue) {
                                    habitCard.bestStreakValue = habitCard.currentStreakValue;
                                }
                            }
                        }
                    }
                }
            }

            // Space to the right: streaks
            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignRight

                Text {
                    text: "Текущая: " + habitCard.currentStreakValue + " дн."
                    font.pixelSize: 12
                    color: "#888888"
                }

                Text {
                    text: "Лучшая: " + habitCard.bestStreakValue + " дн."
                    font.pixelSize: 12
                    color: "#666666"
                }
            }
        }

        // Simple button for marking today's completion
        // (real logic will depend on your C++ model)
        Button {
            text: habitCard.completedToday ? "Выполнено сегодня!" : "Отметить выполнение"
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            enabled: !habitCard.completedToday // Disable if already done
            palette.button: habitCard.completedToday ? "#2a7f2a" : "#2a4a4a" // Button color
            palette.buttonText: "#4ecdc4"
            onClicked: {
                // Completion logic should be implemented,
                // e.g., by calling a C++ model method or changing QML data.
                console.log("Отметка выполнения для:", nameText.text)
                // Example: increase streak (this is temporary behavior)
                habitCard.currentStreakValue++
                if (habitCard.currentStreakValue > habitCard.bestStreakValue) {
                    habitCard.bestStreakValue = habitCard.currentStreakValue
                }
                habitCard.completedToday = true
            }
        }

        // Control buttons (edit, delete) with interactivity
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4
            spacing: 8

            Button {
                text: "Редактировать"
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                palette.button: habitCard.hoveredEdit || habitCard.pressedEdit
                                   ? "#3a5a5a" : "#2a4a4a"
                palette.buttonText: "#4ecdc4"
                background: Rectangle {
                    color: parent.palette.button
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.palette.buttonText
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: habitCard.hoveredEdit = true
                    onExited: habitCard.hoveredEdit = false
                    onPressed: habitCard.pressedEdit = true
                    onReleased: habitCard.pressedEdit = false
                    onClicked: {
                        console.log("Редактировать привычку:", habitCard.habitName)
                        // Logic to open edit dialog
                        // emit editRequested(habitCard.habitName)
                    }
                }
            }

            Button {
                text: "Удалить"
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                palette.button: habitCard.hoveredDelete || habitCard.pressedDelete
                                   ? "#5a2a2a" : "#3a1a1a"
                palette.buttonText: "#ff6b6b"
                background: Rectangle {
                    color: parent.palette.button
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: parent.palette.buttonText
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: habitCard.hoveredDelete = true
                    onExited: habitCard.hoveredDelete = false
                    onPressed: habitCard.pressedDelete = true
                    onReleased: habitCard.pressedDelete = false
                    onClicked: {
                        console.log("Удалить привычку:", habitCard.habitName)
                        // Logic to delete habit from model
                        // emit deleteRequested(habitCard.habitName)
                    }
                }
            }
        }
    }
}
