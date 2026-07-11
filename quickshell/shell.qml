import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "config.js" as Config
import "bar/components"

Scope {
    id: root

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true
        }
    }

    PanelWindow {

        anchors {
            top: true
            right: true
        }

        margins {
            top: 12
            right: 12
        }

        implicitWidth: 360
        implicitHeight: Math.max(1, column.implicitHeight)

        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay

        ColumnLayout {
            id: column

            anchors.fill: parent
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {

                    id: card

                    required property var modelData

                    Layout.fillWidth: true

                    implicitHeight: layout.implicitHeight + 20
                    Layout.preferredHeight: implicitHeight

                    radius: 10

                    color: Config.colors.bg

                    border.width: 2
                    border.color:
                        modelData.urgency === NotificationUrgency.Critical
                        ? Config.colors.urgency
                        : Config.colors.normal

                    opacity: 0
                    x: 40

                    Component.onCompleted: {
                        opacity = 1
                        x = 0
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 180
                        }
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 220
                            easing.type: Easing.OutCubic
                        }
                    }

                    SequentialAnimation {
                        id: hideAnim

                        NumberAnimation {
                            target: card
                            property: "opacity"
                            to: 0
                            duration: 150
                        }

                        NumberAnimation {
                            target: card
                            property: "x"
                            to: 40
                            duration: 150
                        }

                        ScriptAction {
                            script: card.modelData.dismiss()
                        }
                    }

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        repeat: false
                        interval: Config.timer.timeout

                        onTriggered: hideAnim.start()
                    }

                    RowLayout {

                        id: layout

                        anchors.fill: parent
                        anchors.margins: 12

                        spacing: 12

                        Image {

                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignTop

                            fillMode: Image.PreserveAspectFit

                            source: card.modelData.image
                                    || card.modelData.appIcon
                                    || ""

                            visible: source.toString() !== ""
                        }

                        ColumnLayout {

                            Layout.fillWidth: true

                            spacing: 4

                            Text {

                                Layout.fillWidth: true

                                text: card.modelData.summary

                                color: Config.colors.author

                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize
                                font.bold: true

                                wrapMode: Text.Wrap
                            }

                            Text {

                                Layout.fillWidth: true

                                visible: text !== ""

                                text: card.modelData.body

                                color: Config.colors.infoText

                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 2

                                wrapMode: Text.Wrap
                            }
                        }
                    }

                    Rectangle {

                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }

                        height: 3
                        radius: 2

                        visible: card.modelData.urgency !== NotificationUrgency.Critical

                        color: border.color

                        PropertyAnimation on width {

                            from: card.width
                            to: 0

                            duration: Config.timer.timeout

                            running: card.modelData.urgency !== NotificationUrgency.Critical
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: hideAnim.start()
                    }
                }
            }
        }
    }

    Bar {}
}
