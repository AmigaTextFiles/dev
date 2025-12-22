{*********************************************}
{*                                           *}
{*       Designer (C) Ian OConnor 1994       *}
{*                                           *}
{*       Designer Produced Pascal Unit       *}
{*                                           *}
{*********************************************}

Unit edittags;

Interface

Uses diskfont,workbench,utility,designermenus,exec,intuition,dos,
     definitions,editboopsi,
     routines,amiga,gadtools,graphics,
     colorwheel,gradientslider,amigados;

Procedure RendWindowEditTagsWindow( pwin:pwindow; vi:pointer  );
procedure openwindowEditTagsWindow;
Procedure CloseWindowEditTagsWindow;
Procedure ProcessWindowEditTagsWindow( Class : long ; Code : word ; IAddress : pbyte );

var
  edittaglistselected : long;
  edittaglist         : tlist;

Const
  lvgad = 0;
  labelgad = 1;
  valuegad = 2;
  tagsave = 3;
  newtaggad = 4;
  deltaggad = 5;
  tagcancel = 6;
  taguse = 7;
Var
  EditTagsWindowglist      : pGadget;
  EditTagsWindowVisualInfo : Pointer;
  EditTagsWindowDrawInfo   : pdrawinfo;
  EditTagsWindowgads  : array [0..7] of pgadget;

Implementation

procedure shocktagwindows;
var
  pdwn : pdesignerwindownode;
  pgn : pgadgetnode;
  pmt : pmytag;
begin
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while(pdwn^.ln_succ <>nil) do
    begin
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          if pgn^.kind=198 then
            begin
              if pgn^.editwindow<>nil then
                begin
                  if pgn^.editwindow^.data4<>~0 then
                    begin
                      pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                      if pmt<>nil then
                        begin
                          if pmt^.tagtype=tagtypeselect then
                            begin
                              gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],
                                                     pgn^.editwindow^.pwin,GTLV_labels,~0);
                              gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],
                                                 pgn^.editwindow^.pwin,GTLV_labels,long(@knowntaglist));
                            end;
                        end;
                    end;
                end;
            end;
          pgn:=pgn^.ln_succ;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
end;

procedure readtagdata;
var
  n :pstringnode;
begin
  if edittaglistselected<>~0 then
    begin
      n:=pstringnode(getnthnode(@edittaglist,edittaglistselected));
      n^.va:=getintegerfromgad(EditTagsWindowGads[valuegad]);
      n^.st:=getstringfromgad(EditTagsWindowGads[labelgad]);
    end;
end;

procedure writetagdata;
var
  n : pstringnode;
begin
  gt_setsinglegadgetattr(EditTagsWindowGads[lvgad],edittagswindow,
                         gtlv_labels,~0);
  gt_setsinglegadgetattr(EditTagsWindowGads[lvgad],edittagswindow,
                         gtlv_labels,long(@edittaglist));
  if edittaglistselected<>~0 then
    begin
      gt_setsinglegadgetattr(EditTagsWindowGads[labelgad],edittagswindow,
                             ga_disabled,0);
      gt_setsinglegadgetattr(EditTagsWindowGads[valuegad],edittagswindow,
                             ga_disabled,0);
      gt_setsinglegadgetattr(EditTagsWindowGads[deltaggad],edittagswindow,
                             ga_disabled,0);
      n:=pstringnode(getnthnode(@edittaglist,edittaglistselected));
      gt_setsinglegadgetattr(EditTagsWindowGads[labelgad],edittagswindow,
                             gtst_String,long(n^.ln_name));
      gt_setsinglegadgetattr(EditTagsWindowGads[valuegad],edittagswindow,
                             gtin_number,long(n^.va));
    end
   else
    begin
      gt_setsinglegadgetattr(EditTagsWindowGads[labelgad],edittagswindow,
                             ga_disabled,1);
      gt_setsinglegadgetattr(EditTagsWindowGads[valuegad],edittagswindow,
                             ga_disabled,1);
      gt_setsinglegadgetattr(EditTagsWindowGads[deltaggad],edittagswindow,
                             ga_disabled,1);
    end;
  
end;

Procedure ProcessWindowEditTagsWindow( Class : long ; Code : word ; IAddress : pbyte );
Var
  pgsel : pgadget;
  n : pstringnode;
