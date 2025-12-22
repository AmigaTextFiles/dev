/*========================================================*/
/*																												*/
/* Show gadgets in a window	V1.0													*/
/* © J.Tyberghein																					*/
/*		Mon Mar  5 09:16:17 1990 V1.0												*/
/*																												*/
/*========================================================*/

#include <exec/types.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <exec/interrupts.h>
#include <devices/inputevent.h>
#include <devices/input.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <string.h>

/*=============================== Data ======================================*/

APTR SysBase;
struct DosLibrary *DOSBase;
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;

void OpenStuff ();
void __regargs CloseStuff (int);
void Print (char *);

/* NewWindow structure for our dummy window */
struct NewWindow nWin =
	{
		0,0,0,0,0,1,
		NULL,
		BORDERLESS,
		NULL,NULL,NULL,NULL,NULL,
		0,0,0,0,
		CUSTOMSCREEN
	};

/* Everything for the input device */
#define GKEY				0x24
#define ESCAPEKEY		0x45

/* The following structure is needed to pass information from our input
device handler to our task */
typedef struct
	{
		struct Task *TaskToSig;				/* Pointer to our own task */
		ULONG QuitSig,QuitSigNum;			/* Signal to quit ShowGadgets */
		ULONG ActionSig,ActionSigNum;	/* Someone pressed AMIGA-AMIGA-G */
	} Global_Data;

Global_Data Global;

struct MsgPort *InputDevPort = NULL;
struct IOStdReq *InputRequestBlock = NULL;
struct Interrupt HandlerStuff;

/*=============================== Code ======================================*/


/*------------------------------ main program -------------------------------*/

void __saveds myMain ()
{
	struct Window *win,*myWin;
	int w,h,sig,xx,yy;
	struct RastPort *rp;
	struct Gadget *g;

	OpenStuff ();
	Print ("[01mShowGadgets 1.0[00m  [33mWritten by J.Tyberghein 5 Mar 90[31m\n");
	Print ("Press 'AMIGA-AMIGA-G' for gadget view ");
	Print ("(Left mouse button to stop view)\n");
	Print ("Press 'AMIGA-AMIGA-ESC' to quit\n");
	for ( ; ; )
		{
			sig = Wait (Global.QuitSig | Global.ActionSig);
			if (sig & Global.QuitSig) break;
			if (sig & Global.ActionSig)
				{
					win = IntuitionBase->ActiveWindow;
					nWin.LeftEdge = win->LeftEdge;
					nWin.TopEdge = win->TopEdge;
					w = nWin.Width = win->Width;
					h = nWin.Height = win->Height;
					nWin.Screen = win->WScreen;
					if (!(myWin = (struct Window *)OpenWindow (&nWin)))
						{
							Print ("Error opening window\n");
							DisplayBeep (0L);
						}
					else
						{
							rp = myWin->RPort;
							Forbid ();
							SetRast (rp,0L);
							SetAPen (rp,1L);
							g = win->FirstGadget;
							while (g)
								{
									int x1,y1,x2,y2;

									x1 = g->LeftEdge; y1 = g->TopEdge;
									if (g->Flags & GRELRIGHT) x1 += w;
									if (g->Flags & GRELBOTTOM) y1 += h;
									if (g->Flags & GRELWIDTH) xx = x2 = x1+g->Width+w-1;
									else x2 = x1+g->Width-1;
									if (g->Flags & GRELHEIGHT) yy = y2 = y1+g->Height+h-1;
									else y2 = y1+g->Height-1;
									Move (rp,x1,y1);
									Draw (rp,x2,y1);
									Draw (rp,x2,y2);
									Draw (rp,x1,y2);
									Draw (rp,x1,y1);
									g = g->NextGadget;
								}
							while ((*(BYTE *)0xbfe001)&64) ;
							CloseWindow (myWin);
							Permit ();
						}
				}
		}
	Print ("Done !\n");
	CloseStuff (0);
}

/*-------------------------- Print something --------------------------------*/

