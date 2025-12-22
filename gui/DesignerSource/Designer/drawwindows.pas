unit drawwindows;

interface

uses designermenus,asl,utility,routines,exec,intuition,workbench,diskfont,editboopsi,gadgeteditwindow,
     amiga,gadtools,graphics,dos,amigados,definitions,amigaguide,obsolete,objectmenucustomunit;

function OpenMainWindow:boolean;
procedure closemainwindow;
procedure rendmainwindow;
procedure OpenLibWindow;
procedure closelibwindow;
procedure rendlibwindow;
procedure HelpWindow(pwn:pwindownode;n:word);
function openeditwindow(pdwn:pdesignerwindownode):boolean;
procedure closeeditwindow(pdwn:pdesignerwindownode);
procedure rendoptionswindow(pdwn:pdesignerwindownode);
procedure closeoptionswindow(pdwn:pdesignerwindownode);
function openoptionswindow(pdwn:pdesignerwindownode):boolean;
procedure opentextlistwindow(pdwn:pdesignerwindownode);
procedure closetextlistwindow(pdwn:pdesignerwindownode);
procedure opensizeswindow(pdwn:pdesignerwindownode);
procedure closesizeswindow(pdwn:pdesignerwindownode);
procedure rendsizeswindow(pdwn:pdesignerwindownode);
procedure openidcmpwindow(pdwn:pdesignerwindownode);
procedure closeidcmpwindow(pdwn:pdesignerwindownode);
procedure setidcmpwindowgads(pdwn:pdesignerwindownode);
procedure rendeditwindow(pdwn:pdesignerwindownode);
procedure closeeditgadget(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure closeimagelistwindow(pdwn:pdesignerwindownode);
procedure openimagelistwindow(pdwn:pdesignerwindownode);
procedure opentagswindow(pdwn:pdesignerwindownode);
procedure closetagswindow(pdwn:pdesignerwindownode);
procedure rendtagswindow(pdwn:pdesignerwindownode);
procedure rendtextlistwindow(pdwn:pdesignerwindownode);
procedure closeeditscreenforwindow(pdwn:pdesignerwindownode);
function openscreentoeditwindow(pdwn:pdesignerwindownode;mode:byte):boolean;
procedure openeditgadget(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure openeditmenuwindow(pdmn:pdesignermenunode);
procedure closeeditmenuwindow(pdmn:pdesignermenunode);
procedure rendeditmenuwindow(pdmn:pdesignermenunode);
procedure closewindowcodewindow(pdwn:pdesignerwindownode);
procedure openwindowcodewindow(pdwn:pdesignerwindownode);
Procedure CloseBevelWindow(pdwn:pdesignerwindownode);
procedure OpenBevelWindow(pdwn:pdesignerwindownode);
procedure OpenMainCodeWindow;
procedure closemaincodewindow;
procedure closeprefswindow;
procedure OpenPrefsWindow;
Procedure Closeimageeditwindow(pin : pimagenode);
procedure openimageeditwindow(pin:pimagenode);
function doeditwindowgadgets(pdwn:pdesignerwindownode):pgadget;
procedure closeopeneditwindow(pdwn:pdesignerwindownode);
procedure openeditgadgetlist(pdwn:pdesignerwindownode);
procedure closegadgetlistwindow(pdwn:pdesignerwindownode);
procedure closemagnifywindow(pdwn:pdesignerwindownode);
procedure freegadgetnode(pdwn:pdesignerwindownode;pgn:pgadgetnode);

implementation

procedure freegadgetnode(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pgn2 : pgadgetnode;
  pmt,pmt2 : pmytag;
begin
  
  if pdwn<>nil then
    begin
    
  pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn2^.ln_succ<>nil) do
    begin
      if pgn2^.kind = myobject_kind then
        begin
          pmt:=pmytag(pgn2^.infolist.lh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              if pmt^.tagtype=tagtypeobject then
                begin
                  
                  if pgn=pmt^.data then
                    begin
                      pmt^.data:=nil;
                    end;
                  
                end;
              pmt:=pmt^.ln_succ;
            end;
          
          if pgn2^.editwindow<>nil then
            begin
              pmt:=pmytag(pgn2^.editwindow^.editlist.lh_head);
              while(pmt^.ln_succ<>nil) do
                begin
                  if pmt^.tagtype=tagtypeobject then
                    begin
                      if pgn=pmt^.data then
                        begin
                          pmt^.data:=nil;
                        end;
                          
                      if pgn2^.editwindow^.data4=getlistpos(@pgn2^.editwindow^.editlist,pnode(pmt)) then
                        begin
                          if pmt^.data=nil then
                            pgn2^.editwindow^.data2:=~0
                           else
                            pgn2^.editwindow^.data2:=getlistpos(@pdwn^.gadgetlist,pmt^.data);
                          gt_setsinglegadgetattr(pgn2^.editwindow^.gads[20],pgn2^.editwindow^.pwin,
                                         gtlv_labels,~0);
                          gt_setsinglegadgetattr(pgn2^.editwindow^.gads[20],pgn2^.editwindow^.pwin,
                                         gtlv_labels,long(@pdwn^.gadgetlist));
                          gt_setsinglegadgetattr(pgn2^.editwindow^.gads[20],pgn2^.editwindow^.pwin,
                                         gtlv_selected,pgn2^.editwindow^.data2);
                        end;
                          
                    end;
                  pmt:=pmt^.ln_succ;
                end;
              end;
        
        end;
      pgn2:=pgn2^.ln_succ;
    end;
  
    end;
  
  if (pgn^.kind=listview_kind) then
    begin
      freelist(@pgn^.infolist,sizeof(tstringnode));
      if pgn^.tags[3].ti_data<>0 then
        begin
          pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
          pgn2^.joined:=false;
          pgn2^.pointers[1]:=nil;
        end;
    end;
  
  if (pgn^.kind=myobject_kind) then
    begin
      pmt:=pmytag(pgn^.infolist.lh_head);
      while(pmt^.ln_succ<>nil) do
        begin
          pmt2:=pmt^.ln_succ;
          freemytag(pmt);
          pmt:=pmt2;
        end;
    end;
  
  if (pgn^.kind=mx_kind)or(pgn^.kind=cycle_kind) then
    begin
      freelist(@pgn^.infolist,sizeof(tstringnode));
      if (pgn^.pointers[1]<>nil) and (pgn^.pointers[2]<>nil) then
        freemymem(pgn^.pointers[1],long(pgn^.pointers[2]));
    end;
  
  if (pgn^.kind=string_kind) then
    begin
      if pgn^.joined then
        begin
          {pgn^.joined:=false;}
          pgn2:=pgadgetnode(pgn^.pointers[1]);
          pgn2^.tags[3].ti_data:=0;
        end;
    end;
  
  if pdwn<>nil then
    if pgn^.editwindow<>nil then
      closeeditgadget(pdwn,pgn);
  
  freemymem(pgn,sizeof(tgadgetnode));
end;


procedure closegadgetlistwindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.gadgetlistwindow<>nil then
    begin
      if pdwn^.gmenu<>nil then
        begin
          clearmenustrip(pdwn^.gadgetlistwindow);
          freemenus(pdwn^.gmenu);
        end;
      pdwn^.nextid:=getintegerfromgad(pdwn^.gadgetlistwindowgads[1]);
      fixgadgetnumbers(pdwn);
      closewindowsafely(pdwn^.gadgetlistwindow);
      pdwn^.gadgetlistwindow:=nil;
      freegadgets( pdwn^.gadgetlistwindowglist);
    end;
end;

procedure openeditgadgetlist(pdwn:pdesignerwindownode);
const
  Gadgetstrings : array[0..5] of string[10]=
  (
  ''#0,
  '_First ID'#0,
  '_Edit'#0,
  '_Up'#0,
  '_Down'#0,
  '_High'#0
  );
  wintitle : string [12]='Gadget List'#0;
var
  pgad : pgadget;
  tags : array[1..16] of ttagitem;
  offx,offy : word;
begin
  if pdwn^.gadgetlistwindow=nil then
    begin
      pdwn^.gadgetlistwindowglist:=nil;
      pgad:=createcontext(@pdwn^.gadgetlistwindowglist);
      offx:=pdwn^.editscreen^.WBorLeft;
      offy:=Pdwn^.editScreen^.WBorTop+Pdwn^.editScreen^.Font^.ta_YSize+1;
      Settagitem(@tags[1], GTLV_ShowSelected, 0);
      Settagitem(@tags[2], GTLV_Selected, 0);
      Settagitem(@tags[3], Tag_Done, 0);
      pgad:=GeneralGadToolsGad( 4, offx+4, offy+2, 241, 88, 0, @gadgetstrings[0,1],
                               @ttopaz80, 1, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
      pdwn^.gadgetlistwindowGads[0]:=pGad;
      Settagitem(@tags[2], GT_UnderScore, Ord('_'));
      pgad:=GeneralGadToolsGad( 3, offx+4, offy+107, 90, 12, 1, @gadgetstrings[1,1],
                               @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
      pdwn^.gadgetlistwindowGads[1]:=pGad;
      pgad:=GeneralGadToolsGad( 1, offx+4, offy+93, 59, 12, 2, @gadgetstrings[2,1],
                               @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
      pgad:=GeneralGadToolsGad( 1, offx+65, offy+93, 59, 12, 3, @gadgetstrings[3,1],
                               @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
      pgad:=GeneralGadToolsGad( 1, offx+126, offy+93, 59, 12, 4, @gadgetstrings[4,1],
                                @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
      pgad:=GeneralGadToolsGad( 1, offx+187, offy+93, 59, 12, 5, @gadgetstrings[5,1],
                               @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
      if pgad<>nil then
        begin
          settagitem(@tags[ 1],WA_Left  ,700);
          settagitem(@tags[ 2],WA_Top   ,34);
          settagitem(@tags[ 3],WA_Width ,255+offx);
          settagitem(@tags[ 4],WA_Height,123+offy);
          settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
          settagitem(@tags[ 6],WA_DragBar,long(true));
          settagitem(@tags[ 7],WA_DepthGadget,long(true));
          settagitem(@tags[ 8],WA_CloseGadget,long(true));
          settagitem(@tags[ 9],WA_Activate,long(true));
          settagitem(@tags[10],WA_SmartRefresh,long(true));
          settagitem(@tags[11],WA_AutoAdjust,long(true));
          settagitem(@tags[12],WA_Gadgets,long(pdwn^.gadgetlistwindowglist));
          settagitem(@tags[13],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[14],Tag_Done,0);
          pdwn^.gadgetlistwindow:=openwindowtaglistnicely(Nil,@tags[1],listviewidcmp or
                                                                       idcmp_refreshwindow or
                                                                       idcmp_vanillakey or
                                                                       buttonidcmp or
                                                                       idcmp_menupick or
                                                                       integeridcmp or
                                                                       idcmp_closewindow);
          if pdwn^.gadgetlistwindow<>nil then
            begin
              pdwn^.gadselected:=~0;
              pdwn^.gadgetlistwindow^.userdata:=pointer(pdwn);
              GT_RefreshWindow( pdwn^.gadgetlistwindow, Nil);
              gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                     gtlv_labels,long(@pdwn^.gadgetlist));
              gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[1],pdwn^.gadgetlistwindow,
                                     gtin_number,long(pdwn^.nextid));
              glistmenu:=nil;
              pdwn^.gmenu:=nil;
              if makemenuglistmenu(pdwn^.helpwin.screenvisinfo) then
                begin
                  if setmenustrip(pdwn^.gadgetlistwindow,glistmenu) then
                    pdwn^.gmenu:=glistmenu
                   else
                    freemenus(glistmenu);
                end;
            end
           else
            Begin
              telluser(pdwn^.editwindow,'Cannot open Gadget List Window.');
              FreeGadgets(pdwn^.gadgetlistwindowGList);
            end;
        end
       else
        begin
          freegadgets(pdwn^.gadgetlistwindowglist);
          telluser(pdwn^.editwindow,'Cannot make gadgets for Gadget List Window.');
        end;
    end
   else
    begin
      WindowToFront(pdwn^.gadgetlistwindow);
      activatewindow(pdwn^.gadgetlistwindow);
    end;
end;

procedure closeopeneditwindow(pdwn);
begin
   closeeditwindow(pdwn);
   if openeditwindow(pdwn)=false then
     begin
       if pdwn^.editscreen<>nil then
         closeeditscreenforwindow(pdwn);
     end
    else
     windowtoback(pdwn^.editwindow);
end;

procedure closeeditscreenforwindow(pdwn:pdesignerwindownode);
var
  pgn   : pgadgetnode;
  pin   : pimagenode;
begin
  if pdwn^.editscreen<>nil then
    begin
      if (amigaguidescreen=pdwn^.editscreen)and(amigaguidehandle<>nil) then
        begin
          closeamigaguide(amigaguidehandle);
          amigaguidehandle:=nil;
        end;
      closegadgetlistwindow(pdwn);
      closemagnifywindow(pdwn);
      closeimagelistwindow(pdwn);
      closetagswindow(pdwn);
      closesizeswindow(pdwn);
      closewindowcodewindow(pdwn);
      closebevelwindow(pdwn);
      closetextlistwindow(pdwn);
      closeeditwindow(pdwn);
      if pdwn^.optionswindow<>nil then
        closeoptionswindow(pdwn);
      if pdwn^.idcmpwindow<>nil then
        closeidcmpwindow(pdwn);
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      while(pgn^.ln_succ<>nil)do
        begin
          closeeditgadget(pdwn,pgn);  
          pgn:=pgn^.ln_succ;
        end;   
      pin:=pimagenode(teditimagelist.lh_head);
      while (pin^.ln_succ<>nil) do
        begin
          if pin^.pscr=pdwn^.editscreen then
            closeimagedisplaywindow(pin); 
          pin:=pin^.ln_succ;
        end;
      if pdwn^.helpwin.screenvisinfo<>nil then
        freevisualinfo(pdwn^.helpwin.screenvisinfo);
      pdwn^.helpwin.screenvisinfo:=nil;
      if long(closescreen(pdwn^.editscreen))=0 then
        telluser(mainwindow,'Cannot close screen.');
      pdwn^.editscreen:=nil;
      if pdwn^.listmenu<>nil then
        freemenus(pdwn^.listmenu);
      pdwn^.listmenu:=nil;
      if pdwn^.gadgetmenu<>nil then
        freemenus(pdwn^.gadgetmenu);
      if pdwn^.objectmenu<>nil then
        freemenus(pdwn^.objectmenu);
      if pdwn^.mmenu<>nil then
        freemenus(pdwn^.mmenu);
      pdwn^.mmenu:=nil;
      pdwn^.objectmenu:=nil;
      pdwn^.gadgetmenu:=nil;
    end;
end;

function openscreentoeditwindow(pdwn:pdesignerwindownode;mode:byte):boolean;
var
  tags            : array[1..14] of ttagitem;
  editscr         : pscreen;
  loop            : byte;
  pen1            : integer;
  teasy           : teasystruct;
  title           : string[100];
  gadgetformat    : string[100];
  textformat      : string[100];
  result          : long;
begin
  pen1:=~0;
  openscreentoeditwindow:=false;
  settagitem(@tags[1],sa_width,pdwn^.screenprefs.sm_width);
  settagitem(@tags[2],sa_height,pdwn^.screenprefs.sm_height);
  settagitem(@tags[3],sa_depth,pdwn^.screenprefs.sm_depth);
  settagitem(@tags[4],sa_overscan,oscan_text);
  settagitem(@tags[5],sa_autoscroll,long(true));
  settagitem(@tags[6],sa_pens,long(@pen1));
  if not pdwn^.screenprefs.changed then
    begin
      settagitem(@tags[7],sa_sysfont,1);
     end
   else
    begin
      pdwn^.screenprefs.font.ta_name:=@pdwn^.screenprefs.fontname[1];
      settagitem(@tags[7],sa_font,long(@pdwn^.screenprefs.font));
    end;
  settagitem(@tags[8],sa_displayid,pdwn^.screenprefs.sm_displayid);
  settagitem(@tags[9],sa_title,long(@editscreentitle[1])); 
  settagitem(@tags[10],sa_fullpalette,long(true));
  settagitem(@tags[11],sa_interleaved,1); 
  settagitem(@tags[12],sa_sharepens,1); 
  settagitem(@tags[13],tag_end,0); 
  editscr:=openscreentaglist(nil,@tags[1]);
  if editscr<>nil then
    begin
      {
      setupoptionswindowborders;
      }
      if pdwn^.screenprefs.sm_depth>1 then
        begin
          pdwn^.gadbord1:=@image1;
          pdwn^.gadbord2:=@image2;
        end
       else
        begin
          pdwn^.gadbord1:=@image3;
          pdwn^.gadbord2:=@image4;
        end;
      pdwn^.helpwin.screenvisinfo:=getvisualinfoa(editscr,pendtagitem);
      pdwn^.helpwin.pscr:=editscr;
      pdwn^.editscreen:=editscr;
      if nil=pdwn^.helpwin.screenvisinfo then
        begin
          closeeditscreenforwindow(pdwn);
          telluser(mainwindow,'Unable to get visinfo for screen.');
        end
       else
        begin
          pdwn^.listmenu:=nil;
          winlistmenu:=nil;
          openscreentoeditwindow:=true;
          if makemenuWinListMenu(pdwn^.helpwin.screenvisinfo) then
          pdwn^.listmenu:=winlistmenu;
          pdwn^.gadgetmenu:=nil;
          gadgetmenu:=nil;
          if makemenugadgetmenu(pdwn^.helpwin.screenvisinfo) then
            pdwn^.gadgetmenu:=gadgetmenu;
          
          pdwn^.objectmenu:=nil;
          objectmenu:=nil;
          if makemenuobjectmenu(pdwn^.helpwin.screenvisinfo) then
            pdwn^.objectmenu:=objectmenu;
          
          editwinmenu:=nil;
          if makemenueditwinmenu(pdwn^.helpwin.screenvisinfo) then
            pdwn^.mmenu:=editwinmenu;
        end;
    end
   else
    begin
      if mode=0 then
        begin
          waiteverything;
          textformat:='  Cannot Open Edit Screen  '#10#10'Try Default Screen Format ?'#10#0;
          gadgetformat:='Yes|No'#0;
          title:='Designer Message'#0;
          with teasy do
            begin
              es_structsize:=sizeof(teasy);
              es_flags:=0;
              es_title:=@title[1];
              es_textformat:=@textformat[1];
              es_gadgetformat:=@gadgetformat[1];
            end;
          result:=easyrequestargs(mainwindow,@teasy,nil,nil);
          if result=1 then
            begin
              copymem(@defaultscreenmode,@pdwn^.screenprefs,sizeof(pdwn^.screenprefs));
              openscreentoeditwindow:=openscreentoeditwindow(pdwn,1);
            end
           else
            begin
              telluser(pdwn^.optionswindow,'Cannot open edit window.');
              openscreentoeditwindow:=false;
            end;
          inputmode:=1;
          unwaiteverything;
        end
       else
        begin
          telluser(mainwindow,'Failed to open Screen.');
          openscreentoeditwindow:=false;
        end;
    end;
end;

function openoptionswindow:boolean(pdwn:pdesignerwindownode):boolean;
const
  wintitle : string[13] = 'Tools Window'#0;
  myobjectstring : string[20] = 'Object'#0;
var
  tags : array[1..17] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  pgn  : pgadgetnode;
begin
  pdwn^.bevelselected:=~0;
  pdwn^.backoptwin:=prefsvalues[9];
  pdwn^.alignselect:=0;
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while pgn^.ln_succ<>nil do
    begin
      pgn^.high:=false;
      pgn:=pgn^.ln_succ;
    end;
  settagitem(@tags[1],gtcy_labels,long(@aligncycle));
  settagitem(@tags[2],gtcy_active,0);
  settagitem(@tags[3],tag_done,0);
  settagitem(@tags[4],gtin_number,pdwn^.spreadsize);
  settagitem(@tags[5],stringa_justification,gact_stringcenter);
  settagitem(@tags[6],tag_done,0);
  settagitem(@tags[7],gtcy_labels,long(@spreadcycle[1]));
  settagitem(@tags[8],gtcy_active,pdwn^.spreadpos);
  settagitem(@tags[9],tag_done,0);
  settagitem(@tags[10],gt_underscore,ord('_'));
  settagitem(@tags[11],tag_done,0);
  openoptionswindow:=false;
  pdwn^.mxchoice:=0;
  pgad:=createcontext(@pdwn^.optionsglist);
  offx:=8;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight;
  if not pdwn^.backoptwin then
    dec(offy,2);
  pgad:=togglegad(offx,13+offy,10,@windowoptions[1,1],pgad,pdwn);    {button}
  pgad^.flags:=pgad^.flags or gflg_selected;
  pdwn^.optionswingads[10]:=pgad;
  pgad:=togglegad(84+offx,13+offy,11,@windowoptions[2,1],pgad,pdwn); {string}
  pdwn^.optionswingads[11]:=pgad;
  pgad:=togglegad(offx+168,13+offy,12,@windowoptions[3,1],pgad,pdwn);    {numeric}
  pdwn^.optionswingads[12]:=pgad;
  pgad:=togglegad(offx,26+offy,13,@windowoptions[4,1],pgad,pdwn); {checkbox}
  pdwn^.optionswingads[13]:=pgad;
  pgad:=togglegad(offx+84,26+offy,14,@windowoptions[5,1],pgad,pdwn);    {radio}
  pdwn^.optionswingads[14]:=pgad;
  pgad:=togglegad(168+offx,26+offy,15,@windowoptions[6,1],pgad,pdwn); {cycle}
  pdwn^.optionswingads[15]:=pgad;
  pgad:=togglegad(offx,39+offy,16,@windowoptions[7,1],pgad,pdwn);    {slider}
  pdwn^.optionswingads[16]:=pgad;
  pgad:=togglegad(84+offx,39+offy,17,@windowoptions[8,1],pgad,pdwn); {scroller}
  pdwn^.optionswingads[17]:=pgad;
  pgad:=togglegad(offx+168,39+offy,18,@windowoptions[9,1],pgad,pdwn);    {listview}
  pdwn^.optionswingads[18]:=pgad;
  pgad:=togglegad(offx,52+offy,19,@windowoptions[10,1],pgad,pdwn);{palette}
  pdwn^.optionswingads[19]:=pgad; 
  pgad:=togglegad(offx+84,52+offy,20,@windowoptions[11,1],pgad,pdwn);   {text}
  pdwn^.optionswingads[20]:=pgad;
  pgad:=togglegad(168+offx,52+offy,21,@windowoptions[12,1],pgad,pdwn);{number}
  pdwn^.optionswingads[21]:=pgad;
  pgad:=togglegad(offx,65+offy,40,@strings[106,1],pgad,pdwn);        {DropBox}
  pdwn^.optionswingads[40]:=pgad;
  pgad:=togglegad(offx+168,65+offy,42,@strings[188,1],pgad,pdwn);     {Generic}
  pdwn^.optionswingads[42]:=pgad;
  
  {
  pgad:=togglegad(offx+168,65+offy,41,@strings[107,1],pgad,pdwn); 
  pdwn^.optionswingads[41]:=pgad;
  }
  
  pgad:=togglegad(offx+84,65+offy,43,@myobjectstring[1],pgad,pdwn);     {object}
  pdwn^.optionswingads[43]:=pgad;
  
  offy:=offy+78{+13};
  
  pgad:=generalgadtoolsgad(button_kind,offx+84,offy+13,optgadgwidth,
                           optgadgheight,32,@strings[96,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {delete}
  pdwn^.optionswingads[32]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,168+offx,13+offy,optgadgwidth,
                           optgadgheight,33,@strings[97,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {clone}
  pdwn^.optionswingads[33]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,offx,13+offy,optgadgwidth,
                           optgadgheight,34,@strings[98,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {size}
  pdwn^.optionswingads[34]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,offx,offy,optgadgwidth,
                           optgadgheight,35,@strings[99,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {move}
  pdwn^.optionswingads[35]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,84+offx,offy,optgadgwidth,
                           optgadgheight,36,@strings[104,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {align}
  pdwn^.optionswingads[36]:=pgad;
  pgad:=generalgadtoolsgad(cycle_kind,168+offx,offy,optgadgwidth,
                           optgadgheight,37,nil,
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);     { align cycle }
  pdwn^.optionswingads[37]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,offx,26+offy,optgadgwidth,
                           optgadgheight,60,@windowoptions[15,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);  {spread}
  pgad:=generalgadtoolsgad(cycle_kind,84+offx,26+offy,optgadgwidth,
                           optgadgheight,61,nil,
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);     { spread cycle }
  pdwn^.spreadcyclegad:=pgad;
  pgad:=generalgadtoolsgad(integer_kind,168+offx,26+offy,optgadgwidth,
                           optgadgheight,62,nil,
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);     { spread size }
  pdwn^.spreadsizegad:=pgad;
  offy:=offy+48;
  pgad:=togglegad(offx,offy,22,@windowoptions[13,1],pgad,pdwn);     {Bevel}
  pdwn^.optionswingads[22]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,+offx,offy+13,optgadgwidth,
                           optgadgheight,23,@strings[95,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);  {edit... bevel}
  pdwn^.optionswingads[23]:=pgad;
  pgad:=togglegad(offx+84,offy,24,@windowoptions[11,1],pgad,pdwn);  {text}
  pdwn^.optionswingads[24]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,84+offx,13+offy,optgadgwidth,
                           optgadgheight,25,@strings[95,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);  {edit... text}
  pdwn^.optionswingads[25]:=pgad;
  pgad:=togglegad(168+offx,offy,38,@strings[105,1],pgad,pdwn);       {image}
  pdwn^.optionswingads[38]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,168+offx,13+offy,optgadgwidth,
                           optgadgheight,39,@strings[127,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);  {choose... image}
  pdwn^.optionswingads[39]:=pgad;
  offy:=offy+35;
  pgad:=generalgadtoolsgad(button_kind,offx,offy,optgadgwidth,        {screen...}
                           optgadgheight,26,@strings[23,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[26]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,84+offx,offy,optgadgwidth,     {tags...}
                           optgadgheight,27,@strings[26,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[27]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,offx,13+offy,optgadgwidth,     {sizes...}
                           optgadgheight,28,@strings[27,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[28]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,84+offx,13+offy,optgadgwidth,  {idcmp...}
                           optgadgheight,29,@strings[28,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[29]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,168+offx,offy,optgadgwidth,     {code...}
                           optgadgheight,30,@strings[29,1],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[30]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,168+offx,13+offy,optgadgwidth,  {help...}
                           optgadgheight,31,@strings[35,6],
                           @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
  pdwn^.optionswingads[31]:=pgad;
  dec(offy,161);
  if pgad<>nil then
    pdwn^.optionswingads[10]^.gadgettext^.frontpen:=2;
  if pgad<>nil then
    begin
      if pdwn^.backoptwin then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.optionsglist));
          settagitem(@tags[2],wa_smartrefresh,long(true));
          settagitem(@tags[3],wa_backdrop,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_borderless,long(true));
          {
          settagitem(@tags[3],wa_dragbar,long(true));
          settagitem(@tags[7 ],wa_left,0);
          settagitem(@tags[8 ],wa_top,offy+2);
          settagitem(@tags[9 ],wa_width,264);
          settagitem(@tags[10 ],wa_height,189+offy);
          settagitem(@tags[7],wa_closegadget,long(true));
          }
   
          settagitem(@tags[6],tag_done,0);
        end
       else
        begin
          settagitem(@tags[1 ],wa_left,0);
          settagitem(@tags[2 ],wa_top,offy+2);
          settagitem(@tags[3 ],wa_width,264);
          settagitem(@tags[4 ],wa_height,189+offy);
          settagitem(@tags[5 ],wa_title,long(@wintitle[1]));
          settagitem(@tags[6 ],wa_dragbar,long(true));
          settagitem(@tags[7 ],wa_depthgadget,long(true));
          settagitem(@tags[8 ],wa_autoadjust,long(true));
          settagitem(@tags[9 ],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[10],wa_gadgets,long(pdwn^.optionsglist));
          settagitem(@tags[11],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[12],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[13],wa_closegadget,long(true));
          settagitem(@tags[14],Tag_Done,0);
        end;
      pdwn^.optionswindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                mxidcmp or
                                                                idcmp_menupick or
                                                                cycleidcmp or
                                                                listviewidcmp or
                                                                buttonidcmp or
                                                                {WA_MenuHelp or}
                                                                idcmp_refreshwindow or
                                                                IDCMP_VanillaKey);
      if pdwn^.optionswindow<>nil then
        begin
          pdwn^.optionswindow^.userdata:=pointer(pdwn);
          gt_refreshwindow(pdwn^.optionswindow,nil);
          gt_setsinglegadgetattr(pdwn^.optionswingads[42],pdwn^.optionswindow,ga_disabled,long(true));
          rendoptionswindow(pdwn);
          openoptionswindow:=true;
          if prefsvalues[10] then
            openeditgadgetlist(pdwn);
          if pdwn^.mmenu<>nil then
            if setmenustrip(pdwn^.optionswindow,pdwn^.mmenu) then;
        end;
    end
   else
    telluser(mainwindow,'Unable to create gadgets for options window.');
end;

procedure closeoptionswindow(pdwn);
var
  loop : byte;
begin
  if pdwn^.spreadsizegad<>nil then
    pdwn^.spreadsize:=getintegerfromgad(pdwn^.spreadsizegad);
  if pdwn^.optionswindow<>nil then 
    begin
      if pdwn^.optionswindow^.menustrip<>nil then
        clearmenustrip(pdwn^.optionswindow);
      closewindowsafely(pdwn^.optionswindow);
    end;
   for loop:=38 to 43 do
    if (loop<>39) and (loop<>41) then
      begin
        if pdwn^.optionswingads[loop]^.gadgettext<>nil then
          freemymem(pdwn^.optionswingads[loop]^.gadgettext,sizeof(tintuitext));
        pdwn^.optionswingads[loop]^.gadgettext:=nil;
      end;
  for loop:=10 to 24 do
    if loop<>23 then
      begin
        if pdwn^.optionswingads[loop]^.gadgettext<>nil then
          freemymem(pdwn^.optionswingads[loop]^.gadgettext,sizeof(tintuitext));
        pdwn^.optionswingads[loop]^.gadgettext:=nil;
      end;
  if pdwn^.optionsglist<>nil then
    freegadgets(pdwn^.optionsglist);
  pdwn^.optionswindow:=nil;
  pdwn^.optionsglist:=nil;  
end;

procedure rendoptionswindow(pdwn:pdesignerwindownode);
var
  tags : array[1..5] of ttagitem;
  offx,offy : word;
begin
  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=0;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight;
  
  if pdwn^.backoptwin then
    drawbevelboxa(pdwn^.optionswindow^.rport,offx+2,offy+2,262,187,@tags[2])
   else
    dec(offy,2);
  {
  if not pdwn^.backoptwin then
    dec(offy,2);
  drawbevelboxa(pdwn^.optionswindow^.rport,offx+2,offy+2,262,187,@tags[2]);
  }
  printstring(pdwn^.optionswindow,offx+107,4+offy,'Gadgets',1,0,@ttopaz80);
  {inc(offy,13);}
  printstring(pdwn^.optionswindow,offx+100,117+offy,'Graphics',1,0,@ttopaz80);
  printstring(pdwn^.optionswindow,offx+104,152+offy,'Options',1,0,@ttopaz80);
end;

procedure openeditstringinteger(pdwn:pdesignerwindownode;pgn:pgadgetnode);
const
  editstring : string[9] = 'EditHook'#0;
  defstring : string[8] = 'Default'#0;
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],gt_underscore,ord('_'));
          settagitem(@tags[6],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+extratopborder+3;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,53+offy,26,11,3,@strings[76,1],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,53+offy,26,11,4,@strings[77,1],{underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,5,@strings[78,1],{text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,6,@strings[79,1],{placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,67+offy,26,11,9,@strings[5,7],    {replacemode}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,67+offy,26,11,10,@strings[3,7], {exithelp}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[10]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,81+offy,26,11,13,@strings[14,10], {tabcycle}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[13]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,81+offy,26,11,14,@strings[110,1], {immediate}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[14]:=pgad;
          settagitem(@tags[4],gtst_string,long(@pgn^.edithook[1]));
          pgad:=generalgadtoolsgad(string_kind,offx+4,129+offy,179,14,15,@editstring[1],{text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[15]:=pgad;
          
          if pgn^.kind = string_kind then
            begin
              settagitem(@tags[4],gtst_string,long(@pgn^.contents[1]));
              settagitem(@tags[5],gtst_maxchars,80);
              
              pgad:=generalgadtoolsgad(string_kind,offx+4,146+offy,179,14,16,@defstring[1],{default}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
              pgn^.editwindow^.gads[16]:=pgad;
            end
           else
            begin
              settagitem(@tags[4],gtin_number,pgn^.contents2);
              settagitem(@tags[5],gtst_maxchars,12);
              
              pgad:=generalgadtoolsgad(integer_kind,offx+4,146+offy,179,14,16,@defstring[1],{default}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
              pgn^.editwindow^.gads[16]:=pgad;
            end;
            
          case pgn^.tags[2].ti_data of
            gact_stringleft   : test:=0;
            gact_stringright  : test:=1;
            gact_stringcenter : test:=3;
           end;
           
          pgn^.editwindow^.data2:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@justcycle[1]));
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,95+offy,179,14,11,@strings[4,1],{Justification}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[11]:=pgad;
          settagitem(@tags[1],gtin_number,pgn^.tags[1].ti_data);
          pgad:=generalgadtoolsgad(integer_kind,offx+4,112+offy,50,14,12,@strings[11,6],  {MaxChars}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pgn^.editwindow^.gads[12]:=pgad;
          
          
          
              opengadgeteditwindowframe(pdwn,pgn,pgad);
              if pgn^.editwindow^.pwin<>nil then
                begin
                  pgn^.editwindow^.pwin^.userdata:=pointer(pdwn);
                  gt_refreshwindow(pgn^.editwindow^.pwin,nil);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[4].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[8].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[5].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[6].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[14],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[9].ti_data);
                end;
                
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

function doeditwindowgadgets(pdwn:pdesignerwindownode):pgadget;
var
  tags      : array[1..30] of ttagitem;
  pgad      : pgadget;
  pgad2     : pgadget;
  pgn       : pgadgetnode;
  psn       : pstringnode;
  ppa       : ppointerarray;
  dummy     : long;
  loop      : long;
  pit       : pintuitext;
  pgn2      : pgadgetnode;
  dummyf    : ptextfont;
  pin       : pimagenode;
  onefont   : boolean;
  pbbn      : pbevelboxnode;
  numtags   : long;
  mytags    : ptagarray;
  pmt       : pmytag;
  sdi       : pointer;
  pmtn      : pmytag;
  w,h       : word;
begin
  onefont:=false;
  pdwn^.inputmodeb:=false;
  if pdwn^.codeoptions[17] then
    with pdwn^ do
      begin
        onefont:=true;
        wholefont.ta_ysize:=editscreen^.font^.ta_ysize;
        wholefont.ta_style:=editscreen^.font^.ta_style;
        wholefont.ta_flags:=editscreen^.font^.ta_flags;
        ctopas(editscreen^.font^.ta_name^,wholefontname);
        wholefontname:=wholefontname+#0;
        wholefont.ta_name:=@wholefontname[1];
      end
     else
      if pdwn^.codeoptions[6] then
        with pdwn^ do
          begin
            onefont:=true;
            wholefontname:=gadgetfontname;
            wholefont.ta_ysize:=gadgetfont.ta_ysize;
            wholefont.ta_style:=gadgetfont.ta_style;
            wholefont.ta_flags:=gadgetfont.ta_flags;
            wholefont.ta_name:=@wholefontname[1];
          end;
  pdwn^.gadgetfont.ta_name:=@pdwn^.gadgetfontname[1];
  
  if pdwn^.codeoptions[6] then
    dummyf:=opendiskfont(@pdwn^.gadgetfont);

  
  pdwn^.bevelglist:=nil;
  pgad:=createcontext(@pdwn^.bevelglist);
  
  loop:=0;
  pbbn:=pbevelboxnode(pdwn^.bevelboxlist.lh_head);
  while pbbn^.ln_succ<>nil do
    begin
      pgad:=generalgadtoolsgad(generic_kind,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,
                                          pbbn^.w,pbbn^.h,65000+loop,nil
                                          ,nil,0,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      if pgad<>nil then
        begin
          pgad^.activation:=pgad^.activation or gact_relverify;
          pgad^.flags:=pgad^.flags or gflg_gadghcomp;
          pgad^.gadgettype:=pgad^.gadgettype or gtyp_boolgadget;
        end;
                        
      inc(loop);
      pbbn:=pbbn^.ln_succ;
    end;
  
  pgad:=createcontext(@pdwn^.glist);
      
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      if pgad<>nil then
      while (pgn^.ln_succ<>nil) do
        begin
          if not pdwn^.codeoptions[6] then
            dummyf:=opendiskfont(@pgn^.font);
          settagitem(@tags[1],tag_done,0);
          case pgn^.kind of
            myobject_kind :
              if pgn^.tags[2].ti_tag = long(false) then 
                begin
                  w:=pgn^.w;
                  h:=pgn^.h;
                  if w<10 then w:=10;
                  if h<12 then h:=12;

                  pgad2:=generalgadtoolsgad(button_kind,pgn^.x+pdwn^.offx,pgn^.y+pdwn^.offy,
                                            w,h,pgn^.id,@pgn^.title[1],
                                            @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
                  
                  if pgad2<>nil then
                    begin
                      pgn^.pg:=pgad2;
                      pgad:=pgad2;
                    end;
                end;
            button_kind :
              begin
                if boolean(pgn^.tags[3].ti_data) then
                  settagitem(@tags[1],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[1],tag_ignore,0);
                settagitem(@tags[2],ga_immediate,long(true));
                settagitem(@tags[3],tag_done,0);
              end;
            string_kind :
              begin
                settagitem(@tags[1],gtst_maxchars,pgn^.tags[1].ti_data);
                settagitem(@tags[2],stringa_justification,pgn^.tags[2].ti_data);
                settagitem(@tags[3],stringa_replacemode,pgn^.tags[3].ti_data);
                settagitem(@tags[4],ga_tabcycle,pgn^.tags[6].ti_data);
                settagitem(@tags[5],ga_immediate,long(true));
                if boolean(pgn^.tags[8].ti_data) then
                  settagitem(@tags[6],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[6],tag_ignore,0);
                settagitem(@tags[7],gtst_string,long(@pgn^.contents[1]));
                settagitem(@tags[8],tag_done,0);
              end;
            integer_kind :
              begin
                settagitem(@tags[1],gtin_maxchars,pgn^.tags[1].ti_data);
                settagitem(@tags[2],stringa_justification,pgn^.tags[2].ti_data);
                settagitem(@tags[3],stringa_replacemode,pgn^.tags[3].ti_data);
                settagitem(@tags[4],ga_tabcycle,pgn^.tags[6].ti_data);
                settagitem(@tags[5],ga_immediate,long(true));
                if boolean(pgn^.tags[8].ti_data) then
                  settagitem(@tags[6],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[6],tag_ignore,0);
                settagitem(@tags[7],gtin_number,pgn^.contents2);
                settagitem(@tags[8],tag_done,0);
              end;
            checkbox_kind :
              begin
                if boolean(pgn^.tags[4].ti_data) then
                  settagitem(@tags[1],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[1],tag_ignore,0);
                settagitem(@tags[2],{gtcb_scaled}gt_tagbase+68,pgn^.tags[5].ti_data);
                settagitem(@tags[3],gtcb_checked,pgn^.tags[1].ti_data);
                settagitem(@tags[4],ga_immediate,long(true));
                settagitem(@tags[5],tag_done,0);
              end;
            slider_kind :
              begin
                if boolean(pgn^.tags[4].ti_data) then
                  begin
                    settagitem(@tags[1],gtsl_levelformat,long(@pgn^.datas[1]));
                    settagitem(@tags[2],gtsl_maxlevellen,pgn^.tags[5].ti_data);
                    settagitem(@tags[3],gtsl_levelplace,pgn^.tags[6].ti_data);
                   end
                 else
                  begin
                    settagitem(@tags[1],tag_ignore,0);
                    settagitem(@tags[2],tag_ignore,0);        
                    settagitem(@tags[3],tag_ignore,0);
                  end;
                settagitem(@tags[4],gtsl_min,pgn^.tags[1].ti_data);
                settagitem(@tags[5],gtsl_max,pgn^.tags[2].ti_data);
                settagitem(@tags[6],gtsl_level,pgn^.tags[3].ti_data);
                settagitem(@tags[7],pga_freedom,pgn^.tags[9].ti_data);
                settagitem(@tags[8],ga_immediate,long(true));
                settagitem(@tags[9],ga_relverify,long(true));
                if pgn^.tags[14].ti_data=long(true) then
                  settagitem(@tags[10],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[10],tag_ignore,0);
                settagitem(@tags[11],tag_done,0);
              end;
            scroller_kind :
              begin
                if pgn^.tags[12].ti_data=long(true) then
                  settagitem(@tags[1],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[1],tag_ignore,0);
                settagitem(@tags[2],tag_more,long(@pgn^.tags[1]));
              end;
            listview_kind :
              begin
                pgad2:=nil;
                if pgn^.tags[3].ti_data<>0 then
                  pgn^.tags[3].ti_tag:=gtlv_showselected;
                if pgn^.tags[3].ti_data<>0 then
                  begin
                    pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                    checkgadsize(pdwn,pgn2);
                    settagitem(@tags[1],gtst_maxchars,pgn2^.tags[1].ti_data);
                    settagitem(@tags[2],stringa_justification,pgn2^.tags[2].ti_data);
                    settagitem(@tags[3],stringa_replacemode,pgn2^.tags[3].ti_data);
                    settagitem(@tags[4],ga_tabcycle,pgn2^.tags[6].ti_data);
                    settagitem(@tags[5],ga_immediate,long(true));
                    if boolean(pgn2^.tags[8].ti_data) then
                      settagitem(@tags[6],gt_underscore,ord('_'))
                     else
                      settagitem(@tags[6],tag_ignore,0);
                    settagitem(@tags[7],tag_done,0);
                    if not onefont then
                      pgad2:=generalgadtoolsgad(pgn2^.kind,
                                                pgn2^.x+pdwn^.offx,pgn2^.y+pdwn^.offy,pgn^.w,pgn2^.h,pgn2^.id,@pgn2^.title[1],
                                                @pgn2^.font,pgn2^.flags,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1])
                     else
                      pgad2:=generalgadtoolsgad(pgn2^.kind,
                                                pgn2^.x+pdwn^.offx,pgn2^.y+pdwn^.offy,pgn^.w,pgn2^.h,pgn2^.id,@pgn2^.title[1],
                                                @pdwn^.wholefont,pgn2^.flags,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
                    pgn2^.w:=pgn^.w;
                    if pgad2=nil then
                      begin
                        telluser(pdwn^.optionswindow,
                            'Unable to create gadget : Edit gadget window opening, gadget highlighted.');
                        openeditgadget(pdwn,pgn2);
                        pgn2^.high:=true;
                        pgn2^.pg:=nil;
                      end
                     else
                      begin 
                        pgn2^.pg:=pgad2;
                        pgad:=pgad2;
                        if gadtoolsbase^.lib_version=37 then
                          pgad^.activation:=pgad^.activation or gact_immediate;
                      end;
                    {string gadget is set up as pgad if pgad2<>nil}
                  end; 
                if pgn^.tags[10].ti_data=long(false) then
                   settagitem(@tags[1],gtlv_labels,long(@listvieweditlist))
                 else
                  settagitem(@tags[1],gtlv_labels,long(@pgn^.infolist));
                tags[2].ti_tag :=gtlv_labels;
                tags[2].ti_data:=pgn^.tags[2].ti_data;
                {
                settagitem(@tags[2],gtlv_top,pgn^.tags[2].ti_data);
                }
                settagitem(@tags[3],gtlv_scrollwidth,pgn^.tags[4].ti_data);
                settagitem(@tags[4],gtlv_selected,pgn^.tags[5].ti_data);
                settagitem(@tags[5],layouta_spacing,pgn^.tags[6].ti_data);
                if boolean(pgn^.tags[9].ti_data) then
                  settagitem(@tags[6],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[6],tag_ignore,0);
                settagitem(@tags[7],pgn^.tags[3].ti_tag,long(pgad2));
                settagitem(@tags[8],tag_done,0)
              end;
            palette_kind :
              begin
                if pgn^.tags[8].ti_data=long(true) then
                  settagitem(@tags[1],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[1],tag_ignore,0);
                settagitem(@tags[2],ga_immediate,long(true));
                settagitem(@tags[3],ga_relverify,long(true));
                tags[4].ti_tag:=gtpa_depth;
                if pgn^.tags[1].ti_data=0 then
                  tags[4].ti_data:=pdwn^.screenprefs.sm_depth
                 else
                  tags[4].ti_data:=pgn^.tags[1].ti_data;
                settagitem(@tags[5],tag_more,long(@pgn^.tags[2]));
              end;
            number_kind,text_kind :
              begin
                if boolean(pgn^.tags[5].ti_data) then
                  begin
                    settagitem(@tags[1],gt_tagbase+72,pgn^.tags[6].ti_data);
                    settagitem(@tags[2],gt_tagbase+73,pgn^.tags[7].ti_data);
                    settagitem(@tags[3],gt_tagbase+74,pgn^.tags[8].ti_data);
                    settagitem(@tags[4],gt_tagbase+85,pgn^.tags[9].ti_data);
                    if pgn^.kind=number_kind then
                      begin
                        if pgn^.tags[10].ti_data<>0 then
                          settagitem(@tags[5],gt_tagbase+76,pgn^.tags[10].ti_data)
                         else
                          settagitem(@tags[5],tag_ignore,0);
                        if no0(pgn^.datas)<>'' then
                          settagitem(@tags[6],gt_tagbase+75,long(@pgn^.datas[1]))
                         else
                          settagitem(@tags[6],tag_ignore,0);
                        settagitem(@tags[7],tag_more,long(@pgn^.tags[1]));
                      end
                     else
                      settagitem(@tags[5],tag_more,long(@pgn^.tags[1]));
                  end
                 else
                  settagitem(@tags[1],tag_more,long(@pgn^.tags[1]));
                
                pgad2:=generalgadtoolsgad(generic_kind,pgn^.x+pdwn^.offx,pgn^.y+pdwn^.offy,
                                          pgn^.w,pgn^.h,pgn^.id,nil
                                          ,nil,0,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
                if pgad2<>nil then
                  begin
                    pgad:=pgad2;
                    pgn^.pg:=pgad;
                    pgad^.gadgettype:=pgad^.gadgettype or gtyp_boolgadget;
                    pgad^.activation:=pgad^.activation or gact_relverify;
                    pgad^.flags:=pgad^.flags or gflg_gadghcomp;
                  end;
              end;
            mybool_kind :
              begin
                pgad2:=generalgadtoolsgad(generic_kind,pgn^.x+pdwn^.offx,pgn^.y+pdwn^.offy,
                                          pgn^.w,pgn^.h,pgn^.id,nil,
                                          nil,0,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
                if pgad2=nil then
                  begin
                    telluser(pdwn^.optionswindow,'Unable to create gadget : Edit gadget window opening, gadget highlighted.');
                    openeditgadget(pdwn,pgn);
                    pgn^.high:=true;
                    pgn^.pg:=nil;
                  end
                 else
                  begin
                    pgn^.pg:=pgad2;
                    pit:=pintuitext(@pgn^.tags[5].ti_tag);
                    pgad:=pgad2;
                    with pgad^ do
                      begin
                        activation:=activation or pgn^.tags[1].ti_tag or gact_immediate or gact_relverify;
                        gadgettype:=gadgettype or gtyp_boolgadget;
                        flags:=gflg_gadgimage or pgn^.flags;
                        flags:=flags and (~0-gflg_disabled);
                        if boolean(pgn^.tags[1].ti_data) then
                          begin
                            with pit^ do
                              begin
                                frontpen:=pgn^.tags[3].ti_tag;
                                backpen:=pgn^.tags[3].ti_data;
                                leftedge:=pgn^.tags[2].ti_tag;
                                topedge:=pgn^.tags[2].ti_data;
                                drawmode:=pgn^.tags[4].ti_tag;
                                if not onefont then
                                  itextfont:=@pgn^.font
                                 else
                                  itextfont:=@pdwn^.wholefont;
                                itext:=@pgn^.title[1];
                                nexttext:=nil;
                              end;
                            gadgettext:=pit;
                          end
                         else
                          gadgettext:=nil;
                        pin:=pimagenode(pgn^.pointers[1]);
                        if pin<>nil then
                          begin
                            gadgetrender:=pointer(@pin^.leftedge);
                          end
                         else
                          gadgetrender:=nil;
                        pin:=pimagenode(pgn^.pointers[2]);
                        if pin<>nil then
                          begin
                            selectrender:=pointer(@pin^.LeftEdge)
                          end
                         else
                          selectrender:=nil;
                        mutualexclude:=0;
                        specialinfo:=nil;
                      end;
                  end;
              end;
            mx_kind,cycle_kind :
              begin
                dummy:=0;
                psn:=pstringnode(pgn^.infolist.lh_head);
                while (psn^.ln_succ<>nil) do
                  begin
                   inc(dummy);
                   psn:=psn^.ln_succ;
                  end;
                ppa:=ppointerarray(allocmymem(dummy*4+4,memf_clear or memf_any));
                psn:=pstringnode(pgn^.infolist.lh_head);
                if ppa<>nil then
                  begin
                    pgn^.pointers[2]:=pointer(dummy*4+4);
                    for loop:=1 to dummy do
                      begin
                        ppa^[loop]:=@psn^.st[1];
                        psn:=psn^.ln_succ;
                      end;
                    ppa^[dummy+1]:=nil;
                    pgn^.tags[3].ti_data:=long(ppa);
                    pgn^.pointers[1]:=pointer(ppa);
                  end
                 else
                  begin
                    pgn^.pointers[1]:=nil;
                    pgn^.pointers[2]:=nil;
                    telluser(pdwn^.optionswindow,memerror);
                    pgn^.tags[3].ti_data:=long(@radiofail[1]);
                  end;
                if pgn^.tags[5].ti_data=long(true) then
                  settagitem(@tags[1],gt_underscore,ord('_'))
                 else
                  settagitem(@tags[1],tag_ignore,0);
                tags[2].ti_tag:=tag_ignore;
                if boolean(pgn^.tags[6].ti_data)and(pgn^.kind=mx_kind) then
                  settagitem(@tags[2],gt_tagbase+69,long(TRUE));
                
                {****************}
                settagitem(@tags[3],gt_tagbase+71,pgn^.tags[7].ti_data);
                {****************}
                
                settagitem(@tags[4],tag_more,long(@pgn^.tags[1]));
                dummy:=0;
                psn:=pstringnode(pgn^.infolist.lh_head);
                while(psn^.ln_succ<>nil) do
                  begin
                    inc(dummy);
                    psn:=psn^.ln_succ;
                  end;
              end;
           end;
          if not ((pgn^.joined and (pgn^.kind=string_kind)) or (pgn^.kind=mybool_kind) or (pgn^.kind=myobject_kind)) then
            begin
              checkgadsize(pdwn,pgn);
              if not onefont then
                pgad2:=generalgadtoolsgad(pgn^.kind,pgn^.x+pdwn^.offx,pgn^.y+pdwn^.offy,
                                          pgn^.w,pgn^.h,pgn^.id,@pgn^.title[1],
                                     @pgn^.font,pgn^.flags,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1])
               else
                pgad2:=generalgadtoolsgad(pgn^.kind,pgn^.x+pdwn^.offx,pgn^.y+pdwn^.offy,pgn^.w,
                                          pgn^.h,pgn^.id,@pgn^.title[1],
                                     @pdwn^.wholefont,pgn^.flags,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
              if pgad2=nil then
                begin
                  telluser(pdwn^.optionswindow,'Unable to create gadget : Edit gadget window opening, gadget highlighted.');
                  openeditgadget(pdwn,pgn);
                  pgn^.high:=true;
                  pgn^.pg:=nil;
                end
               else
                begin 
                  if (pgn^.kind<>number_kind) and
                     (pgn^.kind<>text_kind) then
                    pgn^.pg:=pgad2;
                  pgad:=pgad2;
                  if (pgn^.kind=string_kind)or(pgn^.kind=integer_kind) then
                    begin
                      if gadtoolsbase^.lib_version=37 then
                        pgad^.activation:=pgad^.activation or gact_immediate;
                    end;
                end;
            end;
          pgn:=pgn^.ln_succ;
        end;      
  
  sdi:=getscreendrawinfo(pdwn^.editscreen);
                 
  if pgad<>nil then
    begin
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      while (pgn^.ln_succ<>nil) do
        begin
          if pgn^.kind=myobject_kind then
            begin
              if (pgn^.tags[2].ti_tag = long(true)) and
                 (pgn^.tags[1].ti_tag=0) then
                begin
                  numtags:=sizeoflist(@pgn^.infolist)+2;
                  mytags:=ptagarray(allocatetagitems(numtags));
                  loop:=0;
                  if mytags<>nil then
                    begin
                      
                      
                      pmt := pmytag(pgn^.infolist.lh_head);
                      while(pmt^.ln_succ<>nil) do
                        begin
                          mytags^[loop].ti_tag:=pmt^.value;
                          if pmt^.value = -1 then
                            mytags^[loop].ti_tag:=1;
                          mytags^[loop].ti_data:=0;
                          case pmt^.tagtype of
                            
                            tagtypelong,tagtypeboolean,tagtypestring,tagtypearraybyte,
                            tagtypearrayword,tagtypearraylong,tagtypearraystring,tagtypestringlist
                               :
                                mytags^[loop].ti_data:=long(pmt^.data);
                            tagtypeintuitext :
                                if pmt^.sizebuffer>0 then
                                  begin
                                    mytags^[loop].ti_data:=long(pmt^.data);
                                    pit:=pintuitext(pmt^.data);
                                    while(pit<>nil) do
                                      begin
                                        if onefont then
                                          pit^.itextfont:=@pdwn^.wholefont
                                         else
                                          pit^.itextfont:=@pgn^.font;
                                        pit:=pit^.nexttext;
                                      end;
                                  end
                                 else
                                  mytags^[loop].ti_data:=0;
                            tagtypeuser,tagtypeuser2 :
                                mytags^[loop].ti_data:=1;
                            tagtypevisualinfo :
                                mytags^[loop].ti_data:=long(pdwn^.helpwin.screenvisinfo);
                            tagtypedrawinfo :
                                mytags^[loop].ti_data:=long(sdi);
                            tagtypeimage :
                                begin
                                  pin:=pimagenode(pmt^.data);
                                  if pgn<>nil then
                                    mytags^[loop].ti_data:=long(@pin^.leftedge)
                                   else
                                    mytags^[loop].ti_data:=0;
                                end;
                            tagtypeimagedata :
                                begin
                                  pin:=pimagenode(pmt^.data);
                                  if pgn<>nil then
                                    mytags^[loop].ti_data:=long(pin^.ImageData)
                                   else
                                    mytags^[loop].ti_data:=0;
                                end;
                            tagtypeleftcoord :
                                begin
                                  mytags^[loop].ti_data:=pgn^.x+pdwn^.offx;
                                end;
                            tagtypetopcoord :
                                begin
                                  mytags^[loop].ti_data:=pgn^.y+pdwn^.offy;
                                end;
                            tagtypewidthcoord :
                                begin
                                  mytags^[loop].ti_data:=pgn^.w;
                                end;
                            tagtypeheightcoord :
                                begin
                                  mytags^[loop].ti_data:=pgn^.h;
                                end;
                            tagtypegadgetid :
                                begin
                                  mytags^[loop].ti_data:=pgn^.id;
                                end;
                            tagtypefont :
                                begin
                                  if onefont then
                                    mytags^[loop].ti_data:=long(@pdwn^.wholefont)
                                   else
                                    mytags^[loop].ti_data:=long(@pgn^.font);
                                end;
                            tagtypescreen :
                                begin
                                  mytags^[loop].ti_data:=long(pdwn^.editscreen);
                                end;
                            tagtypeobject :
                                begin
                                  pgn2:=pgadgetnode(pmt^.data);
                                  if pgn2<>nil then
                                    begin
                                      if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<
                                         getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                                        begin
                                          mytags^[loop].ti_data:=long(pgn2^.ob);
                                        end;
                                    end;
                                end;
                           end;
                          inc(loop);
                          pmt:=pmt^.ln_succ;
                        end;
                      
                      mytags^[loop+1].ti_tag:=0;
                      mytags^[loop].ti_tag:=0;
                      if pgn^.tags[3].ti_tag=0 then
                        begin
                          mytags^[loop].ti_tag:=ga_previous;
                          mytags^[loop].ti_data:=long(pgad);
                        end;
                        
                      { set all tags done  }
                      
                      { create object }
                      pgad2:=pgadget(NewobjectA(nil,@pgn^.datas[1],ptagitem(mytags)));
                      
                      pgn^.ob:=pgad2;
                      if (pgad2<>nil) and (pgn^.tags[3].ti_data=0) then
                        begin
                          pgad:=pgad2;
                        end;
                      
                      {
                      if (pgad2<>nil) and (pgn^.tags[3].ti_data=1) then
                        begin
                          if pdwn^.editwindow<>nil then
                            drawimagestate(pdwn^.editwindow^.rport,pointer(pgad2),0,0,ids_normal,sdi);
                        end;
                      }
                      
                      if (pgad2=nil) then
                        begin
                          telluser(pdwn^.optionswindow,'Could not create object.');
                          openeditgadget(pdwn,pgn);
                        end
                       else
                        begin
                          pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                          while (pgn2^.ln_succ<>nil) and (pgn<>pgn2) do
                            begin
                              pmtn:=pmytag(pgn2^.infolist.lh_head);
                              while(pmtn^.ln_succ<>nil) do
                                begin
                                  if pmtn^.tagtype=tagtypeobject then
                                    if pgadgetnode(pmtn^.data)=pgn then
                                      begin
                                        settagitem(@tags[1],pmtn^.value,long(pgn^.ob));
                                        settagitem(@tags[2],0,0);
                                        if pgn^.ob<>nil then
                                          if (pgn2^.tags[2].ti_data<>0) then
                                            loop:=setgadgetattrsa(pgn2^.ob,pdwn^.editwindow,nil,@tags[1])
                                           else
                                            loop:=setattrsa(pgn2^.ob,@tags[1]);
                                      end;
                                  pmtn:=pmtn^.ln_succ;
                                end;
                              pgn2:=pgn2^.ln_succ;  
                              
                            end;
                        end;
                      
                      { create object done }
                      
                      freetagitems(ptagitem(mytags));
                    end;
                end;
            end;
          pgn:=pgn^.ln_succ;
        end;
    end;
  if sdi<>nil then
    freescreendrawinfo(pdwn^.editscreen,sdi);
  
  doeditwindowgadgets:=pgad;
  
end;

function openeditwindow(pdwn:pdesignerwindownode):boolean;
var
  tags      : array[1..35] of ttagitem;
  pgad      : pgadget;
  pgad2     : pgadget;
  pgn       : pgadgetnode;
  psn       : pstringnode;
  ppa       : ppointerarray;
  dummy     : long;
  loop      : long;
  pgn2      : pgadgetnode;
  dummyf    : ptextfont;
begin
  waiteverything;
  pdwn^.fontx:=pdwn^.editscreen^.rastport.font^.tf_xsize;
  pdwn^.fonty:=pdwn^.editscreen^.rastport.font^.tf_ysize;
  if pdwn^.gimmezz or pdwn^.borderless then
    begin
      if pdwn^.gimmezz then
        begin
          if pdwn^.offx<>0 then
            pdwn^.w:=pdwn^.w+pdwn^.offx;
          if pdwn^.offy<>0 then
            pdwn^.h:=pdwn^.h+pdwn^.offy;
        end;
      pdwn^.offx:=0;
      pdwn^.offy:=0;
    end
   else
    begin
      pdwn^.offx:=pdwn^.editscreen^.wborleft;
      pdwn^.offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
    end;
  pdwn^.inputglist:=Nil;
  pdwn^.inputglist:=createcontext(@pdwn^.inputglist);
  if pdwn^.inputglist<>nil then
    begin
      pdwn^.inputgadget:=generalgadtoolsgad(generic_kind,pdwn^.offx,pdwn^.offy,pdwn^.screenprefs.sm_width,
                                            pdwn^.screenprefs.sm_height,9999,Nil,Nil,0,
                                            pdwn^.helpwin.screenvisinfo,pdwn^.inputglist,Nil,Nil);
      if pdwn^.inputgadget=Nil then
        begin
          freegadgets(pdwn^.inputglist);
          pdwn^.inputglist:=nil;
          telluser(pdwn^.optionswindow,'Cannot create input gadget.');
        end
       else
        begin
          pdwn^.inputgadget^.flags:=GFLG_Gadghnone;
          pdwn^.inputgadget^.activation:=gact_relverify or gact_immediate;
          pdwn^.inputgadget^.gadgetrender:=Nil;
          pdwn^.inputgadget^.selectrender:=Nil;
          pdwn^.inputgadget^.gadgettype:=pdwn^.inputgadget^.gadgettype or gtyp_boolgadget;
        end;
    end
   else
    telluser(pdwn^.optionswindow,'Cannot create input gadget.');
  openeditwindow:=false;
  if pdwn^.editscreen<>nil then
    begin
      if true then
        begin
          settagitem(@tags[1],wa_left,pdwn^.x);
          settagitem(@tags[2],wa_top,pdwn^.y);
          if pdwn^.innerw=0 then
            settagitem(@tags[3],wa_width,pdwn^.w+pdwn^.offx)
           else
            settagitem(@tags[3],wa_innerwidth,pdwn^.innerw);
          if pdwn^.innerh=0 then
            settagitem(@tags[4],wa_height,pdwn^.h+pdwn^.offy)
           else
            settagitem(@tags[4],wa_innerheight,pdwn^.innerh);
          settagitem(@tags[5],wa_closegadget,long(pdwn^.closegad));
          if no0(pdwn^.title)<>'' then
            settagitem(@tags[6],wa_title,long(@pdwn^.title[1]))
           else
            settagitem(@tags[6],tag_ignore,0);
          settagitem(@tags[7],wa_dragbar,long(pdwn^.dragbar));
          settagitem(@tags[8],wa_activate,long(true));
          settagitem(@tags[9],wa_autoadjust,long(true));
          settagitem(@tags[10],wa_flags,wflg_reportmouse);
          settagitem(@tags[11],wa_depthgadget,long(pdwn^.depthgad));
          settagitem(@tags[12],wa_menuhelp,long(pdwn^.menuhelp));
          settagitem(@tags[13],wa_smartrefresh,long(pdwn^.smartrefresh));
          settagitem(@tags[14],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[15],wa_sizegadget,long(pdwn^.sizegad));
          settagitem(@tags[16],wa_sizebright,long(pdwn^.sizebright));
          settagitem(@tags[17],wa_sizebbottom,long(pdwn^.sizebbottom));
          settagitem(@tags[18],wa_minwidth,pdwn^.minw);
          settagitem(@tags[19],wa_minheight,pdwn^.minh);
          settagitem(@tags[20],wa_maxwidth,pdwn^.maxw);
          settagitem(@tags[21],wa_maxheight,pdwn^.maxh);
          if pdwn^.usezoom then
            settagitem(@tags[22],wa_zoom,long(@pdwn^.zoom[1]))
           else
            settagitem(@tags[22],tag_ignore,0);
          settagitem(@tags[23],wa_reportmouse,long(true));
          settagitem(@tags[24],1,0);
          settagitem(@tags[25],wa_gimmezerozero,long(pdwn^.gimmezz));
          settagitem(@tags[26],wa_borderless,long(pdwn^.borderless));
          settagitem(@tags[27],wa_simplerefresh,long(pdwn^.simplerefresh));
          settagitem(@tags[28],wa_backdrop,long(pdwn^.backdrop));
          if pdwn^.backdrop then
            begin
              if pdwn^.backoptwin then
                begin
                  {
                  telluser(pdwn^.optionswindow,
                  'Cannot make backdrop because Tools window is backdrop, change this in prefs.');
                  }
                  settagitem(@tags[28],wa_backdrop,long(false));
                end;
            end;
          settagitem(@tags[29],wa_nocarerefresh,long(pdwn^.nocarerefresh));
          settagitem(@tags[30],Tag_Done,0);
          pdwn^.editwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                 slideridcmp or
                                                                 scrolleridcmp or
                                                                 listviewidcmp or
                                                                 checkboxidcmp or
                                                                 stringidcmp or
                                                                 idcmp_menupick or
                                                                 cycleidcmp or
                                                                 paletteidcmp or
                                                                 textidcmp or
                                                                 numberidcmp or
                                                                 integeridcmp or
                                                                 buttonidcmp or
                                                                 mxidcmp or
                                                                 idcmp_vanillakey or
                                                                 idcmp_rawkey or
                                                                 idcmp_refreshwindow or
                                                                 idcmp_inactivewindow or
                                                                 idcmp_mousemove or
                                                                 idcmp_mousebuttons or
                                                                 idcmp_changewindow or
                                                                 idcmp_newsize);
          if pdwn^.editwindow<>nil then
            begin
              setpointer(pdwn^.editwindow,pwaitpointer,16,16,-6,0);
              
              pgad:=doeditwindowgadgets(pdwn);
              
              rendeditwindow(pdwn);
              
              if 0=addglist(pdwn^.editwindow,pdwn^.glist,65535,-1,nil) then;
              refreshgadgets(pdwn^.glist,pdwn^.editwindow,nil);
              
              updatewindowsizes(pdwn);
              pdwn^.editwindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.editwindow,nil);
              openeditwindow:=true;
              pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
              
              if errorstring<>'' then
                setwindowtitles(pdwn^.editwindow,pointer(-1),@errorstring[1]);
              if pdwn^.mmenu<>nil then
                if setmenustrip(pdwn^.editwindow,pdwn^.mmenu) then;
              
              if pdwn^.mxchoice=12 then
                begin
                  if 0=removeglist(pdwn^.editwindow,pdwn^.glist,~0) then;
                  if 0=addglist(pdwn^.editwindow,pdwn^.bevelglist,65535,~0,Nil) then;
                end;
              
            end;
        end
       else
        begin
          freegadgets(pdwn^.glist);
          pdwn^.glist:=nil;
          telluser(pdwn^.optionswindow,'Unable to create gadgets for edit window');
        end;
    end;
  unwaiteverything;
end;

procedure closeeditwindow(pdwn:pdwsignerwindownode);
var
  dummy : long;
  pgn   : pgadgetnode;
  psn   : pstringnode;
begin
  if pdwn^.editwindow<>nil then
    begin
      if pdwn^.editwindow^.menustrip<>nil then
        clearmenustrip(pdwn^.editwindow);
      closewindowsafely(pdwn^.editwindow);
    end;
  pdwn^.editwindow:=nil;
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      
      pgn^.pg:=nil;
      if (pgn^.kind=mx_kind)or(pgn^.kind=cycle_kind) then
        if (pgn^.pointers[1]<>nil)and(pgn^.pointers[2]<>nil) then
          begin
            freemymem(pgn^.pointers[1],long(pgn^.pointers[2]));
            pgn^.pointers[1]:=nil;
            pgn^.pointers[2]:=nil;
          end;
      pgn:=pgn^.ln_succ;
    end;
  
  if pdwn^.glist<>nil then
    freegadgets(pdwn^.glist);
  pdwn^.glist:=nil;
  
  if pdwn^.bevelglist<>nil then
    freegadgets(pdwn^.bevelglist);
  pdwn^.bevelglist:=nil;
  
  if pdwn^.inputglist<>Nil then
    freegadgets(pdwn^.inputglist);
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if pgn^.ob<>nil then
            begin
              if pgn^.tags[4].ti_tag<>0 then
                disposeobject(pointer(pgn^.ob));
              pgn^.ob:=nil;
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
  pdwn^.inputglist:=Nil;
end;

procedure rendeditwindow(pdwn:pdesignerwindownode);
var
  tags  : array [1..3] of ttagitem;
  pbbn  : pbevelboxnode;
  pgn   : pgadgetnode;
  ptn   : ptextnode;
  psin  : psmallimagenode;
  dummy : ptextfont;
  sdi   : pdrawinfo;
begin
  sdi:=getscreendrawinfo(pdwn^.editscreen);
              
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if (pgn^.ob<>nil) and (pgn^.tags[3].ti_data=1) then
            begin
              if sdi<>nil then
                begin
                  if pdwn^.editwindow<>nil then
                    drawimagestate(pdwn^.editwindow^.rport,pointer(pgn^.ob),0,0,ids_normal,sdi);
                  freescreendrawinfo(pdwn^.editscreen,sdi);
                end;
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
  if sdi<>nil then
    freescreendrawinfo(pdwn^.editscreen,sdi);

  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(screenvisualinfo));
  settagitem(@tags[3],tag_done,0);
  pbbn:=pbevelboxnode(pdwn^.bevelboxlist.lh_head);
  while pbbn^.ln_succ<>nil do
    begin
      case pbbn^.beveltype of
        0: drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[2]);
        1: drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[1]);
        2: begin
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[2]);
             if pbbn^.w<8 then pbbn^.w:=8;
             if pbbn^.h<4 then pbbn^.h:=4;
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+4+pdwn^.offx,pbbn^.y+2+pdwn^.offy,pbbn^.w-8,pbbn^.h-4,@tags[1]);
           end;
        3: begin
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[1]);
             if pbbn^.w<8 then pbbn^.w:=8;
             if pbbn^.h<4 then pbbn^.h:=4;
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+4+pdwn^.offx,pbbn^.y+2+pdwn^.offy,pbbn^.w-8,pbbn^.h-4,@tags[2]);
           end;
        4: begin
             settagitem(@tags[1],gt_tagbase+77,2);
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[1]);
           end;
        5: begin
             settagitem(@tags[1],gt_tagbase+77,3);
             drawbevelboxa(pdwn^.editwindow^.rport,pbbn^.x+pdwn^.offx,pbbn^.y+pdwn^.offy,pbbn^.w,pbbn^.h,@tags[1]);
           end;
       end;
      pbbn:=pbbn^.ln_succ;
    end;
  ptn:=ptextnode(pdwn^.textlist.lh_head);
  while (ptn^.ln_succ<>nil) do
    begin
      dummy:=opendiskfont(@ptn^.ta);
      if ptn^.screenfont then
        ptn^.pta:=pdwn^.editscreen^.font
       else
        ptn^.pta:=@ptn^.ta;
      if ptn^.placed then
        printitext(pdwn^.editwindow^.rport,pintuitext(@ptn^.frontpen),pdwn^.offx,pdwn^.offy);
      ptn:=ptn^.ln_succ;
    end;
  psin:=psmallimagenode(pdwn^.imagelist.lh_head);
  while(psin^.ln_succ<>nil) do
    begin
      if (psin^.placed)and(psin^.pin<>nil) then
        drawimage(pdwn^.editwindow^.rport,@psin^.pin^.leftedge,psin^.x+pdwn^.offx,psin^.y+pdwn^.offy);
      psin:=psin^.ln_succ;
    end;
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while pgn^.ln_succ<>nil do
    begin
      if pgn^.high and (not((pgn^.joined) and (pgn^.kind=string_kind))) then
        highlightgadget(pgn,pdwn);
      pgn:=pgn^.ln_succ
    end;
end;

procedure rendmainwindow;
var
  offx : word;
  offy : word;
  tags : array [1..2] of ttagitem;
  pen  : byte;
begin
  settagitem(@tags[1],gt_visualinfo,long(screenvisualinfo));
  settagitem(@tags[2],tag_done,0);
  offx:=mainwindow^.borderleft+4;
  offy:=mainwindow^.bordertop;
  pen:=2;
  if defaultscreenmode.sm_depth=1 then
    pen:=1;
  printstring(mainwindow,74+offx,7+offy,'Intuition Interface',pen,0,@ttopaz80);
  printstring(mainwindow,333+offx,8+offy,'Options',pen,0,@ttopaz80);
  drawbevelboxa(mainwindow^.rport,offx+305,offy+3,116,144,@tags[1]);
  drawbevelboxa(mainwindow^.rport,offx+3,offy+3,295,144,@tags[1]);
end;

function OpenMainWindow:boolean;
const
  demostring : string ='Registered Users Click Here To Upgrade'#0;
var
  tags : array[1..17] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  settagitem(@tags[1],gtlv_showselected,0);
  settagitem(@tags[2],tag_done,0);
  settagitem(@tags[3],gtcy_labels,long(@mainlabels));
  settagitem(@tags[4],gt_underscore,ord('_'));
  settagitem(@tags[5],tag_done,0);
  offx:=myscreen^.wborleft+4;
  offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
  openmainwindow:=false;
  pgad:=createcontext(@mainwindowglist);
  pgad:=generalgadtoolsgad(listview_kind,14+offx,36+offy,274,88,1,nil,           {listview}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[1]);
  mainwindowgadgets[1]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,19+offy,84,15,2,@strings[13,10], {About}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[2]:=pgad;
  pgad:=generalgadtoolsgad(cycle_kind,14+offx,18+offy,274,15,3,nil,              {cycle gadget}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[3]);
  mainwindowgadgets[3]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,37+offy,84,15,4,@strings[73,6],  {Prefs}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[4]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,55+offy,84,15,5,@strings[7,1],   {code}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[5]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,73+offy,84,15,6,@strings[8,1],   {load}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[6]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,91+offy,84,15,7,@strings[9,1],   {save}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[7]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,109+offy,84,15,8,@strings[10,1], {generate}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[8]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,14+offx,127+offy,84,15,9,@strings[11,1],  {new}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[9]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,110+offx,127+offy,84,15,10,@strings[12,1],{delete}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[10]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,205+offx,127+offy,84,15,11,@strings[13,1],{edit}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[11]:=pgad;
  pgad:=generalgadtoolsgad(button_kind,320+offx,127+offy,84,15,12,@strings[14,1],{help}
                           @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[4]);
  mainwindowgadgets[12]:=pgad;
  
  if wasdemoversion then
    begin
      offy:=offy+22;
      pgad:=generalgadtoolsgad(button_kind,3+offx,130+offy,418,17,99,@demostring[1],{upgrade}
                               @ttopaz80,0,screenvisualinfo,pgad,nil,nil);
      upgradegad:=pgad;
    end;
  
  if pgad<>nil then
    begin
      settagitem(@tags[1],wa_left,100);
      settagitem(@tags[2],wa_top,50);
      settagitem(@tags[3],wa_width,430+offx);
      settagitem(@tags[4],wa_height,153+offy);
      settagitem(@tags[5],wa_closegadget,long(true));
      settagitem(@tags[6],wa_title,long(@strings[15,1]));
      settagitem(@tags[7],wa_dragbar,long(true));
      settagitem(@tags[8],wa_activate,long(true));
      settagitem(@tags[9],wa_autoadjust,long(true));
      settagitem(@tags[10],wa_gadgets,long(mainwindowglist));
      settagitem(@tags[11],wa_depthgadget,long(true));
      settagitem(@tags[12],wa_autoadjust,long(true));
      settagitem(@tags[13],wa_smartrefresh{ Experiment },long(true));
      settagitem(@tags[14],wa_zoom,long(@mainwindowzoom));
      settagitem(@tags[15],wa_screentitle,long(@frontscreentitle[1]));
      settagitem(@tags[16],Tag_Done,0);
      mainwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                       idcmp_refreshwindow or
                                                       cycleidcmp or
                                                       listviewidcmp or
                                                       buttonidcmp or
                                                       WA_MenuHelp or
                                                       IDCMP_VanillaKey or
                                                       idcmp_menupick
                                                       );
      if mainwindow<>nil then
        begin
          setpointer(mainwindow,pwaitpointer,16,16,-6,0);
          {
          mainappwindow:=addappwindowa(0,0,mainwindow,myprogramport,nil);
          }
          if makemenumainwindowmenu(screenvisualinfo) then
            if not setmenustrip(mainwindow,mainwindowmenu) then
              begin
                freemenus(mainwindowmenu);
                mainwindowmenu:=nil;
              end;
          mainwindownode.ln_type:=mainwindownodetype;
          mainwindow^.userdata:=pointer(@mainwindownode);
          openmainwindow:=true;
          gt_refreshwindow(mainwindow,nil);
          rendmainwindow;
        end;
    end
   else
    telluser(nil,'Unable to create gadgets for main window.');
end;

procedure closemainwindow;
begin
  
  {
  if mainappwindow<>nil then
    if removeappwindow(mainappwindow) then;     }{ OS bugged : always true. }{
  }
  
  if mainwindow<>nil then
    begin
      if mainwindowmenu<>nil then
        begin
          clearmenustrip(mainwindow);
          freemenus(mainwindowmenu);
        end;
      mainwindowmenu:=nil;
      closewindowsafely(mainwindow);
    end;
  if mainwindowglist<>nil then
    freegadgets(mainwindowglist);
  mainwindow:=nil;
  mainwindowglist:=nil;
end;

procedure closelibwindow;
begin
  if libwindow<>nil then
    begin
      if libmenu<>nil then
        begin
          clearmenustrip(libwindow);
          freemenus(libmenu);
          libmenu:=nil;
        end;
      closewindowsafely(libwindow);
    end;
  if libwindowglist<>nil then
    freegadgets(libwindowglist);
  libwindowglist:=nil;
  libwindow:=nil;
end;

procedure rendlibwindow;
var
  offx : word;
  offy : word;
  tags : array [1..2] of ttagitem;
  pen  : byte;
begin
  settagitem(@tags[1],gt_visualinfo,long(screenvisualinfo));
  settagitem(@tags[2],tag_done,0);
  offx:=libwindow^.borderleft+4;
  offy:=libwindow^.bordertop;
  pen:=2;
  if defaultscreenmode.sm_depth=1 then
    pen:=1;
  printstring(libwindow,94+offx,7+offy,'Library List',pen,0,@ttopaz80);
  drawbevelboxa(libwindow^.rport,offx+3,offy+3,295,138,@tags[1]);
  drawbevelboxa(libwindow^.rport,offx+3,offy+145,295,29,@tags[1]);
end;

procedure OpenLibWindow;
var
  tags : array[0..16] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  pln  : plibnode;
  pb   : pbyte;
  loop : byte;
begin
  waiteverything;
  if libwindow=nil then
    begin
      libselected:=0;
      pln:=plibnode(tliblist.lh_head);
      settagitem(@tags[0],gtlv_labels,long(@tliblist));
      settagitem(@tags[1],gtlv_showselected,0);
      settagitem(@tags[2],gtlv_selected,0);
      settagitem(@tags[3],tag_done,0);
      settagitem(@tags[4],gtcb_checked,long(pln^.open));
      settagitem(@tags[5],gt_underscore,ord('_'));
      settagitem(@tags[6],tag_done,0);
      settagitem(@tags[7],GTIN_number,0);
      settagitem(@tags[8],GTIN_maxchars,4);
      settagitem(@tags[9],GT_underscore,ord('_'));
      settagitem(@tags[10],tag_done,0);
      settagitem(@tags[11],gtcb_checked,long(pln^.abortonfail));
      settagitem(@tags[12],GT_underscore,ord('_'));
      settagitem(@tags[13],tag_done,0);
      loop:=0;
      repeat
        pb:=@librarynames[loop,1];
        pln^.opene:=pln^.open;
        pln^.versione:=pln^.version;
        pln^.abortonfaile:=pln^.abortonfail;
        if pln^.opene=true then
          pb^:=ord('>')
         else
          pb^:=32;
        pln:=pln^.ln_succ;
        inc(loop);
      until pln^.ln_succ=nil;
      offx:=myscreen^.wborleft+4;
      offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
      pgad:=createcontext(@libwindowglist);
      pgad:=generalgadtoolsgad(listview_kind,14+offx,19+offy,274,88,1,nil, {list view}
                               @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[0]);
      libwindowgadgets[1]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,14+offx,152+offy,84,15,2,@strings[16,1], {ok}
                               @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[5]);
      libwindowgadgets[2]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,110+offx,152+offy,84,15,3,@strings[14,1],{help}
                               @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[5]);
      libwindowgadgets[3]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,205+offx,152+offy,84,15,4,@strings[17,1],{cancel}
                               @ttopaz80,0,screenvisualinfo,pgad,nil,@tags[5]);
      libwindowgadgets[4]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,14+offx,110+offy,0,0,5,@strings[18,1],{open}
                               @ttopaz80,Placetext_right,screenvisualinfo,pgad,nil,@tags[4]);
      libwindowgadgets[5]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,151+offx,110+offy,0,0,6,@strings[19,1],{abort on fail}
                               @ttopaz80,Placetext_right,screenvisualinfo,pgad,nil,@tags[11]);
      libwindowgadgets[6]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,14+offx,123+offy,100,15,7,@strings[20,1],{version to request}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[7]);
      libwindowgadgets[7]:=pgad;
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_left,500);
          settagitem(@tags[2],wa_top,100);
          settagitem(@tags[3],wa_width,312+offx);
          settagitem(@tags[4],wa_height,179+offy);
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_title,long(@strings[15,1]));
          settagitem(@tags[7],wa_dragbar,long(true));
          settagitem(@tags[8],wa_activate,long(true));
          settagitem(@tags[9],wa_autoadjust,long(true));
          settagitem(@tags[10],wa_gadgets,long(libwindowglist));
          settagitem(@tags[11],wa_depthgadget,long(true));
          settagitem(@tags[12],wa_autoadjust,long(true));
          settagitem(@tags[13],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[14],wa_screentitle,long(@frontscreentitle[1]));
          settagitem(@tags[15],Tag_Done,0);
          libwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                          listviewidcmp or
                                                          checkboxidcmp or
                                                          idcmp_menupick or
                                                          integeridcmp or
                                                          idcmp_vanillakey or
                                                          buttonidcmp or
                                                          idcmp_refreshwindow);
          if libwindow<>nil then
            begin
              libwindownode.ln_type:=libwindownodetype;
              libwindow^.userdata:=pointer(@libwindownode);
              gt_refreshwindow(libwindow,nil);
              rendlibwindow;
              writelibdata(plibnode(tliblist.lh_head));
              if makemenulibmenu(screenvisualinfo) then
                begin
                  if not setmenustrip(libwindow,libmenu) then
                    begin
                      freemenus(libmenu);
                      libmenu:=nil;
                    end;
                end;
                
            end;
        end
       else
        begin
          freegadgets(libwindowglist);
          telluser(mainwindow,'Unable to create gadgets for lib window.');
        end;
    end
   else
    begin
      windowtofront(libwindow);
      activatewindow(libwindow);
    end;
  unwaiteverything;
end;

procedure HelpWindow(pwn:pwindownode;n:word);
const
  amigaguidefilename : string[15] = 'Designer.Guide'#0;
  basename : string[9] = 'Designer'#0;
  clientport : string[14] = 'DESIGNER_HELP'#0;
var
  m           : pointer;
  tags        : array[1..16] of ttagitem;
  pgad        : pgadget;
  offx        : integer;
  offy        : integer;
  phn         : phelpnode;
  agm         : pamigaguidemsg;
  done        : boolean;
  currentline : string;
  f           : bptr;
  buf         : array[0..256] of byte;
  filename    : string;
  sizebuf     : word;
  comstr      : string;
  gotmsg      : boolean;
begin  
  waiteverything;
  if amigaguidebase<>nil then
    begin
      if (amigaguidehandle=nil) or (pwn^.pscr<>amigaguidescreen) then
        begin
          if (amigaguidehandle<>nil) then
            begin
              closeamigaguide(amigaguidehandle);
              amigaguidehandle:=nil;
            end;
          amigaguidescreen:=pwn^.pscr;
          
          nag.nag_lock:=getprogramdir;
          nag.nag_name:=@amigaguidefilename[1];
          nag.nag_screen:=pwn^.pscr;
          nag.nag_pubscreen:=nil;
          nag.nag_hostport:=nil;
          nag.nag_clientport:=@clientport[1];
          nag.nag_basename:=@basename[1];
          nag.nag_flags:=0;
          nag.nag_context:=@helpcontext;
          nag.nag_node:=nil;
          nag.nag_line:=0;
          nag.nag_extens:=nil;
          nag.nag_client:=nil;
          amigaguidehandle:=pointer(openamigaguideasyncA(@nag,nil));
          if amigaguidehandle=nil then
            telluser(mainwindow,'Unable to open amiga guide help display.')
           else
            begin
              amigaguidesig:=(amigaguidesignal(amigaguidehandle){ shr 24});
              setamigaguidenum:=n;
            end;
        end
       else
        begin
          if amigaguidehandle<>nil then
            begin
              setamigaguidenum:=n;
              if setamigaguidecontextA(amigaguidehandle,n,nil) then;
              if sendamigaguidecontextA(amigaguidehandle,nil) then;
            end;
        end;
    end
   else
    telluser(mainwindow,'Need AmigaGuide To Use Help.');
  inputmode:=1;
  unwaiteverything;
end;

procedure rendtextlistwindow(pdwn:pdesignerwindownode);
var
  tags      : array[1..5] of ttagitem;
  offx,offy : word;
begin
  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=pdwn^.editscreen^.wborleft;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
  drawbevelboxa(pdwn^.textlistwindow^.rport,offx+6,offy+135,539,29,@tags[2]);
  drawbevelboxa(pdwn^.textlistwindow^.rport,offx+10,offy+137,531,25,@tags[1]);
  drawbevelboxa(pdwn^.textlistwindow^.rport,offx+6,offy+2,539,129,@tags[2]);
end;

procedure opentextlistwindow(pdwn:pdesignerwindownode);
var
  tags : array[1..15] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  if pdwn^.textlistwindow=nil then
    begin
      pdwn^.textgadsdis:=false;
      settagitem(@tags[1],gtlv_selected,~0);
      settagitem(@tags[2],gtlv_labels,long(@pdwn^.textlist));
      settagitem(@tags[3],tag_done,0);
      settagitem(@tags[4],gtpa_depth,pdwn^.screenprefs.sm_depth);
      settagitem(@tags[5],gtpa_indicatorwidth,26);
      settagitem(@tags[6],tag_done,0);
      settagitem(@tags[7],gt_underscore,ord('_'));
      settagitem(@tags[8],tag_done,0);
      offx:=pdwn^.editscreen^.wborleft+4;
      offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
      pgad:=createcontext(@pdwn^.textlistglist);
      pgad:=generalgadtoolsgad(listview_kind,15+offx,5+offy,249,80,1,nil,
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pdwn^.textgadgets[1]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+272,5+offy,55,13,2,@strings[42,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {left edge}
      pdwn^.textgadgets[2]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+408,5+offy,55,13,3,@strings[43,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {top edge}
      pdwn^.textgadgets[3]:=pgad;
      pgad:=generalgadtoolsgad(palette_kind,offx+272,55+offy,178,14,4,@strings[132,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);  {frontpen}
      pdwn^.textgadgets[4]:=pgad;
      pgad:=generalgadtoolsgad(palette_kind,offx+272,71+offy,178,14,5,@strings[133,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);  {backpen}
      pdwn^.textgadgets[5]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+13,106+offy,80,16,6,@strings[11,1],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);  {_new}
      pgad:=generalgadtoolsgad(button_kind,offx+101,106+offy,80,16,7,@strings[12,1],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);  {_delete}
      pdwn^.textgadgets[11]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+189,106+offy,80,16,8,@strings[36,1],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);  {_font...}
      pdwn^.textgadgets[12]:=pgad;
      
      pgad:=generalgadtoolsgad(button_kind,offx+277,106+offy,80,16,9,@strings[79,1],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);  {_place}
      pdwn^.textgadgets[13]:=pgad;
      pgad:=generalgadtoolsgad(string_kind,offx+16,88+offy,360,14,10,@strings[142,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); { string}
      pdwn^.textgadgets[6]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+273,21+offy,26,11,11,@strings[138,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {blockpen}
      pdwn^.textgadgets[7]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+273,37+offy,26,11,12,@strings[139,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {complement}
      pdwn^.textgadgets[8]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+408,21+offy,26,11,13,@strings[140,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {jam2}
      pdwn^.textgadgets[9]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+408,37+offy,26,11,14,@strings[141,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); {inversvid}
      pdwn^.textgadgets[10]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+365,106+offy,80,16,15,@strings[14,1],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]); {_help}
      pgad:=generalgadtoolsgad(button_kind,offx+453,106+offy,80,16,16,@strings[153,6],
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]); {_update}
      
      
      pgad:=generalgadtoolsgad(checkbox_kind,offx+425,88+offy,0,0,999,@strings[134,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem); { screen font}
      pdwn^.textgadgets[14]:=pgad;

      
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.textlistglist));
          settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-557-offx)/2));
          settagitem(@tags[7],wa_top,100);
          settagitem(@tags[8],wa_width,555+offx);
          settagitem(@tags[9],wa_height,168+offy);
          settagitem(@tags[10],wa_title,long(@strings[37,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],Tag_Done,0);
          pdwn^.textlistwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                     cycleidcmp or
                                                                     listviewidcmp or
                                                                     buttonidcmp or
                                                                     idcmp_menupick or
                                                                     WA_MenuHelp or
                                                                     idcmp_refreshwindow or
                                                                     IDCMP_VanillaKey);
          if pdwn^.textlistwindow<>nil then
            begin
              pdwn^.textlistwindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.textlistwindow,nil);
              rendtextlistwindow(pdwn);
              if pdwn^.textselected=nil then
                disableselectontextlistwindow(pdwn)
               else
                setalltextlistwindowgadgets(pdwn);
              if pdwn^.listmenu<>nil then
                if setmenustrip(pdwn^.textlistwindow,pdwn^.listmenu) then;
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Unable to create gadgets for text list window');
    end
   else
    begin
      activatewindow(pdwn^.textlistwindow);
      windowtofront(pdwn^.textlistwindow);
    end;
end;

procedure closetextlistwindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.textlistwindow<>nil then
    begin
      if pdwn^.textlistwindow^.menustrip<>nil then
        clearmenustrip(pdwn^.textlistwindow);
      closewindowsafely(pdwn^.textlistwindow);
    end;
  if pdwn^.textlistglist<>nil then
    freegadgets(pdwn^.textlistglist);
  pdwn^.textlistglist:=nil;
  pdwn^.textlistwindow:=nil;
  pdwn^.textgadgets[1]:=nil;
end;

procedure opensizeswindow(pdwn:pdesignerwindownode);
const
  mys : array [1..3] of string[8] =
    (
    'InnerW'#0,
    'InnerH'#0,
    '_Update'#0
    );
var
  tags : array[1..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  settagitem(@tags[1 ],gtin_number,pdwn^.maxw);
  settagitem(@tags[2 ],tag_done,0);
  settagitem(@tags[3 ],gtin_number,pdwn^.maxh);
  settagitem(@tags[4 ],tag_done,0);
  settagitem(@tags[5 ],gtin_number,pdwn^.minw);
  settagitem(@tags[6 ],tag_done,0);
  settagitem(@tags[7 ],gtin_number,pdwn^.minh);
  settagitem(@tags[8 ],tag_done,0);
  settagitem(@tags[9 ],gtin_number,pdwn^.zoom[1]);
  settagitem(@tags[10],tag_done,0);
  settagitem(@tags[11],gtin_number,pdwn^.zoom[2]);
  settagitem(@tags[12],tag_done,0);
  settagitem(@tags[13],gtin_number,pdwn^.zoom[3]);
  settagitem(@tags[14],tag_done,0);
  settagitem(@tags[15],gtin_number,pdwn^.zoom[4]);
  settagitem(@tags[16],tag_done,0);
  settagitem(@tags[17],gtin_number,pdwn^.x);
  settagitem(@tags[18],tag_done,0);
  settagitem(@tags[19],gtin_number,pdwn^.y);
  settagitem(@tags[20],tag_done,0);
  settagitem(@tags[21],gtin_number,pdwn^.w+pdwn^.offx);
  settagitem(@tags[22],tag_done,0);
  settagitem(@tags[23],gtin_number,pdwn^.h+pdwn^.offy);
  settagitem(@tags[24],tag_done,0);
  if pdwn^.sizeswindow=nil then
    begin
      offx:=pdwn^.editscreen^.wborleft+4;
      offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
      pgad:=createcontext(@pdwn^.sizesglist);
      pgad:=generalgadtoolsgad(integer_kind,offx+25,15+offy,86,12,1,@strings[38,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pdwn^.sizesgads[1]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,31+offy,86,12,2,@strings[39,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[3]);
      pdwn^.sizesgads[2]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,15+offy,86,12,3,@strings[40,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[5]);
      pdwn^.sizesgads[3]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,31+offy,86,12,4,@strings[41,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.sizesgads[4]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,64+offy,86,12,5,@strings[42,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[9]);
      pdwn^.sizesgads[5]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,80+offy,86,12,6,@strings[43,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[11]);
      pdwn^.sizesgads[6]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,64+offy,86,12,7,@strings[44,2],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[13]);
      pdwn^.sizesgads[7]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,80+offy,86,12,8,@strings[45,2],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[15]);
      pdwn^.sizesgads[8]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,111+offy,86,12,9,@strings[42,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[17]);
      pdwn^.sizesgads[9]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,127+offy,86,12,10,@strings[43,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[19]);
      pdwn^.sizesgads[10]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,111+offy,86,12,11,@strings[44,2],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[21]);
      pdwn^.sizesgads[11]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,127+offy,86,12,12,@strings[45,2],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[23]);
      pdwn^.sizesgads[12]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+25,143+offy,86,12,13,@mys[1,1],{innerw}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.sizesgads[13]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+200,143+offy,86,12,14,@mys[2,1],{innerh}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.sizesgads[14]:=pgad;
      settagitem(@tags[1],gt_underscore,ord('_'));
      settagitem(@tags[2],tag_done,0);
      pgad:=generalgadtoolsgad(button_kind,offx+4,164+offy,79,12,15,@strings[16,1], {ok}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+310,164+offy,79,12,17,@strings[17,1], {cancel}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+208,164+offy,79,12,16,@strings[14,1], {help}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+106,164+offy,79,12,18,@mys[3,1], {update}
                               @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.sizesglist));
          settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-397-offx)/2));
          settagitem(@tags[7],wa_top,100);
          settagitem(@tags[8],wa_width,397+offx);
          settagitem(@tags[9],wa_height,181+offy);
          settagitem(@tags[10],wa_title,long(@strings[72,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],Tag_Done,0);
          pdwn^.sizeswindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                     cycleidcmp or
                                                                     listviewidcmp or
                                                                     idcmp_menupick or
                                                                     buttonidcmp or
                                                                     WA_MenuHelp or
                                                                     idcmp_refreshwindow or
                                                                     IDCMP_VanillaKey);
          if pdwn^.sizeswindow<>nil then
            begin
              pdwn^.sizeswindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.sizeswindow,nil);
              gt_setsinglegadgetattr(pdwn^.sizesgads[13],pdwn^.sizeswindow,
                                     gtin_number,pdwn^.innerw);
              gt_setsinglegadgetattr(pdwn^.sizesgads[14],pdwn^.sizeswindow,
                                     gtin_number,pdwn^.innerh);
              rendsizeswindow(pdwn);
              pdwn^.smenu:=nil;
              winsizesmenu:=nil;
              if makemenuwinsizesmenu(pdwn^.helpwin.screenvisinfo) then
                begin
                  if setmenustrip(pdwn^.sizeswindow,winsizesmenu) then
                    pdwn^.smenu:=winsizesmenu
                   else
                    freemenus(winsizesmenu);
                end;
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Unable to create gadgets for sizes window.');
    end
   else
    begin
      activatewindow(pdwn^.sizeswindow);
      windowtofront(pdwn^.sizeswindow);
    end;
