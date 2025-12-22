unit extrawinhandling;

interface

uses designermenus,asl,utility,routines,exec,intuition,amiga,workbench,layers,icon,import,localewin,obsolete,edittags,
     gadtools,graphics,dos,amigados,drawwindows,definitions,iffparse,loadsave,magnify,editscreenstuff,editboopsi,
     objectmenucustomunit,savecodedefs;

procedure openabout;
procedure gadgetwindowhandling(pgn:pgadgetnode;messcopy:tintuimessage;pdwn:pdesignerwindownode);
procedure setmenueditwindowsubitem(pdmn:pdesignermenunode;pmin:pmenuitemnode;pmsi:pmenusubitemnode);
procedure setmenueditwindowitem(pdmn:pdesignermenunode;pmtn:pmenutitlenode;pmin:pmenuitemnode);
procedure setmenueditwindowtitle(pdmn:pdesignermenunode;pmtn:pmenutitlenode);
procedure editmenuhandling(messcopy : tintuimessage);
procedure handlewindowcodewindow(messcopy : tintuimessage);
procedure handlebevelwindow(messcopy : tintuimessage);
procedure editimagehandling(messcopy:tintuimessage);
procedure maincodeinputhandler(messcopy : tintuimessage);
procedure updatewin(pdwn:pdesignerwindownode);
procedure highsome(messcopy:tintuimessage;pgsel:pgadget;pdwn:pdesignerwindownode);
procedure highlotsofgads(pdwn:pdesignerwindownode);
procedure idcmphandling(pdwn:pdesignerwindownode;messcopy:tintuimessage);
procedure handlegadgetlistwindow(messcopy : tintuimessage);
procedure handledisplayimagewindow(messcopy : tintuimessage);
procedure handlelibrarywindow(messcopy : tintuimessage);
procedure handlemainwindow(messcopy : tintuimessage);
procedure handletagswindow(messcopy : tintuimessage);
procedure handleimagelistwindow(messcopy : tintuimessage);
procedure handleoptionswindow(messcopy : tintuimessage);
procedure handlesizeswindow(messcopy : tintuimessage);
procedure handleupgradewin;
procedure handlelocalewindow(messcopy : tintuimessage);
procedure writeregistereduser;

implementation

function cornerin(x,y:integer):boolean;
var  
  c : boolean;
begin
  cornerin:= ((x<=box[3])and(x>=box[1]))and((y>=box[2])and(y<=box[4]));
end;

procedure gadisin(pgn:pgadgetnode;pdwn:pdesignerwindownode);
begin
  if (pgn^.joined)and(pgn^.kind=string_kind) then
    pgn:=pgadgetnode(pgn^.pointers[1]);
  if not pgn^.high then
    begin
      pgn^.high:=true;
      highlightgadget(pgn,pdwn);
      if (pgn^.kind=listview_kind)and(pgn^.tags[3].ti_data<>0)then
        begin
          pgn:=pgadgetnode(pgn^.tags[3].ti_data);
          pgn^.high:=true;
        end;
    end;
end;

procedure highlotsofgads(pdwn);
var
  loop : word;
  pgn : pgadgetnode;
begin
  if box[1]>box[3] then 
    begin
      loop:=box[3];
      box[3]:=box[1];
      box[1]:=loop;
    end;
  if box[2]>box[4] then 
    begin
      loop:=box[4];
      box[4]:=box[2];
      box[2]:=loop;
    end;
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn^.ln_succ<>nil)do
    begin
      if cornerin(pgn^.x,pgn^.y) then
        gadisin(pgn,pdwn)
       else
        if cornerin(pgn^.x,pgn^.y+pgn^.h-1) then
          gadisin(pgn,pdwn)
         else
          if cornerin(pgn^.x+pgn^.w-1,pgn^.y) then
            gadisin(pgn,pdwn)
           else
            if cornerin(pgn^.x+pgn^.w-1,pgn^.h+pgn^.y-1) then
              gadisin(pgn,pdwn);
      pgn:=pgn^.ln_succ;
    end;
end;

procedure highsome(messcopy:tintuimessage;pgsel:pgadget;pdwn);
var
  pgn,pgn2 : pgadgetnode;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn^.ln_succ<>nil)do
    begin
      if (pgsel^.gadgetid=pgn^.id)and((pgn^.kind = mx_kind) or 
                                      (pgn^.kind = string_kind) or 
                                      (pgn^.kind = integer_kind)) then
        begin
          if ((iequalifier_lshift or iequalifier_rshift) and messcopy.qualifier)=0 then
            begin
              pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
              while(pgn2^.ln_succ<>nil) do
                begin
                  if pgn2^.high and (pgn2<>pgn) then
                    begin
                      pgn2^.high:=false;
                      highlightgadget(pgn2,pdwn);
                    end;
                  pgn2:=pgn2^.ln_succ;
                end;
            end;
          if not pgn^.high then
            highlightgadget(pgn,pdwn);
          pgn^.high:=true;
          if (pgn^.kind=listview_kind)and(pgn^.tags[3].ti_data<>0) then
            begin
              pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
              pgn2^.high:=true;
            end
           else
            if pgn^.joined and (pgn^.kind=string_kind) then
              begin
                pgn2:=pgadgetnode(pgn^.pointers[1]);
                if not pgn2^.high then
                  highlightgadget(pgn2,pdwn);
                pgn2^.high:=true;
              end;
          if (doubleclick(pgn^.seconds,pgn^.micros,
                          messcopy.seconds,messcopy.micros)) then
            openeditgadget(pdwn,pgn);
          pgn^.seconds:=messcopy.seconds;
          pgn^.micros:=messcopy.micros;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

procedure updatewin(pdwn:pdesignerwindownode);
var
  pgn : pgadgetnode;
  xmin,ymin,xmax,ymax : word;
  pos  : long;
begin
  inputmode:=1;
  waiteverything;
  updateeditwindow:=false;
  if pdwn^.editwindow<>nil then
    begin
      if pdwn^.mxchoice<>12 then
        begin
          if 0=removeglist(pdwn^.editwindow,pdwn^.glist,~0) then
        end
       else
        begin
          if 0=removeglist(pdwn^.editwindow,pdwn^.bevelglist,~0) then;
        end;
      
      freegadgets(pdwn^.glist);
      freegadgets(pdwn^.bevelglist);
      
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
      
      pdwn^.glist:=nil;
      pdwn^.bevelglist:=nil;
      
      pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
      while (pgn^.ln_succ<>nil) do
        begin
          if (pgn^.kind=mx_kind)or(pgn^.kind=cycle_kind) then
            if (pgn^.pointers[1]<>nil)and(pgn^.pointers[2]<>nil) then
              begin
                freemymem(pgn^.pointers[1],long(pgn^.pointers[2]));
                pgn^.pointers[1]:=nil;
                pgn^.pointers[2]:=nil;
              end;
          pgn:=pgn^.ln_succ;
        end;
      
              if pdwn^.gimmezz then
                setrast(pdwn^.editwindow^.rport,0)
               else
                begin
                  xmin:=pdwn^.editwindow^.borderleft;
                  xmax:=pdwn^.w-pdwn^.editwindow^.borderright+pdwn^.offx-1;
                  if xmin<xmax then
                    begin
                       ymin:=pdwn^.editwindow^.bordertop;
                       ymax:=pdwn^.h-pdwn^.editwindow^.borderbottom+pdwn^.offy-1;
                       if ymin<ymax then
                         begin
                           setapen(pdwn^.editwindow^.rport,0);
                           setdrmd(pdwn^.editwindow^.rport,jam1);
                           rectfill(pdwn^.editwindow^.rport,xmin,ymin,xmax,ymax);
                         end;
                    end;
                end;

      
      if doeditwindowgadgets(pdwn)<>nil then
        begin
          if -1<>addglist(pdwn^.editwindow,pdwn^.glist,65535,~0,nil) then
            begin
              rendeditwindow(pdwn);
              refreshglist(pdwn^.glist,pdwn^.editwindow,nil,~0);
              gt_refreshwindow(pdwn^.editwindow,nil);
              if pdwn^.mxchoice=12 then
                begin
                  if pdwn^.bevelglist<>nil then
                    begin
                      pos:=removeglist(pdwn^.editwindow,pdwn^.glist,~0);
                      pos:=addglist(pdwn^.editwindow,pdwn^.bevelglist,65535,~0,Nil);
                    end;
                end;
            end
           else
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
        end
       else
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
    end;
  unwaiteverything;
end;

procedure maincodeinputhandler(messcopy : tintuimessage);
var 
  dummy : long;
  pgsel : pgadget;
  code  : word;
  class : long;
  pin   : pimagenode;
  ti    : timage;
  itemnumber : word;
  subnumber : word;
  menunumber : word;
  loop      : word;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pin:=pimagenode(messcopy.idcmpwindow^.userdata);
  pgsel:=pgadget(messcopy.iaddress);
  dummy:=0;
  if class=idcmp_gadgetup then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_vanillakey then
    case upcase(chr(code)) of
      'H' : dummy:=101;
      'L' : dummy:=102;
     end;
  if class=idcmp_menupick then
    begin
      ItemNumber:=ITEMNUM(code);
      SubNumber:=SUBNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        MainCodeOptions :
          Case ItemNumber of
            MainCodeOptionslibs :
              dummy:=102;
            MainCodeoptionshelp :
              dummy:=101;
            maincodeoptionsclose :
              dummy:=99;
            maincodeoptionslocale :
              dummy:=103;
            maincodeoptionssavedef :
              begin
                writecodedefs(1);
                writecodedefs(2);
              end;
            maincodeoption_susedef :
              begin
                writecodedefs(1);
              end;
            maincodeoptionsloaddef :
              begin
                readcodedefs;
                
                
                
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

                
                closelibwindow;
                
              end;
           end;
       end;
    end;
  if class=idcmp_closewindow then
    dummy:=99;
  case dummy of
    1 : presentcompiler:=code;
    2..10 : codeoptions[dummy-1]:=checkedbox(maincodegadgets[dummy]);
    13 : codeoptions[8]:=checkedbox(maincodegadgets[13]);
    14 : codeoptions[9]:=checkedbox(maincodegadgets[14]);
    15 : codeoptions[10]:=checkedbox(maincodegadgets[15]);
    16 : codeoptions[11]:=checkedbox(maincodegadgets[16]);
    17 : codeoptions[12]:=checkedbox(maincodegadgets[17]);
    18 : codeoptions[13]:=checkedbox(maincodegadgets[18]);
    
    99 : if inputmode=0 then
           closemaincodewindow;
    101 : if inputmode=0 then
            helpwindow(@defaulthelpwindownode,maincodehelp);
    102 : if inputmode=0 then 
            openlibwindow;
    103 : if inputmode=0 then
            openwindowlocalewindow;
   end;
end;

function processplanepick(pin:pimagenode;p:byte):byte;
var
  result : byte;
  count  : byte;
  loop   : byte;
begin
  result:=0;
  count:=0;
  for loop:=0 to 7 do
    if (p and (1 shl loop))<>0 then
      if count<pin^.depth then
        begin
          result:=result or (1 shl loop);
          inc(count);
        end;
  for loop:=0 to 7 do
    begin
      if (result and (1 shl loop))=0 then
        begin
          if  (count<pin^.depth) then
            begin
              inc(count);
              result:=result or (1 shl loop);
            end;
        end;
    end;
  for loop:=0 to 7 do
    begin
      gt_setsinglegadgetattr(pin^.editwindowgads[8+loop],pin^.editwindow,
                             gtcb_checked,long((result and (1 shl loop))<>0));
    end;
  processplanepick:=result;
end;

function read8checks(pin:pimagenode;p:byte):byte;
var
  result : byte;
  loop   : byte;
  count  : byte;
begin
  result:=0;
  for loop:=0 to 7 do
    begin
      if checkedbox(pin^.editwindowgads[loop+p]) then
        result:=result or (1 shl loop);
    end;
  if p=8 then
    result:=processplanepick(pin,result);
  read8checks:=result;
end;

procedure idcmphandling(pdwn;messcopy:tintuimessage);
var 
  dummy : long;
  pgsel : pgadget;
  code  : word;
  class : long;
  pin   : pimagenode;
  ti    : timage;
  itemnumber : word;
  menunumber : word;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pin:=pimagenode(messcopy.idcmpwindow^.userdata);
  pgsel:=pgadget(messcopy.iaddress);
  dummy:=0;
  case class of
    idcmp_closewindow :
      if inputmode=0 then
        closeidcmpwindow(pdwn);
    idcmp_gadgetup :
      if inputmode=0 then 
        dummy:=pgsel^.gadgetid;
    idcmp_vanillakey :
      if inputmode=0 then
        case upcase(chr(code)) of
          'H' : dummy:=27;
          'C' : dummy:=28;
          'O' : dummy:=26;
         end;
    idcmp_menupick :
      if inputmode=0 then
        begin
          ItemNumber:=ITEMNUM(code);
          MenuNumber:=MENUNUM(code);
          Case MenuNumber of
            winIdcmpoptions :
              Case ItemNumber of
                winIdcmpoptionsdefault :
                  begin
                    for dummy:=1 to 25 do
                      gt_setsinglegadgetattr(pdwn^.idcmpgads[dummy],pdwn^.idcmpwindow,
                          gtcb_checked,long(defaultidcmpvalues[dummy]));
                    dummy:=0;
                  end;
                winIdcmpoptionshelp :
                  dummy:=27;
                winIdcmpoptionsok :
                  dummy:=26;
                winIdcmpoptionscancel :
                  dummy:=28;
               end;
           end;
        end;    
   end;
  case dummy of
    26 : begin
           for dummy:=1 to 25 do
             pdwn^.idcmplist[dummy]:=
               (pdwn^.idcmpgads[dummy]^.flags and gflg_selected)<>0;
           dummy:=0;
           closeidcmpwindow(pdwn);
         end;
    27 : helpwindow(@pdwn^.helpwin,windowidcmphelp);
    28 : closeidcmpwindow(pdwn);
   end;
end;

