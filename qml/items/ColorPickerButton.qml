import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQml 2.0
import QtQuick.Dialogs 1.3
import "qrc:/qml/items"
import Memorus.Style 1.0

PopupButton {
	id: colorPickerButton
	property color currentColor: "black"
	signal colorChanged(color color)
	button.textColor: currentColor

	popup.contentItem: Rectangle {
		id: dropdown
		color: Style.normal.background
		property var defaultColors: ["white", "gray", "black", "red", "green", "yellow", "brown", "blue"]
		property int nColumns: 3
		property int nRows: dropdown.nColumns ? dropdown.defaultColors.length / dropdown.nColumns
												+ (dropdown.defaultColors.length
												   % dropdown.nColumns != 0) : 0
		GridLayout {
			rowSpacing: 0

			Repeater {
				id: columnRepeater
				model: dropdown.nColumns

				delegate: Rectangle {
					id: colorColumn
					property int colorWidth: 25
					property int colorHeight: 20
					property int colorsCount: Math.min(
												  dropdown.defaultColors.length
												  - index * dropdown.nColumns,
												  dropdown.nColumns)
					width: colorWidth + border.width * 2
					height: colorsCount * colorHeight + border.width * 2
					border.width: 1

					border.color: "black"
					Layout.column: index
					Layout.rowSpan: colorsCount

					ColumnLayout {
						anchors.fill: parent
						anchors.margins: colorColumn.border.width

						anchors.verticalCenter: parent.verticalCenter
						spacing: 0
						Repeater {
							id: rowRepeater
							property int topIndex: index
							model: Math.min(dropdown.defaultColors.length
											- topIndex * dropdown.nColumns,
											dropdown.nColumns)

							delegate: FontStyleButton {
								id: colorButton
								bg.color: dropdown.defaultColors[index + rowRepeater.topIndex
																 * dropdown.nColumns]
								implicitWidth: colorColumn.colorWidth
								implicitHeight: colorColumn.colorHeight
								onClicked: {
									console.log(bg.color)
									colorPickerButton.setColor(bg.color)
									colorPickerButton.close()
								}
								Layout.alignment: Qt.AlignCenter
								Layout.row: index
								Layout.column: rowRepeater.topIndex
							}
						}
					}
				}
			}

			FontStyleButton {
				text: "Custom color"
				onClicked: colorPicker.open()

				Layout.row: dropdown.nRows
				Layout.columnSpan: dropdown.nColumns
				Layout.fillWidth: true
			}
		}
	}

	ColorDialog {
		id: colorPicker
		modality: Qt.ApplicationModal
		currentColor: colorPickerButton.currentColor
		showAlphaChannel: true
		onAccepted: {
			colorPickerButton.setColor(currentColor)
			colorPickerButton.close()
		}
	}

	function setColor(color) {
		currentColor = color
		colorChanged(currentColor)
	}
}
