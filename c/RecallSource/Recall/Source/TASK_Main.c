/*
 *	File:					TASK_Main.c
 *	Description:	Main window
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef	TASK_MAIN_C
#define	TASK_MAIN_C

/*** INCLUDES ************************************************************************/
#include "System_Prefs.h"
#include "Dirs.h"
#include "ProjectIO.h"
#include "PrefsIO.h"
#include "myinclude:Execute.h"
#include "MainMenu.h"
#include "myDoubleClick.h"
#include "Dirs.h"
#include "cursorHook.h"

/*** DEFINES *************************************************************************/
#define DIRPRESTRING			"» "

#define	GID_ADDEVENT			1
#define	GID_COPYEVENT			2
#define	GID_CUTEVENT			3
#define	GID_PASTEEVENT		4
#define	GID_ADDDIR				5
#define	GID_ROOT					6
#define	GID_PARENT				7
#define	GID_EVENTLISTVIEW	8
#define	GID_EVENTSTRING		9
#define	GID_CANCEL				10
#define GID_TEST					11
#define GID_SAVE					12
#define	GID_ENTERDIR			13

#define	ADDNEWMAIN				1
#define	ADDNEWDIR					2
#define	ADDNEWTEXT				3

/*** GLOBALS *************************************************************************/
struct egTask			mainTask;
UBYTE							progtitle[MAXCHARS],
									eventname[MAXCHARS],
									windowtitle[MAXCHARS];
WORD	rightgadsize, bottomgadsize;
UWORD								activeevent=0,
										pens[]={~0};

struct egGadget		*eventstring,
									*eventlistview,
									*addevent,
									*cutevent,
									*copyevent,
									*pasteevent,
									*adddir,
									*enterdir,
									*root,
									*parent,
									*save,
									*test,
									*cancel;
BYTE addflag;

struct EventNode	*eventnode		=NULL,
									*eventbuffer	=NULL,
									*oldeventnode	=NULL;
struct List				*eventlist,
									*rootlist;
ULONG							closemsg;

