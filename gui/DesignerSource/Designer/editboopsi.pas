Unit editboopsi;

Interface

{
  
pgn data fields
  labelid         = label string
  x,y,w,h
  id
  datas           = class name
  tags[1].ti_tag  = class type
  tags[1].ti_data = scale ?
  tags[2].ti_tag  = create now ?
  tags[2].ti_data = gadget ?
  tags[3].ti_tag  = what is it ?
  tags[4].ti_tag  = dispose ?
  infolist        = list of tmytag

}

uses designermenus,exec,intuition,definitions,routines,amiga,utility,gadtools,graphics,
     colorwheel,gradientslider,amigados,loadsave2,objectmenucustomunit;

Procedure RendWindowEditBoopsiWin(pwin:pwindow; vi:pointer);
procedure openwindowEditBoopsiWin(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure readtagdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure settagdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure setintuitextdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure getintuitextdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure getobjectdatafromwin(pdwn:pdesignerwindownode;pgn:pgadgetnode);

procedure AddCustomTag(s:string;va:long);
procedure WriteCustomTags( f:string );
procedure ReadCustomTags;
procedure FreeExtraTags;
procedure copyobjecttags(l1,l2:plist);

type
  knowntag = record
    value : long;
    name  : string[25];
   end;

Const
  numberofknowntags = 121;

var
  knownnodes : array [0..numberofknowntags] of tnode;
  knowntaglist  : tlist;
  selectlistpos : long;
  t : array[0..3] of pbyte;

const
  
  knowntags : array [0..numberofknowntags] of knowntag =
  (
  ( value: tag_more       ;name: 'TAG_MORE'#0),
  ( value: tag_ignore     ;name: 'TAG_IGNORE'#0),
  ( value: tag_skip       ;name: 'TAG_SKIP'#0),
  ( value: ica_target     ;name: 'ICA_TARGET'#0),
  ( value: ica_map        ;name: 'ICA_MAP'#0),
  ( value: IA_left        ;name: 'IA_Left'#0),
  ( value: ia_top         ;name: 'IA_Top'#0),
  ( value: ia_width       ;name: 'IA_Width'#0),
  ( value: ia_height      ;name: 'IA_Height'#0),
  ( value: ia_fgpen       ;name: 'IA_FGPen'#0),
  ( value: ia_bgpen       ;name: 'IA_BGPen'#0),
  ( value: ia_data        ;name: 'IA_Data'#0),
  ( value: ia_linewidth   ;name: 'IA_LineWidth'#0),
  ( value: ia_pens        ;name: 'IA_Pens'#0),
  ( value: ia_resolution  ;name: 'IA_Resolution'#0),
  ( value: ia_apattern    ;name: 'IA_APattern'#0),
  ( value: ia_apatsize    ;name: 'IA_APatSize'#0),
  ( value: ia_mode        ;name: 'IA_Mode'#0),
  ( value: ia_font        ;name: 'IA_Font'#0),
  ( value: ia_outline     ;name: 'IA_OutLine'#0),
  ( value: ia_recessed    ;name: 'IA_Recessed'#0),
  ( value: ia_doubleemboss;name: 'IA_DoubleEmboss'#0),
  ( value: ia_edgesonly   ;name: 'IA_EdgesOnly'#0),
  ( value: ia_supportsdisable  ;name: 'IA_SupportsDisable'#0),
  ( value: ia_frametype   ;name: 'IA_FrameType'#0),
  ( value: sysia_size     ;name: 'SYSIA_Size'#0),
  ( value: sysia_depth    ;name: 'SYSIA_Depth'#0),
  ( value: sysia_Which    ;name: 'SYSIA_Which'#0),
  ( value: sysia_drawinfo ;name: 'SYSIA_DrawInfo'#0),
  ( value: sysia_referencefont;name: 'SYSIA_ReferenceFont'#0),
  ( value: ga_previous    ;name: 'GA_Previous'#0),
  ( value: ga_left        ;name: 'GA_Left'#0),
  ( value: ga_top         ;name: 'GA_Top'#0),
  ( value: ga_width       ;name: 'GA_Width'#0),
  ( value: ga_height      ;name: 'GA_Height'#0),
  ( value: ga_relright    ;name: 'GA_RelRight'#0),
  ( value: ga_relbottom   ;name: 'GA_RelBottom'#0),
  ( value: ga_relwidth    ;name: 'GA_RelWidth'#0),
  ( value: ga_relheight   ;name: 'GA_RelHeight'#0),
  ( value: ga_intuitext   ;name: 'GA_IntuiText'#0),
  ( value: ga_text        ;name: 'GA_Text'#0),
  ( value: ga_labelimage  ;name: 'GA_LabelImage'#0),
  ( value: ga_image       ;name: 'GA_Image'#0),
  ( value: ga_border      ;name: 'GA_Border'#0),
  ( value: ga_selectrender;name: 'GA_SelectRender'#0),
  ( value: ga_id          ;name: 'GA_ID'#0),
  ( value: ga_userdata    ;name: 'GA_UserData'#0),
  ( value: ga_specialinfo ;name: 'GA_SpecialInfo'#0),
  ( value: ga_gzzgadget   ;name: 'GA_GZZGadget'#0),
  ( value: ga_sysgadget   ;name: 'GA_SysGadget'#0),
  ( value: ga_disabled    ;name: 'GA_Disabled'#0),
  ( value: ga_selected    ;name: 'GA_Selected'#0),
  ( value: ga_endgadget   ;name: 'GA_EndGadget'#0),
  ( value: ga_immediate   ;name: 'GA_Immediate'#0),
  ( value: ga_relverify   ;name: 'GA_RelVerify'#0),
  ( value: ga_followmouse ;name: 'GA_FollowMouse'#0),
  ( value: ga_rightborder ;name: 'GA_RightBorder'#0),
  ( value: ga_leftborder  ;name: 'GA_LeftBorder'#0),
  ( value: ga_topborder   ;name: 'GA_TopBorder'#0),
  ( value: ga_bottomborder;name: 'GA_BottomBorder'#0),
  ( value: ga_toggleselect;name: 'GA_ToggleSelect'#0),
  ( value: ga_tabcycle    ;name: 'GA_TabCycle'#0),
  ( value: ga_highlight   ;name: 'GA_HighLight'#0),
  ( value: ga_sysgtype    ;name: 'GA_SysGType'#0),
  ( value: ga_gadgetHelp  ;name: 'GA_GadgetHelp'#0),
  ( value: ga_bounds      ;name: 'GA_Bounds'#0),
  ( value: ga_relspecial  ;name: 'GA_RelSpecial'#0),
  ( value: GA_DrawInfo    ;name: 'GA_DrawInfo'#0),
  ( value: pga_freedom    ;name: 'PGA_Freedom'#0),
  ( value: pga_newlook    ;name: 'PGA_NewLook'#0),
  ( value: PGA_BorderLess ;name: 'PGA_BorderLess'#0),
  ( value: pga_horizpot   ;name: 'PGA_HorizPot'#0),
  ( value: pga_horizbody  ;name: 'PGA_HorizBody'#0),
  ( value: pga_vertpot    ;name: 'PGA_VertPot'#0),
  ( value: pga_vertbody   ;name: 'PGA_VertBody'#0),
  ( value: pga_top        ;name: 'PGA_Top'#0),
  ( value: pga_visible    ;name: 'PGA_Visible'#0),
  ( value: pga_total      ;name: 'PGA_Total'#0),
  ( value: stringa_longval;name: 'STRINGA_LongVal'#0),
  ( value: stringa_textval;name: 'STRINGA_TextVal'#0),
  ( value: STRINGa_maxchars   ;name: 'STRINGA_MaxChars'#0),
  ( value: stringa_buffer     ;name: 'STRINGA_Buffer'#0),
  ( value: stringa_undobuffer ;name: 'STRINGA_UndoBuffer'#0),
  ( value: stringa_workbuffer ;name: 'STRINGA_WorkBuffer'#0),
  ( value: stringa_bufferpos  ;name: 'STRINGA_BufferPos'#0),
  ( value: stringa_disppos    ;name: 'STRINGA_DispPos'#0),
  ( value: stringa_altkeymap  ;name: 'STRINGA_AltKeyMap'#0),
  ( value: stringa_font       ;name: 'STRINGA_Font'#0),
  ( value: stringa_pens       ;name: 'STRINGA_Pens'#0),
  ( value: stringa_activepens ;name: 'STRINGA_ActivePens'#0),
  ( value: stringa_EditHook   ;name: 'STRINGA_EditHook'#0),
  ( value: stringa_editmodes  ;name: 'STRINGA_EditModes'#0),
  ( value: STRINGA_replacemode;name: 'STRINGA_ReplaceMode'#0),
  ( value: stringa_fixedfieldmode ;name: 'STRINGA_FixedFieldMode'#0),
  ( value: stringa_nofiltermode   ;name: 'STRINGA_NoFilterMode'#0),
  ( value: STRINGA_Justification  ;name: 'STRINGA_Justification'#0),
  ( value: STRINGA_ExitHelp       ;name: 'STRINGA_ExitHelp'#0),
  ( value: wheel_brightness       ;name: 'WHEEL_Brightness'#0),
  ( value: wheel_saturation       ;name: 'WHEEL_Saturation'#0),
  ( value: wheel_red              ;name: 'WHEEL_Red'#0),
  ( value: wheel_bevelbox         ;name: 'WHEEL_BevelBox'#0),
  ( value: wheel_Hue              ;name: 'WHEEL_Hue'#0),
  ( value: wheel_blue             ;name: 'WHEEL_Blue'#0),
  ( value: wheel_abbrv            ;name: 'WHEEL_Abbrv'#0),
  ( value: wheel_Green            ;name: 'WHEEL_Green'#0),
  ( value: wheel_MaxPens          ;name: 'WHEEL_MaxPens'#0),
  ( value: wheel_Screen           ;name: 'WHEEL_Screen'#0),
  ( value: wheel_gradientslider   ;name: 'WHEEL_GradientSlider'#0),
  ( value: wheel_rgb              ;name: 'WHEEL_RGB'#0),
  ( value: WHEEL_HSB              ;name: 'WHEEL_HSB'#0),
  ( value: WHEEL_Donation         ;name: 'WHEEL_Donation'#0),
  ( value: GRAD_MaxVal            ;name: 'GRAD_MaxVal'#0),
  ( value: grad_curval            ;name: 'GRAD_CurVal'#0),
  ( value: grad_skipval           ;name: 'GRAD_SkipVal'#0),
  ( value: grad_penarray          ;name: 'GRAD_PenArray'#0),
  ( value: grad_knobpixels        ;name: 'GRAD_KnobPixels'#0),
  {
  ( value: $800002bd              ;name: 'PUMG_Active'#0),
  ( value: $800002be              ;name: 'PUMG_TextFont'#0),
  ( value: $800002bf              ;name: 'PUMG_NewLook'#0),
  }
  ( value: $80039001              ;name: 'POINTERA_BitMap'#0),
  ( value: $80039002              ;name: 'POINTERA_XOffset'#0),
  ( value: $80039003              ;name: 'POINTERA_YOffset'#0),
  ( value: $80039004              ;name: 'POINTERA_WordWidth'#0),
  ( value: $80039005              ;name: 'POINTERA_XResolution'#0),
  ( value: $80039006              ;name: 'POINTERA_YResolution'#0)
  
  {
  ( value:  ;name: ''#0),
  }
  
  );
  
  ClassTypeGadCycleTexts : array [0..1] of string[8]=
  (
  'Public'#0,
  'Private'#0
  );
  
  TagTypeListGad = 0;
  ClassNameGad = 1;
  ClassTypeGad = 2;
  CreateGad = 3;
  ScaleGad = 4;
  TagListText = 5;
  TagList = 6;
  NewTag = 7;
  DeleteTag = 8;
  TagNumber = 9;
  okgad = 10;
  cancelgad = 11;
  helpgad = 12;
  Select_ti_tag = 13;
  objectlabelgad = 14;
  
  tstrings : array [0..10] of string [17] =
  (
  'BOOLEAN'#0,
  'LONG'#0,
  'STRING'#0,
  'User'#0,
  'Image'#0,
  'Image Data'#0,
  'Array of LONG'#0,
  'Array of BYTE'#0,
  'Array of WORD'#0,
  'Array of STRPTR'#0,
  'List of Strings'#0
  );
  
Var
  TagTypeListGadList      : tlist;
  TagTypeListGadListItems : array [0..numoftagtypes] of tnode;
  ClassTypeGadLabels      : array [0..2] of pbyte;
  EditBoopsiWingads       : array [0..13] of pgadget;
  
Procedure ProcessMenuIDCMPObjectMenu(pdwn:pdesignerwindownode;pgn:pgadgetnode; MenuNumber : word);

Implementation

procedure doit(pdwn:pdesignerwindownode;pgn:pgadgetnode;name:string;i,g:boolean);
var
  pmt : pmytag;
  temps : string;
begin
  pgn^.editwindow^.data4:=~0;
  temps:=name+#0;
  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[classtypegad],pgn^.editwindow^.pwin,
                         gtcy_active,0);
                  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[creategad],pgn^.editwindow^.pwin,
                         gtcb_checked,1);
                  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[scalegad],pgn^.editwindow^.pwin,
                         gtcb_checked,0);
  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                         gtcb_checked,1);
  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcy_active,pgn^.tags[3].ti_data);
  
  pgn^.tags[3].ti_data:=2;
  pmt:=pmytag(remhead(@pgn^.editwindow^.editlist));
  while(pmt<>nil) do
    begin
      freemytag(pmt);
      pmt:=pmytag(remhead(@pgn^.editwindow^.editlist));
    end;
  newlist(@pgn^.editwindow^.editlist);
  if i then
    begin
      pgn^.tags[3].ti_data:=1;
 
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='IA_Left'#0;
          pmt^.value:=ia_left;
          pmt^.tagtype:=tagtypeleftcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='IA_Top'#0;
          pmt^.value:=ia_top;
          pmt^.tagtype:=tagtypetopcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='IA_Width'#0;
          pmt^.value:=ia_width;
          pmt^.tagtype:=tagtypewidthcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='IA_Height'#0;
          pmt^.value:=ia_height;
          pmt^.tagtype:=tagtypeheightcoord;
        end;
    end;
  if g then
    begin
      pgn^.tags[3].ti_data:=0;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='GA_Left'#0;
          pmt^.value:=ga_left;
          pmt^.tagtype:=tagtypeleftcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='GA_Top'#0;
          pmt^.value:=ga_top;
          pmt^.tagtype:=tagtypetopcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='GA_Width'#0;
          pmt^.value:=ga_width;
          pmt^.tagtype:=tagtypewidthcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='GA_Height'#0;
          pmt^.value:=ga_height;
          pmt^.tagtype:=tagtypeheightcoord;
        end;
      pmt:=allocmymem(sizeof(tmytag),memf_clear);
      if pmt<>nil then
        begin
          addtail(@pgn^.editwindow^.editlist,pnode(pmt));
          pmt^.ln_name:=@pmt^.title[1];
          pmt^.title:='GA_ID'#0;
          pmt^.value:=ga_id;
          pmt^.tagtype:=tagtypegadgetid;
        end;
    end;
  
    if name='modelclass' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='ICA_TARGET'#0;
            pmt^.value:=ica_target;
            pmt^.tagtype:=tagtypeobject;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='ICA_Map'#0;
            pmt^.value:=ica_map;
            pmt^.tagtype:=tagtypearraylong;
          end;
      end;
  if name=  'frameiclass' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='IA_Recessed'#0;
            pmt^.value:=ia_recessed;
            pmt^.tagtype:=tagtypeboolean;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='IA_EdgesOnly'#0;
            pmt^.value:=ia_edgesonly;
            pmt^.tagtype:=tagtypeboolean;
          end;
      end;
  if name=  'sysiclass' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='SYSIA_DrawInfo'#0;
            pmt^.value:=sysia_drawinfo;
            pmt^.tagtype:=tagtypedrawinfo;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='SYSIA_Which'#0;
            pmt^.value:=sysia_which;
            pmt^.tagtype:=tagtypelong;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='SYSIA_Size'#0;
            pmt^.value:=sysia_size;
            pmt^.tagtype:=tagtypelong;
          end;
      end;
   if name= 'fillrectclass' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='IA_APattern'#0;
            pmt^.value:=ia_apattern;
            pmt^.tagtype:=tagtypearraylong;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='IA_APatSize'#0;
            pmt^.value:=ia_apatsize;
            pmt^.tagtype:=tagtypelong;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='IA_Mode'#0;
            pmt^.value:=ia_mode;
            pmt^.tagtype:=tagtypelong;
          end;
      end;
    
    if name='colorwheel.gadget' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='WHEEL_Screen'#0;
            pmt^.value:=wheel_screen;
            pmt^.tagtype:=tagtypescreen;
          end;
      end;
    
    if (name='propgclass') or
       (name='proprightborder') or
       (name='propbottomborder') then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='PGA_NewLook'#0;
            pmt^.value:=pga_newlook;
            pmt^.tagtype:=tagtypeboolean;
            pmt^.data:=pointer(1);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='PGA_Top'#0;
            pmt^.value:=pga_top;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(20);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='PGA_visible'#0;
            pmt^.value:=pga_visible;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(20);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='PGA_total'#0;
            pmt^.value:=pga_total;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(100);
          end;
      end;
        
    if name='propbottomborder' then
      begin
        pgn^.tags[3].ti_data:=0;
        pgn^.x:=2;
        temps:='propgclass'#0;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_RelWidth'#0;
            pmt^.value:=ga_relwidth;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(-28);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_Height'#0;
            pmt^.value:=ga_height;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(6);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_RelBottom'#0;
            pmt^.value:=ga_relbottom;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(-7);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_Left'#0;
            pmt^.value:=ga_left;
            pmt^.tagtype:=tagtypeleftcoord;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_BottomBorder'#0;
            pmt^.value:=ga_bottomborder;
            pmt^.tagtype:=tagtypeboolean;
            pmt^.data:=pointer(1);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='PGA_Freedom'#0;
            pmt^.value:=pga_freedom;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(2);
          end;
      end;

    
    if name='proprightborder' then
      begin
        pgn^.tags[3].ti_data:=0;
        pgn^.y:=1;
        temps:='propgclass'#0;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_RelRight'#0;
            pmt^.value:=ga_relright;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(-13);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_RelHeight'#0;
            pmt^.value:=ga_relheight;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(-24);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_Top'#0;
            pmt^.value:=ga_top;
            pmt^.tagtype:=tagtypetopcoord;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_Width'#0;
            pmt^.value:=ga_width;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(10);
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GA_RightBorder'#0;
            pmt^.value:=ga_rightborder;
            pmt^.tagtype:=tagtypeboolean;
            pmt^.data:=pointer(1);
          end;
      end;


    if name='strgclass' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='STRINGA_TextVal'#0;
            pmt^.value:=stringa_textval;
            pmt^.tagtype:=tagtypestring;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='STRINGA_MaxChars'#0;
            pmt^.value:=stringa_maxchars;
            pmt^.tagtype:=tagtypelong;
            pmt^.data:=pointer(12);
          end;
      end;
    if name='gradientslider.gadget' then
      begin
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GRAD_MaxVal'#0;
            pmt^.value:=grad_maxval;
            pmt^.tagtype:=tagtypelong;
          end;
        pmt:=allocmymem(sizeof(tmytag),memf_clear);
        if pmt<>nil then
          begin
            addtail(@pgn^.editwindow^.editlist,pnode(pmt));
            pmt^.ln_name:=@pmt^.title[1];
            pmt^.title:='GRAD_PenArray'#0;
            pmt^.value:=grad_penarray;
            pmt^.tagtype:=tagtypearraylong;
          end;
      end;
  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                           gtcy_active,pgn^.tags[3].ti_data);
  
  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                         gtst_string,long(@temps[1]));
    
  settagdata(pdwn,pgn);
end;

procedure getobjectdatafromwin(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pmt : pmytag;
begin
                readtagdata(pdwn,pgn);
                pgn^.tags[1].ti_tag:=pgn^.editwindow^.data;
                pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[14]);
                pgn^.datas:=getstringfromgad(pgn^.editwindow^.gads[1]);
                pgn^.tags[1].ti_data:=long(checkedbox(pgn^.editwindow^.gads[4]));
                pgn^.tags[2].ti_tag:=long(checkedbox(pgn^.editwindow^.gads[3]));
                pgn^.tags[3].ti_tag:=pgn^.tags[3].ti_data;
                
                pmt:=pmytag(remhead(@pgn^.infolist));
                while (pmt<>nil) do
                  begin
                    freemytag(pmt);
                    pmt:=pmytag(remhead(@pgn^.infolist));
                  end;
                
                newlist(@pgn^.infolist);
                
                copyobjecttags(@pgn^.editwindow^.editlist,@pgn^.infolist);
                
                pgn^.tags[4].ti_tag:=long(checkedbox(pgn^.editwindow^.gads[18]));

end;

procedure copyobjecttags(l1,l2:plist);
var
  pmt,pmt2:pmytag;
begin
  newlist(l2);
  pmt:=pmytag(l1^.lh_head);
  while (pmt^.ln_succ<>nil) do
    begin
      pmt2:=pmytag(allocmymem(sizeof(tmytag),memf_clear));
      if pmt2<>nil then
        begin
          addtail(l2,pnode(pmt2));
          pmt2^.ln_name:=@pmt2^.title[1];
          pmt2^.title:=pmt^.title;
          pmt2^.tagtype:=pmt^.tagtype;
          pmt2^.value:=pmt^.value;
          if pmt^.sizebuffer=0 then
            begin
              pmt2^.data:=pmt^.data;
            end
           else
            begin
              pmt2^.data:=allocmymem(pmt^.sizebuffer,memf_any);
              if pmt2^.data<>nil then
                begin
                  pmt2^.sizebuffer:=pmt^.sizebuffer;
                  copymem(pmt^.data,pmt2^.data,pmt2^.sizebuffer);
                  fixmytagdatapointers(pmt2);
                end;
             end;
        end;
      pmt:=pmt^.ln_succ;
    end;
end;

procedure cloneandadd(pgn:pgadgetnode);
var
  pgn2 : pgadgetnode;
  pmt  : pmytag;
begin
  pgn2:=allocmymem(sizeof(tgadgetnode),memf_clear);
  if pgn2<>nil then
    begin
      copymem(pgn,pgn2,sizeof(tgadgetnode));
      newlist(@pgn2^.infolist);
      copyobjecttags(@pgn^.infolist,@pgn2^.infolist);
      pgn2^.ln_name:=@pgn2^.labelid[1];
      addtail(@presetobjectlist,pnode(pgn2));
      pmt:=pmytag(pgn2^.infolist.lh_head);
      while (pmt^.ln_succ<>nil) do
        begin
          if pmt^.tagtype=tagtypeobject then
                pmt^.data:=nil;
          if pmt^.tagtype=tagtypeimagedata then
                pmt^.data:=nil;
          if pmt^.tagtype=tagtypeimage then
                pmt^.data:=nil;
          pmt:=pmt^.ln_succ;
        end;
    end
   else
    telluser(nil,memerror);
end;

Procedure copyfromuserpreset(pdwn:pdesignerwindownode;pgn,preset:pgadgetnode);
var
  pmt : pmytag;
begin
  if preset<>nil then
    if pgn<>nil then
      if pgn^.editwindow<>nil then
        begin
          pmt:=pmytag(remhead(@pgn^.editwindow^.editlist));
          while(pmt<>nil) do
            begin
              freemytag(pmt);
              pmt:=pmytag(remhead(@pgn^.editwindow^.editlist));
            end;
          newlist(@pgn^.editwindow^.editlist);
          copyobjecttags(@preset^.infolist,@pgn^.editwindow^.editlist);
          pgn^.editwindow^.data4:=~0;
          pgn^.editwindow^.data:=pgn^.tags[1].ti_tag;
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[classtypegad],pgn^.editwindow^.pwin,
                         gtcy_active,long(preset^.tags[1].ti_tag));
                  
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[creategad],pgn^.editwindow^.pwin,
                         gtcb_checked,long(preset^.tags[2].ti_tag));
                  
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[scalegad],pgn^.editwindow^.pwin,
                         gtcb_checked,long(preset^.tags[1].ti_data));
  
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                 gtcb_checked,long(preset^.tags[4].ti_tag));
          
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
          
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                           gtcy_active,preset^.tags[3].ti_tag);
          
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                 gtst_string,long(@preset^.datas[1]));
  
          settagdata(pdwn,pgn);

        end;
end;

procedure updateobjectmenus;
var
  pdwn : pdesignerwindownode;
  pgn  : pgadgetnode;
begin
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while(pdwn^.ln_succ<>nil) do
    begin
      if pdwn^.editscreen<>nil then
        begin
          pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.kind=myobject_kind then
                begin
                  if pgn^.editwindow<>nil then
                    begin
                      clearmenustrip(pgn^.editwindow^.pwin);
                    end;
                end;
              pgn:=pgn^.ln_succ;
            end;
      
          if pdwn^.objectmenu<>nil then
            freemenus(pdwn^.objectmenu);
          pdwn^.objectmenu:=nil;
          if makemenuobjectmenu(pdwn^.helpwin.screenvisinfo) then
            pdwn^.objectmenu:=objectmenu;
          
          pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.kind=myobject_kind then
                begin
                  if pgn^.editwindow<>nil then
                    begin
                      if setmenustrip(pgn^.editwindow^.pwin,pdwn^.objectmenu) then;
                    end;
                end;
              pgn:=pgn^.ln_succ;
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
end;

Procedure ProcessMenuIDCMPObjectMenu(pdwn:pdesignerwindownode;pgn:pgadgetnode; MenuNumber : word);
Var
  ItemNumber : Word;
  SubNumber  : Word;
  Done    : Boolean;
  Item    : pMenuItem;
Begin
  Done:=False;
  while (MenuNumber<>MENUNULL) and (Not Done) do
    Begin
      Item:=ItemAddress( pdwn^.ObjectMenu, MenuNumber);
      ItemNumber:=ITEMNUM(MenuNumber);
      SubNumber:=SUBNUM(MenuNumber);
      MenuNumber:=MENUNUM(MenuNumber);
      Case MenuNumber of
        objectmenu4 :
          if itemnumber<>noitem then
            begin
              copyfromuserpreset(pdwn,pgn,pgadgetnode(getnthnode(@presetobjectlist,itemnumber)));
            end;
        ObjectMenu3 :
          case itemnumber of
            useaspreset  : 
              begin
                waiteverything;
                getobjectdatafromwin(pdwn,pgn);
                writepresetobject('Env:Designer/',pgn);
                cloneandadd(pgn);
                updateobjectmenus;
                unwaiteverything;
                inputmode:=1;
              end;
            saveaspreset :
              begin
                waiteverything;
                getobjectdatafromwin(pdwn,pgn);
                writepresetobject('Env:Designer/',pgn);
                writepresetobject('EnvArc:Designer/',pgn);
                cloneandadd(pgn);
                updateobjectmenus;
                unwaiteverything;
                inputmode:=1;
              end;
           end;
        ObjectMenu2 :
          Case ItemNumber of
            objectmenucustom :
              Case  SubNumber of
                ObjectMenuproprightborder :
                  Begin
                    doit(pdwn,pgn,'proprightborder',false,false);
                  end;
                ObjectMenupropbottomborder :
                  Begin
                    doit(pdwn,pgn,'propbottomborder',false,false);
                  end;
               end;
            ObjectMenuicclass :
              Case  SubNumber of
                ObjectMenumodelclass :
                  Begin
                    doit(pdwn,pgn,'modelclass',false,false);
                  end;
               end;
            ObjectMenuimageclass :
              Case  SubNumber of
                objectmenuimageclasssubitem :
                  Begin
                    doit(pdwn,pgn,'imageclass',true,false);
                  end;
                ObjectMenuframeiclass :
                  Begin
                    doit(pdwn,pgn,'frameiclass',true,false);
                  end;
                ObjectMenusysiclass :
                  Begin
                    doit(pdwn,pgn,'sysiclass',true,false);
                  end;
                ObjectMenufillrectclass :
                  Begin
                    doit(pdwn,pgn,'fillrectclass',true,false);
                  end;
                ObjectMenuitexticlass :
                  Begin
                    doit(pdwn,pgn,'itexticlass',true,false);
                  end;
               end;
            ObjectMenugadgetclass :
              Case  SubNumber of
                ObjectMenupropgclass :
                  Begin
                    doit(pdwn,pgn,'propgclass',false,true);
                  end;
                ObjectMenustrgclass :
                  Begin
                    doit(pdwn,pgn,'strgclass',false,true);
                  end;
                ObjectMenubuttongclass :
                  Begin
                    doit(pdwn,pgn,'buttongclass',false,true);
                  end;
                ObjectMenufrbuttongclass :
                  Begin
                    doit(pdwn,pgn,'frbuttonclass',false,true);
                  end;
                ObjectMenugroupgclass :
                  Begin
                    doit(pdwn,pgn,'groupgclass',false,true);
                  end;
               end;
            ObjectMenugradientslider :
              Begin
                doit(pdwn,pgn,'gradientslider.gadget',false,true);
              end;
            ObjectMenucolorwheel :
              Begin
                doit(pdwn,pgn,'colorwheel.gadget',false,true);
              end;
           end;
       end;
      MenuNumber:=menunull;
    end;
end;

procedure setintuitextdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pni  : pnumberitem;
  loop : word;
  test : long;
begin
  if pgn^.editwindow^.data3<>~0 then
    begin
      for loop:= 20 to 31 do
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[loop],pgn^.editwindow^.pwin,
                                 ga_disabled,0);
      
      pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
      
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                             gtin_number,pni^.words[1]);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[21],pgn^.editwindow^.pwin,
                             gtin_number,pni^.words[2]);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[22],pgn^.editwindow^.pwin,
                             gtpa_color,pni^.words[3]);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[23],pgn^.editwindow^.pwin,
                             gtpa_color,pni^.words[4]);
      
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[28],pgn^.editwindow^.pwin,
                             gtst_string,long(@pni^.title[1]));
      
      if pgn^.editwindow^.data3=0 then
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[29],pgn^.editwindow^.pwin,
                               ga_disabled,1);
      if pgn^.editwindow^.data3=sizeoflist(@pgn^.editwindow^.extralist)-1 then
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[30],pgn^.editwindow^.pwin,
                               ga_disabled,1);
      
      test := long((pni^.words[5] and inversvid)<>0);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[27],pgn^.editwindow^.pwin,
                             gtcb_checked,test);
      
      test := long( ((pni^.words[5] and ~inversvid) )=jam1);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[24],pgn^.editwindow^.pwin,
                             gtcb_checked,test);
      test := long( ((pni^.words[5] and ~inversvid) )=jam2);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                             gtcb_checked,test);
      test := long( ((pni^.words[5] and ~inversvid) )=complement);
      gt_setsinglegadgetattr(pgn^.editwindow^.gads[26],pgn^.editwindow^.pwin,
                             gtcb_checked,test);
      
    end
   else
    begin
      for loop:= 20 to 31 do
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[loop],pgn^.editwindow^.pwin,
                               ga_disabled,1);
    end;
end;

procedure getintuitextdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pni : pnumberitem;
begin
  if pgn^.editwindow^.data3<>~0 then
    begin
      pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
      pni^.words[1]:=getintegerfromgad(pgn^.editwindow^.gads[20]);
      pni^.words[2]:=getintegerfromgad(pgn^.editwindow^.gads[21]);
      pni^.words[5]:=0;
      if checkedbox(pgn^.editwindow^.gads[24]) then
        pni^.words[5]:=jam1;
      if checkedbox(pgn^.editwindow^.gads[25]) then
        pni^.words[5]:=jam2;
      if checkedbox(pgn^.editwindow^.gads[26]) then
        pni^.words[5]:=complement;
      if checkedbox(pgn^.editwindow^.gads[27]) then
        pni^.words[5]:=pni^.words[5] or inversvid;
      pni^.title:=getstringfromgad(pgn^.editwindow^.gads[28]);
    end;
end;

procedure readtagdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pmt : pmytag;
  st  : string;
  loop,n:long;
  pla : plongarray;
  pwa : pwordarray2;
  pba : pbytearray;
  pni : pnumberitem;
  itstore : tintuitext;
  previt : pintuitext;
  loop2  : long;
  pn : pnode;
begin
  if pgn^.editwindow<>nil then
    if pgn^.editwindow^.data4<>~0 then
      begin
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                  
        pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
        pmt^.value:=getintegerfromgad(pgn^.editwindow^.gads[tagnumber]);
        pmt^.title:=getstringfromgad(pgn^.editwindow^.gads[taglisttext]);
        case pmt^.tagtype of
          
          tagtypeintuitext,tagtypeborder :
            begin
              previt:=nil;
              if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                freemymem(pmt^.data,pmt^.sizebuffer);
              pmt^.data:=nil;
              pmt^.sizebuffer:=0;
              getintuitextdata(pdwn,pgn);
              loop:=0;
              if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                begin
                  pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                  while (pni^.ln_succ<>nil) do
                    begin
                      loop:=loop+  ((length(no0(pni^.title))+1+1)div 2)*2  +sizeof(tintuitext);
                      pni:=pni^.ln_succ;
                    end;
                  if (loop>0) then
                    begin
                      pmt^.data:=allocmymem(loop,memf_clear or memf_any);
                      if pmt^.data<>nil then
                        begin
                          pmt^.sizebuffer:=loop;
                          loop:=0;
                          pba:=pbytearray(pmt^.data);
                          pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                          while (pni^.ln_succ<>nil) do
                            begin
                              itstore.nexttext:=nil;
                              if previt<>nil then
                                previt^.nexttext:=@pba^[loop];
                              previt:=@pba^[loop];
                              
                              itstore.leftedge:=pni^.words[1];
                              itstore.topedge:=pni^.words[2];
                              itstore.frontpen:=pni^.words[3];
                              itstore.backpen:=pni^.words[4];
                              itstore.drawmode:=pni^.words[5];
                              itstore.itextfont:=nil;
                              itstore.itext:=pointer(long(@pba^[loop])+sizeof(tintuitext));
                              
                              copymem(@itstore,@pba^[loop],sizeof(tintuitext));
                              inc(loop,sizeof(tintuitext));
                              
                              copymem(@pni^.title[1],@pba^[loop],length(no0(pni^.title)));
                              loop:=loop+length(no0(pni^.title))+1;
                              pba^[loop-1]:=0;
                              loop:=((loop+1)div 2)*2;
                              pni:=pni^.ln_succ;
                            end;
                        end
                       else
                        telluser(pgn^.editwindow^.pwin,memerror);
                    end;
                end;
            end;

          
          tagtypeboolean :
            begin
              pmt^.data:=pointer(long(checkedbox(pgn^.editwindow^.gads[20])));
            end;
          tagtypelong :
            begin
              pmt^.data:=pointer(long(getintegerfromgad(pgn^.editwindow^.gads[20])));
            end;
          tagtypestring,tagtypeuser,tagtypeuser2 :
            begin
              if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                freemymem(pmt^.data,pmt^.sizebuffer);
              st:=getstringfromgad(pgn^.editwindow^.gads[20]);
              pmt^.data:=allocmymem(length(st)+4,memf_clear or memf_any);
              pmt^.sizebuffer:=0;
              if pmt^.data<>nil then
                begin
                  pmt^.sizebuffer:=length(st)+4;
                  copymem(@st[1],pmt^.data,pmt^.sizebuffer);
                end
               else
                telluser(pgn^.editwindow^.pwin,memerror);
            end;
          tagtypeimage,tagtypeimagedata :
            begin
              if pgn^.editwindow^.data2=~0 then
                pmt^.data:=nil
               else
                begin
                  pmt^.data:=getnthnode(@teditimagelist,pgn^.editwindow^.data2);
                end;
            end;
          tagtypearraystring :
            begin
              if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                freemymem(pmt^.data,pmt^.sizebuffer);
              pmt^.data:=nil;
              pmt^.sizebuffer:=0;
              if pgn^.editwindow^.data3<>~0 then
                begin
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                end;
              loop:=0;
              if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                begin
                  pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                  while (pni^.ln_succ<>nil) do
                    begin
                      loop:=loop+length(no0(pni^.title))+1+4;
                      pni:=pni^.ln_succ;
                    end;
                  if loop>0 then
                    loop:=loop+4;
                  if (loop>0) then
                    begin
                      pmt^.data:=allocmymem(loop,memf_clear or memf_any);
                      if pmt^.data<>nil then
                        begin
                          loop2:=0;
                          pla:=plongarray(pmt^.data);
                          pmt^.sizebuffer:=loop;
                          loop:=4*sizeoflist(@pgn^.editwindow^.extralist)+4;
                          pba:=pbytearray(pmt^.data);
                          pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                          while (pni^.ln_succ<>nil) do
                            begin
                              pla^[loop2]:=long(@pba^[loop]);
                              inc(loop2);
                              copymem(@pni^.title[1],@pba^[loop],length(no0(pni^.title)));
                              loop:=loop+length(no0(pni^.title))+1;
                              pba^[loop-1]:=0;
                              pni:=pni^.ln_succ;
                            end;
                          pla^[loop2]:=0;
                        end
                       else
                        telluser(pgn^.editwindow^.pwin,memerror);
                    end;
                end;
            end;
          tagtypestringlist :
            begin
              if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                freemymem(pmt^.data,pmt^.sizebuffer);
              pmt^.data:=nil;
              pmt^.sizebuffer:=0;
              if pgn^.editwindow^.data3<>~0 then
                begin
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                end;
              loop:=0;
              if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                begin
                  pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                  while (pni^.ln_succ<>nil) do
                    begin
                      loop:=loop+  ((length(no0(pni^.title))+2) div 2)*2  +sizeof(tnode);
                      pni:=pni^.ln_succ;
                    end;
                  if loop>0 then
                    loop:=loop+sizeof(tlist);
                  if (loop>0) then
                    begin
                      pmt^.data:=allocmymem(loop,memf_clear or memf_any);
                      if pmt^.data<>nil then
                        begin
                          newlist(plist(pmt^.data));
                          pmt^.sizebuffer:=loop;
                          loop:=sizeof(tlist);
                          pba:=pbytearray(pmt^.data);
                          pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                          while (pni^.ln_succ<>nil) do
                            begin
                              pn:=pnode(@pba^[loop]);
                              addtail(plist(pmt^.data),pn);
                              pn^.ln_name:=@pba^[loop+sizeof(tnode)];
                              inc(loop,sizeof(tnode));
                              copymem(@pni^.title[1],@pba^[loop],length(no0(pni^.title)));
                              loop:=loop+length(no0(pni^.title))+1;
                              pba^[loop-1]:=0;
                              loop := ((loop+1) div 2)*2;
                              pni:=pni^.ln_succ;
                            end;
                        end
                       else
                        telluser(pgn^.editwindow^.pwin,memerror);
                    end;
                end;
            end;

          tagtypearraylong,tagtypearrayword,tagtypearraybyte :
            begin
              
              if pgn^.editwindow^.data3<>~0 then
                begin
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                  if pmt^.tagtype=tagtypearrayword then
                    pni^.num:=pni^.num and 65535
                   else
                    if pmt^.tagtype=tagtypearraybyte then
                      pni^.num:=pni^.num and 255;
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                       gtin_number,long(pni^.num));
                end;
           
              if pmt^.tagtype=tagtypearraylong then
                n:=4
               else
                if pmt^.tagtype=tagtypearraybyte then
                  n:=1
                 else
                  if pmt^.tagtype=tagtypearrayword then
                    n:=2;
              
              if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                freemymem(pmt^.data,pmt^.sizebuffer);
              pmt^.data:=nil;
              pmt^.sizebuffer:=0;
              if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                begin
                  pmt^.data:=allocmymem(n*sizeoflist(@pgn^.editwindow^.extralist),memf_clear or memf_any);
                  if pmt^.data<>nil then
                    begin
                      pba:=pbytearray(pmt^.data);
                      pwa:=pwordarray2(pmt^.data);
                      pla:=plongarray(pmt^.data);
                      pmt^.sizebuffer:=n*sizeoflist(@pgn^.editwindow^.extralist);
                      loop:=0;
                      pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                      while (pni^.ln_succ<>nil) do
                        begin
                          if pmt^.tagtype=tagtypearraylong then
                            pla^[loop]:=pni^.num
                           else
                            if pmt^.tagtype=tagtypearraybyte then
                              pba^[loop]:=pni^.num
                             else
                              if pmt^.tagtype=tagtypearrayword then
                                pwa^[loop]:=pni^.num;
                          inc(loop);
                          pni:=pni^.ln_succ;
                        end;
                    end
                   else
                    telluser(pgn^.editwindow^.pwin,memerror);
                end;
            end;    
         end;
        gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
      end;
end;

procedure Settagdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
const
  selectstring : string[13] = 'Select Tag'#0;
  up : array[1..5] of string[7] =
  (
  'New'#0,
  'Up'#0,
  'Down'#0,
  'Delete'#0,
  'Data'#0
  );
  thesestrings : array[1..15] of string[12]=
  (
  'Left'#0,
  'Top'#0,
  'FGPen'#0,
  'BGPen'#0,
  'JAM1'#0,
  'JAM2'#0,
  'COMPLEMENT'#0,
  'INVERSVID'#0,
  'Text'#0,
  '<<'#0,
  'New'#0,
  '>>'#0,
  'Delete'#0,
  'Nums'#0,
  'Gadgets'#0
  );
var
  pmt  : pmytag;
  pgad : pgadget;
  pos  : long;
  str  : pbyte;
  offx,offy : word;
  tags  : array [1..5] of ttagitem;
  n,loop : word;
  pni  : pnumberitem;
  pba : pbytearray;
  pwa : pwordarray2;
  pla : plongarray;
  s   : string;
  previt : pintuitext;
  pn : pnode;
  pl : plist;
begin
  
  if pgn^.editwindow<>nil then
    begin
      if pgn^.editwindow^.glist2<>nil then
        begin
          pos:=removeglist(pgn^.editwindow^.pwin,pgn^.editwindow^.glist2,-1);
          freegadgets(pgn^.editwindow^.glist2);
        end;
      pgn^.editwindow^.glist2:=nil;
      
      Offx:=pgn^.editwindow^.pwin^.borderleft;
      Offy:=pgn^.editwindow^.pwin^.bordertop;
      
      setdrmd(pdwn^.editwindow^.rport,jam1);
      setapen(pgn^.editwindow^.pwin^.rport,0);
      rectfill(pgn^.editwindow^.pwin^.rport,offx+270,offy+74,315+offx+269,89+offy+73);
      
      if pgn^.editwindow^.data4<>~0 then
        begin
          pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
        
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglisttext],pgn^.editwindow^.pwin,
                                 ga_disabled,long(false));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagnumber],pgn^.editwindow^.pwin,
                                 ga_disabled,long(false));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagtypelistgad],pgn^.editwindow^.pwin,
                                 ga_disabled,long(false));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[select_ti_tag],pgn^.editwindow^.pwin,
                                 ga_disabled,long(false));
        
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglisttext],pgn^.editwindow^.pwin,
                                 gtst_string,long(@pmt^.title[1]));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagnumber],pgn^.editwindow^.pwin,
                                 gtin_number,long(pmt^.value));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagtypelistgad],pgn^.editwindow^.pwin,
                                 gtlv_selected,long(pmt^.tagtype));
          
          pgad:=createcontext(@pgn^.editwindow^.glist2);
          if pgad<>nil then
            begin
              case pmt^.tagtype of
                tagtypeintuitext,tagtypeborder :
                  begin
                    
                    freelist(@pgn^.editwindow^.extralist,sizeof(tnumberitem));
                    
                    
                    { create list }
                    
                    s:='';
                    
                    pba:=pointer(pmt^.data);
                    
                    if (pmt^.sizebuffer>0) then
                      begin
                        loop:=0;
                        
                        previt:=pointer(@pba^[loop]);
                        inc(loop,sizeof(tintuitext));
                                
                        while (loop<pmt^.sizebuffer) do
                          begin
                            
                            if pba^[loop]=0 then
                              begin
                                pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                                if pni<>nil then
                                  begin
                                    addtail(@pgn^.editwindow^.extralist,pnode(pni));
                                    pni^.title:=s+#0;
                                    pni^.words[1]:=previt^.leftedge;
                                    pni^.words[2]:=previt^.topedge;
                                    pni^.words[3]:=previt^.frontpen;
                                    pni^.words[4]:=previt^.backpen;
                                    pni^.words[5]:=previt^.drawmode;
                                    s:='';
                                  end;
                                loop := loop+1;
                                loop:=((loop+1)div 2)*2;
                                previt:=pointer(@pba^[loop]);
                                inc(loop,sizeof(tintuitext)-1);
                              end
                             else
                              begin
                                s:=s+chr(pba^[loop]);
                              end;
                            inc(loop);
                          end;
                      end;

                    
                    if sizeoflist(@pgn^.editwindow^.extralist)=0 then
                      pgn^.editwindow^.data3:=~0
                     else
                      pgn^.editwindow^.data3:=0;
                    
                    settagitem(@tags[1],stringa_justification,gact_Stringcenter);
                    settagitem(@tags[2],0,0);
                    if pgn^.editwindow^.data3=0 then
                      begin
                        pni:=pnumberitem(pgn^.editwindow^.extralist.lh_head);
                        settagitem(@tags[2],gtin_number,pni^.words[1]);
                      end
                     else
                      settagitem(@tags[2],ga_disabled,1);
                    settagitem(@tags[3], gtin_maxchars, 12);
          
                    settagitem(@tags[4],0,0);
                    pgad:=GeneralGadToolsGad( integer_kind, offx+274, offy+76, 
          	                                 100, 13, 2005, @thesestrings[1,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[2],gtin_number,pni^.words[2]);
                    pgad:=GeneralGadToolsGad( integer_kind, offx+434, offy+76, 
          	                                 100, 13, 2006, @thesestrings[2,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[21]:=pGad;
                    
                    settagitem(@tags[1],gtpa_depth,pdwn^.screenprefs.sm_depth);
                    settagitem(@tags[2],gtpa_indicatorwidth,15);
                    settagitem(@tags[3],0,0);
                    settagitem(@tags[4],0,0);
                    
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[3],gtpa_color,pni^.words[3])
                     else
                      settagitem(@tags[3],ga_disabled,1);
                   
                    pgad:=GeneralGadToolsGad( palette_kind, offx+274, offy+91, 
          	                                 100, 13, 2007, @thesestrings[3,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[22]:=pGad;
                    
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[3],gtpa_color,pni^.words[4]);

                    pgad:=GeneralGadToolsGad( palette_kind, offx+434, offy+91, 
          	                                 100, 13, 2008, @thesestrings[4,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[23]:=pGad;
                    
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[1],gtcb_checked,long((pni^.words[5] and ~INVERSVID)=jam1))
                     else
                      settagitem(@tags[1],ga_disabled,1);
                    settagitem(@tags[2],0,0);
                    
                    pgad:=GeneralGadToolsGad( checkbox_kind, offx+274, offy+106, 
          	                                 26, 11, 2009, @thesestrings[5,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[24]:=pGad;
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[1],gtcb_checked,long((pni^.words[5] and ~INVERSVID)=jam2));
                    
                    pgad:=GeneralGadToolsGad( checkbox_kind, offx+434, offy+106, 
          	                                 26, 11, 2010, @thesestrings[6,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[25]:=pGad;
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[1],gtcb_checked,long((pni^.words[5] and ~INVERSVID)=complement));
                    
                    pgad:=GeneralGadToolsGad( checkbox_kind, offx+274, offy+119, 
          	                                 26, 11, 2011, @thesestrings[7,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[26]:=pGad;
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[1],gtcb_checked,long((pni^.words[5] and INVERSVID)));
                    
                    pgad:=GeneralGadToolsGad( checkbox_kind, offx+434, offy+119, 
          	                                 26, 11, 2012, @thesestrings[8,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[27]:=pGad;
                    
                    settagitem(@tags[1],stringa_justification,gact_Stringcenter);
                    if pgn^.editwindow^.data3=0 then
                      settagitem(@tags[2],gtst_string,long(@pni^.title[1]))
                     else
                      settagitem(@tags[2],ga_disabled,1);
                    settagitem(@tags[3],0,0);
                    
                    if pmt^.tagtype=tagtypeborder then
                      str:=@thesestrings[14,1]
                     else
                      str:=@thesestrings[9,1];
                    
                    pgad:=GeneralGadToolsGad( string_kind, offx+274, offy+132, 
          	                                 260, 13, 2013, str,
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[28]:=pGad;
                    
                    settagitem(@tags[2],ga_disabled,1);
                    
                    pgad:=GeneralGadToolsGad( button_kind, offx+274, offy+147, 
          	                                 70, 13, 2014, @thesestrings[10,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
                    pgn^.editwindow^.gads[29]:=pGad;
                    pgad:=GeneralGadToolsGad( button_kind, offx+274+79, offy+147, 
          	                                 70, 13, 2015, @thesestrings[11,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, nil);
                    
                    if sizeoflist(@pgn^.editwindow^.extralist)>1 then
                      settagitem(@tags[2],ga_disabled,0);
                    
                    pgad:=GeneralGadToolsGad( button_kind, offx+274+237, offy+147, 
          	                                 70, 13, 2016, @thesestrings[12,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
                    pgn^.editwindow^.gads[30]:=pGad;
                    
                    if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                      settagitem(@tags[2],ga_disabled,0);
                    
                    pgad:=GeneralGadToolsGad( button_kind, offx+274+158, offy+147, 
          	                                 70, 13, 2017, @thesestrings[13,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
                    pgn^.editwindow^.gads[31]:=pGad;
                   
                    
                  end;
                tagtypeboolean :
                  begin
                    settagitem(@tags[1],gtcb_checked,long(pmt^.data));
                    settagitem(@tags[2],0,0);
                    pgad:=GeneralGadToolsGad( checkbox_kind, offx+385, offy+112, 
          	                                 26, 11, 99, @tstrings[0,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                  end;
                tagtypelong :
                  begin
                    settagitem(@tags[1],gtin_number,long(pmt^.data));
                    settagitem(@tags[2],stringa_justification,gact_stringcenter);
                    settagitem(@tags[3], gtin_maxchars, 12);
                    settagitem(@tags[4],0,0);
                    pgad:=GeneralGadToolsGad( integer_kind, offx+315, offy+111, 
          	                                 200, 13, 99, @tstrings[1,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                  end;
                
                tagtypevisualinfo :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass VisualInfo',1,0,@ttopaz80);
                
                tagtypedrawinfo :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass DrawInfo',1,0,@ttopaz80);
                
                tagtypeleftcoord :
                  printstring(pgn^.editwindow^.pwin,offx+335,offy+111,'Pass Left Coordinate',1,0,@ttopaz80);
                
                tagtypetopcoord :
                  printstring(pgn^.editwindow^.pwin,offx+335,offy+111,'Pass Top Coordinate',1,0,@ttopaz80);
                
                tagtypescreen :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass Screen',1,0,@ttopaz80);
                
                tagtypeselect :
                  begin
                    
                    settagitem(@tags[1],gtlv_labels,long(@knowntaglist));
                    
                    settagitem(@tags[2],gtlv_top,selectlistpos);
                    settagitem(@tags[3],0,0);
                    
                    pgad:=GeneralGadToolsGad( listview_kind, offx+274, offy+90, 
          	                                 307, 70, 10997, @selectstring[1],
                                             @ttopaz80, placetext_above,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                    
                  end;
                
                tagtypefont :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass Gadget Font',1,0,@ttopaz80);
                
                tagtypewidthcoord :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass Width',1,0,@ttopaz80);
                
                tagtypeheightcoord :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass Height',1,0,@ttopaz80);
                
                tagtypegadgetid :
                  printstring(pgn^.editwindow^.pwin,offx+365,offy+111,'Pass Gadget ID',1,0,@ttopaz80);
                
                tagtypestring,tagtypeuser,tagtypeuser2 :
                  begin
                    settagitem(@tags[1],gtst_string,long(pmt^.data));
                    settagitem(@tags[2],stringa_justification,gact_stringcenter);
                    settagitem(@tags[3],0,0);
                    
                    if pmt^.tagtype = tagtypestring then
                      str:= @tstrings[2,1]
                     else
                      str:= @tstrings[3,1];
                    
                    pgad:=GeneralGadToolsGad( string_kind, offx+315, offy+111, 
          	                                 200, 13, 99, str,
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                  end;
                tagtypearraylong,tagtypearrayword,tagtypearraybyte,tagtypearraystring,tagtypestringlist :
                  begin
                    
                    if pmt^.tagtype=tagtypearraylong then
                      n:=4
                     else
                      if pmt^.tagtype=tagtypearraybyte then
                        n:=1
                       else
                        if pmt^.tagtype=tagtypearrayword then
                          n:=2;
                    
                    pba:=pbytearray(pmt^.data);
                    pwa:=pwordarray2(pmt^.data);
                    pla:=plongarray(pmt^.data);
                    
                    freelist(@pgn^.editwindow^.extralist,sizeof(tnumberitem));
                    
                    if (pmt^.sizebuffer>0) and (pmt^.tagtype<>tagtypearraystring) and (pmt^.tagtype<>tagtypestringlist) then
                      for loop:=0 to (pmt^.sizebuffer div n)-1 do
                       begin
                        pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                        if pni<>nil then
                          begin
                            addtail(@pgn^.editwindow^.extralist,pnode(pni));
                            pni^.ln_name:=@pni^.title[1];
                            
                            if pmt^.tagtype=tagtypearraylong then
                              pni^.num:=pla^[loop]
                             else
                              if pmt^.tagtype=tagtypearraybyte then
                                pni^.num:=pba^[loop]
                               else
                                if pmt^.tagtype=tagtypearrayword then
                                  pni^.num:=pwa^[loop];
                            
                            system.str(pni^.num,pni^.title);
                            pni^.title:=pni^.title+#0;
                          end;
                       end;
                    
                    s:='';
                    if (pmt^.sizebuffer>0) and (pmt^.tagtype=tagtypearraystring) then
                      begin
                        loop:=0;
                        while pla^[loop]<>0 do
                          inc(loop);
                        loop:=loop*4+4;
                        while (loop<pmt^.sizebuffer) do
                          begin
                            if pba^[loop]=0 then
                              begin
                                pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                                if pni<>nil then
                                  begin
                                    addtail(@pgn^.editwindow^.extralist,pnode(pni));
                                    pni^.ln_name:=@pni^.title[1];
                                    pni^.title:=s+#0;
                                    s:='';
                                  end;
                              end
                             else
                              begin
                                s:=s+chr(pba^[loop]);
                              end;
                            inc(loop);
                          end;
                      end;
                    
                    if (pmt^.sizebuffer>0) and (pmt^.tagtype=tagtypestringlist) then
                      begin
                        pl:=plist(pmt^.data);
                        pn:=pl^.lh_head;
                        while (pn^.ln_succ<>nil) do
                          begin
                            pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                            if pni<>nil then
                              begin
                                ctopas(pn^.ln_name^,s);
                                addtail(@pgn^.editwindow^.extralist,pnode(pni));
                                pni^.ln_name:=@pni^.title[1];
                                pni^.title:=s+#0;
                              end;
                            pn:=pn^.ln_succ;
                          end;
                      end;

                    
                    settagitem(@tags[3],gtlv_selected,~0);
                    settagitem(@tags[1],1,0);
                    settagitem(@tags[2],gtlv_labels,long(@pgn^.editwindow^.extralist));
                    settagitem(@tags[4],0,0);
                    if pmt^.tagtype=tagtypearraylong then
                      str:=@tstrings[6,1]
                     else
                      if pmt^.tagtype=tagtypearraybyte then
                        str:=@tstrings[7,1]
                       else
                        if pmt^.tagtype=tagtypearrayword then
                          str:=@tstrings[8,1]
                         else
                          if pmt^.tagtype=tagtypearraystring then
                            str:=@tstrings[9,1]
                           else
                            if pmt^.tagtype=tagtypestringlist then
                              str:=@tstrings[10,1];

                    
                    pgn^.editwindow^.data3:=~0;
                    
                    if sizeoflist(@pgn^.editwindow^.extralist)>0 then
                      pgn^.editwindow^.data3:=0;
                    
                    pgad:=GeneralGadToolsGad( listview_kind, offx+274, offy+90, 
          	                                 203, 52, 1004, str,
                                             @ttopaz80, placetext_above,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;
                    pgad:=GeneralGadToolsGad( button_kind, offx+481, offy+90, 
          	                                 100, 12, 1005, @up[1,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, nil);
                    pgn^.editwindow^.gads[21]:=pGad;
                    pgad:=GeneralGadToolsGad( button_kind, offx+481, offy+103, 
          	                                 100, 12, 1006, @up[2,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, nil);
                    pgn^.editwindow^.gads[22]:=pGad;
                    pgad:=GeneralGadToolsGad( button_kind, offx+481, offy+116, 
          	                                 100, 12, 1007, @up[3,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, nil);
                    pgn^.editwindow^.gads[23]:=pGad;
                    pgad:=GeneralGadToolsGad( button_kind, offx+481, offy+129, 
          	                                 100, 12, 1008, @up[4,1],
                                             @ttopaz80, placetext_in,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, nil);
                    pgn^.editwindow^.gads[24]:=pGad;
                    
                    settagitem(@tags[1],0,0);
                    if pgn^.editwindow^.data3=~0 then
                      settagitem(@tags[1],ga_disabled,long(true));
                    settagitem(@tags[2],0,0);
                    
                    if pgn^.editwindow^.data3<>~0 then
                      pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                    if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist) then
                      begin
                        loop:=string_kind;
                        if pgn^.editwindow^.data3<>~0 then
                          settagitem(@tags[1],gtst_string,long(@pni^.title[1]));
                      end
                     else
                      begin
                        if pgn^.editwindow^.data3<>~0 then
                          settagitem(@tags[1],gtin_number,long(pni^.num));
                        settagitem(@tags[2], gtin_maxchars, 12);
                        settagitem(@tags[3],0,0);
                        loop:=integer_kind;
                      end;
                    pgad:=GeneralGadToolsGad( loop, offx+274, offy+144, 
          	                                 203, 13, 1009, @up[5,1],
                                             @ttopaz80, placetext_right,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[25]:=pGad;
                    
                  end;
                
                tagtypeimage,tagtypeimagedata :
                  begin
                    if pmt^.data<>nil then
                      begin
                        pgn^.editwindow^.data2:=getlistpos(@teditimagelist,pnode(pmt^.data));
                      end
                     else
                      pgn^.editwindow^.data2:=~0;
                    
                    settagitem(@tags[3],gtlv_selected,pgn^.editwindow^.data2);
                    settagitem(@tags[1],gtlv_showselected,0);
                    settagitem(@tags[2],gtlv_labels,long(@teditimagelist));
                    settagitem(@tags[4],0,0);
                    
                    if pmt^.tagtype = tagtypeimage then
                      str:= @tstrings[4,1]
                     else
                      str:= @tstrings[5,1];
                    pgad:=GeneralGadToolsGad( listview_kind, offx+274, offy+90, 
          	                                 307, 70, 997, str,
                                             @ttopaz80, placetext_above,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;

                  end;
                
                tagtypeobject :
                  begin
                    if pmt^.data<>nil then
                      begin
                        pgn^.editwindow^.data2:=getlistpos(@pdwn^.gadgetlist,pnode(pmt^.data));
                      end
                     else
                      pgn^.editwindow^.data2:=~0;
                    
                    settagitem(@tags[3],gtlv_selected,pgn^.editwindow^.data2);
                    settagitem(@tags[1],gtlv_showselected,0);
                    settagitem(@tags[2],gtlv_labels,long(@pdwn^.gadgetlist));
                    settagitem(@tags[4],0,0);
                    
                    pgad:=GeneralGadToolsGad( listview_kind, offx+274, offy+90, 
          	                                 307, 70, 4997, @thesestrings[15,1],
                                             @ttopaz80, placetext_above,
                                       	     pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
                    pgn^.editwindow^.gads[20]:=pGad;

                  end;

                
                
               end;
              pos:=addglist(pgn^.editwindow^.pwin,pgn^.editwindow^.glist2,65535,-1,nil);
              refreshglist(pgn^.editwindow^.glist2,pgn^.editwindow^.pwin,nil,-1);
              gt_refreshwindow(pgn^.editwindow^.pwin,nil);
              
            end;
        end
       else
        begin
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglisttext],pgn^.editwindow^.pwin,
                                 ga_disabled,long(true));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagnumber],pgn^.editwindow^.pwin,
                                 ga_disabled,long(true));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[tagtypelistgad],pgn^.editwindow^.pwin,
                                 ga_disabled,long(true));
          gt_setsinglegadgetattr(pgn^.editwindow^.gads[select_ti_tag],pgn^.editwindow^.pwin,
                                 ga_disabled,long(true));
        
        end;
    end;
end;


Procedure RendWindowEditBoopsiWin( pwin:pwindow; vi:pointer);
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
        260,77,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,81+Offy,
        260,83,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,268+Offx,2+Offy,
        319,69,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,268+Offx,73+Offy,
        319,91,@tags[2]);
      DrawBevelBoxA(pwin^.RPort,4+Offx,166+Offy,
        583,19,@tags[2]);
    end;
end;

procedure openwindowEditBoopsiWin(pdwn:pdesignerwindownode;pgn:pgadgetnode);
Const
  Gadgetstrings : array[-1..15] of string[11]=
  (
  'LabelID'#0,
  'Tag Type'#0,
  'Class Name'#0,
  'Class Type'#0,
  'Create'#0,
  'Scale'#0,
  ''#0,
  'Tags'#0,
  'New'#0,
  'Delete'#0,
  'ti_tag'#0,
  'OK'#0,
  'Cancel'#0,
  'Help...'#0,
  'Select'#0,
  'Dispose'#0,
  'Obj Type'#0
  );
  wintitle : string [19]='Edit Boopsi Object'#0;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pgad  : pgadget;
  pmt,pmt2 : pmytag;
begin
  
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
  
          offx:=pdwn^.editscreen^.wborleft;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
          
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          
          Settagitem(@tags[1], GTLV_ShowSelected, 0);
          Settagitem(@tags[2], GTLV_Selected, 0);
          SetTagItem(@tags[3], GTLV_Labels, Long(@TagTypeListGadList));
          Settagitem(@tags[4], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 4, offx+359, offy+20, 
          	222, 48, 0, @gadgetstrings[0,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[0]:=pGad;
          
          pgad:=GeneralGadToolsGad( 12, offx+97, offy+5, 
          	161, 13, 14, @gadgetstrings[-1,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[14]:=pGad;
          
          
          pgad:=GeneralGadToolsGad( 12, offx+97, offy+20, 
          	161, 13, 1, @gadgetstrings[1,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[1]:=pGad;
          
          SetTagItem(@tags[1], GTCY_Labels, Long(@ClassTypeGadLabels));
          Settagitem(@tags[2], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 7, offx+97, offy+35, 
          	161, 13, 2, @gadgetstrings[2,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[2]:=pGad;
          
          pgad:=GeneralGadToolsGad( 2, offx+66, offy+65, 
          	26, 11, 3, @gadgetstrings[3,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[3]:=pGad;
          
          
          pgad:=GeneralGadToolsGad( 2, offx+232, offy+65, 
          	26, 11, 4, @gadgetstrings[4,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[4]:=pGad;
          
          
          pgad:=GeneralGadToolsGad( 12, offx+10, offy+136, 
          	248, 13, 5, @gadgetstrings[5,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[5]:=pGad;
          
          Settagitem(@tags[1], GTLV_ShowSelected, long(pgad));
          
          Settagitem(@tags[2], GTLV_Selected, 0);
          Settagitem(@tags[3], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 4, offx+10, offy+84, 
          	248, 52, 6, nil,
                                   @ttopaz80, 4,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[6]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+10, offy+149, 
          	90, 13, 7, @gadgetstrings[7,1],
                                   @ttopaz80, 16,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[7]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+168, offy+149, 
          	90, 13, 8, @gadgetstrings[8,1],
                                   @ttopaz80, 16,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[8]:=pGad;
          
          Settagitem(@tags[1], STRINGA_Justification, 512);
          settagitem(@tags[2], gtin_maxchars, 12);
          settagitem(@tags[3], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 3, offx+359, offy+5, 
          	152, 13, 9, @gadgetstrings[9,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[9]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+10, offy+169, 
          	140, 13, 10, @gadgetstrings[10,1],
                                   @ttopaz80, 16,
            pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[10]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+441, offy+169, 
          	140, 13, 11, @gadgetstrings[11,1],
                                   @ttopaz80, 16,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[11]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+225, offy+169, 
          	140, 13, 12, @gadgetstrings[12,1],
                                   @ttopaz80, 16,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[12]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+515, offy+5, 
          	66, 13, 13, @gadgetstrings[13,1],
                                   @ttopaz80, 16,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[13]:=pGad;
          
          SetTagItem(@tags[1], GTcb_checked, pgn^.tags[4].ti_tag );
          Settagitem(@tags[2], 0,0);

          pgad:=GeneralGadToolsGad( 2, offx+157, offy+65, 
          	26, 11, 18, @gadgetstrings[14,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[18]:=pGad;
          
          pgn^.tags[3].ti_data:=pgn^.tags[3].ti_tag;
          SetTagItem(@tags[1], GTCY_Labels, Long(@t));
          Settagitem(@tags[2], gtcy_active, pgn^.tags[3].ti_tag);
          Settagitem(@tags[3], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( cycle_kind, offx+97, offy+50, 
                                   161, 13, 17,@gadgetstrings[15,1],
                                   @ttopaz80, 1,
          	pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[17]:=pGad;
          

          
          if pgad<>nil then
            begin
              settagitem(@tags[ 1],WA_Left  ,round((pdwn^.editscreen^.width-286-offx)/2));
              settagitem(@tags[ 2],WA_Top   ,100);
              settagitem(@tags[ 3],WA_Width ,595+offx);
              settagitem(@tags[ 4],WA_Height,189+offy);
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
              settagitem(@tags[17],WA_Gadgets,long(pgn^.editwindow^.glist));
              settagitem(@tags[18],wa_customscreen,long(pdwn^.editscreen));
              settagitem(@tags[19],Tag_Done,0);
              pgn^.editwindow^.pWin:=openwindowtaglistnicely(Nil,@tags[1],6292348);
              if pgn^.editwindow^.pWin<>nil then
                begin
                  pgn^.editwindow^.pwin^.userdata:=pointer(pdwn);
                  GT_RefreshWindow( pgn^.editwindow^.pWin, Nil);
                  newlist(@pgn^.editwindow^.editlist);
                  newlist(@pgn^.editwindow^.extralist);
                  { clone list }
                  
                  pmt:=pmytag(pgn^.infolist.lh_head);
                  while (pmt^.ln_succ<>nil) do
                    begin
                      pmt2:=allocmymem(sizeof(tmytag),memf_clear or memf_any);
                      if pmt2<>nil then
                        begin
                          pmt2^:=pmt^;
                          pmt2^.ln_name:=@pmt2^.title[1];
                          addtail(@pgn^.editwindow^.editlist,pnode(pmt2));
                          if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
                            begin
                              pmt2^.sizebuffer:=0;
                              pmt2^.data:=allocmymem(pmt^.sizebuffer,memf_clear or memf_any);
                              if pmt2^.data<>nil then
                                begin
                                  copymem(pmt^.data,pmt2^.data,pmt^.sizebuffer);
                                  fixmytagdatapointers(pmt);
                                  pmt2^.sizebuffer:=pmt^.sizebuffer;
                                end;
                            end;
                        end;
                      pmt:=pmt^.ln_succ;
                    end;

                  
                  if sizeoflist(@pgn^.editwindow^.editlist)>0 then
                    pgn^.editwindow^.data4:=0
                   else
                    pgn^.editwindow^.data4:=~0;
                  
                  settagdata(pdwn,pgn);
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[14],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.labelid[1]));
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.datas[1]));
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[creategad],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[2].ti_tag);
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[scalegad],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[1].ti_data);
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[classtypegad],pgn^.editwindow^.pwin,
                                         gtcy_active,pgn^.tags[1].ti_tag);
                                    
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@pgn^.editwindow^.editlist));
                  {
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                         gtlv_selected,pgn^.editwindow^.data4);
                  }
                  RendWindowEditBoopsiWin( pgn^.editwindow^.pWin,pdwn^.helpwin.screenvisinfo );
                  pgn^.editwindow^.data:=pgn^.tags[1].ti_tag;
                end;
            end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end;
end;

procedure AddCustomTag(s:string;va:long);
var
  ps : pstringnode;
begin
  ps:=routines.allocmymem(sizeof(tstringnode), memf_clear);
  if (ps<>nil) then
    begin
      AddTail(@knowntaglist,pnode(ps));
      ps^.st:=s+#0;
      ps^.ln_pri:=7;
      ps^.ln_name:=@ps^.st[1];
      ps^.va:=va;
    end;
end;

const
  myname : string[30] = 'ENV:Designer/Designer.Tags'#0;
  chars : string[16] = '0123456789ABCDEF';

procedure WriteCustomTags( f:string );
const
  data : array[0..6] of string[65] =
  (
  '##   This file contains extra tags that are to be listed'#10#0,
  '##   in the BOOPSI Object window when you are editing an'#10#0,
  '##   Object inside the designer.'#10#0,
  '##'#10#0,
  '##   The format is a HEX number followed by a space and'#10#0,
  '##   then text until the end of the line.'#10#0,
  '##'#10#0
  );
var
  o : bptr;
  loop : word;
  n : pstringnode;
  dummy : long;
begin
  f:=f+#0;
  o:=Open(@f[1], mode_newfile);
  if long(o)<>0 then
    begin
      for loop:=0 to 6 do
        dummy:=FPuts(o,@data[loop,1]);
      n:=pstringnode(knowntaglist.lh_head);
      while(n^.ln_succ<>nil) do
        begin
          if n^.ln_pri = 7 then
            begin
              dummy:=FPutc(o, ord(chars[ ((n^.va and $f0000000) shr 28 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $0f000000) shr 24 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $00f00000) shr 20 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $000f0000) shr 16 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $0000f000) shr 12 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $00000f00) shr 08 )+1]));
              dummy:=FPutc(o, ord(chars[ ((n^.va and $000000f0) shr 04 )+1]));
              dummy:=FPutc(o, ord(chars[ (n^.va and  $0000000f) +1]));
              dummy:=FPutc(o, 32);
              dummy:=FPuts(o, n^.ln_name);
              dummy:=FPutc(o, 10);
            end;
          n:=n^.ln_succ;
        end;
      dummy:=long(Close_(o));
    end;
end;

procedure ReadCustomTags;
var
  f : bptr;
  buffer : array[0..255] of byte;
  s  : string;
  v : long;
  loop : word;
  total : long;
  pos   : word;
begin
  FreeExtraTags;
  f:=Open(@myname[1],mode_oldfile);
  if long(f)<>0 then
    begin
      while (NIL <> FGets(f,@buffer[0],256)) do
        begin
          ctopas(buffer,s);
          if (s[1]<>'#') and (s[2]<>'#') then
            begin
              total:=0;
              pos:=0;
              repeat
                inc(pos);
                v:=-1;
                for loop:=1 to 16 do
                  if upcase(s[pos])=chars[loop] then
                    v:=loop;
                if v<>-1 then
                  total:=total*16+v-1;
              until v =-1;
              if s[pos]=' ' then
                begin
                  if length(s)-pos-1>0 then
                    AddCustomTag(copy(s,pos+1,length(s)-pos-1),total);
                end;
            end;
          buffer[0]:=0;
          buffer[1]:=0;
        end;
      if long(Close_(f))=0 then;
    end;
end;

procedure FreeExtraTags;
var
  n : pnode;
begin
  n:=(knowntaglist.lh_tailpred);
  if n<>Nil then
    begin
      while (n^.ln_pri = 7) do
        begin
          remove(pnode(n));
          Freemymem(n,sizeof(tstringnode));
          n:=(knowntaglist.lh_tailpred);
        end;
    end;
end;

var
  loop : byte;
const
  td : array[0..2] of string[10] =
  (
  'Gadget'#0,
  'Image'#0,
  'Other'#0
  );
begin
  for loop:=0 to 2 do
    t[loop]:=@td[loop,1];
  t[3]:=nil;
  
  newlist(@knowntaglist);
  for loop:=0 to numberofknowntags do
    begin
      knownnodes[loop].ln_name:=@knowntags[loop].name[1];
      addtail(@knowntaglist,@knownnodes[loop]);
      knownnodes[loop].ln_pri:=0;
    end;
  
  NewList(@TagTypeListGadList);
  
  For Loop:=0 to numoftagtypes do
    Begin
      TagTypeListGadListItems[Loop].ln_name:=@TagTypeListGadListViewTexts[Loop,1];
      AddTail( @TagTypeListGadList, @TagTypeListGadListItems[Loop]);
    end;
  
  For Loop:=0 to 1 do
    ClassTypeGadLabels[Loop]:=@ClassTypeGadCycleTexts[Loop,1];
  ClassTypeGadLabels[2]:=Nil;
  selectlistpos:=0;
end.