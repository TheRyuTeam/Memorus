import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQml 2.0
import "../../additionalWindows"
import "../../items"
import Memorus.Controls 1.0

TextArea {
	id: textEdit
	property alias document: textDocument
	property Note note
	property bool saved: true
	textFormat: TextArea.RichText
	persistentSelection: true
	selectByMouse: true
	mouseSelectionMode: TextEdit.SelectCharacters
	wrapMode: TextEdit.Wrap

	signal noteAdded(Note note)
	signal createNote(string file, string name, string path)

	function save() {
		if (!textEdit.note) {
			saveAsWindow.show()
		} else {
			var errCode = note.setTextWithErrorHandle(textEdit.text)
			if (errCode !== 0) {
				saveAsWindow.setInvalid('file', 'Can not write in this file')
				return
			}

			saveAsWindow.close()
			parent.title = note.name
			saved = true
			noteAdded(note)
		}
	}

	function reset() {
		textEdit.text = note ? note.text : ""
	}

	DocumentHandler {
		id: textDocument
		document: textEdit.textDocument
		cursorPosition: textEdit.cursorPosition
		selectionStart: textEdit.selectionStart
		selectionEnd: textEdit.selectionEnd
	}

	SaveAsWindow {
		id: saveAsWindow
		file: note ? note.file : ""
		name: note ? note.name : ""
		path: note ? note.path : ""
		modality: Qt.ApplicationModal

		onSave: {
			textEdit.createNote(file, name, path)
			textEdit.save()
		}
	}
}
