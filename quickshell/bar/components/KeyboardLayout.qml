import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../config.js" as Config

Rectangle {
    id: button

    implicitWidth: label.implicitWidth + 16
    implicitHeight: label.implicitHeight + 8

    radius: Config.bar.radius
    color: hoverArea.containsMouse
           ? Config.colors.hover
           : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Text {
        id: label

        anchors.centerIn: parent

        property string layout: ""

        text: layout
        color: Config.colors.text
        font.pixelSize: Config.text.fontSize
        font.family: Config.text.fontFamily
        font.bold: true

        function update(keymap) {
            if (!keymap)
                return

            if (keymap.startsWith("Russian"))
                layout = "RU"
            else if (keymap.startsWith("English"))
                layout = "EN"
            else
                layout = keymap.substring(0, 2).toUpperCase()
        }

        Component.onCompleted: {
            Hyprland.rawEvent.connect(function(event) {
                if (event.name !== "activelayout")
                    return

                const parts = event.data.split(",")
                update(parts[parts.length - 1])
            })
        }

        Process {
            command: ["hyprctl", "-j", "devices"]
            running: true

            stdout: StdioCollector {
		onStreamFinished: { 
		    const keymap = label.parseKeyboard(text)
		    label.update(keymap)
		}
            }
        }

        function parseKeyboard(json) {
            const keyboards = JSON.parse(json).keyboards
            const main = keyboards.find(k => k.main)
            return (main ?? keyboards[0])?.active_keymap
        }
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Quickshell.execDetached([
            "hyprctl",
            "switchxkblayout",
            "all",
            "next"
        ])
    }
}