/*** FUNCTIONS ***********************************************************************/
__asm ULONG RenderMainTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	geta4();
	{
		register BYTE	noroot=IsNil(rootlist),
									nodir	=IsNil(dirlist);
		WORD 					posarray[3],
									sizearray[3];
	
#ifdef MYDEBUG_H
	DebugOut("RenderMainTask");
#endif

		egCreateContext(eg, &mainTask);
	
		addevent=egCreateGadget(eg,
									EG_Window,					mainTask.window,
									EG_GadgetKind,			BUTTON_KIND,
									EG_TextAttr,				fontattr,
									EG_Flags,						0,
									EG_Width,						rightgadsize,
									EG_DefaultHeight,		TRUE,
									EG_GadgetText,			GetString(&li, MSG__ADD),
									EG_PlaceWindowTop,	TRUE,
									EG_PlaceWindowRight,TRUE,
									EG_GadgetID,				GID_ADDEVENT,
									EG_HelpNode,				"AddMain",
									TAG_END);
		copyevent=egCreateGadget(eg,
									EG_PlaceBelow,			addevent,
									EG_GadgetText,			GetString(&li, MSG__COPY),
									EG_GadgetID,				GID_COPYEVENT,
									GA_Disabled,				eventnode==NULL,
									EG_HelpNode,				"Copy",
									TAG_END);
		cutevent=egCreateGadget(eg,
									EG_PlaceBelow,			copyevent,
									EG_GadgetText,			GetString(&li, MSG__CUT),
									EG_GadgetID,				GID_CUTEVENT,
									GA_Disabled,				eventnode==NULL,
									EG_HelpNode,				"Cut",
									TAG_END);
		pasteevent=egCreateGadget(eg,
									EG_PlaceBelow,			cutevent,
									EG_GadgetText,			GetString(&li, MSG__PASTE),
									EG_GadgetID,				GID_PASTEEVENT,
									GA_Disabled,				eventbuffer==NULL,
									EG_HelpNode,				"Paste",
									TAG_END);
		adddir=egCreateGadget(eg,
									EG_PlaceBelow,			pasteevent,
									EG_VSpace,					FontHeight,
									EG_GadgetText,			GetString(&li, MSG__MAKEDIR),
									EG_GadgetID,				GID_ADDDIR,
									EG_HelpNode,				"AddDir",
									TAG_END);
		enterdir=egCreateGadget(eg,
									EG_PlaceBelow,			adddir,
									EG_GadgetText,			GetString(&li, MSG__ENTERDIR),
									EG_GadgetID,				GID_ENTERDIR,
									GA_Disabled,				!(eventnode && eventnode->nn_Node.ln_Type==REC_DIR),
									EG_HelpNode,				"EnterDir",
									TAG_END);
		parent=egCreateGadget(eg,
									EG_PlaceBelow,			enterdir,
									EG_GadgetText,			GetString(&li, MSG__PARENT),
									EG_GadgetID,				GID_PARENT,
									GA_Disabled,				nodir,
									TAG_END);
		root=egCreateGadget(eg,
									EG_PlaceBelow,			parent,
									EG_GadgetText,			GetString(&li, MSG__ROOT),
									EG_GadgetID,				GID_ROOT,
									GA_Disabled,				nodir,
									EG_HelpNode,				"RootParent",
									TAG_END);
	
	sizearray[0]=sizearray[1]=sizearray[2]=bottomgadsize;
		egSpreadGadgets(posarray, sizearray, LeftMargin, X2(addevent), 3, TRUE);
	
	save=egCreateGadget(eg,
									EG_LeftEdge,				posarray[0],
									EG_Width,						bottomgadsize,
									EG_GadgetText,			GetString(&li, MSG__SAVE),
									EG_PlaceWindowBottom,	TRUE,
									EG_GadgetID,				GID_SAVE,
									EG_HelpNode,				"Save",
									GA_Disabled,				noroot,
									TAG_END);
	
	test=egCreateGadget(eg,
									EG_LeftEdge,				posarray[1],
									EG_GadgetText,			GetString(&li, MSG__TEST),
									EG_GadgetID,				GID_TEST,
									EG_HelpNode,				"Test",
									GA_Disabled,				noroot,
									TAG_END);
		cancel=egCreateGadget(eg,
									EG_LeftEdge,				posarray[2],
									EG_GadgetText,			GetString(&li, MSG__CANCEL),
									EG_HelpNode,				"Cancel",
									EG_GadgetID,				GID_CANCEL,
									TAG_END);	
	eventlistview=egCreateGadget(eg,
									EG_GadgetKind,			LISTVIEW_KIND,
									EG_LeftEdge,				LeftMargin,
									EG_TopEdge,					TopMargin,
									EG_Width,						X1(addevent)-LeftMargin-GadHSpace,
									EG_Height,					mainTask.window->Height-TopMargin-BottomMargin-GadVSpace-GadDefHeight*2,
									EG_GadgetID,				GID_EVENTLISTVIEW,
									EG_GadgetText,			NULL,
									EG_HelpNode,				"RecursiveDirs",
									EG_Arrows,					TRUE,
									GTLV_Labels,				eventlist,
									(KickStart<39 ? TAG_IGNORE : GTLV_ShowSelected),	NULL,
									GTLV_Selected,			activeevent,
									GTLV_MakeVisible,		activeevent,
									TAG_END);
		eventstring=egCreateGadget(eg,
									EG_GadgetKind,			STRING_KIND,
									EG_TopEdge,					Y2(eventlistview),
									EG_DefaultHeight,		TRUE,
									EG_GadgetID,				GID_EVENTSTRING,
									EG_HelpNode,				"AddMain",
									EG_Link,						eventlistview,
									GTST_MaxChars,			MAXCHARS,
									GTST_String,				eventname,
									GA_Disabled,				eventnode==NULL,
									GTST_EditHook,			(ULONG)&cursorHook,
									TAG_END);
	}
	return 1L;
}

__asm __saveds ULONG CloseGUIMainTask(register __a0 struct Hook *hook,
																			register __a2 APTR	      object,
																			register __a1 APTR	      message)
{
#ifdef MYDEBUG_H
	DebugOut("CloseGUIMainTask");
#endif

	geta4();

	if(!env.lockedscreen)
		CloseScreen(mainTask.screen);

	return 1L;
}

__asm ULONG CloseMainTask(	register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	geta4();

	if(ISBITSET(eg->flags, EG_ICONIFIED))
		closemsg=MSG_ICONIFY;
//	if(EasyRexxBase)
//		ARexxCommandShell(context, ER_Close, TRUE, TAG_DONE);
	if(SafeToQuit(closemsg, FALSE))
	{
		if(font)
			CloseFont(font);

		return 1L;
	}
	return 0L;
}


