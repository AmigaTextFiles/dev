/*==========================================================================+
| filter_cbuffer.e                                                          |
| circular buffer for storing past data, with modified read()               |
| read(-i) (i : 0 .. length) gives relative to current                      |
+--------------------------------------------------------------------------*/

OPT MODULE

RAISE "MEM" IF New() = NIL

/*-------------------------------------------------------------------------*/

CONST CBUFFER_SPACE = 1

EXPORT OBJECT filtercbuffer
PRIVATE
	length : LONG
	wptr   : LONG
	data   : PTR TO LONG
ENDOBJECT

PROC filtercbuffer(length : LONG) OF filtercbuffer
	self.length := length + 1
	self.wptr := 0
	self.data := New(Mul(length + 1 + CBUFFER_SPACE, SIZEOF LONG))
ENDPROC

PROC end() OF filtercbuffer
	Dispose(self.data)
ENDPROC

PROC read(offset = 0) OF filtercbuffer  -> -length < offset <= 0
	DEF r
	r := self.wptr + offset
	IF r < 0 THEN r := r + self.length + CBUFFER_SPACE
ENDPROC self.data[r]

PROC write(x : LONG) OF filtercbuffer
	self.data[self.wptr] := x
ENDPROC

PROC next() OF filtercbuffer
	self.wptr := self.wptr + 1
	IF self.wptr >= (self.length + CBUFFER_SPACE) THEN self.wptr := 0
ENDPROC

/*--------------------------------------------------------------------------+
| END: filter_cbuffer.e                                                     |
+==========================================================================*/
