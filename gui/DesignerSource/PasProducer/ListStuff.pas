unit ListStuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

procedure freelist(pl:plist);
function getnthnode(ph:plist;n:word):pnode;
function getlistpos(pl:plist;pn:pnode):long;
function sizeoflist(pl:plist):long;
procedure printlisttoscreen(pl:plist);
procedure addline(pl:plist;s:string;comstr:string);
procedure addlinefront(pl:plist;s:string;comstr:string);
procedure writelisttofile(pl:plist;fl:bptr);
procedure freemymem(mem:pointer);
function allocmymem(size:long;typ:long):pointer;

implementation

procedure freelist(pl:plist);
var
  pn : pnode;
begin
  pn:=remhead(pl);
  while (pn<>nil) do
    begin
      freemymem(pn);
      pn:=remhead(pl);
    end;
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

procedure printlisttoscreen(pl:plist);
var
  psn : pstringnode;
begin
  psn:=pstringnode(pl^.lh_head);
  while(psn^.ln_succ<>nil) do
    begin
      writeln(psn^.st);
      psn:=psn^.ln_succ;
    end;
end;

procedure addline(pl:plist;s:string;comstr:string,'');
var
  psn     : pstringnode;
begin
  if oksofar then
    begin
      if (s<>'')or((s='') and (comstr=''))or((s='') and (comstr<>'') and comment) then
        begin
          if not comment then
            comstr:='';
          psn:=allocmymem(sizeof(tstringnode)-254+length(s)+length(comstr),memf_clear or memf_public);
          if psn<>nil then
            begin
              inc(linecount);
              psn^.st:=s+comstr+#0;
              addtail(pl,pnode(psn));
            end
           else
            oksofar:=false;
        end;
    end;
end;

procedure addlinefront(pl:plist;s:string;comstr:string,'');
var
  psn     : pstringnode;
begin
  if oksofar then
    begin
      if (s<>'')or((s='') and (comstr=''))or((s='') and (comstr<>'') and comment) then
        begin
          if not comment then
            comstr:='';
          psn:=allocmymem(sizeof(tstringnode)-254+length(s)+length(comstr),memf_clear or memf_public);
          if psn<>nil then
            begin
              inc(linecount);
              psn^.st:=s+comstr+#0;
              addhead(pl,pnode(psn));
            end
           else
            oksofar:=false
        end;
    end;
end;

procedure writelisttofile(pl:plist;fl:bptr);
var 
  psn : pstringnode;
begin
  psn:=pstringnode(pl^.lh_head);
  while psn^.ln_succ<>nil do
    begin
      if 0<>fputs(fl,@psn^.st[1]) then
        oksofar:=false;
      if 10=fputc(fl,10) then;
      psn:=psn^.ln_succ;
    end;
end;

procedure freemymem(mem:pointer);
begin
  freevec(mem);
  dec(memused);
end;

function allocmymem(size:long;typ:long):pointer;
var
  p : pointer;
begin
  p:=allocvec(size,typ);
  if p<>nil then
    inc(memused);
  allocmymem:=p;
end;

end.