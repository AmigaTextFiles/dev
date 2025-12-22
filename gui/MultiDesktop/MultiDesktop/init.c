/* Initialisierung */
#include "multiwindows.h"

extern struct IntuitionBase    *IntuitionBase;
extern struct MultiDesktopBase *MultiDesktopBase;
extern struct MultiWindowsBase *MultiWindowsBase;
extern struct ExecBase         *SysBase;
extern struct Library          *LocaleBase;
extern struct Library          *UtilityBase;

struct Library                 *AmigaGuideBase;
struct Library                 *AslBase;

extern ULONG FloatHookProc();
extern ULONG HexHookProc();
extern ULONG UserHookProc();
extern ULONG AvailMem();

void         FlushFonts();
void         TestFont();
void         DOut();
void         CloseGuide();

/*
 LocaleLibrary Hinweis:
 Wird vor dem Schließen der Locale-Library RemLibrary() aufgerufen,
 so werden alle nicht mehr benötigten Kataloge freigegeben.
*/

void RemoveLib();

/* ---------------------------------------------------------------------- */

struct TextAttr Topaz8=
{ "topaz.font",8,FS_NORMAL,FPF_ROMFONT };

struct TextAttr Topaz8Bold=
{ "topaz.font",8,FSF_BOLD,FPF_ROMFONT };

struct TextAttr Password5=
{ "password.font",5,FS_NORMAL,FPF_ROMFONT };

struct TextAttr Password9=
{ "password.font",9,FS_NORMAL,FPF_ROMFONT };

struct CommandTable CommandTable[]=
{
 {"NumLock",'[',0},
 {"ScrLock",']',0},
 {"PrtSc"  ,'*',0},
 {"Home"   ,'7',0},
 {"PgUp"   ,'9',0},
 {"End"    ,'1',0},
 {"PgDown" ,'3',0},
 {"Insert" ,'0',0},
 {"Del"    ,'.',0},
 {"Return" , 10,0},
 {"ESC"    , 27,0},
 {"Tab"    ,  9,0},
 {"Enter"  , 10,0},
 {"Star"   ,'*',0},
 {"Number" ,'#',0},
 {0L,0,0}
};

UBYTE *FontTestString="abcdefghijklmnopqrstuvwxyz  -  1234567890 #,.;:*+^/*?!|$%&()= <> ABCDEFGHIJKLMNOPQRSTUVWXYZ öäüÄÖÜß";

/* ---------------------------------------------------------------------- */
/* Interne Initialisation */

/* ---- Library initialisieren */
struct MultiWindowsBase *InitLib()
{
 UBYTE str[128];

 /* ---- Libraries öffnen ----------------------------------------------- */
 MultiWindowsBase->AslLibrary=OpenLibrary("asl.library",0L);
 MultiWindowsBase->AmigaGuideLibrary=OpenLibrary("amigaguide.library",0L);
 if(MultiWindowsBase->AslLibrary==NULL)
  {
   ErrorL(800,"Unable to open asl.library!");
   return(NULL);
  }
 AslBase=MultiWindowsBase->AslLibrary;
 AmigaGuideBase=MultiWindowsBase->AmigaGuideLibrary;

 /* ---- Zeiger auf Buffer setzen --------------------------------------- */
 MultiWindowsBase->Preferences=&MultiWindowsBase->PreferencesBuffer;
 MultiWindowsBase->UserInfo=&MultiWindowsBase->UserInfoBuffer;
 strcpy(&MultiWindowsBase->UserInfo->Name,"?");
 strcpy(&MultiWindowsBase->UserInfo->Address[0],"?");
 strcpy(&MultiWindowsBase->UserInfo->PhoneNumber,"?");
 strcpy(&MultiWindowsBase->UserInfo->FaxNumber,"?");

 /* ---- Preferences, Listen initialisieren ----------------------------- */
 GetPrefs(MultiWindowsBase->Preferences,sizeof(struct Preferences));
 NewList(&MultiWindowsBase->AppList);
 NewList(&MultiWindowsBase->WallpaperList);
 NewList(&MultiWindowsBase->PointerList);

