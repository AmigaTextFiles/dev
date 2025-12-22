/*==========================================================================+
| processor.e                                                               |
| abstract effects processor class                                          |
+--------------------------------------------------------------------------*/

OPT MODULE

MODULE '*inputbuffer', '*outputbuffer'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT processor
PUBLIC
	input  : PTR TO inputbuffer
	output : PTR TO outputbuffer
ENDOBJECT

PROC processor(input : PTR TO inputbuffer,
               output : PTR TO outputbuffer) OF processor
	self.input  := input
	self.output := output
ENDPROC

PROC end() OF processor
	self.input  := NIL
	self.output := NIL
ENDPROC

PROC process() OF processor IS FALSE    -> WHILE fx.process() DO ...

/*--------------------------------------------------------------------------+
| END: processor.e                                                          |
+==========================================================================*/
