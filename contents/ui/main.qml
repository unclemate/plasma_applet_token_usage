import QtQuick
import QtQuick.Layouts
import QtQml
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

import "lib/store.js" as Store
import "lib/deepseek.js" as DeepseekApi
import "lib/formatters.js" as Fmt

PlasmoidItem {
    id: root

    Plasmoid.constraintHints: Plasmoid.CanFillArea

    // --- Reactive state bridge (mutated by store.js) ---
    property var balanceData: ({})
    property bool isLoading: false
    property string errorMessage: ""
    property var lastFetchTime: null

    preferredRepresentation: compactRepresentation

    // --- Size hints for panel and popup ---

    // --- Tooltip — reactively updates ---
    toolTipMainText: i18n("DeepSeek Balance")
    toolTipSubText: {
        if (isLoading) return i18n("Loading...");
        if (errorMessage) return errorMessage;
        var b = Fmt.formatBalance(balanceData);
        return b.formatted + " (" + b.currency + ")";
    }

    // --- Compact representation (panel) ---
    compactRepresentation: Text {
        id: compactLabel
        text: {
            if (root.isLoading) return "...";
            if (root.errorMessage) return "ERR";
            var b = Fmt.formatBalance(root.balanceData);
            return b.formatted;
        }
        color: root.errorMessage ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
        elide: Text.ElideRight
        font: Kirigami.Theme.defaultFont
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        Layout.minimumWidth: 48
    }

    // --- Full representation (popup / desktop) ---
    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 44
        Layout.preferredHeight: Kirigami.Units.gridUnit * 18
        Layout.maximumWidth: Kirigami.Units.gridUnit * 60
        implicitWidth: Kirigami.Units.gridUnit * 44
        implicitHeight: Kirigami.Units.gridUnit * 18

        QtObject {
            id: fmtData
            property var result: Fmt.formatBalance(root.balanceData)
        }

        Flickable {
            id: flickArea
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            contentWidth: columnLayout.width
            contentHeight: columnLayout.height + Kirigami.Units.largeSpacing
            clip: true
            interactive: true

            ColumnLayout {
                id: columnLayout
                width: flickArea.width - Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                // Header
                Kirigami.Heading {
                    text: i18n("DeepSeek Balance")
                    level: 2
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                }

                // Loading indicator
                PlasmaComponents.BusyIndicator {
                    running: root.isLoading
                    visible: root.isLoading
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Kirigami.Units.gridUnit * 2
                }

                // Error message
                PlasmaComponents.Label {
                    visible: root.errorMessage !== "" && !root.isLoading
                    text: root.errorMessage
                    color: Kirigami.Theme.negativeTextColor
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Empty state
                PlasmaComponents.Label {
                    visible: !root.isLoading && root.errorMessage === ""
                        && (!root.balanceData || !root.balanceData.balance_infos)
                    text: i18n("Configure your API key in settings")
                    opacity: 0.6
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Kirigami.Units.gridUnit * 2
                }

                // Balance display
                ColumnLayout {
                    visible: !root.isLoading && root.errorMessage === ""
                        && root.balanceData && root.balanceData.balance_infos
                    spacing: Kirigami.Units.smallSpacing
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Kirigami.Units.gridUnit * 2

                    PlasmaComponents.Label {
                        text: fmtData.result.formatted
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: i18n("Available: ") + (fmtData.result.available ? i18n("Yes") : i18n("No"))
                        opacity: 0.7
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: i18n("Granted: %1", fmtData.result.grantedFormatted)
                        opacity: 0.7
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: i18n("Topped up: %1", fmtData.result.toppedUpFormatted)
                        opacity: 0.7
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Spacer to push footer down
                Item { Layout.fillHeight: true }

                // Footer
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.smallSpacing

                    PlasmaComponents.Label {
                        text: root.lastFetchTime
                            ? i18n("Updated %1", Fmt.timeAgo(root.lastFetchTime))
                            : ""
                        opacity: 0.5
                        font: Kirigami.Theme.smallFont
                    }

                    Item { Layout.fillWidth: true }

                    PlasmaComponents.Button {
                        text: i18n("Refresh")
                        enabled: !root.isLoading
                        onClicked: doRefresh()
                    }
                }
            }
        }
    }

    // --- Refresh timer ---
    Timer {
        id: refreshTimer
        interval: Math.max(60, Plasmoid.configuration.refreshInterval) * 1000
        running: true
        repeat: true
        onTriggered: doRefresh()
    }

    // --- Refresh trigger ---
    function doRefresh() {
        Store.triggerFetch(DeepseekApi);
    }

    // --- React to config changes ---
    Connections {
        target: Plasmoid.configuration
        function onApiKeyChanged() {
            Store.setApiKey(Plasmoid.configuration.apiKey);
            doRefresh();
        }
        function onRefreshIntervalChanged() {
            refreshTimer.interval = Math.max(60, Plasmoid.configuration.refreshInterval) * 1000;
        }
    }

    Component.onCompleted: {
        Store.init(root);
        Store.setApiKey(Plasmoid.configuration.apiKey);
        doRefresh();
    }
}
