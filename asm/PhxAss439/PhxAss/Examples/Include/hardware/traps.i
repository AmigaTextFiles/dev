	IFND	TRAPS_I
TRAPS_I	SET	1
**
** $VER: traps.i 1.0 (4.6.97)
**
** definitions for the cpu trap vectors
**
** Written by Sunbeam/Shelter!
**

** this trap vectors are pointed in vbr (vectorbaseregister).
** on 68000 amigas at address 0.
** see in exec.library/Supervisor for more details.


tp_BusError		EQU	$08
tp_AddressError		EQU	$0C
tp_IllegalInstruction	EQU	$10
tp_DivisionByZero	EQU	$14
tp_CHK			EQU	$18
tp_TRAPV		EQU	$1C
tp_PrivilegeViolation	EQU	$20
tp_Trace		EQU	$24
tp_1010Emulator		EQU	$28
tp_1111Emulator		EQU	$2C
tp_CoProProtocol	EQU	$30
tp_FormatError		EQU	$34
tp_trapReserved1	EQU	$38
tp_UnInitInterrupt	EQU	$3C

** $4C-$5F for future use

tp_SpuriousInterrupt	EQU	$60
tp_AutoLevel1		EQU	$64
tp_AutoLevel2		EQU	$68
tp_AutoLevel3		EQU	$6C
tp_AutoLevel4		EQU	$70
tp_AutoLevel5		EQU	$74
tp_AutoLevel6		EQU	$78
tp_AutoLevel7		EQU	$7C

** trap instruction vectors

tp_Trap0		EQU	$80
tp_Trap1		EQU	$84
tp_Trap2		EQU	$88
tp_Trap3		EQU	$8C
tp_Trap4		EQU	$90
tp_Trap5		EQU	$94
tp_Trap6		EQU	$98
tp_Trap7		EQU	$9C
tp_Trap8		EQU	$A0
tp_Trap9		EQU	$A4
tp_Trap10		EQU	$A8
tp_Trap11		EQU	$AC
tp_Trap12		EQU	$B0
tp_Trap13		EQU	$B4
tp_Trap14		EQU	$B8
tp_Trap15		EQU	$BC

** for the trap #x instruction

CT_TRAP0		EQU	0
CT_TRAP1		EQU	1
CT_TRAP2		EQU	2
CT_TRAP3		EQU	3
CT_TRAP4		EQU	4
CT_TRAP5		EQU	5
CT_TRAP6		EQU	6
CT_TRAP7		EQU	7
CT_TRAP8		EQU	8
CT_TRAP9		EQU	9
CT_TRAP10		EQU	10
CT_TRAP11		EQU	11
CT_TRAP12		EQU	12
CT_TRAP13		EQU	13
CT_TRAP14		EQU	14
CT_TRAP15		EQU	15


	ENDC	;TRAPS_I