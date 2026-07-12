import QtQuick
import Quickshell
import Quickshell.Networking
import "../config.js" as Config


Item {
    id: root
    implicitHeight: label.implicitHeight
    implicitWidth: label.implicitWidth

    property string  ssid: "Disconnected"
    property var wifiDevice: null

    function getCurrentWIFI(){
	if (!Networking.devices || !Networking.devices.values)
        return null

	const wifi = Networking.devices.values.find(d => d.mode !== undefined)
	
	if(!wifi) return null

	return wifi.networks.values.find(n => n.connected)
    }

    function updateSSID(){
	const network = getCurrentWIFI()
	if(network) {
	    ssid = network.name
	    return;
	}
	ssid = "Disconnected"
    }

	function findWifi() {
	    wifiDevice = Networking.devices.values.find(
		d => d.mode !== undefined
	    ) ?? null
	    if (wifiDevice)
		wifiDevice.scannerEnabled = true
	    updateSSID()
	}


    Connections {
	target: Networking.devices


	function onValuesChanged() {
	    findWifi()
	}
    }
    
    
    Connections {
	target: root.wifiDevice
	enabled: root.wifiDevice !== null

	function onConnectedChanged() {
	    updateSSID()
	}
    }

    Connections {
	target: root.wifiDevice ? root.wifiDevice.networks : null

	function onValuesChanged() {
	    updateSSID()
	}
    }

    Connections {
	target: Networking

	function onWifiEnabledChanged() {
	    updateSSID()
	}
    }

    Component.onCompleted: findWifi()

    Text {
	id: label
	anchors.centerIn: parent 
	text: (Networking.wifiEnabled ? "󰤨 " : "󰤭") + "   " + ssid
	color: Config.colors.text
	font.pixelSize: Config.text.fontSize
    }
}
