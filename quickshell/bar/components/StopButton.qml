import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Rectangle {
    id: root

    signal clicked()

    Layout.preferredWidth: Config.workspace.size
    Layout.preferredHeight: Config.workspace.size
    radius: Config.workspace.radius
    color: hoverArea.containsMouse ? Config.colors.hoverWorkspace : "transparent"

    Text {
        anchors.centerIn: parent
        text: "⏸"
        color: Config.colors.text
        font.pixelSize: Config.text.fontSize + 2
        font.family: Config.text.fontFamily
        font.bold: true
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
