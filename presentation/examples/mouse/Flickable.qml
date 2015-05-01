import QtQuick 2.1

Rectangle {
    width: 600; height: 600;
    Flickable {
        anchors.fill: parent; contentHeight: 1200;
        Rectangle {
            x: 100; y: 100; width: 300; height: 300;
            color: mouse.pressed ? "red" : (mouse.containsMouse ? "blue" : "#006")
            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
        Rectangle {
            x: 200; y: 200; width: 300; height: 300;
            color: mouse2.containsMouse ? "green" : "#060"
            MouseArea {
                id: mouse2
                anchors.fill: parent
                hoverEnabled: true
                onPressed: mouse.accepted = false
            }
        }
    }
}