 /* ---- Defaulteinstellungen ------------------------------------------- */
 MultiWindowsBase->AppCount=0;
 MultiWindowsBase->TopazAttr=&Topaz8;
 MultiWindowsBase->Password9Attr=&Password9;
 MultiWindowsBase->Password5Attr=&Password5;
 MultiWindowsBase->DefaultAttr=&Topaz8;
 MultiWindowsBase->DefaultNonPropAttr=&Topaz8;
 MultiWindowsBase->WallpaperDir=WALLPAPER_DIR;
 MultiWindowsBase->PointerDir=POINTER_DIR;
 MultiWindowsBase->HelpTicks=HELP_TICKS;
 MultiWindowsBase->HelpAvoidFlicker=HELP_AVOIDFLICKER;
 MultiWindowsBase->HelpActive=HELP_ACTIVE;
 MultiWindowsBase->HelpDeveloper=HELP_DEVELOPER;
 MultiWindowsBase->HelpCorrY=HELP_CORR_Y;
 MultiWindowsBase->HelpWallpaperName=HELP_WALLPAPERNAME;
 MultiWindowsBase->HelpPointerName=HELP_POINTERNAME;
 MultiWindowsBase->SleepPointerName=SLEEP_POINTERNAME;
 MultiWindowsBase->WorkPointerName=WORK_POINTERNAME;

 MultiWindowsBase->CommandTable=&CommandTable;
 MultiWindowsBase->MenuLineSpacing=MENU_LINESPACING;
 MultiWindowsBase->MenuItemMove=MENU_ITEMMOVE;
 MultiWindowsBase->MenuCommSeqSpacing=MENU_COMMSEQSPACING;
 MultiWindowsBase->MenuBarChar=MENU_BARCHAR;
 MultiWindowsBase->MenuSubString=MENU_SUBSTRING;

 MultiWindowsBase->TestString=FontTestString;
 MultiWindowsBase->TestStringLength=strlen(FontTestString);

 /* ---- Externe Daten laden -------------------------------------------- */
 MultiWindowsBase->TopazFont=OpenFont(MultiWindowsBase->TopazAttr);
 if(MultiWindowsBase->TopazFont==NULL)
  {
   ErrorL(1040,"Unable to load font:\ntopaz.font 8");
   RemoveLib();
   return(NULL);
  }

 MultiWindowsBase->Password5Font=OpenDiskFont(MultiWindowsBase->Password5Attr);
 MultiWindowsBase->Password9Font=OpenDiskFont(MultiWindowsBase->Password9Attr);
 if((MultiWindowsBase->Password5Font==NULL)||(MultiWindowsBase->Password9Font==NULL))
  {
   ErrorL(1022,"Unable to load font:\npassword.font 5 and 9");
   RemoveLib();
   return(NULL);
  }

 MultiWindowsBase->DefaultFont=OpenDiskFont(MultiWindowsBase->DefaultAttr);
 if(MultiWindowsBase->DefaultFont==NULL)
  {
   sprintf(&str,"%s:\n%s %ld",GetLStr(1101,"Unable to open font"),MultiWindowsBase->DefaultAttr->ta_Name,MultiWindowsBase->DefaultAttr->ta_YSize);
   ErrorRequest(0,&str,0);
   MultiWindowsBase->DefaultFont=MultiWindowsBase->TopazFont;
   MultiWindowsBase->DefaultAttr=MultiWindowsBase->TopazAttr;
  }

 MultiWindowsBase->DefaultNonPropFont=OpenDiskFont(MultiWindowsBase->DefaultNonPropAttr);
 if(MultiWindowsBase->DefaultNonPropFont==NULL)
  {
   sprintf(&str,"%s:\n%s %ld",GetLStr(1101,"Unable to open font"),MultiWindowsBase->DefaultNonPropAttr->ta_Name,MultiWindowsBase->DefaultNonPropAttr->ta_YSize);
   ErrorRequest(0,&str,0);
   MultiWindowsBase->DefaultNonPropFont=MultiWindowsBase->TopazFont;
   MultiWindowsBase->DefaultNonPropAttr=MultiWindowsBase->TopazAttr;
  }

 if(MultiWindowsBase->HelpWallpaperName!=NULL)
  {
   MultiWindowsBase->HelpWallpaper=LoadWallpaper(MultiWindowsBase->HelpWallpaperName);
   if(MultiWindowsBase->HelpWallpaper==NULL)
     ErrorL(1029,"Unable to load help window wallpaper!");
  }

 if(MultiWindowsBase->HelpPointerName!=NULL)
  {
   MultiWindowsBase->HelpPointer=LoadPointer(MultiWindowsBase->HelpPointerName);
   if(MultiWindowsBase->HelpPointer==NULL)
     ErrorL(1036,"Unable to load help pointer!");
  }

 if(MultiWindowsBase->SleepPointerName!=NULL)
  {
   MultiWindowsBase->SleepPointer=LoadPointer(MultiWindowsBase->SleepPointerName);
   if(MultiWindowsBase->SleepPointer==NULL)
     ErrorL(1037,"Unable to load sleep pointer!");
  }

 if(MultiWindowsBase->WorkPointerName!=NULL)
  {
   MultiWindowsBase->WorkPointer=LoadPointer(MultiWindowsBase->WorkPointerName);
   if(MultiWindowsBase->WorkPointer==NULL)
     ErrorL(1018,"Unable to load work pointer!");
  }

