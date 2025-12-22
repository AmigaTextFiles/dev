program cproducer;

uses asl,utility,routines,exec,intuition,amiga,workbench,layers,icon,producerlib,
     gadtools,graphics,dos,amigados,producerwininterface,definitions,iffparse,screenstuff;

const
  winname : string [80] ='CON:5/20/450/50/CProducer (C) Ian OConnor 1994'#0;
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
  pln             : plocalenode;
  maxlocalelen    : long;
  tags            : array[1..6] of ttagitem;
  filename        : string;
  destname        : string;
  maindestname    : string;
  pdwn2           : pdesignerwindownode;
  mainmicro       : long;
  mainseconds     : long;
  skipone         : boolean;
  goforit         : boolean;
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
  catname2        : string[50];
  globalincludeextra : string;
  catnamebig      : string;
  pdsn,pdsn2      : pdesignerscreennode;
  res : long;
begin
  beveltags:=false;
  maxlocalelen:=0;
  includelocale:=false;
  linecount:=0;
  badfileb:=false;
  oksofar:=true;
  beveltags:=false;
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
  lastobject:=nil;
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
    res := LoadDesignerData( producernode, @filename[1]);
    if res<>0 then
      begin
        doing(@Loaderror[res,1]);
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
  while (not done) do
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
            if pdsn^.ln_succ<>nil then
              begin
                doing(pdsn^.sn_title);
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
          oksofar:=false;
          done:=true;
        end;
      
      {*************}
    
    end;

