/*** Test the mouse ***/

#include "MTRD.h"
#include "MTRDTypes.h"

struct MtrdBase *MtrdBase;


struct NewWindow newwindow = {
	40,20,180,60,0,1,
	MOUSEMOVE|MOUSEBUTTONS,WINDOWDRAG|REPORTMOUSE|RMBTRAP|ACTIVATE,
	NULL,NULL,(UBYTE *)"Test Mouse",
	NULL,NULL,0,0,0,0,WBENCHSCREEN
};

void *IntuitionBase;
char myBuffer[20],Com[32];
struct FileID myID = { MTT_MOUSE,MTS_RELMOUSE|MTS_CHAR,20,
								myBuffer,"MyMouseCoordsBuffer",0,0,0,0 };


main()
{
	struct MFile *File;
	struct MUser *User;
	int out=FALSE;
	ULONG class;
	UWORD code;
	SHORT mx,my;
	struct Window *win;
	struct IntuiMessage *msg;
	char t[20];

	IntuitionBase=OpenLibrary("intuition.library",0);
	MtrdBase=OpenLibrary("mtrd.library",0);
	File=OpenMFile(NULL,&myID,0);
	GETMUSER(File,User);

	win=OpenWindow(&newwindow);
	while (!out) {
		WaitPort(win->UserPort);
		while (msg=(struct IntuiMessage *)GetMsg(win->UserPort)) {
			class=msg->Class;
			code=msg->Code;
			mx=msg->MouseX;
			my=msg->MouseY;
			ReplyMsg((struct Message *)msg);
			if (class==MOUSEMOVE) {
				InitData(Com);
				sprintf(t,"%d,%d",mx,my);
				AddBytes(Com,0,20,t);
				WriteData(File,User,Com);
			}
			if (class==MOUSEBUTTONS)
				if (code==MENUDOWN)
					out=TRUE;
		}
	}
	CloseMFile(File,User);
	CloseWindow(win);
	CloseLibrary(MtrdBase);
	CloseLibrary(IntuitionBase);
}
