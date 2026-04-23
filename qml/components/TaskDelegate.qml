import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    id: root
    width: ListView.view.width
    checkable: true
    padding: 0

    /*
    // ← Обязательно прозрачный фон, иначе стиль может нарисовать свою подложку
    background: Rectangle {
        color: "transparent"
    }*/

    property int index
    required property var model
    property bool complete: false
    required property var db

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
                    text: model.nameTask
                    font.pixelSize: 16
                    font.bold: true
                    font.strikeout: root.complete
                    color: "#4ecdc4"
                    Layout.fillWidth: true
                }

                Label {
                    text: {
                        /*
                        // Парсим строку в дату
                        var dt = new Date(root.dateTask)
                        // Проверяем валидность
                        if (isNaN(dt.getTime())) return "Некорректная дата"
                        return Qt.formatDateTime(dt, "dd.MM.yyyy, hh:mm")
                        */
                        model.dateTask
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
                text: model.describeTask
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
                        onClicked: db.deleteTask(model.id)
                    }
                }
            }
        }
    }
}