procedure editimagehandling(messcopy:tintuimessage);
var 
  dummy : long;
  pgsel : pgadget;
  code  : word;
  class : long;
  pin   : pimagenode;
  ti    : timage;
  MenuNumber : Word;
  ItemNumber : Word;
  SubNumber  : Word;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pin:=pimagenode(messcopy.idcmpwindow^.userdata);
  pgsel:=pgadget(messcopy.iaddress);
  dummy:=69;
  case class of
    idcmp_closewindow : 
      dummy:=4;
    idcmp_menuhelp :
      dummy:=2;
    idcmp_menupick :
      begin
        ItemNumber:=ITEMNUM(code);
        SubNumber:=SUBNUM(code);
        MenuNumber:=MENUNUM(code);
        Case MenuNumber of
          MenuEditImage :
            Case ItemNumber of
              MenuReplaceImage : 
                dummy:=91;
              MenuViewImage :
                dummy:=3;
              MenuHelpImage :
                dummy:=2;
              MenuOKImage :
                dummy:=1;
              MenuImageCancel :
                dummy:=4;
             end;
         end;
      end;
    idcmp_vanillakey :
      begin
        case upcase(chr(code)) of
          'O' : dummy:=1;
          'C' : dummy:=4;
          'H' : dummy:=2;
          'V' : dummy:=3;
          'L' : if inputmode=0 then
                  if activategadget(pin^.editwindowgads[0],pin^.editwindow,nil) then;
         end;
      end;
    idcmp_gadgetup :
      dummy:=pgsel^.gadgetid;
   end;
  if inputmode=0 then
    case dummy of
      1 : begin
            gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
            pin^.title:=getstringfromgad(pin^.editwindowgads[0])+#0;
            gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
            pin^.planepick:=read8checks(pin,8);
            pin^.planeonoff:=read8checks(pin,16);
            {read 'em all}
            closeimageeditwindow(pin);
            if pin^.displaywindow<>nil then
              begin
                setrast(pin^.displaywindow^.rport,0);
                drawimage(pin^.displaywindow^.rport,pointer(@pin^.leftedge),0,0);
              end;
          end;
      2 : helpwindow(@defaulthelpwindownode,imagehelp);
      3 : begin
            {view}
            ti.leftedge:=0;
            ti.topedge:=0;
            ti.width:=pin^.width;
            ti.height:=pin^.height;
            ti.depth:=pin^.depth;
            ti.imagedata:=pointer(pin^.imagedata);
            ti.planepick:=read8checks(pin,8);
            ti.planeonoff:=read8checks(pin,16);
            ti.nextimage:=nil;
            if (pin^.displaywindow<>nil) then
              if (pin^.pscr<>myscreen) then
                closeimagedisplaywindow(pin);
            openimagedisplaywindow(pin,myscreen,nil);
            if pin^.displaywindow<>nil then
              begin
                setrast(pin^.displaywindow^.rport,0);
                drawimage(pin^.displaywindow^.rport,@ti,0,0);
              end;
          end;
      4 : begin
            closeimageeditwindow(pin);
            if pin^.displaywindow<>nil then
              begin
                setrast(pin^.displaywindow^.rport,0);
                drawimage(pin^.displaywindow^.rport,pointer(@pin^.leftedge),0,0);
              end;
          end;
      91 :
          if inputmode=0 then
            begin
              replaceimage(pin);
              
              
              
            end;
     end;          
end;

procedure openabout;
const
  aboutstring2 : string[40]='About The Designer'#0;
var
  loop         : byte;
  abouttextt   : string;
  lenpos       : long;
begin
  
  if not demoversion then
    begin
      copymem(@registerstore[0],@registerstring[0],42);
      for loop:=0 to 40 do
        begin
          registerstring[loop]:=chr(ord(registerstring[loop])+ord(crypt1[loop]));
          registerstring[loop]:=chr(ord(registerstring[loop])-ord(crypt2[loop]));
        end;
    end
   else
    registerstring:='  Demonstration Version';
  
  abouttext:='The Designer'#10'Release V'+versionstring+#10#169' '+Ian+' 1994'#10;  {45}
  abouttext:=abouttext+{#10'Registered Owner :'}#10;
  abouttext:=abouttext+'Final release (2002) all restrictions removed';
  abouttext:=abouttext+#10+#10+'This version is freely distributable'+#10;
  abouttext:=abouttext+'It would be nice to think it still has some life left in it yet.';
   
  lenpos:=length(abouttext);
  
  registerstring:='hello world, how are you?              '#0;
    
  abouttextt:=#10+#10'Written using HighSpeed Pascal 1.20'#10#169' 1992 HiSoft, D-House & Christen Fihl'#0; {80}
  copymem(@abouttextt[1],pointer( long(@abouttext[0]) + lenpos+1),length(abouttextt));
  lenpos:=lenpos+length(abouttextt);

  if aboutwin=nil then
    begin
      waiteverything;
      with abouteasy do 
        begin
          es_structsize:=sizeof(teasystruct);
          es_flags:=0;
          es_title:=@aboutstring2[1];
          es_textformat:=@abouttext[1];
          es_gadgetformat:=@strings[16,2];
        end;
      inputmode:=1;
      aboutwin:=buildeasyrequestargs(mainwindow,@abouteasy,idcmp_diskinserted,pendtagitem);
      unwaiteverything;
    end;
end;

procedure gadgetwindowhandling(pgn:pgadgetnode;
                               messcopy:tintuimessage;
                               pdwn:pdesignerwindownode);
var 
  dummy : long;
  pgsel : pgadget;
  code  : word;
  class : long;
  psn   : pstringnode;
  psn2  : pstringnode;
  pgn2  : pgadgetnode;
  ldone : boolean;
  itemnumber : word;
  subnumber  : word;
  menunumber : word;
  loop,test  : word;
  pmt,pmt2   : pmytag;
  pni,pni2   : pnumberitem;
begin
  pgsel:=pgadget(messcopy.iaddress);
  code:=messcopy.code;
  class:=messcopy.class;
  ItemNumber:=ITEMNUM(code);
  MenuNumber:=MENUNUM(code);
  if class=idcmp_menupick then
    begin
      Case MenuNumber of
        GadgOpts :
          Case ItemNumber of
            GadgOptsFont :
              gadgetfont(pdwn,pgn);
            GadgOptsHelp :
              begin
                dummy:=0;
                case pgn^.kind of 
                  button_kind : dummy:=buttonhelp;
                  string_kind : dummy:=stringhelp;
                  integer_kind : dummy:=integerhelp;
                  checkbox_kind : dummy:=checkboxhelp;
                  mx_kind : dummy:=mxhelp;
                  cycle_kind : dummy:=cyclehelp;
                  slider_kind : dummy:=sliderhelp;
                  scroller_kind : dummy:=scrollerhelp;
                  listview_kind : dummy:=listviewhelp;
                  palette_kind : dummy:=palettehelp;
                  text_kind : dummy:=texthelp;
                  number_kind : dummy:=numberhelp;
                  mybool_kind : dummy:=boolhelp;
                  myobject_kind : dummy:=objecthelp;
                 end;
                helpwindow(@pdwn^.helpwin,dummy);
              end;
            GadgOptsClose :
              closeeditgadget(pdwn,pgn);
           end;
        objectmenu2,objectmenu3,objectmenu4 :
           if inputmode=0 then
             begin
               processmenuidcmpobjectmenu(pdwn,pgn,code);
             end;
       end;
    end;
  
  case pgn^.kind of
          
    {*********************************}
    {*                               *}
    {*     Object Edit Handling      *}
    {*                               *}
    {*********************************}
                      
    myobject_kind : 
      begin
        dummy:=64561;
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        if (class=idcmp_gadgetup) then
          dummy:=pgsel^.gadgetid;
        
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=10;
            {
            'F','f' : if inputmode=0 then
                           dummy:=8;
            }
            'C','c' : if inputmode=0 then
                           dummy:=11;
            {
            'L','l' : if inputmode=0 then
                           if activategadget(pgn^.editwindow^.gads[7],
                                             pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[5],
                                          pgn^.editwindow^.pwin,nil) then;
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>4 then
                             pgn^.editwindow^.data:=0;
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                   pgn^.editwindow^.pwin,
                                                   gtcy_active,
                                                   pgn^.editwindow^.data);
                        end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=4
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'd','D' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[3],
                                       pgn^.editwindow^.pwin);
            'u','U' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[4],
                                       pgn^.editwindow^.pwin);
            }
           end;
        
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=10;
        case dummy of
          0  :
            if pgn^.editwindow^.data4<>~0 then
              begin
                pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                if pmt^.tagtype<>code then
                  begin
                    pmt^.tagtype:=code;
                    if (pmt^.data<>nil) and (pmt^.sizebuffer<>0) then
                      freemymem(pmt^.data,pmt^.sizebuffer);
                    pmt^.data:=nil;
                    pmt^.sizebuffer:=0;
                    settagdata(pdwn,pgn);
                  end;
              end;
          13 :
           if inputmode=0 then
            if pgn^.editwindow^.data4<>~0 then
              begin
                pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                if pmt^.tagtype<>tagtypeselect then
                  begin
                    pmt^.tagtype:=tagtypeselect;
                    if (pmt^.data<>nil) and (pmt^.sizebuffer<>0) then
                      freemymem(pmt^.data,pmt^.sizebuffer);
                    pmt^.data:=nil;
                    pmt^.sizebuffer:=0;
                    settagdata(pdwn,pgn);
                  end;
              end;
          2  :
            pgn^.editwindow^.data:=code;
          5  :
            readtagdata(pdwn,pgn);
          6  :
            begin
              if inputmode=0 then
                if code<>pgn^.editwindow^.data4 then
                  begin
                    readtagdata(pdwn,pgn);
                    pgn^.editwindow^.data4:=code;
                    settagdata(pdwn,pgn);
                  end ;
            end;
          7  :
            if inputmode=0 then
              begin
                readtagdata(pdwn,pgn);
                pmt:=allocmymem(sizeof(tmytag),memf_clear or memf_any);
                if pmt<>nil then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    addtail(@pgn^.editwindow^.editlist,pnode(pmt));
                    pmt^.tagtype:=tagtypelong;
                    pmt^.value:=1;
                    pmt^.title:='TAG_IGNORE'#0;
                    pmt^.ln_name:=@pmt^.title[1];
                    pgn^.editwindow^.data4:=sizeoflist(@pgn^.editwindow^.editlist)-1;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    settagdata(pdwn,pgn);
                  end
                 else
                  telluser(pgn^.editwindow^.pwin,memerror);
              end;
          8  :
            if inputmode=0 then
              begin
                { delete tag }
                if pgn^.editwindow^.data4<>~0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                    remove(pnode(pmt));
                    freemytag(pmt);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[taglist],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    if pgn^.editwindow^.data4>0 then
                      dec(pgn^.editwindow^.data4);
                    if sizeoflist(@pgn^.editwindow^.editlist)=0 then
                      pgn^.editwindow^.data4:=~0;
                    settagdata(pdwn,pgn);
                  end;
              end;
          10 : 
            if inputmode=0 then
              begin
                getobjectdatafromwin(pdwn,pgn);
                updateeditwindow:=true;
                pgn^.justcreated:=false;
                closeeditgadget(pdwn,pgn);
              end;
          11 : if inputmode=0 then
            closeeditgadget(pdwn,pgn);
          12 : if inputmode=0 then
            helpwindow(@pdwn^.helpwin,objecthelp);
          17 :
            pgn^.tags[3].ti_data:=code;
          
          10997 :
            begin
              if inputmode=0 then
                  begin
                    
                    pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                    readtagdata(pdwn,pgn);
                    psn:=pstringnode(GetNthnode(@knowntaglist,code));
                    if psn^.ln_pri = 0 then
                      begin
                        pmt^.value:=knowntags[code].value;
                        pmt^.title:=knowntags[code].name;
                      end
                     else
                      begin
                        pmt^.value:=psn^.va;
                        pmt^.title:=psn^.st;
                      end;
                    pmt^.tagtype:=tagtypelong;
                    settagdata(pdwn,pgn);
                    selectlistpos:=code;
                    
                  end ;
              
            end;
          
          997 :
            begin
              pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
              pgn^.editwindow^.data2:=code;
              pmt^.data:=getnthnode(@teditimagelist,pgn^.editwindow^.data2);
            end;
          
          4997 :
            begin
              pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
              pgn^.editwindow^.data2:=code;
              pmt^.data:=getnthnode(@pdwn^.gadgetlist,pgn^.editwindow^.data2);
            end;
          
          1004 :
            if inputmode=0 then
              begin
                pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                if pgn^.editwindow^.data3<>~0 then
                  begin
                    pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                    
                    if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist) then
                      begin
                        pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                      end
                     else
                      begin
                        pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                        if pmt^.tagtype=tagtypearrayword then
                          pni^.num:=pni^.num and 65535
                         else
                          if pmt^.tagtype=tagtypearraybyte then
                            pni^.num:=pni^.num and 255;
                        system.str(pni^.num,pni^.title);
                        pni^.title:=pni^.title+#0;
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.extralist));
                  end
                 else
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                           ga_disabled,long(false));
                  end;
                pgn^.editwindow^.data3:=code;
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                if (pmt^.tagtype=tagtypearraystring)  or (pmt^.tagtype=tagtypestringlist) then
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                         gtst_string,long(@pni^.title[1]))
                 else
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                         gtin_number,long(pni^.num));
              end;
          
          1005 :
            if inputmode=0 then
              begin
                pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                if pgn^.editwindow^.data3<>~0 then
                  begin
                    pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                    if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                      begin
                        pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                      end
                     else
                      begin
                        pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                        if pmt^.tagtype=tagtypearrayword then
                          pni^.num:=pni^.num and 65535
                         else
                          if pmt^.tagtype=tagtypearraybyte then
                            pni^.num:=pni^.num and 255;
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               gtin_number,long(pni^.num));
                        system.str(pni^.num,pni^.title);
                        pni^.title:=pni^.title+#0;
                      end
                  end;
                
                pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                if pni<>nil then
                  begin
                    addtail(@pgn^.editwindow^.extralist,pnode(pni));
                    pgn^.editwindow^.data3:=sizeoflist(@pgn^.editwindow^.extralist)-1;
                    pni^.ln_name:=@pni^.title[1];
                    if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                      begin
                        pni^.title:='New Item'#0;
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               gtst_string,long(@pni^.title[1]));
                      end
                     else
                      begin
                        system.str(pni^.num,pni^.title);
                        pni^.title:=pni^.title+#0;
                      
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               gtin_number,long(pni^.num));
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                           ga_disabled,long(false));
                    
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                         gtlv_labels,~0);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@pgn^.editwindow^.extralist));
                 
                  end;
              end;
          1006 :
            if inputmode=0 then
              if pgn^.editwindow^.data3<>~0 then
                begin
                  
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                  if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                    begin
                      pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                    end
                   else
                    begin
                      pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                      if pmt^.tagtype=tagtypearrayword then
                        pni^.num:=pni^.num and 65535
                       else
                        if pmt^.tagtype=tagtypearraybyte then
                          pni^.num:=pni^.num and 255;
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                             gtin_number,long(pni^.num));
                      system.str(pni^.num,pni^.title);
                      pni^.title:=pni^.title+#0;
                    end;

                  if pgn^.editwindow^.data3>0 then
                    begin
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,~0);
                      pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                      pni2:=pni^.ln_pred;
                      remove(pnode(pni2));
                      insert_(@pgn^.editwindow^.extralist,pnode(pni2),pnode(pni));
                      dec(pgn^.editwindow^.data3);
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,long(@pgn^.editwindow^.extralist));
                    end;
                end;
          1007 :
            if inputmode=0 then
              if pgn^.editwindow^.data3<>~0 then
                begin
                  
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                  if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                    begin
                      pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                    end
                   else
                    begin
                      pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                      if pmt^.tagtype=tagtypearrayword then
                        pni^.num:=pni^.num and 65535
                       else
                        if pmt^.tagtype=tagtypearraybyte then
                          pni^.num:=pni^.num and 255;
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                             gtin_number,long(pni^.num));
                      system.str(pni^.num,pni^.title);
                      pni^.title:=pni^.title+#0;
                    end;

                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  if pni^.ln_succ^.ln_succ<>nil then
                    begin
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,~0);
                      pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                      pni2:=pni^.ln_succ;
                      remove(pnode(pni));
                      insert_(@pgn^.editwindow^.extralist,pnode(pni),pnode(pni2));
                      inc(pgn^.editwindow^.data3);
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,long(@pgn^.editwindow^.extralist));
                    end;
                end;
          1008 :
            if inputmode=0 then
              begin
                if pgn^.editwindow^.data3<>~0 then
                  begin
                    pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                    pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                    remove(pnode(pni));
                    freemymem(pni,sizeof(tnumberitem));
                    if pgn^.editwindow^.data3>0 then
                      dec(pgn^.editwindow^.data3);
                    if sizeoflist(@pgn^.editwindow^.extralist)=0 then
                      begin
                        pgn^.editwindow^.data3:=~0;
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               ga_disabled,long(true));
                      end
                     else
                      begin
                        pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                        if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                          begin
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               gtst_string,long(@pni^.title[1]));
                          end
                         else
                          begin
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                               gtin_number,pni^.num);
                          end;
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,~0);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                             gtlv_labels,long(@pgn^.editwindow^.extralist));
                  end;
              end;
          1009 :
            begin
              if pgn^.editwindow^.data3<>~0 then
                begin
                  pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                  pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
        
                  if (pmt^.tagtype=tagtypearraystring) or (pmt^.tagtype=tagtypestringlist)  then
                    begin
                      pni^.title:=getstringfromgad(pgn^.editwindow^.gads[25]);
                      
                    end
                   else
                    begin
                      pni^.num:=getintegerfromgad(pgn^.editwindow^.gads[25]);
                      if pmt^.tagtype=tagtypearrayword then
                        pni^.num:=pni^.num and 65535
                       else
                        if pmt^.tagtype=tagtypearraybyte then
                          pni^.num:=pni^.num and 255;
                      gt_setsinglegadgetattr(pgn^.editwindow^.gads[25],pgn^.editwindow^.pwin,
                                             gtin_number,long(pni^.num));
                      system.str(pni^.num,pni^.title);
                      pni^.title:=pni^.title+#0;
                    end;
                  
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                         gtlv_labels,~0);
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                         gtlv_labels,long(@pgn^.editwindow^.extralist));
                  
                end;
            end;
          2007 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                pni^.words[3]:=code;
              end;
          2008 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                pni^.words[4]:=code;
              end;
          2009 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                pni^.words[5]:=jam1 or (pni^.words[5] and INVERSVID);
                setintuitextdata(pdwn,pgn);
              end;
           2010 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                pni^.words[5]:=jam2 or (pni^.words[5] and INVERSVID);
                setintuitextdata(pdwn,pgn);
              end;
           2011 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                pni^.words[5]:=complement or (pni^.words[5] and INVERSVID);
                setintuitextdata(pdwn,pgn);
              end;
           20012 :
            if pgn^.editwindow^.data3<>~0 then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                if checkedbox(pgn^.editwindow^.gads[27]) then
                  pni^.words[5]:=pni^.words[5] or INVERSVID
                 else
                  pni^.words[5]:=pni^.words[5] and ~INVERSVID;
                setintuitextdata(pdwn,pgn);
              end;
           2014 :
             if (inputmode=0)and(pgn^.editwindow^.data3<>~0) then
              begin
                getintuitextdata(pdwn,pgn);
                if pgn^.editwindow^.data3>0 then
                  begin
                    dec(pgn^.editwindow^.data3);
                    setintuitextdata(pdwn,pgn);
                  end;
              end;
           2016 :
             if (inputmode=0)and(pgn^.editwindow^.data3<>~0) then
              begin
                getintuitextdata(pdwn,pgn);
                if pgn^.editwindow^.data3<sizeoflist(@pgn^.editwindow^.extralist)-1 then
                  begin
                    inc(pgn^.editwindow^.data3);
                    setintuitextdata(pdwn,pgn);
                  end;
              end;
           
          2017 :
            if (inputmode=0)and(pgn^.editwindow^.data3<>~0) then
              begin
                pni:=pnumberitem(getnthnode(@pgn^.editwindow^.extralist,pgn^.editwindow^.data3));
                remove(pnode(pni));
                freemymem(pni,sizeof(tnumberitem));
                if pgn^.editwindow^.data3>0 then
                  dec(pgn^.editwindow^.data3);
                if sizeoflist(@pgn^.editwindow^.extralist)=0 then
                  pgn^.editwindow^.data3:=~0;
                setintuitextdata(pdwn,pgn);
              end;
          
          2015 :
            if (inputmode=0) then
              begin
                getintuitextdata(pdwn,pgn);
                pni:=allocmymem(sizeof(tnumberitem),memf_clear or memf_any);
                if pni<>nil then
                  begin
                    addtail(@pgn^.editwindow^.extralist,pnode(pni));
                    pni^.title:='New Text'#0;
                    pni^.words[3]:=1;
                    pni^.words[5]:=jam1;
                    pgn^.editwindow^.data3:=sizeoflist(@pgn^.editwindow^.extralist)-1;
                  end
                 else
                  telluser(pgn^.editwindow^.pwin,memerror);
                setintuitextdata(pdwn,pgn);
              end;
              
          
         end;
      end;
                 
    
    {*********************************}
    {*                               *}
    {*     Button Edit Handling      *}
    {*                               *}
    {*********************************}
                      
    button_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=173;
            'F','f' : if inputmode=0 then
                           dummy:=175;
            'C','c' : if inputmode=0 then
                           dummy:=174;
            'L','l' : if inputmode=0 then
                           if activategadget(pgn^.editwindow^.gads[7],
                                             pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[5],
                                          pgn^.editwindow^.pwin,nil) then;
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>4 then
                             pgn^.editwindow^.data:=0;
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                   pgn^.editwindow^.pwin,
                                                   gtcy_active,
                                                   pgn^.editwindow^.data);
                        end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=4
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'd','D' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[3],
                                       pgn^.editwindow^.pwin);
            'u','U' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[4],
                                       pgn^.editwindow^.pwin);
           end;
        if class=idcmp_gadgetup then
          case pgsel^.gadgetid of
            173 : if inputmode=0 then
                  dummy:=173;
            174 : if inputmode=0 then
                  dummy:=174;
            6   : pgn^.editwindow^.data:=code;
            175 : if inputmode=0 then
                  dummy:=175;
           end;
          if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
            dummy:=173;

          case dummy of
            173 : begin
                  pgn^.tags[2].ti_data:=
                      long(checkedbox(pgn^.editwindow^.gads[3]));
                  pgn^.tags[3].ti_data:=
                      long(checkedbox(pgn^.editwindow^.gads[4]));
                  pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[5]);
                  pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                  case pgn^.editwindow^.data of
                     0: pgn^.flags:=placetext_in;
                     1: pgn^.flags:=placetext_above;
                     2: pgn^.flags:=placetext_below;
                     3: pgn^.flags:=placetext_left;
                     4: pgn^.flags:=placetext_right;
                    end;
                   copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                   pgn^.fontname:=pgn^.editwindow^.tfontname;
                   pgn^.justcreated:=false;
                   closeeditgadget(pdwn,pgn);
                   updateeditwindow:=true;
                   inputmode:=1;
                 end;
            174 : closeeditgadget(pdwn,pgn);
            6 : pgn^.editwindow^.data:=code;
            175 : gadgetfont(pdwn,pgn);
           end;
      end;
                 
    {*********************************}
    {*                               *}
    {*  StringInteger Edit Handling  *}
    {*                               *}
    {*********************************}
    
    string_kind,integer_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=173;
            'F','f' : if inputmode=0 then
                        dummy:=175;
            'C','c' : if inputmode=0 then
                        dummy:=174;
            'L','l' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[7],
                                          pgn^.editwindow^.pwin,nil) then;
            'M','m' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[12],
                                          pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[5],
                                          pgn^.editwindow^.pwin,nil) then;
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>4 then
                            pgn^.editwindow^.data:=0;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=4
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'j'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data2);
                          if pgn^.editwindow^.data2>2 then
                            pgn^.editwindow^.data2:=0;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data2);
                        end;
            'J'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data2=0 then
                            pgn^.editwindow^.data2:=2
                           else
                            dec(pgn^.editwindow^.data2);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data2);
                        end;
            'd','D' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[3],
                                       pgn^.editwindow^.pwin);
            'u','U' : if inputmode=0 then
                        togglecheckbox(pgn^.editwindow^.gads[4],
                                       pgn^.editwindow^.pwin);
           end;
        if class=idcmp_gadgetup then
          case pgsel^.gadgetid of
            173  : if inputmode=0 then
                   dummy:=173;
            174  : if inputmode=0 then
                   dummy:=174;
            6    : pgn^.editwindow^.data:=code;
            175  : if inputmode=0 then
                   dummy:=175;
            11 : pgn^.editwindow^.data2:=code; 
           end;
        case dummy of
          173 : begin
                if pgn^.kind=string_kind then
                  pgn^.contents:=getstringfromgad(pgn^.editwindow^.gads[16])
                 else
                  pgn^.contents2:=getintegerfromgad(pgn^.editwindow^.gads[16]);
                pgn^.tags[9].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[14]));
                pgn^.tags[4].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[3]));
                pgn^.tags[8].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[4]));
                pgn^.tags[3].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[9]));
                pgn^.tags[5].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[10]));
                pgn^.tags[6].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[13]));
                pgn^.edithook:=getstringfromgad(pgn^.editwindow^.gads[15]);
                pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[12]);
                pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[5]);
                pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                case pgn^.editwindow^.data of
                  0: pgn^.flags:=placetext_above;
                  1: pgn^.flags:=placetext_below;
                  2: pgn^.flags:=placetext_left;
                  3: pgn^.flags:=placetext_right;
                 end;
                case pgn^.editwindow^.data2 of
                  0: pgn^.tags[2].ti_data:=gact_stringleft;
                  1: pgn^.tags[2].ti_data:=gact_stringright;
                  2: pgn^.tags[2].ti_data:=gact_stringcenter;
                 end;
                copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                pgn^.fontname:=pgn^.editwindow^.tfontname;
                checkgadsize(pdwn,pgn);
                pgn^.justcreated:=false;
                closeeditgadget(pdwn,pgn);
                updateeditwindow:=true;
                inputmode:=1;
              end;
          174 : closeeditgadget(pdwn,pgn);
          6 : pgn^.editwindow^.data:=code;
          175 : gadgetfont(pdwn,pgn);
         end;
      end;
      
    {*********************************}
    {*                               *}
    {*    Checkbox Edit Handling     *}
    {*                               *}
    {*********************************}
    
    checkbox_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if (class=idcmp_vanillakey) and 
           (inputmode=0) then
          begin
            case chr(code) of
              'C','c' : dummy:=174;
              'O','o' : dummy:=173;
              'F','f' : dummy:=175;
              'L','l' : if inputmode=0 then
                          if activategadget(pgn^.editwindow^.gads[8],
                                            pgn^.editwindow^.pwin,nil) then;
              'T','t' : if inputmode=0 then
                          if activategadget(pgn^.editwindow^.gads[3],
                                            pgn^.editwindow^.pwin,nil) then;
              'p'     : if inputmode=0 then
                          begin
                            inc(pgn^.editwindow^.data);
                            if pgn^.editwindow^.data>3 then
                              pgn^.editwindow^.data:=0;
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                   pgn^.editwindow^.pwin,
                                                   gtcy_active,
                                                   pgn^.editwindow^.data);
                          end;
              'P'     : if inputmode=0 then
                          begin
                            if pgn^.editwindow^.data=0 then
                              pgn^.editwindow^.data:=3
                             else
                              dec(pgn^.editwindow^.data);
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                   pgn^.editwindow^.pwin,
                                                   gtcy_active,
                                                   pgn^.editwindow^.data);
                          end;
              'd','D' : if inputmode=0 then
                          togglecheckbox(pgn^.editwindow^.gads[5],
                                         pgn^.editwindow^.pwin);
              'u','U' : if inputmode=0 then
                          togglecheckbox(pgn^.editwindow^.gads[7],
                                         pgn^.editwindow^.pwin);
             end;
          end;
        if (class=idcmp_gadgetup) then
          dummy:=pgsel^.gadgetid;
        case dummy of
          173 : if inputmode=0 then
            begin
              pgn^.tags[3].ti_data:=
                long(checkedbox(pgn^.editwindow^.gads[5]));
              pgn^.tags[1].ti_data:=
                long(checkedbox(pgn^.editwindow^.gads[4]));
              pgn^.tags[4].ti_data:=
                long(checkedbox(pgn^.editwindow^.gads[7]));
              
              
              pgn^.tags[5].ti_data:=
                long(checkedbox(pgn^.editwindow^.gads[10]));
              
              
              pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[3]);
              pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[8]);
              case pgn^.editwindow^.data of
                0: pgn^.flags:=placetext_above;
                1: pgn^.flags:=placetext_below;
                2: pgn^.flags:=placetext_left;
                3: pgn^.flags:=placetext_right;
               end;
              copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
              pgn^.fontname:=pgn^.editwindow^.tfontname;
              pgn^.justcreated:=false;
              closeeditgadget(pdwn,pgn);
              updateeditwindow:=true;
              inputmode:=1;
            end;
          174 : if (inputmode=0) then
                closeeditgadget(pdwn,pgn);
          6 : pgn^.editwindow^.data:=code;
          175 : gadgetfont(pdwn,pgn);
         end;
      end;
    
    {*********************************}
    {*                               *}
    {*    Ex-Cycle Edit Handling     *}
    {*                               *}
    {*********************************}
    
    { ignore - out of date
    cycle_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        if (class=idcmp_gadgetup) then
          begin
            if (pgsel^.gadgetid=3) then
              pgn^.editwindow^.data:=code;
            if (pgsel^.gadgetid=2) and
               (inputmode=0) then
              closeeditgadget(pdwn,pgn);
            if (pgsel^.gadgetid=1) and
               (inputmode=0) then
              begin
                pgn^.tags[3].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[5]));
                pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[4]);
                case pgn^.editwindow^.data of
                  0: pgn^.flags:=placetext_above;
                  1: pgn^.flags:=placetext_below;
                  2: pgn^.flags:=placetext_left;
                  3: pgn^.flags:=placetext_right;
                 end;
                closeeditgadget(pdwn,pgn);
                updateeditwindow:=true;
                inputmode:=1;
              end;
          end;
      end;
    }
    
    {*********************************}
    {*                               *}
    {*     Slider Edit Handling      *}
    {*                               *}
    {*********************************}
      slider_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if (class=idcmp_gadgetup) then
          begin
            case
              pgsel^.gadgetid of
                3  : pgn^.editwindow^.data:=code;
                11 : pgn^.editwindow^.data2:=code;
                174  : if inputmode=0 then
                       closeeditgadget(pdwn,pgn);
                173  : dummy:=173;
                13 : pgn^.editwindow^.data3:=code;
                175 : gadgetfont(pdwn,pgn);
             end;
          end;
        if (class=idcmp_vanillakey) then
          case chr(code) of
            'O','o' : dummy:=173;
            'C','c' : if inputmode=0 then
                          closeeditgadget(pdwn,pgn);
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>3 then
                            pgn^.editwindow^.data:=0;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                          end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=3
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'd','D' : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data2=1 then
                            pgn^.editwindow^.data2:=0
                           else
                            pgn^.editwindow^.data2:=1;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data2);
                        end;
            'L','l' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[7],
                                          pgn^.editwindow^.pwin,nil) then;
            'X','x' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[6],
                                          pgn^.editwindow^.pwin,nil) then;
            'N','n' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[5],
                                          pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[4],
                                          pgn^.editwindow^.pwin,nil) then;
            'F','f' : if inputmode=0 then
                        gadgetfont(pdwn,pgn);
           end;
        case dummy of
          173  : if (inputmode=0) then
                 begin
                   pgn^.tags[12].ti_data:=
                     long(checkedbox(pgn^.editwindow^.gads[8]));
                   pgn^.tags[13].ti_data:=
                     long(checkedbox(pgn^.editwindow^.gads[9]));
                   pgn^.tags[11].ti_data:=
                     long(checkedbox(pgn^.editwindow^.gads[10]));
                   pgn^.tags[4].ti_data:=
                     long(checkedbox(pgn^.editwindow^.gads[16]));
                   pgn^.tags[14].ti_data:=
                     long(checkedbox(pgn^.editwindow^.gads[1]));
                   pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[4]);
                   pgn^.edithook:=getstringfromgad(pgn^.editwindow^.gads[17]);
                   pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                   pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[6]);
                   pgn^.tags[3].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[7]);
                   case pgn^.editwindow^.data2 of
                     0: pgn^.tags[9].ti_data:=lorient_horiz;
                     1: pgn^.tags[9].ti_data:=lorient_vert;
                    end;
                   case pgn^.editwindow^.data of
                     0: pgn^.flags:=placetext_above;
                     1: pgn^.flags:=placetext_below;
                     2: pgn^.flags:=placetext_left;
                     3: pgn^.flags:=placetext_right;
                    end;
                   case pgn^.editwindow^.data3 of
                     0: pgn^.tags[6].ti_data:=placetext_above;
                     1: pgn^.tags[6].ti_data:=placetext_below;
                     2: pgn^.tags[6].ti_data:=placetext_left;
                     3: pgn^.tags[6].ti_data:=placetext_right;
                    end;
                   pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[12]);
                   pgn^.datas:=getstringfromgad(pgn^.editwindow^.gads[14]);
                   pgn^.tags[5].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[15]);
                   copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                   pgn^.fontname:=pgn^.editwindow^.tfontname;
                   checkgadsize(pdwn,pgn);
                   pgn^.justcreated:=false;
                   closeeditgadget(pdwn,pgn);
                   updateeditwindow:=true;
                   inputmode:=1;
                 end;
         end;
      end;
    
    {*********************************}
    {*                               *}
    {*     Palette Edit Handling     *}
    {*                               *}
    {*********************************}
    
    palette_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if (class=idcmp_gadgetup) then
          begin
            if (pgsel^.gadgetid=3) then
              pgn^.editwindow^.data:=code;
            if (pgsel^.gadgetid=174) and
               (inputmode=0) then
              closeeditgadget(pdwn,pgn);
            if (pgsel^.gadgetid=173) then
              dummy:=173;
            if (pgsel^.gadgetid=175) then
              gadgetfont(pdwn,pgn);
            if (pgsel^.gadgetid=11) then
              gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                     gtcb_checked,long(false));
            if (pgsel^.gadgetid=12) then
              gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],pgn^.editwindow^.pwin,
                                     gtcb_checked,long(false));
          end;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : dummy:=173;
            'C','c' : if inputmode=0 then
                        closeeditgadget(pdwn,pgn);
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>3 then
                            pgn^.editwindow^.data:=0;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                          end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=3
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'F','f' : gadgetfont(pdwn,pgn);
            'L','l' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[14],
                                          pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[4],
                                          pgn^.editwindow^.pwin,nil) then;
            'I','i' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[13],
                                          pgn^.editwindow^.pwin,nil) then;
           end;
        case dummy of
          173:if(inputmode=0) then
              begin
                pgn^.tags[7].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[10]));
                pgn^.tags[8].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[1]));
                if checkedbox(pgn^.editwindow^.gads[11]) then
                  pgn^.tags[4].ti_tag:=gtpa_indicatorwidth
                 else
                  pgn^.tags[4].ti_tag:=tag_ignore;
                if checkedbox(pgn^.editwindow^.gads[12]) then
                  pgn^.tags[5].ti_tag:=gtpa_indicatorheight
                 else
                  pgn^.tags[5].ti_tag:=tag_ignore;
                pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[4]);
                pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[6]);
                pgn^.tags[3].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[7]);
                pgn^.tags[4].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[13]);
                pgn^.tags[5].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[13]);
                pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[14]);
                case pgn^.editwindow^.data of
                  0: pgn^.flags:=placetext_above;
                  1: pgn^.flags:=placetext_below;
                  2: pgn^.flags:=placetext_left;
                  3: pgn^.flags:=placetext_right;
                 end;
                copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                pgn^.fontname:=pgn^.editwindow^.tfontname;
                checkgadsize(pdwn,pgn);
                pgn^.justcreated:=false;
                closeeditgadget(pdwn,pgn);
                updateeditwindow:=true;
                inputmode:=1;
              end;
         end;
      end;
    
    {*********************************}
    {*                               *}
    {*    Scroller Edit Handling     *}
    {*                               *}
    {*********************************}
    
    scroller_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if (class=idcmp_gadgetup) then
          begin
            if (pgsel^.gadgetid=3) then
              pgn^.editwindow^.data:=code;
            if (pgsel^.gadgetid=11) then
              pgn^.editwindow^.data2:=code;
            if (pgsel^.gadgetid=174) and
               (inputmode=0) then
              closeeditgadget(pdwn,pgn);
            if (pgsel^.gadgetid=173) then
              dummy:=173;
            if (pgsel^.gadgetid=175) then
              gadgetfont(pdwn,pgn);
          end;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : dummy:=173;
            'C','c' : if inputmode=0 then
                        closeeditgadget(pdwn,pgn);
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>3 then
                            pgn^.editwindow^.data:=0;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                          end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=3
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[3],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
            'd','D' : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data2=1 then
                            pgn^.editwindow^.data2:=0
                           else
                            pgn^.editwindow^.data2:=1;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[11],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data2);
                        end;
            'F','f' : gadgetfont(pdwn,pgn);
            'L','l' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[14],
                                          pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[4],
                                          pgn^.editwindow^.pwin,nil) then;
           end;
        case dummy of
          173:if(inputmode=0) then
              begin
                pgn^.tags[10].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[8]));
                pgn^.tags[11].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[9]));
                pgn^.tags[9].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[10]));
                pgn^.tags[12].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[1]));
                pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[4]);
                pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[6]);
                pgn^.tags[3].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[7]);
                pgn^.tags[4].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[13]);
                pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[14]);
                if checkedbox(pgn^.editwindow^.gads[12]) then
                  pgn^.tags[4].ti_tag:=gtsc_arrows
                 else
                  pgn^.tags[4].ti_tag:=tag_ignore;
                case pgn^.editwindow^.data2 of
                  0: pgn^.tags[7].ti_data:=lorient_horiz;
                  1: pgn^.tags[7].ti_data:=lorient_vert;
                 end;
                case pgn^.editwindow^.data of
                  0: pgn^.flags:=placetext_above;
                  1: pgn^.flags:=placetext_below;
                  2: pgn^.flags:=placetext_left;
                  3: pgn^.flags:=placetext_right;
                 end;
                copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                pgn^.fontname:=pgn^.editwindow^.tfontname;
                checkgadsize(pdwn,pgn);
                pgn^.justcreated:=false;
                closeeditgadget(pdwn,pgn);
                updateeditwindow:=true;
                inputmode:=1;
              end;
         end;
      end;
    
    {*********************************}
    {*                               *}
    {*   Ex-Listview Edit Handling   *}
    {*                               *}
    {*********************************}
    
    { out of date handling
    listview_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        if (class=idcmp_gadgetup) then
          begin
            if (pgsel^.gadgetid=3) then
              pgn^.editwindow^.data:=code;
            if (pgsel^.gadgetid=2) and
               (inputmode=0) then
              closeeditgadget(pdwn,pgn);
            if (pgsel^.gadgetid=1) and
               (inputmode=0) then
              begin
                pgn^.tags[8].ti_data:=
                  long(checkedbox(pgn^.editwindow^.gads[5]));
                if checkedbox(pgn^.editwindow^.gads[6]) then
                  pgn^.tags[3].ti_tag:=gtlv_showselected
                   else
                    pgn^.tags[3].ti_tag:=tag_ignore;
                pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[4]);
                pgn^.tags[4].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[7]);
                pgn^.tags[6].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[8]);
                case pgn^.editwindow^.data of
                  0: pgn^.flags:=placetext_above;
                  1: pgn^.flags:=placetext_below;
                  2: pgn^.flags:=placetext_left;
                  3: pgn^.flags:=placetext_right;
                 end;
                pgn^.justcreated:=false;
                closeeditgadget(pdwn,pgn);
                updateeditwindow:=true;
                inputmode:=1;
              end;
          end;
      end;
    }
    
    {*********************************}
    {*                               *}
    {*   TextNumber Edit Handling    *}
    {*                               *}
    {*********************************}
                      
    text_kind,number_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=173;
            'F','f' : if inputmode=0 then
                           dummy:=175;
            'C','c' : if inputmode=0 then
                           dummy:=174;
            'L','l' : if inputmode=0 then
                           if activategadget(pgn^.editwindow^.gads[7],
                                             pgn^.editwindow^.pwin,nil) then;
            'T','t' : if inputmode=0 then
                        if activategadget(pgn^.editwindow^.gads[5],
                                          pgn^.editwindow^.pwin,nil) then;
            'p'     : if inputmode=0 then
                        begin
                          inc(pgn^.editwindow^.data);
                          if pgn^.editwindow^.data>3 then
                             pgn^.editwindow^.data:=0;
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                   pgn^.editwindow^.pwin,
                                                   gtcy_active,
                                                   pgn^.editwindow^.data);
                        end;
            'P'     : if inputmode=0 then
                        begin
                          if pgn^.editwindow^.data=0 then
                            pgn^.editwindow^.data:=3
                           else
                            dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
           end;
        if class=idcmp_gadgetup then
          case pgsel^.gadgetid of
            173 : if inputmode=0 then
                  dummy:=173;
            174 : if inputmode=0 then
                  dummy:=174;
            6 : pgn^.editwindow^.data:=code;
            175 : if inputmode=0 then
                  dummy:=175;
            10,11,12,13 : dummy:=pgsel^.gadgetid;
           end;
          case dummy of
            173 : begin
                  pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[5]);
                  pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                  case pgn^.editwindow^.data of
                    0: pgn^.flags:=placetext_above;
                    1: pgn^.flags:=placetext_below;
                    2: pgn^.flags:=placetext_left;
                    3: pgn^.flags:=placetext_right;
                   end;
                  
                  pgn^.tags[5].ti_data:=long(checkedbox(pgn^.editwindow^.gads[10]));
                  pgn^.tags[6].ti_data:=pgn^.tags[6].ti_tag;
                  pgn^.tags[7].ti_data:=pgn^.tags[7].ti_tag;
                  pgn^.tags[8].ti_data:=pgn^.tags[8].ti_tag;
                  pgn^.tags[9].ti_data:=long(checkedbox(pgn^.editwindow^.gads[14]));
                  
                  pgn^.tags[2].ti_data:=
                    long(checkedbox(pgn^.editwindow^.gads[9]));
                  if pgn^.kind=text_kind then
                    begin
                     pgn^.datas:=getstringfromgad(pgn^.editwindow^.gads[4]);
                     pgn^.tags[3].ti_data:=long(checkedbox(pgn^.editwindow^.gads[3]));
                    end
                   else
                    begin
                      pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[4]);
                      pgn^.tags[10].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[16]);
                      pgn^.datas:=getstringfromgad(pgn^.editwindow^.gads[15]);
                    end;
                  copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                  pgn^.fontname:=pgn^.editwindow^.tfontname;
                  pgn^.justcreated:=false;
                  closeeditgadget(pdwn,pgn);
                  updateeditwindow:=true;
                  inputmode:=1;
                end;
            174 : closeeditgadget(pdwn,pgn);
            6 : pgn^.editwindow^.data:=code;
            175 : gadgetfont(pdwn,pgn);
            10 : if inputmode=0 then
                   begin
                     if pgn^.kind=number_kind then
                       test:=16
                      else
                       test:=14;
                     for loop:=11 to test do
                       gt_setsinglegadgetattr(pgn^.editwindow^.gads[loop],pgn^.editwindow^.pwin,
                                          ga_disabled,long(not checkedbox(pgsel)));
                   end;
            11 : pgn^.tags[6].ti_tag:=code;
            12 : pgn^.tags[7].ti_tag:=code;
            13 : pgn^.tags[8].ti_tag:=code;
           end;
      end;
    
    {*********************************}
    {*                               *}
    {*    Radiocycle Edit Handling   *}
    {*                               *}
    {*********************************}
                      
    mx_kind,cycle_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=173;
            'F','f' : if inputmode=0 then
                           dummy:=75;
            'C','c' : if inputmode=0 then
                           dummy:=74;
            'L','l' : if inputmode=0 then
                           if activategadget(pgn^.editwindow^.gads[7],
                                             pgn^.editwindow^.pwin,nil) then;
            'T','t' : if (inputmode=0) then
                        if activategadget(pgn^.editwindow^.gads[15],
                                          pgn^.editwindow^.pwin,nil) then;
            'p','P' : if inputmode=0 then
                        begin
                          if pgn^.kind=mx_kind then
                            begin
                              if pgn^.editwindow^.data=1 then
                                pgn^.editwindow^.data:=0
                               else
                                pgn^.editwindow^.data:=1;
                            end
                           else
                            begin
                              if chr(code)='p' then
                                if pgn^.editwindow^.data=3 then
                                  pgn^.editwindow^.data:=0
                                 else
                                  inc(pgn^.editwindow^.data)
                               else
                                if pgn^.editwindow^.data=0 then
                                  pgn^.editwindow^.data:=3
                                 else
                                  dec(pgn^.editwindow^.data);
                            end;
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
           end;
        if class=idcmp_gadgetup then
          case pgsel^.gadgetid of
            173,174,175 : if inputmode=0 then
                  dummy:=pgsel^.gadgetid;
            6 : pgn^.editwindow^.data:=code;
            77: pgn^.editwindow^.data4:=code;
            9 : if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    { make new one }
                    
                    {get old}
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    
                    psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
                    if psn<>nil then
                      begin
                        psn^.ln_name:=@psn^.st[1];
                        if pgn^.kind=mx_kind then
                          psn^.st:='New Button'#0
                         else
                          psn^.st:='New Option'#0;
                        insert_(@pgn^.editwindow^.editlist,pnode(psn),
                                getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        inc(pgn^.editwindow^.data2);
                        
                        {set new}
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                               gtst_string,long(psn^.ln_name));
                      end
                     else
                      telluser(pdwn^.editwindow,memerror);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            10: if inputmode=0 then
                  begin
                    {move item up list}
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    if pnode(psn)<>pgn^.editwindow^.editlist.lh_head then
                      begin
                        dec(pgn^.editwindow^.data2);
                        psn2:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn2));
                        insert_(@pgn^.editwindow^.editlist,pnode(psn2),pnode(psn)); 
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                          gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            11: if inputmode=0 then
                  begin
                    dummy:=0;
                    psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                    while (psn^.ln_succ<>nil) do
                      begin
                        inc(dummy);
                        psn:=psn^.ln_succ;
                      end;
                    if dummy>1 then
                      begin
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                               gtlv_labels,~0);
                        { delete one }
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn));
                        freemymem(psn,sizeof(tstringnode));
                        if pgn^.editwindow^.data2<>0 then
                          dec(pgn^.editwindow^.data2);
                        {set new}
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                               gtst_string,long(psn^.ln_name));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                               gtlv_labels,long(@pgn^.editwindow^.editlist));
                      end;
                    dummy:=0;
                  end;
            12: if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    pgn^.editwindow^.data2:=code;
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                           gtst_string,long(psn^.ln_name));
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            13: if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                  end;
            14: if inputmode=0 then
                  begin
                    {move item down list}
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    if psn^.ln_succ^.ln_succ<>nil then
                      begin
                        inc(pgn^.editwindow^.data2);
                        psn2:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn));
                        insert_(@pgn^.editwindow^.editlist,pnode(psn),pnode(psn2)); 
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                          gtlv_labels,long(@pgn^.editwindow^.editlist));
                  end;
           end;
          case dummy of
            173 : begin
                  pgn^.tags[5].ti_data:=
                    long(checkedbox(pgn^.editwindow^.gads[4]));
                  pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                  if pgn^.kind=mx_kind then
                    begin
                      case pgn^.editwindow^.data of
                        0: pgn^.flags:=placetext_left;
                        1: pgn^.flags:=placetext_right;
                       end;
                      case pgn^.editwindow^.data4 of
                        0: pgn^.tags[7].ti_data:=placetext_above;
                        1: pgn^.tags[7].ti_data:=placetext_below;
                        2: pgn^.tags[7].ti_data:=placetext_left;
                        3: pgn^.tags[7].ti_data:=placetext_right;
                       end;
                    end
                   else
                    case pgn^.editwindow^.data of
                      0: pgn^.flags:=placetext_above;
                      1: pgn^.flags:=placetext_below;
                      2: pgn^.flags:=placetext_left;
                      3: pgn^.flags:=placetext_right;
                     end;
                  pgn^.tags[6].ti_data:=long(checkedbox(pgn^.editwindow^.gads[16]));
                  if pgn^.kind=mx_kind then
                    pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[3]);
                  pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[15]);
                  pgn^.tags[1].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                  psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                  psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                  copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                  pgn^.fontname:=pgn^.editwindow^.tfontname;
                  checkgadsize(pdwn,pgn);
                  freelist(@pgn^.infolist,sizeof(tstringnode));
                  psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                  while (psn^.ln_succ<>nil) do
                    begin
                      psn2:=psn^.ln_succ;
                      remove(pnode(psn));
                      addtail(@pgn^.infolist,pnode(psn));
                      psn:=psn2;
                    end;
                  pgn^.justcreated:=false;
                  closeeditgadget(pdwn,pgn);
                  updateeditwindow:=true;
                  inputmode:=1;
                end;
            174 : closeeditgadget(pdwn,pgn);
            6 : pgn^.editwindow^.data:=code;
            175 : gadgetfont(pdwn,pgn);
           end;
      end;
                
    {*********************************}
    {*                               *}
    {*     Listview Edit Handling    *}
    {*                               *}
    {*********************************}
                      
    listview_kind : 
      begin
        if (class=idcmp_closewindow) and
           (inputmode=0) then
          closeeditgadget(pdwn,pgn);
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if class=idcmp_vanillakey then
          case chr(code) of
            'O','o' : if inputmode=0 then
                        dummy:=173;
            'F','f' : if inputmode=0 then
                           dummy:=175;
            'C','c' : if inputmode=0 then
                           dummy:=174;
            'L','l' : if inputmode=0 then
                           if activategadget(pgn^.editwindow^.gads[7],
                                             pgn^.editwindow^.pwin,nil) then;
            'T','t' : if (inputmode=0) then
                        if activategadget(pgn^.editwindow^.gads[15],
                                          pgn^.editwindow^.pwin,nil) then;
            'p','P' : if inputmode=0 then
                        begin
                          if chr(code)='p' then
                            if pgn^.editwindow^.data=3 then
                              pgn^.editwindow^.data:=0
                             else
                              inc(pgn^.editwindow^.data)
                           else
                            if pgn^.editwindow^.data=0 then
                              pgn^.editwindow^.data:=3
                             else
                              dec(pgn^.editwindow^.data);
                          gt_setsinglegadgetattr(pgn^.editwindow^.gads[6],
                                                 pgn^.editwindow^.pwin,
                                                 gtcy_active,
                                                 pgn^.editwindow^.data);
                        end;
           end;
        if class=idcmp_gadgetup then
          case pgsel^.gadgetid of
            173 : if inputmode=0 then
                  dummy:=173;
            174 : if inputmode=0 then
                  dummy:=174;
            6 : pgn^.editwindow^.data:=code;
            175 : if inputmode=0 then
                  dummy:=175;
            9 : if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    { make new one }
                    
                    {get old}
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    
                    psn:=pstringnode(allocmymem(sizeof(tstringnode),memf_any or memf_clear));
                    if psn<>nil then
                      begin
                        psn^.ln_name:=@psn^.st[1];
                        psn^.st:='New Button'#0;
                        insert_(@pgn^.editwindow^.editlist,pnode(psn),
                                getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        inc(pgn^.editwindow^.data2);
                        
                        {set new}
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                               gtst_string,long(psn^.ln_name));
                      end
                     else
                      telluser(pdwn^.editwindow,memerror);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            10: if inputmode=0 then
                  begin
                    {move item up list}
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    if pnode(psn)<>pgn^.editwindow^.editlist.lh_head then
                      begin
                        dec(pgn^.editwindow^.data2);
                        psn2:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn2));
                        insert_(@pgn^.editwindow^.editlist,pnode(psn2),pnode(psn)); 
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                          gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            11: if inputmode=0 then
                  begin
                    dummy:=0;
                    psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                    while (psn^.ln_succ<>nil) do
                      begin
                        inc(dummy);
                        psn:=psn^.ln_succ;
                      end;
                    if dummy>1 then
                      begin
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                               gtlv_labels,~0);
                        { delete one }
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn));
                        freemymem(psn,sizeof(tstringnode));
                        if pgn^.editwindow^.data2<>0 then
                          dec(pgn^.editwindow^.data2);
                        {set new}
                        psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                               gtst_string,long(psn^.ln_name));
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                               gtlv_labels,long(@pgn^.editwindow^.editlist));
                      end;
                    dummy:=0;
                  end;
            12: if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    pgn^.editwindow^.data2:=code;
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[13],pgn^.editwindow^.pwin,
                                           gtst_string,long(psn^.ln_name));
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                    dummy:=0;
                  end;
            13: if inputmode=0 then
                  begin
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,long(@pgn^.editwindow^.editlist));
                  end;
            14: if inputmode=0 then
                  begin
                    {move item down list}
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                           gtlv_labels,~0);
                    psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                    psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                    if psn^.ln_succ^.ln_succ<>nil then
                      begin
                        inc(pgn^.editwindow^.data2);
                        psn2:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                        remove(pnode(psn));
                        insert_(@pgn^.editwindow^.editlist,pnode(psn),pnode(psn2)); 
                      end;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[12],pgn^.editwindow^.pwin,
                                          gtlv_labels,long(@pgn^.editwindow^.editlist));
                  end;
            22: If inputmode=0 then
                  begin
                    pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                    ldone:=false;
                    while(pgn2^.ln_succ<>nil)and(not ldone) do
                      begin
                        if (pgn2^.high) and(pgn2^.kind=string_kind)and 
                           ((pgn2^.joined=false) or (pgn2=pgadgetnode(pgn^.tags[3].ti_data) )) then
                          begin
                            ldone:=true;
                            pgn^.pointers[4]:=pointer(pgn2);
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                   gttx_text,long(@pgn2^.labelid[1])); { gadget id printed }
                            gt_setsinglegadgetattr(pgn^.editwindow^.gads[2],pgn^.editwindow^.pwin,
                                                   gtcb_checked,long(true));
                          end;
                        pgn2:=pgn2^.ln_succ;
                      end;
                  end;
            20,23
              : If inputmode=0 then
                  begin
                    
                    { split }
                    
                    pgn2:=pgadgetnode(pgn^.pointers[4]);
                    if (pgn2<>nil)and(pgsel^.gadgetid=23) or
                      ((pgsel^.gadgetid=20)and(not checkedbox(pgn^.editwindow^.gads[2]))) then
                      begin
                        pgn^.pointers[4]:=nil;
                        gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                               gttx_text,long(@strings[155,8])); {'None' printed}
                      end;
                  end;
                  
           end;
          case dummy of
            173 : begin
                  if pgn^.pointers[4]<>nil then
                    begin
                      pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                      if pgn2<>nil then
                        begin
                          pgn2^.joined:=false;
                          pgn2^.pointers[1]:=nil;
                        end;
                      pgn^.tags[3].ti_data:=long(pgn^.pointers[4]);
                      pgn2:=pgadgetnode(pgn^.pointers[4]);
                      pgn2^.pointers[1]:=pointer(pgn);
                      pgn2^.joined:=true;
                      pgn2^.w:=pgn^.w;
                      pgn^.high:=true;
                      pgn2^.high:=true;
                      remove(pnode(pgn2));
                      insert_(@pdwn^.gadgetlist,pnode(pgn2),pnode(pgn));
                      remove(pnode(pgn));
                      insert_(@pdwn^.gadgetlist,pnode(pgn),pnode(pgn2));
                      pdwn^.gadselected:=~0;
                    end
                   else
                    begin
                      pgn^.high:=true;
                      pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                      if pgn2<>nil then
                        begin
                          pgn2^.joined:=false;
                          pgn2^.pointers[1]:=nil;
                        end;
                      pgn^.tags[3].ti_data:=0;
                    end;
                  pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                  pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[15]);
                  pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[18]);
                  pgn^.tags[5].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                  pgn^.tags[4].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[17]);
                  pgn^.tags[6].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[3]);
                  pgn^.edithook:=getstringfromgad(pgn^.editwindow^.gads[11]);
                  if checkedbox(pgn^.editwindow^.gads[2]) then
                    pgn^.tags[3].ti_tag:=gtlv_showselected
                   else
                    pgn^.tags[3].ti_tag:=tag_ignore;
                  pgn^.tags[9].ti_data:=
                    long(checkedbox(pgn^.editwindow^.gads[4]));
                  pgn^.tags[8].ti_data:=
                    long(checkedbox(pgn^.editwindow^.gads[16]));
                  pgn^.tags[10].ti_data:=
                    long(checkedbox(pgn^.editwindow^.gads[1]));
                  pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[7]);
                  case pgn^.editwindow^.data of
                    0: pgn^.flags:=placetext_above;
                    1: pgn^.flags:=placetext_below;
                    2: pgn^.flags:=placetext_left;
                    3: pgn^.flags:=placetext_right;
                   end;
                  psn:=pstringnode(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data2));
                  psn^.st:=getstringfromgad(pgn^.editwindow^.gads[13]);
                  copymem(@pgn^.editwindow^.tfont,@pgn^.font,sizeof(ttextattr));
                  pgn^.fontname:=pgn^.editwindow^.tfontname;
                  checkgadsize(pdwn,pgn);
                  freelist(@pgn^.infolist,sizeof(tstringnode));
                  psn:=pstringnode(pgn^.editwindow^.editlist.lh_head);
                  while (psn^.ln_succ<>nil) do
                    begin
                      psn2:=psn^.ln_succ;
                      remove(pnode(psn));
                      addtail(@pgn^.infolist,pnode(psn));
                      psn:=psn2;
                    end;
                  pgn^.justcreated:=false;
                  closeeditgadget(pdwn,pgn);
                  updateeditwindow:=true;
                  inputmode:=1;
                end;
            174 : closeeditgadget(pdwn,pgn);
            6 : pgn^.editwindow^.data:=code;
            175 : gadgetfont(pdwn,pgn);
           end;
      end;
    
    {*********************************}
    {*                               *}
    {*      MyBool Edit Handling     *}
    {*                               *}
    {*********************************}
                      
    mybool_kind : 
      begin
        dummy:=0;
        if (menunumber=gadgopts) and (inputmode=0) and (itemnumber=gadgoptsok) and (class=idcmp_menupick) then
          dummy:=173;
        if (class=idcmp_closewindow) then
          dummy:=174;
        if class=idcmp_vanillakey then
          case upcase(chr(code)) of
            'C' : if inputmode=0 then
                    dummy:=174;
            'F' : if inputmode=0 then
                    dummy:=175;
            'O' : if inputmode=0 then
                    dummy:=173;
           end;
        if class=idcmp_gadgetup then
          dummy:=pgsel^.gadgetid;
        case dummy of
          8   : pgn^.editwindow^.data2:=code;
          9   : pgn^.editwindow^.data3:=code;
          16  : begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(true));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[19],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                end;
          17  : begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(true));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[19],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                end;
          18  : begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(true));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[19],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                end;
          19  : begin
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[16],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[17],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[18],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(false));
                  gt_setsinglegadgetattr(pgn^.editwindow^.gads[19],pgn^.editwindow^.pwin,
                                         gtcb_checked,long(true));
                end;
          20  : pgn^.tags[4].ti_data:=code;
          21  : pgn^.tags[15].ti_data:=code;
          173  : if inputmode=0 then
                  begin
                    updateeditwindow:=true;
                    pgn^.tags[3].ti_tag:=pgn^.tags[4].ti_data;
                    pgn^.tags[3].ti_data:=pgn^.tags[15].ti_data;
                    pgn^.flags:=0;
                    if checkedbox(pgn^.editwindow^.gads[16]) then
                      pgn^.flags:=pgn^.flags or gflg_gadghnone;
                    if checkedbox(pgn^.editwindow^.gads[17]) then
                      pgn^.flags:=pgn^.flags or gflg_gadghcomp;
                    if checkedbox(pgn^.editwindow^.gads[18]) then
                      pgn^.flags:=pgn^.flags or gflg_gadghbox;
                    if checkedbox(pgn^.editwindow^.gads[19]) then
                      pgn^.flags:=pgn^.flags or gflg_gadghimage;
                    if checkedbox(pgn^.editwindow^.gads[14]) then
                      pgn^.flags:=pgn^.flags or gflg_selected;
                    if checkedbox(pgn^.editwindow^.gads[15]) then
                      pgn^.flags:=pgn^.flags or gflg_disabled;
                    case pgn^.editwindow^.data of
                      0: pgn^.tags[4].ti_tag:=jam1;
                      1: pgn^.tags[4].ti_tag:=jam2;
                      2: pgn^.tags[4].ti_tag:=complement;
                     end;
                    if checkedbox(pgn^.editwindow^.gads[6]) then
                      pgn^.tags[4].ti_tag:=pgn^.tags[4].ti_tag or inversvid;
                    pgn^.labelid:=getstringfromgad(pgn^.editwindow^.gads[0]);
                    pgn^.title:=getstringfromgad(pgn^.editwindow^.gads[3]);
                    pgn^.w:=getintegerfromgad(pgn^.editwindow^.gads[1]);
                    pgn^.h:=getintegerfromgad(pgn^.editwindow^.gads[2]);
                    pgn^.tags[2].ti_tag :=getintegerfromgad(pgn^.editwindow^.gads[4]);
                    pgn^.tags[2].ti_data:=getintegerfromgad(pgn^.editwindow^.gads[5]);
                    pgn^.tags[1].ti_data:=long(checkedbox(pgn^.editwindow^.gads[7]));
                    pgn^.tags[1].ti_tag:=0;
                    if checkedbox(pgn^.editwindow^.gads[10]) then
                      pgn^.tags[1].ti_tag:=pgn^.tags[1].ti_tag or gact_toggleselect;
                    if checkedbox(pgn^.editwindow^.gads[11]) then
                      pgn^.tags[1].ti_tag:=pgn^.tags[1].ti_tag or gact_immediate;
                    if checkedbox(pgn^.editwindow^.gads[12]) then
                      pgn^.tags[1].ti_tag:=pgn^.tags[1].ti_tag or gact_relverify;
                    if checkedbox(pgn^.editwindow^.gads[13]) then
                      pgn^.tags[1].ti_tag:=pgn^.tags[1].ti_tag or gact_followmouse;
                    if pgn^.editwindow^.data2<>~0 then
                      begin
                        pgn^.pointers[1]:=pointer(getnthnode(@teditimagelist, pgn^.editwindow^.data2));
                      end
                     else
                      pgn^.pointers[1]:=nil;
                    if pgn^.editwindow^.data3<>~0 then
                      begin
                        pgn^.pointers[2]:=pointer(getnthnode(@teditimagelist, pgn^.editwindow^.data3));
                      end
                     else
                      pgn^.pointers[2]:=nil;
                    pgn^.justcreated:=false;
                    closeeditgadget(pdwn,pgn);
                  end;
          174  : if inputmode=0 then
                  closeeditgadget(pdwn,pgn);
          175  : gadgetfont(pdwn,pgn);
          25  : if inputmode=0 then
                  begin
                    pgn^.editwindow^.data2:=~0;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                           gtlv_selected,~0);
                  end;
          26  : if inputmode=0 then
                  begin
                    pgn^.editwindow^.data3:=~0;
                    gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                           gtlv_selected,~0);
                  end;
          27  : pgn^.editwindow^.data:=code;
         end;
      end;
    
    {**** end of case ***}
   end;