 InitHook(&MultiWindowsBase->FloatHook,FloatHookProc,NULL);
 InitHook(&MultiWindowsBase->HexHook,HexHookProc,NULL);
 InitHook(&MultiWindowsBase->UserHook,UserHookProc,NULL);
 ScanDisplayModes();
 return(MultiWindowsBase);
}

/* ---- Library entfernen */
void RemoveLib()
{
 struct List      *list;
 struct Node      *node,*succ;
 struct Wallpaper *wp;
 struct Pointer   *po;

 if(MultiWindowsBase->TopazFont)
   CloseFont(MultiWindowsBase->TopazFont);

 if(MultiWindowsBase->Password5Font)
  {
   RemFont(MultiWindowsBase->Password5Font);
   CloseFont(MultiWindowsBase->Password5Font);
  }

 if(MultiWindowsBase->Password9Font)
  {
   RemFont(MultiWindowsBase->Password9Font);
   CloseFont(MultiWindowsBase->Password9Font);
  }

 list=&MultiWindowsBase->WallpaperList;
 node=list->lh_Head;
 while(node!=&list->lh_Tail)
  {
   succ=node->ln_Succ;
   wp=node;
   wp->UserCount=1;
   UnLoadWallpaper(wp);
   node=succ;
  }

 list=&MultiWindowsBase->PointerList;
 node=list->lh_Head;
 while(node!=&list->lh_Tail)
  {
   succ=node->ln_Succ;
   po=node;
   po->UserCount=1;
   UnLoadPointer(po);
   node=succ;
  }

 list=&MultiWindowsBase->VideoInfoList;
 node=list->lh_Head;
 while(node!=&list->lh_Tail)
  {
   succ=node->ln_Succ;
   FreeMem(node,sizeof(struct VideoInfo));
   node=succ;
  }

 if(MultiWindowsBase->AslLibrary)
   CloseLibrary(MultiWindowsBase->AslLibrary);
 if(MultiWindowsBase->AmigaGuideLibrary)
   CloseLibrary(MultiWindowsBase->AmigaGuideLibrary);
}

/* ---- Neuer Benutzer-Task */
struct MultiWindowsUser *InitWindowsUser(task)
 struct Task *task;
{
 struct MultiDesktopUser *mu;
 struct MultiWindowsUser *mw;
 struct MultiDesktopBase *mdb;
 UBYTE                    str[512];
 int                      i;

 mdb=OpenLibrary("multidesktop.library",0);
 if(mdb==NULL) return(NULL);

 if(task==NULL) task=SysBase->ThisTask;
 mu=task->tc_UserData;
 mw=mu->MultiWindows;
 if(mw==NULL)
  {
   mw=AllocMem(sizeof(struct MultiWindowsUser),MEMF_CLEAR|MEMF_PUBLIC);
   if(mw!=NULL)
    {
     mw->AppPort=CreatePort(0L,0L);
     if(mw->AppPort==NULL)
      {
       FreeMem(mw,sizeof(struct MultiWindowsUser));
       CloseLibrary(mdb);
       return(NULL);
      }
     mw->MultiDesktopBase=mdb;
     mw->UserCount=1;

     mw->FactorX=1.0;
     mw->FactorY=1.0;
     mw->OldFontH=792;
     mw->OldFontV=8;
     mw->NewFontH=792;
     mw->NewFontV=8;
     mw->TextAttr=MultiWindowsBase->TopazAttr;
     mw->BoldTextAttr=&Topaz8Bold;
     mw->TextFont=MultiWindowsBase->TopazFont;
     mw->NonPropTextAttr=MultiWindowsBase->TopazAttr;
     mw->NonPropTextFont=MultiWindowsBase->TopazFont;

     mw->SpaceSize=PixelLength(MultiWindowsBase->TopazFont," ");
     mw->BarCharSize=mw->SpaceSize;   /* Topaz ist nicht proportional */
     mw->SubStringSize=PixelLength(MultiWindowsBase->TopazFont,MultiWindowsBase->MenuSubString);

     mw->ActiveWindowID=-1;
     NewList(&mw->AppObjectList);
     NewList(&mw->CachedFontsList);
     if(MultiWindowsBase->HelpActive) mw->HelpOn=TRUE;

     mw->Arguments=GetArgStr();
     mw->OldTaskPriority=task->Node.ln_Pri;

     GetProgramName(&str,512);
     i=strlen(&str)+2;
     mw->ProgramName=ALLOC1(i);
     if(mw->ProgramName==NULL) NoMemory();
     strcpy(mw->ProgramName,&str);

     GetCurrentDirName(&str,512);
     i=strlen(&str)+2;
     mw->ProgramDirName=ALLOC1(i);
     if(mw->ProgramDirName==NULL) NoMemory();
     strcpy(mw->ProgramDirName,&str);

     mu->MultiWindows=mw;
    }
   else
     CloseLibrary(mdb);
  }
 else
  {
   mw->UserCount++;
  }
 return(mw);
}

