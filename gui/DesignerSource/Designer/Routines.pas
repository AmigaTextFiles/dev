unit routines;

interface

uses designermenus,utility,layers,gadtools,exec,intuition,dos,
     amigados,graphics,definitions,iffparse,amiga,obsolete,modeid,
     asl,workbench,diskfont;

procedure telluser(pwin:pwindow;tf:string);
procedure replaceimage(oldpin : pimagenode);
function createliblist:boolean;
function duplicate(n : word;c:char):string;
procedure freelist(pl:plist;si:long);
procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);
function getnthnode(ph:plist;n:word):pnode;
procedure setupnewmenu(pnm:pnewmenu;ty:byte;labl:strptr;commke:strptr;flags:word;me:longint;ud:pointer);
procedure settagitem(pt :ptagitem;t,d:long);
procedure printstring(pwin:pwindow;x,y:word;s:string;n,m:byte;font:pointer);
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
procedure stripintuimessages(mp:pmsgport;win:pwindow);
function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long):pwindow;
procedure closewindowsafely(win : pwindow);
procedure writelibdata(pln:plibnode);
procedure readlibdata(pln:plibnode);
procedure freemymem(mem:pointer;size:long);
function allocmymem(size:long;typ:long):pointer;
procedure setdefaultwindow(pdwn:pdesignerwindownode);
procedure updatewindowsizes(pdwn : pdesignerwindownode);
procedure drawbox(pdwn:pdesignerwindownode);
function checkedbox(pgad:pgadget):boolean;
function getstringfromgad(pgad:pgadget):string;
function getintegerfromgad(pgad:pgadget):long;
{
procedure setupoptionswindowborders(pdwn:pdesignerwindownode;screendrawinfo:pdrawinfo);
}
function togglegad(x,y,id:word;
                   ptxt:pbyte;
                   pprevgad:pgadget;
                   pdwn:pdesignerwindownode
                  ):pgadget;
procedure highlightgadget(pgn:pgadgetnode;pdwn:pdesignerwindownode);
procedure drawhighbox(x,y,w,h:word;pwin:pwindow);
procedure checkgadsize(pdwn:pdesignerwindownode;pgn:pgadgetnode);
function setimagedata(var ti : timage;p:pointer;ty:byte):boolean;
function readiffimage(pb : pbyte):pimagenode;
procedure waiteverything;
procedure unwaiteverything;
procedure openafewimages;
function allocasls:boolean;
procedure freeasls;
procedure openimagedisplaywindow(pin:pimagenode;pscr:pscreen;pdwn:pdesignerwindownode);
procedure closeimagedisplaywindow(pin:pimagenode);
procedure checkimagenodegadget(pin:pimagenode;gid:word);
procedure newimagenodewindowsize(pin:pimagenode);
procedure puttextintextlistwindow(pdwn:pdesignerwindownode;ptn:ptextnode);
procedure setalltextlistwindowgadgets(pdwn:pdesignerwindownode);
procedure readalltextlistwindowgadgets(pdwn:pdesignerwindownode);
procedure enableselectontextlistwindow(pdwn:pdesignerwindownode);
procedure disableselectontextlistwindow(pdwn:pdesignerwindownode);
procedure quickputtext(pdwn:pdesignerwindownode);
procedure quickputimage(pdwn:pdesignerwindownode);
procedure setallimagelistwindowgadgets(pdwn:pdesignerwindownode);
procedure readallimagelistwindowgadgets(pdwn:pdesignerwindownode);
procedure enableselectonimagelistwindow(pdwn:pdesignerwindownode);
procedure disableselectonimagelistwindow(pdwn:pdesignerwindownode);
procedure settagswindowgadgets(pdwn:pdesignerwindownode);
procedure readtagswindowgadgets(pdwn:pdesignerwindownode);
procedure seterror(s:string);
procedure clearerror;
procedure deleteimagenode(pin:pimagenode);
function screenrequester(pscr : pscreen;pprefs : pscreenmodeprefs):boolean;
procedure readdefaultscreenmode;
procedure gadgetfont(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure togglecheckbox(pgad:pgadget;pwin:pwindow);
procedure newgadnode(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure spreadhighgadgets(pdwn:pdesignerwindownode);
function createnewdesignermenunode:pdesignermenunode;
function createnewmenutitle(place : byte;pdmn:pdesignermenunode):pmenutitlenode;
function createnewmenuitemnode(place : byte;pmtn:pmenutitlenode):pmenuitemnode;
function getlistpos(pl:plist;pn:pnode):long;
function sizeoflist(pl:plist):long;
function createnewmenusubitemnode(place : byte;pmin:pmenuitemnode):pmenusubitemnode;
procedure testmenu(pdmn:pdesignermenunode);
procedure setwindowcodewindowgadgets(pdwn:pdesignerwindownode);
procedure getwindowcodewindowgadgets(pdwn:pdesignerwindownode);
function no0(s:string):string;
procedure makecompilerlist(lo : bptr);
function areyousure(pwin:pwindow;tf:string):boolean;
procedure setinputglist(pdwn:pdesignerwindownode);
procedure clearinputglist(pdwn:pdesignerwindownode);
function upstring(s:string):string;
procedure startshiftselect(pdwn:pdesignerwindownode;messcopy:tintuimessage);
procedure fixgadgetnumbers(pdwn:pdesignerwindownode);
procedure changegaddybitty(pdwn:pdesignerwindownode;num:word);
function demoversion:boolean;
{
function checkprint(pscr : pscreen):boolean;
}
function checkprotection:boolean;


procedure freemyfullbitmap(pbm : pbitmap;w,h,d:word);
function allocatemyfullbitmap(w,h,depth:word):pbitmap;
procedure multiplesizedraw(pdwn: pdesignerwindownode);
function addgetfileimage(t:byte):pimagenode;
procedure freemytag(pmt:pmytag);

var
  waiting : boolean;

implementation

procedure freemytag(pmt:pmytag);
begin
  if pmt<>nil then
    begin
      if (pmt^.data<>nil) and (pmt^.sizebuffer>0) then
        freemymem(pmt^.data,pmt^.sizebuffer);
      freemymem(pmt,sizeof(tmytag));
    end;
end;

function addgetfileimage(t:byte):pimagenode;
var
  pin : pimagenode;
  pin2: pimagenode;
begin
  pin:=nil;
  pin2:=pointer(teditimagelist.lh_head);
  while(pin2^.ln_succ<>nil) do
    begin
      if (pin2^.title='GetFileUp'#0)and(t=0) then
        pin:=pin2;
      if (pin2^.title='GetFileDown'#0)and(t<>0) then
        pin:=pin2;
      pin2:=pin2^.ln_succ;
    end;
  if pin=nil then
    begin
      pin:=allocmymem(sizeof(timagenode),memf_clear);
      if pin<>nil then
        begin
          if t=0 then
            pin^.title:='GetFileUp'#0
           else
            pin^.title:='GetFileDown'#0;
          pin^.ln_name:=@pin^.title[1];
          pin^.imagedata:=allocmymem(112,memf_chip);
          if pin^.imagedata<>nil then
            begin
              pin^.sizeallocated:=112;
              pin^.depth:=2;
              pin^.width:=20;
              pin^.height:=14;
              pin^.planepick:=3;
              
              pin^.leftedge:=0;
              pin^.topedge:=0;
              
              if t=0 then
                copymem(@getfiledata1,pin^.imagedata,112)
               else
                copymem(@getfiledata2,pin^.imagedata,112);
              
              pin^.ln_type:=imagenodetype;
              
              addtail(@teditimagelist,pnode(pin));
              if cyclepos=2 then
                begin
                  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
                  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
                  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                  mainselected:=~0;
                end;
            end
           else
            begin
              telluser(mainwindow,memerror);
              freemymem(pin,sizeof(timagenode));
            end;
        end
       else
        telluser(mainwindow,memerror);
    end;
  addgetfileimage:=pin;
end;

procedure multiplesizedraw(pdwn: pdesignerwindownode);
var
  loop : byte;
  pgn : pgadgetnode;
begin
  for loop:=1 to 4 do
    boxold[loop]:=box[loop];
                           
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if (pgn<>sgad) and(pgn^.quicksize) then
        begin
          box[1]:=boxold[1]-sgad^.x+pgn^.x;
          box[3]:=boxold[3]-sgad^.x+pgn^.x;
          box[2]:=boxold[2]-sgad^.y+pgn^.y;
          box[4]:=boxold[4]-sgad^.y+pgn^.y;
          drawbox(pdwn);
        end;
      pgn:=pgn^.ln_succ;
    end;
  for loop:=1 to 4 do
    box[loop]:=boxold[loop];
end;


procedure freemyfullbitmap(pbm : pbitmap;w,h,d:word);
var
  loop : word;
begin
  for loop:= 0 to d-1 do
    begin
      
      if pbm^.planes[loop]<>nil then
        freeraster(pbm^.planes[loop],w,h);
      
    end;
  freemymem(pbm,sizeof(tbitmap));
end;

function allocatemyfullbitmap(w,h,depth:word):pbitmap;
var
  loop : word;
  pbm  : pbitmap;						
  failed : boolean;
begin
  failed:=false;
  pbm:=allocmymem(sizeof(tbitmap),memf_chip or memf_clear);
  if pbm<>nil then
    begin
      initbitmap(pbm,depth,w,h);
      for loop:=0 to depth-1 do
        begin
          pbm^.planes[loop] := pointer(AllocRaster(w,h));
          if pbm^.planes[loop]=nil then
            failed:=true;
        end;
      if failed then
        begin
          freemyfullbitmap(pbm,w,h,depth);
          pbm:=nil;
        end;
    end;
  allocatemyfullbitmap:=pbm;
end;


{
function checkprint(pscr : pscreen):boolean;
const
  mytitle : string[20] = 'Select Print File'#0;
var
  pdone  : boolean;
  pmsg   : pintuimessage;
  temp   : string;
  temps1 : string;
  temps2 : string;
  code   : word;
  class  : long;
  pdummy : long;
  pgsel  : pgadget;
  tags   : array[1..6] of ttagitem;
  d      : dirstr;
  n      : namestr;
  e      : extstr;
  fr     : pfilerequester;
begin
  checkprint:=false;
  waiteverything;
  if openwindowtheprintwindow(pscr) then
    begin
      gt_setsinglegadgetattr(theprintwindowgads[theprintwindowstring],theprintwindow,
                        gtst_string,long(@printfile[1]));
      pdone:=false;
      repeat
        pdummy:=wait(bitmask(theprintwindow^.userport^.mp_sigbit));
        pmsg:=gt_getimsg(theprintwindow^.userport);
        while (pmsg<>nil) do
          begin
            pdummy:=999;
            class:=pmsg^.class;
            code:=pmsg^.code;
            pgsel:=pgadget(pmsg^.iaddress);
            gt_replyimsg(pmsg);
            case class of
              idcmp_closewindow :
                pdone:=true;
              idcmp_gadgetup :
                pdummy:=pgsel^.gadgetid;
              idcmp_vanillakey :
                case upcase(chr(code)) of
                  'P' : pdummy:=theprintwindowprint;
                  'C' : pdummy:=theprintwindowcancel;
                  'F' : pdummy:=theprintwindowfile;
                 end;
             end;
            case pdummy of
              theprintwindowfile   :
                begin
                  setpointer(theprintwindow,pwaitpointer,16,16,-6,0);
                  temp:=no0(printfile);
                  if upstring(temp)='PRT:' then
                    temp:='';
                  fsplit(temp,d,n,e);
                  temps1:=d+#0;
                  temps2:=n+e+#0;
                  settagitem(@tags[1],asl_hail,long(@mytitle[1]));
                  settagitem(@tags[2],asl_dir,long(@temps1[1]));
                  settagitem(@tags[3],asl_file,long(@temps2[1]));
                  settagitem(@tags[4],tag_done,0);
                  fr:=allocaslrequest(asl_filerequest,@tags[1]);
                  if fr<>nil then
                    begin
                      if aslrequest(fr,nil) then
                        begin
                          ctopas(fr^.rf_dir^,temps1);
                          ctopas(fr^.rf_file^,temps2);
                          if temps1<>'' then
                            if (temps1[length(temps1)]<>':') and (temps1[length(temps1)]<>'/') then
                              temps1:=temps1+'/';
                          printfile:=temps1+temps2+#0;
                          if printfile=#0 then
                            printfile:='PRT:'#0;
                          gt_setsinglegadgetattr(theprintwindowgads[theprintwindowstring],theprintwindow,
                            gtst_string,long(@printfile[1]));
                        end;
                      freeaslrequest(fr);
                    end;
                  clearpointer(theprintwindow);
                end;
              theprintwindowprint  :
                begin
                  printfile:=getstringfromgad(theprintwindowgads[theprintwindowstring]);
                  pdone:=true;
                  checkprint:=true;
                end;
              theprintwindowcancel :
                pdone:=true;
             end;
            pmsg:=gt_getimsg(theprintwindow^.userport);
          end;
      until pdone;
      closewindowtheprintwindow;
    end
   else
    telluser('Cannot open print window.');
  unwaiteverything;
  inputmode:=1;
end;
}
procedure changegaddybitty(pdwn:pdesignerwindownode;num:word);
var
  oldpos : long;
  gad    : pgadget;
  pos    : long;
begin
  oldpos:=removegadget(pdwn^.optionswindow,pdwn^.optionswingads[pdwn^.mxchoice+10]);
  gad:=pdwn^.optionswingads[pdwn^.mxchoice+10];
  if oldpos<>-1 then
    begin
      pdwn^.optionswingads[pdwn^.mxchoice+10]^.flags:=
          pdwn^.optionswingads[pdwn^.mxchoice+10]^.flags and ~gflg_selected;
      pdwn^.optionswingads[pdwn^.mxchoice+10]^.gadgettext^.frontpen:=1;
      oldpos:=addgadget(pdwn^.optionswindow,pdwn^.optionswingads[pdwn^.mxchoice+10],65534);
      
      if pdwn^.mxchoice=12 then
        begin
          {  remove bevel list }
          if pdwn^.bevelglist<>nil then
            begin
              pos:=removeglist(pdwn^.editwindow,pdwn^.bevelglist,~0);
              pos:=addglist(pdwn^.editwindow,pdwn^.glist,65535,~0,Nil);
              refreshglist(pdwn^.glist,pdwn^.editwindow,nil,~0)
            end;
        end;
                             
      { old changed back }
      pdwn^.mxchoice:=num;
      oldpos:=removegadget(pdwn^.optionswindow,pdwn^.optionswingads[pdwn^.mxchoice+10]);
      if oldpos<>-1 then
        begin
          pdwn^.optionswingads[pdwn^.mxchoice+10]^.flags:=
              pdwn^.optionswingads[pdwn^.mxchoice+10]^.flags or gflg_selected;
          pdwn^.optionswingads[pdwn^.mxchoice+10]^.gadgettext^.frontpen:=2;
          oldpos:=addgadget(pdwn^.optionswindow,pdwn^.optionswingads[pdwn^.mxchoice+10],65534);
          refreshgadgets(gad,pdwn^.optionswindow,nil);
          if pdwn^.mxchoice=12 then
            begin
              { put bevel list }
              if pdwn^.bevelglist<>nil then
                begin
                  pos:=removeglist(pdwn^.editwindow,pdwn^.glist,~0);
                  pos:=addglist(pdwn^.editwindow,pdwn^.bevelglist,65535,~0,Nil);
                end;
            end;
        end
       else
        telluser(pdwn^.optionswindow,'Big problem.');
    end
   else
    telluser(pdwn^.optionswindow,'Big problem.');
end;

procedure fixgadgetnumbers(pdwn);
var
  pgn,pgn2,pgn3  : pgadgetnode;
  loop : long;
  s    : string[20];
  pmt  : pmytag;
begin
  if pdwn^.gadgetlistwindow<>nil then
    begin
      pdwn^.nextid:=getintegerfromgad(pdwn^.gadgetlistwindowgads[1]);
    end;
  loop:=pdwn^.nextid;
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      if pgn^.labelid=#0#0#0 then
        begin
          str(loop,s);
          pgn^.labelid:=no0(pdwn^.labelid)+'_Gad'+s+#0;
        end;
      pgn^.id:=loop;
      if pgn^.pg<>nil then
        pgn^.pg^.gadgetid:=loop;
      inc(loop);
      pgn:=pgn^.ln_succ;
    end;
  if pdwn^.gadgetlistwindow<>nil then
    begin
      gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                     gtlv_labels,~0);
      gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                     gtlv_labels,long(@pdwn^.gadgetlist));
      gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                     gtlv_selected,~0);
      pdwn^.gadselected:=~0;
    end;
  
  
  pgn3:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn3^.ln_succ<>nil) do
    begin
      if pgn3^.kind = myobject_kind then
        begin
          if pgn3^.editwindow<>nil then
            begin
              pmt:=pmytag(pgn3^.editwindow^.editlist.lh_head);
              while(pmt^.ln_succ<>nil) do
                begin
                  if pmt^.tagtype=tagtypeobject then
                    begin
                      if pgn3^.editwindow^.data4=getlistpos(@pgn3^.editwindow^.editlist,pnode(pmt)) then
                        begin
                          if pmt^.data=nil then
                            pgn3^.editwindow^.data2:=~0
                           else
                            pgn3^.editwindow^.data2:=getlistpos(@pdwn^.gadgetlist,pmt^.data);
                          gt_setsinglegadgetattr(pgn3^.editwindow^.gads[20],pgn3^.editwindow^.pwin,
                                         gtlv_labels,~0);
                          gt_setsinglegadgetattr(pgn3^.editwindow^.gads[20],pgn3^.editwindow^.pwin,
                                         gtlv_labels,long(@pdwn^.gadgetlist));
                          gt_setsinglegadgetattr(pgn3^.editwindow^.gads[20],pgn3^.editwindow^.pwin,
                                         gtlv_selected,pgn3^.editwindow^.data2);
                        end;
                    
                    end;
                  pmt:=pmt^.ln_succ;
                end;
              end;
        end;
      pgn3:=pgn3^.ln_succ;
    end;
end;

procedure startshiftselect(pdwn:pdesignerwindownode;messcopy:tintuimessage);
begin
  setdrpt(pdwn^.editwindow^.rport,$FF);
  setdrmd(pdwn^.editwindow^.rport,complement);
  drawbitty:=$FF;
  inputmode:=157;
  box[1]:=messcopy.mousex;
  box[2]:=messcopy.mousey;
  box[3]:=box[1];
  box[4]:=box[2];
  drawbox(pdwn);
  forbid;
  pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags or wflg_rmbtrap;       
  permit;
end;

function upstring(s:string):string;
var
  s2   : string;
  loop : byte;
begin
  loop:=1;
  s2:='';
  while (loop<=length(s)) do
    begin
      s2:=s2+upcase(s[loop]);
      inc(loop);
    end;
  upstring:=s2;
end;

procedure setinputglist(pdwn:pdesignewindownode);
var
  pos : long;
begin
  if pdwn^.inputglist<>nil then
    if pdwn^.editwindow<>nil then
      begin
        if pdwn^.mxchoice<>12 then
          pos:=removeglist(pdwn^.editwindow,pdwn^.glist,~0)
         else
          pos:=removeglist(pdwn^.editwindow,pdwn^.bevelglist,~0);
        pos:=addglist(pdwn^.editwindow,pdwn^.inputglist,65535,~0,Nil);
        pdwn^.inputmodeb:=true;
      end;
  if pdwn^.editwindow<>nil then
    begin
      forbid;
      pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags or wflg_rmbtrap;       
      permit;
    end;
end;

procedure clearinputglist(pdwn:pdesignerwindownode);
var
  pos : long;
begin
  if pdwn^.inputglist<>nil then
    if pdwn^.editwindow<>nil then
      if pdwn^.inputmodeb then
        begin
          pdwn^.inputmodeb:=false;
          pos:=removeglist(pdwn^.editwindow,pdwn^.inputglist,~0);
          if pdwn^.mxchoice<>12 then
            pos:=addglist(pdwn^.editwindow,pdwn^.glist,65535,~0,Nil)
           else
            pos:=addglist(pdwn^.editwindow,pdwn^.bevelglist,65535,~0,Nil);
          if not updateeditwindow then
            refreshglist(pdwn^.glist,pdwn^.editwindow,nil,~0);
          forbid;
          pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags or wflg_rmbtrap;
          permit;
        end;
  if pdwn^.editwindow<>nil then
    begin
      forbid;
      pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
      permit;
    end;
