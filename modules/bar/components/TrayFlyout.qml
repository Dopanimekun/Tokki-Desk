pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../theme"

// Painel flutuante com os ícones escondidos da bandeja, no estilo do popup de
// "ícones ocultos" do Plasma / seta de itens ocultos do Windows. Fica ancorado
// logo abaixo do botão de seta em Tray.qml.
PopupWindow {
    id: root

    required property Item anchorItem
    required property var hiddenItems
    signal pinRequested(var item)

    visible: false
    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    implicitWidth: content.implicitWidth + 24
    implicitHeight: content.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: ThemeManager.colors.surface
        border.width: 1
        border.color: ThemeManager.colors.border

        RowLayout {
            id: content

            anchors.centerIn: parent
            spacing: 12

            Repeater {
                model: root.hiddenItems

                PinnableTrayItem {
                    required property var modelData

                    trayItem: modelData
                    pinned: false
                    onTogglePinRequested: root.pinRequested(modelData)
                }
            }
        }
    }
}