/* ---- Benutzer-Task entfernen */
void TerminateWindowsUser(task)
 struct Task *task;
{
 struct MultiDesktopUser *mu;
 struct MultiWindowsUser *mw;
 struct MultiDesktopBase *mdb;
 struct List             *list;
 struct Node             *node,*succ;
 int                      i;

 if(task==NULL) task=SysBase->ThisTask;
 mu=task->tc_UserData;
 mw=mu->MultiWindows;

 if(mw!=NULL)
  {
   mw->UserCount--;
   if(mw->UserCount==0)
    {
     Forbid();
     if(mw->UserNode.Node.ln_Succ) Remove(&mw->UserNode);
     MultiWindowsBase->AppCount--;
     Permit();

     for(i=0;i<MAXWINDOWS;i++)
       if(mw->WindowList[i]) DeleteWindow(i);
     for(i=0;i<MAXSCREENS;i++)
       if(mw->ScreenList[i]) DeleteScreen(i);

     if(mw->Guide) CloseGuide();
     if(mw->Catalog) CloseCatalog(mw->Catalog);
     if(mw->Locale) CloseLocale(mw->Locale);
     if(mw->Icon) FreeDiskObject(mw->Icon);
     if((mw->TextFont)&&(mw->TextFont!=MultiWindowsBase->TopazFont)) CloseFont(mw->TextFont);
     if((mw->NonPropTextFont)&&(mw->NonPropTextFont!=MultiWindowsBase->TopazFont)) CloseFont(mw->NonPropTextFont);

     if(mw->AppPort) DeletePort(mw->AppPort);
     list=&mw->AppObjectList;
     node=list->lh_Head;
     while(node!=&list->lh_Tail)
      {
       succ=node->ln_Succ;
       DeleteAppObject(node);
       node=succ;
      }

     FlushFonts();
     SetTaskPri(SysBase->ThisTask,mw->OldTaskPriority);
     FreeMemory(&mw->Remember);

     mdb=mw->MultiDesktopBase;
     mu->MultiWindows=NULL;
     FreeMem(mw,sizeof(struct MultiWindowsUser));
     CloseLibrary(mdb);
    }
  }
}

/* ---- Applikations-Info */
BOOL AppInfo(name,version,catalog,oldFontH,oldFontV,font,npfont,icon,guide,tagList)
 UBYTE            *name;
 ULONG             version;
 UBYTE            *catalog;
 ULONG             oldFontH,oldFontV;
 struct TextAttr  *font,*npfont;

 UBYTE            *icon;

 UBYTE            *guide;
 struct TagItem  **tagList;
{
 BOOL                     bool;
 UBYTE                    str[256];
 UBYTE                   *arg;
 UBYTE                   *language;
 UBYTE                   *debugName;
 ULONG                    j;
 struct TagItem           tag[4];
 struct MultiDesktopUser *mu;
 struct MultiWindowsUser *mw;
 struct WBStartup        *wbs;
 struct Task             *task;
 struct FileLock         *lock;
 struct WBArg            *wbarg;
 struct FileHandle       *debug;
 int                      i;

 /* --- Zeiger initialisieren ---------------------------------------- */
 USER;
 mu=SysBase->ThisTask->tc_UserData;
 wbs=mu->WBStartup;
 mw->UserNode.Node.ln_Name=name;
 mw->UserNode.Address=mw;
 mw->UserNode.Version=version;
 task=FindTask(NULL);
 language=NULL;

 bool=GetTagData(AI_Req020,FALSE,tagList);
 if((bool)&&(!(SysBase->AttnFlags & AFF_68020)))
  { ErrorL(1124,"This program requires an 68020 processor!"); return(FALSE); }

 bool=GetTagData(AI_Req030,FALSE,tagList);
 if((bool)&&(!(SysBase->AttnFlags & AFF_68030)))
  { ErrorL(1125,"This program requires an 68030 processor!"); return(FALSE); }

 bool=GetTagData(AI_ReqFPU,FALSE,tagList);
 if((bool)&&(!(SysBase->AttnFlags & AFF_68881)))
  { ErrorL(1126,"This program requires an 68881 processor!"); return(FALSE); }

 bool=GetTagData(AI_ReqLocale,FALSE,tagList);
 if((bool)&&(LocaleBase==NULL))
  { ErrorL(1127,"This program requires Workbench 2.1 and Locale"); return(FALSE); }

