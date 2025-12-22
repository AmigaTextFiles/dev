Program Designer;

uses designermenus,asl,utility,routines,exec,intuition,amiga,workbench,layers,
     loadsave,icon,diskfont,amigaguide,import,localewin,editscreenstuff,edittags,
     gadtools,graphics,dos,amigados,drawwindows,definitions,iffparse,extrawinhandling,
     magnify,gtx,nofrag,obsolete,modeid,editboopsi,colorwheel,gradientslider,loadsave2,
     savecodedefs;

const 
  winname : string [80]  = 'CON:0/0/450/50/The Designer (C) Ian OConnor 1995/AUTO/CLOSE'#0;

procedure handleprefswindow(messcopy : tintuimessage);
var
  pgsel     : pgadget;
  class     : long;
  code      : word;
  dummy     : long;
  pdwn      : pdesignerwindownode;
  Done    : Boolean;
  Item    : pMenuItem;
  pwn     : pwindownode;
  MenuNumber : Word;
  ItemNumber : Word;
  SubNumber  : Word;
  loop       : byte;
begin
  code:=messcopy.code;
  class:=messcopy.class;
  pgsel:=pgadget(messcopy.iaddress);
  pwn:=pwindownode(messcopy.idcmpwindow^.userdata);
  dummy:=9999;
  case class of
    idcmp_gadgetup :
      dummy:=pgsel^.gadgetid;
    idcmp_vanillakey :
      case upcase(chr(code)) of
        'S' : dummy:=100;
        'U' : dummy:=101;
        'C' : dummy:=102;
       end;
    idcmp_closewindow :
      dummy:=102;
    idcmp_menupick :
      begin
        MenuNumber:=MENUNUM(code);
        ItemNumber:=ITEMNUM(code);
        SubNumber:=SUBNUM(code);
        Case MenuNumber of
          PrefsControl :
            Case ItemNumber of
              PrefsSave :
                dummy:=100;
              PrefsUse :
                dummy:=101;
              PrefsCancel :
                dummy:=102;
              PrefsDefault :
                dummy:=65;
              PrefsLast :
                dummy:=82;
              prefshelpmenucode :
                begin
                  dummy:=999;
                end;
             end;
         end;
      end;
   end;
  case dummy of
    0   : defaultcompileredit:=code;
    65  : for loop:=1 to numofprefsoptions do
              gt_setsinglegadgetattr(prefsgadgets[loop],prefswindow,
                                     gtcb_checked,long(defaultprefs[loop]));
    82  : oldprefstoscreen;
    100,101 
        : if inputmode=0 then
            begin
              for code:=1 to numofprefsoptions do
                prefsvalues[code]:=checkedbox(prefsgadgets[code]);
              deflangnum:=defaultcompileredit;
              if dummy=101 then
                writeprefsvalues(1)
               else
                begin
                  writeprefsvalues(2);
                  writeprefsvalues(1);
                end;
              closeprefswindow;
            end;
    102 : if inputmode=0 then
            closeprefswindow;
    999 : if inputmode=0 then
            helpwindow(@defaulthelpwindownode,prefshelp);
   end;
end;

function dealwithparams(var filename,filedir:string):boolean;
var
  p     : string;
  d     : dirstr;
  f     : namestr;
  e     : extstr;
  arg   : pwbarg;
  start : pwbstartup;
