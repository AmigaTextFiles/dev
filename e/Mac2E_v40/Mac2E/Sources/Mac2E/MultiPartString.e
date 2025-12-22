OPT MODULE


->*****
->** External modules
->*****
MODULE	'Exec/Lists' , 'Exec/Nodes'


->*****
->** Exception handling
->*****
RAISE	"MEM"	IF	String()	=	NIL	,
		"OUT"	IF	Write()		=	-1	,
		"OUT"	IF	Fwrite()	=	-1


->*****
->** Object definitions
->*****
OBJECT mps_part
	mln				:	mln
	type			:	LONG
	string_ptr		:	PTR TO CHAR
	string_length	:	LONG
ENDOBJECT

EXPORT	OBJECT multi_part_string
			PRIVATE
				mlh				:	mlh
			PUBLIC
				number_parts	:	INT
		ENDOBJECT


->*****
->** Constant definitions
->*****
EXPORT	CONST	MPS_TYPE_STRING	=	-1


/********************
** Creates the MPS **
********************/
PROC create() OF multi_part_string

->	self.mlh.tailpred := self.mlh
->	self.mlh.tail := 0
->	self.mlh.head := self.mlh + 4

	LEA		4(A0) , A0

	MOVE.L	A0 , 8(A0)
	ADDQ.L	#4 , A0
	CLR.L	(A0)
	MOVE.L	A0 , -(A0)

ENDPROC


/****************************************
** Returns the asked part from the MPS **
****************************************/
PROC get_part( part_number , string_ptr_ptr : PTR TO LONG , string_length_ptr : PTR TO LONG ) OF multi_part_string
					->	part_number must be in [0..(number_parts-1)]

->	DEF searched_part : PTR TO mps_part , i
->	searched_part := self.mlh.head
->	FOR i := 1 TO part_number DO searched_part := searched_part.mln.succ
->		IF searched_part.type = MPS_TYPE_STRING
->			^string_ptr_ptr := searched_part.string_ptr
->			^string_length_ptr := searched_part.string_length
->		ENDIF
->ENDPROC searched_part.type

	MOVE.L	4(A0) , A1
	MOVE.L	part_number , D0
	BEQ.B	gp_end_for
	SUBQ.W	#1 , D0
gp_for:
	MOVE.L	(A1) , A1
	DBRA.B	D0 , gp_for
gp_end_for:
	MOVE.L	8(A1) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.B	gp_end
	MOVE.L	string_ptr_ptr , A2
	MOVE.L	12(A1) , (A2)
	MOVE.L	string_length_ptr , A2
	MOVE.L	16(A1) , (A2)
gp_end:

ENDPROC D0


/*********************************************************
** Adds the given piece of string to the end of the MPS **
*********************************************************/
PROC add_string( string_ptr : PTR TO CHAR , string_length ) OF multi_part_string

->	DEF part_to_add : PTR TO mps_part
->	AddTail( self.mlh , ( NEW part_to_add ) BUT part_to_add.mln )
->	part_to_add.type := MPS_TYPE_STRING
->	part_to_add.string_ptr := string_ptr
->	part_to_add.string_length := string_length
->	self.number_parts := self.number_parts + 1

	DEF part_to_add : PTR TO mps_part

	NEW part_to_add

	MOVE.L	D7 , A0
	ADDQ.W	#1 , 16(A0)
	LEA		4(A0) , A0
	MOVE.L	part_to_add , A1
	MOVE.L	execbase , A6
	JSR		-246(A6)
	MOVE.L	part_to_add , A1
	MOVE.L	#MPS_TYPE_STRING , 8(A1)
	MOVE.L	string_ptr , 12(A1)
	MOVE.L	string_length , 16(A1)

ENDPROC


/*****************************************************
** Adds the given custom part to the end of the MPS **
*****************************************************/
PROC add_part( type ) OF multi_part_string

