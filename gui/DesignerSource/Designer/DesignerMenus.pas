{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1994       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit designermenus;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility;

Function MakeMenuMainWindowMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuPrefsMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuEditImageMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuDisplayImagemenu(VisualInfo : Pointer):Boolean;
Function MakeMenuMainCodeMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuLibMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuWinListMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuGadgetMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuWinSizesMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuWinTagsMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuWinIDCMPMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuScreenReqMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuWinCodeMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuGlistMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuEditWinMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuMagnifyMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuLocaleMenu(VisualInfo : Pointer):Boolean;
Function MakeMenuScreenEditMenu(VisualInfo : Pointer):Boolean;
Procedure Settagitem( pt : ptagitem ; tag : long ; data : long);
procedure printstring(pwin:pwindow;x,y:word;s:string;f,b:byte;font:ptextattr;dm:byte);
procedure stripintuimessages(mp:pmsgport;win:pwindow);
procedure closewindowsafely(win : pwindow);
function generalgadtoolsgad(kind         : long;
                            x,y,w,h,id   : word;
                            ptxt         : pbyte;
                            font         : ptextattr;
                            flags        : long;
                            visinfo      : pointer;
                            pprevgad     : pgadget;
                            userdata     : pointer;
                            taglist      : ptagitem
                           ):pgadget;
function getstringfromgad(pgad:pgadget):string;
function getintegerfromgad(pgad:pgadget):long;
function GadSelected(pgad:pgadget):Boolean;
procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long;pmport:pmsgport):pwindow;
procedure freebitmap(pbm : pbitmap;w,h:word);

Type

  PNewMenuArray = ^TNewMenuArray;
  TNewMenuArray = array [1..10000] of tnewmenu;

