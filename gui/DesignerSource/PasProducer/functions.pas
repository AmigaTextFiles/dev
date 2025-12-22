unit Functions;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,fonts;

procedure addfreebitmap;
procedure addopenwindowtaglistnicely;
procedure addprocsettagitem;
procedure addprocprintstring;
procedure addprocstripintuimessages;
procedure addprocgetintegerfromgad;
procedure addprocgetstringfromgad;
procedure addprocgeneralgadtoolsgad;
procedure addprocclosewindowsafely;
procedure addprocCheckedBox;
procedure addprocgtsetsingle;


implementation

{ free bit map created for a superbitmap window }

procedure addfreebitmap;
const
  procdef : array[1..10] of string[150]=
  (
  ''#0,
  'procedure freebitmap(pbm : pbitmap;w,h:word);'#0,
  'var'#0,
  '  loop : word;'#0,
  'begin'#0,
  '  for loop:= 0 to 7 do'#0,
  '    if pbm^.planes[loop]<>nil then'#0,
  '      freeraster(pbm^.planes[loop],w,h);'#0,
  '  freemem(pbm,sizeof(tbitmap));'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 10 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ fuction to open window with shared user port }

procedure addopenwindowtaglistnicely;
const
  procdef : array[1..10] of string[150]=
  (
  ''#0,
  'function openwindowtaglistnicely( pnewwin : pnewwindow;pt:ptagitem;tidcmp:long;pmport:pmsgport):pwindow;'#0,
  'var'#0,
  '  temp : pwindow;'#0,
  'begin'#0,
  '  temp:=openwindowtaglist(pnewwin,pt);'#0,
  '  if temp<>nil then temp^.userport:=pmport;'#0,
  '  if temp<>nil then if modifyidcmp(temp,tidcmp) then;'#0,
  '  openwindowtaglistnicely:=temp;'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 10 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ add settagitem procedure }

procedure addprocsettagitem;
const
  procdef : array[1..6] of string [70]=
  (
  ''#0,
  'Procedure Settagitem( pt : ptagitem ; tag : long ; data : long);'#0,
  'Begin'#0,
  '  pt^.ti_tag:=tag;'#0,
  '  pt^.ti_data:=data;'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 6 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ add procedure to printstring to window }

procedure addprocprintstring;
const
  procdef : array [1..20] of string[90]=
  (
  ''#0,
  'procedure printstring(pwin:pwindow;x,y:word;s:string;f,b:byte;font:ptextattr;dm:byte);'#0,
  'var'#0,
  '  mit : tintuitext;'#0,
  '  str : string;'#0,
  'begin'#0,
  '  str:=s+#0;'#0,
  '  with mit do'#0,
  '    begin'#0,
  '      frontpen:=f;'#0,
  '      backpen:=b;'#0,
  '      leftedge:=x;'#0,
  '      topedge:=y;'#0,
  '      itextfont:=font;'#0,
  '      drawmode:=dm;'#0,
  '      itext:=@str[1];'#0,
  '      nexttext:=nil;'#0,
  '    end;'#0,
  '  printitext(pwin^.rport,@mit,0,0);'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 20 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ function converted from RKM : libraries to close window with }
{ shared message port properly }

procedure addprocstripintuimessages;
const
  procdef:array[1..19] of string[80]=
  (
  ''#0,
  'procedure stripintuimessages(mp:pmsgport;win:pwindow);'#0,
  '  var'#0,
  '  msg  : pintuimessage;'#0,
  '  succ : pnode;'#0,
  'begin'#0,
  '  msg:=pintuimessage(mp^.mp_msglist.lh_head);'#0,
  '  succ:=msg^.execmessage.mn_node.ln_succ;'#0,
  '  while (succ<>nil) do'#0,
  '    begin'#0,
  '      if (msg^.idcmpwindow=win) then'#0,
  '        begin'#0,
  '          remove(pnode(msg));'#0,
  '          replymsg(pmessage(msg));'#0,
  '        end;'#0,
  '      msg:=pintuimessage(succ);'#0,
  '      succ:=msg^.execmessage.mn_node.ln_succ;'#0,
  '    end;'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 19 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ function to get string from string gadget }