begin
  dealwithparams:=false;
  if paramcount>0 then
    begin
      {
      if paramcount>1 then
        seterror('Only one parameter possible.');
      }
      if wbenchmsg=nil then
        begin
          p:=paramstr(1);
          fsplit(p,d,f,e);
          filedir:=d;
          if filedir<>'' then
            if (filedir[length(filedir)]<>':') and
               (filedir[length(filedir)]<>'/') then
              filedir:=filedir+'/';
          dealwithparams:=readalldata(p+#0,true);
          filename:=f+e;
        end
       else
        begin
          { workbench startup }
          start:=pwbstartup(wbenchmsg);
          arg:=start^.sm_arglist;
          arg:=pointer(long(arg)+8);
          filedir:=no0(fexpandlock(arg^.wa_lock));
          if filedir<>'' then
            if (filedir[length(filedir)]<>':') and
               (filedir[length(filedir)]<>'/') then
              filedir:=filedir+'/';
          ctopas(arg^.wa_name^,filename);
          dealwithparams:=readalldata(filedir+filename+#0,true);
        end;
    end;
end;

procedure MainProcess;
var
  ItemNumber      : word;
  SubNumber       : word;
  MenuNumber      : word;
  pwn             : pwindownode;
  dummy           : long;
  dummy2          : long;
  pgsel           : pgadget;
  mess            : pintuimessage;
  messcopy        : tintuimessage;
  class           : long;
  code            : word;
  pln             : plibnode;
  pdwn            : pdesignerwindownode;
  pbbn            : pbevelboxnode;
  pgn,pgn2        : pgadgetnode;
  psin            : psmallimagenode;
  count           : word;
  st              : string;
  x2,y2           : long;
  x3,y3           : long;
  lo              : boolean;
  pin,pin2        : pimagenode;
  ptn,ptn2        : ptextnode;
  tags            : array[1..6] of ttagitem;
  tp              : tscreenmodeprefs;
  appmessage      : tappmessage;
  wbargarray      : pwbargarray;
  pdwn2           : pdesignerwindownode;
  skipone         : boolean;
  goforit         : boolean;
  pgn3,pgn4       : pgadgetnode;
  psn,psn2        : pstringnode;
  dummy3          : long;
  pdmn            : pdesignermenunode;
  pdwn9           : pdesignerwindownode;
  go              : boolean;
  totalsignals    : long;
  magm            : pointer;
  agm             : pamigaguidemsg;
  loop            : word;
  n               : pnode;
  comstr          : string;
  pdsn,pdsn2      : pdesignerscreennode;
  pos             : long;
  pmt,pmt2        : pmytag;
  curpos          : long;
  
begin
  filename:='';
  filedir:='';
  saved:=dealwithparams(filename,filedir);                                                                 
  {
  if demoversion then
     begin
       telluser(mainwindow,'     Designer V'+versionstring+#10#10+'  '+#169+' Ian OConnor 1994'+#10#10+
                'Demonstration version,'#10+
                'save partially disabled'#10#10+'To register see ReadMe');
     end
   else
  }
    if prefsvalues[1] or demoversion then
      openabout;
  
  done:=not imrun;
  inputmode:=1;
  unwaiteverything;
  repeat
    
    totalsignals:=bitmask(myprogramport^.mp_sigbit);
    if aboutwin<>nil then
      totalsignals:=totalsignals or bitmask(aboutwin^.userport^.mp_sigbit);
    
    {
    if upgradewin<>nil then
      totalsignals:=totalsignals or bitmask(upgradewin^.userport^.mp_sigbit);
    }
    
    if amigaguidehandle<>nil then
      totalsignals:=totalsignals or amigaguidesig;
    dummy:=wait(totalsignals);
    if amigaguidehandle<>nil then
      begin
        magm:=pointer(getamigaguidemsg(amigaguidehandle));
        while (magm<>nil) do
          begin
            agm:=pamigaguidemsg(magm);
            dummy:=agm^.agm_type;
            replyamigaguidemsg(amigaguidehandle);
            if dummy=StartupMsgID then
              begin
                comstr:='link '+helptextpos[setamigaguidenum];
                if sendamigaguidecmdA(amigaguidehandle,strptr(@comstr[1]),nil) then;
              end;
            if dummy=ActiveToolID then
              begin
                comstr:='link '+helptextpos[setamigaguidenum];
                if sendamigaguidecmdA(amigaguidehandle,strptr(@comstr[1]),nil) then;
              end;
            magm:=pointer(getamigaguidemsg(amigaguidehandle));
          end;    
      end;
    
    
    {
    if upgradewin<>nil then
      begin
        mess:=gt_getimsg(upgradewin^.userport);
        while mess<>nil do
          begin
            class:=mess^.class;
            code:=mess^.code;
            pgsel:=pgadget(mess^.iaddress);
            gt_replyimsg(mess);
            case class of
              idcmp_closewindow : closewindowupgradewin;
              idcmp_gadgetup : handleupgrade(pgsel^.gadgetid);
             end;
            if upgradewin<>nil then 
              mess:=gt_getimsg(upgradewin^.userport)
             else
              mess:=nil;
          end;
      end;
    }
    
    if aboutwin<>nil then
      begin
        mess:=pintuimessage(getmsg(aboutwin^.userport));
        if mess<>nil then
          begin
            freesysrequest(aboutwin);
            aboutwin:=nil;
          end;
      end;
    mess:=gt_getimsg(mainwindow^.userport);
    while mess<>nil do
      begin
        pgsel:=pgadget(mess^.iaddress);
        class:=mess^.class;
        code:=mess^.code;
        copymem(mess,@messcopy,sizeof(tintuimessage));
        pwn:=pwindownode(mess^.idcmpwindow^.userdata);
        gt_replyimsg(mess);
        if errorstring<>'' then
          if messcopy.seconds-errorstartseconds>7 then
            begin
              clearerror;
              errorstring:='';
            end;

{*******************************************}
{*                                         *}
{*           Edit Screen Handling          *}
{*                                         *}
{*******************************************}
        
        if pwn^.ln_type=screennodetype then
          handlescreennode(pdesignerscreennode(pwn),messcopy);
        
{*******************************************}
{*                                         *}
{*        Refresh Window Handling          *}
{*                                         *}
{*******************************************}

        if class=idcmp_refreshwindow then 
          begin
            dummy:=0;
            pdwn:=pdesignerwindownode(teditwindowlist.lh_head);
            if messcopy.idcmpwindow<>nil then
              while(pdwn^.ln_succ<>nil) do
                begin
                  if messcopy.idcmpwindow=pdwn^.editwindow then
                    begin
                      dummy:=1;
                    end;
                  pdwn:=pdwn^.ln_succ;
                end;
            if dummy=0 then
              begin
                gt_beginrefresh(messcopy.idcmpwindow);
                if messcopy.idcmpwindow=mainwindow then
                  rendmainwindow;
                gt_endrefresh(messcopy.idcmpwindow,true);
              end;
          end;
        
{*******************************************}
{*                                         *}
{*          Main Window Handling           *}
{*                                         *}
{*******************************************}
        
        if messcopy.idcmpwindow=mainwindow then
          handlemainwindow(messcopy);
        
{*******************************************}
{*                                         *}
{*       Main Code Window Handling         *}
{*                                         *}
{*******************************************}

        if pwn^.ln_type=maincodewindownodetype then
          maincodeinputhandler(messcopy);

{*******************************************}
{*                                         *}
{*          Prefs Window Handling          *}
{*                                         *}
{*******************************************}

        if pwn^.ln_type=prefswindownodetype then
          handleprefswindow(messcopy);

{*******************************************}
{*                                         *}
{*         Menu Window Handling            *}
{*                                         *}
{*******************************************}

        if pwn^.ln_type=menunodetype then
          editmenuhandling(messcopy);

{*******************************************}
{*                                         *}
{*          Image Window Handling          *}
{*                                         *}
{*******************************************}

        if pwn^.ln_type=imagenodetype then
          handledisplayimagewindow(messcopy);

{*******************************************}
{*                                         *}
{*          Lib Window Handling            *}
{*                                         *}
{*******************************************}

        if messcopy.idcmpwindow=libwindow then
          handlelibrarywindow(messcopy);

{*******************************************}
{*                                         *}
{*      Edit Tags Window Handling          *}
{*                                         *}
{*******************************************}

        if messcopy.idcmpwindow=edittagswindow then
          processwindowedittagswindow(messcopy.class,messcopy.code,messcopy.iaddress);

{*******************************************}
{*                                         *}
{*        Locale Window Handling           *}
{*                                         *}
{*******************************************}

        if messcopy.idcmpwindow=localewindow then
          handlelocalewindow(messcopy);

{*******************************************}
{*                                         *}
{*          Draw Coords On Edit Window     *}
{*                                         *}
{*******************************************}

        if pwn^.ln_type=designerwindownodetype then
          begin
            pdwn:=pdesignerwindownode(pwn);
            messcopy.mousex:=messcopy.mousex-pdwn^.offx;
            messcopy.mousey:=messcopy.mousey-pdwn^.offy;
            if pdwn^.magnifywindow<>nil then
              begin
                if pdwn^.magnifymode=1 then
                  begin
                    pdwn^.mx:=pdwn^.editscreen^.mousex;
                    pdwn^.my:=pdwn^.editscreen^.mousey;
                    
                    if pdwn^.mx >= trunc(pdwn^.magwidth/2) then
                      pdwn^.srcx:=pdwn^.mx-trunc(pdwn^.magwidth/2)
                     else
                      pdwn^.srcx:=0;
                    if pdwn^.my >= trunc(pdwn^.magheight/2) then
                      pdwn^.srcy:=pdwn^.my-trunc(pdwn^.magheight/2)
                     else
                      pdwn^.srcy:=0;
                    if (pdwn^.mx>=0) and
                       (pdwn^.my>=0) then
                      updatemagnifywindow(pdwn);
                  end;
              end;
            if pdwn^.gimmezz then
              begin
                dec(messcopy.mousex,pdwn^.editwindow^.borderleft);
                dec(messcopy.mousey,pdwn^.editwindow^.bordertop);
              end;
            if (pdwn^.usecoordswindow) and
               (messcopy.idcmpwindow=pdwn^.editwindow) then
              begin
                if (inputmode=0)or(inputmode=157) then
                  begin
                    x2:=messcopy.mousex;
                    y2:=messcopy.mousey;
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' Y:';
                    str(y2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                  end;
                if (inputmode=5)or(inputmode=4)or(inputmode=101) then
                  begin
                    x2:=box[1];
                    y2:=box[2];
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' Y:';
                    str(y2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                  end;
                if (inputmode=2)or(inputmode=6)or(inputmode=102) then
                  begin
                    x2:=box[1];
                    y2:=box[2];
                    x3:=box[3]-box[1]+1;
                    y3:=box[4]-box[2]+1;
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' Y:';
                    str(y2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                    pdwn^.coordstitle:=pdwn^.coordstitle+'W:';
                    str(x3,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' H:';
                    str(y3,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                    
                    { delta size ?? }
                    
                  end;
                if inputmode=3 then
                  begin
                    { checkbox gad }
                    x2:=messcopy.mousex;
                    y2:=messcopy.mousey;
                    case pdwn^.mxchoice of
                      3 : begin
                            x2:=x2-13;
                            y2:=y2-6;
                          end;
                      4 : begin
                            x2:=x2-7;
                            y2:=y2-4;
                          end;
                     end;
                    if x2<0 then x2:=0;
                    if y2<0 then y2:=0;
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' Y:';
                    str(y2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                  end;
                if inputmode=7 then
                  begin
                    { left/right align}
                    x2:=box[1];
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st;
                  end;
                if inputmode=8 then
                  begin
                    { top/bottom align }
                    x2:=box[2];
                    pdwn^.coordstitle:=' Y:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st;
                  end;
                if (inputmode=17)or(inputmode=18) then
                  begin
                    { text/image placing }
                    x2:=messcopy.mousex;
                    y2:=messcopy.mousey;
                    x2:=x2-lengthtext2;
                    y2:=y2-heighttext2;
                    if x2<0 then x2:=0;
                    if y2<0 then y2:=0;
                    pdwn^.coordstitle:=' X:';
                    str(x2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' Y:';
                    str(y2,st);
                    pdwn^.coordstitle:=pdwn^.coordstitle+copy('      ',1,4-length(st))+st+' ';
                  end;
                pdwn^.coordstitle:=pdwn^.coordstitle+#0;
                if (no0(pdwn^.title)<>'') and (not pdwn^.borderless) then
                  setwindowtitles(pdwn^.editwindow,@pdwn^.coordstitle[1],pointer(long(-1)))
                 else
                  setwindowtitles(pdwn^.editwindow,pointer(long(-1)),@pdwn^.coordstitle[1]);
              end;
            
{*******************************************}
{*                                         *}
{*       Gadget Edit Window Handling       *}
{*                                         *}
{*******************************************}

            pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
            while pgn^.ln_succ<>nil do
              begin
                pgn2:=pgn^.ln_succ;
                if pgn^.editwindow<>nil then
                  if pgn^.editwindow^.pwin=messcopy.idcmpwindow then
                    gadgetwindowhandling(pgn,messcopy,pdwn);
                pgn:=pgn2;
              end;

{*******************************************}
{*                                         *}
{*          Tags Window Handling           *}
{*                                         *}
{*******************************************}

            if messcopy.idcmpwindow=pdwn^.tagswindow then
              handletagswindow(messcopy);

{*******************************************}
{*                                         *}
{*        Magnify Window Handlin           *}
{*                                         *}
{*******************************************}

            if messcopy.idcmpwindow=pdwn^.magnifywindow then
              handlemagnifywindow(messcopy);

{*******************************************}
{*                                         *}
{*            Image List Handling          *}
{*                                         *}
{*******************************************}

            if messcopy.idcmpwindow=pdwn^.imagelistwindow then
              handleimagelistwindow(messcopy);
            
{*******************************************}
{*                                         *}
{*      Window Code Window Handling        *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.codewindow then
              handlewindowcodewindow(messcopy);

{*******************************************}
{*                                         *}
{*      Window Bevel Window Handling       *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.bevelwindow then
              handlebevelwindow(messcopy);

{*******************************************}
{*                                         *}
{*    Window gadgetlist Window Handling    *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.gadgetlistwindow then
              handlegadgetlistwindow(messcopy);

{*******************************************}
{*                                         *}
{*          Options Window Handling        *}
{*                                         *}
{*******************************************}

            if messcopy.idcmpwindow=pdwn^.optionswindow then
              handleoptionswindow(messcopy);
            
{*******************************************}
{*                                         *}
{*          Edit Window Handling           *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.editwindow then
              begin
                                
                {************************************}
                {*                                  *}
                {*      Finish Editing Window       *}
                {*                                  *}
                {************************************}
                  
                if (class=idcmp_closewindow) and (inputmode=0) then
                  closeeditscreenforwindow(pdwn);
                  
                {*********************************}
                {*                               *}
                {*     New Edit Window Size      *}
                {*                               *}
                {*********************************}
                
                if (inputmode=157) and (class=idcmp_intuiticks) then
                  begin
                    drawbox(pdwn);
                    drawbitty:=not drawbitty;
                    setdrpt(pdwn^.editwindow^.rport,drawbitty);
                    drawbox(pdwn);
                  end;
                
                if class=idcmp_newsize then
                  begin
                    updatewindowsizes(pdwn);
                    
                    if pdwn^.mxchoice=12 then
                      begin
                        pos:=removeglist(pdwn^.editwindow,pdwn^.bevelglist,~0);
                        pos:=addglist(pdwn^.editwindow,pdwn^.glist,65535,~0,Nil);
                        {
                        refreshglist(pdwn^.glist,pdwn^.editwindow,nil,~0)
                        }
                      end;
                    
                    gt_beginrefresh(pdwn^.editwindow);
                    rendeditwindow(pdwn);
                    if (inputmode>1)and(inputmode<9) then
                      drawbox(pdwn);
                    gt_endrefresh(pdwn^.editwindow,true);
                    
                    refreshglist(pdwn^.glist,pdwn^.editwindow,nil,~0);
                    gt_refreshwindow(pdwn^.editwindow,nil);
                    
                    if pdwn^.mxchoice=12 then
                      begin
                        pos:=removeglist(pdwn^.editwindow,pdwn^.glist,~0);
                        pos:=addglist(pdwn^.editwindow,pdwn^.bevelglist,65535,~0,Nil);
                      end;

                    if ((inputmode>1)and(inputmode<9))or(inputmode=157) then
                      drawbox(pdwn);
                    if inputmode=7 then
                      box[4]:=pdwn^.h;
                    if inputmode=8 then
                      box[3]:=pdwn^.w;
                    if (inputmode>1)and(inputmode<9) then
                      drawbox(pdwn);
                  end;
                
                {*************************************}
                {*                                   *}
                {*     Refresh/Change Edit Window    *}
                {*                                   *}
                {*************************************}
                 
                if (class=idcmp_refreshwindow) or (class=idcmp_changewindow) then
                  begin
                    if class=idcmp_changewindow then
                      updatewindowsizes(pdwn);
                    gt_beginrefresh(pdwn^.editwindow);
                    rendeditwindow(pdwn);
                    case inputmode of
                      2..8,157 : drawbox(pdwn);
                      17   : quickputtext(pdwn);
                      18   : quickputimage(pdwn);
                     end;
                    gt_endrefresh(pdwn^.editwindow,true);
                    
                  end;
                  
                {*********************************}
                {*                               *}
                {*     Edit Window Gadget Up     *}
                {*                               *}
                {*********************************}
                
                if (class=idcmp_gadgetup) and (inputmode=0) and (pdwn^.mxchoice<>31) then
                  begin
                    pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                    while(pgn^.ln_succ<>nil)do
                      begin
                        if (pgsel^.gadgetid=pgn^.id) then
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
                            if pgn^.joined and (pgn^.kind=string_kind) then
                              begin
                                pgn2:=pgadgetnode(pgn^.pointers[1]);
                                if not pgn2^.high then
                                  highlightgadget(pgn2,pdwn);
                                pgn2^.high:=true;
                              end
                             else
                              if (pgn^.kind=listview_kind)and(pgn^.tags[3].ti_data<>0) then
                                begin
                                  pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
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
                    
                    if pdwn^.mxchoice=12 then
                      begin
                        curpos:=pgsel^.gadgetid-65000;
                        pdwn^.bevelselected:=curpos;
                        if pdwn^.bevelwindow<>nil then
                          begin
                            
                            pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                            gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                                   gtlv_selected,long (curpos) );
                            gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                                   gtmx_active,pbbn^.beveltype );
                            
                          end;
                      end;
                    
                  end;
                                                             
                {*********************************}
                {*                               *}
                {*     Edit Window menu          *}
                {*                               *}
                {*********************************}
                                                                 
                if (class=idcmp_menupick) or (class=idcmp_vanillakey) then
                  handleoptionswindow(messcopy);
                
                {*********************************}
                {*                               *}
                {*     Edit Window Gadget down   *}
                {*                               *}
                {*********************************}
                
                if (class=idcmp_gadgetdown) and (inputmode=0) and (pdwn^.mxchoice<>31) then
                  highsome(messcopy,pgsel,pdwn);

                {************************************}
                {*                                  *}
                {*      Edit Window Deactivated     *}
                {*                                  *}
                {************************************}
                
                if (class=idcmp_inactivewindow) then
                  begin
                    case inputmode of
                      2..8,101,102,157 :
                         drawbox(pdwn);
                      17 :
                         quickputtext(pdwn);
                      18 :
                         quickputimage(pdwn);
                     end;
                    case inputmode of
                      3,4,5,6,7,8,17,18,101,102
                         : clearinputglist(pdwn);
                      2,157
                         : begin
                             forbid;
                             pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
                             permit;
                           end;
                     end;
                    inputmode:=0;
                  end;
                
                {****************************************}
                {*                                      *}
                {*      New Edit Window Mouse Pos       *}
                {*                                      *}
                {****************************************}
                  
                if class=idcmp_mousemove then
                  begin
                    if (inputmode=2)or(inputmode=157) then
                      begin
                        drawbox(pdwn);
                        if messcopy.mousex>=0 then
                          box[3]:=messcopy.mousex
                         else
                          box[3]:=0;
                        if messcopy.mousey>=0 then
                          box[4]:=messcopy.mousey
                         else
                          box[4]:=0;
                        drawbox(pdwn);
                      end;
                    if inputmode=3 then
                      begin
                        drawbox(pdwn);
                        case pdwn^.mxchoice of
                          3 : begin
                                if messcopy.mousex>12 then
                                  begin
                                    box[1]:=messcopy.mousex-13;
                                    box[3]:=messcopy.mousex+12;
                                  end
                                 else
                                  begin
                                    box[1]:=0;
                                    box[3]:=25;
                                  end;
                                if messcopy.mousey>4 then
                                  begin
                                    box[2]:=messcopy.mousey-5;
                                    box[4]:=messcopy.mousey+5;
                                  end
                                 else
                                  begin
                                    box[2]:=0;
                                    box[4]:=10;
                                  end;
                              end;
                          4 : begin
                                if messcopy.mousex>7 then
                                  begin
                                    box[1]:=messcopy.mousex-7;
                                    box[3]:=messcopy.mousex+6;
                                  end
                                 else
                                  begin
                                    box[1]:=0;
                                    box[3]:=14;
                                  end;
                                if messcopy.mousey>4 then
                                  begin
                                    box[2]:=messcopy.mousey-4;
                                    box[4]:=messcopy.mousey+3;
                                  end
                                 else
                                  begin
                                    box[2]:=0;
                                    box[4]:=8;
                                  end;
                              end;
                         end;
                        drawbox(pdwn);
                      end;
                    if (inputmode=4)or(inputmode=5)or(inputmode=101) then
                      begin
                        drawbox(pdwn);
                        if messcopy.mousex>round((maxx-minx)/2) then
                          begin
                            box[1]:=messcopy.mousex-round((maxx-minx)/2);
                            box[3]:=messcopy.mousex+maxx-minx-round((maxx-minx)/2);
                          end
                         else
                          begin
                            box[1]:=0;
                            box[3]:=maxx-minx;
                          end;
                        if messcopy.mousey>round((maxy-miny)/2) then
                          begin
                            box[2]:=messcopy.mousey-round((maxy-miny)/2);
                            box[4]:=messcopy.mousey+maxy-miny-round((maxy-miny)/2);
                          end
                         else
                          begin
                            box[2]:=0;
                            box[4]:=maxy-miny;
                          end;
                        drawbox(pdwn);
                      end;
                    if (inputmode=6)or(inputmode=102) then
                      begin
                        drawbox(pdwn);
                        if inputmode=6 then
                          multiplesizedraw(pdwn);
                        
                        if messcopy.mousex>=box[1] then
                          box[3]:=messcopy.mousex
                         else
                          box[3]:=box[1];
                        if messcopy.mousey>=box[2] then
                          box[4]:=messcopy.mousey
                         else
                          box[4]:=box[2];
                        
                        drawbox(pdwn);
                        
                        { drawothers }
                        if inputmode=6 then
                          multiplesizedraw(pdwn);

                        
                      end;
                    if inputmode=7 then
                      begin
                        drawbox(pdwn);
                        if messcopy.mousex>0 then
                          box[1]:=messcopy.mousex
                         else
                          box[1]:=0;
                        box[3]:=box[1]+1;
                        drawbox(pdwn);
                      end;
                    if inputmode=8 then
                      begin
                        drawbox(pdwn);
                        if messcopy.mousey>0 then
                          box[2]:=messcopy.mousey
                         else
                          box[2]:=0;
                        box[4]:=box[2]+1;
                        drawbox(pdwn);
                      end;
                    if (inputmode=17)or(inputmode=18) then
                      begin
                        y2:=messcopy.mousex-lengthtext2;
                        x2:=messcopy.mousey-heighttext2;
                        if y2<1 then y2:=0;
                        if x2<1 then x2:=0;
                        if (x2<>box[2]) or (y2<>box[1]) then
                          begin
                            if inputmode=17 then
                              quickputtext(pdwn)
                             else
                              quickputimage(pdwn);
                            box[1]:=y2;
                            box[2]:=x2;
                            if inputmode=18 then
                              begin
                                box[3]:=y2+pdwn^.bigimsel^.width;
                                box[4]:=x2+pdwn^.bigimsel^.height;
                              end;
                            if inputmode=17 then
                              quickputtext(pdwn)
                             else
                              quickputimage(pdwn);
                          end;
                      end;
                  end;
                  
                {****** New Edit Window Almost Everything *******}
                  
                if (class=idcmp_mousebuttons) or
                   (class=idcmp_gadgetup) or
                   (class=idcmp_gadgetdown) then
                  begin
                    
                    if inputmode=157 then
                      begin
                        if ((code=selectup)and(class=mousebuttons)) or 
                           (class=idcmp_gadgetup) or 
                           (class=idcmp_gadgetdown) then
                          begin
                            drawbox(pdwn);
                            setdrpt(pdwn^.editwindow^.rport,$FFFF);
                            highlotsofgads(pdwn);
                            forbid;
                            pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
                            permit;
                            inputmode:=1;
                          end;
                        if ((code=menudown)and(class=mousebuttons)) then
                          begin
                            drawbox(pdwn);
                            setdrpt(pdwn^.editwindow^.rport,$FFFF);
                            forbid;
                            pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
                            permit;
                            inputmode:=1;
                          end;

                      end;
                    
                    {**** Clone Gadgets ****}
                    
                    if (inputmode=4) then
                      begin
                        if ((code=selectdown)and(class=mousebuttons)) or 
                           (class=idcmp_gadgetup) or 
                           (class=idcmp_gadgetdown) then
                          begin
                            waiteverything;
                            drawbox(pdwn);
                            inputmode:=1;
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                            while (pgn^.ln_succ<>nil) do
                              begin
                                skipone:=false;
                                goforit:=false;
                                if (pgn^.joined)and(pgn^.kind=string_kind) then
                                  skipone:=true;
                                if (pgn^.kind=listview_kind) and (pgn^.tags[3].ti_data<>0) then
                                  begin
                                    pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                                    if pgn2^.high then
                                      goforit:=true;
                                  end;
                                if (pgn^.high and (not skipone))or goforit then
                                  begin
                                    pgn2:=allocmymem(sizeof(tgadgetnode),memf_any or memf_clear);
                                    if pgn2<>nil then
                                      begin
                                        copymem(pgn,pgn2,sizeof(tgadgetnode));
                                        pgn2^.ob:=nil;
                                        newlist(@pgn2^.infolist);
                                        if pgn^.kind=myobject_kind then
                                          begin
                                            pmt:=pmytag(pgn^.infolist.lh_head);
                                            while (pmt^.ln_succ<>nil) do
                                              begin
                                                pmt2:=pmytag(allocmymem(sizeof(tmytag),memf_clear));
                                                if pmt2<>nil then
                                                  begin
                                                    addtail(@pgn2^.infolist,pnode(pmt2));
                                                    pmt2^.ln_name:=@pmt2^.title[1];
                                                    pmt2^.title:=pmt^.title;
                                                    pmt2^.tagtype:=pmt^.tagtype;
                                                    pmt2^.value:=pmt^.value;
                                                    if pmt^.sizebuffer=0 then
                                                      begin
                                                        pmt2^.data:=pmt^.data;
                                                        if pmt2^.tagtype=tagtypeobject then
                                                          pmt2^.data:=nil;
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
                                          end
                                         else
                                          begin
                                            psn:=pstringnode(pgn^.infolist.lh_head);
                                            while(psn^.ln_succ<>nil) do
                                              begin
                                                psn2:=pstringnode(allocmymem(sizeof(tstringnode),memf_clear or memf_any));
                                                if psn2<>nil then
                                                  begin
                                                    psn2^.ln_name:=@psn2^.st[1];
                                                    psn2^.st:=psn^.st;
                                                    addtail(@pgn2^.infolist,pnode(psn2));
                                                  end;
                                                psn:=psn^.ln_succ;
                                              end;
                                          end;
                                        if pgn^.kind<>mybool_kind then
                                          begin
                                            pgn2^.pointers[1]:=nil;
                                            pgn2^.pointers[2]:=nil;
                                          end;
                                        if (pgn2^.kind=listview_kind) and(pgn2^.tags[3].ti_data<>0) then
                                          begin
                                            
                                            {got to clone joined string gadget}
                                            
                                            pgn4:=pgadgetnode(pgn^.tags[3].ti_data);
                                            pgn3:=allocmymem(sizeof(tgadgetnode),memf_clear or memf_any);
                                            if pgn3<>nil then
                                              begin
                                                {copy gad4 into gad3}
                                                copymem(pgn4,pgn3,sizeof(tgadgetnode));
                                                pgn3^.pointers[1]:=pointer(pgn2);
                                                pgn2^.tags[3].ti_data:=long(pgn3);
                                                pgn3^.x:=pgn2^.x+box[1]-minx;
                                                pgn3^.y:=pgn2^.y+box[2]-miny;
                                                pgn3^.ln_name:=@pgn2^.title[1];
                                                pgn3^.editwindow:=nil;
                                                pgn3^.high:=false;
                                                pgn3^.labelid:=#0#0#0;
                                                addtail(@pdwn^.gadgetlist,pnode(pgn3));
                                              end
                                             else
                                              begin
                                                pgn2^.tags[3].ti_data:=0;
                                                telluser(pdwn^.editwindow,memerror);
                                              end;
                                          end;
                                        case pgn2^.kind of
                                          cycle_kind    : pgn2^.tags[3].ti_data:=long(@pgn2^.infolist);
                                          mx_kind       : pgn2^.tags[3].ti_data:=long(@pgn2^.infolist);
                                          listview_kind : pgn2^.tags[1].ti_data:=long(@pgn2^.infolist);
                                          text_kind     : pgn2^.tags[1].ti_data:=long(@pgn2^.datas[1]);
                                         end;
                                        pgn2^.x:=pgn2^.x+box[1]-minx;
                                        pgn2^.y:=pgn2^.y+box[2]-miny;
                                        pgn2^.ln_name:=@pgn2^.labelid[1];
                                        pgn2^.editwindow:=nil;
                                        pgn2^.labelid:=#0#0#0;
                                        pgn2^.high:=false;
                                        addtail(@pdwn^.gadgetlist,pnode(pgn2));
                                      end;
                                  end;
                                pgn:=pgn^.ln_succ;
                              end;
                            fixgadgetnumbers(pdwn);
                            unwaiteverything;
                          end;
                        if (code=menudown)and(class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    
                    {**** move gadgets ****}
                    
                    if (inputmode=5) then
                      begin
                        if ((code=selectdown)and(class=mousebuttons)) or 
                           (class=idcmp_gadgetup) or 
                           (class=idcmp_gadgetdown) then
                          begin
                            drawbox(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            inputmode:=1;
                            pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                            while (pgn^.ln_succ<>nil) do
                              begin
                                skipone:=false;
                                if (pgn^.joined)and(pgn^.kind=string_kind) then
                                  skipone:=true;
                                goforit:=false;
                                pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                                if (pgn2<>nil)and(pgn^.kind=listview_kind) then
                                  if pgn2^.high and (not pgn^.high) then
                                    goforit:=true;
                                if ((pgn^.high)and(not skipone))or goforit then
                                  begin
                                    pgn^.x:=pgn^.x+box[1]-minx;
                                    pgn^.y:=pgn^.y+box[2]-miny;
                                  end;
                                pgn:=pgn^.ln_succ;
                              end;
                          end;
                        if (code=menudown) and (class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    
                    {**** size gadget ****}
                    
                    if inputmode=6 then
                      begin
                        if ((code=selectdown) and (class=idcmp_mousebuttons)) or
                           ((class=gadgetup))then 
                          begin
                            {here}
                            
                            drawbox(pdwn);
                            
                            { drawothers }
                            multiplesizedraw(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            sgad^.w:=box[3]-box[1]+1;
                            sgad^.h:=box[4]-box[2]+1;
                            pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                            while(pgn^.ln_succ<>nil) do
                              begin
                                if pgn^.quicksize then
                                  begin
                                    pgn^.w:=box[3]-box[1]+1;
                                    pgn^.h:=box[4]-box[2]+1;
                                    checkgadsize(pdwn,pgn);
                                  end;
                                pgn:=pgn^.ln_succ;
                              end;
                            checkgadsize(pdwn,sgad);
                          end;
                        if (code=menudown) and (class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            multiplesizedraw(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    
                    {**** size bevel box ****}
                    
                    if inputmode=102 then
                      begin
                        if ((code=selectdown) and (class=idcmp_mousebuttons)) or
                           ((class=gadgetup))then 
                          begin
                            drawbox(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                            pbbn^.w:=box[3]-box[1]+1;
                            pbbn^.h:=box[4]-box[2]+1;
                          end;
                        if (code=menudown) and (class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    
                    {**** align left/top ****}
                    
                    if (inputmode=7)or(inputmode=8) then
                      begin
                        if ((code=selectdown) and (class=idcmp_mousebuttons)) or
                           (class=gadgetup) or (class=gadgetdown) then 
                          begin
                            drawbox(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pgn:=pgadgetnode(pdwn^.gadgetlist.lh_head);
                            while pgn^.ln_succ<>nil do
                              begin
                                skipone:=false;
                                if (pgn^.kind=string_kind)and(pgn^.joined) then
                                  skipone:=true;
                                goforit:=false;
                                pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                                if (pgn2<>nil)and(pgn^.kind=listview_kind) then
                                  if pgn2^.high and (not pgn^.high) then
                                    goforit:=true;
                                if ((pgn^.high)and(not skipone)) or goforit then
                                  begin
                                    case pdwn^.alignselect of
                                      0 : pgn^.x:=box[1];
                                      1 : pgn^.x:=box[1]-pgn^.w+1;
                                      2 : pgn^.y:=box[2]; 
                                      3 : pgn^.y:=box[2]-pgn^.h+1;
                                     end;
                                    if pgn^.x<0 then pgn^.x:=0;
                                    if pgn^.y<0 then pgn^.y:=0;
                                  end;
                                pgn:=pgn^.ln_succ;
                              end;
                            inputmode:=1;
                          end;
                        if (code=menudown) and (class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    
                    {**** move bevel box ****}
                    
                    if (inputmode=101) then
                      begin
                        if ((code=selectdown)and(class=mousebuttons)) or 
                           (class=idcmp_gadgetup) or 
                           (class=idcmp_gadgetdown) then
                          begin
                            drawbox(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pbbn:=pbevelboxnode(getnthnode(@pdwn^.bevelboxlist,pdwn^.bevelselected));
                            pbbn^.x:=pbbn^.x+box[1]-minx;
                            pbbn^.y:=pbbn^.y+box[2]-miny;
                          end;
                        if (code=menudown) and (class=idcmp_mousebuttons) then
                          begin
                            drawbox(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                      end;
                    if (pdwn^.mxchoice=32) and (code=selectdown)and(class=idcmp_mousebuttons) and (inputmode=0) then
                          startshiftselect(pdwn,messcopy);
                    if ((pdwn^.mxchoice=3)or(pdwn^.mxchoice=4)) and
                       ((class=idcmp_mousebuttons)or(class=idcmp_gadgetdown)) then
                      begin
                        case inputmode of
                          0 : begin
                              if code=selectdown then
                                if ((messcopy.qualifier and(IEQUALIFIER_LSHIFT or IEQUALIFIER_RSHIFT))=0)then
                                  begin
                                    case pdwn^.mxchoice of
                                      3: begin
                                           box[1]:=messcopy.mousex-13;
                                           box[2]:=messcopy.mousey-5;
                                           box[3]:=box[1]+26;
                                           box[4]:=box[2]+11;
                                         end;
                                      4: begin
                                           box[1]:=messcopy.mousex-7;
                                           box[2]:=messcopy.mousey-4;
                                           box[3]:=box[1]+14;
                                           box[4]:=box[2]+8;
                                         end;
                                     end;
                                    if box[1]<0 then box[1]:=0;
                                    if box[2]<0 then box[2]:=0;
                                    case pdwn^.mxchoice of
                                      3: begin
                                           box[3]:=box[1]+25;
                                           box[4]:=box[2]+10;
                                         end;
                                      4: begin
                                           box[3]:=box[1]+13;
                                           box[4]:=box[2]+8;
                                         end;
                                     end;
                                    inputmode:=3;
                                    setinputglist(pdwn);
                                    drawbox(pdwn);
                                  end
                                 else
                                  begin
                                    startshiftselect(pdwn,messcopy);
                                  end;
                              end;
                          3 : begin
                                if (code=selectdown)or((class=idcmp_gadgetdown)) then
                                  begin
                                    drawbox(pdwn);
                                    if true then
                                      begin
                                        pgn:=allocmymem(sizeof(tgadgetnode),memf_clear or memf_any);
                                        if pgn<>nil then
                                          begin
                                            newgadnode(pdwn,pgn);
                                            updateeditwindow:=true;
                                            addtail(@pdwn^.gadgetlist,pnode(pgn));
                                            fixgadgetnumbers(pdwn);
                                            openeditgadget(pdwn,pgn);
                                          end
                                         else
                                          telluser(pdwn^.editwindow,memerror);
                                        updateeditwindow:=true;
                                      end;
                                    clearinputglist(pdwn);
                                    inputmode:=1;
                                  end;
                                if code=menudown then
                                  begin
                                    drawbox(pdwn);
                                    clearinputglist(pdwn);
                                    inputmode:=1;
                                  end;
                              end;
                         end;
                      end;
                   
                    {*  Fiddle with text and buttons  *}
                     
                    if (inputmode=17) then
                      begin
                        if (class=idcmp_mousebuttons) and (code=menudown) then
                          begin
                            quickputtext(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                        if ((class=idcmp_mousebuttons) and 
                             (code=selectdown))  or
                           ((class=gadgetup)or(class=gadgetdown)) then
                          begin
                            quickputtext(pdwn);
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pdwn^.textselected^.placed:=true;
                            pdwn^.textselected^.x:=box[1];
                            pdwn^.textselected^.y:=box[2];
                            setalltextlistwindowgadgets(pdwn);
                          end;
                      end;
                   
                    {*  Start moving text about  *}
                     
                    if (pdwn^.mxchoice=14) and (inputmode=0) and
                       (class=idcmp_mousebuttons)and(code=selectdown) then
                      begin
                        if ((messcopy.qualifier and(IEQUALIFIER_LSHIFT or IEQUALIFIER_RSHIFT))=0) then
                          if (pdwn^.textselected<>nil) then
                            begin
                              box[3]:=messcopy.mousex;
                              box[4]:=messcopy.mousey;
                              lengthtext2:=intuitextlength(pintuitext(@pdwn^.textselected^.frontpen)) div 2;
                              heighttext2:=pdwn^.textselected^.ta.ta_ysize div 2;
                              box[1]:=box[3]-lengthtext2;
                              box[2]:=box[4]-heighttext2;
                              if box[1]<0 then box[1]:=0;
                              if box[2]<0 then box[2]:=0;
                              inputmode:=17;
                              setinputglist(pdwn);
                              quickputtext(pdwn);
                            end
                           else
                            telluser(pdwn^.editwindow,'No text selected.')
                         else
                          begin
                            startshiftselect(pdwn,messcopy);
                          end;
                      end;
                   
                    {*  Fiddle with images buttons  *}
                   
                    if (inputmode=18) then
                      begin
                        if (class=idcmp_mousebuttons) and (code=menudown) then
                          begin
                            quickputimage(pdwn);
                            clearinputglist(pdwn);
                            inputmode:=1;
                          end;
                        if ((class=idcmp_mousebuttons) and 
                            (code=selectdown))  or
                           ((class=gadgetup)or(class=gadgetdown)) then
                          begin
                            quickputimage(pdwn);
                            { store final coords }
                            updateeditwindow:=true;
                            clearinputglist(pdwn);
                            pdwn^.imageselected^.x:=box[1];
                            pdwn^.imageselected^.y:=box[2];
                            pdwn^.imageselected^.placed:=true;
                            setallimagelistwindowgadgets(pdwn);
                          end;
                      end;
                   
                    {*  start image placing  *}
                   
                    if (pdwn^.mxchoice=28) and (inputmode=0) and
                       (class=idcmp_mousebuttons)and(code=selectdown) then
                      begin
                        if ((messcopy.qualifier and(IEQUALIFIER_LSHIFT or IEQUALIFIER_RSHIFT))=0) then
                          if (pdwn^.imageselected<>nil) then
                            if (pdwn^.imageselected^.pin<>nil) then
                              begin
                                setinputglist(pdwn);
                                box[3]:=messcopy.mousex;
                                box[4]:=messcopy.mousey;
                                lengthtext2:=pdwn^.imageselected^.pin^.width div 2;
                                heighttext2:=pdwn^.imageselected^.pin^.height div 2;
                                box[1]:=box[3]-lengthtext2;
                                box[2]:=box[4]-heighttext2;
                                if box[1]<0 then box[1]:=0;
                                if box[2]<0 then box[2]:=0;
                                box[3]:=box[1]+pdwn^.imageselected^.pin^.width;
                                box[4]:=box[2]+pdwn^.imageselected^.pin^.height;
                                inputmode:=18;
                                quickputimage(pdwn);
                              end
                             else
                              telluser(pdwn^.editwindow,'No picture selected.')
                           else
                            telluser(pdwn^.editwindow,'No image selected.')
                         else
                          startshiftselect(pdwn,messcopy);
                      end;
                    
                    {* deal with gadget making etc. *}
                   
                    if ((class=idcmp_mousebuttons)or(class=idcmp_gadgetup)or(class=idcmp_gadgetdown)) and
                       ((pdwn^.mxchoice=0) or (pdwn^.mxchoice=1) or 
                        (pdwn^.mxchoice=2) or (pdwn^.mxchoice=5) or
                        (pdwn^.mxchoice=6) or (pdwn^.mxchoice=7) or
                        (pdwn^.mxchoice=8) or (pdwn^.mxchoice=12) or
                        (pdwn^.mxchoice=9) or (pdwn^.mxchoice=10) or
                        (pdwn^.mxchoice=11) or (pdwn^.mxchoice=30) or
                        (pdwn^.mxchoice=33)) then
                      case inputmode of
                        2 : begin
                              if (code=selectup)and(class=idcmp_mousebuttons) then
                                begin
                                  drawbox(pdwn);
                                  if box[3]<box[1] then
                                    begin
                                      dummy:=box[1];
                                      box[1]:=box[3];
                                      box[3]:=dummy;
                                    end;
                                  if box[4]<box[2] then
                                    begin
                                      dummy:=box[2];
                                      box[2]:=box[4];
                                      box[4]:=dummy;
                                    end;
                                  if (pdwn^.mxchoice=0) or (pdwn^.mxchoice=1) or 
                                     (pdwn^.mxchoice=2) or (pdwn^.mxchoice=5) or
                                     (pdwn^.mxchoice=8) or (pdwn^.mxchoice=6) or
                                     (pdwn^.mxchoice=10) or (pdwn^.mxchoice=11) or
                                     (pdwn^.mxchoice=7) or (pdwn^.mxchoice=9) or
                                     (pdwn^.mxchoice=30) or (pdwn^.mxchoice=33) then
                                    begin
                                      pgn:=allocmymem(sizeof(tgadgetnode),memf_clear or memf_any);
                                      if pgn<>nil then
                                        begin
                                          newgadnode(pdwn,pgn);
                                          updateeditwindow:=true;
                                          addtail(@pdwn^.gadgetlist,pnode(pgn));
                                          fixgadgetnumbers(pdwn);
                                          openeditgadget(pdwn,pgn);
                                        end
                                       else
                                        telluser(pdwn^.editwindow,memerror);
                                    end;
                                  if pdwn^.mxchoice=12 then
                                    begin
                                      pbbn:=allocmymem(sizeof(tbevelboxnode),memf_clear or memf_any);
                                      if pbbn<>nil then
                                        begin
                                          pbbn^.x:=box[1];
                                          pbbn^.y:=box[2];
                                          pbbn^.w:=box[3]-box[1]+1;
                                          pbbn^.h:=box[4]-box[2]+1;
                                          pbbn^.ln_name:=@pbbn^.title[1];
                                          str(sizeoflist(@pdwn^.bevelboxlist),pbbn^.title);
                                          pbbn^.title:='Bevel Box '+pbbn^.title+#0;
                                          addtail(@pdwn^.bevelboxlist,pnode(pbbn));
                                          pdwn^.bevelselected:=getlistpos(@pdwn^.bevelboxlist,pnode(pbbn));
                                          if pdwn^.bevelwindow<>nil then
                                            begin
                                              gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                                gtlv_labels,~0);
                                              gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                                gtlv_labels,long(@pdwn^.bevelboxlist));
                                              gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_listview],pdwn^.bevelwindow,
                                                gtlv_selected,pdwn^.bevelselected);
                                              
                                              gt_setsinglegadgetattr(pdwn^.bevelwindowgads[bevel_radio],pdwn^.bevelwindow,
                                                gtmx_active,pbbn^.beveltype);
                
                                              
                                            end;
                                          updateeditwindow:=true;
                                        end
                                       else
                                        telluser(pdwn^.editwindow,memerror);
                                    end;
                                  forbid;
                                  pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
                                  permit;
                                  inputmode:=1;
                                end;
                              if (code=menudown)and(class=idcmp_mousebuttons) then
                                begin
                                  drawbox(pdwn);
                                  inputmode:=1;
                                  forbid;
                                  pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags and ~wflg_rmbtrap;       
                                  permit;
                                end;
                            end;
                      
                        {*  Start Gadget sizing (for creation)  }
                        
                        0 : begin
                              if ((class=idcmp_mousebuttons) and (code=selectdown)) then
                                begin
                                  if ((messcopy.qualifier and(IEQUALIFIER_LSHIFT or IEQUALIFIER_RSHIFT))=0)
                                     or (pdwn^.mxchoice=12) then
                                    begin
                                      box[1]:=messcopy.mousex;
                                      box[2]:=messcopy.mousey;
                                      box[3]:=messcopy.mousex+2;
                                      box[4]:=messcopy.mousey+2;
                                      if (box[1]>=0) and (box[2]>=0) then
                                        begin
                                          inputmode:=2;
                                          forbid;
                                          pdwn^.editwindow^.flags:=pdwn^.editwindow^.flags or wflg_rmbtrap;       
                                          permit;
                                          drawbox(pdwn);
                                        end;
                                    end
                                   else
                                    begin
                                      startshiftselect(pdwn,messcopy);
                                    end;
                                end;
                            end;
                       end;
                  end;
              end;
            
{*******************************************}
{*                                         *}
{*          Edit texts Handling            *}
{*                                         *}
{*******************************************}

            if messcopy.idcmpwindow=pdwn^.textlistwindow then
              begin
                dummy:=0;
                case class of
                  idcmp_closewindow :
                    dummy:=9898;
                  idcmp_menupick :
                   if inputmode=0 then
                    begin
                      ItemNumber:=ITEMNUM(code);
                      SubNumber:=SUBNUM(code);
                      MenuNumber:=MENUNUM(code);
                      Case MenuNumber of
                        WinListOpts :
                          Case ItemNumber of
                            WinListUpdate :
                              dummy:=16;
                            WinListHelp :
                              dummy:=15;
                            WinListClose :
                              dummy:=9898;
                           end;
                       end;
                    end;
                  idcmp_gadgetup :
                    dummy:=pgsel^.gadgetid;
                  idcmp_vanillakey :
                   if inputmode=0 then
                    case upcase(chr(code)) of
                     'U' : dummy:=16;
                     'H' : dummy:=15;
                     'N' : dummy:=6;
                     'D' : dummy:=7;
                     'F' : dummy:=8;
                     'P' : dummy:=9;
                    end;
                 end;
                case dummy of
                  1 : begin 
                        if inputmode=0 then
                          begin
                            enableselectontextlistwindow(pdwn);
                            readalltextlistwindowgadgets(pdwn);
                            pdwn^.textselected:=ptextnode(getnthnode(@pdwn^.textlist,messcopy.code));
                            setalltextlistwindowgadgets(pdwn);
                          end
                         else
                          setalltextlistwindowgadgets(pdwn);
                      end;
                  4 : if pdwn^.textselected<>nil then
                      begin
                        if inputmode=0 then
                          begin
                            pdwn^.textselected^.frontpen:=messcopy.code;
                            readalltextlistwindowgadgets(pdwn);
                          end
                         else
                          gt_setsinglegadgetattr(pdwn^.textgadgets[4],pdwn^.textlistwindow,
                                                 gtpa_color,pdwn^.textselected^.frontpen);
                      end;
                  5 : if pdwn^.textselected<>nil then
                      begin
                        if inputmode=0 then
                          begin
                            pdwn^.textselected^.backpen:=messcopy.code;
                            readalltextlistwindowgadgets(pdwn);
                          end
                         else
                          gt_setsinglegadgetattr(pdwn^.textgadgets[5],pdwn^.textlistwindow,
                                                 gtpa_color,pdwn^.textselected^.backpen);
                      end;
                  6 : if inputmode=0 then
                      begin
                        readalltextlistwindowgadgets(pdwn);
                        ptn:=allocmymem(sizeof(ttextnode),memf_clear or memf_any);
                        if ptn<>nil then
                          begin
                            enableselectontextlistwindow(pdwn);
                            with ptn^ do
                              begin
                                ln_name:=@title[1];
                                title:='New Text Item'#0;
                                frontpen:=2;
                                backpen:=3;
                                placed:=false;
                                drawmode:=jam1;
                                x:=0;
                                y:=0;
                                pta:=@ta;
                                itext:=@title[1];
                                nexttext:=nil;
                                pfr:=pfontrequester(fontrequest);
                                ta.ta_ysize:=pfr^.fo_attr.ta_ysize;
                                ta.ta_style:=pfr^.fo_attr.ta_style;
                                ta.ta_flags:=pfr^.fo_attr.ta_flags;
                                ctopas(pfr^.fo_attr.ta_name^,st);
                                if length(st)>44 then 
                                  st:=copy(st,1,44);
                                fonttitle:=st+#0;
                                ta.ta_name:=@fonttitle[1];
                              end;
                            gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                     gtlv_labels,~0);
                            addtail(@pdwn^.textlist,pnode(ptn));
                            gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                     gtlv_labels,long(@pdwn^.textlist));
                            pdwn^.textselected:=ptn;
                            setalltextlistwindowgadgets(pdwn);
                          end
                         else
                          telluser(pdwn^.editwindow,memerror);
                      end;
                  7 : if inputmode=0 then
                        begin
                          if pdwn^.textselected<>nil then
                            begin
                              disableselectontextlistwindow(pdwn);
                              gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                     gtlv_labels,~0);
                              remove(pnode(pdwn^.textselected));
                              freemymem(pdwn^.textselected,sizeof(ttextnode));
                              gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                     gtlv_labels,long(@pdwn^.textlist));
                              pdwn^.textselected:=nil;
                            end;
                        end;
                  8 : if pdwn^.textselected<>nil then
                      begin
                        waiteverything;
                        settagitem(@tags[1],asl_window,long(pdwn^.editwindow));
                        settagitem(@tags[2],asl_fontname,long(pdwn^.textselected^.ta.ta_name));
                        settagitem(@tags[3],asl_fontheight,long(pdwn^.textselected^.ta.ta_ysize));
                        settagitem(@tags[4],asl_fontstyles,long(pdwn^.textselected^.ta.ta_style));
                        settagitem(@tags[5],asl_fontflags,long(pdwn^.textselected^.ta.ta_flags));
                        settagitem(@tags[6],tag_done,0);
                        readalltextlistwindowgadgets(pdwn);
                        inputmode:=1;
                        if (aslrequest(fontrequest,@tags[1])) then
                          begin
                            with pdwn^.textselected^ do
                              begin
                                pfr:=pfontrequester(fontrequest);
                                ta.ta_ysize:=pfr^.fo_attr.ta_ysize;
                                ta.ta_style:=pfr^.fo_attr.ta_style;
                                ta.ta_flags:=pfr^.fo_attr.ta_flags;
                                ctopas(pfr^.fo_attr.ta_name^,st);
                                if length(st)>44 then st:=copy(st,1,44);
                                fonttitle:=st+#0;
                                ta.ta_name:=@fonttitle[1];
                              end;
                            setalltextlistwindowgadgets(pdwn);
                          end;
                        unwaiteverything;
                      end;
                  999: if pdwn^.textselected<>nil then
                      begin
                        readalltextlistwindowgadgets(pdwn);
                        inputmode:=1;
                        pdwn^.textselected^.screenfont:=checkedbox(pdwn^.textgadgets[14]);
                        setalltextlistwindowgadgets(pdwn);
                      end;
                  9 : if (inputmode=0) and (pdwn^.textselected<>nil) then
                        begin
                          readalltextlistwindowgadgets(pdwn);
                          box[1]:=0;
                          box[2]:=0;
                          box[3]:=0;
                          box[4]:=0;
                          lengthtext2:=intuitextlength(pintuitext(@pdwn^.textselected^.frontpen)) div 2;
                          heighttext2:=pdwn^.textselected^.ta.ta_ysize div 2;
                          inputmode:=17;
                          windowtofront(pdwn^.editwindow);
                          activatewindow(pdwn^.editwindow);
                          setinputglist(pdwn);
                          quickputtext(pdwn);
                        end;
                  10: if inputmode=0 then
                        begin
                          readalltextlistwindowgadgets(pdwn);
                          gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                 gtlv_labels,~0);
                          gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                                 gtlv_labels,long(@pdwn^.textlist));
                          setalltextlistwindowgadgets(pdwn);
                        end;
                  11,12,13,14
                    : begin
                        if inputmode=0 then
                          begin
                            if pgsel=pdwn^.textgadgets[7] then
                              begin
                                pdwn^.textselected^.drawmode:=
                                    jam1 or (inversvid and pdwn^.textselected^.drawmode);
                              end;
                            if pgsel=pdwn^.textgadgets[9] then
                              begin
                                pdwn^.textselected^.drawmode:=
                                    jam2 or (inversvid and pdwn^.textselected^.drawmode);
                              end;
                            if pgsel=pdwn^.textgadgets[8] then
                              begin
                                pdwn^.textselected^.drawmode:=
                                    complement or (inversvid and pdwn^.textselected^.drawmode);
                              end;
                            if pgsel=pdwn^.textgadgets[10] then
                              begin
                                if (pgsel^.flags and gflg_selected)<>0 then
                                  pdwn^.textselected^.drawmode:=inversvid or pdwn^.textselected^.drawmode
                                 else
                                  pdwn^.textselected^.drawmode:=
                                      pdwn^.textselected^.drawmode and (jam1 or jam2 or complement);
                              end;
                          end;
                        setalltextlistwindowgadgets(pdwn);
                      end;
                  15: if inputmode=0 then
                        helpwindow(@pdwn^.helpwin,windowtextlisthelp);
                  16: begin
                        readalltextlistwindowgadgets(pdwn);
                        gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                               gtlv_labels,~0);
                        gt_setsinglegadgetattr(pdwn^.textgadgets[1],messcopy.idcmpwindow,
                                               gtlv_labels,long(@pdwn^.textlist));
                        setalltextlistwindowgadgets(pdwn);
                        updateeditwindow:=true;
                      end;
                  9898 :
                    if inputmode=0 then
                      begin
                        readalltextlistwindowgadgets(pdwn);
                        closetextlistwindow(pdwn);
                        updateeditwindow:=true;
                      end;

                 end;
              end;
            
{*******************************************}
{*                                         *}
{*          Edit Sizes Handling            *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.sizeswindow then
              handlesizeswindow(messcopy);

{*******************************************}
{*                                         *}
{*          IDCMP Window Handling          *}
{*                                         *}
{*******************************************}
            
            if messcopy.idcmpwindow=pdwn^.idcmpwindow then
              idcmphandling(pdwn,messcopy);
            
{*******************************************}
{*                                         *}
{*          Redraw Edit Window             *}
{*                                         *}
{*******************************************}

            if updateeditwindow then
              updatewin(pdwn);
          end;

{*******************************************}

        mess:=gt_getimsg(mainwindow^.userport);
      end;
    if inputmode=1 then inputmode:=0;
    drawmag:=true;
  until done;
  waiteverything;
  if aboutwin<>nil then
    freesysrequest(aboutwin);
  closewindowedittagswindow;
  closelibwindow;
  CloseWindowlocaleWindow;
  freelist(@tlocalelist,sizeof(tlocalenode));
  
  if not imrun then
    begin
      telluser(mainwindow,'Seems to be an internal error.');
    end;

{*******************************************}
{*                                         *}
{*     Free Designed Windows etc.          *}  
{*                                         *}
{*******************************************}

  pdsn:=pdesignerscreennode(teditscreenlist.lh_head);
  while (pdsn^.ln_succ<>nil) do
    begin
      pdsn2:=pdsn^.ln_succ;
      handledeletescreennode(pdsn);
      pdsn:=pdsn2;
    end;
  
  pin:=pimagenode(teditimagelist.lh_head);
  while (pin^.ln_succ<>nil) do
    begin
      if pin^.colourmap<>nil then
        freemymem(pin^.colourmap,pin^.mapsize);
      if pin^.imagedata<>nil then
        freemymem(pin^.imagedata,pin^.sizeallocated);
      if pin^.editwindow<>nil then
        closeimageeditwindow(pin);
      if pin^.displaywindow<>nil then
        closeimagedisplaywindow(pin);
      pin:=pin^.ln_succ;
    end;
  freelist(@teditimagelist,sizeof(timagenode));
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
  
  Freeextratags;
  
  pgn := pgadgetnode(remhead(@presetobjectlist));
  while (pgn<>nil) do
    begin
      freegadgetnode(nil,pgn);
      pgn := pgadgetnode(remhead(@presetobjectlist));
    end;
  
{*******************************************}

end;

Begin
  gtxbase:=NIL;
  waiting:=false;
  printfile:='ram:printtest'#0;
  wbwindowname:=strptr(@winname[1]);
  { default prefs values }
  
  deflangnum:=~0;
  for cyclepos:=1 to 20 do
    prefsvalues[cyclepos]:=defaultprefs[cyclepos];
  updateeditwindow:=false;
  cyclepos:=0;
  inputmode:=0;
  mainselected:=~0;
  
  newlist(@teditmenulist);
  newlist(@teditwindowlist);
  newlist(@teditimagelist);
  newlist(@compilerlist);
  for memused:=1 to 9 do
    pencycle[memused]:=@strings[142+memused,1];
  pencycle[10]:=nil;
  
  pla:=plongarray(@screenmodesavailable);
  for memused:=0 to 5 do
    pla^[memused]:=pla^[memused] or pal_monitor_id;
  for memused:=6 to 11 do
    pla^[memused]:=pla^[memused] or ntsc_monitor_id;
  
  memused:=0;
  with ttopaz80 do
    begin
      fontname:='topaz.font'#0;
      tta_name:=@fontname[1];
      tta_ysize:=8;
      tta_style:=0;
      tta_flags:=0;
    end;
  pendtagitem:=@tendtagitem;
  settagitem(pendtagitem,tag_done,0);
  frontscreentitle:='The Designer (C) '+Ian+' 1994'#0;
  maincodewindow:=nil;
  prefswindow:=nil;
  prefsglist:=nil;
  maincodeglist:=nil;
  mainlabels[1]:=@strings[2,1];
  mainlabels[2]:=@strings[3,1];
  mainlabels[3]:=@strings[124,1];
  mainlabels[4]:=@strings[18,7];
  mainlabels[5]:=nil;
  newlist(@listvieweditlist);
  listvieweditnode.ln_name:=@strings[86,1];
  addtail(@listvieweditlist,@listvieweditnode);
  justcycle[1]:=@strings[84,7];
  justcycle[2]:=@strings[83,6];
  justcycle[3]:=@strings[80,4];
  justcycle[4]:=nil;
  maincodewindownode.ln_type:=maincodewindownodetype;           
  prefswindownode.ln_type:=prefswindownodetype;
  newlist(@tlocalelist);
  aligncycle[1]:=@strings[100,1];
  aligncycle[2]:=@strings[101,1];
  aligncycle[3]:=@strings[102,1];
  aligncycle[4]:=@strings[103,1];
  aligncycle[5]:=nil;
  radiofail[1]:=@strings[36,10];
  radiofail[2]:=nil;
  spreadcycle[1]:=@windowoptions[16,1];
  spreadcycle[2]:=@windowoptions[17,1];
  spreadcycle[3]:=nil;
  pgacycle[1]:=@strings[113,1];
  pgacycle[2]:=@strings[114,1];
  pgacycle[3]:=nil;
  placetextcycle1[1]:=@strings[80,1];
  placetextcycle1[2]:=@strings[81,1];
  placetextcycle1[3]:=@strings[82,1];
  placetextcycle1[4]:=@strings[83,1];
  placetextcycle1[5]:=@strings[84,1];
  placetextcycle1[6]:=nil;
  placetextcycle2[1]:=@strings[81,1];
  placetextcycle2[2]:=@strings[82,1];
  placetextcycle2[3]:=@strings[83,1];
  placetextcycle2[4]:=@strings[84,1];
  placetextcycle2[5]:=nil;
  bevel_radiolabels[0]:=@bevel_radiomxtexts[0,1];
  bevel_radiolabels[1]:=@bevel_radiomxtexts[1,1];
  bevel_radiolabels[2]:=@bevel_radiomxtexts[2,1];
  bevel_radiolabels[3]:=@bevel_radiomxtexts[3,1];
  bevel_radiolabels[4]:=@bevel_radiomxtexts[4,1];
  bevel_radiolabels[5]:=@bevel_radiomxtexts[5,1];
  bevel_radiolabels[6]:=Nil;
  errorstring:='';
  libwindow:=nil;
  libwindowglist:=nil;
  aboutwin:=nil;
  mainwindow:=nil;
  mainwindowglist:=nil;
  mainwindowzoom[1]:=150;
  mainwindowzoom[2]:=0;
  mainwindowzoom[3]:=180;
  with defaulthelpwindownode do
    begin
      pwin:=nil;
      glist:=nil;
      ln_type:=helpwindownodetype;
      {
      newlist(@hl);
      }
    end;
  intuitionbase:=pintuitionbase(openlibrary('intuition.library',37));
  if (intuitionbase<>nil) then
    begin
      gfxbase:=pgfxbase(openlibrary('graphics.library',37));
      if (gfxbase<>nil) then
        begin
          utilitybase:=putilitybase(openlibrary('utility.library',37));
          if (utilitybase<>nil) then
            begin
              gadtoolsbase:=openlibrary('gadtools.library',37);
              if (gadtoolsbase<>nil) then
                begin
                  layersbase:=openlibrary('layers.library',37);
                  if layersbase<>nil then
                    begin
                      iffparsebase:=openlibrary('iffparse.library',37);
                      if iffparsebase<>nil then
                        begin
                          iconbase:=openlibrary('icon.library',37);
                          if iconbase<>nil then
                            begin
                              workbenchbase:=openlibrary('workbench.library',37);
                              if workbenchbase<>nil then
                                begin
                                  aslbase:=openlibrary('asl.library',37);                  
                                  if (aslbase<>nil) then
                                    begin
                                      
                                      colorwheelbase:=openlibrary('gadgets/colorwheel.gadget', 39);                  
                                      GradientSliderBase := OpenLibrary('gadgets/gradientslider.gadget', 39);
                                      
                                      diskfontbase:=openlibrary('diskfont.library',36);                  
                                      if (diskfontbase<>nil) then
                                        begin

                                      myscreen:=lockpubscreen(nil);
                                      if myscreen<>nil then
                                        begin
                                          myprogramport:=createmsgport;
                                          if myprogramport<>nil then
                                            begin                
                                              mainwindowzoom[4]:=myscreen^.wbortop+myscreen^.rastport.txheight+1;
                                              screenvisualinfo:=getvisualinfoa(myscreen,nil);
                                              if screenvisualinfo<>nil then
                                                begin
                                                  defaulthelpwindownode.screenvisinfo:=screenvisualinfo;
                                                  defaulthelpwindownode.pscr:=myscreen;
                                                  pwaitpointer:=allocmymem(72,memf_chip or memf_clear);
                                                  if pwaitpointer<>nil then
                                                    begin
                                                      copymem(pointer(@waitpointer[1]),pointer(pwaitpointer),72);
                                                      if setimagedata(image1,@imagedata1[1],1) and
                                                         setimagedata(image2,@imagedata2[1],1) and
                                                         setimagedata(image3,@imagedata3[1],2) and
                                                         setimagedata(image4,@imagedata4[1],2) and
                                                         setimagedata(getfileimage1,@getfiledata1[1],3) and
                                                         setimagedata(getfileimage2,@getfiledata2[1],3) and
                                                         setimagedata(getfileimage3,@getfiledata3[1],4) and
                                                         setimagedata(getfileimage4,@getfiledata4[1],4) then
                                                        begin
                                                          if allocasls then
                                                            begin
                                                              
                                                              amigaguidebase:=openlibrary('amigaguide.library',33);
                                                              
                                                              if makemenueditimagemenu(screenvisualinfo) then;
                                                              
                                                              if createliblist then
                                                                begin
                                                                  wasdemoversion:=demoversion;
                                                                  readdefaultscreenmode;
                                                                  ReadCustomTags;
                                                                  gtxbase:=nil;
                                                                  nofragbase:=nil;
                                                                  if openmainwindow then
                                                                    begin
                                                                      presentcompiler:=~0;
                                                                      makecompilerlist(getprogramdir);
                                                                      readprefsvalues;
                                                                      if (deflangnum=~0) and
                                                                         (sizeoflist(@compilerlist)>0) then
                                                                        deflangnum:=0;
                                                                      presentcompiler:=deflangnum;
                                                                      
                                                                      loadpresetobjects('Env:Designer/');
                                                                      loadpresetobjects('progdir:');
                                                                      
                                                                      if checkprotection then
                                                                        begin
                                                                          readcodedefs;
                                                                          mainprocess;
                                                                        end
                                                                       else
                                                                        telluser(mainwindow,'Error in Designer file.');
                                                                      
                                                                      closemaincodewindow;
                                                                      closeprefswindow;
                                                                      freelist(@compilerlist,sizeof(tstringnode));
                                                                      closemainwindow;
                                                                    end;
                                                                  freelist(@tliblist,sizeof(tlibnode));
                                                                end;
                                                              
                                                              if gtxbase<>nil then
                                                                closelibrary(gtxbase); 
                                                              if nofragbase<>nil then
                                                                closelibrary(nofragbase);
                                                              if amigaguidebase<>nil then
                                                                begin
                                                                  if amigaguidehandle<>nil then
                                                                    closeamigaguide(amigaguidehandle);
                                                                  closelibrary(amigaguidebase);
                                                                end;
                                                              
                                                              if editimagemenu<>nil then
                                                                freemenus(editimagemenu);
                                                              
                                                              freeasls;
                                                            end;
                                                        end
                                                       else
                                                        telluser(nil,memerror);
                                                      if image1.imagedata<>nil then
                                                        freemymem(image1.imagedata,288);  
                                                      if image2.imagedata<>nil then
                                                        freemymem(image2.imagedata,288);  
                                                      if image3.imagedata<>nil then
                                                        freemymem(image3.imagedata,288);  
                                                      if image4.imagedata<>nil then
                                                        freemymem(image4.imagedata,288);  
                                                      if getfileimage1.imagedata<>nil then
                                                        freemymem(getfileimage1.imagedata,112);  
                                                      if getfileimage2.imagedata<>nil then
                                                        freemymem(getfileimage2.imagedata,112);
                                                      if getfileimage3.imagedata<>nil then
                                                        freemymem(getfileimage3.imagedata,56);  
                                                      if getfileimage4.imagedata<>nil then
                                                        freemymem(getfileimage4.imagedata,56);  
                                                      
                                                      freemymem(pwaitpointer,72);
                                                    end
                                                   else
                                                    telluser(nil,memerror);
                                                  freevisualinfo(screenvisualinfo);
                                                end
                                               else
                                                telluser(nil,'Unable to get screen info.');
                                              deletemsgport(myprogramport);  
                                            end
                                           else
                                            telluser(nil,'Unable to open message port.');
                                          unlockpubscreen(nil,myscreen); 
                                        end
                                       else
                                        telluser(nil,'Unable to get screen.');
                                      
                                          closelibrary(diskfontbase);
                                        end
                                       else
                                        telluser(nil,'Unable to open diskfont library (V36).');

                                      if  gradientsliderbase<>nil then
                                        CloseLibrary(GradientSliderBase);
                                 	  if colorwheelbase<>nil then
                                 	    CloseLibrary(ColorWheelBase);

                                      
                                      closelibrary(aslbase);
                                    end
                                   else
                                    telluser(nil,'Unable to open asl library.');
                                  closelibrary(workbenchbase);
                                end
                               else
                                telluser(nil,'Unable to open workbench library.');
                              closelibrary(iconbase);
                            end
                           else
                            telluser(nil,'Unable to open icon library.');
                          closelibrary(iffparsebase);
                        end
                       else
                        telluser(nil,'Unable to open iffparse library.');
                      closelibrary(layersbase);
                    end
                   else
                    telluser(nil,'Unable to open layers library.');
                  closelibrary(gadtoolsbase);
                end
               else
                telluser(nil,'Unable to open Gadtools Library.');
              closelibrary(plibrary(utilitybase));
            end
           else
            telluser(nil,'Unable to open utility library.');
          closelibrary(plibrary(gfxbase));
        end
       else
        telluser(nil,'Unable to open Graphics library.');
      closelibrary(plibrary(intuitionbase));
    end
   else
    begin
      writeln('Unable To Open Intuition Library V37+');
      writeln('Need Release 2.04 Or Above To Run.');
    end;
{$ifdef TEST}
  if memused<>0 then
    writeln('UnFreed Memory : ',memused);
{$endif}
End.
