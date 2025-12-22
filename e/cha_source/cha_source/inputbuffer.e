/*==========================================================================+
| inputbuffer.e                                                             |
| abstract input buffer class                                               |
+--------------------------------------------------------------------------*/

OPT MODULE

/*-------------------------------------------------------------------------*/

EXPORT OBJECT inputbuffer
ENDOBJECT

PROC inputbuffer() OF inputbuffer IS EMPTY
PROC end()         OF inputbuffer IS EMPTY
PROC read()        OF inputbuffer IS 0.0

/*--------------------------------------------------------------------------+
| END: inputbuffer.e                                                        |
+==========================================================================*/