{*******************************************}
{*                                         *}
{*     Deal With Compiled Stuff            *}
{*                                         *}
{*******************************************}
  
  if oksofar and producernode^.codeoptions[4] then
    processlibs;
  
  if oksofar and producernode^.codeoptions[6] and (sizeoflist(@opendiskfontlist)>0) then
    doopendiskfonts;
  
  if oksofar and producernode^.codeoptions[7] then
    begin
      doing(@mainfilestring[1]);
      makemainfilelist;
    end;
  
  if oksofar then
    oksofar:=checkinput;
  
  if oksofar and producernode^.codeoptions[2] then
    begin
      makeimagemakefunction;
      addline(@constlist,'','');
      addline(@externlist,'extern APTR WaitPointer;','');
      if producernode^.codeoptions[5] then
        addline(@constlist,'APTR WaitPointer = &WaitPointerData[0];','')
       else
        addline(@constlist,'APTR WaitPointer = NULL;','');
      addline(@externlist,'extern UWORD WaitPointerData[];','');
      if producernode^.codeoptions[5] then
        addline(@constlist,'UWORD __chip WaitPointerData[] =','')
       else
        addline(@constlist,'UWORD WaitPointerData[] =','');
      addline(@constlist,'    {','');
      addline(@constlist,'    0x0000,0x0000,0x0400,0x07c0,','');
      addline(@constlist,'    0x0000,0x07c0,0x0100,0x0380,','');
      addline(@constlist,'    0x0000,0x07e0,0x07c0,0x1ff8,','');
      addline(@constlist,'    0x1ff0,0x3fec,0x3ff8,0x7fde,','');
      addline(@constlist,'    0x3ff8,0x7fbe,0x7ffc,0xff7f,','');
      addline(@constlist,'    0x7ffc,0xffff,0x7ffc,0xffff,','');
      addline(@constlist,'    0x3ff8,0x7ffe,0x3ff8,0x7ffe,','');
      addline(@constlist,'    0x1ff0,0x3ffc,0x07c0,0x1ff8,','');
      addline(@constlist,'    0x0000,0x07e0,0x0000,0x0000','');
      addline(@constlist,'    };','');
    end
   else
    if oksofar and (sizeoflist(plist(@producernode^.imagelist))>0) then
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
  if oksofar then
    setlinenumber;
    
  if oksofar and (producernode^.localecount>0) then
    begin
      
        res:=0;
        pln := plocalenode(producernode^.localelist.mlh_head);
        while (pln^.ln_succ<>nil) do
          begin
            
            addline(@localestringlist,'  (STRPTR)"'+sfp(pln^.ln_string)+'",','');
            str(res,s);
            inc(res);
            addline(@defineslist,'#define  '+sfp(pln^.ln_label)+'   '+s+'','');
            if length(sfp(pln^.ln_string))>maxlocalelen then
              maxlocalelen:=length(sfp(pln^.ln_string));
            pln := pln^.ln_succ;
          end;

      
      addlinefront(@localestringlist,'{','');
      addlinefront(@localestringlist,'STRPTR '+sfp(producernode^.basename)+'_Strings[] =','');
      addlinefront(@localestringlist,'','');
      addline(@localestringlist,'};','');
    end;
  
  if oksofar and (producernode^.localecount>0) then
    setuplocalestuff;

  if oksofar then
    oksofar:=checkinput;
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
      
      
      
      { here we go  17/12/95 }
      
      
      s:=no0(stringforme)+'.h';
      
      addlinefront(@typelist,'','');
      addlinefront(@typelist,'#include "'+s+'"','');
      
      
      
      
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
                  addlinefront(@typelist,'#include "'+tempstring92+'"','');
                tempstring92:='';
              end;
          until looppos=length(no0(globalincludeextra));
          if tempstring92<>'' then
            addlinefront(ilist,'#include "'+tempstring92+'"','');
        end;
      
      
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
      addlinefront(ilist,'#include <graphics/scale.h>','');
      addlinefront(ilist,'#include <workbench/workbench.h>','');
      addlinefront(ilist,'#include <graphics/gfxbase.h>','');
      addlinefront(ilist,'#include <utility/utility.h>','');
      addlinefront(ilist,'#include <diskfont/diskfont.h>','');
      
      addlinefront(ilist,'#include <libraries/gadtools.h>','');
      addlinefront(ilist,'#include <intuition/gadgetclass.h>','');
      addlinefront(ilist,'#include <intuition/intuition.h>','');
      addlinefront(ilist,'#include <intuition/screens.h>','');
      addlinefront(ilist,'#include <dos/dosextens.h>','');
      
      addlinefront(ilist,'#include <exec/memory.h>','');
      if includelocale then
        addlinefront(ilist,'#include <libraries/locale.h>','');
      addlinefront(ilist,'#include <exec/types.h>','');

      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,'','');
      addlinefront(@defineslist,'/*********************************************/','');
      addlinefront(@defineslist,'/*                                           */','');
      addlinefront(@defineslist,'/*      Designer Produced C header file      */','');
      addlinefront(@defineslist,'/*                                           */','');
      addlinefront(@defineslist,'/*       Designer (C) Ian OConnor 1994       */','');
      addlinefront(@defineslist,'/*                                           */','');
      addlinefront(@defineslist,'/*********************************************/','');
      
      addlinefront(@typelist,'','');
      addlinefront(@typelist,'/*********************************************/','');
      addlinefront(@typelist,'/*                                           */','');
      addlinefront(@typelist,'/*      Designer Produced C include file     */','');
      addlinefront(@typelist,'/*                                           */','');
      addlinefront(@typelist,'/*       Designer (C) Ian OConnor 1994       */','');
      addlinefront(@typelist,'/*                                           */','');
      addlinefront(@typelist,'/*********************************************/','');
      addline(@procfuncdefslist,'','');
      addline(@procfunclist,'','');
    end;
  if oksofar then
    begin
      inc(linecount);
      setlinenumber;
    end;
  
  if oksofar then
    begin
      doing(@writingfile[1]);
      destname:=destname+'.c'#0;
      destfile:=open(@destname[1],mode_newfile);
      if destfile<>bptr(nil) then
        begin
          
          { main file }
          
          writelisttofile(@typelist,destfile);
          writelisttofile(@constlist,destfile);
          if sizeoflist(@localestringlist)>0 then
            begin
              writelisttofile(@localestringlist,destfile);
            end;
          writelisttofile(@fontlist,destfile);
          writelisttofile(@varlist,destfile);
          if (not producernode^.codeoptions[7]) and (producernode^.codeoptions[3]) then
              begin
                addlinefront(@idcmplist,'/* copied into your program, not edited in this file, */','');
                addlinefront(@idcmplist,'/* Procedures to handle IDCMP events should be        */','');
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
  
  maindestname:=copy(destname,1,length(destname)-3)+'Main.c'#0;
    
  if oksofar and producernode^.codeoptions[8] then
    begin
      
      doing(@catalogfile[1]);
      oksofar:=boolean( WriteLocaleCD(producernode) );
      
    end;
  
  if oksofar and producernode^.codeoptions[9] then
    begin
      
      doing(@catalogfile[1]);
      oksofar:=boolean( WriteLocaleCT(producernode) );
      
    end;
  
  if oksofar and (producernode^.codeoptions[7]) then
    oksofar:=checkinput;
    
  if oksofar and (producernode^.codeoptions[7]) then
    if (godome(@maindestname[1])) then
      begin
        maindestfile:=open(@maindestname[1],mode_newfile);
        if maindestfile<>bptr(nil) then
          begin
            doing(@makemainfile[1]);
            if producernode^.codeoptions[3] then
              begin
                if not producernode^.codeoptions[11] then
                  addlinefront(@idcmplist,'#include "'+no0(stringforme)+'.c"','')
                 else
                  addlinefront(@idcmplist,'#include "'+no0(stringforme)+'.h"','');
                addlinefront(@idcmplist,'#include <stdio.h>','');
                addlinefront(@idcmplist,'','');
                addlinefront(@idcmplist,'/* Compile me to get full executable. */','');
              end
             else
              begin
                if not producernode^.codeoptions[11] then
                  addlinefront(@mainfilelist,'#include "'+no0(stringforme)+'.c"','')
                 else
                  addlinefront(@mainfilelist,'#include "'+no0(stringforme)+'.h"','');
                addlinefront(@mainfilelist,'#include <stdio.h>','');
                addlinefront(@mainfilelist,'','');
                addlinefront(@mainfilelist,'/* Compile me to get full executable. */','');
              end;
            setlinenumber;
            if producernode^.codeoptions[3] then
              writelisttofile(@idcmplist,maindestfile);
            writelisttofile(@mainfilelist,maindestfile);
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
      destname:=destname+'h'#0;
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
