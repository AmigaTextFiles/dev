/*

Title:     Font
Version:   0.08
Author:    Matthias Scheler <tron@lyssa.ms.sub.org>
           DICE Support by Stefan Becker <stefanb@pool.informatik.rwth-aachen.de>
Copyright: (c) by Matthias Scheler, freely distributable with MUI

This is a replacment for Commodore's prefs program "Font" written with "MUI".
It does the same as the original program, but is font sensitive and sizable
(A preferences program which ignores it's own setting, strange ...).

Look at the source code, and you'll recognize that the code for the creation
of the GUI is very short, thanks to Magic User Interface.

Thanks to Klaus Melchior for the nice icon.

Compile:
  sc Font.c MCCONS STRMERGE UNSCHAR NOSTKCHK OPTIMIZE
  slink FROM LIB:c.o Font.o LIB LIB:sc.lib LIB:amiga.lib SC SD ND TO Font

*/

#include <intuition/intuitionbase.h>
#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <libraries/iffparse.h>
#include <libraries/mui.h>
#include <workbench/icon.h>
#include <workbench/startup.h>
#include <prefs/font.h>
#include <prefs/prefhdr.h>

#ifdef __SASC
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/icon.h>
#include <proto/iffparse.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>
struct IntuitionBase *IntuitionBase;
struct Library *IconBase;
extern struct Library *SysBase;
#else
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/iffparse_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/muimaster_pragmas.h>
extern struct Library *SysBase, *DOSBase, *IntuitionBase, *IconBase;
#endif

#include <string.h>
#include <stdlib.h>

struct Library *IFFParseBase,*MUIMasterBase;

#ifdef MAX
#undef MAX
#endif
#ifdef MIN
#undef MIN
#endif

#ifdef __SASC
#define MAX(a,b) __builtin_max(a,b)
#define MIN(a,b) __builtin_min(a,b)
#else
#define MAX(a,b) ((a)>(b)?(a):(b))
#define MIN(a,b) ((a)<(b)?(a):(b))
#endif

#define VERSION "0.08"

char *Version = "$VER: Font " VERSION " (03.08.93)";

#define FONT_NUM (FP_SCREENFONT+1)

APTR AP_Font;
APTR WI_Font;
APTR TO_Font[FONT_NUM];
APTR BT_Font[FONT_NUM],BT_Save,BT_Use,BT_Cancel;

#define ID_WBFONT      1L
#define ID_SYSFONT     2L
#define ID_SCREENFONT  3L
#define ID_SAVE        4L
#define ID_USE         5L

#define ID_OPEN       10L
#define ID_SAVE_AS    11L

#define ID_DEFAULTS   20L
#define ID_LAST_SAVED 21L
#define ID_RESTORE    22L

#define ID_ICONS      30L

struct NewMenu MN_Font[] =
 {
  NM_TITLE,"Project",NULL,0,0L,NULL,
   NM_ITEM,"Open...","O",0,0L,(APTR)ID_OPEN,
   NM_ITEM,"Save As...","A",0,0L,(APTR)ID_SAVE_AS,
   NM_ITEM,NM_BARLABEL,NULL,0,0L,NULL,
   NM_ITEM,"Quit","Q",0,0L,(APTR)MUIV_Application_ReturnID_Quit,
  NM_TITLE,"Edit",NULL,0,0L,NULL,
   NM_ITEM,"Reset To Defaults","D",0,0L,(APTR)ID_DEFAULTS,
   NM_ITEM,"Last Saved","L",0,0L,(APTR)ID_LAST_SAVED,
   NM_ITEM,"Restore","R",0,0L,(APTR)ID_RESTORE,
  NM_TITLE,"Settings",NULL,0,0L,NULL,
   NM_ITEM,"Create Icons?","I",CHECKIT|CHECKED|MENUTOGGLE,0L,(APTR)ID_ICONS,
  NM_END,NULL,NULL,0,0L,NULL
 };

struct FontPrefs FontPrefs[FONT_NUM],RestorePrefs[FONT_NUM],StdFont =
 {0L,0L,0L,0,0,1,0,JAM1,NULL,TOPAZ_EIGHTY,FS_NORMAL,FPF_ROMFONT,"topaz.font"};

