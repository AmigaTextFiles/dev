//===============================================//
// Layout manager classes                        //
// Text header file                              //
// © Jorrit Tyberghein, Wed Apr  6 20:27:37 1994 //
//===============================================//

#ifndef LAYOUT_TEXT_H
#define LAYOUT_TEXT_H 1

#ifndef LAYOUT_H
#include "layout.h"
#endif

#ifndef LAYOUT_BOX_H
#include "layout_box.h"
#endif

#ifndef LAYOUT_PRIMITIVE_H
#include "layout_primitive.h"
#endif

#ifndef LAYOUT_COMPOSITE_H
#include "layout_composite.h"
#endif

#ifndef LAYOUT_FORM_H
#include "layout_form.h"
#endif

#ifndef LAYOUT_SCROLLBAR_H
#include "layout_scrollbar.h"
#endif


typedef unsigned short StringPos;

class ByteLine
{
	StringPos len;
	char* line;

public:
	ByteLine () { D db("ByteLine::ByteLine"); line = NULL; len = 0; }
	~ByteLine () { D db("ByteLine::~ByteLine"); if (line) delete line; }

	char* Get () { D db("ByteLine::Get", line); if (line) return line; else return ""; }
	char* Get (StringPos p) { D db("ByteLine::Get", p, line); if (p >= len) return ""; else return line+p; }
	void Put (StringPos p, char* s, StringPos l);
	StringPos Length () { return len; }
	StringPos Length (StringPos p) { if (p >= len) return 0; else return len-p; }
	void Clear () { if (line) delete line; line = NULL; len = 0; }

	ByteLine& operator= (ByteLine& bl) { return *this = bl.Get (); }
	ByteLine& operator= (char* s);

	char& operator[] (StringPos p);
};


class Lines
{
	ByteLine* lines;
	int nrlines;
	int TopRow, BottomRow;
	int CurrentRow;
	StringPos CurrentCol, MaxCol;

public:
	Lines ();
	~Lines () { D db("Lines::~Lines"); if (lines) delete [] lines; }

	void SetNrLines (int nr);
	int GetNrLines (void) { return nrlines; }
	int GetLines (void) { return nrlines ? (BottomRow+nrlines-TopRow) % nrlines : 0; }
	ByteLine& operator[] (int p);

	void NewLine ();
	void Print (char* s);
};


class TextArea : public primitive
{
	Lines lines;
	int FirstCol, FirstRow;
	int VisibleCols, VisibleRows;
	int CharWidth, CharHeight;
	int Baseline;

protected:
	virtual ResourceType GetResourceType (YtResource r);
	virtual void SetResource (YtResource r, ResourceVal& v);

public:
	TextArea (Shell* shell, char *name, composite *parent = NULL);
	virtual ~TextArea () { D db("TextArea::~TextArea", get_name ()); }

	virtual void expose ();
	virtual void resize ();
	virtual GeometryResult query_geometry (GeometryRequest& answer);

	void NewLine ();
	void Print (char* s);

	void Scroll (int c, int r) { FirstCol = c; FirstRow = r; }
	int GetVisibleCols () { return VisibleCols; }
	int GetVisibleRows () { return VisibleRows; }
	int GetFirstCol () { return FirstCol; }
	int GetFirstRow () { return FirstRow; }
	int GetLines () { return lines.GetLines (); }
};

class ScrollTextArea : public form
{
	TextArea ta;
	scrollbar sbarV, sbarH;

	static int newValueCB (primitive* obj, void* data, void* user);
	static int slidingCB (primitive* obj, void* data, void* user);

	void AdjustProps ();

public:
	ScrollTextArea (Shell* shell, char *name, composite *parent = NULL);
	virtual ~ScrollTextArea ();
	virtual void resize ();
	virtual int HandleEvent (unsigned long clas, unsigned short code, unsigned short qual, void* iaddr);

	void NewLine ();
	void Print (char* s);

	TextArea& GetTextArea () { return ta; }
};

#endif
