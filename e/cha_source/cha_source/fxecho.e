/*==========================================================================+
| fxecho.e                                                                  |
| echo effect                                                               |
+--------------------------------------------------------------------------*/

OPT MODULE

MODULE '*inputbuffer', '*outputbuffer', '*cbuffer', '*processor'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT echo OF processor
PRIVATE
	out    : PTR TO cbuffer
	decay  : LONG
ENDOBJECT

PROC echo(input : PTR TO inputbuffer, output : PTR TO outputbuffer,
          length : LONG, decay : LONG) OF echo
	self.processor(input, output)
	NEW self.out.cbuffer(length)
	self.decay  := decay
ENDPROC

PROC end() OF echo
	END self.out
ENDPROC SUPER self.end()

PROC process() OF echo
	DEF out : LONG
	out := ! self.input.read() + (! self.decay * self.out.read())
	self.out.write(out)
	self.out.next()
ENDPROC self.output.write(out)

/*--------------------------------------------------------------------------+
| END: fxecho.e                                                             |
+==========================================================================*/
