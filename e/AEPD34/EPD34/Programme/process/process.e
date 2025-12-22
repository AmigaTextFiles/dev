->
->	process.e
->
->	Amiga-E module for starting new processes without problems
->
->	16-Jul-95
->
->	Piotr Obminski
->
->	1 TAB = 4 spaces	<----------------<<<
->


OPT	MODULE

OPT OSVERSION = 37


MODULE	'dos/dostags'


RAISE	"proc"	IF CreateNewProc()	= NIL


DEF	child_ptr	: PTR TO LONG

->
->
->
EXPORT PROC createNewProc( tag_list : PTR TO LONG )
	DEF	i, len

	len	:= ListLen( tag_list )

	FOR i := 0 TO len - 1 STEP 2
		IF tag_list[ i ] = NP_SEGLIST THEN JUMP done
	ENDFOR

	FOR i := 0 TO len - 1 STEP 2
		IF tag_list[ i ] = NP_ENTRY THEN JUMP fix_entry
	ENDFOR

	Raise( "tags" )

fix_entry:
	INC i

	child_ptr		:= tag_list[ i ]
	tag_list[ i ]	:= { child_starter }

done:
	LEA		store_A4(PC),	A0
	MOVE.L	A4,				(A0)
ENDPROC CreateNewProc( tag_list )

-> ------------------------------------------------------------

store_A4:  	LONG	0		-> place to store contents of A4 register

-> ------------------------------------------------------------

->
->	this launches our baby process after having restored A4
->
PROC child_starter()
	LEA			store_A4(PC), 	A4
	MOVE.L 		(A4), 			A4

	child_ptr()
ENDPROC

-> ------------------------------------------------------------

