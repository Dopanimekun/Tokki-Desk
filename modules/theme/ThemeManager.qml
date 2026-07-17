pragma Singleton
import QtQuick

QtObject {
    id: manager

    property string themeName: "Supernatural"
    property string iconFont: "JetBrainsMono Nerd Font"

    property Loader themeLoader: Loader {
        source: Qt.resolvedUrl("palettes/" + themeName + ".qml")
    }

    readonly property QtObject colors: themeLoader.item

    function setTheme(name) {
        themeName = name
    }
}
