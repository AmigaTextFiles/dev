program asmproducer;

uses asl,utility,routines,exec,intuition,amiga,workbench,layers,icon,imagestuff,funcdefs,
     gadtools,graphics,dos,amigados,producerwininterface,definitions,iffparse,localestuff,menustuff,libstuff,producerlib,
     screenstuff;

const
  winname : string [80] ='CON:5/20/450/50/AsmProducer (C) Ian OConnor 1994'#0;
  nofiles : string [10] = 'No Files'#0;
var
  pwbs     : pwbstartup;
  pwbaa    : pwbargarray;
  paramnum : word;
  ds,ds2   : string;

function upstring(s:string):string;
var
  store : string;
  loop  : byte;
begin
  store:='';
  for loop:=1 to length(s) do
    store:=store+upcase(s[loop]);
  upstring:=store;
end;

function MainProcess(sfname : string):boolean;
var
  dummy           : long;
  dummy2          : long;
  pgsel           : pgadget;
  mess            : pintuimessage;
  ilist           : plist;
  done            : boolean;
  class           : long;
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
  res             : long;
  mainmicro       : long;
  maxlocalelen    : long;
  mainseconds     : long;
  globalincludeextra : string;
  skipone         : boolean;
  goforit         : boolean;
  pln             : plocalenode;
  pgn3,pgn4       : pgadgetnode;
  psn,psn2        : pstringnode;
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
  catname         : string;
  catnamebig      : string;
  pdsn,pdsn2      : pdesignerscreennode;
begin
  lastobject:=nil;
  includelocale:=false;
  linecount:=0;
  badfileb:=false;
  newlist(@localelabellist);
  bitmaprequired:=false;
  oksofar:=true;
  beveltags:=false;
  maxlocalelen:=0;
  includelocale:=false;
  procgetintegerfromgadadded:=false;
  procgetstringfromgadadded:=false;
  procgeneralgadtoolsgadadded:=false;
  procsettagitemadded:=false;
  procprintstringadded:=false;
  procstripintuimessagesadded:=false;
  procclosewindowsafelyadded:=false;
  proccheckedboxadded:=false;
  sharedwindow:=false;
  done:=false;
  filename:='';
  stringforme:=''#0;
  
  filename:=sfname+#0;
  
  cutname:=sfname;
  
  if length(cutname)>3 then
    if upstring(copy(cutname,length(cutname)-3,4))='.DES' then
      dec(cutname[0],4);
  destname:=filename;
  
  if upstring(copy(filename,length(filename)-4,5))='.DES'#0 then
    dec(destname[0],5);
  destname:=no0(destname);
  stringforme:=cutname+#0;
  
  setfilename(stringforme);
  
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar then
  begin
  
      doing(@loading[1]);
      res:=loaddesignerdata(producernode,@filename[1]);
      if res<>0 then
        begin
          doing(@LoadError[res,1]);
          oksofar:=false;
          badfileb:=true;
          delay_(50);
        end;
  
  end;
  
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
                processscreen(pdsn);
                pdsn:=pdsn^.ln_succ;
              end
             else
              begin
                done:=true;
              end;
      if not oksofar then
        done:=true;
      
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
          done:=true;
          oksofar:=false;
        end;
      
      {*************}
    
    end;

