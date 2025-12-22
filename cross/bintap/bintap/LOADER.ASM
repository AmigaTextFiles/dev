;Blood's LOADING A HEADERLESS SCREEN$ routine
;Compile with TASM or other Z80 Cross Assembler
;Distributed with BINTAP - See BINTAP.TXT for more info
	.ORG 60000
START:	LD IX,16384
	LD DE,6912
	LD A,255
	SCF
	CALL 1366
	RET

	.end
