import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Window {
	id: settingsWindow
	width: 500
	height: 500

	GridLayout {
		anchors.fill: parent

		CheckBox {
			id: keepNoteEditorVisibleCheckbox
			checked: settings.value("keepNoteEditorVisibleCheckbox", false)
			onCheckedChanged: settings.setValue(
								  "keepNoteEditorVisibleCheckbox", checked)
		}

		Button {
			id: saveButton
			onClicked: settings.sync()
		}
	}
}
