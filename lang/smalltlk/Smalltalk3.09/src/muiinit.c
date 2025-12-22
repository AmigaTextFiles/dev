/* 
	MUI initialization
	written by David Faught, July 1995
*/

# include "muist.h"
# include "env.h"
# include "memory.h"
# include "names.h"

#ifndef __GNUC__
#include <clib/muimaster_protos.h>
#else
#include <inline/muimaster.h>
#endif

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

LONG __stack = 8192;

extern object trueobj, falseobj;
extern boolean parseok;
extern int initial;

struct Library *MUIMasterBase;

/* windows are maintained in a single structure */
APTR wins[WINDOWMAX];

/* A little array definition */
const char LVT_STinit[] =
"Little Smalltalk version 3 by Timothy Budd.\nAmiga interface by David Faught.\nMUI - MagicUserInterface Copyright © 1993-94 Stefan Stuntz.";

/* Conventional GadTools NewMenu structures for menus */
struct NewMenu mainMenu[] =
{
	{ NM_TITLE, "Project"  , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "About..." ,"?",0,0,(APTR)ID_ABOUT     },
	{ NM_ITEM , "Browser"  ,"B",0,0,(APTR)ID_BROWSE    },
	{ NM_ITEM , "fileIn"   ,"I",0,0,(APTR)ID_FILEIN    },
	{ NM_ITEM , "fileOut"  ,"O",NM_ITEMDISABLED,0,(APTR)ID_FILEOUT   },
	{ NM_ITEM , "saveImage","S",0,0,(APTR)ID_SAVEIMG   },
	{ NM_ITEM , NM_BARLABEL, 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "Quit"     ,"Q",0,0,(APTR)MUIV_Application_ReturnID_Quit },
	{ NM_TITLE, "Edit"     , 0 ,NM_MENUDISABLED,0,(APTR)0            },
	{ NM_ITEM , "addClass" ,"C",0,0,(APTR)ID_ADDCLS    },
	{ NM_ITEM , "addMethod","M",0,0,(APTR)ID_ADDMTH    },
	{ NM_ITEM , "editMethod","E",0,0,(APTR)ID_TXTEDT   },
	{ NM_TITLE, "Options"  , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "echo"     ,"H",0,0,(APTR)ID_ECHO      },
	{ NM_ITEM , "bytecodes","Y",NM_ITEMDISABLED,0,(APTR)ID_BYTES     },
	{ NM_END  , NULL       , 0 ,0,0,(APTR)0            },
};

struct NewMenu browserMenu[] =
{
	{ NM_TITLE, "Project"  , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "About..." ,"?",0,0,(APTR)ID_ABOUT     },
	{ NM_ITEM , "Browser"  ,"B",0,0,(APTR)ID_QUITBR    },
	{ NM_ITEM , "fileIn"   ,"I",0,0,(APTR)ID_FILEIN    },
	{ NM_ITEM , "fileOut"  ,"O",0,0,(APTR)ID_FILEOUT   },
	{ NM_ITEM , "saveImage","S",0,0,(APTR)ID_SAVEIMG   },
	{ NM_ITEM , NM_BARLABEL, 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "Quit"     ,"Q",0,0,(APTR)MUIV_Application_ReturnID_Quit },
	{ NM_TITLE, "Edit"     , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "addClass" ,"C",0,0,(APTR)ID_ADDCLS    },
	{ NM_ITEM , "addMethod","M",0,0,(APTR)ID_ADDMTH    },
	{ NM_ITEM , "editMethod","E",0,0,(APTR)ID_TXTEDT   },
	{ NM_TITLE, "Options"  , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "echo"     ,"H",0,0,(APTR)ID_ECHO      },
	{ NM_ITEM , "bytecodes","Y",0,0,(APTR)ID_BYTES     },
	{ NM_END  , NULL       , 0 ,0,0,(APTR)0            },
};

