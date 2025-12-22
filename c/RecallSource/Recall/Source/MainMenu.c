/*
 *	File:					Menus.c
 *	Description:	Global menus
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef MENUS_C
#define MENUS_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System_Prefs.h"
#include "MainMenu.h"
#include "PrefsIO.h"
#include "Asl.h"
#include "TASK_Find.h"

/*** DEFINES *************************************************************************/
#define	TOGGLE			CHECKIT|MENUTOGGLE

#define	ID_NEWPROJECT				10
#define	ID_OPENPROJECT			11
#define	ID_INCLUDE					12
#define	ID_IMPORT						13
#define	ID_SAVEPROJECT			14
#define	ID_SAVEPROJECTAS		15
#define	ID_EXPORT						16
#define	ID_TEST							17
#define	ID_ICONIFY					18
#define	ID_ABOUT						19
#define	ID_QUIT							20

#define	ID_LASTSAVED				21

#define	ID_FIND							24
#define	ID_FINDNEXT					25
#define	ID_REPLACE					26
#define	ID_REPLACENEXT			27

#define	ID_EVENTWINDOW			400
#define	ID_TEXTWINDOW				401
#define	ID_DATEWINDOW				402
#define	ID_ATTRIBWINDOW			403
#define	ID_OWNSCREEN				404
#define	ID_BACKDROP					405
#define	ID_CLOSEWORKBENCH		406
#define	ID_SHANGHAI					407
#define	ID_SIMPLEREFRESH		408
#define	ID_SAVEWHENEXIT			409
#define	ID_ACKNOWLEDGE			410
#define	ID_SELECTSCREENMODE	411
#define	ID_SELECTFONT				412
#define	ID_PALETTE					413
#define	ID_USESCREENFONT		414
#define	ID_OPENSETTINGS			415
#define	ID_SAVESETTINGS			416
#define	ID_SAVESETTINGSAS		417
#define	ID_AFFECTALL				418
#define	ID_PARSEDIRS				419

#define	ID_MACROWINDOW			200
#define	ID_MACRO1						201
#define	ID_MACRO2						202
#define	ID_MACRO3						203
#define	ID_MACRO4						204
#define	ID_MACRO5						205
#define	ID_MACRO6						206
#define	ID_MACRO7						207
#define	ID_MACRO8						208
#define	ID_MACRO9						209
#define	ID_MACRO10					210
#define	ID_OTHER						211
#define	ID_STARTRECORDING		212
#define	ID_STOPRECORDING		213
#define	ID_COMMANDSHELL			214
#define	ID_LOADMACROS				215
#define	ID_SAVEMACROS				216
#define	ID_SAVEMACROSAS			217

#define	ID_HELPABOUT				300
#define	ID_HELPAUTHOR				301
#define	ID_HELPCONTENTS			302
#define	ID_HELPINDEX				303
#define	ID_HELPHELP					304
#define	ID_HELPPREFERENCES	305
#define	ID_HELPCHECKER			306
#define	ID_HELPEVENTS				308
#define	ID_HELPTEXTS				309
#define	ID_HELPDATES				310
#define	ID_HELPATTRIBUTES		311

/*** GLOBALS *************************************************************************/
struct Menu	*mainMenu;
struct List *loaders, *savers, *displayers, *operators;

/*** FUNCTIONS ***********************************************************************/
__stackext struct List *GetModules(STRPTR dir)
{
	register struct FileInfoBlock	*fib;
	register BPTR									lock, oldlock;
	register struct List					*list;

#ifdef MYDEBUG_H
	DebugOut("GetModules");
#endif

	if(list=InitList())
		if(fib=AllocDosObject(DOS_FIB, TAG_DONE))
		{
			if(lock=Lock(dir, SHARED_LOCK))
			{
				oldlock=CurrentDir(lock);
				if(Examine(lock, fib))
				{
					while(ExNext(lock, fib))
						if(!(fib->fib_Protection & FIBF_EXECUTE))
							if(Stricmp(fib->fib_FileName+MAX(0, strlen(fib->fib_FileName)-5), ".info"))
								AddNode(list, NULL, fib->fib_FileName);
				}
				CurrentDir(oldlock);
				UnLock(lock);
			}
			FreeDosObject(DOS_FIB, fib);  
		}
		else
			FailAlert(MSG_OUTOFMEMORY);

	return list;
}

