///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Little test program implementing a simple painter to illustrate
//	how objects are easy to use, and easy to handle.
//
//	For all comment email 'brulhart@cuilima.unige.ch'
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <stream.h>
#include <stdlib.h>


///////////////////////////////////////////////////////////////////////////////
// Intuition objects created with PowerWindows defined in 'drawctrl.c'

extern struct NewScreen NewScreenStructure;
extern struct TagItem ScreenTags[]; 
extern struct NewWindow CTRLNewWindowStructure1;
extern struct NewWindow BITNewWindowStructure2;
extern struct Gadget CTRLpoint;
extern struct Gadget CTRLfree;
extern struct Gadget CTRLline;
extern struct Gadget CTRLrect;
extern struct Gadget CTRLcircle;
extern struct Image CTRLImage1;
extern struct Image CTRLImage2;
extern struct Image CTRLImage3;
extern struct Image CTRLImage4;
extern struct Image CTRLImage5;
extern struct Image CTRLImage6;
extern struct Image CTRLImage7;
extern struct Image CTRLImage8;
extern struct Image CTRLImage9;
extern struct Image CTRLImage10;
extern struct Menu Menu1;
extern struct Menu Menu2;
extern struct MenuItem MenuItem1;
extern struct MenuItem MenuItem2;
extern struct MenuItem MenuItem3;

///////////////////////////////////////////////////////////////////////////////
// Global objects used by the painter 

#define POINTS		1
#define FREEHANDS	2
#define LINES 		3
#define RECTANGLES 	4
#define ELLIPSES 	5

#define DO(from,until,do,undo,result) from while (! (until)) { do undo } result

#include <ipp/mgwindow.h>
#include <ipp/wgscreen.h>

MsgWindow ctrlw(&CTRLNewWindowStructure1);
MGWindow bw(&BITNewWindowStructure2);
WGScreen scr(&NewScreenStructure, ScreenTags);
int drawingmode=POINTS;


///////////////////////////////////////////////////////////////////////////////
// Functions used by the painter

void help(IMessage& message)
{
	scr.setapen(2);
	scr.setfont((STRPTR)"Dom32.font",32,0,0);
	for (int i=0; i<30; i+=5)
		scr.drawrect(200-i,400-i,500+i,480+i);
	scr.writetext(250,450,"Do you really need help ?");
	scr.setfont((STRPTR)"FuturaB.font",12,0,0);
	ctrlw.offgadget(&CTRLpoint);
}
void quit(IMessage& message)	{ bw.close(); ctrlw.close(); scr.close(); exit(0); }
void clear(IMessage& message)	{ bw.clear(); ctrlw.ongadget(&CTRLpoint);}
void point(IMessage& message)	{ drawingmode=POINTS; }
void free(IMessage& message)	{ drawingmode=FREEHANDS; }
void line(IMessage& message)	{ drawingmode=LINES; }
void rect(IMessage& message)	{ drawingmode=RECTANGLES; }
void circle(IMessage& message)	{ drawingmode=ELLIPSES; }

void makepoint(IMessage& message)
{
IMessage mess;
DO(
	bw.setapen(1);
	bw.setdrmd(JAM1);
	bw.writepixel(message.imousex,message.imousey);
,
	bw.getImsg(mess)->icode==SELECTUP
,
	bw.writepixel(bw.mousex(),bw.mousey()); ,, );
}


void makefreehand(IMessage& message)
{
IMessage mess;
DO(
	bw.setapen(1);
	bw.setdrmd(JAM1);
	bw.setpenpos(message.imousex,message.imousey);
,
	bw.getImsg(mess)->icode==SELECTUP
,
	bw.drawlineto(bw.mousex(),bw.mousey()); ,, );
}


void makeline(IMessage& message)
{
IMessage mess;
int x,y;
DO(
	bw.setapen(1);
	bw.setdrmd(COMPLEMENT);
,
	bw.getImsg(mess)->icode==SELECTUP
,
	x=bw.mousex();
	y=bw.mousey();
	bw.drawline(message.imousex,message.imousey,x,y);
,
	bw.drawline(message.imousex,message.imousey,x,y);
,
	bw.setdrmd(JAM1);
	bw.drawline(message.imousex,message.imousey,x,y); );
}