/* Pointers for some MUI objects */
APTR AP_Small;
APTR LV_Classes, LV_Methods, LV_Text, LV_Console;
APTR ST_Console;

VOID stccpy(char *dest,char *source,int len)
{
        strncpy(dest,source,len);
        dest[len-1]='\0';
}

APTR * CreateApp( void )
{
	APTR * App;

	App = ApplicationObject,
		MUIA_Application_Author, "David Faught",
		MUIA_Application_Base, "STMUI",
		MUIA_Application_Title, "Smalltalk",
		MUIA_Application_Version, "$VER: LittleSmalltalk 3.09 (8.27.95)",
		MUIA_Application_Copyright, "Public Domain, except as noted",
		MUIA_Application_Description, "Amiga Little Smalltalk with MUI",

		SubWindow, wins[1] = WindowObject, MUIA_Window_Title, "Browser", MUIA_Window_ID, MAKE_ID('B','R','O','W'), MUIA_Window_Menustrip, MUI_MakeObject(MUIO_MenustripNM,browserMenu,0), WindowContents,
			VGroup,
				Child, HGroup, GroupFrameT("Classes and Methods"),
					Child, LV_Classes = ListviewObject,
						MUIA_Listview_Input, TRUE,
						MUIA_Listview_List, ListObject, InputListFrame, End,
						End,
					Child, LV_Methods = ListviewObject,
						MUIA_Listview_Input, TRUE,
						MUIA_Listview_List, ListObject, InputListFrame, End,
						End,
					End,
				Child, HGroup, GroupFrameT("Method Viewer"),
					Child, LV_Text = ListviewObject,
						MUIA_Listview_Input, TRUE,
						MUIA_Listview_List, FloattextObject, MUIA_Floattext_Text, "", MUIA_Floattext_TabSize, 4, ReadListFrame, End,
						End,
					End,
				End,
			End,

		SubWindow, wins[0] = WindowObject, MUIA_Window_Title, "Amiga Little Smalltalk", MUIA_Window_ID, MAKE_ID('A','L','S','T'), MUIA_Window_Menustrip, MUI_MakeObject(MUIO_MenustripNM,mainMenu,0), WindowContents,
			VGroup,
				Child, LV_Console = ListviewObject,
					MUIA_Listview_Input, FALSE,
					MUIA_Listview_List, ListObject, InputListFrame, End,
					End,
				Child, ST_Console = StringObject, StringFrame, End,
				End,
			End,
		End;

	return( App );
}

VOID failmui(char *str)
{
        if (AP_Small)
                MUI_DisposeObject(AP_Small);

        if (MUIMasterBase)
                CloseLibrary(MUIMasterBase);

        if (str)
        {
                puts(str);
                exit(20);
        }
        exit(0);
}

VOID initmui(VOID)
{
	if (!(MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)))
		failmui("Failed to open "MUIMASTER_NAME".");
	if (!(AP_Small = CreateApp()))
		failmui("Failed to create App object.");

/* Automagically remove the browser window when the user hits the close gadget */
	DoMethod(wins[1],MUIM_Notify,MUIA_Window_CloseRequest,TRUE,wins[1],3,MUIM_Set,MUIA_Window_Open,FALSE);

/* Closing the console window forces a complete shutdown of the application */
	DoMethod(wins[0],MUIM_Notify,MUIA_Window_CloseRequest,TRUE,AP_Small,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

/* Receive input ids from several list views */
	DoMethod(LV_Classes ,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,AP_Small,2,MUIM_Application_ReturnID,ID_NEWCLA);
	DoMethod(LV_Methods ,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,AP_Small,2,MUIM_Application_ReturnID,ID_NEWMET);
	DoMethod(LV_Text    ,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,AP_Small,2,MUIM_Application_ReturnID,ID_TXTEDT);
	DoMethod(ST_Console ,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,AP_Small,2,MUIM_Application_ReturnID,ID_NEWCON);
	DoMethod(wins[0]    ,MUIM_Notify,MUIA_Window_Activate,TRUE,wins[0],3,MUIM_Set,MUIA_Window_ActiveObject,ST_Console);

/* Set the TAB cycle chain for some of our windows */
	DoMethod(wins[1] ,MUIM_Window_SetCycleChain,LV_Classes,LV_Methods,LV_Text,NULL);
	DoMethod(wins[0] ,MUIM_Window_SetCycleChain,ST_Console,NULL);
}

