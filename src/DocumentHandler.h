#pragma once
#include <QFont>
#include <QObject>
#include <QTextCursor>
#include <QUrl>

class QTextDocument;
class QQuickTextDocument;

class DocumentHandler : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QQuickTextDocument *document READ document WRITE setDocument NOTIFY documentChanged)
	Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
	Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
	Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)

	Q_PROPERTY(QColor foreground READ foreground WRITE setForeground NOTIFY foregroundChanged)
	Q_PROPERTY(QColor background READ background WRITE setBackground NOTIFY backgroundChanged)
	Q_PROPERTY(QString fontFamily READ fontFamily WRITE setFontFamily NOTIFY fontFamilyChanged)
	Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment NOTIFY alignmentChanged)

	Q_PROPERTY(bool bold READ bold WRITE setBold NOTIFY boldChanged)
	Q_PROPERTY(bool italic READ italic WRITE setItalic NOTIFY italicChanged)
	Q_PROPERTY(bool underline READ underline WRITE setUnderline NOTIFY underlineChanged)
	Q_PROPERTY(bool strikeout READ strikeout WRITE setStrikeout NOTIFY strikeoutChanged)

	Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)

	Q_PROPERTY(int list READ list WRITE setList NOTIFY listChanged)

	Q_PROPERTY(int table READ table NOTIFY tableChanged)

	Q_PROPERTY(bool tableCollapse READ tableCollapse WRITE setTableCollapse NOTIFY tableCollapseChanged)
	Q_PROPERTY(QColor tableBorderColor READ tableBorderColor WRITE setTableBorderColor NOTIFY tableBorderColorChanged)
	Q_PROPERTY(QColor tableBackground READ tableBackground WRITE setTableBackground NOTIFY tableBackgroundChanged)
	Q_PROPERTY(int tableCellPadding READ tableCellPadding WRITE setTableCellPadding NOTIFY tableCellPaddingChanged)
	Q_PROPERTY(int tableCellSpacing READ tableCellSpacing WRITE setTableCellSpacing NOTIFY tableCellSpacingChanged)


	Q_PROPERTY(QString fileName READ fileName NOTIFY fileUrlChanged)
	Q_PROPERTY(QString fileType READ fileType NOTIFY fileUrlChanged)
	Q_PROPERTY(QUrl fileUrl READ fileUrl NOTIFY fileUrlChanged)

public:
	explicit DocumentHandler(QObject *parent = nullptr);

	QQuickTextDocument *document() const;
	void setDocument(QQuickTextDocument *document);

	inline int cursorPosition() const;
	void setCursorPosition(int position);

	inline int selectionStart() const;
	void setSelectionStart(int position);

	inline int selectionEnd() const;
	void setSelectionEnd(int position);

	QString fontFamily() const;
	void setFontFamily(const QString &family);

	QColor foreground() const;
	void setForeground(const QColor &color);

	QColor background() const;
	void setBackground(const QColor &color);

	Qt::Alignment alignment() const;
	void setAlignment(Qt::Alignment alignment);

	bool bold() const;
	void setBold(bool bold);

	bool italic() const;
	void setItalic(bool italic);

	bool underline() const;
	void setUnderline(bool underline);

	bool strikeout() const;
	void setStrikeout(bool strikeout);

	int fontSize() const;
	void setFontSize(int size);

	int list() const;
	void setList(int style);

	int table() const;

	bool tableCollapse() const;
	void setTableCollapse(bool collapse);

	QColor tableBorderColor() const;
	void setTableBorderColor(const QColor& color);

	QColor tableBackground() const;
	void setTableBackground(const QColor& color);

	Q_INVOKABLE void setTable(int rows, int cols, int borderStyle = QTextFrameFormat::BorderStyle::BorderStyle_Solid);
	Q_INVOKABLE void setTableBorderStyle(int borderStyle);

	int tableCellPadding() const;
	void setTableCellPadding(int tableCellPadding);

	int tableCellSpacing() const;
	void setTableCellSpacing(int tableCellSpacing);

	QString fileName() const;
	QString fileType() const;
	QUrl fileUrl() const;

public Q_SLOTS:
	void load(const QUrl &fileUrl);
	void saveAs(const QUrl &fileUrl);
	void contentsChanged(int from, int removed, int added);

Q_SIGNALS:
	void documentChanged();
	void cursorPositionChanged();
	void selectionStartChanged();
	void selectionEndChanged();

	void fontFamilyChanged();
	void foregroundChanged();
	void backgroundChanged();
	void alignmentChanged();

	void boldChanged();
	void italicChanged();
	void underlineChanged();
	void strikeoutChanged();

	void fontSizeChanged();

	void listChanged();

	void tableChanged();
	void tableCollapseChanged();
	void tableBorderColorChanged();
	void tableBackgroundChanged();
	void tableCellPaddingChanged();
	void tableCellSpacingChanged();

	void textChanged();
	void fileUrlChanged();

	void loaded(const QString &text);
	void error(const QString &message);

protected:
	QTextTable* getTable() const;

private:
	void reset();
	QTextCursor textCursor() const;
	QTextDocument *textDocument() const;
	void mergeFormatOnWordOrSelection(const QTextCharFormat &format);
	void mergeTableFormat(const QTextTableFormat& format);
	void mergeTableCellFormat(const QTextTableCellFormat& format);

	QQuickTextDocument *m_document;

	int m_cursorPosition;
	int m_selectionStart;
	int m_selectionEnd;

	QUrl m_fileUrl;

	bool m_need;
	int m_last;
	QTextCharFormat m_nfor;
};


inline int DocumentHandler::cursorPosition() const
{
	return m_cursorPosition;
}

inline int DocumentHandler::selectionStart() const
{
	return m_selectionStart;
}

inline int DocumentHandler::selectionEnd() const
{
	return m_selectionEnd;
}

