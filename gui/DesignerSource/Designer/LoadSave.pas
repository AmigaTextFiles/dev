unit loadsave;

interface

uses asl,utility,exec,intuition,amiga,workbench,layers,drawwindows,icon,loadsave2,
     gadtools,graphics,dos,amigados,definitions,iffparse,routines,editscreenstuff;

const
  SaveFileVersion = 5;

type
  
 
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
    newlook39   : boolean;
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
    leftedge   : long;
    topedge    : long;
    placed     : boolean;
    title      : string[66];
    frontpen   : byte;
    backpen    : byte;
    drawmode   : byte;
    fontname   : string[46];
    fontysize  : word;
    fontstyle  : byte;
    fontflags  : byte;
    screenfont : boolean;
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

  pprefsstore = ^tprefsstore;
  tprefsstore = record
    prefsvals   : array[1..20] of boolean;
    defcompname : string;
   end;

var
  readcodestore   : twholecodestore;
  readlocalelist  : tlist;
  readlocaledata  : tlocalestore;
  readlocalestuff : boolean;
  
function writealldata(filename : string):boolean;
function readalldata(filename : string; clearold : boolean):boolean;
procedure writeprefsvalues(num : byte);
procedure readprefsvalues;
procedure oldprefstoscreen;
procedure deletedesignermenunode(pdmn:pdesignermenunode);
procedure deletedesignerwindow(pdwn:pdesignerwindownode);

implementation

function writescreen(iff:piffhandle;pdsn:pdesignerscreennode):boolean;
var
  tss     : tscreenstore;
  error   : long;
  oksofar : boolean;
begin
  oksofar:=true;
  with tss do
    begin
      labelid:=pdsn^.labelid;
      left:=pdsn^.left;
      top:=pdsn^.top;
      width:=pdsn^.width;
      height:=pdsn^.height;
      depth:=pdsn^.depth;
      overscan:=pdsn^.overscan;
      fonttype:=pdsn^.fonttype;
      behind:=pdsn^.behind;
      quiet:=pdsn^.quiet;
      showtitle:=pdsn^.showtitle;
      autoscroll:=pdsn^.autoscroll;
      bitmap:=pdsn^.bitmap;
      createbitmap:=pdsn^.createbitmap;
      title:=pdsn^.title;
      loctitle:=pdsn^.loctitle;
      idnum:=pdsn^.idnum;
      screentype:=pdsn^.screentype;
      {
      pens:=pdsn^.pens;
      }
      copymem(@pdsn^.penarray,@penarray,sizeof(penarray));
      pubname:=pdsn^.pubname;
      dopubsig:=pdsn^.dopubsig;
      defpens:=pdsn^.defpens;
      fullpalette:=pdsn^.fullpalette;
      font:=pdsn^.font;
      fontname:=pdsn^.fontname;
      if pdsn^.colorarray<>nil then
        sizecolorarray:=pdsn^.sizecolorarray
       else
        sizecolorarray:=0;
      {
      penarray:=pdsn^.penarray;
      }
      errorcode:=pdsn^.errorcode;
      sharedpens:=pdsn^.sharedpens;
      draggable:=pdsn^.draggable;
      exclusive:=pdsn^.exclusive;
      interleaved:=pdsn^.interleaved;
      likeworkbench:=pdsn^.likeworkbench;
    end;
  error:=pushchunk(iff,id_scrn,id_form,iffsize_unknown);
  if error=0 then
    begin
      error:=pushchunk(iff,id_scrn,id_scri,sizeof(tscreenstore));
      if error=0 then
        begin
          error:=writechunkbytes(iff,@tss,sizeof(tscreenstore));
          if error<0 then
            oksofar:=false;
          error:=popchunk(iff);
          if error<>0 then
            oksofar:=false;
        end;
      
      if pdsn^.colorarray<>nil then
        begin
          {
          writeln('color data');
          
          writeln(pdsn^.sizecolorarray);
          }
          error:=pushchunk(iff,id_scrn,id_scrc,pdsn^.sizecolorarray);
          if error=0 then
            begin
              
              error:=writechunkbytes(iff,pdsn^.colorarray,pdsn^.sizecolorarray);
              if error<0 then
                oksofar:=false;
              error:=popchunk(iff);
              if error<>0 then
                oksofar:=false;
              
            end;
        end;
      
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writescreen:=oksofar;
end;

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
                                  ln_name:=@labelid[1];
                                  ln_type:=screennodetype;
                                  
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
                                  
                                  copymem(@tss.penarray,@penarray,sizeof(penarray));
                                  
                                  font.ta_name:=@fontname[1];
                                  
                                  sizecolorarray:=tss.sizecolorarray;

                                  if sizecolorarray>0 then
                                    begin
                                      colorarray:=allocmymem(sizecolorarray,memf_chip or memf_clear);
                                      if colorarray=nil then
                                        begin
                                          freemymem(pdsn,sizeof(tdesignerscreennode));
                                          pdsn:=nil;
                                          oksofar:=false;
                                        end;
                                    end;
                                  
                                  errorcode:=tss.errorcode;
                                  sharedpens:=tss.sharedpens;
                                  draggable:=tss.draggable;
                                  exclusive:=tss.exclusive;
                                  interleaved:=tss.interleaved;
                                  likeworkbench:=tss.likeworkbench;
                                  
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
                              freemymem(pdsn,sizeof(tdesignerscreennode));
                              pdsn:=nil;
                            end;
                        end
                       else
                        begin
                          freemymem(pdsn,sizeof(tdesignerscreennode));
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

procedure deletedesignerwindow(pdwn:pdesignerwindownode);
var
  pgn : pgadgetnode;
  ptn : ptextnode;
begin
  remove(pnode(pdwn));
  freelist(@pdwn^.bevelboxlist,sizeof(tbevelboxnode));
  pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
  while(pgn<>nil)do
    begin
      freegadgetnode(pdwn,pgn);
      pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
    end;
  if pdwn^.editscreen<>nil then
    closeeditscreenforwindow(pdwn);
  freelist(@pdwn^.textlist,sizeof(ttextnode));
  freelist(@pdwn^.imagelist,sizeof(tsmallimagenode));
  freemymem(pdwn,sizeof(tdesignerwindownode));
  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_labels,~0);
  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_labels,long(@teditwindowlist));
  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_selected,~0);
  mainselected:=~0;
end;

procedure deletedesignermenunode(pdmn:pdesignermenunode);
var
  pmtn  : pmenutitlenode;
  pmin  : pmenuitemnode;
  pdwn  : pdesignerwindownode;
  pdmn3 : pdesignermenunode;
  loop  : long;
