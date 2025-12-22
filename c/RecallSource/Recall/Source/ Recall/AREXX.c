/*
 *	File:					AREXX.c
 *	Description:	Defines the set of AREXX commands understood by Recall.
 *								97 AREXX commands defined
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef AREXX_C
#define AREXX_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "ARexx.h"

/*** DEFINES *************************************************************************/
#define AREXX_NEW							1
#define AREXX_OPEN						2
#define AREXX_INCLUDE					3
#define AREXX_IMPORT					4
#define AREXX_SAVE						5
#define AREXX_SAVEAS					6
#define AREXX_EXPORT					7
#define AREXX_QUIT						8
#define AREXX_TEST						9
#define AREXX_HELP						10

#define AREXX_MAKEDIR					11
#define AREXX_CUT							12
#define AREXX_PASTE						13

#define AREXX_ROOT						14
#define AREXX_PARENT					15

#define AREXX_LASTSAVED				16
#define AREXX_OPERATE					17
#define AREXX_DISPLAY					18

#define AREXX_FIND						19
#define AREXX_FINDNEXT				20
#define AREXX_FINDCHANGE			21
#define AREXX_CHANGENEXT			22

#define AREXX_USESCREEN				23
#define AREXX_REFRESH					24
#define AREXX_CLOSEWB					25

#define AREXX_SCREENMODE			26
#define AREXX_FONT						27

#define AREXX_SAVEWHENEXIT		28
#define AREXX_ACKNOWLEDGE			29
#define AREXX_AFFECTALLEVENTS	30
#define AREXX_PARSEDIRS				31

#define AREXX_GROUP						32
#define AREXX_FLASH						33
#define AREXX_CONFIRM					34
#define AREXX_POSTPONE				35
#define AREXX_MULTITASK				36
#define AREXX_CENTRE					37
#define AREXX_TYPECYCLE				38
#define AREXX_SHOWCYCLE				39
#define AREXX_SCREEN					40
#define AREXX_DIR							41
#define AREXX_STACK						42
#define AREXX_PRIORITY				43
#define AREXX_TIMEOUT					44

#define AREXX_GETFILE					45
#define AREXX_GETFIELD				46

#define AREXX_DAY							47
#define AREXX_MONTH						48
#define AREXX_YEAR						49
#define AREXX_WEEKDAY					50

#define AREXX_HOUR						51
#define AREXX_MINUTE					52

#define AREXX_PERIOD					53
#define AREXX_REPEAT					54

#define AREXX_WHEN						55

#define AREXX_RECALLTOFRONT		56
#define AREXX_RECALLTOBACK		57
#define AREXX_WINDOW					58
#define AREXX_MOVEWINDOW			59
#define AREXX_SIZEWINDOW			60
#define AREXX_CHANGEWINDOW		61
#define AREXX_ICONIFY					62
#define AREXX_UNICONIFY				63

#define AREXX_LEARN						64
#define AREXX_REQUESTNOTIFY		65
#define AREXX_REQUESTRESPONSE	66

#define	AREXX_LOCKGUI					67
#define	AREXX_UNLOCKGUI				68

/*** GLOBALS *************************************************************************/
struct ARexxContext *arexxcontext;
BYTE lockgui=FALSE;

struct ARexxCommandTable commandTable[]=
{
	AREXX_NEW,						"NEW",							"PROJECT/S,EVENT/S,DIR/S,TEXT/S,DATE/S,FORCE/S,NAME/F",	NULL,
	AREXX_OPEN,						"OPEN",							"PROJECT/S,SETTINGS/S,NAME,FORCE/S",	NULL,
	AREXX_INCLUDE,				"INCLUDE",					"NAME/F",													NULL,
//	AREXX_IMPORT,					"IMPORT",						"TYPE/A,NAME/F",									NULL,
	AREXX_SAVE,						"SAVE",							"PROJECT/S,SETTINGS/S",						NULL,
	AREXX_SAVEAS,					"SAVEAS",						"PROJECT/S,SETTINGS/S,NAME/F",		NULL,
//	AREXX_EXPORT,					"EXPORT",						"TYPE/A,NAME/F",									NULL,
	AREXX_QUIT,						"QUIT",							"FORCE/S",												NULL,
	AREXX_TEST,						"TEST",							NULL,															NULL,
	AREXX_HELP,						"HELP",							"TOPIC/F",												NULL,

