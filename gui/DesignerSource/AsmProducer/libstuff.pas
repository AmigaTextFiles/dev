unit libstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;
 

procedure processlibs;
procedure addlibxrefs;

implementation

procedure processlibs;
const
  titles : array[0..30] of string[18]=
  (
  'Others',
  'Arp',
  'Asl',
  'Cx',
  'Diskfont',
  'Expansion',
  'GadTools',
  'Gfx',
  'Icon',
  'IFFParse',
  'Intuition',
  'Keymap',
  'Layers',
  'Math',
  'MathIeeeDoubBas',
  'MathIeeeDoubTrans',
  'MathIeeeSingBas',
  'MathIeeeSingTrans',
  'RexxSys',
  'ReqTools',
  'Translator',
  'Utility',
  'Workbench',
  'Locale'
  );

var
  loop   : word;
  loop2  : word;
  s      : string;
  last   : integer;
  done : boolean;
  first : boolean;
begin
  addline(@procfunclist,'','');
  addline(@externlist,'    XREF    OpenLibs','0 indicates success, 1 failure, no parameters');
  addline(@procfunclist,'    XDEF    OpenLibs','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'OpenLibs:','0 indicates success, 1 failure, no parameters');
  addline(@procfunclist,'    movem.l d1/a0-a2/a6,-(sp)','Store registers');
  addline(@procfunclist,'    move.l    _AbsExecBase,_SysBase','Set up Exec Library Base');
  
  addline(@constlist,'_AbsExecBase                EQU     4','');
  addline(@constlist,'    XDEF    _SysBase','');
  addline(@constlist,'_SysBase   '+copy('                     ',
                      1,17)+'DS.L    1','');
  addline(@externlist,'    XREF    _SysBase','');
  addline(@procfunclist,'','');
  
  addline(@externlist,'    XREF    _DOSBase','');
  addline(@constlist,'    XDEF    _DOSBase','');
  addline(@constlist,'_DOSBase:','');
  addline(@constlist,'    dc.l    0','');
  
  addline(@procfunclist,'    lea     DOS_Name,a1','');
  addline(@procfunclist,'    moveq   #0,d0','');
  addline(@procfunclist,'    move.l  _SysBase,a6','');
  addline(@procfunclist,'    jsr     OpenLibrary(a6)','');
  addline(@procfunclist,'    move.l  d0,_DOSBase','');
  addline(@procfunclist,'    beq     DOSNotOpened','');
  
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) then
        begin
          
          addline(@externlist,'    XREF    _'+titles[loop]+'Base','');
          addline(@constlist,'    XDEF    _'+titles[loop]+'Base','');
          addline(@constlist,'_'+titles[loop]+'Base:','');
          addline(@constlist,'    dc.l    0','');
          
          str(producernode^.versionlibs[loop],s);
          if not producernode^.abortonfaillibs[loop] then
            begin
              addline(@procfunclist,'    lea     '+titles[loop]+'_Name,a1','Put library name into a1');
              addline(@procfunclist,'    moveq   #'+s+',d0','Put version in d0');
              addline(@procfunclist,'    move.l  _SysBase,a6','Put SysBase in a6 to call Exec function');
              addline(@procfunclist,'    jsr     OpenLibrary(a6)','Call OpenLibrary');
              addline(@procfunclist,'    move.l  d0,_'+titles[loop]+'Base',
                     'Put result in library base, do not care if failed');
              addline(@procfunclist,'','');
            end;
        end;
      inc(loop);
    end;
  loop:=1;
  last:=0;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop])  then
        begin
          str(producernode^.versionlibs[loop],s);
          if producernode^.abortonfaillibs[loop] then
            begin
              addline(@procfunclist,'    lea     '+titles[loop]+'_Name,a1','Put library name into a1');
              addline(@procfunclist,'    moveq   #'+s+',d0','Put version in d0');
              addline(@procfunclist,'    move.l  _SysBase,a6','Put SysBase in a6 to call Exec function');
              addline(@procfunclist,'    jsr     OpenLibrary(a6)','Call OpenLibrary');
              addline(@procfunclist,'    move.l  d0,_'+titles[loop]+'Base','Put result in library base');
              addline(@procfunclist,'    beq     Close_'+titles[last],'If failed call close of previous open.');
              addline(@procfunclist,'','');
              last:=loop;
            end;
        end;
      inc(loop);
    end;
  
  addline(@procfunclist,'    movem.l (sp)+,d1/a0-a2/a6','Put registers back');
  addline(@procfunclist,'    move.l  #0,d0','Put 0 in d0 for a succesful return');
  addline(@procfunclist,'    rts','Return from OpenLibs');
  addline(@procfunclist,'','');
  

  addline(@constlist,'','');
  addline(@constlist,'DOS_Name:','');
  addline(@constlist,'    dc.b    ''dos.library'',0','');
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) then
        begin
          addline(@constlist,titles[loop]+'_Name:','');
          addline(@constlist,'    dc.b    '''+no0(librarynames[loop])+''',0','');
        end;
      inc(loop);
    end;
  addline(@constlist,'    cnop 0,2','');
  
  first:=true;
  
  addline(@procfunclist,'','');
  addline(@externlist,'    XREF    CloseLibs','No parameters, no return, d0 contents destroyed');
  addline(@procfunclist,'    XDEF    CloseLibs','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'CloseLibs:','No parameters, no return, d0 contents destroyed');
  addline(@procfunclist,'    movem.l d1/a0-a2/a6,-(sp)','Store registers');
  addline(@procfunclist,'','');
  
  done:=false;
  first:=true;
  dec(loop);
  while(loop>0) do
    begin
      if (producernode^.openlibs[loop]) and producernode^.abortonfaillibs[loop] then
        begin
          done:=true;
          if not first then
            begin
              addline(@procfunclist,'    beq     Close_'+titles[loop],'Skip close if not opened');
              addline(@procfunclist,'    move.l  _SysBase,a6 ','Put ExecBase in a6 for Exec call');
              addline(@procfunclist,'    jsr     CloseLibrary(a6) ','Call Closelibrary');
              addline(@procfunclist,'Close_'+titles[loop]+':','');
            end;
          first:=false;
          addline(@procfunclist,'    move.l  _'+titles[loop]+'Base,a1','Put library base in a1');
          addline(@procfunclist,'    cmpa.l  #0,a1','See if open');
        end;
      dec(loop);
    end;
  
  if done then
    begin
      addline(@procfunclist,'    beq Close_Others','');
      addline(@procfunclist,'    move.l  _SysBase,a6 ','');
      addline(@procfunclist,'    jsr     CloseLibrary(a6) ','');
    end;
  
  addline(@procfunclist,'Close_Others:','Close libraries whose opening was not compulsory.');
  
  done:=false;
  first:=true;
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) and (not producernode^.abortonfaillibs[loop]) then
        begin
          done:=true;
          if not first then
            begin
              addline(@procfunclist,'    beq     Close_'+titles[loop],'If closed skip to next close.');
              addline(@procfunclist,'    move.l  _SysBase,a6 ','Load SysBase into a6 for Exec call');
              addline(@procfunclist,'    jsr     CloseLibrary(a6) ','Call CloseLibrary');
              addline(@procfunclist,'Close_'+titles[loop]+':','');
            end;
          first:=false;
          addline(@procfunclist,'    move.l  _'+titles[loop]+'Base,a1','Put library base in a1');
          addline(@procfunclist,'    cmpa.l  #0,a1','See if actually open');
        end;
      inc(loop);
    end;
  
    
  if done then
    begin
      addline(@procfunclist,'    beq Closed_All','If not opened end CloseLibs');
      addline(@procfunclist,'    move.l  _SysBase,a6 ','');
      addline(@procfunclist,'    jsr     CloseLibrary(a6) ','');
      addline(@procfunclist,'Closed_All:','');
    end;
  
  addline(@procfunclist,'Close_DOS:','');
  addline(@procfunclist,'    move.l  _DOSBase,a1','Put library base in a1');
  addline(@procfunclist,'    move.l  _SysBase,a6 ','Load SysBase into a6 for Exec call');
  addline(@procfunclist,'    jsr     CloseLibrary(a6) ','Call CloseLibrary');
  addline(@procfunclist,'DOSNotOpened:','');
  
  addline(@procfunclist,'    movem.l (sp)+,d1/a0-a2/a6','Put registers back');
  addline(@procfunclist,'    move.l #1,d0','Put 1 in d0 so call to OpenLibs gets 1 returned if failed');
  if comment then
    addline(@procfunclist,'                 ','If called CloseLibs then ignore return');
  if comment then
    addline(@procfunclist,'                 ','CloseLibs destroys contents of d0');
  addline(@procfunclist,'    rts','Return from CloseLibs');
  addline(@procfunclist,'','');

  
end;

procedure addlibxrefs;
const
  countup = 4;
  namess:array[1..countup] of string[11] =
  (
  'Intuition',
  'GadTools',
  'Gfx',
  'Sys'
  );
var
  loop : word;
begin
  addline(@constlist,'','');
  for loop:=1 to countup do
    addline(@constlist,'    XREF    _'+namess[loop]+'Base','');
end;

end.

