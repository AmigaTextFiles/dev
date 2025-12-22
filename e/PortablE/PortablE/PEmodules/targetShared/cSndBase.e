/* cSndBase.e
	An abstract class which provides an easy interface for sounds.


Copyright (c) 2011 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

/* Public procedures:
   LoadSound(file:ARRAY OF CHAR, allowReturnNIL=FALSE:BOOL) RETURNS sound:PTR TO cSnd
DestroySound(sound:PTR TO cSnd) RETURNS nil:PTR TO cSnd
 WaitForSoundEvent() RETURNS sound:PTR TO cSnd
CheckForSoundEvent() RETURNS sound:PTR TO cSnd
StoreSound(name:ARRAY OF CHAR, number, sound:OWNS PTR TO cSnd) RETURNS storedSound:PTR TO cSnd
  UseSound(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS sound:PTR TO cSnd
*/
/* Public methods of *cSnd* class:
play(playCount=1, speed=100)
stop()
infoLength()    RETURNS milliSeconds
infoIsPlaying() RETURNS isPlaying:BOOL
waitForPlayToFinish()
setVolume(volume) RETURNS sound:PTR TO cSnd
getVolume() RETURNS volume
setPan(pan) RETURNS sound:PTR TO cSnd
getPan() RETURNS pan
*/

/*
Possible FUTURE procedures:
 WaitForSoundEvent() RETURNS sound:PTR TO cSnd, id
CheckForSoundEvent() RETURNS sound:PTR TO cSnd, id

Possible FUTURE methods for cSnd:
play(playCount=1, speed=100) RETURNS id
stop(id=0)
infoIsPlaying(id=0) RETURNS isPlaying:BOOL
infoPlayCount(id) RETURNS playCount
infoSpeed(id)  RETURNS speed
waitForPlayToFinish(id=0)
setVolume(volume, id=0) RETURNS sound:PTR TO cSnd
getVolume(id=0) RETURNS volume
setPan(pan, id=0) RETURNS sound:PTR TO cSnd
getPan(id=0) RETURNS pan
*/

MODULE 'targetShared/cAppBase', 'CSH/cStaticStringNumberPairSpace'

PRIVATE
DEF storeSounds:OWNS PTR TO cStaticStringNumberPairSpace/*<cSnd>*/
PUBLIC

PROC new()
	NEW storeSounds.new(FALSE)	->autoDealloc=FALSE
ENDPROC

PROC end()
	END storeSounds
ENDPROC

/*****************************/

PROC LoadSound(file:ARRAY OF CHAR, allowReturnNIL=FALSE:BOOL) RETURNS sound:PTR TO cSnd PROTOTYPE IS EMPTY

PROC DestroySound(sound:PTR TO cSnd) RETURNS nil:PTR TO cSnd PROTOTYPE IS EMPTY

PROC WaitForSoundEvent() RETURNS sound:PTR TO cSnd PROTOTYPE IS EMPTY

PROC CheckForSoundEvent() RETURNS sound:PTR TO cSnd PROTOTYPE IS EMPTY

PROC StoreSound(name:ARRAY OF CHAR, number, sound:OWNS PTR TO cSnd) RETURNS storedSound:PTR TO cSnd
	DEF temp
	
	IF sound
		temp := storeSounds.set(name, number, sound)
	ELSE
		temp := storeSounds.get(name, number, TRUE)	->quiet=TRUE
	ENDIF
	
	IF temp
		Print('ERROR: There was already a sound with name=\'\s\' & number=\d\n', name, number)
		Throw("EMU", 'cSnd; StoreSound(); you have already stored a bitmap with that name/number')
	ENDIF
	
	storedSound := sound
ENDPROC

PROC UseSound(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS sound:PTR TO cSnd
	sound := storeSounds.get(name, number)::cSnd
	IF allowReturnNIL = FALSE
		IF sound = NIL THEN Throw("EMU", 'cSnd; UseSound(); there was no sound matching that name/number')
	ENDIF
ENDPROC

/*****************************/

CLASS cSnd ABSTRACT OF cAppResource
ENDCLASS

PROC play(playCount=1, speed=100) OF cSnd IS EMPTY

PROC stop() OF cSnd IS EMPTY

PROC infoLength() OF cSnd RETURNS milliSeconds IS EMPTY

PROC infoIsPlaying() OF cSnd RETURNS isPlaying:BOOL IS EMPTY

PROC waitForPlayToFinish() OF cSnd IS EMPTY

PROC setVolume(volume) OF cSnd RETURNS sound:PTR TO cSnd IS EMPTY

PROC getVolume() OF cSnd RETURNS volume IS EMPTY

PROC setPan(pan) OF cSnd RETURNS sound:PTR TO cSnd IS EMPTY

PROC getPan() OF cSnd RETURNS pan IS EMPTY

/*****************************/