BYTE AllocMainMenu(void)
{
	UBYTE moduledir[MAXCHARS];

#ifdef MYDEBUG_H
	DebugOut("AllocMainMenu");
#endif

	sprintf(moduledir, "%s/%s/", startdir, LOADERSDIR);
	loaders=GetModules(moduledir);

	sprintf(moduledir, "%s/%s/", startdir, SAVERSDIR);
	savers=GetModules(moduledir);

	sprintf(moduledir, "%s/%s/", startdir, DISPLAYERSDIR);
	displayers=GetModules(moduledir);

	sprintf(moduledir, "%s/%s/", startdir, OPERATORSDIR);
	operators=GetModules(moduledir);

	if(mainMenu=egCreateMenu(
			NM_TITLE,		egGetString(MSG_PROJECT),			0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_NEW),				0, 0L, ID_NEWPROJECT,
			NM_ITEM,		NM_BARLABEL,									0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_OPEN),			0, 0L, ID_OPENPROJECT,
			NM_ITEM,		egGetString(MSG_K_INCLUDE),		0, 0L, ID_INCLUDE,
			NM_ITEM,		egGetString(MSG_IMPORT),			0, 0L, ID_INCLUDE,
			EG_SUBLIST,	loaders,											0, 0L, LOADERBASE,
			NM_ITEM,		NM_BARLABEL,									0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_SAVE),			0, 0L, ID_SAVEPROJECT,
			NM_ITEM,		egGetString(MSG_K_SAVEAS),		0, 0L, ID_SAVEPROJECTAS,
			NM_ITEM,		egGetString(MSG_EXPORT),			0, 0L, ID_INCLUDE,
			EG_SUBLIST,	savers,												0, 0L, SAVERBASE,
			NM_ITEM,		NM_BARLABEL,									0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_TEST),			0, 0L, ID_TEST,
			NM_ITEM,		NM_BARLABEL,									0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_ICONIFY),		0, 0L, ID_ICONIFY,
			NM_ITEM,		NM_BARLABEL,									0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_QUIT),			0, 0L, ID_QUIT,

			NM_TITLE,		egGetString(MSG_EDIT),				0, 0L, NULL,
			NM_ITEM,		egGetString(MSG_K_LASTSAVED),	0, 0L, ID_LASTSAVED,
			(IsNil(operators) ? NM_IGNORE:NM_ITEM),		NM_BARLABEL,									0, 0L, NULL,
			EG_LIST,		operators,										0, 0L, OPERATORBASE,

			(IsNil(operators) ? NM_IGNORE:NM_TITLE),		egGetString(MSG_DISPLAYERS),	0, 0L, NULL,
			EG_LIST,		displayers,										0, 0L, OPERATORBASE,

			NM_TITLE, egGetString(MSG_SEARCH),				0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_FIND),				0, 0L, ID_FIND,
			NM_ITEM,	egGetString(MSG_K_FINDNEXT),		0, 0L, ID_FINDNEXT,
			NM_ITEM,	NM_BARLABEL,										0, 0L, NULL,

			NM_ITEM,	egGetString(MSG_K_REPLACE),			0, 0L, ID_REPLACE,
			NM_ITEM,	egGetString(MSG_K_REPLACENEXT),	0, 0L, ID_REPLACENEXT,

			NM_TITLE,	egGetString(MSG_SETTINGS),					0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_EVENTS),					0, 0L, ID_EVENTWINDOW,
			NM_ITEM,	egGetString(MSG_K_TEXTS),						0, 0L, ID_TEXTWINDOW,
			NM_ITEM,	egGetString(MSG_K_DATES),						0, 0L, ID_DATEWINDOW,
			NM_ITEM,	egGetString(MSG_K_ATTRIBUTES),			0, 0L, ID_ATTRIBWINDOW,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_MODULES),						0, 0L, 0,
			NM_SUB,		egGetString(MSG_K_AFFECTALL),				TOGGLE, 0L, ID_AFFECTALL,
			NM_SUB,		egGetString(MSG_K_PARSEDIRS),				TOGGLE, 0L, ID_PARSEDIRS,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_ACKNOWLEDGE),			CHECKIT|MENUTOGGLE, 0L, ID_ACKNOWLEDGE,
			NM_ITEM,	egGetString(MSG_K_SAVEWHENEXIT),		CHECKIT|MENUTOGGLE, 0L, ID_SAVEWHENEXIT,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_SIMPLEREFRESH),		CHECKIT|MENUTOGGLE, 0L, ID_SIMPLEREFRESH,
			NM_ITEM,	egGetString(MSG_K_CLOSEWB),					CHECKIT|MENUTOGGLE, 0L, ID_CLOSEWORKBENCH,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_OWNSCREEN),				CHECKIT|MENUTOGGLE, 0L, ID_OWNSCREEN,
			NM_ITEM,	egGetString(MSG_K_BACKDROP),				CHECKIT|MENUTOGGLE, 0L, ID_BACKDROP,
			NM_ITEM,	egGetString(MSG_K_SHANGHAI),				CHECKIT|MENUTOGGLE, 0L, ID_SHANGHAI,
			NM_ITEM,	egGetString(MSG_K_USESCREENFONT),		CHECKIT|MENUTOGGLE, 0L, ID_USESCREENFONT,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_SELECTFONT),			NULL,	0L, ID_SELECTFONT,
			NM_ITEM,	egGetString(MSG_K_SELECTSCREENMODE),NULL, 0L, ID_SELECTSCREENMODE,
			NM_ITEM,	egGetString(MSG_K_ADJUSTPALETTE),		NULL, 0L, ID_PALETTE,
			NM_ITEM,	NM_BARLABEL,												0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_OPENSETTINGS),		NULL, 0L, ID_OPENSETTINGS,
			NM_ITEM,	egGetString(MSG_K_SAVESETTINGS),		NULL, 0L, ID_SAVESETTINGS,
			NM_ITEM,	egGetString(MSG_K_SAVESETTINGSAS),	NULL, 0L, ID_SAVESETTINGSAS,

			NM_TITLE,	egGetString(MSG_HELP),								0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_HELPABOUT),					0, 0L, ID_HELPABOUT,
			NM_ITEM,	egGetString(MSG_K_HELPAUTHOR),				0, 0L, ID_HELPAUTHOR,
			NM_ITEM,	NM_BARLABEL,													0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_HELPCONTENTS),			0, 0L, ID_HELPCONTENTS,
			NM_ITEM,	egGetString(MSG_K_HELPINDEX),					0, 0L, ID_HELPINDEX,
			NM_ITEM,	egGetString(MSG_K_HELPHELP),					0, 0L, ID_HELPHELP,
			NM_ITEM,	NM_BARLABEL,													0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_HELPCHECKER),				0, 0L, ID_HELPCHECKER,
			NM_ITEM,	egGetString(MSG_K_HELPPREFERENCES),		0, 0L, ID_HELPPREFERENCES,
			NM_ITEM,	NM_BARLABEL,													0, 0L, NULL,
			NM_ITEM,	egGetString(MSG_K_HELPEVENTS),				0, 0L, ID_HELPEVENTS,
			NM_ITEM,	egGetString(MSG_K_HELPTEXTS),					0, 0L, ID_HELPTEXTS,
			NM_ITEM,	egGetString(MSG_K_HELPDATES),					0, 0L, ID_HELPDATES,
			NM_ITEM,	egGetString(MSG_K_HELPATTRIBUTES),		0, 0L, ID_HELPATTRIBUTES,
			NM_END))
		return TRUE;
	return FALSE;
}

