PROGRAM SortDemo;

{ Graphical demonstration of sorting algorithms (W. N÷ker, 02/96) }
{ based on "Sortieren" of Purity #48 }

{
    Translated to PCQ from Kick(Maxon) Pascal.
    Updated the source to 2.0+.
    Now uses GadTools for menus.
    Added CloseWindowSafely.
    Cleaned up the menuhandling.
    Added LockWinSize and RestoreWin, now the
    window will be locked on showtime.

    The German text was translated to English
    by Andreas Neumann, thanks Andreas.
    Jun 03 1998.
    nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Libraries.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Graphics/DisplayInfo.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:PCQUtils/IntuiUtils.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:PCQUtils/CStrings.i"}
{$I "Include:Utils/Random.i"}

CONST version : string ="$VER: SortDemo 1.3  (02-Jun-98)";

      nmax=2000;
      Pi = 3.1415927;

      MinWinX = 80;
      MinWiny = 80;

      w         : WindowPtr = Nil;
      s         : ScreenPtr = Nil;
      MenuStrip : MenuPtr   = Nil;
      vi        : Address   = Nil;

      modenames : Array[0..7] of string = (
                                "Heapsort",
                                "Shellsort",
                                "Pick out",
                                "Insert",
                                "Shakersort",
                                "Bubblesort",
                                "Quicksort",
                                "Mergesort");

      nm : Array[0..20] of NewMenu = (
         (NM_TITLE, "Demo",          NIL, 0, 0,NIL),
         (NM_ITEM,  "Start",         "S", 0, 0,NIL),
         (NM_ITEM,  "Stop",          "H", 0, 0,NIL),
         (NM_ITEM,  "Quit",          "Q", 0, 0,NIL),
         (NM_TITLE, "Algorithm",     NIL, 0, 0,NIL),
         (NM_ITEM,  "HeapSort",      "1", CHECKIT+CHECKED+MENUTOGGLE, 254,NIL),
         (NM_ITEM,  "ShellSort",     "2", CHECKIT+MENUTOGGLE, 253,NIL),
         (NM_ITEM,  "Pick out",      "3", CHECKIT+MENUTOGGLE, 251,NIL),
         (NM_ITEM,  "Insert",        "4", CHECKIT+MENUTOGGLE, 247,NIL),
         (NM_ITEM,  "ShakerSort",    "5", CHECKIT+MENUTOGGLE, 239,NIL),
         (NM_ITEM,  "BubbleSort",    "6", CHECKIT+MENUTOGGLE, 223,NIL),
         (NM_ITEM,  "QuickSort",     "7", CHECKIT+MENUTOGGLE, 191,NIL),
         (NM_ITEM,  "MergeSort",     "8", CHECKIT+MENUTOGGLE, 127,NIL),
         (NM_TITLE, "Preferences",   NIL, 0, 0,NIL),
         (NM_ITEM,  "Data",          NIL, 0, 0,NIL),
         (NM_SUB,   "Random",        "R", CHECKIT+CHECKED+MENUTOGGLE, 2,NIL),
         (NM_SUB,   "Malicious",     "M", CHECKIT+MENUTOGGLE, 1,NIL),
         (NM_ITEM,  "Diagram",       NIL, 0, 0,NIL),
         (NM_SUB,   "Needles",       "N", CHECKIT+CHECKED+MENUTOGGLE, 2,NIL),
         (NM_SUB,   "Dots",          "D", CHECKIT+MENUTOGGLE, 1,NIL),
         (NM_END,   NIL,NIL,0,0,NIL));




VAR sort: ARRAY[1..nmax] OF Real;
    sort2: ARRAY[1..nmax] OF Real;  { for dumb Mergesort %-( }
    num,range,modus: Integer;
    rndom,needles: Boolean;
    Rast : RastPortPtr;
    QuitStopDie  : Boolean;

    IMessage : IntuiMessage;
    Msg      : MessagePtr;

Procedure CleanUp(str : string; err : Integer);
begin
    if MenuStrip <> nil then begin
       ClearMenuStrip(w);
       FreeMenus(MenuStrip);
    end;
    if vi <> nil then FreeVisualInfo(vi);
    if w <> nil then CloseWindowSafely(w);
    if GadToolsBase <> nil then CloseLibrary(GadToolsBase);
    Exit(err);
end;

Procedure RestoreWin;
var
   dummy : Boolean;
begin
   dummy := WindowLimits(w,MinWinX,MinWinY,-1,-1);
end;

Procedure LockWinSize(x,y,x2,y2 : Integer);
var
   dummy : Boolean;
begin
   dummy := WindowLimits(w,x,y,x2,y2);
end;

FUNCTION cancel: Boolean;
{ checked while sorting }
VAR m,i,s: Short;
    result : boolean;
    IM : IntuiMessagePtr;
BEGIN
  result := False;
  IM := IntuiMessagePtr(GetMsg(w^.UserPort));
  IF IM<>Nil THEN BEGIN
    IF IM^.Class=IDCMP_CLOSEWINDOW THEN
      result := True;   { Close-Gadget }
    IF IM^.Class=IDCMP_MENUPICK THEN BEGIN
      m := IM^.Code AND $1F;
      i := (IM^.Code SHR 5) AND $3F;
      s := (IM^.Code SHR 11) AND $1F;
      IF (m=0) AND (i=1) THEN  result := True;  { Menu item "Stop" }
    END;
    ReplyMsg(MessagePtr(Msg));
  END;
  cancel := result;
END;


PROCEDURE showstack(size: Integer);
{ little diagram showing the depth of Quicksort's recursion :-) }
BEGIN
  SetAPen(Rast,2); IF size>0 THEN RectFill(Rast,0,0,3,size-1);
  SetAPen(Rast,0); RectFill(Rast,0,size,3,size);
END;


PROCEDURE setpixel(i: Integer);
BEGIN
  SetAPen(Rast,1);
  IF needles THEN BEGIN
    Move(Rast,i,range); Draw(Rast,i,Round((1-sort[i])*range));
  END ELSE
    IF WritePixel(Rast,i,Round((1-sort[i])*range))=0 THEN;
END;

PROCEDURE clearpixel(i: Integer);
BEGIN
  SetAPen(Rast,0);
  IF needles THEN BEGIN
    Move(Rast,i,range); Draw(Rast,i,Round((1-sort[i])*range));
  END ELSE
    IF WritePixel(Rast,i,Round((1-sort[i])*range))=0 THEN;
END;

procedure Exchange(var first,second : real);
var
  temp : real;
begin
  temp := first;
  first := second;
  second := temp;
end;

PROCEDURE swap(i,j: integer);
BEGIN
  clearpixel(i); clearpixel(j);
  Exchange(sort[i],sort[j]);
  setpixel(i); setpixel(j);
END;

FUNCTION descending(i,j: Integer): Boolean;
BEGIN
  descending := sort[i]>sort[j];
END;

PROCEDURE settitles(time: Integer);
VAR
  sbuff : array[0..79] of char;
  wbuff : array[0..79] of char;
  scrtitle : string;
  wintitle : string;
BEGIN
  scrtitle := @sbuff;
  wintitle := @wbuff;
  IF time=0 THEN begin
    sprintf(wintitle,"%s running ...",modenames[modus]);
  end ELSE begin
    IF time<0 THEN
    sprintf(wintitle,"<- %ld Data ->",num)
    ELSE
    sprintf(wintitle,"%ld Seconds",time);
  end;
  sprintf(scrtitle,"%s - %s",@version[6],modenames[modus]);
  SetWindowTitles(w,wintitle,scrtitle);
END;

PROCEDURE refresh;
{ react on new size of window/init data }
VAR i: Integer;
BEGIN
  num := w^.GZZWidth; IF num>nmax THEN num := nmax;
  range := w^.GZZHeight;
  settitles(-1);
  SetRast(Rast,0);    { clear screen }
  FOR i := 1 TO num DO BEGIN
    IF rndom THEN sort[i] := RealRandom  { produces 0..1 }
      ELSE sort[i] := (num-i)/num;
    setpixel(i);
  END;
END;

{ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#* }
{ *#*#*#*#*#*#*#*#*#*#*# The sorting algorithms! #*#*#*#*#*#*#*#*#*#*#*#* }
{ *#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#* }

PROCEDURE bubblesort;
{ like the head of a beer, reaaal slow and easy-going }
VAR i,j,max: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  max := num;
  REPEAT
    j := 1;
    FOR i := 1 TO max-1 DO
      IF descending(i,i+1) THEN BEGIN
        swap(i,i+1); j := i;
      END;
    max := j;
  UNTIL (max=1) OR cancel;
  RestoreWin;
END;

PROCEDURE shakersort;
{ interesting variant, but bubblesort still remains hopelessness }
{ (because it only compares and swaps immediate adjacent units)  }
VAR i,j,min,max: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  min := 1;
  max := num;
  REPEAT
    j := min;
    FOR i := min TO max-1 DO
      IF descending(i,i+1) THEN BEGIN
        swap(i,i+1); j := i;
      END;
    max := j;
    j := max;
    FOR i := max DOWNTO min+1 DO
      IF descending(i-1,i) THEN BEGIN
        swap(i,i-1); j := i;
      END;
    min := j;
  UNTIL (max=min) OR cancel;
  RestoreWin;
END;

PROCEDURE e_sort;
{ Insert: a pretty human strategy }
VAR i,j: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  FOR i := 2 TO num DO BEGIN
    j := i;
    WHILE j>1 DO
      IF descending(j-1,j) THEN BEGIN
        swap(j-1,j); Dec(j);
      END ELSE
        j := 1;
    IF cancel THEN Return;
  END;
  RestoreWin;
END;

PROCEDURE a_sort;
{ Pick out: Preparation is one half of a life }
{ Take a look at the ridiculous low percentage of successful comparisions:  }
{ Although there are only n swaps, there are n^2/2 comparisions!            }
{ Both is a record, one in a good sense, the other one in a bad sense.      }

VAR i,j,minpos: Integer;
    min: Real;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  FOR i := 1 TO num-1 DO BEGIN
    minpos := i; min := sort[i];
    FOR j := i+1 TO num DO
      IF descending(minpos,j) THEN
        minpos := j;
    IF minpos<>i THEN swap(i,minpos);
    IF cancel THEN Return;
  END;
  RestoreWin;
END;

PROCEDURE shellsort;
{ brilliant extension of E-Sort, stunning improvement of efficience }
VAR i,j,gap: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  gap := num DIV 2;
  REPEAT
    FOR i := 1+gap TO num DO BEGIN
      j := i;
      WHILE j>gap DO
        IF descending(j-gap,j) THEN BEGIN
          swap(j,j-gap); j := j-gap;
        END ELSE
          j := 1;
      IF cancel THEN Return;
    END;
    gap := gap DIV 2;
  UNTIL gap=0;
  RestoreWin;
END;

PROCEDURE seepaway(i,max: Integer);
{ belongs to heapsort }
VAR j: Integer;
BEGIN
  j := 2*i;
  WHILE j<=max DO BEGIN
    IF j<max THEN IF descending(j+1,j) THEN
      Inc(j);
    IF descending(j,i) THEN BEGIN
      swap(j,i);
      i := j; j := 2*i;
    END ELSE
      j := max+1; { cancels }
  END;
END;

PROCEDURE heapsort;
{ this genius rules over the chaos: it's the best algorithm, I know about    }
{ The only disadvantage compared with shellsort: it's not easy to understand }
{ and impossible to know it by heart. }
VAR i,j: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  i := num DIV 2 + 1;
  j := num;
  WHILE i>1 DO BEGIN
    Dec(i); seepaway(i,j);
  END;
  WHILE j>1 DO BEGIN
    swap(i,j);
    Dec(j); seepaway(i,j);
  END;
  RestoreWin;
END;

PROCEDURE quicksort;
{ "divide and rule": a classic, but recursive  >>-( }
{ In this demonstration it is faster than heapsort, but does considerable }
{ more unsuccessful comparisions. }
VAR stack: ARRAY[1..100] OF RECORD li,re: Integer; END;
    sp,l,r,m,i,j: Integer;
    ref: Real;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  sp := 1; stack[1].li := 1; stack[1].re := num;
  REPEAT
    l := stack[sp].li; r := stack[sp].re; Dec(sp);
    showstack(sp);
    m := (l+r) DIV 2;
    i := l; j := r;
    REPEAT
      WHILE descending(m,i) DO Inc(i);
      WHILE descending(j,m) DO Dec(j);
      IF j>i THEN swap(i,j);
      IF m=i THEN m := j ELSE IF m=j THEN m := i; { ahem ... }
      { This "Following" of the reference data is only required because  }
      { I stubborn call the comparision function, and this one only gets }
      { indices on the values which have to be compared. }
    UNTIL i>=j;
    IF i>l THEN BEGIN
      Inc(sp); stack[sp].li := l; stack[sp].re := i; END;
    IF i+1<r THEN BEGIN
      Inc(sp); stack[sp].li := i+1; stack[sp].re := r; END;
  UNTIL (sp=0) OR cancel;
  RestoreWin;
END;

PROCEDURE mergesort;
{ *the* algorithm for lists with pointers on it, for arrays rather }
{ inacceptable. The non.recursive implementation came out pretty more }
{ complicated than the one for quicksort, as quicksort first does }
{ something and then recurses; with mergesort it is the other way round. }
VAR stack: ARRAY[1..100] OF RECORD li,re,mi: Integer; END;
    sp,l,r,i,j,k,m: Integer;
BEGIN
  LockWinSize(w^.Width,w^.Height,w^.Width,w^.Height);
  sp := 1; stack[1].li := 1; stack[1].re := num; stack[1].mi := 0;
  REPEAT
    l := stack[sp].li; r := stack[sp].re; m := stack[sp].mi; Dec(sp);
    showstack(sp);
    IF m>0 THEN BEGIN { put two halfs together }
      { Unfortunately it is only possible in an efficient way by using }
      { extra memory; mergesort really is something for lists with }
      { pointers originally ... }
      FOR i := m DOWNTO l do sort2[i] := sort[i];  i := l;
      FOR j := m+1 TO r DO sort2[r+m+1-j] := sort[j];  j := r;
      FOR k := l TO r DO BEGIN
        clearpixel(k);
        IF sort2[i]<sort2[j] THEN BEGIN
          sort[k] := sort2[i]; Inc(i);
        END ELSE BEGIN
          sort[k] := sort2[j]; Dec(j);
        END;
        setpixel(k);
      END;
    END ELSE IF l<r THEN BEGIN
      { create two halfs and the order to put them together }
      m := (l+r) DIV 2;
      Inc(sp); stack[sp].li := l; stack[sp].mi := m; stack[sp].re := r;
      Inc(sp); stack[sp].li := m+1; stack[sp].mi := 0; stack[sp].re := r;
      Inc(sp); stack[sp].li := l; stack[sp].mi := 0; stack[sp].re := m;
    END;
  UNTIL (sp=0) OR cancel;
  RestoreWin;
END;

Procedure OpenEverything;
begin
    GadToolsBase := OpenLibrary("gadtools.library",37);
    if GadToolsBase = nil then CleanUp("Can't open gadtools,library",20);

    s := LockPubScreen(nil);
    if s = nil then CleanUp("Could not lock pubscreen",10);

    vi := GetVisualInfo(s, TAG_END);
    if vi = nil then CleanUp("No visual info",10);

    w := OpenWindowTags(NIL,
                 WA_IDCMP,         IDCMP_CLOSEWINDOW or IDCMP_MENUPICK or IDCMP_NEWSIZE,
                 WA_Left,          0,
                 WA_Top,           s^.BarHeight+1,
                 WA_Width,         224,
                 WA_Height,        s^.Height-(s^.BarHeight-1),
                 WA_MinWidth,      MinWinX,
                 WA_MinHeight,     MinWinY,
                 WA_MaxWidth,      -1,
                 WA_MaxHeight,     -1,
                 WA_DepthGadget,   true,
                 WA_DragBar,       true,
                 WA_CloseGadget,   true,
                 WA_SizeGadget,    true,
                 WA_Activate,      true,
                 WA_SizeBRight,    true,
                 WA_GimmeZeroZero, true,
                 WA_PubScreen,     s,
                 TAG_END);
    IF w=NIL THEN CleanUp("Could not open window",20);

    Rast := w^.RPort;

    if OSVersion >= 39 then MenuStrip := CreateMenus(adr(nm),GTMN_FrontPen,1,TAG_END)
    else MenuStrip := CreateMenus(adr(nm),TAG_END);

    if MenuStrip = nil then CleanUp("Could not open Menus",10);
    if LayoutMenus(MenuStrip,vi,TAG_END)=false then
        CleanUp("Could not layout Menus",10);

    if SetMenuStrip(w, MenuStrip) = false then
        CleanUp("Could not set the Menus",10);

end;

PROCEDURE ProcessIDCMP;
VAR
    IMessage    : IntuiMessage;
    IPtr    : IntuiMessagePtr;

    Procedure ProcessMenu;
    var
    MenuNumber  : Short;
    ItemNumber  : Short;
    SubItemNumber   : Short;
    t0,t1,l         : Integer;

    begin
    if IMessage.Code = MENUNULL then
        return;

    MenuNumber := MenuNum(IMessage.Code);
    ItemNumber := ItemNum(IMessage.Code);
    SubItemNumber := SubNum(IMessage.Code);

    case MenuNumber of
      0 : begin
          case ItemNumber of
             0 : begin
                   refresh;
                   settitles(0);
                   CurrentTime(t0,l);
                   CASE modus OF
                     0: heapsort;
                     1: shellsort;
                     2: a_sort;
                     3: e_sort;
                     4: shakersort;
                     5: bubblesort;
                     6: quicksort;
                     7: mergesort;
                   END;
                   CurrentTime(t1,l);
                   settitles(t1-t0);
                 end;
             2 : QuitStopDie := True;
          end;
          end;
      1 : begin
          case ItemNumber of
              0..7 : modus := ItemNumber;
          end;
          settitles(-1);
          end;
      2 : begin
          case ItemNumber of
             0 : begin
                 case SubItemNumber of
                    0 : if not rndom then rndom := true;
                    1 : if rndom then rndom := false;
                 end;
                 end;
             1 : begin
                 case SubItemNumber of
                    0 : if not needles then needles := true;
                    1 : if needles then needles := false;
                 end;
                 end;
          end;
          end;
    end;
    end;

begin
    IPtr := IntuiMessagePtr(Msg);
    IMessage := IPtr^;
    ReplyMsg(Msg);

    case IMessage.Class of
      IDCMP_MENUPICK    : ProcessMenu;
      IDCMP_NEWSIZE     : refresh;
      IDCMP_CLOSEWINDOW : QuitStopDie := True;
    end;
end;



begin
   OpenEverything;
   QuitStopDie := False;
   modus := 0;
   needles := true;
   rndom := true;
   refresh;
   repeat
   Msg := WaitPort(w^.UserPort);
   Msg := GetMsg(w^.UserPort);
       ProcessIDCMP;
   until QuitStopDie;
   CleanUp(nil,0);
end.



