///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : cwindow.h             ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class CWindow :
//
//		- Simple window handling, remember size, position, ... 
//		between open and close. You can pass a NewWindow, ExtNewWindow
//		or NewWindow and TagList structure to its constructor.


#ifndef __CWINDOW__
#define __CWINDOW__

#include <intuition/intuition.h>


class CWindow
{
protected:
	friend class Waiter;
	friend class CScreen;

	BOOL initlibs();
	struct ExtNewWindow *newwind;
	struct Window *wind;
	CScreen *screen;

	virtual void update();
public:
	CWindow();
	CWindow(struct NewWindow *newwindow);
	CWindow(struct ExtNewWindow *extnewwindow);
	CWindow(struct NewWindow *newwindow, struct TagItem *tags);
	~CWindow();

	virtual BOOL open();
	BOOL isopen();
	virtual void close();
	void resize(int sizex, int sizey);
	void setpos(int x, int y);
	void move(int x, int y);
	void tofront();
	void toback();
	void activate();

	void settitle(char *string);
	BOOL setlimit(int xmin, int ymin, int xmax, int ymax);
	ULONG setflags(ULONG flags);
	void setpointer(UWORD *pointerdata, int heigth, int width, int x0, int y0);
	void clearpointer();
	void refreshframe();

	int leftedge();
	int topedge();
	int width();
	int height();
	int minwidth();
	int minheight();
	int maxwidth();
	int maxheight();
	unsigned long flags();
	int mousex();
	int mousey();
};


#endif //__CWINDOW__
