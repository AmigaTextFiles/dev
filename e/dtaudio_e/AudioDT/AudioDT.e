OPT MODULE
OPT EXPORT

/*
 * This module is for hear files (VOC,WAV,IFF etc.)
 * by means of datatypes.library
 *
 * AudioDT v1.0 - written by Krzysztof Cmok
 * module is written in day 11-May-99
 *
 */

MODULE	'datatypes/datatypesclass'	-> definicje...
MODULE	'datatypes/soundclass'		-> object 'voiceheader'
MODULE	'intuition/classes'		-> object struct ;)
MODULE	'amigalib/boopsi'		-> dla domethod
MODULE	'datatypes'			-> wiadomo co

OBJECT audiodt
    obj:PTR TO object			-> objekt
    cycles:PTR TO LONG			-> sample cycles
    period:PTR TO LONG		        -> sample period
    volume:PTR TO LONG		        -> sample volume
    buf:PTR TO LONG			-> sample data
    buflen:PTR TO LONG			-> sample length
ENDOBJECT

->- procedure for open file...
PROC load(filename) OF audiodt
DEF buf,buflen

	IF (datatypesbase:=OpenLibrary('datatypes.library',0))=0 THEN RETURN 0
	
	self.obj:=NewDTObjectA(filename,
				[DTA_SOURCETYPE, DTST_FILE,
				 DTA_GROUPID,	 $736F756E,		-> ID: pict
				 SDTA_CONTINUOUS,	TRUE,
				 SDTA_VOLUME,		self.volume,
				 SDTA_CYCLES,		self.cycles,0])
	IF self.obj=0 THEN RETURN 0

	GetDTAttrsA(self.obj,[SDTA_SAMPLE,{buf},0])
	GetDTAttrsA(self.obj,[SDTA_SAMPLELENGTH,{buflen},0])

	self.buf:=buf;
	self.buflen:=buflen;
	IF buflen=0 THEN RETURN 0
ENDPROC -1

->- play
PROC play() OF audiodt
DEF dtt:PTR TO dttrigger

	IF self.obj=0 THEN RETURN 0
		NEW dtt
		dtt.methodid := DTM_TRIGGER;
		dtt.function := STM_PLAY;
		doMethodA(self.obj,dtt);
		END dtt

ENDPROC -1

->- set volume
PROC setvolume(vol) OF audiodt

	IF self.obj=0 THEN RETURN 0
		SetDTAttrsA(self.obj,0,0,[SDTA_VOLUME,vol,0]);
		self.volume:=vol;
ENDPROC -1

->- set period
PROC setperiod(per) OF audiodt

	IF self.obj=0 THEN RETURN 0
		SetDTAttrsA(self.obj,0,0,[SDTA_PERIOD,per,0]);
		self.period:=per;
ENDPROC -1

->- set cycles
PROC setcycles(cyc) OF audiodt

	IF self.obj=0 THEN RETURN 0
		SetDTAttrsA(self.obj,0,0,[SDTA_CYCLES,cyc,0]);
		self.cycles:=cyc
ENDPROC -1


->- dispose
PROC dispose() OF audiodt
	DisposeDTObject(self.obj)
	Dispose(self.obj)
	CloseLibrary(datatypesbase);
	self.obj:=0;
ENDPROC -1

/* SIMPLE EXAMPLE
 *****************

PROC main()
DEF a:PTR TO audiodt

NEW a

IF (a.load('meanswar.wav'))=0 THEN CleanUp()

a.setvolume(64);
a.setperiod(330);
a.setcycles(1);
a.play()
Delay(100);
a.dispose()

END a

ENDPROC

*/
