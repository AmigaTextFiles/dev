PROGRAM triangle;
{ Programmed by the Informer/PTL as an example for the AEDoor.Library    }
{ by SiNTAX/WøT.                                                         }
{ addedd check for null DIF                                              }
{ Triangle has no meaning as a door, but it shows a few tricks of Pascal } 
{ ---------------------------------------------------------------------- }
    
USES exec,AEDoor;

VAR  

str:strptr;
    data:pLongint;
    d:pointer;
    username,LinesStr:aestring;
    key:char;
    stars,left,right,empty,lines,i:integer;

BEGIN
	AEDBase:= OpenLibrary('AEDoor.library',1);
	IF AEDBase=NIL
		then 
		begin
			WriteLn('Needs AEDoor.library to run!');
			Halt(0);
		end;

	d:= CreateLink;
	IF d=NIL
		then
		begin
			WriteLn('This is supposed to be run from AmiExpress!');
			CloseLibrary(AEDBase);
			Halt(0);
		end;

	str:=  GetString(d);
	data:= GetData(d);
	
	
	Prompt(d,2,'How many lines for the triangle? ');
	CToPas(str^,LinesStr);
    Val(LinesStr,lines,i); 				{String to integer!}
	stars:=1;
	for left:= lines downto 1 do
		begin
				for empty:=left downto 1 do
				WriteStr(d,' ',NOLF);
				for right:=1 to stars do
				WriteStr(d,'*',NOLF);
				Inc(stars,2);
				WriteStr(d,' ',LF);
		end;				
	DeleteComm(d);
	CloseLibrary(AEDBase);
END.

