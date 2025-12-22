*****
****
***			D E T A C H   code for   P O W E R V I S O R
**
*				Version 1.32
**				Mon Aug 31 10:15:24 1992
***			© Jorrit Tyberghein
****
*****

 * Part of PowerVisor source   Copyright © 1992   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH


			INCLUDE	"pv.i"

			INCLUDE	"pv.lib.i"
			INCLUDE	"pv.errors.i"

	XREF		MainPr,Detach,CmdLine,CheckOption


	IFD D20
	section DetachCode,code

DetachCode:
		move.l	a0,(CmdLine)

		moveq		#'d',d0
		jsr		(CheckOption)
		bne.b		1$

		movea.l	(SysBase).w,a6
		movea.l	(ThisTask,a6),a3
		tst.l		(pr_CLI,a3)
		beq.b		1$

	;Yes, there is a CLI
		lea		(DosLib,pc),a1
		moveq		#36,d0
		CALL		OpenLibrary
		tst.l		d0
		beq.b		2$
		movea.l	d0,a6

		lea		(CNPtags,pc),a0
		move.l	(CmdLine),(12,a0)	;NP_Arguments
		lea		(DetachCode,pc),a1
		move.l	(-4,a1),(4,a0)		;Get pointer to next seglist
		clr.l		(-4,a1)				;End this seglist

		moveq		#1,d0
		move.l	d0,(Detach)

		move.l	a0,d1
		CALL		CreateNewProc

		movea.l	a6,a1
		movea.l	(SysBase).w,a6
		CALL		CloseLibrary

	;Exit this process
		moveq		#0,d0
		rts

	;We are running in AmigaDOS 1.3 or 1.2!
2$		movea.l	(CmdLine),a0		;Restore pointer to commandline
	ENDC

1$		jmp		(MainPr)

 IFD D20
CNPtags:			dc.l		NP_Seglist,0
					dc.l		NP_Arguments,0
					dc.l		NP_StackSize,16000
					dc.l		NP_Name,CNPname
					dc.l		NP_FreeSeglist,1
					dc.l		NP_Cli,1
					dc.l		TAG_DONE

DosLib:			dc.b		"dos.library",0
CNPname:			dc.b		"pv",0
 ENDC

	END
