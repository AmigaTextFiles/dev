/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


#define TRPREFS_VERSION "6.2"
#define TRPREFS_RELEASE "2.0"
#define TRPREFS_DATE    "23.5.98"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON
#define TR_PREFSONLY

#include <exec/memory.h>
#include <dos/dos.h>
#include <graphics/gfx.h>
#include <libraries/reqtools.h>
#include <libraries/asl.h>
#include <libraries/triton.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/reqtools.h>
#include <proto/asl.h>
#include <proto/triton.h>
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <time.h>
#include <math.h>

#include "Triton.h"
#include "/internal.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// Library bases //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct ReqToolsBase *ReqToolsBase;
struct Library *ASLBase;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////// Stack extending //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

long __stack=16384;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Locale support //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define CATCOMP_NUMBERS
#define LS(num) GetString(&li,num)
#include <libraries/locale.h>
#include <proto/locale.h>
#include "/catalogs/tritonprefs.h"
struct Library *LocaleBase;
struct LocaleInfo li;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Global variables //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum object_ids
{
  ID_MAIN_LIST=1, ID_MAIN_INFO_BUTTON, ID_MAIN_DELETE_BUTTON,
  ID_MAIN_FRAMES_BUTTON, ID_MAIN_PENS_BUTTON, ID_MAIN_IMAGES_BUTTON, ID_MAIN_WINDOWS_BUTTON, ID_MAIN_SYSTEM_BUTTON,
  ID_MAIN_SAVE_BUTTON, ID_MAIN_USE_BUTTON, ID_MAIN_TEST_BUTTON, ID_MAIN_CANCEL_BUTTON,
  ID_MAIN_PROJECT_ABOUT, ID_MAIN_PROJECT_REMOVE,
  ID_MAIN_EDIT_DEFAULTS, ID_MAIN_EDIT_LASTSAVED, ID_MAIN_EDIT_RESTORE, ID_MAIN_EDIT_GLOBAL,
  ID_FRAMES_CYCLE_WIDTH, ID_FRAMES_CYCLE_TITLE,
  ID_FRAMES_CYCLE_KIND_BUTTON, ID_FRAMES_CYCLE_RAISED_BUTTON,
  ID_FRAMES_CYCLE_KIND_FRAMEBOX, ID_FRAMES_CYCLE_RAISED_FRAMEBOX,
  ID_FRAMES_CYCLE_KIND_GROUPBOX, ID_FRAMES_CYCLE_RAISED_GROUPBOX,
  ID_FRAMES_CYCLE_KIND_ICONDROPBOX, ID_FRAMES_CYCLE_RAISED_ICONDROPBOX,
  ID_FRAMES_CYCLE_KIND_PROGRESS, ID_FRAMES_CYCLE_RAISED_PROGRESS,
  ID_PENS_LIST_FROM, ID_PENS_LIST_TO, ID_PENS_CYCLE_TO,
  ID_IMAGES_LIST_FROM, ID_IMAGES_LIST_TO, ID_IMAGES_CYCLE_TO, ID_IMAGES_RETURN_CHECKBOX,
  ID_WINDOWS_WINDOWS_LIST,
  ID_WINDOWS_INFO_BUTTON, ID_WINDOWS_SNAPSHOT_BUTTON, ID_WINDOWS_UNSNAPSHOT_BUTTON,
  ID_WINDOWS_SNAPSHOTALL_BUTTON, ID_WINDOWS_UNSNAPSHOTALL_BUTTON,
  ID_SYSTEM_SCREENS_LIST,
  ID_SYSTEM_ADD_BUTTON, ID_SYSTEM_DELETE_BUTTON, ID_SYSTEM_EDIT_BUTTON, ID_SYSTEM_TEST_BUTTON, ID_SYSTEM_USE_BUTTON,
  ID_SYSTEM_PUBSCREEN,
  ID_SYSTEM_SIMPLEREFRESH_CHECKBOX,
  ID_SCREEN_SCREENMODE, ID_SCREEN_SCREENMODEDISPLAY, ID_SCREEN_PUBNAME, ID_SCREEN_SCREENTITLE,
  ID_SCREEN_OK_BUTTON, ID_SCREEN_CANCEL_BUTTON
};

enum window_ids
{
  WINID_MAIN=1, WINID_FRAMES, WINID_PENS, WINID_WINDOWS, WINID_SYSTEM, WINID_SCREEN, WINID_IMAGES
};


struct AppNode
{
  struct Node node;
  STRPTR name;
  STRPTR longname;
  STRPTR info;
  STRPTR version;
  STRPTR release;
  STRPTR date;
  struct TR_AppPrefs *prefs;
  BOOL globalprefs;
};

struct WindowNode
{
  struct Node node;
  ULONG id;
  struct TR_Dimensions dim;
  BOOL hasname;
};

struct FileList
{
  struct List list;
  APTR mempool;
};

struct ScreenList
{
  struct FileList fl;
  ULONG numnodes;
};


UBYTE *versionstring="\0$VER: Triton " TRPREFS_VERSION " (" TRPREFS_DATE ") Triton Preferences Editor, © 1994-1995 by Stefan Zeiger";
struct TR_App *app;
struct TR_Project *maingui, *framesgui, *pensgui, *imagesgui, *windowsgui, *systemgui;
struct FileList *applist, *systempenlist, *penkindlist, *penlist, *windowlist, *imagekindlist, *patternlist, *gfxpenlist;
struct ScreenList *screenlist;
struct AppNode *currentnode, *globalnode, *origglobalnode, *lastnode;
BOOL isglobal=TRUE,backedup=FALSE;

void update_all(void);


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////// Project locking //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

void LockAllProjects(void)
{
  if(maingui) TR_LockProject(maingui);
  if(framesgui) TR_LockProject(framesgui);
  if(windowsgui) TR_LockProject(windowsgui);
  if(pensgui) TR_LockProject(pensgui);
  if(imagesgui) TR_LockProject(imagesgui);
  if(systemgui) TR_LockProject(systemgui);
}

