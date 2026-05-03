import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#0a0a0a"

    // Заголовок приложения
    Text {
        id: headerTitle
        text: "Мои Цели"
        font.pixelSize: 24
        font.bold: true
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ColumnLayout {
        anchors.top: headerTitle.bottom
        anchors.bottom: bottomNav.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        spacing: 20

        // Секция Задач
        Tasks {
            Layout.fillWidth: true
        }

        // Секция Привычек
        HabitsView {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    // Нижняя навигация (переключение вкладок и настройки)
    Rectangle {
        id: bottomNav
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: "#1a1a1a"
        radius: 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        RowLayout {
            anchors.centerIn: parent
            spacing: 60

            // Кнопка "Цели" (Tasks)
            ColumnLayout {
                spacing: 4
                Label {
                    text: "✓"
                    font.pixelSize: 22
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: qsTr("Цели")
                    font.pixelSize: 12
                    color: "#ffffff"
                }
                TapHandler {
                    onTapped: console.log("Открыть задачи")
                }
            }

            // Кнопка "Привычки" (Активная)
            ColumnLayout {
                spacing: 4
                Label {
                    text: "●"
                    font.pixelSize: 22
                    color: "#4ecdc4"
                    Layout.alignment: Qt.AlignHCenter
                }
                Label {
                    text: qsTr("Привычки")
                    font.pixelSize: 12
                    color: "#4ecdc4"
                }
                TapHandler {
                    onTapped: console.log("Открыть привычки")
                }
            }

            // Кнопка "Настройки"
            ColumnLayout {
                spacing: 4
                Text {
                    text: "⚙"
                    font.pixelSize: 22
                    color: "#888888"
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: qsTr("Настройки")
                    font.pixelSize: 12
                    color: "#888888"
                }
                TapHandler {
                    onTapped: console.log("Открыть настройки")
                }
            }
        }
    }
}
