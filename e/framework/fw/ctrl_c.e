
-> ctrl_c is an abstraction of CTRL-C break.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE

MODULE 'dos/dos'
MODULE 'fw/wbObject'

CONST SIGBREAKB_CTRL_C=12

EXPORT OBJECT ctrl_c OF wbObject
ENDOBJECT

-> Exec signal associated with this WB object
PROC signal() OF ctrl_c IS SIGBREAKB_CTRL_C