{*******************************************}
{*                                         *}
{*     Deal With Compiled Stuff            *}
{*                                         *}
{*******************************************}
  
  if bitmaprequired then
    if oksofar then
      dobitmapstuff;
  
  if oksofar then
    if producernode^.codeoptions[4] then
      processlibs
     else
      addlibxrefs;
  
  if producernode^.codeoptions[6] and oksofar then
    doopendiskfonts;
  
  if oksofar and producernode^.codeoptions[7] then
    begin
      doing(@mainfilestring[1]);
      makemainfilelist;
    end;
  
  if oksofar and producernode^.codeoptions[2] then
    begin
      makeimagemakefunction;
      addline(@constlist,'','');
      addline(@constlist,'   XDEF   WaitPointer','');
      addline(@externlist,'   XREF   WaitPointer','');
      addline(@constlist,'WaitPointer:','');
      addline(@constlist,'    dc.l    0','');
      addline(@constlist,'','');
      addline(@constlist,'WaitPointerData:','');
      addline(@constlist,'    dc.w    $0000,$0000,$0400,$07c0','');
      addline(@constlist,'    dc.w    $0000,$07c0,$0100,$0380','');
      addline(@constlist,'    dc.w    $0000,$07e0,$07c0,$1ff8','');
      addline(@constlist,'    dc.w    $1ff0,$3fec,$3ff8,$7fde','');
      addline(@constlist,'    dc.w    $3ff8,$7fbe,$7ffc,$ff7f','');
      addline(@constlist,'    dc.w    $7ffc,$ffff,$7ffc,$ffff','');
      addline(@constlist,'    dc.w    $3ff8,$7ffe,$3ff8,$7ffe','');
      addline(@constlist,'    dc.w    $1ff0,$3ffc,$07c0,$1ff8','');
      addline(@constlist,'    dc.w    $0000,$07e0,$0000,$0000','');
      addline(@constlist,'','');
    end
   else
    if (sizeoflist(plist(@producernode^.imagelist))>0) and oksofar then
      makeimagemakefunction;
  
  if oksofar then
    setlinenumber;
  
  if oksofar then 
    doing(@tidyup[1])
   else
    if not badfileb then
      if not done then
        doing(@failed[1]);
  
  if oksofar then
    setlinenumber;
  if oksofar and sharedwindow then
    begin
      addprocstripintuimessages;
      addprocclosewindowsafely;
    end;
  
  setlinenumber;
  
  if oksofar and (producernode^.localecount>0) then
    begin
      
        res:=0;
        pln := plocalenode(producernode^.localelist.mlh_head);
        while (pln^.ln_succ<>nil) do
          begin
            addline(@localestringlist,sfp(pln^.ln_label)+'Data:','');
  			
  			addline(@localestringlist,'    dc.b    '''+sfp(pln^.ln_string)+''',0','');
            addline(@localelabellist,'    dc.l    '+sfp(pln^.ln_label)+'Data','');
  			
            str(res,s);
            inc(res);
            addline(@localeidlist,sfp(pln^.ln_label)+copy('                                          '
                 ,1,40-length(sfp(pln^.ln_label)))+'    EQU    '+s,'');
            if length(sfp(pln^.ln_string))>maxlocalelen then
              maxlocalelen:=length(sfp(pln^.ln_string));
            pln := pln^.ln_succ;
          end;

      
      addlinefront(@localelabellist,sfp(producernode^.basename)+'_Strings:','');
      addlinefront(@localestringlist,'','');
      addline(@localestringlist,'    cnop    0,2','');
      
    end;
  
  if oksofar and (producernode^.localecount>0) then
    setuplocalestuff;

  
  { Format File Properly }
  
  if oksofar then
    begin
      
      {
      addlinefront(@defineslist,'#define GetString( gad )   ((( struct '+
               'StringInfo * )gad->SpecialInfo )->Buffer  )','');
      addlinefront(@defineslist,'#define GetNumber( gad )   ((( struct'+
               ' StringInfo * )gad->SpecialInfo )->LongInt )','');
      }

      addlinefront(@procfuncdefslist,'','');
      addline(@defineslist,'','');
      
      if not producernode^.codeoptions[11] then
        ilist:=@typelist
       else
        ilist:=@defineslist;
      
      s:=no0(stringforme)+'.h';
      
      tempstring92:='';
      globalincludeextra:=sfp(producernode^.includes);
      if no0(globalincludeextra)<>'' then
        begin
          looppos:=0;
          repeat
            inc(looppos);
            if globalincludeextra[looppos]<>',' then
              begin
                tempstring92:=tempstring92+globalincludeextra[looppos];
              end
             else
              begin
                if tempstring92<>'' then
                  addlinefront(@typelist,'    include    '+tempstring92,'');
                tempstring92:='';
              end;
          until looppos=length(no0(globalincludeextra));
          if tempstring92<>'' then
            addlinefront(ilist,'    include    '+tempstring92,'');
        end;
      
      addlinefront(@typelist,'','');
      {
      addlinefront(@typelist,'#include "'+s+'"','');
      }
      {
      addlinefront(ilist,'','');
      addlinefront(ilist,'#include <clib/diskfont_protos.h>','');
      addlinefront(ilist,'#include <string.h>','');
      addlinefront(ilist,'#include <clib/utility_protos.h>','');
      addlinefront(ilist,'#include <clib/graphics_protos.h>','');
      addlinefront(ilist,'#include <clib/gadtools_protos.h>','');
      addlinefront(ilist,'#include <clib/intuition_protos.h>','');
      addlinefront(ilist,'#include <clib/wb_protos.h>','');
      addlinefront(ilist,'#include <clib/exec_protos.h>','');
      if includelocale then
        addlinefront(ilist,'#include <clib/locale_protos.h>','');
      addlinefront(ilist,'#include <workbench/workbench.h>','');
      addlinefront(ilist,'#include <graphics/gfxbase.h>','');
      addlinefront(ilist,'#include <libraries/gadtools.h>','');
      addlinefront(ilist,'#include <intuition/gadgetclass.h>','');
      addlinefront(ilist,'#include <intuition/intuition.h>','');
      addlinefront(ilist,'#include <intuition/screens.h>','');
      addlinefront(ilist,'#include <exec/memory.h>','');
      if includelocale then
        addlinefront(ilist,'#include <libraries/locale.h>','');
      addlinefront(ilist,'#include <exec/types.h>','');
      }
      
      addthings;
      
      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,';*********************************************','');
      addlinefront(@defineslist,';*                                           *','');
      addlinefront(@defineslist,';*     Designer Produced Asm source file     *','');
      addlinefront(@defineslist,';*                                           *','');
      addlinefront(@defineslist,';*       Designer (C) Ian OConnor 1994       *','');
      addlinefront(@defineslist,';*                                           *','');
      addlinefront(@defineslist,';*********************************************','');
      
      addlinefront(@typelist,'','');
      addlinefront(@typelist,';*********************************************','');
      addlinefront(@typelist,';*                                           *','');
      addlinefront(@typelist,';*     Designer Produced Asm include file    *','');
      addlinefront(@typelist,';*                                           *','');
      addlinefront(@typelist,';*       Designer (C) Ian OConnor 1994       *','');
      addlinefront(@typelist,';*                                           *','');
      addlinefront(@typelist,';*********************************************','');
      addline(@procfuncdefslist,'','');
      addline(@procfunclist,'','');
    end;
  
  if oksofar then
    begin
      addline(@procfunclist,'    ','');
      addline(@procfunclist,'    end','');
    end;
  if oksofar then
    inc(linecount);
  if oksofar then
    setlinenumber;
  
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar then
    begin
      doing(@writingfile[1]);
      destname:=destname+'.s'#0;
      destfile:=open(@destname[1],mode_newfile);
      if destfile<>bptr(nil) then
        begin
          
          { main file }
          
          writelisttofile(@typelist,destfile);
          writelisttofile(@constlist,destfile);
          if sizeoflist(@localestringlist)>0 then
            begin
              writelisttofile(@localeidlist,destfile);
              writelisttofile(@localelabellist,destfile);
              writelisttofile(@localestringlist,destfile);
            end;
          writelisttofile(@fontlist,destfile);
          writelisttofile(@varlist,destfile);
          if (not producernode^.codeoptions[7]) and (producernode^.codeoptions[3]) then
              begin
                addlinefront(@idcmplist,'; copied into your program, not edited in this file, ','');
                addlinefront(@idcmplist,'; Procedures to handle IDCMP events should be        ','');
                addlinefront(@idcmplist,'','');
                setlinenumber;
                writelisttofile(@idcmplist,destfile);
              end;
          writelisttofile(@procfunclist,destfile);
          if not close_(destfile) then
            begin
              doing(@fileunclose[1]);
              oksofar:=false;
            end;
          
          if not oksofar then
            begin
              { delete file? }
            end;
        
        end
       else
        begin
          oksofar:=false;
          doing(@fileunopen[1]);
        end;
    end;
  maindestname:=copy(destname,1,length(destname)-3)+'Main.s'#0;
    
  if oksofar and producernode^.codeoptions[8] then
    begin
      doing(@catalogfile[1]);
      oksofar:=boolean(WriteLocaleCD(producernode));
    end;
    
  if oksofar and producernode^.codeoptions[8] then
    begin
      doing(@catalogfile[1]);
      oksofar:=boolean(WriteLocaleCT(producernode));
    end;

  if oksofar then
    oksofar:=checkinput;
    
  if oksofar and (producernode^.codeoptions[7]) then
    if (godome(@maindestname[1])) then
      begin
        doing(@makemainfile[1]);
        if producernode^.codeoptions[3] then
          addline(@idcmplist,'    end','')
         else
          addline(@mainfilelist,'    end','');
        
        maindestfile:=open(@maindestname[1],mode_newfile);
        if maindestfile<>bptr(nil) then
          begin
            addlinefront(@mainfilelist,'    include    '+no0(stringforme)+'.i','');
            addlinefront(@mainfilelist,'','');
            addlinefront(@mainfilelist,'; Compile me to get full executable','');
            setlinenumber;
            writelisttofile(@mainfilelist,maindestfile);
            if producernode^.codeoptions[3] then
              writelisttofile(@idcmplist,maindestfile);
            if not close_(maindestfile) then
              begin
                doing(@fileunclose[1]);
                oksofar:=false;
              end;
          end
         else
          begin
            oksofar:=false;
            doing(@fileunopen[1]);
          end;
      end;
  
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar then
    begin
      doing(@writingfile[1]);
      dec(destname[0],2);
      destname:=destname+'i'#0;
      destfile:=open(@destname[1],mode_newfile);
      if destfile<>bptr(nil) then
        begin
          
          { header file }
          {
          addlinefront(@defineslist,'#define GetString( gad )   ((( struct '+
                'StringInfo * )gad->SpecialInfo )->Buffer  )','');
          addlinefront(@defineslist,'#define GetNumber( gad )   ((( struct'+
                ' StringInfo * )gad->SpecialInfo )->LongInt )','');
          }
          writelisttofile(@defineslist,destfile);
          
          writelisttofile(@fontexternlist,destfile);


          writelisttofile(@externlist,destfile);

          writelisttofile(@procfuncdefslist,destfile);
          
          if not close_(destfile) then
            doing(@fileunclose[1]);
          if not oksofar then
            begin
              { delete file? }
            end;
        end
       else
        begin
          doing(@fileunopen[1]);
          oksofar:=false;
        end;
    end;


{*******************************************}
{*                                         *}
{*       Free Allocated resources          *}  
{*                                         *}
{*******************************************}
  
  if oksofar then
    doing(@alldone[1]);
  freelist(@constlist);
  FreeDesignerData(producernode);
  freelist(@varlist);
  freelist(@procfuncdefslist);
  freelist(@typelist);
  freelist(@procfunclist);
  freelist(@idcmplist);
  freelist(@defineslist);
  freelist(@externlist);
  freelist(@fontlist);
  freelist(@fontexternlist);
  freelist(@localestringlist);
  freelist(@opendiskfontlist);
  freelist(@mainfilelist);
  freelist(@localelabellist);
  freelist(@localeidlist);
  freelist(@extern2list);
  
  mainprocess:=oksofar;
{*******************************************}

end;

{$I /generalproducer/filenames.pas}

Begin
  
  wbwindowname:=strptr(@winname[1]);
  wbexitdelay:=5000;
  newlist(@mainfilelist);
  newlist(@constlist);
  newlist(@varlist);
  newlist(@typelist);
  newlist(@procfuncdefslist);
  newlist(@procfunclist);
  newlist(@idcmplist);
  newlist(@defineslist);
  newlist(@externlist);
  newlist(@fontlist);
  newlist(@fontexternlist);
  newlist(@opendiskfontlist);
  newlist(@extern2list);
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
                    
                      iffparsebase:=openlibrary('iffparse.library',37);
                      if iffparsebase<>nil then
                        begin
                          iconbase:=openlibrary('icon.library',37);
                          if iconbase<>nil then
                            begin
                              workbenchbase:=openlibrary('workbench.library',37);
                              if workbenchbase<>nil then
                                begin
                                                      producerbase:=openlibrary('producer.library',0);
                                                      
                                                      if producerbase<>nil then
                                                        begin
                                                          processfiles;
                                                          closelibrary(producerbase);
                                                        end
                                                       else
                                                        writeln('Requires producer.library to run.');
                                                      
                                                  
                                  closelibrary(workbenchbase);
                                end
                               else
                                writeln('Cannot open workbench');
                              closelibrary(iconbase);
                            end
                           else
                            writeln(('Cannot open icon library'));
                          
                          closelibrary(iffparsebase);
                        end
                       else
                        writeln(('Cannot open iffparse library'));
                      
                  closelibrary(gadtoolsbase);
                end
               else
                writeln(('Cannot open Gadtools Library'));
              closelibrary(plibrary(utilitybase));
            end
           else
            writeln(('Cannot open utility library'));
          closelibrary(plibrary(gfxbase));
        end
       else
        writeln(('Cannot open Graphics library'));
      closelibrary(plibrary(intuitionbase));
    end
   else
    begin
      writeln('Unable To Open Intuition Library V37+,');
      writeln('Need Release 2.04 Or Above To Run.');
    end;
  if memused<>0 then
    writeln('UnFreed Memory Blocks : ',memused);
End.