->	DEF part_to_add : PTR TO mps_part
->	AddTail( self.mlh , ( NEW part_to_add ) BUT part_to_add.mln )
->	part_to_add.type := type
->	self.number_parts := self.number_parts + 1

	DEF part_to_add : PTR TO mps_part

	NEW part_to_add

	MOVE.L	D7 , A0
	ADDQ.W	#1 , 16(A0)
	LEA		4(A0) , A0
	MOVE.L	part_to_add , A1
	MOVE.L	execbase , A6
	JSR		-246(A6)
	MOVE.L	part_to_add , A1
	MOVE.L	type , 8(A1)

ENDPROC


/*********************************************
** Adds at the end of the MPS the given MPS **
** The given MPS stays usable               **
*********************************************/
PROC add_mps( mps_to_add : PTR TO multi_part_string ) OF multi_part_string

->	DEF one_part : PTR TO mps_part , i
->	one_part := mps_to_add.mlh.head
->	FOR i := 1 TO mps_to_add.number_parts
->		IF one_part.type = MPS_TYPE_STRING
->			self.add_string( one_part.string_ptr , one_part.string_length )
->		ELSE
->			self.add_part( one_part.type )
->		ENDIF
->		one_part := one_part.mln.succ
->	ENDFOR

	DEF one_part , i

	MOVE.L	mps_to_add , A0
	MOVE.W	16(A0) , i
	BEQ.B	am_end_for
	SUBQ.W	#1 , i
	MOVE.L	4(A0) , one_part
	MOVE.L	one_part , A2
am_for:
	MOVE.L	8(A2) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.B	am_no_string
	MOVE.L	12(A2) , -(A7)
	MOVE.L	16(A2) , -(A7)
	MOVE.L	D7 , A0
	MOVE.L	(A0) , A1
	MOVE.L	28(A1) , A1
	JSR		(A1)
	LEA		8(A7) , A7
	BRA.B	am_endfor
am_no_string:
	MOVE.L	D0 , -(A7)
	MOVE.L	D7 , A0
	MOVE.L	(A0) , A1
	MOVE.L	24(A1) , A1
	JSR		(A1)
	LEA		4(A7) , A7
am_endfor:
	MOVE.L	one_part , A2
	MOVE.L	(A2) , A2
	MOVE.L	A2 , one_part
	DBRA.B	i , am_for
am_end_for:

ENDPROC


/**********************************************
** Joins at the end of the MPS the given MPS **
** The given MPS isn't anymore usable        **
**********************************************/
PROC join_mps( mps_to_join : PTR TO multi_part_string ) OF multi_part_string

->	DEF one_part : PTR TO mps_part , next_part : PTR TO mps_part , i
->	one_part := mps_to_join.mlh.head
->	FOR i := 1 TO mps_to_join.number_parts
->		next_part := one_part.mln.succ
->		AddTail( self.mlh , one_part.mln )
->		one_part := next_part
->	ENDFOR
->	self.number_parts := self.number_parts + mps_to_join.number_parts
->	END mps_to_join

	DEF i

	MOVE.L	mps_to_join , A3
	MOVE.W	16(A3) , D2
	BEQ.B	jm_end
	MOVE.W	D2 , i
	SUBQ.W	#1 , i
	MOVE.L	4(A3) , A1
	ADDQ.L	#4 , D7
	MOVE.L	execbase , A6
jm_for:
	MOVE.L	(A1) , A2
	MOVE.L	D7 , A0
	JSR		-246(A6)
	MOVE.L	A2 , A1
	DBRA	i , jm_for
jm_end_for:
	MOVE.L	D7 , A0
	ADD.W	D2 , 12(A0) 
jm_end:

ENDPROC


/**************************************
** Converts the MPS into an E-string **
**************************************/
PROC to_estring( type_array : PTR TO LONG ) OF multi_part_string

->	DEF one_part : PTR TO mps_part
->	DEF converted_string : PTR TO CHAR , converted_string_length = 0
->	DEF i

	DEF converted_string , converted_string_length : REG
	DEF i : REG , one_part : REG
	DEF arg1 : REG , arg2 : REG