void UnlockAllProjects(void)
{
  if(maingui) TR_UnlockProject(maingui);
  if(framesgui) TR_UnlockProject(framesgui);
  if(windowsgui) TR_UnlockProject(windowsgui);
  if(pensgui) TR_UnlockProject(pensgui);
  if(imagesgui) TR_UnlockProject(imagesgui);
  if(systemgui) TR_UnlockProject(systemgui);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////// Requesters //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

void About(void)
{
  UBYTE reqstr[600];

  LockAllProjects();
  sprintf(reqstr,LS(MSG_ABOUT_REG),TRPREFS_RELEASE,TRPREFS_VERSION,TRPREFS_DATE,"OpenTriton","OpenTriton");
  TR_EasyRequestTags(app,reqstr,LS(MSG_OK_GAD),TREZ_Return,0,TREZ_Title,LS(MSG_ABOUT_TITLE),TAG_END);
  UnlockAllProjects();
}


void DisplayError(STRPTR str)
{
  if(app) TR_EasyRequestTags(app,str,LS(MSG_OK_GAD),TREZ_Title,LS(MSG_ERROR_TITLE),TAG_END);
  else puts(str);
}


void AppInfo(void)
{
  UBYTE reqstr[600];

  LockAllProjects();
  sprintf(reqstr,LS(MSG_APPINFO_REQUESTER),
    currentnode->longname?currentnode->longname:"???",
    currentnode->name,
    currentnode->info?currentnode->info:"???",
    currentnode->version?currentnode->version:"???",
    currentnode->release?currentnode->release:"???",
    currentnode->date?currentnode->date:"???");
  TR_EasyRequestTags(app,reqstr,LS(MSG_OK_GAD),TREZ_Title,LS(MSG_APPINFO_TITLE),TAG_END);
  UnlockAllProjects();
}


void WinInfo(struct WindowNode *WindowNode)
{
  UBYTE reqstr[600];

  LockAllProjects();
  sprintf(reqstr,LS(MSG_WININFO_REQUESTER),
    WindowNode->hasname?WindowNode->node.ln_Name:"???",
    WindowNode->id,
    WindowNode->dim.trd_Left,
    WindowNode->dim.trd_Top,
    WindowNode->dim.trd_Width,
    WindowNode->dim.trd_Height,
    WindowNode->dim.trd_Left2,
    WindowNode->dim.trd_Top2,
    WindowNode->dim.trd_Width2,
    WindowNode->dim.trd_Height2);
  TR_EasyRequestTags(app,reqstr,LS(MSG_OK_GAD),TREZ_Title,LS(MSG_WININFO_TITLE),TAG_END);
  UnlockAllProjects();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////// Public screen editor //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID SelectScreenMode(ULONG *screenmode, ULONG *screendepth)
{
  struct rtScreenModeRequester *rtreq;
  APTR aslreq;
  struct Screen *lockedscreen;

  lockedscreen=TR_LockScreen(maingui);

  if(ASLBase)
  {
    if(!(aslreq=AllocAslRequest(ASL_ScreenModeRequest,NULL))) { DisplayError(LS(MSG_ERROR_NOMEM)); return; }
    if(AslRequestTags(aslreq,ASLSM_InitialDisplayID,*screenmode,ASLSM_InitialDisplayDepth,*screendepth,ASLSM_DoDepth,TRUE,ASLSM_Screen,lockedscreen,TAG_END))
    {
      *screenmode=((struct ScreenModeRequester *)(aslreq))->sm_DisplayID;
      *screendepth=((struct ScreenModeRequester *)(aslreq))->sm_DisplayDepth;
    }
    FreeAslRequest(aslreq);
  }
  else if(ReqToolsBase)
  {
    if(!(rtreq=(struct rtScreenModeRequester *)rtAllocRequestA(RT_SCREENMODEREQ,NULL))) { DisplayError(LS(MSG_ERROR_NOMEM)); return; }
    rtChangeReqAttr((APTR)rtreq,RTSC_DisplayID,*screenmode,RTSC_DisplayDepth,*screendepth,TAG_END);
    if(rtScreenModeRequest(rtreq,LS(MSG_PICKSCREENMODE_TITLE),RT_Underscore,'_',RTSC_Flags,SCREQF_DEPTHGAD|SCREQF_GUIMODES,RT_Screen,lockedscreen,TAG_END))
    {
      *screenmode=rtreq->DisplayID;
      *screendepth=rtreq->DisplayDepth;
    }
    rtFreeRequest((APTR)rtreq);
  }
  else DisplayError(LS(MSG_ERROR_NOREQTOOLSNOASLLIB));

  if(lockedscreen) TR_UnlockScreen(lockedscreen);
}


void EditScreen(struct TR_ScreenNode *ScreenNode)
{
  struct TR_Project *screengui;
  BOOL close_me=FALSE,close_ok=FALSE;
  struct TR_Message *trmsg;
  ULONG screenmode=ScreenNode->screenmode, screendepth=ScreenNode->depth;
  struct NameInfo nameinfo;
  UBYTE smname[40];

  if(!(GetDisplayInfoData(NULL,(UBYTE *)(&nameinfo),sizeof(struct NameInfo),DTAG_NAME,screenmode))) nameinfo.Name[0]=0;
  sprintf(smname,LS(MSG_SCREEN_INFOLINE),nameinfo.Name,2<<(screendepth-1));

  if(screengui=TR_OpenProjectTags(app,
    WindowID(WINID_SCREEN), WindowTitle(LS(MSG_SCREEN_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    WindowFlags(TRWF_NOCLOSEGADGET|TRWF_NOESCCLOSE),
    HorizGroupA,
      Space,
      VertGroupA,
        Space,
        LineArray,
          BeginLine,
            TextNR(LS(MSG_SCREEN_SCREENMODE_GADGET)), TRAT_ID,ID_SCREEN_SCREENMODE,
            Space,
            HorizGroupA,TextBox(smname,ID_SCREEN_SCREENMODEDISPLAY,40),SpaceS,GetEntryButton(ID_SCREEN_SCREENMODE),EndGroup,
          EndLine,
          Space,
          BeginLine,
            TextNR(LS(MSG_SCREEN_PUBLICNAME_GADGET)), TRAT_ID,ID_SCREEN_PUBNAME,
            Space,
            StringGadget(ScreenNode->pubname,ID_SCREEN_PUBNAME),TRAT_Value,31,
          EndLine,
          Space,
          BeginLine,
            TextNR(LS(MSG_SCREEN_SCREENTITLE_GADGET)), TRAT_ID,ID_SCREEN_SCREENTITLE,
            Space,
            StringGadget(ScreenNode->title,ID_SCREEN_SCREENTITLE),TRAT_Value,123,
          EndLine,
        EndArray,
        Space,
        Line(TROF_HORIZ),
        Space,
        HorizGroupS,
          Button(LS(MSG_OK_GAD),ID_SCREEN_OK_BUTTON),
          Space,
          ButtonE(LS(MSG_CANCEL_GAD),ID_SCREEN_CANCEL_BUTTON),
        EndGroup,
        Space,
      EndGroup,
      Space,
    EndGroup, EndProject))
  {
    LockAllProjects();
    while(!close_me)
    {
      TR_Wait(app,NULL);
      while(trmsg=TR_GetMsg(app))
      {
        switch(trmsg->trm_Class)
        {
          case TRMS_ACTION:
            switch(trmsg->trm_ID)
            {
              case ID_SCREEN_SCREENMODE:
                TR_LockProject(screengui);
                SelectScreenMode(&screenmode,&screendepth);
                if(!(GetDisplayInfoData(NULL,(UBYTE *)(&nameinfo),sizeof(struct NameInfo),DTAG_NAME,screenmode))) nameinfo.Name[0]=0;
                sprintf(smname,LS(MSG_SCREEN_INFOLINE),nameinfo.Name,2<<(screendepth-1));
                TR_SetAttribute(screengui,ID_SCREEN_SCREENMODEDISPLAY,TRAT_Text,(ULONG)smname);
                TR_UnlockProject(screengui);
                break;
              case ID_SCREEN_OK_BUTTON:
                close_me=TRUE;
                close_ok=TRUE;
                break;
              case ID_SCREEN_CANCEL_BUTTON:
                close_me=TRUE;
                break;
            }
        }
        TR_ReplyMsg(trmsg);
      }
    }
    if(close_ok)
    {
      ScreenNode->screenmode=screenmode;
      ScreenNode->depth=screendepth;
      strcpy(ScreenNode->title,(STRPTR)TR_GetAttribute(screengui,ID_SCREEN_SCREENTITLE,NULL));
      TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)(~0));
      strcpy(ScreenNode->pubname,(STRPTR)TR_GetAttribute(screengui,ID_SCREEN_PUBNAME,NULL));
      TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)screenlist);
    }
    UnlockAllProjects();
    TR_CloseProject(screengui);
  }
  else DisplayBeep(NULL);
}


struct Screen * __regargs TR_OpenScreen(struct TR_ScreenNode *sn)
{
  UWORD pens[]={(UWORD)(~0)};

  return OpenScreenTags(NULL,
    SA_LikeWorkbench, TRUE,
    SA_Title,         sn->title,
    SA_Depth,         sn->depth,
    SA_Type,          CUSTOMSCREEN,
    SA_DisplayID,     sn->screenmode,
    //SA_PubName,       sn->pubname,
    SA_AutoScroll,    TRUE,
    SA_Pens,          pens,
    SA_FullPalette,   TRUE,
    TAG_DONE);
}


VOID __regargs TR_CloseScreen(struct TR_ScreenNode *sn)
{
  struct Screen *screen;

  if(screen=LockPubScreen(sn->pubname))
  {
    UnlockPubScreen(NULL,screen);
    CloseScreen(screen);
  }
}


void TestScreen(struct TR_ScreenNode *ScreenNode)
{
  struct TR_Project *testscreengui;
  BOOL close_me=FALSE;
  struct TR_Message *trmsg;
  struct Screen *screen;

  if(screen=TR_OpenScreen(ScreenNode))
  {
    if(testscreengui=TR_OpenProjectTags(app,
      WindowTitle(LS(MSG_TESTSCREEN_TITLE)),
      WindowPosition(TRWP_BELOWTITLEBAR),
      CustomScreen(screen),EndProject))
    {
      LockAllProjects();
      while(!close_me)
      {
        TR_Wait(app,NULL);
        while(trmsg=TR_GetMsg(app))
        {
          switch(trmsg->trm_Class)
          {
            case TRMS_CLOSEWINDOW:
              close_me=TRUE;
              break;
          }
          TR_ReplyMsg(trmsg);
        }
      }
      UnlockAllProjects();
      TR_CloseProject(testscreengui);
    } else DisplayBeep(NULL);
    CloseScreen(screen);
  } else DisplayBeep(NULL);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// Node and prefs handling //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL EqualAppPrefs(struct TR_AppPrefs *p1, struct TR_AppPrefs *p2)
{
  int i;

  if(p1->frames_width!=p2->frames_width) return FALSE;
  if(p1->frames_title!=p2->frames_title) return FALSE;
  for(i=0;i<3;i++)
  {
    if(p1->pentype[i]!=p2->pentype[i]) return FALSE;
    if(p1->pendata[i]!=p2->pendata[i]) return FALSE;
  }
  for(i=0;i<4;i++)
  {
    if(p1->imgtype[i]!=p2->imgtype[i]) return FALSE;
    if(p1->imgdata[i]!=p2->imgdata[i]) return FALSE;
    if(p1->frames_type[i-TRFT_ABSTRACT_BUTTON]!=p2->frames_type[i-TRFT_ABSTRACT_BUTTON]) return FALSE;
    if(p1->frames_raised[i-TRFT_ABSTRACT_BUTTON]!=p2->frames_raised[i-TRFT_ABSTRACT_BUTTON]) return FALSE;
  }
  if(strcmp(p1->pubscreen,p2->pubscreen)) return FALSE;
  if(p1->flags!=p2->flags) return FALSE;

  return TRUE;
}


struct TR_AppPrefs *GetEditorPrefs(void)
{
  struct Node *worknode,*nextnode;
  struct TR_AppPrefs *prefs;

  worknode=(struct Node *)(((struct List *)applist)->lh_Head);
  while(nextnode=(struct Node *)(worknode->ln_Succ))
  {
    if(!(strcmp(((struct AppNode *)worknode)->name,"TritonPrefs"))) goto got_one;
    worknode=nextnode;
  }
  return NULL;

  got_one:
    prefs=((struct AppNode *)worknode)->prefs;
    if(EqualAppPrefs(prefs,origglobalnode->prefs)) prefs=origglobalnode->prefs;
    return prefs;
}


struct Node *NodeFromNumber(struct List *list, ULONG num)
{
  ULONG i;
  struct Node *node=list->lh_Head;

  for(i=0;i<num;i++) node=node->ln_Succ;

  return node;
}


ULONG NumberFromNode(struct List *list, struct Node *finalnode)
{
  ULONG num=0;
  struct Node *node;

  for(node=list->lh_Head;node->ln_Succ;node=node->ln_Succ)
  {
    if(node==finalnode) return num;
    num++;
  }

  return 0;
}


BOOL LoadAppPrefs(void *pool, struct AppNode *appnode, BOOL saved)
{
  BPTR lock;
  UBYTE totalfilename[50];
  struct TR_AppPrefs *prefs;

  if(!(prefs=LibAllocPooled(pool,sizeof(struct TR_AppPrefs)))) return FALSE;
  appnode->prefs=prefs;

  if(saved) sprintf(totalfilename,"envarc:Triton/%s.tri",appnode->name);
  else sprintf(totalfilename,"env:Triton/%s.tri",appnode->name);
  if(!(lock=Open(totalfilename,MODE_OLDFILE)))
  {
    appnode->globalprefs=TRUE;
    if(!(lock=Open("env:Triton/__GLOBAL__.tri",MODE_OLDFILE)))
    {
      CopyMem((APTR)(&TR_DefaultAppPrefs),(APTR)prefs,sizeof(struct TR_AppPrefs));
      strcpy(prefs->pubscreen,LS(MSG_PRDEFSCREEN_LABEL));
      return TRUE;
    }
  }

  FRead(lock,(STRPTR)prefs,sizeof(struct TR_AppPrefs),1);

  switch(prefs->pubscreen[0])
  {
    case 1:
      strcpy(prefs->pubscreen,LS(MSG_PRDEFSCREEN_LABEL));
      break;
    case 2:
      strcpy(prefs->pubscreen,LS(MSG_DEFSCREEN_LABEL));
      break;
    case 3:
      strcpy(prefs->pubscreen,LS(MSG_WBSCREEN_LABEL));
      break;
  }
  Close(lock);

  return TRUE;
}


void FreeAppPrefs(void *pool, struct AppNode *appnode)
{
  if(!(appnode->prefs)) return;

  LibFreePooled(pool,appnode->prefs,sizeof(struct TR_AppPrefs));
  appnode->prefs=NULL;
}


BOOL SaveAppPrefs(struct AppNode *appnode, BOOL save)
{
  BPTR lock;
  UBYTE totalfilename[50],totalfilename2[50],command[100];
  struct TR_AppPrefs newprefs,*prefs=&newprefs;
  BOOL equal=FALSE;

  if(!(appnode->prefs)) return TRUE;

  CopyMem(&TR_DefaultAppPrefs,prefs,sizeof(struct TR_AppPrefs));
  prefs->flags=(appnode->prefs->flags)&(~TRPF_RETURNARROW);
  strcpy(prefs->pubscreen,appnode->prefs->pubscreen);
  CopyMem(appnode->prefs,prefs,sizeof(struct TR_AppPrefs));
  prefs->version=TR_PREFSVERSION;

  if(appnode!=globalnode)
  {
    if(appnode->globalprefs)
    {
      if(EqualAppPrefs(appnode->prefs,origglobalnode->prefs))
      {
        equal=TRUE;
      }
      else
      {
	sprintf(command,"c:copy env:Triton/%s.app envarc:Triton/",appnode->name);
	SystemTagList(command,NULL);
      }
    }
  }

  sprintf(totalfilename,"env:Triton/%s.tri",appnode->name);
  sprintf(totalfilename2,"envarc:Triton/%s.tri",appnode->name);

  if(equal)
  {
    DeleteFile(totalfilename);
    if(save) DeleteFile(totalfilename2);
    return TRUE;
  }

  if(!strcmp(prefs->pubscreen,LS(MSG_PRDEFSCREEN_LABEL))) prefs->pubscreen[0]=1;
  else if(!strcmp(prefs->pubscreen,LS(MSG_DEFSCREEN_LABEL))) prefs->pubscreen[0]=2;
  else if(!strcmp(prefs->pubscreen,LS(MSG_WBSCREEN_LABEL))) prefs->pubscreen[0]=3;

  if(!(lock=Open(totalfilename,MODE_NEWFILE))) return FALSE;
  FWrite(lock,(STRPTR)prefs,sizeof(struct TR_AppPrefs),1);
  Close(lock);

  if(save)
  {
    if(!(lock=Open(totalfilename2,MODE_NEWFILE))) return FALSE;
    FWrite(lock,(STRPTR)prefs,sizeof(struct TR_AppPrefs),1);
    Close(lock);
  }

  return TRUE;
}


BOOL SaveAllAppPrefs(struct FileList *fl, BOOL save)
{
  struct Node *worknode,*nextnode;
  BOOL retval=TRUE;

  worknode=(struct Node *)(((struct List *)fl)->lh_Head);
  while(nextnode=(struct Node *)(worknode->ln_Succ))
  {
    if(!(SaveAppPrefs((struct AppNode *)worknode,save))) retval=FALSE;
    worknode=nextnode;
  }

  return retval;
}


struct AppNode *GetAppNode(void *pool, STRPTR filename)
{
  struct AppNode *appnode;
  BPTR lock;
  ULONG val;

  if(!(strstr(filename,".app"))) return NULL;

  if(!(appnode=LibAllocPooled(pool,sizeof(struct AppNode)))) return NULL;

  if(lock=Open(filename,MODE_OLDFILE))
  {
    // Short name
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->name=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->name,val,1);
      appnode->name[val]=0;
    }
    else goto broken;

    // Long name
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->longname=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->longname,val,1);
      appnode->longname[val]=0;
    }
    else goto broken;

    // Info
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->info=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->info,val,1);
      appnode->info[val]=0;
    }
    else goto broken;

    // Version
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->version=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->version,val,1);
      appnode->version[val]=0;
    }
    else goto broken;

    // Release
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->release=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->release,val,1);
      appnode->release[val]=0;
    }
    else goto broken;

    // Date
    FRead(lock,(STRPTR)(&val),4,1);
    if(val) if(appnode->date=LibAllocPooled(pool,val+1))
    {
      FRead(lock,appnode->date,val,1);
      appnode->date[val]=0;
    }
    else goto broken;

    Close(lock);
  }
  broken:

  appnode->node.ln_Name=appnode->longname?appnode->longname:appnode->name;

  if(!(LoadAppPrefs(pool,appnode,FALSE))) return NULL;

  return appnode;
}