const

  MenuProject = 0;
  MenuClearAll = 0;
  MenuProject_Item19 = 1;
  MenuOpen = 2;
  MenuMerge = 3;
  NewMenu0_Menu0_Item2 = 4;
  MenuSave = 5;
  MenuSaveAs = 6;
  MenuProject_Item17 = 7;
  MenuRevert = 8;
  MenuImport = 9;
  MenuProject_Item16 = 10;
  MenuGenerate = 11;
  NewMenu0_Menu0_Item7 = 12;
  MenuAbout = 13;
  NewMenu0_Menu0_Item10 = 14;
  MenuQuit = 15;
  MenuOptions = 1;
  MenuPrefs = 0;
  MenuCode = 1;
  MenuLibs = 2;
  MenuLocale = 3;
  MenuEditTags = 4;
  MainMenuHelp = 5;
  PrefsControl = 0;
  PrefsDefault = 0;
  PrefsLast = 1;
  PrefsControl_Item5 = 2;
  prefshelpmenucode = 3;
  prefshelpmenu = 4;
  PrefsSave = 5;
  PrefsUse = 6;
  PrefsCancel = 7;
  MenuEditImage = 0;
  MenuReplaceImage = 0;
  MenuViewImage = 1;
  NewMenu3_Menu0_Item4 = 2;
  MenuHelpImage = 3;
  NewMenu3_Menu0_Item5 = 4;
  MenuOKImage = 5;
  MenuImageCancel = 6;
  ImageOptions = 0;
  DisplayEdit = 0;
  ImageOptions_Item3 = 1;
  DisplayZip = 2;
  ImageOptions_Item4 = 3;
  DisplayClose = 4;
  MainCodeOptions = 0;
  MainCodeOptionslocale = 0;
  MainCodeOptionslibs = 1;
  MainCodeOptions_Item4 = 2;
  MainCodeOptionssavedef = 3;
  MainCodeOption_susedef = 4;
  MainCodeOption_Item10X = 5;
  MainCodeOptionsloaddef = 6;
  MainCodeOption_Item6X = 7;
  MainCodeoptionshelp = 8;
  MainCodeOptions_Item3 = 9;
  maincodeoptionsclose = 10;
  LibOpt = 0;
  LibOptDefault = 0;
  LibOpt_Item4 = 1;
  LibOptHelp = 2;
  LibOpt_Item5 = 3;
  LibOptok = 4;
  LibOptcancel = 5;
  WinListOpts = 0;
  WinListUpdate = 0;
  WinListOpts_Item1 = 1;
  WinListHelp = 2;
  WinListOpts_Item3 = 3;
  WinListClose = 4;
  GadgOpts = 0;
  GadgOptsFont = 0;
  GadgOpts_Item7 = 1;
  GadgOptsHelp = 2;
  GadgOpts_Item5 = 3;
  GadgOptsOK = 4;
  GadgOptsClose = 5;
  WinsizesOptions = 0;
  winsizesoptionsupdate = 0;
  WinsizesOptions_Item5 = 1;
  WinsizesOptionshelp = 2;
  WinsizesOptions_Item4 = 3;
  WinsizesOptionsok = 4;
  WinsizesOptionscancel = 5;
  WinTagOpts = 0;
  wintagshelp = 0;
  NewMenu10_Menu0_Item6 = 1;
  wintagsundo = 2;
  fgfdgfdgfd = 3;
  wintagsok = 4;
  wintagscancel = 5;
  winIdcmpoptions = 0;
  winIdcmpoptionsdefault = 0;
  winIdcmpoptions_Item5 = 1;
  winIdcmpoptionshelp = 2;
  winIdcmpoptions_Item4 = 3;
  winIdcmpoptionsok = 4;
  winIdcmpoptionscancel = 5;
  ReqOptions = 0;
  ReqOptionsFont = 0;
  ReqOptionsbar = 1;
  ReqOptionsok = 2;
  ReqOptionscancel = 3;
  WinCodeOptions = 0;
  WinCodeOptionsHelp = 0;
  WinCodeOptions_Item2 = 1;
  WinCodeOptionsok = 2;
  WinCodeOptionscancel = 3;
  Gadlistmenuoptions = 0;
  gadlistmenuoptionshelp = 0;
  Gadlistmenuoptions_Item2 = 1;
  GadlistmenuoptionsClose = 2;
  Editwindowopts = 0;
  Editwindowopts_Item11 = 0;
  Editwindowopts_Item10 = 1;
  Editwindowoptssizes = 2;
  Editwindowoptstags = 3;
  Editwindowopts_magnify = 4;
  Editwindowoptsscreen = 5;
  Editwindowoptsscrfont = 6;
  Editwindowoptsidcmp = 7;
  Editwindowoptscode = 8;
  Editwindowopts_Item9 = 9;
  Editwindowoptshelp = 10;
  Editwindowopts_Item7 = 11;
  Editwindowoptsexit = 12;
  EditWinMenugadgets = 1;
  EditWinMenugadgetsglist = 0;
  EditWinMenugadgetshighall = 1;
  EditWinMenugadgetshighnone = 2;
  EditWinMenugadgetsedithigh = 3;
  MagnifyTitle = 0;
  MagnifyMenuHelp = 0;
  NewMenu16_Menu0_Item1 = 1;
  MagnifyMenuClose = 2;
  LocaleMenuTitle = 0;
  LocaleMenuTitle_help = 0;
  LocalMenuTitle_Item3 = 1;
  localemenutitle_ok = 2;
  LocalMenuTitle_cancel = 3;
  Screeneditmenutitle = 0;
  Screeneditmenu_update = 0;
  Screeneditmenu_Item4 = 1;
  screeneditmenu_help = 2;
  Screeneditmenu_Item1 = 3;
  Screeneditmenutitle_Item7 = 4;
  Screeneditmenutitle_Item6 = 5;
  Screeneditmenu_ok = 6;
  Screeneditmenu_cancel = 7;
  ScreenEditMenu_Menu1 = 1;
  ScreenEditMenuerrorcode = 0;
  ScreenEditMenusharedpens = 1;
  ScreenEditMenu_Menu1_Item2 = 2;
  ScreenEditMenuexclusive = 3;
  ScreenEditMenuinterleaved = 4;
  ScreenEditMenulikeworkbench = 5;
