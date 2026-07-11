import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import "../config.js" as Config
import Quickshell


    Text {
    id: root

    property string layout: ""

    text: layout
    color: Config.colors.text
    font.pixelSize: Config.text.fontSize
    font.family: Config.text.fontFamily
    font.bold: true
    Layout.alignment: Qt.AlignVCenter

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
        Hyprland.rawEvent.connect(function (event) {
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
            onStreamFinished: root.update(parseKeyboard(this.text))
        }
    }

    function parseKeyboard(json) {
        const keyboards = JSON.parse(json).keyboards
        const main = keyboards.find(k => k.main)
        return (main ?? keyboards[0])?.active_keymap
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}

