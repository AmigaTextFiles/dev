#include <proto/muimaster.h>
#include <proto/intuition.h>
#include <proto/iffparse.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>

#include <libraries/mui.h>
#include <libraries/dos.h>
#include <libraries/iffparse.h>

#include <utility/hooks.h>

#include <sys/dir.h>
#include <string.h>
#include <stdio.h>

struct Library *MUIMasterBase;

long __stack=8192;

#define PROGNAME "CrazyMCP"

#define MCCDIR "MUI:libs/mui"

#define MAXMCC 100
struct mccinfo 
{
struct Library *lib;
char *name;
}
mcctab[MAXMCC];
int mccnum=0;

Object *app,*win,*data;

int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

#define ABOUTID 999
#define ALLID 998

extern long libmccQuery(long);
#pragma libcall MCCBase libmccQuery 1e 001
long MCCQuery(struct Library *MCCBase,long q)
{return libmccQuery(q);}

void MakeItColumnGroup(Object *grp,int cols)
{
int numchildren=0,spaces;
APTR Children;
SetAttrs(grp,MUIA_Group_Columns,cols,0);

GetAttr(MUIA_Group_ChildList,grp,(ULONG*)&Children);
while (NextObject(&Children)) numchildren++;

numchildren--;

for (spaces=(cols-(numchildren%cols))%cols;spaces>0;spaces--)
	DoMethod(grp,OM_ADDMEMBER,HVSpace);

}

Object *CreateWinContents(int par,char **wintitle)
{
Object* obj=0;
struct MUI_CustomClass *mcc;
switch(par)
	{
	case ABOUTID: // aboutwindow
		obj=ListviewObject,
			MUIA_Listview_List,FloattextObject,
			MUIA_Floattext_Text,
				"\033cThis useless program is written by\n"
				"\033cSzymon Ulatowski\n"
				"\033ce-mail: szulat@arrakis.cs.put.poznan.pl\n"
				"\n"
				"MUI Custom Preferences with the Workbench look... "
				"Interesting, huh?\n"
				"\n"
				"\033lWarning: \033bThis is a hack!\033n :-)\n"
				"It can make your machine work bad, hang or something. "
				"And probably it will be even worse "
				"with improper MUI version (tested on 3.8). "
				"But who cares?!\n"
				"Use at your own risk and be happy!\n",
				End,
			End;
			*wintitle="About " PROGNAME "...";
		break;
	case ALLID: // aboutwindow
	{
	int i;
	Object *grp=VirtgroupObject,MUIA_Group_Spacing,12,End;
	obj=ScrollgroupObject,MUIA_Scrollgroup_Contents,grp,End;
	for (i=0;i<mccnum;i++)
		DoMethod(grp,OM_ADDMEMBER,CreateWinContents(i,wintitle));
	MakeItColumnGroup(grp,4);
	*wintitle=PROGNAME " - All in One!";
	}
		break;
	default:
	if (!mcctab[par].lib) mcctab[par].lib=OldOpenLibrary(mcctab[par].name);
	mcc=(struct MUI_CustomClass *)MCCQuery(mcctab[par].lib,1);
	*wintitle=mcctab[par].lib->lib_IdString;
	if (!(obj=NewObject(mcc->mcc_Class,0,0))) return 0;
	DoMethod(obj,MUIM_Settingsgroup_ConfigToGadgets,data);
	}
return obj;
}

__saveds ULONG __asm openwindowfun(register __a0 struct Hook *h, register __a2 Object *obj,register __a1 long *par)
{
Object *app=_app(obj),*win,*winobj;
//struct MUI_CustomClass *mcc;
char *wintitle;
ULONG id;
static ULONG lastsec=0,lastmic=0;
ULONG thissec,thismic;
CurrentTime(&thissec,&thismic);
if ((*par<MAXMCC)&&!DoubleClick(lastsec,lastmic,thissec,thismic))
	{
	lastsec=thissec;
	lastmic=thismic;
	return 0;
	}

id='WINA'+(*par);
if (!(win=(Object*)DoMethod(app,MUIM_FindUData,id)))
	{
	if (!(winobj=CreateWinContents(*par,&wintitle))) return 0;
	if (!(win=WindowObject,
		MUIA_Window_Title, wintitle,
		MUIA_Window_ID   ,id,
		MUIA_UserData, id,
		WindowContents, winobj,
		End)) { MUI_DisposeObject(winobj); return 0;}

	DoMethod(app,OM_ADDMEMBER,win);
	DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			win,3,MUIM_Set,MUIA_Window_Open,0);
	}
SetAttrs(win,MUIA_Window_Open,1);
}

struct Hook openwindowhook
 = { {0,0},(ULONG(*)())openwindowfun, NULL, NULL };

Object *myFixedLabel(char *t)
{
return TextObject,
	MUIA_Text_Contents,t,
	MUIA_FixWidthTxt,t,
	MUIA_FixHeightTxt,t,
	End;
}

