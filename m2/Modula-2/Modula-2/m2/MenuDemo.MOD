(********************************************************************************

Name         : MenuDemo.MOD
Version      : 1.0
Purpose      : Demo For Windows With Menus
Author       : ms
Modified     : 27.3.86  14:20  ms

********************************************************************************)

MODULE MenuDemo;

FROM Terminal   IMPORT WriteString, WriteLn;
FROM SYSTEM     IMPORT ADDRESS, ADR, BYTE, LONG, TSIZE;
FROM System     IMPORT Allocate;
FROM AMIGADos   IMPORT Delay;
FROM AMIGABase  IMPORT ExecBase, ExecOpenLib, LibCall, Regs;

CONST CLOSEWINDOW   =   512D;
      MENUPICK      =   256D;
      JAM2          =      1;
      MENUENABLED   =      1D;
      ITEMTEXT      =      2;
      HIGHCOMP      =     64;
      ITEMENABLED   =     16;
      WINDOWCLOSE   =     8D;
      ACTIVATE      =  4096D;
      WINDOWDRAG    =     2D;
      WINDOWDEPTH   =     4D;
      WINDOWSIZING  =     1D;
      BORDERLESS    =  2048D;
      NOCAREREFRESH =131072D;
      CUSTOMSCREEN  =    0FH;
      WBSCREEN      =    01H; 
      HIRES         =  8000H;
      INTERLACE     =    04H;
      RPORTOFFSET   =     25;
      USERPORTOFS   =     43;
      interMenuWidth = 15;
TYPE StringPtr = POINTER TO ARRAY [0..29999] OF CHAR;
     NewWindow = RECORD
                   leftEdge,
                   topEdge,
                   width,
                   height: CARDINAL;
                   detailPen,
                   blockPen: BYTE;
                   IDCMPFlags,
                   flags: LONGINT;
                   firstGadget,
                   checkMark: LONGINT;
                   title: StringPtr;
                   screen,
                   bitMap: ADDRESS;
                   minWidth,
                   minHeight,
                   maxWidth,
                   maxHeight: CARDINAL;
                   type: CARDINAL
                 END;

     MsgPort   = RECORD
                   mpNode: ARRAY [0..13] OF BYTE;    (* TSIZE(Node) = 14  *)
                   mpFlags,
                   mpSigBit: BYTE;
                   mpSigTask: ADDRESS;
                   mpMsgList: ARRAY [0..13] OF BYTE  (* TSIZE(List) = 14 *)
                 END;

    MenuItemPtr= POINTER TO MenuItem;
     MenuItem  = RECORD
                   nextItem: MenuItemPtr;
                   leftEdge, topEdge, width, height: INTEGER;
                   flags: CARDINAL;
                   mutex: LONGINT;
                   itemFill, selectFill: ADDRESS;
                   command: BYTE;
                   subItem: MenuItemPtr;
                   nextSelect: CARDINAL
                 END;
     MenuPtr   = POINTER TO Menu;
     Menu      = RECORD
                   nextMenu: MenuPtr;
                   leftEdge, topEdge, width, height: INTEGER;
                   flags: CARDINAL;
                   name: StringPtr;
                   firstItem: MenuItemPtr;
                   jazX, jazzY, beatX, beatY: INTEGER
                 END;
     IntuiTextPtr = POINTER TO IntuiText;
     IntuiText = RECORD
                   frontPen, backPen,
                   drawMode: BYTE;
                   leftEdge, topEdge: INTEGER;
                   iTextFont,
                   iText,
                   nextText: ADDRESS
                 END;
(*   dummy types for window data structure *)

     Window    = ARRAY [0..63] OF CARDINAL;

     WindowPtr = POINTER TO Window;

PROCEDURE OpenLibrary(st: ARRAY OF CHAR): LONGINT;
VAR r: Regs;
BEGIN
  r.a[1]:=ADR(st);
  r.d[0]:=0D;
  LibCall(ExecBase(), ExecOpenLib(), r);
  RETURN r.d[0]
END OpenLibrary;

VAR nw: NewWindow;
    w: WindowPtr;
    up: POINTER TO MsgPort;
    len: LONGINT;
    i, intuibase, gfxbase: LONGINT;
    st, wt: ARRAY [0..31] OF CHAR;
    t: ARRAY [0..99] OF CHAR;
    menuHead: MenuPtr;

PROCEDURE AllocString(VAR p: ADDRESS; st: ARRAY OF CHAR);
VAR i, j: CARDINAL;
    s: StringPtr;
