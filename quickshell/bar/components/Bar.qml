import Quickshell
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        left: Config.bar.marginH
        right: Config.bar.marginH
        top: Config.bar.padding
    }

    color: "transparent"
    implicitHeight: Config.bar.height

    Rectangle {
        anchors.fill: parent
        color: Config.colors.bg
        border.color: Config.colors.border
        radius: Config.bar.radius

        RowLayout {
            anchors.fill: parent
            anchors.margins: Config.bar.padding
            spacing: Config.bar.spacing

            StopButton {
                onClicked: Quickshell.execDetached([
                    "quickshell",
                    "--path", Quickshell.shellPath(Config.wlogout.path),
                    "--no-duplicate",
                ])
            }

            Item { width: 30 }
	    
	    //Workspaces
            WorkspaceSwitcher {}

	    Item { width: 50}

            ActiveWindows {}

            Item { Layout.fillWidth: true }
	    
	    WifiButton{}

	    Item { width: 15}

            KeyboardLayout {}

	    Item { width: 15}

	    Clock {}

	    Item { width: 30}

	MultiPanelButton {}
    } 
}
}