end;

procedure setmenueditwindowsubitem(pdmn:pdesignermenunode;pmin:pmenuitemnode;pmsi:pmenusubitemnode);
var
  loop : word;
  dummy,dummy2:long;
  pin : pimagenode;
begin
  if pmsi<>nil then
    begin
      {enable all}
      for loop:=24 to 40 do
        if (loop<>26) and(loop<>39)and(loop<>31) then
          gt_setsinglegadgetattr(pdmn^.gads[loop],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[53],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[54],pdmn^.editwindow,ga_disabled,long(false));
      { set all }
      gt_setsinglegadgetattr(pdmn^.gads[40],pdmn^.editwindow,gtcb_checked,long(pmsi^.barlabel));
      gt_setsinglegadgetattr(pdmn^.gads[33],pdmn^.editwindow,gtst_string,long(@pmsi^.commkey[1]));
      gt_setsinglegadgetattr(pdmn^.gads[34],pdmn^.editwindow,gtcb_checked,long(pmsi^.disabled));
      gt_setsinglegadgetattr(pdmn^.gads[35],pdmn^.editwindow,gtcb_checked,long(pmsi^.checkit));
      gt_setsinglegadgetattr(pdmn^.gads[36],pdmn^.editwindow,gtcb_checked,long(pmsi^.menutoggle));
      gt_setsinglegadgetattr(pdmn^.gads[37],pdmn^.editwindow,gtcb_checked,long(pmsi^.checked));
      gt_setsinglegadgetattr(pdmn^.gads[38],pdmn^.editwindow,gtst_string,long(@pmsi^.idlabel[1]));
      gt_setsinglegadgetattr(pdmn^.gads[30],pdmn^.editwindow,gtcb_checked,long(pmsi^.textprint));
      gt_setsinglegadgetattr(pdmn^.gads[25],pdmn^.editwindow,gtst_string,long(@pmsi^.text[1]));
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,long(@pmin^.tsubitems));
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_selected,getlistpos(@pmin^.tsubitems,pnode(pmsi)));
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_top,getlistpos(@pmin^.tsubitems,pnode(pmsi)));
      pdmn^.subitemselected:=(getlistpos(@pmin^.tsubitems,pnode(pmsi)));
      gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_labels,long(@teditimagelist));
      if pmsi^.graphic<>nil then
        begin
          dummy2:=~0;
          dummy:=0;
          pin:=pimagenode(teditimagelist.lh_head);
          while(pin^.ln_succ<>nil)do
            begin
              if pin=pmsi^.graphic then
                dummy2:=dummy;
              inc(dummy);
              pin:=pin^.ln_succ;
            end;
          if dummy2=~0 then pmsi^.graphic:=nil;
          gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_selected,dummy2);
          if dummy2<>~0 then
            gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_top,dummy2);
        end
       else
        begin
          gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_selected,~0);
        end;
    end
   else
    begin
      pdmn^.subitemselected:=~0;
      {disable all}
      for loop:=24 to 40 do
        if (loop<>26) and(loop<>39)and(loop<>31) then
          gt_setsinglegadgetattr(pdmn^.gads[loop],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[53],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[54],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,0);
      gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_labels,0);
    end;
