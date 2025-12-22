/*==========================================================================+
| filter_design.e                                                           |
| abstract filter design class                                              |
+--------------------------------------------------------------------------*/

OPT MODULE

MODULE '*complex'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT filterdesign
ENDOBJECT

PROC filterdesign() OF filterdesign IS EMPTY
PROC end()          OF filterdesign IS EMPTY

PROC compile() OF filterdesign IS EMPTY     -> returns a new filter object

-> analysis,  w : 0..PI
PROC cgain(w, z : PTR TO complex) OF filterdesign IS w BUT z BUT EMPTY
PROC gain(w)                      OF filterdesign IS w BUT 0.0
PROC phase(w)                     OF filterdesign IS w BUT 0.0

-> FIR/IIR
PROC m()  OF filterdesign IS 0
PROC n()  OF filterdesign IS 0
PROC a(i) OF filterdesign IS i BUT 0.0
PROC b(i) OF filterdesign IS i BUT 0.0

/*--------------------------------------------------------------------------+
| END: filter_design.e                                                      |
+==========================================================================*/