end;

procedure closesizeswindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.sizeswindow<>nil then
    begin
      if pdwn^.smenu<>nil then
        begin
          clearmenustrip(pdwn^.sizeswindow);
          freemenus(pdwn^.smenu);
        end;
      closewindowsafely(pdwn^.sizeswindow);
    end;
  if pdwn^.sizesglist<>nil then
    freegadgets(pdwn^.sizesglist);
  pdwn^.sizesglist:=nil;
  pdwn^.sizeswindow:=nil;
end;

procedure rendsizeswindow(pdwn:pdesignerwindownode);
var
  tags      : array[1..5] of ttagitem;
  offx,offy : word;
  pen       : byte;
begin
  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=pdwn^.editscreen^.wborleft;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
  pen:=2;
  if pdwn^.screenprefs.sm_depth=1 then
    pen:=1;
  printstring(pdwn^.sizeswindow,164+offx,5+offy,'Limits',pen,0,@ttopaz80);
  printstring(pdwn^.sizeswindow,171+offx,55+offy,'Zoom',pen,0,@ttopaz80);
  printstring(pdwn^.sizeswindow,163+offx,102+offy,'Window',pen,0,@ttopaz80);
  drawbevelboxa(pdwn^.sizeswindow^.rport,offx+4,offy+100,387,60,@tags[2]);
  drawbevelboxa(pdwn^.sizeswindow^.rport,offx+4,offy+51,387,47,@tags[2]);
  drawbevelboxa(pdwn^.sizeswindow^.rport,offx+4,offy+2,387,47,@tags[2]);
