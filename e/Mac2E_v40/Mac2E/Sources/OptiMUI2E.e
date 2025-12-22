OPT OSVERSION=37


->*****
->** Exception handling
->*****
RAISE	"MEM"	IF	New()		=	NIL	,
		"ARGS"	IF	ReadArgs()	=	NIL	,
		"OPEN"	IF	Open()		=	NIL	,
		"IN"	IF	Read()		=	-1	,
		"OUT"	IF	Read()		=	-1


/*******************
** Main procedure **
*******************/
PROC main() HANDLE

	DEF rdargs , args : PTR TO LONG
	DEF file = NIL , file_adr , file_length , file_end
	DEF version

	PrintF( '            \c1;33;40\cOptiMUI2E\c0;31;40\c v1.2\n' , $9B , $6D , $9B , $6D )
	PutStr( 'Copyright © 1993, 1994, Lionel Vintenat\n' )
	PrintF( '\c1;32;40\c---------------------------------------\c0;31;40\c\n' , $9B , $6D , $9B , $6D )
	version := '$VER: OptiMUI2E 1.2 (12.08.94)'

	args := [ NIL , NIL ]
	rdargs := ( rdargs := NIL ) BUT ReadArgs( 'FROM/A,TO/A' , args , NIL )

	file := Open( args[ 0 ] , OLDFILE )
	file_length := FileLength( args[ 0 ] )
	file_adr := NewR( file_length )
	file_end := file_adr + file_length
	Read( file , file_adr , file_length )
	Close( file )

	file := Open( args[ 1 ] , NEWFILE )

	process( file , file_adr , file_end )

	Close( file )
	FreeArgs( rdargs )

EXCEPT

	SELECT exception

		CASE "ARGS"

			PrintFault(IoErr(),NIL)

		CASE "MEM"

			PutStr('Out of memory !\n')

		CASE "OPEN"

			PrintFault(IoErr(),NIL)

		CASE "IN"

			PrintFault(IoErr(),NIL)

		CASE "OUT"

			PrintFault(IoErr(),NIL)

	ENDSELECT

	IF rdargs THEN	FreeArgs(rdargs)
	IF file THEN Close( file )

	CleanUp(100)

ENDPROC


/*********************************************************************
** Performs the "', [TAG_IGNORE, 0" string replacements in the file **
*********************************************************************/
PROC process( file , file_adr , file_end )

	DEF part_end , part_start

	part_start := file_adr

	MOVE.L	file_adr , A0
	MOVE.L	file_end , A1
	while0:
		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
	while1:
		CMP.B	#"'" , D0 			-> string_ptr[] = "'" ?
		BNE.B	while0

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"," , D0 			-> string_ptr[] = "," ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#" " , D0 			-> string_ptr[] = " " ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"[" , D0 			-> string_ptr[] = "[" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"T" , D0 			-> string_ptr[] = "T" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"A" , D0 			-> string_ptr[] = "A" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"G" , D0 			-> string_ptr[] = "G" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"_" , D0 			-> string_ptr[] = "_" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"I" , D0 			-> string_ptr[] = "I" ?
		BNE.B	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"G" , D0 			-> string_ptr[] = "G" ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"N" , D0 			-> string_ptr[] = "N" ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"O" , D0 			-> string_ptr[] = "O" ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"R" , D0 			-> string_ptr[] = "R" ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"E" , D0 			-> string_ptr[] = "E" ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"," , D0 			-> string_ptr[] = "," ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#" " , D0 			-> string_ptr[] = " " ?
		BNE.W	while1

		CMPA.L	A1 , A0				-> string_ptr = file_end ?
		BEQ.W	fin_while1
		MOVE.B	(A0)+ , D0
		CMP.B	#"0" , D0 			-> string_ptr[] = "0" ?
		BNE.W	while1

		MOVE.L	A0 , part_end
		Write( file , part_start , part_end - part_start -13 )
		MOVE.L	part_end , A0
		MOVE.L	file_end , A1

		while2:
			CMPA.L	A1 , A0
			BEQ.B	fin_while1
			MOVE.B	(A0)+ , D0
			CMP.B	#"," , D0
			BEQ.B	while2
			CMP.B	#" " , D0
			BEQ.B	while2
			CMP.B	#9 , D0
			BEQ.B	while2
			CMP.B	#10 , D0
			BEQ.B	while2
			fin_while2:
		SUBQ.L	#1 , A0
		MOVE.L	A0 , part_start
		BRA.W	while1
	fin_while1:
	MOVE.L	A0 , part_end
	Write( file , part_start , part_end - part_start )

ENDPROC