Var
  MainWindowMenu : pmenu;
  PrefsMenu : pmenu;
  EditImageMenu : pmenu;
  DisplayImagemenu : pmenu;
  MainCodeMenu : pmenu;
  LibMenu : pmenu;
  WinListMenu : pmenu;
  GadgetMenu : pmenu;
  WinSizesMenu : pmenu;
  WinTagsMenu : pmenu;
  WinIDCMPMenu : pmenu;
  ScreenReqMenu : pmenu;
  WinCodeMenu : pmenu;
  GlistMenu : pmenu;
  EditWinMenu : pmenu;
  MagnifyMenu : pmenu;
  LocaleMenu : pmenu;
  ScreenEditMenu : pmenu;
  LocaleBase : plibrary;

Implementation

Function MakeMenuMainWindowMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..25] of string[14]=
  (
  'Project'#0,
  'Clear All'#0,
  'bar'#0,
  'Open...'#0,
  'Merge...'#0,
  'New Item 2'#0,
  'Save'#0,
  'Save As...'#0,
  'bar'#0,
  'Revert'#0,
  'Import GTB...'#0,
  'bar'#0,
  'Generate'#0,
  'New Item 7'#0,
  'About...'#0,
  'New Item 10'#0,
  'Quit...'#0,
  'Options'#0,
  'Prefs...'#0,
  'Code...'#0,
  'Libraries...'#0,
  'Locale...'#0,
  'Edit Tags...'#0,
  'Help...'#0,
  ''#0
  );
  MenuCommKeys : array[1..25] of string[2]=
  (
  ''#0,
  ''#0,
  ''#0,
  'O'#0,
  ''#0,
  ''#0,
  'V'#0,
  'S'#0,
  ''#0,
  'R'#0,
  ''#0,
  ''#0,
  'G'#0,
  ''#0,
  'A'#0,
  ''#0,
  'Q'#0,
  ''#0,
  'P'#0,
  'C'#0,
  'L'#0,
  ''#0,
  'T'#0,
  'H'#0,
  ' '#0
  );
  NewMenus : array[1..25] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 25 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        6  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        9  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        12 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        14 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        16 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  MainWindowMenu:=createmenusa(@newmenus[1],Nil);
  If MainWindowMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(MainWindowMenu,visualinfo,@tags[1]) then;
      makemenuMainWindowMenu:=True;
    end
   else
    makemenuMainWindowMenu:=false;
end;

Function MakeMenuPrefsMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..10] of string[11]=
  (
  'Control'#0,
  'Default'#0,
  'Last Saved'#0,
  'New Item 5'#0,
  'Help...'#0,
  'New Item 6'#0,
  'Save...'#0,
  'Use...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..10] of string[2]=
  (
  ''#0,
  'D'#0,
  'L'#0,
  ''#0,
  'H'#0,
  ''#0,
  'S'#0,
  'U'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..10] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 10 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        4  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        6  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  PrefsMenu:=createmenusa(@newmenus[1],Nil);
  If PrefsMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(PrefsMenu,visualinfo,@tags[1]) then;
      makemenuPrefsMenu:=True;
    end
   else
    makemenuPrefsMenu:=false;
end;

Function MakeMenuEditImageMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..9] of string[11]=
  (
  'Edit Image'#0,
  'Replace...'#0,
  'View...'#0,
  'New Item 4'#0,
  'Help...'#0,
  'New Item 5'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..9] of string[2]=
  (
  ''#0,
  'R'#0,
  'V'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..9] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 9 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        4  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        6  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  EditImageMenu:=createmenusa(@newmenus[1],Nil);
  If EditImageMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(EditImageMenu,visualinfo,@tags[1]) then;
      makemenuEditImageMenu:=True;
    end
   else
    makemenuEditImageMenu:=false;
end;

Function MakeMenuDisplayImagemenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..7] of string[17]=
  (
  'Options'#0,
  'Edit Image...'#0,
  'New Item 3'#0,
  'Zip Window...'#0,
  'New Item 4'#0,
  'Close Display...'#0,
  ''#0
  );
  MenuCommKeys : array[1..7] of string[2]=
  (
  ''#0,
  'E'#0,
  ''#0,
  'Z'#0,
  ''#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..7] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 7 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  DisplayImagemenu:=createmenusa(@newmenus[1],Nil);
  If DisplayImagemenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(DisplayImagemenu,visualinfo,@tags[1]) then;
      makemenuDisplayImagemenu:=True;
    end
   else
    makemenuDisplayImagemenu:=false;
end;

Function MakeMenuMainCodeMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..13] of string[21]=
  (
  'Code Options'#0,
  'Locale'#0,
  'Libraries'#0,
  'New Item 4'#0,
  'Save Code Options'#0,
  'Use Code Options'#0,
  'New Item 10'#0,
  'Default Code Options'#0,
  'New Item 6'#0,
  'Help...'#0,
  'New Item 3'#0,
  'Close...'#0,
  ''#0
  );
  MenuCommKeys : array[1..13] of string[2]=
  (
  ''#0,
  'O'#0,
  'L'#0,
  ''#0,
  'S'#0,
  'U'#0,
  ''#0,
  'D'#0,
  ''#0,
  'H'#0,
  ''#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..13] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 13 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        4  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        7  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        9  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        11 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  MainCodeMenu:=createmenusa(@newmenus[1],Nil);
  If MainCodeMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(MainCodeMenu,visualinfo,@tags[1]) then;
      makemenuMainCodeMenu:=True;
    end
   else
    makemenuMainCodeMenu:=false;
end;

Function MakeMenuLibMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..8] of string[16]=
  (
  'Library Options'#0,
  'Default...'#0,
  'New Item 4'#0,
  'Help...'#0,
  'New Item 5'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..8] of string[2]=
  (
  ''#0,
  'D'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..8] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 8 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  LibMenu:=createmenusa(@newmenus[1],Nil);
  If LibMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(LibMenu,visualinfo,@tags[1]) then;
      makemenuLibMenu:=True;
    end
   else
    makemenuLibMenu:=false;
end;

Function MakeMenuWinListMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..7] of string[11]=
  (
  'Options'#0,
  'Update...'#0,
  'grrggrg'#0,
  'Help...'#0,
  'New Item 3'#0,
  'Close...'#0,
  ''#0
  );
  MenuCommKeys : array[1..7] of string[2]=
  (
  ''#0,
  'U'#0,
  ''#0,
  'H'#0,
  ''#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..7] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 7 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  WinListMenu:=createmenusa(@newmenus[1],Nil);
  If WinListMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(WinListMenu,visualinfo,@tags[1]) then;
      makemenuWinListMenu:=True;
    end
   else
    makemenuWinListMenu:=false;
end;

Function MakeMenuGadgetMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..8] of string[15]=
  (
  'Gadget Options'#0,
  'Font...'#0,
  'New Item 5'#0,
  'Help...'#0,
  'New Item 3'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..8] of string[2]=
  (
  ''#0,
  'F'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..8] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 8 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  GadgetMenu:=createmenusa(@newmenus[1],Nil);
  If GadgetMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(GadgetMenu,visualinfo,@tags[1]) then;
      makemenuGadgetMenu:=True;
    end
   else
    makemenuGadgetMenu:=false;
end;

Function MakeMenuWinSizesMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..8] of string[13]=
  (
  'Window Sizes'#0,
  'Update...'#0,
  'New Item 5'#0,
  'Help...'#0,
  'New Item 4'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..8] of string[2]=
  (
  ''#0,
  'U'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..8] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 8 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  WinSizesMenu:=createmenusa(@newmenus[1],Nil);
  If WinSizesMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(WinSizesMenu,visualinfo,@tags[1]) then;
      makemenuWinSizesMenu:=True;
    end
   else
    makemenuWinSizesMenu:=false;
end;

Function MakeMenuWinTagsMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..8] of string[20]=
  (
  'Window Tags Options'#0,
  'Help...'#0,
  'bar'#0,
  'Undo'#0,
  'bar'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..8] of string[2]=
  (
  ''#0,
  'H'#0,
  ''#0,
  'U'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..8] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 8 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  WinTagsMenu:=createmenusa(@newmenus[1],Nil);
  If WinTagsMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(WinTagsMenu,visualinfo,@tags[1]) then;
      makemenuWinTagsMenu:=True;
    end
   else
    makemenuWinTagsMenu:=false;
