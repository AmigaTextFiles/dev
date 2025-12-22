/*==========================================================================+
| fxfilter.e                                                                |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| FIR/IIR filter code                                                       |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*processor', '*inputbuffer', '*outputbuffer',
       '*filter_cbuffer', '*filter'

#define FLOAT LONG

/*-------------------------------------------------------------------------*/

EXPORT OBJECT fxfilter OF processor
PRIVATE
	filter : PTR TO filter
	in     : PTR TO filtercbuffer
	out    : PTR TO filtercbuffer
ENDOBJECT

PROC fxfilter(input  : PTR TO inputbuffer,
              output : PTR TO outputbuffer,
              filter : PTR TO filter)       OF fxfilter
	self.processor(input, output)
	self.filter := filter
	NEW self.in .filtercbuffer(filter.m)
	NEW self.out.filtercbuffer(filter.n)
ENDPROC

PROC end() OF fxfilter
	END self.in
	END self.out
ENDPROC SUPER self.end()

PROC process() OF fxfilter
	DEF x, i, a : PTR TO FLOAT, b : PTR TO FLOAT, m, n
	m := self.filter.m
	n := self.filter.n
	a := self.filter.a
	b := self.filter.b
	self.in.write(self.input.read())
	x := 0.0
	FOR i := 0 TO m DO x := ! x + (! a[i] * self.in .read(-i))
	FOR i := 1 TO n DO x := ! x + (! b[i] * self.out.read(-i))
	self.out.write(x)
	self.in.next()
	self.out.next()
ENDPROC self.output.write(x)

/*--------------------------------------------------------------------------+
| END: fxfilter.e                                                          |
+==========================================================================*/
