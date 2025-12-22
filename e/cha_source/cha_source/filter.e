/*==========================================================================+
| filter.e                                                                  |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| FIR/IIR data storage                                                      |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*filter_design', '*debug'

RAISE "MEM" IF New() = NIL

#define FLOAT LONG

/*-------------------------------------------------------------------------*/

EXPORT OBJECT filter
PUBLIC
	m : LONG            -> out = sum(0..m)(a[i]*in [-i])
	n : LONG            ->     + sum(1..n)(b[i]*out[-i])
	a : PTR TO FLOAT    -> from a[0] to a[m]
	b : PTR TO FLOAT    -> from b[0] to b[n], b[0] is unused
ENDOBJECT

PROC filter(design : PTR TO filterdesign) OF filter
	DEF i
	self.m := design.m()
	self.n := design.n()
	self.a := New((self.m + 1 + self.n + 1) * SIZEOF FLOAT)
	self.b := self.a + (self.m + 1 * SIZEOF FLOAT)
	FOR i := 0 TO self.m DO self.a[i] := design.a(i)
	FOR i := 0 TO self.n DO self.b[i] := design.b(i)
#ifdef DEBUG
WriteF('+++ Debug +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
WriteF('+   Filter\n')
WriteF('+   m = \d\n', self.m)
FOR i := 0 TO self.m
WriteF('+       \s\n', float2string(self.a[i]))
ENDFOR
WriteF('+   n = \d\n', self.n)
FOR i := 0 TO self.n
WriteF('+       \s\n', float2string(self.b[i]))
ENDFOR
WriteF('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n')
#endif
ENDPROC

PROC end() OF filter
	Dispose(self.a)
ENDPROC

/*--------------------------------------------------------------------------+
| END: filter.e                                                             |
+==========================================================================*/