char *ModeList[] = {"Mode","Text","Text+Field",NULL};

#define ENV_FILE    "ENV:Sys/Font.prefs"
#define ENVARC_FILE "ENVARC:Sys/Font.prefs"

UWORD PutChar[2] = {0x16C0,0x4E75};

/* dirty hack to avoid assembler part :-)

   16C0: move.b d0,(a3)+
   4E75: rts
*/

/* own sprintf() based on exec.library/RawDoFmt() to keep program short */

void SPrintF(char *Buffer,char *FormatString,...)

{
 RawDoFmt (FormatString,(APTR)((LONG *)&FormatString+1L),(void *)PutChar,Buffer);
}

/* load font preferences from a file */

LONG LoadPrefs(struct FontPrefs *FontPrefs,char *Name)

{
 LONG Error;
 struct IFFHandle *IFF;

 Error=ERROR_NO_FREE_STORE;
 if (IFF=AllocIFF())
  {
   if (IFF->iff_Stream=(ULONG)Open(Name,MODE_OLDFILE))
    {
     InitIFFasDOS (IFF);
     if ((Error=OpenIFF(IFF,IFFF_READ))==0L)
      {
       if ((Error=CollectionChunk(IFF,ID_PREF,ID_FONT))==0L)
        if ((Error=StopOnExit(IFF,ID_PREF,ID_FORM))==0L)
         if ((Error=ParseIFF(IFF,IFFPARSE_SCAN))==IFFERR_EOC)
          {
           struct CollectionItem *CItem;

           Error=0L;
           CItem=FindCollection(IFF,ID_PREF,ID_FONT);
           while (CItem)
            {
             struct FontPrefs *Ptr;

             Ptr=(struct FontPrefs *)CItem->ci_Data;
             if ((CItem->ci_Size==sizeof(struct FontPrefs))&&
                 (Ptr->fp_Type<FONT_NUM)) FontPrefs[Ptr->fp_Type]=*Ptr;

             CItem=CItem->ci_Next;
            }
          }

       CloseIFF (IFF);
      }
     Close ((BPTR)IFF->iff_Stream);
    }
   else Error=IoErr();

   FreeIFF (IFF);
  }
 return Error;
}

/* write one "struct PrefHeader" and three "struct FontPrefs" to an IFF file */

LONG WritePrefsData(struct IFFHandle *IFF,struct FontPrefs *FontPrefs)

{
 struct PrefHeader PrefHeader;
 LONG Error,Index;

 if (Error=PushChunk(IFF,ID_PREF,ID_FORM,IFFSIZE_UNKNOWN)) return Error;

 PrefHeader.ph_Version=0;
 PrefHeader.ph_Type=0;
 PrefHeader.ph_Flags=0L;
 if (Error=PushChunk(IFF,ID_PREF,ID_PRHD,sizeof(struct PrefHeader))) return Error;
 if ((Error=WriteChunkBytes(IFF,&PrefHeader,sizeof(struct PrefHeader)))<0L) return Error;
 if (Error=PopChunk(IFF)) return Error;

 for (Index=0L; Index<FONT_NUM; Index++)
  {
   if (Error=PushChunk(IFF,ID_PREF,ID_FONT,sizeof(struct FontPrefs))) return Error;
   if ((Error=WriteChunkBytes(IFF,&FontPrefs[Index],sizeof(struct FontPrefs)))<0L) return Error;
   if (Error=PopChunk(IFF)) return Error;
  }

 return PopChunk(IFF);
}

/* save font preferences to a file */

LONG SavePrefs(struct FontPrefs *FontPrefs,char *Name)

{
 LONG Error;
 struct IFFHandle *IFF;

 Error=ERROR_NO_FREE_STORE;
 if (IFF=AllocIFF())
  {
   if (IFF->iff_Stream=(ULONG)Open(Name,MODE_NEWFILE))
    {
     InitIFFasDOS (IFF);
     if (OpenIFF(IFF,IFFF_WRITE)==0L)
      {
       Error=WritePrefsData(IFF,FontPrefs);

       CloseIFF (IFF);
      }
     Close ((BPTR)IFF->iff_Stream);
     if (Error) (void)DeleteFile(Name);
    }
   else Error=IoErr();

   FreeIFF (IFF);
  }
 return Error;
}

