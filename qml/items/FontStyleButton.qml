import QtQuick 2.12
import QtQml.Models 2.1
import QtQuick.Controls 2.12
import QtQml 2.0
import "../items"
import Memorus.Style 1.0

ToolButton {
	id: fontStyleButton
	property alias bg: rect
	property alias textColor: label.color

	opacity: Style.getStyleByState(fontStyleButton).opacity
	implicitWidth: 30
	implicitHeight: 30

	contentItem: Text {
		id: label
		text: fontStyleButton.text
		font: fontStyleButton.font
		color: Style.getStyleByState(fontStyleButton).foreground
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
	}

	background: Rectangle {
		id: rect
		anchors.fill: parent
		color: enabled
			   && (mouseArea.containsMouse
				   || checked) ? Style.focus.background : Style.getStyleByState(
									 fontStyleButton).background
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: {
			if (enabled) {
				if (checkable)
					checked ^= true

				fontStyleButton.clicked()
			}
		}
	}
}
