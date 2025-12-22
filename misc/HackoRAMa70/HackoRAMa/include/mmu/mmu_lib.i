	include	exec/funcdef.i

FUNC_CNT	SET	5*-6

	FUNCDEF	GetBit_PROTECTION_AWARE
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_PROTECTION_AWARE
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_COOKIE
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_COOKIE
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_TASK_READONLY
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_TASK_READONLY
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_GLOBAL_READONLY
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_GLOBAL_READONLY
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_GLOBAL_ILLEGAL
;-Output:----------------------------------------------------------------------
;	d0 = GLOBAL_ILLEGAL
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_WRITETHROUGH
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_PROTECTION_AWARE
;------------------------------------------------------------------------------

	FUNCDEF	GetBit_NOCACHE
;-Output:----------------------------------------------------------------------
;	d0 = MEMF_WRITETHROUGH
;------------------------------------------------------------------------------


	FUNCDEF	AnalyzeEnforcerHit
;-Input:-----------------------------------------------------------------------
;	a0 = task
;	d0 = hit address
;-Output:----------------------------------------------------------------------
;	d0 = hit info (OR'ed together)
;		#$0001 = task not owner
;		#$0002 = should not have hit (write and read legal)
;		#$0004 = write protect violation
;		#$0008 = read protect violation
;		#$8000 = address not in ram
;------------------------------------------------------------------------------


	FUNCDEF	AcceptParentTask
; WARNING: This function must be called with Forbid() protection!
;-Input:-----------------------------------------------------------------------
;	d0 = task
;------------------------------------------------------------------------------
; if parent has already accepted us then we will share address space with the
; parent task
;------------------------------------------------------------------------------
; tasks are not checked to see if they are alive
;------------------------------------------------------------------------------
; no memory will be freed and no protection will change by doing this call.
; be sure to free all allocated memory before calling this function
;-------

	FUNCDEF	AdoptTask
; WARNING: This function must be called with Forbid() protection!
;-Input:-----------------------------------------------------------------------
;	d0 = task
;------------------------------------------------------------------------------
; if child has already accepted us then the child will share address space with
; us
;------------------------------------------------------------------------------
; tasks are not checked to see if they are alive
;------------------------------------------------------------------------------
; no memory will be freed and no protection will change by doing this call.
; be sure child has freed all allocated memory before calling the matching
; AcceptParentTask() function
;-------

	FUNCDEF	ChangeThreadOwner
; WARNING: This function must be called with Forbid() protection!
;-Input:-----------------------------------------------------------------------
;	d0 = task
;------------------------------------------------------------------------------
; this is only for tasks that have called AcceptParentTask()/AdoptTask() and
; therefore established a thread relationship. This will change responsibility
; for who owns the common thread information.
; LAST TASK TO CLOSE mmu.library MUST BE THE OWNER!
;------------------------------------------------------------------------------
; tasks are not checked to see if they are alive
;------------------------------------------------------------------------------
; tasks have to agree on who is owner. There is no way to deny a thread to
; become the thread owner.
;-------

	FUNCDEF	MMU_Private0
; keep out

	FUNCDEF	AllocExecMem
;-Input:-----------------------------------------------------------------------
;	d0 = size
;	d1 = type
;-Output:----------------------------------------------------------------------
;	d0 = memory address
;------------------------------------------------------------------------------

	FUNCDEF	FreeExecMem
;-Input:-----------------------------------------------------------------------
;	d0 = size
;	a1 = address
;------------------------------------------------------------------------------

	FUNCDEF	SetReadonly
;-Input:----------------------------------------------------------------------
;	d0 = 4k aligned address of page to be write-protected
;-Output:---------------------------------------------------------------------
;	d0 = old descriptor
;	a0 = address of descriptor
;	page is protected against write
;-----------------------------------------------------------------------------

	FUNCDEF	SetIllegal
;-Input:----------------------------------------------------------------------
;	d0 = 4k aligned address of page to be read&write-protected
;-Output:---------------------------------------------------------------------
;	d0 = old descriptor
;	a0 = address of descriptor
;	page is protected against access
;-----------------------------------------------------------------------------

	FUNCDEF	RestoreDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = old descriptor
;	a0 = old descriptor address
;------------------------------------------------------------------------------

	FUNCDEF	SetPageDescriptor
;-Input:-----------------------------------------------------------------------
;	d0 = new descriptor
;	a0 = descriptor address
;------------------------------------------------------------------------------

