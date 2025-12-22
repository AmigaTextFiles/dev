
;---;  locks.r  ;--------------------------------------------------------------
*
*	****	LOCKS, FILES AND DIRECTORIES    ****
*
*	Author		Stefan Walter
*	Version		0.00
*	Last Revision	15.02.94
*	Identifier	lfd_defined
*       Prefix		lfd_	(Locks, Files and Directories)
*				 ¯      ¯         ¯
*	Functions	RememberCD, RestoreCD, IsFile, GetParentDir,
*			GetLAEInfo, FreeLAEInfo, AddToDirList, FreeDirList,
*			FindFileDirList, GetPathFromLock
*
;------------------------------------------------------------------------------

	IFND	lfd_defined
lfd_defined	SET	1

;------------------
lfd_oldbase	EQU __BASE
	base	lfd_base
lfd_base:

;------------------


;------------------------------------------------------------------------------
*
* GetPathFromLock	Get the full path of a file or directory with
*			a given lock.
*
* INPUT:	d0:	Lock.
*		a0:	Buffer.
*
* RESULT:	d0:	Lock or 0 if an error occured.
*		a0:	Buffer.
*		ccr:	On d0.
*
;------------------------------------------------------------------------------

	IFD	xxx_GetPathFromLock

GetPathFromLock:
	movem.l	d1-a6,-(sp)
	moveq	#0,d7
	move.l	a0,a4
	clr.b	(a4)
	moveq	#0,d5
	move.l	d0,d4

	moveq	#1,d1
	moveq	#65,d0
	lsl.l	#2,d0
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq	.done
	move.l	d0,a3

	move.l	d4,d1
	move.l	DosBase(pc),a6
	jsr	-96(a6)			;DupLock()
	move.l	d0,d6
	beq.s	.free

.l:	move.l	d6,d1
	move.l	a3,d2
	jsr	-102(a6)		;Examine()
	tst.l	d0	
	beq.s	.unl

	moveq	#-1,d4
	lea	8(a3),a2
.cnt:	addq.l	#1,d4	
	tst.b	(a2)+
	bne.s	.cnt

	move.l	a4,a0
	addq.l	#1,a0
	add.l	d5,a0
	move.l	a0,a1
	move.w	d4,d3
	tst.w	d5
	beq.s	.nd1
	addq.w	#1,d4
.nd1	add.l	d4,a1
	move.w	d5,d0
.mv:	move.b	-(a0),-(a1)
	dbra	d0,.mv
	tst.w	d5
	beq.s	.nd2
	move.b	#"/",-(a1)
.nd2:	move.l	a2,a0
	move.l	a1,a2
	subq.l	#1,a0
.cp:	move.b	-(a0),-(a1)
	subq.w	#1,d3
	bne.s	.cp
	move.l	d6,d0
	CALL_	GetParentDir
	bne.s	.nd3
	move.b	#":",(a2)
	tst.w	d5
	bne.s	.nroot
	clr.b	1(a2)
.nroot:	moveq	#-1,d7
	bra.s	.free

.nd3:	move.l	d0,d6
	add.l	d4,d5
	bra.s	.l


.unl:	move.l	d6,d1
	move.l	DosBase(pc),a6
	jsr	-90(a6)			;UnLock()
	
.free:	move.l	a3,a1
	moveq	#65,d0
	lsl.l	#2,d0
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

.done:	move.l	d7,d0
	movem.l	(sp)+,d1-a6
	rts


	ENDC

;------------------------------------------------------------------------------
*
* AddToDirList	Add an entry to directory list.
*
* INPUT:	d0:	Path.
*
* RESULT:	d0:	Entry or 0 if error.
*
;------------------------------------------------------------------------------

	IFD	xxx_AddToDirList

AddToDirList:
	movem.l	d1-a6,-(sp)
	CALL_	GetLAEInfo
	beq.s	\done
	move.l	d0,d4
	move.l	a0,a4
	CALL_	IsFile
	bpl.s	\rem
	CALL_	GetParentDir
	beq.s	\unlck
	move.l	d0,d4

\rem:	move.l	DosBase(pc),a6
	move.l	d4,d1
	jsr	-96(a6)			;DupLock()
	move.l	d0,d3
	beq.s	\unlck
	
	moveq	#8,d0
	moveq	#0,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	tst.l	d0
	beq.s	\undl

	move.l	d0,a0
	clr.l	(a0)
	move.l	d3,4(a0)
	lea	lfd_dirList(pc),a1
\l:	tst.l	(a1)
	beq.s	\cp
	move.l	(a1),a1
	bra.s	\l

\cp:	move.l	a0,(a1)
	bra.s	\unlck

\undl:	move.l	DosBase(pc),a6
	move.l	d3,d1
	jsr	-90(a6)			;UnLock()
	moveq	#0,d0

\unlck:	move.l	d4,d0
	move.l	a4,a0
	CALL_	FreeLAEInfo
	tst.l	d0

\done:	movem.l	(sp)+,d1-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* FreeDirList	Free all entries of the directory list.
*
;------------------------------------------------------------------------------

	IFD	xxx_FreeDirList

FreeDirList:
	movem.l	d0-a6,-(sp)
	move.l	lfd_dirList(pc),a4

