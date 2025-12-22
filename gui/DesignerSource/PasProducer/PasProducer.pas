program pasproducer;

{ (C) Ian OConnor 1993/4 }

uses asl,utility,routines,exec,intuition,amiga,workbench,layers,icon,screenstuff,producerlib,
     gadtools,graphics,dos,amigados,producerwininterface,definitions,iffparse,images,menus,
     localestuff,mainstuff,functions,liststuff,windowstuff,fonts,libraries;

const
  winname : string [80] ='CON:5/20/450/50/PasProducer (C) Ian OConnor 1994'#0;
  nofiles : string [10] = 'No Files'#0;
var
  pwbs     : pwbstartup;
  pwbaa    : pwbargarray;
  paramnum : word;
  ds,ds2   : string;

function upstring(s:string) : string;
var
  loop : word;
  dest : string;
begin
  dest:='';
  for loop:=1 to length(s) do
    dest:=dest+upcase(s[loop]);
  upstring:=dest;
end;

function MainProcess(sfname : string): boolean;
var
  dummy           : long;
  dummy2          : long;
  pgsel           : pgadget;
  mess            : pintuimessage;
  pln             : plocalenode;
  res             : long;
  done            : boolean;
  class           : long;
  hspascal        : string[30];
  code            : word;
  pdwn            : pdesignerwindownode;
  pbbn            : pbevelboxnode;
  pgn,pgn2        : pgadgetnode;
  minx,miny       : word;
  maxx,maxy       : word;
  psin            : psmallimagenode;
  count           : word;
  st              : string;
  pin,pin2        : pimagenode;
  ptn,ptn2        : ptextnode;
  tags            : array[1..6] of ttagitem;
  filename        : string;
  destname        : string;
  maindestname    : string;
  pdwn2           : pdesignerwindownode;
  dummy3          : long;
  pdmn            : pdesignermenunode;
  signals         : long;
  destfile        : bptr;
  maindestfile    : bptr;
  dataicon        : pdiskobject;
  cutname         : string;
  stringforme     : string[50];
  s               : string;
  badfileb        : boolean;
  arg             : pwbarg;
  start           : pwbstartup;
  s2              : string;
  destdir         : string;
  pdsn,pdsn2      : pdesignerscreennode;
  globalincludeextra : string;
  spec            : string[20];
  maxlocalelen    : long;
  catname         : string;
begin
  hspascal:='HSPASCAL:HSPASCAL'#0;
  maxlocalelen:=0;
  badfileb:=false;
  linecount:=0;
  oksofar:=true;
  done:=false;
  filename:='';
  stringforme:=''#0;
  newlist(@localelabellist);
  
  cutname:=sfname;
  
  { remove .des from filename }
  
  if length(cutname)>3 then
    if upstring(copy(cutname,length(cutname)-3,4))='.DES' then
      dec(cutname[0],4);
  
  filename:=sfname+#0; { source file }
  
  { set up destname }
  
  destname:=filename;
  if upstring(copy(filename,length(filename)-4,5))='.DES'#0 then
  dec(destname[0],5);
  destname:=no0(destname)+'.pas'#0;
  stringforme:=cutname+#0;
      
  { read all data }
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar then
    begin
      setfilename(stringforme);
      doing(@loading[1]);
      res := LoadDesignerData(producernode,@filename[1]);
      if res<>0 then
        begin
          doing(@loaderror[res,1]);
          oksofar:=false;
          badfileb:=true;
          delay_(50);
        end;
  end;
  
  { go through all created stuff }
  
  comment:=producernode^.codeoptions[1];
  
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  pdmn:=pdesignermenunode(producernode^.menulist.mlh_head);
  pdwn:=pdesignerwindownode(producernode^.windowlist.mlh_head);
  pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
  while (not done) and oksofar do
    begin
      if (pin^.ln_succ<>nil) then
        begin
          doing(pin^.in_label);
          processimage(pin);
          pin:=pin^.ln_succ;
        end
       else
        if (pdmn^.ln_succ<>nil) then
          begin
            doing(pdmn^.mn_label);
            processmenu(pdmn);
            pdmn:=pdmn^.ln_succ;
          end
         else
          if (pdwn^.ln_succ<>nil) then
            begin
              doing(@pdwn^.title[1]);
              processwindow(pdwn);
              pdwn:=pdwn^.ln_succ;
            end
           else
            if (pdsn^.ln_succ<>nil) then
              begin
                doing(pdsn^.sn_label);
                processscreen(pdsn);
                pdsn:=pdsn^.ln_succ;
              end
             else
              begin
                done:=true;
              end;
       
      {**********************************}
      {*                                *}
      {*    Update Main Window Info     *}
      {*                                *}
      {**********************************}
      
      setlinenumber;
      
      {**********************************}
      {*                                *}
      {*   Check input port for abort   *}
      {*                                *}
      {**********************************}
      
      if not checkinput then
        begin
          oksofar:=false;
          done:=false;
        end;
            
      {*************}
    
    end;

