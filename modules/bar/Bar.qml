import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "../theme"
import "components"

PanelWindow {
    id: root

    property int fontSize: 14

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    Rectangle {
        anchors.fill: parent
        color: ThemeManager.colors.surface
        
        RowLayout {
          anchors.fill: parent
          spacing: 0

            RowLayout {
              id: leftSection
              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.alignment: Qt.AlignLeft
              spacing: 0
    
              Item { width: 8 }
    
              Rectangle {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                color: "transparent"
    
                Image {
                  anchors.fill: parent
                  source: "file:///home/dopanime/.config/kitty/images/bernice.png"
                  fillMode: Image.PreserveAspectFit
                }
              }
            }
              Item { width: 8 }
              
              Repeater {
                model: Hyprland.workspaces.values

                Rectangle {
                  required property var modelData

                  Layout.preferredWidth: 20
                  Layout.fillHeight: true

                  color: "transparent"

                  property int workspaceId: modelData.id

                  property bool isActive:
                    Hyprland.focusedWorkspace?.id === workspaceId

                  Text {
                    id: workspaceText
                    text: workspaceId
                    style: Text.Outline
                    styleColor: "#FFF"

                    color: parent.isActive
                      ? ThemeManager.colors.col2
                      : ThemeManager.colors.textSoft

                      font.pixelSize: root.fontSize
                      font.family: ThemeManager.colors.fontFamily
                      font.bold: true

                      anchors.centerIn: parent
                    }
                  
                  MultiEffect {
                    anchors.fill: workspaceText
                    source: workspaceText

                    shadowEnabled: true
                    shadowColor: parent.isActive
                      ? ThemeManager.colors.border
                      : ThemeManager.colors.col4
                  }

                  Rectangle {
                    width: 20
                    height: 3

                    color: parent.isActive
                    ? ThemeManager.colors.col2
                    : "transparent"

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                  }

                  MouseArea {
                    anchors.fill: parent

                    onClicked: {
                      Hyprland.dispatch("workspace " + workspaceId)
                    }
                  }
                }
              }

            Rectangle {
              Layout.preferredWidth: 1
              Layout.preferredHeight: 16
              Layout.alignment: Qt.AlignCenter
              Layout.leftMargin: 8
              Layout.rightMargin: 8
              color: ThemeManager.colors.border
            }
    
            Item {
              Layout.fillWidth: true
            }

            Rectangle {
              Layout.preferredWidth: 1
              Layout.preferredHeight: 16
              Layout.alignment: Qt.AlignCenter
              Layout.leftMargin: 8
              Layout.rightMargin: 8
              color: ThemeManager.colors.border
            }

            RowLayout {
              id: rightSection
              Layout.alignment: Qt.AlignRight
              Layout.rightMargin: 10
              spacing: 15
              
              Loader {
                source: "./components/Tray.qml"
              }

              Text {
                id: clockText
                font.family: ThemeManager.colors.fontFamily
                text: Qt.formatDateTime(new Date(), "    HH:mm\nddd, MMM dd")
                color: ThemeManager.colors.text
              
                Timer {
                  interval: 1000
                  running: true
                  repeat: true
                  onTriggered: clockText.text = Qt.formatDateTime(new Date(), "    HH:mm\nddd, MMM dd")
                }
              }
            }

          
    }     
  }

    RowLayout {
      id: centerSection
      anchors.centerIn: parent
      
      Loader {
        source: "./components/Taskbar.qml"
      }

    }     
}