begin
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while(pdwn^.ln_succ<>nil) do
    begin
      pdwn^.pdmn2:=nil;
      if pdwn^.pdmn=pdmn then
        begin
          pdwn^.pdmn:=nil;
          pdwn^.codeoptions[11]:=false;
        end;
      if pdwn^.codewindow<>nil then
        begin
          if pdwn^.pdmn=pdmn then
            begin
              gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,
                         gtlv_labels,~0);
              pdwn^.codeselected:=~0;
              gt_setsinglegadgetattr(pdwn^.codegadgets[11],pdwn^.codewindow,gtcb_checked,long(false));
            end
           else
            begin
              if pdwn^.codeselected<>~0 then
                pdwn^.pdmn2:=pdesignermenunode(getnthnode(@teditmenulist,pdwn^.codeselected));
              gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,
                         gtlv_labels,~0);
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
  if cyclepos=1 then
    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_labels,~0);
  remove(pnode(pdmn));
  if cyclepos=1 then
    begin
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_labels,long(@teditmenulist));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                         gtlv_selected,~0);
      mainselected:=~0;
    end;
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while(pdwn^.ln_succ<>nil) do
    begin
      if pdwn^.codewindow<>nil then
        begin
          pdwn^.codeselected:=~0;
          if pdwn^.pdmn2<>nil then
            begin
              loop:=0;
              pdmn3:=pdesignermenunode(teditmenulist.lh_head);
              while (pdmn3^.ln_succ<>nil) do
                begin
                  if pdmn3=pdwn^.pdmn2 then
                    pdwn^.codeselected:=loop;
                  inc(loop);
                  pdmn3:=pdmn3^.ln_succ;
                end;
            end;
          gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,
                                 gtlv_labels,long(@teditmenulist));
          gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,
                                 gtlv_selected,pdwn^.codeselected);
        end;
      pdwn:=pdwn^.ln_succ;
    end;
  if pdmn^.editwindow<>nil then
    closeeditmenuwindow(pdmn);
  pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          freelist(@pmin^.tsubitems,sizeof(tmenusubitemnode));
          pmin:=pmin^.ln_succ;
        end;
      freelist(@pmtn^.titemlist,sizeof(tmenuitemnode));
      pmtn:=pmtn^.ln_succ;
    end;
  freelist(@pdmn^.tmenulist,sizeof(tmenutitlenode));
  freemymem(pdmn,sizeof(tdesignermenunode));
end;

procedure writeprefsvalues( num : byte );
var
  f    : bptr;
  tps  : tprefsstore;
  psn  : pstringnode;
  loop : word;
  s : string;
begin
  if num=2 then
    begin
      s:='EnvArc:Designer/Designer.Prefs'#0;
      mkdir('EnvArc:Designer');
    end
   else
    begin
      s:='Env:Designer/Designer.Prefs'#0;
      mkdir('Env:Designer');
    end;
  f:=open(@s[1],mode_newfile);
  if f<>0 then
    begin
      for loop:=1 to 20 do
        tps.prefsvals[loop]:=prefsvalues[loop];
      if deflangnum<>~0 then
        begin
          psn:=pstringnode(getnthnode(@compilerlist,deflangnum));
          tps.defcompname:=no0(psn^.st);
        end
       else
        tps.defcompname:='';
      if write_(f,@tps,sizeof(tps))<>sizeof(tps) then
        telluser(mainwindow,'Incomplete prefs file written.');
      if not close_(f) then
        telluser(mainwindow,'Cannot close prefs file.');
    end
   else
    telluser(mainwindow,'Cannot write prefs file.');
end;

procedure rpv(num:byte);
var
  f    : bptr;
  tps  : tprefsstore;
  s    : string;
  loop : long;
  psn  : pstringnode;
begin
  if num=1 then 
    s:='Env:Designer/Designer.Prefs'#0
   else
    s:='EnvArc:Designer/Designer.Prefs'#0;
  f:=open(@s[1],mode_oldfile);
  if f<>0 then
    begin
      if read_(f,@tps,sizeof(tps))<>sizeof(tps) then
        telluser(mainwindow,'Incomplete Prefs file read, old version possibly.');
      for loop:=1 to 20 do
        if num=1 then
          prefsvalues[loop]:=tps.prefsvals[loop]
         else
          if loop<=numofprefsoptions then
            gt_setsinglegadgetattr(prefsgadgets[loop],prefswindow,
                                   gtcb_checked,long(tps.prefsvals[loop]));
      defcompname:=tps.defcompname;
      loop:=0;
      psn:=pstringnode(compilerlist.lh_head);
      while (psn^.ln_succ<>nil) do
        begin
          if no0(psn^.st)=defcompname then
            begin
              deflangnum:=loop;
            end;
          inc(loop);
          psn:=psn^.ln_succ;
        end;
      if not close_(f) then
        telluser(mainwindow,'Cannot close prefs file.');
    end;
end;

procedure oldprefstoscreen;
begin
  rpv(2);
end;

procedure readprefsvalues;
begin
  rpv(1);
end;

