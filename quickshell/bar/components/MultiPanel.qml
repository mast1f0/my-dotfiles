import QtQuick
import Quickshell

import "../config.js" as Config

PanelWindow {
    anchors {
        top: true
        right: true
    }

    visible: States.quickSettingsVisible
   
    color: "transparent"
    margins {
        top: 10
        right: Config.bar.marginH
    }

    implicitWidth: 350
    implicitHeight: 350

    Rectangle {
	radius: Config.bar.radius
        anchors.fill: parent
        color: Config.colors.bg
    }
}