	AREXX_MAKEDIR,				"MAKEDIR",					"NAME/F",													NULL,
	AREXX_CUT,						"CUT",							"EVENT/S,TEXT/S,DATE/S",					NULL,
	AREXX_PASTE,					"PASTE",						"EVENT/S,TEXT/S,DATE/S",					NULL,

	AREXX_ROOT,						"ROOT",							NULL,															NULL,
	AREXX_PARENT,					"PARENT",						NULL,															NULL,

	AREXX_LASTSAVED,			"LASTSAVED",				"FORCE/S",												NULL,
//	AREXX_OPERATE,				"OPERATE",					"TYPE/A,NAME/F",								NULL,
//	AREXX_DISPLAY,				"DISPLAY",					"TYPE/A,NAME/F",								NULL,

//	AREXX_FIND,						"FIND",							"NEXT/S,PROMPT/S,IGNORECASE/S,WORDS/S,TEXT/F",							NULL,
//	AREXX_FINDCHANGE,			"FINDCHANGE",				"NEXT/S,PROMPT/S,IGNORECASE/S,WORDS/S,ALL/S,FIND,CHANGE",			NULL,
//	AREXX_FINDCHANGE,			"REPLACE",					"NEXT/S,PROMPT/S,IGNORECASE/S,WORDS/S,ALL/S,FIND,CHANGE",			NULL,

	AREXX_USESCREEN,			"USESCREEN",				"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_REFRESH,				"REFRESH",					"SIMPLE/S,SMART/S,TOGGLE/S,CLEAR/S",		NULL,
	AREXX_CLOSEWB,				"CLOSEWB",					"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,

//	AREXX_SCREENMODE,			"SCREENMODE",				NULL,															NULL,
	AREXX_FONT,						"FONT",							"NAME/A,SIZE/A/N,PLAIN/S,BOLD/S,UNDERLINED/S,ITALIC/S",	NULL,

	AREXX_SAVEWHENEXIT,		"SAVEWHENEXIT",			"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_ACKNOWLEDGE,		"ACKNOWLEDGE",			"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_AFFECTALLEVENTS,"AFFECTALLEVENT",		"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_PARSEDIRS,			"PARSEDIRS",				"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,

	AREXX_GROUP,					"GROUP",						"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_FLASH,					"FLASH",						"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_CONFIRM,				"CONFIRM",					"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_POSTPONE,				"POSTPONE",					"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_MULTITASK,			"MULTITASK",				"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
	AREXX_CENTRE,					"CENTRE",						"ON/S,OFF/S,TRUE/S,FALSE/S,TOGGLE/S,CLEAR/S",	NULL,
//	AREXX_TYPECYCLE,		"TYPE",							"NUMBER/N,NAME/F",										NULL,
//	AREXX_SHOWCYCLE,		"SHOW",							"NUMBER/N,NAME/F",										NULL,
	AREXX_SCREEN,					"SCREEN",						"NAME/A/F",														NULL,
	AREXX_DIR,						"DIR",							"NAME/A/F",														NULL,
	AREXX_STACK,					"STACK",						"SIZE/A/N",														NULL,
	AREXX_PRIORITY,				"PRIORITY",					"PRI/A/N",														NULL,
	AREXX_TIMEOUT,				"TIMEOUT",					"TIME/A/N",														NULL,

	AREXX_GETFILE,				"GETFILE",					"FILENAME/F",														NULL,
//	AREXX_GETFIELD,				"GETFIELD",					"NUMBER/N,FIELD/F",										NULL,

	AREXX_DAY,						"DAY",							"DAY/N,ANY=ALL/S",												NULL,
	AREXX_MONTH,					"MONTH",						"NUMBER/N,JANUARY/S,FEBRUARY/S,MARCH/S,APRIL/S,MAY/S,JUNE/S,JULY/S,AUGUST/S,SEPTEMBER/S,OCTOBER/S,NOVEMBER/S,DECEMBER/S,ANY=ALL/S",	NULL,
	AREXX_YEAR,						"YEAR",							"NUMBER/N,ANY=ALL/S",														NULL,
//	AREXX_WEEKDAY,				"WEEKDAY",					"MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,ON/S,OFF/S,TRUE/S,FALSE/S,CLEAR/S",	NULL,

	AREXX_HOUR,						"HOUR",							"NUMBER/N,ANY/S",											NULL,
	AREXX_MINUTE,					"MINUTE",						"NUMBER/N,ANY/S",											NULL,

