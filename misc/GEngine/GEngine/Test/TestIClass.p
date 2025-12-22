Program TestIClass;

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
{$I "Include:Libraries/GE_Hooks.i"}
{$I "Include:Libraries/GE_TagItem.i"}
{$I "Include:Libraries/GE_imageclass.i"}

Const

BallData : Array [1..64] of short =
(
	$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,
	$FFFA,$2FFF,$FFEA,$93FF,$FFF5,$48FF,$FFD5,$227F,
	$FFF5,$493F,$FFD4,$905F,$FFF5,$451F,$FFD5,$282F,
	$FFAA,$408F,$FED5,$140F,$F752,$4117,$FAA9,$280F,
	$ED54,$8247,$F552,$480F,$F6A9,$100F,$F544,$412F,
	$F529,$080F,$FA92,$402F,$F448,$111F,$FAA2,$805F,
	$FC08,$043F,$FEA1,$20FF,$FF10,$02FF,$FFA4,$8BFF,
	$FFD0,$27FF,$FFFB,$5FFF,$FFFF,$FFFF,$FFFF,$FFFF
);


Itext1 : IntuiText =(1,0,JAM1,0,0,0,Nil,Nil,Nil);


AGad : MyProp = (20,40,160,10,0,0,0,0,0,30,FREEHORIZ+PTXT,0,Nil,Nil,1,0,Nil);
ZGad : MyProp = (20,65,160,10,0,0,0,0,0,30,FREEHORIZ+PTXT,0,Nil,Nil,2,0,Nil);
XGad : MyProp = (20,90,160,10,0,0,0,0,0,30,FREEHORIZ+PTXT,0,Nil,Nil,3,0,Nil);
YGad : MyProp = (20,115,160,10,0,0,0,0,0,30,FREEHORIZ+PTXT,0,Nil,Nil,4,0,Nil);


WFgs = SMART_REFRESH + ACTIVATE + WINDOWDRAG + WINDOWDEPTH + WINDOWCLOSE;

TestP	: NewProject = (0,0,0,0,0,Nil,0,"TestI1");

IAtt : Array [1..8] of TagItem = ((GIA_Left,0),(GIA_Top,0),(GIA_Data,0),(GIA_FgPen,1),
        (GIA_BgPen,0),(GIA_Width,32),(GIA_Height,32),(TAG_DONE,0));

IAtt2 : Array [1..3] of TagItem = ((GIA_Left,0),(GIA_Top,0),(TAG_DONE,0));

OOSet : gpSet = (GM_NEW,Nil,Nil);

OODraw : GE_ImpDraw = (GIM_DRAW,Nil,(50,50),GIDS_NORMAL,Nil,(0,0));

OOGet : gpGet = (GM_GET,GIA_Left,Nil);

Var