/* Open the console window */
VOID openCons()
{
	set(wins[0],MUIA_Window_Open,TRUE);
}

#define MAXCONLINES 200
char conSave[80*MAXCONLINES];
ULONG conCount = 0;

/* put a line to the console window */
VOID putCons(s1)
char *s1;
{
	ULONG conlines;

	stccpy(&conSave[80*conCount], s1, 80);
	DoMethod(LV_Console, MUIM_List_InsertSingle, &conSave[80*conCount], MUIV_List_Insert_Bottom);
	get(LV_Console, MUIA_List_Entries, &conlines);
	while (conlines-- > MAXCONLINES) {
		DoMethod(LV_Console, MUIM_List_Remove, MUIV_List_Remove_First);
		}
	set(LV_Console, MUIA_List_Active, MUIV_List_Active_Bottom);
	if (++conCount >= MAXCONLINES) conCount = 0;
}

/* put up a general requester */
VOID genRequest(s1)
char *s1;
{
	(VOID)MUI_Request(AP_Small, wins[0], 0, NULL, "OK", s1);
}

/* report a fatal system error */
noreturn sysError(s1, s2)
char *s1, *s2;
{	char buffer[1024];

	if (initial) {
		ignore fprintf(stderr,"%s\n%s\n", s1, s2);
		}
	else {
		ignore sprintf(buffer,"%s %s", s1, s2);
		genRequest(buffer);
		}
	failmui(NULL);
}

/* report a non-fatal system error */
noreturn sysWarn(s1, s2)
char *s1, *s2;
{	char buffer[1024];

	if (initial) {
		ignore fprintf(stderr,"%s\n%s\n", s1, s2);
		}
	else {
		ignore sprintf(buffer,"%s %s", s1, s2);
		putCons(buffer);
		genRequest(buffer);
		}
}

compilWarn(selector, str1, str2)
char *selector, *str1, *str2;
{	char buffer[1024];

	if (initial) {
		ignore fprintf(stderr,"compiler warning: Method %s : %s %s\n", 
			selector, str1, str2);
		}
	else {
		ignore sprintf(buffer,"warn: %s %s", str1, str2);
		putCons(buffer);
		}
}

compilError(selector, str1, str2)
char *selector, *str1, *str2;
{	char buffer[1024];

	if (initial) {
		ignore fprintf(stderr,"compiler error: Method %s : %s %s\n", 
			selector, str1, str2);
		}
	else {
		ignore sprintf(buffer,"error: %s %s", str1, str2);
		putCons(buffer);
		}
	parseok = false;
}

noreturn dspMethod(cp, mp)
char *cp, *mp;
{	char buffer[1024];

	if (initial) {
		ignore fprintf(stderr, "%s %s\n", cp, mp);
		}
	else {
		ignore sprintf(buffer,"%s %s", cp, mp);
		putCons(buffer);
		}
}

givepause()
{	char buffer[80];

	if (initial) {
		ignore fprintf(stderr,"push return to continue\n");
		ignore gets(buffer);
		}
	else
		genRequest("ok to continue?");
}

object newPoint(x, y)
int x, y;
{	object newObj;

	newObj = allocObject(2);
	setClass(newObj, globalSymbol("Point"));
	basicAtPut(newObj, 1, newInteger(x));
	basicAtPut(newObj, 2, newInteger(y));
	return newObj;
}
