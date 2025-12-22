unit amontpu;

{ impplemetation of a buffered collection of blitable objects.        }
{ right now the code can display char based data in "hex monitor"     }
{ style. further versions may have the capability to display sprites. }

{ (c) 2005 by I.N.C.             }
{ version 1.00 2nd november 2005 }

interface

uses crt,tblstr;
{$i buf.inc}

const txtdata=0;
const hxtxt=0;


type amon=object
 dbuf:Tdbuf;
 fname:string;
 dfile:file of Tdbuf;
 lcursx,lcursy:word;
 objx,objy:word;
 lineidx,objidx:word;
 objtypeset,displaytypeset:boolean;
 objtype:word;
 dplytype:word;
 xydimset:boolean;
 fopen:boolean;
 frecord:word;
 dpxofs,dpyofs:word;
 status_str:string;
 status_va,status_vb,status_vc:word;
 filepos:word;

 constructor init(fn:string);
 procedure idle;
 procedure idledisplay;

 procedure idxdisplay;
 procedure skipfile(pos:word);
 procedure setxydimensions(x,y:word);
 procedure setobjtype(t:word);
 procedure setobjindex(t:word);

 function getobjcount:word;
 function getcurrentobj:longint;
 procedure locateobj(n:longint);
 function getfilesize:word;

 procedure setdisplaytype(t:word);
 procedure setoffset(x,y:word);
 procedure display;
 procedure erase;
 procedure displayhexscreen;
 procedure erasehexscreen;
 procedure outputcrt(st:string);
 procedure outputgfx(st:string);

 procedure setstatus_msg(s:string);
 procedure setstatus_value(a,b,c:word);
 procedure displaystatusline_static;
 procedure displaystatusline;

 procedure hxdebug(hx:word);
 destructor done;
end;

implementation

constructor amon.init(fn:string);
{ do some ineviteable initializations. }

begin
 fname:=fn;
 assign(dfile,fname);
 reset(dfile);
 lcursx:=0;
 lcursy:=0;
 objtypeset:=false;
 displaytypeset:=false;
 xydimset:=false;
 fopen:=false;
 frecord:=0;
 objidx:=0;
 objx:=0;
 objy:=0;
 lineidx:=0;
 filepos:=0;
end;

procedure amon.idle;
{ display random flicker. }
begin
 self.displaystatusline;write('*');
 delay(30);
end;

procedure amon.idledisplay;
begin
end;

procedure amon.skipfile(pos:word);
begin
 seek(dfile,pos);
 read(dfile,dbuf);
 self.filepos:=pos;
end;

procedure amon.setxydimensions(x,y:word);
begin
 self.objx:=x;
 self.objy:=y;
end;

procedure amon.setobjtype(t:word);
begin
 self.objtype:=t;
end;

procedure amon.setobjindex(t:word);
begin
 self.objidx:=t;
end;

function amon.getobjcount:word;
begin
 getobjcount:=sizeof(self.dbuf) div ((self.objx+1)*(self.objy+1));
end;

function amon.getcurrentobj:longint;
var a:longint;
begin
 a:=self.filepos*self.getobjcount;
 getcurrentobj:=a+self.objidx;
end;

procedure amon.locateobj(n:longint);
{ locate absolute object, load from disk if necessary. }

begin
 if ((n div self.getobjcount)<=self.getfilesize)then
 begin
  if((n div self.getobjcount)<>(self.filepos))then
  begin
   if((n div self.getobjcount)<self.getfilesize)then
   begin
    self.objidx:=n-((n div self.getobjcount)*self.getobjcount);
    skipfile(n div self.getobjcount);
   end;
  end else
  begin
   self.objidx:=n-((n div self.getobjcount)*self.getobjcount);
  end;
 end;

 self.status_va:=self.objidx;
 self.status_vb:=self.filepos;
end;

function amon.getfilesize:word;
begin
 getfilesize:=filesize(dfile);
end;

procedure amon.setdisplaytype(t:word);
begin
 self.dplytype:=t;
end;

procedure amon.setoffset(x,y:word);
begin
 self.dpxofs:=x;
 self.dpyofs:=y;
end;

procedure amon.display;
{ actually perform the display. }

begin
 if (self.dplytype=hxtxt)then
 begin
  self.erasehexscreen;
  self.displayhexscreen;
  self.displaystatusline_static;
  self.displaystatusline;
 end;