end;

function areyousure(pwin:pwindow;tf:string):boolean;
var
  teasy : teasystruct;
  gf    : String;
  title : string;
begin
  
  inputmode:=1;
  tf:=tf+#0;
  waiteverything;
  gf:='Yes|No'#0;
  title:='Designer Request'#0;
  with teasy do
    begin
      es_structsize:=sizeof(teasy);
      es_flags:=0;
      es_title:=@title[1];
      es_textformat:=@tf[1];
      es_gadgetformat:=@gf[1];
    end;
  areyousure:=(1=easyrequestargs(pwin,@teasy,nil,nil));
  unwaiteverything;
  
end;

procedure telluser(pwin:pwindow;tf:string);
var
  teasy : teasystruct;
  gf    : String;
  title : string;
  res   : long;
  temp  : boolean;
begin
  if not Prefsvalues[16] then
    begin
      temp:=waiting;
      messagedone:=true;
      if not temp then
        begin
          inputmode:=1;  
          waiteverything;
        end;
      gf:='OK'#0;
      tf:=tf+#0;
      title:='Designer Message'#0;
      with teasy do
        begin
          es_structsize:=sizeof(teasy);
          es_flags:=0;
          es_title:=@title[1];
          es_textformat:=@tf[1];
          es_gadgetformat:=@gf[1];
        end;
      res := easyrequestargs(pwin,@teasy,nil,nil);
      if not temp then
        unwaiteverything;
      waiting:=temp; 
    end
   else
    seterror(tf);
end;

procedure makecompilerlist(lo:bptr);
var
  buffer   : array[1..256] of char;
  psn      : pstringnode;
  mylock   : bptr;
  pfib     : pfileinfoblock;
  success  : boolean;
  name     : string;
  name2    : string;
  loop     : word;
  pap      : panchorpath;
  curdir   : BPTR;
  error    : long;
begin
  curdir:=currentdir(lo);
  pap:=allocmymem(sizeof(tanchorpath),memf_clear);
  if pap<>nil then
    begin
      name2:='#?producer'#0;
      error:=matchfirst(@name2[1],pap);
      while (error=0) do
        begin
          if pap^.ap_info.fib_direntrytype<0 then
            begin
              psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_any);
              if psn<>nil then
                begin
                  ctopas(pap^.ap_info.fib_filename,name);
                  psn^.ln_name:=@psn^.st[1];
                  psn^.st:=name+#0;
                  addtail(@compilerlist,pnode(psn));
                end
               else
                telluser(nil,'No memory at this point is a bad omen for the future.');
            end;
          error:=matchnext(pap);
        end;
      matchend(pap);
      freemymem(pap,sizeof(tanchorpath));
    end
   else
    telluser(nil,memerror);
  curdir:=currentdir(curdir);
end;

function no0(s:string):string;
var
  str : string;
begin
  str:=s;
  while (str[length(str)]=#0)and(length(str)>0) do
    dec(str[0]);
  no0:=str;
end;

procedure getwindowcodewindowgadgets(pdwn:pdesignerwindownode);
var
  loop  : byte;
  pdmn  : pdesignermenunode;
begin
  pdwn^.winparams:=getstringfromgad(pdwn^.codegadgets[26]);
  for loop:=1 to 19 do
    if loop<>15 then
      pdwn^.codeoptions[loop]:=checkedbox(pdwn^.codegadgets[loop]);
  for loop:=1 to 4 do
    pdwn^.localeoptions[loop]:=checkedbox(pdwn^.localegads[loop]);
  pdwn^.extracodeoptions[1]:=checkedbox(pdwn^.codegadgets[27]);
  pdwn^.extracodeoptions[2]:=checkedbox(pdwn^.codegadgets[28]);
  loop:=0;
  pdwn^.pdmn:=nil;
  pdwn^.codeoptions[11]:=false;
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while(pdmn^.ln_succ<>nil) do
    begin
      if pdwn^.codeselected=loop then
        begin
          pdwn^.pdmn:=pdmn;
          pdwn^.codeoptions[11]:=true;
        end;
      inc(loop);
      pdmn:=pdmn^.ln_succ;
    end;
end;

procedure setwindowcodewindowgadgets(pdwn:pdesignerwindownode);
var
  loop : byte;
  pdmn : pdesignermenunode;
begin
  pdwn^.codeselected:=~0;
  gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,gtlv_labels,long(@teditmenulist));
  if pdwn^.codeoptions[11] then
    begin
      loop:=0;
      pdmn:=pdesignermenunode(teditmenulist.lh_head);
      while(pdmn^.ln_succ<>nil) do
        begin
          if pdmn=pdwn^.pdmn then
            pdwn^.codeselected:=loop;
          inc(loop);
          pdmn:=pdmn^.ln_succ;
        end;
    end;
  gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,gtlv_selected,pdwn^.codeselected);
  gt_setsinglegadgetattr(pdwn^.codegadgets[26],pdwn^.codewindow,gtst_string,long(@pdwn^.winparams[1]));
  gt_setsinglegadgetattr(pdwn^.codegadgets[27],pdwn^.codewindow,gtcb_checked,long(pdwn^.extracodeoptions[1]));
  gt_setsinglegadgetattr(pdwn^.codegadgets[28],pdwn^.codewindow,gtcb_checked,long(pdwn^.extracodeoptions[2]));
  for loop:=1 to 4 do
    gt_setsinglegadgetattr(pdwn^.localegads[loop],pdwn^.codewindow,gtcb_checked,long(pdwn^.localeoptions[loop]));
  for loop:=1 to 19 do
    if loop<>15 then
      gt_setsinglegadgetattr(pdwn^.codegadgets[loop],pdwn^.codewindow,gtcb_checked,long(pdwn^.codeoptions[loop]));
end;

procedure testmenu(pdmn:pdesignermenunode);
type
  pnewmenuarray = ^tnewmenuarray;
  tnewmenuarray = array[0..1000000] of tnewmenu;
var
  pmtn   : pmenutitlenode;
  pmin   : pmenuitemnode;
  pmsi   : pmenusubitemnode;
  count  : long;
  pn     : pnewmenuarray;
  count2 : long;
  tags   : array[1..3] of ttagitem;
begin
  waiteverything;
  count:=0;
  count2:=0;
  if pdmn^.testmenu<>nil then
    freemenus(pdmn^.testmenu);
  pdmn^.inusefontname:=pdmn^.fontname+#0;
  pdmn^.inusetextattr.ta_name:=@pdmn^.inusefontname[1];
  pdmn^.inusetextattr.ta_ysize:=pdmn^.font.ta_ysize;
  pdmn^.inusetextattr.ta_style:=pdmn^.font.ta_style;
  pdmn^.inusetextattr.ta_flags:=pdmn^.font.ta_flags;
  {
  loop through titles
    write title
    loop through items
      if nosubs
        write item
       else
        loop through subs
          write subs
  }
  pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      inc(count);
      pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
      while (pmin^.ln_succ<>nil) do
        begin
          inc(count);
          pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
          while (pmsi^.ln_succ<>nil) do
            begin
              inc(count);
              pmsi:=pmsi^.ln_succ;
            end;
          pmin:=pmin^.ln_succ;
        end;
      pmtn:=pmtn^.ln_succ;
    end;
  pn:=allocmymem((1+count)*sizeof(tnewmenu),memf_any or memf_clear);
  if pn=nil then
    telluser(mainwindow,memerror);
  pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
  if pn<>nil then
   while (pmtn^.ln_succ<>nil) do
     begin
        with pn^[count2] do
          begin
            nm_type:=nm_title;
            pmtn^.displaytext:=pmtn^.text;
            nm_label:=@pmtn^.displaytext[1];
            nm_commkey:=nil;
            if pmtn^.disabled then
              nm_flags:=nm_flags or nm_menudisabled;
            nm_mutualexclude:=0;
            nm_userdata:=nil;
          end;
        inc(count2);
        pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
        while (pmin^.ln_succ<>nil) do
          begin
            with pn^[count2] do
              begin
                if pmin^.barlabel then
                  begin
                    nm_label:=pointer(nm_barlabel);
                    nm_type:=nm_item;
                  end
                 else
                  begin
                    if (pmin^.graphic<>nil) then
                      begin
                        nm_type:=im_item;
                        nm_label:=pointer(@pmin^.graphic^.leftedge);
                      end
                     else
                      begin
                        pmin^.displaytext:=pmin^.text;
                        nm_label:=@pmin^.displaytext[1];
                        nm_type:=nm_item
                      end;
                  end;
                nm_commkey:=nil;
                if (pmin^.commkey<>#0)and(not pmin^.barlabel) then
                  nm_commkey:=@pmin^.commkey[1];
                nm_flags:=0;
                if pmin^.disabled then
                  nm_flags:=nm_flags or nm_itemdisabled;
                if pmin^.checkit then
                  nm_flags:=nm_flags or intuition.checkit;
                if pmin^.checked then
                  nm_flags:=nm_flags or intuition.checked;
                if pmin^.menutoggle then
                  nm_flags:=nm_flags or intuition.menutoggle;
                nm_mutualexclude:=pmin^.exclude;
                nm_userdata:=nil;
              end;
            inc(count2);
            pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
            while (pmsi^.ln_succ<>nil) do
              begin
                with pn^[count2] do
                 begin
                   nm_type:=nm_sub;
                   if pmsi^.barlabel then
                     nm_label:=pointer(nm_barlabel)
                    else
                     if (pmsi^.graphic<>nil) then
                       begin
                         nm_type:=im_sub;
                         nm_label:=pointer(@pmsi^.graphic^.leftedge);
                       end
                      else
                       begin
                         pmsi^.displaytext:=pmsi^.text;
                         nm_label:=@pmsi^.displaytext[1];
                         nm_type:=nm_sub;
                       end;
                   nm_commkey:=nil;
                   if (pmsi^.commkey<>#0)and(not pmin^.barlabel) then
                    nm_commkey:=@pmsi^.commkey[1];
                   if pmsi^.disabled then
                    nm_flags:=nm_flags or nm_itemdisabled;
                   if pmsi^.checkit then
                     nm_flags:=nm_flags or intuition.checkit;
                   if pmsi^.checked then
                     nm_flags:=nm_flags or intuition.checked;
                   if pmsi^.menutoggle then
                     nm_flags:=nm_flags or intuition.menutoggle;
                   nm_mutualexclude:=pmsi^.exclude;
                   nm_userdata:=nil;
                 end;
                inc(count2);
                pmsi:=pmsi^.ln_succ;
              end;
            pmin:=pmin^.ln_succ;
          end;
        pmtn:=pmtn^.ln_succ;
      end;
  if (pn<>nil) then
    begin
      pn^[count2].nm_type:=nm_end;
      pn^[count2].nm_label:=nil;
      settagitem(@tags[1],gtmn_frontpen,pdmn^.frontpen);
      settagitem(@tags[2],tag_done,0);
      if pdmn^.frontpen=0 then
        tags[1].ti_tag:=tag_ignore;
      {
      settagitem(@tags[2],(67+gt_tagbase),long(true));
      }
      pdmn^.testmenu:=createmenusa(pnewmenu(pn),@tags[1]);
      if pdmn^.testmenu<>nil then
        begin
          if pdmn^.defaultfont then
            settagitem(@tags[1],tag_ignore,0)
           else
            begin
              if nil<>opendiskfont(@pdmn^.inusetextattr) then
                begin
                  settagitem(@tags[1],gtmn_textattr,long(@pdmn^.inusetextattr));
                end
               else
                begin
                  telluser(mainwindow,'Cannot Open Font : '+pdmn^.inusefontname);
                  settagitem(@tags[1],tag_ignore,0)
                end;
            end;
          settagitem(@tags[2],(67+gt_tagbase),long(true));
          settagitem(@tags[3],tag_done,0);
          if layoutmenusa(pdmn^.testmenu,pdmn^.screenvisinfo,@tags[1]) then
            begin
              if not setmenustrip(pdmn^.editwindow,pdmn^.testmenu) then
                begin
                  telluser(mainwindow,'Could not set menu.');
                  freemenus(pdmn^.testmenu);
                end;
            end
           else
            begin
              telluser(mainwindow,'Could not layout menu.');
              freemenus(pdmn^.testmenu);
            end;
        end
       else
        telluser(mainwindow,'Could not create menu.');
      freemymem(pn,(count+1)*sizeof(tnewmenu));
    end;
  unwaiteverything;
end;

function sizeoflist(pl:plist):long;
var
  pn:pnode;
  count : long;
begin
  count:=0;
  pn:=pl^.lh_head;
  while(pn^.ln_succ<>nil) do
    begin
      inc(count);
      pn:=pn^.ln_succ;
    end;
  sizeoflist:=count;
end;

function getlistpos(pl:plist;pn:pnode):long;
var
  count : long;
  pn2   : pnode;
begin
  count:=0;
  pn2:=pl^.lh_head;
  while(pn2^.ln_succ<>nil)and(pn2<>pn) do
    begin
      inc(count);
      pn2:=pn2^.ln_succ;
    end;
  getlistpos:=count;
end;

function createnewmenusubitemnode(place : byte; pmin:pmenuitemnode):pmenusubitemnode;
var
  pmsi : pmenusubitemnode;
  s    : string;
begin
  pmsi:=allocmymem(sizeof(tmenusubitemnode),memf_clear or memf_any);
  if pmsi<>nil then
    begin
      with pmsi^ do
        begin
          checked:=false;
          menutoggle:=false;
          checkit:=false;
          disabled:=false;
          commkey:=#0;
          graphic:=nil;
          str(place,s);
          text:='New Sub Item '+s+#0;
          textprint:=true;
          graphprint:=false;
          barlabel:=false;
          ln_name:=@text[1];
          str(pmin^.nextsub,idlabel);
          inc(pmin^.nextsub);
          idlabel:=copy(no0(pmin^.idlabel),1,length(no0(pmin^.idlabel))-1)+'_Sub'+idlabel+#0;
        end;
    end
   else
    telluser(mainwindow,memerror);
  createnewmenusubitemnode:=pmsi;
end;

function createnewmenuitemnode(place : byte;pmtn:pmenutitlenode):pmenuitemnode;
var
  pmin : pmenuitemnode;
  s    : string;
begin
  pmin:=allocmymem(sizeof(tmenuitemnode),memf_clear or memf_any);
  if pmin<>nil then
    begin
      with pmin^ do
        begin
          newlist(@tsubitems);
          checked:=false;
          menutoggle:=false;
          checkit:=false;
          disabled:=false;
          commkey:=#0;
          graphic:=nil;
          str(place,s);
          text:='New Item '+s+#0;
          textprint:=true;
          graphprint:=false;
          barlabel:=false;
          ln_name:=@text[1];
          str(pmtn^.nextitem,idlabel);
          inc(pmtn^.nextitem);
          idlabel:=copy(no0(pmtn^.idlabel),1,length(no0(pmtn^.idlabel))-1)+'_Item'+idlabel+'X'#0;
        end;
    end
   else
    telluser(mainwindow,memerror);
  createnewmenuitemnode:=pmin;
end;

function createnewmenutitle(place : byte;pdmn:pdesignermenunode):pmenutitlenode;
var
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
  s    : string;
begin
  pmtn:=allocmymem(sizeof(tmenutitlenode),memf_clear or memf_any);
  if pmtn<>nil then
    begin
      pmtn^.ln_name:=@pmtn^.text[1];
      str(place,s);
      pmtn^.text:='New Menu '+s+#0;
      newlist(@pmtn^.titemlist);
      str(pdmn^.nexttitle,pmtn^.idlabel);
      inc(pdmn^.nexttitle);
      pmtn^.idlabel:=copy(no0(pdmn^.idlabel),1,length(no0(pdmn^.idlabel))-1)+'_Menu'+pmtn^.idlabel+'X'#0;
      pmtn^.disabled:=false;
      pmin:=createnewmenuitemnode(0,pmtn);
      if pmin=nil then
        begin
          freemymem(pmtn,sizeof(tmenutitlenode));
          pmtn:=nil;
        end
       else
        addtail(@pmtn^.titemlist,pnode(pmin));
    end
   else
    telluser(mainwindow,memerror);
  createnewmenutitle:=pmtn;
end;

function createnewdesignermenunode:pdesignermenunode;
var
  pdmn : pdesignermenunode;
  pmtn : pmenutitlenode;
  s    : string;
begin
  pdmn:=allocmymem(sizeof(tdesignermenunode),memf_clear or memf_any);
  if pdmn<>nil then
    begin
      newlist(@pdmn^.tmenulist);
      pdmn^.localmenu:=prefsvalues[15];
      pdmn^.ln_name:=@pdmn^.idlabel[1];
      str(sizeoflist(@teditmenulist),s);
      pdmn^.ln_type:=menunodetype;
      pdmn^.defaultfont:=true;
      pdmn^.frontpen:=0;
      copymem(@ttopaz80,@pdmn^.font,sizeof(ttextattr));
      pdmn^.font.ta_name:=@pdmn^.fontname[1];
      pdmn^.fontname:=fontname;
      pdmn^.idlabel:='NewMenu'+s;
      pmtn:=createnewmenutitle(0,pdmn);
      if pmtn=nil then
        begin
          freemymem(pdmn,sizeof(tdesignermenunode));
          pdmn:=nil;
        end
       else
        addtail(@pdmn^.tmenulist,pnode(pmtn));
    end
   else
    telluser(mainwindow,memerror);
  createnewdesignermenunode:=pdmn;
end;

procedure spreadhighgadgets(pdwn:pdesignerwindownode);
var
  templist : tlist;
  pgn      : pgadgetnode;
  pgn2     : pgadgetnode;
  pgn3     : pgadgetnode;
  pgn4     : pgadgetnode;
  cc       : long;
  done     : boolean;
  goforit  : boolean;
  skipone  : boolean;
begin
  
  { select highlighted }
  
  newlist(@templist);
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin
      pgn3:=pgn^.ln_succ;
      if pgn^.kind=string_kind then
        skipone:=pgn^.joined
       else
        skipone:=false;
      goforit:=false;
      pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
      if (pgn2<>nil) and (pgn^.kind=listview_kind) then
        if pgn2^.high and (not pgn^.high) then
          goforit:=true;
      if (pgn^.high and (not skipone)) or goforit then
        begin
          remove(pnode(pgn));
          addhead(@templist,pnode(pgn));
        end;
      pgn:=pgn3;
    end;
  
  { bad sort list into order }
  
  if sizeoflist(@templist)>1 then
    repeat
      done:=true;
      pgn:=pgadgetnode(templist.lh_head);
      while (pgn^.ln_succ^.ln_succ<>nil)and done do
        begin
          if ((pdwn^.spreadpos=0)and(pgn^.ln_succ^.x<pgn^.x)) or
             ((pdwn^.spreadpos=1)and(pgn^.ln_succ^.y<pgn^.y)) then
            begin
              done:=false;
              pgn2:=pgn^.ln_succ;
              remove(pnode(pgn));
              insert_(@templist,pnode(pgn),pnode(pgn2));
              pgn:=pgn2;
            end
           else
            pgn:=pgn^.ln_succ;
        end;
    until done;
  
  {
  Degug bitty
  
  pgn:=pgadgetnode(templist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin 
      writeln('gad : ',pgn^.x,' ',pgn^.y);
      pgn:=pgn^.ln_succ;
    end;
  }
  
  { Move gadgets to new positions }
  
  pgn:=pgadgetnode(templist.lh_head);
  if pgn^.ln_succ<>nil then
    begin
      if pdwn^.spreadpos=0 then
        cc:=pgn^.x+pgn^.w+pdwn^.spreadsize
       else
        cc:=pgn^.y+pgn^.h+pdwn^.spreadsize;
      pgn:=pgn^.ln_succ;
      while (pgn^.ln_succ<>nil) do
        begin
          if pdwn^.spreadpos=0 then
            begin
              pgn^.x:=cc;
              cc:=cc+pgn^.w+pdwn^.spreadsize;
            end
           else
            begin
              pgn^.y:=cc;
              cc:=cc+pgn^.h+pdwn^.spreadsize;
            end;
          pgn:=pgn^.ln_succ;
        end;
    end;
  
  { Put back in window gadget list }
  
  pgn:=pgadgetnode(templist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin 
      pgn2:=pgn^.ln_succ;
      remove(pnode(pgn));
      done:=false;
      pgn3:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      if pgn3^.ln_succ=nil then
        begin
          done:=true;
          addhead(@pdwn^.gadgetlist,pnode(pgn));
        end;
      if not done then
        if pgn3^.id>pgn^.id then
          begin
            done:=true;
            addhead(@pdwn^.gadgetlist,pnode(pgn));
          end;
      if not done then 
        while(pgn3^.ln_succ^.ln_succ<>nil)and(not done) do
          begin
            if pgn^.id<pgn3^.ln_succ^.id then
              begin
                done:=true;
                insert_(@pdwn^.gadgetlist,pnode(pgn),pnode(pgn3));
              end;
            if not done then
              pgn3:=pgn3^.ln_succ;
          end;
      if not done then
        addtail(@pdwn^.gadgetlist,pnode(pgn));
      pgn:=pgn2;
    end;
  
  {
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while (pgn^.ln_succ<>nil) do
    begin 
      writeln('gad : ',pgn^.id);
      pgn:=pgn^.ln_succ;
    end;
  }
end;

procedure newgadnode(pdwn:pdwesignerwindownode;pgn:pgadgetnode);
var
  s : string;
  psn : pstringnode;
begin
  pgn^.flags:=placetext_left;
  pgn^.title:=''#0;
  newlist(@pgn^.infolist);
  
  pgn^.justcreated:=true;
  
  case pdwn^.mxchoice of
    0 : begin
           
          {**** New button gadget ****}
           
          pgn^.kind:=button_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          pgn^.flags:=placetext_in;
          checkgadsize(pdwn,pgn);
          settagitem(@pgn^.tags[3],gt_underscore,long(false));
          settagitem(@pgn^.tags[2],ga_disabled,long(false));
          settagitem(@pgn^.tags[1],tag_done,0);
        end;
    1 : begin
      
          {**** new string gadget ****}
                                                
          pgn^.kind:=string_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gtst_maxchars,64);
          settagitem(@pgn^.tags[2],stringa_justification,gact_stringleft);
          settagitem(@pgn^.tags[3],stringa_replacemode,long(false));
          settagitem(@pgn^.tags[4],ga_disabled,long(false));
          settagitem(@pgn^.tags[5],stringa_exithelp,long(false));
          settagitem(@pgn^.tags[6],ga_tabcycle,long(true));
          settagitem(@pgn^.tags[7],tag_done,0);
          settagitem(@pgn^.tags[8],gt_underscore,long(false));
          settagitem(@pgn^.tags[9],ga_immediate,long(false));
        end;
    2 : begin
                                                
          {**** New integer gadget ****}
                                        
          pgn^.kind:=integer_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gtin_maxchars,10);
          settagitem(@pgn^.tags[2],stringa_justification,gact_stringleft);
          settagitem(@pgn^.tags[3],stringa_replacemode,long(false));
          settagitem(@pgn^.tags[4],ga_disabled,long(false));
          settagitem(@pgn^.tags[5],stringa_exithelp,long(false));
          settagitem(@pgn^.tags[6],ga_tabcycle,long(true));
          settagitem(@pgn^.tags[7],tag_done,0);
          settagitem(@pgn^.tags[8],gt_underscore,long(false));
          settagitem(@pgn^.tags[9],ga_immediate,long(false));
        end;                                  
    3 : begin
          
          {**** New CheckBox Gadget ****}
          
          pgn^.kind:=checkbox_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=26;
          pgn^.h:=11;
          pgn^.flags:=placetext_left;
          {settagitem(@pgn^.tags[5],gtcb_scaled,long(false));}
          settagitem(@pgn^.tags[4],gt_underscore,long(false));
          settagitem(@pgn^.tags[3],ga_disabled,long(false));
          settagitem(@pgn^.tags[2],tag_done,0);
          settagitem(@pgn^.tags[1],gtcb_checked,long(false));
        end;
    4 : begin
          
          {**** new mx kind ****}
          
          pgn^.kind:=mx_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=17;
          pgn^.h:=9;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='First'#0;
            end;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='Second'#0;
            end;
          settagitem(@pgn^.tags[1],gtmx_active,0);
          settagitem(@pgn^.tags[2],gtmx_spacing,1);
          settagitem(@pgn^.tags[3],gtmx_labels,long(@pgacycle[1]));
          settagitem(@pgn^.tags[4],tag_done,0);
          settagitem(@pgn^.tags[5],gt_underscore,long(false));
          settagitem(@pgn^.tags[6],gt_tagbase+69,long(false));
          settagitem(@pgn^.tags[7],gt_tagbase+69,placetext_left);
        end;
    5 : begin
                                                
          {**** new cycle kind ****}
                                    
          pgn^.kind:=cycle_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='Zero'#0;
            end;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='One'#0;
            end;
          settagitem(@pgn^.tags[1],gtcy_active,0);
          settagitem(@pgn^.tags[2],tag_ignore,0);
          settagitem(@pgn^.tags[3],gtcy_labels,0);
          settagitem(@pgn^.tags[4],tag_done,0);
          settagitem(@pgn^.tags[5],gt_underscore,long(false));
          settagitem(@pgn^.tags[6],ga_disabled,long(false));
        end;
    6 : begin
                                                
          {**** new slider kind ****}
                                               
          pgn^.kind:=slider_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          pgn^.datas:='%2ld'#0;
          settagitem(@pgn^.tags[1],gtsl_min,0);
          settagitem(@pgn^.tags[2],gtsl_max,15);
          settagitem(@pgn^.tags[3],gtsl_level,0); 
          settagitem(@pgn^.tags[4],tag_ignore,long(false)); 
          settagitem(@pgn^.tags[5],tag_ignore,64);
          settagitem(@pgn^.tags[6],tag_ignore,placetext_left);
          settagitem(@pgn^.tags[7],ga_immediate,long(false)); 
          settagitem(@pgn^.tags[8],ga_relverify,long(true));
          settagitem(@pgn^.tags[9],pga_freedom,lorient_horiz);
          settagitem(@pgn^.tags[10],tag_done,0);
          settagitem(@pgn^.tags[11],ga_disabled,long(false));
          settagitem(@pgn^.tags[14],gt_underscore,long(false));
        end;
    7 : begin
                        
          {**** new scroller kind ****}
                                    
          pgn^.kind:=scroller_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gtsc_top,0);
          settagitem(@pgn^.tags[2],gtsc_total,0);                                          
          settagitem(@pgn^.tags[3],gtsc_visible,2);
          settagitem(@pgn^.tags[4],tag_ignore,0);
          settagitem(@pgn^.tags[5],ga_immediate,long(true));
          settagitem(@pgn^.tags[6],ga_relverify,long(true));
          settagitem(@pgn^.tags[7],pga_freedom,lorient_horiz);
          settagitem(@pgn^.tags[8],tag_done,0);
          settagitem(@pgn^.tags[9],ga_disabled,long(false));
          settagitem(@pgn^.tags[10],ga_immediate,long(false));
          settagitem(@pgn^.tags[11],ga_relverify,long(false));
          settagitem(@pgn^.tags[12],gt_underscore,long(false));
        end;
    8 : begin
                                               
          {**** new listview kind ****}
                                               
          pgn^.kind:=listview_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='Click Me'#0;
            end;
          psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
          if psn<>nil then
            begin
              addtail(@pgn^.infolist,pnode(psn));
              psn^.ln_name:=@psn^.st[1];
              psn^.st:='Or Me'#0;
            end;
          settagitem(@pgn^.tags[1],gtlv_labels,long(@pgn^.infolist));
          settagitem(@pgn^.tags[2],gtlv_top,0);
          settagitem(@pgn^.tags[3],tag_ignore,0);
          settagitem(@pgn^.tags[4],gtlv_scrollwidth,16);
          settagitem(@pgn^.tags[5],gtlv_selected,0);
          settagitem(@pgn^.tags[6],layouta_spacing,0);
          settagitem(@pgn^.tags[7],tag_done,0);
          settagitem(@pgn^.tags[8],gtlv_readonly,long(false));
          settagitem(@pgn^.tags[9],gt_underscore,long(false));
          settagitem(@pgn^.tags[10],0,long(true));
        end;
    9 : begin
                                 
          {**** new palette kind ****}
                                               
          pgn^.kind:=palette_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gtpa_depth,0);
          settagitem(@pgn^.tags[2],gtpa_color,1);
          settagitem(@pgn^.tags[3],gtpa_coloroffset,0);
          settagitem(@pgn^.tags[4],tag_ignore,0);
          settagitem(@pgn^.tags[5],tag_ignore,0);
          settagitem(@pgn^.tags[6],tag_done,0);
          settagitem(@pgn^.tags[7],ga_disabled,long(false));
          settagitem(@pgn^.tags[8],gt_underscore,long(false));
        end;
    10: begin
          
          {**** new text kind ****}
          
          pgn^.kind:=text_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          pgn^.datas:='Display Text'#0;
          settagitem(@pgn^.tags[1],gttx_text,long(@pgn^.datas[1]));
          settagitem(@pgn^.tags[2],gttx_border,long(false));
          settagitem(@pgn^.tags[3],gttx_copytext,long(false));
          settagitem(@pgn^.tags[4],tag_done,0);
          pgn^.tags[6].ti_data:=1;
          pgn^.tags[9].ti_data:=long(true);
          
        end;
    11: begin
          
          {**** new number kind ****}
          
          pgn^.kind:=number_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gtnm_number,0);
          settagitem(@pgn^.tags[2],gtnm_border,long(false));
          settagitem(@pgn^.tags[3],tag_done,0);
          pgn^.tags[6].ti_data:=1;
          pgn^.tags[9].ti_data:=long(true);
          
        end;
    30: begin
          
          {**** New mybool Gadget ****}
          
          pgn^.kind:=mybool_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          settagitem(@pgn^.tags[1],gact_relverify 
            or gact_immediate,long(false));
          settagitem(@pgn^.tags[2],0,0);
          settagitem(@pgn^.tags[3],1,0);
          settagitem(@pgn^.tags[4],jam1,0);
          pgn^.pointers[1]:=nil;
          pgn^.pointers[2]:=nil;
          pgn^.flags:=gflg_gadghcomp or gflg_gadgimage;
        end;
    33 : 
        begin
           
          {**** New object gadget ****}
           
          pgn^.kind:=myobject_kind;
          pgn^.x:=box[1];
          pgn^.y:=box[2];
          pgn^.w:=box[3]-box[1]+1;
          pgn^.h:=box[4]-box[2]+1;
          pgn^.tags[4].ti_tag:=1;
          {
          pgn^.flags:=placetext_in;
          }
          checkgadsize(pdwn,pgn);
          {
          settagitem(@pgn^.tags[3],gt_underscore,long(false));
          settagitem(@pgn^.tags[2],ga_disabled,long(false));
          settagitem(@pgn^.tags[1],tag_done,0);
          }
          pgn^.title:='Object'#0;
          pgn^.datas:=''#0;
          pgn^.tags[1].ti_tag:=0;
          pgn^.tags[1].ti_data:=0;
          pgn^.tags[2].ti_tag:=0;
          pgn^.tags[2].ti_data:=1;
        end;

    {
    32: begin
          
          }{**** New Generic Image ****}{
          
          writeln('New generic');
          
        end;
    }
   end;
  pgn^.fontname:=pdwn^.gadgetfontname;
  with pgn^.font do
    begin
      ta_name:=@pgn^.fontname[1];
      ta_ysize:=pdwn^.gadgetfont.ta_ysize;
      ta_style:=pdwn^.gadgetfont.ta_style;
      ta_flags:=pdwn^.gadgetfont.ta_flags;
    end;
  pgn^.ln_name:=@pgn^.labelid[1];
  pgn^.labelid:=#0#0#0;
  checkgadsize(pdwn,pgn);
