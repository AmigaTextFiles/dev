External;

{ Crt.p for PCQ-Pascal. Copyright © 1995 by Andreas Tetzl }
{ Version 1.0 (15.04.1995) }

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Graphics/RastPort.i"}
{$I "Include:Utils/StringLib.i"}

const    CSI = chr($9b);

PROCEDURE Locate(Zeile, Spalte : Byte);
Begin
 Write(CSI,Zeile,";",Spalte,"H");
end;

PROCEDURE ClrScr;
Begin
 Write(Chr($0c));
end;

PROCEDURE CursorOff;
Begin
 Write(CSI,"0 p");
end;

PROCEDURE CursorOn;
Begin
 Write(CSI,"1 p");
end;

PROCEDURE Bell;
Begin
 Write(Chr($07));
end;

PROCEDURE MoveCursorUp(n : Byte);
Begin
 Write(CSI,n,"A");
end;

PROCEDURE MoveCursorDown(n : Byte);
Begin
 Write(CSI,n,"B");
end;

PROCEDURE MoveCursorLeft(n : Byte);
Begin
 Write(CSI,n,"D");
end;

PROCEDURE MoveCursorRight(n : Byte);
Begin
 Write(CSI,n,"C");
end;

PROCEDURE ResetConsole;
Begin
 Write("\ec");
end;

PROCEDURE SetTextStyle(Style, fCol, bCol : Byte);
Begin
 Write(CSI,"0;31;40m");     { Zurücksetzen }
 Write(CSI,Style,";3",fCol,";4",bCol,"m");
end;

PROCEDURE GetConSize(VAR Zeilen : Integer; VAR Spalten : Integer);
VAR IB : Address;
    Win : WindowPtr;
    RP : RastPortPtr;

{ Ich habe das Ganze über die Intuition.library realisiert.
  Daraus ergibt sich, daß das Shell-Fenster, von dem ihr
  die Größe wissen wollt, das aktive Fenster des Screens
  sein muß. Wenn ein anderes Fenster aktiv ist, erhaltet
  ihr falsche Werte.
  Man kann die Zeilen/Spalten auch irgendwie über das
  Console.device herausfinden, aber das funktioniert bei
  mir irgendwie nicht. :-(
}

Begin
 IB:=OpenLibrary("intuition.library",33);
 Win:=IntuitionBasePtr(IB)^.ActiveWindow;
 CloseLibrary(IB);

 RP:=Win^.RPort;
 Zeilen:=(Win^.Height-Win^.BorderTop-Win^.BorderBottom) div RP^.TxHeight;
 Spalten:=(Win^.Width-Win^.BorderLeft-Win^.BorderRight) div RP^.TxWidth;
end;

PROCEDURE TxtLine(x1,y1,x2,y2 : Integer; c : Char);
VAR m : Real;
    x, y : Integer;
    Test1, Test2 : Integer;
    xold,yold : Integer;
    v : Integer;

PROCEDURE Swap(VAR v1, v2 : Integer);
BEGIN
 v:=v1;
 v1:=v2;
 v2:=v;
END;

BEGIN
 XOld:=x2;
 YOld:=y2;
 
 Test1:=x1-x2;
 Test2:=y1-y2;
 IF Test1<0 THEN Test1:=-Test1;
 IF Test2<0 THEN Test2:=-Test2;

 IF Test1>Test2 THEN
  BEGIN
   IF (x2<x1) THEN
    BEGIN
     Swap(x1,x2);
     Swap(y1,y2);
    END;

   IF x1=x2 THEN Inc(x2);
   m:=(y2-y1)/(x2-x1);
   For x:=x1 to x2 do 
    Begin
     Locate(m*(x-x1)+y1+0.5,x);
     Write(c);
    end;
  END
 else
  BEGIN
   IF (y2<y1) THEN
    BEGIN
     Swap(x1,x2);
     Swap(y1,y2);
    END;

   IF y1=y2 THEN Inc(y2);
   m:=(x2-x1)/(y2-y1);
   for y:=y1 to y2 do 
    Begin
     Locate(y,m*(y-y1)+x1+0.5);
     Write(c);
    end;
  END;
END;

PROCEDURE HorizTxtLine(x,y,w : Integer; c : Char);
VAR i : Integer;
    Str : String;
Begin
 Str:=AllocString(200);
 StrCpy(Str,"");
 For i:=1 to w do StrCat(Str,adr(c));
 Locate(y,x);
 Write(Str);
end;

PROCEDURE TxtRectFill(x,y,w,h : Integer; c : Char);
VAR i : Integer;
    Str : String;
Begin
 Str:=AllocString(200);
 StrCpy(Str,"");
 For i:=1 to w do StrCat(Str,adr(c));
 For i:=0 to h-1 do
  Begin
   Locate(y+i,x);
   Write(Str);
  end;
end;

