import Quickshell
import QtQuick
import QtQuick.Layouts
import "../config.js" as Config

Text {
    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(systemClock.date, "hh:mm")
    color: Config.colors.text
    font.pixelSize: Config.text.fontSize
    font.family: Config.text.fontFamily
    font.bold: true
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
}
