program MemSize;
var s,i,j,k:integer;
    pa,pb,pc,l:string;
    a:real;
    n:short;
    f:boolean;

{$I "Include:Exec/Memory.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Libraries/Dos.i"}

begin
 pa:="   ";pb:="        ";a:=0;
 pc:="                                                                      ";
 getparam(1,pa);
 if not strieq(pa,"MIN") and not strieq(pa,"MAX") then begin
  writeln("\e[1;4;33mM e m S i z e   V1.1   \e[22;33;3mby Stefan Grad of GPD \e[23m -  FREEWARE  -  © 20-11-94\e[0m");
  writeln("\e[3mUSAGE: \e[0mMemSize <MIN|MAX> <Size> <ProgramName>");
  writeln("Size = Min/max amount of memory (bytes) necessary to/not to run <ProgramName>");
 end;
 if strieq(pa,"MIN") or strieq(pa,"MAX") then begin
  getparam(2,pb);
  for i:=0 to 7 do begin
   for j:=0 to 9 do begin
    k:=inttostr(l,j);
    if pb[i]=l[0] then a:=a*10+j;
   end;
  end;
  getparam(3,pc);
  s:=availmem(1);
  if strieq(pa,"MIN") and (s>a) then f:=execute(pc,nil,nil);
  if strieq(pa,"MAX") and (s<a) then f:=execute(pc,nil,nil);
 end;
end.