void makeellipse(IMessage& message)
{
IMessage mess;
int x,y;
DO(
	bw.setapen(1);
	bw.setdrmd(COMPLEMENT);
,
	bw.getImsg(mess)->icode==SELECTUP
,
	x=abs(message.imousex-bw.mousex());
	y=abs(message.imousey-bw.mousey());
	bw.drawellipse(message.imousex,message.imousey,x,y);
,
	bw.drawellipse(message.imousex,message.imousey,x,y);
,
	bw.setdrmd(JAM1);
	bw.drawellipse(message.imousex,message.imousey,x,y);	);
}


void makerectangle(IMessage& message)
{
IMessage mess;
int x,y;
DO(
	bw.setapen(1);
	bw.setdrmd(COMPLEMENT);
,
	bw.getImsg(mess)->icode==SELECTUP
,
	x=(message.imousex-bw.mousex());
	y=(message.imousey-bw.mousey());
	bw.drawrect(message.imousex,message.imousey,message.imousex-x,message.imousey-y);
,
	bw.drawrect(message.imousex,message.imousey,message.imousex-x,message.imousey-y);
,
	bw.setdrmd(JAM1);
	bw.drawrect(message.imousex,message.imousey,message.imousex-x,message.imousey-y); );
}


void mouseselectup(IMessage& message)
{
	switch(drawingmode)
	{
		case POINTS:
			makepoint(message);
			break;
		case FREEHANDS:
			makefreehand(message);
			break;
		case LINES:
			makeline(message);
			break;
		case RECTANGLES:
			makerectangle(message);
			break;
		case ELLIPSES:
			makeellipse(message);
			break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// The application. Note that no initialization at all is needed to be made.


main()
{
// Set fonts to windows and screen
	scr.setfont((STRPTR)"FuturaB.font",12,0,0);
	bw.setfont((STRPTR)"Dom32.font",32,0,0);

// Link events for drawing window
	bw.linkIevent(MOUSEBUTTONS,SELECTDOWN,0,NULL,mouseselectup);
	bw.linkIevent(CLOSEWINDOW,0,0,NULL,quit);
	bw.linkmenu(&Menu1);
	bw.linkIevent(MENUPICK,0,0,(void *)&MenuItem1,clear);
	bw.linkIevent(MENUPICK,0,0,(void *)&MenuItem2,help);
	bw.linkIevent(MENUPICK,0,0,(void *)&MenuItem3,quit);

// Link events for control window
	ctrlw.linkgadgets(&CTRLpoint);
	ctrlw.linkmenu(&Menu1);
	ctrlw.linkIevent(MENUPICK,0,0,(void *)&MenuItem1,clear);
	ctrlw.linkIevent(MENUPICK,0,0,(void *)&MenuItem2,help);
	ctrlw.linkIevent(MENUPICK,0,0,(void *)&MenuItem3,quit);
	ctrlw.linkIevent(GADGETUP,0,0,(void *)&CTRLpoint,point);
	ctrlw.linkIevent(GADGETUP,0,0,(void *)&CTRLfree,free);
	ctrlw.linkIevent(GADGETUP,0,0,(void *)&CTRLline,line);
	ctrlw.linkIevent(GADGETUP,0,0,(void *)&CTRLrect,rect);
	ctrlw.linkIevent(GADGETUP,0,0,(void *)&CTRLcircle,circle);
	ctrlw.linkIevent(CLOSEWINDOW,0,0,NULL,quit);

// Link windows to the screen
	scr.linkwindow(ctrlw);
	scr.linkwindow(bw);

// Open all and give control to the waitgraphicscreen
	scr.open();
	bw.open();
	ctrlw.open();
	bw.writetext(50,50,"Welcome");

	scr.hardcontrol();

// Just for fun
	ctrlw.close();
	bw.close();
}
