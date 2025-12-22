/*==========================================================================+
| test_cbuffer.e                                                            |
| test circular buffer                                                      |
| test passed                                                               |
+--------------------------------------------------------------------------*/

MODULE '*cbuffer'

/*-------------------------------------------------------------------------*/

CONST CBCOUNT=4

PROC main() HANDLE
/*
	DEF cb[CBCOUNT] : ARRAY OF LONG, cbuffer : PTR TO cbuffer, i, t
	-> initialise
	FOR i := 0 TO CBCOUNT-1 DO cb[i] := 0
	FOR i := 0 TO CBCOUNT-1
		cbuffer := NIL
		NEW cbuffer.cbuffer(2*i)
		cb[i] := cbuffer
	ENDFOR
	-> check stuff
	FOR t := 1 TO 20
		WriteF('\d[2]: ', t)
		FOR i := 0 TO CBCOUNT-1
			cbuffer := cb[i]
			cbuffer.write(t)
			WriteF('\d[2] ', cbuffer.read(IF t > 10 THEN -i ELSE 0))
		ENDFOR
		WriteF('\n')
		FOR i := 0 TO CBCOUNT-1
			cbuffer := cb[i]
			cbuffer.next()
		ENDFOR
	ENDFOR
*/
	DEF i, j, cb = NIL : PTR TO cbuffer, length = 20
	NEW cb.cbuffer(length)
	FOR i := 0 TO length
		WriteF('\n\d[2]: ', i)
		cb.write(i+1)
		FOR j := 0 TO i DO WriteF('\d[2] ', cb.read(j-length))
		cb.next()
	ENDFOR

EXCEPT DO
	END cb
/*
	-> cleanup
	FOR i := 0 TO CBCOUNT-1
		cbuffer := cb[i]
		END cbuffer
		cb[i] := NIL
	ENDFOR
*/
	WriteF('all ok\n')
	-> report errors
ENDPROC IF exception THEN 5 ELSE 0

/*--------------------------------------------------------------------------+
| END: test_cbuffer.e                                                       |
+==========================================================================*/
