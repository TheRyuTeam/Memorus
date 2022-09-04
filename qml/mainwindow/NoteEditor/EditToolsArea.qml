import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQml 2.0
import "../../items"
import Memorus.Controls 1.0
import Memorus.Style 1.0

Rectangle {
	id: editToolsArea
	readonly property int buttonSize: 30
	property DocumentHandler document: null
	property var familyMap: new Map()
	onDocumentChanged: setStyle()
	enabled: document != null
	color: Style.normal.background

	signal saveClicked

	function setStyle() {
		if (document) {
			fontStyle.setStyle(document)
			fontColor.setStyle(document)
			fontSize.setStyle(document)
			textAlignment.setStyle(document)
			textList.setStyle(document)
			textTableArea.setStyle(document)
			tableCellPadding.setStyle(document)
			tableCellSpacing.setStyle(document)
			if (document.fontFamily !== fontFamily.currentText)
				fontFamily.currentIndex = familyMap[document.fontFamily]
		}
	}

	Flow {
		anchors.fill: parent
		spacing: 5
		clip: true

		RowLayout {
			spacing: 0
			Layout.alignment: Qt.AlignLeft

			FontStyleButton {
				contentItem: Image {
					source: "qrc:/resources/img/saved.png"
				}

				font.pixelSize: 15
				onClicked: editToolsArea.saveClicked()

				Layout.maximumWidth: editToolsArea.buttonSize
				Layout.maximumHeight: editToolsArea.buttonSize
			}
		}

		ColumnLayout {
			spacing: 0
			Layout.maximumWidth: editToolsArea.buttonSize * 6 + 30

			Layout.alignment: Qt.AlignLeft

			RowLayout {
				spacing: 0

				FontFamilyComboBox {
					id: fontFamily
					focusPolicy: Qt.NoFocus
					Layout.maximumWidth: editToolsArea.buttonSize * fontStyle.count
					Layout.maximumHeight: editToolsArea.buttonSize
					onCurrentIndexChanged: {
						if (editToolsArea.document)
							editToolsArea.document.fontFamily = textAt(
										currentIndex)
					}
				}

				//FontSize
				ComboBox {
					id: fontSize
					implicitWidth: 70
					implicitHeight: editToolsArea.buttonSize
					focusPolicy: Qt.NoFocus
					model: 60
					displayText: currentIndex + 12

					delegate: ItemDelegate {
						contentItem: Text {
							text: index + 12
							color: Style.normal.foreground
							font.family: modelData

							elide: Text.ElideRight
							verticalAlignment: Text.AlignVCenter
						}
						highlighted: fontSize.highlightedIndex === index
					}

					onCurrentIndexChanged: {
						if (document)
							document.fontSize = currentIndex + 12
					}

					function setSize(value) {
						if (value >= 0)
							currentIndex = value - 12
					}

					function size() {
						return currentIndex + 12
					}

					function setStyle(document) {
						currentIndex = document.fontSize - 12
					}
				}

				Repeater {
					id: fontSizeModifier
					model: [{
							"text": 'Aˆ',
							"value": 2
						}, {
							"text": 'Aˇ',
							"value": -2
						}]

					delegate: FontStyleButton {
						text: modelData.text
						font.pixelSize: 15
						onClicked: fontSize.setSize(fontSize.size(
														) + modelData.value)
						Layout.maximumWidth: editToolsArea.buttonSize
						Layout.maximumHeight: editToolsArea.buttonSize
					}
				}
			}

			RowLayout {
				spacing: 0

				// Font style
				Repeater {
					id: fontStyle
					model: [{
							"text": "B",
							"style": "bold"
						}, {
							"text": "C",
							"style": "italic"
						}, {
							"text": "U",
							"style": "underline"
						}, {
							"text": "S",
							"style": "strikeout"
						}]

					delegate: FontStyleButton {
						property string stylename: modelData.style
						text: modelData.text
						checkable: true
						font.pixelSize: 16

						onClicked: {
							if (editToolsArea.document)
								editToolsArea.document[modelData.style] = checked
						}
						Layout.maximumWidth: editToolsArea.buttonSize
						Layout.maximumHeight: editToolsArea.buttonSize

						Component.onCompleted: font[modelData.style] = true

						Layout.row: 1
						Layout.column: index
					}

					function setStyle(document) {
						for (var i = 0; i < count; ++i)
							itemAt(i).checked = document[itemAt(i).stylename]
					}
				}

				// Font color
				Repeater {
					id: fontColor
					model: ["foreground", "background"]

					delegate: ColorPickerButton {
						property string stylename: modelData
						implicitWidth: editToolsArea.buttonSize + 15
						implicitHeight: editToolsArea.buttonSize

						onColorChanged: {
							if (editToolsArea.document)
								editToolsArea.document[modelData] = color
						}
						button.font: Qt.font({
												 "pixelSize": 20,
												 "bold": true
											 })
					}

					function setStyle(document) {
						for (var i = 0; i < count; ++i)
							itemAt(i).currentColor = document[itemAt(
																  i).stylename]
					}
				}
			}
		} // Font Style Area

		Rectangle {
			width: 1
			height: parent.height * 0.8
			color: Style.normal.border.color
			Layout.alignment: Qt.AlignLeft
		}

		ColumnLayout {
			spacing: 0
			Layout.alignment: Qt.AlignLeft

			RowLayout {
				PopupButton {
					id: textList
					button.contentItem: Image {
						source: "qrc:/resources/img/list.png"
					}
					onClicked: editToolsArea.document.list = 1

					implicitWidth: editToolsArea.buttonSize + 15
					implicitHeight: editToolsArea.buttonSize

					popup.width: 100
					popup.height: list.count * editToolsArea.buttonSize

					popup.contentItem: ListView {
						id: list
						anchors.fill: parent

						model: ["●", "○", "■", "1", "a", "A", "ⅰ", "Ⅰ"]
						delegate: FontStyleButton {
							anchors.horizontalCenter: parent.horizontalCenter
							text: modelData

							width: parent.width

							onClicked: {
								editToolsArea.document.list = -index - 1
								textList.close()
							}
						}
					}

					function setStyle(document) {
						button.checked = document.list !== 0
					}
				}

				PopupButton {
					id: textTable
					button.contentItem: Image {
						source: "qrc:/resources/img/table.png"
					}

					implicitWidth: editToolsArea.buttonSize + 15
					implicitHeight: editToolsArea.buttonSize

					popup.width: grid.column * (grid.cellSize + grid.columnSpacing)
					popup.height: grid.count * editToolsArea.buttonSize

					popup.contentItem: GridLayout {
						id: grid
						anchors.fill: parent
						anchors.centerIn: parent
						columnSpacing: 0
						rowSpacing: 0
						property int cellSize: 15

						Repeater {
							id: colV
							model: 10

							Repeater {
								id: rowV
								property int topI: index
								model: 10

								delegate: Rectangle {
									property bool active: false
									width: 15
									height: width

									border.width: 1
									border.color: active
												  || ar.containsMouse ? "red" : Style.normal.border.color

									Layout.column: index
									Layout.row: rowV.topI

									MouseArea {
										id: ar
										anchors.fill: parent
										hoverEnabled: true
										onContainsMouseChanged: {
											for (var i = 0; i <= rowV.topI; ++i) {
												for (var j = 0; j <= index; ++j)
													colV.itemAt(i).itemAt(
																j).active = containsMouse
											}
										}
										onClicked: {
											editToolsArea.document.setTable(
														rowV.topI + 1,
														index + 1)
											textTable.close()
										}
									}
								}
							}
						}
					}
				}
			}

			RowLayout {
				spacing: 0
				ButtonGroup {
					id: textEditTextAlignment
					onClicked: button.checked
				}
				Repeater {
					id: textAlignment
					model: [{
							"imageSource": 'qrc:/resources/img/left-align.png',
							"checked": true,
							"alignment": Qt.AlignLeft
						}, {
							"imageSource": 'qrc:/resources/img/center-align.png',
							"checked": true,
							"alignment": Qt.AlignCenter
						}, {
							"imageSource": 'qrc:/resources/img/right-align.png',
							"checked": false,
							"alignment": Qt.AlignRight
						}, {
							"imageSource": 'qrc:/resources/img/justification.png',
							"checked": false,
							"alignment": Qt.AlignJustify
						}]

					delegate: FontStyleButton {
						property int alignment: modelData.alignment
						contentItem: Image {
							source: modelData.imageSource
						}
						checkable: true
						onClicked: {
							if (!checked)
								checked = true
						}

						onCheckedChanged: {
							if (checked)
								editToolsArea.document.alignment = modelData.alignment
						}
						Layout.maximumWidth: editToolsArea.buttonSize
						Layout.maximumHeight: editToolsArea.buttonSize
						ButtonGroup.group: textEditTextAlignment
					}

					function setStyle(document) {
						for (var i = 0; i < count; ++i)
							itemAt(i).checked = document.alignment === itemAt(
										i).alignment
					}
				}
			}
		}

		Rectangle {
			visible: textTableArea.visible
			width: 1
			height: parent.height * 0.8
			color: Style.normal.border.color
			Layout.alignment: Qt.AlignLeft
		}

		ColumnLayout {
			id: textTableArea
			visible: editToolsArea.document ? editToolsArea.document.table !== 0 : false
			spacing: 0
			Layout.preferredHeight: editToolsArea.buttonSize * 2

			function setStyle(document) {
				visible = document.table
			}

			RowLayout {
				TextField {
					id: tableCellPadding
					implicitWidth: 50
					implicitHeight: editToolsArea.buttonSize
					focus: Qt.NoFocus
					inputMethodHints: Qt.ImhDigitsOnly
					validator: IntValidator {
						bottom: 0
						top: 150
					}

					onTextChanged: {
						var size = this.size()
						if (editToolsArea.document && size !== -1)
							editToolsArea.document.tableCellPadding = size
					}

					function size() {
						var value = parseInt(text)
						return value ? value : -1
					}

					function setStyle(document) {
						text = document.tableCellPadding
					}
				}

				TextField {
					id: tableCellSpacing
					implicitWidth: 50
					implicitHeight: editToolsArea.buttonSize
					focus: Qt.NoFocus
					inputMethodHints: Qt.ImhDigitsOnly
					validator: IntValidator {
						bottom: 0
						top: 150
					}

					onTextChanged: {
						var size = this.size()
						if (editToolsArea.document && size !== -1)
							editToolsArea.document.tableCellSpacing = size
					}

					function size() {
						var value = parseInt(text)
						return value ? value : -1
					}

					function setStyle(document) {
						text = document.tableCellSpacing
					}
				}
			}

			RowLayout {
				PopupButton {
					button.text: "Border"
					implicitWidth: button.text.length * button.font.pixelSize + 15
					implicitHeight: editToolsArea.buttonSize
					popup.width: width
					popup.height: tableBorderStyle.count * editToolsArea.buttonSize

					popup.contentItem: ListView {
						id: tableBorderStyle
						anchors.fill: parent
						clip: true
						model: ["None", "Dotted", "Dashed", "Solid", "Double", "Dot dash", "Dot dot dash", "Groove", "Ridge", "Inset", "Outset"]
						delegate: FontStyleButton {
							text: modelData
							width: parent.width
							height: editToolsArea.buttonSize
							onClicked: editToolsArea.document.setTableBorderStyle(
										   index)
						}
					}
				}

				FontStyleButton {
					text: "Collapse"
					implicitWidth: text.length * font.pixelSize
					implicitHeight: editToolsArea.buttonSize
				}

				ColorPickerButton {
					id: tableBorderColor
					implicitWidth: editToolsArea.buttonSize + 15
					implicitHeight: editToolsArea.buttonSize
					button.font.pixelSize: 20
					button.font.bold: true
					onColorChanged: editToolsArea.document.tableBorderColor = color
				}

				ColorPickerButton {
					id: tableBackground
					implicitWidth: editToolsArea.buttonSize + 15
					implicitHeight: editToolsArea.buttonSize
					button.font.pixelSize: 20
					button.font.bold: true
					onColorChanged: editToolsArea.document.tableBackground = color
				}
			}
		}
		Item {}
	}

	Component.onCompleted: {
		var families = Qt.fontFamilies()
		for (var i = 0; i < families.length; ++i) {
			familyMap[families[i]] = i - 1
		}
	}
}
