{
function readalldata(filename : string):boolean;
var
  iff      : piffhandle;
  error    : long;
  oksofar  : boolean;
  pdwn     : pdesignerwindownode;
  pin      : pimagenode;
  pcn      : pcontextnode;
  done     : boolean;
  winlist  : tlist;
  pgn      : pgadgetnode;
  tgs      : tgadgetstore;
  tbbs     : tbevelboxstore;
  pbbn     : pbevelboxnode;
  tsins    : tsmallimagestore;
  psin     : psmallimagenode;
  ptn      : ptextnode;
  ttns     : ttextstore;
  twininfo : twindowinfostore;
  pdwn2    : pdesignerwindownode;
  imagelist: tlist;
  tish     : timagestorehead;
  pin2     : pimagenode;
begin
  newlist(@winlist);
  newlist(@imagelist);
  oksofar:=true;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=long(open(@filename[1],mode_oldfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_read);
          if error=0 then
            begin
              repeat
                error:=parseiff(iff,iffparse_rawstep);
                if error=0 then
                  begin
                    pcn:=currentchunk(iff);
                    if oksofar and (pcn^.cn_type=id_wind) and (pcn^.cn_id=id_form) then
                      begin
                        pdwn:=allocmymem(sizeof(tdesignerwindownode),memf_any or memf_clear);
                        if pdwn<>nil then
                          begin
                            addtail(@winlist,pnode(pdwn));
                            setdefaultwindow(pdwn);
                            done:=false;
                            repeat
                              error:=parseiff(iff,iffparse_rawstep);
                              if (error=0) or (error=ifferr_eoc) then 
                                begin
                                  pcn:=currentchunk(iff);
                                  if (pcn^.cn_type=id_wind) and 
                                     (pcn^.cn_id=id_form) and
                                     (error=ifferr_eoc) then
                                       done:=true;
                                end
                               else
                                done:=true;
                              if (error=0) then
                                begin
                                  case pcn^.cn_id of
                                    id_gadg : begin
                                                pgn:=allocmymem(sizeof(tgadgetnode),memf_any or memf_clear);
                                                if pgn<>nil then
                                                  begin
                                                    error:=readchunkbytes(iff,@tgs,sizeof(tgs));
                                                    addtail(@pdwn^.gadgetlist,pnode(pgn));
                                                    if error>0 then
                                                      begin
                                                        with tgs do
                                                          begin
                                                            pgn^.ln_name:=@pgn^.labelid[1];
                                                            pgn^.flags:=flags;
                                                            pgn^.x:=leftedge;
                                                            pgn^.y:=topedge;
                                                            pgn^.w:=width;
                                                            pgn^.h:=height;
                                                            pgn^.kind:=kind;
                                                            pgn^.title:=title;
                                                            pgn^.id:=id;
                                                            pgn^.labelid:=labelid;
                                                            pgn^.fontname:=fontname;
                                                            pgn^.font.ta_ysize:=fontysize;
                                                            pgn^.font.ta_style:=fontstyle;
                                                            pgn^.font.ta_flags:=fontflags;
                                                            pgn^.high:=false;
                                                            pgn^.font.ta_name:=@pgn^.fontname;
                                                            pgn^.editwindow:=nil;
                                                            copymem(@tags[1],@pgn^.tags[1],sizeof(tags));
                                                            case pgn^.kind of
                                                              cycle_kind : begin
                                                                             pgn^.pointers[1]:=@strings[73,1];
                                                                             pgn^.pointers[2]:=@strings[74,1];
                                                                             pgn^.pointers[3]:=@strings[75,1];
                                                                             pgn^.pointers[4]:=nil;
                                                                             settagitem(@pgn^.tags[1],gtcy_labels,
                                                                                 long(@pgn^.pointers[1]));
                                                                           end;
                                                              listview_kind : begin
                                                                                settagitem(@pgn^.tags[1],
                                                                                    gtlv_labels,long(@listvieweditlist));
                                                                              end;
                                                             end;
                                                          end;
                                                      end
                                                     else
                                                      oksofar:=false;
                                                  end
                                                 else
                                                  oksofar:=false;
                                              end;
                                    id_bevl : begin
                                                pbbn:=allocmymem(sizeof(tbevelboxnode),memf_clear or memf_any);
                                                if pbbn<>nil then
                                                  begin
                                                    addtail(@pdwn^.bevelboxlist,pnode(pbbn));
                                                    error:=readchunkbytes(iff,@tbbs,sizeof(tbbs));
                                                    if error>0 then
                                                      begin
                                                        with tbbs do
                                                          begin
                                                            pbbn^.x:=leftedge;
                                                            pbbn^.y:=topedge;
                                                            pbbn^.w:=width;
                                                            pbbn^.h:=height;
                                                            pbbn^.recessed:=recessed;
                                                            pbbn^.double:=double;
                                                            pbbn^.title:=title;
                                                            pbbn^.ln_name:=@pbbn^.title[1];
                                                          end;
                                                      end
                                                     else
                                                      oksofar:=false;
                                                  end
                                                 else
                                                  oksofar:=false;
                                              end;
                                    id_imag : begin
                                                psin:=allocmymem(sizeof(tsmallimagenode),memf_any or memf_clear);
                                                if psin<>nil then
                                                  begin
                                                    addtail(@pdwn^.imagelist,pnode(psin));
                                                    error:=readchunkbytes(iff,@tsins,sizeof(tsins));
                                                    if error>0 then
                                                      begin
                                                        with tsins do
                                                          begin
                                                            psin^.x:=leftedge;
                                                            psin^.y:=topedge;
                                                            psin^.placed:=placed;
                                                            psin^.title:=title;
                                                            psin^.imagename:=imagename;
                                                            psin^.ln_name:=@psin^.title[1];
                                                            psin^.pin:=nil;
                                                          end;
                                                      end
                                                     else
                                                      oksofar:=false;
                                                  end
                                                 else
                                                  oksofar:=false;
                                              end;
                                    id_text : begin
                                                
                                                ptn:=allocmymem(sizeof(ttextnode),memf_any or memf_clear);
                                                if ptn<>nil then
                                                  begin
                                                    addtail(@pdwn^.textlist,pnode(ptn));
                                                    error:=readchunkbytes(iff,@ttns,sizeof(ttns));
                                                    if error>0 then
                                                      begin
                                                        with ttns do
                                                          begin
                                                            ptn^.x:=leftedge;
                                                            ptn^.y:=topedge;
                                                            ptn^.placed:=placed;
                                                            ptn^.title:=title;
                                                            ptn^.frontpen:=frontpen;
                                                            ptn^.backpen:=backpen;
                                                            ptn^.drawmode:=drawmode;
                                                            ptn^.fonttitle:=fontname;
                                                            ptn^.ta.ta_ysize:=fontysize;
                                                            ptn^.ta.ta_style:=fontstyle;
                                                            ptn^.ta.ta_flags:=fontflags;
                                                            ptn^.ln_name:=@ptn^.title[1];
                                                            ptn^.pta:=@ptn^.ta;
                                                            ptn^.itext:=ptn^.ln_name;
                                                            ptn^.nexttext:=nil;
                                                            ptn^.ta.ta_name:=@ptn^.fonttitle[1];
                                                          end;
                                                      end
                                                     else
                                                      oksofar:=false;
                                                  end
                                                 else
                                                  oksofar:=false;
                                                
                                              end;
                                    id_info : begin
                                                error:=readchunkbytes(iff,@twininfo,sizeof(twininfo));
                                                if error>0 then
                                                  begin
                                                    with twininfo do
                                                      begin
                                                         copymem(@dripens[1],@pdwn^.dripens,20);;
                                                         pdwn^.offx:=offx;
                                                         pdwn^.offy:=offy;
                                                         pdwn^.offsetsdone:=offsetsdone;
                                                         pdwn^.nextid:=nextid;
                                                         pdwn^.useoffsets:=useoffsets;
                                                         pdwn^.title:=title;
                                                         pdwn^.x:=leftedge;
                                                         pdwn^.y:=topedge;
                                                         pdwn^.w:=width;
                                                         pdwn^.h:=height;
                                                         pdwn^.screentitle:=screentitle;
                                                         pdwn^.minw:=minw;
                                                         pdwn^.maxw:=maxw;
                                                         pdwn^.minh:=minh;
                                                         pdwn^.maxh:=maxh;
                                                         pdwn^.innerw:=innerw;
                                                         pdwn^.innerh:=innerh;
                                                         pdwn^.labelid:=labelid;
                                                         copymem(@zoom,@pdwn^.zoom[1],8);;
                                                         pdwn^.mousequeue:=mousequeue;
                                                         pdwn^.rptqueue:=rptqueue;
                                                         pdwn^.sizegad:=sizegad;
                                                         pdwn^.sizebright:=sizebright;
                                                         pdwn^.sizebbottom:=sizebbottom;
                                                         pdwn^.dragbar:=dragbar;
                                                         pdwn^.depthgad:=depthgad;
                                                         pdwn^.closegad:=closegad;
                                                         pdwn^.reportmouse:=reportmouse;
                                                         pdwn^.nocarerefresh:=nocarerefresh;
                                                         pdwn^.borderless:=borderless;
                                                         pdwn^.backdrop:=backdrop;
                                                         pdwn^.gimmezz:=gimmezz;
                                                         pdwn^.activate:=activate;
                                                         pdwn^.rmbtrap:=rmbtrap;
                                                         pdwn^.simplerefresh:=simplerefresh;
                                                         pdwn^.smartrefresh:=smartrefresh;
                                                         pdwn^.autoadjust:=autoadjust;
                                                         pdwn^.menuhelp:=menuhelp;
                                                         pdwn^.usezoom:=usezoom;
                                                         pdwn^.customscreen:=customscreen;
                                                         pdwn^.pubscreen:=pubscreen;
                                                         pdwn^.pubscreenname:=pubscreenname;
                                                         pdwn^.pubscreenfallback:=pubscreenfallback;
                                                         pdwn^.flags:=flags;
                                                         copymem(@screenprefs,@pdwn^.screenprefs,sizeof(screenprefs));
                                                         pdwn^.fontname:=fontname;
                                                         copymem(@idcmplist,@pdwn^.idcmplist,sizeof(idcmplist));
                                                      end;
                                                  end
                                                 else
                                                  oksofar:=false;
                                              end;
                                   end;
                                end;
                            until done; 
                          end
                         else
                          oksofar:=false;
                      end;
                    if oksofar and (pcn^.cn_type=id_pic1) and (pcn^.cn_id=id_form) then
                      begin
                        done:=false;
                        repeat
                          error:=parseiff(iff,iffparse_rawstep);
                          if (error=0) or (error=ifferr_eoc) then 
                            begin
                              pcn:=currentchunk(iff);
                              if (pcn^.cn_type=id_pic1) and 
                                 (pcn^.cn_id=id_form) and
                                 (error=ifferr_eoc) then
                                   done:=true;
                            end
                           else
                            done:=true;
                          if (error=0) then
                            begin
                              case pcn^.cn_id of
                                id_head : begin
                                            error:=readchunkbytes(iff,@tish,sizeof(tish));
                                              if error>0 then
                                                begin
                                                  pin:=allocmymem(sizeof(timagenode),memf_clear or memf_any);
                                                  if pin<>nil then
                                                    begin
                                                      with pin^ do
                                                        begin
                                                          ln_name:=@title[1];
                                                          title:=tish.title;
                                                          sizeallocated:=tish.sizedata;
                                                          leftedge:=tish.leftedge;
                                                          topedge:=tish.topedge;
                                                          width:=tish.width;
                                                          height:=tish.height;
                                                          depth:=tish.depth;
                                                          planepick:=tish.planepick;
                                                          planeonoff:=tish.planeonoff;
                                                          imagedata:=allocmymem(sizeallocated,memf_chip or memf_clear);
                                                          ln_type:=imagenodetype;
                                                          if imagedata=nil then
                                                            begin
                                                              freemymem(pin,sizeof(timagenode));
                                                              pin:=nil;
                                                              oksofar:=false;
                                                            end;
                                                        end;
                                                    end
                                                   else
                                                    oksofar:=false;
                                                end;
                                          end;
                                id_data : if pin<>nil then
                                            begin
                                              error:=readchunkbytes(iff,pin^.imagedata,pin^.sizeallocated);
                                              addtail(@imagelist,pnode(pin));
                                              if error<0 then
                                                oksofar:=false;
                                            end;
                               end;
                            end;
                        until done; 

                      end;
                  end;
              until (error<>0)and(error<>ifferr_eoc);
              closeiff(iff);
            end
           else
            oksofar:=false;
          if not close_(bptr(iff^.iff_stream)) then
            oksofar:=false;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  pin:=pimagenode(imagelist.lh_head);
  while (pin^.ln_succ<>nil) do
    begin
      pin2:=pin^.ln_succ;
      remove(pnode(pin));
      if oksofar then
        begin
          addtail(@teditimagelist,pnode(pin));
          if cyclepos=2 then
            begin
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,~0);
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,long(@teditimagelist));
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_selected,~0);
              mainselected:=~0;
            end;
          pdwn:=pdesignerwindownode(winlist.lh_head);
          while (pdwn^.ln_succ<>nil) do
            begin
              psin:=psmallimagenode(pdwn^.imagelist.lh_head);
              while (psin^.ln_succ<>nil) do
                begin
                  if psin^.imagename=pin^.title then
                    psin^.pin:=pin;
                  psin:=psin^.ln_succ;
                end;
              pdwn:=pdwn^.ln_succ;
            end;
        end
       else
        begin
          if pin^.imagedata<>nil then
            freemymem(pin^.imagedata,pin^.sizeallocated);
          freemymem(pin,sizeof(timagenode));
        end;
      pin:=pin2;
    end;
  pdwn:=pdesignerwindownode(winlist.lh_head);
  while(pdwn^.ln_succ<>nil) do
    begin
      pdwn2:=pdwn^.ln_succ;
      remove(pnode(pdwn));
      if oksofar then
        begin
          addtail(@teditwindowlist,pnode(pdwn));
          if cyclepos=0 then
            begin
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,~0);
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_labels,long(@teditwindowlist));
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                             gtlv_selected,~0);
              mainselected:=~0;
            end;
        end
       else
        begin
          freelist(@pdwn^.bevelboxlist,sizeof(tbevelboxnode));
          pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
          while(pgn<>nil)do
            begin
              freemymem(pgn,sizeof(tgadgetnode));
              pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
            end;
          freelist(@pdwn^.textlist,sizeof(ttextnode));
          freelist(@pdwn^.imagelist,sizeof(tsmallimagenode));
          freemymem(pdwn,sizeof(tdesignerwindownode));
        end;
      pdwn:=pdwn2;
    end;
end;
}
