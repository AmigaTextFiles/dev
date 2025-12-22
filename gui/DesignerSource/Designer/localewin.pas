{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1994       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit localewin;

Interface

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,definitions,routines,designermenus;

Procedure RendWindowlocaleWindow( pwin:pwindow; vi:pointer);
procedure openwindowlocaleWindow;
Procedure CloseWindowlocaleWindow;

const

  getstringgad = 0;
  builtinlanguagegad = 1;
  basenameGad = 2;
  versiongad = 3;
  supportgad = 4;
  loclistgad = 5;
  locstringgad = 6;
  loclabelgad = 7;
  newlocgad = 8;
  deletelocgad = 9;
  okgad = 10;
  helpgad = 11;
  cancelgad = 12;
  loccommentgad = 13;
Var
  localeWindowglist      : pGadget;
  localeWindowVisualInfo : Pointer;
  loclistgadList      : tlist;
  localeWindowgads  : array [0..13] of pgadget;
  localelistselected : long;

Implementation

Procedure RendWindowlocaleWindow( pwin:pwindow; vi:pointer);
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
      DrawBevelBoxA(pwin^.RPort,4+Offx,2+Offy,
        313,108,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,323+Offx,2+Offy,
        294,138,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,112+Offy,
        313,28,@tags[2]);
      routines.PrintString(pwin,104+Offx,7+Offy,
        'Locale Options',1,3, @ttopaz80);
    end;
end;

procedure openwindowlocaleWindow;
Const
  loclistgadListViewTexts : array [0..1] of string[9]=
  (
  'Click Me'#0,
  'Or Me'#0
  );
  Gadgetstrings : array[0..13] of string[24]=
  (
  'GetString function'#0,
  'Built in Language'#0,
  'Catalog Basename'#0,
  'Version'#0,
  'Support locale in V37'#0,
  'Extra Localized Strings'#0,
  'String'#0,
  'Label'#0,
  'New'#0,
  'Delete'#0,
  '_OK'#0,
  '_Help...'#0,
  '_Cancel'#0,
  'Comment'#0
  );
  wintitle : string [15]='Locale options'#0;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pScr  : PScreen;
  pgad  : pgadget;
  pln,pln2 : plocalenode;
begin
  waiteverything;
  if localeWindow=nil then
    begin
      pScr:=lockPubScreen(Nil);
      If pScr<>Nil then
        Begin
          offx:=PScr^.WBorLeft;
          offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;
          localeWindowVisualInfo:=getvisualinfoa( PScr, Nil);
          if localeWindowVisualInfo<>nil then
            Begin
              localeWindowGList:=Nil;
              pGad:=createcontext(@localeWindowGList);
              pgad:=GeneralGadToolsGad( 12, offx+12, offy+19, 
              	139, 13, 0, @gadgetstrings[0,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[0]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+12, offy+35, 
              	139, 13, 2, @gadgetstrings[2,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[2]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+12, offy+51, 
              	139, 13, 1, @gadgetstrings[1,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[1]:=pGad;
              Settagitem(@tags[1], STRINGA_Justification, 512);
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 3, offx+12, offy+67, 
              	139, 13, 3, @gadgetstrings[3,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[3]:=pGad;
              Settagitem(@tags[1], GA_Disabled, Long(True));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 2, offx+13, offy+83, 
              	26, 11, 4, @gadgetstrings[4,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[4]:=pGad;
              localelistselected:=~0;
              NewList(@loclistgadList);
              pln:=plocalenode(tlocalelist.lh_head);
              while(pln^.ln_succ<>nil) do
                begin
                  pln2:=allocmymem(sizeof(tlocalenode),memf_clear);
                  if pln2<>nil then
                    begin
                      
                      pln2^.labl:=pln^.labl;
                      pln2^.str:=pln^.str;
                      pln2^.comment:=pln^.comment;
                      pln2^.ln_name:=@pln2^.str[1];
                      
                      addtail(@loclistgadList,pnode(pln2));
                    end
                   else
                    begin
                      pgad:=nil;
                      telluser(mainwindow,memerror);
                    end;
                  pln:=pln^.ln_succ;
                end;
              Settagitem(@tags[1], GTLV_Selected, ~0);
              SetTagItem(@tags[2], GTLV_Labels, Long(@loclistgadList));
              
              Settagitem(@tags[3], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 4, offx+332, offy+18, 
              	278, 52, 5, @gadgetstrings[5,1],
                                       @ttopaz80, 4,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[5]:=pGad;
              settagitem(@tags[1],gtst_maxchars,250);
              tags[2].ti_tag:=tag_done;
              pgad:=GeneralGadToolsGad( 12, offx+332, offy+89, 
              	214, 13, 6, @gadgetstrings[6,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[6]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+332, offy+105, 
              	214, 13, 7, @gadgetstrings[7,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[7]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+332, offy+73, 
              	89, 13, 8, @gadgetstrings[8,1],
                                       @ttopaz80, 16,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[8]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+520, offy+73, 
              	89, 13, 9, @gadgetstrings[9,1],
                                       @ttopaz80, 16,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[9]:=pGad;
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 1, offx+24, offy+120, 
              	86, 14, 10, @gadgetstrings[10,1],
                                       @ttopaz80, 16,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[10]:=pGad;
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 1, offx+116, offy+120, 
              	86, 14, 11, @gadgetstrings[11,1],
                                       @ttopaz80, 16,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[11]:=pGad;
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 1, offx+208, offy+120, 
              	86, 14, 12, @gadgetstrings[12,1],
                                       @ttopaz80, 16,
              	localeWindowVisualInfo, pGad, Nil, @tags[1]);
              localeWindowGads[12]:=pGad;
              pgad:=GeneralGadToolsGad( 12, offx+332, offy+121, 
              	214, 13, 13, @gadgetstrings[13,1],
                                       @ttopaz80, 2,
              	localeWindowVisualInfo, pGad, Nil, Nil);
              localeWindowGads[13]:=pGad;
              if pgad<>nil then
                begin
                  settagitem(@tags[ 1],WA_Left  ,434);
                  settagitem(@tags[ 2],WA_Top   ,129);
                  settagitem(@tags[ 3],WA_Width ,626+offx);
                  settagitem(@tags[ 4],WA_Height,145+offy);
                  settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
                  settagitem(@tags[ 6],WA_MinWidth ,150);
                  settagitem(@tags[ 7],WA_MinHeight,25);
                  settagitem(@tags[ 8],WA_MaxWidth ,1200);
                  settagitem(@tags[ 9],WA_MaxHeight,1200);
                  settagitem(@tags[10],WA_DragBar,long(true));
                  settagitem(@tags[11],WA_DepthGadget,long(true));
                  settagitem(@tags[12],WA_CloseGadget,long(true));
                  settagitem(@tags[13],WA_Dummy + $30,long(true));
                  settagitem(@tags[14],WA_Activate,long(true));
                  settagitem(@tags[15],WA_SmartRefresh,long(true));
                  settagitem(@tags[16],WA_AutoAdjust,long(true));
                  settagitem(@tags[17],WA_Gadgets,long(localeWindowglist));
                  {
                  settagitem(@tags[18],WA_IDCMP,6292348);
                  }
                  settagitem(@tags[18],Tag_Done,0);
                  localeWindow:=routines.openwindowtaglistnicely(Nil,@tags[1],6292348);
                  if localeWindow<>nil then
                    begin
                      GT_RefreshWindow( localeWindow, Nil);
                      RendWindowlocaleWindow( localeWindow,localeWindowVisualInfo );
                      if makemenulocalemenu(screenvisualinfo) then
                        begin
                          if not setmenustrip(localewindow,localemenu) then
                            begin
                              freemenus(localemenu);
                              localemenu:=nil;
                            end;
                        end;

                      
                      localewindownode.ln_type:=localewindownodetype;
                      localewindow^.userdata:=pointer(@localewindownode);
                      gt_setsinglegadgetattr(localewindowgads[getstringgad],localewindow,gtst_string,long(@getstring[1]));
                      gt_setsinglegadgetattr(localewindowgads[builtinlanguagegad],localewindow,gtst_string,
                               long(@builtinlanguage[1]));
                      gt_setsinglegadgetattr(localewindowgads[basenamegad],localewindow,gtst_string,long(@basename[1]));
                      gt_setsinglegadgetattr(localewindowgads[versiongad],localewindow,gtin_NUMBER,long(version));
                      gt_setsinglegadgetattr(localewindowgads[supportgad],localewindow,gtcb_checked,long(locale37));
                      gt_setsinglegadgetattr(localewindowgads[deletelocgad],localewindow,ga_disabled,long(true));
                      gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,ga_disabled,long(true));
                      gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,ga_disabled,long(true));
                      gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,ga_disabled,long(true));
                      
                      
                      { set up extra stuff }
                      
                    end
                   else
                    Begin
                      FreeVisualInfo(localeWindowVisualInfo);
                      FreeGadgets(localeWindowGList);
                    end;
                end
               else
                Begin
                  FreeVisualInfo(localeWindowVisualinfo);
                End;
            end;
          UnLockPubScreen( Nil, PScr);
        end;
    end
   else
    begin
      WindowToFront(localeWindow);
      activatewindow(localeWindow);
    end;
  unwaiteverything;
  inputmode:=1;
end;

Procedure CloseWindowlocaleWindow;
Begin
  if localeWindow<>nil then
    Begin
      if localemenu<>nil then
        begin
          clearmenustrip(localewindow);
          freemenus(localemenu);
          localemenu:=nil;
        end;
      Closewindowsafely(localeWindow);
      freelist(@loclistgadlist,sizeof(tlocalenode));
      localeWindow:=Nil;
      FreeVisualInfo(localeWindowVisualinfo);
      FreeGadgets(localeWindowGList);
    end;
end;

Begin
End.
