/*
**
** ServerPort v1.0 by Dr. Ice/lISENCE
**
** This utility will send a message to the current port (if found)
** It will return TRUE or FALSE if anything goes wrong..
**
** This E module is specially made for /X coders, thanks to Splash
** for the ASM-routine..
**
** The usage is quite easy:
**
** Usage: Portname, command
**
** See SERVERCONST.e for commands
**
*/

MODULE	'*serverconst',
	'*server'

DEF	open

PROC main()
	IF (open:=serverPort('AEServer.0',SV_CHAT))=NIL
		WriteF('Error opening server\n')
	ENDIF
ENDPROC