end;

procedure openidcmpwindow(pdwn:pdesignerwindownode);
var
  tags : array[1..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
begin
  settagitem(@tags[2],tag_done,0);
  if pdwn^.idcmpwindow=nil then
    begin
      offx:=pdwn^.editscreen^.wborleft+4;
      offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
      pgad:=createcontext(@pdwn^.idcmpglist);
      
      for loop:=1 to 13 do
        begin
          pgad:=generalgadtoolsgad(checkbox_kind,offx+10,offy+12*loop-6,26,11,loop,@strings[45+loop,1],
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.idcmpgads[loop]:=pgad;
        end;
      for loop:=14 to 25 do
        begin
          pgad:=generalgadtoolsgad(checkbox_kind,offx+152,6+offy+12*(loop-14),26,11,loop,@strings[45+loop,1],
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.idcmpgads[loop]:=pgad;
        end;
      settagitem(@tags[1],gt_underscore,ord('_'));
      settagitem(@tags[2],tag_done,0);
      pgad:=generalgadtoolsgad(button_kind,offx+10,169+offy,80,13,26,@strings[16,1], {ok}
                                 @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+114,169+offy,80,13,27,@strings[14,1], {help}
                                 @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+218,169+offy,80,13,28,@strings[17,1], {cancel}
                                 @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.idcmpglist));
          settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-509-offx)/2));
          settagitem(@tags[7],wa_top,100);
          settagitem(@tags[8],wa_width,312+offx);
          settagitem(@tags[9],wa_height,189+offy);
          settagitem(@tags[10],wa_title,long(@strings[71,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],Tag_Done,0);
          pdwn^.idcmpwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                  cycleidcmp or
                                                                  idcmp_menupick or
                                                                  listviewidcmp or
                                                                  buttonidcmp or
                                                                  WA_MenuHelp or
                                                                  idcmp_refreshwindow or
                                                                  IDCMP_VanillaKey);
          if pdwn^.idcmpwindow<>nil then
            begin
              
              settagitem(@tags[1],gtbb_recessed,long(true));
              settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
              settagitem(@tags[3],tag_done,0);
              drawbevelboxa(pdwn^.idcmpwindow^.rport,offx+4,offy+2,299,162,@tags[2]);
              drawbevelboxa(pdwn^.idcmpwindow^.rport,offx+4,offy+166,299,19,@tags[2]);
              {
              drawbevelboxa(pdwn^.idcmpwindow^.rport,offx+4,offy+2,387,47,@tags[2]);
              }

              
              pdwn^.idcmpwindow^.userdata:=pointer(pdwn);
              setidcmpwindowgads(pdwn);
              gt_refreshwindow(pdwn^.idcmpwindow,nil);
              pdwn^.imenu:=nil;
              winidcmpmenu:=nil;
              if makemenuwinidcmpmenu(pdwn^.helpwin.screenvisinfo) then
                begin
                  if setmenustrip(pdwn^.idcmpwindow,winidcmpmenu) then
                    pdwn^.imenu:=winidcmpmenu
                   else
                    freemenus(winidcmpmenu);
                end;
            end;
        end
       else
        telluser(pdwn^.editwindow,'Unable to create gadgets for idcmp window');
    end
   else
    begin
      activatewindow(pdwn^.idcmpwindow);
      windowtofront(pdwn^.idcmpwindow);
    end;
