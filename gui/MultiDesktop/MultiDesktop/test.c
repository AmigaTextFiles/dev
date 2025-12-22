#include "multiwindows.h"
#define D(x) printf("DEBUG %ld\n",x);

BOOL        InitWindow();
void        InitItems();
void        GfxTest();
extern BOOL CreateWindow();
void        Term();
void        Iconify(),UnIconify();

struct MultiWindowsBase  mwb;
struct Library          *VersionBase;
extern struct ExecBase  *SysBase;
extern struct WBStartup *WBenchMsg;
struct IntuitionBase    *IntuitionBase;
struct GfxBase          *GfxBase;
struct LayersBase       *LayersBase;
struct MultiWindowsBase *MultiWindowsBase;
struct ExpansionBase    *ExpansionBase;
extern APTR              IconBase;
APTR                     KeymapBase,UtilityBase,MultiSystemBase;
APTR                     WorkbenchBase,GadToolsBase,MultiDesktopBase,
                         DiskfontBase,LocaleBase;

struct TextAttr newFont=
{
 "helvetica.font",15,FS_NORMAL,FPF_DISKFONT
};

void OpenAll()
{
 VersionBase=OpenLibrary("version.library",0L);
 IntuitionBase=OpenLibrary("intuition.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 LayersBase=OpenLibrary("layers.library",0L);
 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 DiskfontBase=OpenLibrary("diskfont.library",0L);
 IconBase=OpenLibrary("icon.library",0L);
 WorkbenchBase=OpenLibrary("workbench.library",0L);
 GadToolsBase=OpenLibrary("gadtools.library",0L);
 LocaleBase=OpenLibrary("locale.library",0L);
 KeymapBase=OpenLibrary("keymap.library",0L);
 UtilityBase=OpenLibrary("utility.library",0L);
 ExpansionBase=OpenLibrary("expansion.library",0L);
 if(UtilityBase==NULL) exit(0);
 if(ExpansionBase==NULL) exit(0);
 if((IntuitionBase==NULL)||(GfxBase==NULL)||(LayersBase==NULL)) exit(0);
 if((MultiDesktopBase==NULL)||(GadToolsBase==NULL)||(WorkbenchBase==NULL)||(IconBase==NULL)) exit(0);
 if((DiskfontBase==NULL)||(LocaleBase==NULL)||(KeymapBase==NULL)) exit(0);
 MultiSystemBase=OpenLibrary("multisystem.library",0L);
 if(MultiSystemBase==NULL)
  {
   puts("No multisystem.library!");
   exit(0);
  }
}

void CloseAll()
{
 CloseLibrary(ExpansionBase);
 CloseLibrary(UtilityBase);
 CloseLibrary(IntuitionBase);
 CloseLibrary(GfxBase);
 CloseLibrary(LayersBase);
 CloseLibrary(DiskfontBase);
 CloseLibrary(IconBase);
 CloseLibrary(WorkbenchBase);
 CloseLibrary(GadToolsBase);
 RemLibrary(LocaleBase);
 CloseLibrary(LocaleBase);
 CloseLibrary(KeymapBase);
 RemLibrary(MultiDesktopBase);
 CloseLibrary(MultiDesktopBase);
 RemLibrary(MultiSystemBase);
 CloseLibrary(MultiSystemBase);
}

/* ------------------------------------------------------ */

BOOL bool,ende,b2;
long i,j,k;

struct MultiMessage *msg;
struct WindowEntry  *we;

void main()
{
 int zz,x,y;
 struct MultiWindowsUser *mw;

 OpenAll();
 MultiWindowsBase=&mwb;
 InitLib();
 DesktopStartup(WBenchMsg,STARTUP_TRAPHANDLER|STARTUP_BREAKHANDLER_C|STARTUP_BREAKHANDLER_F|STARTUP_ALERTHANDLER|STARTUP_BREAKHANDLER_ON);
 InitWindowsUser(NULL);
 USER;
                                   /* -OldFont- */     /*nonprop*/
 AppInfo("Application",15000,"test.cat", 708,15, &newFont,  NULL,  "m:test",NULL,NULL);
 SetTermProcedure(Term);

/*
 bool=CreateScreen(2,"2:Screen",640,440,3,NTSC_MONITOR_ID|HIRESLACE_KEY,CUSTOMSCREEN,0L,NULL);
 SetScreenWallpaper(2,"Stone7.wallpaper");
*/
 zz=0;
/*
 bool=InitWindow(10,50,50,zz);
 we=FindWindowEntry(10);
*/

bool=OpenInformationBox(0,0,0);
Wallpaper("LightGrey1.wallpaper");


/*
 bool=InitWindow(20,25,25,zz);
 Wallpaper("LightGrey1.wallpaper");
 bool=InitWindow(30,50,50,zz);
*/
 if(bool)
  {
   ende=FALSE;
   while(ende==FALSE)
    {
     msg=GetMultiMessage(WindowID_InformationBox,TRUE);
     if(msg!=NULL)
      {
       if(msg->WindowID!=0) ActWindow(msg->WindowID);
       HandleInformationBox(msg);

       if(msg->Class==MULTI_CLOSEWINDOW)
         ende=TRUE;
       else if(msg->Class==MULTI_VANILLAKEY)
        {
         if(msg->ObjectID==(ULONG)'5') OpenGuide();
         if(msg->ObjectID==(ULONG)'6') CloseGuide();
         if(msg->ObjectID==(ULONG)'7') { puts("Show..."); ShowGuide(); }
         if(msg->ObjectID==(ULONG)'q')
          {
           IconifyWindow(10,IF_APPICON);
           Delay(50);
           b2=UnIconifyWindow(10);
           if(b2==FALSE) ende=TRUE;
          }
         if(msg->ObjectID==(ULONG)'w')
          {
           IconifyScreen(2,IF_APPICON|IF_APPMENU);
           Delay(50);
           b2=UnIconifyScreen(2);
           if(b2==FALSE) ende=TRUE;
          }
         if(msg->ObjectID==(ULONG)'y')
          {
           Iconify();
           Delay(120);
           UnIconify();
          }
         if(msg->ObjectID==(ULONG)'b') StdPointer(STDP_WORK);
         if(msg->ObjectID==(ULONG)'n') StdPointer(STDP_SLEEP);
         if(msg->ObjectID==(ULONG)'m') StdPointer(STDP_HELP);
         if(msg->ObjectID==(ULONG)'v') StdPointer(STDP_DEFAULT);
       }
      }
    }
   CloseInformationBox();
  }

 TerminateWindowsUser(NULL);
 DesktopExit();
 RemoveLib();
 CloseAll();

 printf("Avail=%ld\n",AvailMem(MEMF_PUBLIC));
}

void Term()
{
 TerminateWindowsUser(NULL);
 DesktopExit();
 RemoveLib();
 CloseAll();
 printf("Avail=%ld\n",AvailMem(MEMF_PUBLIC));
 exit(0);
}

BOOL InitWindow(id,w,h,scrID)
 int id,w,h,scrID;
{
 BOOL bool;

 bool=CreateWindow(id,"1:Window",w,h,450,210,CW_CLOSE|CW_DEPTH|CW_SIZE|CW_DRAG,scrID,NULL);
 if(bool==FALSE) return(FALSE);

 GfxTest();

/*
 Wallpaper("Sand1.wallpaper");

 AddHSlider(  1,"10",  20,  20,150, 20, "Slider", CGA_RIGHT, 7500,0,20000);
 MakeAction(2,AGC_SLIDER,AGC_NUMBER);
 MakeAction(3,AGC_SLIDER,AGC_STATUS);
 MakeAction(4,AGC_SLIDER,AGC_HEX);
 AddNumber(   2,"11",  20,  50,150, 20, "Number", CGA_RIGHT, "This is number %lD",4711,JSF_CENTER);
 AddStatus(   3,"12",  20,  80,150, 20, "Status", CGA_RIGHT, "%ld files",7500,0,20000);
 AddHex(      4,"13",  20, 110,150, 20, "Hex", CGA_RIGHT|CIN_CENTER,0x7466,0,0xffff);
 AddString(   5,"14",  20, 140,150, 20, "String", CST_PASSWORD|CGA_RIGHT|CST_CENTER,"",256);
 MakeAction(6,AGC_STRING,AGC_TEXT);
 AddText(     6,"10",  20, 170,150, 20, "Text", CGA_RIGHT, "Text-Gadget!",JSF_CENTER);
*/
/*
 AddIcon( 6,"10",60, 60,80,40, "Test 1", CGA_BELOW,"M:Test");
 AddImage(8,"10",160, 60,80,40, "Test 2",CGA_BELOW,LEFTIMAGE);
*/

/*
 AddWheel(     6,"10",  50, 50,100,100, "6", CGA_ABOVE, 200,0,500);
 MakeAction(2,AGC_WHEEL,AGC_NUMBER);
 AddNumber(    2,"11",  50,160,100, 20, "2", CGA_RIGHT, "%ld",200,JSF_CENTER);

 AddSelectBox(     6,"10",  50, 50,150,20, "6:_SelectBox", CGA_DEFAULT, &array, 3);
*/
/*
 AddMenu( 1,"300:Menu 1", "300:Menu 1", CME_DEFAULT);  InitItems();
 AddMenu(99,"301:Menu 2", "301:Menu 2", CME_DEFAULT);  InitItems();
*/
 AddStdMenus();
 ShowMenu();
 return(TRUE);
}

void InitItems()
{
 AddItem( 1,"100:New item",  "200:New...",  0, "Shift-N", 0);
  MakeItemAction(3,IAF_DISABLE);
 AddBarItem(1000);
 AddItem( 2,"101:Load item", "201:Load...",  0, "Alt-Ctrl-L", 0);
  MakeItemAction(3,IAF_ENABLE);
 AddItem( 3,"102:Save item", "202:Save...",  0, 0,  0);
 AddSubItem(10, "109:ASCII-Item", "209:ASCII", 0, "Shift-F3",0);
 AddSubBarItem(11);
 AddSubCheckItem(12, "110:Text item",   "210:Text",    0, "Shift-F4",0,TRUE);
  MakeItemAction(13,IAF_UNCHECK);
  MakeItemAction(14,IAF_UNCHECK);
 AddSubCheckItem(13, "111:Picture item","211:Picture", 0, "F7",0,FALSE);
  MakeItemAction(12,IAF_UNCHECK);
  MakeItemAction(14,IAF_UNCHECK);
 AddSubCheckItem(14, "112:Special item","212:Special", 0, "Alt-F9",0,FALSE);
  MakeItemAction(12,IAF_CHECK);
  MakeItemAction(13,IAF_CHECK);
 AddBarItem(2000);
 AddItem( 4,"103:Save-as item",     "203:Save as...",  0, "Shift-A",  0);
 AddBarItem(3000);
 AddItem( 5,"104:Information item", "204:Information",  0, "Shift-F10",    0);
 AddBarItem(4000);
 AddItem( 6,"105:Quit item",        "205:Quit","2051:Are you sure?", "Q", CMI_T2BOLD);
}

#asm
   public _GuruTest
_GuruTest:
   illegal
   rts
   public _GuruTest2
_GuruTest2:
   move.w sr,d0
   rts
#endasm

void Iconify()
{
 struct MultiWindowsUser *mw;
 BOOL                     bool;
 int                      i,j;

 USER;
 j=0;
/*
 for(i=0;i<MAXWINDOWS;i++)
  {
   if(mw->WindowList[i]!=NULL)
    {
     if(j==0)
       bool=IconifyWindow(i,IF_APPICON|IF_APPMENU);
     else
       bool=IconifyWindow(i,0);
     j++;
    }
  }
*/
 for(i=0;i<MAXSCREENS;i++)
  {
   if(mw->ScreenList[i]!=NULL)
    {
     if(j==0)
       bool=IconifyScreen(i,IF_APPICON|IF_APPMENU);
     else
       bool=IconifyScreen(i,0);
     j++;
    }
  }
}

void UnIconify()
{
 struct MultiWindowsUser *mw;
 BOOL                     bool;
 int                      i,j;

 USER;
 for(i=0;i<MAXSCREENS;i++)
  {
   if(mw->ScreenList[i]!=NULL)
    {
     bool=UnIconifyScreen(i);
    }
  }
/*
 for(i=0;i<MAXWINDOWS;i++)
  {
   if(mw->WindowList[i]!=NULL)
    {
     bool=UnIconifyWindow(i,IF_APPICON|IF_APPMENU);
    }
  }
*/
}

void GfxTest()
{
 UBYTE r,g,b;

 CorrectionOn();

 SetFgPen(3);
 SetStyle(ST_ITALIC|ST_OUTLINE|ST_SHADOW|ST_WIDE);
 Plot(10,10);

 AInit();

/*
 Rectangle(15,15,100,150);
 Ellipse(75,75,40,40);
*/
/*
 SetOlPen(7);

 AEllipse(75,75,40,40);
 AEnd();

 SetFgPen(6);
 AMoveTo(75,75);
 ADrawTo(150,150);
 ADrawTo(10,120);
 ADrawTo(30,20);
 AEnd();
*/
/*
 SetFgPen(6);
 Paint(75,75);
*/
 SetFgPen(7);
 SetBgPen(4);

/*
 SetWindowFont("opal.font",9);
 Print(20,10,"MultiWindows Test!");
 SetWindowFont("times.font",18);
 Print(20,22,"MultiWindows Test!");
 SetWindowFont("sapphire.font",18);
 Print(20,45,"MultiWindows Test!");
 SetWindowFont("emerald.font",9);
 Print(20,65,"MultiWindows Test!");
 SetWindowFont("ruby.font",12);
 Print(20,80,"MultiWindows Test!");
*/

/*
 Circle(100,100,70);
 SetPalette(7,255,250,100);
 GetPalette(7,&r,&g,&b);
 printf("%ld %ld %ld\n",r,g,b);  */

/* Wallpaper("Stone1.wallpaper"); */

}

