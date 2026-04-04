import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    id: root
    width: parent.width

    padding: 0  // ← Убираем все системные отступы контрола

    /*
    // ← Обязательно прозрачный фон, иначе стиль может нарисовать свою подложку
    background: Rectangle {
        color: "transparent"
    }*/

    required property int index
    required property int numberTask
    required property string descriptionTask

    onClicked: ListView.view.currentIndex = index

    contentItem: ColumnLayout {
        id: habitContent
        anchors.fill: parent
        spacing: 0

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

            Label {
                text: root.numberTask
                font.pixelSize: 16
                font.bold: true
                color: "#4ecdc4"
                Layout.fillWidth: true
            }

            Label {
                text: root.descriptionTask
                font.pixelSize: 12
                color: "#888888"
                Layout.fillWidth: true
            }

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

                Label {
                    text: "Редактировать"
                    anchors.centerIn: parent
                    color: "#4ecdc4"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Edit:")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: "#3a1a1a"

                Label {
                    text: "Удалить"
                    anchors.centerIn: parent
                    color: "#ff6b6b"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Delete:")
                }
            }
        }
    }
}
