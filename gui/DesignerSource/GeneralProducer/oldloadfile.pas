unit loadfile;

{ This unit should be left alone }

interface


uses asl,utility,exec,intuition,amiga,workbench,layers,icon,objectproduction,producerlib,
     gadtools,graphics,dos,amigados,definitions,iffparse,routines,liststuff;

const
  id_des1 = $44455332;
  id_wind = $57494e44;
  id_gadg = $47414447;
  id_bevl = $4245564c;
  id_imag = $494d4147;
  id_text = $54455854;
  id_info = $494e464f;
  id_pics = $50494353;
  id_pic1 = $50494331;
  id_head = $48454144;
  id_data = $44415441;
  id_strn = $5354524e;
  id_strl = $5354524c;
  id_menu = $4d454e55;
  id_ttle = $54544c45;
  id_item = $4954454d;
  id_SubI = $53554249;
  id_subs = $53554253;
  id_itms = $49544d53;
  id_ttls = $54544c53;
  id_loca = $4c4f4341;
  id_loci = $4c4f4349;
  id_scrn = $5343524e;
  id_scri = $53435249;
  id_scrc = $53435243;
  id_tagi = $54414749;
  id_tagd = $54414744;
  id_tags = $54414753;

  SaveFileVersion = 1;
  
type
  
  ttagstore = record
    tagtype  : word;
    title    : string[66];
    value    : long;
    datasize : long;
    data     : long;
    dataname : string[66];
   end;
  
  tscreenstore = record
    labelid   : string;
    left      : word;
    top       : word;
    width     : word;
    height    : word;
    depth     : word;
    overscan  : byte;
    fonttype  : byte;
    behind    : boolean;
    quiet     : boolean;
    showtitle : boolean;
    autoscroll : boolean;
    bitmap     : boolean;
    createbitmap : boolean;
    title  : string;
    loctitle  : boolean;
    idnum     : long;
    screentype : word;
    {
    pens      : array [0..20] of word;
    }
    pubname   : string;
    dopubsig  : boolean;
    defpens   : boolean;
    fullpalette : boolean;
    font        : ttextattr;
    fontname    : string[50];
    sizecolorarray : long;
    penarray : array [0..30] of word;
    
    errorcode     : boolean;
    sharedpens    : boolean;
    draggable     : boolean;
    exclusive     : boolean;
    interleaved   : boolean;
    likeworkbench : boolean;
    
   end;
  
  tlocalestore = record
    tgetstring       : string[70];
    tbuiltinlanguage : string[70];
    tversion         : long;
    tbasename        : string[70];
    numberofnodes    : long;
   end;
   
  tlocalenodestore = record
    labl    : string[70];
    comment : string[70];
    str     : string;
   end; 
  
  pwholecodestore = ^twholecodestore;
  twholecodestore=record
    procedureoptions : array [1..50] of boolean;
    codeoptions      : array [1..20] of boolean;
    openlibs         : array [1..30] of boolean;
    versionlibs      : array [1..30] of long;
    abortonfaillibs  : array [1..30] of boolean;
    compilername     : string[50];
    includeextra     : string;
    fileversion      : long;
   end;

  pmenustore = ^tmenustore;
  tmenustore = record
    text        : string[66];
    idlabel     : string[66];
    frontpen    : long;
    font        : ttextattr;
    fontname    : string[46];
    defaultfont : boolean;
    nexttitle   : word;
    pad         : boolean;
    localmenu   : boolean;
   end;
  
  ptitlestore = ^ttitlestore;
  ttitlestore = record
    idlabel  : string[66];
    text     : string[66];
    disabled : boolean;
    nextitem : word;
   end;
  
  pitemstore = ^titemstore;
  titemstore = record
    idlabel     : string[66];
    barlabel    : boolean;
    text        : string[66];
    graphicname : string[66];
    commkey     : string[3];
    disabled    : boolean;
    checkit     : boolean;
    menutoggle  : boolean;
    checked     : boolean;
    textprint   : boolean;
    exclude     : long;
    nextsub     : word;
   end;
  
  psubitemstore = ^titemstore;
  tsubitemstore = record
    idlabel     : string[66];
    barlabel    : boolean;
    text        : string[66];
    graphicname : string[66];
    commkey     : string[3];
    disabled    : boolean;
    checkit     : boolean;
    menutoggle  : boolean;
    checked     : boolean;
    textprint   : boolean;
    exclude     : long;
   end;

  pgadgetstore = ^tgadgetstore;
  tgadgetstore = record
    leftedge  : long;
    topedge   : long;
    width     : long;
    height    : long;
    kind      : long;
    title     : string[66];
    id        : long;
    flags     : long;
    labelid   : string[66];
    fontname  : string[46];
    fontysize : word;
    fontstyle : byte;
    fontflags : byte;
    tags      : array [1..15] of ttagitem;
    joined    : boolean;
    datas     : string[66];
    listfollows : long;
    specialdata : long;
    EditHook    : string;
   end;     

  psmallimagestore = ^tsmallimagestore;
  tsmallimagestore = record
    leftedge  : long;
    topedge   : long;
    placed    : boolean;
    title     : string[66];
    imagename : string[66];
   end;

  ptextstore = ^ttextstore;
  ttextstore = record
    leftedge  : long;
    topedge   : long;
    placed    : boolean;
    title     : string[66];
    frontpen  : byte;
    backpen   : byte;
    drawmode  : byte;
    fontname  : string[46];
    fontysize : word;
    fontstyle : byte;
    fontflags : byte;
    screenfont: boolean;
   end;

  pbevelboxstore = ^tbevelboxstore;
  tbevelboxstore = record
    leftedge : long;
    topedge  : long;
    width    : long;
    height   : long;
    beveltype: word;
    title    : string[31];
   end;

  pwindowinfostore = ^twindowinfostore;
  twindowinfostore = record
    codeoptions    : array[1..20] of boolean;
    dripens        : array[1..10] of word;
    offx           : long;
    offy           : long;
    offsetsdone    : boolean;
    nextid         : long;
    useoffsets     : boolean;
    title          : string[66];
    leftedge       : long;
    topedge        : long;
    width          : long;
    height         : long;
    screentitle    : string[66];
    minw           : long;
    maxw           : long;
    minh           : long;
    maxh           : long;
    innerw         : long;
    innerh         : long;
    labelid        : string[66];
    zoom           : array[1..4] of integer;
    mousequeue     : long;
    rptqueue       : long;
    sizegad        : boolean;
    sizebright     : boolean;
    sizebbottom    : boolean;
    dragbar        : boolean;
    depthgad       : boolean;
    closegad       : boolean;
    reportmouse    : boolean;
    nocarerefresh  : boolean;
    borderless     : boolean;
    backdrop       : boolean;
    gimmezz        : boolean;
    activate       : boolean;
    rmbtrap        : boolean;
    simplerefresh  : boolean;
    smartrefresh   : boolean;
    autoadjust     : boolean;
    menuhelp       : boolean;
    usezoom        : boolean;
    customscreen   : boolean;
    pubscreen      : boolean;
    pubscreenname  : boolean;
    pubscreenfallback : boolean;
    flags          : long;
    screenprefs    : tscreenmodeprefs;
    fontname       : string[46];
    idcmplist      : array [1..25] of boolean;
    menutitle      : string[66];
    gadgetfont     : ttextattr;
    gadgetfontname : string[46];
    fontx,fonty    : word;
    winparams      : string;
    extracodeoptions : array [1..20] of boolean;
    moretags       : array[1..5] of boolean;
    localeoptions  : array[1..5] of boolean;
    defpubname     : string[80];
   end;

  pimagestorehead = ^timagestorehead;
  timagestorehead = record
    title      : string[66];
    leftedge   : long;
    topedge    : long;
    width      : long;
    height     : long;
    depth      : integer;
    planepick  : byte;
    planeonoff : byte;
    sizedata   : long;
   end;