void FreeMainMenu(void)
{
#ifdef MYDEBUG_H
	DebugOut("FreeMainMenu");
#endif
	if(loaders)
		FreeList(loaders);
	if(savers)
		FreeList(savers);
	if(displayers)
		FreeList(displayers);
	if(operators)
		FreeList(operators);

	FreeMenus(mainMenu);
	mainMenu=NULL;
}

void UpdateMainMenu(void)
{
	register BYTE flag;

#ifdef MYDEBUG_H
	DebugOut("UpdateMainMenu");
#endif

	egSetMenuBit(	mainTask.window, mainMenu, NM_ITEMDISABLED,
								ID_FINDNEXT,					!(findTask.status==STATUS_OPEN | *(finder.findstring)=='\0' ? TRUE:FALSE),
								ID_REPLACENEXT,				!(findTask.status==STATUS_OPEN | (*(finder.replacestring)=='\0' | *(finder.findstring)=='\0') ? TRUE:FALSE),
								ID_NEWPROJECT,				flag=!(IsNil(rootlist) ? TRUE:FALSE),
								ID_INCLUDE,						flag,
								ID_SAVEPROJECT,				flag,
								ID_SAVEPROJECTAS,			flag,
								ID_EXPORT,						flag,
								ID_TEST,							flag,
								ID_CLOSEWORKBENCH,		flag=!(env.ownscreen==TRUE ? FALSE:TRUE),
								ID_SELECTSCREENMODE,	flag,
								ID_SELECTFONT,				flag,
								ID_PALETTE,						flag,
								NULL);

	egSetMenuBit(	mainTask.window, mainMenu, CHECKED,
//								ID_AFFECTALL, 		env.affectall,
//								ID_PARSEDIRS, 		env.parsedirs,
								ID_OWNSCREEN,				env.ownscreen,
								ID_SIMPLEREFRESH,		env.simplerefresh,
								ID_CLOSEWORKBENCH,	env.closeworkbench,
								ID_SAVEWHENEXIT,		env.savewhenexit,
								ID_ACKNOWLEDGE,			env.acknowledge,
								NULL);
}

