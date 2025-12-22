External;

{
   Crt.p für PCQ-Pascal, um nützliche "Konsolen"-Funktionen und Prozeduren
   auch ohne einen Konsolenparameter nutzen zu können;
   Crt.p for PCQ-Pascal to use console functions and procedures without an
   console parameter.
}

{$I "include:exec/exec.i"}
{$I "include:dos/dos.i"}
{$I "include:dos/dosextens.i"}
{$I "include:intuition/intuition.i"}
{$I "include:Devices/ConUnit.i"}
{$I "include:Utils/StringLib.i"}

const
   CSI = chr($9b);
   
   CD_CURRX =  1;
   CD_CURRY =  2;
   CD_MAXX  =  3;
   CD_MAXY  =  4;
   
   TEXT_BACKGROUND = -1;
   
{ -- Interne Crt-Funktionen/Prozeduren; internals -- }

function OpenInfo : InfoDataPtr;
var
   port     :  MsgPortPtr;
   info     :  InfoDataPtr;
   bptr, d4, d5, d6, d7 :  integer;
begin
   info  := InfoDataPtr(AllocVec(SizeOf(InfoData), MEMF_PUBLIC));
   
   if info <> nil then begin
      port  := GetConsoleTask;
      bptr  := integer(info) shr 2;
      
      if port <> nil then begin
         if DoPkt(port, ACTION_DISK_INFO, bptr, d4, d5, d6, d7) <> DOSFALSE then info := InfoDataPtr(bptr shl 2)
         else port := nil;
      end;
      
      if port = nil then begin   
         FreeVec(info);
         info := nil;
      end;
   end;

   OpenInfo := info;
end;

procedure CloseInfo(var info : InfoDataPtr);
begin
   if info <> nil then begin
      FreeVec(info);
      info := nil;
   end;
end;

function ConData(modus : byte) : integer;
var
   info  :  InfoDataPtr;
   unit  :  ConUnitPtr;
   pos   :  integer;
begin
   pos   := 1;
   info  := OpenInfo;
   
   if info <> nil then begin
      unit  := ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit);

      case modus of
         CD_CURRX :  pos   := unit^.cu_XCP;
         CD_CURRY :  pos   := unit^.cu_YCP;
         CD_MAXX  :  pos   := unit^.cu_XMax;
         CD_MAXY  :  pos   := unit^.cu_YMax;
      end;
      
      CloseInfo(info);
   end;
   
   ConData := pos + 1;
end;

{ -- öffentliche Funktionen und Prozeduren; public functions and procedures -- }

{ Cursorpositionen; cursor positions }

function WhereX : integer;
begin
   WhereX := ConData(CD_CURRX);
end;

function WhereY : integer;
begin
   WhereY := ConData(CD_CURRY);
end;

function MaxX : integer;
begin
   MaxX := ConData(CD_MAXX);
end;

function MaxY : integer;
begin
   MaxY := ConData(CD_MAXY);
end;

{ Cursorpositionierungen; cursor positioning }

procedure GotoXY(x, y : integer);
var
   mx, my : integer;
begin
   mx := MaxX;
   my := MaxY;
   
   if x < 1 then x := WhereX
   else if x > mx then x := mx;
   
   if y < 1 then y := WhereY
   else if y > my then y := my;
   
   Write(CSI, y, ";", x, "H");
end;

procedure GotoX(x : integer);
begin
   GotoXY(x, 0);
end;

procedure GotoY(y : integer);
begin
   GotoXY(0, y);
end;

procedure GoUp(n : integer);
begin
   if (n > 1) and (n < WhereY) then Write(CSI, n, "A");
end;

procedure GoDown(n : integer);
begin
   if (n > 0) and (n <= (MaxY - WhereY)) then Write(CSI, n, "B");
end;

procedure GoLeft(n : integer);
begin
   if (n > 0) and (n < WhereX) then Write(CSI, n, "D");
end;

procedure GoRight(n : integer);
begin
   if (n > 0) and (n <= (MaxX - WhereX)) then Write(CSI, n, "C");
end;

{ Cursordarstellungen; cursor display }

procedure CursorOff;
begin
   Write(CSI,"0 p");
end;

procedure CursorOn;
begin
   Write(CSI,"1 p");
end;

{ Spezielle Consolen-Aktionen; special console procedures }

procedure Bell;
begin
   Write(Chr($07));
end;

procedure ClrScr;
begin
   Write(Chr($0c));
end;

procedure ConReset;
begin
   Write("\ec");
end;

{ Tastatureingaben; keyboard inputs }

function Break : boolean;
begin
   if (SetSignal(0, 0) and SIGBREAKF_CTRL_C) = SIGBREAKF_CTRL_C then
      Break := true
   else
      Break := false;
end;

function ReadKey : char;
var
   info  :  InfoDataPtr;
   win   :  WindowPtr;
   imsg  :  IntuiMessagePtr;
   msg   :  MessagePtr;
   key   :  char;
   idcmp, vanil   :  integer;
   dummy : Boolean;
