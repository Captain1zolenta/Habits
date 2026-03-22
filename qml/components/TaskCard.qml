import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    Layout.fillWidth: true
    //width: habitsListView.width
    height: habitContent.implicitHeight + 24
    radius: 16
    color: "#1a2f2f"

    ColumnLayout {
        id: habitContent
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Отметка
        RowLayout {
            Layout.fillWidth: true

            Rectangle {
                id: check
                implicitWidth: 38
                implicitHeight: 38
                radius: 19
                color: "#2a4a4a"

                MouseArea {
                    anchors.fill: parent  // ← Область клика = размер текста
                    cursorShape: Qt.PointingHandCursor  // ← Курсор-рука при наведении
                    onClicked: {
                        check.color = "#2a4a3a"
                    }
                }
            }

            Text {
                text: "Название задачи"
                font.pixelSize: 16
                font.bold: true
                color: "#4ecdc4"
                Layout.fillWidth: true
            }

            Text {
                text: "Описание задачи"
                font.pixelSize: 12
                color: "#888888"
                Layout.fillWidth: true
            }

            /*Rectangle {
                implicitWidth: 38
                implicitHeight: 50
                radius: 19
                color: "#2a4a4a"
                Layout.fillWidth: true

                Text {
                    text: "Описание задачи"
                    font.pixelSize: 12
                    color: "#888888"
                }
            }*/


        }

        // Кнопки управления
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: "#2a4a4a"

                Text {
                    text: "Редактировать"
                    anchors.centerIn: parent
                    color: "#4ecdc4"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Edit:", model.habitName)
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: "#3a1a1a"

                Text {
                    text: "Удалить"
                    anchors.centerIn: parent
                    color: "#ff6b6b"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Delete:", model.habitName)
                }
            }
        }
    }
}
