///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : cwindow.cc            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <string.h>

//extern struct Library *OpenLibrary(char *, long);
//extern void *CloseLibrary(struct Library *);
//struct IntuitionBase *IntuitionBase=NULL;
//struct GfxBase *GfxBase=NULL;


struct ExtNewWindow WindowData = {
	50,50,
	200,200,
	0,1,
	CLOSEWINDOW,
	WINDOWSIZING+WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE+NOCAREREFRESH+GIMMEZEROZERO,
	(struct Gadget *)NULL,
	(struct Image *)NULL,
	(UBYTE *)"CWindow",
	(struct Screen *)NULL,
	(struct BitMap *)NULL,
	50,50,
	100,100,
	WBENCHSCREEN,
	(struct TagItem *)NULL
};



#include "cwindow.h"
#include "cscreen.h"

BOOL CWindow :: initlibs()
{
//	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
//	if (IntuitionBase == NULL) return FALSE;
//	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
//	if (GfxBase == NULL)
//	{
//		CloseLibrary((struct Library *)IntuitionBase);
//		return FALSE;
//	}
	return TRUE;
}


CWindow :: CWindow()
{
	if (!initlibs()) return;
	newwind=NULL;
	wind=NULL;
	newwind=new ExtNewWindow;
	if (newwind==NULL) return;
	*newwind=WindowData;
}


CWindow :: CWindow(struct NewWindow *neww)
{
	if (!initlibs()) return;
	newwind=NULL;
	wind=NULL;
	newwind=new ExtNewWindow;
	if (newwind==NULL) return;
	memcpy((void *)newwind,(void *)neww,sizeof(struct NewWindow));
	newwind->Extension=NULL;
}

CWindow :: CWindow(struct ExtNewWindow *neww)
{
	if (!initlibs()) return;
	newwind=NULL;
	wind=NULL;
	newwind=new ExtNewWindow;
	if (newwind==NULL) return;
	*newwind=*neww;
}


CWindow :: CWindow(struct NewWindow *neww ,struct TagItem *tags)
{
	if (!initlibs()) return;
	newwind=NULL;
	wind=NULL;
	newwind=new ExtNewWindow;
	if (newwind==NULL) return;
	if (neww) memcpy((void *)newwind,(void *)neww,sizeof(struct NewWindow));
	else *newwind=WindowData;	
	newwind->Extension=tags;
}


CWindow :: ~CWindow()
{
	close();
	if (screen) screen->rmwindow(*this);
	if (newwind) delete newwind;
//	if (GfxBase) CloseLibrary((struct Library *)GfxBase);
//	if (IntuitionBase) CloseLibrary((struct Library *)IntuitionBase);
}


BOOL CWindow :: open()
{
	if (wind) CloseWindow(wind);
	newwind->Screen=NULL;
	newwind->Type=WBENCHSCREEN;
	if (screen)
	{
		if (screen->isopen())
		{
			newwind->Screen=screen->scr;
			newwind->Type=CUSTOMSCREEN;
		}
	}
	wind=(struct Window *)OpenWindowTagList((struct NewWindow *)newwind, newwind->Extension);
	return isopen();
}


BOOL CWindow :: isopen() { return (wind!=NULL); }


void CWindow :: close()
{
	if (isopen())
	{
		newwind->LeftEdge=wind->LeftEdge;
		newwind->TopEdge=wind->TopEdge;
		newwind->Width=wind->Width;
		newwind->Height=wind->Height;
		newwind->MinWidth=wind->MinWidth;
		newwind->MinHeight=wind->MinHeight;
		newwind->MaxWidth=wind->MaxWidth;
		newwind->MaxHeight=wind->MaxHeight;
		newwind->Flags=wind->Flags;
		CloseWindow(wind);
		wind=NULL;
	}
}


void CWindow :: update()
{
	if (isopen())
	{
		CloseWindow(wind);
		wind=(struct Window *)OpenWindowTagList((struct NewWindow *)newwind, newwind->Extension);
	}	
}

void CWindow :: resize(int x, int y)
{
	newwind->Width=x;
	newwind->Height=y;
	if (isopen()) SizeWindow(wind,x,y);
}


void CWindow :: move(int x, int y)
{
	newwind->LeftEdge+=x;
	newwind->TopEdge+=y;
	if (isopen()) MoveWindow(wind,x,y);
}


void CWindow :: setpos(int x, int y)
{
	newwind->LeftEdge=x;
	newwind->TopEdge=y;
	if (isopen()) MoveWindow(wind,x-wind->LeftEdge,y-wind->TopEdge);
}


void CWindow :: settitle(char *Wtitle)
{
	newwind->Title=(UBYTE *)Wtitle;
	if (wind) SetWindowTitles(wind,(UBYTE *)Wtitle,(UBYTE *)Wtitle);
}


BOOL CWindow :: setlimit(int minw, int minh, int maxw, int maxh)
{
	newwind->MinWidth=minw;
	newwind->MinHeight=minh;
	newwind->MaxWidth=maxw;
	newwind->MaxHeight=maxh;
	return WindowLimits(wind,minw, minh, maxw, maxh);
}


ULONG CWindow :: setflags(ULONG flags)
{
ULONG oldf;
	oldf=newwind->Flags;
	newwind->Flags=(ULONG)flags;
	update();
	return oldf;
}


void CWindow :: setpointer(UWORD *sprite, int h, int w, int xo, int yo)
{
	if (isopen()) SetPointer(wind,sprite,h,w,xo,yo);
}


void CWindow :: clearpointer()
{
	if (isopen()) ClearPointer(wind);
}


void CWindow :: refreshframe()
{
	if (isopen()) RefreshWindowFrame(wind);
}


void CWindow :: tofront()
{
	if (isopen()) WindowToFront(wind);
}


void CWindow :: toback()
{
	if (isopen()) WindowToBack(wind);
}


void CWindow :: activate()
{
	if (isopen()) ActivateWindow(wind);
}


int CWindow :: leftedge() { return isopen()?wind->LeftEdge:newwind->LeftEdge; }

int CWindow :: topedge() { return isopen()?wind->TopEdge:newwind->TopEdge; }

int CWindow :: width() { return isopen()?wind->Width:newwind->Width; }

int CWindow :: height() { return isopen()?wind->Height:newwind->Height; }

int CWindow :: minwidth() { return isopen()?wind->MinWidth:newwind->MinWidth; }

int CWindow :: minheight() { return isopen()?wind->MinHeight:newwind->MinHeight; }

int CWindow :: maxwidth() { return isopen()?wind->MaxWidth:newwind->MaxWidth; }

int CWindow :: maxheight() { return isopen()?wind->MaxHeight:newwind->MaxHeight; }

unsigned long CWindow :: flags() { return isopen()?wind->Flags:newwind->Flags; }

int CWindow :: mousex()
{
	if (!isopen()) return 0;
	return wind->MouseX;
}

int CWindow :: mousey()
{
	if (!isopen()) return 0;
	return wind->MouseY;
}