end;

procedure setmenueditwindowitem(pdmn:pdesignermenunode;pmtn:pmenutitlenode;pmin:pmenuitemnode);
var
  loop : word;
  pin  : pimagenode;
  dummy,dummy2: long;
begin
  if pmin<>nil then
    begin
      {enable all}
      for loop:=9 to 23 do
        if (loop<>11)and(loop<>16) then
          gt_setsinglegadgetattr(pdmn^.gads[loop],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[39],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[26],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[51],pdmn^.editwindow,ga_disabled,long(false));
      gt_setsinglegadgetattr(pdmn^.gads[52],pdmn^.editwindow,ga_disabled,long(false));
      { set all }
      gt_setsinglegadgetattr(pdmn^.gads[39],pdmn^.editwindow,gtcb_checked,long(pmin^.barlabel));
      gt_setsinglegadgetattr(pdmn^.gads[18],pdmn^.editwindow,gtst_string,long(@pmin^.commkey[1]));
      gt_setsinglegadgetattr(pdmn^.gads[19],pdmn^.editwindow,gtcb_checked,long(pmin^.disabled));
      gt_setsinglegadgetattr(pdmn^.gads[20],pdmn^.editwindow,gtcb_checked,long(pmin^.checkit));
      gt_setsinglegadgetattr(pdmn^.gads[21],pdmn^.editwindow,gtcb_checked,long(pmin^.menutoggle));
      gt_setsinglegadgetattr(pdmn^.gads[22],pdmn^.editwindow,gtcb_checked,long(pmin^.checked));
      gt_setsinglegadgetattr(pdmn^.gads[23],pdmn^.editwindow,gtst_string,long(@pmin^.idlabel[1]));
      gt_setsinglegadgetattr(pdmn^.gads[15],pdmn^.editwindow,gtcb_checked,long(pmin^.textprint));
      gt_setsinglegadgetattr(pdmn^.gads[10],pdmn^.editwindow,gtst_string,long(@pmin^.text[1]));
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,long(@pmtn^.titemlist));
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_selected,getlistpos(@pmtn^.titemlist,pnode(pmin)));
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_top,getlistpos(@pmtn^.titemlist,pnode(pmin)));
      
      gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_labels,long(@teditimagelist));
      if pmin^.graphic<>nil then
        begin
          dummy2:=~0;
          dummy:=0;
          pin:=pimagenode(teditimagelist.lh_head);
          while(pin^.ln_succ<>nil)do
            begin
              if pin=pmin^.graphic then
                dummy2:=dummy;
              inc(dummy);
              pin:=pin^.ln_succ;
            end;
          if dummy2=~0 then pmin^.graphic:=nil;
          gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_selected,dummy2);
          if dummy2<>~0 then
            gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_top,dummy2);
        end
       else
        begin
          gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_selected,~0);
        end;
      
      pdmn^.itemselected:=getlistpos(@pmtn^.titemlist,pnode(pmin));
      if sizeoflist(@pmin^.tsubitems)=0 then
        setmenueditwindowsubitem(pdmn,nil,nil)
       else
        setmenueditwindowsubitem(pdmn,pmin,pmenusubitemnode(pmin^.tsubitems.lh_head));
    end
   else
    begin
      {disable all}
      pdmn^.itemselected:=~0;
      for loop:=9 to 23 do
        if (loop<>11)and(loop<>16) then
          gt_setsinglegadgetattr(pdmn^.gads[loop],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[39],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[26],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[51],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[52],pdmn^.editwindow,ga_disabled,long(true));
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,0);
      gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_labels,0);
      setmenueditwindowsubitem(pdmn,nil,nil);
    end;
end;

procedure setmenueditwindowtitle(pdmn:pdesignermenunode;pmtn:pmenutitlenode);
begin
  if sizeoflist(@pmtn^.titemlist)>0 then
    setmenueditwindowitem(pdmn,pmtn,pmenuitemnode(pmtn^.titemlist.lh_head))
   else
    setmenueditwindowitem(pdmn,pmtn,nil);
  gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,long(@pdmn^.tmenulist));
  gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_selected,getlistpos(@pdmn^.tmenulist,pnode(pmtn)));
  gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_top,getlistpos(@pdmn^.tmenulist,pnode(pmtn)));
  gt_setsinglegadgetattr(pdmn^.gads[7],pdmn^.editwindow,gtcb_checked,long(pmtn^.disabled));
  gt_setsinglegadgetattr(pdmn^.gads[8],pdmn^.editwindow,gtst_string,long(@pmtn^.idlabel[1]));
  gt_setsinglegadgetattr(pdmn^.gads[2],pdmn^.editwindow,gtst_string,long(@pmtn^.text[1]));  
  pdmn^.titleselected:=getlistpos(@pdmn^.tmenulist,pnode(pmtn));
end;

procedure readsubitem(pdmn:pdesignermenunode);
var
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
  pmsi : pmenusubitemnode;
begin
  if pdmn^.subitemselected<>~0 then
    begin
      pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
      pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
      pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
      pmsi^.textprint:=checkedbox(pdmn^.gads[30]);
      pmsi^.barlabel:=checkedbox(pdmn^.gads[40]);
      pmsi^.disabled:=checkedbox(pdmn^.gads[34]);
      pmsi^.checkit:=checkedbox(pdmn^.gads[35]);
      pmsi^.menutoggle:=checkedbox(pdmn^.gads[36]);
      pmsi^.checked:=checkedbox(pdmn^.gads[37]);
      pmsi^.commkey:=getstringfromgad(pdmn^.gads[33]);
      pmsi^.idlabel:=getstringfromgad(pdmn^.gads[38]);
      pmsi^.text:=getstringfromgad(pdmn^.gads[25]);
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,~0);
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,long(@pmin^.tsubitems));
      gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_selected,pdmn^.subitemselected);
    end;
end;

procedure readitem(pdmn:pdesignermenunode);
var
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
begin
  if pdmn^.itemselected<>~0 then
    begin
      pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
      pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
      pmin^.textprint:=checkedbox(pdmn^.gads[15]);
      pmin^.barlabel:=checkedbox(pdmn^.gads[39]);
      pmin^.disabled:=checkedbox(pdmn^.gads[19]);
      pmin^.checkit:=checkedbox(pdmn^.gads[20]);
      pmin^.menutoggle:=checkedbox(pdmn^.gads[21]);
      pmin^.checked:=checkedbox(pdmn^.gads[22]);
      pmin^.commkey:=getstringfromgad(pdmn^.gads[18]);
      pmin^.idlabel:=getstringfromgad(pdmn^.gads[23]);
      pmin^.text:=getstringfromgad(pdmn^.gads[10]);
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,~0);
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,long(@pmtn^.titemlist));
      gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_selected,pdmn^.itemselected);
    end;
end;

procedure readtitle(pdmn:pdesignermenunode);
var
  pmtn : pmenutitlenode;
begin
  if pdmn^.titleselected<>~0 then
    begin
      pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
      pmtn^.text:=getstringfromgad(pdmn^.gads[2]);
      gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,~0);
      gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,long(@pdmn^.tmenulist));
      gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_selected,pdmn^.titleselected);
      pmtn^.disabled:=checkedbox(pdmn^.gads[7]);
      pmtn^.idlabel:=getstringfromgad(pdmn^.gads[8]);
      pdmn^.idlabel:=getstringfromgad(pdmn^.gads[45]);
    end;
end;

procedure editmenuhandling(messcopy : tintuimessage);
const
  diffmenu : string[36]='Difficulty reading menu structure.';
var
  pgsel : pgadget;
  class : long;
  code  : word;
  dummy : long;
  pdmn  : pdesignermenunode;
  pmtn  : pmenutitlenode;
  pmin  : pmenuitemnode;
  pmtn2 : pmenutitlenode;
  pmin2 : pmenuitemnode;
  pmsi  : pmenusubitemnode;
  pmsi2 : pmenusubitemnode;
  tags  : array[1..10] of ttagitem;
  wmenu : pmenu;
  witem : pmenuitem;
  pfr   : pfontrequester;
  loop  : word;
  st    : string;
  updatemenu : boolean;
  updatemenuanyway : boolean;
  mask     : long;
  oldlong  : long;