end;

procedure amon.erase;
begin
end;

procedure amon.displayhexscreen;
{ display hexadecimal by interpreting the data as char based text. }

var a,b,d:word;
var s:string;
var i:word;
var c:char;
begin
 if (self.dplytype=hxtxt) then
 begin
  if (self.objtype=txtdata) then
  begin
   for a:=1 to 255 do s[a]:=chr(32);

   for a:=0 to self.objy do
   begin
    for b:=0 to self.objx do
    begin

     { process 16bits each iteration. }
     if ((b and 1)=0) then
     begin
      d:=self.dbuf[(((self.objidx)*(self.objy+1)*(self.objx+1))+b+(self.lineidx*(self.objy+1)))div 2];
     end;

     { concat the hex display string from a table. }
     s[(b*2)+1]:=tblstr_hxtbl[byte(d)][0];
     s[(b*2)+2]:=tblstr_hxtbl[byte(d)][1];

     { display the char as well, filter out unprintable chars }
     { by translating by a table.                             }
     if byte(d)>32 then
     begin
      c:=chr(byte(d));
     end else
     begin
      {$R-}c:=chr(tblstr_hxprint[byte(d)]);{$R+}
     end;
     s[b+(self.objx*2)+8]:=c;
     d:=d shr 8;

    end;

    s[0]:=chr((self.objx*5)+5);
    self.outputcrt(s);
    inc(self.lineidx);
   end;
   self.lineidx:=0;
  end;
 end;
end;

procedure amon.erasehexscreen;
begin

end;

procedure amon.outputcrt(st:string);
begin
 gotoxy(self.dpxofs,self.dpyofs+self.lineidx);
 write(st);
end;

procedure amon.outputgfx(st:string);
begin
end;

procedure amon.idxdisplay;
begin
end;

procedure amon.setstatus_msg(s:string);
begin
 self.status_str:=s;
end;

procedure amon.setstatus_value(a,b,c:word);
begin
 self.status_va:=a;
 self.status_vb:=b;
 self.status_vc:=c;
end;

procedure amon.displaystatusline_static;
{ display file position seg:offset (64k full segments). }

var a:longint;

begin
if (self.dplytype=hxtxt) then
 begin
  if (self.objtype=txtdata) then
  begin
   gotoxy(self.dpxofs,self.dpyofs+self.objy+2);
   write(self.status_str);
   gotoxy(self.dpxofs,self.dpyofs+self.objy+3);
   a:=self.status_vb*sizeof(self.dbuf);
   a:=a+self.status_va*((sizeof(self.dbuf) div self.getobjcount));
   a:=a-((a shr 16)shl 16);
   self.hxdebug(self.status_vb div($10000 div sizeof(dbuf)));write(':');
   self.hxdebug(a);
  end;
 end;
end;

procedure amon.displaystatusline;
{ display cursor/page/filesize, indeed any three 16bit values.    }
{ the routine can parse upto three values by place holder '0000'. }

var a,b,c:byte;
var s1,s2:string;
begin
 if (self.dplytype=hxtxt) then
 begin
  if (self.objtype=txtdata) then
  begin
   a:=pos('0000',self.status_str);
   if (a<>0) then
   begin
    gotoxy(self.dpxofs+a-1,self.dpyofs+self.objy+2);
    self.hxdebug(self.status_va);
    s1:=copy(self.status_str,a+4,length(self.status_str)-a);
    b:=pos('0000',s1);
    if (b<>0) then
    begin
     gotoxy(self.dpxofs+a+b+2,self.dpyofs+self.objy+2);
     self.hxdebug(self.status_vb);
     s2:=copy(self.status_str,a+b+8,length(self.status_str)-(a+b));
     c:=pos('0000',s2);
     if (c<>0) then
     begin
      gotoxy(self.dpxofs+a+b+c+6,self.dpyofs+self.objy+2);
      self.hxdebug(self.status_vc);
     end;
    end;
   end;
  end;
 end;
end;

procedure amon.hxdebug(hx:word);
begin
 write(tblstr_hxtbl[hi(hx)][0]);
 write(tblstr_hxtbl[hi(hx)][1]);
 write(tblstr_hxtbl[lo(hx)][0]);
 write(tblstr_hxtbl[lo(hx)][1]);
end;

destructor amon.done;
begin
 close(dfile);
end;

begin
end.