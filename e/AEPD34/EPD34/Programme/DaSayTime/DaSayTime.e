OPT OSVERSION=37

/****
**
** Product: DaSayTime.e
**
** Syntax : DaSayTime <P=PATH> [S=SAMPLERATE] [V=VOLUME] [H=12H]
**
** Author : Jørgen 'Da' Larsen (dapp@iesd.auc.dk)
**			Carl Blochs Vej 20
**			9000 Aalborg
**			Denmark
**
** Idea   : saytime - Jef Poskanzer
**
** History: Version 0.1
**				- First try!! Works :)
**			Version 0.2
**				- Added CONST instead of #define
**				- Added version string
**				- Added _better_ error handling
**				- Added 12H option (18:00:00->06:00:00)		(SSP)
**				- Added SAMPLERATE option (DEFAULT 8000)
**				- Added real arg. handling
**				- Added PAL/NTSC check
**			Version 0.3
**				- Bug when the clock was 00:__:__			(DA)
**				  changed too 24:__:__
**				- Added VOLUME option 
**
** To do  : Figure out why
**				IF arequest.length=4 THEN DeleteIORequest(arequest) /*WORKS*/
**				IF arequest			 THEN DeleteIORequest(arequest) /*CRASH*/
**			Data:
**				ioReq = CreateIORequest( ioReplyPort, size );
**				ioReq - A pointer to the new IORequest block, or NULL.
**				NULL:=NIL!!!!!
**
*/

MODULE	'devices/audio',
		'dos/datetime',
		'dos/dos',
		'dos/rdargs',
		'exec/io',
		'exec/memory',
		'exec/ports',
		'graphics/gfxbase'


CONST PH_ONE = 1
CONST PH_TWO = 2
CONST PH_THREE = 3
CONST PH_FOUR = 4
CONST PH_FIVE = 5
CONST PH_SIX = 6
CONST PH_SEVEN = 7
CONST PH_EIGHT = 8
CONST PH_NINE = 9
CONST PH_TEN = 10
CONST PH_ELEVEN = 11
CONST PH_TWELVE = 12
CONST PH_THIRTEEN = 13
CONST PH_FOURTEEN = 14
CONST PH_FIFTEEN = 15
CONST PH_SIXTEEN = 16
CONST PH_SEVENTEEN = 17
CONST PH_EIGHTEEN = 18
CONST PH_NINETEEN = 19
CONST PH_TWENTY = 20
CONST PH_THIRTY = 21
CONST PH_FORTY = 22
CONST PH_FIFTY = 23
CONST PH_THE_TIME_IS = 24
CONST PH_OCLOCK = 25
CONST PH_OH = 26
CONST PH_EXACTLY = 27
CONST PH_AND = 28
CONST PH_SECOND = 29
CONST PH_SECONDS = 30

CONST BUFFSIZE = 8192

ENUM ERR_ARG=1, ERR_VOL, ERR_INT, ERR_OPEN, ERR_MEM, ERR_PORT, ERR_IO

DEF path:PTR TO LONG, rate=8000, vol

PROC main() HANDLE
 /* ReadArgs DEF's */
 DEF readargs:PTR TO rdargs, args:PTR TO LONG
 DEF eng

 /* Time DEF's */
 DEF dt:datetime,ds:PTR TO datestamp
 DEF hour,min,sec

 IF (readargs:=ReadArgs('P=PATH/A,S=SAMPLERATE,V=VOLUME,H=12H/S',args:=[NIL,NIL,NIL,NIL],NIL))=NIL THEN Throw(ERR_ARG,0)

 /* Arg Handling */
 path:=String(StrLen(args[0]))
 StrCopy(path,args[0],ALL)

 IF args[1]<>NIL		
	rate:=Val(args[1])
 ELSE
	rate:=8000
 ENDIF

 vol:=Val(args[2])
 IF vol<>NIL
 	IF ( (vol<1) OR (vol>64) )
		Throw(ERR_VOL,0)
	ENDIF
 ELSE
	vol:=64
 ENDIF

 eng:=args[3]

 /* Get the current time */
 ds:=DateStamp(dt.stamp)
 min,hour:=Mod(ds.minute,60)
 sec:=ds.tick/50

 /* Say the time is */
 sayphrase( PH_THE_TIME_IS );

 /* Say Hour */
 IF eng=TRUE
	IF ( hour=0 )
		saynumber( 12, 0 )
	ELSEIF ( hour > 12 )
		saynumber( hour - 12, 0 )
	ELSE
		saynumber( hour, 0 )
 	ENDIF
 ELSE
	IF ( hour=0 )
		saynumber( 24, 0 )
	ELSE
		saynumber( hour, 0 )
	ENDIF
 ENDIF

 /* Say min. */
 IF ( min = 0 )
	sayphrase ( PH_OCLOCK )
 ELSE
	saynumber( min, 1 )
 ENDIF

 /* Say sec. */
 IF ( sec = 0 )
	sayphrase( PH_EXACTLY )
 ELSE
	sayphrase( PH_AND )
	saynumber( sec, 0 )
	IF ( sec = 1 )
		sayphrase( PH_SECOND )
	ELSE
		sayphrase( PH_SECONDS )
	ENDIF
 ENDIF

