
OPT MODULE
OPT PREPROCESS
OPT EXPORT

	MODULE 'exec/libraries','exec/types'


OBJECT dbplayerbase
 libnode:lib
 seglist:LONG
 sysbase:PTR TO lib
 ahibase:PTR TO lib
 playing:LONG
 audiomodeid:LONG
 audiofrequency:LONG
 last7command:LONG
ENDOBJECT