 j=GetTagData(AI_MinStack,4096,tagList);
 if((ULONG)task->tc_SPUpper-(ULONG)task->tc_SPLower<j)
  {
   sprintf(&str,FindID(mu->Catalog,"1128:This program requires a stack of %ld bytes."),j);
   ErrorRequest(0,&str,"1130:Ignore?!|Quit program!");
   if(j==0) return(FALSE);
  }

 j=GetTagData(AI_MinMemory,0,tagList);
 if((AvailMem(MEMF_ANY))<j)
  {
   sprintf(&str,FindID(mu->Catalog,"1129:This program requires %ld KBytes\nof free memory!"),j/1024);
   j=ErrorRequest(0,&str,"1130:Ignore?!|Quit program!");
   if(j==0) return(FALSE);
  }

 j=GetTagData(AI_MinChipMem,0,tagList);
 if((AvailMem(MEMF_CHIP))<j)
  {
   sprintf(&str,FindID(mu->Catalog,"1131:This program requires %ld KBytes\nof free chip memory!"),j/1024);
   j=ErrorRequest(0,&str,"1130:Ignore?!|Quit program!");
   if(j==0) return(FALSE);
  }

 j=GetTagData(AI_MinOSVersion,0,tagList);
 if(SysBase->LibNode.lib_Version<j)
  {
   sprintf(&str,FindID(mu->Catalog,"1132:This program requires DOS version %ld!"),j);
   j=ErrorRequest(0,&str,0);
   return(FALSE);
  }

 mw->HasMenuHelp=1;
 mw->HasGadgetHelp=1;

/*
 j=GetTagData(AI_NoGadgetHelp,0,tagList);
 if(j==0) mw->HasGadgetHelp=1;

 j=GetTagData(AI_NoMenuHelp,0,tagList);
 if(j==0) mw->HasMenuHelp=1;
*/

 if(font)
   CopyMemQuick(font,&mw->TABuffer[0],sizeof(struct TextAttr));
 else
   CopyMemQuick(MultiWindowsBase->DefaultAttr,&mw->TABuffer[0],sizeof(struct TextAttr));
 mw->TextAttr=&mw->TABuffer[0];

 if(npfont)
   CopyMemQuick(npfont,&mw->TABuffer[2],sizeof(struct TextAttr));
 else
   CopyMemQuick(MultiWindowsBase->DefaultNonPropAttr,&mw->TABuffer[2],sizeof(struct TextAttr));
 mw->NonPropTextAttr=&mw->TABuffer[2];

 /* --- WBStartup, CLI-Startup, Icon laden ------------------------------ */
 if(wbs==NULL)
   mw->Icon=GetDiskObject(mw->ProgramName);
 else
  {
   wbarg=wbs->sm_ArgList;
   if(wbarg->wa_Lock)
    {
     lock=CurrentDir(wbarg->wa_Lock);
     mw->Icon=GetDiskObject(wbarg->wa_Name);
     CurrentDir(lock);
    }
   mw->WorkbenchStartup=TRUE;
  }

