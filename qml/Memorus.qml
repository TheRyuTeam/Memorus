import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQml 2.0
import Qt.labs.settings 1.0
import "./additionalWindows"
import "./mainwindow"
import "./mainwindow/NoteEditor"
import "./mainwindow/NotesNavigation"

import Memorus.Controls 1.0

ApplicationWindow {
	id: memorus
	visible: true
	minimumHeight: 500
	minimumWidth: notesNavigation.minimumWidth + (noteEditor.visible ? noteEditor.minimumWidth : 0)
	title: "Memorus"
	color: "#2E4B1B"

	JsonFileNoteController {
		id: noteController
		file: "notes.json"
		onNoteAdded: note => {
						 notesNavigation.add(note)
						 save()
					 }
		onNoteRemoved: note => {
						   notesNavigation.remove(note)
						   save()
					   }
	}

	property SettingsWindow settingsWindow: Window {
		id: settingsWindow
		width: 500
		height: 500

		GridLayout {
			anchors.fill: parent

			Text {
				text: "Keep editor open:"
				Layout.row: 0
				Layout.column: 0
			}

			CheckBox {
				id: keepNoteEditorVisibleCheckbox
				checked: settings.keepNoteEditorVisible
			}

			Text {
				text: "Font size"
				Layout.row: 1
				font.pixelSize: settings.fontSize
			}

			TextField {
				id: memorusFontSize
				text: settings.fontSize.toString()

				validator: IntValidator {
					bottom: 0
					top: 1000
				}

				inputMethodHints: Qt.ImhDigitsOnly
			}

			Button {
				text: "Save"
				onClicked: {
					settings.keepNoteEditorVisible = keepNoteEditorVisibleCheckbox.checked
					settings.fontSize = memorusFontSize.text - 1 + 1
				}
				Layout.row: 2
				Layout.column: 2
			}
		}
	}

	Settings {
		id: settings
		property bool keepNoteEditorVisible: value("keepNoteEditorVisible",
												   false)
		property int fontSize: value("noteEditorDefaultFontSize", 12)

		category: ""
		fileName: "settings.ini"
	}

	RowLayout {
		id: mainLayout
		anchors.fill: parent
		width: parent.width
		spacing: 0

		LeftBar {
			id: leftBar
			btnSize: 50
			Layout.fillHeight: true
			width: 50
			color: "#2E4B1B"
			onAddNoteButtonClicked: noteEditor.add(null)
			onCalendarButtonClicked: console.log("calendar")
			onSettingsButtonClicked: settingsWindow.show()
		}

		SplitView {
			id: split
			Layout.fillWidth: true
			Layout.fillHeight: true

			NotesNavigation {
				id: notesNavigation
				readonly property int minimumWidth: 200
				color: memorus.color
				onListItemClicked: noteEditor.add(note)
				Layout.fillHeight: true
				Layout.fillWidth: !noteEditor.visible
				Layout.minimumWidth: minimumWidth
				Layout.onFillWidthChanged: {
					if (!Layout.fillWidth)
						width = 200
				}
				Component.onCompleted: {
					noteController.emitAll()
				}
			}

			NoteEditor {
				id: noteEditor
				noteController: noteController
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.minimumWidth: requiredWidth
				visible: settings.keepNoteEditorVisible || tabsCount !== 0
			}
		}
	}
}