end;

procedure closeidcmpwindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.idcmpwindow<>nil then
    begin
      if pdwn^.imenu<>nil then
        begin
          clearmenustrip(pdwn^.idcmpwindow);
          freemenus(pdwn^.imenu);
        end;
      closewindowsafely(pdwn^.idcmpwindow);
    end;
  if pdwn^.idcmpglist<>nil then
    freegadgets(pdwn^.idcmpglist);
  pdwn^.idcmpglist:=nil;
  pdwn^.idcmpwindow:=nil;
end;

procedure setidcmpwindowgads(pdwn:pdesignerwindownode);
var
  loop : byte;
begin
  if pdwn^.idcmpwindow<>nil then
    for loop:=1 to 25 do
      gt_setsinglegadgetattr(pdwn^.idcmpgads[loop],pdwn^.idcmpwindow,gtcb_checked,long(pdwn^.idcmplist[loop]));
end;

procedure openeditbutton(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_in    : test:=0;
            placetext_above : test:=1;
            placetext_below : test:=2;
            placetext_left  : test:=3;
            placetext_right : test:=4;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[1]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],gt_underscore,ord('_'));
          settagitem(@tags[6],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+extratopborder+3;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,53+offy,26,11,3,@strings[76,1],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,53+offy,26,11,4,@strings[77,1],{underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,5,@strings[78,1],{text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,6,@strings[79,1],{placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          if pgn^.editwindow^.pwin<>nil then
            begin
              gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                      gtcb_checked,pgn^.tags[2].ti_data);
              gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                      gtcb_checked,pgn^.tags[3].ti_data);
            end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure closeeditgadget(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pmt,pmt2 : pmytag;
  pos      : long;
begin
  if pgn^.editwindow<>nil then
    begin
      if pgn^.editwindow^.object1<>nil then
        disposeobject(pgn^.editwindow^.object1);
      if pgn^.editwindow^.object2<>nil then
        disposeobject(pgn^.editwindow^.object2);
      
      if (pgn^.kind=mx_kind)or(pgn^.kind=cycle_kind)or(pgn^.kind=listview_kind) then
        freelist(@pgn^.editwindow^.editlist,sizeof(tstringnode));
      if (pgn^.kind=myobject_kind) then
        begin
          
          freelist(@pgn^.editwindow^.extralist,sizeof(tnumberitem));
          
          if pgn^.editwindow^.glist2<>nil then
            begin
              pos:=removeglist(pgn^.editwindow^.pwin,pgn^.editwindow^.glist2,-1);
              freegadgets(pgn^.editwindow^.glist2);
              pgn^.editwindow^.glist2:=nil;
            end;
          
          pmt:=pmytag(pgn^.editwindow^.editlist.lh_head);
          while (pmt^.ln_succ<>nil) do
            begin
              pmt2:=pmt^.ln_succ;
              freemytag(pmt);
              pmt:=pmt2;
            end;
          
        end;
      
      if pgn^.editwindow^.pwin<>nil then
        begin
          if pgn^.editwindow^.pwin^.menustrip<>nil then
            clearmenustrip(pgn^.editwindow^.pwin);
          closewindowsafely(pgn^.editwindow^.pwin);
        end;
      
      if pgn^.editwindow^.glist<>nil then
        freegadgets(pgn^.editwindow^.glist);
      
      freemymem(pgn^.editwindow,sizeof(tgadeditwindow));
      if pdwn^.gadgetlistwindow<>nil then
        begin
          gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                 gtlv_labels,~0);
          gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                 gtlv_labels,long(@pdwn^.gadgetlist));
          gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                 gtlv_selected,pdwn^.gadselected);
        end;
      pgn^.editwindow:=nil;
      
      if pgn^.justcreated and prefsvalues[19] then
        begin
          
          { delete gad from first cancel }
          
          {
          writeln('would have deleted gadget.');
          }
          
          remove(pnode(pgn));
          freegadgetnode(pdwn,pgn);
          updateeditwindow:=true;
          fixgadgetnumbers(pdwn);
        end
       else
        pgn^.justcreated:=false;
    end;
