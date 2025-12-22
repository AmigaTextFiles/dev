;***********************************
;	Subroutine Dummy Output
;
;	Send data where it belongs
;***********************************

	IFND GLOBAL_DAT
	include <Global_Dat.i>
	ENDIF

	CODE		;get code PC back

Output:	ldx Reg_Table	;get pointer to table
	psha		;save data
	ldaa #SizeOfHware ;find offset
	mul
	abx		;add offset to pointer
	pula		;recover data
	jmp Handler,x	;goto Handler

Handler1:
	;do handling
	rts

Handler2:
	;do handling of second sort
	rts

	AUTO	;goto auto area
	ORG 0	;same ORG cuz same area

Itch1:	RMB BYTE
Itch2:	RMB BYTE

	end