__asm __saveds ULONG OpenMainTask(register __a0 struct Hook *hook,
																	register __a2 APTR	      object,
																	register __a1 APTR	      message)
{
	WORD minwidth, minheight;
	register BYTE backdrop=(env.ownscreen && env.backdrop);

	geta4();
#ifdef MYDEBUG_H
	DebugOut("OpenMainTask");
#endif

	if(egTaskToFront(&mainTask))
			return FALSE;

	initCursorHook();

	mainTask.screen=NULL;

	if(!env.ownscreen)
	{
		env.lockedscreen=TRUE;

		if(NULL==(mainTask.screen=LockPubScreen(env.pubname)))
		{
			if(NULL==(mainTask.screen=LockPubScreen(NULL)))
			{
				env.ownscreen=TRUE;
				env.lockedscreen=FALSE;
			}
		}
		GetPubScreenName(mainTask.screen, env.pubname);
	}

	fontattr=&env.textAttr;
	if(!env.ownscreen && env.usescreenfont)
		fontattr=mainTask.screen->Font;

	if(OpenDiskFont(fontattr))
		font=OpenFont(fontattr);

	if(env.ownscreen)
	{
		mainTask.screen=OpenScreenTags(NULL,
				SA_Title,					(UBYTE *)NAME,
				SA_DisplayID,			env.screeninfo.DisplayID,
				SA_Width,					env.screeninfo.DisplayWidth,
				SA_Height,				env.screeninfo.DisplayHeight,
				SA_Depth,					env.screeninfo.DisplayDepth,
				SA_AutoScroll,		env.screeninfo.AutoScroll,
				SA_Overscan,			env.screeninfo.OverscanType,
				SA_Type,					PUBLICSCREEN,
				SA_PubName,				GetUniquePubScreenName(env.pubname, NAME),
				SA_Font,					fontattr,
				SA_Interleaved,		TRUE,
				SA_MinimizeISG,		TRUE,
				SA_LikeWorkbench,	TRUE,
				SA_SharePens,			TRUE,
				(KickStart<39 ? SA_Pens:TAG_IGNORE), pens,
				TAG_DONE);
		LoadRGB4(&mainTask.screen->ViewPort, env.colors, MAXCOLORS);
		env.lockedscreen=FALSE;

		DefaultPubScreen(mainTask.screen, env.pubname, env.shanghai);
	}

	if(mainTask.screen)
	{
		egInitialize(eg, mainTask.screen, font);

		rightgadsize=egMaxLen(eg,		GetString(&li, MSG__ADD),
																GetString(&li, MSG__COPY),
																GetString(&li, MSG__CUT),
																GetString(&li, MSG__PASTE),
																GetString(&li, MSG__MAKEDIR),
																GetString(&li, MSG__ENTERDIR),
																GetString(&li, MSG__ROOT),
																GetString(&li, MSG__PARENT),
																NULL)+GadHInside;
		bottomgadsize=egMaxLen(eg,	GetString(&li, MSG__SAVE),
																GetString(&li, MSG__TEST),
																GetString(&li, MSG__CANCEL),
																NULL)+GadHInside;
		if(backdrop)
		{
			mainTask.coords.LeftEdge=0;
			mainTask.coords.TopEdge	=0;
			mainTask.coords.Width		=mainTask.screen->Width;
			mainTask.coords.Height	=mainTask.screen->Height;
		}
		else
		{
			minwidth=LeftMargin+MAX(rightgadsize*2+GadHSpace, bottomgadsize*3+GadHSpace*2)+RightMargin;
			minheight=TopMargin+GadDefHeight*9+GadVSpace*8+FontHeight*2+BottomMargin;
		}

		if(egOpenTask(&mainTask,
								(backdrop ? TAG_IGNORE:WA_Title),					(UBYTE *)NAME,
								(backdrop ? TAG_IGNORE:WA_Width),					MAX(minwidth, mainTask.coords.Width),
								(backdrop ? TAG_IGNORE:WA_Height),				MAX(minheight, mainTask.coords.Height),
								(backdrop ? TAG_IGNORE:WA_MinWidth),			minwidth,
								(backdrop ? TAG_IGNORE:WA_MinHeight),			minheight,
								(backdrop ? TAG_IGNORE:WA_MaxWidth),			~0,
								(backdrop ? TAG_IGNORE:WA_MaxHeight),			~0,
								WA_AutoAdjust,		TRUE,
								(backdrop ? TAG_IGNORE:WA_DragBar),				TRUE,
								(backdrop ? TAG_IGNORE:WA_DepthGadget),		TRUE,
								(backdrop ? TAG_IGNORE:WA_SizeGadget),		TRUE,
								(backdrop ? TAG_IGNORE:WA_SizeBBottom),		TRUE,
								(backdrop ? TAG_IGNORE:WA_CloseGadget),		TRUE,
								(backdrop ? WA_Backdrop:TAG_IGNORE),			TRUE,
								(backdrop ? WA_Borderless:TAG_IGNORE),		TRUE,
								WA_PubScreen,			mainTask.screen,
								WA_SimpleRefresh,	env.simplerefresh,
								WA_Activate,			TRUE,
								EG_Menu,					mainMenu,
//								EG_HelpMenu,			TRUE,
								EG_IDCMP,					IDCMP_MENUPICK			|
																	LISTVIEWIDCMP				|
																	CHECKBOXIDCMP				|
																	GADGETUP						|
																	GADGETDOWN					|
																	IDCMP_MOUSEBUTTONS	|
																	IDCMP_CLOSEWINDOW		|
																	STRINGIDCMP,
								EG_CloseGUIFunc,	(ULONG)CloseGUIMainTask,
								EG_OpenFunc,			(ULONG)OpenMainTask,
								EG_CloseFunc,			(ULONG)CloseMainTask,
								EG_RenderFunc,		(ULONG)RenderMainTask,
								EG_HandleFunc,		(ULONG)HandleMainTask,
								(backdrop ? TAG_IGNORE:EG_IconifyGadget),	TRUE,
								(backdrop ? TAG_IGNORE:EG_InitialUpperLeft),	TRUE,

								TAG_END))
		{
			ScreenToFront(mainTask.screen);
			if(env.lockedscreen)
				UnlockPubScreen(NULL, mainTask.screen);
			closemsg=MSG_QUIT;
			oldeventnode=NOEVENT;
			return TRUE;
		}
	}
	return FALSE;
}

