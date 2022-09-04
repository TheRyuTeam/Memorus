#include "DocumentHandler.h"

#include <QFile>
#include <QFileInfo>
#include <QFileSelector>
#include <QQmlFile>
#include <QQmlFileSelector>
#include <QQuickTextDocument>
#include <QTextCharFormat>
#include <QTextCodec>
#include <QTextDocument>
#include <QDebug>
#include <QTextList>
#include <QTextTable>
#include <QTextTableFormat>



DocumentHandler::DocumentHandler(QObject *parent)
	: QObject(parent)
	, m_document(nullptr)
	, m_cursorPosition(-1)
	, m_selectionStart(0)
	, m_selectionEnd(0)
	, m_fileUrl()
	, m_need(false)
	, m_last(0)
	, m_nfor()
{
}

QQuickTextDocument *DocumentHandler::document() const
{
	return m_document;
}

void DocumentHandler::setDocument(QQuickTextDocument *document)
{
	if (document == m_document)
		return;

	if (m_document && m_document->textDocument())
		disconnect(m_document->textDocument(), &QTextDocument::contentsChange, this, &DocumentHandler::contentsChanged);

	m_document = document;

	if (m_document && m_document->textDocument())
		connect(m_document->textDocument(), &QTextDocument::contentsChange, this, &DocumentHandler::contentsChanged);

	emit documentChanged();
}

void DocumentHandler::setCursorPosition(int position)
{
	if (position == m_cursorPosition)
		return;

	m_cursorPosition = position;
	reset();
	emit cursorPositionChanged();
}

void DocumentHandler::setSelectionStart(int position)
{
	if (position == m_selectionStart)
		return;

	m_selectionStart = position;
	emit selectionStartChanged();
}

void DocumentHandler::setSelectionEnd(int position)
{
	if (position == m_selectionEnd)
		return;

	m_selectionEnd = position;
	emit selectionEndChanged();
}

QString DocumentHandler::fontFamily() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return QString();
	QTextCharFormat format = cursor.charFormat();
	return format.font().family();
}

void DocumentHandler::setFontFamily(const QString &family)
{
	QTextCharFormat format;
	format.setFontFamily(family);
	mergeFormatOnWordOrSelection(format);
	emit fontFamilyChanged();
}

QColor DocumentHandler::foreground() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return QColor(Qt::black);
	QTextCharFormat format = cursor.charFormat();
	return format.foreground().color();
}

void DocumentHandler::setForeground(const QColor &color)
{
	QTextCharFormat format;
	format.setForeground(QBrush(color));
	mergeFormatOnWordOrSelection(format);
	emit foregroundChanged();
}

QColor DocumentHandler::background() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return QColor(Qt::white);
	QTextCharFormat format = cursor.charFormat();
	return format.background().color();
}

void DocumentHandler::setBackground(const QColor& color)
{
	QTextCharFormat format;
	format.setBackground(QBrush(color));
	mergeFormatOnWordOrSelection(format);
	emit backgroundChanged();
}

Qt::Alignment DocumentHandler::alignment() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return Qt::AlignLeft;
	return textCursor().blockFormat().alignment();
}

void DocumentHandler::setAlignment(Qt::Alignment alignment)
{
	QTextBlockFormat format;
	format.setAlignment(alignment);
	QTextCursor cursor = textCursor();
	cursor.mergeBlockFormat(format);
	emit alignmentChanged();
}

bool DocumentHandler::bold() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return false;
	return textCursor().charFormat().fontWeight() == QFont::Bold;
}

void DocumentHandler::setBold(bool bold)
{
	QTextCharFormat format;
	format.setFontWeight(bold ? QFont::Bold : QFont::Normal);
	mergeFormatOnWordOrSelection(format);
	emit boldChanged();
}

bool DocumentHandler::italic() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return false;
	return textCursor().charFormat().fontItalic();
}

void DocumentHandler::setItalic(bool italic)
{
	QTextCharFormat format;
	format.setFontItalic(italic);
	mergeFormatOnWordOrSelection(format);
	emit italicChanged();
}

bool DocumentHandler::underline() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return false;
	return textCursor().charFormat().fontUnderline();
}

void DocumentHandler::setUnderline(bool underline)
{
	QTextCharFormat format;
	format.setFontUnderline(underline);
	mergeFormatOnWordOrSelection(format);
	emit underlineChanged();
}