WinWin, Win2,
Mwin    : WindowPtr;
MRp,MRp2    : RastPortPtr;
IMess    : IntuiMessagePtr;
Quit    : Boolean;
P    : PropInfoPtr;
i,a,z,x,y,pz,pa,px,py  : Integer;
Ap,Zp,Xp,Yp : GadgetPtr;
{/cut/}
MExt    : GPropExtPtr;
GPP : GEProjectPtr;
GEM : GEMessPtr;
MyPI : PenInfoPtr;
Pens: ^Array[0..0] of Short;
Th : Short;
{/////}
Oima: _GObjectPtr;
IData: ^Array[1..64] of short;
Tima: ImagePtr;
Stora: Integer;
StoraS: String;

{--Main--}
Begin
 OOSet.gps_AttrList:= Address(@IAtt);
 OOGet.gpg_Storage:=@Stora;
 pa:=0; pz:=0; a:=0; z:=0;
 StoraS:= AllocString(12);
 GfxBase := OpenLibrary("graphics.library",0);
 if GfxBase <> Nil then begin
  Quit := false;
  if StartGEngine then begin
   GPP:= CreateProject(@TestP);
   if GPP<>Nil then begin
    WinWin:= GEOpenWindow(GPP,"Controls",200,160,PL_TL,WFgs);
    if WinWin<>Nil then begin
     MRp:= WinWin^.RPort;
     Ap:= InitGProp(GPP,WinWin,@AGad);
     Zp:= InitGProp(GPP,WinWin,@ZGad);
     Xp:= InitGProp(GPP,WinWin,@XGad);
     Yp:= InitGProp(GPP,WinWin,@YGad);
     RefreshGadgets(WinWin^.FirstGadget,WinWin,Nil);
     Win2:= GEOpenWindow(GPP,"ImageClass demo",200,200,PL_CC,WFgs-WINDOWCLOSE);
     if Win2<>Nil then begin
      MRp2:= Win2^.RPort;
      IClass:= GE_MakeClass("gimageclass","gerootclass",Nil,SizeOf(Image),0);
      if IClass<>Nil then begin
       With IClass^.gc_dispatcher do begin {Init dispatcher hook}
        h_MinNode.mln_Succ:=Nil;
        h_MinNode.mln_Pred:=Nil;
        h_Entry:= Adr(HookEntry);
        h_SubEntry:= Adr(_GEImageHook);
        h_Data:= Nil;
       end;
       IClass^.gc_Subclasscount:=0;
       GE_AddClass(IClass);
       IData:= AllocMem(128,MEMF_CHIP+MEMF_CLEAR);
       if IData<>Nil then begin
        CopyMem(@BallData,IData,128);
        IAtt[3].ti_Data:= Integer(IData);
        Writeln(Integer(IData));
        Oima:= _GObjectPtr(CallHook(HookPtr(IClass),IClass,@OOSet));
        if Oima<>Nil then begin
         Tima:= INST_DATA(IClass,Oima);
         Tima^.Depth:= 1;
         Writeln(Tima^.ImageData=IData);
         {MyPI:= GetPenInfo(ScreenPtr(Win2^.WScreen));
         Pens:= MyPI^.PI_PenArray;}
         {MRp2^.RP_User:= MyPI;}
         OODraw.gimp_RPort:= MRp2;
         OOSet.MethodID:= GM_SET;
         OOSet.gps_AttrList:= @IAtt2;
         Writeln(GE_IsObject(Oima));
         Writeln(GE_IsObject(@OODraw));
         if DoMethodA(Oima,@OODraw)=1 then;
         Repeat
          IMess := IntuiMessagePtr(WaitPort(WinWin^.UserPort));
          IMess := IntuiMessagePtr(GetMsg(WinWin^.UserPort));
          GEM:= Gotcha(GPP,WinWin,IMess);
          if GEM<>Nil then begin
           if GEM^.GType= GT_SLD then begin
            case GEM^.GID of
             1 : a:= GEM^.GVal;
             2 : z:= GEM^.GVal;
             3 : x:= GEM^.GVal;
             4 : y:= GEM^.GVal;
            end;
            if (a<>pa)or(z<>pz)or(x<>px)or(y<>py) then begin
             OODraw.MethodID:= GIM_ERASE;
             if DoMethodA(Oima,@OODraw)=1 then;
             IAtt2[1].ti_Data:= a;
             IAtt2[2].ti_Data:= z;
             OODraw.MethodID:= GIM_DRAW;
             OODraw.gimp_Offset.x:= 50+x;
             OODraw.gimp_Offset.y:= 50+y;
             if DoMethodA(Oima,@OOSet)=0 then;
             if DoMethodA(Oima,@OODraw)=1 then;
             {if DoMethodA(Oima,@OOGet)<>0 then begin
              MOVE(MRp,100,100);
              SetDrMd(MRp,JAM2);
              SetAPen(MRp,2);
              SetBPen(MRp,0);
              i:= IntToStr(StoraS,Stora);
              GText(MRp,StoraS,i);
             end;}
             pa:=a; pz:=z; px:=x; py:=y;
            end;
           end;
           GEReply(GEM);
          end else case IMess^.Class of
           CLOSEWINDOW_f    : Quit := true;
          end;
          ReplyMsg(MessagePtr(IMess));
         Until Quit;
         FreePenInfo(MyPI);
         OOSet.MethodID:= GM_DISPOSE;
         if DoMethodA(Oima,@OOSet)=0 then;
        end else
         Writeln("no object");
        FreeMem(IData,128);
       end;
       GE_RemoveClass(IClass);
       if GE_FreeClass(IClass) then;
       Writeln("Deleted IClass");
      end;
      GECloseWindow(GPP,Win2);
     end;
     FreeGProp(GPP,WinWin,Ap);
     FreeGProp(GPP,WinWin,Zp);
     FreeGProp(GPP,WinWin,Xp);
     FreeGProp(GPP,WinWin,Yp);
     GECloseWindow(GPP,WinWin);
    end;
    KillProject(GPP);
   end;
   StopGEngine;
  end;
  CloseLibrary(GfxBase);
 end;
 FreeString(StoraS);
end.