begin
  updatemenuanyway :=false;
  updatemenu:=false;
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdmn:=pdesignermenunode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  if class=idcmp_gadgetup then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_closewindow then
    dummy:=50;
  if class=idcmp_vanillakey then
    case upcase(chr(code)) of
      'H' : dummy:=46;
      'F' : dummy:=42;
      'T' : dummy:=44;
     end;
  case dummy of
    1,2,3,7,8,9,10,11,17,18,39,19,20,21,22,24,25,26,29,32,33,40,34,35,36,37,38,50,44,45 : 
      begin
        readsubitem(pdmn);
        readitem(pdmn);
        readtitle(pdmn);
      end;
   end;
  case dummy of
    2,3,4,5,6,7,10,11,12,13,15,17,18,39,19,20,21,22,26,27,28,29,52,25,29,30,32,33,40,34,35,36,37,54,41,42,43,44,55 :
     updatemenu:=true;
   end;
  case dummy of
    29,14,6 : updatemenuanyway:=true;
   end;
  case dummy of
    1 : if (inputmode=0)and(code<>pdmn^.titleselected) then
          setmenueditwindowtitle(pdmn,pmenutitlenode(getnthnode(@pdmn^.tmenulist,code)));
    3 : if (inputmode=0)and(sizeoflist(@pdmn^.tmenulist)<31) then
          begin
            pmtn:=createnewmenutitle(sizeoflist(@pdmn^.tmenulist),pdmn);
            if pmtn<>nil then
              begin
                addtail(@pdmn^.tmenulist,pnode(pmtn));
                setmenueditwindowtitle(pdmn,pmtn);
              end;
          end;
    4 : if (inputmode=0)and(pdmn^.titleselected>0) then
          begin
            gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,~0);
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected-1));
            pmtn2:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            remove(pnode(pmtn));
            insert_(@pdmn^.tmenulist,pnode(pmtn),pnode(pmtn2));
            dec(pdmn^.titleselected);
            gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,long(@pdmn^.tmenulist));
          end;
    5 : if (inputmode=0) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            if pmtn^.ln_succ^.ln_succ<>nil then
              begin
                gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,~0);
                pmtn2:=pmtn^.ln_succ;
                remove(pnode(pmtn));
                insert_(@pdmn^.tmenulist,pnode(pmtn),pnode(pmtn2));
                inc(pdmn^.titleselected);
                gt_setsinglegadgetattr(pdmn^.gads[1],pdmn^.editwindow,gtlv_labels,long(@pdmn^.tmenulist));
              end;
          end;
    6 : if (inputmode=0)and(sizeoflist(@pdmn^.tmenulist)>1) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            remove(pnode(pmtn));
            pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
            while(pmin^.ln_succ<>nil) do
              begin
                freelist(@pmin^.tsubitems,sizeof(tmenusubitemnode));
                pmin:=pmin^.ln_succ;
              end;
            freelist(@pmtn^.titemlist,sizeof(tmenuitemnode));
            freemymem(pmtn,sizeof(tmenutitlenode));
            if pdmn^.titleselected>0 then
              dec(pdmn^.titleselected);
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            setmenueditwindowtitle(pdmn,pmtn);
          end;
    9 : if (inputmode=0)and(code<>pdmn^.itemselected) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,code));
            setmenueditwindowitem(pdmn,pmtn,pmin);
          end;
    11: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            if sizeoflist(@pmtn^.titemlist)<63 then
              begin
                pmin:=createnewmenuitemnode(sizeoflist(@pmtn^.titemlist),pmtn);
                if pmin<>nil then
                  begin
                    addtail(@pmtn^.titemlist,pnode(pmin));
                    setmenueditwindowitem(pdmn,pmtn,pmin);
                  end;
              end;
          end;
    12: if (inputmode=0)and(pdmn^.itemselected>0) then
          begin
            gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,~0);
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected-1));
            pmin2:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            remove(pnode(pmin));
            insert_(@pmtn^.titemlist,pnode(pmin),pnode(pmin2));
            dec(pdmn^.itemselected);
            gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,long(@pmtn^.titemlist));
            
            pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
            while(pmin^.ln_succ<>nil) do
              begin
                mask:=( 1 shl pdmn^.itemselected)or( 1 shl (pdmn^.itemselected+1));
                oldlong:=pmin^.exclude;
                pmin^.exclude:=~mask and pmin^.exclude;
                if (oldlong and ( 1 shl pdmn^.itemselected))<>0 then
                  pmin^.exclude:=pmin^.exclude or ( 1 shl (pdmn^.itemselected+1));
                if (oldlong and ( 1 shl (pdmn^.itemselected+1)))<>0 then
                  pmin^.exclude:=pmin^.exclude or ( 1 shl pdmn^.itemselected);
                pmin:=pmin^.ln_succ;
              end;
            
          end;
    13: if (inputmode=0) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            if pmin^.ln_succ^.ln_succ<>nil then
              begin
                gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,~0);
                pmin2:=pmin^.ln_succ;
                remove(pnode(pmin));
                insert_(@pmtn^.titemlist,pnode(pmin),pnode(pmin2));
                inc(pdmn^.itemselected);
                gt_setsinglegadgetattr(pdmn^.gads[9],pdmn^.editwindow,gtlv_labels,long(@pmtn^.titemlist));
                
                pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
                while(pmin^.ln_succ<>nil) do
                  begin
                    mask:=( 1 shl pdmn^.itemselected)or( 1 shl (pdmn^.itemselected-1));
                    oldlong:=pmin^.exclude;
                    pmin^.exclude:=~mask and pmin^.exclude;
                    if (oldlong and ( 1 shl pdmn^.itemselected))<>0 then
                      pmin^.exclude:=pmin^.exclude or ( 1 shl (pdmn^.itemselected-1));
                    if (oldlong and ( 1 shl (pdmn^.itemselected-1)))<>0 then
                      pmin^.exclude:=pmin^.exclude or ( 1 shl pdmn^.itemselected);
                    pmin:=pmin^.ln_succ;
                  end;
                
              end;
          end;
    14: if (inputmode=0)and(pdmn^.itemselected<>~0) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(pmtn^.titemlist.lh_head);
            while(pmin^.ln_succ<>nil) do
              begin
                pmin^.exclude:=(pmin^.exclude and ~($FFFFFFFF shl (pdmn^.itemselected))) or
                               ((pmin^.exclude and ($FFFFFFFF shl (pdmn^.itemselected+1))) shr 1);
                pmin:=pmin^.ln_succ;
              end;
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            remove(pnode(pmin));
            freelist(@pmin^.tsubitems,sizeof(tmenusubitemnode));
            freemymem(pmin,sizeof(tmenuitemnode));
            if sizeoflist(@pmtn^.titemlist)>0 then
              begin
                if pdmn^.itemselected>0 then
                  dec(pdmn^.itemselected);
                pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
              end
             else
              pmin:=nil;
            setmenueditwindowitem(pdmn,pmtn,pmin);
          end;
    15: if checkedbox(pdmn^.gads[15]) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmin^.graphic:=nil;
            gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,gtlv_selected,~0);
          end
         else
          gt_setsinglegadgetattr(pdmn^.gads[15],pdmn^.editwindow,gtcb_checked,long(true));
    17: if (inputmode=0)and(pdmn^.itemselected<>~0) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmin^.graphic:=pimagenode(getnthnode(@teditimagelist,code));
            gt_setsinglegadgetattr(pdmn^.gads[15],pdmn^.editwindow,gtcb_checked,long(false));
          end;
    24: if (inputmode=0)and(code<>pdmn^.subitemselected) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,code));
            setmenueditwindowsubitem(pdmn,pmin,pmsi);
          end;
    26: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            if sizeoflist(@pmin^.tsubitems)<31 then
              begin
                pmsi:=createnewmenusubitemnode(sizeoflist(@pmin^.tsubitems),pmin);
                if pmsi<>nil then
                  begin
                    addtail(@pmin^.tsubitems,pnode(pmsi));
                    setmenueditwindowsubitem(pdmn,pmin,pmsi);
                  end;
              end;
          end;
    27: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi2:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            if pdmn^.subitemselected>0 then
              begin
                gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,~0);
                pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected-1));
                remove(pnode(pmsi));
                insert_(@pmin^.tsubitems,pnode(pmsi),pnode(pmsi2));
                dec(pdmn^.subitemselected);
                gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,long(@pmin^.tsubitems));
                
                pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
                while(pmsi^.ln_succ<>nil) do
                  begin
                    mask:=( 1 shl pdmn^.subitemselected)or( 1 shl (pdmn^.subitemselected+1));
                    oldlong:=pmsi^.exclude;
                    pmsi^.exclude:=~mask and pmsi^.exclude;
                    if (oldlong and ( 1 shl pdmn^.subitemselected))<>0 then
                      pmsi^.exclude:=pmsi^.exclude or ( 1 shl (pdmn^.subitemselected+1));
                    if (oldlong and ( 1 shl (pdmn^.subitemselected+1)))<>0 then
                      pmsi^.exclude:=pmsi^.exclude or ( 1 shl pdmn^.subitemselected);
                    pmsi:=pmsi^.ln_succ;
                  end;
                
              end;
          end;
    28: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            if pmsi^.ln_succ^.ln_succ<>nil then
              begin
                gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,~0);
                pmsi2:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected+1));
                remove(pnode(pmsi));
                insert_(@pmin^.tsubitems,pnode(pmsi),pnode(pmsi2));
                inc(pdmn^.subitemselected);
                gt_setsinglegadgetattr(pdmn^.gads[24],pdmn^.editwindow,gtlv_labels,long(@pmin^.tsubitems));
                
                pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
                while(pmsi^.ln_succ<>nil) do
                  begin
                    mask:=( 1 shl pdmn^.subitemselected)or( 1 shl (pdmn^.subitemselected-1));
                    oldlong:=pmsi^.exclude;
                    pmsi^.exclude:=~mask and pmsi^.exclude;
                    if (oldlong and ( 1 shl pdmn^.subitemselected))<>0 then
                      pmsi^.exclude:=pmsi^.exclude or ( 1 shl (pdmn^.subitemselected-1));
                    if (oldlong and ( 1 shl (pdmn^.subitemselected-1)))<>0 then
                      pmsi^.exclude:=pmsi^.exclude or ( 1 shl pdmn^.subitemselected);
                    pmsi:=pmsi^.ln_succ;
                  end;
                
              end;
          end;
    29: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            if pdmn^.subitemselected<>~0 then
              begin
                pmsi:=pmenusubitemnode(pmin^.tsubitems.lh_head);
                while(pmsi^.ln_succ<>nil) do
                  begin
                    pmsi^.exclude:=(pmsi^.exclude and ~($FFFFFFFF shl (pdmn^.subitemselected))) or
                                   ((pmsi^.exclude and ($FFFFFFFF shl (pdmn^.subitemselected+1))) shr 1);
                    pmsi:=pmsi^.ln_succ;
                  end;
                pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
                remove(pnode(pmsi));
                freemymem(pmsi,sizeof(tmenusubitemnode));
                if sizeoflist(@pmin^.tsubitems)>0 then
                  begin
                    if pdmn^.subitemselected>0 then
                      dec(pdmn^.subitemselected);
                    setmenueditwindowsubitem(pdmn,pmin,pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected)));
                  end
                 else
                  setmenueditwindowsubitem(pdmn,pmin,nil);
              end;
          end;
    30: if checkedbox(pdmn^.gads[30]) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            pmsi^.graphic:=nil;
            gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,gtlv_selected,~0);
          end
         else
          gt_setsinglegadgetattr(pdmn^.gads[30],pdmn^.editwindow,gtcb_checked,long(true));
    32: if (inputmode=0)and(pdmn^.subitemselected<>~0) then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            pmsi^.graphic:=pimagenode(getnthnode(@teditimagelist,code));
            gt_setsinglegadgetattr(pdmn^.gads[30],pdmn^.editwindow,gtcb_checked,long(false));
          end;
    41: pdmn^.frontpen:=code;
    42: if inputmode=0 then
          begin
            waiteverything;
            settagitem(@tags[1],asl_window,long(pdmn^.editwindow));
            settagitem(@tags[2],asl_fontname,long(@pdmn^.fontname[1]));
            settagitem(@tags[3],asl_fontheight,long(pdmn^.font.ta_ysize));
            settagitem(@tags[4],asl_fontstyles,long(pdmn^.font.ta_style));
            settagitem(@tags[5],asl_fontflags,long(pdmn^.font.ta_flags));
            settagitem(@tags[6],tag_done,0);
            inputmode:=1;
            if (aslrequest(fontrequest,@tags[1])) then
              begin
                pfr:=pfontrequester(fontrequest);
                ctopas(pfr^.fo_attr.ta_name^,st);
                if length(st)>44 then 
                  st:=copy(st,1,44);
                pdmn^.fontname:=st+#0;
                pdmn^.font.ta_ysize:=pfr^.fo_attr.ta_ysize;
                pdmn^.font.ta_style:=pfr^.fo_attr.ta_style;
                pdmn^.font.ta_flags:=pfr^.fo_attr.ta_flags;
                gt_setsinglegadgetattr(pdmn^.gads[43],pdmn^.editwindow,gtcb_checked,long(false));
                pdmn^.defaultfont:=false;
                updatemenu:=true;
              end;
            unwaiteverything;
          end;
    43: pdmn^.defaultfont:=checkedbox(pdmn^.gads[43]);
    46: if inputmode=0 then
          helpwindow(@defaulthelpwindownode,menuhelp);
    50: if inputmode=0 then
          closeeditmenuwindow(pdmn);
    52: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmin^.exclude:=0;
          end;
    51: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            if (pdmn^.testmenu<>nil) then
              begin
                loop:=pdmn^.titleselected;
                wmenu:=pdmn^.testmenu;
                while(loop>0)do
                  begin
                    if wmenu<>nil then
                      wmenu:=wmenu^.nextmenu;
                    dec(loop);
                  end;
                if wmenu<>nil then
                  begin
                    pmin^.exclude:=0;
                    witem:=wmenu^.firstitem;
                    loop:=0;
                    while(witem<>nil)and(loop<32) do
                      begin
                        if (loop<>pdmn^.itemselected)and((witem^.flags and (checkit or checked))=(checkit or checked)) then
                          pmin^.exclude:=pmin^.exclude or (1 shl loop);
                        witem:=witem^.nextitem;
                        inc(loop);
                      end;
                  end
                 else
                  telluser(mainwindow,diffmenu);
              end;
          end;
    54: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            pmsi^.exclude:=0;
          end;
    53: if inputmode=0 then
          begin
            pmtn:=pmenutitlenode(getnthnode(@pdmn^.tmenulist,pdmn^.titleselected));
            pmin:=pmenuitemnode(getnthnode(@pmtn^.titemlist,pdmn^.itemselected));
            pmsi:=pmenusubitemnode(getnthnode(@pmin^.tsubitems,pdmn^.subitemselected));
            if (pdmn^.testmenu<>nil) then
              begin
                loop:=pdmn^.titleselected;
                wmenu:=pdmn^.testmenu;
                while(loop>0)do
                  begin
                    if wmenu<>nil then
                      wmenu:=wmenu^.nextmenu;
                    dec(loop);
                  end;
                if wmenu<>nil then
                  begin
                    witem:=wmenu^.firstitem;
                    loop:=pdmn^.itemselected;
                    while(loop>0) do
                      begin
                        if witem<>nil then
                          witem:=witem^.nextitem;
                        dec(loop);
                      end;
                    if witem<>nil then
                      begin
                        pmin^.exclude:=0;
                        witem:=witem^.subitem;
                        loop:=0;
                        while(witem<>nil) and (loop<32) do
                          begin
                            if (loop<>pdmn^.subitemselected)and
                               ((witem^.flags and (checkit or checked))=(checkit or checked)) then
                              pmsi^.exclude:=pmsi^.exclude or (1 shl loop);
                            witem:=witem^.nextitem;
                            inc(loop);
                          end;
                      end
                     else
                      telluser(mainwindow,diffmenu);
                  end
                 else
                  telluser(mainwindow,diffmenu);
              end;
          end;
    55: if pdmn^.newlook39<>checkedbox(pdmn^.gads[55]) then
        begin
          pdmn^.newlook39:=checkedbox(pdmn^.gads[55]);
          closeeditmenuwindow(pdmn);
          openeditmenuwindow(pdmn);
        end;
    177 : pdmn^.localmenu:=checkedbox(pdmn^.localgad);
   end;
  if updatemenu or updatemenuanyway then
    begin
      pdmn^.newlook39:=checkedbox(pdmn^.gads[55]);
      inputmode:=1;
      if prefsvalues[13] or updatemenuanyway then
        begin
          pdmn^.defaultfont:=checkedbox(pdmn^.gads[43]);
          if pdmn^.testmenu<>nil then
            clearmenustrip(pdmn^.editwindow);
          testmenu(pdmn);
        end;
    end;
end;

procedure handlewindowcodewindow(messcopy : tintuimessage);
var
  pgsel : pgadget;
  class : long;
  code  : word;
  itemnumber : word;
  menunumber : word;
  dummy : long;
  pdwn  : pdesignerwindownode;
  tags  : array[1..10] of ttagitem;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  if (class=idcmp_gadgetup)or(class=idcmp_gadgetdown) then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_closewindow then
    dummy:=50;
  if class=idcmp_vanillakey then
    case upcase(chr(code)) of
      'H' : dummy:=23;
      'O' : dummy:=22;
      'C' : dummy:=24;
      'G' : dummy:=47;
     end;
  if class=idcmp_menupick then
    begin
      ItemNumber:=ITEMNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        WinCodeOptions :
          Case ItemNumber of
            WinCodeOptionsHelp :
              dummy:=23;
            WinCodeOptionsok :
              dummy:=22;
            WinCodeOptionscancel :
              dummy:=24;
           end;
       end;
    end;
  case dummy of
    11 : begin
           if not checkedbox(pdwn^.codegadgets[11]) then
             begin
               gt_setsinglegadgetattr(pdwn^.codegadgets[25],pdwn^.codewindow,gtlv_selected,~0);
               pdwn^.codeselected:=~0;
             end;
         end;
    22 : if inputmode=0 then
           begin
             getwindowcodewindowgadgets(pdwn);
             updateeditwindow:=true;
             closewindowcodewindow(pdwn);
           end;
    23 : if inputmode=0 then
           helpwindow(@pdwn^.helpwin,windowcodehelp);
    24 : if inputmode=0 then
           closewindowcodewindow(pdwn);
    25 :  begin
            pdwn^.codeselected:=code;
            gt_setsinglegadgetattr(pdwn^.codegadgets[11],pdwn^.codewindow,gtcb_checked,long(true));
          end;
    47 : if inputmode=0 then
           openeditgadgetlist(pdwn);
    50 : if inputmode=0 then
           closewindowcodewindow(pdwn);
{$ifdef TEST}
    998: if inputmode=0 then
           begin
             pdwn^.screenprefs.sm_displayid:=$00008000;
           end;
{$endif}
   end;
end;

procedure handlebevelwindow(messcopy : tintuimessage);
var
  pgsel : pgadget;
  class : long;
  code  : word;
  dummy : long;
  pdwn  : pdesignerwindownode;
  tags  : array[1..10] of ttagitem;
  pbbn  : pbevelboxnode;
  ItemNumber : word;
  SubNumber  : word;
  MenuNumber : word;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=9999;
  if (class=idcmp_gadgetup)or(class=idcmp_gadgetdown) then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_closewindow then
    dummy:=50;
  if class=idcmp_menupick then
    if inputmode=0 then
      begin
        ItemNumber:=ITEMNUM(code);
        SubNumber:=SUBNUM(code);
        MenuNumber:=MENUNUM(code);
        Case MenuNumber of
          WinListOpts :
            Case ItemNumber of
              WinListUpdate :
                dummy:=bevel_update;
              WinListHelp :
                dummy:=bevel_help;
              WinListClose :
                dummy:=50;
             end;
         end;
      end;
  if (class=idcmp_vanillakey) then
    case upcase(chr(code)) of
      'H' : dummy:=Bevel_Help;
      'U' : dummy:=Bevel_Update;
      'M' : dummy:=Bevel_Move;
      'S' : dummy:=Bevel_Size;
      'D' : dummy:=Bevel_Delete;
      'N' : begin code:=3; dummy:=30; end;
      'O' : begin code:=0; dummy:=30; end;
      'R' : begin code:=1; dummy:=30; end;
      'B' : begin code:=2; dummy:=30; end;
     end;
  case dummy of
    bevel_radio : if (inputmode=0)and(pdwn^.bevelselected<>~0) then
                    begin
                      pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                      pbbn^.beveltype:=code;
                    end;
    bevel_listview : begin
                       pdwn^.bevelselected:=code;
                       pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                              gtmx_active,pbbn^.beveltype);
                     end;
    Bevel_Help   : if inputmode=0 then 
                     helpwindow(@pdwn^.helpwin,bevelhelp);
    Bevel_Update : if inputmode=0 then 
                     updateeditwindow:=true;
    bevel_move   : if (inputmode=0)and(pdwn^.bevelselected<>~0) then
                     Begin
                       pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                       maxx:=pbbn^.x+pbbn^.w-1;
                       minx:=pbbn^.x;
                       maxy:=pbbn^.h+pbbn^.y-1;
                       miny:=pbbn^.y;
                       box[1]:=minx;
                       box[3]:=maxx-minx+box[1];
                       box[2]:=miny;
                       box[4]:=maxy-miny+box[2];
                       inputmode:=101;
                       setinputglist(pdwn);
                       WindowToFront(pdwn^.editWindow);
                       activatewindow(pdwn^.editwindow);
                       drawbox(pdwn);
                     end;
    bevel_delete : if (inputmode=0)and(pdwn^.bevelselected<>~0) then
                     begin
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                        gtlv_labels,~0);
                       pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                       remove(pnode(pbbn));
                       freemymem(pbbn,sizeof(tbevelboxnode));
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                        gtlv_labels,long(@pdwn^.bevelboxlist));
                       if sizeoflist(@pdwn^.bevelboxlist)>0 then
                         begin
                           if pdwn^.bevelselected>0 then
                             dec(pdwn^.bevelselected);
                         end
                        else
                         pdwn^.bevelselected:=~0;
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                        gtlv_selected,long(pdwn^.bevelselected));
                       if pdwn^.bevelselected<>~0 then
                         begin
                           pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                           gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                                  gtmx_active,pbbn^.beveltype);
                         end;
                       updateeditwindow:=true;
                     end;
    bevel_size   : if (inputmode=0) and (pdwn^.bevelselected<>~0) then
                     begin
                       pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                       inputmode:=102;
                       setinputglist(pdwn);
                       box[1]:=pbbn^.x;
                       box[2]:=pbbn^.y;
                       box[3]:=box[1]+pbbn^.w-1;
                       box[4]:=box[2]+pbbn^.h-1;
                       drawbox(pdwn);
                       windowtofront(pdwn^.editwindow);
                       activatewindow(pdwn^.editwindow);
                     end;
    30 : if (inputmode=0) then
              begin
                gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                       gtmx_active,code);
                if pdwn^.bevelselected<>~0 then
                  begin
                    pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                    pbbn^.beveltype:=code;
                  end;
              end;
    50 : if inputmode=0 then
           begin
             updateeditwindow:=true;
             closebevelwindow(pdwn);
           end;
   end;
end;

procedure handlegadgetlistwindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  itemnumber : word;
  menunumber : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  tags      : array[1..10] of ttagitem;
  pgn       : pgadgetnode;
  pgn2,pgn3 : pgadgetnode;
  pmt       : pmytag;
  str       : long;
  
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=9999;
  if (class=idcmp_gadgetup)or(class=idcmp_gadgetdown) then
    dummy:=pgsel^.gadgetid;
  if class=idcmp_closewindow then
    dummy:=50;
  if (class=idcmp_vanillakey) then
    case upcase(chr(code)) of
      'E' : dummy:=2;
      'U' : dummy:=3;
      'D' : dummy:=4;
      'H' : dummy:=5;
     end;
  if class=idcmp_menupick then
    begin
      ItemNumber:=ITEMNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        Gadlistmenuoptions :
          Case ItemNumber of
            gadlistmenuoptionshelp :
              dummy:=9;
            GadlistmenuoptionsClose :
              dummy:=50;
           end;
       end;
    end;
  case dummy of
    0  : begin
           pdwn^.gadselected:=code;
           pgn:=pgadgetnode(getnthnode(@pdwn^.gadgetlist,pdwn^.gadselected));
           if (doubleclick(pgn^.seconds,pgn^.micros,
                           messcopy.seconds,messcopy.micros)) then
             openeditgadget(pdwn,pgn);
           pgn^.seconds:=messcopy.seconds;
           pgn^.micros:=messcopy.micros;
         end;
    2  : if (inputmode=0)and(pdwn^.gadselected<>~0) then
           begin
             pgn:=pgadgetnode(getnthnode(@pdwn^.gadgetlist,pdwn^.gadselected));
             openeditgadget(pdwn,pgn);
           end;
    3  : if (inputmode=0)and(pdwn^.gadselected<>~0) then
           begin
             str:=pdwn^.gadselected;
             pgn:=pgadgetnode(getnthnode(@pdwn^.gadgetlist,pdwn^.gadselected));
             if (pgn^.kind=listview_kind)and(pgn^.tags[3].ti_data<>0) then
               pgn:=pgn^.ln_pred;
             pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
             if pgn<>pgn2 then
               begin
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_labels,~0);
                 pgn2:=pgn^.ln_pred;
                 remove(pnode(pgn2));
                 insert_(@pdwn^.gadgetlist,pnode(pgn2),pnode(pgn));
                 if (pgn^.kind=string_kind) and (pgn^.joined) then
                   begin
                     pgn:=pgadgetnode(pgn^.pointers[1]);
                     pgn2:=pgn^.ln_pred;
                     remove(pnode(pgn2));
                     insert_(@pdwn^.gadgetlist,pnode(pgn2),pnode(pgn));
                   end;
                 fixgadgetnumbers(pdwn);
                 pdwn^.gadselected:=str-1;
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_labels,long(@pdwn^.gadgetlist));
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_selected,pdwn^.gadselected);
               end;
           end;
    4  : if (inputmode=0)and(pdwn^.gadselected<>~0) then
           begin
             str:=pdwn^.gadselected;
             pgn:=pgadgetnode(getnthnode(@pdwn^.gadgetlist,pdwn^.gadselected));
             if (pgn^.kind=string_kind)and(pgn^.joined) then
               pgn:=pgn^.ln_succ;
             if pgn^.ln_succ^.ln_succ<>nil then
               begin
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_labels,~0);
                 pgn2:=pgn^.ln_succ;
                 remove(pnode(pgn));
                 insert_(@pdwn^.gadgetlist,pnode(pgn),pnode(pgn2));
                 if (pgn^.kind=listview_kind)and(pgn^.tags[3].ti_data<>0) then
                   begin
                     pgn:=pgadgetnode(pgn^.tags[3].ti_data);
                     pgn2:=pgn^.ln_succ;
                     remove(pnode(pgn));
                     insert_(@pdwn^.gadgetlist,pnode(pgn),pnode(pgn2));
                   end;
                 fixgadgetnumbers(pdwn);
                 pdwn^.gadselected:=str+1;
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_labels,long(@pdwn^.gadgetlist));
                 gt_setsinglegadgetattr(pdwn^.gadgetlistwindowgads[0],pdwn^.gadgetlistwindow,
                                        gtlv_selected,pdwn^.gadselected);
                 
               end;
           end;
    5  : if (inputmode=0)and(pdwn^.gadselected<>~0)and(pdwn^.mxchoice<>31) then
           begin
             pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
             pgn2:=pgadgetnode(getnthnode(@pdwn^.gadgetlist,pdwn^.gadselected));
             while(pgn^.ln_succ<>nil) do
               begin
                 if ((iequalifier_lshift or iequalifier_rshift) and messcopy.qualifier)=0 then
                   begin
                     if pgn^.high and (pgn<>pgn2) then
                       begin
                         pgn^.high:=false;
                         highlightgadget(pgn,pdwn);
                       end;
                   end;
                 pgn:=pgn^.ln_succ;
               end;
             if not pgn2^.high then
               highlightgadget(pgn2,pdwn);
             pgn2^.high:=true;
             if (pgn2^.kind=listview_kind)and(pgn2^.tags[3].ti_data<>0) then
               begin
                 pgn:=pgadgetnode(pgn2^.tags[3].ti_data);
                 pgn^.high:=true;
               end
              else
               if pgn^.joined and (pgn^.kind=string_kind) then
                 begin
                   pgn2:=pgadgetnode(pgn^.pointers[1]);
                   if not pgn2^.high then
                     highlightgadget(pgn2,pdwn);
                   pgn2^.high:=true;
                 end;
           end;
    9  : if inputmode=0 then
           helpwindow(@pdwn^.helpwin,windowedithelp);
    50 : if inputmode=0 then
           closegadgetlistwindow(pdwn);
   end;
end;

procedure handledisplayimagewindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  Item    : pMenuItem;
  pwn     : pwindownode;
  pin     : pimagenode;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pin:=pimagenode(messcopy.idcmpwindow^.userdata);
  if pin^.displaywindow=messcopy.idcmpwindow then
    begin
      case class of
        idcmp_closewindow :
          if inputmode=0 then
            closeimagedisplaywindow(pin);
        idcmp_newsize :
          newimagenodewindowsize(pin);
        idcmp_gadgetdown :
          pin^.currentgadget:=pgsel^.gadgetid;
        idcmp_gadgetup :
          begin
            checkimagenodegadget(pin,pin^.currentgadget);
            pin^.currentgadget:=0;
          end;
        idcmp_intuiticks :
          checkimagenodegadget(pin,pin^.currentgadget);
        idcmp_menupick :
         if inputmode=0 then
           begin
            ItemNumber:=ITEMNUM(code);
            SubNumber:=SUBNUM(code);
            MenuNumber:=MENUNUM(code);
            Case MenuNumber of
              ImageOptions :
                Case ItemNumber of
                  DisplayEdit :
                    begin
                      openimageeditwindow(pin);
                    end;
                  DisplayZip :
                    zipwindow(pin^.displaywindow);
                  DisplayClose :
                    closeimagedisplaywindow(pin);
                 end;
             end;
           end;
        idcmp_vanillakey :
          if inputmode=0 then
            case upcase(chr(code)) of
              'C' : closeimagedisplaywindow(pin);
              'Z' : zipwindow(pin^.displaywindow);
              'E' : begin
                      openimageeditwindow(pin);
                    end;
             end;
       end;
    end
   else
    editimagehandling(messcopy);
end;

procedure handlelibrarywindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  pwn     : pwindownode;
  pln     : plibnode;
  loop    : long;
  ps      : pbytearray;
