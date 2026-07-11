import QtQuick
import Quickshell
import Quickshell.Networking
import "../config.js" as Config


Item {
    id: root
    implicitHeight: label.implicitHeight
    implicitWidth: label.implicitWidth

    property string  ssid: "Disconnected"
    
    function getIcon(){
	return !Networking.wifiEnabled ? "󰤭" : "󰤨 "
    }
    
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
	} else {
	    ssid = "Disconnected"
	}
    }

    Text {
	id: label
	anchors.centerIn: parent 
	text: getIcon() + "   " + ssid
	color: Config.colors.text
	font.pixelSize: Config.text.fontSize
    }

    Component.onCompleted: {
	updateSSID()
    }
}