end;

Function MakeMenuWinIDCMPMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..8] of string[14]=
  (
  'IDCMP Options'#0,
  'Default...'#0,
  'bar'#0,
  'Help...'#0,
  'bar'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..8] of string[2]=
  (
  ''#0,
  'D'#0,
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..8] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 8 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  WinIDCMPMenu:=createmenusa(@newmenus[1],Nil);
  If WinIDCMPMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(WinIDCMPMenu,visualinfo,@tags[1]) then;
      makemenuWinIDCMPMenu:=True;
    end
   else
    makemenuWinIDCMPMenu:=false;
end;

Function MakeMenuScreenReqMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..6] of string[19]=
  (
  'Screen Req Options'#0,
  'Font...'#0,
  'bar'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..6] of string[2]=
  (
  ''#0,
  'F'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..6] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 6 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  ScreenReqMenu:=createmenusa(@newmenus[1],Nil);
  If ScreenReqMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(ScreenReqMenu,visualinfo,@tags[1]) then;
      makemenuScreenReqMenu:=True;
    end
   else
    makemenuScreenReqMenu:=false;
end;

Function MakeMenuWinCodeMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..6] of string[13]=
  (
  'Code Options'#0,
  'Help...'#0,
  'bar'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..6] of string[2]=
  (
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..6] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 6 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  WinCodeMenu:=createmenusa(@newmenus[1],Nil);
  If WinCodeMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(WinCodeMenu,visualinfo,@tags[1]) then;
      makemenuWinCodeMenu:=True;
    end
   else
    makemenuWinCodeMenu:=false;
end;

Function MakeMenuGlistMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..5] of string[20]=
  (
  'Gadget List Options'#0,
  'Help...'#0,
  'bar'#0,
  'Close...'#0,
  ''#0
  );
  MenuCommKeys : array[1..5] of string[2]=
  (
  ''#0,
  'H'#0,
  ''#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..5] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 5 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  GlistMenu:=createmenusa(@newmenus[1],Nil);
  If GlistMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(GlistMenu,visualinfo,@tags[1]) then;
      makemenuGlistMenu:=True;
    end
   else
    makemenuGlistMenu:=false;
end;

Function MakeMenuEditWinMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..20] of string[18]=
  (
  'Window'#0,
  'Update Win'#0,
  'New'#0,
  'Sizes...'#0,
  'Tags...'#0,
  'Magnify...'#0,
  'Screen...'#0,
  'Screen Font...'#0,
  'IDCMP...'#0,
  'Code...'#0,
  'bar'#0,
  'Help...'#0,
  'bar'#0,
  'Exit...'#0,
  'Gadgets'#0,
  'Gadget List...'#0,
  'Highlight All'#0,
  'Highlight None'#0,
  'Edit High Gadgets'#0,
  ''#0
  );
  MenuCommKeys : array[1..20] of string[2]=
  (
  ''#0,
  'U'#0,
  ''#0,
  'S'#0,
  'T'#0,
  'M'#0,
  ''#0,
  ''#0,
  'I'#0,
  'C'#0,
  ''#0,
  'H'#0,
  ''#0,
  'X'#0,
  ''#0,
  'G'#0,
  'A'#0,
  'N'#0,
  'E'#0,
  ' '#0
  );
  NewMenus : array[1..20] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 20 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        11 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        13 : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  EditWinMenu:=createmenusa(@newmenus[1],Nil);
  If EditWinMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(EditWinMenu,visualinfo,@tags[1]) then;
      makemenuEditWinMenu:=True;
    end
   else
    makemenuEditWinMenu:=false;
end;

