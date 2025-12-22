unit AEDoor;

INTERFACE
uses Exec,dos;

const	AEMAXCHARS=200;
type	aestring= string[AEMAXCHARS-1];		{-1 for NULL byte in C string}

function CreateLink: pointer;
function CreateComm (node: longint): pointer;
procedure DeleteComm (dif: pointer);

procedure SendCmd
		(dif: pointer;
		command: longint);

procedure SendStrCmd
		(dif: pointer;
		command: longint;
		string_: aestring);

procedure SendDataCmd
		(dif: pointer;
		command,
		data: longint);

procedure SendStrDataCmd
		(dif: pointer;
		command: longint;
		string_: aestring;
		data: longint);

function GetData (dif: pointer): plongint;
function GetString (dif: pointer): strptr;

procedure Prompt
		(dif: pointer;
		length: longint;
		pstring: aestring);

procedure WriteStr
		(dif : pointer;
		 string_: aestring;
		 feed: longint);

procedure ShowGFile
		(dif: pointer;
		file_: aestring);

procedure ShowFile
		(dif: pointer;
		file_: aestring);

procedure SetDT
		(dif: pointer;
		id: longint;
		str: aestring);

procedure GetDT
		(dif: pointer;
		id: longint;
		str: aestring);

procedure GetStr
		(dif: pointer;
		length: longint;
		defstr: aestring);

function Hotkey
		(dif: pointer;
		promptstr: aestring): char;