 debugName=NULL;
 if(mw->Icon==NULL)
  { mw->Icon=GetDefDiskObject(WBTOOL); }
 else
  {
   arg=FindToolType(mw->Icon->do_ToolTypes,"CATALOG");
   if(arg)
    {
     mw->TaskPriority=atol(arg);
     mw->OldTaskPriority=SetTaskPri(task,mw->TaskPriority);
    }
   arg=FindToolType(mw->Icon->do_ToolTypes,"CATALOG");
   if(arg) catalog=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"LANGUAGE");
   if(arg) language=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"GUIDE");
   if(arg) guide=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"DEBUG");
   if(arg) debugName=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"FONT.NAME");
   if(arg) mw->TextAttr->ta_Name=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"FONT.SIZE");
   if(arg) mw->TextAttr->ta_YSize=atol(arg);
   arg=FindToolType(mw->Icon->do_ToolTypes,"NONPROPFONT.NAME");
   if(arg) mw->NonPropTextAttr->ta_Name=arg;
   arg=FindToolType(mw->Icon->do_ToolTypes,"NONPROPFONT.SIZE");
   if(arg) mw->NonPropTextAttr->ta_YSize=atol(arg);
  }

 if(debugName)
   debug=Open(debugName,MODE_NEWFILE);
 else
   debug=NULL;

 if(mw->Icon)
  {
   mw->ToolTypes=mw->Icon->do_ToolTypes;
   mw->Icon->do_CurrentX=NO_ICON_POSITION;
   mw->Icon->do_CurrentY=NO_ICON_POSITION;
  }
 mw->GuideName=guide;
 if(mw->GuideName) DOut(debug,"(+) Guide file is <%s>.\n",mw->GuideName);

 /* --- Locale und Katalog öffnen ------------------------------------ */
 if((catalog)&&(LocaleBase))
  {
   mw->Locale=OpenLocale(NULL);
   if(mw->Locale!=NULL)
    {
     DOut(debug,"(+) Locale at $%lx\n",mw->Locale);
     if(language)
      {
       tag[0].ti_Tag=OC_Language;
       tag[0].ti_Data=language;
       tag[1].ti_Tag=TAG_DONE;
      }
     else
       tag[0].ti_Tag=TAG_DONE;

     mw->Catalog=OpenCatalogA(mw->Locale,catalog,&tag);
     if(mw->Catalog==NULL)
      {
       GetCurrentDirName(&str,256);
       AddPart(&str,catalog,510);
       mw->Catalog=OpenCatalogA(mw->Locale,&str,&tag);
      }
     if(mw->Catalog)
       DOut(debug,"(+) Catalog <%s> at $%lx\n",catalog,mw->Catalog);
     else
       DOut(debug,"(-) Unable to open catalog <%s>!",catalog);
    }
   else
     DOut(debug,"(!) Unable to allocate locale!");
  }
 else
  {
   if(LocaleBase==NULL) {
     DOut(debug,"(-) No locale.library!\n"); }
  }

 /* --- Zeichensatz öffnen ------------------------------------------- */
 mw->OldFontH=oldFontH;
 mw->OldFontV=oldFontV;

 mw->TextFont=OpenDiskFont(mw->TextAttr);
 if(mw->TextFont==NULL)
  {
   sprintf(&str,"%s:\n%s %ld",GetLStr(1101,"Unable to open font"),mw->TextAttr->ta_Name,mw->TextAttr->ta_YSize);
   ErrorRequest("1100:AppInfo()-Warning",&str,"1012:Continue");
   mw->TextAttr=MultiWindowsBase->TopazAttr;
   mw->TextFont=MultiWindowsBase->TopazFont;
   DOut(debug,"(-) Unable to load font <%s/%ld>, using topaz/8.\n",mw->TextAttr->ta_Name,mw->TextAttr->ta_YSize);
  }
 else
   DOut(debug,"(+) Font <%s/%ld> at $%lx.\n",mw->TextAttr->ta_Name,mw->TextAttr->ta_YSize,mw->TextFont);

 mw->NonPropTextFont=OpenDiskFont(mw->NonPropTextAttr);
 if(mw->NonPropTextFont==NULL)
  {
   sprintf(&str,"%s:\n%s %ld",GetLStr(1101,"Unable to open font"),mw->NonPropTextAttr->ta_Name,mw->NonPropTextAttr->ta_YSize);
   ErrorRequest("1100:AppInfo()-Warning",&str,"1012:Continue");
   mw->NonPropTextAttr=MultiWindowsBase->TopazAttr;
   mw->NonPropTextFont=MultiWindowsBase->TopazFont;
   DOut(debug,"(-) Unable to load font <%s/%ld>, using topaz/8.\n",mw->NonPropTextAttr->ta_Name,mw->TextAttr->ta_YSize);
  }
 else
   DOut(debug,"(+) Font <%s/%ld> at $%lx.\n",mw->NonPropTextAttr->ta_Name,mw->TextAttr->ta_YSize,mw->NonPropTextFont);

 CopyMemQuick(mw->TextAttr,&mw->TABuffer[1],sizeof(struct TextAttr));
 mw->BoldTextAttr=&mw->TABuffer[1];
 mw->BoldTextAttr->ta_Style |= FSF_BOLD;

 /* --- Zeichenlängen für Space und Bar-Zeichen ermitteln ------------ */
 mw->SpaceSize=PixelLength(mw->TextFont," ");
 if(mw->SpaceSize==0) mw->SpaceSize=1;
 DOut(debug,"(+) Space size is %ld.\n",mw->SpaceSize);

 str[0]=MultiWindowsBase->MenuBarChar;
 str[1]=0x00;
 mw->BarCharSize=PixelLength(mw->TextFont,&str);
 if(mw->BarCharSize==0)
  {    /* Zeichensatz ohne MenuBarChar (·) */
   MultiWindowsBase->MenuBarChar='-';
   mw->BarCharSize=PixelLength(mw->TextFont,"-");
   if(mw->BarCharSize==0)
    {  /* Zeichensatz ohne Minus-Zeichen?! */
     MultiWindowsBase->MenuBarChar=' ';
     mw->BarCharSize=10;
    }
  }
 DOut(debug,"(+) Bar char <%c> size is %ld.\n",MultiWindowsBase->MenuBarChar,mw->BarCharSize);

 mw->SubStringSize=PixelLength(mw->TextFont,MultiWindowsBase->MenuSubString);
 if(mw->SubStringSize==0)
  { /* Zeichensatz ohne SubItem-Zeichen (») */
   MultiWindowsBase->MenuSubString=" ";
   mw->SubStringSize=mw->SpaceSize;
  }
 DOut(debug,"(+) Sub string <%s> size is %ld.\n",MultiWindowsBase->MenuSubString,mw->SubStringSize);

 /* --- Streckungsfaktoren berechnen --------------------------------- */
 TestFont(mw->TextFont,&mw->NewFontH,&mw->NewFontV);
 DOut(debug,"(+) Developer's font: H=%ld  V=%ld\n",mw->OldFontH,mw->OldFontV);
 DOut(debug,"(+) Your font:        H=%ld  V=%ld\n",mw->NewFontH,mw->NewFontV);

 mw->FactorX=(FLOAT)mw->NewFontH/(FLOAT)mw->OldFontH;
 mw->FactorY=(FLOAT)mw->NewFontV/(FLOAT)mw->OldFontV;
 DOut(debug,"(+) FactorX=%1.1f  FactorY=%1.1f\n",mw->FactorX,mw->FactorY);

 /* --- Applikation in Applikationsliste einfügen -------------------- */
 Forbid();
 AddTail(&MultiWindowsBase->AppList,&mw->UserNode);
 MultiWindowsBase->AppCount++;
 Permit();
 DOut(debug,"(+) Application added to application list.\n");

 if(debug) Close(debug);
 return(TRUE);
}