end;

procedure togglecheckbox(pgad:pgadget;pwin:pwindow);
begin
  gt_setsinglegadgetattr(pgad,pwin,gtcb_checked,long(not checkedbox(pgad)));
end;

procedure gadgetfont(pdwn,pgn);
var
  tags : array[1..6] of ttagitem;
  st   : string;
begin
  waiteverything;
  settagitem(@tags[1],asl_window,long(pdwn^.editwindow));
  settagitem(@tags[2],asl_fontname,long(@pgn^.fontname[1]));
  settagitem(@tags[3],asl_fontheight,long(pgn^.font.ta_ysize));
  settagitem(@tags[4],asl_fontstyles,long(pgn^.font.ta_style));
  settagitem(@tags[5],asl_fontflags,long(pgn^.font.ta_flags));
  settagitem(@tags[6],tag_done,0);
  inputmode:=1;
  if (aslrequest(fontrequest,@tags[1])) then
    begin
      pfr:=pfontrequester(fontrequest);
      pgn^.editwindow^.tfont.ta_ysize:=pfr^.fo_attr.ta_ysize;
      pgn^.editwindow^.tfont.ta_style:=pfr^.fo_attr.ta_style;
      pgn^.editwindow^.tfont.ta_flags:=pfr^.fo_attr.ta_flags;
      ctopas(pfr^.fo_attr.ta_name^,st);
      if length(st)>44 then
        st:=copy(st,1,44);
      pgn^.editwindow^.tfontname:=st+#0;
      pdwn^.gadgetfont.ta_ysize:=pfr^.fo_attr.ta_ysize;
      pdwn^.gadgetfont.ta_style:=pfr^.fo_attr.ta_style;
      pdwn^.gadgetfont.ta_flags:=pfr^.fo_attr.ta_flags;
      pdwn^.gadgetfontname:=pgn^.editwindow^.tfontname;
    end;
  unwaiteverything;
end;

procedure readdefaultscreenmode;
var
  filename : string;
  iff      : piffhandle;
  sp       : pstoredproperty;
  psp      : pscreenmodeprefs;
begin
  with defaultscreenmode do
    begin
      sm_displayid:=$8000;
      sm_width:=640;
      sm_height:=200;
      sm_depth:=2;
      sm_control:=1;
      changed:=false;
      font.ta_name:=@fontname[1];
      font.ta_ysize:=8;
      font.ta_style:=0;
      font.ta_flags:=0;
      fontname:='topaz80'#0;
    end;
  filename:='ENV:SYS/ScreenMode.Prefs'#0;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=long(open(@filename[1],mode_oldfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          if 0=openiff(iff,ifff_read) then
            begin
              if (0=propchunk(iff,id_pref,id_scrm)) and
                 (0=stoponexit(iff,id_pref,id_form)) then
                begin
                  if 0=parseiff(iff,iffparse_scan) then;
                  sp:=findprop(iff,id_pref,id_scrm);
                  if sp<>nil then
                    begin
                      copymem(sp^.sp_data,@defaultscreenmode,sizeof(tscreenmodeprefs))
                    end;
                end;
              closeiff(iff);
            end;
          if long(amigados.Close_(bptr(iff^.iff_stream)))=0 then;
        end;
      freeiff(iff);
    end
end;

procedure setscreengadgets(pwin:pwindow;var pg:pgadget;selected:word;var modelist:tlist;var depthnow:word);
var
  gads  : array[1..15] of pgadget absolute pg;
  pn    : pnode;
  dummy : word;
  psmn  : pscreenmodenode;
begin
  psmn:=pscreenmodenode(getnthnode(@modelist,selected));
  dummy:=selected;
  gt_setsinglegadgetattr(gads[1],pwin,gtlv_selected,dummy);
  gt_setsinglegadgetattr(gads[2],pwin,gtnm_number,640);
  gt_setsinglegadgetattr(gads[3],pwin,gtnm_number,200);
  gt_setsinglegadgetattr(gads[4],pwin,gtnm_number,psmn^.tdimsinfo.maxrasterwidth);
  gt_setsinglegadgetattr(gads[5],pwin,gtnm_number,psmn^.tdimsinfo.maxrasterheight);
  gt_setsinglegadgetattr(gads[8],pwin,gtsl_max,psmn^.tdimsinfo.maxdepth);
  if depthnow>psmn^.tdimsinfo.maxdepth then
    depthnow:=psmn^.tdimsinfo.maxdepth;
  dummy:=getintegerfromgad(gads[6]);
  if dummy<640 then dummy:=640;
  if dummy>psmn^.tdimsinfo.maxrasterwidth then
    dummy:=psmn^.tdimsinfo.maxrasterwidth;
  gt_setsinglegadgetattr(gads[6],pwin,gtin_number,dummy);
  dummy:=getintegerfromgad(gads[7]);
  if dummy<200 then dummy:=199;
  if dummy>psmn^.tdimsinfo.maxrasterheight then
    dummy:=psmn^.tdimsinfo.maxrasterheight;
  gt_setsinglegadgetattr(gads[7],pwin,gtin_number,dummy);
end;

function screenrequester(pscr : pscreen;pprefs : pscreenmodeprefs):boolean;
var
  asl_tb        : long;
  pwin          : pwindow;
  glist         : pgadget;
  gads          : array [1..20] of pgadget;
  dummy         : long;
  tags          : array[1..20] of ttagitem;
  handle        : pointer;
  tni           : tnameinfo;
  loop          : word;
  result        : long;
  modelist      : tlist;
  oksofar       : boolean;
  psmn          : pscreenmodenode;
  localfail     : boolean;
  offx,offy     : word;
  pgad          : pgadget;
  imsg          : pintuimessage;
  tmsg          : tintuimessage;
  done          : boolean;
  screenvisinfo : pointer;
  format        : string[11];
  selected      : long;
  depthnow      : word;
  final         : boolean;
  font          : ttextattr;
  fontname      : string[46];
  changed       : boolean;
  st            : string;
  itemnumber    : word;
  menunumber    : word;
  currentscreenmode : long;
  gosr          : boolean;
  disphandle    : pointer;
  aslreq        : pscreenmoderequester;
begin
asl_tb:=tag_user+$80000;
waiteverything;
if aslbase^.lib_version>37 then
begin
  
  
  settagitem(@tags[ 1],40+asl_tb,long(pscr));
  settagitem(@tags[ 2],42+asl_tb,long(true));
  
  settagitem(@tags[ 5],asl_tb+101,pscr^.width  {pprefs^.sm_width}  );
  settagitem(@tags[ 4],asl_tb+102,pscr^.height {pprefs^.sm_height} );
  
  settagitem(@tags[ 3],asl_tb+100,pprefs^.sm_displayid);
  settagitem(@tags[ 6],asl_tb+103,pprefs^.sm_depth);
  settagitem(@tags[ 7],asl_tb+109,long(true));
  settagitem(@tags[ 8],asl_tb+110,long(true));
  settagitem(@tags[ 9],asl_tb+111,long(true));
  settagitem(@tags[10],asl_tb+118,200);
  settagitem(@tags[11],tag_done,0);
  settagitem(@tags[12],0,0);
  settagitem(@tags[13],0,0);
  
  aslreq:=pscreenmoderequester(allocaslrequest(2,@tags[1]));
  if aslreq<>nil then
    begin
      if aslrequest(pointer(aslreq),nil) then
        begin
          pprefs^.sm_displayid:=aslreq^.sm_displayid;
          pprefs^.sm_width:=aslreq^.sm_displaywidth;
          pprefs^.sm_height:=aslreq^.sm_displayheight;
          pprefs^.sm_depth:=aslreq^.sm_displaydepth;
          pprefs^.changed:=true;
          screenrequester:=true;
        end
       else
        screenrequester:=false;
      freeaslrequest(pointer(aslreq));
    end
   else
    begin
      screenrequester:=false;
      telluser(mainwindow,'Unable to open screen requester.');
    end;
  
