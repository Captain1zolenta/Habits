import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    id: root
    width: parent.width
    checkable: true
    padding: 0

    /*
    // ← Обязательно прозрачный фон, иначе стиль может нарисовать свою подложку
    background: Rectangle {
        color: "transparent"
    }*/

    required property int index
    required property string dateTask
    required property string descriptionTask
    required property string nameTask
    property bool complete: false

    onClicked: ListView.view.currentIndex = index

    contentItem: ColumnLayout {
        id: habitContent
        anchors.fill: parent
        spacing: 0

        // Отметка
        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {

                Label {
                    id: nameTask
                    text: root.nameTask
                    font.pixelSize: 16
                    font.bold: true
                    font.strikeout: root.complete
                    color: "#4ecdc4"
                    Layout.fillWidth: true
                }

                Label {
                    text: {
                        // Парсим строку в дату
                        var dt = new Date(root.dateTask)
                        // Проверяем валидность
                        if (isNaN(dt.getTime())) return "Некорректная дата"
                        return Qt.formatDateTime(dt, "dd.MM.yyyy, hh:mm")
                    }
                    font.pixelSize: 12
                    font.strikeout: root.complete
                    color: "#888888"
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Switch {
                Layout.alignment: Qt.AlignCenter
                onClicked: root.complete = !root.complete
            }

        }

        ColumnLayout {
            visible: root.checked

            Label {
                text: root.descriptionTask
                font.pixelSize: 16
                font.bold: true
                font.strikeout: root.complete
                color: "#aeaeae"
                Layout.fillWidth: true
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
}