EXCEPT
	SELECT exception
		CASE ERR_INT
			PrintF( 'DaSayTime: Internal error - \s\n', exceptioninfo )
		CASE ERR_VOL
			PrintF( 'DaSayTime: Option VOLUME need a value from 1 to 64\n')
		CASE ERR_ARG
			PrintF('[1mDaSayTime (c) 1995 Jørgen \aDa\a Larsen (Posse Pro. DK)[0m\n'+
				   'Syntax:  DaSayTime <P=PATH> [S=SAMPLERATE] [V=VOLUME] [H=12H]\n'+
				   'Example: DaSayTime Work:music/DaSayTime/Sounds/\n')
	ENDSELECT
ENDPROC

PROC sayfile( filename )
	DEF execstr[256]:STRING
	StringF(execstr,'\s\s',path,filename)
	play(execstr,rate)
ENDPROC

PROC play(filename,rate) HANDLE
	/* Audio DEF's */
	DEF arequest:ioaudio, reply=NIL, ior:PTR TO io, adevice=1, mnode:PTR TO mn

	/* File DEF's */
	DEF memoryblock=NIL, file, len

	/* NTSC/PAL check DEF's */
	DEF gfxBase:PTR TO gfxbase, clock 

	/* Check if PAL or NTSC */		
	gfxBase:=gfxbase
	IF gfxBase.displayflags AND PAL
		clock := 3546895;		 /* PAL clock */
	ELSE
		clock := 3579545;		 /* NTSC clock */
	ENDIF

	IF (file:=Open(filename,MODE_OLDFILE))=NIL THEN Throw(ERR_OPEN,filename)

	IF (memoryblock:=AllocMem(BUFFSIZE,MEMF_CHIP))=NIL THEN Throw(ERR_MEM,BUFFSIZE)

	IF (reply:=CreateMsgPort())=NIL THEN Throw(ERR_PORT,0)

	IF (arequest:=CreateIORequest(reply, SIZEOF ioaudio))=NIL THEN Throw(ERR_IO,0)

	/* want to allocate and use any channel with OpenDev() */
	arequest.data	:= [1,2,4,8]:CHAR
	arequest.length := 4					/* This number is checks in EXECPT */
	ior				:= arequest
	ior.command		:= ADCMD_ALLOCATE

	IF (adevice:=OpenDevice('audio.device', 0, arequest, 0))<>NIL THEN Throw(ERR_OPEN,'audio.device')

	len:=Read(file,memoryblock,BUFFSIZE)
	ior.flags		:= ADIOF_PERVOL
	ior.command		:= CMD_WRITE
	arequest.data	:= memoryblock
	arequest.length := len
	arequest.volume := vol					/* volume = MAX */
	arequest.period := Div(clock,rate)		/* set frequency */
	arequest.cycles := 1					/* 1 cycle only */
	mnode			:= arequest
	mnode.replyport := reply

	/* start audio device */
	beginIO(arequest)

	/* clean up */
	WaitPort(mnode.replyport)
	GetMsg(mnode.replyport)
EXCEPT DO
	IF file THEN Close(file)
	IF memoryblock THEN FreeMem(memoryblock,BUFFSIZE)
	IF reply THEN DeleteMsgPort(reply)
	IF arequest.length=4 THEN DeleteIORequest(arequest)
	IF adevice=NIL THEN CloseDevice(arequest)
	SELECT exception
		CASE ERR_MEM
			PrintF( 'DaSayTime: Could\an allocate \s bytes\n', exceptioninfo )
		CASE ERR_PORT
			PrintF( 'DaSayTime: Could\an Create Message Port\n')
		CASE ERR_IO
			PrintF( 'DaSayTime: Could\an Create IO port\n')
		CASE ERR_OPEN
			PrintF( 'DaSayTime: Could\an open \s\n', exceptioninfo )
	ENDSELECT
ENDPROC

PROC beginIO(arequest)
	MOVE.L	arequest,A1
	MOVE.L	A6,-(A7)
	MOVE.L	$14(A1),A6
	JSR -$1E(A6)
	MOVE.L	(A7)+,A6
