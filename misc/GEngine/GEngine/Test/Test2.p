Program TestVector;

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
{$I "Include:Graphics/Layers.i"}
{$I "Include:Graphics/Regions.i"}

{--Exec--}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Memory.i"}

{--Utils--}
{$I "Include:Utils/StringLib.i"}
{$I "sys:Filegrabber/Source/GEngine_d.i"}

Const


Itext1 : IntuiText =(1,0,JAM1,0,0,0,Nil,Nil,Nil);


AGad : MyProp = (20,40,160,10,0,0,0,0,0,360,FREEHORIZ+PTXT,0,Nil,Nil,1,0,Nil);
ZGad : MyProp = (20,60,160,10,0,10,0,10,0,116,FREEHORIZ+PTXT,0,Nil,Nil,2,0,Nil);


WFgs = SMART_REFRESH + ACTIVATE + WINDOWDRAG + WINDOWDEPTH + WINDOWCLOSE;

TestP	: NewProject = (0,0,0,0,0,Nil,0,"Test2");


Var

WinWin, Win2,
Mwin    : WindowPtr;
MRp,MRp2    : RastPortPtr;
IMess    : IntuiMessagePtr;
Quit    : Boolean;
P    : PropInfoPtr;
i,a,z,pz,pa  : Integer;
Bl,Wh   : Short;
Ap,Zp,Bp : GadgetPtr;
{/cut/}
MExt    : GPropExtPtr;
GPP : GEProjectPtr;
GEM : GEMessPtr;
MyPI : PenInfoPtr;
Pens: ^Array[0..0] of Short;
Th : Short;
oreg,nregion : RegionPtr;
MyRect : Rectangle;

{/////}

{--Main--}
Begin
 pa:=0; pz:=10; a:=0; z:=10;
 GfxBase := OpenLibrary("graphics.library",0);
 if GfxBase <> Nil then begin
  LayersBase:= OpenLibrary("layers.library",34);
  if LayersBase<>Nil then begin
   Quit := false;
   if StartGEngine then begin
    GPP:= CreateProject(@TestP);
    if GPP<>Nil then begin
     WinWin:= GEOpenWindow(GPP,"Controls",200,120,PL_TL,WFgs);
     if WinWin<>Nil then begin
      MRp:= WinWin^.RPort;
      Ap:= InitGProp(GPP,WinWin,@AGad);
      Zp:= InitGProp(GPP,WinWin,@ZGad);
      RefreshGadgets(WinWin^.FirstGadget,WinWin,Nil);
      Wh:= GetBestPen(ViewPortAddress(WinWin),15,15,15);
      Bl:= GetBestPen(ViewPortAddress(WinWin),0,0,0);
      Win2:= GEOpenWindow(GPP,"Vector demo",200,200,PL_CC,WFgs-WINDOWCLOSE);
      if Win2<>Nil then begin
       MyPI:= GetPenInfo(ScreenPtr(Win2^.WScreen));
       Pens:= MyPI^.PI_PenArray;
       MRp2:= Win2^.RPort;
       MRp2^.RP_User:= MyPI;
       MyRect.MinX:= Win2^.BorderLeft;
       MyRect.MinY:= Win2^.BorderTop;
       MyRect.MaxX:= Win2^.Width-Win2^.BorderRight-1;
       MyRect.MaxY:= Win2^.Height-Win2^.BorderBottom-1;
       nregion:= NewRegion;
       if nregion<>nil then
	if OrRectRegion(nregion,@MyRect)=false then begin
	 DisposeRegion(nregion);
	 nregion:= nil;
	end;
       oreg:= InstallClipRegion(Win2^.WLayer,nregion);
       if oreg<>Nil then
	DisposeRegion(oreg);
       DrawVertex(MRp2,100-(z/2),100-(z/2),z,z,a,@Arrow);
       Repeat
	IMess := IntuiMessagePtr(WaitPort(WinWin^.UserPort));
	IMess := IntuiMessagePtr(GetMsg(WinWin^.UserPort));
	GEM:= Gotcha(GPP,WinWin,IMess);
	if GEM<>Nil then begin
	 if GEM^.GType= GT_SLD then begin
	  case GEM^.GID of
		1 : a:= GEM^.GVal;
		2 : z:= GEM^.GVal;
	  end;
	  if (a<>pa)or(z<>pz) then begin
           SetAPen(MRp2,0);
           i:= CModulo(pz/2,pz/2);
	   i:= (ABS(i*cos((pa*pi2/360))))+(ABS(i*sin((pa*pi2/360))));
           RectFill(MRp2,100-i,100-i,100+i,100+i);
	   DrawVertex(MRp2,100-(z/2),100-(z/2),z,z,a,@Arrow);
	   pa:=a; pz:=z;
	  end;
	 end; 
	 GEReply(GEM);
        end else case IMess^.Class of
	 CLOSEWINDOW_f    : Quit := true;
	end;
	ReplyMsg(MessagePtr(IMess));
       Until Quit;
       oreg:= InstallClipRegion(Win2^.WLayer,nil);
       if oreg<>Nil then
	DisposeRegion(oreg);
       FreePenInfo(MyPI);
       GECloseWindow(GPP,Win2);
      end;
      FreeGProp(GPP,WinWin,Ap);
      FreeGProp(GPP,WinWin,Zp);
      GECloseWindow(GPP,WinWin);
     end;
     KillProject(GPP);
    end;
    StopGEngine;
   end;
   CloseLibrary(LayersBase);
  end;
  CloseLibrary(GfxBase);
 end;
end.