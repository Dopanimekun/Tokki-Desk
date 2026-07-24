pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../../theme"

// Envolve um TrayItem e acrescenta:
// - um botão de fixar/desafixar (aparece ao passar o mouse);
// - o nome do app numa janela flutuante própria (PopupWindow), ancorada
//   embaixo do ícone. Não usamos o ToolTip do QtQuick.Controls porque ele
//   fica preso dentro da janela do componente pai (a barra ou o popup da
//   bandeja) e, quando essa janela é pequena, acaba grudado no cursor.
Item {
    id: root

    required property SystemTrayItem trayItem
    required property bool pinned
    signal togglePinRequested()

    readonly property string displayName: root.trayItem.title ?? ""
    property bool showTooltip: false

    implicitWidth: 24
    implicitHeight: 24
    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    Layout.alignment: Qt.AlignVCenter

    TrayItem {
        id: icon

        anchors.centerIn: parent
        width: 20
        height: 20
        modelData: root.trayItem
    }

    HoverHandler {
        id: hover

        onHoveredChanged: {
            if (hover.hovered) {
                tooltipDelay.restart();
            } else {
                tooltipDelay.stop();
                root.showTooltip = false;
            }
        }
    }

    Timer {
        id: tooltipDelay
        interval: 400
        onTriggered: root.showTooltip = true
    }

    PopupWindow {
        id: nameTooltip

        visible: root.showTooltip && root.displayName !== ""
        color: "transparent"

        anchor.item: icon
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom

        implicitWidth: nameText.implicitWidth + 16
        implicitHeight: nameText.implicitHeight + 10

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: ThemeManager.colors.surface
            border.width: 1
            border.color: ThemeManager.colors.border

            Text {
                id: nameText

                anchors.centerIn: parent
                text: root.displayName
                color: ThemeManager.colors.text
                font.pixelSize: 11
            }
        }
    }

    Rectangle {
        visible: hover.hovered
        width: 10
        height: 10
        radius: 5
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: root.pinned ? ThemeManager.colors.col2 : ThemeManager.colors.surface
        border.width: 1
        border.color: ThemeManager.colors.border

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.togglePinRequested()
        }
    }
}
