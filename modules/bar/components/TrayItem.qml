pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../../theme"

// Um único ícone da bandeja do sistema (ex: volume, rede, apps em background).
// Recebe o SystemTrayItem via modelData quando usado dentro de um Repeater.
Item {
    id: root

    required property SystemTrayItem modelData

    Layout.preferredWidth: 20
    Layout.preferredHeight: 20
    Layout.alignment: Qt.AlignVCenter

    IconImage {
        id: icon

        anchors.fill: parent
        anchors.margins: 1
        source: root.modelData.icon
        smooth: true
        asynchronous: true

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onClicked: mouse => {
                switch (mouse.button) {
                case Qt.LeftButton:
                    root.modelData.activate();
                    break;
                case Qt.MiddleButton:
                    root.modelData.secondaryActivate();
                    break;
                case Qt.RightButton:
                    if (root.modelData.hasMenu)
                        menuAnchor.open();
                    break;
                }
            }
        }
    }

    // Menu de contexto (clique direito). A API de QsMenuAnchor pode variar
    // um pouco entre versões do Quickshell — se `Edges` não resolver,
    // troque por `anchor.rect` manual usando icon.mapToItem().
    QsMenuAnchor {
        id: menuAnchor

        menu: root.modelData.menu
        anchor.item: icon
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
    }
}
