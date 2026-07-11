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

    function updateSSID(){
	console.log(Networking.devices)
       ssid =  Networking.connected ? Networking.activeConnection.name : "Disconnected"
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
