import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQml 2.0
import "../items"
import Memorus.Style 1.0

Window {
	id: saveAsWindow
	property alias name: noteName.text
	property alias file: noteFile.text
	property alias path: notePath.text

	minimumWidth: 300
	maximumWidth: minimumWidth
	minimumHeight: 280
	maximumHeight: minimumHeight

	title: "Save as"

	signal save(string file, string name, string path)

	function setInvalid(name, reason) {
		if (layout.fields.hasOwnProperty(name)) {
			var field = layout.fields[name]
			field.valid = false
			field.toolTipText = reason
		}
	}

	Rectangle {
		anchors.fill: parent
		color: Style.normal.background

		GridLayout {
			id: layout
			property var fields: {
				"name": noteName,
				"file": noteFile,
				"path": notePath
			}
			anchors.margins: 20
			anchors.fill: parent

			Text {
				text: "Repeating:"
				visible: false
				Layout.row: 0
				Layout.column: 0
			}

			ComboBox {
				model: ['none', 'interval', 'datetime']
				visible: false
				background: Rectangle {
					width: 200
					color: "white"
					border.width: 1
					border.color: Style.normal.border.color
				}
				implicitWidth: 200
				implicitHeight: 30
				Layout.columnSpan: 2
				onCurrentTextChanged: {
					if (currentText == 'interval') {
						intervalSettingsLabel.visible = true
						intervalSettings.visible = true
						intervalRepeatTimeLabel.visible = true
						intervalRepeatTime.visible = true
					}
				}
			}

			Text {
				id: intervalSettingsLabel
				visible: false
				text: "Interval:"
				Layout.row: 1
				Layout.column: 0
			}

			ComboBox {
				id: intervalSettings
				model: ['day', 'week', 'month', 'year']
				visible: false
				background: Rectangle {
					width: 200
					color: "white"
					border.width: 1
					border.color: Style.normal.border.color
				}
				implicitWidth: 200
				implicitHeight: 30
				Layout.columnSpan: 2
			}

			Text {
				id: intervalRepeatTimeLabel
				visible: false
				text: "At: "
				Layout.row: 2
				Layout.column: 0
			}

			TextField {
				id: intervalRepeatTime
				visible: false
				implicitWidth: 200
				implicitHeight: 30
				text: "00:00:00"
				inputMask: "99:99:99"
				inputMethodHints: Qt.ImhDigitsOnly
				validator: RegExpValidator {
					regExp: /^([0-1\s]?[0-9\s]|2[0-3\s]):([0-5\s][0-9\s]):([0-5\s][0-9\s])$ /
				}
				Layout.columnSpan: 2
			}

			Text {
				text: "Name:"
				Layout.row: 3
				Layout.column: 0
			}

			TextField {
				id: noteName
				property bool valid: true
				property string toolTipText: ""
				implicitWidth: 200
				implicitHeight: 30
				Layout.columnSpan: 2
				background: Rectangle {
					border.color: parent.valid ? Style.normal.border.color : "red"
					border.width: 1
				}
				onTextChanged: valid = true
				ToolTip.visible: !valid
				ToolTip.text: toolTipText
			}

			Text {
				text: "File:"
				Layout.row: 4
				Layout.column: 0
			}

			TextField {
				id: noteFile
				property bool valid: true
				property string toolTipText: ""
				implicitWidth: 200
				implicitHeight: 30
				Layout.columnSpan: 2
				background: Rectangle {
					border.color: parent.valid ? Style.normal.border.color : "red"
					border.width: 1
				}
				onTextChanged: valid = true
				ToolTip.visible: !valid
				ToolTip.text: toolTipText
			}

			Text {
				text: "Path:"
				Layout.row: 5
				Layout.column: 0
			}

			TextField {
				id: notePath
				property bool valid: true
				property string toolTipText: ""
				implicitWidth: 200
				implicitHeight: 30
				Layout.columnSpan: 2
				background: Rectangle {
					border.color: parent.valid ? Style.normal.border.color : "red"
					border.width: 1
				}
				onTextChanged: valid = true
				ToolTip.visible: !valid
				ToolTip.text: toolTipText
			}

			FontStyleButton {
				id: saveButton
				text: "Save"
				implicitWidth: 100
				implicitHeight: 30
				onClicked: save()
				Layout.row: 6
				Layout.column: 2

				function save() {
					var nErr = validCheck(noteFile)
					nErr += validCheck(noteName)
					nErr += validCheck(notePath)

					if (nErr === 0)
						saveAsWindow.save(noteFile.text, noteName.text,
										  notePath.text)
				}

				function validCheck(field) {
					if (field.text.length === 0) {
						field.valid = false
						field.toolTipText = 'Field is empty'
						return 1
					}
					var format = /[/\\]/
					if (format.test(field.text)) {
						field.valid = false
						field.toolTipText = 'Field contains invalid symbols'
					}

					return 0
				}
			}
		}
	}
}