begin
  dummy:=0;
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  case class of
    idcmp_menupick :
      begin
        ItemNumber:=ITEMNUM(code);
        SubNumber:=SUBNUM(code);
        MenuNumber:=MENUNUM(code);
        Case MenuNumber of
          LibOpt :
            Case ItemNumber of
              LibOptDefault :
                Begin
                  loop:=0;
                  pln:=plibnode(tliblist.lh_head);
                  while(pln^.ln_succ<>nil) do
                    begin
                      pln^.versione:=libraryversions[loop];
                      pln^.opene:=defaultlibopen[loop];
                      pln^.abortonfaile:=true;
                      ps:=pbytearray(@librarynames[loop,0]);
                      if pln^.opene then
                        ps^[1]:=ord('>')
                       else
                        ps^[1]:=32;
                      inc(loop);
                      pln:=pln^.ln_succ;
                    end;
                  pln:=plibnode(getnthnode(@tliblist,libselected));
                  writelibdata(pln);
                end;
              LibOptHelp :
                dummy:=3;
              LibOptok :
                dummy:=2;
              LibOptcancel :
                dummy:=4;
             end;
         end;
      end;
    idcmp_closewindow :
      dummy:=4;
    idcmp_vanillakey :
      case upcase(chr(code)) of  
        'V' : if inputmode=0 then
                if activategadget(libwindowgadgets[7],libwindow,nil) then;
        'A' : if inputmode=0 then
                togglecheckbox(libwindowgadgets[6],libwindow);
        'P' : if inputmode=0 then
                begin
                  togglecheckbox(libwindowgadgets[5],libwindow);
                  pln:=plibnode(getnthnode(@tliblist,libselected));
                  readlibdata(pln);
                  writelibdata(pln);
                end;
        'C' : dummy:=4;
        'H' : dummy:=3;
        'O' : dummy:=2;
       end;
    idcmp_gadgetup :
      dummy:=pgsel^.gadgetid;
   end;
  case dummy of
    1 : begin
              if inputmode=0 then
                begin
                  pln:=plibnode(getnthnode(@tliblist,code));
                  libselected:=code;
                  writelibdata(pln);
                end
               else
                begin
                  pln:=plibnode(getnthnode(@tliblist,libselected));
                  writelibdata(pln);
                end;
            end;
    2 : if inputmode=0 then
              begin
                pln:=plibnode(getnthnode(@tliblist,libselected));
                readlibdata(pln);
                pln:=plibnode(tliblist.lh_head);
                repeat
                  with pln^ do 
                    begin
                      open:=opene;
                      version:=versione;
                      abortonfail:=abortonfaile;
                    end;
                  pln:=pln^.ln_succ;
                until pln^.ln_succ=nil;
                closelibwindow;
              end;
    3 : if inputmode=0 then
              helpwindow(@defaulthelpwindownode,libhelp);
    4 : if inputmode=0 then
              closelibwindow;
    5,6,7: 
            if inputmode=0 then
              begin
                pln:=plibnode(getnthnode(@tliblist,libselected));
                readlibdata(pln);
                writelibdata(pln);
              end
             else
              begin
                pln:=plibnode(getnthnode(@tliblist,libselected));
                writelibdata(pln);
              end;
   end;
end;

procedure handlelocalewindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  pwn     : pwindownode;
  loop    : long;
  ps      : pbytearray;
  s       : string;
  pln     : plocalenode;
begin
  dummy:=1000;
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  case class of
    idcmp_menupick :
      begin
        ItemNumber:=ITEMNUM(code);
        MenuNumber:=MENUNUM(code);
        Case MenuNumber of
          localemenutitle :
            Case ItemNumber of
              Localemenutitle_ok :
                dummy:=localewin.okgad;
              LocaleMenuTitle_help :
                dummy:=localewin.helpgad;
              Localmenutitle_cancel :
                dummy:=localewin.cancelgad;

             end;
         end;
      end;
    idcmp_closewindow :
      dummy:=localewin.cancelgad;
    idcmp_vanillakey :
      case upcase(chr(code)) of  
        'C' : dummy:=localewin.cancelgad;
        'H' : dummy:=localewin.helpgad;
        'O' : dummy:=localewin.okgad;
       end;
    idcmp_gadgetup :
      dummy:=pgsel^.gadgetid;
   end;
  if localelistselected<>~0 then
    begin
      pln:=pointer(getnthnode(@loclistgadlist,localelistselected));
      pln^.str:=getstringfromgad(localewindowgads[locstringgad]);
      pln^.labl:=getstringfromgad(localewindowgads[loclabelgad]);
      pln^.comment:=getstringfromgad(localewindowgads[loccommentgad]);
    end;
  case dummy of
    localewin.okgad : if inputmode=0 then
              begin
                getstring:=getstringfromgad(localewindowgads[getstringgad]);
                builtinlanguage:=getstringfromgad(localewindowgads[builtinlanguagegad]);
                basename:=getstringfromgad(localewindowgads[basenamegad]);
                version:=getintegerfromgad(localewindowgads[versiongad]);
                locale37:=checkedbox(localewindowgads[supportgad]);
                freelist(@tlocalelist,sizeof(tlocalenode));
                pln:=pointer(remhead(@loclistgadlist));
                while(pln<>nil) do
                  begin
                    addtail(@tlocalelist,pnode(pln));
                    pln:=pointer(remhead(@loclistgadlist));
                  end;
                closewindowlocalewindow;
              end;
    localewin.helpgad : if inputmode=0 then
              helpwindow(@defaulthelpwindownode,localehelp);
    localewin.cancelgad : if inputmode=0 then
              closewindowlocalewindow;
    newlocgad : 
            if (inputmode=0) then
              begin
                pln:=allocmymem(sizeof(tlocalenode),memf_clear);
                if pln<>nil then
                  begin
                    gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(~0));
                    addtail(@loclistgadlist,pnode(pln));
                    localelistselected:=getlistpos(@loclistgadlist,pnode(pln));
                    pln^.ln_name:=@pln^.str[1];
                    pln^.str:='New string'#0;
                    str(localelistselected,s);
                    pln^.labl:='NewLocaleText'+s+#0;
                    pln^.comment:=#0;
                    gt_setsinglegadgetattr(localewindowgads[deletelocgad],localewindow,ga_disabled,long(false));
                    gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,ga_disabled,long(false));
                    gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,ga_disabled,long(false));
                    gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,ga_disabled,long(false));
                    gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,gtst_string,long(@pln^.comment[1]));
                    gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,gtst_string,long(@pln^.labl[1]));
                    gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,gtst_string,long(@pln^.str[1]));
                    gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(@loclistgadlist));
                  end
                 else
                  begin
                    telluser(localewindow,memerror);
                  end;
              end;
    locstringgad:
      begin
        gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(~0));
        gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(@loclistgadlist));
      end;
    deletelocgad : 
      if (inputmode=0) and (localelistselected<>~0) then
        begin
          gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(~0));
          gt_setsinglegadgetattr(localewindowgads[deletelocgad],localewindow,ga_disabled,long(true));
          gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,ga_disabled,long(true));
          gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,ga_disabled,long(true));
          gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,ga_disabled,long(true));
          pln:=pointer(getnthnode(@loclistgadlist,localelistselected));
          remove(pnode(pln));
          freemymem(pln,sizeof(tlocalenode));
          localelistselected:=~0;
          gt_setsinglegadgetattr(localewindowgads[loclistgad],localewindow,gtlv_labels,long(@loclistgadlist));
        end;
    loclistgad:
      begin
        localelistselected:=code;
        pln:=pointer(getnthnode(@loclistgadlist,localelistselected));
        gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,gtst_string,long(@pln^.comment[1]));
        gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,gtst_string,long(@pln^.labl[1]));
        gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,gtst_string,long(@pln^.str[1]));
        gt_setsinglegadgetattr(localewindowgads[deletelocgad],localewindow,ga_disabled,long(false));
        gt_setsinglegadgetattr(localewindowgads[loccommentgad],localewindow,ga_disabled,long(false));
        gt_setsinglegadgetattr(localewindowgads[loclabelgad],localewindow,ga_disabled,long(false));
        gt_setsinglegadgetattr(localewindowgads[locstringgad],localewindow,ga_disabled,long(false));
      end;
   end;
end;


procedure handlemainwindow(messcopy : tintuimessage);
var
  pdsn      : pdesignerscreennode;
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  Item    : pMenuItem;
  pwn     : pwindownode;
  pin     : pimagenode;
  dummy3  : long;
  pdmn    : pdesignermenunode;
  pdsn2   : pdesignerscreennode;
  goforit : boolean;
  tags    : array[1..6] of ttagitem;
  psn     : pstringnode;
  pdwn2   : pdesignerwindownode;
  pdwn9   : pdesignerwindownode;
  dummy2  : long;
  loop4   : word;
  pgn     : pgadgetnode;
  menudone: boolean;
  go      : boolean;
  pmt     : pmytag;