Function MakeMenuMagnifyMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..5] of string[16]=
  (
  'Magnify Options'#0,
  'Help...'#0,
  'bar'#0,
  'Close...'#0,
  ''#0
  );
  MenuCommKeys : array[1..5] of string[2]=
  (
  ''#0,
  'H'#0,
  ''#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..5] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 5 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  MagnifyMenu:=createmenusa(@newmenus[1],Nil);
  If MagnifyMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(MagnifyMenu,visualinfo,@tags[1]) then;
      makemenuMagnifyMenu:=True;
    end
   else
    makemenuMagnifyMenu:=false;
end;

Function MakeMenuLocaleMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..6] of string[11]=
  (
  'Options'#0,
  'Help..'#0,
  'New Item 3'#0,
  'OK...'#0,
  'Cancel...'#0,
  ''#0
  );
  MenuCommKeys : array[1..6] of string[2]=
  (
  ''#0,
  'H'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ' '#0
  );
  NewMenus : array[1..6] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 6 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  LocaleMenu:=createmenusa(@newmenus[1],Nil);
  If LocaleMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(LocaleMenu,visualinfo,@tags[1]) then;
      makemenuLocaleMenu:=True;
    end
   else
    makemenuLocaleMenu:=false;
end;

Function MakeMenuScreenEditMenu(VisualInfo : Pointer):Boolean;
Const
  MenuTexts : array[1..17] of string[23]=
  (
  'Edit Screen'#0,
  'Update...'#0,
  'bar'#0,
  'Help...'#0,
  'bar'#0,
  'Get CMAP...'#0,
  'New Item 6'#0,
  'OK...'#0,
  'Cancel...'#0,
  'More Tags'#0,
  'SA_ErrorCode'#0,
  'SA_SharePens     (V39)'#0,
  'SA_Draggable     (V39)'#0,
  'SA_Exclusive     (V39)'#0,
  'SA_Interleaved   (V39)'#0,
  'SA_LikeWorkBench (V39)'#0,
  ''#0
  );
  MenuCommKeys : array[1..17] of string[2]=
  (
  ''#0,
  ''#0,
  ''#0,
  'H'#0,
  ''#0,
  'M'#0,
  ''#0,
  'O'#0,
  'C'#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ''#0,
  ' '#0
  );
  NewMenus : array[1..17] of tnewmenu=
  (
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; Nm_Label : Nil; Nm_Flags :0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type : Nm_Title; Nm_Label : Nil; Nm_Flags : 0; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :  Nm_Item; NM_Label : Nil; Nm_Flags : 9; Nm_MutualExclude : 0),
  ( Nm_Type :   Nm_End; Nm_Label : Nil; Nm_Flags : 0)
  );
Var
  Loop     : Word;
  pnma     : PNewMenuArray;
  Tags     : array [1..3] of TTagItem;
Begin
  pnma:=PNewMenuArray(@NewMenus[1]);
  for loop:=1 to 17 do
    begin
      if pnma^[loop].nm_label=Nil then
        pnma^[loop].nm_label:=STRPTR(@MenuTexts[loop,1]);
      if MenuCommKeys[loop]<>''#0 then
        pnma^[loop].nm_commkey:=STRPTR(@MenuCommKeys[loop,1])
       else
        pnma^[loop].nm_commkey:=nil;
      case loop of
        3  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        5  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
        7  : pnma^[loop].nm_label:=strptr(Nm_BarLabel);
       end;
    end;
  ScreenEditMenu:=createmenusa(@newmenus[1],Nil);
  If ScreenEditMenu<>nil then 
    begin
      tags[1].ti_tag:=gt_tagbase+67;
      tags[1].ti_data:=long(true);
      tags[2].ti_tag:=tag_done;
      if layoutmenusa(ScreenEditMenu,visualinfo,@tags[1]) then;
      makemenuScreenEditMenu:=True;
    end
   else
    makemenuScreenEditMenu:=false;
end;

Procedure Settagitem( pt : ptagitem ; tag : long ; data : long);
Begin
  pt^.ti_tag:=tag;
  pt^.ti_data:=data;
end;

procedure printstring(pwin:pwindow;x,y:word;s:string;f,b:byte;font:ptextattr;dm:byte);
var
  mit : tintuitext;
  str : string;