__asm ULONG HandleMainTask(register __a0 struct Hook *hook,
														register __a2 APTR	      object,
														register __a1 APTR	      message)
{
	struct IntuiMessage *msg;

	geta4();
	msg=eg->msg;

	switch(msg->Class)
	{
		case IDCMP_MENUPICK:
			HandleMainMenu(&mainTask, msg->Code);
			break;

		case IDCMP_CLOSEWINDOW:
			Quit();
			break;
	
			case EGIDCMP_NOTIFY:
				if(env.lockedscreen)
					switch(msg->Code)
					{
						case SCREENNOTIFY_TYPE_WORKBENCH:
							if(0==stricmp(env.pubname, "Workbench"))
								switch((BYTE)msg->IAddress)
								{
									case FALSE:
										SETBIT(eg->flags, EG_RESET);
										egCloseAllTasks(eg);
										break;
									case TRUE:
										if(!ISBITSET(eg->flags, EG_ICONIFIED))
										{
											egOpenAllTasks(eg);
											CLEARBIT(eg->flags, EG_RESET);
										}
										break;
								}
							break;
						case SCREENNOTIFY_TYPE_CLOSESCREEN:
							if(((struct Screen *)msg->IAddress)==mainTask.screen)
							{
								egCloseAllTasks(eg);
								Delay(50L);
								egOpenAllTasks(eg);
							}
							break;
						case SCREENNOTIFY_TYPE_PRIVATESCREEN:
							if(((struct PubScreenNode *)msg->IAddress)->psn_Screen==mainTask.screen)
							{
								egCloseAllTasks(eg);
								Delay(50L);
								egOpenAllTasks(eg);
							}
							break;
					}
				break;
			case IDCMP_LISTVIEWCURSOR:
				switch(((struct Gadget *)msg->IAddress)->GadgetID)
				{
					case GID_EVENTSTRING:
						if(Stricmp(String(eventstring), eventnode->nn_Node.ln_Name))
							RenameEvent(String(eventstring));
						egHandleListviewArrows(eventlistview, mainTask.window, msg);
						msg->Code=eventlistview->active;
						ClearDoubleClick();
						GetSelectedEvent(msg);
						egActivateGadget(eventstring, mainTask.window, NULL);
						break;
				}
				break;

		case IDCMP_RAWKEY:
			if(eventnode)
				switch(egConvertRawKey(msg))
				{
					case RETURN_KEY:
						egActivateGadget(eventstring, mainTask.window, NULL);
						break;
				}
			break;

		case IDCMP_GADGETDOWN:
		case IDCMP_GADGETUP:
			switch(((struct Gadget *)msg->IAddress)->GadgetID)
			{
				case GID_EVENTLISTVIEW:
					GetSelectedEvent(msg);
					break;
				case GID_EVENTSTRING:
					RenameEvent(String(eventstring));
					break;
				case GID_ADDEVENT:
					AddEvent(GID_ADDEVENT, "\0");
					break;
				case GID_COPYEVENT:
					CopyEvent();
					break;
				case GID_CUTEVENT:
					if(AttemptSemaphore(eventsemaphore))
					{
						CutEvent();
						ReleaseSemaphore(eventsemaphore);
					}
//					else
//						SEMAPHOREFAIL();
					break;
				case GID_PASTEEVENT:
					PasteEvent();
					break;
				case GID_ADDDIR:
					AddEvent(GID_ADDDIR, DIRPRESTRING);
					break;
				case GID_ENTERDIR:
					ShowChildren(eventnode);
					break;
				case GID_ROOT:
					ShowRoot();
					break;
				case GID_PARENT:
					ShowParent();
					break;

				case GID_SAVE:
					SaveProject(rootlist, project);
					if(SafeToQuit(STATUS_CLOSED, FALSE))
						egCloseAllTasks(eg);
					break;
				case GID_TEST:
					TestProject();
					break;
				case GID_CANCEL:
					Quit();
					break;
			}
			break;
	}
	return 1L;
}

