import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0

Item { width: 800; height: 800
    Repeater {
        id: root; anchors.fill: parent

        Image {
            source: folderModel.folder + fileName

            PinchArea {
                anchors.fill: parent
                pinch.target: parent
                pinch.minimumRotation: -360
                pinch.maximumRotation: 360
                pinch.minimumScale: 0.1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                MouseArea {
                    anchors.fill: parent
                    drag.target: parent.parent
                    onPressed: parent.parent.z = ++root.zmax
                }
            }

            scale: root.defaultSize / Math.max(sourceSize.width, sourceSize.height)
            antialiasing: true
            rotation: Math.random() * 13 - 6
            onStatusChanged: {
                x = root.width - 500 - Math.random() * 20
                y = Math.random() * root.height / 3
            }
        }

        property real zmax: folderModel.count
        property real defaultSize: 200
        model: FolderListModel {
            id: folderModel
            showDirs: false; folder: "resources/"; nameFilters: ["*.jpg", "*.JPG"]
        }
    }
}