end
else
begin  
  changed:=false;
  newlist(@modelist);
  oksofar:=true;
  loop:=1;
  currentscreenmode:=lores_key;
  while currentscreenmode<>A2024FIFTEENHERTZ_KEY do
    begin
      currentscreenmode:=screenmodesavailable[loop];
      gosr:=true;
      disphandle:=finddisplayinfo(currentscreenmode);
      if disphandle<>nil then
        begin
          psmn:=pscreenmodenode(modelist.lh_head);
          while (psmn^.ln_succ<>nil) do
            begin
              if psmn^.dhandle=disphandle then
                gosr:=false;
              psmn:=psmn^.ln_succ;
            end;
        end;
      if (0=modenotavailable(currentscreenmode)) and
         gosr and
         (disphandle<>nil) {and
         ((currentscreenmode and $400)=0) and
         ((currentscreenmode and  $80)=0) and
         ((currentscreenmode and $800)=0) } then
        begin
          localfail:=false;
          psmn:=allocmymem(sizeof(tscreenmodenode),memf_clear or memf_any);
          if psmn<>nil then
            begin
              with psmn^ do
                begin
                  addtail(@modelist,pnode(psmn));
                  monitorname:='';
                  dhandle:=disphandle;
                  ln_name:=@monitorname[1];
                  modeid:=currentscreenmode;
                  result:=getdisplayinfodata(nil,@tni,sizeof(tni),dtag_name,currentscreenmode);
                  if result<>0 then
                    for dummy:=0 to 31 do
                      monitorname:=monitorname+chr(tni.name[dummy]);
                  monitorname:=monitorname+#0;
                  result:=getdisplayinfodata(nil,@tdispinfo,sizeof(tdisplayinfo),dtag_disp,currentscreenmode);
                  if result=0 then
                    begin
                      telluser(mainwindow,'Could not get displayinfo on screen mode.');
                      localfail:=true;
                    end
                   else
                    if monitorname=#0 then
                      begin
                        if loop<19 then
                          begin
                            case loop of
                              1..6   : monitorname:='PAL:'+monname[loop]+#0;
                              7..12  : monitorname:='NTSC:'+monname[loop-6]+#0;
                              13..18 : monitorname:=monname[loop-12]+#0;
                             end;
                          end
                         else
                          monitorname:=monname[loop]+#0;
                      end;
                  result:=getdisplayinfodata(nil,@tdimsinfo,sizeof(tdimensioninfo),dtag_dims,currentscreenmode);
                  if result=0 then
                    begin
                      telluser(mainwindow,'Could not get dimensioninfo on screen mode.');
                      localfail:=true;
                    end;
                  result:=getdisplayinfodata(nil,@tmoninfo,sizeof(tmonitorinfo),dtag_mntr,currentscreenmode);
                  if result=0 then
                    begin
                      telluser(mainwindow,'Could not get monitorinfo on screen mode.');
                      localfail:=true;
                    end;
                end;
            end
           else
            begin
              telluser(mainwindow,memerror);
              oksofar:=false;
            end;
          if localfail then
            begin
              remove(pnode(psmn));
              freemymem(psmn,sizeof(tscreenmodenode));
            end;
        end;
      inc(loop);
    end;  
  selected:=0;
  done:=false;
  if oksofar then
    begin
      dummy:=0;
      psmn:=pscreenmodenode(modelist.lh_head);
      while (psmn^.ln_succ<>nil)and (not done) do
        begin
          if (psmn^.modeid=pprefs^.sm_displayid) or 
             ((psmn^.modeid-(psmn^.modeid and monitor_id_mask))=pprefs^.sm_displayid) then
            begin
              selected:=dummy;
              done:=true;
            end;
          inc(dummy);
          psmn:=psmn^.ln_succ;
        end;
    end;
  screenvisinfo:=nil;
  if oksofar then
    begin
      screenvisinfo:=getvisualinfoa(pscr,nil);
      if screenvisinfo=nil then
        oksofar:=false;
    end;
  if oksofar then
    begin
      format:='%2ld'#0;
      settagitem(@tags[1],gtlv_labels,long(@modelist));
      settagitem(@tags[2],gtlv_showselected,long(false));
      settagitem(@tags[3],tag_done,0);
      settagitem(@tags[4],gtnm_border,long(true));
      settagitem(@tags[5],gtsl_levelformat,long(@format[1]));
      settagitem(@tags[6],gtsl_maxlevellen,2);
      settagitem(@tags[7],gtsl_levelplace,placetext_right);
      settagitem(@tags[8],gtsl_min,1);
      settagitem(@tags[9],gtsl_max,8);
      settagitem(@tags[10],ga_relverify,long(true));
      settagitem(@tags[11],gt_underscore,ord('_'));
      settagitem(@tags[12],tag_done,0);
      offx:=pscr^.wborleft+4;
      offy:=pscr^.wbortop+pscr^.rastport.txheight+1;
      glist:=nil;
      pgad:=createcontext(@glist);
      pgad:=generalgadtoolsgad(listview_kind,offx+11,6+offy,373,88,1,nil,             {listview}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[1]);
      gads[1]:=pgad;
      pgad:=generalgadtoolsgad(number_kind,offx+11,98+offy,91,12,2,@strings[40,1],    {Min Width}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[4]);
      gads[2]:=pgad;
      pgad:=generalgadtoolsgad(number_kind,offx+11,113+offy,91,12,3,@strings[41,1],   {Min Height}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[4]);
      gads[3]:=pgad;
      pgad:=generalgadtoolsgad(number_kind,offx+196,98+offy,91,12,4,@strings[38,1],   {max width}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[4]);
      gads[4]:=pgad;
      pgad:=generalgadtoolsgad(number_kind,offx+196,113+offy,91,12,5,@strings[39,1],  {max height}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[4]);
      gads[5]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+11,128+offy,91,12,6,@strings[44,1],  {width}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[11]);
      gads[6]:=pgad;
      pgad:=generalgadtoolsgad(integer_kind,offx+196,128+offy,91,12,7,@strings[45,1], {height}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[11]);
      gads[7]:=pgad;
      pgad:=generalgadtoolsgad(slider_kind,offx+11,143+offy,277,12,8,@strings[185,1], {scroller}
                               @ttopaz80,placetext_right,screenvisinfo,pgad,nil,@tags[5]);
      gads[8]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+11,159+offy,91,14,9,@strings[16,1],   {ok}
                               @ttopaz80,0,screenvisinfo,pgad,nil,@tags[11]);
      gads[9]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+293,159+offy,91,14,10,@strings[17,1], {cancel}
                               @ttopaz80,0,screenvisinfo,pgad,nil,@tags[11]);
      gads[10]:=pgad;
      pgad:=generalgadtoolsgad(button_kind,offx+152,159+offy,91,14,11,@strings[36,1], {font}
                               @ttopaz80,0,screenvisinfo,pgad,nil,@tags[11]);
      gads[11]:=pgad;
      if pgad<>nil then
        begin
          settagitem(@tags[1],wa_gadgets,long(glist));
          settagitem(@tags[2],wa_smartrefresh,long(true));
          settagitem(@tags[3],wa_depthgadget,long(true));
          settagitem(@tags[4],wa_customscreen,long(pscr));
          settagitem(@tags[5],wa_closegadget,long(true));
          settagitem(@tags[6],wa_left,40);
          settagitem(@tags[7],wa_top,40);
          settagitem(@tags[8],wa_width,404+offx);
          settagitem(@tags[9],wa_height,183+offy);
          settagitem(@tags[10],wa_title,long(@strings[1,1]));
          settagitem(@tags[11],wa_dragbar,long(true));
          settagitem(@tags[12],wa_activate,long(true));
          settagitem(@tags[13],wa_autoadjust,long(true));
          settagitem(@tags[14],wa_idcmp,idcmp_vanillakey or
                                        buttonidcmp or
                                        listviewidcmp or
                                        idcmp_closewindow or
                                        idcmp_menupick or
                                        slideridcmp);
          settagitem(@tags[15],wa_dummy+$30,long(true));
          settagitem(@tags[16],Tag_Done,0);
          pwin:=openwindowtaglist(nil,@tags[1]);
          if pwin<>nil then
            begin
              screenreqmenu:=nil;
              if makemenuscreenreqmenu(screenvisinfo) then
                if not setmenustrip(pwin,screenreqmenu) then
                  begin
                    freemenus(screenreqmenu);
                    screenreqmenu:=nil;
                  end;
              settagitem(@tags[1],gt_visualinfo,long(screenvisinfo));
              settagitem(@tags[2],tag_done,0);
              drawbevelboxa(pwin^.rport,offx+5,2+offy,387,177,@tags[1]);
              depthnow:=pprefs^.sm_depth;
              if depthnow<0 then depthnow:=1;
              if depthnow>8 then depthnow:=8;
              gt_refreshwindow(pwin,nil);
              gt_setsinglegadgetattr(gads[8],pwin,gtsl_level,pprefs^.sm_depth);
              psmn:=pscreenmodenode(getnthnode(@modelist,selected));
              gt_setsinglegadgetattr(gads[6],pwin,gtin_number,psmn^.tdimsinfo.nominal.maxx);
              gt_setsinglegadgetattr(gads[7],pwin,gtin_number,psmn^.tdimsinfo.nominal.maxy);
              gt_setsinglegadgetattr(gads[1],pwin,gtlv_top,selected);
              setscreengadgets(pwin,gads[1],selected,modelist,depthnow);
              done:=false;
              repeat
                dummy:=wait(bitmask(pwin^.userport^.MP_SIGBIT));
                imsg:=gt_getimsg(pwin^.userport);
                while imsg<>nil do
                  begin
                    copymem(imsg,@tmsg,sizeof(tmsg));
                    gt_replyimsg(imsg);
                    dummy:=0;
                    case tmsg.class of
                      idcmp_closewindow :
                          begin
                            done:=true;
                            final:=false;
                          end;
                      idcmp_vanillakey : case chr(tmsg.code) of
                                            'O','o' : dummy:=9;
                                            'C','c' : begin
                                                        {cancel}
                                                        final:=false;
                                                        done:=true;
                                                      end;
                                            'F','f' : dummy:=11;
                                            'W','w' : if activategadget(gads[6],pwin,nil) then;
                                            'H','h' : if activategadget(gads[7],pwin,nil) then;
                                            'd'     : begin
                                                        psmn:=pscreenmodenode(getnthnode(@modelist,selected));
                                                        if psmn^.tdimsinfo.maxdepth>depthnow then
                                                          inc(depthnow);
                                                        gt_setsinglegadgetattr(gads[8],pwin,gtsl_level,depthnow);
                                                      end;
                                            'D'     : begin
                                                        if depthnow>1 then
                                                          dec(depthnow);
                                                        gt_setsinglegadgetattr(gads[8],pwin,gtsl_level,depthnow);
                                                      end;
                                           end;
                      idcmp_menupick    :  begin
                                             ItemNumber:=ITEMNUM(tmsg.code);
                                             MenuNumber:=MENUNUM(tmsg.code);
                                             Case MenuNumber of
                                               ReqOptions :
                                                 Case ItemNumber of
                                                   ReqOptionsFont :
                                                     dummy:=11;
                                                   ReqOptionsok :
                                                     dummy:=9;
                                                   ReqOptionscancel :
                                                     begin
                                                       final:=false;
                                                       done:=true;
                                                     end;
                                                  end;
                                              end;
                                           end;
                      idcmp_gadgetup    :
                        begin
                          pgad:=pgadget(tmsg.iaddress);
                          case pgad^.gadgetid of
                            1 :   begin
                                    selected:=tmsg.code;
                                    psmn:=pscreenmodenode(getnthnode(@modelist,selected));
                                    gt_setsinglegadgetattr(gads[6],pwin,gtin_number,
                                            psmn^.tdimsinfo.stdoscan.maxx-psmn^.tdimsinfo.stdoscan.minx);
                                    gt_setsinglegadgetattr(gads[7],pwin,gtin_number,
                                            psmn^.tdimsinfo.stdoscan.maxy-psmn^.tdimsinfo.stdoscan.miny);
                                    setscreengadgets(pwin,gads[1],selected,modelist,depthnow);
                                  end;
                            6,7 :
                                setscreengadgets(pwin,gads[1],selected,modelist,depthnow);
                            8 : depthnow:=tmsg.code;
                            9 : begin
                                  dummy:=9;
                                  {ok}
                                end;
                            10: begin
                                  {cancel}
                                  final:=false;
                                  done:=true;
                                end;
                            11 : dummy:=11;
                           end;
                        end;
                     end;
                    if (dummy=11) then
                      begin
                        setpointer(pwin,pwaitpointer,16,16,-6,0);
                        pwin^.flags:=pwin^.flags or wflg_rmbtrap;
                        settagitem(@tags[1],asl_window,long(pwin));
                        if changed then
                          begin
                            settagitem(@tags[2],asl_fontname,long(@pprefs^.fontname[1]));
                            settagitem(@tags[3],asl_fontheight,long(pprefs^.font.ta_ysize));
                            settagitem(@tags[4],asl_fontstyles,long(pprefs^.font.ta_style));
                            settagitem(@tags[5],asl_fontflags,long(pprefs^.font.ta_flags));
                            settagitem(@tags[6],tag_done,0);
                          end
                         else
                          settagitem(@tags[2],tag_done,0);
                        if (aslrequest(fontrequest,@tags[1])) then
                          begin
                            pfr:=pfontrequester(fontrequest);
                            font.ta_ysize:=pfr^.fo_attr.ta_ysize;
                            font.ta_style:=pfr^.fo_attr.ta_style;
                            changed:=true;
                            font.ta_flags:=pfr^.fo_attr.ta_flags;
                            ctopas(pfr^.fo_attr.ta_name^,st);
                            if length(st)>44 then
                              st:=copy(st,1,44);
                            fontname:=st+#0;
                          end;
                        pwin^.flags:=pwin^.flags and ~wflg_rmbtrap;
                        clearpointer(pwin);
                      end;
                    if (dummy=9) then
                      begin
                        final:=true;
                        done:=true;
                        setscreengadgets(pwin,gads[1],selected,modelist,depthnow);
                        psmn:=pscreenmodenode(getnthnode(@modelist,selected));
                        pprefs^.sm_displayid:=psmn^.modeid;
                        pprefs^.sm_width:=getintegerfromgad(gads[6]);
                        pprefs^.sm_height:=getintegerfromgad(gads[7]);
                        pprefs^.sm_depth:=depthnow;
                        pprefs^.sm_control:=pprefs^.sm_control or 1;
                        if changed then
                          begin
                            pprefs^.changed:=true;
                            pprefs^.fontname:=fontname;
                            pprefs^.font.ta_ysize:=font.ta_ysize;
                            pprefs^.font.ta_style:=font.ta_style;
                            pprefs^.font.ta_flags:=font.ta_flags;
                          end;
                      end;
                    imsg:=gt_getimsg(pwin^.userport);
                  end;
              until done;
              if screenreqmenu<>nil then
                begin
                  clearmenustrip(pwin);
                  freemenus(screenreqmenu);
                end;
              
              intuition_2.closewindow(pwin);
              
            end
           else
            telluser(mainwindow,'Unable to open screen requester');
        end
       else
        telluser(mainwindow,'Unable to create gadgets for screen requestor');
      freegadgets(glist);
    end;
  freelist(@modelist,sizeof(tscreenmodenode));
  unwaiteverything;
  inputmode:=1;
  if screenvisinfo<>nil then
    freevisualinfo(screenvisinfo);
  screenrequester:=final;
end;
unwaiteverything;
end;

procedure deleteimagenode(pin:pimagenode);
var
  pdwn : pdesignerwindownode;
  psin : psmallimagenode;
  pdmn : pdesignermenunode;
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
  pmsi : pmenusubitemnode;
  dummy,dummy2 : long;
  pin2   : pimagenode;
  pgn    : pgadgetnode;
  thepos : long;
  pinx,piny : pimagenode;
  pdsn   : pdesignerscreennode;
  pmt,pmt2 : pmytag;
begin
  if pin^.colourmap<>nil then
    freemymem(pin^.colourmap,pin^.mapsize);
  pin^.colourmap:=nil;
  if pin^.editwindow<>nil then
    Begin
      Closewindowsafely(pin^.editwindow);
      pin^.editwindow:=Nil;
      FreeVisualInfo(pin^.editwindowVisualinfo);
      FreeGadgets(pin^.editwindowGList);
    end;
  if cyclepos=2 then
    begin
      mainselected:=~0;
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
    end;
  thepos:=getlistpos(@teditimagelist,pnode(pin));
  remove(pnode(pin));
 
  { remove image from menus }
  
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while (pdmn^.ln_succ<>nil) do
    begin
      pmtn:=pmenutitlenode(pdmn^.tmenulist.lh_head);
      while (pmtn^.ln_succ<>nil) do
        begin
          pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
          while (pmin^.ln_succ<>nil) do
            begin
              if pmin^.graphic=pin then
                pmin^.graphic:=nil;
              pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
              while (pmsi^.ln_succ<>nil) do
                begin
                  if pmsi^.graphic=pin then
                    pmsi^.graphic:=nil;
                  pmsi:=pmsi^.ln_succ;
                end;
              pmin:=pmin^.ln_succ;
            end;
          pmtn:=pmtn^.ln_succ;
        end;
      pdmn:=pdmn^.ln_succ;
    end;
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while (pdmn^.ln_succ<>nil) do
    begin
      if pdmn^.editwindow<>nil then
        begin
          if pdmn^.itemselected<>~0 then
            begin
              pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
              pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
              gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_labels,0);
              gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_labels,long(@teditimagelist));
                begin
                  dummy2:=~0;
                  dummy:=0;
                  pin2:=pimagenode(teditimagelist.lh_head);
                  while(pin2^.ln_succ<>nil)do
                    begin
                      if pin2=pmin^.graphic then
                        dummy2:=dummy;
                      inc(dummy);
                      pin2:=pin2^.ln_succ;
                    end;
                  if dummy2=~0 then pmin^.graphic:=nil;
                  gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_selected,dummy2);
                  if dummy2<>~0 then
                    gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_top,dummy2);
                end;
            end;
          if pdmn^.subitemselected<>~0 then
            begin
              pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
              pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
              pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
              gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_labels,long(@teditimagelist));
                begin
                  dummy2:=~0;
                  dummy:=0;
                  pin2:=pimagenode(teditimagelist.lh_head);
                  while(pin2^.ln_succ<>nil)do
                    begin
                      if pin2=pmsi^.graphic then
                        dummy2:=dummy;
                      inc(dummy);
                      pin2:=pin2^.ln_succ;
                    end;
                  if dummy2=~0 then pmsi^.graphic:=nil;
                  gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_selected,dummy2);
                  if dummy2<>~0 then
                    gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_top,dummy2);
                end;
            end;
          if pdmn^.testmenu<>nil then
            clearmenustrip(pdmn^.editwindow);
          testmenu(pdmn);
        end;
      pdmn:=pdmn^.ln_succ;
    end; 
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while (pdwn^.ln_succ<>nil) do
    begin
      pdwn^.bigimsel:=nil;
      pdwn^.imageselected:=nil;
      if pdwn^.imagelistwindow<>nil then
        begin
          gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_labels,~0);
          gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_labels,~0);
        end;
      psin:=psmallimagenode(pdwn^.imagelist.lh_head);
      while psin^.ln_succ<>nil do
        begin
          if psin^.pin=pin then
            begin
              remove(pnode(psin));
              freemymem(psin,sizeof(tsmallimagenode));
            end;
          psin:=psin^.ln_succ;
        end;
      if pdwn^.imagelistwindow<>nil then
        begin
          gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_labels,long(@pdwn^.imagelist));
          gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_labels,long(@teditimagelist));
          gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_selected,~0);
          gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_selected,~0);
          disableselectonimagelistwindow(pdwn);
        end;
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          if pgn^.kind=myobject_kind then
            begin
              pmt:=pmytag(pgn^.infolist.lh_head);
              while (pmt^.ln_succ<>nil) do
                begin
                  if (pmt^.tagtype=tagtypeimage) or
                     (pmt^.tagtype=tagtypeimagedata) then
                    begin
                      if pmt^.data=pointer(pin) then
                        pmt^.data:=nil;
                    end;
                  pmt:=pmt^.ln_succ;
                end;
              
              if pgn^.editwindow<>nil then
                begin
                  pmt:=pmytag(pgn^.editwindow^.editlist.lh_head);
                  while (pmt^.ln_succ<>nil) do
                    begin
                      if (pmt^.tagtype=tagtypeimage) or
                         (pmt^.tagtype=tagtypeimagedata) then
                        begin
                          if pmt^.data=pointer(pin) then
                            begin
                              pmt^.data:=nil;
                              if (pgn^.editwindow^.data4<>~0) then
                                if pmt = pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4)) then
                                  begin
                                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_labels,~0);
                                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_labels,long(@teditimagelist));
                                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_selected,~0);
                                    pgn^.editwindow^.data2:=~0;
                                  end;
                            end;
                        end;
                      pmt:=pmt^.ln_succ;
                    end;
                end;
            end;
          if (pgn^.kind=mybool_kind) then
            begin
              if pointer(pin)=pgn^.pointers[1] then
                pgn^.pointers[1]:=nil;
              if pointer(pin)=pgn^.pointers[2] then
                pgn^.pointers[2]:=nil;
              if pgn^.editwindow<>nil then
                begin
                  pgn^.editwindow^.data2:=~0;
                  pgn^.editwindow^.data3:=~0;
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@teditimagelist));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@teditimagelist));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                         gtlv_selected,~0);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                         gtlv_selected,~0);
                  dummy:=0;
                  pinx:=pimagenode(teditimagelist.lh_head);
                  while(pinx^.ln_succ<>nil) do
                    begin
                      if pinx=pimagenode(pgn^.pointers[1]) then
                        begin
                          pgn^.editwindow^.data2:=dummy;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                                 gtlv_selected,dummy);
                        end;
                      if pinx=pimagenode(pgn^.pointers[2]) then
                         begin
                           pgn^.editwindow^.data3:=dummy;
                           gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                  gtlv_selected,dummy);
                         end;
                      inc(dummy);
                      pinx:=pinx^.ln_succ;
                    end;

                end;
            end;
          pgn:=pgn^.ln_succ;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
  pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
  while (pdsn^.ln_succ<>nil) do
    begin
      if pdsn^.editwindow<>nil then
        begin
          gt_setsinglegadgetattr(pdsn^.editwindowgads[11],pdsn^.editwindow,gtlv_labels,~0);
          gt_setsinglegadgetattr(pdsn^.editwindowgads[11],pdsn^.editwindow,gtlv_labels,long(@teditimagelist));
        end;
      pdsn:=pdsn^.ln_succ;
    end;
  
  if cyclepos=2 then
    begin
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
    end;
  if pin^.displaywindow<>nil then
    closeimagedisplaywindow(pin);
  if pin^.imagedata<>nil then
    freemymem(pin^.imagedata,pin^.sizeallocated);
  freemymem(pin,sizeof(timagenode));                                                                
