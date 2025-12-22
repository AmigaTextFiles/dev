AllocFastByWapp	MACRO	; Allocate fast ram from wildapp \1:wildapp pointer,\2:[WILD] type WILD if you alreary have WILDBASE in a6,D0:Memsize SKR:d1/a0-a1
		IFNC	'WILD','\2'
		movea.l	wap_WildBase(\1),a6
		ENDC
		movea.l	wap_FastPool(\1),a0
		Call	AllocVecPooled
		ENDM

AllocChipByWapp	MACRO	; Allocate chip ram from wildapp \1:wildapp pointer,\2:[WILD] type WILD if you alreary have WILDBASE in a6,D0:Memsize SKR:d1/a0-a1
		IFNC	'WILD','\2'
		movea.l	wap_WildBase(\1),a6
		ENDC
		movea.l	wap_ChipPool(\1),a0
		Call	AllocVecPooled
		ENDM		
