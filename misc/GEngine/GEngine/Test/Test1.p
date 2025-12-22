Program TestPalette;

{--Intuition--}
{$I "Include:Intuition/Intuition.i"}

{--Graphics--}
{$I "Include:Graphics/RastPort.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/GFXBase.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Graphics/GFX.i"}

{--Exec--}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}

{--Utils--}
{$I "Include:Utils/StringLib.i"}
{$I "sys:Filegrabber/Source/GEngine_d.i"}

Const


Txt : Array[0..7] of String= ("Background","Text      ","Shine     ","Half Shine",
	"Dark      ","Half Dark ","Highlight ","Selected  ");


Itext1 : IntuiText =(1,0,JAM1,0,0,0,Nil,Nil,Nil);


RGad : MyProp = (20,40,160,10,0,0,$FFFF,256,FREEHORIZ+PTXT,0,Nil,Nil,2,0,Nil);
GGad : MyProp = (20,60,160,10,0,0,$FFFF,256,FREEHORIZ+PTXT,0,Nil,Nil,3,0,Nil);
BGad : MyProp = (20,80,160,10,0,0,$FFFF,256,FREEHORIZ+PTXT,0,Nil,Nil,4,0,Nil);


WFgs = SMART_REFRESH + ACTIVATE + WINDOWDRAG + WINDOWDEPTH + WINDOWCLOSE;

TestP	: NewProject = (0,0,0,0,0,Nil,0,"Test1");


Var

WinWin, Win2,
Mwin    : WindowPtr;
MRp,MRp2    : RastPortPtr;
IMess    : IntuiMessagePtr;
Quit    : Boolean;
P    : PropInfoPtr;
i,r,g,b    : Integer;
Bl,Wh   : Short;
MPp,Rp,Gp,Bp : GadgetPtr;
{/cut/}
MExt    : GPropExtPtr;
GPP : GEProjectPtr;
GEM : GEMessPtr;
MyPI : PenInfoPtr;
Pens: ^Array[0..0] of Short;
Th : Short;
{/////}

{--Main--}
Begin
 GfxBase := OpenLibrary("graphics.library",0);
 if GfxBase <> Nil then begin
  Quit := false;
  if StartGEngine then begin
   GPP:= CreateProject(@TestP);
   if GPP<>Nil then begin
    WinWin:= GEOpenWindow(GPP,"Palette Demo",300,120,PL_CC,WFgs);
    if WinWin<>Nil then begin
     MRp:= WinWin^.RPort;
     Rp:= InitGProp(GPP,WinWin,@RGad);
     Gp:= InitGProp(GPP,WinWin,@GGad);
     Bp:= InitGProp(GPP,WinWin,@BGad);
     RefreshGadgets(WinWin^.FirstGadget,WinWin,Nil);
     Wh:= GetBestPen(ViewPortAddress(WinWin),15,15,15);
     Bl:= GetBestPen(ViewPortAddress(WinWin),0,0,0);
     Win2:= GEOpenWindow(GPP,"Default Colors",50+TextLength(MRp,Txt[0],10),
     50+9*TextFontPtr(MRp^.Font)^.tf_YSize,PL_CC,WFgs-WINDOWCLOSE);
     if Win2<>Nil then begin
      MyPI:= GetPenInfo(ScreenPtr(Win2^.WScreen));
      Pens:= MyPI^.PI_PenArray;
      MRp2:= Win2^.RPort;
      MRp2^.RP_User:= MyPI;
      Th:= TextFontPtr(MRp2^.Font)^.tf_Baseline;
      for i:= 0 to 7 do begin
	SetAPen(MRp2, Pens^[i]);
	r:= i*(Th+5);
	RectFill(MRp2,20,20+r,30,30+r);
	SetAPen(MRp2, Pens^[TXTPEN]);
	Move(MRp2,35,20+r+th);
	GText(MRp2,Txt[i],10);
      end;
      r:=0;
      SetAPen(MRp,Bl);
      RectFill(MRp,220,45,270,95);
      Repeat
       IMess := IntuiMessagePtr(WaitPort(WinWin^.UserPort));
       IMess := IntuiMessagePtr(GetMsg(WinWin^.UserPort));
       GEM:= Gotcha(GPP,WinWin,IMess);
       if GEM<>Nil then begin
	if GEM^.GType= GT_SLD then begin
	 case GEM^.GID of
		2 : r:= GEM^.GVal shl 24;
		3 : g:= GEM^.GVal shl 24;
		4 : b:= GEM^.GVal shl 24;
	 end;
	 SetAPen(MRp,GetBestPen(ViewPortAddress(WinWin),r,g,b));
	 RectFill(MRp,220,45,270,95);
	end; 
	GEReply(GEM);
       end else case IMess^.Class of
        CLOSEWINDOW_f    : Quit := true;
       end;
       ReplyMsg(MessagePtr(IMess));
      Until Quit;
      FreePenInfo(MyPI);
      GECloseWindow(GPP,Win2);
     end;
     FreeGProp(GPP,WinWin,Rp);
     FreeGProp(GPP,WinWin,Gp);
     FreeGProp(GPP,WinWin,Bp);
     GECloseWindow(GPP,WinWin);
    end;
    KillProject(GPP);
   end;
   StopGEngine;
  end;
  CloseLibrary(GfxBase);
 end;
end.