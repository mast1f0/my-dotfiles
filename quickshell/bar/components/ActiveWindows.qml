import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

RowLayout {
    spacing: 4
    clip: true
     Layout.maximumWidth: 600
    
    Repeater {
        model: Hyprland.toplevels.values

        Rectangle {
            id: windowButton
            required property var modelData

	    implicitHeight: 24
            implicitWidth: Math.min(title.implicitWidth + 16, 180)
            radius: 8

            readonly property bool active: modelData.activated

            color: {
                if (active)
                    return Config.colors.activeWorkspace
                if (hoverArea.containsMouse)
                    return Config.colors.hoverWorkspace
                return "transparent"
            }

            Text {
                id: title
                anchors.centerIn: parent
                width: parent.width - 16
                text: modelData.title || "?"
                color: Config.colors.text
                font.pixelSize: Config.text.fontSize - 2
                font.family: Config.text.fontFamily
                font.bold: active
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!modelData.address)
                        return
                    Hyprland.dispatch('hl.dsp.focus({ window = "address:0x' + modelData.address + '" })')
                }
            }
        }
    }
}