->	one_part := self.mlh.head
->	FOR i := 1 TO self.number_parts
->		IF one_part.type = MPS_TYPE_STRING
->			converted_string_length := converted_string_length + one_part.string_length
->		ELSE
->			converted_string_length := converted_string_length + StrLen( type_array[ one_part.type ] )
->		ENDIF
->		one_part := one_part.mln.succ
->	ENDFOR

	CLR.L	converted_string_length
	MOVE.W	16(A0) , i
	BEQ.B	te_end_for1
	SUBQ.W	#1 , i
	MOVE.L	4(A0) , one_part
	MOVE.L	one_part , A1
te_for1:
	MOVE.L	8(A1) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.B	te_no_string1
	ADD.L	16(A1) , converted_string_length
	BRA.B	te_endfor1
te_no_string1:
	MOVE.L	type_array , A0
	LSL.L	#2 , D0
	MOVE.L	0(A0,D0.L) , arg1
	StrLen( arg1 )
	ADD.L	D0 , D7
te_endfor1:
	MOVE.L	one_part , A1
	MOVE.L	(A1) , A1
	MOVE.L	A1 , one_part
	DBRA.B	i , te_for1
te_end_for1:

->	converted_string := String( converted_string_length )

	converted_string := String( converted_string_length )

->	one_part := self.mlh.head
->	FOR i := 1 TO self.number_parts
->		IF one_part.type = MPS_TYPE_STRING
->			StrAdd( converted_string , one_part.string_ptr , one_part.string_length )
->		ELSE
->			StrAdd( converted_string , type_array[ one_part.type ] , ALL )
->		ENDIF
->		one_part := one_part.mln.succ
->	ENDFOR

	MOVE.L	-4(A5) , A0
	MOVE.W	16(A0) , i
	BEQ.B	te_end_for2
	SUBQ.W	#1 , i
	MOVE.L	4(A0) , one_part
	MOVE.L	one_part , A1
te_for2:
	MOVE.L	8(A1) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.B	te_no_string2
	MOVE.L	12(A1) , arg1
	MOVE.L	16(A1) , arg2
	StrAdd( converted_string , arg1 , arg2 )
	BRA.B	te_endfor2
te_no_string2:
	MOVE.L	type_array , A0
	LSL.L	#2 , D0
	MOVE.L	0(A0,D0.L) , arg1
	StrAdd( converted_string , arg1 , ALL )
	ADD.L	D0 , D7
te_endfor2:
	MOVE.L	one_part , A1
	MOVE.L	(A1) , A1
	MOVE.L	A1 , one_part
	DBRA.B	i , te_for2
te_end_for2:

ENDPROC converted_string


/****************************
** Saves the MPS in a file **
****************************/
PROC save( file , join ) OF multi_part_string

->	DEF one_part : PTR TO mps_part
->	DEF string_before = FALSE , number_parts = 0
->	DEF i

	DEF string_before : REG , i : REG , aux1 : REG , aux2 : REG , aux3 : REG

->	IF join
->		one_part := self.mlh.head
->		FOR i := 1 TO self.number_parts
->			IF one_part.type = MPS_TYPE_STRING
->				IF string_before = FALSE
->					INC number_parts
->					string_before := TRUE
->				ENDIF
->			ELSE
->				INC number_parts
->				string_before := FALSE
->			ENDIF
->			one_part := one_part.mln.succ
->		ENDFOR
->	ELSE
->		number_parts := self.number_parts
->	ENDIF

	MOVE.W	16(A0) , aux1
	TST.L	join
	BEQ.B	sm_false_join1
	CLR.W	aux2
	MOVE.W	aux1 , i
	BEQ.B	sm_endif1
	SUBQ.W	#1 , i
	MOVE.L	4(A0) , aux3
	MOVE.L	aux3 , A1
	CLR.B	string_before
