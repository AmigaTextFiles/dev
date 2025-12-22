/* PE/EndianShared.e 27-04-2010
   Endian-swapping routines shared by all targets.
*/

OPT INLINE
MODULE 'target/PE/base'

PROC SwapEndianINT(in:INT) IS (in SHL 8 AND $FF00) OR (in SHR 8 AND $00FF) !!VALUE!!INT
/*PROC SwapEndianINT(in:INT)
	DEF out:INT
	DEF p1:INT, p2:INT
	p1 := in SHL 8 AND $FF00
	p2 := in SHR 8 AND $00FF
	out := p1 OR p2
ENDPROC out*/

PROC SwapEndianLONG(in:LONG) IS (in SHL 24 AND $FF000000) OR (in SHL  8 AND $00FF0000) OR (in SHR  8 AND $0000FF00) OR (in SHR 24 AND $000000FF) !!LONG
/*PROC SwapEndianLONG(in:LONG)
	DEF out:LONG
	DEF p1:LONG, p2:LONG, p3:LONG, p4:LONG
	p1 := in SHL 24 AND $FF000000
	p2 := in SHL  8 AND $00FF0000
	p3 := in SHR  8 AND $0000FF00
	p4 := in SHR 24 AND $000000FF
	out := p1 OR p2 OR p3 OR p4
ENDPROC out*/

PROC SwapEndianBIGVALUE(in:BIGVALUE)
	DEF out:BIGVALUE
	DEF bigValue:ARRAY OF BIGVALUE, buffer[2]:ARRAY OF LONG, temp:LONG
	
	bigValue := buffer !!ARRAY!!ARRAY OF BIGVALUE
	bigValue[0] := in
	
	temp      := SwapEndianLONG(buffer[0])
	buffer[0] := SwapEndianLONG(buffer[1])
	buffer[1] := temp
	
	out := bigValue[0]
ENDPROC out