end;

procedure openeditcheckbox(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],gt_underscore,ord('_'));
          settagitem(@tags[6],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+extraleftborder+3;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+3+extratopborder;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,3,@strings[78,1],   {text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,67+offy,26,11,4,@strings[92,1], {checked}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,53+offy,26,11,5,@strings[76,1], {disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,6,@strings[79,1],   {placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,53+offy,26,11,7,@strings[77,1],{underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[7]:=pgad;
          
          
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,67+offy,26,11,10,@strings[130,1], {scaled V39}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[10]:=pgad;
          
          
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,8,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[8]:=pgad;
              
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[1].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[7],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[4].ti_data);
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[5].ti_data);
                  
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure rendeditlistcycle(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags      : array[1..5] of ttagitem;
  offx,offy : word;
begin
  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=pdwn^.editscreen^.wborleft;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
  {
  printstring(pdwn^.idcmpwindow,190+offx,7+offy,'Window IDCMP Flags  ',2,0,@ttopaz80);
  }
  drawbevelboxa(pgn^.editwindow^.pwin^.rport,offx+6,3+offy,269,78,@tags[2]);
end;

procedure openeditslider(pdwn:pdesignerwindownode;pgn:pgadgetnode);
const
  dispfunc : string[9]='DispFunc'#0;
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
  wid  : word;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],gt_underscore,ord('_'));
          settagitem(@tags[6],tag_done,0);
          case pgn^.tags[9].ti_data of
            lorient_horiz                    : test:=0;
            lorient_vert                     : test:=1;
           end;
          pgn^.editwindow^.data2:=test;
          settagitem(@tags[7],gtcy_active,test);
          settagitem(@tags[8],gtcy_labels,long(@pgacycle[1]));
          settagitem(@tags[9],gt_underscore,ord('_'));
          settagitem(@tags[10],tag_done,0);
          settagitem(@tags[11],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[12],gt_underscore,ord('_'));
          settagitem(@tags[13],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+4+extratopborder;
          pgn^.editwindow^.glist:=nil;
          wid:=280;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,3,@strings[79,1],         {placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,4,@strings[78,1],         {text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,12,@strings[189,1],      {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[11]);
          pgn^.editwindow^.gads[12]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,53+offy,179,14,5,@strings[108,1],      {min}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,70+offy,179,14,6,@strings[109,1],      {max}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,87+offy,179,14,7,@strings[117,1],      {lev}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4+wid,2+offy,26,11,8,@strings[110,1],   {imm}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);
          pgn^.editwindow^.gads[8]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157+wid,2+offy,26,11,9,@strings[111,1], {rel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);
          pgn^.editwindow^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4+wid,16+offy,26,11,10,@strings[112,1], {dis}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);
          pgn^.editwindow^.gads[10]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4+wid,30+offy,26,11,19,@strings[77,2], {underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,pendtagitem);
          pgn^.editwindow^.gads[1]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,104+offy,179,14,11,@strings[116,1],      {freedom}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[11]:=pgad;
          case pgn^.tags[6].ti_data of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data3:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          pgad:=generalgadtoolsgad(cycle_kind,offx+4+wid,44+offy,179,14,13,@strings[193,1],    {levelplace}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[13]:=pgad;
          settagitem(@tags[4],gtst_string,long(@pgn^.datas[1]));
          pgad:=generalgadtoolsgad(string_kind,offx+4+wid,61+offy,179,14,14,@strings[192,1],   {Level Format}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[14]:=pgad;
          settagitem(@tags[1],gtin_number,pgn^.tags[5].ti_data);
          pgad:=generalgadtoolsgad(integer_kind,offx+4+wid,78+offy,50,14,15,@strings[195,1],   {MaxLevelLen}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pgn^.editwindow^.gads[15]:=pgad;
          settagitem(@tags[4],gtst_string,long(@pgn^.edithook[1]));
          pgad:=generalgadtoolsgad(string_kind,offx+4+wid,95+offy,179,14,14,@dispfunc[1],   {dispfunc}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[17]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157+wid,16+offy,26,11,16,@strings[194,1],{Display level}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[16]:=pgad;
              
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[7],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[1].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[2].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[11].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[12].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[13].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[4].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[14].ti_data);
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditscroller(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],tag_more,long(@tags[2]));
          
          case pgn^.tags[7].ti_data of
            lorient_horiz                    : test:=0;
            lorient_vert                     : test:=1;
           end;
          pgn^.editwindow^.data2:=test;
          settagitem(@tags[6],gtcy_active,test);
          settagitem(@tags[7],gtcy_labels,long(@pgacycle[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+4+extratopborder;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          settagitem(@tags[12],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[13],gt_underscore,ord('_'));
          settagitem(@tags[14],tag_done,0);
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,3,@strings[79,1],    {placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,4,@strings[78,1],    {text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,14,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[12]);
          pgn^.editwindow^.gads[14]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,53+offy,179,14,5,@strings[120,1], {top}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,70+offy,179,14,6,@strings[119,1], {total}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,87+offy,179,14,7,@strings[118,1], {visible}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[7]:=pgad;
          
          offx:=offx+253;
          offy:=offy-102;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,104+offy,26,11,8,@strings[110,1], {immediate}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[8]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,104+offy,26,11,9,@strings[111,1],{relverify}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,118+offy,26,11,10,@strings[112,1],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[10]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,146+offy,179,14,11,@strings[116,1],{freedom}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[6]);
          pgn^.editwindow^.gads[11]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,offy+118,26,11,12,@strings[105,7], {arrows}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[12]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,163+offy,179,14,13,@strings[105,7],{Arrows}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[13]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,offy+132,26,11,14,@strings[77,2], {underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[1]:=pgad;
              
          opengadgeteditwindowframe(pdwn,pgn,pgad);
              
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[7],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[1].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[4].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[2].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[9].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[10].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[11].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[4].ti_tag=gtsc_arrows));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[12].ti_data);
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditpalette(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],tag_more,long(@tags[2]));
          settagitem(@tags[6],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[7],gt_underscore,ord('_'));
          settagitem(@tags[8],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+3+extratopborder;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,3,@strings[79,1],    {placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,4,@strings[78,1],    {text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,14,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[6]);
          pgn^.editwindow^.gads[14]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,53+offy,179,14,5,@strings[185,6], {depth}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,70+offy,179,14,6,@strings[184,7], {color}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,87+offy,179,14,7,@strings[183,6], {color offset}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,104+offy,26,11,10,@strings[112,1],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[10]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,offy+104,26,11,14,@strings[77,2], {underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[1]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,118+offy,26,11,11,@strings[197,1],{indleft}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[11]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,offy+118,26,11,12,@strings[198,1], {indabove}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[12]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,132+offy,179,14,13,@strings[199,1], {indicator size}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[13]:=pgad;
             
              opengadgeteditwindowframe(pdwn,pgn,pgad);
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[1].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[2].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[7],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[7].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[8].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[4].ti_tag=gtpa_indicatorwidth));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[5].ti_tag=gtpa_indicatorheight));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[4].ti_data);
                end;
        
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openimagelistwindow(pdwn:pdesignerwindownode);
var
  tags : array[0..15] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  if pdwn^.imagelistwindow=nil then
    begin
      pdwn^.imagegadsdis:=false;
      settagitem(@tags[1],gtlv_selected,~0);
      settagitem(@tags[2],gtlv_labels,long(@pdwn^.imagelist));
      settagitem(@tags[3],tag_done,0);
      settagitem(@tags[4],gtlv_selected,~0);
      settagitem(@tags[5],gtlv_labels,long(@teditimagelist));
      settagitem(@tags[6],gtlv_showselected,long(false));
      settagitem(@tags[7],gt_underscore,ord('_'));
      settagitem(@tags[8],tag_done,0);
      offx:=pdwn^.editscreen^.wborleft+4;
      offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
      pgad:=createcontext(@pdwn^.imagelistglist);
      settagitem(@tags[0],gtlv_showselected,0);
      
      pgad:=generalgadtoolsgad(listview_kind,4+offx,2+offy,195,96,1,nil,
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
      pdwn^.imagegadgets[1]:=pgad;
      pgad:=generalgadtoolsgad(listview_kind,203+offx,2+offy,195,47,2,nil,
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
      pdwn^.imagegadgets[2]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,4+offx,100+offy,75,14,3,@strings[11,1],      {new}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[3]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,84+offx,100+offy,75,14,4,@strings[12,1],     {delete}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[4]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,203+offx,52+offy,75,14,5,@strings[129,1],     {view}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[5]:=pgad;
      
      pgad:=generalgadtoolsgad(button_kind,244+offx,100+offy,75,14,6,@strings[153,6],      {_update}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[6]:=pgad;
      
      pgad:=generalgadtoolsgad(button_kind,324+offx,100+offy,75,14,7,@strings[14,1],     {help}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[7]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,164+offx,100+offy,75,14,8,@strings[79,1],    {place}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
      pdwn^.imagegadgets[8]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,203+offx,68+offy,75,14,10,@strings[42,1],   {left edge}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.imagegadgets[10]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,203+offx,84+offy,75,14,11,@strings[43,1],   {top edge}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.imagegadgets[11]:=pgad;
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.imagelistglist));
          settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-476-offx)/2));
          settagitem(@tags[7],wa_top,100);
          settagitem(@tags[8],wa_width,406+offx);
          settagitem(@tags[9],wa_height,118+offy);
          settagitem(@tags[10],wa_title,long(@strings[155,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],tag_done,0);
          pdwn^.imagelistwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                      cycleidcmp or
                                                                      listviewidcmp or
                                                                      buttonidcmp or
                                                                      idcmp_menupick or
                                                                      WA_MenuHelp or
                                                                      idcmp_refreshwindow or
                                                                      IDCMP_VanillaKey);
          if pdwn^.imagelistwindow<>nil then
            begin
              pdwn^.imagelistwindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.imagelistwindow,nil);
              setallimagelistwindowgadgets(pdwn);
              if winlistmenu<>nil then
                if setmenustrip(pdwn^.imagelistwindow,winlistmenu) then;
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Unable to create gadgets for image list window');
    end
   else
    begin
      activatewindow(pdwn^.imagelistwindow);
      windowtofront(pdwn^.imagelistwindow);
    end;
end;

procedure closeimagelistwindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.imagelistwindow<>nil then
    begin
      if pdwn^.imagelistwindow^.menustrip<>nil then
        clearmenustrip(pdwn^.imagelistwindow);
      closewindowsafely(pdwn^.imagelistwindow);
    end;
  if pdwn^.imagelistglist<>nil then
    freegadgets(pdwn^.imagelistglist);
  pdwn^.imagelistglist:=nil;
  pdwn^.imagelistwindow:=nil;
  pdwn^.imagegadgets[1]:=nil;
end;

procedure opentagswindow(pdwn:pdesignerwindownode);
const
  tagstrings: array[1..3] of string[15] =
  (
  'NewLookMenus'#0,
  'NotifyDepth'#0,
  'TabletMessages'#0
  );
  newstring : string[14] ='DefPubName'#0;
var
  tags : array[1..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  if pdwn^.tagswindow=nil then
    begin
      offx:=pdwn^.editscreen^.wborleft+4;
      offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+2;
      pgad:=createcontext(@pdwn^.tagsglist);
      pgad:=generalgadtoolsgad(checkbox_kind,offx+16,99+offy,26,11,1,@strings[157,1],{sizegadget}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[1]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+16,112+offy,26,11,2,@strings[158,1],{sizebright}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[2]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+16,125+offy,26,11,3,@strings[159,1],{sizebbottom}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[3]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,71+offy,26,11,4,@strings[160,1],{dragbar}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[4]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,84+offy,26,11,5,@strings[161,1],{depthgadget}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[5]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,97+offy,26,11,6,@strings[162,1],{closegadget}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[6]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,110+offy,26,11,7,@strings[163,1],{reportmouse}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[7]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,123+offy,26,11,8,@strings[164,1],{nocarerefresh}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[8]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,71+offy,26,11,9,@strings[165,1],{borderless}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[9]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,84+offy,26,11,10,@strings[166,1],{backdrop}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[10]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,97+offy,26,11,11,@strings[167,1],{gimmezerozero}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[11]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,110+offy,26,11,12,@strings[168,1],{activate}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[12]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,123+offy,26,11,13,@strings[169,1],{rmbtrap}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[13]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+467,71+offy,26,11,14,@strings[170,1],{simplerefresh}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[14]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+467,84+offy,26,11,15,@strings[171,1],{smartrefresh}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[15]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+467,97+offy,26,11,16,@strings[172,1],{autoadjust}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[16]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+467,110+offy,26,11,17,@strings[173,1],{menuhelp}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[17]:=pgad;
      pgad:=generalgadtoolsgad(string_kind,offx+16,5+offy,251,13,18,@strings[174,1],{windowtitle}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[18]:=pgad;
      pgad:=generalgadtoolsgad(string_kind,offx+16,20+offy,251,13,19,@strings[175,1],{screentitle}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[19]:=pgad;
      pgad:=generalgadtoolsgad(string_kind,offx+16,35+offy,251,13,20,@strings[176,1],{windowlabel}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[20]:=pgad;
      
      pgad:=generalgadtoolsgad(string_kind,offx+16,50+offy,251,13,997,@newstring[1],{windowlabel}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.defpubgadget:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,offx+403,5+offy,26,11,21,@strings[177,1],{customscreen}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[21]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+403,18+offy,26,11,22,@strings[178,1],{pubscreen}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[22]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+403,31+offy,26,11,23,@strings[179,1],{pubscreenname}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[23]:=pgad; 
      pgad:=generalgadtoolsgad(checkbox_kind,offx+403,44+offy,26,11,24,@strings[180,1],{pubscreenfallback}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[24]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+16,71+offy,52,12,25,@strings[181,1],{mousequeue}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[25]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+16,85+offy,52,12,26,@strings[182,1],{rptqueue}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[26]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+467,123+offy,26,11,27,@strings[183,1],{zoom}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.tagsgads[27]:=pgad;
      settagitem(@tags[1],gt_underscore,ord('_'));
      settagitem(@tags[2],tag_done,0);
      pgad:=generalgadtoolsgad(button_kind,offx+27,159+offy,85,13,28,@strings[16,1],{ok}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+513,159+offy,85,13,29,@strings[17,1],{cancel}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+193,159+offy,85,13,30,@strings[184,1],{undo}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,offx+358,159+offy,85,13,31,@strings[14,1],{Help}
                               @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
      
      pgad:=generalgadtoolsgad(checkbox_kind,offx+16,138+offy,26,11,51,@tagstrings[1,1], {newlookmenus}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.moretaggads[1]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+173,136+offy,26,11,52,@tagstrings[2,1], {depthnotify}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.moretaggads[2]:=pgad;
      pgad:=generalgadtoolsgad(checkbox_kind,offx+322,136+offy,26,11,53,@tagstrings[3,1], {tabletmessages}
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
      pdwn^.moretaggads[3]:=pgad;

      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(pdwn^.tagsglist));
          settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-636-offx)/2));
          settagitem(@tags[7],wa_top,100);
          settagitem(@tags[8],wa_width,629+offx);
          settagitem(@tags[9],wa_height,179+offy);
          settagitem(@tags[10],wa_title,long(@strings[156,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],tag_done,0);
          pdwn^.tagswindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                 cycleidcmp or
                                                                 listviewidcmp or
                                                                 buttonidcmp or
                                                                 idcmp_menupick or
                                                                 WA_MenuHelp or
                                                                 idcmp_vanillakey or
                                                                 idcmp_refreshwindow or
                                                                 IDCMP_VanillaKey);
          if pdwn^.tagswindow<>nil then
            begin
              pdwn^.tagswindow^.userdata:=pointer(pdwn);
              gt_refreshwindow(pdwn^.tagswindow,nil);
              rendtagswindow(pdwn);
              settagswindowgadgets(pdwn);
              pdwn^.tmenu:=nil;
              wintagsmenu:=nil;
              if makemenuwintagsmenu(pdwn^.helpwin.screenvisinfo) then
                begin
                  if setmenustrip(pdwn^.tagswindow,wintagsmenu) then
                    pdwn^.tmenu:=wintagsmenu
                   else
                    freemenus(wintagsmenu);
                end;
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Unable to create gadgets for tags window');
    end
   else
    begin
      activatewindow(pdwn^.tagswindow);
      windowtofront(pdwn^.tagswindow);
    end;
end;

procedure closetagswindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.tagswindow<>nil then
    begin
      if pdwn^.tmenu<>nil then
        begin
          clearmenustrip(pdwn^.tagswindow);
          freemenus(pdwn^.tmenu);
        end;
      closewindowsafely(pdwn^.tagswindow);
    end;
  if pdwn^.tagsglist<>nil then
    freegadgets(pdwn^.tagsglist);
  pdwn^.tagsglist:=nil;
  pdwn^.tagswindow:=nil;
end;

procedure rendtagswindow(pdwn:pdesignerwindownode);
var
  tags      : array[1..5] of ttagitem;
  offx,offy : word;
begin
  settagitem(@tags[1],gtbb_recessed,long(true));
  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=pdwn^.editscreen^.wborleft;
  offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+2;
  drawbevelboxa(pdwn^.tagswindow^.rport,offx+384,offy+1,240,65,@tags[2]);
  drawbevelboxa(pdwn^.tagswindow^.rport,offx+4,offy+1,376,65,@tags[2]);
  drawbevelboxa(pdwn^.tagswindow^.rport,offx+4,offy+68,620,86,@tags[2]);
  drawbevelboxa(pdwn^.tagswindow^.rport,offx+4,offy+156,620,19,@tags[2]);
end;

procedure openedittextnumber(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
              placetext_above : test:=0;
              placetext_below : test:=1;
              placetext_left  : test:=2;
              placetext_right : test:=3;
           end;
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[4],gtst_string,long(@pgn^.title[1]));
          settagitem(@tags[5],gt_underscore,ord('_'));
          settagitem(@tags[6],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+extratopborder+3;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          if pgn^.kind=text_kind then
            begin
              pgad:=generalgadtoolsgad(checkbox_kind,offx+157,53+offy,26,11,3,@strings[189,10],{copytext}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
              pgn^.editwindow^.gads[3]:=pgad;
            end;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,53+offy,26,11,9,@windowoptions[13,1],{Bevel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,5,@strings[78,1],{text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,6,@strings[79,1],{placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          if pgn^.kind=text_kind then 
            begin
              pgad:=generalgadtoolsgad(string_kind,offx+4,67+offy,179,14,4,@windowoptions[11,1], {string}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[5]);
              pgn^.editwindow^.gads[4]:=pgad;
            end
           else
            begin
              pgad:=generalgadtoolsgad(integer_kind,offx+4,67+offy,179,14,4,@windowoptions[12,1],{number}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[5]);
              pgn^.editwindow^.gads[4]:=pgad;
            end;
          
          {**************}
          
          settagitem(@tags[9],gtcb_checked,pgn^.tags[5].ti_data);
          settagitem(@tags[10],tag_done,0);
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,84+offy,28,11,10,@strings[131,1],{use V39?}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[9]);
          pgn^.editwindow^.gads[10]:=pgad;
          settagitem(@tags[8],gtpa_depth,pdwn^.screenprefs.sm_depth);
          settagitem(@tags[9],gtpa_indicatorwidth,26);
          settagitem(@tags[10],gtpa_color,pgn^.tags[6].ti_data);
          pgn^.tags[6].ti_tag:=pgn^.tags[6].ti_data;
          settagitem(@tags[11],tag_done,0);
          pgad:=generalgadtoolsgad(palette_kind,offx+4,98+offy,178,14,11,@strings[132,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);  {frontpen}
          pgn^.editwindow^.gads[11]:=pgad;
          settagitem(@tags[10],gtpa_color,pgn^.tags[7].ti_data);
          pgn^.tags[7].ti_tag:=pgn^.tags[7].ti_data;
          pgad:=generalgadtoolsgad(palette_kind,offx+4,115+offy,178,14,12,@strings[133,1],
                               @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);  {backpen}
          pgn^.editwindow^.gads[12]:=pgad;
          settagitem(@tags[8],gtcy_labels,long(@justcycle));
          settagitem(@tags[9],gtcy_active,pgn^.tags[8].ti_data);
          pgn^.tags[8].ti_tag:=pgn^.tags[8].ti_data;
          settagitem(@tags[10],tag_done,0);
          pgad:=generalgadtoolsgad(cycle_kind,4+offx,132+offy,178,14,13,@strings[4,2],
                           @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[13]:=pgad;
          settagitem(@tags[9],gtcb_checked,pgn^.tags[9].ti_data);
          
          pgn^.tags[9].ti_tag:=pgn^.tags[9].ti_data;
          
          settagitem(@tags[10],tag_done,0);
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,149+offy,28,11,14,@strings[133,9],{clip}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[9]);
          pgn^.editwindow^.gads[14]:=pgad;
          if pgn^.kind=number_kind then
            begin
              settagitem(@tags[9],gtst_string,long(@pgn^.datas[1]));
              settagitem(@tags[10],tag_done,0);
              pgad:=generalgadtoolsgad(string_kind,4+offx,163+offy,178,14,15,@strings[207,1], {num format}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[9]);
              pgn^.editwindow^.gads[15]:=pgad;
              settagitem(@tags[9],gtin_number,pgn^.tags[10].ti_data);
              pgad:=generalgadtoolsgad(integer_kind,4+offx,180+offy,178,14,16,@strings[206,1], {maxnumlen}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[9]);
              pgn^.editwindow^.gads[16]:=pgad;
              inc(offy,34);
            end;
          
          {**************}
          inc(offy,79);
          
              opengadgeteditwindowframe(pdwn,pgn,pgad);
              if pgn^.editwindow^.pwin<>nil then
                begin
                  if pgn^.kind=text_kind then
                    begin
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                           gtcb_checked,pgn^.tags[3].ti_data);
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                           gtst_string,long(@pgn^.datas[1]));
                    end
                   else
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                           gtin_number,pgn^.tags[1].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtcb_checked,pgn^.tags[2].ti_data);
                  
                  if pgn^.kind=number_kind then
                    test:=16
                   else
                    test:=14;
                  for loop:=11 to test do
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[loop],pgn^.editwindow^.pwin,
                                       ga_disabled,long(not checkedbox(pgn^.editwindow^.gads[10])));
                  
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditmxcycle(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags  : array[0..24] of ttagitem;
  pgad  : pgadget;
  offx  : integer;
  offy  : integer;
  loop  : integer;
  test  : byte;
  psn   : pstringnode;
  psn2  : pstringnode;
  test2 : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          if pgn^.kind=mx_kind then
            begin
              case pgn^.flags of
                placetext_left  : test:=0;
                placetext_right : test:=1;
               end;
             case pgn^.tags[7].ti_data of
              placetext_above : test2:=0;
              placetext_below : test2:=1;
              placetext_left  : test2:=2;
              placetext_right : test2:=3;
             end;
             
            end
           else
            case pgn^.flags of
              placetext_above : test:=0;
              placetext_below : test:=1;
              placetext_left  : test:=2;
              placetext_right : test:=3;
             end;
          pgn^.editwindow^.data:=test;
          pgn^.editwindow^.data4:=test2;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+extratopborder+3;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          if pgn^.kind=cycle_kind then
            begin
              pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,15,@strings[78,1],  {text, for cycle only}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
              pgn^.editwindow^.gads[15]:=pgad;
              pgad:=generalgadtoolsgad(checkbox_kind,offx+157,70+offy,26,11,16,@strings[76,2],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
              pgn^.editwindow^.gads[16]:=pgad;
            end;
          if pgn^.kind=mx_kind then
            begin
              pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,15,@strings[135,1],  {text, for v39 only}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
              pgn^.editwindow^.gads[15]:=pgad;
              tags[0].ti_data:=test2;
              pgad:=generalgadtoolsgad(cycle_kind,offx+4,19+offy,179,14,77,@strings[136,1],{placetext v39}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
              tags[0].ti_data:=test;
              tags[1].ti_data:=long(@placetextcycle1[4]);
              inc(offy,34);
            end;
          if pgn^.kind=cycle_kind then inc(offy,17);
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,19+offy,179,14,6,@strings[79,1],{placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,36+offy,179,14,5,@strings[34,6],  {active}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[5]:=pgad;
          if pgn^.kind=cycle_kind then dec(offy,17);
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,70+offy,26,11,4,@strings[77,1],{underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[4]:=pgad;
          
          if pgn^.kind=mx_kind then
            begin
              pgad:=generalgadtoolsgad(checkbox_kind,offx+157,70+offy,26,11,16,@strings[130,1],{scale}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
              pgn^.editwindow^.gads[16]:=pgad;
              pgad:=generalgadtoolsgad(integer_kind,offx+4,53+offy,179,14,3,@strings[26,10],  {spacing}
                                       @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
              pgn^.editwindow^.gads[3]:=pgad;
            end;
          offy:=offy+84;
          {listview}
          newlist(@pgn^.editwindow^.editlist);
          psn:=pstringnode(pgn^.infolist.lh_head);
          while (psn^.ln_succ<>nil) do
            begin
              psn2:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
              if psn2<>nil then
                begin
                  psn2^.ln_name:=@psn2^.st[1];
                  psn2^.st:=psn^.st;
                  addtail(@pgn^.editwindow^.editlist,pnode(psn2));
                end;
              psn:=psn^.ln_succ;
            end;
          settagitem(@tags[4],gtlv_labels,long(@pgn^.editwindow^.editlist));
          settagitem(@tags[5],gtlv_selected,0);
          settagitem(@tags[6],tag_done,0);
          pgn^.editwindow^.data2:=0;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,offy,271,44,12,nil, {listview}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[12]:=pgad;
          
          offy:=offy+47;
          pgad:=generalgadtoolsgad(string_kind,offx+4,offy,271,14,13,nil,
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[13]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,17+offy,60,13,9,@strings[11,2], {new}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+74,17+offy,60,13,10,@strings[50,10],  {up}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+214,17+offy,61,13,11,@strings[47,11], {del}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+144,17+offy,60,13,14,@strings[2,9], {down}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
              
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[5].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,long(pgn^.tags[1].ti_data));
                  if pgn^.kind=mx_kind then
                    begin
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                             gtin_number,long(pgn^.tags[2].ti_data));
                    end;
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[15],pgn^.editwindow^.pwin,
                                          gtst_string,long(@pgn^.title[1]));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[6].ti_data));
                  psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                  if psn^.ln_succ<>nil then
                     gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                           gtst_string,long(psn^.ln_name));
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditlistview(pdwn:pdesignerwindownode;pgn:pgadgetnode);
const
  dispfunc : string[9] = 'CallBack'#0;
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
  psn  : pstringnode;
  psn2 : pstringnode;
  pgn2 : pgadgetnode;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          case pgn^.flags of
            placetext_above : test:=0;
            placetext_below : test:=1;
            placetext_left  : test:=2;
            placetext_right : test:=3;
           end;
          pgn^.pointers[4]:=pointer(pgn^.tags[3].ti_data);
          pgn^.editwindow^.data:=test;
          settagitem(@tags[0],gtcy_active,test);
          settagitem(@tags[1],gtcy_labels,long(@placetextcycle1[2]));
          settagitem(@tags[2],gt_underscore,ord('_'));
          settagitem(@tags[3],tag_done,0);
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+4+extratopborder;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,15,@strings[78,1],  {text}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[15]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,87+offy,26,11,16,@strings[87,1],{readonly}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[16]:=pgad;
          pgad:=generalgadtoolsgad(cycle_kind,offx+4,36+offy,179,14,6,@strings[79,1],{placetext}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[0]);
          pgn^.editwindow^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,19+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,53+offy,50,14,5,@strings[34,6],  {selected}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+133,53+offy,50,14,18,@strings[102,1],  {top}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[18]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,87+offy,26,11,4,@strings[77,2],{underscore}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,101+offy,26,11,19,@strings[203,1],{create list}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[1]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+157,101+offy,26,11,20,@strings[169,9],{display}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgn^.editwindow^.gads[2]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+4,70+offy,50,14,3,@strings[90,1],  {spacing}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(integer_kind,offx+133,70+offy,50,14,17,@strings[89,1],  {scrollwidth}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[17]:=pgad;
          settagitem(@tags[10],gttx_border,long(true));
          settagitem(@tags[11],gt_underscore,ord('_'));
          settagitem(@tags[12],tag_done,0);
          pgad:=generalgadtoolsgad(text_kind,offx+4,115+offy,179,14,21,@strings[157,5],  {gadget}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[10]);
          pgn^.editwindow^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,132+offy,81,13,22,@strings[8,7],  {join}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+102,132+offy,81,13,23,@strings[9,7], {split}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(string_kind,offx+4,148+offy,179,14,11,@dispfunc[1],  {dispfunc}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[11]:=pgad;
          offx:=offx+290;
          inc(offy,19);
          {listview}
          newlist(@pgn^.editwindow^.editlist);
          psn:=pstringnode(pgn^.infolist.lh_head);
          while (psn^.ln_succ<>nil) do
            begin
              psn2:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
              if psn2<>nil then
                begin
                  psn2^.ln_name:=@psn2^.st[1];
                  psn2^.st:=psn^.st;
                  addtail(@pgn^.editwindow^.editlist,pnode(psn2));
                end;
              psn:=psn^.ln_succ;
            end;
          settagitem(@tags[4],gtlv_labels,long(@pgn^.editwindow^.editlist));
          settagitem(@tags[5],gtlv_selected,0);
          settagitem(@tags[6],tag_done,0);
          pgn^.editwindow^.data2:=0;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,offy-17,271,94+17,12,nil, {listview}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[4]);
          pgn^.editwindow^.gads[12]:=pgad;
          offy:=offy+95;
          pgad:=generalgadtoolsgad(string_kind,offx+4,offy,271,14,13,nil,
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
          pgn^.editwindow^.gads[13]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,17+offy,60,13,9,@strings[11,2], {new}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+74,17+offy,60,13,10,@strings[50,10],  {up}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+214,17+offy,61,13,11,@strings[47,11], {del}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pgad:=generalgadtoolsgad(button_kind,offx+144,17+offy,60,13,14,@strings[2,9], {down}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          offy:=offy+34;
          
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_refreshwindow(pgn^.editwindow^.pwin,nil);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[9].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[8].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[10].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,long(pgn^.tags[5].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                         gtin_number,long(pgn^.tags[6].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtin_number,long(pgn^.tags[4].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtin_number,long(pgn^.tags[2].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[2],pgn^.editwindow^.pwin,
                                         gtcb_checked,long( pgn^.tags[3].ti_tag=gtlv_showselected));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.edithook[1]));
                  psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                  if psn^.ln_succ<>nil then
                     gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                           gtst_string,long(psn^.ln_name));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[15],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.title[1]));
                  if pgn^.tags[3].ti_data=0 then
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                 gttx_text,long(@strings[155,8])) {'None' printed}
                   else
                    begin
                      pgn2:=pgadgetnode(pgn^.pointers[1]);
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                             gttx_text,long(@pgn2^.labelid[1])); {gadget label printed}
                    end;
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditgetfile(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          settagitem(@tags[7],gtst_string,long(@pgn^.labelid[1]));
          settagitem(@tags[8],gt_underscore,ord('_'));
          settagitem(@tags[9],tag_done,0);
          offx:=pdwn^.editscreen^.wborleft+4;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1;
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          pgad:=generalgadtoolsgad(button_kind,offx+4,33+offy,81,14,1,@strings[16,1],  {ok}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[1]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+98,33+offy,81,14,2,@strings[17,1], {cancel}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[2]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,19+offy,26,11,3,@strings[76,1],{disabled}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[8]);
          pgn^.editwindow^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,2+offy,179,14,7,@strings[189,1],  {IDLabel}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[7]);
          pgn^.editwindow^.gads[7]:=pgad;
          if pgad<>nil then
            begin
              settagitem(@tags[1],wa_gadgets,long(pgn^.editwindow^.glist));
              settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
              settagitem(@tags[3],wa_depthgadget,long(true));
              settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
              settagitem(@tags[5],wa_closegadget,long(true));
              settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-286-offx)/2));
              settagitem(@tags[7],wa_top,100);
              settagitem(@tags[8],wa_width,286+offx);
              settagitem(@tags[9],wa_height,50+offy);
              settagitem(@tags[10],wa_title,long(@strings[204,1]));
              settagitem(@tags[11],wa_dragbar,long(true));
              settagitem(@tags[12],wa_activate,long(true));
              settagitem(@tags[13],wa_autoadjust,long(true));
              settagitem(@tags[14],tag_done,0);
              pgn^.editwindow^.pwin:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                      buttonidcmp or
                                                                      idcmp_menupick or
                                                                      idcmp_refreshwindow or
                                                                      IDCMP_VanillaKey);
              if pgn^.editwindow^.pwin<>nil then
                begin
                  pgn^.editwindow^.pwin^.userdata:=pointer(pdwn);
                  gt_refreshwindow(pgn^.editwindow^.pwin,nil);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                          gtcb_checked,pgn^.tags[2].ti_data);
                end;
            end
           else
            telluser(pdwn^.optionswindow,'Unable to create gadgets.');
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end
end;

procedure openeditgeneric(pdwn:pdesignerwindownode;pgn:pgadgetnode);
begin
end;

procedure openeditmybool(pdwn:pdesignerwindownode;pgn:pgadgetnode);
Const
  Win0_Gad30CycleTexts : array [0..2] of string[11]=
  (
  'JAM1'#0,
  'JAM2'#0,
  'COMPLEMENT'#0
  );
  Gadgetstrings : array[0..27] of string[14]=
  (
  'Label'#0,
  'Width'#0,
  'Height'#0,
  'Text'#0,
  'X'#0,
  'Y'#0,
  'INVERSVID'#0,
  'Use Text'#0,
  'Gadget Render'#0,
  'Select Render'#0,
  'TOGGLESELECT'#0,
  'IMMEDIATE'#0,
  'RELVERIFY'#0,
  'FOLLOWMOUSE'#0,
  'SELECTED'#0,
  'DISABLED'#0,
  'GADGHNONE'#0,
  'GADGHCOMP'#0,
  'GADGHBOX'#0,
  'GADGHIMAGE'#0,
  'Front Pen'#0,
  'Back Pen'#0,
  '_OK'#0,
  '_Cancel'#0,
  '_Font'#0,
  'None'#0,
  'None'#0,
  ''#0
  );
var
  Dummy : long;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  pgad  : pgadget;
  pin   : pimagenode;
begin
  if pgn^.editwindow=nil then
    begin
      pgn^.editwindow:=allocmymem(sizeof(tgadeditwindow),memf_any or memf_clear);
      if pgn^.editwindow<>nil then
        begin
          offx:=pdwn^.editscreen^.wborleft+3+extraleftborder;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+1+extratopborder+3;
          
          pgn^.editwindow^.glist:=nil;
          pgad:=createcontext(@pgn^.editwindow^.glist);
          
          Settagitem(@tags[2], GT_UnderScore, Ord('_'));
          Settagitem(@tags[3], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 12, offx+4, offy+2, 150, 12, 0, @gadgetstrings[0,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[0]:=pGad;
          Settagitem(@tags[1], GTIN_MaxChars, 4);
          pgad:=GeneralGadToolsGad( 3, offx+207, offy+2, 50, 12, 1, @gadgetstrings[1,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[1]:=pGad;
          pgad:=GeneralGadToolsGad( 3, offx+323, offy+2, 50, 12, 2, @gadgetstrings[2,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[2]:=pGad;
          pgad:=GeneralGadToolsGad( 12, offx+4, offy+17, 150, 12, 3, @gadgetstrings[3,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[3]:=pGad;
          pgad:=GeneralGadToolsGad( 3, offx+207, offy+17, 50, 12, 4, @gadgetstrings[4,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[4]:=pGad;
          pgad:=GeneralGadToolsGad( 3, offx+323, offy+17, 50, 12, 5, @gadgetstrings[5,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[5]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+231, offy+32, 26, 11, 6, @gadgetstrings[6,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[6]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+347, offy+32, 26, 11, 7, @gadgetstrings[7,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[7]:=pGad;
          Settagitem(@tags[1], GTLV_ShowSelected, 0);
          Settagitem(@tags[2], GTLV_Selected, ~0);
          pgad:=GeneralGadToolsGad( 4, offx+4, offy+77, 153, 41, 8, @gadgetstrings[8,1],
                                   @ttopaz80, 4, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[8]:=pGad;
          pgad:=GeneralGadToolsGad( 4, offx+161, offy+77, 150, 41, 9, @gadgetstrings[9,1],
                                   @ttopaz80, 4, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[9]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+77, 26, 11, 10, @gadgetstrings[10,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[10]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+91, 26, 11, 11, @gadgetstrings[11,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[11]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+105, 26, 11, 12, @gadgetstrings[12,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[12]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+119, 26, 11, 13, @gadgetstrings[13,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[13]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+134, 26, 11, 14, @gadgetstrings[14,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[14]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+318, offy+148, 26, 11, 15, @gadgetstrings[15,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[15]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+4, offy+134, 26, 11, 16, @gadgetstrings[16,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[16]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+4, offy+148, 26, 11, 17, @gadgetstrings[17,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[17]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+161, offy+134, 26, 11, 18, @gadgetstrings[18,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[18]:=pGad;
          pgad:=GeneralGadToolsGad( 2, offx+161, offy+148, 26, 11, 19, @gadgetstrings[19,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[19]:=pGad;
          Settagitem(@tags[1], GTPA_Depth, pdwn^.screenprefs.sm_depth);
          Settagitem(@tags[2], GTPA_IndicatorWidth, 28);
          pgad:=GeneralGadToolsGad( 8, offx+4, offy+46, 140, 15, 20, @gadgetstrings[20,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[20]:=pGad;
          pgad:=GeneralGadToolsGad( 8, offx+231, offy+46, 140, 15, 21, @gadgetstrings[21,1],
                                   @ttopaz80, 2, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[21]:=pGad;
          Settagitem(@tags[2], GT_UnderScore, Ord('_'));
          {
          pgad:=GeneralGadToolsGad( 1, offx+4, offy+162, 115, 14, 22, @gadgetstrings[22,1],
                                   @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[22]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+330, offy+162, 115, 14, 23, @gadgetstrings[23,1],
                                   @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[23]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+172, offy+162, 115, 14, 24, @gadgetstrings[24,1],
                                   @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[2]);
          pgn^.editwindow^.gads[24]:=pGad;
          }
          pgad:=GeneralGadToolsGad( 1, offx+3, offy+119, 80, 12, 25, @gadgetstrings[25,1],
                                   @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[25]:=pGad;
          pgad:=GeneralGadToolsGad( 1, offx+161, offy+119, 80, 12, 26, @gadgetstrings[26,1],
                                   @ttopaz80, 16, pdwn^.helpwin.screenvisinfo, pGad, Nil, Nil);
          pgn^.editwindow^.gads[26]:=pGad;
          For Loop:=0 to 2 do
            Win0_Gad30Labels[Loop]:=@Win0_Gad30CycleTexts[Loop,1];
          Win0_Gad30Labels[3]:=Nil;
          SetTagItem(@tags[1], GTCY_Labels, Long(@Win0_Gad30Labels));
          Settagitem(@tags[2], Tag_Done, 0);
          pgad:=GeneralGadToolsGad( 7, offx+4, offy+31, 150, 12, 27, @gadgetstrings[27,1],
                               @ttopaz80, 1, pdwn^.helpwin.screenvisinfo, pGad, Nil, @tags[1]);
          pgn^.editwindow^.gads[27]:=pGad;
          
          opengadgeteditwindowframe(pdwn,pgn,pgad);
          
              if pgn^.editwindow^.pwin<>nil then
                begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[0],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.labelid[1]));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[1],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.w);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[2],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.h);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pgn^.title[1]));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[4],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[2].ti_tag);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[5],pgn^.editwindow^.pwin,
                                         gtin_number,pgn^.tags[2].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.tags[4].ti_tag and INVERSVID)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[7],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(pgn^.tags[1].ti_data));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[10],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.tags[1].ti_tag and gact_toggleselect)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.tags[1].ti_tag and gact_immediate)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.tags[1].ti_tag and gact_relverify)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.tags[1].ti_tag and gact_followmouse)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[14],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and gflg_selected)<>0));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[15],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and gflg_disabled)<>0));
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and 3)=gflg_gadghnone));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and 3)=gflg_gadghcomp));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and 3)=gflg_gadghbox));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[19],pgn^.editwindow^.pwin,
                                         gtcb_checked,long((pgn^.flags and 3)=gflg_gadghimage));
                  
                  dummy:=pgn^.tags[4].ti_tag;
                  if (dummy and inversvid)<>0 then
                    dummy:= dummy-inversvid;
                  case dummy of
                    jam1       : pgn^.editwindow^.data:=0;
                    jam2       : pgn^.editwindow^.data:=1;
                    complement : pgn^.editwindow^.data:=2;
                   end;
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[27],pgn^.editwindow^.pwin,
                                         gtcy_active,pgn^.editwindow^.data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                         gtpa_color,pgn^.tags[3].ti_tag);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[21],pgn^.editwindow^.pwin,
                                         gtpa_color,pgn^.tags[3].ti_data);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@teditimagelist));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@teditimagelist));
                  
                  pgn^.tags[4].ti_data:=pgn^.tags[3].ti_tag;
                  pgn^.tags[15].ti_data:=pgn^.tags[3].ti_data;
                  dummy:=0;
                  pgn^.editwindow^.data2:=~0;
                  pgn^.editwindow^.data3:=~0;
                  pin:=pimagenode(teditimagelist.lh_head);
                  while(pin^.ln_succ<>nil) do
                    begin
                      if pin=pimagenode(pgn^.pointers[1]) then
                        begin
                          pgn^.editwindow^.data2:=dummy;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                                 gtlv_selected,dummy);
                        end;
                      if pin=pimagenode(pgn^.pointers[2]) then
                         begin
                           pgn^.editwindow^.data3:=dummy;
                           gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                  gtlv_selected,dummy);
                         end;
                      inc(dummy);
                      pin:=pin^.ln_succ;
                    end;
                end;
        end
       else
        telluser(pdwn^.optionswindow,memerror);
    end;
