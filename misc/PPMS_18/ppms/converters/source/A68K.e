
/* A68K 2 PPMS converter see E.e for commented source */

MODULE  'tools/ctype'

CONST BUFF = 500,
			WB = 256,
			NB = 10,
			MB = 256,
			WORD = 1,
			NUM = 2,
			EOF = -1

DEF     word, line, msg, end, size, p

PROC main() HANDLE
DEF t, type = NIL

	NEW     word[ WB ], line[ NB ], msg[ MB ]

	WriteF( '' )

	p, size := readfile()
	end := p + size

-> WriteF( '\s', p ) would print all input

	AstrCopy( line, '0' )
	AstrCopy( msg, 'unknown no help available' )

	WHILE   ( t := getbit() ) <> EOF

	IF StrCmp( word, arg )
			eat ( "\n" )
			getline( word, WB )                                     
		type := "E"                             
    t := getbit()                                                                       

		IF t = NUM
			AstrCopy( line, word, NB )      
			WHILE   ( p < end ) AND ( p[] <> "^" ) DO p++
			p := p + 2
			IF p < end THEN getline( msg, MB )
		ENDIF
	ENDIF

	IF type
		outerr( type )
		type := NIL
	ENDIF

	ENDWHILE

EXCEPT
	SELECT exception
		CASE    "MEM"; WriteF( 'NO MEM!!!\n' )
	ENDSELECT
ENDPROC

PROC outerr( type )                                                             
	WriteF( '#\s# ', arg )
	WriteF( '\s ', line )                                           
	WriteF( '\c ', type )                                           
	WriteF( '\s\n', msg )
ENDPROC

PROC readfile()
DEF m, l = NIL, c

  NEW m[ BUFF + 2 ]
  m[ NIL ] := "\n"
  m[ BUFF - 2 ] := "\n"
  m[ BUFF - 1 ] := "\n"
  m++

	WHILE ( ( c := Inp( stdin ) ) <> -1 ) AND ( l < ( BUFF ) ) DO m[ l++ ] := c
ENDPROC m, l

PROC    getbit()
DEF     c, pos = NIL

	LOOP
		SELECT 128 OF c := p[]

			CASE "a" TO "z", "A" TO "Z"
			  WHILE isalpha( p[] ) OR ( p[] = "." ) AND ( pos < WB - 1 )
				word[ pos ] := p[]++
				pos++
			  ENDWHILE
				word[ pos ] := NIL
				RETURN WORD

			CASE "0" TO "9"
			  WHILE isdigit( p[] ) AND ( pos < WB - 1 )
				word[ pos ] := p[]++
				pos++
					ENDWHILE
				word[ pos ] := NIL
				RETURN NUM

			CASE    "\n", "\b"
				IF p >= end THEN RETURN EOF
			DEFAULT

		ENDSELECT
	p++
	ENDLOOP
ENDPROC

PROC    eat( what1 = "\t", what2 = " ", what3 = 9 )                                                     /* default white space  */
	WHILE ( p[] = what1 ) OR ( p[] = what2 ) OR ( p[] = what3 ) AND ( p < end ) DO p++
ENDPROC

PROC    getline( to, len )
	WHILE   ( p[] <> "\n" ) AND ( p[] <> "\b" ) AND ( p < end )
	to[] := p[]
	to++; p++
	len--
	ENDWHILE
	to[] := NIL
ENDPROC