void UpdateMainTask(void)
{
#ifdef MYDEBUG_H
	DebugOut("UpdateMainTask");
#endif

	if(mainTask.window)
	{
		BYTE 	flag,  noneselected=(eventnode==NULL);

		egSetGadgetAttrs(copyevent, mainTask.window, NULL,
											GA_Disabled,	noneselected,
											TAG_DONE);
		egSetGadgetAttrs(cutevent, mainTask.window, NULL,
											GA_Disabled,	noneselected,
											TAG_DONE);
		egSetGadgetAttrs(pasteevent, mainTask.window, NULL,
											GA_Disabled,	eventbuffer==NULL,
											TAG_DONE);
		if(noneselected)
			*eventname='\0';
		else
			strcpy(eventname, (eventnode ? eventnode->nn_Node.ln_Name : NULL));

		egSetGadgetAttrs(eventstring, mainTask.window, NULL,
											GTST_String,	eventname,
											GA_Disabled,	noneselected,
											TAG_DONE);

		flag=IsNil(rootlist);

		egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
											GTLV_Labels,			eventlist,
											GTLV_Selected,		activeevent,
											GTLV_MakeVisible,	activeevent,
											TAG_DONE);
		egSetGadgetAttrs(save, mainTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);
		egSetGadgetAttrs(test, mainTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);

		flag=(IsNil(dirlist) ? TRUE:FALSE);
		egSetGadgetAttrs(root, mainTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);
		egSetGadgetAttrs(parent, mainTask.window, NULL,
											GA_Disabled,	flag,
											TAG_DONE);
		egSetGadgetAttrs(enterdir, mainTask.window, NULL,
											GA_Disabled,	!(eventnode && eventnode->nn_Node.ln_Type==REC_DIR),
											TAG_DONE);
	}
}

void ResetMainWindow(void)
{
#ifdef MYDEBUG_H
	DebugOut("ResetMainWindow");
#endif

	*eventname='\0';
	eventnode=NULL;
	activeevent=EG_LISTVIEW_NONE;
/*
	if(mainTask.status)
		egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
											GA_Selected,	activeevent,
											TAG_DONE);
*/
}

void CopyEvent(void)
{
	CopyNode(eventlist, &eventbuffer, (struct Node *)eventnode);
	UpdateMainTask();
/*
	if(record)
		AddARexxMacroCommand(	macro,
													ER_Command,	"COPY",
													TAG_DONE);
*/
}

void CutEvent(void)
{

#ifdef MYDEBUG_H
	DebugOut("CutEvent");
#endif

	egLockTask(&mainTask, TAG_DONE);
	DetachList(eventlistview, mainTask.window);
	if(eventnode=(struct EventNode *)CutNode(eventlist, &eventbuffer, eventnode))
		activeevent
					=(UWORD)egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
																GTLV_SelectedNode,	eventnode,
																TAG_DONE);
//	else
//		ResetAllWindows();
	AttachList(eventlistview, mainTask.window, eventlist);
	GetFirstText();
	GetFirstDate();
	UpdateAllTasks();
	UpdateMainMenu();
	++env.changes;
	egUnlockTask(&mainTask, TAG_DONE);
}