end;

procedure openeditgadget(pdwn,pgn);
begin
  if pgn^.editwindow=nil then
    begin
      case pgn^.kind of
        button_kind   : openeditbutton(pdwn,pgn);
        string_kind   : openeditstringinteger(pdwn,pgn);
        integer_kind  : openeditstringinteger(pdwn,pgn);
        cycle_kind    : openeditmxcycle(pdwn,pgn);
        slider_kind   : openeditslider(pdwn,pgn);
        scroller_kind : openeditscroller(pdwn,pgn);
        listview_kind : openeditlistview(pdwn,pgn);
        palette_kind  : openeditpalette(pdwn,pgn);
        checkbox_kind : openeditcheckbox(pdwn,pgn);
        text_kind     : openedittextnumber(pdwn,pgn);
        number_kind   : openedittextnumber(pdwn,pgn);
        mx_kind       : openeditmxcycle(pdwn,pgn);
        generic_kind  : begin
                        end;
        mybool_kind   : openeditmybool(pdwn,pgn);
        myobject_kind : openwindoweditboopsiwin(pdwn,pgn);
       end;
      if pgn^.editwindow<>nil then
        begin
          copymem(@pgn^.font,@pgn^.editwindow^.tfont,sizeof(ttextattr));
          pgn^.editwindow^.tfontname:=pgn^.fontname;
          if pgn^.kind=myobject_kind then
            begin
              if (pdwn^.objectmenu<>nil) then
                if setmenustrip(pgn^.editwindow^.pwin,pdwn^.objectmenu) then;
            end
           else
            begin
              if (pdwn^.gadgetmenu<>nil) then
                if setmenustrip(pgn^.editwindow^.pwin,pdwn^.gadgetmenu) then;
            end;
        end;
    end
  else
    begin
      if pgn^.editwindow^.pwin<>nil then
        begin
          windowtofront(pgn^.editwindow^.pwin);
          activatewindow(pgn^.editwindow^.pwin);
        end;
    end;
end;

procedure rendeditmenuwindow(pdmn:pdesignermenunode);
var
  tags : array[2..3] of ttagitem;
  offx,offy : word;
  col : word;
begin
  if defaultscreenmode.sm_depth=1 then
    col:=1
   else
    col:=2;
  settagitem(@tags[2],gt_visualinfo,long(pdmn^.screenvisinfo));
  settagitem(@tags[3],tag_done,0);
  offx:=myscreen^.wborleft;
  offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
  drawbevelboxa(pdmn^.editwindow^.rport,offx+2,offy+1,206,108,@tags[2]);
  drawbevelboxa(pdmn^.editwindow^.rport,offx+210,offy+1,206,185,@tags[2]);
  drawbevelboxa(pdmn^.editwindow^.rport,offx+419,offy+1,206,185,@tags[2]);
  drawbevelboxa(pdmn^.editwindow^.rport,offx+2,offy+111,206,75,@tags[2]);
  printstring(pdmn^.editwindow,offx+89,4+offy,'Menus',col,0,@ttopaz80);
  printstring(pdmn^.editwindow,offx+290,4+offy,'Items',col,0,@ttopaz80);
  printstring(pdmn^.editwindow,offx+481,4+offy,'SubItems',col,0,@ttopaz80);
  printstring(pdmn^.editwindow,offx+81,114+offy,'Options',col,0,@ttopaz80);
