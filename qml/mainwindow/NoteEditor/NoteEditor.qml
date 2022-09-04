import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import QtQuick.Controls 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12
import QtQml 2.0
import QtQuick.Controls.Private 1.0
import "../../items"
import "../../additionalWindows"
import "../"
import Memorus.Controls 1.0
import Memorus.Style 1.0

ColumnLayout {
	id: noteEditor
	property int requiredWidth: 600
	property string defaultFontFamily: "Arial"

	property string newNoteTitle: "New note"
	readonly property alias tabsCount: notesTabView.count
	property NoteController noteController

	readonly property Component tabComponent: Component {
		id: comp
		ScrollView {
			id: flick
			property alias doc: noteEdit.document
			property alias textArea: noteEdit
			property alias note: noteEdit.note
			anchors.fill: parent
			clip: true

			NoteEdit {
				id: noteEdit
				onNoteAdded: noteController.add(note)
				persistentSelection: true
				onCreateNote: {
					note = noteComponent.createObject(
								noteEditor.noteController, {
									"file": file,
									"name": name,
									"path": path
								})
					noteController.add(note)
				}

				onCursorPositionChanged: {
					document.cursorPosition = cursorPosition
					editToolsArea.setStyle()
				}
			}

			function save() {
				noteEdit.save()
			}

			function reset() {
				noteEdit.reset()
			}
		}
	}
	property font defaultFont: Qt.font({
										   "pixelSize": 12,
										   "family": "Arial"
									   })

	Component {
		id: noteComponent
		Note {}
	}

	spacing: 0

	EditToolsArea {
		id: editToolsArea
		height: buttonSize * 2
		Layout.fillWidth: true
		onSaveClicked: {
			var tab = notesTabView.getTab(notesTabView.currentIndex)
			if (tab) {
				var _noteEdit = tab.item
				if (_noteEdit)
					_noteEdit.save()
			}
		}
	}

	// notesTabView
	TabView {
		id: notesTabView
		currentIndex: -1
		onCurrentIndexChanged: loadDocument()

		function loadDocument() {
			var tab = getTab(currentIndex)
			editToolsArea.document = tab ? tab.item.doc : null
		}

		Layout.fillWidth: true
		Layout.fillHeight: true

		style: TabViewStyle {
			frameOverlap: 1
			tab: Rectangle {
				id: rect
				color: styleData.selected ? "red" : Qt.darker(
												Style.normal.background)
				implicitWidth: 120
				implicitHeight: 25
				radius: 5

				Text {
					id: tabTitle
					anchors.margins: 5
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					width: parent.width - closeTabButton.width - 10
					height: parent.height
					clip: true
					elide: Text.ElideRight

					color: "white"
					text: styleData.title
				}
				ImageButton {
					id: closeTabButton
					anchors.margins: 5
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					source: "qrc:/resources/img/close.png"
					width: 10
					height: 10
					onClicked: notesTabView.closeTab(styleData.index)
				}
			}

			frame: Rectangle {
				color: "#FFFFFF"
			}
		}

		function closeTab(index) {
			removeTab(index)
			if (count == 0)
				currentIndex = -1
			loadDocument()
		}

		function searchByTitle(title) {
			for (var i = 0; i < count; ++i) {
				if (getTab(i).title === title) {
					currentIndex = i
					return i
				}
			}

			return -1
		}
	} // notesTabView

	function add(note) {
		var name = note ? note.name : newNoteTitle

		var existingIndex = notesTabView.searchByTitle(name)
		if (existingIndex !== -1) {
			notesTabView.currentIndex = existingIndex
			return
		}

		notesTabView.addTab(name, tabComponent)
		var i = notesTabView.searchByTitle(name)
		var tab = notesTabView.getTab(i).item
		tab.note = note
		tab.reset()
		notesTabView.currentIndex = i
	} // function add(name, component)
} // noteEditor
