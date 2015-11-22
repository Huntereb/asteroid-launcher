import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import org.freedesktop.contextkit 1.0
import MeeGo.Connman 0.2

Item {
    id: rootitem
    width: parent.width
    height: parent.height

    Connections {
        target: lipstickSettings;
        onLockscreenVisibleChanged: {
            if(lipstickSettings.lockscreenVisible) {
                batteryChargePercentage.subscribe()
                cellularSignalBars.subscribe()
                cellularRegistrationStatus.subscribe()
                cellularNetworkName.subscribe()
                cellularDataTechnology.subscribe()
            } else {
                batteryChargePercentage.unsubscribe()
                cellularSignalBars.unsubscribe()
                cellularRegistrationStatus.unsubscribe()
                cellularNetworkName.unsubscribe()
                cellularDataTechnology.unsubscribe()
            }
        }
    }

    ContextProperty {
        id: batteryChargePercentage
        key: "Battery.ChargePercentage"
        value: "100"
    }

    ContextProperty {
        id: cellularSignalBars
        key: "Cellular.SignalBars"
    }

    ContextProperty {
        id: cellularRegistrationStatus
        key: "Cellular.RegistrationStatus"
    }

    NetworkManager {
        id: networkManager
        function updateTechnologies() {
            if (available && technologiesEnabled) {
                wlan.path = networkManager.technologyPathForType("wifi")
            }
        }
        onAvailableChanged: updateTechnologies()
        onTechnologiesEnabledChanged: updateTechnologies()
        onTechnologiesChanged: updateTechnologies()

    }

    NetworkTechnology {
        id: wlan
    }

    ContextProperty {
        id: cellularNetworkName
        key: "Cellular.NetworkName"
    }

    ContextProperty {
        id: cellularDataTechnology
        key: "Cellular.DataTechnology"
    }

    TechnologyModel {
        id: wifimodel
        name: "wifi"
        onPoweredChanged: {
            if (powered)
                wifimodel.requestScan()
        }
    }

    Loader {
        id: panel_loader
        anchors.bottom: rootItem.top
        height: 240
        width: parent.width
        visible: false
    }

    GridLayout {
        anchors.fill: parent
        columns: 3
        StatusbarItem {
            source: (cellularSignalBars.value > 0) ? "image://theme/icon_cell" + cellularSignalBars.value : "image://theme/icon_cell1"
        }

        StatusbarItem {
            Label {
                id: tech
                width: 32
                height: 32
                font.pointSize: 6
                font.bold: true
                wrapMode: Text.ElideRight
                text: (cellularNetworkName.value !== "") ? cellularNetworkName.value.substring(0,3).toUpperCase() : "NA"
            }

            Label {
                anchors.top: tech.bottom
                anchors.topMargin: 4
                width: 32
                height: 32
                font.pointSize: 6
                text: {
                    var techToG = {gprs: "2", egprs: "2.5", umts: "3", hspa: "3.5", lte: "4", unknown: "0"}
                    return techToG[cellularDataTechnology.value ? cellularDataTechnology.value : "unknown"] + "G"
                }
            }
            panel: SimPanel {}
        }

        StatusbarItem {
            source: {
                if (wlan.connected) {
                    if (networkManager.defaultRoute.type !== "wifi")
                        return "image://theme/icon_wifi_0"
                    if (networkManager.defaultRoute.strength >= 59) {
                        return "image://theme/icon_wifi_normal4"
                    } else if (networkManager.defaultRoute.strength >= 55) {
                        return "image://theme/icon_wifi_normal3"
                    } else if (networkManager.defaultRoute.strength >= 50) {
                        return "image://theme/icon_wifi_normal2"
                    } else if (networkManager.defaultRoute.strength >= 40) {
                        return "image://theme/icon_wifi_normal1"
                    } else {
                        return "image://theme/icon_wifi_0"
                    }
                } else {
                    return "image://theme/icon_wifi_0"
                }
            }
            panel: WifiPanel {}
        }
        StatusbarItem {
            source: "image://theme/icon_bt_normal"
        }
        StatusbarItem {
            source: "image://theme/icon_nfc_normal"
        }
        StatusbarItem {
            source: "image://theme/icon_gps_normal"
        }

        StatusbarItem {
            panel: BatteryPanel {}
            source: {
                if(batteryChargePercentage.value > 85) {
                    return "qrc:/qml/images/battery6.png"
                } else if (batteryChargePercentage.value <= 5) {
                    return "qrc:/qml/images/battery0.png"
                } else if (batteryChargePercentage.value <= 10) {
                    return "qrc:/qml/images/battery1.png"
                } else if (batteryChargePercentage.value <= 25) {
                    return "qrc:/qml/images/battery2.png"
                } else if (batteryChargePercentage.value <= 40) {
                    return "qrc:/qml/images/battery3.png"
                } else if (batteryChargePercentage.value <= 65) {
                    return "qrc:/qml/images/battery4.png"
                } else if (batteryChargePercentage.value <= 80) {
                    return "qrc:/qml/images/battery5.png"
                } else {
                    return "qrc:/qml/images/battery6.png"
                }
            }
        }
    }
}