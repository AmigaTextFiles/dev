/*** Print Mouse Test ***/

#include "MTRD.h"
#include "MTRDTypes.h"

struct MtrdBase *MtrdBase;


struct NewWindow newwindow = {
	340,20,180,60,0,1,
	CLOSEWINDOW,WINDOWDRAG|WINDOWCLOSE,
	NULL,NULL,(UBYTE *)"Print Mouse",
	NULL,NULL,0,0,0,0,WBENCHSCREEN
};

void *IntuitionBase,*GfxBase;
char myBuf[20];
struct FileList flist[4];


main()
{
	struct MFile *File;
	struct MUser *User;
	int got,i,out=FALSE;
	ULONG class,sig,type;
	struct Window *win;
	struct IntuiMessage *msg;
	struct MsgPort *Port;
	struct MUpdate *mu;

	IntuitionBase=OpenLibrary("intuition.library",0);
	GfxBase=OpenLibrary("graphics.library",0);
	MtrdBase=OpenLibrary("mtrd.library",0);
	Port=CreatePort("PrintMousePort",0);
	got=GetFileList(flist,4,MTT_MOUSE,GET_ALL);
	for (i=0; i<got; i++)
		if (flist[i].FID.SubType & MTS_CHAR)
			break;
	if (i<got) {
		win=OpenWindow(&newwindow);
		SetAPen(win->RPort,1);
		SetDrMd(win->RPort,JAM2);
		User=AddUser(flist[i].File,Port,myBuf,MUSF_BUFFER|MUSF_NOTIFY|MUSF_LOCKWRITE);
		sig=(1<<win->UserPort->mp_SigBit)|(1<<Port->mp_SigBit);
		while (!out) {
			Wait(sig);
			while (msg=(struct IntuiMessage *)GetMsg(win->UserPort)) {
				class=msg->Class;
				ReplyMsg((struct Message *)msg);
				if (class==CLOSEWINDOW) {
					RemUser(User);
					out=TRUE;
				}
			}
			while (mu=(struct MUpdate *)GetMsg(Port)) {
				type=mu->Type;
				ReplyMsg((struct Message *)mu);
				if (type==MTUP_UPDATE) {
					Move(win->RPort,20,35);
					strcat(myBuf,"   ");
					Text(win->RPort,myBuf,strlen(myBuf));
					UNLOCK(User);
				}
				if (type==MTUP_CLOSE)
					out=TRUE;
			}
		}
		CloseWindow(win);
	}
	DeletePort(Port);
	CloseLibrary(MtrdBase);
	CloseLibrary(GfxBase);
	CloseLibrary(IntuitionBase);
}
