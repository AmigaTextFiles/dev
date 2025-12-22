unit gadgeteditwindow;

interface

uses definitions,exec,intuition,graphics,gadtools,routines,utility;

procedure opengadgeteditwindowframe(pdwn:pdesignerwindownode;pgn:pgadgetnode;pgad : pgadget);

const
  extraleftborder = 4;
  extratopborder  = 3;

implementation

const
  winwidths  : array[1..20] of word = (279,286,303, 575,285,305,285,309,   524,0, 582,0,305,456);
  winheights : array[1..20] of word = (70,84,  166, 168,201,200,167  ,152, 107,0, 124,0,166,165);
  pat : array[0..1] of word = (21845,43690);
   
procedure opengadgeteditwindowframe(pdwn:pdesignerwindownode;pgn:pgadgetnode;pgad:pgadget);
const
  name1 :string[16] = 'fillrectclass'#0;
  name2 :string[14] = 'frameiclass'#0;
var
  tags : array[1..15] of ttagitem;
  sdi : pointer;
  pos : long;
  offx : word;
  thisone : word;
  offy : word;
  ps  : pbyte;
begin
  thisone:=pgn^.kind;
  case pgn^.kind of
    string_kind : thisone:=3;
    mybool_kind : thisone:=14;
   end;
  offx:=pdwn^.editscreen^.wborleft;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
  
  settagitem(@tags[1],gt_underscore,ord('_'));
  settagitem(@tags[2],tag_done,0);
  
  if pgad<>nil then
    begin
      pgad:=generalgadtoolsgad(button_kind,offx+extraleftborder,offy+2*extratopborder+winheights[thisone],
                               81,13,173,@strings[16,1],  {ok}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      if pgn^.justcreated and (prefsvalues[19]) then
        ps:=@strings[12,2]
       else
        ps:=@strings[17,1];
      pgad:=generalgadtoolsgad(button_kind,offx+extraleftborder+winwidths[thisone]-81,offy+2*extratopborder+
                               winheights[thisone],81,13,174,ps, {cancel}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+extraleftborder+(winwidths[thisone]-81) div 2,
                               offy+2*extratopborder+winheights[thisone],81,13,175,@strings[36,1], {font}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
    end
   else
    telluser(pdwn^.optionswindow,'Unable to create gadgets for edit button window.');
        
  settagitem(@tags[2],wa_smartrefresh,long(true));
  settagitem(@tags[3],wa_depthgadget,long(true));
  settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
  settagitem(@tags[5],wa_closegadget,long(true));
  settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-winwidths[thisone]-2*extraleftborder-offx*2)/2));
  settagitem(@tags[7],wa_top,100);
  settagitem(@tags[8],wa_width,winwidths[thisone]+offx+2*extraleftborder+4);
  settagitem(@tags[9],wa_height,winheights[thisone]+offy+3*extratopborder+15);
  settagitem(@tags[10],wa_title,long(@strings[85,1]));
  settagitem(@tags[11],wa_dragbar,long(true));
  settagitem(@tags[12],wa_activate,long(true));
  settagitem(@tags[13],wa_autoadjust,long(true));
  settagitem(@tags[14],Tag_Done,0);
  case pgn^.kind of
    2    : tags[10].ti_data:=long(@strings[94,1]);
    3    : tags[10].ti_data:=long(@strings[191,1]);
    12   : tags[10].ti_data:=long(@strings[190,1]);
    5    : tags[10].ti_data:=long(@strings[202,1]);
    7    : tags[10].ti_data:=long(@strings[93,1]);
    text_kind :   tags[10].ti_data:=long(@strings[200,1]);
    number_kind : tags[10].ti_data:=long(@strings[201,1]);
    palette_kind : tags[10].ti_data:=long(@strings[196,1]);
    mybool_kind : tags[10].ti_data:=long(@strings[204,1]);
    slider_kind : tags[10].ti_data:=long(@strings[122,1]);
    scroller_kind : tags[10].ti_data:=long(@strings[121,1]);
    
    listview_kind : tags[10].ti_data:=long(@strings[91,1]);
    
   end;
  if pgad<>nil then
    begin
      pgn^.editwindow^.pwin:=openwindowtaglistnicely(nil,@tags[2],idcmp_closewindow or
                                              buttonidcmp or
                                              idcmp_menupick or
                                              idcmp_refreshwindow or
                                              IDCMP_VanillaKey or
                                              paletteidcmp or
                                              stringidcmp or
                                              listviewidcmp or
                                              cycleidcmp
                                              );
      
            
    end
   else
    telluser(pdwn^.optionswindow,'Unable to create gadgets for edit button window.');
   
  if pgn^.editwindow^.pwin<>nil then
    begin
      
      settagitem(@tags[1],ia_left,offx);
      settagitem(@tags[2],ia_top,offy);
      settagitem(@tags[3],ia_width,winwidths[thisone]+8);
      settagitem(@tags[4],ia_height,winheights[thisone]+13+3*extratopborder);
      settagitem(@tags[5],ia_apattern,long(@pat[0]));
      settagitem(@tags[6],ia_apatsize,1);
      settagitem(@tags[7],ia_mode,0);
      settagitem(@tags[8],ia_fgpen,2);
      settagitem(@tags[9],0,0);
      pgn^.editwindow^.object1:=NewObjecta(nil,@name1[1],@tags[1]);
      
      settagitem(@tags[1],ia_left,offx+4);
      settagitem(@tags[2],ia_top,offy+4);
      settagitem(@tags[3],ia_width,winwidths[thisone]);
      settagitem(@tags[4],ia_height,winheights[thisone]);
      settagitem(@tags[5],ia_recessed,1);
      settagitem(@tags[6],0,0);
      pgn^.editwindow^.object2:=NewObjecta(nil,@name2[1],@tags[1]);
      
      sdi:=getscreendrawinfo(pdwn^.editscreen);
      
      if pgn^.editwindow^.object1<>nil then
        DrawImageState(pgn^.editwindow^.pwin^.rport,pointer(pgn^.editwindow^.object1),0,0,ids_normal,sdi);
      if pgn^.editwindow^.object2 <>nil then
        DrawImageState(pgn^.editwindow^.pwin^.rport,pointer(pgn^.editwindow^.object2),0,0,ids_normal,sdi);
      
      if sdi<>nil then
        freescreendrawinfo(pdwn^.editscreen,sdi);
      
      pos:=addglist(pgn^.editwindow^.pwin,pgn^.editwindow^.glist,65535,~0,Nil);
      refreshglist(pgn^.editwindow^.glist,pgn^.editwindow^.pwin,nil,~0);
      pgn^.editwindow^.pwin^.userdata:=pointer(pdwn);
      gt_refreshwindow(pgn^.editwindow^.pwin,nil);
    end;
  
end;

end.