/* get Intuition window pointer from a MUI window */

struct Window *GetWinPtr(APTR WI_Any)

{
 struct Window *Window;

 Window=NULL;
 get (WI_Any,MUIA_Window_Window,&Window);
 return Window;
}

/* fill in three "struct FontPrefs" with default values */

void DefaultFontPrefs(struct FontPrefs *FontPrefs)

{
 LONG Index;

 for (Index=0L; Index<FONT_NUM; Index++)
  {
   FontPrefs[Index]=StdFont;
   FontPrefs[Index].fp_Type=Index;
  }
}

/* update font display in font window */

void SetFontTO(APTR *TO_Font,struct FontPrefs *FontPrefs)

{
 static char FontName[FONT_NUM][FONTNAMESIZE];
 ULONG Index;

 for (Index=0L; Index<FONT_NUM; Index++)
  {
   SPrintF (FontName[FontPrefs[Index].fp_Type],"%s %ld",
            FontPrefs[Index].fp_Name,
            FontPrefs[Index].fp_TextAttr.ta_YSize);
   set (TO_Font[Index],MUIA_Text_Contents,FontName[FontPrefs[Index].fp_Type]);
  }
}

/* select a font with the "asl.library */

LONG SelectFont(APTR ParentWindow,struct FontPrefs *FontPrefs,
                          char *Title,LONG FixedWidthOnly,LONG PensAndMode)

{
 struct FontRequester *FontRequester;
 struct Window *Window;
 LONG Result;
 UBYTE Index,FrontPens[8],BackPens[8];

 if ((Window=GetWinPtr(ParentWindow))==NULL) return FALSE;

 for (Index=0L; Index<4L; Index++)
  {
   FrontPens[Index]=BackPens[Index]=Index;
   FrontPens[7-Index]=BackPens[7-Index]=(1<<Window->WScreen->BitMap.Depth)-Index-1;
  }

 if ((FontRequester=(struct FontRequester *)
      MUI_AllocAslRequestTags(ASL_FontRequest,
                              ASLFO_Window,Window,
                              ASLFO_TitleText,Title,
                              ASLFO_InitialHeight,MAX(128L,Window->WScreen->Height-128L),
                              ASLFO_InitialName,FontPrefs->fp_Name,
                              ASLFO_InitialSize,FontPrefs->fp_TextAttr.ta_YSize,
                              ASLFO_InitialFrontPen,FontPrefs->fp_FrontPen,
                              ASLFO_InitialBackPen,FontPrefs->fp_BackPen,
                              ASLFO_InitialDrawMode,FontPrefs->fp_DrawMode,
                              ASLFO_Flags,
                               (FixedWidthOnly?FOF_FIXEDWIDTHONLY:0L)|
                               (PensAndMode?(FOF_DOFRONTPEN|FOF_DOBACKPEN|FOF_DODRAWMODE):0L),
                              ASLFO_MaxFrontPen,MIN(8L,1L<<Window->WScreen->BitMap.Depth),
                              ASLFO_MaxBackPen,MIN(8L,1L<<Window->WScreen->BitMap.Depth),
                              ASLFO_FrontPens,FrontPens,
                              ASLFO_BackPens,BackPens,
                              ASLFO_ModeList,ModeList,
                              TAG_DONE))==NULL) return FALSE;

 set (ParentWindow,MUIA_Window_Sleep,TRUE);
 Result=MUI_AslRequest((APTR)FontRequester,NULL);
 set (ParentWindow,MUIA_Window_Sleep,FALSE);

 if (Result)
  {
   (void)strcpy(FontPrefs->fp_Name,FontRequester->fo_Attr.ta_Name);
   FontPrefs->fp_TextAttr=FontRequester->fo_Attr;
   FontPrefs->fp_TextAttr.ta_Name=NULL;

   if (PensAndMode)
    {
     FontPrefs->fp_FrontPen=FontRequester->fo_FrontPen;
     FontPrefs->fp_BackPen=FontRequester->fo_BackPen;
     FontPrefs->fp_DrawMode=FontRequester->fo_DrawMode;
    }
  }

 MUI_FreeAslRequest (FontRequester);
 return Result;
}

