OPT MODULE
OPT PREPROCESS
OPT EXPORT

OBJECT midiunitdef
	mididevicename[32] : ARRAY OF CHAR
	midiclusterinname[32] : ARRAY OF CHAR
	midiclusteroutname[32] : ARRAY OF CHAR
	mididevicecomment[34] : ARRAY OF CHAR
	midideviceport : CHAR
	flags : CHAR
	xmitqueuesize : LONG
	recvqueuesize : LONG
ENDOBJECT

ENUM MUDB_INTERNAL,
     MUDB_IGNORE

SET MUDF_INTERNAL,
    MUDF_IGNORE

CONST MINXMITQUEUESIZE =  512
CONST MINRECVQUEUESIZE = 2048

OBJECT midiprefs
	nunits : CHAR
	pad0 : CHAR
	unitdef : midiunitdef
ENDOBJECT

#define MIDIPREFSNAME 'midi.prefs'