var
  readcodestore : twholecodestore;
 
function readalldata(filename : string):boolean;

implementation

function readscreen(iff:piffhandle;pcn:pcontextnode;screenlist:plist):boolean;
var
  done    : boolean;
  oksofar : boolean;
  error   : long;
  loop    : long;
  pba     : pbytearray;
  tss     : tscreenstore;
  pdsn    : pdesignerscreennode;
  count   : long;
  tempstore : array[1..256] of word;
begin
  pdsn:=nil;
  oksofar:=true;
  done:=false;
  repeat
    error:=parseiff(iff,iffparse_rawstep);
    if (error=0) or (error=ifferr_eoc) then 
      begin
        pcn:=currentchunk(iff);
        if (pcn^.cn_type=id_scrn) and 
           (pcn^.cn_id=id_form) and
           (error=ifferr_eoc) then
             done:=true;
      end
     else
      done:=true;
    if (error=0)and oksofar then
      case pcn^.cn_id of
        id_scri : begin
                    error:=readchunkbytes(iff,@tss,sizeof(tss));
                      if (error>0) and oksofar then
                        begin
                          pdsn:=allocmymem(sizeof(tdesignerscreennode),memf_clear or memf_any);
                          if pdsn<>nil then
                            begin
                              with pdsn^ do
                                begin
                                  
                                  labelid:=tss.labelid;
                                  left:=tss.left;
                                  top:=tss.top;
                                  width:=tss.width;
                                  height:=tss.height;
                                  depth:=tss.depth;
                                  overscan:=tss.overscan;
                                  fonttype:=tss.fonttype;
                                  behind:=tss.behind;
                                  quiet:=tss.quiet;
                                  showtitle:=tss.showtitle;
                                  autoscroll:=tss.autoscroll;
                                  bitmap:=tss.bitmap;
                                  createbitmap:=tss.createbitmap;
                                  title:=tss.title;
                                  loctitle:=tss.loctitle;
                                  idnum:=tss.idnum;
                                  screentype:=tss.screentype;
                                  {
                                  pens:=tss.pens;
                                  }
                                  pubname:=tss.pubname;
                                  dopubsig:=tss.dopubsig;
                                  defpens:=tss.defpens;
                                  fullpalette:=tss.fullpalette;
                                  font:=tss.font;
                                  fontname:=tss.fontname;
                                  
                                  
                                  errorcode:=tss.errorcode;
                                  sharedpens:=tss.sharedpens;
                                  draggable:=tss.draggable;
                                  exclusive:=tss.exclusive;
                                  interleaved:=tss.interleaved;
                                  likeworkbench:=tss.likeworkbench;
                                  
                                  
                                  copymem(@tss.penarray,@penarray,sizeof(penarray));
                                  
                                  font.ta_name:=@fontname[1];
                                  
                                  sizecolorarray:=tss.sizecolorarray;

                                  if sizecolorarray>0 then
                                    begin
                                      colorarray:=allocmymem(sizecolorarray,memf_chip or memf_clear);
                                      if colorarray=nil then
                                        begin
                                          freemymem(pdsn);
                                          pdsn:=nil;
                                          oksofar:=false;
                                        end;
                                    end;
                                  
                                end;
                            end
                           else
                            oksofar:=false;
                        end;
                  end;
        id_scrc : if (pdsn<>nil) then
                    begin
                      if pdsn^.colorarray<>nil then
                        begin
                          error:=readchunkbytes(iff,pdsn^.colorarray,pdsn^.sizecolorarray);
                          if error<0 then
                            begin
                              oksofar:=false;
                              freemymem(pdsn);
                              pdsn:=nil;
                            end;
                        end
                       else
                        begin
                          freemymem(pdsn);
                          pdsn:=nil;
                          oksofar:=false;
                        end;
                    end
                   else
                    oksofar:=false;
       end;
  until done; 
  {
  if pdsn^.colorarray=nil then
    if pdsn^.sizecolorarray>0 then
      writeln('error');
  }
  if pdsn<>nil then
    addtail(screenlist,pnode(pdsn));
  readscreen:=oksofar;