begin
  str:=s+#0;
  with mit do
    begin
      frontpen:=f;
      backpen:=b;
      leftedge:=x;
      topedge:=y;
      itextfont:=font;
      drawmode:=dm;
      itext:=@str[1];
      nexttext:=nil;
    end;
  printitext(pwin^.rport,@mit,0,0);
end;

procedure stripintuimessages(mp:pmsgport;win:pwindow);
  var
  msg  : pintuimessage;
  succ : pnode;
begin
  msg:=pintuimessage(mp^.mp_msglist.lh_head);
  succ:=msg^.execmessage.mn_node.ln_succ;
  while (succ<>nil) do
    begin
      if (msg^.idcmpwindow=win) then
        begin
          remove(pnode(msg));
          replymsg(pmessage(msg));
        end;
      msg:=pintuimessage(succ);
      succ:=msg^.execmessage.mn_node.ln_succ;
    end;
end;

procedure closewindowsafely(win : pwindow);
begin
  forbid;
  stripintuimessages(win^.userport,win);
  win^.userport:=nil;
  if modifyidcmp(win,0) then ;
  permit;
  closewindow(win);
end;

function generalgadtoolsgad(kind         : long;
                            x,y,w,h,id   : word;
                            ptxt         : pbyte;
                            font         : ptextattr;
                            flags        : long;
                            visinfo      : pointer;
                            pprevgad     : pgadget;
                            userdata     : pointer;
                            taglist      : ptagitem
                           ):pgadget;
var
  newgad : tnewgadget;
begin
  with newgad do
    begin
      ng_textattr:=font;
      ng_leftedge:=x;
      ng_topedge:=y;
      ng_width:=w;
      ng_height:=h;
      ng_gadgettext:=ptxt;
      ng_gadgetid:=id;
      ng_flags:=flags;
      ng_visualinfo:=visinfo;
    end;
  generalgadtoolsgad:=creategadgeta(kind,pprevgad,@newgad,taglist)
end;

function getstringfromgad(pgad:pgadget):string;
var
  psi   : pstringinfo;
  strin : string;
begin
  psi:=pstringinfo(pgad^.specialinfo);
  ctopas(psi^.buffer^,strin);
  getstringfromgad:=strin+#0;
end;

function getintegerfromgad(pgad:pgadget):long;
var
  psi   : pstringinfo;
begin
  psi:=pstringinfo(pgad^.specialinfo);
  getintegerfromgad:=psi^.longint_;
end;

function GadSelected(pgad:pgadget):Boolean;
begin
  GadSelected:=((pgad^.flags and gflg_selected)<>0);
end;

procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
var
  t : array [1..3] of long;
begin
  t[1]:=tag1;
  t[2]:=tag2;
  t[3]:=tag_done;
  gt_setgadgetattrsa(gad,win,nil,@t[1]);
end;

function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long;pmport:pmsgport):pwindow;
var
  temp : pwindow;
begin
  temp:=openwindowtaglist(pnewwin,pt);
  if temp<>nil then temp^.userport:=pmport;
  if temp<>nil then if modifyidcmp(temp,tidcmp) then;
  openwindowtaglistnicely:=temp;
end;

procedure freebitmap(pbm : pbitmap;w,h:word);
var
  loop : word;
begin
  for loop:= 0 to 7 do
    if pbm^.planes[loop]<>nil then
      freeraster(pbm^.planes[loop],w,h);
  freemem(pbm,sizeof(tbitmap));
end;

Begin
  MainWindowMenu:=Nil;
  PrefsMenu:=Nil;
  EditImageMenu:=Nil;
  DisplayImagemenu:=Nil;
  MainCodeMenu:=Nil;
  LibMenu:=Nil;
  WinListMenu:=Nil;
  GadgetMenu:=Nil;
  WinSizesMenu:=Nil;
  WinTagsMenu:=Nil;
  WinIDCMPMenu:=Nil;
  ScreenReqMenu:=Nil;
  WinCodeMenu:=Nil;
  GlistMenu:=Nil;
  EditWinMenu:=Nil;
  MagnifyMenu:=Nil;
  LocaleMenu:=Nil;
  ScreenEditMenu:=Nil;
End.
