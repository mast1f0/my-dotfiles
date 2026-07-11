import QtQuick
import Quickshell
import Quickshell.Networking
import "../config.js" as Config

Item {
    id: root

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    property string ssid: "Disconnected"
    property var wifiAdapter: null
    property var visibleNetworks: []
    property bool menuOpen: false

    function listValues(model) {
        if (!model)
            return []
        if (model.values)
            return [...model.values]
        if (model.count === undefined || !model.get)
            return []
        const values = []
        for (let i = 0; i < model.count; i++)
            values.push(model.get(i))
        return values
    }

    function refreshWifi() {
        wifiAdapter = null
        visibleNetworks = []
        ssid = "Disconnected"

        if (!Networking.wifiEnabled) {
            menuOpen = false
            return
        }

        const devices = listValues(Networking.devices)
        for (const device of devices) {
            if (device && device.type === DeviceType.Wifi) {
                wifiAdapter = device
                break
            }
        }

        if (!wifiAdapter)
            return

        const networks = listValues(wifiAdapter.networks)
        for (const network of networks) {
            const name = network && network.name ? network.name : "Hidden network"
            const connected = network && network.connected === true

            visibleNetworks.push({
                name: name,
                connected: connected,
                ref: network,
            })

            if (connected)
                ssid = name
        }

        visibleNetworks.sort((a, b) => {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1
            return a.name.localeCompare(b.name)
        })
    }

    function connectNetwork(networkRef) {
        if (!networkRef)
            return

        if (networkRef.connect)
            networkRef.connect()

        menuOpen = false
        refreshWifi()
    }

    function disconnectWifi() {
        if (wifiAdapter && wifiAdapter.disconnect)
            wifiAdapter.disconnect()

        refreshWifi()
    }

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled
        refreshWifi()
    }

    Text {
        id: label
        text: !Networking.wifiEnabled ? "󰤭" : ("󰤨 " + root.ssid)
        color: Config.colors.text
        font.pixelSize: Config.text.fontSize
        font.family: Config.text.fontFamily
        font.bold: true
    }

    Component.onCompleted: {
        refreshWifi()
    }


    Connections {
        target: Networking

        function onDevicesChanged() {
            refreshWifi()
        }

        function onWifiEnabledChanged() {
            refreshWifi()
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: root.refreshWifi()
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.wifiAdapter && root.wifiAdapter.scannerEnabled !== undefined)
                root.wifiAdapter.scannerEnabled = true
            root.menuOpen = !root.menuOpen
            root.refreshWifi()
        }
    }

    PopupWindow {
        id: dropdown
        visible: root.menuOpen
        onVisibleChanged: if (!visible) root.menuOpen = false

        anchor.item: root
        anchor.rect.y: root.height + 8
        anchor.rect.x: root.width - implicitWidth

        implicitWidth: 190
        implicitHeight: container.implicitHeight
        color: "transparent"

        Rectangle {
            id: container
            implicitWidth: 190
            implicitHeight: networksColumn.implicitHeight + 8
            radius: 6
            color: Config.colors.bg
            border.color: Config.colors.border
            border.width: 1

            Column {
                id: networksColumn
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                Row {
                    spacing: 4


                    Rectangle {
                        width: 88
                        height: 24
                        radius: 4
                        color: "transparent"
                        border.color: Config.colors.border
                        border.width: 1
                        opacity: root.wifiAdapter && root.ssid !== "Disconnected" ? 1 : 0.5

                        Text {
                            anchors.centerIn: parent
                            text: "Disconnect"
                            color: Config.colors.text
                            font.pixelSize: Config.text.fontSize - 2
                            font.family: Config.text.fontFamily
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: root.wifiAdapter && root.ssid !== "Disconnected"
                            onClicked: root.disconnectWifi()
                        }
                    }
                }

                Rectangle {
                    width: container.width - 8
                    height: 1
                    color: Config.colors.border
                    opacity: 0.7
                }

                Repeater {
                    model: root.visibleNetworks

                    delegate: Rectangle {
                        width: container.width - 8
                        height: 24
                        radius: 4
                        color: modelData.connected ? Config.colors.hoverWorkspace : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            elide: Text.ElideRight
                            text: modelData.connected ? ("✓ " + modelData.name) : modelData.name
                            color: Config.colors.text
                            font.pixelSize: Config.text.fontSize - 2
                            font.family: Config.text.fontFamily
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.connectNetwork(modelData.ref)
                        }
                    }
                }

                Text {
                    visible: !Networking.wifiEnabled || root.visibleNetworks.length === 0
                    text: !Networking.wifiEnabled ? "WiFi disabled" : "No networks"
                    color: Config.colors.text
                    font.pixelSize: Config.text.fontSize - 2
                    font.family: Config.text.fontFamily
                    opacity: 0.8
                }
            }
        }
    }
}
