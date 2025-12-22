unit fcopy;

{ copy source file to destination file,             }
{ which is aligned to the bounds of the buffer      }
{ datatype. set margin bytes in the buffer to zero. }

interface

{$i buf.inc}

type filecopy=object
 dbuf:Tdbuf;
 fsrc,fdst:file;
 srcfile,dstfile:string;

 constructor init;
 procedure assignsrcfile(s:string);
 procedure assigndstfile(s:string);
 procedure extendfile;

 function getsrcfilename:string;
 function getdstfilename:string;

 destructor done;
end;

implementation

constructor filecopy.init;
begin
 self.srcfile:='';
 self.dstfile:='';
end;

procedure filecopy.assignsrcfile(s:string);
begin
 self.srcfile:=s;
end;

procedure filecopy.assigndstfile(s:string);
begin
 self.dstfile:=s;
end;

procedure filecopy.extendfile;

var rbytes,wbytes:word;
var st,i:word;

begin
 assign(self.fsrc,self.srcfile);
 reset(self.fsrc,1);
 assign(self.fdst,self.dstfile);
 rewrite(self.fdst,1);

 repeat
  blockread(self.fsrc,self.dbuf,sizeof(self.dbuf),rbytes);

  if (rbytes<sizeof(self.dbuf))then
   begin
   st:=rbytes shr 1;
   for i:=st to (sizeof(self.dbuf) shr 1)-1 do
   begin
    if (i>st) then self.dbuf[i]:=0;
    if (i=st) then
    begin
     if((rbytes and 1)=1)then self.dbuf[i]:=self.dbuf[i] and $ff;
     if((rbytes and 1)=0)then self.dbuf[i]:=0;
    end;
   end;
  end;

 blockwrite(self.fdst,self.dbuf,sizeof(self.dbuf),wbytes);
 until ((rbytes=0)or(rbytes<>sizeof(self.dbuf)));

 close(self.fsrc);
 close(self.fdst);
end;

function filecopy.getsrcfilename:string;
begin
 getsrcfilename:=self.srcfile;
end;

function filecopy.getdstfilename:string;
begin
 getdstfilename:=self.dstfile;
end;

destructor filecopy.done;
begin
end;

begin
end.