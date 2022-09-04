import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQml 2.0
import QtQuick.Dialogs 1.3
import "../items"
import Memorus.Style 1.0

RowLayout {
	id: popupButton
	property alias button: button
	property alias popup: popup

	signal clicked
	spacing: 0

	FontStyleButton {
		id: button
		implicitWidth: popupButton.width - 15
		text: "A"
		onClicked: popupButton.clicked()
		Layout.fillHeight: true
	}

	FontStyleButton {
		id: popupTrigger
		text: "˅"
		implicitWidth: 15
		checkable: true
		checked: popup ? popup.opened : false
		onClicked: {
			if (popup) {
				if (popup.opened === true)
					popup.close()
				else
					popup.open()
			}
		}
		Layout.fillHeight: true
	}
	Popup {
		id: popup
		parent: popupButton
		y: popupButton.y + popupButton.height
		onClosed: popupTrigger.checked = false

		background: Rectangle {
			color: Style.normal.background
			border.width: Style.normal.border.width
			border.color: Style.normal.border.color
		}
	}

	function close() {
		popup.close()
		popupTrigger.checked = false
	}
}