struct AppNode *GetGlobalNode(void *pool)
{
  struct AppNode *appnode;
  STRPTR  longname  = LS(MSG_GLOBALNAME);

  if(!(appnode=LibAllocPooled(pool,sizeof(struct AppNode)))) return NULL;
  if(!(appnode->name=LibAllocPooled(pool,11))) return NULL;
  if(!(appnode->longname=LibAllocPooled(pool,strlen(longname)+1))) return NULL;

  strcpy(appnode->name,"__GLOBAL__");
  strcpy(appnode->longname,longname);

  appnode->node.ln_Name=appnode->longname;

  if(!(LoadAppPrefs(pool,appnode,FALSE))) return NULL;

  lastnode=currentnode;
  currentnode=appnode;
  return appnode;
}


void DeleteFileList(struct FileList *fl)
{
  if(!fl) return;
  LibDeletePool(fl->mempool);
}


struct FileList *CreateAppList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;
  struct FileInfoBlock *fib=NULL;
  BPTR lock;
  BOOL ok=TRUE;
  UBYTE totalfilename[50];

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)fl);

  origglobalnode=GetGlobalNode(pool);
  if(node=GetGlobalNode(pool)) AddTail((struct List *)fl,node);
  globalnode=(struct AppNode *)node;

  if(!(lock=Lock("env:Triton",ACCESS_READ))) { ok=FALSE; goto cleanup; }
  if(!(fib=(struct FileInfoBlock *)AllocDosObject(DOS_FIB,NULL))) { ok=FALSE; goto cleanup; }
  if(!(Examine(lock,fib))) { ok=FALSE; goto cleanup; }
  while(ExNext(lock,fib))
  {
    sprintf(totalfilename,"env:Triton/%s",fib->fib_FileName);
    if(node=GetAppNode(pool,totalfilename)) AddTail((struct List *)fl,node);
  }

  cleanup:
  if(fib) FreeDosObject(DOS_FIB,(void *)fib);
  if(lock) UnLock(lock);
  if(ok) return fl;
  DeleteFileList(fl);
  return NULL;
}


struct Node *GetTextNode(void *pool, STRPTR text)
{
  struct Node *node;

  if(!(node=LibAllocPooled(pool,sizeof(struct Node)))) return NULL;
  if(!(node->ln_Name=LibAllocPooled(pool,strlen(text)+1))) return NULL;
  strcpy(node->ln_Name,text);
  return node;
}


struct FileList *CreateSystemPenList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)(fl));

  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_DETAILPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_BLOCKPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_TEXTPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_SHINEPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_SHADOWPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_FILLPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_FILLTEXTPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_BACKGROUNDPEN))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_SYSTEMPEN_HIGHLIGHTTEXTPEN))) AddTail((struct List *)fl,node);

  cleanup:
  return fl;
}


struct FileList *CreatePenKindList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)(fl));

  if(node=GetTextNode(pool,LS(MSG_PENKIND_NORMUSCORE))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_HIGHUSCORE))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_HALFSHINE))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_HALFSHADOW))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_USSTRINGGADBACK))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_SSTRINGGADBACK))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_USSTRINGGADFRONT))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PENKIND_SSTRINGGADFRONT))) AddTail((struct List *)fl,node);

  cleanup:
  return fl;
}


struct FileList *CreatePenList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)(fl));

  if(node=GetTextNode(pool,LS(MSG_COLOR_0))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_1))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_2))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_3))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_4))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_5))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_6))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_COLOR_7))) AddTail((struct List *)fl,node);

  cleanup:
  return fl;
}


struct FileList *CreatePatternList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)(fl));

  if(node=GetTextNode(pool,LS(MSG_PATTERN_BACKGROUND))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHINE))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHINE_SHADOW))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHINE_FILL))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHINE_BACKGROUND))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHADOW))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHADOW_FILL))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_SHADOW_BACKGROUND))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_FILL))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_PATTERN_FILL_BACKGROUND))) AddTail((struct List *)fl,node);

  cleanup:
  return fl;
}

struct FileList *CreateImageKindList(void)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)(fl));

  if(node=GetTextNode(pool,LS(MSG_IMAGE_WINBACK))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_IMAGE_REQBACK))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_IMAGE_USBUTTONBACK))) AddTail((struct List *)fl,node);
  if(node=GetTextNode(pool,LS(MSG_IMAGE_SBUTTONBACK))) AddTail((struct List *)fl,node);

  cleanup:
  return fl;
}

void DeleteApp(struct AppNode *node)
{
  UBYTE commandname[200];
  ULONG cnodenum;

  sprintf(commandname,"c:delete <nil: >nil: envarc:Triton/%s.#? env:Triton/%s.#?",node->name,node->name);
  SystemTagList(commandname,NULL);

  TR_SetAttribute(maingui,ID_MAIN_LIST,NULL,(ULONG)(~0));
  Remove((struct Node *)node);
  TR_SetAttribute(maingui,ID_MAIN_LIST,NULL,(ULONG)(applist));

  cnodenum=TR_GetAttribute(maingui,ID_MAIN_LIST,TRAT_Value);
  lastnode=currentnode;
  currentnode=(struct AppNode *)NodeFromNumber((struct List *)applist,cnodenum);
  update_all();
  if(!cnodenum)
  {
    if(!isglobal)
    {
      TR_SetAttribute(maingui,ID_MAIN_DELETE_BUTTON,TRAT_Disabled,TRUE);
      TR_SetAttribute(maingui,ID_MAIN_INFO_BUTTON,TRAT_Disabled,TRUE);
      TR_SetAttribute(maingui,ID_MAIN_EDIT_GLOBAL,TRAT_Disabled,TRUE);
    }
    isglobal=TRUE;
  }
}