sm_for1:
	MOVE.L	8(A1) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.B	sm_no_string1
	TST.B	string_before
	BNE.B	sm_endif2
	ADDQ.W	#1 , aux2
	MOVEQ.B	#-1 , string_before
	BRA.B	sm_endif2
sm_no_string1:
	ADDQ.W	#1 , aux2
	CLR.B	string_before
sm_endif2:
	MOVE.L	(A1) , A1
	DBRA.B	i , sm_for1
sm_end_for1:
	BRA.B	sm_endif1
sm_false_join1:
	MOVE.W	aux1 , aux2
sm_endif1:

->	FputC( file , number_parts / 256 )
->	FputC( file , number_parts - ( number_parts / 256 ) )

	MOVE.L	dosbase , A6
	MOVE.L	file , A3
	MOVE.L	A3 , D1
	MOVE.W	aux2 , D2
	LSR.W	#8 , D2
	JSR		-312(A6)
	MOVE.L	A3 , D1
	MOVE.L	aux2 , D2
	JSR		-312(A6)

->	string_before := FALSE
->	one_part := self.mlh.head
->	FOR i := 1 TO self.number_parts
->		IF one_part.type = MPS_TYPE_STRING
->			IF ( join = FALSE ) OR ( string_before = FALSE ) THEN FputC( file , MPS_TYPE_STRING )
->			Fwrite( file , one_part.string_ptr , one_part.string_length , 1 )
->			IF join = FALSE THEN FputC( file , 0 )
->			string_before := TRUE
->		ELSE
->			IF join AND string_before THEN FputC( file , 0 )
->			FputC( file , one_part.type )
->			string_before := FALSE
->		ENDIF
->		one_part := one_part.mln.succ
->	ENDFOR
->	IF join AND string_before THEN FputC( file , 0 )

	CLR.B	string_before
	MOVE.W	aux1 , i
	BEQ.W	sm_end_for2
	SUBQ.W	#1 , i
	MOVE.L	aux3 , A2
	MOVE.L	join , aux3
sm_for2:
	MOVE.L	8(A2) , D0
	CMP.L	#MPS_TYPE_STRING , D0
	BNE.W	sm_no_string2
	TST.L	aux3
	BEQ.B	sm_string_before
	TST.B	string_before
	BNE.B	sm_no_string_before
sm_string_before:
	MOVE.L	A3 , D1
	MOVE.B	#$FF , D2
	JSR		-312(A6)
sm_no_string_before:
	MOVE.L	12(A2) , aux1
	MOVE.L	16(A2) , aux2
	Fwrite( file , aux1 , aux2 , 1 )
	TST.L	aux3
	BNE.B	sm_false_join2
	MOVE.L	A3 , D1
	MOVEQ.B	#0 , D2
	JSR		-312(A6)
sm_false_join2:
	MOVE.B	#$FF , string_before
	BRA.B	sm_endif3
sm_no_string2:
	TST.L	aux3
	BEQ.B	sm_endif4
	TST.B	string_before
	BEQ.B	sm_endif4
	MOVE.L	A3 , D1
	MOVEQ.B	#0 , D2
	JSR		-312(A6)
sm_endif4:
	MOVE.L	A3 , D1
	MOVE.B	11(A2) , D2
	JSR		-312(A6)
	MOVEQ.B	#0 , string_before
sm_endif3:
	MOVE.L	(A2) , A2
	DBRA.W	i , sm_for2
sm_end_for2:
	TST.L	aux3
	BEQ.B	sm_end
	TST.B	string_before
	BEQ.B	sm_end
	MOVE.L	A3 , D1
	MOVEQ.B	#0 , D2
	JSR		-312(A6)
sm_end:

ENDPROC


/******************************************
** Writes an "ONLY string" MPS to a file **
******************************************/
PROC write( file ) OF multi_part_string

