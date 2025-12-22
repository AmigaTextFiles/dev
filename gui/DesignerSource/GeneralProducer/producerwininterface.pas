unit producerwininterface;

{
changes 
  ng _ highlabel
}

interface

uses asl,utility,exec,intuition,workbench,producerlib,
     amiga,gadtools,graphics,dos,amigados,definitions;

const
  alldone : string[10]='File Done'#0;
  writingfile : string[20]='Writing file'#0;
  tidyup : string[20]='Completing file'#0;
  badfile : string[20]='Could not load'#0;
  aborted : string[8]='Aborted'#0;
  fileunopen  : string[17] = 'Cannot open file'#0;
  fileunclose : string[18] = 'Cannot close file'#0;
  failed      : string[18] = 'Production Failed'#0;
  loading     : string[10] = 'Loading'#0;
  nomem       : string[14] = 'No Memory'#0;
  makemainfile: string[18] = 'Writing Main File'#0;
  
var
  wintitle : string;
  filestr  : string;
  dummy        : long;

function openmainwindow:boolean;
procedure closemainwindow;
procedure doing(pb : pbyte);
procedure setfilename(s:string);
procedure setlinenumber;
function checkinput:boolean;
function godome(st:pbyte):boolean;

implementation

function godome(st:pbyte):boolean;
begin
  godome:=boolean(ProducerWindowWriteMain(producernode,st));
end;

function checkinput:boolean;
begin
  checkinput:=boolean(not ProducerWindowUserAbort(producernode));
end;

function openmainwindow:boolean;
begin
  producernode:=GetProducer;
  if producernode<>nil then
  	begin
      if not OpenProducerWindow(producernode,@DisplayWindowTitle[1]) then
  	    begin
  	      FreeProducer(producernode);
  	      producernode:=nil;
  	    end;
  	end;
  openmainwindow:=(producernode<>nil);
end;

procedure doing(pb : pbyte);
begin
  setproducerwindowaction(producernode,pb);
end;

procedure closemainwindow;
begin
  freeproducer(producernode);
end;

procedure setfilename(s:string);
begin
  filestr:=s;
  setproducerwindowfilename(producernode,@filestr[1]);
end;

procedure setlinenumber;
begin
  setproducerwindowlinenumber(producernode,linecount);
end;

end.