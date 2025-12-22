///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : cscreen.cc            ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <intuition/intuition.h>
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


struct ExtNewScreen ScreenData = {
	0,0,
	640,512,
	4,
	0,1,
	LACE+HIRES,
	CUSTOMSCREEN,
	(struct TextAttr *)NULL,
	(UBYTE *)"CScreen",
	(struct Gadget *)NULL,
	(struct BitMap *)NULL,
	(struct TagItem *)NULL
};


#include "cscreen.h"


CWNode :: CWNode()
{
	wn=NULL;
	wasopen=FALSE;
	nextwnode=NULL;
}


CWNode :: ~CWNode() {}



BOOL CScreen :: initlibs()
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


CScreen :: CScreen()
{
	if (!initlibs()) return;
	newscr=NULL;
	scr=NULL;
	newscr=new ExtNewScreen;
	if (newscr==NULL) return;
	*newscr=ScreenData;
}


CScreen :: CScreen(struct NewScreen *news)
{
	if (!initlibs()) return;
	newscr=NULL;
	scr=NULL;
	newscr=new ExtNewScreen;
	if (newscr==NULL) return;
	memcpy((void *)newscr,(void *)news,sizeof(struct NewScreen));
	newscr->Extension=NULL;
}

CScreen :: CScreen(struct ExtNewScreen *news)
{
	if (!initlibs()) return;
	newscr=NULL;
	scr=NULL;
	newscr=new ExtNewScreen;
	if (newscr==NULL) return;
	*newscr=*news;
}


CScreen :: CScreen(struct NewScreen *news ,struct TagItem *tags)
{
	if (!initlibs()) return;
	newscr=NULL;
	scr=NULL;
	newscr=new ExtNewScreen;
	if (newscr==NULL) return;
	if (news) memcpy((void *)newscr,(void *)news,sizeof(struct NewScreen));
	else *newscr=ScreenData;
	newscr->Extension=tags;
}


CScreen :: ~CScreen()
{
	rmwindows();
	if (scr) CloseScreen(scr);
	if (newscr) delete newscr;
//	if (GfxBase) CloseLibrary((struct Library *)GfxBase);
//	if (IntuitionBase) CloseLibrary((struct Library *)IntuitionBase);
}


BOOL CScreen :: open()
{
	if (isopen()) return TRUE;
	scr=(struct Screen *)OpenScreenTagList((struct NewScreen *)newscr, newscr->Extension);
	if (isopen())
	{
		reopenwindows();
		return TRUE;
	}
	else return FALSE;
}


BOOL CScreen :: isopen() { return (scr!=NULL); }


void CScreen :: close()
{
	if (isopen())
	{
		closewindows();
		newscr->LeftEdge=scr->LeftEdge;
		newscr->TopEdge=scr->TopEdge;
		newscr->Width=scr->Width;
		newscr->Height=scr->Height;
		CloseScreen(scr);
		scr=NULL;
	}
}


void CScreen :: update()
{
	if (isopen())
	{
		closewindows();
		CloseScreen(scr);
		scr=(struct Screen *)OpenScreenTagList((struct NewScreen *)newscr, newscr->Extension);
		openwindows();
	}	
}

void CScreen :: resize(int x, int y)
{
	newscr->Width=x;
	newscr->Height=y;
	update();
}


void CScreen :: setviewmodes(UWORD modes)
{
	newscr->ViewModes=modes;
	update();
}


void CScreen :: move(int x, int y)
{
	newscr->LeftEdge+=x;
	newscr->TopEdge+=y;
	if (isopen()) MoveScreen(scr,x,y);
}


void CScreen :: setpos(int x, int y)
{
	newscr->LeftEdge=x;
	newscr->TopEdge=y;
	if (isopen()) MoveScreen(scr,x-scr->LeftEdge,y-scr->TopEdge);
}


void CScreen :: tofront()
{
	if (!isopen()) ScreenToFront(scr);
}


void CScreen :: toback()
{
	if (!isopen()) ScreenToBack(scr);
}


void CScreen :: showtitle(BOOL ok)
{
	if (isopen()) ShowTitle(scr, ok);
}


void CScreen :: beep()
{
	if (isopen()) DisplayBeep(scr);
}


int CScreen :: leftedge() { return isopen()?scr->LeftEdge:newscr->LeftEdge; }

int CScreen :: topedge() { return isopen()?scr->TopEdge:newscr->TopEdge; }

int CScreen :: width() { return isopen()?scr->Width:newscr->Width; }

int CScreen :: height() { return isopen()?scr->Height:newscr->Height; }

int CScreen :: mousex()
{
	if (!isopen()) return 0;
	return scr->MouseX;
}

int CScreen :: mousey()
{
	if (!isopen()) return 0;
	return scr->MouseY;
}


BOOL CScreen :: linkwindow(CWindow& window)
{
CWNode *node;
	if ((node=new CWNode)==NULL) return FALSE;
	if (node->wasopen=window.isopen()) window.close();
	if (window.screen) window.screen->rmwindow(window);
	window.screen=this;
	node->wn=&window;
	node->nextwnode=cwlist;
	if (isopen() && node->wasopen) window.open();
	cwlist=node;
	return TRUE;
}


CWindow * CScreen :: rmwindow(CWindow& window)
{
CWNode *oldnode,*n;
	if (cwlist==NULL) return NULL;
	if (cwlist->wn==&window)
	{
		cwlist->wn->close();
		cwlist->wn->screen=NULL;
		oldnode=cwlist;
		cwlist=cwlist->nextwnode;
		delete oldnode;
		return &window;
	}
	for (n=cwlist;n->nextwnode;n=n->nextwnode)
	{
		if (n->nextwnode->wn==&window)
		{
			n->wn->close();
			n->wn->screen=NULL;
			oldnode=n->nextwnode;
			n->nextwnode=n->nextwnode->nextwnode;
			delete oldnode;
			return &window;
		}
	}
	return NULL;
}


void CScreen :: rmwindows()
{
CWNode *nextnode;
	while (cwlist)
	{
		cwlist->wn->close();
		cwlist->wn->screen=NULL;
		nextnode=cwlist->nextwnode;
		delete cwlist;
		cwlist=nextnode;
	}
}


void CScreen :: openwindows()
{
CWNode *n;
	if (!isopen()) return;
	for (n=cwlist;n;n=n->nextwnode)
	{
		if (n->wn->isopen()) n->wn->close();
		if (n->wasopen) n->wn->open();
	}
}


void CScreen :: reopenwindows()
{
CWNode *n;
	if (!isopen()) return;
	for (n=cwlist;n;n=n->nextwnode)
	{
		if (n->wn->isopen())
		{
			n->wasopen=TRUE;
			n->wn->close();
		}
		if (n->wasopen) n->wn->open();
	}
}


void CScreen :: closewindows()
{
CWNode *n;
	for (n=cwlist;n;n=n->nextwnode)
		if (n->wasopen=n->wn->isopen()) n->wn->close();
}



void CScreen :: openallwindows()
{
CWNode *n;
	if (!isopen()) return;
	for (n=cwlist;n;n=n->nextwnode)
	{
		if (n->wn->isopen()) n->wn->close();
		n->wn->newwind->Screen=scr;
		n->wn->newwind->Type=CUSTOMSCREEN;
		n->wn->open();
	}
}


void CScreen :: closeallwindows()
{
CWNode *n;
	for (n=cwlist;n;n=n->nextwnode)
	{
		n->wn->close();
		n->wn->newwind->Screen=NULL;
		n->wn->newwind->Type=WBENCHSCREEN;
	}
}



