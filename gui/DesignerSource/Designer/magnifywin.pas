{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1993       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit magnifywin;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility;

Procedure RendWindowpdwnmagnifywin( pwin:pwindow; vi:pointer);
Function openwindowpdwnmagnifywin( Pmport : pMsgPort): Boolean;
Procedure CloseWindowpdwnmagnifywin;
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


const

  pdwn^.magnifywin_Gad0 = 0;
  pdwn^.magnifywin_Gad1 = 1;
  pdwn^.magnifywin_Gad2 = 2;
  topaz800Name : string[11] = 'topaz.font'#0;
Var
  pdwn^.magnifywin           : pWindow;
  pdwn^.magnifywinglist      : pGadget;
  pdwn^.magnifywinVisualInfo : Pointer;
  pdwn^.magnifywin_Gad0Labels : array[0..3] of pbyte;
  pdwn^.magnifywingads  : array [0..2] of pgadget;
  topaz800 : tTextAttr;

Implementation

Procedure RendWindowpdwnmagnifywin( pwin:pwindow; vi:pointer);
Var
  Offx     : word;
  Offy     : word;
  tags     : array[1..3] of ttagitem;
Begin
  If pwin<>nil then
    Begin
      Offx:=pwin^.borderleft;
      Offy:=pwin^.bordertop;
      settagitem(@tags[1],GTBB_Recessed,long(True));
      settagitem(@tags[2],GT_VisualInfo,long(vi));
      settagitem(@tags[3],Tag_Done,0);
      DrawBevelBoxA(pwin^.RPort,7+Offx,3+Offy,
        297,38,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,8+Offx,44+Offy,
        299,128,@tags[1]);
    end;
end;

Function openwindowpdwnmagnifywin( Pmport : pMsgPort): Boolean;
Const
  pdwn^.magnifywin_Gad0CycleTexts : array [0..2] of string[7]=
  (
  'Normal'#0,
  'Mouse'#0,
  'Off'#0
  );
  pdwn^.magnifywin_Gad1levelformat : string[11] ='Zoom :%2ld'#0;
  Gadgetstrings : array[0..2] of string[8]=
  (
  '_Mode'#0,
  ''#0,
  'Help...'#0
  );
  ZoomInfo : array [1..4] of word = (200,0,200,25);
  wintitle : string [15]='Magnify Window'#0;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pScr  : PScreen;
  pgad  : pgadget;
begin
  openwindowpdwnmagnifywin:=true;
  if pdwn^.magnifywin=nil then
    begin
      pScr:=lockPubScreen(Nil);
      If pScr<>Nil then
        Begin
          offx:=PScr^.WBorLeft;
          offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;
          pdwn^.magnifywinVisualInfo:=getvisualinfoa( PScr, Nil);
          if pdwn^.magnifywinVisualInfo<>nil then
            Begin
              pdwn^.magnifywinGList:=Nil;
              pGad:=createcontext(@pdwn^.magnifywinGList);
              For Loop:=0 to 2 do
                pdwn^.magnifywin_Gad0Labels[Loop]:=@pdwn^.magnifywin_Gad0CycleTexts[Loop,1];
              pdwn^.magnifywin_Gad0Labels[3]:=Nil;
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              SetTagItem(@tags[2], GTCY_Labels, Long(@pdwn^.magnifywin_Gad0Labels));
              Settagitem(@tags[3], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 7, offx+15, offy+7, 
              	104, 14, 0, @gadgetstrings[0,1],
                                       @topaz800, 2,
              	pdwn^.magnifywinVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.magnifywinGads[0]:=pGad;
              Settagitem(@tags[1], GTSL_Min, 1);
              Settagitem(@tags[2], GTSL_Max, 8);
              Settagitem(@tags[3], GTSL_Level, 2);
              Settagitem(@tags[4], GTSL_LevelFormat, Long(@pdwn^.magnifywin_Gad1levelformat[1]));
              Settagitem(@tags[5], GTSL_MaxLevelLen, 64);
              Settagitem(@tags[6], GTSL_LevelPlace, 2);
              Settagitem(@tags[7], GA_RelVerify, Long(True));
              Settagitem(@tags[8], GT_UnderScore, Ord('_'));
              Settagitem(@tags[9], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 11, offx+15, offy+23, 
              	104, 14, 1, @gadgetstrings[1,1],
                                       @topaz800, 2,
              	pdwn^.magnifywinVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.magnifywinGads[1]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+212, offy+7, 
              	75, 14, 2, @gadgetstrings[2,1],
                                       @topaz800, 16,
              	pdwn^.magnifywinVisualInfo, pGad, Nil, Nil);
              pdwn^.magnifywinGads[2]:=pGad;
              if pgad<>nil then
                begin
                  settagitem(@tags[ 1],WA_Left  ,297);
                  settagitem(@tags[ 2],WA_Top   ,25);
                  settagitem(@tags[ 3],WA_Width ,331+offx);
                  settagitem(@tags[ 4],WA_Height,184+offy);
                  settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
                  settagitem(@tags[ 6],WA_MinWidth ,150);
                  settagitem(@tags[ 7],WA_MinHeight,25);
                  settagitem(@tags[ 8],WA_MaxWidth ,1200);
                  settagitem(@tags[ 9],WA_MaxHeight,1200);
                  settagitem(@tags[10],WA_SizeGadget,long(true));
                  settagitem(@tags[11],WA_SizeBRight,long(true));
                  settagitem(@tags[12],WA_SizeBBottom,long(true));
                  settagitem(@tags[13],WA_DragBar,long(true));
                  settagitem(@tags[14],WA_DepthGadget,long(true));
                  settagitem(@tags[15],WA_CloseGadget,long(true));
                  settagitem(@tags[16],WA_Activate,long(true));
                  settagitem(@tags[17],WA_SmartRefresh,long(true));
                  settagitem(@tags[18],WA_AutoAdjust,long(true));
                  settagitem(@tags[19],WA_Gadgets,long(pdwn^.magnifywinglist));
                  settagitem(@tags[20],WA_Zoom,long(@ZoomInfo[1]));
                  settagitem(@tags[21],Tag_Done,0);
                  pdwn^.magnifywin:=openwindowtaglistnicely(Nil,@tags[1],628, pMport);
                  if pdwn^.magnifywin<>nil then
                    begin
                      GT_RefreshWindow( pdwn^.magnifywin, Nil);
                      RendWindowpdwnmagnifywin( pdwn^.magnifywin,pdwn^.magnifywinVisualInfo );
                    end
                   else
                    Begin
                      OpenWindowpdwnmagnifywin:=false;
                      FreeVisualInfo(pdwn^.magnifywinVisualInfo);
                      FreeGadgets(pdwn^.magnifywinGList);
                    end;
                end
               else
                Begin
                  OpenWindowpdwnmagnifywin:=false;
                  FreeVisualInfo(pdwn^.magnifywinVisualinfo);
                End;
            end
           else
            openwindowpdwnmagnifywin:=false;
          UnLockPubScreen( Nil, PScr);
        end
       else
        openwindowpdwnmagnifywin:=false;
    end
   else
    begin
      WindowToFront(pdwn^.magnifywin);
      if 0=activatewindow(pdwn^.magnifywin) then;
    end;
end;

Procedure CloseWindowpdwnmagnifywin;
Begin
  if pdwn^.magnifywin<>nil then
    Begin
      Closewindowsafely(pdwn^.magnifywin);
      pdwn^.magnifywin:=Nil;
      FreeVisualInfo(pdwn^.magnifywinVisualinfo);
      FreeGadgets(pdwn^.magnifywinGList);
    end;
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

Begin
  pdwn^.magnifywin:=Nil;
  with topaz800 do
    begin
      topaz800.ta_YSize:=8;
      topaz800.ta_Flags:=0;
      topaz800.ta_Style:=0;
      topaz800.ta_Name:=@topaz800Name[1];
    end;
End.
