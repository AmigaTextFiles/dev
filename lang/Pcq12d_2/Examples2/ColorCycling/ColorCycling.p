Program Kreis;

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Libraries/DOS.i"}



Const


      nw : NewWindow=(0,0,640,400,0,1,CLOSEWINDOW_f,
				 WINDOWCLOSE+WINDOWDRAG+WINDOWDEPTH,
				 NIL,NIL,NIL,NIL,NIL,240,100,240,100,WBENCHSCREEN_F);

VAR  Win : WindowPtr;
     RP : RastPortPtr;
     VP : ViewPortPtr;
     Msg : MessagePtr;
     i : Integer;
     x, y, f, Swap : Short;
     ColorTable : Array[1..16] of Short;

Procedure Clean_Exit(Why : String; RC : Integer);
Begin
  If Win<>NIL then CloseWindow(Win);
  If GfxBase<>NIL then CloseLibrary(GfxBase);
  If Why<>NIL then Writeln(Why);
  Exit(RC);
end;



Begin
  GfxBase:=OpenLibrary("graphics.library",0);
  If GfxBase=NIL then Clean_Exit("Kann Graphics.Library nicht öffnen",10);
  Win:=OpenWindow(adr(nw));
  If Win=NIL then Clean_Exit("Kann Window nicht öffnen.",10);
  RP:=Win^.RPort;

  SetAPen(RP,1);

  For i:=0 to 360 do
   Begin
    x:=100*COS(i/57);
    y:=100*SIN(i/57);
    Move(RP,320,200);
    Draw(RP,320+x,200+y);
    i:=i+5;
   end;

  Msg:=WaitPort(Win^.UserPort);
  Msg:=getMsg(Win^.UserPort);
  ReplyMsg(Msg);
  Clean_Exit(NIL,0);
end.

