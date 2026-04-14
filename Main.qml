import QtQuick 2.15
import QtQuick.Controls
import Habits

ApplicationWindow {
    width: 1280
    height: 800
    visible: true
    title: qsTr("Habits")

    MainView {
        anchors.fill: parent
    }
}