end;


procedure seterror(s:string);
var
  pdwn : pdesignerwindownode;
  pgn  : pgadgetnode;
  pdmn : pdesignermenunode;
  pin  : pimagenode;
begin
  displaybeep(nil);
  errorstring:=s+#0;
  currenttime(@errorstartseconds,@errorstartmicros);
  setwindowtitles(mainwindow,pointer(-1),@errorstring[1]);
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while pdmn^.ln_succ<>nil do
    begin
      if pdmn^.editwindow<>nil then
        setwindowtitles(pdmn^.editwindow,pointer(-1),@errorstring[1]);      
      pdmn:=pdmn^.ln_succ;
    end;
  if libwindow<>nil then
    setwindowtitles(libwindow,pointer(-1),@errorstring[1]);      
  if localewindow<>nil then
    setwindowtitles(localewindow,pointer(-1),@errorstring[1]);      
  
  {
  if upgradewin<>nil then
    setwindowtitles(upgradewin,pointer(-1),@errorstring[1]);      
  }
  if maincodewindow<>nil then
    setwindowtitles(maincodewindow,pointer(-1),@errorstring[1]);      
  
  pin:=pimagenode(teditimagelist.lh_head);
  while(pin^.ln_succ<>nil) do
    begin
      if pin^.editwindow<>nil then
        setwindowtitles(pin^.editwindow,pointer(-1),@errorstring[1]);
      if pin^.displaywindow<>nil then
        setwindowtitles(pin^.displaywindow,pointer(-1),@errorstring[1]);
      pin:=pin^.ln_succ;
    end;
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while pdwn^.ln_succ<>nil do
    begin
      with pdwn^ do
        begin
          if gadgetlistwindow<>nil then
            setwindowtitles(gadgetlistwindow,pointer(-1),@errorstring[1]);
          if editwindow<>nil then
            setwindowtitles(editwindow,pointer(-1),@errorstring[1]);
          if tagswindow<>nil then
            setwindowtitles(tagswindow,pointer(-1),@errorstring[1]);
          if imagelistwindow<>nil then
            setwindowtitles(imagelistwindow,pointer(-1),@errorstring[1]);
          if optionswindow<>nil then
            setwindowtitles(optionswindow,pointer(-1),@errorstring[1]);
          if sizeswindow<>nil then
            setwindowtitles(sizeswindow,pointer(-1),@errorstring[1]);
          if idcmpwindow<>nil then
            setwindowtitles(idcmpwindow,pointer(-1),@errorstring[1]);
          if textlistwindow<>nil then
            setwindowtitles(textlistwindow,pointer(-1),@errorstring[1]);
          if codewindow<>nil then
            setwindowtitles(codewindow,pointer(-1),@errorstring[1]);
          if bevelwindow<>nil then
            setwindowtitles(bevelwindow,pointer(-1),@errorstring[1]);
          if helpwin.pwin<>nil then
            setwindowtitles(helpwin.pwin,pointer(-1),@errorstring[1]);
          pgn:=pgadgetnode(gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.editwindow^.pwin<>nil then
                setwindowtitles(pgn^.editwindow^.pwin,pointer(-1),@errorstring[1]);
              pgn:=pgn^.ln_succ;
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
end;

procedure clearerror;
var
  pdwn : pdesignerwindownode;
  pdmn : pdesignermenunode;
  pgn  : pgadgetnode;
  pin  : pimagenode;
begin
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while pdmn^.ln_succ<>nil do
    begin
      if pdmn^.editwindow<>nil then
        setwindowtitles(pdmn^.editwindow,pointer(-1),@frontscreentitle[1]);
        pdmn:=pdmn^.ln_succ;
    end;
  setwindowtitles(mainwindow,pointer(-1),@frontscreentitle[1]);
  if libwindow<>nil then
    setwindowtitles(libwindow,pointer(-1),@frontscreentitle[1]);      
  if localewindow<>nil then
    setwindowtitles(localewindow,pointer(-1),@frontscreentitle[1]);      
  {
  if upgradewin<>nil then
    setwindowtitles(upgradewin,pointer(-1),@frontscreentitle[1]);      
  }
  if maincodewindow<>nil then
    setwindowtitles(maincodewindow,pointer(-1),@frontscreentitle[1]);      
  {
  if defaulthelpwindownode.pwin<>nil then
    setwindowtitles(defaulthelpwindownode.pwin,pointer(-1),@frontscreentitle[1]);
  }
  pin:=pimagenode(teditimagelist.lh_head);
  while(pin^.ln_succ<>nil) do
    begin
      if pin^.editwindow<>nil then
        setwindowtitles(pin^.editwindow,pointer(-1),@frontscreentitle[1]);
      if pin^.displaywindow<>nil then
        setwindowtitles(pin^.displaywindow,pointer(-1),@frontscreentitle[1]);
      pin:=pin^.ln_succ;
    end;
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while pdwn^.ln_succ<>nil do
    begin
      with pdwn^ do
        begin
          if gadgetlistwindow<>nil then
            setwindowtitles(gadgetlistwindow,pointer(-1),@editscreentitle[1]);
          if bevelwindow<>nil then
            setwindowtitles(bevelwindow,pointer(-1),@editscreentitle[1]);
          if editwindow<>nil then
            setwindowtitles(editwindow,pointer(-1),@editscreentitle[1]);
          if tagswindow<>nil then
            setwindowtitles(tagswindow,pointer(-1),@editscreentitle[1]);
          if imagelistwindow<>nil then
            setwindowtitles(imagelistwindow,pointer(-1),@editscreentitle[1]);
          if optionswindow<>nil then
            setwindowtitles(optionswindow,pointer(-1),@editscreentitle[1]);
          if sizeswindow<>nil then
            setwindowtitles(sizeswindow,pointer(-1),@editscreentitle[1]);
          if idcmpwindow<>nil then
            setwindowtitles(idcmpwindow,pointer(-1),@editscreentitle[1]);
          if textlistwindow<>nil then
            setwindowtitles(textlistwindow,pointer(-1),@editscreentitle[1]);
          if codewindow<>nil then
            setwindowtitles(codewindow,pointer(-1),@editscreentitle[1]);
          if helpwin.pwin<>nil then
            setwindowtitles(helpwin.pwin,pointer(-1),@editscreentitle[1]);
          pgn:=pgadgetnode(gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.editwindow^.pwin<>nil then
                setwindowtitles(pgn^.editwindow^.pwin,pointer(-1),@editscreentitle[1]);
              pgn:=pgn^.ln_succ;
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
end;

procedure readallimagelistwindowgadgets(pdwn:pdesignerwindownode);
begin
  if (pdwn^.imageselected<>nil)and(pdwn^.imagelistwindow<>nil) then
    begin
      pdwn^.imageselected^.x:=getintegerfromgad(pdwn^.imagegadgets[10]);
      pdwn^.imageselected^.y:=getintegerfromgad(pdwn^.imagegadgets[11]);
    end;
end;

procedure disableselectonimagelistwindow(pdwn:pdesignerwindownode);
var
  l : byte;
begin
  if (not pdwn^.imagegadsdis) and (pdwn^.imagelistwindow<>nil) then
    begin
      for l:=8 to 11 do
        if l<>9 then
          gt_setsinglegadgetattr(pdwn^.imagegadgets[l],pdwn^.imagelistwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdwn^.imagegadgets[4],pdwn^.imagelistwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_selected,~0);
      pdwn^.imagegadsdis:=true;
    end;
end;

procedure enableselectonimagelistwindow(pdwn:pdesignerwindownode);
var
  l : byte;
begin
  if (pdwn^.imagegadsdis)and(pdwn^.imagelistwindow<>nil) then
    begin
      for l:=8 to 11 do 
        if l<>9 then
          gt_setsinglegadgetattr(pdwn^.imagegadgets[l],pdwn^.imagelistwindow,ga_disabled,long(false)); 
      gt_setsinglegadgetattr(pdwn^.imagegadgets[4],pdwn^.imagelistwindow,ga_disabled,long(false)); 
      pdwn^.imagegadsdis:=false;
    end;
end;

procedure setallimagelistwindowgadgets(pdwn:pdesignerwindownode);
var
  dummy : long;
  ptnn  : psmallimagenode;
  pin   : pimagenode;
begin
  if (pdwn^.imagelistwindow<>nil) and (pdwn^.imageselected<>nil) then
    begin
      enableselectonimagelistwindow(pdwn);
      dummy:=0;
      ptnn:=psmallimagenode(pdwn^.imagelist.lh_head);
      while(ptnn^.ln_succ<>nil)and(ptnn<>pdwn^.imageselected) do
        begin
          ptnn:=ptnn^.ln_succ;
          inc(dummy);
        end;
      if ptnn^.ln_succ=nil then
        dummy:=~0;
      pdwn^.bigimsel:=pdwn^.imageselected^.pin;
      gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_labels,long(@pdwn^.imagelist));
      if ptnn^.pin<>nil then
        begin
          pin:=pimagenode(teditimagelist.lh_head);
          dummy:=0;
          while (pin^.ln_succ<>nil)and(pin<>ptnn^.pin) do
            begin
              inc(dummy);
              pin:=pin^.ln_succ;
            end;
          gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_top,dummy);
          gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_selected,dummy);
        end
       else
        gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_selected,~0);
      gt_setsinglegadgetattr(pdwn^.imagegadgets[1], pdwn^.imagelistwindow,gtlv_selected,
          getlistpos(@pdwn^.imagelist,pnode(pdwn^.imageselected)));
      gt_setsinglegadgetattr(pdwn^.imagegadgets[10],pdwn^.imagelistwindow,gtin_number,pdwn^.imageselected^.x);
      gt_setsinglegadgetattr(pdwn^.imagegadgets[11],pdwn^.imagelistwindow,gtin_number,pdwn^.imageselected^.y);
    end
   else
    if pdwn^.imagelistwindow<>nil then
      disableselectonimagelistwindow(pdwn);
end;

procedure quickputimage(pdwn:pdesignerwindownode);
begin  
  drawbox(pdwn);
end;

procedure quickputtext(pdwn:pdesignerwindownode);
var
  ti : tintuitext;
begin
  ti.drawmode:=complement;
  ti.frontpen:=1;
  ti.backpen:=0;
  ti.leftedge:=box[1];
  ti.topedge:=box[2];
  if pdwn^.textselected^.screenfont then
    ti.itextfont:=pdwn^.editscreen^.font
   else
    ti.itextfont:=@pdwn^.textselected^.ta;
  ti.itext:=@pdwn^.textselected^.title[1];
  ti.nexttext:=nil;
  printitext(pdwn^.editwindow^.rport,@ti,pdwn^.offx,pdwn^.offy);
end;

procedure readalltextlistwindowgadgets(pdwn:pdesignerwindownode);
begin
  if (pdwn^.textselected<>nil)and(pdwn^.textlistwindow<>nil) then
    begin
      pdwn^.textselected^.title:=getstringfromgad(pdwn^.textgadgets[6])+#0;
      pdwn^.textselected^.x:=getintegerfromgad(pdwn^.textgadgets[2]);
      pdwn^.textselected^.y:=getintegerfromgad(pdwn^.textgadgets[3]);
      pdwn^.textselected^.screenfont:=checkedbox(pdwn^.textgadgets[14]);
      puttextintextlistwindow(pdwn,pdwn^.textselected);
    end;
end;

procedure disableselectontextlistwindow(pdwn:pdesignerwindownode);
var
  l : byte;
begin
  if (not pdwn^.textgadsdis) and (pdwn^.textlistwindow<>nil) then
    begin
      for l:=2 to 14 do 
        gt_setsinglegadgetattr(pdwn^.textgadgets[l],pdwn^.textlistwindow,ga_disabled,long(true));
      pdwn^.textgadsdis:=true;
    end;
end;

procedure enableselectontextlistwindow(pdwn:pdesignerwindownode);
var
  l : byte;
begin
  if (pdwn^.textgadsdis)and(pdwn^.textlistwindow<>nil) then
    begin
      for l:=2 to 14 do 
        gt_setsinglegadgetattr(pdwn^.textgadgets[l],pdwn^.textlistwindow,ga_disabled,long(false)); 
      pdwn^.textgadsdis:=false;
    end;
end;

procedure setalltextlistwindowgadgets(pdwn:pdesignerwindownode);
var
  dummy : long;
  ptnn:ptextnode;
begin
  if (pdwn^.textlistwindow<>nil)and(pdwn^.textselected<>nil) then
    begin
      dummy:=0;
      ptnn:=ptextnode(pdwn^.textlist.lh_head);
      while(ptnn^.ln_succ<>nil)and(ptnn<>pdwn^.textselected) do
        begin
          ptnn:=ptnn^.ln_succ;
          inc(dummy);
        end;
      puttextintextlistwindow(pdwn,pdwn^.textselected);
      gt_setsinglegadgetattr(pdwn^.textgadgets[1],pdwn^.textlistwindow,gtlv_top,dummy);
      gt_setsinglegadgetattr(pdwn^.textgadgets[1],pdwn^.textlistwindow,gtlv_selected,dummy);
      gt_setsinglegadgetattr(pdwn^.textgadgets[2],pdwn^.textlistwindow,gtin_number,long(pdwn^.textselected^.x));
      gt_setsinglegadgetattr(pdwn^.textgadgets[3],pdwn^.textlistwindow,gtin_number,long(pdwn^.textselected^.y));
      gt_setsinglegadgetattr(pdwn^.textgadgets[4],pdwn^.textlistwindow,gtpa_color,long(pdwn^.textselected^.frontpen));
      gt_setsinglegadgetattr(pdwn^.textgadgets[5],pdwn^.textlistwindow,gtpa_color,long(pdwn^.textselected^.backpen));
      gt_setsinglegadgetattr(pdwn^.textgadgets[6],pdwn^.textlistwindow,gtst_string,long(@pdwn^.textselected^.title[1]));
      gt_setsinglegadgetattr(pdwn^.textgadgets[7],pdwn^.textlistwindow,gtcb_checked,
                             long((inversvid or pdwn^.textselected^.drawmode)=inversvid));
      gt_setsinglegadgetattr(pdwn^.textgadgets[14],pdwn^.textlistwindow,gtcb_checked,long(pdwn^.textselected^.screenfont));
      gt_setsinglegadgetattr(pdwn^.textgadgets[9],pdwn^.textlistwindow,gtcb_checked,
                             long((pdwn^.textselected^.drawmode and jam2)<>0));
      gt_setsinglegadgetattr(pdwn^.textgadgets[8],pdwn^.textlistwindow,gtcb_checked,
                             long((pdwn^.textselected^.drawmode and complement)<>0));
      gt_setsinglegadgetattr(pdwn^.textgadgets[10],pdwn^.textlistwindow,gtcb_checked,
                             long((pdwn^.textselected^.drawmode and inversvid)<>0));
    end;
end;

procedure FreezeWindow(pwin : pwindow);
begin
  if pwin<>nil then
    begin
      setpointer(pwin,pwaitpointer,16,16,-6,0);
      forbid;
      pwin^.flags:=pwin^.flags or wflg_rmbtrap;
      permit;
    end;
end;

procedure UnFreezeWindow(pwin : pwindow);
begin
  if pwin<>nil then
    begin
      clearpointer(pwin);
      forbid;
      pwin^.flags:=pwin^.flags and ~wflg_rmbtrap;
      permit;
    end;
end;

procedure waiteverything;
var
  pdwn : pdesignerwindownode;
  pgn  : pgadgetnode;
  pdmn : pdesignermenunode;
  pin  : pimagenode;
  pdsn : pdesignerscreennode;