	AREXX_PERIOD,					"PERIOD",						"DATE/S,TIME/S,VALUE/A/N",						NULL,
	AREXX_REPEAT,					"REPEAT",						"DATE/S,TIME/S,VALUE/A/N",						NULL,

	AREXX_WHEN,						"WHEN",							"DATE/S,TIME/S,EXACT/S,BEFORE/S,AFTER/S",	NULL,

	AREXX_RECALLTOFRONT,	"RECALLTOFRONT",		NULL,																	NULL,
	AREXX_RECALLTOBACK,		"RECALLTOBACK",			NULL,																	NULL,
	AREXX_WINDOW,					"WINDOW",						"EVENT/S,TEXT/S,DATE/S,ATTRIBUTES/S,OPEN/S,CLOSE/S,ACTIVATE/S,ZOOM/S,FRONT/S,BACK/S",	NULL,
	AREXX_MOVEWINDOW,			"MOVEWINDOW",				"EVENT/S,TEXT/S,DATE/S,ATTRIBUTES/S,LEFTEDGE/A/N,TOPEDGE/A/N",								NULL,
//	AREXX_SIZEWINDOW,			"SIZEWINDOW",				"EVENT/S,TEXT/S,DATE/S,ATTRIBUTES/S,WIDTH/N,HEIGHT/N",										NULL,
//	AREXX_CHANGEWINDOW,		"CHANGEWINDOW",			"EVENT/S,TEXT/S,DATE/S,ATTRIBUTES/S,LEFTEDGE/N,TOPEDGE/N,WIDTH/N,HEIGHT/N",	NULL,
	AREXX_ICONIFY,				"ICONIFY",					NULL,																	NULL,
	AREXX_ICONIFY,				"DEACTIVATE",				NULL,																	NULL,
	AREXX_UNICONIFY,			"UNICONIFY",				NULL,																	NULL,
	AREXX_UNICONIFY,			"ACTIVATE",					NULL,																	NULL,

//	AREXX_LEARN,					"LEARN",						"STOP/S,FILENAME/F",									NULL,
	AREXX_REQUESTNOTIFY,	"REQUESTNOTIFY",		"TEXT/A/F",														NULL,
	AREXX_REQUESTNOTIFY,	"OKAY1",						"TEXT/A/F",														NULL,
	AREXX_REQUESTRESPONSE,"REQUESTRESPONSE",	"TEXT/A/F",														NULL,
	AREXX_REQUESTRESPONSE,"OKAY2",						"TEXT/A/F",														NULL,

	TABLE_END,
};