Object *AddMCC(char *name)
{
struct Library *lib;
struct mccinfo *mi;
Object *icon=0;
if (mccnum>=MAXMCC) return 0;
if (lib=OldOpenLibrary(name))
	{
	if (MCCQuery(lib,1))
		{
		mi=&mcctab[mccnum++];
		mi->name=strdup(name);
		mi->lib=0;
		if (!(icon=(Object*)MCCQuery(lib,2)))
			icon=myFixedLabel("?");
		}
	CloseLibrary(lib);
	}
return icon;
}

void CloseMCCs(void)
{
while (mccnum>0) 
	{
	mccnum--;
	if (mcctab[mccnum].lib)
	if (((short)mcctab[mccnum].lib->lib_OpenCnt)>0)	// !!!!!!!
		CloseLibrary(mcctab[mccnum].lib);
	}
}

int strend(char* str,char *end)
{
int l_end=strlen(end);
int l_str=strlen(str);
if ((l_str>=l_end)&&(!stricmp(end,str+l_str-l_end))) return 1;
return 0;
}


void AddAllMCCs(Object *grp)
{
DIR *dfd;
struct dirent *dptr;
Object *o,*icon;
char path[100];

DoMethod(grp,OM_ADDMEMBER,o=SimpleButton("\nAbout\n"));
DoMethod(o,MUIM_Notify,MUIA_Selected,0,
		o,3,MUIM_CallHook,&openwindowhook,ABOUTID);


if (dfd=opendir(MCCDIR))
	{
	while (dptr=readdir(dfd))
	if ((strend(dptr->d_name,".mcp"))
	|| (strend(dptr->d_name,".mcc")))
	{
	sprintf(path,MCCDIR "/%s",dptr->d_name);
	if (icon=AddMCC(path))
		{
		SetAttrs(icon,MUIA_Frame,MUIV_Frame_Button,
			MUIA_InnerTop,5,
			MUIA_InnerBottom,5,
			MUIA_InnerLeft,5,
			MUIA_InnerRight,5,
			MUIA_InputMode,MUIV_InputMode_RelVerify,0);
		DoMethod(icon,MUIM_Notify,MUIA_Selected,0,
			icon,3,
			MUIM_CallHook,&openwindowhook,(mccnum-1));
		o=GroupObject,Child,icon,Child,myFixedLabel(dptr->d_name),End;
		DoMethod(grp,OM_ADDMEMBER,o);
		}
	}
	closedir(dfd);
	}

if (mccnum>0)
	{
	DoMethod(grp,OM_ADDMEMBER,o=SimpleButton("All\nin\nOne!"));
	DoMethod(o,MUIM_Notify,MUIA_Selected,0,
		o,3,MUIM_CallHook,&openwindowhook,ALLID);
	}
else
	{
	DoMethod(grp,OM_ADDMEMBER,Label("No MCP modules found!"));
	}

MakeItColumnGroup(grp,4);
}

void ReadMUIPrefs(Object *d,char *fname)
{
struct IFFHandle *iff;
struct ContextNode *cn;
if (iff=AllocIFF())
	{
	if (iff->iff_Stream=Open(fname,MODE_OLDFILE))
		{
		InitIFFasDOS(iff);
		if (!OpenIFF(iff,IFFF_READ))
		if (!StopChunk(iff,'PREF','MUIC'))
		if (!ParseIFF(iff,IFFPARSE_SCAN))
		if ((cn=CurrentChunk(iff)) && (cn->cn_ID=='MUIC'))
			DoMethod(d,MUIM_Dataspace_ReadIFF,iff);
		Close(iff->iff_Stream);
		}
	FreeIFF(iff);
	}
}


int main(void)
{
ULONG sigs = 0;
MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
if (!MUIMasterBase) 
	{
	puts("Can't open muimaster.library!");
	return 10;
	}
data=MUI_NewObject(MUIC_Dataspace,0);
ReadMUIPrefs(data,"ENV:mui/«Global».prefs");
	{
	Object *grp=VirtgroupObject,MUIA_Group_Spacing,10,End;
	win=WindowObject,
			MUIA_Window_Title, PROGNAME " - " MCCDIR,
			MUIA_Window_ID   , 'WIN1',
			MUIA_Window_UseBottomBorderScroller,TRUE,
			MUIA_Window_UseRightBorderScroller,TRUE,
			WindowContents, ScrollgroupObject,
				MUIA_Scrollgroup_Contents,grp,
				MUIA_Scrollgroup_UseWinBorder,TRUE,
				End,
		End;


	AddAllMCCs(grp);

	app = ApplicationObject,
		MUIA_Application_Title      , PROGNAME,
		MUIA_Application_Version    , "$VER: " PROGNAME " 1.0 (19.08.98)",
		MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
		MUIA_Application_Author     , "Szymon Ulatowski",
		MUIA_Application_Description, "MUI Custom Prefs as never seen before!",
		MUIA_Application_Base       , PROGNAME,
		SubWindow,win,
		End;
	if (app)
		{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

		while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}

		MUI_DisposeObject(app);
		} else puts("MUI can't create application!\n");
	}
CloseMCCs();
MUI_DisposeObject(data);
CloseLibrary(MUIMasterBase);
return 0;
}