/* ---- Hook-Zeichenkopierroutine */
ULONG CopyProc(hook,obj,msg)
 struct Hook *hook;
 ULONG        obj;
 ULONG        msg;
{
 UBYTE *buffer;

 buffer=hook->h_Data;
 buffer[0]=(UBYTE)msg;
 hook->h_Data=(ULONG)buffer+1L;
}

/* ---- String-Formatierung */
BOOL LocaleSFormat(buffer,formatString,args)
 UBYTE *buffer;
 UBYTE *formatString;
 ULONG *args;
{
 struct MultiWindowsUser *mw;
 struct Hook              hook;

 USER;
 if(mw->Locale!=NULL)
  {
   InitHook(&hook,CopyProc,buffer);
   FormatString(mw->Locale,formatString,args,&hook);
   return(TRUE);
  }
 strcpy(buffer,"«No Locale!»");
 return(FALSE);
}

/* ---- Datums-Formatierung */
BOOL LocaleDFormat(buffer,formatString,date)
 UBYTE            *buffer;
 UBYTE            *formatString;
 struct DateStamp *date;
{
 struct MultiWindowsUser *mw;
 struct Hook              hook;

 USER;
 if(mw->Locale!=NULL)
  {
   InitHook(&hook,CopyProc,buffer);
   FormatDate(mw->Locale,formatString,date,&hook);
   return(TRUE);
  }
 strcpy(buffer,"«No Locale V38»");
 return(FALSE);
}

/* ---- Applikationsdaten */
APTR GetLocale()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->Locale);
}

/* ---- Applikationsdaten */
APTR GetCatalog()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->Catalog);
}

/* ---- Applikationsdaten */
UBYTE *GetGuide()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->GuideName);
}

/* ---- Applikationsdaten */
UBYTE *GetProgName()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->ProgramName);
}

/* ---- Applikationsdaten */
UBYTE *GetProgDirName()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->ProgramDirName);
}

/* ---- Applikationsdaten */
UBYTE *GetArguments()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->Arguments);
}

/* ---- Applikationsdaten */
UBYTE *GetWBStartup()
{
 struct MultiDesktopUser *mu;
 mu=SysBase->ThisTask->tc_UserData;
 return(mu->WBStartup);
}

/* ---- Applikationsdaten */
UBYTE **GetToolTypes()
{
 struct MultiWindowsUser *mw;
 USER;
 return(mw->ToolTypes);
}

/* ---- Zeichensatz testen */
void TestFont(font,h,v)
 struct TextFont *font;
 ULONG           *h,*v;
{
 struct RastPort rp;

 InitRastPort(&rp);
 SetFont(&rp,font);
 *h=TextLength(&rp,MultiWindowsBase->TestString,MultiWindowsBase->TestStringLength);
 *v=font->tf_YSize;
}

/* ---- Debug-Ausgabe */
void DOut(fh,text,a1,a2,a3)
 struct FileHandle *fh;
 UBYTE             *text;
 ULONG              a1,a2,a3;
{
 UBYTE buf[200];

 if(fh) {
   sprintf(&buf,text,a1,a2,a3);
   Write(fh,&buf,strlen(&buf)); }
}