void HandleMainMenu(struct egTask *task, UWORD menuNumber)
{
	struct MenuItem	*item;
	ULONG itemnum;
	register BYTE reset		=FALSE,
								loadenv	=FALSE;

#ifdef MYDEBUG_H
	DebugOut("HandleMainMenu");
#endif

	while(menuNumber!=MENUNULL)
	{
		item=ItemAddress(mainMenu, menuNumber);
		itemnum=(ULONG)GTMENUITEM_USERDATA(item);
		switch(itemnum)
		{
			case ID_NEWPROJECT:
				NewProject(FALSE);
				break;
			case ID_OPENPROJECT:
				if(AttemptSemaphore(eventsemaphore))
				{
					OpenProject(rootlist, project, FALSE);
					ReleaseSemaphore(eventsemaphore);
				}
//				else
//					SEMAPHOREFAIL();
				break;
			case ID_INCLUDE:
				AppendProject(eventlist, project);
				break;
			case ID_SAVEPROJECT:
				SaveProject(rootlist, project);
				break;
			case ID_SAVEPROJECTAS:
				SaveProjectAs(rootlist, project);
				break;
			case ID_TEST:
				TestProject();
				break;
			case ID_ICONIFY:
				egIconify(eg, TRUE);
				break;
			case ID_QUIT:
				Quit();
				break;

			case ID_LASTSAVED:
				LastSaved(rootlist, project, FALSE);
				break;
			case ID_AFFECTALL:
				env.affectall=egIsMenuItemChecked(mainMenu, ID_AFFECTALL);
				break;
			case ID_PARSEDIRS:
				env.parsedirs=egIsMenuItemChecked(mainMenu, ID_PARSEDIRS);
				break;

			case ID_FIND:
				finder.replacemode=FALSE;
				OpenFindTask(NULL, NULL, NULL);
				UpdateFindTask();
				break;
			case ID_FINDNEXT:
				{
					BYTE oldmode=finder.replacemode;

					finder.replacemode=FALSE;
					FindReplace();
					finder.replacemode=oldmode;
				}
				break;
			case ID_REPLACE:
				finder.replacemode=TRUE;
				OpenFindTask(NULL, NULL, NULL);
				UpdateFindTask();
				break;
			case ID_REPLACENEXT:
				{
					BYTE oldmode=finder.replacemode;

					finder.replacemode=TRUE;
					FindReplace();
					finder.replacemode=oldmode;
				}
				break;
/*
      /*******************************************************************************/
			case ID_MACROWINDOW:
				OpenAssignTask(NULL, NULL, NULL);
				break;
			case ID_MACRO1:
			case ID_MACRO2:
			case ID_MACRO3:
			case ID_MACRO4:
			case ID_MACRO5:
			case ID_MACRO6:
			case ID_MACRO7:
			case ID_MACRO8:
			case ID_MACRO9:
			case ID_MACRO10:
				itemnum-=ID_MACRO1;
				if(Stricmp(macros[itemnum].fullname, egGetString(MSG_NOTASSIGNED))==0)
				{
					OpenAssignTask(NULL, NULL, NULL);
					DisplayBeep(mainTask.screen);
					egActivateGadget(macrostring[itemnum], assignTask.window, NULL);
				}
				else
					if(0==RunARexxMacro(context,
												ER_MacroFile,	macros[itemnum].fullname,
												TAG_DONE))
						FailRequest(mainTask.window, MSG_NOTFOUND, (APTR)macros[itemnum].fullname, NULL);

				break;
			case ID_OTHER:
				if(FileRequest(	mainTask.window,
												MSG_RUNMACRO,
												macrofile,
												NULL,
												NULL,
												MSG_RUN))
					if(0==RunARexxMacro(context,
												ER_MacroFile,	macrofile,
												TAG_DONE))
						FailRequest(mainTask.window, MSG_NOTFOUND, (APTR)macrofile, NULL);
				break;
      case ID_COMMANDSHELL:
				OpenCommandShell();
      	break;
			case ID_STARTRECORDING:
				if(macro)
				{
					record=TRUE;
					SetAllPointers();
					UpdateMainMenu();
				}
				break;
			case ID_STOPRECORDING:
				ClearAllPointers();
				record=FALSE;
				egLockAllTasks(eg);
				if(!IsARexxMacroEmpty(macro))
				{
					if(FileRequest(	mainTask.window,
													MSG_SAVERECORDEDMACRO,
													macrofile,
													FRF_DOSAVEMODE,
													NULL,
													MSG_SAVE))
					{
						WriteARexxMacro(context, macro, macrofile, TAG_DONE);
						ClearARexxMacro(macro);
					}
				}
				UpdateMainMenu();
				egUnlockAllTasks(eg);
				break;
			case ID_LOADMACROS:
				OpenMacros(macros, macrodefinition);
				break;
			case ID_SAVEMACROS:
				SaveMacros(macros, DEFAULT_MACROS);
				break;
			case ID_SAVEMACROSAS:
				SaveMacrosAs(macros, macrodefinition);
				break;
*/
      /*******************************************************************************/
			case ID_EVENTWINDOW:
				OpenMainTask(NULL, NULL, NULL);
				break;
			case ID_TEXTWINDOW:
				OpenTextTask(NULL, NULL, NULL);
				break;
			case ID_DATEWINDOW:
				OpenDateTask(NULL, NULL, NULL);
				break;
			case ID_ATTRIBWINDOW:
				OpenAttribTask(NULL, NULL, NULL);
				break;
			case ID_ACKNOWLEDGE:
				env.acknowledge=egIsMenuItemChecked(mainMenu, ID_ACKNOWLEDGE);
				break;
			case ID_SAVEWHENEXIT:
				env.savewhenexit=egIsMenuItemChecked(mainMenu, ID_SAVEWHENEXIT);
				break;
			case ID_SIMPLEREFRESH:
				env.simplerefresh=egIsMenuItemChecked(mainMenu, ID_SIMPLEREFRESH);
				reset=TRUE;
				break;
			case ID_CLOSEWORKBENCH:
				env.closeworkbench=egIsMenuItemChecked(mainMenu, ID_CLOSEWORKBENCH);
				CloseWB(env.closeworkbench);
				break;
			case ID_OWNSCREEN:
				env.ownscreen=egIsMenuItemChecked(mainMenu, ID_OWNSCREEN);
				reset=TRUE;
				break;
			case ID_BACKDROP:
				env.backdrop=egIsMenuItemChecked(mainMenu, ID_BACKDROP);
				reset=TRUE;
				break;
			case ID_SHANGHAI:
				env.shanghai=egIsMenuItemChecked(mainMenu, ID_SHANGHAI);
				DefaultPubScreen(mainTask.screen, env.pubname, env.shanghai);
				break;
			case ID_USESCREENFONT:
				env.usescreenfont=egIsMenuItemChecked(mainMenu, ID_USESCREENFONT);
				if(	0==Stricmp(mainTask.screen->Font->ta_Name, env.textAttr.ta_Name)	&&
						mainTask.screen->Font->ta_YSize==env.textAttr.ta_YSize						&&
						mainTask.screen->Font->ta_Style==env.textAttr.ta_Style						&&
						mainTask.screen->Font->ta_Flags==env.textAttr.ta_Flags)
					UpdateMainMenu();
				else
					reset=TRUE;
				break;
			case ID_SELECTSCREENMODE:
				reset=SelectScreenMode();
				break;
			case ID_SELECTFONT:
				reset=SelectFont();
				break;
			case ID_PALETTE:
				AdjustPalette(mainTask.window);
				break;
			case ID_OPENSETTINGS:
				reset=loadenv=OpenEnv(&env, guifile);
				break;
			case ID_SAVESETTINGS:
				WriteEnv(&env, ENVARCGUIFILE, FALSE);
				WriteEnv(&env, ENVGUIFILE, TRUE);
				break;
			case ID_SAVESETTINGSAS:
				SaveEnv(&env, guifile, FALSE);
				break;

      /*******************************************************************************/
			case ID_HELPABOUT:
				OpenAboutTask(NULL, NULL, NULL);
				break;
			case ID_HELPAUTHOR:
				ShowHelp("author");
				break;
			case ID_HELPCONTENTS:
				ShowHelp(NULL);
				break;
			case ID_HELPINDEX:
				ShowHelp("index");
				break;
			case ID_HELPHELP:
				ShowHelp("help");
				break;
			case ID_HELPPREFERENCES:
				ShowHelp("usingprefs");
				break;
			case ID_HELPCHECKER:
				ShowHelp("running");
				break;
			case ID_HELPEVENTS:
				ShowHelp("eventwindow");
				break;
			case ID_HELPTEXTS:
				ShowHelp("textwindow");
				break;
			case ID_HELPDATES:
				ShowHelp("datewindow");
				break;
			case ID_HELPATTRIBUTES:
				ShowHelp("attribwindow");
				break;

			default:
//				LaunchModule(itemnum);
				break;
		}
		menuNumber=item->NextSelect;
	}
	if(reset && SafeToQuit(MSG_RESET, FALSE))
	{
			closemsg=MSG_RESET;
			SETBIT(eg->flags, EG_RESET);
			egCloseAllTasks(eg);
			if(loadenv)
				ReadEnv(&env, guifile);
			egOpenAllTasks(eg);
			CLEARBIT(eg->flags, EG_RESET);
	}
}