->	DEF one_part : PTR TO mps_part , i
->	DEF mps_length = 0 , write_adr , write_ptr : PTR TO CHAR

	DEF n : REG , i : REG
	DEF mps_length : REG , self_mlh_head : REG , write_adr : REG

->	one_part := self.mlh.head
->	FOR i := 1 TO self.number_parts
->		mps_length := mps_length + one_part.string_length
->		one_part := one_part.mln.succ
->	ENDFOR

	CLR.L	mps_length
	MOVE.W	16(A0) , n
	BEQ.W	w_end
	SUBQ.W	#1 , n
	MOVE.W	n , i
	MOVE.L	4(A0) , self_mlh_head
	MOVE.L	self_mlh_head , A2
w_for1:
	ADD.L	16(A2) , mps_length
	MOVE.L	(A2) , A2
	DBRA.B	i , w_for1
w_end_for1:

->	write_ptr := ( write_adr := NewR( mps_length ) )

	NewR( mps_length )
	MOVE.L	D0 , A3
	MOVE.L	D0 , write_adr

->	one_part := self.mlh.head
->	FOR i := 1 TO self.number_parts
->		CopyMem( one_part.string_ptr , write_ptr , one_part.string_length )
->		write_ptr := write_ptr + one_part.string_length
->		one_part := one_part.mln.succ
->	ENDFOR

	MOVE.L	execbase , A6
	MOVE.W	n , i
	MOVE.L	self_mlh_head , A2
w_for2:
	MOVE.L	12(A2) , A0
	MOVE.L	A3 , A1
	MOVE.L	16(A2) , D0
	JSR		-624(A6)
	ADD.L	16(A2) , A3
	MOVE.L	(A2) , A2
	DBRA.B	i , w_for2
w_end_for2:

->	Write( file , write_adr , mps_length )

	Write( file , write_adr , mps_length )

w_end:

ENDPROC

/********************************
** Reads a MPS from the memory **
********************************/
EXPORT PROC read_mps( mps_ptr : PTR TO CHAR , mps_to_read : PTR TO multi_part_string )

->	DEF number_parts , offset , i
->	number_parts := mps_ptr[]++ * 256 + mps_ptr[]
->	FOR i := 1 TO number_parts
->		IF mps_ptr[] = $FF
->			INC mps_ptr
->			mps_to_read.add_string( mps_ptr , offset := StrLen( mps_ptr ) )
->			mps_ptr := mps_ptr + offset + 1
->		ELSE
->			mps_to_read.add_part( mps_ptr[]++ )
->		ENDIF
->	ENDFOR
->ENDPROC mps_ptr

	DEF ptr , i , mps , offset

	MOVE.L	mps_ptr , ptr
	MOVE.L	ptr , A2
	MOVE.B	(A2)+ , i
	LSL.W	#8 , i
	MOVE.B	(A2)+ , i
	BEQ.B	rm_end_for
	SUBQ.W	#1 , i
	MOVE.L	mps_to_read , mps
rm_for:
	MOVE.B	(A2)+ , D1
	MOVE.L	A2 , ptr
	CMP.B	#$FF , D1
	BNE.B	rm_no_string
	offset := StrLen( ptr )
	MOVE.L	ptr , -(A7)
	MOVE.L	offset , -(A7)
	MOVE.L	mps , A0
	MOVE.L	(A0) , A1
	MOVE.L	28(A1) , A1
	JSR		(A1)
	LEA		8(A7),A7
	ADD.L	offset , ptr
	ADDQ.L	#1 , ptr
	BRA.B	rm_endfor
rm_no_string:
	CLR.L	-(A7)
	MOVE.B	D1 , 3(A7)
	MOVE.L	mps , A0
	MOVE.L	(A0) , A1
	MOVE.L	24(A1) , A1
	JSR		(A1)
	LEA		4(A7),A7
rm_endfor:
	MOVE.L	ptr , A2
	DBRA.B	i , rm_for
rm_end_for:
	MOVE.L	ptr , D0

ENDPROC D0
