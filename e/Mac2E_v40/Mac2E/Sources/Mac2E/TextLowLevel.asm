	XDEF skip_spaces_tabs_ii
	XDEF isident_ii


string_ptr		EQUR	A0
string_end		EQUR	A1
string_start	EQUR	D1
return_value	EQUR	D0


*********************************************
** Removes all the leading spaces and tabs **
*********************************************
skip_spaces_tabs_ii:	; ( string_ptr : PTR TO CHAR , string_end ) -> string_ptr

	MOVE.L	8(A7),string_ptr
	MOVE.L	4(A7),string_end

.while:
		CMP.L	string_ptr,string_end
		BEQ		.end_while
		MOVE.B	(string_ptr)+,D0
		CMP.B	#" ",D0					; string_ptr[] = " " ?
		BEQ		.while
		CMP.B	#9,D0					; string_ptr = "\t" ?
		BEQ		.while
		SUBQ.L	#1,A0
.end_while:

	MOVE.L	string_ptr,return_value
	RTS


***************************************************
** Reads if possible an ident in the macro file  **
** Returns a pointer to the ident and its length **
***************************************************
isident_ii:	; ( string_ptr : PTR TO CHAR , string_end ) -> string_ptr

	MOVE.L	8(A7),string_ptr
	MOVE.L	4(A7),string_end
	MOVE.L	string_ptr,string_start

.while:
		CMP.L	string_ptr,string_end
		BEQ		.end_while
		MOVE.B	(string_ptr)+,D0
		CMP.B	#"_",D0					; string_ptr[] = "_" ?
		BEQ		.while
		CMP.B	#"A",D0					; string_ptr[] E ["A".."Z"] ?
		BCS		.no_upper
		CMP.B	#"Z",D0
		BLS		.while
.no_upper:
		CMP.B	#"a",D0					;  string_ptr[] E ["a".."z"] ?
		BCS		.no_lower
		CMP.B	#"z",D0
		BLS		.while
.no_lower:
		CMP.B	#"0",D0					; string_ptr[] E ["0".."9"] ?
		BCS		.no_figure
		CMP.B	#"9",D0
		BLS		.while
.no_figure:
		SUBQ.L	#1,A0
.end_while:

	MOVE.L	string_ptr,return_value
	SUB.L	string_start,return_value
	RTS