end;

function readtextnode(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  ptn     : ptextnode;
  ttns    : ttextstore;
  oksofar : boolean;
  error   : long;
begin
  ttns.screenfont:=false;
  oksofar:=true;
  ptn:=allocmymem(sizeof(ttextnode),memf_clear or memf_public);
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
              ptn^.ta.ta_name:=@ptn^.fonttitle[1];
              ptn^.screenfont:=screenfont;
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readtextnode:=oksofar;
end;

function readsmallimage(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  psin    : psmallimagenode;
  tsins   : tsmallimagestore;
  oksofar : boolean;
  error   : long;
begin
  oksofar:=true;
  psin:=allocmymem(sizeof(tsmallimagenode),memf_clear or memf_public);
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
              psin^.title:=title;
              psin^.imagename:=imagename;
              psin^.pin:=nil;
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readsmallimage:=oksofar;
end;

function readbevelbox(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  pbbn    : pbevelboxnode;
  tbbs    : tbevelboxstore;
  oksofar : boolean;
  error   : long;
begin
  oksofar:=true;
  pbbn:=allocmymem(sizeof(tbevelboxnode),memf_clear or memf_public);
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
              pbbn^.beveltype:=beveltype;
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readbevelbox:=oksofar;
end;

function readgadget(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  pgn     : pgadgetnode;
  tgs     : tgadgetstore;
  oksofar : boolean;
  error   : long;
  pcn     : pcontextnode;
  psn     : pstringnode;
  tts     : ttagstore;
  pmt     : pmytag;
begin
  pmt:=nil;
  oksofar:=true;
  tgs.edithook:=#0;
  pgn:=allocmymem(sizeof(tgadgetnode),memf_clear or memf_public);
  if pgn<>nil then
    begin
      addtail(@pdwn^.gadgetlist,pnode(pgn));
      error:=readchunkbytes(iff,@tgs,sizeof(tgadgetstore));
      if error>0 then
        begin
          with tgs do
            begin
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
              pgn^.font.ta_name:=@pgn^.fontname[1];
              copymem(@tags[1],@pgn^.tags[1],120);
              pgn^.joined:=joined;
              pgn^.datas:=datas;
              newlist(@pgn^.infolist);
              pgn^.pointers[1]:=nil;
              pgn^.edithook:=edithook;
              case pgn^.kind of
                string_kind : begin
                                if pgn^.joined then 
                                  pgn^.pointers[1]:=pointer(specialdata);
                              end;
                listview_kind : begin
                                  pgn^.tags[1].ti_data:=long(@pgn^.infolist);
                                  if pgn^.tags[3].ti_data<>0 then
                                    pgn^.tags[3].ti_data:=specialdata;
                                end;
                text_kind : begin
                              pgn^.tags[1].ti_data:=long(@pgn^.title[1]);
                            end;
               end;
            end;
          while (tgs.listfollows>0) and oksofar do
            begin
              error:=parseiff(iff,iffparse_rawstep);
              if (error=ifferr_eoc)or(error=0) then
                begin
                  pcn:=currentchunk(iff);
                  
                  if (pcn^.cn_id=id_tagd) and
                     (error=0) then
                    begin
                      dec(tgs.listfollows);
                      pmt:=allocmymem(sizeof(tmytag),memf_clear or memf_any);
                      if pmt<>nil then
                        begin
                          addtail(@pgn^.infolist,pnode(pmt));
                          pmt^.ln_name:=@pmt^.title[1];
                          error:=readchunkbytes(iff,@tts,sizeof(tts));
                          pmt^.title:=tts.title;
                          pmt^.tagtype:=tts.tagtype;
                          pmt^.value:=tts.value;
                          pmt^.sizebuffer:=tts.datasize;
                          pmt^.data:=pointer(tts.data);
                          pmt^.dataname:=tts.dataname;
                          if pmt^.sizebuffer>0 then
                            begin
                              pmt^.data:=allocmymem(pmt^.sizebuffer,memf_clear);
                              if pmt^.data=nil then
                                begin
                                  oksofar:=false;
                                  pmt^.sizebuffer:=0;
                                end;
                              inc(tgs.listfollows);
                            end;
                          if error<0 then
                            oksofar:=false;
                          
                          
                          
                        end
                       else
                        oksofar:=false;
                    end;
                  
                  if (pcn^.cn_id=id_tags) and
                     (error=0) then
                    begin
                      if pmt<>nil then
                        if pmt^.data<>nil then
                          begin
                            dec(tgs.listfollows);
                            error:=readchunkbytes(iff,pmt^.data,pmt^.sizebuffer);
                            if error<0 then
                              oksofar:=false
                             else
                              fixmytagdatapointers(pmt);
                            pmt:=nil;
                          end
                         else
                          oksofar:=false
                       else
                        oksofar:=false;
                    end;
                  
                  if (pcn^.cn_type=id_strl) and 
                     (pcn^.cn_id=id_strn) and
                     (error=0) then
                    begin
                      dec(tgs.listfollows);
                      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
                      if psn<>nil then
                        begin
                          addtail(@pgn^.infolist,pnode(psn));
                          psn^.ln_name:=@psn^.st[1];
                          error:=readchunkbytes(iff,@psn^.st,sizeof(psn^.st));
                          if error<0 then
                            oksofar:=false;
                        end
                       else
                        oksofar:=false;
                    end;
                end
               else
                oksofar:=false;
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readgadget:=oksofar;
end;

function readwindowinfo(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  oksofar  : boolean;
  error    : long;
  twininfo : twindowinfostore;
  loop     : word;
begin
  for error:=1 to 5 do
    twininfo.localeoptions[error]:=false;
  for error:=1 to 5 do
    twininfo.moretags[error]:=false;
  twininfo.defpubname:=#0;
  
  twininfo.moretags[1]:=true;
  for error:=1 to 20 do
    twininfo.codeoptions[error]:=false;
  twininfo.winparams:=#0;
  twininfo.fontx:=0;
  twininfo.fonty:=0;
  oksofar:=true;
  error:=readchunkbytes(iff,@twininfo,sizeof(twininfo));
  if error>0 then
    begin
      with twininfo do
        begin
          for error:=1 to 5 do
            pdwn^.localeoptions[error]:=twininfo.localeoptions[error];
          copymem(@codeoptions,@pdwn^.codeoptions,sizeof(codeoptions));            
          copymem(@extracodeoptions,@pdwn^.extracodeoptions,sizeof(extracodeoptions));            
          copymem(@moretags,@pdwn^.moretags,sizeof(pdwn^.moretags));            
          pdwn^.offx:=offx;
          pdwn^.offy:=offy;
          {
          pdwn^.offsetsdone:=offsetsdone;
          }
          pdwn^.nextid:=nextid;
          {
          pdwn^.useoffsets:=useoffsets;
          }
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
          {
          copymem(@screenprefs,@pdwn^.screenprefs,sizeof(screenprefs));
          }
          {
          pdwn^.fontname:=fontname;
          }
          copymem(@idcmplist,@pdwn^.idcmplist,sizeof(idcmplist));
          pdwn^.menutitle:=menutitle;
          pdwn^.gadgetfontname:=gadgetfontname;
          pdwn^.gadgetfont.ta_ysize:=gadgetfont.ta_ysize;
          pdwn^.gadgetfont.ta_style:=gadgetfont.ta_style;
          pdwn^.gadgetfont.ta_flags:=gadgetfont.ta_flags;
          pdwn^.fontx:=fontx;
          pdwn^.fonty:=fonty;
          
          pdwn^.winparams:=winparams;
          for loop:=1 to length(winparams) do
            if (winparams[loop]=':') then
              if (winparams[loop+1]=':') then
                begin
                  pdwn^.winparams:=copy(winparams,1,loop-1);
                  pdwn^.rendparams:=copy(winparams,loop+2,length(winparams)-loop-1);
                end;
          pdwn^.codeoptions[15]:=true;
          pdwn^.defpubname:=defpubname;
        end;
    end
   else
    oksofar:=false;
  readwindowinfo:=oksofar;
end;

function readwindow(iff:piffhandle;pcn:pcontextnode;winlist:plist):boolean;
var
  done    : boolean;
  oksofar : boolean;
  error   : long;
  pdwn    : pdesignerwindownode;
  pgn,pgn2: pgadgetnode;
begin
  done:=false;
  oksofar:=true;
  pdwn:=allocmymem(sizeof(tdesignerwindownode),memf_public or memf_clear);
  if pdwn<>nil then
    begin
      addtail(winlist,pnode(pdwn));
      setdefaultwindow(pdwn);
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
        if (error=0)and oksofar then
          case pcn^.cn_id of
            id_bevl : oksofar:=readbevelbox(iff,pdwn);
            id_imag : oksofar:=readsmallimage(iff,pdwn);
            id_text : oksofar:=readtextnode(iff,pdwn);
            id_gadg : oksofar:=readgadget(iff,pdwn);
            id_info : oksofar:=readwindowinfo(iff,pdwn);
           end;
      until done; 
    end
   else
    oksofar:=false;
  
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      case pgn^.kind of
        string_kind:
          if pgn^.joined then
            begin
              done:=false;
              pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
              while(pgn2^.ln_succ<>nil)and(not done) do
                begin
                  if pgn2^.id=long(pgn^.pointers[1]) then
                    begin
                      pgn^.pointers[1]:=pointer(pgn2);
                      pgn2^.tags[3].ti_data:=long(pgn);
                      done:=true;
                    end;
                  pgn2:=pgn2^.ln_succ;
                end;
              if not done then oksofar:=false;
            end;
       end;
      pgn:=pgn^.ln_succ;
    end;
  readwindow:=oksofar;
end;

function readimagenode(iff:piffhandle;pcn:pcontextnode;imagelist:plist):boolean;
var
  done    : boolean;
  oksofar : boolean;
  error   : long;
  tish    : timagestorehead;
  pin     : pimagenode;
  pba     : pbytearray;
  count   : long;
  loop    : word;
  tempstore : array [1..256] of word;
begin
  oksofar:=true;
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
    if (error=0)and oksofar then
      case pcn^.cn_id of
        id_head : begin
                    error:=readchunkbytes(iff,@tish,sizeof(tish));
                      if error>0 then
                        begin
                          pin:=allocmymem(sizeof(timagenode),memf_clear or memf_public);
                          if pin<>nil then
                            begin
                              with pin^ do
                                begin
                                  title:=tish.title;
                                  sizeallocated:=tish.sizedata;
                                  width:=tish.width;
                                  height:=tish.height;
                                  depth:=tish.depth;
                                  planepick:=tish.planepick;
                                  planeonoff:=tish.planeonoff;
                                  imagedata:=allocmymem(sizeallocated,memf_chip or memf_clear);
                                  if imagedata=nil then
                                    begin
                                      freemymem(pin);
                                      pin:=nil;
                                      oksofar:=false;
                                    end;
                                end;
                            end
                           else
                            oksofar:=false;
                        end;
                  end;
        id_data : if (pin<>nil) then
                    begin
                      error:=readchunkbytes(iff,pin^.imagedata,pin^.sizeallocated);
                      if error<0 then
                        begin
                          oksofar:=false;
                          freemymem(pin^.imagedata);
                          freemymem(pin);
                          pin:=nil;
                        end
                       else
                        addtail(imagelist,pnode(pin));
                   end;
        id_cmap : if (pin<>nil) then
                    begin
                      count:=pcn^.cn_size div 3;
                      pin^.colourmap:=pwordarray2(allocmymem(count*4,memf_any or memf_clear));
                      if pin<>nil then
                        begin
                          pin^.mapsize:=count*2;
                          count:=pcn^.cn_size;
                          if count>512 then
                            count:=512;
                          error:=readchunkbytes(iff,@tempstore,count);
                          if error<0 then
                            begin
                              oksofar:=false;
                              freemymem(pin^.colourmap);
                              pin^.colourmap:=nil;
                            end
                           else
                            begin
                              count:=0;
                              pba:=pbytearray(@tempstore);
                              for loop:=0 to (pcn^.cn_size div 3)-1 do
                                begin
                                  pin^.colourmap^[count]:=((pba^[3*loop] and 240) shl 4);
                                  pin^.colourmap^[count]:=pin^.colourmap^[count] or (pba^[3*loop+1] and 240);
                                  pin^.colourmap^[count]:=pin^.colourmap^[count] or ((pba^[3*loop+2] and 240) shr 4);
                                  if count<255 then
                                    inc(count);
                                end;
                            end;
                        end
                       else
                        oksofar:=false;
                    end;
       end;
  until done; 
  readimagenode:=oksofar;
end;

function readsubitems(iff:piffhandle;pcn:pcontextnode;pmin:pmenuitemnode):boolean;
var
  oksofar      : boolean;
  error        : long;
  done         : boolean;
  pmsi         : pmenusubitemnode;
  tsis         : tsubitemstore;
begin
  pmsi:=nil;
  oksofar:=true;
  done:=false;
  repeat
    error:=parseiff(iff,iffparse_rawstep);
    if (error=0) or (error=ifferr_eoc) then 
      begin
        pcn:=currentchunk(iff);
        if (pcn^.cn_type=id_subs) and 
           (pcn^.cn_id=id_form) and
           (error=ifferr_eoc) then
             done:=true;
      end
     else
      done:=true;
    if (error=0)and oksofar then
      case pcn^.cn_id of
        id_subi : begin
                    pmsi:=allocmymem(sizeof(tmenusubitemnode),memf_public or memf_clear);
                    if pmsi<>nil then
                      begin
                        error:=readchunkbytes(iff,@tsis,sizeof(tsis));
                        if error<0 then oksofar:=false;
                        pmsi^.idlabel:=tsis.idlabel;
                        pmsi^.barlabel:=tsis.barlabel;
                        pmsi^.text:=tsis.text;
                        pmsi^.graphicname:=tsis.graphicname;
                        pmsi^.commkey:=byte(tsis.commkey[1]);
                        pmsi^.disabled:=tsis.disabled;
                        pmsi^.graphic:=nil;
                        pmsi^.checkit:=tsis.checkit;
                        pmsi^.menutoggle:=tsis.menutoggle;
                        pmsi^.checked:=tsis.checked;
                        pmsi^.exclude:=tsis.exclude;
                        addtail(@pmin^.tsubitems,pnode(pmsi));
                      end
                     else
                      oksofar:=false;
                  end;
       end;
    if not oksofar then
      done:=true;
  until done;
  readsubitems:=oksofar;
end;

function readitems(iff:piffhandle;pcn:pcontextnode;pmtn:pmenutitlenode):boolean;
var
  oksofar      : boolean;
  error        : long;
  done         : boolean;
  pmin         : pmenuitemnode;
  tis          : titemstore;
begin
  pmin:=nil;
  oksofar:=true;
  done:=false;
  repeat
    error:=parseiff(iff,iffparse_rawstep);
    if (error=0) or (error=ifferr_eoc) then 
      begin
        pcn:=currentchunk(iff);
        if (pcn^.cn_type=id_itms) and 
           (pcn^.cn_id=id_form) and
           (error=ifferr_eoc) then
             done:=true;
      end
     else
      done:=true;
    if (error=0)and oksofar then
      case pcn^.cn_id of
        id_item : begin
                    pmin:=allocmymem(sizeof(tmenuitemnode),memf_public or memf_clear);
                    if pmin<>nil then
                      begin
                        error:=readchunkbytes(iff,@tis,sizeof(tis));
                        if error<0 then oksofar:=false;
                        pmin^.idlabel:=tis.idlabel;
                        pmin^.barlabel:=tis.barlabel;
                        pmin^.text:=tis.text;
                        pmin^.graphic:=nil;
                        pmin^.graphicname:=tis.graphicname;
                        pmin^.commkey:=byte(tis.commkey[1]);
                        pmin^.disabled:=tis.disabled;
                        pmin^.checkit:=tis.checkit;
                        pmin^.menutoggle:=tis.menutoggle;
                        pmin^.checked:=tis.checked;
                        pmin^.exclude:=tis.exclude;
                        newlist(@pmin^.tsubitems);
                        addtail(@pmtn^.titemlist,pnode(pmin));
                      end
                     else
                      oksofar:=false;
                  end;
        id_form : begin
                    if pmin<>nil then
                      begin
                        if pcn^.cn_type=id_subs then
                          begin
                            oksofar:=readsubitems(iff,pcn,pmin);
                          end;
                      end
                     else
                      oksofar:=false;
                  end;
       end;
    if not oksofar then
      done:=true;
  until done;
  readitems:=oksofar;
end;

function readtitles(iff:piffhandle;pcn:pcontextnode;pdmn:pdesignermenunode):boolean;
var
  oksofar      : boolean;
  error        : long;
  done         : boolean;
  pmtn         : pmenutitlenode;
  tts          : ttitlestore;
begin
  pmtn:=nil;
  oksofar:=true;
  done:=false;
  repeat
    error:=parseiff(iff,iffparse_rawstep);
    if (error=0) or (error=ifferr_eoc) then 
      begin
        pcn:=currentchunk(iff);
        if (pcn^.cn_type=id_ttls) and 
           (pcn^.cn_id=id_form) and
           (error=ifferr_eoc) then
             done:=true;
      end
     else
      done:=true;
    if (error=0)and oksofar then
      case pcn^.cn_id of
        id_ttle : begin
                    pmtn:=allocmymem(sizeof(tmenutitlenode),memf_public or memf_clear);
                    if pmtn<>nil then
                      begin
                        error:=readchunkbytes(iff,@tts,sizeof(tts));
                        if error<0 then oksofar:=false;
                        pmtn^.idlabel:=tts.idlabel;
                        pmtn^.text:=tts.text;
                        pmtn^.disabled:=tts.disabled;
                        newlist(@pmtn^.titemlist);
                        addtail(@pdmn^.tmenulist,pnode(pmtn));
                      end
                     else
                      oksofar:=false;
                  end;
        id_form : begin
                    if pmtn<>nil then
                      begin
                        if pcn^.cn_type=id_itms then
                          begin
                            oksofar:=readitems(iff,pcn,pmtn);
                          end;
                      end
                     else
                      oksofar:=false;
                  end;
       end;
    if not oksofar then
      done:=true;
  until done;
  readtitles:=oksofar;
end;

function readmenunode(iff:piffhandle;pcn:pcontextnode;menulist:plist):boolean;
var
  oksofar      : boolean;
  error        : long;
  done         : boolean;
  currenttitle : pmenutitlenode;
  pdmn         : pdesignermenunode;
  tms          : tmenustore;
begin
  pdmn:=nil;
  currenttitle:=nil;
  tms.localmenu:=false;
  oksofar:=true;
  done:=false;
  repeat
    error:=parseiff(iff,iffparse_rawstep);
    if (error=0) or (error=ifferr_eoc) then 
      begin
        pcn:=currentchunk(iff);
        if (pcn^.cn_type=id_menu) and 
           (pcn^.cn_id=id_form) and
           (error=ifferr_eoc) then
             done:=true;
      end
     else
      done:=true;
    if (error=0) and oksofar then
      case pcn^.cn_id of
        id_info : begin
                    pdmn:=allocmymem(sizeof(tdesignermenunode),memf_clear or memf_any);
                    if pdmn<>nil then
                      begin
                        error:=readchunkbytes(iff,@tms,sizeof(tms));
                        if error<0 then
                          oksofar:=false;
                        pdmn^.text:=tms.text;
                        pdmn^.idlabel:=tms.idlabel;
                        pdmn^.frontpen:=tms.frontpen;
                        pdmn^.fontname:=tms.fontname;
                        pdmn^.defaultfont:=tms.defaultfont;
                        copymem(@tms.font,@pdmn^.font,sizeof(pdmn^.font));
                        pdmn^.font.ta_name:=@pdmn^.fontname[1];
                        newlist(@pdmn^.tmenulist);
                        addtail(menulist,pnode(pdmn));
                        pdmn^.localmenu:=tms.localmenu;
                      end
                     else
                      oksofar:=false;
                  end;
        id_form : begin
                    if pdmn<>nil then
                      begin
                        if pcn^.cn_type=id_ttls then
                          begin
                            oksofar:=readtitles(iff,pcn,pdmn);
                          end;
                      end
                     else
                      oksofar:=false;
                  end;
       end;
    if not oksofar then
      done:=true;
  until done;
  readmenunode:=oksofar;
end;

function readallcode(iff:piffhandle):boolean;
var
  error         : long;
  oksofar       : boolean;
  done          : boolean;
  pcn           : pcontextnode;
begin
  readcodestore.fileversion:=0;
  readcodestore.includeextra:=#0;
  oksofar:=true;
  error:=readchunkbytes(iff,@readcodestore,sizeof(readcodestore));
  if error<0 then
    oksofar:=false;
  readallcode:=oksofar;
  globalincludeextra:=readcodestore.includeextra;
  copymem(@readcodestore.procedureoptions,@procedureoptions,sizeof(procedureoptions));
  copymem(@readcodestore.codeoptions,@codeoptions,sizeof(codeoptions));
  copymem(@readcodestore.openlibs,@openlibs,sizeof(openlibs));
  copymem(@readcodestore.versionlibs,@versionlibs,sizeof(versionlibs));
  copymem(@readcodestore.abortonfaillibs,@abortonfaillibs,sizeof(abortonfaillibs));
  if (0=readcodestore.fileversion)then
    begin
      openlibs[23]:=true;
      versionlibs[23]:=38;
      abortonfaillibs[23]:=false;
    end;

  if (readcodestore.fileversion>SaveFileVersion) then
    begin
      oksofar:=false;
    end;
end;

function readlocale(iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  done    : boolean;
  pcn     : pcontextnode;
  tlns    : tlocalenodestore;
  pln     : plocalenode;
  tlds    : tlocalestore;
begin
  readlocalestuff :=true;
  newlist(@readlocalelist);
  oksofar:=true;
  error:=readchunkbytes(iff,@tlds,sizeof(tlds));
  if error<0 then
    oksofar:=false;
  getstring:=no0(tlds.tgetstring);
  builtinlanguage:=no0(tlds.tbuiltinlanguage);
  localegetversion:=tlds.tversion;
  basename:=no0(tlds.tbasename);
  newlist(@readlocalelist);
  if oksofar then
  while tlds.numberofnodes>0 do
    begin
      error:=parseiff(iff,iffparse_rawstep);
      if (error=ifferr_eoc)or(error=0) then
        begin
          pcn:=currentchunk(iff);
          if (pcn^.cn_type=id_loca) and 
             (pcn^.cn_id=id_loci) and
             (error=0) then
            begin
              dec(tlds.numberofnodes);
              pln:=allocmymem(sizeof(tlocalenode),memf_clear or memf_any);
              if pln<>nil then
                begin
                  addtail(@readlocalelist,pnode(pln));
                  error:=readchunkbytes(iff,@tlns,sizeof(tlns));
                  if error<0 then
                    oksofar:=false
                   else
                    begin
                      pln^.str:=tlns.str;
                      pln^.labl:=tlns.labl;
                      pln^.comment:=tlns.comment;
                    end;
                end
               else
                oksofar:=false;
            end;
        end;
    end;
  if error<0 then
    oksofar:=false;
  
  
  readlocale:=oksofar;
end;



function readalldata(filename : string):boolean;
var
  psn      : pstringnode;
  iff      : piffhandle;
  error    : long;
  oksofar  : boolean;
  pdwn     : pdesignerwindownode;
  pin      : pimagenode;
  pcn      : pcontextnode;
  done     : boolean;
  winlist  : tlist;
  pgn,pgn2 : pgadgetnode;
  tgs      : tgadgetstore;
  twininfo : twindowinfostore;
  pdwn2    : pdesignerwindownode;
  imagelist: tlist;
  pin2     : pimagenode;
  psin     : psmallimagenode;
  realfile : boolean;
  menulist : tlist;
  pdmn     : pdesignermenunode;
  pmtn     : pmenutitlenode;
  pmin     : pmenuitemnode;
  pmsi     : pmenusubitemnode;
  screenlist : tlist;
  pdsn,pdsn2 : pdesignerscreennode;
  pmt      : pmytag;
begin
  readlocalestuff:=false;
  readcodestore.fileversion:=0;
  realfile:=false;
  newlist(@winlist);
  newlist(@screenlist);
  newlist(@imagelist);
  newlist(@menulist);
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
                    done:=false;
                    if (pcn^.cn_type=id_des1)and(pcn^.cn_id=id_form) then
                      repeat
                        realfile:=true;
                        error:=parseiff(iff,iffparse_rawstep);
                        if (error=0) or (error=ifferr_eoc) then
                          begin
                            pcn:=currentchunk(iff);
                            if (pcn^.cn_type=id_des1) and 
                               (pcn^.cn_id=id_form) and
                               (error=ifferr_eoc) then
                              done:=true;
                          end
                         else
                          done:=true; 
                        if oksofar and (pcn^.cn_type=id_wind) and (pcn^.cn_id=id_form)and(error=0) then
                          oksofar:=readwindow(iff,pcn,@winlist);
                        if oksofar and (pcn^.cn_type=id_pic1) and (pcn^.cn_id=id_form)and(error=0) then
                          oksofar:=readimagenode(iff,pcn,@imagelist);
                        if oksofar and (pcn^.cn_type=id_menu) and (pcn^.cn_id=id_form)and(error=0) then
                          oksofar:=readmenunode(iff,pcn,@menulist);
                        if oksofar and (pcn^.cn_id=id_info) and (error=0) then
                          oksofar:=readallcode(iff);
                        if oksofar and (pcn^.cn_id=id_loca) and (error=0) then
                          oksofar:=readlocale(iff);
                        if oksofar and (pcn^.cn_type=id_scrn) and (pcn^.cn_id=id_form)and(error=0) then
                          oksofar:=readscreen(iff,pcn,@screenlist);
                      until done;
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
  
  if realfile then
    begin
      
      pdsn:=pdesignerscreennode(screenlist.lh_head);
      if oksofar then
        while (pdsn^.ln_succ<>nil) do
          begin
            pdsn2:=pdsn^.ln_succ;
            remove(pnode(pdsn));
            if oksofar then
              begin
                addtail(@teditscreenlist,pnode(pdsn));
              end
             else
              begin
                if pdsn^.colorarray<>nil then
                  freemymem(pdsn^.colorarray);
                freemymem(pdsn);
              end;
            pdsn:=pdsn2;
          end;
      
      pin:=pimagenode(imagelist.lh_head);
      while (pin^.ln_succ<>nil) do
        begin
          pin2:=pin^.ln_succ;
          remove(pnode(pin));
          if oksofar then
            begin
              addtail(@teditimagelist,pnode(pin));
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
                  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                  while(pgn^.ln_succ<>nil) do
                    begin
                      if pgn^.kind=mybool_kind then
                        begin
                          psn:=pstringnode(pgn^.infolist.lh_head);
                          if psn^.st=pin^.title then
                            pgn^.pointers[1]:=pointer(pin);
                          psn:=psn^.ln_succ;
                          if psn^.st=pin^.title then
                            pgn^.pointers[2]:=pointer(pin);
                        end;
                      
                      if pgn^.kind=myobject_kind then
                        begin
                          pmt:=pmytag(pgn^.infolist.lh_head);
                          while(pmt^.ln_succ<>nil) do
                            begin
                              if (pmt^.tagtype=tagtypeimage) or
                                 (pmt^.tagtype=tagtypeimagedata) then
                                begin
                                  if pmt^.dataname=pin^.title then
                                    pmt^.data:=pin;
                                end;
                              pmt:=pmt^.ln_succ;
                            end;
                        end;
                      
                      pgn:=pgn^.ln_succ;
                    end;
                  pdwn:=pdwn^.ln_succ;
                end;
            end
           else
            begin
              if pin^.imagedata<>nil then
                freemymem(pin^.imagedata);
              if pin^.colourmap<>nil then
                freemymem(pin^.colourmap);
              freemymem(pin);
            end;
          pin:=pin2;
        end;
      pdmn:=pdesignermenunode(remhead(@menulist));
      while(pdmn<>nil) do
        begin
          addtail(@teditmenulist,pnode(pdmn));
          if not oksofar then
            deletedesignermenunode(pdmn)
           else
            begin
              pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
              while (pmtn^.ln_succ<>nil) do
                begin
                  pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
                  while (pmin^.ln_succ<>nil) do
                    begin
                      pmin^.graphic:=nil;
                      if pmin^.graphicname<>'' then
                        begin
                          pin:=pimagenode(teditimagelist.lh_head);
                          while(pin^.ln_succ<>nil) do
                            begin
                              if pin^.title=pmin^.graphicname then
                                pmin^.graphic:=pin;
                              pin:=pin^.ln_succ;
                            end;
                        end;
                      pmsi:=pmenusubitemnode(pmin^.tsubitems.mlh_head);
                      while (pmsi^.ln_succ<>nil) do
                        begin
                          pmsi^.graphic:=nil;
                          if pmsi^.graphicname<>'' then
                            begin
                              pin:=pimagenode(teditimagelist.lh_head);
                              while(pin^.ln_succ<>nil) do
                                begin
                                  if pin^.title=pmsi^.graphicname then
                                    pmsi^.graphic:=pin;
                                  pin:=pin^.ln_succ;
                                end;
                            end;
                          pmsi:=pmsi^.ln_succ;
                        end;
                      pmin:=pmin^.ln_succ;
                   end;
                 pmtn:=pmtn^.ln_succ;
              end;
            end;
          pdmn:=pdesignermenunode(remhead(@menulist));
        end;      
      
      pdwn:=pdesignerwindownode(winlist.lh_head);
      while(pdwn^.ln_succ<>nil) do
        begin
          pdwn2:=pdwn^.ln_succ;
          remove(pnode(pdwn));
          if oksofar then
            begin
              addtail(@teditwindowlist,pnode(pdwn));
              
              pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
              while(pgn^.ln_succ<>nil)do
                begin
                  if pgn^.kind=mybool_kind then
                    freelist(@pgn^.infolist);
                  if pgn^.kind=myobject_kind then
                    begin
                      pmt:=pmytag(pgn^.infolist.lh_head);
                      while(pmt^.ln_succ<>nil) do
                        begin
                          if pmt^.tagtype=tagtypeobject then
                            begin
                              pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                              while(pgn2^.ln_succ<>nil)do
                                begin
                                  if pgn2^.labelid=pmt^.dataname then
                                    pmt^.data:=pgn2;
                                  pgn2:=pgn2^.ln_succ;
                                end;

                            end;
                          pmt:=pmt^.ln_succ;
                        end;
                    end;
                  pgn:=pgn^.ln_succ;
                end;
              

              
              
            end
           else
            begin
              freelist(@pdwn^.bevelboxlist);
              pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
              while(pgn<>nil)do
                begin
                  if pgn^.kind=myobject_kind then
                    begin
                      pmt:=pmytag(pgn^.infolist.lh_head);
                      while(pmt^.ln_succ<>nil) do
                        begin
                          if (pmt^.sizebuffer>0) and(pmt^.data<>nil) then
                            freemymem(pmt^.data);
                          pmt:=pmt^.ln_succ;
                        end;
                    end;
                  freelist(@pgn^.infolist);
                  freemymem(pgn);
                  pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
                end;
              freelist(@pdwn^.textlist);
              freelist(@pdwn^.imagelist);
              freemymem(pdwn);
            end;
          pdwn:=pdwn2;
        end;
      if oksofar then
        begin
          copymem(@readcodestore.procedureoptions,@procedureoptions,sizeof(procedureoptions));
          copymem(@readcodestore.codeoptions,@codeoptions,sizeof(codeoptions));
          
          copymem(@readcodestore.openlibs,@openlibs,sizeof(openlibs));
          copymem(@readcodestore.versionlibs,@versionlibs,sizeof(versionlibs));
          copymem(@readcodestore.abortonfaillibs,@abortonfaillibs,sizeof(abortonfaillibs));
          
        end;
    end
   else
    begin
      oksofar:=false;
    end;
  readalldata:=oksofar;
end;

end.