*********************************************************************************************************
*
* PSXAmiga.i
*
*********************************************************************************************************


* Following is the PSX-EXE Structure. Keep in mind that all the adresses are stored in little
* endian mode! (eg. $80 00 10 00 is stored as $00 10 00 80). You have to do the necessary
* conversion yourself (shouldn't be that hard ;).

   STRUCTURE PSX_EXE,0
	ULONG	ps_id0			; "PS-X"
	ULONG	ps_id1			; " EXE"
	ULONG	ps_text			; Offset of the text segment
	ULONG	ps_data			; Offset of the data segment
	ULONG	ps_PC0			; Program Counter register value (to load)
	ULONG	ps_GP0			; Global Pointer register value (to load)
	ULONG	ps_t_addr		; The address where the text segment is loaded
	ULONG	ps_t_size		; The size of the text segment
	ULONG	ps_d_addr		; The address where the data segment is loaded
	ULONG	ps_d_size		; The size of the data segment
	ULONG	ps_b_addr		; The address of the BSS segment
	ULONG	ps_b_size		; The size of the BSS segment
	ULONG	ps_s_addr		; The address of the stack
	ULONG	ps_s_size		; The size of the stack
	ULONG	ps_SP			; Stack Pointer (PSX will set this!)
	ULONG	ps_FP			; Frame Pointer (PSX will set this!)
	ULONG	ps_GP			; Global Pointer (PSX will set this!)
	ULONG	ps_RET			; Return Adress (PSX will set this!)
	ULONG	ps_base			; Base Adress (PSX will set this!)

	LABEL	ps_SIZEOF

* These are the R3000A's registers for use with the _LVOSetCPUReg() call 
* Don't mess around with delicate ones since you might simply crash the PSX

R3000A_ZERO	EQU	0		; DO NOT TOUCH THIS - THIS REGISTER MUST ALWAYS BE SET TO ZERO
R3000A_AT	EQU	1		; Assembler temporary register
R3000A_V0	EQU	2		; Return value
R3000A_V1	EQU	3		; Return value
R3000A_A0	EQU	4		; Argument register
R3000A_A1	EQU	5		; Argument register
R3000A_A2	EQU	6		; Argument register
R3000A_A3	EQU	7		; Argument register
R3000A_T0	EQU	8
R3000A_T1	EQU	9
R3000A_T2	EQU	10
R3000A_T3	EQU	11
R3000A_T4	EQU	12
R3000A_T5	EQU	13
R3000A_T6	EQU	14
R3000A_T7	EQU	15
R3000A_S0	EQU	16
R3000A_S1	EQU	17
R3000A_S2	EQU	18
R3000A_S3	EQU	19
R3000A_S4	EQU	20
R3000A_S5	EQU	21
R3000A_S6	EQU	22
R3000A_S7	EQU	23
R3000A_T8	EQU	24
R3000A_T9	EQU	25
R3000A_K0	EQU	26		; Kernel temporary
R3000A_K1	EQU	27
R3000A_GP	EQU	28		; Global pointer
R3000A_SP	EQU	29		; Stack pointer
R3000A_FP	EQU	30		; Frame pointer
R3000A_RA	EQU	31		; Return adress

R3000A_EPC	EQU	32		; Program counter
R3000A_MDHI	EQU	33
R3000A_MDLO	EQU	34
R3000A_SR	EQU	35
R3000A_CR	EQU	36		; Cause register

* And these are the supported development systems. Use these values to 
* check the pa_System value.
*
* Other values are reserved for future use only!

YAROZE          EQU     1