begin
  waiting:=true;
  pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
  while (pdsn^.ln_succ<>nil) do
    begin
      FreezeWindow(pdsn^.editwindow);
      pdsn:=pdsn^.ln_succ;
    end;
  
  FreezeWindow(edittagswindow);
  FreezeWindow(mainwindow);
  FreezeWindow(libwindow);
  FreezeWindow(maincodewindow);
  FreezeWindow(prefswindow);
  FreezeWindow(localewindow);
  {
  if upgradewin<>nil then
    freezewindow(upgradewin);
  }
  pin:=pimagenode(teditimagelist.lh_head);
  while (pin^.ln_succ<>nil) do
    begin
      FreezeWindow(pin^.editwindow);
      FreezeWindow(pin^.displaywindow);
      pin:=pin^.ln_succ;
    end;
  
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while pdwn^.ln_succ<>nil do
    begin
      with pdwn^ do
        begin
          FreezeWindow(magnifywindow);
          FreezeWindow(gadgetlistwindow);
          FreezeWindow(bevelwindow);
          FreezeWindow(imagelistwindow);
          FreezeWindow(textlistwindow);
          FreezeWindow(editwindow);
          FreezeWindow(tagswindow);
          FreezeWindow(optionswindow);
          FreezeWindow(sizeswindow);
          FreezeWindow(idcmpwindow);
          FreezeWindow(codewindow);
          pgn:=pgadgetnode(gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.editwindow<>nil then
                FreezeWindow(pgn^.editwindow^.pwin);
              pgn:=pgn^.ln_succ;
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
  
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while (pdmn^.ln_succ<>nil) do
    begin
      FreezeWindow(pdmn^.editwindow);
      pdmn:=pdmn^.ln_succ;
    end;
end;

procedure unwaiteverything;
var
  pdwn : pdesignerwindownode;
  pgn  : pgadgetnode;
  pdmn : pdesignermenunode;
  pin  : pimagenode;
  pdsn : pdesignerscreennode;
begin
  waiting:=false;
  pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
  while (pdsn^.ln_succ<>nil) do
    begin
      unFreezeWindow(pdsn^.editwindow);
      pdsn:=pdsn^.ln_succ;
    end;

  UnFreezeWindow(mainwindow);
  UnFreezeWindow(libwindow);
  UnFreezeWindow(maincodewindow);
  UnFreezeWindow(prefswindow);
  UnFreezeWindow(localewindow);
  UnFreezeWindow(edittagswindow);

  {
  if upgradewin<>nil then
    unfreezewindow(upgradewin);
  }
  pin:=pimagenode(teditimagelist.lh_head);
  while (pin^.ln_succ<>nil) do
    begin
      UnFreezeWindow(pin^.editwindow);
      UnFreezeWindow(pin^.displaywindow);
      pin:=pin^.ln_succ;
    end;
  pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
  while pdwn^.ln_succ<>nil do
    begin
      with pdwn^ do
        begin
          UnFreezeWindow(magnifywindow);
          UnFreezeWindow(bevelwindow);
          UnFreezeWindow(imagelistwindow);
          UnFreezeWindow(textlistwindow);
          UnFreezeWindow(editwindow);
          UnFreezeWindow(gadgetlistwindow);
          UnFreezeWindow(tagswindow);
          UnFreezeWindow(optionswindow);
          UnFreezeWindow(sizeswindow);
          UnFreezeWindow(idcmpwindow);
          UnFreezeWindow(codewindow);
          pgn:=pgadgetnode(gadgetlist.lh_head);
          while (pgn^.ln_succ<>nil) do
            begin
              if pgn^.editwindow<>nil then
                UnFreezeWindow(pgn^.editwindow^.pwin);
              pgn:=pgn^.ln_succ;
            end;
        end;
      pdwn:=pdwn^.ln_succ;
    end;
  pdmn:=pdesignermenunode(teditmenulist.lh_head);
  while (pdmn^.ln_succ<>nil) do
    begin
      UnFreezeWindow(pdmn^.editwindow);
      pdmn:=pdmn^.ln_succ;
    end;
end;

procedure puttextintextlistwindow(pdwn:pdesignerwindownode;ptn:ptextnode);
var
  x,y : long;
begin
  if (pdwn^.textlistwindow<>nil) then
    begin
      setapen(pdwn^.textlistwindow^.rport,0);
      setdrmd(pdwn^.textlistwindow^.rport,jam1);
      rectfill(pdwn^.textlistwindow^.rport,15,pdwn^.textlistwindow^.height-30,540,pdwn^.textlistwindow^.height-8);
      y:=pdwn^.textlistwindow^.height-16-(ptn^.ta.ta_ysize div 2);
      x:=(pdwn^.textlistwindow^.width div 2)-(intuitextlength(pintuitext(@ptn^.frontpen)) div 2);
      if y<pdwn^.textlistwindow^.height-30 then
        y:=pdwn^.textlistwindow^.height-30;
      if x<14 then x:=14;
      x:=x-ptn^.x;
      y:=y-ptn^.y;
      if ptn^.screenfont then
        ptn^.pta:=pdwn^.editscreen^.font
       else
        ptn^.pta:=@ptn^.ta;
      printitext(pdwn^.textlistwindow^.rport,pintuitext(@ptn^.frontpen),x,y);
    end;
end;

function layerxoffset(pwin:pwindow):long;
begin
  layerxoffset:=pwin^.rport^.layer^.scroll_x;
end;

function layeryoffset(pwin:pwindow):long;
begin
  layeryoffset:=pwin^.rport^.layer^.scroll_y;
end;

procedure openafewimages;
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
begin
  if aslrequest(imagefilerequest,nil) then
    begin
      dir:='';
      loop:=1;
      ctopas(imagefilerequest^.fr_drawer^,dir);
      dir:=dir+#0;
      numofargs:=imagefilerequest^.fr_numargs;
      count:=0;
      pargs:=pwbargarray(imagefilerequest^.fr_arglist);
      while (numofargs>0) do
       begin
        dec(numofargs);
        title:='';
        loop:=1;
        ctopas(pargs^[count].wa_name^,title);
        title:=title+#0;
        dir2:=dir;
        if addpart(@dir2[1],@title[1],253) then
          begin
            pin:=readiffimage(@dir2[1]);
            if pin<>nil then
              begin
                pin^.title:=title;
                gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                  gtlv_labels,~0);
                addtail(@teditimagelist,pnode(pin));
                gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                  gtlv_labels,long(@teditimagelist));
              end;
          end;
        inc(count);
       end;
    end;
end;

procedure replaceimage(oldpin : pimagenode);
const
  pat2 : string[11] = '~(#?.info)'#0;
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
  settagitem(@tags[1],asl_hail,long(@strings[125,1]));
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
              pin:=readiffimage(@dir2[1]);
              if pin<>nil then
                begin
                  closeimagedisplaywindow(oldpin);
                  if oldpin^.imagedata<>nil then
                    freemymem(oldpin^.imagedata,oldpin^.sizeallocated);
                  if oldpin^.colourmap<>nil then
                    freemymem(oldpin^.colourmap,oldpin^.mapsize);
                  oldpin^.colourmap:=pin^.colourmap;
                  oldpin^.mapsize:=pin^.mapsize;
                  oldpin^.sizeallocated:=pin^.sizeallocated;
                  oldpin^.leftedge:=pin^.leftedge;
                  oldpin^.topedge:=pin^.topedge;
                  oldpin^.width:=pin^.width;
                  oldpin^.height:=pin^.height;
                  oldpin^.depth:=pin^.depth;
                  oldpin^.imagedata:=pin^.imagedata;
                  oldpin^.planepick:=pin^.planepick;
                  oldpin^.planeonoff:=pin^.planeonoff;
                  oldpin^.nextimage:=pin^.nextimage;
                  if oldpin^.editwindow<>nil then
                    begin
                      gt_setsinglegadgetattr(oldpin^.editwindowgads[0],oldpin^.editwindow,
                              gtst_string,long(@oldpin^.title[1]));
                      gt_setsinglegadgetattr(oldpin^.editwindowgads[5],oldpin^.editwindow,gtnm_number,long(oldpin^.width)); 
                      gt_setsinglegadgetattr(oldpin^.editwindowgads[6],oldpin^.editwindow,gtnm_number,long(oldpin^.height));
                      gt_setsinglegadgetattr(oldpin^.editwindowgads[7],oldpin^.editwindow,gtnm_number,long(oldpin^.depth));
                      
                      if oldpin^.imagedata<>nil then
                        gt_setsinglegadgetattr(oldpin^.editwindowgads[25],oldpin^.editwindow,gtnm_number,
                                  oldpin^.sizeallocated)
                       else
                        gt_setsinglegadgetattr(oldpin^.editwindowgads[25],oldpin^.editwindow,gtnm_number,0);
                      
                      if oldpin^.colourmap<>nil then
                        gt_setsinglegadgetattr(oldpin^.editwindowgads[26],oldpin^.editwindow,gtnm_number,
                                  long(oldpin^.mapsize div 4))
                       else
                        gt_setsinglegadgetattr(oldpin^.editwindowgads[26],oldpin^.editwindow,gtnm_number,0);
                      for loop:=0 to 7 do
                        begin
                          gt_setsinglegadgetattr(oldpin^.editwindowgads[8+loop],oldpin^.editwindow,
                                                 gtcb_checked,long((oldpin^.planepick and (1 shl loop))<>0));
                          gt_setsinglegadgetattr(oldpin^.editwindowgads[16+loop],oldpin^.editwindow,
                                                 gtcb_checked,long((oldpin^.planeonoff and (1 shl loop))<>0));
                        end;
                    end;
                  pdmn:=pdesignermenunode(teditmenulist.lh_head);
                  while(pdmn^.ln_succ<>nil) do
                    begin
                      if pdmn^.editwindow<>nil then
                        begin
                          if pdmn^.testmenu<>nil then
                            clearmenustrip(pdmn^.editwindow);
                          testmenu(pdmn);
                        end;
                      pdmn:=pdmn^.ln_succ;
                    end;
                  freemymem(pin,sizeof(timagenode));
                end
               else
                telluser(mainwindow,'Could not get file.');
            end;
        end;
      freeaslrequest(pointer(ifr));
    end
   else
    telluser(mainwindow,'Could not get file requester.');
  inputmode:=1;
  unwaiteverything;
end;

function allocasls:boolean;
const
  pat1 : string[7] = '#?.des'#0;
  pat2 : string[11] = '~(#?.info)'#0;
var
  tags : array[1..4] of ttagitem;
begin
  allocasls:=false;
  settagitem(@tags[1],asl_hail,long(@strings[125,1]));
  settagitem(@tags[2],asl_funcflags,filf_multiselect);
  settagitem(@tags[3],asl_pattern,long(@pat2[1]));
  settagitem(@tags[4],tag_done,0);
  imagefilerequest:=allocaslrequest(asl_filerequest,@tags[1]);
  if imagefilerequest<>nil then
    begin
      settagitem(@tags[1],asl_funcflags,fonf_styles or 
                                        fonf_newidcmp);
      settagitem(@tags[2],asl_hail,long(@strings[152,1]));
      settagitem(@tags[3],tag_done,0);
      fontrequest:=allocaslrequest(asl_fontrequest,@tags[1]);
      if fontrequest<>nil then
        begin
          settagitem(@tags[1],asl_hail,long(@strings[186,1]));
          settagitem(@tags[2],asl_pattern,long(@pat1[1]));
          settagitem(@tags[3],asl_funcflags,filf_patgad);
          settagitem(@tags[4],tag_done,0);
          loadsaverequest:=allocaslrequest(asl_filerequest,@tags[1]);
          if loadsaverequest<>nil then
            begin
              allocasls:=true;
            end
           else
            begin
              freeaslrequest(imagefilerequest);
              freeaslrequest(fontrequest);
            end
        end
       else
        freeaslrequest(imagefilerequest);
    end;
end;

procedure freeasls;
begin
  if imagefilerequest<>nil then
    freeaslrequest(imagefilerequest);
  if fontrequest<>nil then
    freeaslrequest(fontrequest);
  if loadsaverequest<>nil then
    freeaslrequest(loadsaverequest);
end;

function setimagedata(var ti : timage;p:pointer;ty:byte):boolean;
begin
  setimagedata:=false;
  ti.leftedge:=0;
  ti.topedge:=0;
  if (ty=1) or (ty=2) then 
    begin
      ti.width:=82;
      ti.height:=12;
      ti.depth:=2;
      ti.imagedata:=allocmymem(288,memf_chip or memf_clear);
    end;
  if (ty=3) then
    begin
      ti.imagedata:=allocmymem(112,memf_chip or memf_clear);
      ti.width:=20;
      ti.height:=14;
      ti.depth:=2;
    end;
  if (ty=4) then
    begin
      ti.imagedata:=allocmymem(56,memf_chip or memf_clear);
      ti.width:=20;
      ti.height:=14;
      ti.depth:=1;
    end;
  if ti.imagedata<>nil then
    begin
      if ty=1 then
        copymem(p,ti.imagedata,288);
      if ty=2 then
        copymem(p,ti.imagedata,144);
      if ty=3 then
        copymem(p,ti.imagedata,112);
      if ty=4 then
        copymem(p,ti.imagedata,56);  
      setimagedata:=true;
    end;
  ti.planepick:=3;
  ti.planeonoff:=0;
  ti.nextimage:=nil;
end;

procedure checkgadsize(pdwn:pdesignerwindownode;pgn:pgadgetnode);
const
  s : string[3]='WW'#0;
var
  minw,minh : word;
  it        : tintuitext;
  psn       : pstringnode;
  pgn2      : pgadgetnode;
begin
  minw:=0;
  minh:=0;
  with it do
    begin
      if pdwn^.codeoptions[6] then
        begin
          if pdwn^.codeoptions[17] then
            itextfont:=pdwn^.editscreen^.font
           else
            itextfont:=@pdwn^.gadgetfont;
        end
       else
        itextfont:=@pgn^.font;
      itext:=@s[1];
      nexttext:=nil;
    end;
  case pgn^.kind of
    button_kind : begin
                    minw:=4;
                    minh:=2;
                  end;
    listview_kind : begin
                      minw:=4+intuitextlength(@it)+pgn^.tags[4].ti_data+8;
                      minh:=pgn^.font.ta_ysize+4;
                      if (pgn^.tags[3].ti_data=0)and(pgn^.tags[3].ti_tag=gtlv_showselected) then
                        minh:=minh+pgn^.font.ta_ysize+4;
                      pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                      if (pgn^.tags[3].ti_data<>0)and(pgn^.tags[3].ti_tag=gtlv_showselected) then
                        begin
                          checkgadsize(pdwn,pgn2);
                          minh:=minh+pgn2^.h;
                          if not pdwn^.codeoptions[6] then
                            it.itextfont:=@pgn2^.font;
                          if minw<8+intuitextlength(@it) then
                            minw:=8+intuitextlength(@it);
                        end;
                    end;
    string_kind : begin
                    minw:=8+intuitextlength(@it);
                    minh:=pgn^.font.ta_ysize+4;
                  end;
    integer_kind : begin
                     minw:=8+intuitextlength(@it);
                     minh:=pgn^.font.ta_ysize+4;
                   end;
    cycle_kind : begin
                   minw:=4+intuitextlength(@it);
                   minh:=pgn^.font.ta_ysize+4;
                 end;
    slider_kind : begin
                    minw:=0;
                    minh:=0;
                  end;
    scroller_kind : begin
                     minw:=0;
                     minh:=0;
                   end;
    palette_kind : begin
                     minw:=5;
                     minh:=5;
                   end;
    text_kind : begin
                  minw:=4+intuitextlength(@it);
                  minh:=pgn^.font.ta_ysize+4;
                end;
    number_kind : begin
                    minw:=4+intuitextlength(@it);
                    minh:=pgn^.font.ta_ysize+4;
                  end;
    mx_kind     : begin
                    minw:=0;
                    minh:=0;
                  end;
    checkbox_kind : begin
                      minw:=5;
                      minh:=5;
                    end;
   end;
  if pgn^.w<minw then
    pgn^.w:=minw;
  if pgn^.h<minh then
    pgn^.h:=minh;
end;

procedure drawhighbox(x,y,w,h:word;pwin:pwindow);
var
  coords : array [1..10] of word;
  tb     : tborder;
begin
  coords[1]:=x;
  coords[2]:=y;
  coords[3]:=x+w-1;
  coords[4]:=y;
  coords[5]:=x+w-1;
  coords[6]:=y+h-1;
  coords[7]:=x;
  coords[8]:=y+h-1;
  coords[9]:=x;
  coords[10]:=y+1;
  with tb do
    begin
      nextborder:=nil;
      leftedge:=0;
      topedge:=0;
      drawmode:=complement;
      count:=5;
      xy:=@coords[1];
    end;
  setdrpt(pwin^.rport,$FFFF);
  drawborder(pwin^.rport,@tb,0,0);
end;

procedure highlightgadget(pgn,pdwn);
var
  h : long;
  fontysize : word;
begin
  if not ((pgn^.joined) and (pgn^.kind=string_kind)) then
    begin
      if pdwn^.codeoptions[17] then
        fontysize:=pdwn^.editscreen^.font^.ta_ysize
       else
        if pdwn^.codeoptions[6] then
          fontysize:=pdwn^.gadgetfont.ta_ysize
         else
          fontysize:=pgn^.font.ta_ysize;
      if (pgn^.kind=mx_kind) then
        h:=sizeoflist(@pgn^.infolist)*(fontysize+pgn^.tags[2].ti_data)-pgn^.tags[2].ti_data+1
       else
        h:=pgn^.h;
      drawhighbox(pgn^.x-1+pdwn^.offx,pgn^.y-1+pdwn^.offy,pgn^.w+2,h+2,pdwn^.editwindow);
      drawhighbox(pgn^.x-2+pdwn^.offx,pgn^.y-2+pdwn^.offy,pgn^.w+4,h+4,pdwn^.editwindow);
    end;
end;

function togglegad(x,y,id:word;
                   ptxt:pbyte;
                   pprevgad:pgadget;
                   pdwn:pdesignerwindownode;
                  ):pgadget;
var
  pgad : pgadget;
begin
  pgad:=generalgadtoolsgad(generic_kind,x,y,81,12,id,nil,
                    @ttopaz80,0,pdwn^.helpwin.screenvisinfo,pprevgad,nil,pendtagitem);
  if pgad<>nil then
    with pgad^ do
      begin
        flags:=(flags or gflg_gadghimage or gflg_gadgimage);
        activation:=activation or
                    gact_immediate;
        gadgetrender:=pdwn^.gadbord1;
        selectrender:=pdwn^.gadbord2;
        if ptxt<>nil then
          begin
            pgad^.gadgettext:=allocmymem(sizeof(tintuitext),memf_any or memf_clear);
            if pgad^.gadgettext<>nil then
              with pgad^.gadgettext^ do
                begin
                  frontpen:=1;
                  drawmode:=jam1;
                  topedge:=round((11-ttopaz80.tta_ysize+1)/2);
                  itextfont:=@ttopaz80;
                  itext:=ptxt;
                  nexttext:=nil;
                  leftedge:=round((81-intuitextlength(pgad^.gadgettext))/2);
                end
             else
              pgad:=nil;
          end;
      end;
  togglegad:=pgad;
end;

{
procedure setupoptionswindowborders(pdwn:pdesignerwindownode;screendrawinfo:pdrawinfo);
var
  width  : word;
  height : word;
  pens   : pwordarray;
begin
  width:=82;
  height:=12;
  optionsgadgetscoords[1]:=width-1;
  optionsgadgetscoords[2]:=0;
  optionsgadgetscoords[3]:=0;
  optionsgadgetscoords[4]:=0;
  optionsgadgetscoords[5]:=0;
  optionsgadgetscoords[6]:=height-1;
  optionsgadgetscoords[7]:=1;
  optionsgadgetscoords[8]:=height-2;
  optionsgadgetscoords[9]:=1;
  optionsgadgetscoords[10]:=1;
  optionsgadgetscoords[11]:=1;
  optionsgadgetscoords[12]:=height-1;
  optionsgadgetscoords[13]:=width-1;
  optionsgadgetscoords[14]:=height-1;
  optionsgadgetscoords[15]:=width-1;
  optionsgadgetscoords[16]:=0;
  optionsgadgetscoords[17]:=width-2;
  optionsgadgetscoords[18]:=1;
  optionsgadgetscoords[19]:=width-2;
  optionsgadgetscoords[20]:=height-2;
end;
}

function checkedbox(pgad:pgadget):boolean;
begin
  checkedbox:=(pgad^.flags and gflg_selected)<>0;
end;

function getstringfromgad(pgad:pgadget):string;
var
  psi   : pstringinfo;
  strin : string;
  {
  pcs   : pcstring;
  loop  : word;
  }
begin
  psi:=pstringinfo(pgad^.specialinfo);  
  ctopas(psi^.buffer^,strin);
  {
  pcs:=pcstring(psi^.buffer);
  loop:=1;
  while (pcs^[loop]<>0) do
    begin
      strin:=strin+chr(pcs^[loop]);
      inc(loop);
    end;
  }
  getstringfromgad:=strin+#0;
end;

function getintegerfromgad(pgad:pgadget):long;
var
  psi   : pstringinfo;
begin
  psi:=pstringinfo(pgad^.specialinfo);
  getintegerfromgad:=psi^.longint_;
end;

procedure drawbox(pdwn:pdesignerwindownode);
var
  boxborder : tborder;
  coords    : array[1..10] of word;
begin
  boxborder.nextborder:=nil;
  boxborder.leftedge:=0;
  boxborder.topedge:=0;
  if pdwn^.useoffsets then
    begin
      boxborder.leftedge:=0;
      boxborder.topedge:=0;
    end;
  boxborder.drawmode:=complement;
  boxborder.xy:=@coords[1];
 if inputmode=7 then
   begin
     boxborder.count:=2;
     coords[1]:=box[1];
     coords[2]:=box[2];
     coords[3]:=box[1];
     coords[4]:=box[4];
   end
  else
   if inputmode=8 then
     begin
       boxborder.count:=2;
       coords[1]:=box[1];
       coords[2]:=box[2];
       coords[3]:=box[3];
       coords[4]:=box[2];
     end
    else
     begin
       boxborder.count:=5;
       coords[1]:=box[1];
       coords[2]:=box[2];
       coords[3]:=box[3];
       coords[4]:=box[2];
       coords[5]:=box[3];
       coords[6]:=box[4];
       coords[7]:=box[1];
       coords[8]:=box[4];
       coords[9]:=box[1];
       if box[2]<box[4] then 
         coords[10]:=box[2]+1
        else
         coords[10]:=box[2]-1;
     end;
  {
  setdrpt(pdwn^.editwindow^.rport,$FFFF);
  }
  drawborder(pdwn^.editwindow^.rport,@boxborder,pdwn^.offx,pdwn^.offy);
end;

procedure readtagswindowgadgets(pdwn);
var
  l : byte;