procedure addprocgetstringfromgad;
const
  procdef : array[1..10] of string[50]=
  (
  ''#0,
  'function getstringfromgad(pgad:pgadget):string;'#0,
  'var'#0,
  '  psi   : pstringinfo;'#0,
  '  strin : string;'#0,
  'begin'#0,
  '  psi:=pstringinfo(pgad^.specialinfo);'#0,
  '  ctopas(psi^.buffer^,strin);'#0,
  '  getstringfromgad:=strin+#0;'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 10 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ function to get integer from integer gadget }

procedure addprocgetintegerfromgad;
const
  procdef : array[1..8] of string[50]=
  (
  ''#0,
  'function getintegerfromgad(pgad:pgadget):long;'#0,
  'var'#0,
  '  psi   : pstringinfo;'#0,
  'begin'#0,
  '  psi:=pstringinfo(pgad^.specialinfo);'#0,
  '  getintegerfromgad:=psi^.longint_;'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 8 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ function to add general gadtools gadget }

procedure addprocgeneralgadtoolsgad;
const
  procdef : array[1..30] of string[70]=
  (
  ''#0,
  'function generalgadtoolsgad(kind         : long;'#0,
  '                            x,y,w,h,id   : word;'#0,
  '                            ptxt         : pbyte;'#0,
  '                            font         : ptextattr;'#0,
  '                            flags        : long;'#0,
  '                            visinfo      : pointer;'#0,
  '                            pprevgad     : pgadget;'#0,
  '                            userdata     : pointer;'#0,
  '                            taglist      : ptagitem'#0,
  '                           ):pgadget;'#0,
  'var'#0,
  '  newgad : tnewgadget;'#0,
  'begin'#0,
  '  with newgad do'#0,
  '    begin'#0,
  '      ng_textattr:=font;'#0,
  '      ng_leftedge:=x;'#0,
  '      ng_topedge:=y;'#0,
  '      ng_width:=w;'#0,
  '      ng_height:=h;'#0,
  '      ng_gadgettext:=ptxt;'#0,
  '      ng_gadgetid:=id;'#0,
  '      ng_flags:=flags;'#0,
  '      ng_visualinfo:=visinfo;'#0,
  '    end;'#0,
  '  generalgadtoolsgad:=creategadgeta(kind,pprevgad,@newgad,taglist)'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 28 do
    addline(@procfunclist,procdef[loop],'');
  for loop:=2 to 11 do
    addline(@procfuncdefslist,procdef[loop],'');
end;

{ function to close window with shared message port }

procedure addprocclosewindowsafely;
const
  procdef : array[1..10] of string[60]=
  (
  ''#0,
  'procedure closewindowsafely(win : pwindow);'#0,
  'begin'#0,
  '  forbid;'#0,
  '  stripintuimessages(win^.userport,win);'#0,
  '  win^.userport:=nil;'#0,
  '  if modifyidcmp(win,0) then ;'#0,
  '  permit;'#0,
  '  closewindow(win);'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 10 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ returns state of checkbox gadget }

procedure addprocCheckedBox;
const
  procdef : array[1..5] of string[55]=
  (
  ''#0,
  'function GadSelected(pgad:pgadget):Boolean;'#0,
  'begin'#0,
  '  GadSelected:=((pgad^.flags and gflg_selected)<>0);'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 5 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

{ function to set gadget attribute }

procedure addprocgtsetsingle;
const
  procdef : array[1..10] of string[75]=
  (
  ''#0,
  'procedure gt_setsinglegadgetattr(gad:pgadget;win:pwindow;tag1,tag2:long);'#0,
  'var'#0,
  '  t : array [1..3] of long;'#0,
  'begin'#0,
  '  t[1]:=tag1;'#0,
  '  t[2]:=tag2;'#0,
  '  t[3]:=tag_done;'#0,
  '  gt_setgadgetattrsa(gad,win,nil,@t[1]);'#0,
  'end;'#0
  );
var
  loop : word;
begin
  for loop:=1 to 10 do
    addline(@procfunclist,procdef[loop],'');
  addline(@procfuncdefslist,procdef[2],'');
end;

end.