begin
  code:=messcopy.code;
  MenuNumber:=code;
  class:=messcopy.class;
  menudone:=false;
  pgsel:=pgadget(messcopy.iaddress);
  dummy3:=0;
  case class of
    idcmp_menupick :
      begin
        while (MenuNumber<>MENUNULL) and (Not menuDone) do
          Begin
            menudone:=true;
            Item:=ItemAddress( MainWindowMenu, MenuNumber);
            ItemNumber:=ITEMNUM(MenuNumber);
            SubNumber:=SUBNUM(MenuNumber);
            MenuNumber:=MENUNUM(MenuNumber);
            Case MenuNumber of
              MenuProject :
                Case ItemNumber of
                  MenuClearAll :
                    if inputmode=0 then
                    if areyousure(mainwindow,'Clear all data ?'#0) then
                    Begin
                      waiteverything;
                      freelist(@tlocalelist,sizeof(tlocalenode));
                      saved:=false;
                      filedir:='';
                      filename:='';
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
                      pin:=pimagenode(teditimagelist.lh_head);
                      while (pin^.ln_succ<>nil) do
                        begin
                          gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,~0);
                          if pin^.editwindow<>nil then
                            closeimageeditwindow(pin);
                          if pin^.displaywindow<>nil then
                            closeimagedisplaywindow(pin);
                          if pin^.colourmap<>nil then
                            freemymem(pin^.colourmap,pin^.mapsize);
                          if pin^.imagedata<>nil then
                            freemymem(pin^.imagedata,pin^.sizeallocated);
                          pin:=pin^.ln_succ;
                        end;
                      freelist(@teditimagelist,sizeof(timagenode));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
                      pdmn:=pdesignermenunode(remhead(@teditmenulist));
                      while (pdmn<>nil) do
                        begin
                          deletedesignermenunode(pdmn);
                          pdmn:=pdesignermenunode(remhead(@teditmenulist));
                        end;
                      pdwn:=pdesignerwindownode(remhead(@teditwindowlist));
                      while (pdwn<>nil) do
                        begin
                          deletedesignerwindow(pdwn);
                          pdwn:=pdesignerwindownode(remhead(@teditwindowlist));
                        end;
                      pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
                      while(pdsn^.ln_succ<>nil) do
                        begin
                          pdsn2:=pdsn^.ln_succ;
                          handledeletescreennode(pdsn);
                          pdsn:=pdsn2;
                        end;
                      mainselected:=~0;
                      inputmode:=1;
                      unwaiteverything;
                    end;
                  MenuOpen :
                    dummy3:=6;
                  MenuSave :
                    if inputmode=0 then
                      if saved then
                        begin
                          if not writealldata(filedir+filename+#0) then
                            begin
                              {
                              saved:=false;
                              }
                            end;
                           {
                           else
                            saved:=true;
                           }
                        end
                       else
                        telluser(mainwindow,'File not saved yet.');
                  MenuSaveAs :
                    dummy3:=7;
                  MenuGenerate :
                    dummy3:=8;
                  menuimport :
                    if inputmode=0 then
                      importagtbfile;
                  MenuRevert :
                    if inputmode=0 then
                      begin
                        go := true;
                        if prefsvalues[14] then
                          go := areyousure(mainwindow,'Lose new data ?');
                        if go then
                          begin
                            if saved then
                              if readalldata(filedir+filename+#0,true) then
                                begin
                                  closelibwindow;
                                  closemaincodewindow;
                                  CloseWindowlocaleWindow;
                                  {
                                  saved:=true;
                                  }
                                end
                             else
                              telluser(mainwindow,'File not saved yet.');
                          end;
                      end;
                  MenuMerge :
                    begin
                      {load      filedir has slash when outside load/save no 0's }
                      goforit:=true;
                      if goforit then
                        begin
                          waiteverything;
                          settagitem(@tags[1],asl_funcflags,filf_patgad);
                          filedir:=no0(filedir);
                          if filedir[length(filedir)]='/' then
                            filedir:=copy(filedir,1,length(filedir)-1);
                          filedir:=filedir+#0;
                          filename:=no0(filename)+#0;
                          settagitem(@tags[2],asl_file,long(@filename[1]));
                          settagitem(@tags[3],asl_dir,long(@filedir[1]));
                          settagitem(@tags[4],tag_done,0);
                          if aslrequest(loadsaverequest,@tags[1]) then
                            begin
                              ctopas(loadsaverequest^.fr_file^,filename);
                              ctopas(loadsaverequest^.fr_drawer^,filedir);
                              if filedir<>'' then
                                if (filedir[length(filedir)]<>':') and
                                   (filedir[length(filedir)]<>'/') then
                                  filedir:=filedir+'/';
                              closewindowlocalewindow;
                              if readalldata(filedir+filename+#0,false) then
                                saved:=false;
                            end;
                          filedir:=no0(filedir);
                          filename:=no0(filename);
                          if filedir<>'' then
                            if (filedir[length(filedir)]<>':') and
                               (filedir[length(filedir)]<>'/') then
                              filedir:=filedir+'/';
                          
                          unwaiteverything;
                          inputmode:=1;
                        end;
                    end;
                  MenuAbout :
                    dummy3:=2;
                  MenuQuit :
                    dummy3:=101;
                 end;
              MenuOptions :
                Case ItemNumber of
                  MenuPrefs :
                    dummy3:=4;                     
                  MenuCode :
                    dummy3:=5;
                  MenuEditTags :
                    openwindowedittagswindow;
                  MenuLibs :
                    if inputmode=0 then
                      openlibwindow;
                  menulocale :
                    if inputmode=0 then
                      openwindowlocalewindow;
                  MainMenuHelp :
                    dummy3:=12;
                 end;
             end;
            MenuNumber:=Item^.NextSelect;
          end;
      end;
    idcmp_closewindow :
      dummy3:=101;
    idcmp_gadgetup :
      dummy3:=pgsel^.gadgetid;
    idcmp_vanillakey :
      if inputmode=0 then
        begin
          case upcase(chr(code)) of
            'A' : dummy3:=2;
            'P' : dummy3:=4;
            'C' : dummy3:=5;
            'O' : dummy3:=6;
            'S' : dummy3:=7;
            'G' : dummy3:=8;
            'H' : dummy3:=12;
            'E' : dummy3:=11;
            'D' : dummy3:=10;
            'N' : dummy3:=9;
            'I' : if inputmode=0 then
                    begin
                      mainselected:=~0;
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                      gt_setsinglegadgetattr(mainwindowgadgets[3],mainwindow,gtcy_active,2);
                      cyclepos:=2;
                    end;
            'W' : if inputmode=0 then
                    begin
                      mainselected:=~0;
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditwindowlist));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                      gt_setsinglegadgetattr(mainwindowgadgets[3],mainwindow,gtcy_active,0);
                      cyclepos:=0;
                    end;
            'M' : if inputmode=0 then
                    begin
                      mainselected:=~0;
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditmenulist));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                      gt_setsinglegadgetattr(mainwindowgadgets[3],mainwindow,gtcy_active,1);
                      cyclepos:=1;
                    end;
            'R' : if inputmode=0 then
                    begin
                      mainselected:=~0;
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditscreenlist));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
                      gt_setsinglegadgetattr(mainwindowgadgets[3],mainwindow,gtcy_active,3);
                      cyclepos:=3;
                    end;
           end;
        end;
   end;
  case dummy3 of
    1  : if (inputmode=0) then
           begin
             if (mainselected<>~0)and(mainselected=code) then
               if doubleclick(mainseconds,mainmicro,messcopy.seconds,messcopy.micros) then
                 begin
                   mainselected:=code;
                   case cyclepos of
                     0 : begin
                           pdwn:=pdesignerwindownode(getnthnode(@teditwindowlist,mainselected));
                           if pdwn^.editwindow=nil then
                             begin
                               if openscreentoeditwindow(pdwn,0) then
                                 if openoptionswindow(pdwn) then
                                   begin 
                                     if not openeditwindow(pdwn) then
                                       closeeditscreenforwindow(pdwn);
                                   end
                                  else
                                   begin
                                     telluser(mainwindow,'Unable to open backdrop window.');
                                     closeeditscreenforwindow(pdwn);
                                   end;
                             end
                            else
                             screentofront(pdwn^.editscreen);
                         end;
                     1 : begin 
                           pdmn:=pdesignermenunode(getnthnode(@teditmenulist,mainselected));
                           openeditmenuwindow(pdmn);
                           if pdmn^.editwindow<>nil then
                           setmenueditwindowtitle(pdmn,pmenutitlenode(pdmn^.tmenulist.lh_head));
                         end;
                     2 : begin
                           openimageeditwindow(pimagenode(
                               getnthnode(@teditimagelist,mainselected)));
                         end;
                     3 : begin
                           handleeditscreennode(pdesignerscreennode(
                                       getnthnode(@teditscreenlist,mainselected)));
                         end;
                    end; 
                 end;
             mainmicro:=messcopy.micros;
             mainseconds:=messcopy.seconds;
             mainselected:=code
           end
          else
           gt_setsinglegadgetattr(pgsel,mainwindow,gtlv_selected,mainselected);
    2  : if inputmode=0 then
           openabout;
    3  : if inputmode=0 then
           begin
             mainselected:=~0;
             cyclepos:=code;
             case cyclepos of
               0 : gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditwindowlist));
               1 : gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditmenulist));
               2 : gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditimagelist));
               3 : gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_labels,long(@teditscreenlist));
              end;
             gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,gtlv_selected,~0);
           end
          else
           gt_setsinglegadgetattr(pgsel,mainwindow,gtcy_active,cyclepos);
    4  : if inputmode=0 then
           begin
             { prefs }
             openprefswindow;
           end;
    5  : if inputmode=0 then
           openmaincodewindow;
    6  : if inputmode=0 then
           begin
             {load      filedir has slash when outside load/save no 0's }
             goforit:=true;
             if prefsvalues[8] then
               goforit:=areyousure(mainwindow,'Lose Current Data ?'#0);
             if goforit then
               begin
                 waiteverything;
                 settagitem(@tags[1],asl_funcflags,filf_patgad);
                 filedir:=no0(filedir);
                 if filedir[length(filedir)]='/' then
                   filedir:=copy(filedir,1,length(filedir)-1);
                 filedir:=filedir+#0;
                 filename:=no0(filename)+#0;
                 settagitem(@tags[2],asl_file,long(@filename[1]));
                 settagitem(@tags[3],asl_dir,long(@filedir[1]));
                 settagitem(@tags[4],tag_done,0);
                 if aslrequest(loadsaverequest,@tags[1]) then
                   begin
                     ctopas(loadsaverequest^.fr_file^,filename);
                     ctopas(loadsaverequest^.fr_drawer^,filedir);
                     if filedir<>'' then
                       if (filedir[length(filedir)]<>':') and
                          (filedir[length(filedir)]<>'/') then
                         filedir:=filedir+'/';
                     if readalldata(filedir+filename+#0,true) then
                       begin
                         closelibwindow;
                         closemaincodewindow;
                         CloseWindowlocaleWindow;
                         saved:=true;
                       end;
                   end;
                 filedir:=no0(filedir);
                 filename:=no0(filename);
                 if filedir<>'' then
                   if (filedir[length(filedir)]<>':') and
                      (filedir[length(filedir)]<>'/') then
                     filedir:=filedir+'/';
                 unwaiteverything;
                 inputmode:=1;
               end;
           end;
    7  : if inputmode=0 then
           begin
             {save}
             waiteverything;
             settagitem(@tags[1],asl_funcflags,filf_save or filf_patgad);
             filedir:=no0(filedir);
             if filedir[length(filedir)]='/' then
               filedir:=copy(filedir,1,length(filedir)-1);
             filedir:=filedir+#0;
             filename:=no0(filename)+#0;
             settagitem(@tags[2],asl_file,long(@filename[1]));
             settagitem(@tags[3],asl_dir,long(@filedir[1]));
             settagitem(@tags[4],tag_done,0);
             if aslrequest(loadsaverequest,@tags[1]) then
               begin
                 ctopas(loadsaverequest^.fr_file^,filename);
                 if filename<>'' then
                   begin
                     ctopas(loadsaverequest^.fr_drawer^,filedir);
                     if filedir<>'' then
                       if (filedir[length(filedir)]<>':') and
                          (filedir[length(filedir)]<>'/') then
                         filedir:=filedir+'/';
                     if upstring(copy(filename,length(filename)-3,4))<>'.DES' then
                       filename:=filename+'.des';
                     if not writealldata(filedir+filename+#0) then
                       begin
                         {
                         saved:=false;
                         }
                       end
                      else
                       saved:=true;
                     if filedir[length(filedir)]='/' then
                       filedir:=copy(filedir,1,length(filedir)-1);
                   end
                  else
                   begin
                     telluser(mainwindow,'Need a filename.');
                     {
                     saved:=false;
                     }
                   end;
               end;
             filedir:=no0(filedir);
             filename:=no0(filename);
             if filedir<>'' then
               if (filedir[length(filedir)]<>':') and
                  (filedir[length(filedir)]<>'/') then
                 filedir:=filedir+'/';
             unwaiteverything;
             inputmode:=1;
           end;
    8  : if (inputmode=0) then 
           begin
             {Generate}
             if (presentcompiler<>~0) then
               begin
                 waiteverything;
                 if not saved then
                   begin
                     telluser(mainwindow,'Designer file not saved : cannot produce source file.');
                   end
                  else
                   begin
                     if writealldata(filedir+filename+#0) then
                       begin
                         psn:=pstringnode(getnthnode(@compilerlist,presentcompiler));
                         exec(no0(psn^.st),'"'+filedir+filename+'"');
                       end;
                   end;
                 unwaiteverything;
                 inputmode:=1;
               end
              else
               telluser(mainwindow,'No Producer selected.');
           end;
    9  : if inputmode=0 then
          { new window/menu }
           case cyclepos of
             0: begin
                  pdwn:=allocmymem(sizeof(tdesignerwindownode),memf_any or memf_clear);
                  if pdwn<>nil then
                    begin
                      setdefaultwindow(pdwn);
                      addtail(@teditwindowlist,pnode(pdwn));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_labels,~0);
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_labels,long(@teditwindowlist));
                    end;
                  pdwn2:=pdesignerwindownode(teditwindowlist.lh_head);
                  dummy:=~0;
                  dummy2:=0;
                  while (pdwn2^.ln_succ<>nil) do
                    begin
                      if pdwn=pdwn2 then
                        dummy:=dummy2;
                      inc(dummy2);
                      pdwn2:=pdwn2^.ln_succ;
                    end;
                  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_selected,dummy);
                  gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_top,dummy);
                  mainselected:=dummy;
                end;
             1: begin
                  pdmn:=createnewdesignermenunode;
                  if pdmn<>nil then
                    begin
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_labels,~0);
                      addtail(@teditmenulist,pnode(pdmn));
                      dummy:=getlistpos(@teditmenulist,pnode(pdmn));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_labels,long(@teditmenulist));
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_selected,dummy);
                      gt_setsinglegadgetattr(mainwindowgadgets[1],mainwindow,
                                             gtlv_top,dummy);
                      mainselected:=dummy;
                      pdwn9:=pdesignerwindownode(teditwindowlist.lh_head);
                      while (pdwn9^.ln_succ<>nil) do
                        begin
                          if pdwn9^.codewindow<>nil then
                            begin
                              gt_setsinglegadgetattr(pdwn9^.codegadgets[25],pdwn9^.codewindow,
                                                     gtlv_labels,~0);
                              gt_setsinglegadgetattr(pdwn9^.codegadgets[25],pdwn9^.codewindow,
                                                     gtlv_labels,long(@teditmenulist));
                              gt_setsinglegadgetattr(pdwn9^.codegadgets[25],pdwn9^.codewindow,
                                                     gtlv_selected,pdwn9^.codeselected);
                            end;
                          pdwn9:=pdwn9^.ln_succ;
                        end;
                    end;
                end;
             2 : begin
                   waiteverything;
                   openafewimages;
                   pdmn:=pdesignermenunode(teditmenulist.lh_head);
                   while (pdmn^.ln_succ<>nil) do
                     begin
                       if pdmn^.editwindow<>nil then
                         begin
                           if pdmn^.itemselected<>~0 then
                             begin
                               gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,
                                                      gtlv_labels,~0);
                               gt_setsinglegadgetattr(pdmn^.gads[17],pdmn^.editwindow,
                                                      gtlv_labels,long(@teditimagelist));
                             end;
                           if pdmn^.subitemselected<>~0 then
                             begin
                               gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,
                                                      gtlv_labels,~0);
                               gt_setsinglegadgetattr(pdmn^.gads[32],pdmn^.editwindow,
                                                      gtlv_labels,long(@teditimagelist));
                             end;
                         end;
                       pdmn:=pdmn^.ln_succ;
                     end;
                   pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
                   while pdwn^.ln_succ<>nil do
                     begin
                       if pdwn^.imagelistwindow<>nil then
                         begin
                           gt_setsinglegadgetattr(pdwn^.imagegadgets[2],pdwn^.imagelistwindow,gtlv_labels,~0);
                           gt_setsinglegadgetattr(pdwn^.imagegadgets[2],
                                                  pdwn^.imagelistwindow,gtlv_labels,long(@teditimagelist));
                           readallimagelistwindowgadgets(pdwn);
                           setallimagelistwindowgadgets(pdwn);
                         end;
                       pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                       while(pgn^.ln_succ<>nil) do
                         begin
                           if (pgn^.kind=mybool_kind)and(pgn^.editwindow<>nil) then
                             begin
                               gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                                      gtlv_labels,long(@teditimagelist));
                               gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                      gtlv_labels,long(@teditimagelist));
                               gt_setsinglegadgetattr(pgn^.editwindow^.gads[8],pgn^.editwindow^.pwin,
                                                      gtlv_selected,pgn^.editwindow^.data2);
                               gt_setsinglegadgetattr(pgn^.editwindow^.gads[9],pgn^.editwindow^.pwin,
                                                      gtlv_selected,pgn^.editwindow^.data3);
                             end;
                           if (pgn^.kind=myobject_kind) and (pgn^.editwindow<>nil) then
                             begin
                               pmt:=pmytag(getnthnode(@pgn^.editwindow^.editlist,pgn^.editwindow^.data4));
                               if (pmt^.tagtype=tagtypeimage) or (pmt^.tagtype=tagtypeimage) then
                                 begin
                                   gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_labels,~0);
                                   gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_labels,long(@teditimagelist));
                                   gt_setsinglegadgetattr(pgn^.editwindow^.gads[20],pgn^.editwindow^.pwin,
                                                          gtlv_selected,long(pgn^.editwindow^.data2));
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
                           gt_setsinglegadgetattr(pdsn^.editwindowgads[11],
                                      pdsn^.editwindow,gtlv_labels,long(@teditimagelist));
                         end;                
                       pdsn:=pdsn^.ln_succ;
                     end;
                   
                   unwaiteverything;
                   inputmode:=1;
                 end;
             3 :
                 begin
                   handlenewscreennode;
                 end;
            end;
    10 : if (inputmode=0)and(mainselected<>~0) then 
           {delete}
           case cyclepos of
             0 : begin 
                   pdwn:=pdesignerwindownode(getnthnode(@teditwindowlist,mainselected));
                   if prefsvalues[3] then
                     begin
                       if areyousure(mainwindow,'Delete Window '+no0(pdwn^.title)+' ?'#0) then
                         deletedesignerwindow(pdwn);
             
                     end
                    else
                     deletedesignerwindow(pdwn);
                 end;
             1 : begin 
                   pdmn:=pdesignermenunode(getnthnode(@teditmenulist,mainselected));
                   if prefsvalues[4] then
                     begin
                       if areyousure(mainwindow,'Delete Menu '+no0(pdmn^.idlabel)+' ?'#0) then
                         deletedesignermenunode(pdmn);
                     end
                    else
                     deletedesignermenunode(pdmn);
                 end;
             2 : begin
                   goforit:=true;
                   pin:=pimagenode(getnthnode(@teditimagelist,mainselected));
                   if prefsvalues[5] then
                     goforit:=areyousure(mainwindow,'Delete Image '+no0(pin^.title)+' ?'#0);
                   if goforit then
                     begin
                       deleteimagenode(pin);
                       pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
                       while(pdwn^.ln_succ<>nil) do
                         begin
                           if pdwn^.editwindow<>nil then
                             closeopeneditwindow(pdwn);
                           pdwn:=pdwn^.ln_succ;
                         end;
                     end;
                 end;
             3 : begin 
                   pdsn:=pdesignerscreennode(getnthnode(@teditscreenlist,mainselected));
                   if prefsvalues[17] then
                     begin
                       if areyousure(mainwindow,'Delete Screen '+no0(pdsn^.title)+' ?'#0) then
                         handledeletescreennode(pdsn);
                     end
                    else
                     handledeletescreennode(pdsn);
                 end;
            end;
    11 : if (inputmode=0)and(mainselected<>~0) then
           { edit window/menu }
           case cyclepos of
             0 : begin
                   pdwn:=pdesignerwindownode(getnthnode(@teditwindowlist,mainselected));
                   if pdwn^.editwindow=nil then
                     begin
                       if openscreentoeditwindow(pdwn,0) then
                         if openoptionswindow(pdwn) then
                           begin                                                                              
                             if not openeditwindow(pdwn) then
                               begin
                                 closeoptionswindow(pdwn);
                                 closeeditscreenforwindow(pdwn);
                               end;
                           end
                          else
                           begin
                             telluser(mainwindow,'Unable to open backdrop window.');
                             closeeditscreenforwindow(pdwn);
                           end;
                     end
                    else
                     screentofront(pdwn^.editscreen);
                 end;
             1 : begin 
                   pdmn:=pdesignermenunode(getnthnode(@teditmenulist,mainselected));
                   openeditmenuwindow(pdmn);
                   if pdmn^.editwindow<>nil then
                     setmenueditwindowtitle(pdmn,pmenutitlenode(pdmn^.tmenulist.lh_head));
                 end;
             2 : begin
                   openimageeditwindow(pimagenode(getnthnode(@teditimagelist,mainselected)));
                 end;
             3 : begin
                   handleeditscreennode(pdesignerscreennode(
                                        getnthnode(@teditscreenlist,mainselected)));
                 end;
            end; 
    12 : if inputmode=0 then
           helpwindow(@defaulthelpwindownode,mainhelp);
    99 : if inputmode=0 then
           begin
             
             if demoversion then
               begin
                 telluser(mainwindow,'If you are a registered user select'+#10#10+
                                     'your registered Designer executable'+#10#10+
                                     'to upgrade to new version.');
                 handleupgradewin;
               end
              else
               begin
                 if AreYouSure(mainwindow,
                               'Registration has been confirmed, all features enabled.'+#10#10+
                               'Do you wish to upgrade the Designer file on disk ?') then
                   begin
                     waiteverything;
                     writeregistereduser;
                     unwaiteverything;
                   end;
                                                  

               end;
             
             {
             if upgradewin=nil then
               if not openwindowupgradewin then
                 telluser(mainwindow,'Unable To Open Window.')
                else
                 if not demoversion then
                   begin
                     
                     gt_setsinglegadgetattr(upgradewingads[0],upgradewin,ga_disabled,1);
                     for loop4:=1 to 5 do
                        gt_setsinglegadgetattr(upgradewingads[loop4],upgradewin,ga_disabled,0);
                   end;
             }
           end;
    101: begin
           if (inputmode=0) then 
             if prefsvalues[2] then
               done:=areyousure(mainwindow,'Do Really Want'#10'To Quit Now ?'#0)
              else
               done:=true;
         end;
   end;
end;

procedure handletagswindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  Item    : pMenuItem;
  pwn     : pwindownode;
  pin     : pimagenode;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  if (inputmode=0) and(class=idcmp_gadgetup) then
    begin
      with pdwn^ do 
        case pgsel^.gadgetid of
          1  : begin
                 if (tagsgads[1]^.flags and gflg_selected)=0 then
                   begin
                     gt_setsinglegadgetattr(tagsgads[2],
                                            tagswindow,gtcb_checked,long(false));
                     gt_setsinglegadgetattr(tagsgads[3],
                                            tagswindow,gtcb_checked,long(false));
                   end;
               end;
          2  : begin
                 if ((tagsgads[1]^.flags and gflg_selected)=0) and 
                    ((tagsgads[2]^.flags and gflg_selected)<>0)then
                   begin
                     gt_setsinglegadgetattr(tagsgads[1],
                                            tagswindow,gtcb_checked,long(true));
                   end;
               end;
          3  : begin
                 if ((tagsgads[1]^.flags and gflg_selected)=0) and 
                    ((tagsgads[3]^.flags and gflg_selected)<>0)then
                   begin
                     gt_setsinglegadgetattr(tagsgads[1],
                                            tagswindow,gtcb_checked,long(true));
                   end;
               end;
          8  : begin
                 gt_setsinglegadgetattr(tagsgads[14],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[15],tagswindow,gtcb_checked,long(false));
               end;
          14 : begin
                 gt_setsinglegadgetattr(tagsgads[8 ],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[15],tagswindow,gtcb_checked,long(false));
               end;
          15 : begin
                 gt_setsinglegadgetattr(tagsgads[8 ],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[14],tagswindow,gtcb_checked,long(false));
               end;
          21 : begin
                 gt_setsinglegadgetattr(tagsgads[22],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[23],tagswindow,gtcb_checked,long(false));
               end;
          22 : begin
                 gt_setsinglegadgetattr(tagsgads[21],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[23],tagswindow,gtcb_checked,long(false));
               end;
          23 : begin
                 gt_setsinglegadgetattr(tagsgads[21],tagswindow,gtcb_checked,long(false));
                 gt_setsinglegadgetattr(tagsgads[22],tagswindow,gtcb_checked,long(false));
               end;
          28 : begin
                 readtagswindowgadgets(pdwn);
                 closetagswindow(pdwn);
                 closeopeneditwindow(pdwn);
               end;
          29 : closetagswindow(pdwn);
          30 : settagswindowgadgets(pdwn);
          31 : helpwindow(@pdwn^.helpwin,tagshelp);
         end;
    end;
  if class=idcmp_vanillakey then
    if inputmode=0 then
      case upcase(chr(code)) of
        'O' : begin
                readtagswindowgadgets(pdwn);
                closetagswindow(pdwn);
                closeopeneditwindow(pdwn);
              end;
        'C' : closetagswindow(pdwn);
        'U' : settagswindowgadgets(pdwn);
        'H' : helpwindow(@pdwn^.helpwin,tagshelp);
       end;
  if class=idcmp_menupick then
    if inputmode=0 then
      begin
        ItemNumber:=ITEMNUM(code);
        MenuNumber:=MENUNUM(code);
        Case MenuNumber of
          WinTagOpts :
            Case ItemNumber of
              wintagshelp :
                helpwindow(@pdwn^.helpwin,tagshelp);
              wintagsundo :
                settagswindowgadgets(pdwn);
              wintagsok :
                begin
                  readtagswindowgadgets(pdwn);
                  closetagswindow(pdwn);
                  closeopeneditwindow(pdwn);
                end;
              wintagscancel :
                closetagswindow(pdwn);
             end;
         end;
      end;
  if (class=idcmp_closewindow) and (inputmode=0) then
    closetagswindow(pdwn);
end;

procedure handleimagelistwindow(messcopy : tintuimessage);
var
  pgsel      : pgadget;
  psin       : psmallimagenode;
  class      : long;
  code       : word;
  dummy      : long;
  pdwn       : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  Item       : pMenuItem;
  pwn        : pwindownode;
  pin        : pimagenode;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  if class=idcmp_gadgetup then
    if inputmode=0 then
      dummy:=pgsel^.gadgetid;
  if (class=idcmp_menupick) and (inputmode=0) then
    begin
      ItemNumber:=ITEMNUM(code);
      SubNumber:=SUBNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        WinListOpts :
          Case ItemNumber of
            WinListUpdate :
              dummy:=6;
            WinListHelp :
              dummy:=7;
            WinListClose :
              dummy:=9898;
           end;
       end;
    end;
  if (class=idcmp_closewindow) and (inputmode=0) then
    dummy:=9898;
  if (inputmode=0)and(class=idcmp_vanillakey) then
    case upcase(chr(code)) of
      'H' : dummy:=7;
      'P' : dummy:=8;
      'V' : dummy:=5;
      'N' : dummy:=3;
      'D' : dummy:=4;
      'U' : dummy:=6;
     end;
  case dummy of
    1 : begin
          readallimagelistwindowgadgets(pdwn);
          pdwn^.imageselected:=psmallimagenode(getnthnode(@pdwn^.imagelist,messcopy.code));
          setallimagelistwindowgadgets(pdwn);
        end;
    2 : begin
          pdwn^.bigimsel:=pimagenode(getnthnode(@teditimagelist,messcopy.code));
          if pdwn^.imageselected<>nil then
            pdwn^.imageselected^.pin:=pdwn^.bigimsel;
        end;
    3 : begin
          psin:=allocmymem(sizeof(tsmallimagenode),memf_clear or memf_any);
          if psin<>nil then
            begin
              gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_labels,~0);
              addtail(@pdwn^.imagelist,pnode(psin));
              gt_setsinglegadgetattr(pdwn^.imagegadgets[1],pdwn^.imagelistwindow,gtlv_selected,dummy);
              with psin^ do
                begin
                  x:=0;
                  y:=0;
                  placed:=false;
                  pin:=pdwn^.bigimsel;
                  str(sizeoflist(@pdwn^.imagelist),title);
                  title:='New image '+title+#0;
                  ln_name:=@title[1];
                end;
              readallimagelistwindowgadgets(pdwn);
              pdwn^.imageselected:=psin;
              setallimagelistwindowgadgets(pdwn);
            end
           else
            telluser(pdwn^.imagelistwindow,memerror);
        end;
    4 : begin
          if pdwn^.imageselected<>nil then
            begin
              psin:=pdwn^.imageselected;
              pdwn^.imageselected:=nil;
              gt_setsinglegadgetattr(pdwn^.imagegadgets[1],
                  pdwn^.imagelistwindow,gtlv_labels,~0);
              remove(pnode(psin));
              gt_setsinglegadgetattr(pdwn^.imagegadgets[1],
                  pdwn^.imagelistwindow,gtlv_labels,long(@pdwn^.imagelist));
              setallimagelistwindowgadgets(pdwn);
              if psin^.placed then
                updateeditwindow:=true;
              freemymem(psin,sizeof(tsmallimagenode));
            end;
        end;
    5 : begin
          {view}
          pin:=pdwn^.bigimsel;
          if pin<>nil then
            begin
              if pin^.displaywindow<>nil then
                if pin^.pscr<>pdwn^.editscreen then
                  closeimagedisplaywindow(pin);
              openimagedisplaywindow(pin,pdwn^.editscreen,pdwn);
            end;
        end;
    6 : if inputmode=0 then
          begin
            inputmode:=2;
            updateeditwindow:=true;
          end;
    7 : helpwindow(@pdwn^.helpwin,windowimagelisthelp);
    8 : if (pdwn^.imageselected<>nil) and (pdwn^.bigimsel<>nil) then
          begin
            box[1]:=0;
            box[2]:=0;
            lengthtext2:=pdwn^.bigimsel^.width div 2;
            heighttext2:=pdwn^.bigimsel^.height div 2;
            box[3]:=pdwn^.bigimsel^.width;
            box[4]:=pdwn^.bigimsel^.height;
            inputmode:=18;
            setinputglist(pdwn);
            windowtofront(pdwn^.editwindow);
            activatewindow(pdwn^.editwindow);
            quickputimage(pdwn);
          end;
    9 : begin
          readallimagelistwindowgadgets(pdwn);
          setallimagelistwindowgadgets(pdwn);
        end;
    10,11
      : begin
          updateeditwindow:=true;
          readallimagelistwindowgadgets(pdwn);
          setallimagelistwindowgadgets(pdwn);
        end;
    9898 :
        begin
          updateeditwindow:=true;
          inputmode:=1;
          closeimagelistwindow(pdwn);
        end;
   end;
end;

procedure scalegads(pdwn:pdesignerwindownode;x,y : real);
var 
  pgn  : pgadgetnode;
  psin : psmallimagenode;
  ptn  : ptextnode;
  pbbn : pbevelboxnode;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      pgn^.x:=round(pgn^.x*x);
      pgn^.y:=round(pgn^.y*y);
      if pgn^.kind <> mybool_kind then
        begin
          pgn^.w:=round(pgn^.w*x);
          pgn^.h:=round(pgn^.h*y);
        end;
      checkgadsize(pdwn,pgn);
      pgn:=pgn^.ln_succ;
    end;
  psin:=psmallimagenode(pdwn^.imagelist.lh_head);
  while(psin^.ln_succ<>nil) do
    begin
      psin^.x:=round(psin^.x*x);
      psin^.y:=round(psin^.y*y);
      psin:=psin^.ln_succ;
    end;
  ptn:=ptextnode(pdwn^.textlist.lh_head);
  while(ptn^.ln_succ<>nil) do
    begin
      ptn^.x:=round(ptn^.x*x);
      ptn^.y:=round(ptn^.y*y);
      ptn:=ptn^.ln_succ;
    end;
  pbbn:=pbevelboxnode(pdwn^.bevelboxlist.lh_head);
  while(pbbn^.ln_succ<>nil) do
    begin
      pbbn^.x:=round(pbbn^.x*x);
      pbbn^.y:=round(pbbn^.y*y);
      pbbn^.w:=round(pbbn^.w*x);
      pbbn^.h:=round(pbbn^.h*y);
      pbbn:=pbbn^.ln_succ;
    end;
  pdwn^.w:=round(x*pdwn^.w);
  pdwn^.h:=round(y*pdwn^.h);
  if pdwn^.innerw<>0 then
    pdwn^.innerw:=round(x*pdwn^.innerw);
  if pdwn^.innerh>0 then
    pdwn^.innerh:=round(y*pdwn^.innerh);
end;

procedure handleoptionswindow(messcopy : tintuimessage);
var
  pgsel      : pgadget;
  psin       : psmallimagenode;
  class      : long;
  code       : word;
  count      : long;
  goforit    : boolean;
  dummy      : long;
  go         : boolean;
  pdwn       : pdesignerwindownode;
  skipone    : boolean;
  pgn        : pgadgetnode;
  pgn2       : pgadgetnode;
  MenuNumber : word;
  ItemNumber : Word;
  pbbn       : pbevelboxnode;
  st         : string;
  Item       : pMenuItem;
  pwn        : pwindownode;
  pin        : pimagenode;
  up         : boolean;
  tags       : array[1..7] of ttagitem;
  oldscrfontwidth : word;
  oldscrfontheight : word;
  dummyn     : word;
begin
  dummyn:=65535;
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  if (class=idcmp_closewindow) and (inputmode=0) then
    closeeditscreenforwindow(pdwn);
  if class=idcmp_refreshwindow then
    begin
      gt_beginrefresh(pdwn^.optionswindow);
      rendoptionswindow(pdwn);
      gt_endrefresh(pdwn^.optionswindow,true);
    end;
  if class=idcmp_gadgetup then
    if inputmode=1 then
      begin
        gt_setsinglegadgetattr(pdwn^.optionswingads[37],pdwn^.optionswindow,
                                gtcy_active,pdwn^.alignselect);
        gt_setsinglegadgetattr(pdwn^.spreadcyclegad,pdwn^.optionswindow,
                                gtcy_active,pdwn^.spreadpos);
      end;
  if class=idcmp_gadgetup then
    dummyn:=pgsel^.gadgetid;
  if class=idcmp_vanillakey then
    begin
      case upcase(chr(code)) of
        'D' : dummyn:=32;
        'C' : dummyn:=33;
        'S' : dummyn:=34;
        'M' : dummyn:=35;
        'A' : dummyn:=36;
        'X','Y' : 
            if inputmode=0 then
              begin
                if upcase(chr(code))='X' then
                  pdwn^.spreadpos:=0
                 else
                  pdwn^.spreadpos:=1;
                gt_setsinglegadgetattr(pdwn^.spreadcyclegad,pdwn^.optionswindow,
                                       gtcy_active,pdwn^.spreadpos);
              end;
        'Z' : dummyn:=28;
        'I' : dummyn:=29;
        'H' : dummyn:=31;
        'O' : dummyn:=30;
        'E' : dummyn:=26;
        'T' : dummyn:=27;
        'P' : dummyn:=60;
        'F' : if pdwn^.editwindow<>nil then
                windowtofront(pdwn^.editwindow);
        'B' : if pdwn^.editwindow<>nil then
                windowtoback(pdwn^.editwindow);
       end;
    end;
    
    if inputmode=0 then
      case dummyn of
        23 : begin
               changegaddybitty(pdwn,12);
               OpenBevelWindow(pdwn);
             end;
        25 : begin
               changegaddybitty(pdwn,14);
               opentextlistwindow(pdwn);
             end;
        26 : begin
               oldscrfontwidth:=pdwn^.editscreen^.rastport.font^.tf_xsize;
               oldscrfontheight:=pdwn^.editscreen^.rastport.font^.tf_ysize;
               if screenrequester(pdwn^.editscreen,@pdwn^.screenprefs) then
                 begin
                   closeeditscreenforwindow(pdwn);
                   if openscreentoeditwindow(pdwn,0) then
                     begin
                       if pdwn^.codeoptions[17] then
                         { *** scale gads *** }
                         begin
                           scalegads(pdwn,(pdwn^.editscreen^.rastport.font^.tf_xsize/oldscrfontwidth),
                                          (pdwn^.editscreen^.rastport.font^.tf_ysize/oldscrfontheight));
                           pdwn^.fontx:=pdwn^.editscreen^.rastport.font^.tf_xsize;
                           pdwn^.fonty:=pdwn^.editscreen^.rastport.font^.tf_ysize;
                         end;
                       if openoptionswindow(pdwn) then
                         begin                                                                              
                           if not openeditwindow(pdwn) then
                             closeeditscreenforwindow(pdwn)
                         end
                        else
                         begin
                           telluser(mainwindow,'Unable to open backdrop window');
                           closeeditscreenforwindow(pdwn);
                         end;
                     end;
                 end;
             end;
        27 : opentagswindow(pdwn);
        28 : opensizeswindow(pdwn);
        29 : openidcmpwindow(pdwn);
        30 : openwindowcodewindow(pdwn);
        31 : helpwindow(@pdwn^.helpwin,windowedithelp);
        32 : if pdwn^.mxchoice=12 then
               begin
                 if pdwn^.bevelselected<>~0 then
                   begin
                     if pdwn^.bevelwindow<>nil then
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                              gtlv_labels,~0);
                     pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                     remove(pnode(pbbn));
                     freemymem(pbbn,sizeof(tbevelboxnode));
                     if pdwn^.bevelwindow<>nil then
                       gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                              gtlv_labels,long(@pdwn^.bevelboxlist));
                     
                     if sizeoflist(@pdwn^.bevelboxlist)>0 then
                       begin
                         if pdwn^.bevelselected>0 then
                           dec(pdwn^.bevelselected);
                       end
                      else
                       pdwn^.bevelselected:=~0;
                     
                     if pdwn^.bevelwindow<>nil then
                       begin
                         gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                                gtlv_selected,long(pdwn^.bevelselected));
                         if pdwn^.bevelselected<>~0 then
                           begin
                             pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                             gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                                    gtmx_active,pbbn^.beveltype);
                           end;
                       end;
                     
                     updateeditwindow:=true;
                   end;
               end
              else
             begin
               { delete gadgets }
               goforit:=false;
               go:=true;
               pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
               while pgn^.ln_succ<>nil do
                 begin
                   pbbn:=pbevelboxnode(pgn^.ln_succ);
                   if pgn^.high then
                     begin
                       if (not goforit) and prefsvalues[6] then
                         begin
                           go:=areyousure(pdwn^.optionswindow,'Delete Gadgets ?'#0);
                           goforit:=true;
                         end;
                       if go then
                         begin
                           remove(pnode(pgn));
                           freegadgetnode(pdwn,pgn);
                           updateeditwindow:=true;
                         end;
                     end;
                   pgn:=pgadgetnode(pbbn);
                 end;
               fixgadgetnumbers(pdwn);
             end;
        
        {*   clone selected gadgets    *}
        
        33 : if pdwn^.mxchoice<>12 then
             begin
               waiteverything;
               count:=0;
               pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
               while pgn^.ln_succ<>nil do
                 begin
                   skipone:=false;
                   if (pgn^.joined)and(pgn^.kind=string_kind) then
                     skipone:=true;
                   goforit:=false;
                   pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                   if (pgn2<>nil)and(pgn^.kind=listview_kind) then
                     if pgn2^.high and (not pgn^.high) then
                       goforit:=true;
                   if ((pgn^.high)and (not skipone))or goforit then
                     begin
                       if count=0 then
                         begin
                           minx:=pgn^.x;
                           miny:=pgn^.y;
                           maxx:=pgn^.x+pgn^.w-1;
                           maxy:=pgn^.y+pgn^.h-1;
                         end
                        else
                         begin
                           if pgn^.y<miny then miny:=pgn^.y;
                           if pgn^.x<minx then minx:=pgn^.x;
                           if pgn^.y+pgn^.h>maxy then maxy:=pgn^.y+pgn^.h-1;
                           if pgn^.x+pgn^.w>maxx then maxx:=pgn^.x+pgn^.w-1;
                         end;
                       inc(count);
                     end;
                   pgn:=pgn^.ln_succ;
                 end;
               unwaiteverything;
               if count>0 then
                 begin
                   inputmode:=4;
                   box[1]:=minx;
                   box[2]:=miny;
                   box[3]:=maxx+box[1]-minx;
                   box[4]:=maxy+box[2]-miny;
                   setinputglist(pdwn);
                   drawbox(pdwn);
                   windowtofront(pdwn^.editwindow);
                   activatewindow(pdwn^.editwindow);
                 end;
             end;
        
        {* Size a gadget if sizeable *}
        
        34 : if pdwn^.mxchoice=12 then
               begin
                 if pdwn^.bevelselected<>~0 then
                   begin
                     pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                     inputmode:=102;
                     setinputglist(pdwn);
                     box[1]:=pbbn^.x;
                     box[2]:=pbbn^.y;
                     box[3]:=box[1]+pbbn^.w-1;
                     box[4]:=box[2]+pbbn^.h-1;
                     drawbox(pdwn);
                     windowtofront(pdwn^.editwindow);
                     activatewindow(pdwn^.editwindow);
                   end;
               end
              else
             
             begin
               pgn2:=nil;
               pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
               while (pgn^.ln_succ<>nil) do
                 begin
                   pgn^.quicksize:=false;
                   if pgn^.high then
                     if (pgn^.kind=button_kind) or
                        (pgn^.kind=string_kind) or
                        ((pgn^.kind=checkbox_kind) and (boolean(pgn^.tags[5].ti_data))) or
                        ((pgn^.kind=mx_kind) and (boolean(pgn^.tags[6].ti_data))) or
                        (pgn^.kind=integer_kind) or
                        (pgn^.kind=cycle_kind) or
                        (pgn^.kind=slider_kind) or
                        (pgn^.kind=scroller_kind) or
                        (pgn^.kind=listview_kind) or
                        (pgn^.kind=palette_kind) or
                        (pgn^.kind=mybool_kind) or
                        (pgn^.kind=text_kind) or
                        (pgn^.kind=number_kind) or
                        (pgn^.kind=myobject_kind) then
                       begin
                         if pgn2=nil then
                           begin
                             pgn2:=pgn;
                             minx:=pgn^.x;
                             miny:=pgn^.y;
                           end
                          else
                           begin
                             if pgn^.x<minx then
                               begin
                                 minx:=pgn^.x;
                                 pgn2:=pgn;
                               end
                              else
                               if pgn^.x=minx then
                                 begin
                                   if pgn^.y<miny then
                                     begin
                                       miny:=pgn^.y;
                                       pgn2:=pgn;
                                     end;
                                 end;
                           end;
                         pgn^.quicksize:=true;
                       end;
                   pgn:=pgn^.ln_succ;
                 end;
               if pgn2<>nil then
                 begin
                   pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                   while(pgn^.ln_succ<>nil) do
                     begin
                       if (pgn^.joined) and (pgn^.quicksize) and (pgn^.kind=string_kind) then
                         begin
                           pgn^.quicksize:=false;
                           pgn2:=pgadgetnode(pgn^.pointers[1]);
                           pgn2^.quicksize:=true;
                         end;
                       pgn:=pgn^.ln_succ;
                     end;
                   
                   sgad:=pgn2;
                   inputmode:=6;
                   
                   setinputglist(pdwn);
                   box[1]:=pgn2^.x;
                   box[2]:=pgn2^.y;
                   box[3]:=box[1]+pgn2^.w-1;
                   box[4]:=box[2]+pgn2^.h-1;
                   drawbox(pdwn);
                   multiplesizedraw(pdwn);  
                   { drawothers }
                   
                   windowtofront(pdwn^.editwindow);
                   
                   activatewindow(pdwn^.editwindow);
                 end;
             end;
        
        {* same as 4 *}
        
        35 : if pdwn^.mxchoice=12 then
               begin
                 if pdwn^.bevelselected<>~0 then
                 
                 begin
                 pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                 maxx:=pbbn^.x+pbbn^.w-1;
                 minx:=pbbn^.x;
                 maxy:=pbbn^.h+pbbn^.y-1;
                 miny:=pbbn^.y;
                 box[1]:=minx;
                 box[3]:=maxx-minx+box[1];
                 box[2]:=miny;
                 box[4]:=maxy-miny+box[2];
                 inputmode:=101;
                 setinputglist(pdwn);
                 WindowToFront(pdwn^.editWindow);
                 activatewindow(pdwn^.editwindow);
                 drawbox(pdwn);
                 end;
                 
               end
              else
             begin
               waiteverything;
               count:=0;
               pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
               while pgn^.ln_succ<>nil do
                 begin
                   skipone:=false;
                   if (pgn^.joined)and(pgn^.kind=string_kind) then
                     skipone:=true;
                   goforit:=false;
                   pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                   if (pgn2<>nil)and(pgn^.kind=listview_kind) then
                     if pgn2^.high and (not pgn^.high) then
                       goforit:=true;
                   if ((pgn^.high)and (not skipone))or goforit then
                     begin
                       if count=0 then
                         begin
                           minx:=pgn^.x;
                           miny:=pgn^.y;
                           maxx:=pgn^.x+pgn^.w-1;
                           maxy:=pgn^.y+pgn^.h-1;
                         end
                        else
                         begin
                           if pgn^.y<miny then miny:=pgn^.y;
                           if pgn^.x<minx then minx:=pgn^.x;
                           if pgn^.y+pgn^.h>maxy then maxy:=pgn^.y+pgn^.h-1;
                           if pgn^.x+pgn^.w>maxx then maxx:=pgn^.x+pgn^.w-1;
                         end;
                       inc(count);
                     end;
                   pgn:=pgn^.ln_succ;
                 end;
               unwaiteverything;
               if count>0 then
                 begin
                   inputmode:=5;
                   box[1]:=minx;
                   box[2]:=miny;
                   box[3]:=maxx+box[1]-minx;
                   box[4]:=maxy+box[2]-miny;
                   drawbox(pdwn);
                   windowtofront(pdwn^.editwindow);
                   activatewindow(pdwn^.editwindow);
                   setinputglist(pdwn);
                 end;
             end;
        
        {*    Alignment of selected gadgets    *}
        
        36 : if pdwn^.mxchoice<>12 then
             begin
               box[1]:=0;
               pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
               while (pgn^.ln_succ<>nil) do
                 begin
                   if pgn^.high then
                     inc(box[1]);
                   pgn:=pgn^.ln_succ;
                 end;
               if box[1]>0 then
                 begin
                   case pdwn^.alignselect of
                     0,1 : begin
                             box[1]:=0;
                             box[2]:=0;
                             box[3]:=1;
                             box[4]:=pdwn^.h;
                             inputmode:=7;
                           end;
                     2,3 : begin
                             box[1]:=0;
                             box[2]:=0;
                             box[3]:=pdwn^.w;
                             box[4]:=1;
                             inputmode:=8;
                           end;
                    end;
                   setinputglist(pdwn);
                   windowtofront(pdwn^.editwindow);
                   activatewindow(pdwn^.editwindow);
                   drawbox(pdwn);
                 end;
             end;
        37 : pdwn^.alignselect:=code;
        39 : begin
               changegaddybitty(pdwn,28);
               openimagelistwindow(pdwn);
             end;
        61 : pdwn^.spreadpos:=code;
        60 : if pdwn^.mxchoice<>12 then
               begin
                 pdwn^.spreadsize:=getintegerfromgad(pdwn^.spreadsizegad);
                 spreadhighgadgets(pdwn);
                 updateeditwindow:=true;
               end;
       end;
  if class=idcmp_gadgetdown then
    case pgsel^.gadgetid of
      10..22,24,40,38,41,42,43
           : begin
               if inputmode=0 then
                 begin
                   if pgsel^.gadgetid-10<>pdwn^.mxchoice then
                     begin
                       changegaddybitty(pdwn,pgsel^.gadgetid-10);
                       if pgsel^.gadgetid=41 then
                         begin
                           pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                           while(pgn^.ln_succ<>nil) do
                             begin
                               if pgn^.high then
                                 begin
                                   pgn^.high:=false;
                                   highlightgadget(pgn,pdwn);
                                 end;
                               pgn:=pgn^.ln_succ;
                             end;
                         end;
                     end;
                 end;
             end;
     end;
     
  if (class=idcmp_menupick)and(inputmode=0) then
    begin
      ItemNumber:=ITEMNUM(code);
      MenuNumber:=MENUNUM(code);
      Case MenuNumber of
        Editwindowopts :
          Case ItemNumber of
            editwindowopts_item11 :
              updateeditwindow:=true;
            Editwindowoptssizes :
              opensizeswindow(pdwn);
            editwindowopts_magnify :
              startmagnifywindow(pdwn);
            Editwindowoptstags :
              opentagswindow(pdwn);
            editwindowoptsscrfont,Editwindowoptsscreen :
              begin
                go:=false;
                if itemnumber=editwindowoptsscreen then
                  go:=screenrequester(pdwn^.editscreen,@pdwn^.screenprefs)
                 else
                  begin
                    waiteverything;
                    inputmode:=1;
                    settagitem(@tags[1],asl_window,long(pdwn^.editwindow));
                    if pdwn^.screenprefs.changed then
                      begin
                        settagitem(@tags[2],asl_fontname,long(@pdwn^.screenprefs.fontname[1]));
                        settagitem(@tags[3],asl_fontheight,long(pdwn^.screenprefs.font.ta_ysize));
                        settagitem(@tags[4],asl_fontstyles,long(pdwn^.screenprefs.font.ta_style));
                        settagitem(@tags[5],asl_fontflags,long(pdwn^.screenprefs.font.ta_flags));
                        settagitem(@tags[6],tag_done,0);
                      end
                     else
                      begin
                        settagitem(@tags[2],tag_done,0);
                      end;
                    if (aslrequest(fontrequest,@tags[1])) then
                      begin
                        pfr:=pfontrequester(fontrequest);
                        pdwn^.screenprefs.font.ta_ysize:=pfr^.fo_attr.ta_ysize;
                        pdwn^.screenprefs.font.ta_style:=pfr^.fo_attr.ta_style;
                        pdwn^.screenprefs.font.ta_flags:=pfr^.fo_attr.ta_flags;
                        ctopas(pfr^.fo_attr.ta_name^,st);
                        if length(st)>44 then
                          st:=copy(st,1,44);
                        pdwn^.screenprefs.fontname:=st+#0;
                        pdwn^.screenprefs.changed:=true;
                        go:=true;
                      end;
                    unwaiteverything;
                  end;
                if go then
                  begin
                    oldscrfontwidth:=pdwn^.editscreen^.rastport.font^.tf_xsize;
                    oldscrfontheight:=pdwn^.editscreen^.rastport.font^.tf_ysize;
                    closeeditscreenforwindow(pdwn);
                    if openscreentoeditwindow(pdwn,0) then
                      begin
                        if pdwn^.codeoptions[17] then
                          begin
                            { *** scale gads *** }
                            scalegads(pdwn,(pdwn^.editscreen^.rastport.font^.tf_xsize/oldscrfontwidth),
                                         (pdwn^.editscreen^.rastport.font^.tf_ysize/oldscrfontheight));
                            pdwn^.fontx:=pdwn^.editscreen^.rastport.font^.tf_xsize;
                            pdwn^.fonty:=pdwn^.editscreen^.rastport.font^.tf_ysize;
                          end;
                        if openoptionswindow(pdwn) then
                          begin                                                                              
                            if not openeditwindow(pdwn) then
                              closeeditscreenforwindow(pdwn);
                          end
                         else
                          begin
                            telluser(mainwindow,'Unable to open backdrop window');
                            closeeditscreenforwindow(pdwn);
                          end;
                      end;
                 end;
              end;
            Editwindowoptsidcmp :
              openidcmpwindow(pdwn);
            Editwindowoptscode :
               openwindowcodewindow(pdwn);
            Editwindowoptshelp :
              helpwindow(@pdwn^.helpwin,windowedithelp);
            Editwindowoptsexit :
              closeeditscreenforwindow(pdwn);
           end;
        EditWinMenugadgets :
          Case ItemNumber of
            EditWinMenugadgetsglist :
              Begin
                openeditgadgetlist(pdwn);
              end;
            EditWinMenugadgetshighall,EditWinMenugadgetshighnone :
              Begin
                pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                while(pgn^.ln_succ<>nil) do
                  begin
                    up:=false;
                    if (itemnumber=EditWinMenugadgetshighall) then
                      up:=true;
                    if not ((pgn^.kind=string_kind) and pgn^.joined) then
                      if (up and (not pgn^.high)) or ((not up) and pgn^.high) then
                        highlightgadget(pgn,pdwn);
                    pgn^.high:=up;
                    pgn:=pgn^.ln_succ;
                  end;
              end;
            EditWinMenugadgetsedithigh :
              Begin
                pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                while(pgn^.ln_succ<>nil) do
                  begin
                    if pgn^.high then
                      openeditgadget(pdwn,pgn);
                    pgn:=pgn^.ln_succ;
                  end;
              end;
           end;
       end
    end;
end;

procedure handlesizeswindow(messcopy : tintuimessage);
var
  pgsel      : pgadget;
  psin       : psmallimagenode;
  class      : long;
  code       : word;
  dummy      : long;
  pdwn       : pdesignerwindownode;
  MenuNumber : word;
  ItemNumber : Word;
  SubNumber  : Word;
  Item       : pMenuItem;
  pwn        : pwindownode;
  pin        : pimagenode;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pdwn:=pdesignerwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=0;
  case class of
    idcmp_closewindow :
      if inputmode=0 then 
        closesizeswindow(pdwn);
    idcmp_gadgetup :
      dummy:=pgsel^.gadgetid;
    idcmp_vanillakey :
      case upcase(chr(code)) of
        'H' : dummy:=16;
        'O' : dummy:=15;
        'C' : dummy:=17;
        'U' : dummy:=18;
       end;
    idcmp_menupick :
       begin
          ItemNumber:=ITEMNUM(code);
          MenuNumber:=MENUNUM(code);
          Case MenuNumber of
            WinsizesOptions :
              Case ItemNumber of
                winsizesoptionsupdate :
                  dummy:=18;
                WinsizesOptionshelp :
                  dummy:=16;
                WinsizesOptionsok :
                  dummy:=15;
                WinsizesOptionscancel :
                  dummy:=17;
               end;
           end;
       end;
   end; 
  if inputmode=0 then
    case dummy of
      15,18 : begin
                pdwn^.maxw:=getintegerfromgad(pdwn^.sizesgads[1]);
                pdwn^.maxh:=getintegerfromgad(pdwn^.sizesgads[2]);
                pdwn^.minw:=getintegerfromgad(pdwn^.sizesgads[3]);
                pdwn^.minh:=getintegerfromgad(pdwn^.sizesgads[4]);
                pdwn^.zoom[1]:=getintegerfromgad(pdwn^.sizesgads[5]);
                pdwn^.zoom[2]:=getintegerfromgad(pdwn^.sizesgads[6]);
                pdwn^.zoom[3]:=getintegerfromgad(pdwn^.sizesgads[7]);
                pdwn^.zoom[4]:=getintegerfromgad(pdwn^.sizesgads[8]);
                pdwn^.x:=getintegerfromgad(pdwn^.sizesgads[9]);
                pdwn^.y:=getintegerfromgad(pdwn^.sizesgads[10]);
                pdwn^.w:=getintegerfromgad(pdwn^.sizesgads[11])-pdwn^.offx;
                pdwn^.h:=getintegerfromgad(pdwn^.sizesgads[12])-pdwn^.offy;
                pdwn^.innerw:=getintegerfromgad(pdwn^.sizesgads[13]);
                pdwn^.innerh:=getintegerfromgad(pdwn^.sizesgads[14]);
              end;
     end;
  if inputmode=0 then
    case dummy of
      15 : begin
             closesizeswindow(pdwn);
             dummy:=35;
           end;
      16 : helpwindow(@pdwn^.helpwin,windowsizehelp);
      17 : closesizeswindow(pdwn);
      18 : begin
             dummy:=35;
           end;
     end;
   if dummy=35 then
     begin
       if pdwn^.innerw<>0 then
         begin
           if pdwn^.innerw+pdwn^.editwindow^.borderleft+pdwn^.editwindow^.borderright<
              pdwn^.minw then
             pdwn^.innerw:=pdwn^.minw-pdwn^.editwindow^.borderleft-pdwn^.editwindow^.borderright;
           if pdwn^.innerw>
               pdwn^.maxw-pdwn^.editwindow^.borderleft-pdwn^.editwindow^.borderright then
             pdwn^.innerw:=pdwn^.maxw-pdwn^.editwindow^.borderleft-pdwn^.editwindow^.borderright;
         end;
       if pdwn^.innerh<>0 then
         begin
           if pdwn^.innerh+pdwn^.editwindow^.bordertop+pdwn^.editwindow^.borderbottom<
              pdwn^.minh then
             pdwn^.innerh:=pdwn^.minh-pdwn^.editwindow^.bordertop-pdwn^.editwindow^.borderbottom;
           if pdwn^.innerh+pdwn^.editwindow^.bordertop+pdwn^.editwindow^.borderbottom>
              pdwn^.maxh then
             pdwn^.innerh:=pdwn^.maxh-pdwn^.editwindow^.bordertop-pdwn^.editwindow^.borderbottom;
         end;
       closeopeneditwindow(pdwn);
     end;
end;

procedure writeregistereduser;
var
  filename : string;
  filelock : bptr;
  data     : pbytearray;
  finished : boolean;
  amountread:long;
  last:long;
  allok : boolean;
  loop,loop2:long;
  good:boolean;
begin
  filename:=paramstr(0)+#0;
  filelock:=open(@filename[1],mode_oldfile);
  if filelock<>0 then
    begin
      data:=pbytearray(allocmymem(50000,memf_any));
      if data<>nil then
        begin
          finished:=false;
          repeat
            amountread:=read_(filelock,data,50000);
            if amountread=-1 then
              begin
                finished:=true;
                telluser(mainwindow,'File error.');
              end;
            if amountread>90 then
              begin
                for loop:=0 to amountread-90 do
                  begin
                    if data^[loop]=byte(crypt1[1]) then
                      begin
                        good:=true;
                        for loop2:=2 to 40 do
                          if good then
                            begin
                              good:=(crypt1[loop2]=char(data^[loop+loop2-1]));
                            end;
                        if good and (not finished) then
                          begin
                            if seek_(filelock,loop+41-amountread,offset_current)<>-1 then
                              begin
                                if 0=write_(filelock,@registerstore[0],42) then;
                                
                                gt_setsinglegadgetattr(upgradegad,mainwindow,
                                                       ga_disabled,long(true));
                                telluser(mainwindow,'Designer executable modified for registered user.');
                              end
                             else
                              telluser(mainwindow,'File could not be modified correnctly,'#10+
                                       ' very odd, installation failed.');
                            finished:=true;
                          end;
                      end;
                  end;
              end;
            if seek_(filelock,-100,offset_current)=0 then;
            if (last=100) and(amountread=100) then
              finished:=true;
            last:=amountread;
          until finished or (amountread=0);
          freemymem(data,50000);
        end
       else
        begin
          allok:=true;
          telluser(mainwindow,memerror);
        end;
      if close_(filelock) then;
    end
   else
    telluser(mainwindow,'Cannot open file.');
                              
end;

procedure handleupgradewin;
const
  getdesfile : string[30]='Select Registered Designer'#0;
  patgad     : string[9]='Designer'#0;
var
  tags:array[1..10] of ttagitem;
  com1       : string;
  fr         : pfilerequester;
  filename   : string;
  filelock   : bptr;
  data       : pbytearray;
  amountread : long;
  finished   : boolean;
  loop       : long;
  good       : boolean;
  loop2      : long;
  last       : long;
  tempregisterstring : string;
  tempregisterstring2 : string;
  allok : boolean;
  loop4 : word;
begin
  messagedone:=false;
  allok:=false;
  waiteverything;
  
  settagitem(@tags[1],asl_hail,long(@getdesfile[1]));
  settagitem(@tags[2],asl_funcflags,filf_patgad);
  settagitem(@tags[3],asl_pattern,long(@patgad[1]));
  settagitem(@tags[4],tag_done,0);
  fr:=pfilerequester(allocaslrequest(asl_filerequest,@tags[1]));
  if fr<>nil then
    begin
      if aslrequest(pointer(fr),nil) then
        begin
          ctopas(fr^.fr_drawer^,filename);
          filename:=filename+#0;
          if addpart(@filename[1],pointer(fr^.fr_file),254) then
            begin
              filelock:=open(@filename[1],mode_oldfile);
              if filelock<>0 then
                begin
                  data:=pbytearray(allocmymem(50000,memf_any));
                  if data<>nil then
                    begin
                      finished:=false;
                      repeat
                        amountread:=read_(filelock,data,50000);
                        if amountread=-1 then
                          begin
                            finished:=true;
                            telluser(mainwindow,'File error.');
                          end;
                        if amountread>90 then
                          begin
                            for loop:=0 to amountread-90 do
                              begin
                                if data^[loop]=byte(crypt1[1]) then
                                  begin
                                    good:=true;
                                    for loop2:=2 to 40 do
                                      if good then
                                        begin
                                          good:=(crypt1[loop2]=char(data^[loop+loop2-1]));
                                        end;
                                    if good and (not finished) then
                                      begin
                                        copymem(@data^[loop+41],@tempregisterstring[0],42);
                                        copymem(@registerstore[0],@tempregisterstring2[0],42);
                                        copymem(@tempregisterstring[0],@registerstore[0],42);
                                        if checkprotection then
                                          begin
                                            allok:=true;
                                            if demoversion then
                                              telluser(mainwindow,'Close, but it needs to be a registered version, '+
                                                       'not the Demo.')
                                             else
                                              begin
                                                if AreYouSure(mainwindow,
                                                      'Registration confirmed, all features now enabled.'+#10#10+
                                                      'Do you wish to upgrade the Designer file on disk ?') then
                                                  begin
                                                    writeregistereduser;
                                                  end;
                                                  
                                              end;
                                          end
                                         else
                                          begin
                                            copymem(@tempregisterstring2[0],@registerstore[0],42);
                                          end;
                                        finished:=true;
                                      end;
                                  end;
                              end;
                          end;
                        if seek_(filelock,-100,offset_current)=0 then;
                        if (last=100) and(amountread=100) then
                          finished:=true;
                        last:=amountread;
                      until finished or (amountread=0);
                      freemymem(data,50000);
                    end
                   else
                    begin
                      allok:=true;
                      telluser(mainwindow,memerror);
                    end;
                  if close_(filelock) then;
                end
               else
                telluser(mainwindow,'Cannot open file.');
            end
           else
            telluser(mainwindow,'Error in filename.');
        end
       else
        allok:=true;
      freeaslrequest(pointer(fr));
      inputmode:=1;
    end
   else
    telluser(mainwindow,'Unable to allocate file requester.');
  
  unwaiteverything;
  if (not allok) and (not messagedone) then
    telluser(mainwindow,'File was not a registered Designer executable.');
end;


end.