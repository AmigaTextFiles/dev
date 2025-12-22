/*==========================================================================+
| outputbuffer.e                                                            |
| abstract output buffer class                                              |
+--------------------------------------------------------------------------*/

OPT MODULE

/*-------------------------------------------------------------------------*/

EXPORT OBJECT outputbuffer
ENDOBJECT

PROC outputbuffer() OF outputbuffer IS EMPTY
PROC end()          OF outputbuffer IS EMPTY
PROC write(float)   OF outputbuffer IS float BUT FALSE -> while o.write(x) ..

/*--------------------------------------------------------------------------+
| END: outputbuffer.e                                                       |
+==========================================================================*/