begin
  if pdwn^.tagswindow<>nil then
    with pdwn^ do
      begin
        for l:=1 to 3 do
          moretags[l]:=checkedbox(moretaggads[l]);
        sizegad:=(tagsgads[1]^.flags and gflg_selected)<>0;
        sizebright:=(tagsgads[2]^.flags and gflg_selected)<>0;
        sizebbottom:=(tagsgads[3]^.flags and gflg_selected)<>0;
        defpubname:=getstringfromgad(defpubgadget);
        dragbar:=(tagsgads[4]^.flags and gflg_selected)<>0;
        depthgad:=(tagsgads[5]^.flags and gflg_selected)<>0;
        closegad:=(tagsgads[6]^.flags and gflg_selected)<>0;
        reportmouse:=(tagsgads[7]^.flags and gflg_selected)<>0;
        nocarerefresh:=(tagsgads[8]^.flags and gflg_selected)<>0;
        borderless:=(tagsgads[9]^.flags and gflg_selected)<>0;
        backdrop:=(tagsgads[10]^.flags and gflg_selected)<>0;
        if gimmezz then
          if not checkedbox(tagsgads[11]) then
            begin
              pdwn^.h:=pdwn^.h-pdwn^.editwindow^.bordertop;
              pdwn^.w:=pdwn^.w-pdwn^.editwindow^.borderleft;
            end;
        gimmezz:=(tagsgads[11]^.flags and gflg_selected)<>0;
        activate:=(tagsgads[12]^.flags and gflg_selected)<>0;
        rmbtrap:=(tagsgads[13]^.flags and gflg_selected)<>0;
        simplerefresh:=(tagsgads[14]^.flags and gflg_selected)<>0;
        smartrefresh:=(tagsgads[15]^.flags and gflg_selected)<>0;
        autoadjust:=(tagsgads[16]^.flags and gflg_selected)<>0;
        menuhelp:=(tagsgads[17]^.flags and gflg_selected)<>0;
        
        if cyclepos=0 then
          gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
        title:=getstringfromgad(tagsgads[18]);
        if cyclepos=0 then
          begin
            gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditwindowlist));
            gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
          end;
        screentitle:=getstringfromgad(tagsgads[19]);
        labelid:=getstringfromgad(tagsgads[20]);
        
        customscreen:=(tagsgads[21]^.flags and gflg_selected)<>0;
        pubscreen:=(tagsgads[22]^.flags and gflg_selected)<>0;
        pubscreenname:=(tagsgads[23]^.flags and gflg_selected)<>0;
        pubscreenfallback:=(tagsgads[24]^.flags and gflg_selected)<>0;
        usezoom:=(tagsgads[27]^.flags and gflg_selected)<>0;
        
        mousequeue:=getintegerfromgad(tagsgads[25]);
        rptqueue:=getintegerfromgad(tagsgads[26]);
      end;
end;

procedure settagswindowgadgets(pdwn);
var
  l : byte;
begin
  if pdwn^.tagswindow<>nil then
    with pdwn^ do
      begin
        gt_setsinglegadgetattr(tagsgads[1 ],tagswindow,gtcb_checked,long(sizegad));
        gt_setsinglegadgetattr(tagsgads[2 ],tagswindow,gtcb_checked,long(sizebright));
        gt_setsinglegadgetattr(tagsgads[3 ],tagswindow,gtcb_checked,long(sizebbottom));
        gt_setsinglegadgetattr(tagsgads[4 ],tagswindow,gtcb_checked,long(dragbar));
        gt_setsinglegadgetattr(tagsgads[5 ],tagswindow,gtcb_checked,long(depthgad));
        gt_setsinglegadgetattr(tagsgads[6 ],tagswindow,gtcb_checked,long(closegad));
        gt_setsinglegadgetattr(tagsgads[7 ],tagswindow,gtcb_checked,long(reportmouse));
        gt_setsinglegadgetattr(tagsgads[8 ],tagswindow,gtcb_checked,long(nocarerefresh));
        gt_setsinglegadgetattr(tagsgads[9 ],tagswindow,gtcb_checked,long(borderless));
        gt_setsinglegadgetattr(tagsgads[10],tagswindow,gtcb_checked,long(backdrop));
        gt_setsinglegadgetattr(tagsgads[11],tagswindow,gtcb_checked,long(gimmezz));
        gt_setsinglegadgetattr(tagsgads[12],tagswindow,gtcb_checked,long(activate));
        gt_setsinglegadgetattr(tagsgads[13],tagswindow,gtcb_checked,long(rmbtrap));
        gt_setsinglegadgetattr(tagsgads[14],tagswindow,gtcb_checked,long(simplerefresh));
        gt_setsinglegadgetattr(tagsgads[15],tagswindow,gtcb_checked,long(smartrefresh));
        gt_setsinglegadgetattr(tagsgads[16],tagswindow,gtcb_checked,long(autoadjust));
        gt_setsinglegadgetattr(tagsgads[17],tagswindow,gtcb_checked,long(menuhelp));
        gt_setsinglegadgetattr(tagsgads[18],tagswindow,gtst_string ,long(@title[1]));
        gt_setsinglegadgetattr(tagsgads[19],tagswindow,gtst_string ,long(@screentitle[1]));
        gt_setsinglegadgetattr(tagsgads[20],tagswindow,gtst_string ,long(@labelid[1]));
        gt_setsinglegadgetattr(defpubgadget,tagswindow,gtst_string ,long(@defpubname[1]));
        gt_setsinglegadgetattr(tagsgads[21],tagswindow,gtcb_checked,long(customscreen));
        gt_setsinglegadgetattr(tagsgads[22],tagswindow,gtcb_checked,long(pubscreen));
        gt_setsinglegadgetattr(tagsgads[23],tagswindow,gtcb_checked,long(pubscreenname));
        gt_setsinglegadgetattr(tagsgads[24],tagswindow,gtcb_checked,long(pubscreenfallback));
        gt_setsinglegadgetattr(tagsgads[25],tagswindow,gtin_number ,long(mousequeue));
        gt_setsinglegadgetattr(tagsgads[26],tagswindow,gtin_number ,long(rptqueue));
        gt_setsinglegadgetattr(tagsgads[27],tagswindow,gtcb_checked,long(usezoom));
        for l:=1 to 3 do
           gt_setsinglegadgetattr(moretaggads[l],tagswindow,gtcb_checked,long(moretags[l]));
      end
end;

function checkprotection:boolean;
var
  loop   : byte;
  total  : long;
  total2 : pword;
begin
  {IOC 2002 remove protection }
  checkprotection:=true
  { commentd out IOC 2002
  total:=0;
  for loop:=0 to 11 do
    begin
      total:=total+ord(ian[loop]);
    end;
  for loop:=0 to 40 do
    begin
      total:=total+ord(crypt1[loop])+ord(crypt2[loop]);
    end;
  imrun:=true;
  if total=7673 then
    begin
      total:=0;
      total2:=pword(@registerstore[40]);
      if imrun then
        for loop:=0 to 38 do
          total:=total+ord(registerstore[loop]);
    
      checkprotection:=true
      
      if demoversion then
        checkprotection:=true
       else
        checkprotection:=(total2^=total);
  
    end
   else
    checkprotection:=false;
  if imrun then;
  end of commented out IOC 2002 }
end;

procedure setdefaultwindow(pdwn);
var
  pn    : pnode;
  dummy : word;
begin
  with pdwn^ do
    begin
      copymem(@defaultscreenmode,@screenprefs,sizeof(tscreenmodeprefs));
      screenprefs.changed:=false;
      pdwn^.codeoptions[1 ]:=true;
      pdwn^.codeoptions[2 ]:=true;
      pdwn^.codeoptions[3 ]:=true;
      pdwn^.codeoptions[4 ]:=true;
      pdwn^.codeoptions[5 ]:=true;
      pdwn^.codeoptions[6 ]:=true;
     {pdwn^.codeoptions[7 ]:=false;}
     {pdwn^.codeoptions[8 ]:=false;}
      pdwn^.codeoptions[9 ]:=true;
      pdwn^.codeoptions[10]:=true;
     {pdwn^.codeoptions[11]:=false;}
      pdwn^.codeoptions[12]:=true;
      pdwn^.codeoptions[13]:=true;
      pdwn^.codeoptions[14]:=true;
      pdwn^.codeoptions[15]:=true;
      pdwn^.codeoptions[16]:=true;
     {pdwn^.codeoptions[17]:=False;}
      for dummy:=1 to 5 do
        pdwn^.localeoptions[dummy]:=prefsvalues[15];
      y:=20;
      x:=300;
      w:=300;
      h:=150;
      {
      customscreen:=false;
      pubscreen:=false;
      pubscreenname:=false;
      pubscreenfallback:=false;
      }
      ln_name:=@title[1];
      ln_type:=designerwindownodetype;
      dummy:=0;
      pn:=teditwindowlist.lh_head;
      while (pn^.ln_succ<>nil) do
        begin
          inc(dummy);
          pn:=pn^.ln_succ;
        end;
      str(dummy,labelid);
      title:='New Window '+labelid+#0;
      labelid:='Win'+labelid;
      backoptwin:=true;
      {
      with helpwin do
        begin
          ln_type:=helpwindownodetype;
          pwin:=nil;
          glist:=nil;
          newlist(@hl);
          pscr:=nil;
          screenvisinfo:=nil;
        end;
      }
      helpwin.ln_type:=helpwindownodetype;
      {
      newlist(@helpwin.hl);
      }
      screentitle:=''#0;
      {
      editscreen:=nil;
      tagswindow:=nil;
      tagsglist:=nil;
      textlistwindow:=nil;
      textlistglist:=nil;
      sizeswindow:=nil;
      sizesglist:=nil;
      idcmpwindow:=nil;
      idcmpglist:=nil;
      }
      newlist(@bevelboxlist);
      newlist(@gadgetlist);
      newlist(@textlist);
      newlist(@imagelist);
      copymem(@defaultidcmpvalues,@pdwn^.idcmplist,
              sizeof(defaultidcmpvalues));
      {
      imageselected:=nil;
      bigimsel:=nil;
      imagelistwindow:=nil;
      imagelistglist:=nil;
      }
      minw:=150;
      maxw:=1200;
      minh:=25;
      maxh:=1200;
      {
      offsetsdone:=false;
      nextid:=0;
      }
      useoffsets:=true;
      {
      innerw:=0;
      innerh:=0;
      }
      zoom[1]:=200;
      {
      zoom[2]:=0;
      }
      zoom[3]:=200;
      zoom[4]:=25;
      {
      mxchoice:=0;
      }
      usezoom:=true;
      coordstitle:='Hello'#0;
      usecoordswindow:=true;
      {
      textselected:=nil;
      }
      mousequeue:=5;
      {
      biggad:=nil;
      }
      spreadsize:=3;
      {
      spreadpos:=0;
      }
      rptqueue:=3;
      sizegad:=true;
      sizebright:=true;
      sizebbottom:=false;
      dragbar:=true;
      depthgad:=true;
      closegad:=true;
      {
      reportmouse:=false;
      nocarerefresh:=false;
      borderless:=false;
      backdrop:=false;
      gimmezz:=false;
      }
      activate:=true;
      {
      rmbtrap:=false;
      simplerefresh:=false;
      }
      smartrefresh:=true;
      autoadjust:=true;
      {
      menuhelp:=false;
      flags:=0;
      glist:=nil;
      optionsglist:=nil;
      optionswindow:=nil;
      inputglist:=nil;
      inputgadget:=nil;
      }
      gadgetfontname:='topaz.font'#0;
      {
      with gadgetfont do
        begin
          ta_name:=@gadgetfontname[1];
          ta_ysize:=8;
          ta_style:=0;
          ta_flags:=0;
        end;
      }
      moretags[1]:=true;
      gadgetfont.ta_name:=@gadgetfontname[1];
      gadgetfont.ta_ysize:=8;
    end;
end;

function allocmymem(size:long;typ:long):pointer;
var 
  t : pointer;
begin
  t:=allocmem(size,typ);
  allocmymem:=t;
  if t<>nil then
    inc(memused,size);
end;

procedure freemymem(mem:pointer;size:long);
begin
  dec(memused,size);
  freemem_(mem,size);
end;

procedure readlibdata(pln:plibnode);
var
  pb : pbyte;
  ps : pstringinfo;
begin
  if 0<>(gflg_selected and libwindowgadgets[5]^.flags) then
    pln^.opene:=true
   else
    pln^.opene:=false;
  if 0<>(gflg_selected and libwindowgadgets[6]^.flags) then
    pln^.abortonfaile:=true
   else
    pln^.abortonfaile:=false;
  ps:=pstringinfo(libwindowgadgets[7]^.specialinfo);
  pln^.versione:=ps^.longint_;
  pb:=@librarynames[libselected,1];
  if pln^.opene=true then
    pb^:=ord('>')
   else
    pb^:=32;
end;

procedure writelibdata(pln:plibnode);
begin
  gt_setsinglegadgetattr(libwindowgadgets[1],libwindow,gtlv_labels,~0);
  gt_setsinglegadgetattr(libwindowgadgets[1],libwindow,gtlv_labels,long(@tliblist));
  gt_setsinglegadgetattr(libwindowgadgets[1],libwindow,gtlv_selected,libselected);
  gt_setsinglegadgetattr(libwindowgadgets[7],libwindow,gtin_number,pln^.versione);
  gt_setsinglegadgetattr(libwindowgadgets[5],libwindow,gtcb_checked,long(pln^.opene));
  gt_setsinglegadgetattr(libwindowgadgets[6],libwindow,gtcb_checked,long(pln^.abortonfaile));                   
end;

function createliblist:boolean;
var
  pn   : plibnode;
  loop : word;
  done : boolean;
  phn  : phelpnode;
begin
  for loop:=1 to 14 do
    mxstrings[loop]:=@windowoptions[loop,1];
  mxstrings[15]:=nil;
  createliblist:=true;
  done:=false;
  newlist(@tliblist);
  loop:=0;
  repeat
    if librarynames[loop]<>'end' then
      begin
        pn:=allocmymem(sizeof(tlibnode),memf_any or memf_clear);
        if pn<>nil then
          begin
            pn^.version:=libraryversions[loop];
            pn^.ln_name:=@librarynames[loop,1];
            pn^.abortonfail:=true;
            if loop=22 then
              pn^.abortonfail:=false;
            pn^.open:=defaultlibopen[loop];
            addtail(@tliblist,pnode(pn));
          end
         else
          begin
            createliblist:=false;
            done:=true;
            freelist(@tliblist,sizeof(tlibnode));
          end;
      end
     else
      done:=true;
    inc(loop);
  until done;
end;

function duplicate(n : word,c:char):string;
var
  s : string;
begin
  s:='';
  while n>0 do
    begin
      dec(n);
      s:=s+c;
    end;
  duplicate:=s;
end;

procedure freelist(pl:plist;si:long);
var
  pn : pnode;
begin
  pn:=remhead(pl);
  while (pn<>nil) do
    begin
      freemymem(pn,si);
      pn:=remhead(pl);
    end;
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

function getnthnode(ph:plist;n:word):pnode;
var
  temp : pnode;
begin
  temp:=pnode(ph^.lh_head);
  while (n>0) and (temp^.ln_succ<>nil) do
    begin
      dec(n);
      temp:=temp^.ln_succ;
    end;
  getnthnode:=temp;
end;

{
function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long):pwindow;
var
  temp : pwindow;
begin
  temp:=openwindowtaglist(pnewwin,pt);
  if temp<>nil then temp^.userport:=myprogramport;
  if temp<>nil then if modifyidcmp(temp,tidcmp) then;
  openwindowtaglistnicely:=temp;
end;
}

procedure setupnewmenu(pnm:pnewmenu;ty:byte;labl:strptr;commke:strptr;flags:word;me:longint;ud:pointer);
begin
  pnm^.nm_type:=ty;
  pnm^.nm_label:=labl;
  pnm^.nm_commkey:=commke;
  pnm^.nm_flags:=flags;
  pnm^.nm_mutualexclude:=me;
  pnm^.nm_userdata:=ud;
end;

{
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
}

procedure settagitem(pt :ptagitem;t,d:long);
begin
  pt^.ti_tag:=t;
  pt^.ti_data:=d;
end;

procedure printstring(pwin:pwindow;x,y:word;s:string;n,m:byte;font:pointer);
var
  mit : tintuitext;
  str : string;
begin
  str:=s+#0;
  with mit do
    begin
      frontpen:=n;
      backpen:=m;
      leftedge:=x;
      topedge:=y;
      itextfont:=font;
      drawmode:=jam1;
      itext:=@str[1];
      nexttext:=nil;
    end;
  printitext(pwin^.rport,@mit,0,0);
end;

{

function checkboxgad(x,y,id:word;pprevgad:pgadget):pgadget;
var
  newgad : tnewgadget;
begin
  with newgad do
    begin
      ng_textattr:=nil;
      ng_leftedge:=x;
      ng_topedge:=y;
      ng_width:=26;
      ng_height:=11;
      ng_gadgettext:=nil;
      ng_gadgetid:=id;
      ng_flags:=0;
      ng_visualinfo:=screenvisualinfo;
    end;
  if pprevgad<>nil then
    checkboxgad:=creategadgeta(checkbox_kind,pprevgad,@newgad,pendtagitem)
   else
    checkboxgad:=nil;
end;

}

{
function integergad(x,y,w,h:word;num : long;len : long;id:word;pprevgad:pgadget;
                    ptitle:pbyte):pgadget;
var
  tags     : array [1..3] of ttagitem;
  newgad : tnewgadget;
begin
  with newgad do
    begin
      ng_textattr:=nil;
      ng_leftedge:=x;
      ng_topedge:=y;
      ng_width:=w;
      ng_height:=h;
      ng_gadgettext:=ptitle;
      ng_gadgetid:=id;
      ng_flags:=0;
      ng_visualinfo:=screenvis;
    end;
  settagitem(@tags[1],gtin_maxchars,len);
  settagitem(@tags[2],gtin_number,num);
  settagitem(@tags[3],tag_done,0);
  if pprevgad<>nil then
    integergad:=creategadgeta(integer_kind,pprevgad,@newgad,@tags[1])
   else
    integergad:=nil;
end;

function buttongad(x,y,w,h,id:word;ptxt:pbyte;font:ptextattr;
                   flags:long;visinfo:pointer;pprevgad:pgadget;
                   userdata:pointer;disabled:boolean):pgadget;
var
  taglist : array[1..2] of ttagitem;
begin
  settagitem(@taglist[1],ga_disabled,long(disabled));
  settagitem(@taglist[2],tag_done,0);
  buttongad:=generalgadtoolsgad(button_kind,x,y,w,h,id,ptxt,font,flags,
                                visinfo,pprevgad,userdata,@taglist[1]);
end;
}

function generalgadtoolsgad(kind         : long;
                            x,y,,w,h,id  : word;
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

function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long):pwindow;
var
  temp : pwindow;
  tags : array[1..2] of ttagitem;
begin
  settagitem(@tags[1],wa_dummy+$30,long(true));
  settagitem(@tags[2],Tag_more,long(pt));
  temp:=openwindowtaglist(pnewwin,@tags[1]);
  if temp<>nil then temp^.userport:=myprogramport;
  if temp<>nil then if modifyidcmp(temp,tidcmp) then;
  openwindowtaglistnicely:=temp;
end;

procedure closewindowsafely(win : pwindow);
begin
  forbid;
  stripintuimessages(win^.userport,win);
  win^.userport:=nil;
  if modifyidcmp(win,0) then ;
  permit;
  intuition_2.closewindow(win);
end;