Begin
  Case Class of
    IDCMP_GADGETUP :
      if inputmode = 0 then
      Begin
        { Gadget message, gadget = pgsel. }
        pgsel:=pgadget(iaddress);
        Case pgsel^.gadgetid of
          lvgad :
            Begin
              readtagdata;
              edittaglistselected:=code;
              writetagdata;
            end;
          labelgad :
            Begin
              { String entered  , Text of gadget : Label }
            end;
          valuegad :
            Begin
              { Integer entered , Text of gadget : Value }
            end;
          tagsave :
            Begin
              readtagdata;
              FreeExtraTags;
              n:=pstringnode(remhead(@edittaglist));
              while n<>nil do
                begin
                  n^.ln_pri:=7;
                  addtail(@knowntaglist,pnode(n));
                  n:=pstringnode(remhead(@edittaglist));
                end;
              shocktagwindows;
              mkdir('Env:Designer');
              mkdir('EnvArc:Designer');
              writecustomtags('Env:Designer/Designer.Tags');
              writecustomtags('EnvArc:Designer/Designer.Tags');
              closewindowedittagswindow;
            end;
          newtaggad :
            Begin
              { Button pressed  , Text of gadget : New }
              readtagdata;
              n:=pstringnode(allocmymem(sizeof(tstringnode),memf_clear));
              if n<>nil then
                begin
                  n^.va:=1;
                  n^.ln_name:=@n^.st[1];
                  n^.st:='New_Tag'#0;
                  Addtail(@edittaglist,pnode(n));
                  edittaglistselected:=sizeoflist(@edittaglist)-1;
                  writetagdata;
                end;
            end;
          deltaggad :
            Begin
              { Button pressed  , Text of gadget : Del }
              if edittaglistselected<>~0 then
                begin
                  n:=pstringnode(getnthnode( @edittaglist, edittaglistselected));
                  remove(pnode(n));
                  FreeMyMem(n,sizeof(tstringnode));
                  if edittaglistselected>0 then
                    dec(edittaglistselected)
                   else
                    if sizeoflist(@edittaglist)=0 then
                      edittaglistselected:=~0;
                  writetagdata;        
                end;
            end;
          tagcancel :
            Begin
              closewindowedittagswindow;
            end;
          taguse :
            Begin
              readtagdata;
              FreeExtraTags;
              n:=pstringnode(remhead(@edittaglist));
              while n<>nil do
                begin
                  n^.ln_pri:=7;
                  addtail(@knowntaglist,pnode(n));
                  n:=pstringnode(remhead(@edittaglist));
                end;
              shocktagwindows;
              mkdir('Env:Designer');
              WriteCustomTags('ENV:Designer/Designer.Tags');
              closewindowedittagswindow;
            end;
         end;
      end;
    IDCMP_CLOSEWINDOW :
      if inputmode = 0 then
        CloseWindowEditTagsWindow;
    IDCMP_MENUPICK :
      Begin
      end;
   end;
end;

Procedure RendWindowEditTagsWindow( pwin:pwindow; vi:pointer  );
Var
  Offx     : word;
  Offy     : word;
  tags     : array[2..3] of ttagitem;
Begin
  If pwin<>nil then
    Begin
      Offx:=pwin^.borderleft;
      Offy:=pwin^.bordertop;
      settagitem(@tags[2],GT_VisualInfo,long(vi));
      settagitem(@tags[3],Tag_Done,0);
      DrawBevelBoxA(pwin^.RPort,4+Offx,2+Offy,
        276,141,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,145+Offy,
        274,19,@tags[2]);
    end;
end;

procedure openwindowEditTagsWindow;
Const
  Gadgetstrings : array[0..7] of string[12]=
  (
  'Custom Tags'#0,
  'Label'#0,
  'Value'#0,
  'Save'#0,
  'New'#0,
  'Del'#0,
  'Cancel'#0,
  'Use'#0
  );
  wintitle : string [30]='Edit Tags Window'#0;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pgad  : pgadget;
  pgad2 : pgadget;
  res   : long;
  pit   : pintuitext;
  objectname : string;
  n : pstringnode;
  psn : pstringnode;