void PasteEvent(void)
{
#ifdef MYDEBUG_H
	DebugOut("PasteEvent");
#endif
	DetachList(eventlistview, mainTask.window);
	eventnode=(struct EventNode *)PasteNode(eventlist, eventbuffer, eventnode);
	AttachList(eventlistview, mainTask.window, eventlist);
	activeevent=(UWORD)egSetGadgetAttrs(eventlistview, mainTask.window, NULL,
																			GTLV_SelectedNode,	eventnode,
																			TAG_DONE);
	strcpy(eventname, (eventnode ? eventnode->nn_Node.ln_Name : NULL));
	GetFirstText();
	GetFirstDate();
	UpdateAllTasks();
	UpdateMainMenu();
	++env.changes;
}

void NewProject(BYTE force)
{
	if(AttemptSemaphore(eventsemaphore))
	{
		if(ConfirmActions(MSG_CLEAR, force))
		{
			DetachList(eventlistview, mainTask.window);
			ClearList(rootlist);
			ClearList(dirlist);
			eventlist=rootlist;
			AttachList(eventlistview, mainTask.window, rootlist);
			GetFirstEvent();
			GetFirstText();
			GetFirstDate();
			UpdateAllTasks();
			UpdateMainMenu();
			env.changes=0;
		}
		ReleaseSemaphore(eventsemaphore);
	}
//	else
//		SEMAPHOREFAIL();
}

void TestProject(void)
{
/*
	UBYTE command[500], file[MAXCHARS];

	egLockAllTasks(eg);
	if(WriteIFF(rootlist, TESTFILE)==0)
	{
		strcpy(file, startdir);
		AddPart(file, NAME, MAXCHARS-1);
		sprintf(command, "\"%s\" "	FROM_TOOLTYPE					"=%s "
																LANGUAGE_TOOLTYPE 		"=%s "
																USEREQTOOLS_TOOLTYPE	"=%s",
																file, TESTFILE,
																(*language=='*' ? "english":language),
																(usereqtools ? "TRUE":"FALSE"));
		StartCLIProgram(command, "RAM:T", 4096, 0, FALSE);
		DeleteFile(TESTFILE);
		egRequest(mainTask.window,
							NAME " " VERS,
							GetString(&li, MSG_ENDOFPROJECT),
							GetString(&li, MSG_OK),
							NULL);
	}
	egUnlockAllTasks(eg);
*/
}

void RenameEvent(UBYTE *name)
{
#ifdef MYDEBUG_H
	DebugOut("RenameEvent");
#endif

	if(eventnode)
	{
		RenameNode((struct Node *)eventnode, name);
	}
	UpdateMainTask();
}

void GetFirstEvent(void)
{
#ifdef MYDEBUG_H
	DebugOut("GetFirstEvent");
#endif

	if(!IsNil(eventlist) && (eventnode=(struct EventNode *)GetHead(eventlist)))
	{
		textlist=eventnode->textlist;
		datelist=eventnode->datelist;
		GetFirstText();
		GetFirstDate();
		activeevent=0;
	}
	else
	{
		datelist=textlist=NULL;
		eventnode=NULL;
		activeevent=~0;
	}
}

void GetSelectedEvent(struct IntuiMessage *msg)
{
	if(eventnode=(struct EventNode *)egGetNode(eventlist, activeevent=msg->Code))
	{
		if(	eventnode->nn_Node.ln_Type==REC_DIR &&
				CheckDoubleClick(msg, activeevent))
			ShowChildren(eventnode);
		if(oldeventnode!=eventnode)
		{
			GetFirstText();
			GetFirstDate();
			UpdateAllTasks();
			oldeventnode=eventnode;
		}
	}
}

void AddEvent(UBYTE type, UBYTE *name)
{
	if(type==GID_ADDDIR)
		oldeventnode=eventnode=AddDirNode(eventlist, eventnode, name);
	else
		oldeventnode=eventnode=AddEventNode(eventlist, eventnode, name);

	if(eventnode)
	{
		GetFirstText();
		GetFirstDate();
		if(activeevent==~0)
			activeevent=MAX(0, Count(eventlist)-1);
		else
			++activeevent;
		UpdateAllTasks();
		BufferPos(eventstring)=strlen(String(eventstring));
		egActivateGadget(eventstring, mainTask.window, NULL);
		UpdateMainMenu();
		UpdateAboutTask();
		++env.changes;
/*
		if(record)
			AddARexxMacroCommand(	macro,
														ER_Command,	"ADD",
														TAG_DONE);
*/
	}
}

#endif

