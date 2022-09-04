import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../items"

Rectangle {
	id: leftBar

	property int btnSize

	signal addNoteButtonClicked
	signal calendarButtonClicked
	signal settingsButtonClicked

	ColumnLayout {
		anchors.fill: parent

		ImageButton {
			id: addNoteButton
			source: "qrc:/resources/img/plus"
			Layout.maximumWidth: leftBar.btnSize
			Layout.maximumHeight: leftBar.btnSize
			onClicked: leftBar.addNoteButtonClicked()
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		ImageButton {
			id: calendarButton
			source: "qrc:/resources/img/calendar"
			Layout.maximumWidth: leftBar.btnSize
			Layout.maximumHeight: leftBar.btnSize
			onClicked: leftBar.calendarButtonClicked()
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		ImageButton {
			id: settingsButton
			source: "qrc:/resources/img/settings"
			Layout.maximumWidth: leftBar.btnSize
			Layout.maximumHeight: leftBar.btnSize
			onClicked: leftBar.settingsButtonClicked()
		}
	}
}