end;

procedure openeditmenuwindow(pdmn:pdesignermenunode);
const
  title   : string[10]='Edit Menu'#0;
  getexcl : string[8]='GetExcl'#0;
  clrexcl : string[8]='ClrExcl'#0;
  newlook39str : string[15]='NewLook (V39)'#0;
  
  localgadstr : string[16]= 'Localize Menu'#0;
  
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
begin
  if pdmn^.editwindow=nil then
    begin
      pdmn^.screenvisinfo:=getvisualinfoa(myscreen,nil);
      if pdmn^.screenvisinfo<>nil then
        begin
          offx:=myscreen^.wborleft+4;
          offy:=myscreen^.wbortop+myscreen^.rastport.txheight-3;
          settagitem(@tags[0],gtlv_showselected,0);
          settagitem(@tags[1],tag_done,0);
          settagitem(@tags[2],gtst_maxchars,1);
          settagitem(@tags[3],stringa_replacemode,long(true));
          settagitem(@tags[4],stringa_justification,gact_stringcenter);
          settagitem(@tags[5],tag_done,0);
          pdmn^.glist:=nil;
          pgad:=createcontext(@pdmn^.glist);
          pgad:=generalgadtoolsgad(listview_kind,offx+4,16+offy,196{160},44,1,nil{@strings[55,8]},  {menu list}
                                   @ttopaz80,placetext_above,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[1]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,60+offy,196{160},14,2,{@strings[58,9]}nil,  {Title}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[2]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,74+offy,48,11,3,@strings[11,2],  {New}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[3]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+53,74+offy,48,11,4,@strings[50,10],  {Up}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[4]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+102,74+offy,48,11,5,@strings[2,9],  {Down}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[5]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+151,74+offy,48,11,6,@strings[47,11],  {Del}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[6]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,85+offy,26,11,7,@strings[76,2],  {Disabled}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[7]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,96+offy,140,14,8,@strings[176,7],  {label}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[8]:=pgad;
          offx:=offx+208;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,16+offy,196{160},44,9,nil{@strings[10,11]},  {item list}
                                   @ttopaz80,placetext_above,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[9]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,60+offy,196{160},14,10,nil{@strings[58,9]},  {Title}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[10]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,74+offy,48,11,11,@strings[11,2],  {New}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[11]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+53,74+offy,48,11,12,@strings[50,10],  {Up}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[12]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+102,74+offy,48,11,13,@strings[2,9],  {Down}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[13]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+151,74+offy,48,11,14,@strings[47,11],  {Del}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[14]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,85+offy,26,11,15,@strings[189,14],  {Text}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[15]:=pgad;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,96+offy,196{160},32,17,nil,  {graphic list}
                                   @ttopaz80,placetext_above,pdmn^.screenvisinfo,pgad,nil,@tags[0]);        {0}
          pdmn^.gads[17]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,128+offy,26,12,18,@strings[188,9],  {CommKey}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[2]);
          pdmn^.gads[18]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,129+offy,26,11,39,@strings[16,5], {BarLabel}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[39]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,140+offy,26,11,19,@strings[76,2],  {disabled}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[19]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,140+offy,26,11,20,@strings[173,10],  {checkit}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[20]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,151+offy,26,11,21,@strings[205,1],  {toggle}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[21]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,151+offy,26,11,22,@strings[92,1],  {checked}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[22]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,162+offy,132,14,23,@strings[176,7],  {label}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[23]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,offy+176,64,12,51,@getexcl[1],        {get exclude}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[51]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+72,offy+176,64,12,52,@clrexcl[1],     {clear exclude}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[52]:=pgad;
          offx:=offx+207;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,16+offy,196{160},44,24,nil{@strings[12,9]},  {subitem list}
                                   @ttopaz80,placetext_above,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[24]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,60+offy,196{160},14,25,nil{@strings[58,9]},  {Title}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[25]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,74+offy,48,11,26,@strings[11,2],  {New}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[26]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+53,74+offy,48,11,27,@strings[50,10],  {Up}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[27]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+102,74+offy,48,11,28,@strings[2,9],  {Down}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[28]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+151,74+offy,48,11,29,@strings[47,11],  {Del}
                                   @ttopaz80,placetext_in,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[29]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,85+offy,26,11,30,@strings[189,14],  {Text}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[30]:=pgad;
          pgad:=generalgadtoolsgad(listview_kind,offx+4,96+offy,196{160},32,32,nil,  {graphic list}
                                   @ttopaz80,placetext_above,pdmn^.screenvisinfo,pgad,nil,@tags[0]);      {0}
          pdmn^.gads[32]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,128+offy,26,12,33,@strings[188,9],  {CommKey}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[2]);
          pdmn^.gads[33]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,129+offy,26,11,40,@strings[16,5], {BarLabel}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[40]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,140+offy,26,11,34,@strings[76,2],  {disabled}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[34]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,140+offy,26,11,35,@strings[173,10],  {checkit}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[35]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,151+offy,26,11,36,@strings[205,1],  {toggle}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[36]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+110,151+offy,26,11,37,@strings[92,1],  {checked}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[37]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,162+offy,132,14,38,@strings[176,7],  {label}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[38]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,offy+176,64,12,53,@getexcl[1],        {get exclude}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[53]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+72,offy+176,64,12,54,@clrexcl[1],     {clear exclude}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[54]:=pgad;
          offx:=myscreen^.wborleft+4;
          settagitem(@tags[1],gtpa_depth,defaultscreenmode.sm_depth);
          settagitem(@tags[2],gtpa_color,pdmn^.frontpen);
          settagitem(@tags[3],gtpa_indicatorwidth,28);
          settagitem(@tags[4],tag_done,0);
          pgad:=generalgadtoolsgad(palette_kind,offx+4,offy+138,140,14,41,@strings[132,6],    {pen colour}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,@tags[1]);
          pdmn^.gads[41]:=pgad;
          settagitem(@tags[3],gt_underscore,ord('_')); {tag 4 is tag_done}
          pgad:=generalgadtoolsgad(button_kind,offx+4,offy+127,80,11,42,@strings[36,1],       {font select}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,@tags[3]);
          pdmn^.gads[42]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,offx+95,offy+127,26,11,43,@strings[30,10],   {default font}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[43]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+4,offy+166,68,12,44,@strings[154,8],      {test}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,@tags[3]);
          pdmn^.gads[44]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,offx+4,offy+152,140,14,45,@strings[176,7],     {id label}
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[45]:=pgad;
          pgad:=generalgadtoolsgad(button_kind,offx+76,offy+166,68,12,46,@strings[14,1],      {help}
                                   @ttopaz80,0,pdmn^.screenvisinfo,pgad,nil,@tags[3]);
          pdmn^.gads[46]:=pgad;
          
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,offy+184   +99   ,26,11,55,@newlook39str[1],   { newlook }
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.gads[55]:=pgad;
          
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,offy+178,26,11,177,@localgadstr[1],   { localgad }
                                   @ttopaz80,placetext_right,pdmn^.screenvisinfo,pgad,nil,nil);
          pdmn^.localgad:=pgad;
          
          
          if pgad<>nil then
            begin
              settagitem(@tags[1],wa_gadgets,long(pdmn^.glist));
              settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
              settagitem(@tags[3],wa_depthgadget,long(true));
              settagitem(@tags[4],tag_ignore,0);{screen}
              settagitem(@tags[5],wa_closegadget,long(true));
              settagitem(@tags[6],wa_left,0);
              settagitem(@tags[7],wa_top,100);
              settagitem(@tags[8],wa_width,627+offx);
              settagitem(@tags[9],wa_height,193+offy);
              settagitem(@tags[10],wa_title,long(@title[1]));
              settagitem(@tags[11],wa_dragbar,long(true));
              settagitem(@tags[12],wa_activate,long(true));
              settagitem(@tags[13],wa_autoadjust,long(true));
              settagitem(@tags[14],tag_done,0);
              pdmn^.editwindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                      buttonidcmp or
                                                                      listviewidcmp or
                                                                      stringidcmp or
                                                                      integeridcmp or
                                                                      idcmp_refreshwindow or
                                                                      IDCMP_VanillaKey);
              if pdmn^.editwindow<>nil then
                begin
                  pdmn^.editwindow^.userdata:=pointer(pdmn);
                  rendeditmenuwindow(pdmn);
                  testmenu(pdmn);
                  gt_setsinglegadgetattr(pdmn^.gads[43],pdmn^.editwindow,gtcb_checked,long(pdmn^.defaultfont));
                  gt_setsinglegadgetattr(pdmn^.gads[45],pdmn^.editwindow,gtst_string,long(@pdmn^.idlabel[1]));
                  
                  gt_setsinglegadgetattr(pdmn^.gads[55],pdmn^.editwindow,gtcb_checked,long(pdmn^.newlook39));
                  
                  gt_setsinglegadgetattr(pdmn^.localgad,pdmn^.editwindow,gtcb_checked,long(pdmn^.localmenu));
                  
                  gt_refreshwindow(pdmn^.editwindow,nil);
                end;
            end
           else
            telluser(mainwindow,'Unable to create gadgets.');
        end
       else
        telluser(mainwindow,'Unable to get visual info.');
    end
   else
    begin
      WindowToFront(pdmn^.editWindow);
      activatewindow(pdmn^.editWindow);
    end;
end;

procedure closeeditmenuwindow(pdmn:pdesignermenunode);
begin
  if pdmn^.testmenu<>nil then
    begin
      clearmenustrip(pdmn^.editwindow);
      freemenus(pdmn^.testmenu);
    end;
  pdmn^.testmenu:=nil;
  if pdmn^.editwindow<>nil then
    begin
      pdmn^.defaultfont:=checkedbox(pdmn^.gads[43]);
      pdmn^.newlook39:=checkedbox(pdmn^.gads[55]);
      pdmn^.idlabel:=getstringfromgad(pdmn^.gads[45]);
      closewindowsafely(pdmn^.editwindow);
    end;
  if pdmn^.glist<>nil then
    freegadgets(pdmn^.glist);
  pdmn^.glist:=nil;
  pdmn^.editwindow:=nil;
  if pdmn^.screenvisinfo<>nil then
    freevisualinfo(pdmn^.screenvisinfo);
end;

procedure closewindowcodewindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.codewindow<>nil then
    begin
      if pdwn^.cmenu<>nil then
        begin
          clearmenustrip(pdwn^.codewindow);
          freemenus(pdwn^.cmenu);
        end;
      closewindowsafely(pdwn^.codewindow);
    end;
  if pdwn^.codeglist<>nil then
    freegadgets(pdwn^.codeglist);
  pdwn^.codeglist:=nil;
  pdwn^.codewindow:=nil;
end;

procedure openwindowcodewindow(pdwn:pdesignerwindownode);
const
  codestrings : array[1..27] of string[38]=
  (
  'Check if already open'#0,
  'If Open MoveToFront'#0,
  'If Open Activate'#0,
  'Return Boolean'#0,
  'Open Only If Created Gads'#0,
  'Only One Gadget Font'#0,
  'If Open Fail'#0,
  'Use custom msgport'#0,
  'Calculate Border Sizes'#0,
  'Produce pgadget array'#0,
  'Attach'#0,
  'Create'#0,
  'Fail'#0,
  'Free'#0,
  'Menus'#0,
  'Slightly comment code'#0,
  'Scale Using Screen Font'#0,
  'WorkBench AppWindow'#0,
  'Edit _Gadget List...'#0,
  'Params'#0,
  'Do Not Define Pointers'#0,
  'SuperBitmap Window'#0,
  'Create SuperBitMap'#0,
  'Gadgets'#0,
  'Texts'##,
  'WindowTitle'#0,
  'ScreenTitle'#0
  );
  wintitle : string[25]='Window Code Options'#0;
  gap : byte = 0;
{$ifdef TEST}
  extrastring : string[20] = 'NoMon'#0;
{$endif}
var
  tags : array[0..24] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : integer;
  test : byte;
  localex : word;
  localey : word;
  menux   : word;
  menuy   : word;
  alopenx : word;
  alopeny : word;
  sbx,sby : word;
  gx,gy   : word;
  ox,oy   : word;
