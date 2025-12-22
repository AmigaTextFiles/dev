unit libraries;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

procedure processlibs;

implementation

procedure processlibs;
const
  startstring : array[1..30] of string[40]=
  (
  'arpbase:=pArpBase(',
  'aslbase:=',
  'cxbase:=',
  'diskfontbase:=',
  'expansionbase:=pExpansionBase(',
  'gadtoolsbase:=',
  'gfxbase:=pgfxbase(',
  'iconbase:=',
  'iffparsebase:=',
  'intuitionbase:=pintuitionbase(',
  'keymapbase:=',
  'layersbase:=',
  
  'mathffpbase:',
  'mathieeedoubbas:',
  'mathieeedoubtrans:',
  'mathieeesingbas:',
  'mathieesingtrans:',
  
  'rexxsysbase:=',
  'reqtoolsbase:=preqtoolsbase(',
  'translatorbase:=',
  'utilitybase:=',
  'workbenchbase:=',
  'localebase:='
  )
  ;
  endstring   : array[1..30] of string[1]=
  (
  ')','','','',')','',')','','',')',
  '','','','','','','','',')','',
  '','','','','','','','','',''
  );
var
  loop  : word;
  loop2 : word;
  s     : string;
  spec,spec2  : string[20];
begin
  addline(@procfunclist,'','');
  addline(@procfunclist,'Function OpenLibs:Boolean;','');
  addline(@procfuncdefslist,'Function OpenLibs:Boolean;','');
  addline(@procfunclist,'Var','');
  addline(@procfunclist,'  OkSoFar : Boolean;','');
  addline(@procfunclist,'Begin','');
  addline(@procfunclist,'  OkSoFar:=True;','');
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) and ((loop<13)or(loop>17)) then
        begin
          spec:='';
          spec2:='';
          if producernode^.codeoptions[13] then
            if loop=21 then
              begin
                spec:='pUtilityBase(';
                spec2:=')';
              end;
          str(producernode^.versionlibs[loop],s);
          addline(@procfunclist,'  '+startstring[loop]+spec+'OpenLibrary( '''
                                +no0(librarynames[loop])+''', '+s+')'+endstring[loop]+spec2+';','');
          loop2:=1;
          s:='';
          while (startstring[loop,loop2]<>':') do
            begin
              s:=s+startstring[loop,loop2];
              inc(loop2);
            end;
          if producernode^.abortonfaillibs[loop] then
            addline(@procfunclist,'  if '+s+'=Nil then OkSofar:=False;','');
        end;
      inc(loop);
    end;
  addline(@procfunclist,'  If Not OkSoFar then','');
  addline(@procfunclist,'    CloseLibs;','');
  addline(@procfunclist,'  OpenLibs:=OkSoFar;','');
  addline(@procfunclist,'end;','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'Procedure CloseLibs;','');
  addline(@procfuncdefslist,'Procedure CloseLibs;','');
  addline(@procfunclist,'Begin','');
  loop:=1;
  while(librarynames[loop]<>'end') do
    begin
      if (producernode^.openlibs[loop]) and ((loop<13)or(loop>17)) then
        begin
          loop2:=1;
          s:='';
          while (startstring[loop,loop2]<>':') do
            begin
              s:=s+startstring[loop,loop2];
              inc(loop2);
            end;
          addline(@procfunclist,'  if '+s+'<>Nil then','');
          addline(@procfunclist,'    CloseLibrary( PLibrary( '+s+'));','');
        end;
      inc(loop);
    end;
  addline(@procfunclist,'end;','');
end;

end.