bool DocumentHandler::strikeout() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return false;
	return textCursor().charFormat().fontStrikeOut();
}

void DocumentHandler::setStrikeout(bool strikeout)
{
	QTextCharFormat format;
	format.setFontStrikeOut(strikeout);
	mergeFormatOnWordOrSelection(format);
	emit strikeoutChanged();
}

int DocumentHandler::fontSize() const
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return 0;
	QTextCharFormat format = cursor.charFormat();
	return format.font().pointSize();
}

void DocumentHandler::setFontSize(int size)
{
	if (size <= 0)
		return;

	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return;

	if (cursor.charFormat().property(QTextFormat::FontPointSize).toInt() == size)
		return;

	QTextCharFormat format;
	format.setFontPointSize(size);
	mergeFormatOnWordOrSelection(format);
	emit fontSizeChanged();
}

int DocumentHandler::list() const
{
	auto cursor = textCursor();
	if (cursor.isNull())
		return QTextListFormat::Style::ListStyleUndefined;

	auto list = cursor.currentList();
	if (!list)
		return QTextListFormat::Style::ListStyleUndefined;

	return list->formatIndex();
}

void DocumentHandler::setList(int style)
{
	auto cursor = textCursor();
	if (cursor.isNull())
		return;

	cursor.setPosition(cursor.selectionStart());
	cursor.insertList(static_cast<QTextListFormat::Style>(style));
}

int DocumentHandler::table() const
{
	auto table = getTable();
	return table ? table->format().isTableCellFormat() || table->format().isTableFormat() : 0;
}

bool DocumentHandler::tableCollapse() const
{
	//auto table = getTable();
	//return table ? table->format->borderCollapse() : false;
	return false;
}

void DocumentHandler::setTableCollapse(bool collapse)
{
	//auto table = getTable();
	//if (!table)
	//	return;

	//table->format()->borderCollapse(collapse);
	//emit tableCollapseChanged();
}

QColor DocumentHandler::tableBorderColor() const
{
	auto table = getTable();
	if (!table)
		return Qt::black;

	return table->format().borderBrush().color();
}

void DocumentHandler::setTableBorderColor(const QColor& color)
{
	auto table = getTable();
	if (!table)
		return;

	QTextTableFormat format;
	format.merge(table->format());
	format.setBorderBrush(color);
	table->setFormat(format);
	emit tableBorderColorChanged();
}

QColor DocumentHandler::tableBackground() const
{
	auto table = getTable();
	if (!table)
		return Qt::white;

	return table->format().background().color();
}

void DocumentHandler::setTableBackground(const QColor& color)
{
	auto table = getTable();
	if (!table)
		return;

	QTextTableFormat format;
	format.merge(table->format());
	format.setBackground(color);
	table->setFormat(format);
	emit tableBorderColorChanged();
}

void DocumentHandler::setTable(int rows, int cols, int borderStyle)
{
	auto cursor = textCursor();
	if (cursor.isNull())
		return;

	QTextTableFormat format;
	format.setBorderStyle(static_cast<QTextTableFormat::BorderStyle>(borderStyle));
	cursor.insertTable(rows, cols, format);
}

void DocumentHandler::setTableBorderStyle(int borderStyle)
{
	QTextTableFormat format;
	format.setBorderStyle(static_cast<QTextTableFormat::BorderStyle>(borderStyle));
	mergeTableFormat(format);
}

int DocumentHandler::tableCellPadding() const
{
	auto table = getTable();
	if (!table)
		return -1;

	return table->format().cellPadding();
}

void DocumentHandler::setTableCellPadding(int cellPadding)
{
	if (tableCellPadding() == cellPadding)
		return;

	QTextTableFormat format;
	format.setCellPadding(cellPadding);
	mergeTableFormat(format);
	emit tableCellPaddingChanged();
}

int DocumentHandler::tableCellSpacing() const
{
	auto table = getTable();
	if (!table)
		return -1;

	return table->format().cellSpacing();
}

void DocumentHandler::setTableCellSpacing(int cellSpacing)
{
	if (tableCellSpacing() == cellSpacing)
		return;

	QTextTableFormat format;
	format.setCellSpacing(cellSpacing);
	mergeTableFormat(format);
	emit tableCellSpacingChanged();
}

