import QtQuick 2.0

Image {
	scale: Qt.KeepAspectRatio

	signal clicked

	MouseArea {
		cursorShape: Qt.PointingHandCursor
		anchors.fill: parent
		onClicked: parent.clicked()
	}
}
