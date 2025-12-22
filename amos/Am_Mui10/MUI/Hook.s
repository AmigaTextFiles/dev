*****************************************************************************
*    AMOS-MUI Hook stub code  for assembler hooks & AMOS Procedure hooks    *
*                                                                           *
* This file is assemled to bank 14, and contains the code for hook which    *
* call AMOS Procedures, and the initialisation & Finalisation code for      *
* hooks which are implemented as assembler procedures.                      *
*****************************************************************************

* NOTE: Set tab size to 16 to read properly.

* When your assember hook code is called:
*
* - Registers D2-D7/A2-A6 have been saved, and will be restored.
*
* - Registers A0/A1/D1 may be trashed safely
*
* - Register D0 is used to return values to MUI. Remember TRUE is 1, not -1
*
* - Register A0 contains a pointer to the start of your hook code.
*
* - Registers A1 & A2 are as defined in the MUI tag autodoc which calls
*   your hook function. (Varies depending on why hook is called)
*
* - Register A3 contains a pointer to the global data area for all hooks.
*   Currently:
*
*   -4(A3) = Intuition Base   (Also in A6)
*   -8(A3) = AMOS Data Zone Address   (Also in A5)
*     (A3) = MUI Master Library Base
*    4(A3) = Used by AMOS Procedure hooks - leave alone
*    8(A3) = Used by AMOS Procedure hooks - leave alone
*
*   Other offsets may be defined in the future.
*
*
*    
* - Register A4 contains a pointer to the data area you passed to the
*   _MUI_ASM_HOOK[ADR,D] procedure in the D parameter.
*
* - Register A5 contains the usual pointer to the AMOS Data zone.
*
* - Register A6 is preloaded with the base of the intuition library, for
*   easy calling of GetAttr/SetAttrsA. There is no point in opening/closing
*   intuition from the hook, as both AMOS & MUI always have it open anyway.
*   DosBase,GfxBase,DiskFontBase,LayersBase can all be obtained from A5
*   etc. Move.l DosBase(a5),a6, if you include the |AMOSPro_Includes.s from
*   the extensions directory of AMOSPro_Tutorial.
*
* - Obviously the stack pointer (a7) must be left as it was found when your
*   hook function quits.


* Since you code is loaded into AMOS, this means you cannot call domethod
* in amiga.lib since it would be in a second hunk. The following code
* is equivilent to domethod without error check (And is much faster :-)
*
* Initially, the object pointer must be in A2, and the taglist pointer in
* A1. It is important the A0,A1,A2,A3 all have these values.

;	move.l	-4(a2),a0
;	move.l	8(a0),a3
;	jsr	(a3)

* Believe it or not, that's it (This was adapted from a bit of E code by
* Wouter van Oortmerssen).