begin
  if EditTagsWindow=nil then
    begin
          
          offx:=myscreen^.WBorLeft;
          offy:=myscreen^.WBorTop+myscreen^.Font^.ta_YSize+1;
          EditTagsWindowVisualInfo:=getvisualinfoa( myscreen, Nil);
          if EditTagsWindowVisualInfo<>nil then
            Begin
              EditTagsWindowDrawInfo:=getscreendrawinfo( myscreen );
              if EditTagsWindowDrawInfo<>nil then
                Begin
                  EditTagsWindowGList:=Nil;
                  pGad:=createcontext(@EditTagsWindowGList);
                  for res:=0 to 7 do
                    EditTagsWindowGads[res]:=nil;
                  Settagitem(@tags[1], GTLV_Selected, 0);
                  Settagitem(@tags[2], Tag_Done, 0);
                  pgad:=GeneralGadToolsGad( 4, offx+10, offy+18, 
                  	264, 93, 0, @gadgetstrings[0,1],
                                           @ttopaz80, 4,
                  	EditTagsWindowVisualInfo, pGad, Nil, @tags[1]);
                  EditTagsWindowGads[0]:=pGad;
                  Settagitem(@tags[1], GTST_MaxChars, 100);
                  Settagitem(@tags[2], STRINGA_Justification, 512);
                  Settagitem(@tags[3], Tag_Done, 0);
                  pgad:=GeneralGadToolsGad( 12, offx+10, offy+112, 
                  	163, 13, 1, @gadgetstrings[1,1],
                                           @ttopaz80, 2,
                  	EditTagsWindowVisualInfo, pGad, Nil, @tags[1]);
                  EditTagsWindowGads[1]:=pGad;
                  Settagitem(@tags[1], STRINGA_Justification, 512);
                  Settagitem(@tags[2], gtin_Maxchars, 12);
                  Settagitem(@tags[3], Tag_Done, 0);
                  pgad:=GeneralGadToolsGad( 3, offx+10, offy+127, 
                  	163, 13, 2, @gadgetstrings[2,1],
                                           @ttopaz80, 2,
                  	EditTagsWindowVisualInfo, pGad, Nil, @tags[1]);
                  EditTagsWindowGads[2]:=pGad;
                  pgad:=GeneralGadToolsGad( 1, offx+10, offy+148, 
                  	85, 13, 3, @gadgetstrings[3,1],
                                           @ttopaz80, 16,
                  	EditTagsWindowVisualInfo, pGad, Nil, Nil);
                  EditTagsWindowGads[3]:=pGad;
                  pgad:=GeneralGadToolsGad( 1, offx+226, offy+112, 
                  	48, 13, 4, @gadgetstrings[4,1],
                                           @ttopaz80, 16,
                  	EditTagsWindowVisualInfo, pGad, Nil, Nil);
                  EditTagsWindowGads[4]:=pGad;
                  pgad:=GeneralGadToolsGad( 1, offx+226, offy+127, 
                  	48, 13, 5, @gadgetstrings[5,1],
                                           @ttopaz80, 16,
                  	EditTagsWindowVisualInfo, pGad, Nil, Nil);
                  EditTagsWindowGads[5]:=pGad;
                  pgad:=GeneralGadToolsGad( 1, offx+187, offy+148, 
                  	85, 13, 6, @gadgetstrings[6,1],
                                           @ttopaz80, 16,
                  	EditTagsWindowVisualInfo, pGad, Nil, Nil);
                  EditTagsWindowGads[6]:=pGad;
                  pgad:=GeneralGadToolsGad( 1, offx+98, offy+148, 
                  	85, 13, 7, @gadgetstrings[7,1],
                                           @ttopaz80, 16,
                  	EditTagsWindowVisualInfo, pGad, Nil, Nil);
                  EditTagsWindowGads[7]:=pGad;
                  if pgad<>nil then
                    begin
                      settagitem(@tags[ 1],WA_Left  ,167);
                      settagitem(@tags[ 2],WA_Top   ,45);
                      settagitem(@tags[ 3],WA_Width ,286+offx);
                      settagitem(@tags[ 4],WA_Height,167+offy);
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
                      settagitem(@tags[17],WA_Gadgets,long(EditTagsWindowglist));
                      settagitem(@tags[18],Tag_Done,0);
                      EditTagsWindow:=openwindowtaglistnicely(Nil,@tags[1],4195196);
                      if EditTagsWindow<>nil then
                        begin
                          edittagswindownode.ln_type:=edittagswindownodetype;
                          edittagswindow^.userdata:=pointer(@edittagswindownode);
                          RendWindowEditTagsWindow( EditTagsWindow,EditTagsWindowVisualInfo );
                          GT_RefreshWindow( EditTagsWindow, Nil);
                          RefreshGList(EditTagsWindowglist, EditTagsWindow,Nil,~0);
                          
                          n:=pstringnode(knowntaglist.lh_tailpred);
                          while (n^.ln_pri = 7) do
                            begin
                              psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_clear));
                              if psn<>nil then
                                begin
                                  addhead(@edittaglist,pnode(psn));
                                  psn^.st:=n^.st;
                                  psn^.va:=n^.va;
                                  psn^.ln_name:=pbyte(@psn^.st[1]);
                                end;
                              n:=n^.ln_pred;
                            end;
                          
                          gt_setsinglegadgetattr(EditTagsWindowGads[lvgad],edittagswindow,
                                                gtlv_labels,long(@edittaglist));
                          gt_setsinglegadgetattr(EditTagsWindowGads[lvgad],edittagswindow,
                                                gtlv_selected,~0);
                          edittaglistselected:=~0;
                          writetagdata;
                        end
                       else
                        Begin
                          FreeScreenDrawInfo(myscreen,EditTagsWindowDrawInfo);
                          FreeVisualInfo(EditTagsWindowVisualInfo);
                          FreeGadgets(EditTagsWindowGList);
                        end;
                    end
                   else
                    Begin
                      FreeScreenDrawInfo(myscreen,EditTagsWindowDrawInfo);
                      FreeVisualInfo(EditTagsWindowVisualinfo);
                    End;
                end
               else
                FreeVisualInfo(EditTagsWindowVisualinfo);
            end;
    
    end
   else
    begin
      WindowToFront(EditTagsWindow);
      activatewindow(EditTagsWindow);
    end;
end;

Procedure CloseWindowEditTagsWindow;
Begin
  if EditTagsWindow<>nil then
    Begin
      FreeScreenDrawInfo(EditTagsWindow^.wscreen,EditTagsWindowDrawInfo);
      Closewindowsafely(EditTagsWindow);
      EditTagsWindow:=Nil;
      FreeVisualInfo(EditTagsWindowVisualinfo);
      FreeGadgets(EditTagsWindowGList);
      freelist(@edittaglist,sizeof(tstringnode));
    end;
end;

Begin
  EditTagsWindow:=Nil;
  NewList(@EditTagList);
End.
