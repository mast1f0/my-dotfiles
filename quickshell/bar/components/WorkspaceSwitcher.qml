import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

RowLayout {
    spacing: Config.workspace.spacing
    Layout.alignment: Qt.AlignHCenter

    Repeater {
        model: Config.workspace.count

        Rectangle {
            id: wsButton
            required property int index

            Layout.preferredWidth: Config.workspace.size
            Layout.preferredHeight: Config.workspace.size
            radius: Config.workspace.radius

            readonly property bool active: Hyprland.focusedWorkspace?.id === index + 1

            color: {
                if (active) return Config.colors.activeWorkspace
                if (hoverArea.containsMouse) return Config.colors.hoverWorkspace
                return "transparent"
            }

            Text {
                anchors.centerIn: parent
                text: wsButton.index + 1
                color: Config.colors.text
                font.pixelSize: Config.text.fontSize
                font.family: Config.text.fontFamily
                font.bold: active
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (wsButton.index + 1) + " })")
            }
        }
    }
}
