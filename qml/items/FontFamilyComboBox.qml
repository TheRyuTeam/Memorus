import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../items"
import Memorus.Style 1.0

ComboBox {
	id: fontFamilySelector
	font: Style.font

	model: Qt.fontFamilies()
	leftPadding: 5

	delegate: ItemDelegate {
		width: fontFamilySelector.width
		contentItem: Text {
			text: modelData
			color: Style.normal.foreground
			font.family: modelData

			elide: Text.ElideRight
			verticalAlignment: Text.AlignVCenter
		}
		highlighted: fontFamilySelector.highlightedIndex === index
	}

	indicator: Rectangle {
		width: 20
		height: fontFamilySelector.height
		color: Style.getStyleByState(fontFamilySelector).background
		border.width: 1
		border.color: enabled ? (focus ? Style.focus.border.color : Style.normal.border.color) : Style.disabled.border.color
		anchors.right: fontFamilySelector.right

		Text {
			id: indicator
			text: "▼"
			color: Style.getStyleByState(indicator).foreground
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	contentItem: Text {
		clip: true
		anchors.leftMargin: 10
		anchors.rightMargin: fontFamilySelector.indicator.width + fontFamilySelector.spacing
		width: fontFamilySelector.width - fontFamilySelector.indicator.width
			   - fontFamilySelector.spacing
		text: fontFamilySelector.displayText
		font: fontFamilySelector.font
		color: indicator.color
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
	}

	background: Rectangle {
		implicitWidth: 120
		implicitHeight: 40
		color: enabled ? "white" : Style.disabled.background
		border.color: Style.getStyleByState(this).border.color
		border.width: Style.getStyleByState(this).border.width
		radius: 2
	}

	popup: Popup {
		y: fontFamilySelector.height - 1
		width: fontFamilySelector.width
		implicitHeight: contentItem.implicitHeight
		padding: 1

		contentItem: ListView {
			clip: true
			implicitHeight: contentHeight
			model: fontFamilySelector.popup.visible ? fontFamilySelector.delegateModel : null
			currentIndex: fontFamilySelector.highlightedIndex

			ScrollIndicator.vertical: ScrollIndicator {}
		}

		background: Rectangle {
			border.color: Style.normal.border.color
			border.width: Style.normal.border.width
			radius: 2
		}
	}
}
