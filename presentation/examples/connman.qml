/****************************************************************************
**
** Copyright (C) 2015 Shawn Rutledge
**
** This file is part of the Grefsen (Wayland componsitor) project.
**
** This file is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License version 3 as published by the Free Software Foundation
** and appearing in the file LICENSE included in the packaging
** of this file.
**
** This code is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU Lesser General Public License for more details.
**
****************************************************************************/

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import MeeGo.Connman 0.2

Rectangle {
    width: 320
    height: 480
    color: Material.background

    Material.theme: Material.Dark

    NetworkManager {
        id: manager
        function checkTechnologies() {
            var tl = manager.technologiesList()
            if (tl.length > 0)
                techList.model = tl
            console.log("state " + state + " available? " + available + " enabled svcs " + servicesEnabled + " techs " + technologiesEnabled)
            console.log("   list " + tl)
        }

        onAvailabilityChanged: checkTechnologies()
        onStateChanged: checkTechnologies()
        onOfflineModeChanged: checkTechnologies()
        onTechnologiesChanged: checkTechnologies()
        onTechnologiesEnabledChanged: checkTechnologies()
    }

    SwipeView {
        id: swipeView

        currentIndex: 0
        anchors.fill: parent

        ListView {
            id: techList
            spacing: 2
            delegate: Rectangle {
                width: parent.width
                height: 40
                color: "#222"
                property NetworkTechnology tech: manager.getTechnology(modelData)
                Text {
                    text: tech.name
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    x: 6
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: modelData === "wifi" && techEnableSwitch.checked
                    onClicked: swipeView.currentIndex = 1
                }
                Switch {
                    id: techEnableSwitch
                    checked: tech.powered
                    anchors {
                        right: parent.right
                        margins: 6
                        verticalCenter: parent.verticalCenter
                    }
                    onReleased: {
                        console.log("setting " + modelData + " " + !checked)
                        tech.powered = !checked
                    }
                }
            }
        }
        ListView {
            id: wifiList
            spacing: 2
            model: TechnologyModel {
                id: techModel
                name: "wifi"
                onAvailabilityChanged: {
                    console.log(name + " powered? " + powered + " available? " + available)
                }
            }
            delegate: Rectangle {
                width: parent.width
                height: 40
                color: "#222"
                Text {
                    text: networkService.name
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    x: 6
                }
                Text {
                    anchors {
                        right: parent.right
                        margins: 6
                        verticalCenter: parent.verticalCenter
                    }
                    color: "white"
                    font.pixelSize: 30
                    text: networkService.connected ? "✔" : ""
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !networkService.connected
                    onClicked: {
                        console.log("trying to connect to " + networkService.name)
                        networkService.requestConnect()
                    }
                }
            }
        }
        Item {
            id: wifiConfigPage
            Rectangle {
                anchors.fill: parent
                anchors.margins: 6
                anchors.bottomMargin: indicator.height
                radius: 8
                color: "#444"
            }
        }
    }

    PageIndicator {
        id: indicator

        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
