import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_apiKey: apiKeyField.text
    property alias cfg_refreshInterval: refreshSpinBox.value

    TextField {
        id: apiKeyField
        Kirigami.FormData.label: i18n("API Key:")
        echoMode: TextInput.Password
    }

    SpinBox {
        id: refreshSpinBox
        Kirigami.FormData.label: i18n("Refresh interval (s):")
        from: 60
        to: 3600
        stepSize: 30
        value: 60
    }
}