function writeimagenode(pin:pimagenode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  tish    : timagestorehead;
  tempstore : array[1..256] of word;
  pba       : pbytearray;
  count     : long;
  loop      : word;
begin
  oksofar:=true;
  error:=pushchunk(iff,id_pic1,id_form,iffsize_unknown);
  if error=0 then
    begin
      error:=pushchunk(iff,id_pic1,id_head,iffsize_unknown);
      if error=0 then
        begin
          with tish do
            begin
              title:=pin^.title;
              leftedge:=pin^.leftedge;
              topedge:=pin^.topedge;
              width:=pin^.width;
              height:=pin^.height;
              depth:=pin^.depth;
              planepick:=pin^.planepick;
              planeonoff:=pin^.planeonoff;
              sizedata:=pin^.sizeallocated;
            end;
          error:=writechunkbytes(iff,@tish,sizeof(tish));
          if error<0 then
            oksofar:=false;
          error:=popchunk(iff);
          if error<>0 then
            oksofar:=false;
          if oksofar then
            begin
              error:=pushchunk(iff,id_pic1,id_data,iffsize_unknown);
              if error=0 then
                begin
                  
                  { compress data }
                  
                  error:=writechunkbytes(iff,pin^.imagedata,pin^.sizeallocated);
                  if error<0 then
                    oksofar:=false;
                  error:=popchunk(iff);
                  if error<>0 then
                    oksofar:=false;
                end;
            end;
          if oksofar and (pin^.colourmap<>nil) then
            begin
              count:=pin^.mapsize div 4;
              pba:=pbytearray(@tempstore);
              for loop:=0 to count-1 do
                begin
                  pba^[loop*3]  :=(pin^.colourmap^[loop] and (31 shl 8)) shr 4;
                  pba^[loop*3+1]:=(pin^.colourmap^[loop] and (31 shl 4));
                  pba^[loop*3+2]:=(pin^.colourmap^[loop] and 31) shl 4;
                end;
              error:=pushchunk(iff,id_pic1,id_cmap,3*(pin^.mapsize div 4));
              if error=0 then
                begin
                  error:=writechunkbytes(iff,pba,3*(pin^.mapsize div 4));
                  if error<0 then
                    oksofar:=false;
                  error:=popchunk(iff);
                  if error<>0 then
                    oksofar:=false;
                end;
            end;
        end;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writeimagenode:=oksofar;
end;


function writebevelboxstore(pbbn:pbevelboxnode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  tbs     : tbevelboxstore;
begin
  oksofar:=true;
  error:=pushchunk(iff,id_wind,id_bevl,iffsize_unknown);
  if error=0 then
    begin
      with tbs do
        begin
          leftedge:=pbbn^.x;
          topedge:=pbbn^.y;
          width:=pbbn^.w;
          height:=pbbn^.h;
          beveltype:=pbbn^.beveltype;
          title:=pbbn^.title;
        end;
      error:=writechunkbytes(iff,@tbs,sizeof(tbevelboxstore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writebevelboxstore:=oksofar;
end; 

function writesmallimagestore(psin:psmallimagenode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  tsis    : tsmallimagestore;
begin
  oksofar:=true;
  error:=pushchunk(iff,id_wind,id_imag,iffsize_unknown);
  if error=0 then
    begin
      with tsis do
        begin
          leftedge:=psin^.x;
          topedge:=psin^.y;
          placed:=psin^.placed;
          title:=psin^.title;
          imagename:=psin^.pin^.title;
        end;
      error:=writechunkbytes(iff,@tsis,sizeof(tsmallimagestore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writesmallimagestore:=oksofar;
end; 
    
function writetextstore(ptn:ptextnode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  tts     : ttextstore;
begin
  oksofar:=true;
  error:=pushchunk(iff,id_wind,id_text,iffsize_unknown);
  if error=0 then
    begin
      with tts do
        begin
          leftedge:=ptn^.x;
          topedge:=ptn^.y;
          placed:=ptn^.placed;
          title:=ptn^.title;
          frontpen:=ptn^.frontpen;
          backpen:=ptn^.backpen;
          drawmode:=ptn^.drawmode;
          fontname:=ptn^.fonttitle;
          fontysize:=ptn^.ta.ta_ysize;
          fontstyle:=ptn^.ta.ta_style;
          fontflags:=ptn^.ta.ta_flags;
          screenfont:=ptn^.screenfont;
        end;
      error:=writechunkbytes(iff,@tts,sizeof(ttextstore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writetextstore:=oksofar;
end; 

function writewindow(pdwn:pdesignerwindownode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  wininfo : twindowinfostore;
  ptn     : ptextnode;
  psin    : psmallimagenode;
  pbbn    : pbevelboxnode;
  pgn     : pgadgetnode;
begin
  oksofar:=true;
  error:=pushchunk(iff,id_wind,id_form,iffsize_unknown);
  if error=0 then
    begin
      
      { write gadget info }
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      
      keepgoing:=true;
      demopos:=0;
      while (pgn^.ln_succ<>nil)and keepgoing do
        begin
          inc(demopos);
          if (not demoversion) or (demopos<5) then
            begin
              if oksofar then
                oksofar:=writegadgetstore(pgn,iff);
              pgn:=pgn^.ln_succ;
            end
           else
            begin
              {
              seterror('Can Only Save 4 Gadgets Per Window In The Demo Version.');
              }
              incompletesave:=true;
              keepgoing:=false;
            end;
        end;
      
      { write bevel info }
      pbbn:=pbevelboxnode(pdwn^.bevelboxlist.lh_head);
      while (pbbn^.ln_succ<>nil) do
        begin
          if oksofar then
            oksofar:=writebevelboxstore(pbbn,iff);
          pbbn:=pbbn^.ln_succ;
        end;
      
      { write image info }
      
      psin:=psmallimagenode(pdwn^.imagelist.lh_head);
      
      if not demoversion then
        begin
          while (psin^.ln_succ<>nil) do
            begin
              if oksofar then
                oksofar:=writesmallimagestore(psin,iff);
              psin:=psin^.ln_succ;
            end;
        end
       else
        begin
          if psin^.ln_succ<>nil then
            begin
              if psin^.ln_succ^.ln_succ<>nil then
                incompletesave:=true;

                {
                 seterror('Only One Static Image Saved Per Window In The Demo Version.');
                }
              if oksofar then
                oksofar:=writesmallimagestore(psin,iff);
            end;
        end;
      
      { write text info }
      
      ptn:=ptextnode(pdwn^.textlist.lh_head);
      if not demoversion then
        begin
          while (ptn^.ln_succ<>nil) do
            begin
              if oksofar then
                oksofar:=writetextstore(ptn,iff);
              ptn:=ptn^.ln_succ;
            end;
        end
       else
        begin
          if ptn^.ln_succ<>nil then
            begin
              if ptn^.ln_succ^.ln_succ<>nil then
                incompletesave:=true;

                {
                seterror('Only One Static Text Per Window Saved In The Demo Version.');
                }
              if oksofar then
                oksofar:=writetextstore(ptn,iff);
            end;
        end;
      
      { write wininfo }
      if oksofar then
        begin
          with wininfo do
            begin
              copymem(@pdwn^.codeoptions,@wininfo.codeoptions,sizeof(wininfo.codeoptions));
              copymem(@pdwn^.extracodeoptions,@wininfo.extracodeoptions,sizeof(wininfo.extracodeoptions));
              copymem(@pdwn^.dripens[1],@dripens[1],sizeof(dripens));
              offx:=pdwn^.offx;
              offy:=pdwn^.offy;
              offsetsdone:=pdwn^.offsetsdone;
              nextid:=pdwn^.nextid;
              useoffsets:=pdwn^.useoffsets;
              title:=pdwn^.title;
              leftedge:=pdwn^.x;
              for error:=1 to 5 do
                localeoptions[error]:=pdwn^.localeoptions[error];
              topedge:=pdwn^.y;
              width:=pdwn^.w;
              height:=pdwn^.h;
              screentitle:=pdwn^.screentitle;
              minw:=pdwn^.minw;
              maxw:=pdwn^.maxw;
              minh:=pdwn^.minh;
              maxh:=pdwn^.maxh;
              copymem(@pdwn^.moretags,@moretags,sizeof(moretags));
              innerw:=pdwn^.innerw;
              innerh:=pdwn^.innerh;
              labelid:=pdwn^.labelid;
              copymem(@pdwn^.zoom[1],@zoom[1],8);
              mousequeue:=pdwn^.mousequeue;
              rptqueue:=pdwn^.rptqueue;
              sizegad:=pdwn^.sizegad;
              sizebright:=pdwn^.sizebright;
              sizebbottom:=pdwn^.sizebbottom;
              dragbar:=pdwn^.dragbar;
              depthgad:=pdwn^.depthgad;
              closegad:=pdwn^.closegad;
              reportmouse:=pdwn^.reportmouse;
              nocarerefresh:=pdwn^.nocarerefresh;
              borderless:=pdwn^.borderless;
              backdrop:=pdwn^.backdrop;
              gimmezz:=pdwn^.gimmezz;
              activate:=pdwn^.activate;
              rmbtrap:=pdwn^.rmbtrap;
              simplerefresh:=pdwn^.simplerefresh;
              smartrefresh:=pdwn^.smartrefresh;
              autoadjust:=pdwn^.autoadjust;
              menuhelp:=pdwn^.menuhelp;
              usezoom:=pdwn^.usezoom;
              customscreen:=pdwn^.customscreen;
              pubscreen:=pdwn^.pubscreen;
              pubscreenname:=pdwn^.pubscreenname;
              pubscreenfallback:=pdwn^.pubscreenfallback;
              flags:=pdwn^.flags;
              copymem(@pdwn^.screenprefs,@screenprefs,sizeof(screenprefs));
              fontname:=pdwn^.fontname;
              copymem(@pdwn^.idcmplist,@idcmplist,sizeof(idcmplist));
              if pdwn^.pdmn<>nil then
                menutitle:=pdwn^.pdmn^.idlabel
               else
                menutitle:='';
              gadgetfontname:=pdwn^.gadgetfontname;
              gadgetfont.ta_style:=pdwn^.gadgetfont.ta_style;
              gadgetfont.ta_flags:=pdwn^.gadgetfont.ta_flags;
              gadgetfont.ta_ysize:=pdwn^.gadgetfont.ta_ysize;
              fontx:=pdwn^.fontx;
              fonty:=pdwn^.fonty;
              winparams:=pdwn^.winparams;
              defpubname:=pdwn^.defpubname;
            end;
          error:=pushchunk(iff,id_wind,id_info,iffsize_unknown);
          if error=0 then
            begin
              error:=writechunkbytes(iff,@wininfo,sizeof(wininfo));
              if error<0 then
                oksofar:=false;
              error:=popchunk(iff);
              if error<>0 then
                oksofar:=false;
            end
           else
            oksofar:=false;
        end;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writewindow:=oksofar;
end;

function writemenusubitem(iff:piffhandle;pmsi:pmenusubitemnode):boolean;
var
  tsis     : tsubitemstore;
  error   : long;
  oksofar : boolean;
begin
  oksofar:=true;
  with tsis do
    begin
      text:=pmsi^.text;
      barlabel:=pmsi^.barlabel;
      idlabel:=pmsi^.idlabel;
      if pmsi^.graphic<>nil then
        graphicname:=pmsi^.graphic^.title
       else
        graphicname:='';
      commkey:=pmsi^.commkey;
      disabled:=pmsi^.disabled;
      checkit:=pmsi^.checkit;
      checked:=pmsi^.checked;
      menutoggle:=pmsi^.menutoggle;
      textprint:=pmsi^.textprint;
      exclude:=pmsi^.exclude;
    end;
  error:=pushchunk(iff,id_subi,id_subi,sizeof(tsubitemstore));
  if error=0 then
    begin
      error:=writechunkbytes(iff,@tsis,sizeof(tsubitemstore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writemenusubitem:=oksofar;
end;

function writemenuitem(iff:piffhandle;pmin:pmenuitemnode):boolean;
var
  tis     : titemstore;
  error   : long;
  oksofar : boolean;
  pmsi    : pmenusubitemnode;
begin
  oksofar:=true;
  with tis do
    begin
      text:=pmin^.text;
      barlabel:=pmin^.barlabel;
      idlabel:=pmin^.idlabel;
      if pmin^.graphic<>nil then
        graphicname:=pmin^.graphic^.title
       else
        graphicname:='';
      commkey:=pmin^.commkey;
      disabled:=pmin^.disabled;
      checkit:=pmin^.checkit;
      checked:=pmin^.checked;
      menutoggle:=pmin^.menutoggle;
      textprint:=pmin^.textprint;
      exclude:=pmin^.exclude;
      nextsub:=pmin^.nextsub;
    end;
  error:=pushchunk(iff,id_itms,id_item,sizeof(titemstore));
  if error=0 then
    begin
      
      error:=writechunkbytes(iff,@tis,sizeof(titemstore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
      
      if (sizeoflist(@pmin^.tsubitems)>0)and oksofar then
        begin
          error:=pushchunk(iff,id_subs,id_form,iffsize_unknown);
          if error=0 then
            begin
              pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  if oksofar then
                    oksofar:=writemenusubitem(iff,pmsi);
                  pmsi:=pmsi^.ln_succ;
                end;
            end
           else
            oksofar:=false;
          error:=popchunk(iff);
          if error<>0 then
            oksofar:=false;
        end;
    
    end
   else
    oksofar:=false;
  writemenuitem:=oksofar;
end;

function writemenutitle(iff:piffhandle;pmtn:pmenutitlenode):boolean;
var
  tts     : ttitlestore;
  error   : long;
  oksofar : boolean;
  pmin    : pmenuitemnode;
begin
  oksofar:=true;
  with tts do
    begin
      text:=pmtn^.text;
      idlabel:=pmtn^.idlabel;
      disabled:=pmtn^.disabled;
      nextitem:=pmtn^.nextitem;
    end;
  error:=pushchunk(iff,id_ttle,id_ttle,sizeof(ttitlestore));
  if error=0 then
    begin
      error:=writechunkbytes(iff,@tts,sizeof(ttitlestore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
      if oksofar and(sizeoflist(@pmtn^.titemlist)>0) then
        begin
          error:=pushchunk(iff,id_itms,id_form,iffsize_unknown);
          if error=0 then
            begin
              pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
              while (pmin^.ln_succ<>nil) do
                begin
                  if oksofar then
                    oksofar:=writemenuitem(iff,pmin);
                  pmin:=pmin^.ln_succ;
                end;
            end
           else
            oksofar:=false;
          error:=popchunk(iff);
          if error<>0 then
            oksofar:=false;
        end;
    end
   else
    oksofar:=false;
  writemenutitle:=oksofar;
end;

function writemenu(iff:piffhandle;pdmn:pdesignermenunode):boolean;
var
  tms     : tmenustore;
  error   : long;
  oksofar : boolean;
  pmtn    : pmenutitlenode;
begin
  oksofar:=true;
  with tms do
    begin
     {text:=pdmn^.text;}
      if pdmn^.editwindow<>nil then
        begin
          pdmn^.idlabel:=getstringfromgad(pdmn^.gads[45]);
        end;
      idlabel:=pdmn^.idlabel;
      frontpen:=pdmn^.frontpen;
      copymem(@pdmn^.font,@font,sizeof(ttextattr));
      fontname:=pdmn^.fontname;
      defaultfont:=pdmn^.defaultfont;
      nexttitle:=pdmn^.nexttitle;
      newlook39:=pdmn^.newlook39;
      localmenu:=pdmn^.localmenu;
    end;
  error:=pushchunk(iff,id_menu,id_form,iffsize_unknown);
  if error=0 then
    begin
      error:=pushchunk(iff,id_menu,id_info,sizeof(tmenustore));
      if error=0 then
        begin
          error:=writechunkbytes(iff,@tms,sizeof(tmenustore));
          if error<0 then
            oksofar:=false;
          error:=popchunk(iff);
          if error<>0 then
            oksofar:=false;
          if oksofar and (sizeoflist(@pdmn^.tmenulist)>0) then
            begin
              error:=pushchunk(iff,id_ttls,id_form,iffsize_unknown);
              if error=0 then
                begin
                  pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
                  if not demoversion then
                    begin
                      while (pmtn^.ln_succ<>nil) do
                        begin
                          if oksofar then
                            oksofar:=writemenutitle(iff,pmtn);
                          pmtn:=pmtn^.ln_succ;
                        end;
                    end
                   else
                    begin
                      if pmtn^.ln_succ<>nil then
                        begin
                          if pmtn^.ln_succ^.ln_succ<>nil then
                            {
                            seterror('Only One Title Per Menu Saved In The Demo.');
                            }
                            incompletesave:=true;

                          if oksofar then
                            oksofar:=writemenutitle(iff,pmtn);
                        end;
                    end;
                end
               else
                oksofar:=false;
              error:=popchunk(iff);
              if error<>0 then
                oksofar:=false;
            end;
        end;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
    end
   else
    oksofar:=false;
  writemenu:=oksofar;
end;

function writecodeinfo(iff:piffhandle):boolean;
var
  twcs  : twholecodestore;
  error : long;
  loop  : long;
  pln   : plibnode;
  psn   : pstringnode;
begin
  copymem(@procedureoptions,@twcs.procedureoptions,sizeof(twcs.procedureoptions));
  copymem(@codeoptions,@twcs.codeoptions,sizeof(twcs.codeoptions));
  if presentcompiler<>~0 then
    begin
      psn:=pstringnode(getnthnode(@compilerlist,presentcompiler));
      twcs.compilername:=no0(psn^.st);
    end
   else
    twcs.compilername:='';
  if maincodewindow<>nil then
    globalincludeextra:=getstringfromgad(maincodegadgets[12]);
  twcs.includeextra:=globalincludeextra;
  twcs.fileversion:=SaveFileVersion;
  loop:=1;
  pln:=plibnode(tliblist.lh_head);
  while (pln^.ln_succ<>nil) do
    begin
      twcs.openlibs[loop]:=pln^.open;
      twcs.versionlibs[loop]:=pln^.version;
      twcs.abortonfaillibs[loop]:=pln^.abortonfail;
      inc(loop);
      pln:=pln^.ln_succ;
    end;
  
  writecodeinfo:=true;
  error:=pushchunk(iff,id_des1,id_info,iffsize_unknown);
  if error=0 then
    begin
      error:=writechunkbytes(iff,@twcs,sizeof(twcs));
      if error>=0 then
        begin
          error:=popchunk(iff);
          if error<>0 then
            writecodeinfo:=false;
        end
       else
        writecodeinfo:=false;
    end
   else
    writecodeinfo:=false;
end;

function writelocale(iff:piffhandle) : boolean;
var
  ls    : tlocalestore;
  error : long;
  pln   : plocalenode;
  tlns  : tlocalenodestore;
  loop  : long;
begin
  writelocale:=true;
  ls.tgetstring:=getstring;
  ls.tbuiltinlanguage:=builtinlanguage;
  ls.tversion:=version;
  ls.tbasename:=basename;
  ls.numberofnodes:=sizeoflist(@tlocalelist);
  error:=pushchunk(iff,id_des1,id_loca,iffsize_unknown);
  if error=0 then
    begin
      error:=writechunkbytes(iff,@ls,sizeof(ls));
      if error>=0 then
        begin
          
          error:=popchunk(iff);
          if error<>0 then
            writelocale:=false
           else
            if sizeoflist(@tlocalelist)>0 then
              begin
                error:=pushchunk(iff,id_loca,id_form,iffsize_unknown);
                if error=0 then
                  begin
                    pln:=plocalenode(tlocalelist.lh_head);
                    while(pln^.ln_succ<>nil) do
                      begin
                        error:=pushchunk(iff,id_loca,id_loci,sizeof(tlocalenodestore));
                        if error=0 then
                          begin
                            tlns.labl:=pln^.labl;
                            tlns.comment:=pln^.comment;
                            tlns.str:=pln^.str;
                            error:=writechunkbytes(iff,@tlns,sizeof(tlns));
                            if error<0 then
                              writelocale:=false;
                            error:=popchunk(iff);
                            if error<>0 then
                              writelocale:=false; 
                          end
                         else
                          writelocale:=false;
                        pln:=pln^.ln_succ;
                      end;
                    error:=popchunk(iff);
                    if error<>0 then
                      writelocale:=false;
                  end
                 else
                  writelocale:=false;
              end;
        end
       else
        writelocale:=false;
    end
   else
    writelocale:=false;
end;

function writealldata(filename : string):boolean;
var
  defaulttool : string;
  iff         : piffhandle;
  error       : long;
  oksofar     : boolean;
  pdwn        : pdesignerwindownode;
  pin         : pimagenode;
  pdmn        : pdesignermenunode;
  dataicon    : pdiskobject;
  pdsn        : pdesignerscreennode;
begin
  incompletesave:=false;
  oksofar:=true;
  iff:=allociff;
  if iff<>nil then
    begin
      if prefsvalues[12] then
        begin
          {$I-}
          erase(no0(filename)+'.bak');
          rename(no0(filename),no0(filename)+'.bak');
        end;
      iff^.iff_stream:=long(open(@filename[1],mode_newfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_write);
          if error=0 then
            begin
              error:=pushchunk(iff,id_des1,id_form,iffsize_unknown);
              if error=0 then
                begin
                  oksofar:=writelocale(iff);
                  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
                  if not demoversion then
                    begin
                      while (pdwn^.ln_succ<>nil) do
                        begin
                          if oksofar then
                            oksofar:=writewindow(pdwn,iff);
                          pdwn:=pdwn^.ln_succ;
                        end;
                    end
                   else
                    begin
                      if pdwn^.ln_succ<>nil then
                        begin
                          if pdwn^.ln_succ^.ln_succ<>nil then
                            {
                            seterror('Only One Window Saved In Demo Version.');
                            }
                            incompletesave:=true;

                          if oksofar then
                            oksofar:=writewindow(pdwn,iff);
                        end;
                    end;
                  pdmn:=pdesignermenunode(teditmenulist.lh_head);
                  while(pdmn^.ln_succ<>nil) do
                    begin
                      if oksofar then 
                        oksofar:=writemenu(iff,pdmn);
                      pdmn:=pdmn^.ln_succ;
                    end;
                  
                  pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
                  if not demoversion then
                    begin
                      while (pdsn^.ln_succ<>nil) do
                        begin
                          if oksofar then
                            oksofar:=writescreen(iff,pdsn);
                          pdsn:=pdsn^.ln_succ;
                        end;
                    end
                   else
                    begin
                      if pdsn^.ln_succ<>nil then
                        begin
                          if oksofar then
                            oksofar:=writescreen(iff,pdsn);
                          pdsn:=pdsn^.ln_succ;
                        end;
                      if pdsn^.ln_succ<>nil then
                        incompletesave:=true;
                    end; 
                    
                  pin:=pimagenode(teditimagelist.lh_head);
                  if not demoversion then
                    begin
                      while (pin^.ln_succ<>nil) do
                        begin
                          if oksofar then
                            oksofar:=writeimagenode(pin,iff);
                          pin:=pin^.ln_succ;
                        end;
                    end
                   else
                    begin
                      if pin^.ln_succ<>nil then
                        if oksofar then
                          oksofar:=writeimagenode(pin,iff);
                      if pin^.ln_succ<>nil then
                        pin:=pin^.ln_succ;
                  
                      if pin^.ln_succ<>nil then
                        if oksofar then
                          oksofar:=writeimagenode(pin,iff);
                      if pin^.ln_succ<>nil then
                        pin:=pin^.ln_succ;
                  
                      if pin^.ln_succ<>nil then
                        incompletesave:=true;
                        {
                        seterror('Only Two Images Saved In Demo Version.');
                        }
                    end;
                  if oksofar then
                    oksofar:=writecodeinfo(iff);
                  error:=popchunk(iff);
                  if error<>0 then
                    oksofar:=false;
                end
               else
                oksofar:=false;
              closeiff(iff);
            end
           else
            oksofar:=false;
          if not close_(bptr(iff^.iff_stream)) then
            oksofar:=false;
        end
       else
        oksofar:=false;
      freeiff(iff);
    end
   else
    oksofar:=false;
  if oksofar and prefsvalues[7] then
    begin
      dataicon:=getdefdiskobject(wbproject);
      if dataicon<>nil then
        begin
          defaulttool := 'Designer'#0;
          dataicon^.do_defaulttool:=@defaulttool[1];
          if not putdiskobject(@filename[1],dataicon) then
            telluser(mainwindow,'Unable to write icon, file OK though (file name too long ?).');
          freediskobject(dataicon);
        end
       else
        telluser(mainwindow,'Unable to create icon, file OK though, cannot get default icon.');
    end;
  if oksofar then
    begin
      if incompletesave then
        begin
          telluser(mainwindow,'Incomplete save, register for full use.');
        end;
    end
   else
    begin
      telluser(mainwindow,'Unable to save data.');                  
    end;
  writealldata:=oksofar;
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
  ptn:=allocmymem(sizeof(ttextnode),memf_clear or memf_any);
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
  psin:=allocmymem(sizeof(tsmallimagenode),memf_clear or memf_any);
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
              pbbn^.beveltype:=beveltype;
              pbbn^.title:=title;
              pbbn^.ln_name:=@pbbn^.title[1];
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readbevelbox:=oksofar;
end;

function readwindowinfo(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  oksofar  : boolean;
  error    : long;
  twininfo : twindowinfostore;
begin
  for error:=1 to 5 do
    twininfo.localeoptions[error]:=false;
  for error:=1 to 5 do
    twininfo.moretags[error]:=false;
  twininfo.defpubname:=''#0;
  twininfo.moretags[1]:=true;
  twininfo.winparams:=#0;
  for error:=1 to 20 do
    twininfo.extracodeoptions[error]:=false;
  oksofar:=true;
  error:=readchunkbytes(iff,@twininfo,sizeof(twininfo));
  if error>0 then
    begin
      with twininfo do
        begin
          for error:=1 to 5 do
            pdwn^.localeoptions[error]:=twininfo.localeoptions[error];
          copymem(@twininfo.codeoptions,@pdwn^.codeoptions,sizeof(twininfo.codeoptions));            
          pdwn^.codeoptions[15]:=true;
          copymem(@twininfo.extracodeoptions,@pdwn^.extracodeoptions,sizeof(twininfo.extracodeoptions));            
          copymem(@dripens[1],@pdwn^.dripens,20);
          copymem(@moretags,@pdwn^.moretags,sizeof(pdwn^.moretags));
          
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
          pdwn^.menutitle:=menutitle;
          pdwn^.gadgetfontname:=gadgetfontname;
          pdwn^.gadgetfont.ta_ysize:=gadgetfont.ta_ysize;
          pdwn^.gadgetfont.ta_style:=gadgetfont.ta_style;
          pdwn^.gadgetfont.ta_flags:=gadgetfont.ta_flags;
          pdwn^.fontx:=fontx;
          pdwn^.fonty:=fonty;
          pdwn^.winparams:=winparams;
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
  pdwn:=allocmymem(sizeof(tdesignerwindownode),memf_any or memf_clear);
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
  loop    : long;
  pba     : pbytearray;
  tish    : timagestorehead;
  pin     : pimagenode;
  count   : long;
  tempstore : array[1..256] of word;
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
        id_data : if (pin<>nil) then
                    begin
                      error:=readchunkbytes(iff,pin^.imagedata,pin^.sizeallocated);
                      if error<0 then
                        begin
                          oksofar:=false;
                          freemymem(pin^.imagedata,pin^.sizeallocated);
                          freemymem(pin,sizeof(timagenode));
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
                          pin^.mapsize:=count*4;
                          count:=pcn^.cn_size;
                          if count>512 then
                            count:=512;
                          error:=readchunkbytes(iff,@tempstore,count);
                          if error<0 then
                            begin
                              oksofar:=false;
                              freemymem(pin^.colourmap,pin^.mapsize);
                              pin^.colourmap:=nil;
                            end
                           else
                            begin
                              count:=0;
                              pba:=pbytearray(@tempstore);
                              for loop:=0 to (pcn^.cn_size div 3) do
                                begin
                                  pin^.colourmap^[count]:=((pba^[3*loop] and 240) shl 4);
                                  pin^.colourmap^[count]:=pin^.colourmap^[count] or (pba^[3*loop+1] and 240);
                                  pin^.colourmap^[count]:=pin^.colourmap^[count] or ((pba^[3*loop++2] and 240) shr 4);
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
                    pmsi:=allocmymem(sizeof(tmenusubitemnode),memf_any or memf_clear);
                    if pmsi<>nil then
                      begin
                        error:=readchunkbytes(iff,@tsis,sizeof(tsis));
                        if error<0 then oksofar:=false;
                        pmsi^.idlabel:=tsis.idlabel;
                        pmsi^.barlabel:=tsis.barlabel;
                        pmsi^.text:=tsis.text;
                        pmsi^.graphicname:=tsis.graphicname;
                        pmsi^.commkey:=tsis.commkey;
                        pmsi^.disabled:=tsis.disabled;
                        pmsi^.graphic:=nil;
                        pmsi^.checkit:=tsis.checkit;
                        pmsi^.menutoggle:=tsis.menutoggle;
                        pmsi^.checked:=tsis.checked;
                        pmsi^.textprint:=tsis.textprint;
                        pmsi^.graphprint:=not tsis.textprint;
                        pmsi^.ln_name:=@pmsi^.text[1];
                        pmsi^.exclude:=tsis.exclude;
                        addtail(@pmin^.tsubitems,pnode(pmsi));
                        pmsi:=nil;
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
  pmsi         : pmenusubitemnode;
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
                    pmin:=allocmymem(sizeof(tmenuitemnode),memf_any or memf_clear);
                    if pmin<>nil then
                      begin
                        error:=readchunkbytes(iff,@tis,sizeof(tis));
                        if error<0 then oksofar:=false;
                        pmin^.idlabel:=tis.idlabel;
                        pmin^.barlabel:=tis.barlabel;
                        pmin^.text:=tis.text;
                        pmin^.graphic:=nil;
                        pmin^.graphicname:=tis.graphicname;
                        pmin^.commkey:=tis.commkey;
                        pmin^.disabled:=tis.disabled;
                        pmin^.checkit:=tis.checkit;
                        pmin^.menutoggle:=tis.menutoggle;
                        pmin^.checked:=tis.checked;
                        pmin^.textprint:=tis.textprint;
                        pmin^.graphprint:=not tis.textprint;
                        pmin^.ln_name:=@pmin^.text[1];
                        pmin^.exclude:=tis.exclude;
                        pmin^.nextsub:=tis.nextsub;
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
                    pmtn:=allocmymem(sizeof(tmenutitlenode),memf_any or memf_clear);
                    if pmtn<>nil then
                      begin
                        error:=readchunkbytes(iff,@tts,sizeof(tts));
                        if error<0 then oksofar:=false;
                        pmtn^.idlabel:=tts.idlabel;
                        pmtn^.text:=tts.text;
                        pmtn^.disabled:=tts.disabled;
                        pmtn^.ln_name:=@pmtn^.text[1];
                        pmtn^.nextitem:=tts.nextitem;
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
  tms.newlook39:=false;
  tms.localmenu:=false;
  pdmn:=nil;
  currenttitle:=nil;
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
                        pdmn^.ln_type:=menunodetype;
                       {pdmn^.text:=tms.text;}
                        pdmn^.idlabel:=tms.idlabel;
                        pdmn^.frontpen:=tms.frontpen;
                        pdmn^.localmenu:=tms.localmenu;
                        pdmn^.fontname:=tms.fontname;
                        pdmn^.defaultfont:=tms.defaultfont;
                        copymem(@tms.font,@pdmn^.font,sizeof(pdmn^.font));
                        pdmn^.font.ta_name:=@pdmn^.fontname[1];
                        pdmn^.ln_name:=@pdmn^.idlabel[1];
                        pdmn^.nexttitle:=tms.nexttitle;
                        newlist(@pdmn^.tmenulist);
                        addtail(menulist,pnode(pdmn));
                        pdmn^.newlook39:=tms.newlook39;
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

function readlocale(iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  done    : boolean;
  pcn     : pcontextnode;
  tlns    : tlocalenodestore;
  pln     : plocalenode;
begin
  readlocalestuff:=true;
  oksofar:=true;
  error:=readchunkbytes(iff,@readlocaledata,sizeof(readlocaledata));
  newlist(@readlocalelist);
  if error<0 then
    oksofar:=false;
  if oksofar then
  while readlocaledata.numberofnodes>0 do
    begin
      error:=parseiff(iff,iffparse_rawstep);
      if (error=ifferr_eoc)or(error=0) then
        begin
          pcn:=currentchunk(iff);
          if (pcn^.cn_type=id_loca) and 
             (pcn^.cn_id=id_loci) and
             (error=0) then
            begin
              dec(readlocaledata.numberofnodes);
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



function readallcode(iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  done    : boolean;
  pcn     : pcontextnode;
begin
  readcodestore.fileversion:=0;
  oksofar:=true;
  readcodestore.includeextra:=#0;
  error:=readchunkbytes(iff,@readcodestore,sizeof(readcodestore));
  if error<0 then
    oksofar:=false;
  if (readcodestore.fileversion>SaveFileVersion) then
    begin
      oksofar:=false;
      telluser(mainwindow,'Designer file later version than The Designer.');
    end;
  readallcode:=oksofar;
end;

function readalldata(filename : string; clearold : boolean):boolean;
var
  iff      : piffhandle;
  psn      : pstringnode;
  error    : long;
  oksofar  : boolean;
  pdwn     : pdesignerwindownode;
  pdwn2    : pdesignerwindownode;
  pin      : pimagenode;
  pcn      : pcontextnode;
  done     : boolean;
  winlist  : tlist;
  pgn      : pgadgetnode;
  tgs      : tgadgetstore;
  twininfo : twindowinfostore;
  imagelist: tlist;
  pin2     : pimagenode;
  psin     : psmallimagenode;
  realfile : boolean;
  menulist : tlist;
  pdmn     : pdesignermenunode;
  pmtn     : pmenutitlenode;
  pmin     : pmenuitemnode;
  pmsi     : pmenusubitemnode;
  loop     : word;
  pln      : plibnode;
  pn       : pnode;
  pdsn     : pdesignerscreennode;
  screenlist : tlist;
  pdsn2    : pdesignerscreennode;
  pmt      : pmytag;
  pgn2     : pgadgetnode;
begin
  readcodestore.fileversion:=0;
  realfile:=false;
  newlist(@winlist);
  newlist(@imagelist);
  newlist(@menulist);
  newlist(@screenlist);
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
      FreeIFF(iff);
    end
   else
    oksofar:=false;
  if not oksofar then
    if not (savefileversion<readcodestore.fileversion) then
      telluser(mainwindow,'Unable to load file.');
  if realfile then
    begin
      if clearold then
        begin
          pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
          if oksofar then
            while(pdwn^.ln_succ<>nil) do
              begin
                pdwn2:=pdwn^.ln_succ;
                remove(pnode(pdwn));
                deletedesignerwindow(pdwn);
                pdwn:=pdwn2;
              end;
          pin:=pimagenode(teditimagelist.lh_head);
          if oksofar then
            while(pin^.ln_succ<>nil) do
              begin
                pin2:=pin^.ln_succ;
                remove(pnode(pin));
                deleteimagenode(pin);
                pin:=pin2;
              end;
          pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
          if oksofar then
            while (pdsn^.ln_succ<>nil) do
              begin
                pdsn2:=pdsn^.ln_succ;
                handledeletescreennode(pdsn);
                pdsn:=pdsn2;
              end;
        end;
      
      pdsn:=pdesignerscreennode(screenlist.lh_head);
      if oksofar then
        while (pdsn^.ln_succ<>nil) do
          begin
            pdsn2:=pdsn^.ln_succ;
            remove(pnode(pdsn));
            if oksofar then
              begin
                addtail(@teditscreenlist,pnode(pdsn));
                if cyclepos=3 then
                  begin
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_labels,~0);
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_labels,long(@teditscreenlist));
                    gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_selected,~0);
                    mainselected:=~0;
                  end;
              end
             else
              begin
                if pdsn^.colorarray<>nil then
                  freemymem(pdsn^.colorarray,pdsn^.sizecolorarray);
                freemymem(pdsn,sizeof(tdesignerscreennode));
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
                freemymem(pin^.imagedata,pin^.sizeallocated);
              if pin^.colourmap<>nil then
                freemymem(pin^.colourmap,pin^.mapsize);
              freemymem(pin,sizeof(timagenode));
            end;
          pin:=pin2;
        end;
      if oksofar and clearold then
        pdmn:=pdesignermenunode(remhead(@teditmenulist));
      if oksofar and clearold then
        while (pdmn<>nil) do
          begin
            deletedesignermenunode(pdmn);
            pdmn:=pdesignermenunode(remhead(@teditmenulist));
            if cyclepos=1 then
              begin
                gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_labels,~0);
                gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_labels,long(@teditmenulist));
                gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                   gtlv_selected,~0);
                mainselected:=~0;
              end;
          end;
      pdmn:=pdesignermenunode(remhead(@menulist));
      while(pdmn<>nil) do
        begin
          addtail(@teditmenulist,pnode(pdmn));
          if not oksofar then
            deletedesignermenunode(pdmn)
           else
            begin
              pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
              while (pmtn^.ln_succ<>nil) do
                begin
                  pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
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
                      pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
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
          if cyclepos=1 then
            begin
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                 gtlv_labels,~0);
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                 gtlv_labels,long(@teditmenulist));
              gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                 gtlv_selected,~0);
              mainselected:=~0;
            end;
        end;      
      pdwn:=pdesignerwindownode(winlist.lh_head);
      while(pdwn^.ln_succ<>nil) do
        begin
          pdwn2:=pdwn^.ln_succ;
          remove(pnode(pdwn));
          pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
          while(pgn^.ln_succ<>nil) do
            begin
              if pgn^.kind=mybool_kind then
                freelist(@pgn^.infolist,sizeof(tstringnode));
              pgn:=pgn^.ln_succ;
            end;
          if oksofar then
            begin
              pdwn^.pdmn:=nil;
              addtail(@teditwindowlist,pnode(pdwn));
              if pdwn^.menutitle<>'' then
                begin
                  pdmn:=pdesignermenunode(teditmenulist.lh_head);
                  while (pdmn^.ln_succ<>nil) do
                    begin
                      if pdmn^.idlabel=pdwn^.menutitle then
                        pdwn^.pdmn:=pdmn;
                      pdmn:=pdmn^.ln_succ;
                    end; 
                end;
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
              
              pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
              while(pgn^.ln_succ<>nil)do
                begin
                  
                  
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
                          
                          fixmytagdatapointers(pmt);
                          
                          pmt:=pmt^.ln_succ;
                        end;
                    end;
                  
                  
                  
                  pgn:=pgn^.ln_succ;
                end;
              
            end
           else
            begin
              freelist(@pdwn^.bevelboxlist,sizeof(tbevelboxnode));
              pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
              while(pgn<>nil)do
                begin
                  freegadgetnode(pdwn,pgn);
                  pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
                end;
              freelist(@pdwn^.textlist,sizeof(ttextnode));
              freelist(@pdwn^.imagelist,sizeof(tsmallimagenode));
              freemymem(pdwn,sizeof(tdesignerwindownode));
            end;
          pdwn:=pdwn2;
        end;
      if oksofar and readlocalestuff then
        begin
          if clearold then
            freelist(@tlocalelist,sizeof(tlocalenode));
          pn:=remhead(@readlocalelist);
          while(pn<>nil)do
            begin
              addtail(@tlocalelist,pn);
              pn:=remhead(@readlocalelist);
            end;
          if clearold then
            begin
              builtinlanguage:=readlocaledata.tbuiltinlanguage;
              getstring:=readlocaledata.tgetstring;
              version:=readlocaledata.tversion;
              basename:=readlocaledata.tbasename;
            end;
        end;
      if oksofar and clearold then
        begin
          copymem(@readcodestore.procedureoptions,@procedureoptions,sizeof(procedureoptions));
          copymem(@readcodestore.codeoptions,@codeoptions,sizeof(codeoptions));
          globalincludeextra:=readcodestore.includeextra;
          loop:=1;
          pln:=plibnode(tliblist.lh_head);
          while (pln^.ln_succ<>nil) do
            begin
              pln^.open:=readcodestore.openlibs[loop];
              pln^.version:=readcodestore.versionlibs[loop];
              pln^.abortonfail:=readcodestore.abortonfaillibs[loop];
              if (0=readcodestore.fileversion) and (loop=23) then
                begin
                  pln^.open:=true;
                  pln^.version:=38;
                  pln^.abortonfail:=false;
                end;
              inc(loop);
              pln:=pln^.ln_succ;
            end;
          loop:=0;
          presentcompiler:=~0;
          psn:=pstringnode(compilerlist.lh_head);
          while (psn^.ln_succ<>nil) do
            begin
              if upstring(no0(psn^.st))=upstring(readcodestore.compilername) then
                presentcompiler:=loop;
              inc(loop);
              psn:=psn^.ln_succ
            end;
        end;
    end;
  readalldata:=oksofar;
end;

begin
  readlocalestuff:=false;
  newlist(@readlocalelist);
end.