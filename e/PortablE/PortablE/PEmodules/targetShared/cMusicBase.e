/* cMusicBase.e
	An abstract class which provides an easy interface for music.


Copyright (c) 2011 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

/* Public procedures:
   LoadMusic(file:ARRAY OF CHAR, allowReturnNIL=FALSE:BOOL) RETURNS music:PTR TO cMusic
DestroyMusic(music:PTR TO cMusic) RETURNS nil:PTR TO cMusic
 WaitForMusicEvent() RETURNS music:PTR TO cMusic
CheckForMusicEvent() RETURNS music:PTR TO cMusic
StoreMusic(name:ARRAY OF CHAR, number, music:OWNS PTR TO cMusic) RETURNS storedMusic:PTR TO cMusic
  UseMusic(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS music:PTR TO cMusic
*/
/* Public methods of *cMusic* class:
play(playCount=1)
stop()
infoLength()    RETURNS milliSeconds
infoIsPlaying() RETURNS isPlaying:BOOL
waitForPlayToFinish()
setVolume(volume) RETURNS music:PTR TO cMusic
getVolume() RETURNS volume
*/

MODULE 'targetShared/cAppBase', 'CSH/cStaticStringNumberPairSpace'

PRIVATE
DEF storeMusics:OWNS PTR TO cStaticStringNumberPairSpace/*<cMusic>*/
PUBLIC

PROC new()
	NEW storeMusics.new(FALSE)	->autoDealloc=FALSE
ENDPROC

PROC end()
	END storeMusics
ENDPROC

/*****************************/

PROC LoadMusic(file:ARRAY OF CHAR, allowReturnNIL=FALSE:BOOL) RETURNS music:PTR TO cMusic PROTOTYPE IS EMPTY

PROC DestroyMusic(music:PTR TO cMusic) RETURNS nil:PTR TO cMusic PROTOTYPE IS EMPTY

PROC WaitForMusicEvent() RETURNS music:PTR TO cMusic PROTOTYPE IS EMPTY

PROC CheckForMusicEvent() RETURNS music:PTR TO cMusic PROTOTYPE IS EMPTY

PROC StoreMusic(name:ARRAY OF CHAR, number, music:OWNS PTR TO cMusic) RETURNS storedMusic:PTR TO cMusic
	DEF temp
	
	IF music
		temp := storeMusics.set(name, number, music)
	ELSE
		temp := storeMusics.get(name, number, TRUE)	->quiet=TRUE
	ENDIF
	
	IF temp
		Print('ERROR: There was already a music with name=\'\s\' & number=\d\n', name, number)
		Throw("EMU", 'cMusic; StoreMusic(); you have already stored a bitmap with that name/number')
	ENDIF
	
	storedMusic := music
ENDPROC

PROC UseMusic(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS music:PTR TO cMusic
	music := storeMusics.get(name, number)::cMusic
	IF allowReturnNIL = FALSE
		IF music = NIL THEN Throw("EMU", 'cMusic; UseMusic(); there was no music matching that name/number')
	ENDIF
ENDPROC

/*****************************/

CLASS cMusic ABSTRACT OF cAppResource
ENDCLASS

PROC play(playCount=1) OF cMusic IS EMPTY

PROC stop() OF cMusic IS EMPTY

PROC infoLength() OF cMusic RETURNS milliSeconds IS EMPTY

PROC infoIsPlaying() OF cMusic RETURNS isPlaying:BOOL IS EMPTY

PROC waitForPlayToFinish() OF cMusic IS EMPTY

PROC setVolume(volume) OF cMusic RETURNS music:PTR TO cMusic IS EMPTY

PROC getVolume() OF cMusic RETURNS volume IS EMPTY

/*****************************/