{*******************************************}
{*                                         *}
{*     Deal With Compiled Stuff            *}  
{*                                         *}
{*******************************************}
  
  if oksofar and producernode^.codeoptions[6] and (sizeoflist(@opendiskfontlist)>0)then
    doopendiskfonts;
  
  if oksofar and producernode^.codeoptions[4] then
    processlibs;
  
  if oksofar and producernode^.codeoptions[7] then
    begin
      doing(@mainfilestring[1]);
      makemainfilelist;
    end;
  
  if oksofar and producernode^.codeoptions[2] then
    makewaitpointer;
  
  if oksofar and ((sizeoflist(plist(@producernode^.imagelist))>0) or (producernode^.codeoptions[2])) then
    makeimagemakefunction;
  
  { update line count gadget }
  setlinenumber;
  
  if oksofar and (sizeoflist(plist(@producernode^.menulist))>0) then
    begin
      addline(@typelist,'','');
      addline(@typelist,'  PNewMenuArray = ^TNewMenuArray;','');
      addline(@typelist,'  TNewMenuArray = array [1..10000] of tnewmenu;','');
    end;
  
  if oksofar then 
    doing(@tidyup[1])
   else
    if not badfileb then
      if done then
        doing(@failed[1]);
  
  { update line count gadget }
  setlinenumber;

  { add all procedures required in pascal }
  { could have made addition conditional but this is easier }
  
  if oksofar then
    begin
      addprocsettagitem;
      addprocprintstring;
      addprocstripintuimessages;
      addprocclosewindowsafely;
      addprocgeneralgadtoolsgad;
      addprocgetstringfromgad;
      addprocgetintegerfromgad;
      addproccheckedbox;
      addprocgtsetsingle;
      addopenwindowtaglistnicely;
      addfreebitmap;
    end;
    
  { update line count gadget }
  setlinenumber;
  
  
  
  if producernode^.localecount>0 then
    if oksofar then
      begin
        res:=0;
        pln := plocalenode(producernode^.localelist.mlh_head);
        while (pln^.ln_succ<>nil) do
          begin
            
            addline(@localestringlist,'  '''+sfp(pln^.ln_string)+'''#0,','');
            str(res,s);
            inc(res);
            addline(@localelabellist,'  '+sfp(pln^.ln_label)+' = '+s+';','');
            if length(sfp(pln^.ln_string))>maxlocalelen then
              maxlocalelen:=length(sfp(pln^.ln_string));
            pln := pln^.ln_succ;
          end;
        setuplocalestuff;
      end;
  
  { pascal needs locale base definition }
  if producernode^.openlibs[23] and (not producernode^.codeoptions[13]) and oksofar then
    addline(@varlist,'  LocaleBase : plibrary;','');
  
  { Format File Properly }
  
  if oksofar then
    begin
      
      if sizeoflist(@typelist)>0 then
        addlinefront(@typelist,'Type','');
      s:='';
      addlinefront(@procfuncdefslist,'','');
      
      { sort out units to include }
      
      if producernode^.openlibs[3] then s:=s+'commodities,';
      if producernode^.openlibs[11] then s:=s+'keymap,';
      if producernode^.openlibs[8] then s:=s+'icon,';
      if producernode^.openlibs[9] then s:=s+'iffparse,';
      if producernode^.openlibs[2] then s:=s+'asl,';
      if producernode^.openlibs[5] then s:=s+'expansion,';
      if s<>'' then
        begin
          dec(s[0],1);
          
          { note aaddlinetoFRONT below }
          
          addlinefront(@procfuncdefslist,'     '+s+';','');
          s:=',';
        end
       else
        s:=';';
      
      if producernode^.openlibs[18] then s:=',rexx'+s;
      if producernode^.openlibs[20] then s:=',translator'+s;
      if producernode^.openlibs[19] then s:=',reqtools'+s;
      if producernode^.openlibs[1] then s:=',arp'+s;
      if producernode^.openlibs[12] then s:=',layers'+s;
      
      addlinefront(@procfuncdefslist,'     workbench,utility'+s,'');
      
      { sort out user defined extra units ( from designer main code window )}
      
      globalincludeextra := sfp(producernode^.includes);
      if no0(globalincludeextra)<>'' then
        begin
          globalincludeextra:=no0(globalincludeextra);
          if globalincludeextra[length(globalincludeextra)]<>',' then
            globalincludeextra:=globalincludeextra+',';
          addlinefront(@procfuncdefslist,'     '+globalincludeextra,'');
        end;
      
      spec:='';
      if producernode^.codeoptions[13] then
        spec:='obsolete,locale,';
      
      addlinefront(@procfuncdefslist,'Uses exec,'+spec+'intuition,gadtools,graphics,amiga,diskfont,','');
      
      { finish off the file }
      
      addlinefront(@procfuncdefslist,'','');
      addlinefront(@procfuncdefslist,'Interface','');
      addlinefront(@procfuncdefslist,'','');
      addlinefront(@procfuncdefslist,'Unit '+cutname+';','');
      addlinefront(@procfuncdefslist,'','');
      addlinefront(@procfuncdefslist,'{*********************************************}','');
      addlinefront(@procfuncdefslist,'{*                                           *}','');
      addlinefront(@procfuncdefslist,'{*       Designer Produced Pascal Unit       *}','');
      addlinefront(@procfuncdefslist,'{*                                           *}','');
      addlinefront(@procfuncdefslist,'{*       Designer (C) Ian OConnor 1994       *}','');
      addlinefront(@procfuncdefslist,'{*                                           *}','');
      addlinefront(@procfuncdefslist,'{*********************************************}','');
      
      if sizeoflist(@varlist)>0 then
        begin
          addlinefront(@varlist,'Var','');
          addline(@varlist,'','');
        end;
      if sizeoflist(@constlist)>0 then
        begin
          addlinefront(@constlist,'','');
          addlinefront(@constlist,'const','');
          addlinefront(@constlist,'','');
        end;
      
      addline(@procfuncdefslist,'','');
      addline(@procfunclist,'','');
      if (not producernode^.codeoptions[3])or(producernode^.codeoptions[7]) then
        addlinefront(@procfunclist,'Implementation','')
       else
        begin
          addlinefront(@idcmplist,'Implementation','');
          addline(@idcmplist,'','');
        end;
      addlinefront(@initlist,'Begin','');
      addline(@initlist,'End.','');
    end;
  
  {  add locale strings definitions to list }
  
  if oksofar and (producernode^.localecount>0) then
    begin
      str(producernode^.localecount,s);
      str(maxlocalelen+1,s2);
      addlinefront(@localestringlist,'  (','');
      addlinefront(@localestringlist,'  ProgramStrings : array[0..'+s+'] of string['+s2+'] =','');
      addlinefront(@localestringlist,'','');
      addline(@localestringlist,'  ''''#0','');
      addline(@localestringlist,'  );','');
      addlinefront(@localelabellist,'','');
    end;
  if oksofar then
    inc(linecount);
  
  { update line count gadget }
  setlinenumber;
  
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar then
    begin
      doing(@writingfile[1]);
      destfile:=open(@destname[1],mode_newfile);
      if destfile<>bptr(nil) then
        begin
          writelisttofile(@procfuncdefslist,destfile);
          writelisttofile(@typelist,destfile);
          writelisttofile(@constlist,destfile);
          writelisttofile(@localelabellist,destfile);
          writelisttofile(@localestringlist,destfile);
          
          writelisttofile(@varlist,destfile);
          if (not producernode^.codeoptions[7]) and (producernode^.codeoptions[3]) then
            begin
              addlinefront(@idcmplist,'{ copied into your program, not edited in this unit. }','');
              addlinefront(@idcmplist,'{ Procedures to handle IDCMP events should be }','');
              addlinefront(@idcmplist,'','');
              setlinenumber;

       
              writelisttofile(@idcmplist,destfile);
            end;
          writelisttofile(@procfunclist,destfile);
          writelisttofile(@initlist,destfile);
          if not close_(destfile) then
            doing(@fileunclose[1])
           else
            begin
              
              { create file icon }
              
              if oksofar then
                begin
                  dataicon:=getdefdiskobject(wbproject);
                  if dataicon<>nil then
                    begin
                      dataicon^.do_defaulttool:=@hspascal[1];
                      if not putdiskobject(@destname[1],dataicon) then;
                      dataicon^.do_defaulttool:=nil;
                      freediskobject(dataicon);
                    end;
                end;
            end;
          if not oksofar then
            begin
              { delete file? }
            end;
        end
       else
        doing(@fileunopen[1]);
    end;
  
  maindestname:=copy(destname,1,length(destname)-5)+'Main.pas'#0;
  
  { produce .cd file - do not need to change }
  
  if producernode^.codeoptions[8] and oksofar then
    begin
      doing(@catalogfile[1]);
      oksofar:=boolean(WriteLocaleCD(producernode));
    end;
  
  { produce .ct file - do not need to change }
  
  if producernode^.codeoptions[9] and oksofar then
    begin
      doing(@catalogfile[1]);
      oksofar:=boolean(WriteLocaleCT(producernode));
    end;
  
  { .ct file done }
  
  { produce main file }
  if (producernode^.codeoptions[7]) and oksofar then
    oksofar:=checkinput;
  
  if (producernode^.codeoptions[7]) and oksofar then
    if (godome(@maindestname[1])) then
      begin
        maindestfile:=open(@maindestname[1],mode_newfile);
        if maindestfile<>bptr(nil) then
          begin
            doing(@makemainfile[1]);
            spec:='';
            if producernode^.codeoptions[13] then
              spec:='locale,obsolete,';
            if producernode^.codeoptions[3] then
              begin
                addlinefront(@idcmplist,'     workbench,utility,'+cutname+';','');
                addlinefront(@idcmplist,'Uses '+spec+'exec,intuition,gadtools,graphics,amiga,diskfont,','');
                addlinefront(@idcmplist,'','');
                addlinefront(@idcmplist,'program '+no0(stringforme)+'Main;','');
              end
             else
              begin
                addlinefront(@mainfilelist,'     workbench,'+spec+'utility,'+cutname+';','');
                addlinefront(@mainfilelist,'Uses exec,intuition,gadtools,graphics,amiga,diskfont,','');
                addlinefront(@mainfilelist,'','');
                addlinefront(@mainfilelist,'program '+no0(stringforme)+'Main;','');
              end;
            setlinenumber;

            if producernode^.codeoptions[3] then
              writelisttofile(@idcmplist,maindestfile);
            writelisttofile(@mainfilelist,maindestfile);
            if not close_(maindestfile) then
              begin
                doing(@fileunclose[1]);
                oksofar:=false;
              end
             else
              begin
                if oksofar then
                  begin
                    dataicon:=getdefdiskobject(wbproject);
                    if dataicon<>nil then
                      begin
                        dataicon^.do_defaulttool:=@hspascal[1];
                        if not putdiskobject(@maindestname[1],dataicon) then;
                        dataicon^.do_defaulttool:=nil;
                        freediskobject(dataicon);
                      end;
                  end;

              end;
          end
         else
          begin
            oksofar:=false;
            doing(@fileunopen[1]);
          end;
      end;
   