/* display an I/O error with muimaster.library/MUI_Request */

void ErrorReq(char *Name,LONG Error)

{
 char DOSMsg[80],ReqText[256];

 if (Error>0L)
  {
   (void)Fault(Error,NULL,DOSMsg,80L);
   (void)strcat(strcat(strcat(strcpy(ReqText,"Error accessing file\n"),Name),",\n"),DOSMsg);
  }
 else (void)strcat(strcpy(ReqText,"Error processing IFF file\n"),Name);

 (void)MUI_Request(AP_Font,NULL,0L,"Program Error","Ok",ReqText);
}

/* main program */

int main(int argc, char *argv[])

{
 struct DiskObject *DiskObject;
 LONG Done,Index,Error;

/* open our libraries */

#ifndef _DCC
 if ((IconBase=OpenLibrary(ICONNAME,36))==NULL) exit (20);
 if ((IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",36))==NULL)
  {
   CloseLibrary (IconBase);

   exit (20);
  }
#endif
 if ((IFFParseBase=OpenLibrary("iffparse.library",0))==NULL)
  {
#ifndef _DCC
   CloseLibrary (&IntuitionBase->LibNode);
   CloseLibrary (IconBase);
#endif

   exit (20);
  }
 if ((MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))==NULL)
  {
   CloseLibrary (IFFParseBase);
#ifndef _DCC
   CloseLibrary (&IntuitionBase->LibNode);
   CloseLibrary (IconBase);
#endif

   exit (20);
  }

/* init preferences stuff */

 DefaultFontPrefs (FontPrefs);
 if (Error=LoadPrefs(FontPrefs,ENV_FILE))
  if (Error!=ERROR_OBJECT_NOT_FOUND) ErrorReq (ENV_FILE,Error);
 (void)memcpy(RestorePrefs,FontPrefs,sizeof(RestorePrefs));

/* create GUI stuff */

 AP_Font=ApplicationObject,
          MUIA_Application_Title,"Font",
          MUIA_Application_Version,Version,
          MUIA_Application_Copyright,"Copyright © 1993 by Matthias Scheler",
          MUIA_Application_Author,"Matthias Scheler",
          MUIA_Application_Description,"Font Prefs Program",
          MUIA_Application_Base,"Font",
          MUIA_Application_SingleTask,TRUE,
          MUIA_Application_DiskObject,DiskObject=GetDiskObject("PROGDIR:Font"),
          SubWindow,WI_Font=WindowObject,
           MUIA_Window_Title,"Font Preferences",
           MUIA_Window_ID,MAKE_ID('F','O','N','T'),
           MUIA_Window_Menu,MN_Font,
           WindowContents,VGroup,
            Child,ColGroup(2),
             GroupFrameT("Selected Fonts"),ReadListFrame,
             Child, VSpace(0), Child, VSpace(0),
             Child,Label("Workbench Icon Text:"),
             Child,TO_Font[FP_WBFONT]=TextObject,End,
             Child,Label("System Default Text:"),
             Child,TO_Font[FP_SYSFONT]=TextObject,End,
             Child,Label("Screen Text:"),
             Child,TO_Font[FP_SCREENFONT]=TextObject,End,
             Child, VSpace(0), Child, VSpace(0),
            End,
            Child,VSpace(3),
            Child,BT_Font[FP_WBFONT]=SimpleButton("Select Workbench Icon Text..."),
            Child,BT_Font[FP_SYSFONT]=SimpleButton("Select System Default Text..."),
            Child,BT_Font[FP_SCREENFONT]=SimpleButton("Select Screen Text..."),
            Child,VSpace(3),
            Child,HGroup,
             Child,BT_Save=KeyButton("Save",'s'),
             Child,BT_Use=KeyButton("Use",'u'),
             Child,BT_Cancel=KeyButton("Cancel",'c'),
            End,
           End,
          End,
         End;

/* Seen it ? No pixel counting or any sh*t like that */

 if (AP_Font==NULL)
  {
   if (DiskObject) FreeDiskObject (DiskObject);

   CloseLibrary (MUIMasterBase);
   CloseLibrary (IFFParseBase);
#ifndef _DCC
   CloseLibrary (&IntuitionBase->LibNode);
   CloseLibrary (IconBase);
#endif

   exit (10);
  }

/* now setup stuff for event handling */

 DoMethod (WI_Font,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
           AP_Font,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

 for (Index=0L; Index<FONT_NUM; Index++)
  DoMethod (BT_Font[Index],MUIM_Notify,MUIA_Pressed,FALSE,
            AP_Font,2,MUIM_Application_ReturnID,ID_WBFONT+Index);

 DoMethod (BT_Save,MUIM_Notify,MUIA_Pressed,FALSE,
           AP_Font,2,MUIM_Application_ReturnID,ID_SAVE);
 DoMethod (BT_Use,MUIM_Notify,MUIA_Pressed,FALSE,
           AP_Font,2,MUIM_Application_ReturnID,ID_USE);
 DoMethod (BT_Cancel,MUIM_Notify,MUIA_Pressed,FALSE,
           AP_Font,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

/* cycle chain for keyboard control */

 DoMethod (WI_Font,MUIM_Window_SetCycleChain,
           BT_Font[FP_WBFONT],BT_Font[FP_SYSFONT],BT_Font[FP_SCREENFONT],
           BT_Save,BT_Use,BT_Cancel,NULL);

/* init display */

 SetFontTO (TO_Font,FontPrefs);
 set (WI_Font,MUIA_Window_Open,TRUE);

/* event loop */

 Done=FALSE;
 while (!Done)
  {
   ULONG ID,Signal;

   ID=DoMethod(AP_Font,MUIM_Application_Input,&Signal);
   switch (ID)
    {
/* Quit (by close gadget, keyboard, menu, ARexx or Exchange ... doesn't matter) */
     case MUIV_Application_ReturnID_Quit:
      Done=TRUE;
      break;

/* gadgets selected with keyboard or mouse */
     case ID_WBFONT:
      if (SelectFont(WI_Font,&FontPrefs[FP_WBFONT],
                     "Select Workbench Icon Text",FALSE,TRUE)) SetFontTO (TO_Font,FontPrefs);
      break;
     case ID_SYSFONT:
      if (SelectFont(WI_Font,&FontPrefs[FP_SYSFONT],
                     "Select System Default Text",TRUE,FALSE)) SetFontTO (TO_Font,FontPrefs);
      break;
     case ID_SCREENFONT:
      if (SelectFont(WI_Font,&FontPrefs[FP_SCREENFONT],
                     "Select Screen Text...",FALSE,FALSE)) SetFontTO (TO_Font,FontPrefs);
      break;

     case ID_SAVE:
      if (Error=SavePrefs(FontPrefs,ENVARC_FILE))
       {
        ErrorReq (ENVARC_FILE,Error);
        break;
       }
     case ID_USE:
      set (WI_Font,MUIA_Window_Open,FALSE);
      if (Error=SavePrefs(FontPrefs,ENV_FILE)) ErrorReq (ENV_FILE,Error);
      Done=TRUE;
      break;

/* handle menu entries */
     case ID_DEFAULTS:
      DefaultFontPrefs (FontPrefs);
      SetFontTO (TO_Font,FontPrefs);
      break;
     case ID_LAST_SAVED:
      if (Error=LoadPrefs(FontPrefs,ENVARC_FILE)) ErrorReq (ENVARC_FILE,Error);
      else SetFontTO (TO_Font,FontPrefs);
      break;
     case ID_RESTORE:
      (void)memcpy(FontPrefs,RestorePrefs,sizeof(FontPrefs));
      SetFontTO (TO_Font,FontPrefs);
    }

   if (!Done&&(Signal!=0L)) (void)Wait(Signal);
  }

/* remove GUI stuff */

 MUI_DisposeObject (AP_Font);
 if (DiskObject) FreeDiskObject (DiskObject);

/* close our libraries */

 CloseLibrary (MUIMasterBase);
 CloseLibrary (IFFParseBase);
#ifndef _DCC
 CloseLibrary (&IntuitionBase->LibNode);
 CloseLibrary (IconBase);
#endif

 exit (0);
}
