OPT MODULE

MODULE 'exec/io'

EXPORT SET JMBREAKF_STOP, JMBREAKF_ABORT

EXPORT OBJECT jobmsg
   io:io
   priority:LONG
   jobfunc:LONG
   break:LONG                      /* JMBREAKF_STOP or JMBREAKF_ABORT or NIL */
   rsrvd[7]:ARRAY OF LONG
ENDOBJECT