ENDPROC

PROC saydigit( n )
	SELECT n
		CASE 1
			sayphrase( PH_ONE )
		CASE 2
			sayphrase( PH_TWO )
		CASE 3
			sayphrase( PH_THREE )
		CASE 4
			sayphrase( PH_FOUR )
		CASE 5
			sayphrase( PH_FIVE )
		CASE 6
			sayphrase( PH_SIX )
		CASE 7
			sayphrase( PH_SEVEN )
		CASE 8
			sayphrase( PH_EIGHT )
		CASE 9
			sayphrase( PH_NINE )
		DEFAULT
			Throw(ERR_INT,'saydigit()')
	ENDSELECT
ENDPROC

PROC sayphrase( phrase )
	SELECT phrase
		CASE PH_ONE
			sayfile( '1.iff' )
		CASE PH_TWO
			sayfile( '2.iff' )
		CASE PH_THREE
			sayfile( '3.iff' )
		CASE PH_FOUR
			sayfile( '4.iff' )
		CASE PH_FIVE
			sayfile( '5.iff' )
		CASE PH_SIX
			sayfile( '6.iff' )
		CASE PH_SEVEN
			sayfile( '7.iff' )
		CASE PH_EIGHT
			sayfile( '8.iff' )
		CASE PH_NINE
			sayfile( '9.iff' )
		CASE PH_TEN
			sayfile( '10.iff' )
		CASE PH_ELEVEN
			sayfile( '11.iff' )
		CASE PH_TWELVE
			sayfile( '12.iff' )
		CASE PH_THIRTEEN
			sayfile( '13.iff' )
		CASE PH_FOURTEEN
			sayfile( '14.iff' )
		CASE PH_FIFTEEN
			sayfile( '15.iff' )
		CASE PH_SIXTEEN
			sayfile( '16.iff' )
		CASE PH_SEVENTEEN
			sayfile( '17.iff' )
		CASE PH_EIGHTEEN
			sayfile( '18.iff' )
		CASE PH_NINETEEN
			sayfile( '19.iff' )
		CASE PH_TWENTY
			sayfile( '20.iff' )
		CASE PH_THIRTY
			sayfile( '30.iff' )
		CASE PH_FORTY
			sayfile( '40.iff' )
		CASE PH_FIFTY
			sayfile( '50.iff' )
		CASE PH_THE_TIME_IS
			sayfile( 'the_time_is.iff' )
		CASE PH_OCLOCK
			sayfile( 'oclock.iff' )
		CASE PH_OH
			sayfile( 'oh.iff' )
		CASE PH_EXACTLY
			sayfile( 'exactly.iff' )
		CASE PH_AND
			sayfile( 'and.iff' )
		CASE PH_SECOND
			sayfile( 'second.iff' )
		CASE PH_SECONDS
			sayfile( 'seconds.iff' )
		DEFAULT
			Throw(ERR_INT,'sayphrase()')
	ENDSELECT
ENDPROC

PROC saynumber( n, leadingzero )
	DEF ones, tens
	ones,tens:=Mod(n,10)
	SELECT tens
		CASE 0
			IF ( leadingzero ) THEN sayphrase( PH_OH )
			saydigit( ones )
		CASE 1
			SELECT ones
				CASE 0
					sayphrase( PH_TEN )
				CASE 1
					sayphrase( PH_ELEVEN )
				CASE 2
					sayphrase( PH_TWELVE )
				CASE 3
					sayphrase( PH_THIRTEEN )
				CASE 4
					sayphrase( PH_FOURTEEN )
				CASE 5
					sayphrase( PH_FIFTEEN )
				CASE 6
					sayphrase( PH_SIXTEEN )
				CASE 7
					sayphrase( PH_SEVENTEEN )
				CASE 8
					sayphrase( PH_EIGHTEEN )
				CASE 9
					sayphrase( PH_NINETEEN )
				DEFAULT
					Raise()
			ENDSELECT
		CASE 2
			sayphrase( PH_TWENTY )
			IF ( ones<>0 ) THEN saydigit( ones )
		CASE 3
			sayphrase( PH_THIRTY )
			IF ( ones<>0 ) THEN saydigit( ones )
		CASE 4
			sayphrase( PH_FORTY )
			IF ( ones<>0 ) THEN saydigit( ones )
		CASE 5
			sayphrase( PH_FIFTY )
			IF ( ones<>0 ) THEN saydigit( ones )
		DEFAULT
			Throw(ERR_INT,'saynumber()')
	ENDSELECT
ENDPROC

CHAR '$VER: DaSayClock v0.3 (08.08.95) Jørgen ''Da'' Larsen',0
