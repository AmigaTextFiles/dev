* $VER$
*
* $Revision$
* $State$
* $Author$
* $Locker$
* $Date$
*
* $Log:$
*

;fs "Déclarations"
;fs "Includes"
	IncDir    "Include:"
	Include   "exec/exec_lib.i"
	Include   "exec/memory.i"
	Include   "intuition/intuition_lib.i"
	Include   "intuition/screens.i"
	Include   "datatypes/datatypes_lib.i"
	Include   "datatypes/datatypes.i"
;fe
;fs "Variables"
	rsreset
near_data rs.b      0
old_stack rs.l      1
MemPool   rs.l      1
NearDataSize
	rs.b      0
;fe
;fs "Constants"
exec_base = 4
;fe
;fs "Macros"
version   macro
	Dc.b      "0.0"
	endm

date      macro
	Dc.b      "(8.6.98)"
	endm

Call      macro
	IFEQ      NARG-2
	IFEQ      \2_base-4
	Move.l    (exec_base).w,a6
	else
	Move.l    \2_base(a4),a6
	ENDC
	ENDC
	Jsr       _LVO\1(a6)
	endm

Return    macro
	Move.l    \1,d0
	Rts
	endm
;fe
;fe

;fs "Code"
start     Bra       .AfterVer
	Dc.b      "Kaliosis Quantrum Ground Mapper "
	version
	Dc.b      " "
	date
	Dc.b      " ©1998, CdBS Software",0
.AfterVer Move.l    (exec_base).w,a6
	Move.l    #MEMF_CLEAR,d0
	Move.l    #512,d1   ; puddle size
	Move.l    #512,d2   ; Treshold
	Call      CreatePool
	Move.l    a0,d7
	Tst.l     d7
	Beq       CloseAll
	Move.l    #NearDataSize,d0
	bsr       AllocVecPooled
	Move.l    d0,a4
	Move.l    d7,MemPool(a4)
	Move.l    a7,old_stack(a4)


	Beq       CloseAll
	Bra       CloseAll
CloseAll
* Free all allocated ressources
	Rts
AllocVecPooled
* Function to do AllocVecPooled(Pool,memSize)
	Addq.l    #4,d0     ; Get space for tracking
	Move.l    d0,-(sp)  ; Save the size
	Call      AllocPooled         ; Call pool...
	Move.l    (sp)+,d1  ; Get size back
	Tst.l     d0        ; Check for error
	Beq.s     avp_fail  ; If NULL, failed!
	Move.l    d0,a0     ; Get pointer...
	Move.l    d1,(a0)+  ; Store size
	Move.l    a0,d0     ; Get result
avp_fail  Rts

FreeVecPooled
* Function to do FreeVecPooled(pool,memory)
	Move.l    -(a1),d0  ; Get size / ajust pointer
	jmp       _LVOFreePooled(a6)
;fe
;fs "constants"
;fe
