unit import;

interface

uses designermenus,utility,layers,gadtools,exec,intuition,dos,
     amigados,graphics,definitions,iffparse,amiga,routines,
     asl,workbench,diskfont,gtx,nofrag,drawwindows,loadsave,obsolete;

procedure importagtbfile;

var
  tempwindowlist : tlist;
  tempmenulist   : tlist;

implementation

function boolcheck(l:long):long;
begin
  if l<>0 then 
    boolcheck:=1
   else
    boolcheck:=0;
end;

function convertproject(ppro : pprojectwindow):boolean;
var
  oksofar : boolean;
  temp    : string;
  safety1 : string;
  safety2 : string;
  pdwn    : pdesignerwindownode;
  pbbn    : pbevelboxnode;
  pbb     : pbevelbox;
  ptag    : ptagitem;
  tstate  : ptagitem;
  pb      : pbyte;
  pit     : pintuitext;
  ptn     : ptextnode;
  pfr     : pfontrequester;
  pgn     : pgadgetnode;
  peng    : pextnewgadget;
  psn     : pstringnode;
  mxc     : long;
  pn      : pnode;
  pl      : plist;
  ppa     : ppointerarray;
  loop    : integer;
  peng2   : pextnewgadget;
  pmen    : pdesignermenunode;
  pmtn    : pmenutitlenode;
  pmin    : pmenuitemnode;
  pmsi    : pmenusubitemnode;
  penmt   : pextnewmenu;
  penmi   : pextnewmenu;
  penms   : pextnewmenu;

