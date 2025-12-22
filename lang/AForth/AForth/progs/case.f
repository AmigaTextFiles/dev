( A CASE control construct for AFORTH)
( This version handles standard FORTH integer values only,)
( ie bytes, chars, integers, NOT doubles or addresses it WILL break)
( using this code as your starting point it would be a fairly simple task)
( to construct a version which handles double precision, ie 32 bit, values)
( Copyright © Stratagem4, 1994)

: CASE	( n -> ) ( the construct header, n is the test value)
	COMPILE >R	( push test value on return stack)
	0 ; IMMEDIATE	( push nest depth on stack)

: OF	( n -> ) ( run-time code, n is the 'case' value)
	COMPILE R@		( get a copy of the test value)
	COMPILE =		( test equality)
	[COMPILE] IF ; IMMEDIATE	( do following code)

: (ENDOF)	( addr -> ) ( run-time ENDOF code)
	DR> D@ D>R ;	( adjust return address)

: ENDOF	( -> )	( OF terminator)
	COMPILE (ENDOF)	( compile run-time code)
	D>R				( temp store IF address)
	>R				( temp store depth counter)
	HERE			( fetch compilation address)
	4 ALLOT			( leave space for ENDCASE address)
	R> 1+			( fetch and increment depth counter)
	DR>				( retrieve IF address)
	[COMPILE] THEN 	( complete IF..THEN construct)
	; IMMEDIATE

: ENDCASE ( -> ) ( the construct terminator)
	0 DO				( start looping through cases)
		D>R	HERE DR> D!	( store HERE at address)
	LOOP				( loop?)
	COMPILE R> COMPILE DROP ; IMMEDIATE	( drop test value)

: TESTCASE ( -> ) ( just an example CASE)
	CR ." Please enter a number between 1 and 25 : " ( ask for a number)
	0 0 QUERY 1 WORD CONVERT DROPD DROP				( convert to reality)
	CR ." You selected item "						( snappy little message)
	CASE							( test each possible value)
		 1 OF ." one!"			ENDOF
		 2 OF ." two!"			ENDOF
		 3 OF ." three!"		ENDOF
		 4 OF ." four!"			ENDOF
		 5 OF ." five!"			ENDOF
		 6 OF ." six!"			ENDOF
		 7 OF ." seven!"		ENDOF
		 8 OF ." eight!"		ENDOF
		 9 OF ." nine!"			ENDOF
		10 OF ." ten!"			ENDOF
		11 OF ." eleven!"		ENDOF
		12 OF ." twelve!"		ENDOF
		13 OF ." thirteen!"		ENDOF
		14 OF ." fourteen!"		ENDOF
		15 OF ." fifteen!"		ENDOF
		16 OF ." sixteen!"		ENDOF
		17 OF ." seventeen!"	ENDOF
		18 OF ." eighteen!"		ENDOF
		19 OF ." nineteen!"		ENDOF
		20 OF ." twenty!"		ENDOF
		21 OF ." twentyone!"	ENDOF
		22 OF ." twentytwo!"	ENDOF
		23 OF ." twentythree!"	ENDOF
		24 OF ." twentyfour!"	ENDOF
		25 OF ." twentyfive!"	ENDOF
		." I am an !!!!!AIRHEAD!!!!"	( and don't forget the airheads!)
	ENDCASE ;