void UpdateMacroMenu(void)
{
#ifdef MYDEBUG_H
	DebugOut("UpdateMacroMenu");
#endif

	if(mainMenu)
	{
		ClearMenuStrip(mainTask.window);
		if(LayoutMenus(	mainMenu, mainTask.VisualInfo,
										GTMN_NewLookMenus,	TRUE,
										TAG_END))
;//			egMakeHelpMenu(mainMenu, mainTask.screen);
		SetMenuStrip(mainTask.window, mainMenu);
	}
}

void ShowHelp(UBYTE *topic)
{
	egShowAmigaGuide(eg, topic);
/*
	if(record)
		AddARexxMacroCommand(	macro,
													ER_Command, 	"HELP '%s'",
													ER_Argument,	topic,	
													TAG_DONE);
*/
}
/*
void OpenCommandShell(void)
{
	ARexxCommandShell(context,
										ER_Font,					topaz,
										WA_Title,					NAME " Shell",
										WA_PubScreen,			mainTask.screen,
										ER_Prompt,				DEFAULT_PROMPT,
										WA_Top,						mainTask.window->TopEdge+mainTask.window->Height,
										WA_Left,					mainTask.window->LeftEdge,
										WA_Width,					mainTask.window->Width,
										WA_Height,				100,
										WA_DragBar,				TRUE,
										WA_DepthGadget,		TRUE,
										WA_SizeGadget,		TRUE,
										WA_CloseGadget,		TRUE,
										WA_MinWidth,			70,
										WA_MinHeight,			70,
										WA_MaxWidth,			~0,
										WA_MaxHeight,			~0,
										WA_SizeBBottom,		TRUE,
										TAG_DONE);
/*
	if(record)
		AddARexxMacroCommand(	macro,
													ER_Command,		"COMMANDSHELL OPEN",
													TAG_DONE);
*/
}
*/

void Quit(void)
{
#ifdef MYDEBUG_H
	DebugOut("SaveEnvHook");
#endif

	if(SafeToQuit(closemsg=MSG_QUIT, FALSE))
	{
		if(env.savewhenexit)
			WriteEnv(&env, ENVARCGUIFILE, FALSE);
		WriteEnv(&env, ENVGUIFILE, TRUE);
		egCloseAllTasks(eg);
	}
}



#endif