void SetScreenListPos(ULONG pos)
{
  BOOL disabled=FALSE;

  TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value,pos);
  if(pos<3) disabled=TRUE;
  TR_SetAttribute(systemgui,ID_SYSTEM_DELETE_BUTTON,TRAT_Disabled,disabled);
  TR_SetAttribute(systemgui,ID_SYSTEM_EDIT_BUTTON,TRAT_Disabled,disabled);
  TR_SetAttribute(systemgui,ID_SYSTEM_TEST_BUTTON,TRAT_Disabled,disabled);
}


struct Node *AddScreenNode(struct ScreenList *sl, STRPTR pubname)
{
  struct TR_ScreenNode *node;
  void *pool=sl->fl.mempool;
  struct Screen *wbscreen;

  if(!(node=(struct TR_ScreenNode *)LibAllocPooled(pool,sizeof(struct TR_ScreenNode)))) return NULL;
  strcpy(node->pubname,pubname);
  node->node.ln_Name=node->pubname;
  AddTail((struct List *)sl,node);
  node->id=++(sl->numnodes);
  node->version=TR_PREFSVERSION;

  if(node->id>2)
  {
    if(wbscreen=LockPubScreen(NULL))
    {
      node->screenmode=GetVPModeID(&wbscreen->ViewPort);
      if(node->screenmode==INVALID_ID) node->screenmode=167936;
      node->depth=wbscreen->BitMap.Depth;
      UnlockPubScreen(NULL,wbscreen);
    }
    else
    {
      node->screenmode=167936;
      node->depth=2;
    }
  }

  return node;
}


void DeleteScreenNode(struct ScreenList *sl, struct TR_ScreenNode *node)
{
  ULONG csnodenum;
  struct Node *realnode=(struct Node *)node;

  // Calculate new selected node
  csnodenum=TR_GetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value);
  if(!(((struct Node *)(node))->ln_Succ->ln_Succ)) csnodenum--;

  // Actually remove the node
  TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)(~0));
  Remove(realnode);
  TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)(sl));

  // Update the listview gadget
  SetScreenListPos(csnodenum);
}


BOOL LoadScreenList(struct ScreenList *sl)
{
  BPTR lock;
  struct TR_ScreenNode *node;

  if(!(lock=Open("env:Triton/Screens.trc",MODE_OLDFILE))) return TRUE;

  if(!(FRead(lock,(STRPTR)(&(sl->numnodes)),4,1))) { Close(lock); return FALSE; }

  for(;;)
  {
    if(!(node=LibAllocPooled(sl->fl.mempool,sizeof(struct TR_ScreenNode)))) { Close(lock); return FALSE; }
    if(!(FRead(lock,(STRPTR)node,sizeof(struct TR_ScreenNode),1))) break;
    node->node.ln_Name=node->pubname;
    AddTail((struct List *)sl,node);
  }

  Close(lock);
  return TRUE;
}


BOOL SaveScreenList(struct ScreenList *sl,STRPTR filename)
{
  BPTR lock;
  struct Node *node;

  if(!(lock=Open(filename,MODE_NEWFILE))) return FALSE;

  if(!(FWrite(lock,(STRPTR)(&(sl->numnodes)),4,1))) { Close(lock); return FALSE; }

  for(node=sl->fl.list.lh_Head->ln_Succ->ln_Succ->ln_Succ;node->ln_Succ;node=node->ln_Succ)
  {
    FWrite(lock,(STRPTR)node,sizeof(struct TR_ScreenNode),1);
  }

  Close(lock);
  return TRUE;
}


struct ScreenList *CreateScreenList(void)
{
  struct ScreenList *sl;
  void *pool;

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(sl=LibAllocPooled(pool,sizeof(struct ScreenList)))) { LibDeletePool(pool); return NULL; }
  sl->fl.mempool=pool;
  NewList((struct List *)(sl));

  AddScreenNode(sl,LS(MSG_PRDEFSCREEN_LABEL));
  AddScreenNode(sl,LS(MSG_DEFSCREEN_LABEL));
  AddScreenNode(sl,LS(MSG_WBSCREEN_LABEL));

  LoadScreenList(sl);

  return sl;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// Window manager file handling //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct WindowNode *GetWindowNode(void *pool, struct AppNode *app, STRPTR filename)
{
  struct WindowNode *WindowNode;
  BPTR lock;
  ULONG val;
  UBYTE name[50];

  sprintf(name,"%s.win.",app->name);
  if(!(strstr(filename,name))) return NULL;

  if(!(WindowNode=LibAllocPooled(pool,sizeof(struct WindowNode)))) return NULL;

  if(lock=Open(filename,MODE_OLDFILE))
  {
    FRead(lock,(STRPTR)(&(WindowNode->dim)),sizeof(struct TR_Dimensions),1);

    WindowNode->id=atol(&filename[strlen(app->name)+16]);

    FRead(lock,(STRPTR)(&val),4,1);
    if(val)
    {
      if(WindowNode->node.ln_Name=LibAllocPooled(pool,val+1))
      {
        WindowNode->hasname=TRUE;
        FRead(lock,WindowNode->node.ln_Name,val,1);
        WindowNode->node.ln_Name[val]=0;
      }
      else { WindowNode->node.ln_Name=NULL; DisplayBeep(NULL); }
    }
    else
    {
      sprintf(name,"[%ld]",WindowNode->id);
      if(WindowNode->node.ln_Name=LibAllocPooled(pool,strlen(name)+1))
      {
        CopyMem((APTR)name,(APTR)(WindowNode->node.ln_Name),strlen(name)+1);
      }
      else { WindowNode->node.ln_Name=NULL; DisplayBeep(NULL); }
    }

    Close(lock);
  }

  return WindowNode;
}


VOID SaveWindowNode(struct AppNode *app, struct WindowNode *WindowNode)
{
  BPTR lock;
  ULONG val;
  UBYTE name[50];

  sprintf(name,"envarc:Triton/%s.win.%ld",app->name,WindowNode->id);

  if(lock=Open(name,MODE_NEWFILE))
  {
    FWrite(lock,(STRPTR)(&(WindowNode->dim)),sizeof(struct TR_Dimensions),1);
    if(WindowNode->hasname)
    {
      val=strlen(WindowNode->node.ln_Name);
      FWrite(lock,(STRPTR)(&val),4,1);
      FWrite(lock,WindowNode->node.ln_Name,val,1);
    }
    else { val=NULL; FWrite(lock,(STRPTR)val,4,1); }
    Close(lock);
  }
  else DisplayBeep(NULL);
}


VOID SaveAllWindowNodes(struct AppNode *app, struct FileList *fl)
{
  struct Node *node=((struct List *)fl)->lh_Head;
  for(;node->ln_Succ;node=node->ln_Succ) SaveWindowNode(app,(struct WindowNode *)node);
}


VOID DeleteWindowNode(struct AppNode *app, struct WindowNode *WindowNode)
{
  UBYTE name[50];

  sprintf(name,"env:Triton/%s.win.%ld",app->name,WindowNode->id);
  DeleteFile(name);
  sprintf(name,"envarc:Triton/%s.win.%ld",app->name,WindowNode->id);
  DeleteFile(name);
}


VOID DeleteAllWindowNodes(struct AppNode *app, struct FileList *fl)
{
  struct Node *node=((struct List *)fl)->lh_Head;
  for(;node->ln_Succ;node=node->ln_Succ) DeleteWindowNode(app,(struct WindowNode *)node);
}


struct FileList *CreateWindowList(struct AppNode *app)
{
  struct FileList *fl;
  struct Node *node;
  void *pool;
  struct FileInfoBlock *fib=NULL;
  BPTR lock;
  BOOL ok=TRUE;
  UBYTE totalfilename[50];

  if(!(pool=LibCreatePool(MEMF_CLEAR,1024,512))) return NULL;
  if(!(fl=LibAllocPooled(pool,sizeof(struct FileList)))) { LibDeletePool(pool); return NULL; }
  fl->mempool=pool;
  NewList((struct List *)fl);

  if(!(lock=Lock("env:Triton",ACCESS_READ))) { ok=FALSE; goto cleanup; }
  if(!(fib=(struct FileInfoBlock *)AllocDosObject(DOS_FIB,NULL))) { ok=FALSE; goto cleanup; }
  if(!(Examine(lock,fib))) { ok=FALSE; goto cleanup; }
  while(ExNext(lock,fib))
  {
    sprintf(totalfilename,"env:Triton/%s",fib->fib_FileName);
    if(node=GetWindowNode(pool,app,totalfilename)) AddTail((struct List *)fl,node);
  }

