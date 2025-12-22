unit savecodedefs;

interface

uses asl,utility,exec,intuition,amiga,workbench,layers,drawwindows,icon,loadsave2,
     gadtools,graphics,dos,amigados,definitions,iffparse,routines,editscreenstuff,
     loadsave;

procedure readcodedefs;
procedure writecodedefs( num : byte );

implementation

procedure writecodedefs( num : byte );
var
  f     : bptr;
  store : twholecodestore;
  psn   : pstringnode;
  loop  : word;
  s     : string;
  pln   : plibnode;
begin
    
  copymem(@procedureoptions,@store.procedureoptions,sizeof(store.procedureoptions));
  copymem(@codeoptions,@store.codeoptions,sizeof(store.codeoptions));
  if presentcompiler<>~0 then
    begin
      psn:=pstringnode(getnthnode(@compilerlist,presentcompiler));
      store.compilername:=no0(psn^.st);
    end
   else
    store.compilername:='';
  if maincodewindow<>nil then
    globalincludeextra:=getstringfromgad(maincodegadgets[12]);
  store.includeextra:=globalincludeextra;
  store.fileversion:=SaveFileVersion;
  loop:=1;
  pln:=plibnode(tliblist.lh_head);
  while (pln^.ln_succ<>nil) do
    begin
      store.openlibs[loop]:=pln^.open;
      store.versionlibs[loop]:=pln^.version;
      store.abortonfaillibs[loop]:=pln^.abortonfail;
      inc(loop);
      pln:=pln^.ln_succ;
    end;
  
  if num=2 then
    begin
      s:='EnvArc:Designer/Designer.CodeDefaults'#0;
      mkdir('EnvArc:Designer');
    end
   else
    begin
      s:='Env:Designer/Designer.CodeDefaults'#0;
      mkdir('Env:Designer');
    end;
  
  f:=open(@s[1],mode_newfile);
  if f<>0 then
    begin
      if write_(f,@store,sizeof(store))<>sizeof(store) then
        telluser(mainwindow,'Incomplete code file written.');
      if not close_(f) then
        telluser(mainwindow,'Cannot close code file.');
    end
   else
    telluser(mainwindow,'Cannot write code file.');
end;

procedure readcodedefs;
var
  f    : bptr;
  store: twholecodestore;
  s    : string;
  loop : long;
  psn  : pstringnode;
  pln  : plibnode;
begin
  s:='Env:Designer/Designer.CodeDefaults'#0;
  
  f:=open(@s[1],mode_oldfile);
  if f<>0 then
    begin
      if read_(f,@store,sizeof(store))<>sizeof(store) then;
      if not close_(f) then
        telluser(mainwindow,'Cannot close prefs file.');
      
      
      copymem(@store.procedureoptions,@procedureoptions,sizeof(procedureoptions));
      copymem(@store.codeoptions,@codeoptions,sizeof(codeoptions));
      globalincludeextra:=store.includeextra;
      loop:=1;
      pln:=plibnode(tliblist.lh_head);
      while (pln^.ln_succ<>nil) do
        begin
          pln^.open:=store.openlibs[loop];
          pln^.version:=store.versionlibs[loop];
          pln^.abortonfail:=store.abortonfaillibs[loop];
          if (0=store.fileversion) and (loop=23) then
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
          if upstring(no0(psn^.st))=upstring(store.compilername) then
            presentcompiler:=loop;
          inc(loop);
          psn:=psn^.ln_succ
        end;
     
    end;
end;

end.