BEGIN
  WHILE (i<=HIGH(st) & (st[i]#0C) DO INC(i) END;
  Allocate(p, i);
  IF p#NIL THEN
    s:=StringPtr(p);
    FOR j:=0 TO i-1 DO s^[i]:=st[i] END;
    s^[i]:=0C;
  END
END AllocString;
   
PROCEDURE OpenWindow(VAR nw: NewWindow): WindowPtr;
VAR r: Regs;
BEGIN
  r.a[0]:=ADR(nw);
  LibCall(intuibase, -204D, r);
  RETURN WindowPtr(r.d[0]);
END OpenWindow;

PROCEDURE CloseWindow(w: WindowPtr);
VAR r: Regs;
BEGIN
  r.a[0]:=LONGINT(w);
  LibCall(intuibase, -72D, r);
END CloseWindow;

PROCEDURE Move(rP: ADDRESS; x, y: LONGINT);
VAR r: Regs;
BEGIN
  r.a[1]:=rP;
  r.d[0]:=x;
  r.d[1]:=y;
  LibCall(gfxbase, -240D, r);
END Move;

PROCEDURE Wait(signalSet: LONGINT);
VAR r: Regs;
BEGIN
  r.d[0]:=signalSet;
  LibCall(ExecBase(), -318D, r);
END Wait;

PROCEDURE Text(rP: ADDRESS; VAR st: ARRAY OF CHAR; len: LONGINT);
VAR r: Regs;
BEGIN
  r.a[1]:=rP;
  r.a[0]:=ADR(st);
  r.d[0]:=len;
  LibCall(gfxbase, -60D, r);
END Text;

PROCEDURE NewIText(VAR text: ARRAY OF CHAR; left, top: INTEGER): IntuiTextPtr;
VAR newText: IntuiTextPtr;
BEGIN
  text[HIGH(text)]:=0C;
  Allocate(newText, TSIZE(IntuiText));
  WITH newText^ DO
    iText:=ADR(text);
    frontPen:=BYTE(0); backPen:=BYTE(1);
    drawMode:=BYTE(JAM2);
    leftEdge:=left; topEdge:=top;
    iTextFont:=NIL;
    nextText:=NIL
  END;
  RETURN newText
END NewIText;

PROCEDURE NewMenu(menuName: StringPtr;
                  menuWidth, menuHeight: INTEGER): MenuPtr;
VAR menu: MenuPtr;
BEGIN
  menuName[HIGH(menuName)]:=0C;
  Allocate(menu, TSIZE(Menu));
  IF menu#NIL THEN
    WITH menu^ DO
      nextMenu:=NIL;
      leftEdge:=0; topEdge:=0;
      width:=menuWidth; height:=menuHeight;
      flags:=MENUENABLED;
      name:=menuName;
      firstItem:=NIL
    END
  END;
  RETURN menu
END NewMenu;

PROCEDURE AddMenu(VAR menus: MenuPtr; menuName: StringPtr;
                  menuWidth, menuHeight: INTEGER): MenuPtr;
VAR newmenu: MenuPtr;
BEGIN
  menuName[HIGH(menuName)]:=0C;
  newmenu:=NewMenu(menuName, menuWidth, menuHeight);
  newmenu^.leftEdge:=menus^.leftEdge+menus^.width+interMenuWidth;
  menus^.nextMenu:=newmenu;
  RETURN newmenu
END AddMenu;

PROCEDURE NewMenuItem(VAR name: ARRAY OF CHAR;
                      itemWidth, itemHeight: INTEGER): MenuItemPtr;
VAR newItem: MenuItemPtr;
    newText: IntuiTextPtr;
BEGIN
  name[HIGH(name)]:=0C;
  Allocate(newItem, TSIZE(MenuItem));
  newText:=NewIText(name, 0, 1);
  WITH newItem^ DO
    nextItem:=NIL;
    itemFill:=newText;
    leftEdge:=0; topEdge:=0;
    width:=itemWidth; height:=itemHeight;
    flags:=ITEMTEXT + ITEMENABLED + HIGHCOMP;
    mutex:=0;
    selectFill:=NIL;
    command:=BYTE(0);
    subItem:=NIL;
    nextSelect:=0;
  END;
  RETURN newItem
END NewMenuItem;

PROCEDURE AddNewMenuItem(VAR menu: MenuPtr; VAR name: ARRAY OF CHAR; 
                         itemWidth, itemHeight: INTEGER): MenuItemPtr;
VAR newItem: MenuItemPtr;
BEGIN
  name[HIGH(name)]:=0C;
  newItem:=NewMenuItem(name, itemWidth, itemHeight);
  menu^.firstItem:=newItem;
  RETURN newItem
END AddNewMenuItem;

PROCEDURE AddItem(VAR items: MenuItemPtr; VAR name: ARRAY OF CHAR): MenuItemPtr;
VAR newItem: MenuItemPtr;
BEGIN
  name[HIGH(name)]:=0C;
  newItem:=NewMenuItem(name, items^.width, items^.height);
  newItem^.topEdge:=items^.topEdge+items^.height;
  newItem^.leftEdge:=items^.leftEdge;
  items^.nextItem:=newItem;
  RETURN newItem
END AddItem;

PROCEDURE AddNewSubItem(VAR item: MenuItemPtr; VAR name: ARRAY OF CHAR;
                        itemWidth, itemHeight: INTEGER): MenuItemPtr;
VAR newItem: MenuItemPtr;
BEGIN
  name[HIGH(name)]:=0C;
  newItem:=NewMenuItem(name, itemWidth, itemHeight);
  item^.subItem:=newItem;
  newItem^.leftEdge:=item^.width;
  RETURN newItem;
END AddNewSubItem;

PROCEDURE SetMenuStrip(w: WindowPtr; m: MenuPtr);
VAR r: Regs;
BEGIN
  r.a[0]:=LONGINT(w);
  r.a[1]:=LONGINT(m);
  LibCall(intuibase, -264D, r)
END SetMenuStrip;

PROCEDURE InitMenus(VAR w: WindowPtr);
VAR currentMenu: MenuPtr;
    currentItem, subItem: MenuItemPtr;
BEGIN
  s1:="Modula 2";
  currentMenu    := NewMenu(s1 (*"Modula 2 "*), 100, 10);
  menuHead       := currentMenu;
  s2:="Compiler ";
     currentItem := AddNewMenuItem(currentMenu, s2 (*"Compiler "*), 100, 11);
  s3:="Window";
     currentItem := AddItem(currentItem, s3 (*"Window "*) );
  s4:="to Back";
        subItem  := AddNewSubItem(currentItem, s4 (*"to Back "*), 76, 11);
  s5:="to Front";
        subItem  := AddItem(subItem, s5 (*"to Front "*));
  s6:="Quit";
     currentItem := AddItem(currentItem, s6 (*"Quit "*));
  s7:="Settings";
  currentMenu    := AddMenu(currentMenu, s7 (*"Settings "*), 100, 10);
  s8:="Baud";
     currentItem := AddNewMenuItem(currentMenu, s8 (*"Baud "*), 100, 11);
  s9:="Length";
     currentItem := AddItem(currentItem, s9 (*"Length "*));

  SetMenuStrip(w, menuHead);
END InitMenus;
  
 
BEGIN
  st:='intuition.library';
  intuibase:=OpenLibrary(st);
  st:='graphics.library';
  gfxbase:=OpenLibrary(st);
  IF (intuibase=0D) OR (gfxbase=0D) THEN
    WriteString('Error: libraries not opened'); WriteLn
  ELSE
    wt:='A Window With Menus';
    WITH nw DO
      leftEdge:=20;
      topEdge:=20;
      width:=600;
      height:=150;
      detailPen:=BYTE(0);
      blockPen:=BYTE(1);
      IDCMPFlags:=CLOSEWINDOW (* + MENUPICK *);
      flags:=WINDOWCLOSE + ACTIVATE + WINDOWDRAG + WINDOWDEPTH
             + WINDOWSIZING + NOCAREREFRESH;
      firstGadget:=NIL;
      checkMark:=NIL;
      title:=ADR(wt);
      screen:=NIL;
      bitMap:=NIL;
      minWidth:=100;
      minHeight:=25;
      maxWidth:=640;
      maxHeight:=200;
      type:=WBSCREEN 
    END;
    w:=OpenWindow(nw);

    IF LONGINT(w)#0D THEN
      InitMenus(w);
      Move(LONG(w^[RPORTOFFSET], w^[RPORTOFFSET+1]), 10D, 20D);
      t:='Hello World'; len:=11D;
      Text(LONG(w^[RPORTOFFSET], w^[RPORTOFFSET+1]), t, len);

      up:=ADDRESS(LONG(w^[USERPORTOFS], w^[USERPORTOFS+1]));
      Wait(SHIFT(1D, CARDINAL(up^.mpSigBit)));
    ELSE
      WriteString('Error: OpenWindow not done '); WriteLn
    END;
    CloseWindow(w);
  END;
END MenuDemo.
