;---;  RESET  ;--------------------------------------------------------------------
*
*	****	RESET ROUTINE    ****
*
*	Author		Daniel Weber
*	Version		1.13
*	Last Revision	14.02.93
*	Identifier	rtr_defined
*       Prefix		rtr_	(Reset Routine)
*				 ¯   ¯ ¯
*	Functions	ColdReboot()
*
;------------------------------------------------------------------------------
*
*                           Amiga Software Reboot
*
*                          By Daniel Weber in 1990
*
*        * Based on the offical reboot code published by Commodore *
*
*                    - The entire risk as to the use of this -
*                    -  information is assumed by the user   -
*
*     For more information read "The Official Way to Software Reboot an
*     Amiga" from the July/August 1989 issue of Amiga Mail, Exec,
*     page III-9.
*
*
*     The ColdReboot() function listed below should be used whenever an
*     application needs to reboot the Amiga.
*     This code represents the *best* available general purpose reset.
*
*
*     TECHNICAL DESCRIPTION:
*     The code below turns an installed MMU off, precalculates a jump
*     address, executes a RESET instruction, then relies on CPU
*     prefetch to execute the jump. The precalculated jump is
*     constructed to enter the system ROM at the location of a second
*     RESET instruction.
*
;------------------------------------------------------------------------------
*
*       NAME                                                                
*           ColdReboot
*
*       SYNOPSIS
*           ColdReboot()
*
*           void ColdReboot(void);
*
*       FUNCTION
*           Reboot the machine. Turn an installed MMU off, all external
*           memory and peripherals will be RESET, and the machine will
*           start its power up diagnostics.                                 
*
*       NOTE                                                                
*           Rebooting an Amiga in software is very tricky. Differing
*           memory configurations and processor cards require careful
*           treatment. This code represents the *best* available
*           general purpose reset.                                          
*
*           The MagicResetCode must be used exactly as specified here.
*           The code *must* be longword aligned. Failure to duplicate
*           the code *exactly* may result in improper operation under       
*           certain system configurations.
*
*       RESULT
*           This function never returns.                                    
*
;------------------------------------------------------------------------------

;------------------
	IFND	rtr_defined
rtr_defined	=1

;------------------
rtr_oldbase	equ __BASE
	base	rtr_base
rtr_base:


;
;--------------------------------------------------------------------
;
		opt sto			;only for the ProAsm assembler
		opt o+,ow-,q+

		mc68030			;use the MC68030 for the MMU coding
;
;--------------------------------------------------------------------
;


rtr_MAGIC_ROMEND	EQU $01000000	;End of Kickstart ROM
rtr_MAGIC_SIZEOFFSET    EQU -$14	;Offset from end of ROM to Kickstart size
rtr_V36_EXEC	   	EQU 36	        ;Exec with the ColdReboot() function
rtr_TEMP_ColdReboot     EQU -726	;Offset of the V36 ColdReboot function
;
;--------------------------------------------------------------------
;
ColdReboot:	bsr.s	rtr_CacheOff	
		bsr	rtr_killMMU
		move.l	4.w,a6
		cmp.w	#rtr_V36_EXEC,20(a6)
		blt.s	rtr_old_exec
		jmp	rtr_TEMP_ColdReboot(a6)     ;Let Exec do it...
;
;	NOTE: Control flow never returns to here
;
;--- manually reset the Amiga ---------------------------------------
;
rtr_old_exec:
		lea	rtr_GoAway(pc),a5	;address of code to execute
		jsr	-30(a6)			;trap to code at (a5)
;
;
;	NOTE: Control flow never returns to here
;
;--- MagicResetCode ---------------- PLEASE DO NOT CHANGE -----------
;
		CNOP 0,4			;IMPORTANT! Longword align!

rtr_GoAway:
	 	lea	rtr_MAGIC_ROMEND,a0 	    ;(end of ROM)
		sub.l	rtr_MAGIC_SIZEOFFSET(a0),a0 ;(end of ROM)-(ROM size)=PC
		move.l	4(a0),a0                    ;Get Initial Program Counter
		subq.l	#2,a0			    ;now points to second RESET
		RESET				    ;first RESET instruction
		jmp (a0)			    ;CPU prefetch executes this
;
;
;	NOTE: the RESET an JMP instruction must share a longword!!!
;
;
;--- turn caches off... 
;
;
rtr_CacheOff:	move.l	4.w,a6
		btst	#1,AttnFlags+1(a6)	;AFB_68020
		beq.s	4$			;at least a 68020 expected

		cmp.w	#rtr_V36_EXEC,20(a6)
		blt.s	3$
		moveq	#0,d0
		move.l	#CACRF_ClearI|CACRF_ClearD|CACRF_EnableI|CACRF_EnableD|CACRF_IBE|CACRF_DBE,d1
		jsr	_LVOCacheControl(a6)	;this function clears all caches
		rts

3$:		lea	5$(pc),a5
		jsr	_LVOSupervisor(a6)
4$:		rts


5$:		move.l	#CACRF_ClearI|CACRF_ClearD|CACRF_WriteAllocate,d0
		movec	d0,cacr
		rte

;
;--- kill an installed MMU --------- DO NOT CHANGE ANYTHING ! -------
;
;
rtr_killMMU:	move.l	4.w,a6
		sub.l	a1,a1			;look first for a MMU
		jsr	-294(a6)		;get ThisTask
		move.l	d0,a1
		move.l	50(a1),a2		;save old TaskException
		pea	rtr_taskexception(pc)
		move.l	(a7)+,50(a1)		;put own Exceptionhandler in
		moveq	#-1,d0			;set flag "MMU FOUND"
		subq.l	#4,a7
		nop
		pmove	tc,(a7)
		nop
		nop
		addq.l	#4,a7
		tst.l	d0
		bne.s	1$
		nop
		mc68040
		movec	tc,d1			;68040 instruction
		mc68030
		nop
		nop
		neg.l	d0			;-1 => +1 (mc68040)
1$:		move.l	a2,50(a1)		;restore old Exceptionhandler

rtr_killMMU_now:
		tst.l 	d0			;MMU found???
		beq.s	\no_MMU_around
		lea	rtr_kill_it(pc),a5
		jsr	-30(a6)			;trap on code at (a5)
\no_MMU_around:	rts

;--------------------------------------------------------------------
rtr_kill_it:					;kill MMU
		tst.w	d0
		bpl.s	1$
		clr.l	-(a7)
		pmove	(a7),tc			;turn 68030/68851 mmu off
		addq.l	#4,a7
		rte				;back to 'no_MMU_around'

		mc68040
1$:		movec	tc,d0			;turn 68040 mmu off
		bclr	#15,d0
		movec	d0,tc
		rte
		mc68030

;--------------------------------------------------------------------
rtr_taskexception:
		moveq	#0,d0			;'NO MMU FOUND'
		move.l	(a7)+,d1		;load trapnumber in d1
		cmp.w	#4,d1			;'illegal' (no movec)
		beq.s	1$
		cmp.w	#11,d1			;'line-f' (no pmove)
		beq.s	1$
		moveq	#-1,d0			;'MMU FOUND'
1$:		addq.l	#4,2(a7)	;adjust PC *after* pmove instruction
		rte

;--------------------------------------------------------------------

;------------------
	base	rtr_oldbase

;------------------
	opt	rcl			;only for the ProAsm assembler

;------------------
	ENDIF

;--------------------------------------------------------------------

		END