begin
  oksofar:=true;
  pdwn:=pdesignerwindownode(allocmymem(sizeof(tdesignerwindownode), memf_any or memf_clear));
  if pdwn<>nil then
    begin
      setdefaultwindow(pdwn);
      
      addtail(@tempwindowlist,pnode(pdwn));
      
      ctopas(ppro^.pw_name,temp);
      if length(temp)>65 then
        temp:=copy(temp,1,65);
      pdwn^.labelid:=temp+#0;
      
      ctopas(ppro^.pw_screentitle,temp);
      if length(temp)>65 then
        temp:=copy(temp,1,65);
      pdwn^.screentitle:=temp+#0;
      
      ctopas(ppro^.pw_windowtitle,temp);
      if length(temp)>65 then
        temp:=copy(temp,1,65);
      pdwn^.title:=temp+#0;
      
      
      { copy window data }
      tstate:=ppro^.pw_Tags;
      ptag:=nexttagitem(@tstate);
      while(ptag<>nil) do
        begin
          case ptag^.ti_tag of
            wa_left   : pdwn^.x:=ptag^.ti_data;
            wa_top    : pdwn^.y:=ptag^.ti_data;
            wa_width  : pdwn^.w:=ptag^.ti_data-ppro^.pw_leftborder;
            wa_height : pdwn^.h:=ptag^.ti_data-ppro^.pw_topborder;
            wa_innerwidth   : pdwn^.innerw:=ptag^.ti_data;
            wa_innerheight    : pdwn^.innerh:=ptag^.ti_data;
            wa_maxwidth   : pdwn^.maxw:=ptag^.ti_data;
            wa_minwidth    : pdwn^.minw:=ptag^.ti_data;
            wa_maxheight  : pdwn^.maxh:=ptag^.ti_data;
            wa_minheight : pdwn^.minh:=ptag^.ti_data;

            
            wa_screentitle :
                        begin
                          pb:=pbyte(ptag^.ti_data);
                          ctopas(pb^,temp);
                          if length(temp)>65 then
                            temp:=copy(temp,1,65);
                          pdwn^.screentitle:=temp+#0;
                        end;
            wa_sizegadget : pdwn^.sizegad:=boolean(ptag^.ti_data);
            wa_sizebright : begin
                              pdwn^.sizebright:=boolean(ptag^.ti_data);
                              if pdwn^.sizebright then
                                pdwn^.sizegad:=true;
                            end;
            wa_sizebbottom : begin
                               pdwn^.sizebbottom:=boolean(ptag^.ti_data);
                               if pdwn^.sizebbottom then
                                 pdwn^.sizegad:=true;
                             end;
            wa_dragbar : pdwn^.dragbar:=boolean(ptag^.ti_data);
            wa_depthgadget : pdwn^.depthgad:=boolean(ptag^.ti_data);
            wa_closegadget : pdwn^.closegad:=boolean(ptag^.ti_data);
         
           end;
          ptag:=nexttagitem(@tstate);
        end;
      
      pdwn^.sizegad:=(ppro^.pw_windowflags and wflg_sizegadget)<>0;
      pdwn^.sizebbottom:=(ppro^.pw_windowflags and wflg_sizebbottom)<>0;
      pdwn^.sizebright:=(ppro^.pw_windowflags and wflg_sizebright)<>0;
      pdwn^.closegad:=(ppro^.pw_windowflags and wflg_closegadget)<>0;
      pdwn^.depthgad:=(ppro^.pw_windowflags and wflg_depthgadget)<>0;
      pdwn^.dragbar:=(ppro^.pw_windowflags and wflg_dragbar)<>0;
      pdwn^.reportmouse:=(ppro^.pw_windowflags and wflg_reportmouse)<>0;
      pdwn^.nocarerefresh:=(ppro^.pw_windowflags and wflg_nocarerefresh)<>0;
      pdwn^.smartrefresh:=(ppro^.pw_windowflags and wflg_smart_refresh)<>0;
      pdwn^.simplerefresh:=(ppro^.pw_windowflags and wflg_simple_refresh)<>0;
      pdwn^.backdrop:=(ppro^.pw_windowflags and wflg_backdrop)<>0;
      pdwn^.borderless:=(ppro^.pw_windowflags and wflg_borderless)<>0;
      pdwn^.rmbtrap:=(ppro^.pw_windowflags and wflg_rmbtrap)<>0;
      pdwn^.activate:=(ppro^.pw_windowflags and wflg_activate)<>0;
      pdwn^.gimmezz:=(ppro^.pw_windowflags and wflg_gimmezerozero)<>0;
      {
      pdwn^.moretags[1]:=(ppro^.pw_windowflags and wflg_super_bitmap)<>0;
      }
      pdwn^.nextid:=ppro^.pw_countidfrom;
      {
      pdwn^.x:=ppro^.pw_leftborder;
      pdwn^.y:=ppro^.pw_topborder;
      }
      { idcmp : }
      pdwn^.idcmplist[ 1]:=(ppro^.pw_idcmp and idcmp_mousebuttons)<>0;
      pdwn^.idcmplist[ 2]:=(ppro^.pw_idcmp and idcmp_mousemove)<>0;
      pdwn^.idcmplist[ 3]:=(ppro^.pw_idcmp and idcmp_deltamove)<>0;
      pdwn^.idcmplist[ 4]:=(ppro^.pw_idcmp and idcmp_gadgetdown)<>0;
      pdwn^.idcmplist[ 5]:=(ppro^.pw_idcmp and idcmp_gadgetup)<>0;
      pdwn^.idcmplist[ 6]:=(ppro^.pw_idcmp and idcmp_closewindow)<>0;
      pdwn^.idcmplist[ 7]:=(ppro^.pw_idcmp and idcmp_menupick)<>0;
      pdwn^.idcmplist[ 8]:=(ppro^.pw_idcmp and idcmp_menuverify)<>0;
      pdwn^.idcmplist[ 9]:=(ppro^.pw_idcmp and idcmp_menuhelp)<>0;
      pdwn^.idcmplist[10]:=(ppro^.pw_idcmp and idcmp_reqset)<>0;
      pdwn^.idcmplist[11]:=(ppro^.pw_idcmp and idcmp_reqclear)<>0;
      pdwn^.idcmplist[12]:=(ppro^.pw_idcmp and idcmp_reqverify)<>0;
      pdwn^.idcmplist[13]:=(ppro^.pw_idcmp and idcmp_newsize)<>0;
      pdwn^.idcmplist[14]:=(ppro^.pw_idcmp and idcmp_refreshwindow)<>0;
      pdwn^.idcmplist[15]:=(ppro^.pw_idcmp and idcmp_sizeverify)<>0;
      pdwn^.idcmplist[16]:=(ppro^.pw_idcmp and idcmp_activewindow)<>0;
      pdwn^.idcmplist[17]:=(ppro^.pw_idcmp and idcmp_inactivewindow)<>0;
      pdwn^.idcmplist[18]:=(ppro^.pw_idcmp and idcmp_vanillakey)<>0;
      pdwn^.idcmplist[19]:=(ppro^.pw_idcmp and idcmp_rawkey)<>0;
      pdwn^.idcmplist[20]:=(ppro^.pw_idcmp and idcmp_newprefs)<>0;
      pdwn^.idcmplist[21]:=(ppro^.pw_idcmp and idcmp_diskinserted)<>0;
      pdwn^.idcmplist[22]:=(ppro^.pw_idcmp and idcmp_diskremoved)<>0;
      pdwn^.idcmplist[23]:=(ppro^.pw_idcmp and idcmp_intuiticks)<>0;
      pdwn^.idcmplist[24]:=(ppro^.pw_idcmp and idcmp_idcmpupdate)<>0;
      pdwn^.idcmplist[25]:=(ppro^.pw_idcmp and idcmp_changewindow)<>0;
      
      
      if (ppro^.pw_tagflags and wdf_mousequeue)<>0 then
        pdwn^.mousequeue:=ppro^.pw_mousequeue;
      if (ppro^.pw_tagflags and wdf_rptqueue)<>0 then
        pdwn^.rptqueue:=ppro^.pw_rptqueue;
      pdwn^.usezoom:=(ppro^.pw_tagflags and wdf_zoom)<>0;
      pdwn^.autoadjust:=(ppro^.pw_tagflags and wdf_autoadjust)<>0;
      pdwn^.pubscreenfallback:=(ppro^.pw_tagflags and wdf_fallback)<>0;
      if (ppro^.pw_tagflags and wdf_innerwidth)<>0 then
        pdwn^.innerw:=ppro^.pw_innerwidth;
      if (ppro^.pw_tagflags and wdf_innerheight)<>0 then
        pdwn^.innerh:=ppro^.pw_innerheight;
      
      
      
      peng:=ppro^.pw_gadgets.gl_first;
      while(peng^.en_next<>nil) do
        begin
          pgn:=pgadgetnode(allocmymem(sizeof(tgadgetnode),memf_clear or memf_any));
          if pgn<>nil then
            begin
              addtail(@pdwn^.gadgetlist,pnode(pgn));
              case peng^.en_kind of
                button_kind : pdwn^.mxchoice:=0;
                string_kind : pdwn^.mxchoice:=1;
                integer_kind : pdwn^.mxchoice:=2;
                checkbox_kind : pdwn^.mxchoice:=3;
                mx_kind : pdwn^.mxchoice:=4;
                cycle_kind : pdwn^.mxchoice:=5;
                slider_kind : pdwn^.mxchoice:=6;
                scroller_kind : pdwn^.mxchoice:=7;
                listview_kind : pdwn^.mxchoice:=8;
                palette_kind : pdwn^.mxchoice:=9;
                text_kind : pdwn^.mxchoice:=10;
                number_kind : pdwn^.mxchoice:=11;
                generic_kind : pdwn^.mxchoice:=30;
               end;
              pgn^.kind:=peng^.en_kind;
              if pgn^.kind=generic_kind then
                pgn^.kind:=mybool_kind;
              newgadnode(pdwn,pgn);
              ctopas(peng^.en_gadgetlabel,temp);
              if length(temp)>66 then temp[0]:=char(65);
              pgn^.labelid:=temp+#0;
               ctopas(peng^.en_gadgettext,temp);
              if length(temp)>66 then temp[0]:=char(65);
              pgn^.title:=temp+#0;
              
              if pgn^.kind<>mybool_kind then
                begin
                  if (peng^.en_newgadget.ng_flags and 2)=placetext_right then
                    pgn^.flags:=placetext_right;
                  if (peng^.en_newgadget.ng_flags and 4)=placetext_above then
                    pgn^.flags:=placetext_above;
                  if (peng^.en_newgadget.ng_flags and 8)=placetext_below then
                    pgn^.flags:=placetext_below;
                  if (peng^.en_newgadget.ng_flags and 1)=placetext_left then
                    pgn^.flags:=placetext_left;
                  if (peng^.en_newgadget.ng_flags and 16)=placetext_in then
                    pgn^.flags:=placetext_in;
                end
               else
                pgn^.flags:=0;
              
              pgn^.x:=peng^.en_newgadget.ng_leftedge-ppro^.pw_leftborder;
              pgn^.y:=peng^.en_newgadget.ng_topedge-ppro^.pw_topborder;
              pgn^.w:=peng^.en_newgadget.ng_width;
              pgn^.h:=peng^.en_newgadget.ng_height;
              
              
              {en_tags}
              
              tstate:=peng^.en_Tags;
              ptag:=nexttagitem(@tstate);
              while(ptag<>nil) do
                begin
                  case ptag^.ti_tag of
                    gt_underscore :
                      begin
                        if ptag^.ti_data<>0 then
                          ptag^.ti_data:=long(true);
                        case pgn^.kind of
                          button_kind : pgn^.tags[3].ti_data:=ptag^.ti_data;
                          string_kind,integer_kind : 
                            pgn^.tags[8].ti_data:=ptag^.ti_data;
                          cycle_kind : pgn^.tags[5].ti_data:=ptag^.ti_data;
                          listview_kind : pgn^.tags[9].ti_data:=ptag^.ti_data;
                          checkbox_kind : pgn^.tags[4].ti_data:=ptag^.ti_data;
                          slider_kind   : pgn^.tags[14].ti_data:=ptag^.ti_data;
                          scroller_kind : pgn^.tags[12].ti_data:=ptag^.ti_data;
                          palette_kind  : pgn^.tags[8].ti_data:=ptag^.ti_data;
                          mx_kind       : pgn^.tags[5].ti_data:=ptag^.ti_data;
                         end;
                      end;
                    ga_disabled :
                      begin
                        case pgn^.kind of
                          slider_kind : pgn^.tags[11].ti_data:=ptag^.ti_data;
                          button_kind : pgn^.tags[2].ti_data:=ptag^.ti_data;
                          string_kind,integer_kind : 
                            pgn^.tags[4].ti_data:=ptag^.ti_data;
                          cycle_kind : pgn^.tags[6].ti_data:=ptag^.ti_data;
                          checkbox_kind : pgn^.tags[3].ti_data:=ptag^.ti_data;
                          scroller_kind : pgn^.tags[9].ti_data:=ptag^.ti_data;
                          palette_kind  : pgn^.tags[7].ti_data:=ptag^.ti_data;
                          mybool_kind   : pgn^.flags:=gflg_disabled or pgn^.flags;
                         end;
                      end;
                    gtst_maxchars :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    stringa_justification :
                      begin
                        case pgn^.kind of
                          string_kind,integer_kind : 
                              pgn^.tags[2].ti_data:=ptag^.ti_data;
                         end;
                      end;
                    stringa_replacemode :
                          pgn^.tags[3].ti_data:=ptag^.ti_data;
                    stringa_exithelp :
                          pgn^.tags[5].ti_data:=ptag^.ti_data;
                    ga_tabcycle :
                          pgn^.tags[6].ti_data:=ptag^.ti_data;
                    ga_immediate :
                       begin
                        case pgn^.kind of
                          slider_kind :
                            pgn^.tags[12].ti_data:=ptag^.ti_data;
                          scroller_kind :
                            pgn^.tags[10].ti_data:=ptag^.ti_data;
                          string_kind,integer_kind : 
                            pgn^.tags[9].ti_data:=ptag^.ti_data;
                         end;
                      end;
                    ga_relverify :
                       begin
                        case pgn^.kind of
                          slider_kind :
                            pgn^.tags[13].ti_data:=ptag^.ti_data;
                          scroller_kind :
                            pgn^.tags[11].ti_data:=ptag^.ti_data;
                         end;
                      end;
                    gtcy_active :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtlv_labels :
                      if ptag^.ti_data<>0 then
                      begin
                        pl:=plist(ptag^.ti_data);
                        if sizeoflist(pl)>0 then
                          begin
                            freelist(@pgn^.infolist,sizeof(tstringnode));
                            pn:=pl^.lh_head;
                            while(pn^.ln_succ<>nil) do
                              begin
                                psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_clear or memf_any));
                                if psn<>nil then
                                  begin
                                    ctopas(pn^.ln_name^,temp);
                                    psn^.ln_name:=@psn^.st[1];
                                    psn^.st:=temp+#0;
                                    addtail(@pgn^.infolist,pnode(psn));
                                  end
                                 else
                                  begin
                                    oksofar:=false;
                                    telluser(mainwindow,memerror);
                                  end;
                                pn:=pn^.ln_succ;
                              end;
                          end
                         else
                          begin
                            pgn^.tags[10].ti_data:=0;
                          end;
                      end;
                    gtmx_labels,gtcy_labels :
                      begin
                        loop:=1;
                        ppa:=ppointerarray(ptag^.ti_data);
                        if ppa<>nil then
                          freelist(@pgn^.infolist,sizeof(tstringnode));
                        if ppa<>nil then
                          repeat
                            psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_clear or memf_any));
                            if psn<>nil then
                              begin
                                ctopas(ppa^[loop]^,temp);
                                psn^.ln_name:=@psn^.st[1];
                                psn^.st:=temp+#0;
                                addtail(@pgn^.infolist,pnode(psn));
                              end
                             else
                              begin
                                oksofar:=false;
                                telluser(mainwindow,memerror);
                              end;
                            inc(loop);
                          until (ppa^[loop]=nil);
                      end;
                    
                    gtlv_top :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gtlv_scrollwidth :
                      pgn^.tags[4].ti_data:=ptag^.ti_data;
                    gtlv_selected :
                      pgn^.tags[5].ti_data:=ptag^.ti_data;
                    layouta_spacing :
                      pgn^.tags[6].ti_data:=ptag^.ti_data;
                    gtlv_readonly :
                      pgn^.tags[8].ti_data:=ptag^.ti_data;
                    gtlv_showselected :
                      begin
                        pgn^.tags[3].ti_tag:=gtlv_showselected;
                        if (gdf_needlock and peng^.en_flags)<>0  then
                          begin
                            pgn^.tags[3].ti_data:=long(pgn^.ln_pred);
                            pgn^.ln_pred^.joined:=true;
                            pgn^.ln_pred^.pointers[1]:=pointer(pgn);
                          end;
                      end;
                    gtcb_checked :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtsl_min :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtsl_max :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gtsl_level :
                      pgn^.tags[3].ti_data:=ptag^.ti_data;
                    gtsl_levelformat :
                      begin
                        pgn^.tags[4].ti_data:=long(true);
                        ppa:=ppointerarray(ptag^.ti_data);
                        ctopas(ppa^,temp);
                        pgn^.datas:=temp+#0;
                      end;
                    gtsl_maxlevellen :
                      pgn^.tags[5].ti_data:=ptag^.ti_data;
                    gtsl_levelplace :
                      pgn^.tags[6].ti_data:=ptag^.ti_data;
                    pga_freedom :
                       begin
                        case pgn^.kind of
                          slider_kind :
                            pgn^.tags[9].ti_data:=ptag^.ti_data;
                          scroller_kind :
                            pgn^.tags[7].ti_data:=ptag^.ti_data;
                         end;
                      end;
                    gtsc_top :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtsc_visible :
                      pgn^.tags[3].ti_data:=ptag^.ti_data;
                    gtsc_total :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gtsc_arrows :
                      settagitem(@pgn^.tags[2],gtsc_arrows,ptag^.ti_data);
                    gtpa_depth :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtpa_color :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gtpa_coloroffset :
                      pgn^.tags[3].ti_data:=ptag^.ti_data;
                    gtpa_indicatorwidth :
                      pgn^.tags[4].ti_data:=ptag^.ti_data;
                    gtpa_indicatorheight :
                      pgn^.tags[5].ti_data:=ptag^.ti_data;
                    gttx_border :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gtnm_border :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    gttx_copytext :
                      pgn^.tags[3].ti_data:=ptag^.ti_data;
                    gttx_text :
                      begin
                        ppa:=ppointerarray(ptag^.ti_data);
                        ctopas(ppa^,temp);
                        pgn^.datas:=temp+#0;
                      end;
                    gtmx_active :
                      pgn^.tags[1].ti_data:=ptag^.ti_data;
                    gtmx_spacing :
                      pgn^.tags[2].ti_data:=ptag^.ti_data;
                    
                    
                   end;
                  ptag:=nexttagitem(@tstate);
                end;
              
              if pgn^.kind=mybool_kind then
                begin
                  pgn^.w:=20;
                  pgn^.h:=14;
                  pgn^.pointers[1]:=pointer(addgetfileimage(0));
                  pgn^.pointers[2]:=pointer(addgetfileimage(1));
                  pgn^.tags[1].ti_data:=long(false);
                  pgn^.flags:=pgn^.flags or gflg_gadghimage;
                end;

            end
           else
            begin
              oksofar:=true;
              telluser(mainwindow,memerror);
            end;
          peng:=peng^.en_next;
        end;
      
      fixgadgetnumbers(pdwn);
      
      pbb :=ppro^.pw_boxes.bl_first;
      if pbb<>nil then
      while(pbb^.bb_next<>nil) do
        begin
          if oksofar then
            begin
              pbbn:=pbevelboxnode(allocmymem(sizeof(tbevelboxnode),memf_clear or memf_any));
              if pbbn<>nil then
                begin
                  pbbn^.x:=pbb^.bb_left-ppro^.pw_leftborder;
                  pbbn^.y:=pbb^.bb_top-ppro^.pw_topborder;
                  pbbn^.w:=pbb^.bb_width;
                  pbbn^.h:=pbb^.bb_height;
                  str(sizeoflist(@pdwn^.bevelboxlist),temp);
                  temp:='Bevel Box '+temp+#0;
                  pbbn^.title:=temp;
                  pbbn^.ln_name:=@pbbn^.title[1];
                  
                  pbbn^.beveltype:=0;
                  if pbb^.bb_flags=1 then
                     pbbn^.beveltype:=1;
                  if pbb^.bb_flags=2 then
                     pbbn^.beveltype:=2;
                  
                  addtail(@pdwn^.bevelboxlist,pnode(pbbn));
                end
               else
                begin
                  oksofar:=false;
                  telluser(mainwindow,memerror);
                end;
            end;
          pbb:=pbb^.bb_next;
        end;
      
      
      
      pit:=ppro^.pw_windowtext;
      while(pit<>nil) do
        begin
          ptn:=ptextnode(allocmymem(sizeof(ttextnode),memf_any or memf_clear));
          if ptn<>nil then
            begin
              ptn^.placed:=true;
              ctopas(pit^.itext^,temp);
              if length(temp)>65 then
                temp:=copy(temp,1,65);
              ptn^.ln_name:=@ptn^.title[1];
              ptn^.title:=temp+#0;
              ptn^.frontpen:=pit^.frontpen;
              ptn^.backpen:=pit^.backpen;
              ptn^.drawmode:=pit^.drawmode;
              ptn^.itext:=@ptn^.title[1];
              ptn^.nexttext:=nil;
              pfr:=pfontrequester(fontrequest);
              ptn^.ta.ta_ysize:=pfr^.fo_attr.ta_ysize;
              ptn^.ta.ta_style:=pfr^.fo_attr.ta_style;
              ptn^.ta.ta_flags:=pfr^.fo_attr.ta_flags;
              ctopas(pfr^.fo_attr.ta_name^,temp);
              if length(temp)>43 then 
                temp:=copy(temp,1,43);
              ptn^.fonttitle:=temp+#0;

              ptn^.x:=pit^.leftedge-ppro^.pw_leftborder;
              ptn^.y:=pit^.topedge-ppro^.pw_topborder;
              ptn^.pta:=@ptn^.ta;
              ptn^.screenfont:=true;
              ptn^.ta.ta_name:=@ptn^.fonttitle[1];
              addtail(@pdwn^.textlist,pnode(ptn));
            end
           else
            begin
              telluser(mainwindow,memerror);
              oksofar:=false;
            end;
          pit:=pit^.nexttext;
        end;
    
    loop:=0;  
    
      { menus : }
    if sizeoflist(@ppro^.pw_menus)>0 then
    begin  {menu bit}
      pmen:=pdesignermenunode(allocmymem(sizeof(tdesignermenunode),memf_clear or memf_any));
      if pmen<>nil then
        begin
          pmen^.ln_name:=@pmen^.idlabel[1];
          newlist(@pmen^.tmenulist);
          pmen^.ln_type:=menunodetype;
          pmen^.defaultfont:=true;
          pmen^.frontpen:=0;
          copymem(@ttopaz80,@pmen^.font,sizeof(ttextattr));
          pmen^.font.ta_name:=@pmen^.fontname[1];
          pmen^.fontname:=fontname;
          pmen^.idlabel:=no0(pdwn^.labelid)+'_Menu'#0;
          pmen^.nexttitle:=sizeoflist(plist(@ppro^.pw_menus));
          penmt:=ppro^.pw_menus.ml_first;
          while(penmt^.em_next<>nil) do
            begin
              pmtn:=pmenutitlenode(allocmymem(sizeof(tmenutitlenode),memf_clear or memf_any));
              if pmtn<>nil then
                begin
                  pmtn^.ln_name:=@pmtn^.text[1];
                  ctopas(penmt^.em_menutitle,temp);
                  if temp[0]>char(65) then temp[0]:=char(65);
                  pmtn^.text:=temp+#0;
                  ctopas(penmt^.em_menulabel,temp);
                  if temp[0]>char(65) then temp[0]:=char(65);
                  pmtn^.idlabel:=temp+#0;
                  if temp='' then
                    str(loop,temp);
                  inc(loop);
                  pmtn^.idlabel:=no0(pmen^.idlabel)+'Menu_Title_'+temp+#0;
                  pmtn^.disabled:=0<>(nm_menudisabled and penmt^.em_newmenu.nm_flags);
                  
                  newlist(@pmtn^.titemlist);
                  pmtn^.nextitem:=sizeoflist(plist(@penmt^.em_items));
                  addtail(@pmen^.tmenulist,pnode(pmtn));
                  
                  penmi:=penmt^.em_items^.ml_first;
                  while(penmi^.em_next<>nil) do
                    begin
                      pmin:=pmenuitemnode(allocmymem(sizeof(tmenuitemnode),memf_clear or memf_any));
                      if pmin<>nil then
                        begin
                          pmin^.ln_name:=@pmin^.text[1];
                          ctopas(penmi^.em_menutitle,temp);
                          if temp[0]>char(65) then temp[0]:=char(65);
                          pmin^.text:=temp+#0;
                          ctopas(penmi^.em_menulabel,temp);
                          if temp[0]>char(65) then temp[0]:=char(65);
                          pmin^.idlabel:=temp+#0;
                          pmin^.disabled:=0<>(nm_itemdisabled and penmi^.em_newmenu.nm_flags);
                          pmin^.barlabel:=(penmi^.em_newmenu.nm_label = pointer(-1));
                          pmin^.commkey:=#0;
                          if penmi^.em_newmenu.nm_commkey<>nil then
                            pmin^.commkey:=char(penmi^.em_newmenu.nm_commkey^)+#0;
                          pmin^.exclude:=penmi^.em_newmenu.nm_mutualexclude;
                          pmin^.textprint:=true;
                          pmin^.checkit:=0<>(checkit and penmi^.em_newmenu.nm_flags);
                          pmin^.menutoggle:=0<>(menutoggle and penmi^.em_newmenu.nm_flags);
                          pmin^.checked:=0<>(checked and penmi^.em_newmenu.nm_flags);
                                  
                          newlist(@pmin^.tsubitems);
                          pmin^.nextsub:=sizeoflist(plist(@penmi^.em_items));
                          addtail(@pmtn^.titemlist,pnode(pmin));
                          
                          penms:=penmi^.em_items^.ml_first;
                          while(penms^.em_next<>nil) do
                            begin
                              
                              pmsi:=pmenusubitemnode(allocmymem(sizeof(tmenusubitemnode),memf_clear or memf_any));
                              if pmin<>nil then
                                begin
                                  pmsi^.ln_name:=@pmsi^.text[1];
                                  ctopas(penms^.em_menutitle,temp);
                                  if temp[0]>char(65) then temp[0]:=char(65);
                                  pmsi^.text:=temp+#0;
                                  ctopas(penms^.em_menulabel,temp);
                                  if temp[0]>char(65) then temp[0]:=char(65);
                                  pmsi^.textprint:=true;
                                  pmsi^.idlabel:=temp+#0;
                                  pmsi^.disabled:=0<>(nm_itemdisabled and penms^.em_newmenu.nm_flags);
                                  pmsi^.barlabel:=(penms^.em_newmenu.nm_label = pointer(-1));
                                  pmsi^.commkey:=#0;
                                  if penms^.em_newmenu.nm_commkey<>nil then
                                    pmsi^.commkey:=char(penms^.em_newmenu.nm_commkey^)+#0;
                                  pmsi^.exclude:=penms^.em_newmenu.nm_mutualexclude;
                                  pmsi^.checkit:=0<>(checkit and penms^.em_newmenu.nm_flags);
                                  pmsi^.menutoggle:=0<>(menutoggle and penms^.em_newmenu.nm_flags);
                                  pmsi^.checked:=0<>(checked and penms^.em_newmenu.nm_flags);
                                  
                                  addtail(@pmin^.tsubitems,pnode(pmsi));
                                  
                                end
                               else
                                begin
                                  telluser(mainwindow,memerror);
                                  oksofar:=false;
                                end;
                              
                              penms:=penms^.em_next;
                            end;
                        
                        end
                       else
                        begin
                          telluser(mainwindow,memerror);
                          oksofar:=false;
                        end;

                      penmi:=penmi^.em_next;
                    end;
                
                end
               else
                begin
                  telluser(mainwindow,memerror);
                  oksofar:=false;
                end;
              penmt:=penmt^.em_next;
            end;
          
          addtail(@tempmenulist,pnode(pmen));
        end
       else
        begin
          telluser(mainwindow,memerror);
          oksofar:=false;
        end;
    end; {menu bit}
    
    
    end
   else
    begin
      telluser(mainwindow,memerror);
      oksofar:=false;
    end;
  convertproject:=oksofar;
