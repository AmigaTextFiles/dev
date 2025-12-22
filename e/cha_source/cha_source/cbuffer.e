/*==========================================================================+
| cbuffer.e                                                                 |
| circular buffer for storing past data                                     |
+--------------------------------------------------------------------------*/

OPT MODULE
OPT PREPROCESS

MODULE '*debug'

RAISE "MEM" IF New() = NIL

/*-------------------------------------------------------------------------*/

CONST CBUFFER_SPACE = 1

EXPORT OBJECT cbuffer
	length : LONG
PRIVATE
	rptr   : LONG
	wptr   : LONG
	data   : PTR TO LONG
ENDOBJECT

PROC cbuffer(length : LONG) OF cbuffer
->	debug(['cbuffer.cbuffer(\d)', length])
	self.length := length
	self.rptr := 0
	self.wptr := length -> - 1
	self.data := New(Mul(length + CBUFFER_SPACE, SIZEOF LONG))
ENDPROC

PROC end() OF cbuffer
->	debug(['cbuffer.end()'])
	Dispose(self.data)
ENDPROC

PROC read(offset=0) OF cbuffer  -> -length < offset <= 0
	DEF r
	r := self.rptr + offset
	IF r < 0 THEN r := r + self.length + CBUFFER_SPACE
->	debug(['cbuffer.read(\d), r=\d', offset, r])
ENDPROC self.data[r]

PROC write(x : LONG) OF cbuffer
->	debug(['cbuffer.write(\d)', x])
	self.data[self.wptr] := x
ENDPROC

PROC next() OF cbuffer
#ifdef DEBUG
	DEF i
#endif
->	debug(['cbuffer.next(), r=\d w=\d', self.rptr, self.wptr])
	self.rptr := self.rptr + 1
	self.wptr := self.wptr + 1
	IF self.rptr >= (self.length + CBUFFER_SPACE) THEN self.rptr := 0
	IF self.wptr >= (self.length + CBUFFER_SPACE) THEN self.wptr := 0
->	debug(['                r=\d w=\d', self.rptr, self.wptr])
#ifdef DEBUG
	WriteF('cbuffer: ')
	FOR i := 0 TO self.length - 1 DO WriteF('\s ', float2string(self.read(-i)))
	WriteF('...\n')
#endif
ENDPROC

/*--------------------------------------------------------------------------+
| END: cbuffer.e                                                            |
+==========================================================================*/
