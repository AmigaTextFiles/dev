unit routines;

interface

uses utility,layers,gadtools,exec,intuition,dos,liststuff,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

function nicestring(s:string):string;
function duplicate(n : word;c:char):string;
procedure settagitem(pt :ptagitem;t,d:long);
procedure deleteimagenode(pin:pimagenode);
procedure setdefaultwindow(pdwn:pdesignerwindownode);
procedure freegadgetnode(pdwn:pdesignerwindownode;pgn:pgadgetnode);
procedure deletedesignerwindow(pdwn:pdesignerwindownode);
procedure deletedesignermenunode(pdmn:pdesignermenunode);
function no0(s:string):string;
function okchar(c:char):boolean;
function fmtint(n:long):string;

implementation

function fmtint(n:long):string;
var
  temp : string[30];
begin
  str(n,temp);
  fmtint:=temp;
end;

function nicestring(s:string):string;
var
  s2:string;
  loop : word;
begin
  s2:='';
  if s<>'' then
    for loop:= 1 to length(s) do
      begin
        if (s[loop]<>'-') and
           (s[loop]<>'>') and
           (s[loop]<>'^') and
           (s[loop]<>'.')
          then
           s2:=s2+s[loop];
      end;
  nicestring:=s2;
end;

function okchar(c:char):boolean;
const
   a1:string[36] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
var
  loop : byte;
begin
  okchar:=false;
  for loop:=1 to 36 do
    if upcase(c)=a1[loop] then
      okchar:=true;
end;

function no0(s:string):string;
var
  str : string;
begin
  str:=s;
  while (str[length(str)]=#0)and(length(str)>0) do
    dec(str[0]);
  no0:=str;
end;

procedure deletedesignermenunode(pdmn:pdesignermenunode);
var
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
begin
  remove(pnode(pdmn));
  pmtn:=pmenutitlenode(pdmn^.tmenulist.mlh_head);
  while (pmtn^.ln_succ<>nil) do
    begin
      pmin:=pmenuitemnode(pmtn^.titemlist.mlh_head);
      while(pmin^.ln_succ<>nil) do
        begin
          freelist(@pmin^.tsubitems);
          pmin:=pmin^.ln_succ;
        end;
      freelist(@pmtn^.titemlist);
      pmtn:=pmtn^.ln_succ;
    end;
  freelist(@pdmn^.tmenulist);
  freemymem(pdmn);
end;

procedure freegadgetnode(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pgn2 : pgadgetnode;
  pmt  : pmytag;
begin
  if pgn^.kind=myobject_kind then
    begin
      pmt:=pmytag(pgn^.infolist.mlh_head);
      while(pmt^.ln_succ<>nil) do
        begin
          if (pmt^.sizebuffer>0) and(pmt^.data<>nil) then
            freemymem(pmt^.data);
          pmt:=pmt^.ln_succ;
        end;
      freelist(@pgn^.infolist)
    end;
  if (pgn^.kind=listview_kind) then
    begin
      freelist(@pgn^.infolist);
      if pgn^.tags[3].ti_data<>0 then
        begin
          pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
          pgn2^.joined:=false;
        end;
    end;
  if (pgn^.kind=mx_kind)or(pgn^.kind=cycle_kind) then
    begin
      freelist(@pgn^.infolist);
      if (pgn^.pointers[1]<>nil) and (pgn^.pointers[2]<>nil) then
        freemymem(pgn^.pointers[1]);
    end;
  if (pgn^.kind=mybool_kind) then
    freelist(@pgn^.infolist);
  if (pgn^.kind=string_kind) then
    begin
      if pgn^.joined then
        begin
          pgn2:=pgadgetnode(pgn^.pointers[1]);
          pgn2^.tags[3].ti_data:=0;
        end;
    end;
  freemymem(pgn);
end;

procedure deletedesignerwindow(pdwn:pdesignerwindownode);
var
  pgn : pgadgetnode;
  ptn : ptextnode;
begin
  remove(pnode(pdwn));
  freelist(@pdwn^.bevelboxlist);
  pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
  while(pgn<>nil)do
    begin
      freegadgetnode(pdwn,pgn);
      pgn:=pgadgetnode(remhead(@pdwn^.gadgetlist));
    end;
  freelist(@pdwn^.textlist);
  freelist(@pdwn^.imagelist);
  freemymem(pdwn);
end;

procedure setdefaultwindow(pdwn);
var
  pn    : pnode;
begin
  with pdwn^ do
    begin
      y:=20;
      x:=300;
      w:=300;
      h:=150;
      newlist(@bevelboxlist);
      newlist(@gadgetlist);
      newlist(@textlist);
      newlist(@imagelist);
      minw:=150;
      maxw:=1200;
      minh:=25;
      maxh:=1200;
      {
      useoffsets:=true;
      }
      innerw:=400;
      innerh:=200;
      zoom[1]:=200;
      zoom[3]:=200;
      zoom[4]:=25;
      usezoom:=true;
      mousequeue:=5;
      rptqueue:=3;
      sizegad:=true;
      sizebright:=true;
      sizebbottom:=false;
      dragbar:=true;
      depthgad:=true;
      closegad:=true;
      activate:=true;
      smartrefresh:=true;
      autoadjust:=true;
      gadgetfontname:='topaz.font'#0;
      gadgetfont. ta_name:=@gadgetfontname[1];
      gadgetfont.ta_ysize:=8;
    end;
end;

procedure deleteimagenode(pin:pimagenode);
var
  pdwn : pdesignerwindownode;
  psin : psmallimagenode;
  pdmn : pdesignermenunode;
  pmtn : pmenutitlenode;
  pmin : pmenuitemnode;
  pmsi : pmenusubitemnode;
  dummy,dummy2 : long;
  pin2  : pimagenode;
begin
  remove(pnode(pin));
  if pin^.imagedata<>nil then
    freemymem(pin^.imagedata);
  freemymem(pin);
end;

function duplicate(n : word,c:char):string;
var
  s : string;
begin
  s:='';
  while n>0 do
    begin
      dec(n);
      s:=s+c;
    end;
  duplicate:=s;
end;

procedure settagitem(pt :ptagitem;t,d:long);
begin
  pt^.ti_tag:=t;
  pt^.ti_data:=d;
end;

end.