end;

procedure importGTB(filename:pbyte);
var
  Chain        : pointer;
  guiinfo      : tguidata;
  mainconfig   : tgadtoolsconfig;
  windows      : tlist;
  validbits    : long;
  tags         : array[1..15] of ttagitem;
  error        : long;
  errors       : string;
  pitwin       : pnode;
  oksofar      : boolean;
  ppro         : pprojectwindow;
begin
  oksofar:=true;
  newlist(@tempwindowlist);
  newlist(@tempmenulist);
  
  if gtxbase=nil then
    gtxbase:=openlibrary( GTXNAME, GTXVERSION );
  if (gfxbase<>nil) and (nofragbase=nil) then
    nofragbase:=openlibrary('nofrag.library',2);
  
  if (gtxbase<>nil)and(nofragbase<>nil) then
    begin
      
      Chain:=pointer(GetMemoryChain(long(4096)));
      inc(memused,1);
      if chain<>nil then
        begin
          settagitem(@tags[1],rg_gui,long(@guiinfo));
          settagitem(@tags[2],rg_config,long(@mainconfig));
          settagitem(@tags[3],rg_cconfig,0);
          settagitem(@tags[4],rg_windowlist,long(@windows));
          settagitem(@tags[5],rg_valid,long(@validbits));
          settagitem(@tags[6],tag_done,0);
          
          error:=gtx_loadguia( chain , filename, @tags[1] );
          if error=0 then
            begin
              
              { file loaded ok }
              
              if (validbits and vlf_gui)<>0 then
                begin
                  {
                  writeln('ggui');
                  }
                end;
              if (validbits and vlf_config)<>0 then
                begin
                  {
                  writeln('config');
                  }
                end;
              if (validbits and vlf_windowlist)<>0 then
                begin
                  ppro:=pprojectwindow(windows.lh_head);
                  while(ppro^.pw_next<>nil) do
                    begin
                      if oksofar then
                        oksofar:=convertproject(ppro);
                      ppro:=ppro^.pw_next;
                    end;
                  
                end;
              
              mainselected:=~0;
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,0);
              
              if oksofar then
                begin
                  
                  closemaincodewindow;
                  
                  pitwin:=remhead(@teditwindowlist);
                  while(pitwin<>nil) do
                    begin
                      deletedesignerwindow(pdesignerwindownode(pitwin));
                      pitwin:=remhead(@teditwindowlist);
                    end;
                  
                  pitwin:=remhead(@teditmenulist);
                  while(pitwin<>nil) do
                    begin
                      deletedesignermenunode(pdesignermenunode(pitwin));
                      pitwin:=remhead(@teditmenulist);
                    end;
                  
                  pitwin:=remhead(@tempwindowlist);
                  while(pitwin<>nil) do
                    begin
                      addtail(@teditwindowlist,pitwin);
                      pitwin:=remhead(@tempwindowlist);
                    end;
                  
                  pitwin:=remhead(@tempmenulist);
                  while(pitwin<>nil) do
                    begin
                      addtail(@teditmenulist,pitwin);
                      pitwin:=remhead(@tempmenulist);
                    end;

                end
               else
                begin
                  
                  pitwin:=remhead(@tempwindowlist);
                  while(pitwin<>nil) do
                    begin
                      deletedesignerwindow(pdesignerwindownode(pitwin));
                      pitwin:=remhead(@tempwindowlist);
                    end;
                  
                  pitwin:=remhead(@tempmenulist);
                  while(pitwin<>nil) do
                    begin
                      deletedesignermenunode(pdesignermenunode(pitwin));
                      pitwin:=remhead(@tempmenulist);
                    end;
                  
                end;
              case cyclepos of
                0:
                  begin
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditwindowlist));
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                  end;
                1:
                  begin
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditmenulist));
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                  end;
                2:
                  begin
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                  end;
               end;
            end
           else
            begin
              errors:='Could not load file for some reason.';
              {
              case error of
                ERROR_NOMEM   : errors:=memoryerror;
                ERROR_OPEN    : errors:='';
                ERROR_READ    :
                ERROR_WRITE   :
                ERROR_PARSE   :
                ERROR_PACKER  :
                ERROR_PPLIB   :
               end;
              }
              telluser(mainwindow,errors);
            end;
            
          { ????  freeduplicates  ???? }
          
          if Freememorychain(chain,long(true))<>0 then;
          dec(memused,1);
        end
       else
        telluser(mainwindow,memerror);
    end
   else
    begin
      if gtxbase=nil then
        telluser(mainwindow,'Could not open GadToolsBox.library V39.')
       else
        telluser(mainwindow,'Could not open nofrag library.');
    end;