begin
  if pdwn^.codewindow=nil then
    begin
          offx:=pdwn^.editscreen^.wborleft+4;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+4;
          pdwn^.codeglist:=nil;
          pgad:=createcontext(@pdwn^.codeglist);
          settagitem(@tags[0],ga_disabled,long(true));
          settagitem(@tags[1],tag_done,0);
          
          alopenx:=offx+4;
          alopeny:=offy+1;
          pgad:=generalgadtoolsgad(checkbox_kind,alopenx,alopeny,26,11,1,@codestrings[1,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[1]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,alopenx+20,alopeny+11,26,11,2,@codestrings[2,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[2]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,alopenx+20,alopeny+22,26,11,3,@codestrings[3,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[3]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,alopenx+20,alopeny+33,26,11,7,@codestrings[7,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[7]:=pgad;
          
          gx:=alopenx;
          gy:=alopeny+50;
          
          pgad:=generalgadtoolsgad(checkbox_kind,gx,gy,26,11,6,@codestrings[6,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[6]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,gx,gy+11,26,11,10,@codestrings[10,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[10]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,gx,gy+22,26,11,5,@codestrings[5,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[5]:=pgad;
         
          ox:=alopenx;
          oy:=gy+39;
          
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy,26,11,9,@codestrings[9,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[9]:=pgad;
         
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy+11,26,11,17,@codestrings[17,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[17]:=pgad;
          
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy+22,26,11,4,@codestrings[4,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[4]:=pgad;
          
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy+33,26,11,8,@codestrings[8,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[8]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy+44,26,11,18,@codestrings[18,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[18]:=pgad;
          pgad:=generalgadtoolsgad(string_kind,ox,oy+61,180,13,909,@codestrings[20,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[26]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,ox,oy+74,26,11,19,@codestrings[21,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[19]:=pgad;
          
          localex:=offx+260;
          localey:=offy+92;
          pgad:=generalgadtoolsgad(checkbox_kind,localex,localey,26,11,121,@codestrings[24,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.localegads[1]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,localex,localey+11,26,11,122,@codestrings[25,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.localegads[2]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,localex+110,localey,26,11,123,@codestrings[26,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.localegads[3]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,localex+110,localey+11,26,11,124,@codestrings[27,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.localegads[4]:=pgad;
          
          
          menux:=localex;
          menuy:=offy+14;
          
          pgad:=generalgadtoolsgad(checkbox_kind,menux,40+menuy,26,11,11,@codestrings[11,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[11]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,menux+110,40+menuy,26,11,12,@codestrings[12,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[12]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,menux,51+menuy,26,11,13,@codestrings[13,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[13]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,menux+110,51+menuy,26,11,14,@codestrings[14,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[14]:=pgad;
          settagitem(@tags[2],gtlv_showselected,0);
          settagitem(@tags[3],tag_done,0);
          pgad:=generalgadtoolsgad(listview_kind,menux,menuy,242,40,25,@codestrings[15,1],  {}
                                   @ttopaz80,placetext_above,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[2]);
          pdwn^.codegadgets[25]:=pgad;
          
          sbx:=localex;
          sby:=localey+28;
          
          pgad:=generalgadtoolsgad(checkbox_kind,sbx,sby,26,11,27,@codestrings[22,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[27]:=pgad;
          pgad:=generalgadtoolsgad(checkbox_kind,sbx+20,sby+11,26,11,28,@codestrings[23,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[28]:=pgad;

          {
          pgad:=generalgadtoolsgad(checkbox_kind,offx+4,90+offy,26,11,15,@codestrings[15,1],
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[15]:=pgad;
          }
          pgad:=generalgadtoolsgad(checkbox_kind,sbx,sby+22,26,11,16,@codestrings[16,1],  {}
                                   @ttopaz80,placetext_right,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pdwn^.codegadgets[16]:=pgad;
          settagitem(@tags[1],gt_underscore,ord('_'));
          settagitem(@tags[2],tag_done,0);
          dec(offy,3);
          pgad:=generalgadtoolsgad(button_kind,localex+6,163+offy,70,14,22,@strings[16,1],  {ok}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pgad:=generalgadtoolsgad(button_kind,localex+86,163+offy,70,14,23,@strings[14,1],  {help}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          pgad:=generalgadtoolsgad(button_kind,localex+166,163+offy,70,14,24,@strings[17,1],  {cancel}
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          {
          pgad:=generalgadtoolsgad(button_kind,offx+4,115+offy,180,14,47,@codestrings[19,1],  }{gadgetlist...}{
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,@tags[1]);
          }

{$ifdef TEST}
          pgad:=generalgadtoolsgad(button_kind,offx+190,120+offy,50,12,998,@extrastring[1],
                                   @ttopaz80,placetext_in,pdwn^.helpwin.screenvisinfo,pgad,nil,nil);
{$endif}
          
          if pgad<>nil then
            begin
              settagitem(@tags[1],wa_gadgets,long(pdwn^.codeglist));
              settagitem(@tags[2],wa_smartrefresh{ Experiment },long(true));
              settagitem(@tags[3],wa_depthgadget,long(true));
              settagitem(@tags[4],wa_customscreen,long(pdwn^.editscreen));
              settagitem(@tags[5],wa_closegadget,long(true));
              settagitem(@tags[6],wa_left,round((pdwn^.editscreen^.width-286-offx)/2));
              settagitem(@tags[7],wa_top,100);
              settagitem(@tags[8],wa_width,514+offx);
              settagitem(@tags[9],wa_height,offy+184);
              settagitem(@tags[10],wa_title,long(@wintitle[1]));
              settagitem(@tags[11],wa_dragbar,long(true));
              settagitem(@tags[12],wa_activate,long(true));
              settagitem(@tags[13],wa_autoadjust,long(true));
              settagitem(@tags[14],tag_done,0);
              pdwn^.codewindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                                      buttonidcmp or
                                                                      checkboxidcmp or
                                                                      idcmp_menupick or
                                                                      listviewidcmp or
                                                                      idcmp_refreshwindow or
                                                                      IDCMP_VanillaKey);
              if pdwn^.codewindow<>nil then
                begin
                  pdwn^.codewindow^.userdata:=pointer(pdwn);
                  gt_refreshwindow(pdwn^.codewindow,nil);
                  
                  settagitem(@tags[2],gt_visualinfo,long(pdwn^.helpwin.screenvisinfo));
                  settagitem(@tags[3],tag_done,0);
              
                  drawbevelboxa(pdwn^.codewindow^.rport,menux-4,menuy-15,250,79,@tags[2]);
                  drawbevelboxa(pdwn^.codewindow^.rport,alopenx-4,alopeny-2,250,48,@tags[2]);
                  drawbevelboxa(pdwn^.codewindow^.rport,localex-4,localey-12,250,36,@tags[2]);
                  printstring(pdwn^.codewindow,localex+60,localey-10,'Locale Options',1,0,@ttopaz80);
                  drawbevelboxa(pdwn^.codewindow^.rport,sbx-4,sby-2,250,37,@tags[2]);
                  drawbevelboxa(pdwn^.codewindow^.rport,gx-4,gy-2,250,37,@tags[2]);
                  drawbevelboxa(pdwn^.codewindow^.rport,ox-4,oy-2,250,59,@tags[2]);
                  drawbevelboxa(pdwn^.codewindow^.rport,ox-4,oy+59,250,28,@tags[2]);
                  
                  drawbevelboxa(pdwn^.codewindow^.rport,sbx-4,sby+37,250,20,@tags[2]);
                  
                  
                  
                  setwindowcodewindowgadgets(pdwn);
                  pdwn^.cmenu:=nil;
                  wincodemenu:=nil;
                  if makemenuwincodemenu(pdwn^.helpwin.screenvisinfo) then
                    begin
                      if setmenustrip(pdwn^.codewindow,wincodemenu) then
                        pdwn^.cmenu:=wincodemenu
                       else
                        freemenus(wincodemenu);
                    end;
                end;
            end
           else
            telluser(mainwindow,memerror);
    
    end
   else
    begin
      WindowToFront(pdwn^.codeWindow);
      activatewindow(pdwn^.codeWindow);
    end;
end;

procedure openBevelWindow(pdwn:pdesignerwindownode);
Const
  Gadgetstrings : array[0..8] of string[9]=
  (
  '_Help...'#0,
  '_Update'#0,
  '_Move'#0,
  '_Size'#0,
  '_Delete'#0,
  '_Copy'#0,
  ''#0,
  '_New'#0,
  ''#0
  );
  wintitle : string [17]='Edit Bevel Boxes'#0;
  radioy : word = 27;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  PScr  : PScreen;
  pgad  : pgadget;
begin
  if pdwn^.BevelWindow=nil then
    begin
      Pscr:=pdwn^.editscreen;
      If Pscr<>Nil then
        Begin
          offx:=pdwn^.editscreen^.wborleft+9;
          offy:=pdwn^.editscreen^.wbortop+pdwn^.editscreen^.rastport.txheight+3;
          pdwn^.BevelWindowVisualInfo:=getvisualinfoa( PScr, Nil);
          if pdwn^.BevelWindowVisualInfo<>nil then
            Begin
              pdwn^.BevelWindowGList:=Nil;
              pGad:=createcontext(@pdwn^.BevelWindowGList);
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], Tag_Done, 0);
              
              pgad:=GeneralGadToolsGad( 1, offx+262, offy+105+radioy, 126, 14, 0, @gadgetstrings[0,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[0]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+262, offy+71+radioy, 126, 14, 1, @gadgetstrings[1,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[1]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+262, offy+2, 126, 14, 2, @gadgetstrings[2,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[2]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+262, offy+19, 126, 14, 3, @gadgetstrings[3,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[3]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+262, offy+88+radioy, 126, 14, 4, @gadgetstrings[4,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[4]:=pGad;
              {
              pgad:=GeneralGadToolsGad( 1, offx+91, offy+88, 126, 14, 5, @gadgetstrings[5,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              }
              pdwn^.BevelWindowGads[5]:=pGad;
              Settagitem(@tags[1], GTLV_ShowSelected, 0);
              Settagitem(@tags[2], GTLV_labels, long(@pdwn^.bevelboxlist));
              Settagitem(@tags[3], tag_done, 0);
              pgad:=GeneralGadToolsGad( 4, offx-1, offy+2, 251, 117+radioy, 6, @gadgetstrings[6,1],
                                       @ttopaz80, 1, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[6]:=pGad;
              Settagitem(@tags[2], GT_UnderScore, Ord('_'));
              {
              pgad:=GeneralGadToolsGad( 1, offx+4, offy+88, 80, 14, 7, @gadgetstrings[7,1],
                                       @ttopaz80, 16, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              }
              pdwn^.BevelWindowGads[7]:=pGad;
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], GTMX_Spacing, 2);
              SetTagItem(@tags[3], GTMX_Labels, Long(@Bevel_RadioLabels));
              Settagitem(@tags[4], Tag_Done, 0);
              pgad:=GeneralGadToolsGad( 5, offx+262, offy+36, 17, 29, 8, @gadgetstrings[8,1],
                                       @ttopaz80, 2, pdwn^.BevelWindowVisualInfo, pGad, Nil, @tags[1]);
              pdwn^.BevelWindowGads[8]:=pGad;
              if pgad<>nil then
                begin
                  settagitem(@tags[ 1],WA_Left  ,293);
                  settagitem(@tags[ 2],WA_Top   ,100);
                  settagitem(@tags[ 3],WA_Width ,400+offx);
                  settagitem(@tags[ 4],WA_Height,125+offy+radioy);
                  settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
                  settagitem(@tags[ 6],WA_DragBar,long(true));
                  settagitem(@tags[ 7],WA_DepthGadget,long(true));
                  settagitem(@tags[ 8],WA_CloseGadget,long(true));
                  settagitem(@tags[ 9],WA_Activate,long(true));
                  settagitem(@tags[10],WA_smartrefresh{ Experiment },long(true));
                  settagitem(@tags[11],WA_AutoAdjust,long(true));
                  settagitem(@tags[12],WA_Gadgets,long(pdwn^.BevelWindowglist));
                  settagitem(@tags[13],wa_customscreen,long(pdwn^.editscreen));
                  settagitem(@tags[14],Tag_Done,0);
                  pdwn^.BevelWindow:=openwindowtaglistnicely(Nil,@tags[1],listviewidcmp or
                                                                          idcmp_vanillakey or
                                                                          idcmp_menupick or
                                                                          idcmp_closewindow or
                                                                          idcmp_refreshwindow or
                                                                          buttonidcmp or
                                                                          mxidcmp);
                  if pdwn^.BevelWindow<>nil then
                    begin
                      pdwn^.bevelwindow^.userdata:=pointer(pdwn);
                      GT_RefreshWindow( pdwn^.BevelWindow, Nil);
                      
                      settagitem(@tags[1],gt_visualinfo,long(pdwn^.BevelWindowVisualInfo));
                      settagitem(@tags[2],tag_done,0);
                      drawbevelboxa(pdwn^.bevelwindow^.rport,offx-5,offy,259,121+radioy,@tags[1]);
                      drawbevelboxa(pdwn^.bevelwindow^.rport,offx+258,offy,134,121+radioy,@tags[1]);
                      
                      gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                             gtlv_selected,long(pdwn^.bevelselected));
                      if pdwn^.listmenu<>nil then
                        if setmenustrip(pdwn^.bevelwindow,pdwn^.listmenu) then;
                    end
                   else
                    Begin
                      FreeVisualInfo(pdwn^.BevelWindowVisualInfo);
                      FreeGadgets(pdwn^.BevelWindowGList);
                    end;
                end
               else
                FreeVisualInfo(pdwn^.BevelWindowVisualinfo);
            end;
        end;
    end
   else
    begin
      WindowToFront(pdwn^.BevelWindow);
      activatewindow(pdwn^.BevelWindow);
    end;
end;

Procedure CloseBevelWindow(pdwn:pdesignerwindownode);
Begin
  if pdwn^.BevelWindow<>nil then
    Begin
      if pdwn^.bevelwindow^.menustrip<>nil then
        clearmenustrip(pdwn^.bevelwindow);
      Closewindowsafely(pdwn^.BevelWindow);
      pdwn^.BevelWindow:=Nil;
      FreeVisualInfo(pdwn^.BevelWindowVisualinfo);
      FreeGadgets(pdwn^.BevelWindowGList);
    end;
end;

procedure OpenMainCodeWindow;
const
  wintitle : string[13]='Code Options'#0;
  Gadgetstrings : array[1..18] of string[25]=
  (
  'Language Producer'#0,
  '_Help...'#0,
  '_Libraries'#0,
  'Comment Produced Code'#0,
  'Make WaitPointer Data'#0,
  'Create IDCMP Handlers'#0,
  'Make Library Code'#0,
  'Use __chip in C'#0,
  'OpenDiskFonts'#0,
  'Make Main Program'#0,
  'Include'#0,
  'Locale...'#0,
  'Produce Locale .cd'#0,
  'Produce Locale .ct'#0,
  'GTB compatability'#0,
  'Alternate Includes'#0,
  'Open first screen'#0,
  'HSPascal 3.1 units'#0
  );
var
  tags : array[0..16] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : byte;
begin
  if maincodewindow=nil then
    begin
      settagitem(@tags[0],gtlv_showselected,0);
      settagitem(@tags[1],GT_underscore,ord('_'));
      settagitem(@tags[2],tag_done,0);
      offx:=myscreen^.wborleft;
      offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
      
      maincodeglist:=nil;
      pgad:=createcontext(@maincodeglist);
      
      pgad:=generalgadtoolsgad(listview_kind,8+offx,18+offy,242,49,1,@gadgetstrings[1,1], {list view}
                               @ttopaz80,placetext_above,screenvisualinfo,pgad,nil,@tags[0]);
      maincodegadgets[1]:=pgad;
      
      
      for loop:=2 to 5 do
        begin       
          pgad:=generalgadtoolsgad(checkbox_kind,8+offx,66+loop*13-26+offy+8,26,11,loop,
                               @gadgetstrings[loop+2,1],
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
          maincodegadgets[loop]:=pgad;
        end;
      
      pgad:=generalgadtoolsgad(checkbox_kind,8+offx,66+6*13+offy-26+8,26,11,7,
                               @gadgetstrings[7+2,1],
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[7]:=pgad;

      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,4+offy,26,11,8,
                               @gadgetstrings[10,1], 
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[8]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,282+offx,17+offy,26,11,17,@gadgetstrings[17,1], { open screen }
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[17]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,34+offy,26,11,13,@gadgetstrings[13,1], {.cd file}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[13]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,47+offy,26,11,14,@gadgetstrings[14,1], {.ct file}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[14]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,64+offy,26,11,18,@gadgetstrings[18,1], { open screen }
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[18]:=pgad;
      
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,81+offy,26,11,15,@gadgetstrings[15,1], {GTB compat.}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[15]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,107+offy,26,11,16,@gadgetstrings[16,1], {alt. includes}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[16]:=pgad;
      
      pgad:=generalgadtoolsgad(checkbox_kind,262+offx,94+offy,26,11,6,@gadgetstrings[6+2,1], {comment code}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[2]);
      maincodegadgets[6]:=pgad;
      
      pgad:=generalgadtoolsgad(string_kind,262+offx,offy+124,170,13,12,@gadgetstrings[11,1], {includeextra}
                               @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[1]);
      maincodegadgets[12]:=pgad;
      
      pgad:=generalgadtoolsgad(button_kind,8+offx,143+offy,100,15,101,@gadgetstrings[2,1], {help}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,206+offx,143+offy,100,15,102,@gadgetstrings[3,1], {libs}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,404+offx,offy+143,100,15,103,@gadgetstrings[12,1], {locale}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      
      if pgad<>nil then
        begin
          settagitem(@tags[ 1],wa_left,300);
          settagitem(@tags[ 2],wa_top,100);
          settagitem(@tags[ 3],wa_width,516+myscreen^.wborleft);
          settagitem(@tags[ 4],wa_height,164+offy);
          settagitem(@tags[ 5],wa_closegadget,long(true));
          settagitem(@tags[ 6],wa_title,long(@wintitle[1]));
          settagitem(@tags[ 7],wa_dragbar,long(true));
          settagitem(@tags[ 8],wa_activate,long(true));
          settagitem(@tags[ 9],wa_autoadjust,long(true));
          settagitem(@tags[10],wa_gadgets,long(maincodeglist));
          settagitem(@tags[11],wa_depthgadget,long(true));
          settagitem(@tags[12],wa_autoadjust,long(true));
          settagitem(@tags[13],wa_smartrefresh,long(true));
          settagitem(@tags[14],wa_screentitle,long(@frontscreentitle[1]));
          settagitem(@tags[15],tag_done,0);
          maincodewindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                               listviewidcmp or
                                                               checkboxidcmp or
                                                               idcmp_refreshwindow or
                                                               integeridcmp or
                                                               idcmp_menupick or
                                                               idcmp_vanillakey or
                                                               buttonidcmp);
          if maincodewindow<>nil then
            begin
              maincodewindow^.userdata:=pointer(@maincodewindownode);
              gt_refreshwindow(maincodewindow,nil);
              
              settagitem(@tags[ 2],gt_visualinfo,long(screenvisualinfo));
              settagitem(@tags[ 3],tag_done,0);
         
              offx:=myscreen^.wborleft;
              offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
              
              drawbevelboxa(maincodewindow^.rport,offx+4,offy+2,250,68,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+4,offy+72,250,67,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+258,offy+2,250,28,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+258,offy+32,250,28,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+258,offy+62,250,15,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+258,offy+79,250,41,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+258,offy+122,250,17,@tags[2]);
              drawbevelboxa(maincodewindow^.rport,offx+4,offy+141,504,19,@tags[2]);
              
              
              gt_setsinglegadgetattr(maincodegadgets[1],maincodewindow,
                                     gtlv_labels,long(@compilerlist));
              gt_setsinglegadgetattr(maincodegadgets[1],maincodewindow,
                                     gtlv_selected,presentcompiler);
              gt_setsinglegadgetattr(maincodegadgets[12],maincodewindow,
                                     gtst_string,long(@globalincludeextra[1]));
              for loop:=2 to 8 do
                gt_setsinglegadgetattr(maincodegadgets[loop],maincodewindow,
                                       gtcb_checked,long(codeoptions[loop-1]));
              gt_setsinglegadgetattr(maincodegadgets[13],maincodewindow,
                                       gtcb_checked,long(codeoptions[8]));
              gt_setsinglegadgetattr(maincodegadgets[14],maincodewindow,
                                       gtcb_checked,long(codeoptions[9]));
              gt_setsinglegadgetattr(maincodegadgets[15],maincodewindow,
                                       gtcb_checked,long(codeoptions[10]));
              gt_setsinglegadgetattr(maincodegadgets[16],maincodewindow,
                                       gtcb_checked,long(codeoptions[11]));
              
              gt_setsinglegadgetattr(maincodegadgets[17],maincodewindow,
                                       gtcb_checked,long(codeoptions[12]));
              
              gt_setsinglegadgetattr(maincodegadgets[18],maincodewindow,
                                       gtcb_checked,long(codeoptions[13]));
              
              if makemenumaincodemenu(screenvisualinfo) then
                begin
                  if not setmenustrip(maincodewindow,maincodemenu) then
                    begin
                      freemenus(maincodemenu);
                      maincodemenu:=nil;
                    end;
                end;
            end;
        end
       else
        begin
          freegadgets(maincodeglist);
          telluser(mainwindow,'Unable to create gadgets for main code window.');
        end;
    end
   else
    begin
      windowtofront(maincodewindow);
      activatewindow(maincodewindow);
    end;
end;

procedure closemaincodewindow;
begin
  if maincodewindow<>nil then
    begin
      globalincludeextra:=getstringfromgad(maincodegadgets[12]);
      if maincodemenu<>nil then
        begin
          clearmenustrip(maincodewindow);
          freemenus(maincodemenu);
          maincodemenu:=nil;
        end;
      closewindowsafely(maincodewindow);
    end;
  if maincodeglist<>nil then
    freegadgets(maincodeglist);
  maincodeglist:=nil;
  maincodewindow:=nil;
end;

procedure closeprefswindow;
begin
  if prefswindow<>nil then
    begin
      if prefsmenu<>nil then
        begin
          clearmenustrip(prefswindow);
          freemenus(prefsmenu);
        end;
      closewindowsafely(prefswindow);
    end;
  if prefsglist<>nil then
    freegadgets(prefsglist);
  prefsglist:=nil;
  prefswindow:=nil;
end;

procedure OpenPrefsWindow;
const
  wintitle : string[22]='Designer Preferences'#0;
  Gadgetstrings : array[1..19] of string[35]=
  (
  'Open About When Run'#0,
  'Quit Are You Sure ?'#0,
  'Delete Window Are You Sure ?'#0,
  'Delete Menu Are You Sure ?'#0,
  'Delete Image Are You Sure ?'#0,
  'Delete Gadget Are You Sure ?'#0,
  'Make Icons'#0,
  'Load Are You Sure ?'#0,
  'Backdrop Tools Window'#0,
  'Auto open Gadget List Window'#0,
  'Display Images with palette'#0,
  'Create file backups'#0,
  'Auto test Menus'#0,
  'Revert Are You Sure ?'#0,
  'Localize everything'#0,
  'Old style error messages'#0,
  'Delete Screen Are You Sure ?'#0,
  'Screen editor on edit screen'#0,
  'Cancel deletes created gadgets'#0
  );
  listviewstring:string[17]='Default Producer'#0;
var
  tags : array[0..16] of ttagitem;
  pgad : pgadget;
  offx : integer;
  offy : integer;
  loop : byte;
  left : byte;
begin
  waiteverything;
  left:=(numofprefsoptions div 2)-2;
  if Prefswindow=nil then
    begin
      settagitem(@tags[0],gtlv_showselected,0);
      settagitem(@tags[1],GT_underscore,ord('_'));
      settagitem(@tags[2],tag_done,0);
      offx:=myscreen^.wborleft+4;
      offy:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
      Prefsglist:=nil;
      pgad:=createcontext(@Prefsglist);
      pgad:=generalgadtoolsgad(listview_kind,4+offx,16+offy,257,49,0,@listviewstring[1], {list view}
                               @ttopaz80,placetext_above,screenvisualinfo,pgad,nil,@tags[0]);
      prefsgadgets[0]:=pgad;
      for loop:=1 to left do
        begin
          pgad:=generalgadtoolsgad(checkbox_kind,4+offx,55+11*loop+offy,26,11,loop,@gadgetstrings[loop,1], {options}
                                   @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[1]);
          prefsgadgets[loop]:=pgad;
        end;
      offx:=offx+270;
      offy:=offy+3;
      for loop:=left+1 to numofprefsoptions do
        begin
          pgad:=generalgadtoolsgad(checkbox_kind,offx,11*(loop-left-1)+offy,26,11,loop,@gadgetstrings[loop,1], {options}
                                   @ttopaz80,placetext_right,screenvisualinfo,pgad,nil,@tags[1]);
          prefsgadgets[loop]:=pgad;
        end;
      offy:=offy+6+11*(numofprefsoptions-left);
      pgad:=generalgadtoolsgad(button_kind,offx,offy,86,14,100,@strings[9,1],    {save}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,100+offx,offy,86,14,101,@strings[81,7],       {use}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      pgad:=generalgadtoolsgad(button_kind,200+offx,offy,86,14,102,@strings[17,1], {cancel}
                               @ttopaz80,placetext_in,screenvisualinfo,pgad,nil,@tags[1]);
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_left,300);
          settagitem(@tags[2],wa_top,100);
          settagitem(@tags[3],wa_width,296+offx);
          settagitem(@tags[4],wa_height,18+offy);
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_title,long(@wintitle[1]));
          settagitem(@tags[7],wa_dragbar,long(true));
          settagitem(@tags[8],wa_activate,long(true));
          settagitem(@tags[9],wa_autoadjust,long(true));
          settagitem(@tags[10],wa_gadgets,long(Prefsglist));
          settagitem(@tags[11],wa_depthgadget,long(true));
          settagitem(@tags[12],wa_autoadjust,long(true));
          settagitem(@tags[13],wa_smartrefresh{ Experiment },long(true));
          settagitem(@tags[14],wa_screentitle,long(@frontscreentitle[1]));
          settagitem(@tags[15],tag_done,0);
          Prefswindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_closewindow or
                                                            listviewidcmp or
                                                            idcmp_refreshwindow or
                                                            checkboxidcmp or
                                                            integeridcmp or
                                                            idcmp_vanillakey or
                                                            idcmp_menupick or
                                                            buttonidcmp);
          if Prefswindow<>nil then
            begin
              prefswindow^.userdata:=pointer(@prefswindownode);
              gt_refreshwindow(prefswindow,nil);
              gt_setsinglegadgetattr(prefsgadgets[0],prefswindow,
                                     gtlv_labels,long(@compilerlist));
              gt_setsinglegadgetattr(prefsgadgets[0],prefswindow,
                                     gtlv_selected,deflangnum);
              for loop:=1 to numofprefsoptions do
                gt_setsinglegadgetattr(prefsgadgets[loop],prefswindow,
                                       gtcb_checked,long(prefsvalues[loop]));
              prefsmenu:=nil;
              if makemenuprefsmenu(screenvisualinfo) then
                begin
                  if not setmenustrip(prefswindow,prefsmenu) then
                    begin
                      freemenus(prefsmenu);
                      prefsmenu:=nil;
                    end;
                end;
            end;
        end
       else
        begin
          freegadgets(prefsglist);
          telluser(mainwindow,'Unable to create gadgets for main prefernces window.');
        end;
    end
   else
    begin
      windowtofront(prefswindow);
      activatewindow(prefswindow);
    end;
  unwaiteverything;
end;

procedure openimageeditwindow(pin:pimagenode);
Const
  Gadgetstrings : array[0..10] of string[13]=
  (
  '_Label'#0,
  '_OK'#0,
  '_Help...'#0,
  '_View'#0,
  '_Cancel'#0,
  'Width :'#0,
  'Height :'#0,
  'Depth :'#0,
  'PlanePick :'#0,
  'PlaneOnOff :'#0,
  'Bit : '#0
  );
  sizestring : string[10] ='Bytes :'#0;
  cmapstring : string[10] ='Colours :'#0;
  gs : array[1..7] of string[2]=
  (
  '1'#0,
  '2'#0,
  '3'#0,
  '4'#0,
  '5'#0,
  '6'#0,
  '7'#0
  );
  wintitle : string [11]='Edit Image'#0;
Var
  Dummy : Boolean;
  Loop  : Word;
  offx  : Word;
  offy  : Word;
  tags  : array[1..40] of ttagitem;
  PScr  : PScreen;
  pgad  : pgadget;
begin
  waiteverything;
  if pin^.editwindow=nil then
    begin
      Pscr:=myscreen;
      If Pscr<>Nil then
        Begin
          offx:=PScr^.WBorLeft;
          offy:=PScr^.WBorTop+PScr^.Font^.ta_YSize+1;
          pin^.editwindowVisualInfo:=getvisualinfoa( PScr, Nil);
          if pin^.editwindowVisualInfo<>nil then
            Begin
              pin^.editwindowGList:=Nil;
              pGad:=createcontext(@pin^.editwindowGList);
              Settagitem(@tags[1], GT_UnderScore, Ord('_'));
              Settagitem(@tags[2], Tag_Done, 0);
              
              pgad:=GeneralGadToolsGad( 12, offx+10, offy+5, 240, 14, 0, @gadgetstrings[0,1], {label}
                                       @ttopaz80, 2, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[0]:=pGad;
              
              pgad:=GeneralGadToolsGad( 1, offx+10, offy+129, 75, 14, 1, @gadgetstrings[1,1], {ok}
                                       @ttopaz80, 16, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[1]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+89, offy+129, 75, 14, 2, @gadgetstrings[2,1], {help}
                                       @ttopaz80, 16, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[2]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+169, offy+129, 75, 14, 3, @gadgetstrings[3,1], {view}
                                       @ttopaz80, 16, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[3]:=pGad;
              pgad:=GeneralGadToolsGad( 1, offx+249, offy+129, 74, 14, 4, @gadgetstrings[4,1], {cancel}
                                       @ttopaz80, 16, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[4]:=pGad;
              
              Settagitem(@tags[1], GTNM_Number, pin^.width);
              settagitem(@tags[2], gtnm_border, long(true));
              settagitem(@tags[3], tag_done, 0);
              pgad:=GeneralGadToolsGad( 6, offx+97, offy+27, 50, 13, 5, @gadgetstrings[5,1], {width}
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[5]:=pGad;
              Settagitem(@tags[1], GTNM_Number, pin^.height);
              pgad:=GeneralGadToolsGad( 6, offx+97, offy+43, 50, 14, 6, @gadgetstrings[6,1], {height}
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[6]:=pGad;
              Settagitem(@tags[1], GTNM_Number, pin^.depth);
              pgad:=GeneralGadToolsGad( 6, offx+97, offy+60, 50, 14, 7, @gadgetstrings[7,1], {depth}
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[7]:=pGad;
              pgad:=GeneralGadToolsGad( 2, offx+107+4, offy+96, 26, 11, 8, @gadgetstrings[8,1],
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, Nil);
              pin^.editwindowGads[8]:=pGad;
              
              for loop:=1 to 7 do
                begin
                  pgad:=GeneralGadToolsGad( 2, offx+107+loop*27+4, offy+96, 26, 11, 8+loop, @gs[loop,1],
                                       @ttopaz80, placetext_above, pin^.editwindowVisualInfo, pGad, Nil, Nil);
                  pin^.editwindowGads[8+loop]:=pGad;
                end;
              
              pgad:=GeneralGadToolsGad( 2, offx+107+4, offy+110, 26, 11, 16, @gadgetstrings[9,1],
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, Nil);
              pin^.editwindowGads[16]:=pGad;
              
              for loop:=1 to 7 do
                begin
                  pgad:=GeneralGadToolsGad( 2, offx+107+loop*27+4, offy+110, 26, 11, 16+loop, nil,
                                       nil, 0, pin^.editwindowVisualInfo, pGad, Nil, Nil);
                  pin^.editwindowGads[16+loop]:=pGad;
                end;
              
              pgad:=GeneralGadToolsGad( 6, offx+117, offy+82, 34, 12, 24, @gadgetstrings[10,1],
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, Nil);
              pin^.editwindowGads[24]:=pGad;
              
              if pin^.imagedata<>nil then
                Settagitem(@tags[1], GTNM_Number, pin^.sizeallocated)
               else
                Settagitem(@tags[1], GTNM_Number, 0);
              pgad:=GeneralGadToolsGad( 6, offx+240, offy+27, 70, 13, 25, @sizestring[1], {sizeof}
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[25]:=pGad;

              if pin^.colourmap<>nil then
                Settagitem(@tags[1], GTNM_Number, pin^.mapsize div 4)
               else
                Settagitem(@tags[1], GTNM_Number, 0);
              pgad:=GeneralGadToolsGad( 6, offx+240, offy+43, 70, 13, 26, @cmapstring[1], {colors}
                                       @ttopaz80, 1, pin^.editwindowVisualInfo, pGad, Nil, @tags[1]);
              pin^.editwindowGads[26]:=pGad;
              
              if pgad<>nil then
                begin
                  settagitem(@tags[ 1],WA_Left  ,508);
                  settagitem(@tags[ 2],WA_Top   ,35);
                  settagitem(@tags[ 3],WA_Width ,340+offx);
                  settagitem(@tags[ 4],WA_Height,150+offy);
                  settagitem(@tags[ 5],WA_Title ,long(@WinTitle[1]));
                  settagitem(@tags[ 6],WA_ScreenTitle,long(@frontscreentitle[1]));
                  settagitem(@tags[ 7],WA_MinWidth ,150);
                  settagitem(@tags[ 8],WA_MinHeight,25);
                  settagitem(@tags[ 9],WA_MaxWidth ,1200);
                  settagitem(@tags[10],WA_MaxHeight,1200);
                  settagitem(@tags[11],WA_DragBar,long(true));
                  settagitem(@tags[12],WA_DepthGadget,long(true));
                  settagitem(@tags[13],WA_CloseGadget,long(true));
                  settagitem(@tags[14],WA_Activate,long(true));
                  settagitem(@tags[15],WA_smartrefresh{ Experiment },long(true));
                  settagitem(@tags[16],WA_AutoAdjust,long(true));
                  settagitem(@tags[17],WA_Gadgets,long(pin^.editwindowglist));
                  settagitem(@tags[18],Tag_Done,0);
                  pin^.editwindow:=openwindowtaglistnicely(Nil,@tags[1],580 or idcmp_vanillakey
                                                                            or stringidcmp
                                                                            or idcmp_refreshwindow
                                                                            or idcmp_closewindow
                                                                            or idcmp_menupick
                                                                            or buttonidcmp);
                  if pin^.editwindow<>nil then
                    begin
                      pin^.editwindow^.userdata:=pointer(pin);
                      GT_RefreshWindow( pin^.editwindow, Nil);
                      settagitem(@tags[1],gt_visualinfo,long(screenvisualinfo));
                      settagitem(@tags[2],0,0);
                      
                      drawbevelboxa(pin^.editwindow^.rport,offx+4,offy+2,327,20,@tags[1]);
                      drawbevelboxa(pin^.editwindow^.rport,offx+4,offy+24,327,53,@tags[1]);
                      drawbevelboxa(pin^.editwindow^.rport,offx+4,offy+79,327,45,@tags[1]);
                      drawbevelboxa(pin^.editwindow^.rport,offx+4,offy+126,327,20,@tags[1]);
                      
                      
                      gt_setsinglegadgetattr(pin^.editwindowgads[0],pin^.editwindow,gtst_string,long(@pin^.title[1]));
                      for loop:=0 to 7 do
                        begin
                          gt_setsinglegadgetattr(pin^.editwindowgads[8+loop],pin^.editwindow,
                                                gtcb_checked,long((pin^.planepick and (1 shl loop))<>0));
                          gt_setsinglegadgetattr(pin^.editwindowgads[16+loop],pin^.editwindow,
                                                gtcb_checked,long((pin^.planeonoff and (1 shl loop))<>0));
                        end;
                      if editimagemenu<>nil then
                        if setmenustrip(pin^.editwindow,editimagemenu) then;
                    end
                   else
                    Begin
                      FreeVisualInfo(pin^.editwindowVisualInfo);
                      FreeGadgets(pin^.editwindowGList);
                    end;
                end
               else
                FreeVisualInfo(pin^.editwindowVisualinfo);
            end;
        end;
    end
   else
    begin
      WindowToFront(pin^.editwindow);
      activatewindow(pin^.editwindow);
    end;
  unwaiteverything;
end;

Procedure Closeimageeditwindow(pin : pimagenode);
Begin
  if pin^.editwindow<>nil then
    Begin
      if pin^.editwindow^.menustrip<>nil then
        clearmenustrip(pin^.editwindow);
      Closewindowsafely(pin^.editwindow);
      pin^.editwindow:=Nil;
      FreeVisualInfo(pin^.editwindowVisualinfo);
      FreeGadgets(pin^.editwindowGList);
    end;
end;

procedure closemagnifywindow(pdwn:pdesignerwindownode);
begin
  if pdwn^.magnifywindow<>nil then
    begin
      waiteverything;
      pdwn^.magnifymode:=0;
      waitblit;
      if pdwn^.magnifymenu<>nil then
        begin
          clearmenustrip(pdwn^.magnifywindow);
          freemenus(pdwn^.magnifymenu);
        end;
      closewindowsafely(pdwn^.magnifywindow);
      Freegadgets(pdwn^.magnifywinglist);
      pdwn^.magnifywindow:=nil;
      if pdwn^.largecopy<>nil then
        freemyfullbitmap(pdwn^.largecopy,pdwn^.magwidth*pdwn^.oldmagnify,
         pdwn^.magheight*pdwn^.oldmagnify,pdwn^.screenprefs.sm_depth);
      pdwn^.largecopy:=nil;
      unwaiteverything;
      inputmode:=1;
    end;
end;

end.
