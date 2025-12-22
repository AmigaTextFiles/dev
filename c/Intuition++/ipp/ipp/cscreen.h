///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : cscreen.h             ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Class CScreen :
//
//		- Simple screen handling, remember size, position, ... between
//		open and close. You can pass it a NewScreen, ExtNewScreen or
//		NewScreen and TagList structure to its constructor.
//
//		- You can link windows to it so when a window wants to open
//		it asks his address to its screen and opens in it. If the screen
//		is closed, its linked windows open on WorkBench.
//
//		- When a screen is closed and reopened, it remembers which
//		windows was open and tell them to reopen.		


#ifndef __CSCREEN__
#define __CSCREEN__

#include <intuition/screens.h>

#include <ipp/cwindow.h>


class CWNode
{
public:
	CWindow *wn;
	BOOL wasopen;
	CWNode *nextwnode;

	CWNode();
	~CWNode();
};



class CScreen
{
protected:
	friend class CWindow;

	BOOL initlibs();
	struct ExtNewScreen *newscr;
	struct Screen *scr;
	CWNode *cwlist;

	virtual void update();
	void openwindows();
	void reopenwindows();
	void closewindows();

public:
	CScreen();
	CScreen(struct NewScreen *newscreen);
	CScreen(struct ExtNewScreen *extnewscreen);
	CScreen(struct NewScreen *newscreen, struct TagItem *tags);
	~CScreen();

	virtual BOOL open();
	BOOL isopen();
	virtual void close();
	void resize(int sizex, int sizey);
	void setpos(int x, int y);
	void move(int x, int y);
	void tofront();
	void toback();

	void setviewmodes(UWORD modes);
	void showtitle(BOOL yesorno);
	void beep();

	int leftedge();
	int topedge();
	int width();
	int height();
	int mousex();
	int mousey();

	virtual BOOL linkwindow(CWindow& window);
	virtual CWindow *rmwindow(CWindow& window);
	virtual void rmwindows();
	void openallwindows();
	void closeallwindows();
};


#endif //__CSCREEN__