const
  LF = 1;		{Old V1 Lib style, use the new style! }
  NOLF = 0;		{This is just for compatibility reasons }

  WSF_LF = 1;		{ WriteString() LineFeed Flag }
  WSF_SAFE = 2;		{ Allow strings larger than 200 chars }
			{ This is not useful in pascal, since the type check }
			{ won't allow you to use larger strings :-) }
  WSB_LF = 0;		{ Bit numbers }
  WSB_SAFE = 1;

{---------------------------------------------------------------------------
;	JHM_Command commands
---------------------------------------------------------------------------}
JH_LI			=	0;
JH_REGISTER		=	1;
JH_SHUTDOWN		=	2;
JH_WRITE		=	3;
JH_SM			=	4;
JH_PM			=	5;
JH_HK			=	6;
JH_SG			=	7;
JH_SF			=	8;
JH_EF			=	9;
JH_CO			=	10;
JH_BBSNAME		=	11;
JH_SYSOP		=	12;
JH_FLAGFILE		=	13;
JH_SHOWFLAGS		=	14;
JH_ExtHK		=	15;
JH_SIGBIT		=	16;
JH_FetchKey		=	17;
JH_SO			=	18;
DT_NAME           	=	100;
DT_PASSWORD       	=	101;
DT_LOCATION       	=	102;
DT_PHONENUMBER    	=	103;
DT_SLOTNUMBER     	=	104;
DT_SECSTATUS      	=	105;
DT_SECBOARD       	=	106;
DT_SECLIBRARY     	=	107;
DT_SECBULLETIN    	=	108;
DT_MESSAGESPOSTED 	=	109;
DT_UPLOADS        	=	110;
DT_DOWNLOADS      	=	111;
DT_TIMESCALLED    	=	112;
DT_TIMELASTON     	=	113;
DT_TIMEUSED       	=	114;
DT_TIMELIMIT      	=	115;
DT_TIMETOTAL      	=	116;
DT_BYTESUPLOAD    	=	117;
DT_BYTEDOWNLOAD   	=	118;
DT_DAILYBYTELIMIT 	=	119;
DT_DAILYBYTEDLD   	=	120;
DT_EXPERT         	=	121;
DT_LINELENGTH     	=	122;
ACTIVE_NODES      	=	123;
DT_DUMP           	=	124;
DT_TIMEOUT        	=	125;
BB_CONFNAME       	=	126;
BB_CONFLOCAL      	=	127;
BB_LOCAL          	=	128;
BB_STATUS         	=	129;
BB_COMMAND        	=	130;
BB_MAINLINE       	=	131;
NB_LOAD           	=	132;
DT_USERLOAD       	=	133;
BB_CONFIG         	=	134;
CHG_USER          	=	135;
RETURNCOMMAND     	=	136;
ZMODEMSEND        	=	137;
ZMODEMRECEIVE     	=	138;
SCREEN_ADDRESS    	=	139;
BB_TASKPRI        	=	140;
RAWSCREEN_ADDRESS 	=	141;
BB_CHATFLAG       	=	142;
DT_STAMP_LASTON   	=	143;
DT_STAMP_CTIME    	=	144;
DT_CURR_TIME      	=	145;
DT_CONFACCESS     	=	146;
BB_PCONFLOCAL     	=	147;
BB_PCONFNAME      	=	148;
BB_NODEID         	=	149;
BB_CALLERSLOG     	=	150;
BB_UDLOG          	=	151;
EXPRESS_VERSION   	=	152;
SV_UNICONIFY		=	153;
BB_CHATSET		=	162;
ENVSTAT			=	163;
GETKEY			=	500;
RAWARROW		=	501;
CHAIN			=	502;
NODE_DEVICE		=	503;
NODE_UNIT		=	504;
NODE_BAUD		=	505;
NODE_NUMBER		=	506;
JH_MCI			=	507;
PRV_COMMAND		=	508;
PRV_GROUP		=	509;
BB_CONFNUM		=	510;
BB_DROPDTR		=	511;
BB_GETTASK		=	512;
BB_REMOVEPORT		=	513;
BB_SOPT			=	514;
NODE_BAUDRATE		=	516;
BB_LOGONTYPE		=	517;
BB_SCRLEFT		=	518;
BB_SCRTOP		=	519;
BB_SCRWIDTH		=	520;
BB_SCRHEIGHT		=	521;
BB_PURGELINE		=	522;
BB_PURGELINESTART	=	523;
BB_PURGELINEEND		=	524;
BB_NONSTOPTEXT		=	525;
BB_LINECOUNT		=	526;
DT_LANGUAGE		=	527;
DT_QUICKFLAG		=	528;
DT_GOODFILE		=	529;
DT_ANSICOLOR		=	530;
MULTICOM		=	531;
LOAD_ACCOUNT		=	532;
SAVE_ACCOUNT		=	533;
SAVE_CONFDB		=	534;
LOAD_CONFDB		=	535;
GET_CONFNUM		=	536;
SEARCH_ACCOUNT		=	537;
APPEND_ACCOUNT		=	538;
LAST_ACCOUNTNUM		=	539;
MOD_TYPE		=	540;
DT_ISANSI		=	541;
BATCHZMODEMSEND		=	542;
DT_MSGCODE		=	543;
ACP_COMMAND		=	544;
DT_FILECODE		=	545;
EDITOR_STRUCT		=	546;
BYPASS_CSI_CHECK	=	547;
SENTBY			=	548;
SETOVERIDE		=	549;
FULLEDIT		=	550;
DT_ADDBIT		=	1000;
DT_REMBIT		=	1001;
DT_QUERYBIT		=	1002;
{---------------------------------------------------------------------------
;	JHM_Data for above commands!
---------------------------------------------------------------------------}
READIT			=	1;
WRITEIT			=	0;
{---------------------------------------------------------------------------
;	STATS@x values
---------------------------------------------------------------------------}
ENV_DROPPED		=	-1;
ENV_IDLE		=	0;
ENV_DOWNLOADING		=	1;
ENV_UPLOADING		=	2;
ENV_DOORS		=	3;
ENV_MAIL		=	4;
ENV_STATS		=	5;
ENV_ACCOUNT		=	6;
ENV_ZOOM		=	7;
ENV_FILES		=	8;
ENV_BULLETINS		=	9;
ENV_VIEWING		=	10;
ENV_LOGON		=	11;
ENV_LOGOFF		=	12;
ENV_SYSOP		=	13;
ENV_SHELL		=	14;
ENV_EMACS		=	15;
ENV_JOIN		=	16;
ENV_CHAT		=	17;
ENV_NOTACTIVE		=	18;
ENV_REQ_CHAT		=	19;
ENV_CONNECT     	=	20;
ENV_LOGGINGON   	=	21;
ENV_AWAITCONNECT 	=	22;
ENV_SCANNING    	=	23;
ENV_SHUTDOWN    	=	24;
ENV_MULTICHAT		=	25;
ENV_SUSPEND		=	26;
ENV_RESERVE		=	27;

  
var
  AEDBase: pLibrary;
  c_string: aestring;
  lc: boolean;

IMPLEMENTATION

function CreateLink;
var nod:string[3];
begin
	if ParamCount=0
	  then begin
	  	WriteLn('This is an AmiExpress door!  Needs AEDoor.library by SiNTAX/WøT!');
	  	halt(0);
	  end;
	nod:= ParamStr(1);
	CreateLink:= CreateComm(longint(nod[1]));
end;

function CreateComm; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),d0
	move.l	AEDBase,a6
	jsr		-$1E(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure DeleteComm; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a1
	move.l	AEDBase,a6
	jsr		-$24(a6)
	;move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure SendCmd; xassembler;
asm
	move.l	a6,-(sp)
	movem.l	8(sp),d0/a1
	move.l	AEDBase,a6
	jsr		-$2A(a6)
	move.l	(sp)+,a6
end;


procedure SendStrCmd;
begin
	PasToC(string_,c_string);
	asm
		lea		c_string,a0
		move.l	command,d0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$30(a6)
		move.l	(sp)+,a6
	end;
end;

procedure SendDataCmd; xassembler;
asm
	move.l	a6,-(sp)
	lea		8(sp),a6
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a1
	move.l	AEDBase,a6
	jsr		-$36(a6)
	move.l	(sp)+,a6
end;

procedure SendStrDataCmd;
begin
	PasToC(string_,c_string);
	asm
		lea		c_string,a0
		move.l	command,d0
		move.l	data,d1
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$3C(a6)
		move.l	(sp)+,a6
	end;
end;

function GetData; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a1
	move.l	AEDBase,a6
	jsr		-$42(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function GetString; xassembler;
asm
	move.l	a6,-(sp)
	move.l	8(sp),a1
	move.l	AEDBase,a6
	jsr		-$48(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

procedure Prompt;
begin
	PasToC(pstring,c_string);
	asm
		lea		c_string,a0
		move.l	length,d1
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$4E(a6)
		movem.l	(sp)+,a6			{ MOVEM!!! doesn't change CC! }
		seq		lc
	end;
end;

procedure WriteStr;
begin
	PasToC(string_,c_string);
	asm
		lea		c_string,a0
		move.l	feed,d1
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$54(a6)
		move.l	(sp)+,a6
	end;
end;

procedure ShowGFile;
begin
	PasToC(file_,c_string);
	asm
		lea		c_string,a0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$5A(a6)
		move.l	(sp)+,a6
	end;
end;

procedure ShowFile;
begin
	PasToC(file_,c_string);
	asm
		lea		c_string,a0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$60(a6)
		move.l	(sp)+,a6
	end;
end;

procedure SetDT;
begin
	PasToC(str,c_string);
	asm
		lea		c_string,a0
		move.l	id,d0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$66(a6)
		move.l	(sp)+,a6
	end;
end;

procedure GetDT;
begin
	PasToC(str,c_string);
	asm
		lea		c_string,a0
		move.l	id,d0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$6C(a6)
		move.l	(sp)+,a6
	end;
end;


procedure GetStr;
begin
	PasToC(defstr,c_string);
	asm
		lea		c_string,a0
		move.l	length,d1
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$72(a6)
		movem.l	(sp)+,a6
		seq		lc
		neg.b	lc
	end;
end;


function Hotkey;
var	ret:char;
begin
	PasToC(promptstr,c_string);
	asm
		lea		c_string,a0
		move.l	dif,a1
		move.l	a6,-(sp)
		move.l	AEDBase,a6
		jsr		-$7E(a6)
		movem.l	(sp)+,a6
		smi		lc
		neg.b	lc
		move.w	d0,ret
	end;
	Hotkey:= ret;			{ move.w d0,Hotkey doesn't work!! }
end;


end.
