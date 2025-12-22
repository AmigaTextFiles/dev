


	XDEF	addICRVector_resource_iCRBit_interrupt

addICRVector_resource_iCRBit_interrupt:
	MOVEM.L	4(A7),D0/A1/A6
	EXG	D0,A1
	JMP	-6(A6)



	XDEF	remICRVector_resource_iCRBit_interrupt

remICRVector_resource_iCRBit_interrupt:
	MOVEM.L	4(A7),D0/A1/A6
	EXG	D0,A1
	JMP	-12(A6)



	XDEF	ableICR_resource_mask

ableICR_resource_mask:
	MOVEM.L	4(A7),D0/A6
	JMP	-18(A6)




	XDEF	setICR_resource_mask

setICR_resource_mask:
	MOVEM.L 4(A7),D0/A6
	JMP	-24(A6)