/* ---- Font cachen */
struct TextFont *CacheFont(name,size)
 UBYTE *name;
 UWORD  size;
{
 struct TextFont         *font;
 struct CachedFont       *cf;
 struct Node             *node;
 struct MultiWindowsUser *mw;
 struct TextAttr          ta;

 USER;
 for(node=mw->CachedFontsList.lh_Head;node!=&mw->CachedFontsList.lh_Tail;node=node->ln_Succ)
  {
   cf=node;
   if(!(strcmp(name,node->ln_Name))) {
     if(cf->Height==size) {
       return(cf->TextFont);
      }
    }
  }

 cf=ALLOC1(sizeof(struct CachedFont));
 if(cf!=NULL)
  {
   ta.ta_Name=name;
   ta.ta_YSize=size;
   ta.ta_Style=FS_NORMAL;
   ta.ta_Flags=FPF_DISKFONT;
   font=OpenDiskFont(&ta);
   if(font==NULL)
    {
     FREE1(cf);
     return(NULL);
    }

   cf->Node.ln_Name=font->tf_Message.mn_Node.ln_Name;
   cf->Height=font->tf_YSize;
   cf->TextFont=font;

   AddHead(&mw->CachedFontsList,cf);
   return(font);
  }
 return(NULL);
}

/* ---- Font aus Cache entfernen */
void FlushFont(name,size)
 UBYTE *name;
 UWORD  size;
{
 struct CachedFont       *cf;
 struct Node             *node;
 struct MultiWindowsUser *mw;

 USER;
 for(node=mw->CachedFontsList.lh_Head;node!=&mw->CachedFontsList.lh_Tail;node=node->ln_Succ)
  {
   cf=node;
   if(!(strcmp(name,node.ln_Name))) {
     if(cf->Height==size) {
       Remove(cf);
       CloseFont(cf->TextFont);
       FREE1(cf);
       return;
      }
    }
  }
}

/* ---- Alls Fonts aus Cache entfernen */
void FlushFonts()
{
 struct MultiWindowsUser *mw;
 struct CachedFont       *cf;
 struct Node             *node,*succ;
 struct List             *list;

 USER;
 list=&mw->CachedFontsList;
 node=list->lh_Head;

 while(node!=&list->lh_Tail)
  {
   succ=node->ln_Succ;
   cf=node;
   CloseFont(cf->TextFont);
   FREE1(cf);
   node=succ;
  }

 NewList(&mw->CachedFontsList);
}

UBYTE *GuideContext[]={"MAIN",NULL};

/* ---- AmigaGuide-Datei öffnen */
void OpenGuide()
{
 struct MultiWindowsUser *mw;

 USER;
 if((AmigaGuideBase!=NULL)&&(mw->GuideName!=NULL))
  {
   if(mw->Guide==NULL)
    {
     ClearMemQuick(&mw->AmigaGuideBuffer,sizeof(struct NewAmigaGuide));
     mw->AmigaGuideBuffer.nag_Name=mw->GuideName;
/*     mw->AmigaGuideBuffer.nag_BaseName=mw->ProgramName; */
     mw->AmigaGuideBuffer.nag_Context=&GuideContext;

     mw->Guide=OpenAmigaGuideAsync(&mw->AmigaGuideBuffer,NULL);
     if(mw->Guide!=NULL)
      {
       mw->GuideSignalMask=AmigaGuideSignal(mw->Guide);
       mw->GuideReady=FALSE;
       mw->GuideCommand=FALSE;
       SetAmigaGuideContext(mw->Guide,NULL,NULL);
      }
     else
       ErrorL(1134,"OpenAmigaGuideAsync(): Unable to load guide file!");
    }
  }
 else
   ErrorL(1133,"AmigaGuide is not installed!");
}

/* ---- AmigaGuide schließen */
void CloseGuide()
{
 struct MultiWindowsUser *mw;
 struct AmigaGuideMsg    *agm;

 USER;
 if(mw->Guide)
  {
   agm=GetAmigaGuideMsg(mw->Guide);
   while(agm!=NULL)
    {
     ReplyAmigaGuideMsg(agm);
     agm=GetAmigaGuideMsg(mw->Guide);
    }
   CloseAmigaGuide(mw->Guide);
   mw->GuideSignalMask=0;
   mw->Guide=NULL;
  }
}

/* ---- AmigaGuide öffnen und anzeigen */
void ShowGuide()
{
 struct MultiWindowsUser *mw;

 USER;
 if(mw->Guide==NULL) OpenGuide();
 if(mw->Guide)
  {
   SetAmigaGuideContext(mw->Guide,NULL,NULL);
   if(mw->GuideReady)
     SendAmigaGuideContext(mw->Guide,NULL);
   else
     mw->GuideCommand=TRUE;
  }
}