QString DocumentHandler::fileName() const
{
	const QString filePath = QQmlFile::urlToLocalFileOrQrc(m_fileUrl);
	const QString fileName = QFileInfo(filePath).fileName();
	if (fileName.isEmpty())
		return QStringLiteral("untitled.txt");
	return fileName;
}

QString DocumentHandler::fileType() const
{
	return QFileInfo(fileName()).suffix();
}

QUrl DocumentHandler::fileUrl() const
{
	return m_fileUrl;
}

void DocumentHandler::load(const QUrl &fileUrl)
{
	if (fileUrl == m_fileUrl)
		return;

	QQmlEngine *engine = qmlEngine(this);
	if (!engine) {
		qWarning() << "load() called before DocumentHandler has QQmlEngine";
		return;
	}

	const QUrl path = QQmlFileSelector::get(engine)->selector()->select(fileUrl);
	const QString fileName = QQmlFile::urlToLocalFileOrQrc(path);
	if (QFile::exists(fileName)) {
		QFile file(fileName);
		if (file.open(QFile::ReadOnly)) {
			QByteArray data = file.readAll();
			QTextCodec *codec = QTextCodec::codecForHtml(data);
			if (QTextDocument *doc = textDocument())
				doc->setModified(false);

			emit loaded(codec->toUnicode(data));
			reset();
		}
	}

	m_fileUrl = fileUrl;
	emit fileUrlChanged();
}

void DocumentHandler::saveAs(const QUrl &fileUrl)
{
	QTextDocument *doc = textDocument();
	if (!doc)
		return;

	const QString filePath = fileUrl.toLocalFile();
	const bool isHtml = QFileInfo(filePath).suffix().contains(QLatin1String("htm"));
	QFile file(filePath);
	if (!file.open(QFile::WriteOnly | QFile::Truncate | (isHtml ? QFile::NotOpen : QFile::Text))) {
		emit error(tr("Cannot save: ") + file.errorString());
		return;
	}
	file.write((isHtml ? doc->toHtml() : doc->toPlainText()).toUtf8());
	file.close();

	if (fileUrl == m_fileUrl)
		return;

	m_fileUrl = fileUrl;
	emit fileUrlChanged();
}

void DocumentHandler::contentsChanged(int from, int removed, int added)
{
	//TODO: fix this shit
	auto cursor = textCursor();
	if (!cursor.hasSelection())
	{
		//auto currpos = cursor.position();

		if (m_need && from == m_last && added > removed)
		{
			cursor.setPosition(m_last);
			cursor.setPosition(from + added - removed, QTextCursor::KeepAnchor);
			cursor.mergeCharFormat(m_nfor);
			m_need = false;
		}
	}
}

QTextTable* DocumentHandler::getTable() const
{
	auto cursor = textCursor();
	if (cursor.isNull())
		return nullptr;

	return cursor.currentTable();
}

void DocumentHandler::reset()
{
	emit fontFamilyChanged();
	emit alignmentChanged();
	emit boldChanged();
	emit italicChanged();
	emit underlineChanged();
	emit fontSizeChanged();
	emit foregroundChanged();
}

QTextCursor DocumentHandler::textCursor() const
{
	QTextDocument *doc = textDocument();
	if (!doc)
		return QTextCursor();

	QTextCursor cursor = QTextCursor(doc);
	if (m_selectionStart != m_selectionEnd) {
		cursor.setPosition(m_selectionStart);
		cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
	} else {
		cursor.setPosition(m_cursorPosition);
	}
	return cursor;
}

QTextDocument *DocumentHandler::textDocument() const
{
	if (!m_document)
		return nullptr;

	return m_document->textDocument();
}

void DocumentHandler::mergeFormatOnWordOrSelection(const QTextCharFormat &format)
{
	QTextCursor cursor = textCursor();
	if (cursor.isNull())
		return;

	if (!cursor.hasSelection())
	{
		m_need = true;
		m_last = cursor.position();
		m_nfor.merge(cursor.charFormat());
		m_nfor.merge(format);
	}
	else
	{
		cursor.mergeCharFormat(format);
	}
}

void DocumentHandler::mergeTableFormat(const QTextTableFormat& format)
{
	auto table = getTable();
	if (!table)
		return;

	auto merged = table->format();
	merged.merge(format);
	table->setFormat(merged);
	//table->setFrameFormat(merged);
}

void DocumentHandler::mergeTableCellFormat(const QTextTableCellFormat& format)
{
	auto table = getTable();
	if (!table)
		return;

}
