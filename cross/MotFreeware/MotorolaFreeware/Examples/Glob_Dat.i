;************************************
;	Global_Dat.i
;
;	Global Variables & Data
;***********************************

GLOBAL_DAT EQU 1	;to prevent further inclusion

	OPT p50	;page breaks

;Memory Map

	CODE
	ORG $E000	;set CODE
	DATA
	ORG $F800	;set data
	BSS
	ORG 64		;set static variable RAM
	


;Global Definitions/Equates

BYTE EQU 1
WORD EQU 2
APTR EQU 2
EOS  EQU 0	;end of string

;Global Variables

Acc1:	RMB WORD
Acc2:	RMB WORD

	PAGE
;Global Structures

	DATA	;set PC to data area

;Device control register tables
;  each entry is struct Hware where:

;struct Hware definitiion
U_Limit EQU 0			;upper limit
L_Limit EQU U_Limit+BYTE	;lower limit
HErr_Msg EQU L_Limit+BYTE	;*high error message
LErr_Msg EQU HErr_Msg+APTR	;*low error message
Handler EQU LErr_Msg+APTR	;*handler
SizeOfHware EQU Handler+APTR

Reg_Table:	;struct Hware(s) declaration
	FCB $FF,10	;struct Hware Reg1
	FDB Vy_Low_Msg,High_Msg,Handler1

	FCB 100,0	;struct Hware Reg2
	FDB Low_Msg,High_Msg,Handler2

;	etc.

;Global Data

Low_Msg: FCC 'Too low!'
	FCB EOS
Vy_Low_Msg: FCC 'Way too low!'
	FCB EOS
High_Msg: FCC 'Way too high!'
	FCB EOS

	end
	