{*******************************************}
{*                                         *}
{*       Free Allocated resources          *}  
{*                                         *}
{*******************************************}
  
  if oksofar then
    doing(@alldone[1]);
  FreeDesignerData(producernode);
  freelist(@constlist);
  freelist(@varlist);
  freelist(@typelist);
  freelist(@procfuncdefslist);
  freelist(@procfunclist);
  freelist(@initlist);
  freelist(@idcmplist);
  freelist(@opendiskfontlist);
  freelist(@mainfilelist);
  freelist(@localestringlist);
  freelist(@localelabellist);
  
  mainprocess:=oksofar;
  
{*******************************************}

end;

{$I /generalproducer/filenames.pas}

Begin
  
  { init vars, open libraries }
  
  wbwindowname:=strptr(@winname[1]);
  
  wbexitdelay:=5000;
  newlist(@mainfilelist);
  newlist(@constlist);
  newlist(@varlist);
  newlist(@typelist);
  newlist(@procfuncdefslist);
  newlist(@procfunclist);
  newlist(@initlist);
  newlist(@idcmplist);
  newlist(@opendiskfontlist);
  newlist(@localelabellist);
  newlist(@localestringlist);
  memused:=0;
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
                                                              
                                                              { handle multiple files in either environment }
                                                              { you should not need to change this }  
                                                              
                                                              producerbase:=openlibrary('producer.library',0);
                                                              if producerbase<>nil then
                                                                begin
                                                                  processfiles;
                                                                  closelibrary(producerbase);
                                                                end
                                                               else
                                                                writeln('Requires producer.library to run.');

                                                      { free stuff }
                                                              
                                                                
                                      closelibrary(aslbase);
                                    end
                                   else
                                    writeln('Unable to open asl librray ');
                                  closelibrary(workbenchbase);
                                end
                               else
                                writeln('Unable to open workbench library');
                              closelibrary(iconbase);
                            end
                           else
                            writeln('Unable to open icon library');
                          
                          closelibrary(iffparsebase);
                        end
                       else
                        writeln('Unable to open iffparse library');
                      closelibrary(layersbase);
                    end
                   else
                    writeln('Unable to open layers library');
                  closelibrary(gadtoolsbase);
                end
               else
                writeln('Unable to open Gadtools Library');
              closelibrary(plibrary(utilitybase));
            end
           else
            writeln('Unable to open utility library');
          closelibrary(plibrary(gfxbase));
        end
       else
        writeln('Unable to open Graphics library');
      closelibrary(plibrary(intuitionbase));
    end
   else
    begin
      Writeln('Unable To Open Intuition Library V37+,');
      writeln('Need Release 2.04 Or Above To Run.');
    end;
  
  { check allocated and freed memory }
  { if negative then panic... }
  
  if memused<>0 then
    writeln('UnFreed Memory Blocks : ',memused);
  
End.