procedure updatewindowsizes(pdwn);
begin
  if (pdwn^.editwindow^.flags and wflg_zoomed)<>0 then
    begin
      pdwn^.zoom[1]:=pdwn^.editwindow^.leftedge;
      pdwn^.zoom[2]:=pdwn^.editwindow^.topedge;
      pdwn^.zoom[3]:=pdwn^.editwindow^.width-pdwn^.offx; 
      pdwn^.zoom[4]:=pdwn^.editwindow^.height-pdwn^.offy;    
    end
   else
    begin
      pdwn^.x:=pdwn^.editwindow^.leftedge;
      pdwn^.y:=pdwn^.editwindow^.topedge;
      pdwn^.w:=pdwn^.editwindow^.width-pdwn^.offx;
      pdwn^.h:=pdwn^.editwindow^.height-pdwn^.offy;
      if pdwn^.innerh<>0 then
        pdwn^.innerh:=pdwn^.editwindow^.height-pdwn^.editwindow^.borderbottom-pdwn^.editwindow^.bordertop;
      if pdwn^.innerw<>0 then
        pdwn^.innerw:=pdwn^.editwindow^.width-pdwn^.editwindow^.borderright-pdwn^.editwindow^.borderleft;
    end;
  if pdwn^.sizeswindow<>nil then
    begin
      gt_setsinglegadgetattr(pdwn^.sizesgads[5 ],pdwn^.sizeswindow,gtin_number,pdwn^.zoom[1]);
      gt_setsinglegadgetattr(pdwn^.sizesgads[6 ],pdwn^.sizeswindow,gtin_number,pdwn^.zoom[2]);
      gt_setsinglegadgetattr(pdwn^.sizesgads[7 ],pdwn^.sizeswindow,gtin_number,pdwn^.zoom[3]);
      gt_setsinglegadgetattr(pdwn^.sizesgads[8 ],pdwn^.sizeswindow,gtin_number,pdwn^.zoom[4]);
      gt_setsinglegadgetattr(pdwn^.sizesgads[9 ],pdwn^.sizeswindow,gtin_number,pdwn^.x);
      gt_setsinglegadgetattr(pdwn^.sizesgads[10],pdwn^.sizeswindow,gtin_number,pdwn^.y);
      gt_setsinglegadgetattr(pdwn^.sizesgads[11],pdwn^.sizeswindow,gtin_number,pdwn^.w+pdwn^.offx);
      gt_setsinglegadgetattr(pdwn^.sizesgads[12],pdwn^.sizeswindow,gtin_number,pdwn^.h+pdwn^.offy);              
      gt_setsinglegadgetattr(pdwn^.sizesgads[13],pdwn^.sizeswindow,gtin_number,pdwn^.innerw);
      gt_setsinglegadgetattr(pdwn^.sizesgads[14],pdwn^.sizeswindow,gtin_number,pdwn^.innerh);              
    end;
end;

function readiffimage(pb:pbyte):pimagenode;
var
  ok1                : boolean;
  iff                : piffhandle;
  error              : long;
  bitmaphd           : pbmhd;
  sp                 : pstoredproperty;
  newimagenode       : pimagenode;
  readimage          : pshortintarray;
  num                : word;
  dest               : long;
  count              : long;
  num2               : word;
  widthbytes         : word;
  height             : word;
  oneline            : pbytearray;
  psource            : pshortint;
  planesize          : long;
  destline,destplane : word;
  pba                : pbytearray;
  loop               : word;
  pin                : pimagenode;
begin
  ok1:=true;
  oneline:=nil;
  newimagenode:=nil;
  sp:=nil;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=open(pb,mode_oldfile);
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_read);
          if error=0 then
            begin
              if (propchunk(iff,id_ilbm,id_bmhd)=0) and
                 (propchunk(iff,id_ilbm,id_body)=0) and
                 (propchunk(iff,id_ilbm,id_cmap)=0) and
                 (stoponexit(iff,id_ilbm,id_form)=0) then
                begin
                  error:=parseiff(iff,iffparse_scan);
                  sp:=findprop(iff,id_ilbm,id_bmhd);
                  if sp<>nil then
                    begin
                      newimagenode:=allocmymem(sizeof(timagenode),memf_clear or memf_any);
                      if newimagenode<>nil then
                        begin
                          newimagenode^.ln_type:=imagenodetype;
                          bitmaphd:=pbmhd(sp^.sp_data);
                          with newimagenode^ do
                            begin
                              sizeallocated:=widthbytes*height*bitmaphd^.nplanes;
                              ln_name:=@title[1];
                              title:='Image'#0;
                              leftedge:=0;
                              topedge:=0;
                              width:=bitmaphd^.w;
                              height:=bitmaphd^.h;
                              depth:=bitmaphd^.nplanes;
                              nextimage:=nil;
                              planeonoff:=0;
                              case depth of
                                1 : planepick:=1;
                                2 : planepick:=3;
                                3 : planepick:=7;
                                4 : planepick:=15;
                                5 : planepick:=31;
                                6 : planepick:=63;
                                7 : planepick:=127;
                                8 : planepick:=255;
                               end;
                            end;
                          widthbytes:=0;
                          repeat
                            inc(widthbytes,2);
                          until widthbytes*8>=bitmaphd^.w;  
                          if bitmaphd^.w=0 then 
                            widthbytes:=0;
                          height:=bitmaphd^.h;
                          planesize:=widthbytes*height;
                        end
                       else
                        telluser(mainwindow,'Cannot alloc mem for image node.');
                    end
                   else
                    begin
                      telluser(mainwindow,'Not an IFF ILBM.');
                      ok1:=false;
                    end;
                  sp:=findprop(iff,id_ilbm,id_body);
                  if (sp<>nil) and (newimagenode<>nil) then
                    begin
                      psource:=pshortint(sp^.sp_data);
                      newimagenode^.imagedata:=allocmymem(widthbytes*height*bitmaphd^.nplanes,
                          memf_clear or memf_chip);
                      newimagenode^.sizeallocated:=widthbytes*height*bitmaphd^.nplanes;
                      oneline:=allocmymem(widthbytes,memf_clear or memf_any);
                      if (oneline<>nil)and(newimagenode^.imagedata<>nil) then
                        for destline:=0 to height-1 do
                          begin
                            for destplane:=0 to bitmaphd^.nplanes-1 do
                              begin
                                if bitmaphd^.compressed=0 then
                                  begin
                                    copymem(psource,oneline,widthbytes);
                                    psource:=pointer(long(psource)+widthbytes);
                                  end;
                                count:=0;
                                if bitmaphd^.compressed=1 then
                                  begin
                                    repeat
                                      case psource^ of
                                        -128     : psource:=pointer(long(psource)+1);
                                        -127..-1 : begin
                                                     num:=1-psource^;
                                                     num2:=0;
                                                     psource:=pointer(long(psource)+1);
                                                     repeat
                                                       inc(num2);
                                                       oneline^[count]:=psource^;
                                                       inc(count);
                                                     until num=num2;
                                                     psource:=pointer(long(psource)+1);
                                                   end;
                                        0..127   : begin
                                                     num:=psource^+1;
                                                     num2:=0;
                                                     repeat
                                                       inc(num2);
                                                       psource:=pointer(long(psource)+1);
                                                       oneline^[count]:=psource^;
                                                       inc(count);
                                                     until num=num2;
                                                     psource:=pointer(long(psource)+1);
                                                   end;
                                       end;
                                    until (count*8>=bitmaphd^.w);
                                  end;  
                                copymem(oneline,
                                    @newimagenode^.imagedata^[destplane*planesize+destline*widthbytes],
                                    widthbytes);
                              end;
                          end
                       else
                        begin
                          telluser(mainwindow,memerror);
                          if newimagenode^.imagedata<>nil then
                            freemymem(newimagenode^.imagedata,newimagenode^.sizeallocated);
                          freemymem(newimagenode,sizeof(timagenode));
                          newimagenode:=nil;
                        end;
                    end
                   else
                    begin
                      if (sp=nil) and ok1 then 
                        telluser(mainwindow,'No body in IFF File!');
                      if newimagenode<>nil then
                        freemymem(newimagenode,sizeof(timagenode));
                      newimagenode:=nil;
                    end;
                  sp:=findprop(iff,id_ilbm,id_cmap);
                  if (sp<>nil) and (newimagenode<>nil) then
                    begin
                      pin:=newimagenode;
                      count:=sp^.sp_size div 3;
                      pin^.colourmap:=pwordarray2(allocmymem(count*4,memf_any or memf_clear));
                      if pin<>nil then
                        begin
                          pin^.mapsize:=count*4;
                          count:=0;
                          pba:=pbytearray(sp^.sp_data);
                          for loop:=0 to (sp^.sp_size div 3) do
                            begin
                              pin^.colourmap^[count]:=((pba^[3*loop] and 240) shl 4);
                              pin^.colourmap^[count]:=pin^.colourmap^[count] or (pba^[3*loop+1] and 240);
                              pin^.colourmap^[count]:=pin^.colourmap^[count] or ((pba^[3*loop++2] and 240) shr 4);
                              inc(count);
                            end;
                          
                          
                          
                          {
                          loadrgb4(@myscreen^.viewport,pword(pin^.colourmap),pin^.mapsize div 4);
                          readln;
                          loadrgb4(@myscreen^.viewport,nil,pin^.mapsize div 4);
                          }
                        end
                       else
                        begin
                          telluser(mainwindow,memerror);
                          if newimagenode^.imagedata<>nil then
                            freemymem(newimagenode^.imagedata,newimagenode^.sizeallocated);
                          if newimagenode<>nil then
                            freemymem(newimagenode,sizeof(timagenode));
                          newimagenode:=nil;
                        end;
                    end;
                end;
              closeiff(iff);
            end;
          if not amigados.close_(iff^.iff_stream) then
            telluser(mainwindow,'Could not close file. ?!?!?');
        end
       else
        telluser(mainwindow,'Could not open file.');
      freeiff(iff);
    end
   else
    telluser(mainwindow,'Could not allocate IFF handle.');
  readiffimage:=newimagenode;
  if oneline<>nil then
    freemymem(oneline,widthbytes);
end;

procedure initimagenodeprops(pin:pimagenode;pscr:pscreen);
begin
  with pin^.botinfo do
    begin
      flags:=autoknob or freehoriz or propnewlook;
      horizpot:=0;
      vertpot:=0;
      horizbody:=65535;{-1}
      vertbody:=65535;{-1}
    end;
  with pin^.botslide do
    begin
      leftedge:=3;
      topedge:=-7;
      width:=-23;
      height:=6;
      flags:=gflg_relbottom or gflg_relwidth;
      activation:=gact_relverify or gact_immediate or gact_bottomborder;
      gadgettype:=gtyp_propgadget or gtyp_gzzgadget;
      gadgetrender:=@pin^.botimage;
      specialinfo:=@pin^.botinfo;
      gadgetid:=1;
    end;
  with pin^.sideinfo do
    begin
      flags:=autoknob or freevert or propnewlook;
      {
      horizpot:=0;
      vertpot:=0;
      }
      horizbody:=65535;{-1}
      vertbody:=65535;{-1}
    end;
  with pin^.sideslide do
    begin
      leftedge:=-14;
      topedge:=pscr^.wbortop|+pscr^.font^.ta_ysize+2;
      width:=12;
      height:=-topedge-11;
      flags:=gflg_relright or gflg_relheight;
      activation:=gact_relverify or gact_immediate or gact_rightborder;
      gadgettype:=gtyp_propgadget or gtyp_gzzgadget;
      gadgetrender:=@pin^.sideimage;
      specialinfo:=@pin^.sideinfo;
      gadgetid:=2;
      nextgadget:=@pin^.botslide;
    end;
end;

procedure checkimagenodegadget(pin:pimagenode;gid:word);
var
  dx,dy : integer;
  tmp : long;
begin
  dx:=0;
  dy:=0;
  tmp:=0;
  case gid of
    2 : begin
          tmp:=pin^.height-pin^.displaywindow^.gzzheight;
          tmp:=tmp*pin^.sideinfo.vertpot;
          tmp:=(tmp div long(65535));
          dy:=tmp-layeryoffset(pin^.displaywindow);
        end;
    1 : begin
          tmp:=pin^.width-pin^.displaywindow^.gzzwidth;
          tmp:=tmp*pin^.botinfo.horizpot;
          tmp:=(tmp div long(65535));
          dx:=tmp-layerxoffset(pin^.displaywindow);
        end;
   end;
  if (dx<>0) or (dy<>0) then
    begin
      scrolllayer(0,pin^.displaywindow^.rport^.layer,dx,dy);
    end;
end;

procedure newimagenodewindowsize(pin:pimagenode);
var
  tmp:long;
  propxdisp : long;
begin
  tmp:=layerxoffset(pin^.displaywindow)+pin^.displaywindow^.gzzwidth;
  if (tmp>=pin^.width) then
    scrolllayer(0,pin^.displaywindow^.rport^.layer,pin^.width-tmp,0);
  newmodifyprop(@pin^.botslide,
    pin^.displaywindow,
    nil,
    autoknob or freehoriz,
    ((layerxoffset(pin^.displaywindow)*65535) div (pin^.width)),
    0,
    ((pin^.displaywindow^.gzzwidth*65535) div (pin^.width)),
    65535,
    1);
  tmp:=layeryoffset(pin^.displaywindow)+pin^.displaywindow^.gzzheight;
  if (tmp>=pin^.height) then
    scrolllayer(0,pin^.displaywindow^.rport^.layer,0,pin^.height-tmp);
  newmodifyprop(@pin^.sideslide,
    pin^.displaywindow,
    nil,
    autoknob or freevert,
    65535,
    ((layeryoffset(pin^.displaywindow)*65535) div (pin^.height)),
    0,
    (((pin^.displaywindow^.gzzheight*65535) div (pin^.height))),
    1);
end;  

procedure openimagedisplaywindow(pin;pscr;pdwn);
var
  allocatedbitmaps : boolean;
  tags             : array[1..21] of ttagitem;
  planenum         : word;
  xx,yy            : word;
  minx,miny        : word;
  loop             : word;
  vi               : pointer;
begin
  xx:=18+pscr^.wborleft;
  yy:=10+pscr^.wbortop+pscr^.font^.ta_ysize+1;
  minx:=xx;
  miny:=yy;
  if pin^.displaywindow=nil then
    begin
      pin^.pscr:=pscr;
      initimagenodeprops(pin,pscr);
      allocatedbitmaps:=true;
      initbitmap(@pin^.winbitmap,pscr^.bitmap.depth,
          pin^.width+xx,pin^.height+yy);
      for planenum:=0 to pscr^.bitmap.depth-1 do
        pin^.winbitmap.planes[planenum]:=nil;
      planenum:=0;
      while (planenum<pscr^.bitmap.depth)and(allocatedbitmaps) do
        begin
          pin^.winbitmap.planes[planenum]:=nil;
          pin^.winbitmap.planes[planenum]:=allocraster(pin^.width+xx,pin^.height+yy);
          if pin^.winbitmap.planes[planenum]=nil then
            allocatedbitmaps:=false;
          inc(planenum);
        end;
      if allocatedbitmaps then
        begin
          settagitem(@tags[1],wa_maxwidth,pin^.width+xx);
          settagitem(@tags[2],wa_maxheight,pin^.height+yy);
          settagitem(@tags[3],wa_flags,wflg_sizegadget or
                                       wflg_sizebright or
                                       wflg_sizebbottom or
                                       wflg_super_bitmap or
                                       wflg_gimmezerozero or
                                       wflg_nocarerefresh);
          settagitem(@tags[4],wa_superbitmap,long(@pin^.winbitmap));
          settagitem(@tags[5],wa_depthgadget,long(true));
          settagitem(@tags[6],wa_customscreen,long(pscr));
          settagitem(@tags[7],wa_closegadget,long(true));
          settagitem(@tags[8],wa_left,150);
          settagitem(@tags[9],wa_top,50);
          settagitem(@tags[10],wa_width,pin^.width+xx);
          settagitem(@tags[11],wa_height,pin^.height+yy);
          settagitem(@tags[12],wa_title,long(@pin^.title[1]));
          settagitem(@tags[13],wa_dragbar,long(true));
          settagitem(@tags[14],wa_activate,long(true));
          settagitem(@tags[15],wa_autoadjust,long(true));
          settagitem(@tags[16],wa_minwidth,minx);
          settagitem(@tags[17],wa_minheight,miny);
          settagitem(@tags[18],wa_gadgets,long(@pin^.sideslide));
          if pscr=myscreen then
            settagitem(@tags[19],wa_screentitle,long(@frontscreentitle[1]))
           else
            settagitem(@tags[19],tag_done,0);
          settagitem(@tags[20],tag_done,0);
          pin^.displaywindow:=openwindowtaglistnicely(nil,@tags[1],idcmp_gadgetup or
                                                                   idcmp_gadgetdown or
                                                                   idcmp_newsize or
                                                                   idcmp_menupick or
                                                                   idcmp_intuiticks or
                                                                   idcmp_closewindow or
                                                                   idcmp_refreshwindow or
                                                                   IDCMP_VanillaKey);
          if pin^.displaywindow=nil then
            begin
              telluser(mainwindow,'Unable to open display image.');
              planenum:=0;
              while (planenum<pscr^.bitmap.depth) do
                begin
                  if nil<>pin^.winbitmap.planes[planenum] then
                    freeraster(pin^.winbitmap.planes[planenum],pin^.width+xx,pin^.height+yy);
                  pin^.winbitmap.planes[planenum]:=nil;
                  inc(planenum);
                end;
            end
           else
            begin
              newimagenodewindowsize(pin);
              xx:=pin^.displaywindow^.borderright+pscr^.wborleft;
              yy:=pin^.displaywindow^.borderbottom+pscr^.wbortop+pscr^.font^.ta_ysize+1;
              if windowlimits(pin^.displaywindow,minx,miny,xx+pin^.width,yy+pin^.height) then;
              pin^.displaywindow^.userdata:=pointer(pin);
              setrast(pin^.displaywindow^.rport,0);
              if prefsvalues[11] then
                begin
                  if pin^.colourmap<>nil then
                    begin
                      pin^.oldmap:=allocmymem(pin^.mapsize,memf_any or memf_clear);
                      if pin^.oldmap<>nil then
                        begin
                          for loop:=0 to (pin^.mapsize div 4)-1 do
                            begin
                              pin^.oldmap^[loop]:=getrgb4(pscr^.viewport.colormap,loop);
                            end;
                          loadrgb4(@pscr^.viewport,pword(pin^.colourmap),pin^.mapsize div 4);
                        end;
                    end
                end
               else
                pin^.oldmap:=nil;
              drawimage(pin^.displaywindow^.rport,pointer(@pin^.leftedge),0,0);
              pin^.pmen:=nil;
              displayimagemenu:=nil;
              vi:=getvisualinfoa(pscr,nil);
              if vi<>nil then
                begin
                  if makemenudisplayimagemenu(vi) then
                    begin
                      if setmenustrip(pin^.displaywindow,displayimagemenu) then
                        pin^.pmen:=displayimagemenu
                       else
                        freemenus(displayimagemenu);
                    end;
                  freevisualinfo(vi);
                end;
            end;
        end
       else
        begin
          telluser(mainwindow,memerror);
          planenum:=0;
          while (planenum<pscr^.bitmap.depth) do
            begin
              if nil<>pin^.winbitmap.planes[planenum] then
                freeraster(pin^.winbitmap.planes[planenum],pin^.width+xx,pin^.height+yy);
              pin^.winbitmap.planes[planenum]:=nil;
              inc(planenum);
            end;
        end;
    end
   else
    begin
      windowtofront(pin^.displaywindow);
      activatewindow(pin^.displaywindow);
    end;
end;

procedure closeimagedisplaywindow(pin:pimagenode);
var
  planenum:word;
  xx,yy:word;
  pscr : pscreen;
begin
  if pin^.displaywindow<>nil then
    begin
      if pin^.pmen<>nil then
        begin
          clearmenustrip(pin^.displaywindow);
          freemenus(pin^.pmen);
          pin^.pmen:=nil;
        end;
      pscr:=pin^.pscr;
      if pin^.oldmap<>nil then
        begin
          loadrgb4(@pin^.pscr^.viewport,pword(pin^.oldmap),pin^.mapsize div 4);
          freemymem(pin^.oldmap,pin^.mapsize);
          pin^.oldmap:=nil;
        end;
      xx:=18+pscr^.wborleft;
      yy:=10+pscr^.wbortop+pscr^.font^.ta_ysize+1;
      closewindowsafely(pin^.displaywindow);
      planenum:=0;
      while (planenum<pscr^.bitmap.depth) do
        begin
          if nil<>pin^.winbitmap.planes[planenum] then
            freeraster(pin^.winbitmap.planes[planenum],pin^.width+xx,pin^.height+yy);
          pin^.winbitmap.planes[planenum]:=nil;
          inc(planenum);
        end;
    end;
  pin^.displaywindow:=nil;
  pin^.pscr:=nil;
end;

function demoversion:boolean;
begin
  {demoversion:=(registerstore=upstring('Checkbox ')+upstring('Listview ')+upstring('Slider ')+
                   upstring('Boolean ')+copy(upstring('Button '),1,5)+#0#0#0);
}
   { changed IOC 2002 to disable protection}
   demoversion:=false;
end;

end.