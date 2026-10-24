pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../../theme"

RowLayout {
    id: root

    spacing: 10
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true

    Repeater {
        id: repeater

        model: SystemTray.items

        TrayItem {}
    }
}