  cleanup:
  if(fib) FreeDosObject(DOS_FIB,(void *)fib);
  if(lock) UnLock(lock);
  if(ok) return fl;
  DeleteFileList(fl);
  return NULL;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Main window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL open_main(void)
{
  if(maingui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_MAIN), WindowTitle(LS(MSG_MAIN_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    WindowFlags(TRWF_NOESCCLOSE),
    BeginMenu(LS(MSG_MAIN_PROJECT_MENU)),
      MenuItem(LS(MSG_MAIN_PROJECT_REMOVE),ID_MAIN_PROJECT_REMOVE),
      ItemBarlabel,
      MenuItem(LS(MSG_MAIN_PROJECT_ABOUT),ID_MAIN_PROJECT_ABOUT),
      ItemBarlabel,
      MenuItem(LS(MSG_MAIN_PROJECT_QUIT),ID_MAIN_CANCEL_BUTTON),
    BeginMenu(LS(MSG_MAIN_EDIT_MENU)),
      MenuItem(LS(MSG_MAIN_EDIT_DEFAULTS),ID_MAIN_EDIT_DEFAULTS),
      MenuItem(LS(MSG_MAIN_EDIT_LASTSAVED),ID_MAIN_EDIT_LASTSAVED),
      MenuItem(LS(MSG_MAIN_EDIT_RESTORE),ID_MAIN_EDIT_RESTORE),
      ItemBarlabel,
      MenuItemD(LS(MSG_MAIN_EDIT_GLOBAL),ID_MAIN_EDIT_GLOBAL),
    HorizGroupA,
      Space,
      VertGroupA,
        Space,
        HorizGroupA,
          VertGroupA,
            HorizGroupAC,
              Line(TROF_HORIZ),
              Space,
              TextT(LS(MSG_MAIN_APPLICATIONS_GADGET)),
              Space,
              Line(TROF_HORIZ),
            EndGroup,
            Space,
            ListSS(applist,ID_MAIN_LIST,0,0),
            HorizGroupEA,
              Button(LS(MSG_MAIN_INFO_GADGET),ID_MAIN_INFO_BUTTON),TRAT_Disabled,TRUE,
              Button(LS(MSG_MAIN_DELETE_GADGET),ID_MAIN_DELETE_BUTTON),TRAT_Disabled,TRUE,
            EndGroup,
          EndGroup,
          Space,
          Line(TROF_VERT),
          Space,
          VertGroupA|TRGR_FIXHORIZ,
            Button(LS(MSG_MAIN_FRAMES_GADGET),ID_MAIN_FRAMES_BUTTON),
            Space,
            Button(LS(MSG_MAIN_PENS_GADGET),ID_MAIN_PENS_BUTTON),
            Space,
            Button(LS(MSG_MAIN_IMAGES_GADGET),ID_MAIN_IMAGES_BUTTON),
            Space,
            Button(LS(MSG_MAIN_WINDOWS_GADGET),ID_MAIN_WINDOWS_BUTTON),
            VertGroupS, Space, EndGroup,
            Button(LS(MSG_MAIN_SYSTEM_GADGET),ID_MAIN_SYSTEM_BUTTON),
          EndGroup,
        EndGroup,
        Space,
        Line(TROF_HORIZ),
        Space,
        HorizGroupS,
          Button(LS(MSG_MAIN_SAVE_GADGET),ID_MAIN_SAVE_BUTTON),
          Space,
          Button(LS(MSG_MAIN_USE_GADGET),ID_MAIN_USE_BUTTON),
          Space,
          Button(LS(MSG_MAIN_TEST_GADGET),ID_MAIN_TEST_BUTTON),
          Space,
          ButtonE(LS(MSG_CANCEL_GAD),ID_MAIN_CANCEL_BUTTON),
        EndGroup,
        Space,
      EndGroup,
      Space,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void close_main(void)
{
  if(maingui)
  {
    TR_CloseProject(maingui);
    maingui=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// Frames window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

STRPTR frames_width_entries[3];
STRPTR frames_title_entries[4];
STRPTR frames_raised_entries[3];
STRPTR frames_kind_entries[7];


BOOL open_frames(void)
{
  frames_width_entries[0]=LS(MSG_CYCLE_WIDTH_THIN);
  frames_width_entries[1]=LS(MSG_CYCLE_WIDTH_THICK);
  frames_title_entries[0]=LS(MSG_CYCLE_TITLE_NORMAL);
  frames_title_entries[1]=LS(MSG_CYCLE_TITLE_HIGHLIGHT);
  frames_title_entries[2]=LS(MSG_CYCLE_TITLE_SHADOW);
  frames_raised_entries[0]=LS(MSG_CYCLE_RAISED_RAISED);
  frames_raised_entries[1]=LS(MSG_CYCLE_RAISED_RECESSED);
  frames_kind_entries[0]=LS(MSG_CYCLE_KIND_STANDARD);
  frames_kind_entries[1]=LS(MSG_CYCLE_KIND_STRING);
  frames_kind_entries[2]=LS(MSG_CYCLE_KIND_ICONDROPBOX);
  frames_kind_entries[3]=LS(MSG_CYCLE_KIND_XENBUTTON1);
  frames_kind_entries[4]=LS(MSG_CYCLE_KIND_XENBUTTON2);
  frames_kind_entries[5]=LS(MSG_CYCLE_KIND_NEXTBUTTON);

  if(framesgui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_FRAMES), WindowTitle(LS(MSG_FRAMES_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupA,
      Space,
      LineArray,
        BeginLine,
          Space,
          TextNR(LS(MSG_FRAMES_WIDTH_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_WIDTH,
          Space,
          CycleGadget(frames_width_entries,currentnode->prefs->frames_width,ID_FRAMES_CYCLE_WIDTH),
          Space,
        EndLine,
        Space,
        BeginLine,
          Space,
          TextNR(LS(MSG_FRAMES_TITLE_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_TITLE,
          Space,
          CycleGadget(frames_title_entries,currentnode->prefs->frames_title,ID_FRAMES_CYCLE_TITLE),
          Space,
        EndLine,
      EndArray,
      Space,
      HorizGroupA,
        Space,
        NamedFrameBox(LS(MSG_FRAMES_FRAMETYPES_TEXT)),ObjectBackfillWin,
          LineArray,
            Space,
            BeginLine,
              Space,
              TextNR(LS(MSG_FRAMES_KIND_BUTTON_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_KIND_BUTTON,
              Space,
              CycleGadget(frames_kind_entries,currentnode->prefs->frames_type[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON]-1,ID_FRAMES_CYCLE_KIND_BUTTON),
              Space,
              TextN("_1"), TRAT_ID,ID_FRAMES_CYCLE_RAISED_BUTTON,
              Space,
              CycleGadget(frames_raised_entries,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON])?0:1,ID_FRAMES_CYCLE_RAISED_BUTTON),
              Space,
            EndLine,
            Space,
            BeginLine,
              Space,
              TextNR(LS(MSG_FRAMES_KIND_FRAMEBOX_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_KIND_FRAMEBOX,
              Space,
              CycleGadget(frames_kind_entries,currentnode->prefs->frames_type[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON]-1,ID_FRAMES_CYCLE_KIND_FRAMEBOX),
              Space,
              TextN("_2"), TRAT_ID,ID_FRAMES_CYCLE_RAISED_FRAMEBOX,
              Space,
              CycleGadget(frames_raised_entries,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON])?0:1,ID_FRAMES_CYCLE_RAISED_FRAMEBOX),
              Space,
            EndLine,
            Space,
            BeginLine,
              Space,
              TextNR(LS(MSG_FRAMES_KIND_GROUPBOX_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_KIND_GROUPBOX,
              Space,
              CycleGadget(frames_kind_entries,currentnode->prefs->frames_type[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON]-1,ID_FRAMES_CYCLE_KIND_GROUPBOX),
              Space,
              TextN("_3"), TRAT_ID,ID_FRAMES_CYCLE_RAISED_GROUPBOX,
              Space,
              CycleGadget(frames_raised_entries,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON])?0:1,ID_FRAMES_CYCLE_RAISED_GROUPBOX),
              Space,
            EndLine,
            Space,
            BeginLine,
              Space,
              TextNR(LS(MSG_FRAMES_KIND_ICONDROPBOX_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_KIND_ICONDROPBOX,
              Space,
              CycleGadget(frames_kind_entries,currentnode->prefs->frames_type[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON]-1,ID_FRAMES_CYCLE_KIND_ICONDROPBOX),
              Space,
              TextN("_4"), TRAT_ID,ID_FRAMES_CYCLE_RAISED_ICONDROPBOX,
              Space,
              CycleGadget(frames_raised_entries,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON])?0:1,ID_FRAMES_CYCLE_RAISED_ICONDROPBOX),
              Space,
            EndLine,
            Space,
            BeginLine,
              Space,
              TextNR(LS(MSG_FRAMES_KIND_PROGRESS_GADGET)), TRAT_ID,ID_FRAMES_CYCLE_KIND_PROGRESS,
              Space,
              CycleGadget(frames_kind_entries,currentnode->prefs->frames_type[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON]-1,ID_FRAMES_CYCLE_KIND_PROGRESS),
              Space,
              TextN("_5"), TRAT_ID,ID_FRAMES_CYCLE_RAISED_PROGRESS,
              Space,
              CycleGadget(frames_raised_entries,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON])?0:1,ID_FRAMES_CYCLE_RAISED_PROGRESS),
              Space,
            EndLine,
            Space,
          EndArray,
        Space,
      EndGroup,
      Space,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void update_frames(void)
{
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_WIDTH,TRAT_Value,currentnode->prefs->frames_width);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_TITLE,TRAT_Value,currentnode->prefs->frames_title);

  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_KIND_FRAMEBOX,TRAT_Value,currentnode->prefs->frames_type[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON]-1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_RAISED_FRAMEBOX,TRAT_Value,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON])?0:1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_KIND_GROUPBOX,TRAT_Value,currentnode->prefs->frames_type[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON]-1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_RAISED_GROUPBOX,TRAT_Value,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON])?0:1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_KIND_BUTTON,TRAT_Value,currentnode->prefs->frames_type[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON]-1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_RAISED_BUTTON,TRAT_Value,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON])?0:1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_KIND_ICONDROPBOX,TRAT_Value,currentnode->prefs->frames_type[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON]-1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_RAISED_ICONDROPBOX,TRAT_Value,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON])?0:1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_KIND_PROGRESS,TRAT_Value,currentnode->prefs->frames_type[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON]-1);
  TR_SetAttribute(framesgui,ID_FRAMES_CYCLE_RAISED_PROGRESS,TRAT_Value,(currentnode->prefs->frames_raised[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON])?0:1);
}