begin
   key   := char(0);
   info  := OpenInfo;
   
   if info <> nil then begin
      win   := WindowPtr(ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit)^.cu_Window);
      idcmp := win^.IDCMPFlags;
      vanil := IDCMP_VANILLAKEY or IDCMP_RAWKEY;
      
      dummy := ModifyIDCMP(win, (idcmp or vanil));
      
      repeat
         msg   := WaitPort(win^.UserPort);
         imsg  := IntuiMessagePtr(GetMsg(win^.UserPort));
         
         if (imsg^.Class = IDCMP_VANILLAKEY) or (imsg^.Class = IDCMP_RAWKEY) then key := char(imsg^.Code);
         
         ReplyMsg(MessagePtr(imsg));
      until key <> char(0);
      
      repeat
         msg   := GetMsg(win^.UserPort);
         
         if msg <> nil then ReplyMsg(msg);
      until msg = nil;
      
      dummy := ModifyIDCMP(win, idcmp);
      
      CloseInfo(info);
   end;
   
   ReadKey := key;
end;

{ Farben; colors }

function GetTextColor : byte;
var
   info  :  InfoDataPtr;
   pen   :  byte;
begin
   pen   := 1;
   info  := OpenInfo;
   
   if info <> nil then begin
      pen   := ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit)^.cu_FgPen;
      
      CloseInfo(info);
   end;
   
   GetTextColor   := pen;
end;

function GetTextBackground : byte;
var
   info  :  InfoDataPtr;
   pen   :  byte;
begin
   pen   := 1;
   info  := OpenInfo;
   
   if info <> nil then begin
      pen   := ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit)^.cu_BgPen;
      
      CloseInfo(info);
   end;
   
   GetTextBackground := pen;
end;

procedure TextColor(fgpen : byte);
begin
   Write(CSI, '3', fgpen, 'm');
end;

procedure TextBackground(bgpen : byte);
begin
   Write(CSI, '4', bgpen, 'm');
end;

procedure ConBackground(bgpen : byte);
begin
   if bgpen = TEXT_BACKGROUND then bgpen := GetTextBackground;
   
   Write(CSI, '4', bgpen, ';>', bgpen, 'm');
end;

{ Textdarstellungen; text display }

procedure TextReset;
begin
   Write(CSI, "0;39;49m");
end;

procedure TextStyle(style : byte);
begin
   Write(CSI, style, "m");
end;

procedure TextMode(style, fgpen, bgpen : byte);
begin
   TextReset;
   Write(CSI, style, ";3", fgpen, ";4", bgpen, "m");
end;

{ Text-Zentrierung; text line centering }

procedure CenterText(txt : string);
begin
   GotoX((MaxX - StrLen(txt))/2+1);
   WriteLn(txt);
end;

{ Text-Grafiken; text graphics }

procedure TextLine(x1, y1, x2, y2 : Integer; c : Char);
var
   i, j, m, n, d, x, y, dy :  integer;
   s, f  :  real;
   
   procedure Tausch(var a, b : integer);
   begin
      i := a;
      a := b;
      b := i;
   end;
   
   procedure d_ermitteln;
   begin
      s  := s + f;
      n  := trunc(s+0.5);
      d  := n - m;
      m  := n;
   end;
begin
   
   {  Grundsätzlich von links nach rechs zeichnen;
      always draw from left to right }
   if x2 < x1 then begin
      Tausch(x1, x2);
      Tausch(y1, y2);
   end;
   
   GotoXY(x1, y1);
   
   {  Die vertikale Zeichenrichtung und die Abmessung in der Höhe ermitteln;
      determine the vertical drawing direction and height }
   if y1 < y2 then begin
      y  := (y2-y1)+1;
      dy := 1;
   end else begin
      y  := (y1-y2)+1;
      dy := -1;
   end;
   
   {  Die Breite in Zeichen ermitteln;
      determine the count of chars in width }
   x  := (x2-x1)+1;
   
   m  := 0;
   s  := 0;
   
   if x >= y then begin
      {  Die Diagonale bedeckt eine Fläche, die breiter ist, als sie hoch ist;
         The diagonal is smaller in height than in width }
      f  := x/y;
      
      for i := 1 to y do begin
         d_ermitteln;
         
         for j := 1 to d do Write(c);
         
         if i < y then GotoY(WhereY+dy);
      end;
   end else begin
      {  Die Diagonale bedeckt eine Fläche, die schmaler ist, als sie hoch ist;
         The diagonal is smaller in width than in height }
      f  := y/x;
      
      for i := 1 to x do begin
         d_ermitteln;
         
         for j := 1 to d-1 do begin
            Write(c);
            GotoXY(WhereX-1, WhereY+dy);
         end;
         
         Write(c);
         
         if i < x then GotoY(WhereY+dy);
      end;
   end;
end;

procedure TextRectFill(x, y, w, h : Integer; c : Char);
var
   ox, oy, mx, my, i, j :  Integer;
begin
   ox := WhereX;
   oy := WhereY;
   
   GotoXY(x, y);
   
   x  := WhereX;
   y  := WhereY;
   
   if w < 0 then w := -w;
   if h < 0 then h := -h;
   
   mx := MaxX;
   my := MaxY;
   
   if (x+w) > mx then w := mx-x;
   if (y+h) > my then h := my-y;
   
   for i := 1 to h do begin
      for j := 1 to w do Write(c);
      GotoXY(x, WhereY+1);
   end;
   
   GotoXY(ox, oy);
end;