* For those with out of data includes, include these 4 lines for inuition
* library calls to objects using taglists.
*
; _LVOSetAttrsA EQU -648   ;(A0 = Object, A1 = Taglist)
; _LVOGetAttr   EQU -654   ;(D0 = Attribute Tag Value, A0 = Object,
;                          ; A1 = Address To Store Result)
;  TAG_DONE     EQU 0      ;To mark the end of some taglists (But not those
;	           ;in SetAttrsA, or DoMethod.




***************************************************************************** 
* Source for Bank 14
*

	Incdir	cde:prog/devpac/include/include/
	
	Include	libraries/mui.i
	Include	exec/exec_lib.i



* Structure of hook data area for hooks which are AMOS procedures.
* AMHD_User is a pointer to the users data area for the hook.



AMHD_Next	equ	0
AMHD_ID	equ	4
AMHD_A1	equ	8
AMHD_A2	equ	12
AMHD_D0	equ	16
AMHD_Task	equ	20
AMHD_Signal	equ	24
AMHD_User	equ	28
    


******************************
* 4-Byte Jump Table

	bra	hook_prepcode	;Called By Assembler hooks to initialise
	bra	hook_callamos	;Called By AMOS hooks to wait
	bra	hook_getfirst   ;Called By AMOS hook processor to get first hook to execute
	bra	hook_getnext	;Called By AMOS hook processor when it has finished excuting a hook
			;to release the task that called the hook, and get the next to execute
******************************
* Global Hook Datazone	

* The first three entires are initialised by the _MUI_INIT procedure

hook_prepdata	dc.l	0	;AMOS A5 goes here
	dc.l	0	;Intuiton Base goes here
	dc.l	0	;MUI Base goes here	



hook_AMOSGlob	dc.l	0	;1st Waiting Hook Chain
	dc.l	0	;Last Waiting Hook


******************************
* Initialisation and
* Finalisation Code for
* assembler hooks.

hook_prepcode
	movem.l	d2-d7/a2-a6,-(sp)     ;Store registers
	move.l	16(a0),a4             ;Get hook data area
	lea	hook_prepdata(pc),a3  ;Get global data area
	movem.l	(a3)+,a5/a6           ;Setup A5/A6 values
	move.l	12(a0),a0             ;Get hook code address
	jsr	(a0)                  ;Execute hook code
	movem.l	(sp)+,d2-d7/a2-a6     ;Restore registers
	rts		      ;Back to MUI



******************************
* Hook routine for all AMOS
* procedure hooks
*

* NOTE: This must be re-enterant code

hook_callamos
	movem.l	d2-d7/a2-a6,-(sp)
	lea	hook_AMOSGlob(pc),a3
	move.l	16(a0),a4	;Get hook data
	move.l	a1,AMHD_A1(a4)  ;Store registers
	move.l	a2,AMHD_A2(a4)
	move.l	#0,AMHD_Next(a4) ; Becomes last in list

	;Now try to allocate any signal bit


	moveQ	#-1,d0
	movem.l	a3-4,-(sp)
	CALLEXEC	AllocSignal
	movem.l	(sp)+,a3-4
	move.l	d0,AMHD_Signal(a4) ; Store signal bit no.
	bne.s	.gotsignal

	;If no signal bit could be allocated, make hook return
	;immediately with false in D0. This will usually signal
	;MUI to cancel whatever it was doing...
	
	moveQ	#0,d0
	rts
	
.gotsignal	;Now we have a signal bit, store the task calling the
	;hook in the hook data_structure...


	movem.l	a3-4,-(sp)
	move.l	#0,a1	;Task to find is itself
	CALLEXEC	FindTask
	movem.l	(sp)+,a3-4
	move.l	d0,AMHD_Task(a4);	

	;Now insert the current hook into the list of hooks for
	;AMOS to process.


	CALLEXEC	Forbid	;Don't corrupt list
	move.l	(a3),d1
	bne.s	.notfirst
	move.l	a4,(a3)
	move.l	a4,4(a3)
	bra.s	.skip
.notfirst	move.l	4(a3),a5
	move.l	a4,(a5)	;Set next pointer of waiting
	move.l	a4,4(a3)


	CALLEXEC	Permit

	;This hook is now in the waiting list, so wait on the 
	;signal bit allocated earlier. AMOS will then signal us
	;when the hook procedure has been run.
	
	move.l	AMHD_Signal(a4),d0 ;Get Signal bit
	move.l	a4,-(sp)
.skip	CALLEXEC	Wait	;Wait for signal bit
	move.l	(sp),a4
	move.l	AMHD_Signal(a4),d0 ;Get Signal bit Again
	CALLEXEC	FreeSignal
	
	move.l	(sp)+,a4
	move.l	AMHD_D0(a4),d0 ;Get return value from AMOS
	rts	               ;and return it to MUI
		

		
			

****************************************************************************	
*
* These routines is called by AMOS to execute hooks that are AMOS procedures
*
*


hook_getnext
	movem.l	a4-6,-(sp)	;Store AMOS Regs
	
	lea	hook_AMOSGlob(pc),a3

	;First remove the current hook from the list of waiting
	;hooks.

	
	CALLEXEC	Forbid	;No task switching
	move.l	(a3),a4        ;Get head of hook list
	move.l	(a4),d7	;Get next in list
	move.l	d7,(a3)	;Update list pointer
	CALLEXEC	Permit

	;Now signal the task that called the current hook that it
	;may continue.

	move.l	AMHD_Signal(a4),d0	;Get signal bit	
	move.l	AMHD_Task(a4),a1	;Get signal task
	
	CALLEXEC	Signal

	movem.l	(sp)+,a4-6	;Restore AMOS Regs.

	;Now hook_getnext runs straight into hook_getfirst...

hook_getfirst
	
	lea	hook_AMOSGlob(pc),a3
	move.l	4(a3),d0
.another	rts		
		