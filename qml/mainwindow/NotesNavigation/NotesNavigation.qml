import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQml 2.0
import QtQuick.Dialogs 1.3
import "../../items"
import Memorus.Controls 1.0

//NotesNavigationArea
Rectangle {
	id: notesNavigation
	property var notes: []
	signal listItemClicked(Note note)

	ColumnLayout {
		anchors.fill: parent

		RowLayout {
			Layout.fillWidth: true

			ColumnLayout {
				Layout.fillWidth: true

				//Search
				TextInput {
					id: searchText
					onTextChanged: notesList.search(text)
					color: "white"
					font.pixelSize: 14
					selectByMouse: true
					mouseSelectionMode: TextInput.SelectCharacters

					Layout.fillWidth: true
					Layout.maximumHeight: 30

					verticalAlignment: Qt.AlignBottom
				}
				//Underline
				Rectangle {
					Layout.fillWidth: true
					Layout.maximumHeight: 5
					height: 1
					color: "white"
				}
			}

			ImageButton {
				id: searchSettingsButton
				Layout.maximumWidth: 30
				Layout.maximumHeight: 30
				source: "qrc:/resources/img/settings.png"

				onClicked: searchSettingsPopup.open()
			}

			Popup {
				id: searchSettingsPopup
				parent: searchSettingsButton
				topMargin: searchSettingsButton.height

				contentItem: Rectangle {
					ColumnLayout {
						Row {
							spacing: 5
							Text {
								text: "Case sensetive:"
							}
							CheckBox {
								onCheckedChanged: notesList.caseSensetive = checked
							}
						}
						Row {
							spacing: 5
							Text {
								text: "Regexp search:"
							}
							CheckBox {
								onCheckedChanged: notesList.regexpSearch = checked
							}
						}
					}
				}
			}
		}

		//NotesListArea
		Rectangle {
			Layout.fillWidth: true
			Layout.fillHeight: true
			color: "#528430"

			//NotesList
			ListView {
				id: notesList
				property Component comp: ListElement {
					property Note note
					property bool visible: true
				}
				property var searchMatch: regexpSearch ? _regexpSearch : _search
				property bool regexpSearch: false
				property bool caseSensetive: false

				onRegexpSearchChanged: search(searchText.text)
				onCaseSensetiveChanged: search(searchText.text)

				property var model_items: []
				onModel_itemsChanged: createModel()

				anchors.fill: parent
				ScrollBar.vertical: ScrollBar {
					active: true
				}

				model: ListModel {}

				delegate: Rectangle {
					id: area
					height: 20
					width: notesList.width
					color: "#528430"

					Text {
						anchors.fill: parent
						text: note.name
						color: "#FFFFFF"

						MouseArea {
							id: mouseArea
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							onClicked: listItemClicked(note)
							hoverEnabled: true
							onEntered: area.color = "#1A2B0E"
							onExited: area.color = "#528430"
						}
					}
				}

				Component.onCompleted: createModel()

				function createModel() {
					model.clear()
					for (var i = 0; i < model_items.length; ++i) {
						if (model_items[i].visible === true)
							model.append(model_items[i])
					}
				}

				function _search(str, text) {
					return caseSensetive ? str.startsWith(
											   text) : str.toLowerCase(
											   ).startsWith(text.toLowerCase())
				}

				function _regexpSearch(str, text) {
					try {
						return str.match(
									new RegExp(text,
											   caseSensetive ? '' : 'i')) !== null
					} catch (e) {
						return false
					}
				}

				function search(text) {
					for (var i = 0; i < model_items.length; ++i)
						model_items[i].visible = searchMatch(
									model_items[i].note.name, text)

					createModel()
				}
			}
		}
	}

	function add(note) {
		notesList.model_items.push(notesList.comp.createObject(notesList, {
																   "note": note,
																   "visible": notesList.searchMatch(
																				  note.name,
																				  searchText.text)
															   }))
		notesList.createModel()
	}

	function remove(note) {
		var i = notesList.model_items.indexOf(note)
		if (i > -1)
			notesList.model_items.splice(i, 0)
		notesList.createModel()
	}
}
