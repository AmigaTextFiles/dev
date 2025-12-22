Program PopMenus;

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


Itext1 : IntuiText =(1,0,JAM1,0,0,0,Nil,Nil,Nil);

st1 : Items= ("Primero",Nil);
st2 : Items= ("Segundo",@st1);
st3 : Items= ("Tercero",@st2);

TheText : IntuiText = (5,6,JAM2,0,0,0,Nil,"PushMe",Nil);

TheButton : Gadget = (Nil,110,90,100,20,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET,
            Nil,Nil,@TheText,0,Nil,1,Nil);


NProp : MyProp = (50,20,160,20,0,0,0,0,0,360,FREEHORIZ,0,Nil,Nil,1,0,Nil);

RGad : MyProp = (50,120,160,10,0,0,0,0,0,255,FREEHORIZ+PTXT,0,Nil,Nil,2,0,Nil);
GGad : MyProp = (50,140,160,10,0,0,0,0,0,255,FREEHORIZ+PTXT,0,Nil,Nil,3,0,Nil);
BGad : MyProp = (50,160,160,10,0,0,0,0,0,255,FREEHORIZ+PTXT,0,Nil,Nil,4,0,Nil);


WFgs = SMART_REFRESH + ACTIVATE + WINDOWDRAG + WINDOWDEPTH + WINDOWCLOSE;

TestP	: NewProject = (0,0,0,0,0,Nil,0,"TestPop");


Var

WinWin,
Mwin    : WindowPtr;
MRp    : RastPortPtr;
IMess    : IntuiMessagePtr;
Quit    : Boolean;
Playing    : GadgetPtr;
P    : PropInfoPtr;
i,r,g,b    : Integer;
AStr    : String;
Bl,Wh   : Short;
MPp,Rp,Gp,Bp : GadgetPtr;
{/cut/}
MExt    : GPropExtPtr;
TW    : Short;
GPP : GEProjectPtr;
GEM : GEMessPtr;
MyPI : PenInfoPtr;
{/////}

{--Main--}
Begin
 AStr := AllocString(10);
 GfxBase := OpenLibrary("graphics.library",0);
 if GfxBase <> Nil then begin
  Quit := false;
  if StartGEngine then begin
   GPP:= CreateProject(@TestP);
   if GPP<>Nil then begin
    WinWin:= GEOpenWindow(GPP,"My First Project",320,200,PL_CC,WFgs);
    if WinWin<>Nil then begin
     MyPI:= GetPenInfo(ScreenPtr(WinWin^.WScreen));
     MRp:= WinWin^.RPort;
     MRp^.RP_User:= MyPI;
     DrawVertex(MRp,20,20,20,20,0,@XENB2);
     DrawVImage(MRp,@PROPBUTTON,20,70,100,16,0);
     Mpp:= InitGProp(GPP,WinWin,@NProp);
     Rp:= InitGProp(GPP,WinWin,@RGad);
     Gp:= InitGProp(GPP,WinWin,@GGad);
     Bp:= InitGProp(GPP,WinWin,@BGad);
     if AddGList(WinWin,@TheButton,-1,1,Nil)=0 then;
     RefreshGadgets(WinWin^.FirstGadget,WinWin,Nil);
     Wh:= GetBestPen(ViewPortAddress(WinWin),15,15,15);
     Bl:= GetBestPen(ViewPortAddress(WinWin),0,0,0);
     Repeat
      IMess := IntuiMessagePtr(WaitPort(WinWin^.UserPort));
      IMess := IntuiMessagePtr(GetMsg(WinWin^.UserPort));
      GEM:= Gotcha(GPP,WinWin,IMess);
      if GEM<>Nil then begin
	if GEM^.GType= GT_SLD then begin
	 case GEM^.GID of
		1 : Begin
			SetAPen(MRp,0);
			RectFill(MRp,16,16,44,44);
			DrawVertex(MRp,20,20,20,20,GEM^.GVal,@XENB2);
		    end;
		2 : r:= GEM^.GVal shl 24;
		3 : g:= GEM^.GVal shl 24;
		4 : b:= GEM^.GVal shl 24;
	 end;
	 SetAPen(MRp,GetBestPen(ViewPortAddress(WinWin),r,g,b));
	 RectFill(MRp,250,30,300,80);
	end; 
	GEReply(GEM);
      end else case IMess^.Class of
        CLOSEWINDOW_f    : Quit := true;
        GADGETDOWN_f    : if GadgetPtr(IMess^.IAddress)^.GadgetID=1 then
		Begin
		 Mwin := OpenMenuWindow(110+WinWin^.LeftEdge,90+WinWin^.TopEdge,@st3,WinWin^.WScreen);
		 if Mwin <> Nil then begin
		  Writeln(GetMenuSelection(Mwin));
		  CloseMenuWindow(Mwin);
		 end else
		 Writeln('Could not open window');
		end;
      end;
      ReplyMsg(MessagePtr(IMess));
     Until Quit;
     FreePenInfo(MyPI);
     FreeGProp(GPP,WinWin,Mpp);
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
 FreeString(AStr);
end.