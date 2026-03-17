import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 1280
    height: 800
    visible: true
    title: qsTr("Habits")

    MainView {
        anchors.fill: parent
    }
    header: MenuBar {
           Menu {
               title: qsTr("&File")
               Action {
                   text: qsTr("&Open...")
                   onTriggered: console.log("Open action triggered")
               }
               MenuSeparator { }
               Action {
                   text: qsTr("&Exit")
                   onTriggered: Qt.quit()
               }
           }
       }
}
