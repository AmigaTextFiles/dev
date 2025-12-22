program test;
uses exec,AEDoor;

var   d:pointer;
	str:strptr;
	data:plongint;
	txt:aestring; usern:aestring; chatflag:aestring;
	key:char;
begin
	{============ Standard Door Setup stuff =============}
 	AEDBase:= OpenLibrary('AEDoor.library',1);
	d:= CreateLink;			{=== Establish link with /X's doorport ===}
	IF d=NIL
		THEN BEGIN
			WriteLn('This is supposed to be run from AmiExpress!');
			CloseLibrary(AEDBase);
			halt(0);
		     END;

	str:= GetString(d);		{=== Get the pointer to the string field ===}
	data:= GetData(d);		{=== Get the pointer to the data field ===}
	
	{=== Test for GetData() ===}
	SendCmd(d,BB_LOGONTYPE);
	case data^ of
		0: txt:='AWAIT LOGON';
		1: txt:='SYSOP_LOGON';
		2: txt:='LOCAL_LOGON';
		3: txt:='REMOTE_LOGON';
		else txt:='UNKNOWN LOGON TYPE';
	end;
	WriteStr(d,txt,LF);

	{=== Test for SendStrDataCmd() ===}
	SendStrDataCmd(d,DT_NAME,'SiNTAX/WøT!',WRITEIT);

	{=== Test for SendDataCmd() ===}
	SendDataCmd(d,DT_NAME,1);  CToPas(str^,usern);
	WriteStr(d,'Username :'+usern,LF);

	{=== Test for SendStrCmd() ===}	
	SendStrCmd(d,JH_WRITE,'Testing...');
	
	{=== Test for SendCmd() ===}
	SendCmd(d,BB_CHATFLAG);	CToPas(str^,chatflag);
	WriteStr(d,chatflag,LF);
	

	{=== Test for GetDT() ===}
	GetDT(d,DT_NAME,'');  CToPas(str^,usern);
	WriteStr(d,'Username :'+usern,LF);

	{=== Test for SetDT() ===}
	SetDT(d,DT_NAME,usern+'!');

	
	{=== Test ShowFile() and ShowGFile() ===}
	ShowFile(d,'BBS:Node0/ENDCHAT.txt');
	ShowGFile(d,'BBS:Node0/ENDCHAT');


	{=== Test da HotKey function, remember this sets/clrs the boolean LC ===}
	key:= HotKey(d,'--- Press any key to continue ---');
	if lc
	   then WriteStr(d,'OOPS! LOST CARRIER',LF)
	   else begin
				WriteStr(d,'You pressed: ',NOLF);
				WriteStr(d,key,LF);
			end;


	{=== Test da GetStr procedure, remember this sets/clrs the boolean LC ===}
	GetStr(d,30,'default input');
	if lc
	   then WriteStr(d,'LOST CARRIER',LF)
	   else begin
	   			CToPas(str^,txt);		{Fetch the input string & convert to a }
	   			WriteStr(d,txt,LF);		{pascal string                         }
	   		end;

	{=== Test da Prompt procedure, remember this sets/clrs the boolean LC ===}
	Prompt(d,30,'Input: ');
	if lc
	   then WriteStr(d,'LOST CARRIER',LF)
	   else begin
	   			CToPas(str^,txt);		{Fetch the input string & convert to a }
	   			WriteStr(d,txt,LF);		{pascal string                         }
	   		end;

	{============ Standard Door Exit stuff ==============}
	DeleteComm(d);			{=== Close da link with /X ===}
	CloseLibrary(AEDBase);
end.