\loop:	move.l	a4,d7
	beq.s	\done
	move.l	(a4),a4

	move.l	d7,a1
	move.l	4(a1),d6
	moveq	#8,d0
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

	move.l	d6,d1
	move.l	DosBase(pc),a6
	jsr	-90(a6)			;UnLock()
	bra.s	\loop

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* FindFileDirList	Search a file in all directories. Changes current
*			directory.
*
* INPUT:	d0:	Path.
*
* RESULT:	d0:	Lock on file or 0.
*		a0:	Examine block.
*		ccr:	On d0.
*
;------------------------------------------------------------------------------

	IFD	xxx_FindFileDirList
FindFileDirList:
	movem.l	d1-d7/a1-a6,-(sp)
	move.l	d0,d7
	lea	lfd_dirList(pc),a4

\loop:	move.l	d7,d0
	CALL_	GetLAEInfo
	bne.s	\done
	move.l	(a4),a4
	move.l	a4,d0
	beq.s	\done
	move.l	4(a4),d1
	move.l	DosBase(pc),a6
	jsr	-126(a6)		;CurrentDir()	
	bra.s	\loop

\done:	movem.l	(sp)+,d1-d7/a1-a6
	rts
	ENDC



;------------------------------------------------------------------------------
*
* RememberCD	Remember current directory.
* RestoreCD	Restore current directory.
*
;------------------------------------------------------------------------------

	IFD	xxx_RememberCD

RememberCD:
	movem.l	d0-a6,-(sp)
	move.l	DosBase(pc),a6
	moveq	#0,d1	
	jsr	-126(a6)		;CurrentDir()
	lea	lfd_oldCD(pc),a0
	move.l	d0,(a0)
	move.l	d0,d1
	jsr	-126(a6)		;CurrentDir()
	movem.l	(sp)+,d0-a6
	rts

	ENDC



	IFD	xxx_RestoreCD

RestoreCD:
	movem.l	d0-a6,-(sp)
	move.l	DosBase(pc),a6
	move.l	lfd_oldCD(pc),d1
	jsr	-126(a6)		;CurrentDir()
	movem.l	(sp)+,d0-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* GetLAEInfo	Get lock and examine file or directory.
*
* INPUT:	d0:	Path.
*
* RESULT:	d0:	Lock or 0.
*		a0:	Examine block.
*		ccr:	On d0.
*
;------------------------------------------------------------------------------

	IFD	xxx_GetLAEInfo

GetLAEInfo:
	movem.l	d1-d7/a1-a6,-(sp)
	move.l	d0,d4

	move.l	#260/4,d0
	lsl.l	#2,d0
	moveq	#0,d1
	move.l	4.w,a6
	jsr	-198(a6)		;AllocMem()
	move.l	d0,d5
	beq.s	\done

	move.l	d0,d7
	move.l	d4,d1
	moveq	#-2,d2
	move.l	DosBase(pc),a6
	jsr	-84(a6)			;Lock()
	move.l	d0,d4
	beq.s	\free

	move.l	d4,d1
	move.l	d5,d2
	jsr	-102(a6)		;Examine()
	move.l	d5,a0
	exg.l	d0,d4
	tst.l	d0
	bne.s	\done

\unlck:	move.l	d4,d1
	jsr	-90(a6)			;UnLock()

\free:	moveq	#260/4,d0
	lsl.l	#2,d0
	move.l	d5,a1
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()
	moveq	#0,d0

\done:	movem.l	(sp)+,d1-d7/a1-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* FreeLAEInfo	Free lock and examine block.
*
* INPUT:	d0:	Lock, 0 accepted.
*		a0:	Examine block.
*
;------------------------------------------------------------------------------

	IFD	xxx_FreeLAEInfo

FreeLAEInfo:
	movem.l	d0-a6,-(sp)

	move.l	a0,d5
	move.l	d0,d1
	beq.s	\done
	move.l	DosBase(pc),a6
	jsr	-90(a6)			;UnLock()

	moveq	#260/4,d0
	lsl.l	#2,d0
	move.l	d5,a1
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

\done:	movem.l	(sp)+,d0-a6
	rts

	ENDC



;------------------------------------------------------------------------------
*
* IsFile	Check if an examined object is a file.
*
* INPUT:	a0:	Examine block.
*
* RESULT:	ccr:	MI if file, PL if directory.
*
;------------------------------------------------------------------------------

	IFD	xxx_IsFile

IsFile:	tst.l	4(a0)
	rts

	ENDC



;------------------------------------------------------------------------------
*
* GetParentDir	Get parent directory lock. The old lock is unlocked.
*
* INPUT:	d0:	Lock.
*
* RESULT:	d0:	Lock or 0 if previous was root.
*		ccr:	On d0.
*
;------------------------------------------------------------------------------

	IFD	xxx_GetParentDir

GetParentDir:
	movem.l	d1-a6,-(sp)
	move.l	DosBase(pc),a6
	move.l	d0,d1
	move.l	d0,d7
	jsr	-210(a6)		;ParentDir()
	move.l	d0,d6
	move.l	d7,d1
	jsr	-90(a6)			;UnLock()
	move.l	d6,d0
	movem.l	(sp)+,d1-a6
	rts

	ENDC



;--------------------------------------------------------------------

lfd_oldCD:	dc.l	0
lfd_dirList:	dc.l	0


;--------------------------------------------------------------------

	base	lfd_oldbase

;------------------

	ENDIF

	end

