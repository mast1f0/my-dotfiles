import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

import "../config.js" as Config

Item {
    width: 100
    height: 30

    Rectangle{
	id: bg
	color: clickArea.containsMouse ? Config.colors.hoverWorkspace  : "transparent"
	anchors.fill: parent
	Layout.alignment: Qt.AlignBottom
	
	radius: Config.bar.radius

	MouseArea{
	id: clickArea
	anchors.fill: parent
	hoverEnabled: true
	onClicked: () => {
		States.quickSettingsVisible = !States.quickSettingsVisible
	    }
	}
    }
}
