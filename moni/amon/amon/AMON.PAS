{ AMON file monitor 1.00 30-10-2005 }
{ (c) by I.N.C. 2005                }
{ language: pascal55 (borland)      }

uses crt,dos,tblstr,fcopy,fname,amontpu;
{ make subdirectory into tp directory: "library".       }
{ copy directory with unit source there.                }
{ add to unit directory: "LIBRARY" (no slash/drive).    }
{ add to include directory: "LIBRARY" (no slash/drive). }
{ add to include directory "AMON".                      }

{$i buf.inc}

const key_str='ESC: QUIT - CURSOR: 0000 PAGE: 0000 SIZE: 0000';
const cpy_str='AMON 1.00 HEX MONITOR - (C) 2005 BY I.N.C.';

const msg_arr:array[0..3] of string[64]=
('SYNTAX: AMON <FILENAME> [PATH] [OPTION]',
 '<FILENAME> FILE TO DISPLAY',
 '[PATH\] BUFFER PATH (OPTIONAL)',
 '[COPY] A: DISPLAY ORIGINAL FILE (ALIGNED ONLY)');

var myAmon:amon;
var kybc:char;
var kybd:word;

var a:longint;
var i:word;
var fn1,fn2:f_name;

var cs_str:tbl_str;
var fco:filecopy;

label more;

begin
 clrscr;
 gotoxy(0,24);write(cpy_str);

 { display invoke syntax }
 if (paramcount=0)then
 begin
  writeln;
  for i:=0 to 3 do writeln(msg_arr[i]);
  halt(1);
 end;

 {initialize filename objects}
 fn1.init;
 fn2.init;
 {initialize filecopy object}
 fco.init;

 { load filename object with parameters 1 and 2}
 if(paramcount>0)then
 begin
  fn1.enter_fullname(paramstr(1));
  if(paramcount>1)then
  begin
   fn2.enter_fullname(paramstr(2));
  end;
 end;

 { create copy with altered filename extension.                 }
 { create this copy into the same directory as the source file. }
 if(paramcount=1)then
 begin
  fn2.change_name(fn1.return_name);
  fn2.change_path(fn1.return_path);
  fn2.change_ext('AMN');
  fco.assignsrcfile(fn1.return_fullname);
  fco.assigndstfile(fn2.return_fullname);
  fco.extendfile;
 end;

 { PATH\ loads the path into filename object fn2        }
 { if length of 2nd parameter=1, then it is the option   }
 { action: copy the file to the given path and align it. }
 if((paramcount=2)and(length(paramstr(2))>1))then
 begin
  fn2.change_name(fn1.return_name);
  fn2.change_ext(fn1.return_ext);
  fco.assignsrcfile(fn1.return_fullname);
  fco.assigndstfile(fn2.return_fullname);
  fco.extendfile;
 end else
 begin
  if(paramstr(2)<>'')then
  begin
   if(paramcount=3)then
   begin
    cs_str.init(paramstr(3));
   end else
   begin
    cs_str.init(paramstr(2));
   end;

   cs_str.ucase;

   { filename object fn2 = filename object fn1 }
   { do not perform any copy action            }
   if(cs_str.return_buffer^='A')then
   begin
    fn2.enter_fullname(fn1.return_fullname);
   end;
   cs_str.done;
  end;
 end;

 fco.done;
 { init the monitor object with the generated filename.   }
 { skip to the beginning of the file and read one record. }
 myAmon.init(fn2.return_fullname);
 myAmon.skipfile(0);

 { set display parameters. }
 myAmon.setdisplaytype(hxtxt);
 myAmon.setobjtype(txtdata);
 myAmon.setxydimensions(15,15);
 myAmon.setoffset(5,2);

 { set the status display and display the monitor object. }
 myAmon.setstatus_msg(key_str);
 myAmon.setstatus_value(0,0,myAmon.getfilesize);
 myAmon.display;

more:
 while(keypressed=false) do
 begin
  myAmon.idle;
 end;

 { get a keyboard code }
 kybc:=readkey;
 if (kybc=chr(0)) then
 begin
  while(keypressed=false) do
  begin
   myAmon.idle;
  end;
  kybc:=readkey;
  kybd:=ord(kybc)shl 8;
 end else
 begin
  kybd:=word(ord(kybc));
 end;

 { debug code }
 gotoxy(20,23);
 myAmon.hxdebug(kybd);
 write(myAmon.getfilesize);
 write(myAmon.getobjcount);


 { keyboard code: cursor up. }
 if(kybd=csrdownkey)then
 begin
  myAmon.locateobj(myAmon.getcurrentobj+1);
  myAmon.display;
 end;

 { keyboard code: cursor down. }
 if(kybd=csrupkey)then
 begin
  if(myAmon.getcurrentobj>0)then
  begin
   myAmon.locateobj(myAmon.getcurrentobj-1);
   myAmon.display;
  end;
 end;

 { keyboard code: page up. }
 if(kybd=pgupkey)then
 begin
  a:=myAmon.getcurrentobj;
  if(((myAmon.getcurrentobj)AND(myAmon.getobjcount-1))=0)then
  begin
   dec(a);
   a:=a AND(NOT(myAmon.getobjcount-1));
  end else
  begin
   a:=a AND(NOT (myAmon.getobjcount-1));
  end;

   if(a>=0)then
   begin
   myAmon.locateobj(a);
   myAmon.display;
  end;
 end;

 { keyboard code: page down. }
 if(kybd=pgdnkey)then
 begin
  a:=myAmon.getcurrentobj OR (myAmon.getobjcount-1);
  inc(a);
  if(a<(myAmon.getfilesize*myAmon.getobjcount)) then
  begin
   myAmon.locateobj(a);
   myAmon.display;
  end;
 end;

 { keyboard code: home key. }
 if(kybd=homekey)then
 begin
  myAmon.locateobj(0);
  myAmon.display;
 end;

 { keyboard code: end key. }
 if(kybd=endkey)then
 begin
  a:=(myAmon.getfilesize*myAmon.getobjcount)-1;
  a:=a AND(NOT(myAmon.getobjcount-1));
  myAmon.locateobj(a);
  myAmon.display;
 end;

 if(kybd<>27)then goto more;

 fn2.done;
 fn1.done;
 myAmon.done;
end.