/*** FUNCTIONS ***********************************************************************/
LONG HandleAREXX(struct ARexxContext *c)
{
	LONG result=RC_OK;
//	BYTE force=FALSE;
//	UBYTE *tmpstring;
//	LONG tmpnum;

	if(EasyRexxBase==NULL)
		return RC_FATAL;

	if(GetARexxMsg(c))
	{
		LONG result=RC_OK;

		switch(c->id)
		{
			case AREXX_RECALLTOFRONT:
				ScreenToFront(recallscreen);
				break;
			case AREXX_RECALLTOBACK:
				ScreenToBack(recallscreen);
				break;
			case AREXX_REQUESTNOTIFY:
				egRequest(eventTask.window,
												PROGTITLE,
												ARGSTRING(c,0),
												GetString(&li, MSG_OK),
												NULL);
				break;
			case AREXX_REQUESTRESPONSE:
				if(0==egRequest(eventTask.window,
												PROGTITLE,
												ARGSTRING(c,0),
												GetString(&li, MSG_OKCANCEL),
												NULL))
					result=RC_WARN;
				break;
			case AREXX_NEW:
				if(ARG(c, 1))
					AddEvent(eventlist, ARGSTRING(c, 5));
				else if(ARG(c, 2))
					AddDir(eventlist, ARGSTRING(c, 5));
				else if(ARG(c, 3))
					AddNode(eventlist, ARGSTRING(c, 5));
				else if(ARG(c, 4))
					NewDate();
				else
					NewProject(ARGBOOL(c, 6));
				break;
			case AREXX_OPEN:
				if(ARG(c, 1))
				{
					if(ARG(c, 2))
						ReadGUI(&guiconfig, ARGSTRING(c, 3));
					else
						OpenGUI(&guiconfig, guiname);
				}
				else
				{
					if(ARG(c, 2))
					{
						ClearList(rootlist);
						ReadIFF(rootlist, project);
					}
					else
						OpenProject(rootlist, project, ARGBOOL(c, 3));
				}
				break;
			case AREXX_INCLUDE:
				if(ARGBOOL(c, 1))
					ReadIFF(eventlist, ARGSTRING(c, 1));
				else
					IncludeProject(eventlist, project);
				UpdateEventWindow();
				break;
			case AREXX_SAVE:
				if(ARG(c, 1))
				{
					WriteGUI(&guiconfig, RECGUIENVARC);
					WriteGUI(&guiconfig, RECGUIENV);
				}
				else
					SaveProject(rootlist, prefsfile);
				break;
			case AREXX_SAVEAS:
				if(ARG(c, 2))
				{
					if(ARG(c, 1))
						WriteGUI(&guiconfig, ARGSTRING(c, 2));
					else
						SaveGUI(&guiconfig, guiname);
				}
				else
				{
					if(ARG(c, 2))
						SaveProjectAs(rootlist, project);
					else
						SaveProject(rootlist, ARGSTRING(c, 2));
				}
				break;
			case AREXX_TEST:
				TestProject();
				break;
			case AREXX_QUIT:
				eventTask.status=STATUS_CLOSED;
				break;
			case AREXX_HELP:
				if(ARG(c, 0))
					egShowAmigaGuide(eg, ARGSTRING(c, 0));
				else
					egShowAmigaGuide(eg, "MAIN");
			case AREXX_MAKEDIR:
				AddDir(eventlist, ARGSTRING(c, 0));
				break;

			case AREXX_CUT:
				if(ARG(c, 1))
				{
					if(textnode)
						CutText();
				}
				else if(ARG(c, 2))
				{
					if(datenode)
						CutDate();
				}
				else
					if(eventnode)
						CutEvent();
				break;
			case AREXX_PASTE:
				if(ARG(c, 1))
				{

						PasteText();
				}
				else if(ARG(c, 2))
				{
					if(datebuffer)
						PasteDate();
				}
				else
					if(eventbuffer)
						PasteEvent();
				break;

			case AREXX_ROOT:
				ShowRoot();
				break;
			case AREXX_PARENT:
				ShowParent();
				break;
			case AREXX_LASTSAVED:
				LastSaved(ARGBOOL(c, 0));
				break;
			case AREXX_USESCREEN:
				guiconfig.usescreen=GetSwitch(c, guiconfig.usescreen);
				break;
			case AREXX_CLOSEWB:
				guiconfig.closewb=GetSwitch(c, guiconfig.closewb);
				break;
			case AREXX_SAVEWHENEXIT:
				guiconfig.savewhenexit=GetSwitch(c, guiconfig.savewhenexit);
				break;
			case AREXX_ACKNOWLEDGE:
				guiconfig.acknowledge=GetSwitch(c, guiconfig.acknowledge);
				break;
			case AREXX_AFFECTALLEVENTS:
				guiconfig.affectall=GetSwitch(c, guiconfig.affectall);
				break;
			case AREXX_PARSEDIRS:
				guiconfig.parsedirs=GetSwitch(c, guiconfig.parsedirs);
				break;
			case AREXX_GROUP:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, GROUP)), eventnode->flags, GROUP);
				break;
			case AREXX_FLASH:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, FLASH)), eventnode->flags, FLASH);
				break;
			case AREXX_CONFIRM:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, CONFIRM)), eventnode->flags, CONFIRM);
				break;
			case AREXX_POSTPONE:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, POSTPONE)), eventnode->flags, POSTPONE);
				break;
			case AREXX_MULTITASK:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, MULTITASK)), eventnode->flags, MULTITASK);
				break;
			case AREXX_CENTRE:
				if(eventnode)
					IFTRUESETBIT(GetSwitch(c, ISBITSET(eventnode->flags, CENTRE)), eventnode->flags, CENTRE);
				break;
			case AREXX_SCREEN:
				if(eventnode)
					strcpy(eventnode->screen, ARGSTRING(c, 0));
				break;
			case AREXX_DIR:
				if(eventnode)
					strcpy(eventnode->dir, ARGSTRING(c, 0));
				break;

			case AREXX_PRIORITY:
				if(eventnode)
					eventnode->priority=(ULONG)ARGNUMBER(c, 0);
				break;
			case AREXX_STACK:
				if(eventnode)
					eventnode->stack=(ULONG)ARGNUMBER(c, 0);
				break;
			case AREXX_TIMEOUT:
				if(eventnode)
					eventnode->timeout=(ULONG)ARGNUMBER(c, 0);
				break;

			case AREXX_DAY:
				if(datenode)
				{
					if(ARG(c,1))
						datenode->day=0;
					else
						datenode->day=(BYTE)ARGNUMBER(c, 0);
				}
				break;
			case AREXX_MONTH:
				if(datenode)
				{
					if(ARG(c, 13))
						datenode->month=0;
					else if(ARG(c, 0))
						datenode->month=(BYTE)ARGNUMBER(c, 0);
					else if(ARG(c, 1))
						datenode->month=1;
					else if(ARG(c, 2))
						datenode->month=2;
					else if(ARG(c, 3))
						datenode->month=3;
					else if(ARG(c, 4))
						datenode->month=4;
					else if(ARG(c, 5))
						datenode->month=5;
					else if(ARG(c, 6))
						datenode->month=6;
					else if(ARG(c, 7))
						datenode->month=7;
					else if(ARG(c, 8))
						datenode->month=8;
					else if(ARG(c, 9))
						datenode->month=9;
					else if(ARG(c, 10))
						datenode->month=10;
					else if(ARG(c, 11))
						datenode->month=11;
					else if(ARG(c, 12))
						datenode->month=12;
				}
				break;
			case AREXX_YEAR:
				if(datenode)
				{
					if(ARG(c,1))
						datenode->year=0;
					else
						datenode->year=(BYTE)ARGNUMBER(c, 0);
				}
				break;
			case AREXX_HOUR:
				if(datenode)
				{
					if(ARG(c,1))
						datenode->hour=0;
					else
						datenode->hour=(BYTE)ARGNUMBER(c, 0);
				}
				break;
			case AREXX_MINUTE:
				if(datenode)
				{
					if(ARG(c,1))
						datenode->minutes=0;
					else
						datenode->minutes=(BYTE)ARGNUMBER(c, 0);
				}
				break;
			case AREXX_PERIOD:
				if(datenode)
					if(ARG(c, 1))
						datenode->whentime=(BYTE)ARGNUMBER(c, 2);
					else
						datenode->whendate=(BYTE)ARGNUMBER(c, 2);
				break;
			case AREXX_REPEAT:
				if(datenode)
					if(ARG(c, 1))
						datenode->timerepeat=(BYTE)ARGNUMBER(c, 2);
					else
						datenode->daterepeat=(BYTE)ARGNUMBER(c, 2);
				break;
			case AREXX_WHEN:
				if(datenode)
					if(ARG(c, 1))
					{
						if(ARG(c, 2))
							datenode->whentime=0;
						else if(ARG(c, 3))
							datenode->whentime=1;
						else if(ARG(c, 4))
							datenode->whentime=2;
					}
					else
					{
						if(ARG(c, 2))
							datenode->whendate=0;
						else if(ARG(c, 3))
							datenode->whendate=1;
						else if(ARG(c, 4))
							datenode->whendate=2;
					}
				break;

			case AREXX_ICONIFY:
				eventTask.status=STATUS_ICONIFY;
				break;

			case AREXX_LOCKGUI:
				lockgui=TRUE;
				break;
			case AREXX_UNLOCKGUI:
				lockgui=FALSE;
				break;

			case AREXX_REFRESH:
				if(ARG(c, 1) | ARG(c, 3))
					guiconfig.simplerefresh=FALSE;
				else if(ARG(c, 0))
					guiconfig.simplerefresh=TRUE;
				else if(ARG(c, 2))
					guiconfig.simplerefresh=!guiconfig.simplerefresh;
				break;
			case AREXX_WINDOW:
				if(ARG(c, 4) | ARG(c, 6))
				{
					if(ARG(c, 0))
						OpenEventTask();
					if(ARG(c, 1))
						OpenTextTask();
					if(ARG(c, 2))
						OpenDateTask();
					if(ARG(c, 3))
						OpenAttribTask();
				}
				if(ARG(c, 7))
				{
					if(ARGBOOL(c, 0)==TRUE & eventTask.status==STATUS_OPEN)
						ZipWindow(eventTask.window);
					if(ARGBOOL(c, 1)==TRUE & textTask.status==STATUS_OPEN)
						ZipWindow(textTask.window);
					if(ARGBOOL(c, 2)==TRUE & dateTask.status==STATUS_OPEN)
						ZipWindow(dateTask.window);
					if(ARGBOOL(c, 3)==TRUE & attribTask.status==STATUS_OPEN)
						ZipWindow(attribTask.window);
				}
				if(ARG(c, 8))
				{
					if(ARGBOOL(c, 0)==TRUE & eventTask.status==STATUS_OPEN)
						WindowToFront(eventTask.window);
					if(ARGBOOL(c, 1)==TRUE & textTask.status==STATUS_OPEN)
						WindowToFront(textTask.window);
					if(ARGBOOL(c, 2)==TRUE & dateTask.status==STATUS_OPEN)
						WindowToFront(dateTask.window);
					if(ARGBOOL(c, 3)==TRUE & attribTask.status==STATUS_OPEN)
						WindowToFront(attribTask.window);
				}
				if(ARG(c, 9))
				{
					if(ARGBOOL(c, 0)==TRUE & eventTask.status==STATUS_OPEN)
						WindowToBack(eventTask.window);
					if(ARGBOOL(c, 1)==TRUE & textTask.status==STATUS_OPEN)
						WindowToBack(textTask.window);
					if(ARGBOOL(c, 2)==TRUE & dateTask.status==STATUS_OPEN)
						WindowToBack(dateTask.window);
					if(ARGBOOL(c, 3)==TRUE & attribTask.status==STATUS_OPEN)
						WindowToBack(attribTask.window);
				}
				if(ARG(c, 5))
				{
					if(ARG(c, 1))
						egCloseTask(&textTask);
					if(ARG(c, 2))
						egCloseTask(&dateTask);
					if(ARG(c, 3))
						egCloseTask(&attribTask);
					if(ARG(c, 0))
						eventTask.status=STATUS_CLOSED;
				}
				break;
			case AREXX_FONT:
				free(guiconfig.screenFont.ta_Name);
				guiconfig.screenFont.ta_Name=strdup(ARGSTRING(c, 0));
				guiconfig.screenFont.ta_YSize=(UWORD)ARGNUMBER(c, 1);
				if(ARG(c, 2))
					guiconfig.screenFont.ta_Flags=0;
				if(ARG(c, 3))
					guiconfig.screenFont.ta_Flags|=FSB_BOLD;
				if(ARG(c, 4))
					guiconfig.screenFont.ta_Flags|=FSB_UNDERLINED;
				if(ARG(c, 5))
					guiconfig.screenFont.ta_Flags|=FSB_ITALIC;
				eventTask.status=STATUS_RESETGUI;
				break;
			case AREXX_GETFILE:
				if(ARG(c, 0))
					egSetGadgetAttrs(textstring, textTask.window, NULL,
														GTST_String,	ARGSTRING(c, 0),
														TAG_DONE);
				else
					GetFile();
				break;
			case AREXX_MOVEWINDOW:
				if(ARGBOOL(c, 0)==TRUE & eventTask.status==STATUS_OPEN)
					MoveWindow(eventTask.window, ARGNUMBER(c, 4), ARGNUMBER(c,5));
				if(ARGBOOL(c, 1)==TRUE & textTask.status==STATUS_OPEN)
					MoveWindow(textTask.window, ARGNUMBER(c, 4), ARGNUMBER(c,5));
				if(ARGBOOL(c, 2)==TRUE & dateTask.status==STATUS_OPEN)
					MoveWindow(dateTask.window, ARGNUMBER(c, 4), ARGNUMBER(c,5));
				if(ARGBOOL(c, 3)==TRUE & attribTask.status==STATUS_OPEN)
					MoveWindow(attribTask.window, ARGNUMBER(c, 4), ARGNUMBER(c,5));
				break;
		}
		ReplyARexxMsg(c,
									ER_ReturnCode, result,
									TAG_DONE);
	}
	return result;
}

BYTE GetSwitch(struct ARexxContext *c, BYTE state)
{
	if(ARGBOOL(c,0) | ARGBOOL(c, 2))
		state=TRUE;
	else if(ARGBOOL(c, 1) | ARGBOOL(c, 3) | ARGBOOL(c, 5))
		state=FALSE;
	else if(ARGBOOL(c, 4))
		state=!state;

	return state;
}

#endif
