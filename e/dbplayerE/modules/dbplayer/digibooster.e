/*

				DigiBooster.m 

				    by

		Wojtek Zatorski (email: wzator@polbox.com)

		ul. Wrocîawska 23/9
		67-100 Nowa Sól
		POLAND


POMOC :

init()				
dispose()			
loadfile(name)			- wgranie moduîu do pamiëci (nie sprawdza czy to moduî!)
playmodule(mode,frequency)	- granie moduîu
stopmodule()			- zatrzymanie moduîu
volume(volume)			- ustawienie gîoônoôci
position(songPos,patternPos)	- ustawienie pozycji moduîu
checkpos(songPos,patternPos)	- sprawdza czy granie moduîu znalazîo sië na podanej pozycji
get7()				- pobierz ostatniâ komende 7xx

HISTORY :

v1.0 - First Release (20.08.1998)
v1.1 - added new function (checkpos,get7,getattr), removed function waitpos

*/
OPT MODULE
OPT EXPORT,PREPROCESS

MODULE 'dbplayer/dbplayer','dbplayer','utility'

OBJECT digibooster
mem:LONG
len:LONG
ENDOBJECT

PROC init(opts=0) OF digibooster
VOID '$VER: DigiPlayer.m v1.0 by WZP'
IF (dbplayerbase:=OpenLibrary('dbplayer.library',2))=NIL THEN Throw("lib",{dbOpen})
ENDPROC

PROC dispose(opts=0) OF digibooster
IF dbplayerbase THEN CloseLibrary(dbplayerbase)
ENDPROC

PROC loadfile(name) OF digibooster
DEF len,in

len:=FileLength(name)

IF len>0

	self.mem:=New(len)
	IF in:=Open(name,OLDFILE)
	Read(in,self.mem,len)
	self.len:=len
	Close(in)
	RETURN TRUE
	ELSE
	RETURN FALSE
	ENDIF

ELSE
RETURN FALSE
ENDIF

ENDPROC

PROC playmodule(mode=0,freq=0) OF digibooster
DbM_StartModule(self.mem,self.len,mode,freq,DBF_AUTOBOOST)
ENDPROC

PROC stopmodule() OF digibooster
DbM_StopModule()
ENDPROC

PROC volume(vol) OF digibooster
DbM_SetVolume(vol)
ENDPROC

PROC position(song,patt) OF digibooster
DbM_SetPosition(song,patt)
ENDPROC

PROC get7() OF digibooster
ENDPROC DbM_Get7Command()

PROC checkposition(song,patt) OF digibooster
DbM_CheckPosition(song,patt)
ENDPROC


PROC getattr(tagi) OF digibooster
DbM_GetModuleAttrA(tagi)
ENDPROC


dbOpen:
 CHAR 'Unable to open digiplayer.library.',0
