pragma Singleton

import QtQml 2.0

QtObject {
	id: style

	property font font: Qt.font({
									"pixelSize": 12
								})

	function getStyleByState(item) {
		if (item.enabled) {
			if (item.focus)
				return focus

			return normal
		}

		return disabled
	}

	property QtObject normal: QtObject {
		property color background: "#eaeaea"
		property color foreground: "black"
		property double opacity: 1

		property QtObject border: QtObject {
			property int width: 1
			property color color: "black"
		}
	}

	property QtObject focus: QtObject {
		property color background: "#D9D9D9"
		property color foreground: style.normal.foreground
		property double opacity: 1

		property QtObject border: QtObject {
			property int width: style.normal.border.width
			property color color: "black"
		}
	}

	property QtObject disabled: QtObject {
		property color background: style.normal.background
		property color foreground: "black"
		property double opacity: 0.6

		property QtObject border: QtObject {
			property int width: style.normal.border.width
			property color color: "black"
		}
	}
}