void Print (char *str)
{
	Write (Output (),str,strlen (str));
}

/*------------------------ InputEvent handler -------------------------------*/

struct InputEvent * __saveds __asm MyHandler
			(register __a0 struct InputEvent *ev, register __a1 Global_Data *gdptr)
{
	register struct InputEvent *ep;

	for (ep=ev ; ep ; ep=ep->ie_NextEvent)
		if (ep->ie_Class == IECLASS_RAWKEY)
			if (ep->ie_Code == GKEY && (ep->ie_Qualifier &
				IEQUALIFIER_RCOMMAND) && (ep->ie_Qualifier & IEQUALIFIER_LCOMMAND))
				{
					ep->ie_Class = IECLASS_NULL;
					Signal (gdptr->TaskToSig,gdptr->ActionSig);
				}
			else if (ep->ie_Code == ESCAPEKEY && (ep->ie_Qualifier &
				IEQUALIFIER_RCOMMAND) && (ep->ie_Qualifier & IEQUALIFIER_LCOMMAND))
				{
					ep->ie_Class = IECLASS_NULL;
					Signal (gdptr->TaskToSig,gdptr->QuitSig);
				}
	return (ev);
}

/*----------------------------- OpenStuff -----------------------------------*/

void OpenStuff ()
{
	SysBase = (APTR)*(LONG *)4;
	DOSBase = (struct DosLibrary *)OpenLibrary ("dos.library",0L);
	IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library",0L);
	GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library",0L);
	Global.QuitSigNum = Global.ActionSigNum = 0L;
	Global.TaskToSig = FindTask (0L);
	if ((Global.QuitSigNum = AllocSignal (-1L)) == -1L)
		{
			Print ("Error allocating signal\n");
			CloseStuff (4);
		}
	Global.QuitSig = 1L<<Global.QuitSigNum;
	if ((Global.ActionSigNum = AllocSignal (-1L)) == -1L)
		{
			Print ("Error allocating signal\n");
			CloseStuff (4);
		}
	Global.ActionSig = 1L<<Global.ActionSigNum;
	if (!(InputDevPort = CreatePort (0L,0L)))
		{
			Print ("Error creating InputDevPort\n");
			CloseStuff (1);
		}
	if (!(InputRequestBlock = CreateStdIO (InputDevPort)))
		{
			Print ("Error creating Standard IO\n");
			CloseStuff (2);
		}
	HandlerStuff.is_Data = (APTR)&Global;
	HandlerStuff.is_Code = (VOID (*)())MyHandler;
	HandlerStuff.is_Node.ln_Pri = 53;
	if (OpenDevice ("input.device",0L,(struct IORequest *)InputRequestBlock,0L))
		{
			Print ("Error opening Input.device\n");
			CloseStuff (3);
		}
	InputRequestBlock->io_Command = IND_ADDHANDLER;
	InputRequestBlock->io_Data = (APTR)&HandlerStuff;
	DoIO ((struct IORequest *)InputRequestBlock);
}

/*---------------------------- CloseStuff -----------------------------------*/

void __regargs CloseStuff (int Error)
{
	if (DOSBase) CloseLibrary ((struct Library *)DOSBase);
	if (IntuitionBase) CloseLibrary ((struct Library *)IntuitionBase);
	if (GfxBase) CloseLibrary ((struct Library *)GfxBase);
	if (Global.ActionSigNum) FreeSignal (Global.ActionSigNum);
	if (Global.QuitSigNum) FreeSignal (Global.QuitSigNum);
	if (InputRequestBlock)
		{
			InputRequestBlock->io_Command = IND_REMHANDLER;
			InputRequestBlock->io_Data = (APTR)&HandlerStuff;
			DoIO ((struct IORequest *)InputRequestBlock);
			CloseDevice ((struct IORequest *)InputRequestBlock);
			DeleteStdIO (InputRequestBlock);
		}
	if (InputDevPort) DeletePort (InputDevPort);
	Exit (Error);
}

/*================================ End ======================================*/