end;

procedure importagtbfile;
const
  pat2 : string[11] = '~(#?.info)'#0;
  hail : string[30] = 'Select GUI file.'#0;
var
  pargs     : pwbargarray;
  numofargs : word;
  count     : word;
  pin       : pimagenode;
  pcs       : pcstring;
  loop      : word;
  title     : string[66];
  dir       : string;
  dir2      : string;
  ifr       : pFileRequester;
  tags      : array[1..5] of ttagitem;
  pdmn      : pdesignermenunode;
begin
  waiteverything;
  settagitem(@tags[1],asl_hail,long(@hail[1]));
  settagitem(@tags[2],asl_pattern,long(@pat2[1]));
  settagitem(@tags[3],asl_dir,long(imagefilerequest^.fr_drawer));
  settagitem(@tags[4],tag_done,0);
  ifr:=pointer(allocaslrequest(asl_filerequest,@tags[1]));
  if ifr<>nil then
    begin
      if aslrequest(ifr,nil) then
        begin
          dir:='';
          loop:=1;
          ctopas(ifr^.fr_drawer^,dir);
          dir:=dir+#0;
          title:='';
          ctopas(ifr^.fr_file^,title);
          title:=title+#0;
          dir2:=dir;
          if addpart(@dir2[1],@title[1],253) then
            begin
              pin:=pointer(remhead(@teditimagelist));
              while(pin<>nil) do
                begin
                  deleteimagenode(pimagenode(pin));
                  pin:=pointer(remhead(@teditimagelist));
                end;
              importgtb(@dir2[1]);
            end;
        end;
      freeaslrequest(pointer(ifr));
    end
   else
    telluser(mainwindow,'Could not get file requester.');
  inputmode:=1;
  unwaiteverything;
end;

begin
end.