void close_frames(void)
{
  if(framesgui)
  {
    TR_CloseProject(framesgui);
    framesgui=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Pens window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

STRPTR pens_to_entries[3];


BOOL open_pens(void)
{
  BOOL rightpens;
  ULONG rightnum;

  pens_to_entries[0]=LS(MSG_CYCLE_PENTYPE_SYSTEMPEN);
  pens_to_entries[1]=LS(MSG_CYCLE_PENTYPE_PEN);

  systempenlist=CreateSystemPenList();
  penkindlist=CreatePenKindList();
  penlist=CreatePenList();

  rightpens=(BOOL)(currentnode->prefs->pentype[0]);
  rightnum=currentnode->prefs->pendata[0];

  if(pensgui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_PENS), WindowTitle(LS(MSG_PENS_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    HorizGroupEAC,
      Space,
      VertGroupAC,
        Space,
        ListSSN(penkindlist,ID_PENS_LIST_FROM,0,0),
        Space,
      EndGroup,
      Space,
      VertGroupAC,
        Space,
        HorizGroupAC, TextN(LS(MSG_PENS_TYPE_GADGET)),TRAT_ID,ID_PENS_CYCLE_TO, Space, CycleGadget(pens_to_entries,rightpens?1:0,ID_PENS_CYCLE_TO), EndGroup,
        Space,
        ListSSC(rightpens?penlist:systempenlist,ID_PENS_LIST_TO,0,rightnum),
        Space,
      EndGroup,
      Space,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void update_pens(void)
{
  BOOL rightpens;
  UBYTE cback;
  ULONG pennum;

  pennum=TR_GetAttribute(pensgui,ID_PENS_LIST_FROM,TRAT_Value);
  cback=currentnode->prefs->pendata[pennum];
  rightpens=(BOOL)(currentnode->prefs->pentype[pennum]);

  TR_SetAttribute(pensgui,ID_PENS_CYCLE_TO,TRAT_Value,rightpens?1:0);
  TR_SetAttribute(pensgui,ID_PENS_LIST_TO,NULL,(ULONG)(rightpens?penlist:systempenlist));
  TR_SetAttribute(pensgui,ID_PENS_LIST_TO,TRAT_Value,cback);
}


void close_pens(void)
{
  if(pensgui)
  {
    TR_CloseProject(pensgui);
    if(penlist) DeleteFileList(penlist);
    if(penkindlist) DeleteFileList(penkindlist);
    if(systempenlist) DeleteFileList(systempenlist);
    pensgui=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// Images window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

STRPTR images_to_entries[3];


BOOL open_images(void)
{
  BOOL rightimages;
  ULONG rightnum;

  images_to_entries[0]=LS(MSG_CYCLE_PATTERNTYPE_BFPATTERN);
  images_to_entries[1]=LS(MSG_CYCLE_PATTERNTYPE_PEN);

  imagekindlist=CreateImageKindList();
  patternlist=CreatePatternList();
  gfxpenlist=CreatePenList();

  rightimages=(BOOL)(currentnode->prefs->imgtype[0]);
  rightnum=currentnode->prefs->imgdata[0]-2;

  if(imagesgui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_IMAGES), WindowTitle(LS(MSG_IMAGES_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    VertGroupAC,
      HorizGroupEAC,
        Space,
        VertGroupAC,
          Space,
          ListSSN(imagekindlist,ID_IMAGES_LIST_FROM,0,0),
          Space,
        EndGroup,
        Space,
        VertGroupAC,
          Space,
          HorizGroupAC, TextN(LS(MSG_IMAGES_TYPE_GADGET)),TRAT_ID,ID_IMAGES_CYCLE_TO, Space, CycleGadget(images_to_entries,rightimages?1:0,ID_IMAGES_CYCLE_TO), EndGroup,
          Space,
          ListSSC(rightimages?gfxpenlist:patternlist,ID_IMAGES_LIST_TO,0,rightnum),
          Space,
        EndGroup,
        Space,
      EndGroup,
      HorizGroupA,
        Space,
        CheckBox(ID_IMAGES_RETURN_CHECKBOX),TRAT_Value, (currentnode->prefs->flags&TRPF_RETURNARROW)?TRUE:FALSE,
        Space,
        TextID(LS(MSG_IMAGES_RETURN_CHECKBOX),ID_IMAGES_RETURN_CHECKBOX),
        HorizGroupS,Space,EndGroup,
      EndGroup,
      Space,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void update_images(void)
{
  BOOL rightimages;
  UBYTE cback;
  ULONG imagenum;

  imagenum=TR_GetAttribute(imagesgui,ID_IMAGES_LIST_FROM,TRAT_Value);
  cback=currentnode->prefs->imgdata[imagenum]-2;
  rightimages=(BOOL)(currentnode->prefs->imgtype[imagenum]);

  TR_SetAttribute(imagesgui,ID_IMAGES_CYCLE_TO,TRAT_Value,rightimages?1:0);
  TR_SetAttribute(imagesgui,ID_IMAGES_LIST_TO,NULL,(ULONG)(rightimages?gfxpenlist:patternlist));
  TR_SetAttribute(imagesgui,ID_IMAGES_LIST_TO,TRAT_Value,cback);
  TR_SetAttribute(imagesgui,ID_IMAGES_RETURN_CHECKBOX,TRAT_Value,(ULONG)((currentnode->prefs->flags&TRPF_RETURNARROW)?TRUE:FALSE));
}


void close_images(void)
{
  if(imagesgui)
  {
    TR_CloseProject(imagesgui);
    if(imagekindlist) DeleteFileList(imagekindlist);
    if(patternlist) DeleteFileList(patternlist);
    if(gfxpenlist) DeleteFileList(gfxpenlist);
    imagesgui=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Windows window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL open_windows(void)
{
  BOOL WinDisabled=FALSE;

  LockAllProjects();
  windowlist=CreateWindowList(currentnode);
  UnlockAllProjects();

  if(((struct List *)(windowlist))->lh_Head->ln_Succ==NULL) WinDisabled=TRUE;

  if(windowsgui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_WINDOWS), WindowTitle(LS(MSG_WINDOWS_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    HorizGroupA,
      Space,
      VertGroupA,
        Space,
        HorizGroupA,
          VertGroupA,
            HorizGroupAC,
              Line(TROF_HORIZ),
              Space,
              TextT(LS(MSG_WINDOWS_WINDOWS_GADGET)),
              Space,
              Line(TROF_HORIZ),
            EndGroup,
            Space,
            ListSS(windowlist,ID_WINDOWS_WINDOWS_LIST,0,0),
            Button(LS(MSG_WINDOWS_INFO_GADGET),ID_WINDOWS_INFO_BUTTON),TRAT_Disabled,WinDisabled,
            HorizGroupEA,
              Button(LS(MSG_WINDOWS_SNAPSHOT_GADGET),ID_WINDOWS_SNAPSHOT_BUTTON),TRAT_Disabled,WinDisabled,
              Button(LS(MSG_WINDOWS_UNSNAPSHOT_GADGET),ID_WINDOWS_UNSNAPSHOT_BUTTON),TRAT_Disabled,WinDisabled,
            EndGroup,
            HorizGroupEA,
              Button(LS(MSG_WINDOWS_SNAPSHOTALL_GADGET),ID_WINDOWS_SNAPSHOTALL_BUTTON),TRAT_Disabled,WinDisabled,
              Button(LS(MSG_WINDOWS_UNSNAPSHOTALL_GADGET),ID_WINDOWS_UNSNAPSHOTALL_BUTTON),TRAT_Disabled,WinDisabled,
            EndGroup,
          EndGroup,
          Space,
        EndGroup,
        Space,
      EndGroup,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void update_windows(void)
{
  BOOL WinDisabled=FALSE;

  LockAllProjects();

  if(windowlist)
  {
    DeleteFileList(windowlist);
    windowlist=CreateWindowList(currentnode);
    if(((struct List *)(windowlist))->lh_Head->ln_Succ==NULL) WinDisabled=TRUE;
    TR_SetAttribute(windowsgui,ID_WINDOWS_WINDOWS_LIST,NULL,(ULONG)windowlist);
    TR_SetAttribute(windowsgui,ID_WINDOWS_INFO_BUTTON,TRAT_Disabled,WinDisabled);
    TR_SetAttribute(windowsgui,ID_WINDOWS_SNAPSHOT_BUTTON,TRAT_Disabled,WinDisabled);
    TR_SetAttribute(windowsgui,ID_WINDOWS_SNAPSHOTALL_BUTTON,TRAT_Disabled,WinDisabled);
    TR_SetAttribute(windowsgui,ID_WINDOWS_UNSNAPSHOT_BUTTON,TRAT_Disabled,WinDisabled);
    TR_SetAttribute(windowsgui,ID_WINDOWS_UNSNAPSHOTALL_BUTTON,TRAT_Disabled,WinDisabled);
  }

  UnlockAllProjects();
}


void close_windows(void)
{
  if(windowsgui)
  {
    TR_CloseProject(windowsgui);
    windowsgui=NULL;
    if(windowlist) DeleteFileList(windowlist);
    windowlist=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// System window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL open_system(void)
{
  if(systemgui=TR_OpenProjectTags
  (
    app,
    WindowID(WINID_SYSTEM), WindowTitle(LS(MSG_SYSTEM_TITLE)), WindowPosition(TRWP_CENTERDISPLAY),
    HorizGroupA,
      Space,
      VertGroupA,
        Space,
        NamedSeparatorN(LS(MSG_SYSTEM_PUBSCREENS_GADGET)),
        Space,
        StringGadget(currentnode->prefs->pubscreen,ID_SYSTEM_PUBSCREEN),TRAT_Value,31,
        Space,
        ListSS(screenlist,ID_SYSTEM_SCREENS_LIST,0,0),
        HorizGroupEA,
          Button(LS(MSG_SYSTEM_ADD_GADGET),ID_SYSTEM_ADD_BUTTON),
          Button(LS(MSG_SYSTEM_DELETE_GADGET),ID_SYSTEM_DELETE_BUTTON),TRAT_Disabled,TRUE,
          Button(LS(MSG_SYSTEM_EDIT_GADGET),ID_SYSTEM_EDIT_BUTTON),TRAT_Disabled,TRUE,
        EndGroup,
        HorizGroupEA,
          Button(LS(MSG_SYSTEM_TEST_GADGET),ID_SYSTEM_TEST_BUTTON),TRAT_Disabled,TRUE,
          Button(LS(MSG_SYSTEM_USE_GADGET),ID_SYSTEM_USE_BUTTON),
        EndGroup,
        Space,
        NamedSeparatorN(LS(MSG_SYSTEM_MISC_LABEL)),
        Space,
        HorizGroupA,
          CheckBox(ID_SYSTEM_SIMPLEREFRESH_CHECKBOX),TRAT_Value, (currentnode->prefs->flags&TRPF_SIMPLEREFRESH)?TRUE:FALSE,
          Space,
          TextID(LS(MSG_SYSTEM_SIMPLEREFRESH_CHECKBOX),ID_SYSTEM_SIMPLEREFRESH_CHECKBOX),
          HorizGroupS,Space,EndGroup,
        EndGroup,
        Space,
      EndGroup,
      Space,
    EndGroup,
    EndProject
  )) return TRUE; else return FALSE;
}


void update_system(void)
{
  strcpy(lastnode->prefs->pubscreen,(STRPTR)(TR_GetAttribute(systemgui,ID_SYSTEM_PUBSCREEN,NULL)));
  TR_SetAttribute(systemgui,ID_SYSTEM_PUBSCREEN,NULL,(ULONG)(currentnode->prefs->pubscreen));
  TR_SetAttribute(systemgui,ID_SYSTEM_SIMPLEREFRESH_CHECKBOX,TRAT_Value,(ULONG)((currentnode->prefs->flags&TRPF_SIMPLEREFRESH)?TRUE:FALSE));
}


void close_system(void)
{
  if(systemgui)
  {
    strcpy(currentnode->prefs->pubscreen,(STRPTR)(TR_GetAttribute(systemgui,ID_SYSTEM_PUBSCREEN,NULL)));
    TR_CloseProject(systemgui);
    systemgui=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Volatile data handling //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

void BackupVolatile(void)
{
  LockAllProjects();
  SystemTagList("c:copy env:Triton/Screens.trc env:Triton/Screens.trc.bak",NULL);
  UnlockAllProjects();
}


void RemoveVolatile(void)
{
  LockAllProjects();
  DeleteFile("env:Triton/Screens.trc.bak");
  UnlockAllProjects();
}


void RestoreVolatile(void)
{
  LockAllProjects();
  SystemTagList("c:copy env:Triton/Screens.trc.bak env:Triton/Screens.trc",NULL);
  RemoveVolatile();
  UnlockAllProjects();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// Main loop //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

void SaveAndQuit(void)
{
  close_system();
  LockAllProjects();
  SaveAllAppPrefs(applist,TRUE);
  SaveScreenList(screenlist,"env:Triton/Screens.trc");
  SaveScreenList(screenlist,"envarc:Triton/Screens.trc");
  UnlockAllProjects();
}


void UseAndQuit(void)
{
  close_system();
  LockAllProjects();
  SaveAllAppPrefs(applist,FALSE);
  SaveScreenList(screenlist,"env:Triton/Screens.trc");
  UnlockAllProjects();
}


BOOL mainloop(void)
{
  BOOL close_me=FALSE,reopen=FALSE;
  struct TR_Message *trmsg;
  UBYTE reqstr[600];
  ULONG newnum;

  while(!close_me)
  {
    TR_Wait(app,NULL);
    while(trmsg=TR_GetMsg(app))
    {
      switch(trmsg->trm_Class)
      {
        case TRMS_CLOSEWINDOW:
          if(trmsg->trm_Project==framesgui) close_frames();
          else if(trmsg->trm_Project==pensgui) close_pens();
          else if(trmsg->trm_Project==imagesgui) close_images();
          else if(trmsg->trm_Project==systemgui) close_system();
          else if(trmsg->trm_Project==windowsgui) close_windows();
          else
          {
            if(backedup) RestoreVolatile();
            close_me=TRUE;
          }
          break;

        case TRMS_ERROR:
          puts(TR_GetErrorString(trmsg->trm_Data));
          break;

        case TRMS_ACTION:
          switch(trmsg->trm_ID)
          {
            case ID_MAIN_PROJECT_ABOUT:
              About();
              break;

            case ID_MAIN_PROJECT_REMOVE:
              LockAllProjects();
              if(TR_EasyRequestTags(app,LS(MSG_REMOVE_REQUESTER),
                LS(MSG_REMOVEIT_ABORT_GAD),TREZ_Return,0,TAG_END))
              {
                SystemTagList("c:delete <nil: >nil: envarc:triton env:triton all",NULL);
                close_me=TRUE;
              }
              UnlockAllProjects();
              break;

            case ID_MAIN_EDIT_DEFAULTS:
              CopyMem((void *)(&TR_DefaultAppPrefs),(void *)(currentnode->prefs),sizeof(struct TR_AppPrefs));
              update_all();
              break;

            case ID_MAIN_EDIT_LASTSAVED:
              FreeAppPrefs(applist->mempool,currentnode);
              if(LoadAppPrefs(applist->mempool,currentnode,TRUE)) update_all();
              else
              {
                DisplayError(LS(MSG_ERROR_LOADSETTINGS));
                close_me=TRUE;
              }
              break;

            case ID_MAIN_EDIT_RESTORE:
              FreeAppPrefs(applist->mempool,currentnode);
              if(LoadAppPrefs(applist->mempool,currentnode,FALSE)) update_all();
              else
              {
                DisplayError(LS(MSG_ERROR_LOADSETTINGS));
                close_me=TRUE;
              }
              break;

            case ID_MAIN_EDIT_GLOBAL:
              currentnode->globalprefs=TRUE;
              CopyMem((void *)(globalnode->prefs),(void *)(currentnode->prefs),sizeof(struct TR_AppPrefs));
              update_all();
              break;

            case ID_MAIN_INFO_BUTTON:
              AppInfo();
              break;

            case ID_MAIN_DELETE_BUTTON:
              LockAllProjects();
              sprintf(reqstr,LS(MSG_DELETEAPP_REQUESTER),
                currentnode->longname?currentnode->longname:"???",
                currentnode->name);
              if(TR_EasyRequestTags(app,reqstr,LS(MSG_YES_NO_GAD),TAG_END)) DeleteApp(currentnode);
              UnlockAllProjects();
              break;

            case ID_MAIN_SAVE_BUTTON:
              if(backedup) RemoveVolatile();
              SaveAndQuit();
              close_me=TRUE;
              break;

            case ID_MAIN_USE_BUTTON:
              if(backedup) RemoveVolatile();
              UseAndQuit();
              close_me=TRUE;
              break;

            case ID_MAIN_TEST_BUTTON:
              if(!backedup) { BackupVolatile(); backedup=TRUE; }
              reopen=TRUE;
              close_me=TRUE;
              break;

            case ID_MAIN_CANCEL_BUTTON:
              if(backedup) RestoreVolatile();
              close_me=TRUE;
              break;

            case ID_MAIN_FRAMES_BUTTON:
              if(framesgui) close_frames(); else open_frames();
              break;

            case ID_MAIN_PENS_BUTTON:
              if(pensgui) close_pens(); else open_pens();
              break;

            case ID_MAIN_IMAGES_BUTTON:
              if(imagesgui) close_images(); else open_images();
              break;

            case ID_MAIN_WINDOWS_BUTTON:
              if(windowsgui) close_windows(); else open_windows();
              break;

            case ID_MAIN_SYSTEM_BUTTON:
              if(systemgui) close_system(); else open_system();
              break;

            case ID_WINDOWS_SNAPSHOT_BUTTON:
              SaveWindowNode(currentnode,(struct WindowNode *)NodeFromNumber((struct List *)windowlist,TR_GetAttribute(windowsgui,ID_WINDOWS_WINDOWS_LIST,TRAT_Value)));
              break;

            case ID_WINDOWS_INFO_BUTTON:
              WinInfo((struct WindowNode *)NodeFromNumber((struct List *)windowlist,TR_GetAttribute(windowsgui,ID_WINDOWS_WINDOWS_LIST,TRAT_Value)));
              break;

            case ID_WINDOWS_UNSNAPSHOT_BUTTON:
              DeleteWindowNode(currentnode,(struct WindowNode *)NodeFromNumber((struct List *)windowlist,TR_GetAttribute(windowsgui,ID_WINDOWS_WINDOWS_LIST,TRAT_Value)));
              break;

            case ID_WINDOWS_SNAPSHOTALL_BUTTON:
              SaveAllWindowNodes(currentnode,windowlist);
              break;

            case ID_WINDOWS_UNSNAPSHOTALL_BUTTON:
              DeleteAllWindowNodes(currentnode,windowlist);
              break;

            case ID_SYSTEM_ADD_BUTTON:
              TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)(~0));
              newnum=NumberFromNode(screenlist,AddScreenNode(screenlist,LS(MSG_UNNAMEDSCREEN_LABEL)));
              TR_SetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,NULL,(ULONG)screenlist);
              SetScreenListPos(newnum);
              break;

            case ID_SYSTEM_DELETE_BUTTON:
              DeleteScreenNode(screenlist,(struct TR_ScreenNode *)NodeFromNumber(screenlist,TR_GetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value)));
              break;

            case ID_SYSTEM_EDIT_BUTTON:
              EditScreen((struct TR_ScreenNode *)NodeFromNumber(screenlist,TR_GetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value)));
              break;

            case ID_SYSTEM_TEST_BUTTON:
              TestScreen((struct TR_ScreenNode *)NodeFromNumber(screenlist,TR_GetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value)));
              break;

            case ID_SYSTEM_USE_BUTTON:
              strcpy(currentnode->prefs->pubscreen,((struct TR_ScreenNode *)(NodeFromNumber(screenlist,TR_GetAttribute(systemgui,ID_SYSTEM_SCREENS_LIST,TRAT_Value))))->pubname);
              TR_SetAttribute(systemgui,ID_SYSTEM_PUBSCREEN,NULL,(ULONG)(currentnode->prefs->pubscreen));
              break;
          }
          break;

        case TRMS_NEWVALUE:
          switch(trmsg->trm_ID)
          {
            case ID_MAIN_LIST:
              lastnode=currentnode;
              currentnode=(struct AppNode *)NodeFromNumber((struct List *)applist,trmsg->trm_Data);
              update_all();
              if(trmsg->trm_Data)
              {
                if(isglobal)
                {
                  TR_SetAttribute(maingui,ID_MAIN_DELETE_BUTTON,TRAT_Disabled,FALSE);
                  TR_SetAttribute(maingui,ID_MAIN_INFO_BUTTON,TRAT_Disabled,FALSE);
                  TR_SetAttribute(maingui,ID_MAIN_EDIT_GLOBAL,TRAT_Disabled,TRUE);
                  isglobal=FALSE;
                }
              }
              else
              {
                if(!isglobal)
                {
                  TR_SetAttribute(maingui,ID_MAIN_DELETE_BUTTON,TRAT_Disabled,TRUE);
                  TR_SetAttribute(maingui,ID_MAIN_INFO_BUTTON,TRAT_Disabled,TRUE);
                  TR_SetAttribute(maingui,ID_MAIN_EDIT_GLOBAL,TRAT_Disabled,FALSE);
                  isglobal=TRUE;
                }
              }
              if(!isglobal) if(trmsg->trm_Qualifier&IEQUALIFIER_REPEAT) AppInfo();
              break;

            case ID_FRAMES_CYCLE_WIDTH:
              currentnode->prefs->frames_width=trmsg->trm_Data;
              break;

            case ID_FRAMES_CYCLE_TITLE:
              currentnode->prefs->frames_title=trmsg->trm_Data;
              break;

            case ID_FRAMES_CYCLE_KIND_FRAMEBOX:
              currentnode->prefs->frames_type[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON]=trmsg->trm_Data+1;
              break;

            case ID_FRAMES_CYCLE_RAISED_FRAMEBOX:
              currentnode->prefs->frames_raised[TRFT_ABSTRACT_FRAMEBOX-TRFT_ABSTRACT_BUTTON]=(trmsg->trm_Data)?0:1;
              break;

            case ID_FRAMES_CYCLE_KIND_BUTTON:
              currentnode->prefs->frames_type[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON]=trmsg->trm_Data+1;
              break;

            case ID_FRAMES_CYCLE_RAISED_BUTTON:
              currentnode->prefs->frames_raised[TRFT_ABSTRACT_BUTTON-TRFT_ABSTRACT_BUTTON]=(trmsg->trm_Data)?0:1;
              break;

            case ID_FRAMES_CYCLE_KIND_GROUPBOX:
              currentnode->prefs->frames_type[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON]=trmsg->trm_Data+1;
              break;

            case ID_FRAMES_CYCLE_RAISED_GROUPBOX:
              currentnode->prefs->frames_raised[TRFT_ABSTRACT_GROUPBOX-TRFT_ABSTRACT_BUTTON]=(trmsg->trm_Data)?0:1;
              break;

            case ID_FRAMES_CYCLE_KIND_ICONDROPBOX:
              currentnode->prefs->frames_type[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON]=trmsg->trm_Data+1;
              break;

            case ID_FRAMES_CYCLE_RAISED_ICONDROPBOX:
              currentnode->prefs->frames_raised[TRFT_ABSTRACT_ICONDROPBOX-TRFT_ABSTRACT_BUTTON]=(trmsg->trm_Data)?0:1;
              break;

            case ID_FRAMES_CYCLE_KIND_PROGRESS:
              currentnode->prefs->frames_type[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON]=trmsg->trm_Data+1;
              break;

            case ID_FRAMES_CYCLE_RAISED_PROGRESS:
              currentnode->prefs->frames_raised[TRFT_ABSTRACT_PROGRESS-TRFT_ABSTRACT_BUTTON]=(trmsg->trm_Data)?0:1;
              break;

            case ID_PENS_LIST_FROM:
              update_pens();
              break;

            case ID_PENS_LIST_TO:
              currentnode->prefs->pendata[TR_GetAttribute(pensgui,ID_PENS_LIST_FROM,TRAT_Value)]=trmsg->trm_Data;
              break;

            case ID_PENS_CYCLE_TO:
              currentnode->prefs->pentype[TR_GetAttribute(pensgui,ID_PENS_LIST_FROM,TRAT_Value)]=trmsg->trm_Data;
              currentnode->prefs->pendata[TR_GetAttribute(pensgui,ID_PENS_LIST_FROM,TRAT_Value)]=0;
              TR_SetAttribute(pensgui,ID_PENS_LIST_TO,TRAT_Value,0);
              if(trmsg->trm_Data) TR_SetAttribute(pensgui,ID_PENS_LIST_TO,NULL,(ULONG)penlist);
                else TR_SetAttribute(pensgui,ID_PENS_LIST_TO,NULL,(ULONG)systempenlist);
              break;

            case ID_IMAGES_LIST_FROM:
              update_images();
              break;

            case ID_IMAGES_LIST_TO:
              currentnode->prefs->imgdata[TR_GetAttribute(imagesgui,ID_IMAGES_LIST_FROM,TRAT_Value)]=trmsg->trm_Data+2;
              break;

            case ID_IMAGES_CYCLE_TO:
              currentnode->prefs->imgtype[TR_GetAttribute(imagesgui,ID_IMAGES_LIST_FROM,TRAT_Value)]=trmsg->trm_Data;
              currentnode->prefs->imgdata[TR_GetAttribute(imagesgui,ID_IMAGES_LIST_FROM,TRAT_Value)]=0;
              TR_SetAttribute(imagesgui,ID_IMAGES_LIST_TO,TRAT_Value,0);
              if(trmsg->trm_Data) TR_SetAttribute(imagesgui,ID_IMAGES_LIST_TO,NULL,(ULONG)gfxpenlist);
                else TR_SetAttribute(imagesgui,ID_IMAGES_LIST_TO,NULL,(ULONG)patternlist);
              break;

            case ID_WINDOWS_WINDOWS_LIST:
              if(trmsg->trm_Qualifier&IEQUALIFIER_REPEAT) WinInfo((struct WindowNode *)NodeFromNumber((struct List *)windowlist,trmsg->trm_Data));
              break;

            case ID_SYSTEM_SCREENS_LIST:
              SetScreenListPos(trmsg->trm_Data);
              if(trmsg->trm_Qualifier&IEQUALIFIER_REPEAT)
              {
                strcpy(currentnode->prefs->pubscreen,((struct TR_ScreenNode *)(NodeFromNumber(screenlist,trmsg->trm_Data)))->pubname);
                TR_SetAttribute(systemgui,ID_SYSTEM_PUBSCREEN,NULL,(ULONG)(currentnode->prefs->pubscreen));
              }
              break;

            case ID_IMAGES_RETURN_CHECKBOX:
              if(trmsg->trm_Data) currentnode->prefs->flags|=TRPF_RETURNARROW;
                else currentnode->prefs->flags&=(~TRPF_RETURNARROW);
              break;

            case ID_SYSTEM_SIMPLEREFRESH_CHECKBOX:
              if(trmsg->trm_Data) currentnode->prefs->flags|=TRPF_SIMPLEREFRESH;
                else currentnode->prefs->flags&=(~TRPF_SIMPLEREFRESH);
              break;
          }
          break;
      }
      TR_ReplyMsg(trmsg);
    }
  }
  return reopen;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////// Update all windows with new app //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

void update_all(void)
{
  if(framesgui) update_frames();
  if(pensgui) update_pens();
  if(imagesgui) update_images();
  if(windowsgui) update_windows();
  if(systemgui) update_system();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////// Open and close the application //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL createapp(struct TR_AppPrefs *prefs)
{
  return (BOOL)(app=TR_CreateAppTags(
    TRCA_Name,        "TritonPrefs",
    TRCA_LongName,    LS(MSG_TRITON_APP_LONGNAME),
    TRCA_Info,        LS(MSG_TRITON_APP_INFO),
    TRCA_Version,     TRPREFS_VERSION,
    TRCA_Release,     TRPREFS_RELEASE,
    TRCA_Date,        TRPREFS_DATE,
    prefs?TRCA_MagicPrefs:TAG_END,prefs,
    TAG_END));
}


void deleteapp(void)
{
  if(app)
  {
    TR_DeleteApp(app);
    app=NULL;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Check prefs //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL checkprefs(void)
{
  BPTR lock;
  BOOL retval=TRUE;

  if(lock=Lock("env:Triton",ACCESS_READ)) UnLock(lock);
  else
  {
    if(TR_EasyRequestTags(app,LS(MSG_INSTALLPREFS_REQUESTER),LS(MSG_INSTALLIT_QUIT_GAD),
      TREZ_ReqPos,TRWP_CENTERDISPLAY,
      TAG_END))
    {
      lock=CreateDir("env:Triton");
      if(lock) UnLock(lock); else retval=FALSE;
      lock=CreateDir("envarc:Triton");
      if(lock) UnLock(lock); else retval=FALSE;
      if(screenlist=CreateScreenList())
      {
        SaveScreenList(screenlist,"env:Triton/Screens.trc");
        SaveScreenList(screenlist,"envarc:Triton/Screens.trc");
        DeleteFileList((struct FileList *)screenlist);
        screenlist=NULL;
      }
      if(!retval) DisplayError(LS(MSG_ERROR_INSTALLTRITON));
      else
      {
        deleteapp();
        if(!(createapp(NULL)))
        {
          retval=FALSE;
          DisplayError(LS(MSG_ERROR_CREATEAPP));
        }
      }
    }
    else retval=FALSE;
  }
  return retval;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// main() //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{
  int retval=0;
  BOOL opened_frames, opened_pens, opened_images, opened_system, opened_windows;

  if(LocaleBase=OpenLibrary("locale.library",38))
  {
    li.li_LocaleBase=LocaleBase;
    li.li_Catalog=OpenCatalogA(NULL,"tritonprefs.catalog",NULL);
  }

  ASLBase=OpenLibrary("asl.library",38L);
  if(!ASLBase) ReqToolsBase=(struct ReqToolsBase *)OpenLibrary("reqtools.library",0L);

  if(TritonBase=OpenLibrary(TRITONNAME,TRITON12VERSION))
  {
    if(createapp(NULL))
    {
      if(checkprefs())
      {
        if(screenlist=CreateScreenList())
        {
          if(applist=CreateAppList())
          {
            if(open_main())
            {
              while(mainloop())
              {
                if(framesgui) opened_frames=TRUE; else opened_frames=FALSE;
                close_frames();
                if(pensgui) opened_pens=TRUE; else opened_pens=FALSE;
                close_pens();
                if(imagesgui) opened_images=TRUE; else opened_images=FALSE;
                close_images();
                if(systemgui) opened_system=TRUE; else opened_system=FALSE;
                close_system();
                if(windowsgui) opened_windows=TRUE; else opened_windows=FALSE;
                close_windows();
                close_main();
                deleteapp();
                //-- Use proper error reporting
                if(!createapp(GetEditorPrefs())) break;
                currentnode=(struct AppNode *)NodeFromNumber((struct List *)applist,0);
                isglobal=TRUE;
                if(!open_main()) break;
                if(opened_frames) open_frames();
                if(opened_pens) open_pens();
                if(opened_images) open_images();
                if(opened_system) open_system();
                if(opened_windows) open_windows();
              }
              close_frames();
              close_pens();
              close_images();
              close_system();
              close_windows();
              close_main();
            } else { DisplayError(LS(MSG_ERROR_MAINWINDOW)); retval=20; }
            DeleteFileList(applist);
          } else { DisplayError(LS(MSG_ERROR_NOMEM)); retval=20; }
          DeleteFileList((struct FileList *)screenlist);
        } else { DisplayError(LS(MSG_ERROR_NOMEM)); retval=20; }
      }
      deleteapp();
    } else { DisplayError(LS(MSG_ERROR_CREATEAPP)); retval=20; }
    CloseLibrary(TritonBase);
  } else { DisplayError(LS(MSG_ERROR_NOTRITONLIB)); retval=20; }

  if(ASLBase) CloseLibrary(ASLBase);
  if(ReqToolsBase) CloseLibrary((struct Library *)ReqToolsBase);

  if(li.li_LocaleBase)
  {
    CloseCatalog(li.li_Catalog);
    CloseLibrary(LocaleBase);
  }

  return retval;
}
