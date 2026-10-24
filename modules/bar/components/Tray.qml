pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Qt.labs.settings
import Quickshell
import Quickshell.Services.SystemTray
import "../../theme"

RowLayout {
    id: root

    spacing: 10
    Layout.alignment: Qt.AlignVCenter
    Layout.fillHeight: true

    property bool expanded: false
    property var pinnedIds: []

    readonly property var allItems: Array.from(SystemTray.items.values ?? [])
    readonly property var pinnedItems: root.allItems.filter(item => root.isPinned(item))
    readonly property var hiddenItems: root.allItems.filter(item => !root.isPinned(item))

    // Chave estável para lembrar quais itens o usuário escolheu fixar.
    function keyFor(item) {
        if (!item)
            return "";
        return item.id || item.title || "";
    }

    function isPinned(item) {
        const key = root.keyFor(item);
        return key !== "" && root.pinnedIds.indexOf(key) !== -1;
    }

    function togglePin(item) {
        const key = root.keyFor(item);
        if (key === "")
            return;

        const updated = root.pinnedIds.slice();
        const idx = updated.indexOf(key);
        if (idx === -1)
            updated.push(key);
        else
            updated.splice(idx, 1);
        root.pinnedIds = updated;
    }

    Settings {
        id: settings
        category: "tray"
        property string pinnedJson: "[]"
    }

    Component.onCompleted: {
        try {
            const parsed = JSON.parse(settings.pinnedJson);
            if (Array.isArray(parsed))
                root.pinnedIds = parsed;
        } catch (e) {
            root.pinnedIds = [];
        }
    }

    onPinnedIdsChanged: settings.pinnedJson = JSON.stringify(root.pinnedIds)

    // Seta que expande/recolhe os ícones escondidos, igual ao "mostrar ícones
    // ocultos" do Windows/Plasma. Só aparece se houver algo escondido.
    Item {
        id: toggleButton

        visible: root.hiddenItems.length > 0
        Layout.preferredWidth: 16
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter

        Text {
            anchors.centerIn: parent
            text: "V"
            color: ThemeManager.colors.textSoft
            font.pixelSize: 14
            rotation: root.expanded ? 180 : 0

            Behavior on rotation {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    Repeater {
        model: root.pinnedItems

        PinnableTrayItem {
            required property var modelData

            trayItem: modelData
            pinned: true
            onTogglePinRequested: root.togglePin(modelData)
        }
    }

    TrayFlyout {
        anchorItem: toggleButton
        visible: root.expanded
        hiddenItems: root.hiddenItems

        onPinRequested: item => root.togglePin(item)
    }
}
