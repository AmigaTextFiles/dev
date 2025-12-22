

	XDEF upperChar_i
	XDEF lowerChar_i


upperChar_i:

	MOVEQ   #0,D0
	MOVE.B  7(A7),D0
	CMPI.B  #"a",D0
	BCS.S   exitupper
	CMPI.B  #"z",D0
	BHI.S   exitupper
	SUBI.B  #32,D0
exitupper:
	RTS


lowerChar_i:
	MOVEQ   #0,D0
	MOVE.B  7(A7),D0
	CMPI.B  #"A",D0
	BCS.S   exitlower
	CMPI.B  #"Z",D0
	BHI.S   exitlower
	ADDI.B  #32,D0
exitlower:
	RTS


	