;/* this magic file both assembles as assembler code and compiles as E code
; to compile it, do:
; PhxAss patch.e TO patch_asm.o
; o2m patch_asm
; flushcache patch_asm
; EC patch
; delete patch_asm.o

; You need to copy both patch.m and patch_asm.m to your work directory, but
; you only need to include '*patch' on the module line of your source.

	include	exec/execbase.i
	include	exec/tasks.i
	include	exec/types.i

; some essential offsets into the wedge - the three variables located at the
; end of all wedges, and the total length of the wedge.

USECOUNT = usecnt - wedgecode
MISSED = missed - wedgecode
ENABLED = enabled - wedgecode
CODESIZE = endwedge - wedgecode	; always a longword multiple

; I'd like to 'export' these offsets as constants, but o2m won't have it.
; For now, then, we'll have to use 'stub' routines to let E know the lengths.

		xdef	xyzusecount
xyzusecount	moveq	#USECOUNT,d0
		rts
		xdef	xyzmissed
xyzmissed	moveq	#MISSED,d0
		rts
		xdef	xyzenabled
xyzenabled	moveq	#ENABLED,d0
		rts
		xdef	xyzcodesize
xyzcodesize	moveq	#CODESIZE>>1,d0
		add.l	d0,d0
		rts


; We use a number of absolute values and addresses in the wedge to save
; having to use registers. When installing a patch, the install code looks
; in the wedge code for these placeholders, and installs the appropriate
; values in place. To ensure that actual code or data is not mistaken for a
; placeholder, we use the ILLEGAL instruction as part of the placeholder

refbase=$4AFC0000
	ENUM	refbase
	EITEM	pUSECOUNT	; a pointer to the USECOUNT count variable
	EITEM	pMISSED		; a pointer to the MISSED count variable
	EITEM	pENABLED	; a pointer to the ENABLED flag variable
	EITEM	STACKNEEDED	; amount of bytes that should be free on stack
	EITEM	USERDATA	; the userdata value
	EITEM	PATCHCODE	; a pointer to the patch function code
	EITEM	ENTRY		; a pointer to the original function code
	EITEM	GLOBVEC		; the E program's A4 value
	EITEM	EXECBASE	; exec.library base


;****** patch.m/patched_function *******************************************
;
;   NAME
;	patched_function() -- how your installed patch is called.
;
;   SYNOPSIS
;	result := patched_function(
;	            original_function,
;	            a7,a6,a5,a4,a3,a2,a1,a0,d7,d6,d5,d4,d3,d2,d1,d0
;	          )
;
;	result := patched_function(
;	            userdata, original_function,
;	            a7,a6,a5,a4,a3,a2,a1,a0,d7,d6,d5,d4,d3,d2,d1,d0
;	          )
;
;   FUNCTION
;	When  you  install()  a  patch, your patch function will be called
;	instead  of  the original function. Rather than your function code
;	being  installed  directly as the new patch, an assembler wedge is
;	instead used. This allows for the patch to be enabled and disabled
;	with  ease, and also prepares the correct environment for an Amiga
;	E function to operate.
;
;	The  wedge  prepares a set of arguments on the stack for the patch
;	function,  so  that it can know everything neccessary to implement
;	the patch.
;
;	However,  the  wedge  also  makes a check that a minimum amount of
;	bytes are available on the calling task's stack before going on to
;	call  your patch. If there is insufficient stack space, your patch
;	will  not  be  called  and  instead  the original function will be
;	called. In this case, a 'missed' count will be incremented.
;
;   INPUTS
;	userdata          - this  value  was chosen by the programmer when
;	                    installing the patch.
;
;	                    This  userdata  value is passed whether or not
;	                    it  was requested in the installation, and the
;	                    way Amiga E handles function parameters allows
;	                    you  to either define your function so that it
;	                    knows  the  userdata  value, or it doesn't (as
;	                    shown above).
;
;	                    The userdata value can allow you to write only
;	                    one   function   to   patch  multiple  library
;	                    functions  - each patch would have a different
;	                    userdata  parameter,  and the patch code would
;	                    use  this  to  recognise which function it was
;	                    patching when called.
;
;	original_function - this  is  a  pointer  to  the  code that would
;	                    normally  be  executed,  if your patch was not
;	                    installed. In most patches, you do not replace
;	                    the  entire  functionality  of  the patch, and
;	                    therefore have to use this pointer to call the
;	                    original  function. Remember to initialise all
;	                    required   parameters  (including  A6)  before
;	                    calling this function.
;
;	a7, a6, a5, a4,   - these  are  the  68000 registers as set before
;	a3, a2, a1, a0,     your  patch  was called. Some of these will be
;	d7, d6, d5, d4,     parameters to your patch, others will be of no
;	d3, d2, d1, d0      use,  but  you  can  NOT remove them from your
;	                    function  declaration.  You  may  assign names
;	                    other  than their real register names to them,
;	                    perhaps  to  mirror  the  declaration  of  the
;	                    patched function - but be warned that you must
;	                    NOT  modify  these  variables, as they will be
;	                    restored  to  the  registers  on  exit of your
;	                    function.  The  only  parameter you can safely
;	                    alter  is  the 'd0' parameter, as its contents
;	                    are ignored on your function exit, instead the
;	                    function's return value is used for D0.
;
;	                    These  parameters  are  always  defined in the
;	                    same order - from A7 to A0, then D7 to D0.
;
;   RESULT
;	The  value  you return from your patch function is always returned
;	in  D0 by normal E standards. The assembler wedge avoids restoring
;	the  original  value  of  D0 it picked up on entry, so this result
;	stays.   Some  functions  declare  that  they  return  results  in
;	registers  other  than  D0,  so you will have to store those other
;	results  in the appropriate 'register' parameters that were passed
;	in  to  your function. On return, those variables will be restored
;	into the appropriate 68000 registers.
;
;	Some functions promise (or are expected) to return with the Z flag
;	set  when D0 = NIL. For this, D0 is tested as the last instruction
;	before return to the calling program, and Z will be set or cleared
;	depending if D0 = 0 or not.
;
;***************************************************************************
;
; Here we define the assembler wedge that will translate bare calls to
; itself into calls to an Amiga E function, which needs parameters passed
; on the stack in all cases.
;
; We provide all registers as parameters to the E function, and we restore
; those parameters back into the registers, so that the E function has the
; option to modify ANY of the registers in a simple and safe way, if it
; wants to. However, for a simpler analogy with a normal function, the D0
; result from calling the E function is left as it stands.
;
; The first thing we test is if the patch is enabled. If it isn't, then we
; go straight to the original function, and the caller never sees our wedge
; again.
;
; If we are going to call the patch, we increment a usage count to 'lock'
; the wedge in place, as we will be spending time calling something or
; other.
;
; We check if the stack pointer is in the area that the system has defined
; as its stack. If not, we assume there is enough space to call the
; function. All E programs and some old SAS/C programs have this 'problem',
; so to exclude them from our patch is a bit mean.
;
; If the stack pointer is within the upper/lower limit, we check that
; calling our patch would not exceed that limit. If so, we increment a
; 'missed calls' count, decrement the usage count, and jump to the original
; function instead.
;
; Unavoidable stack usage is as follows: 4 bytes for userdata, 4 for
; entryaddr, 64 for registers, 4 for the return address pushed by JSR, and
; 4 from the LINK instruction that E always uses in its functions. That's
; 80 bytes. However, when we make the stack calculation, we have already
; pushed 4 bytes which we will deduct before using the stack as detailed.
; So the minimum NEEDEDSTACK value must be 76.
;
; If our checks show that it is OK to call the patch, we do so. First we
; push the optional userdata value. The way E defines stack parameter
; passing (first pushed=first arg, last arg=last pushed), the initial
; parameters can be skipped by defining a function to accept less
; parameters, not so the other way around. We next push the original
; function's address, then all 16 registers.
;
; The order the registers are pushed into memory is D0-D7/A0-A7, from lower
; memory to higher, but as the stack (and E's parameters) work in reverse
; this comes out as A7-A0/D7-D0 as E function parameters.
;
; As the 'a7' parameter is the last longword pushed of 16, we can assume
; its offset from the stack (where 0(sp)=D0, 4(sp)=D1,...) is 15*4(sp)
;
; We next have to set up A4 so E can access its global variables. Finally,
; we call the patching E function. After it returns, we pull the register
; parameters off the stack and back into registers, except for D0.
;
	cnop	0,4
wedgecode
	tst.w	pENABLED	; only run our patch when enabled
	bne.s	run
	jmp	ENTRY		; otherwise, just call the original function

enabled	dc.w	0
usecnt	dc.l	0
missed	dc.l	0

run	addq.l	#1,pUSECOUNT
	move.l	a0,-(sp)

	move.l	#EXECBASE,a0
	move.l	ThisTask(a0),a0		; get current task
	cmp.l	TC_SPUPPER(a0),sp	; sp > upper stack limit ?
	bhi.s	.call			; if so, call the patch function anyway
	move.l	TC_SPLOWER(a0),a0	; get lower stack limit
	cmp.l	a0,sp			; sp < lower limit?
	bcs.s	.call			; if so, call the patch function anyway
	add.l	#STACKNEEDED,a0		; shorten lower limit by stack needed
	cmp.l	a0,sp			; still within the limit?
	bcc.s	.call			; if so, call the patch function

; otherwise, increment the MISSED count and leave.
	move.l	(sp)+,a0
	addq.l	#1,pMISSED
	subq.l	#1,pUSECOUNT
	jmp	ENTRY

; calling the patched function rather than the original
.call	move.l	(sp)+,a0
	pea	USERDATA	; push userdata as first/ignored parameter
	pea	ENTRY		; push original function entry
	movem.l	d0-7/a0-7,-(sp)	; push all registers
	addq.l	#8,[15*4](sp)	; adjust 'A7' to ignore 2 args we pushed
	move.l	#GLOBVEC,a4
	jsr	PATCHCODE	; call our patch function
	addq.l	#4,sp		; throw away D0 saved register
	movem.l	(sp)+,d1-7/a0-7	; restore all registers except D0
	addq.l	#8,sp		; throw away the entry/userdata parameters
	subq.l	#1,pUSECOUNT
	tst.l	d0		; for compatibility with certain functions
	rts

	cnop	0,4
endwedge


;-----------------------------------------------------------------------------
; install_wedge() copies the wedge code to [codeaddr], then fills in the
; appropriate placeholders as neccessary.

; install_wedge(codeaddr, entry, patchfunc, stackuse, userdata)
;		20(sp)    16(sp) 12(sp)     8(sp)     4(sp)

	xdef	install_wedge__iiiii
install_wedge__iiiii

; copy the normal (unadjusted) wedge code into the specified code location

	lea	wedgecode(pc),a0
	move.l	20(sp),a1
	moveq	#(CODESIZE>>2)-1,d0
.copy	move.l	(a0)+,(a1)+
	dbra	d0,.copy
	
; now go through this copy and fill in the appropriate values at the
; placeholders

	move.l	20(sp),a0

; pointers to within the wedgecode (pointing at its variables)
	lea	USECOUNT(a0),a1
	moveq	#pUSECOUNT-refbase,d0
	bsr.s	.fill
	lea	MISSED(a0),a1
	moveq	#pMISSED-refbase,d0
	bsr.s	.fill
	lea	ENABLED(a0),a1
	moveq	#pENABLED-refbase,d0
	bsr.s	.fill

; values provided as arguments to this function
	move.l	a2,-(sp)
	lea	4+4(sp),a2	; point at original 4(sp) - userdata

	move.l	(a2)+,a1	; = 4(sp) = userdata
	moveq	#USERDATA-refbase,d0
	bsr.s	.fill
	move.l	(a2)+,a1	; = 8(sp) = stackuse
	moveq	#STACKNEEDED-refbase,d0
	bsr.s	.fill
	move.l	(a2)+,a1	; = 12(sp) = patchfunc
	moveq	#PATCHCODE-refbase,d0
	bsr.s	.fill
	move.l	(a2)+,a1	; = 16(sp) = entry
	moveq	#ENTRY-refbase,d0
	bsr.s	.fill
	move.l	(sp)+,a2

; the globvec value
	move.l	a4,a1
	moveq	#GLOBVEC-refbase,d0
	bsr.s	.fill

; execbase
	move.l	4.w,a1
	moveq	#EXECBASE-refbase,d0
	bsr.s	.fill

	rts

.fill	add.l	#refbase,d0

; this miniroutine will look through the patchcode at A0 for the placeholder
; in D0, and any matching placeholders it finds will be replaced with the
; correct value given in A1

	move.l	a0,-(sp)
	moveq	#CODESIZE>>1,d1	; loop for CODESIZE bytes
.search	cmp.l	(a0),d0		; have we found a placeholder?
	bne.s	.nofill
	move.l	a1,(a0)		; if so, put the correct value in place
.nofill	addq.l	#2,a0		; in any case, advance by two bytes
	subq.l	#1,d1
	bne.s	.search		; repeat until we have searched CODESIZE bytes
	move.l	(sp)+,a0
	rts

	end

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------------*/

-> here begins the code compiled as E code

OPT MODULE,PREPROCESS

-> remember folks, if o2m supported creation of constants rather than just
-> functions, we wouldn't need these.

#define USECOUNT xyzusecount()
#define MISSED   xyzmissed()
#define ENABLED  xyzenabled()
#define CODESIZE xyzcodesize()


-> the define OS37_CODE makes shorter code that runs only on WB2+
#define OS37_CODE

#ifdef OS37_CODE
  OPT OSVERSION=37
  #define ALLOC(x,y) AllocVec(x,y)
  #define FREE(x,y)  FreeVec(x)
  #define CLEARCACHE CacheClearU()
#endif
#ifndef OS37_CODE
  OPT OSVERSION=33
  #define ALLOC(x,y) AllocMem(x,y)
  #define FREE(x,y)  IF x THEN FreeMem(x,y)
  #define CLEARCACHE IF KickVersion(36) THEN CacheClearU()
#endif

MODULE 'exec/memory', '*patch_asm'


/****** patch.m/--overview-- *******************************************
*
*   PURPOSE
*	To allow easy patching of Amiga library and device functions
*	with Amiga E code.
*
*   OVERVIEW
*	The AmigaOS has a facility to change the code called in any of the
*	functions  of  a  library  or  device.  But due to the way Amiga E
*	works, it has been difficult to easily use E code as patches.
*
*	This  object  allows  you  to  perform patches on the system using
*	Amiga E code in the most flexible way, via an assembler wedge.
*
*	Installation:
*
*	You  first  need  to open the library/device that you are going to
*	patch.  You  then  need  to  know the Library Vector Offset of the
*	entry  you  are  going to patch. This is available using the 'lvo'
*	tool  from  the  Developer Kit, or any assembler include file with
*	'LVO'  in the title. You must keep the library/device open for the
*	entire  duration  of  the patch. If you do not, the library may be
*	flushed from memory and loaded somewhere else, indirectly removing
*	the  patch  and  also  causing  a  crash when we try to remove our
*	defunct patch later.
*
*	You  create  a patch object with install(), which installs a wedge
*	that calls an E function which you defined like so:
*
*	    PROC patch_code(function, a7,a6,a5,a4,a3,a2,a1,a0,
*	                              d7,d6,d5,d4,d3,d2,d1,d0)
*
*	You  can give alternate names to the 'register' parameters, but do
*	remember  that  they  will  always  be  passed IN THE ABOVE-STATED
*	ORDER, and writing the parameter's names in a different order will
*	NOT cause the registers to be passed to you in a different order.
*
*	See patched_function() for more about this.
*
*	Your patch in operation:
*
*	This  E  function is called 'as' the function you have patched, by
*	absolutely  any  task  and  program  that  could call the original
*	function.  Also,  the  function  may  be  called  by more than one
*	program  at  once,  so  use a Semaphore or similar protection when
*	using global variables.
*
*	You are given all the registers as set when the patch was called -
*	do  NOT modify them unless it is documented that the function does
*	this.  That said, you can always modify the 'd0' variable as it is
*	ignored  on exit, the return value of your function is returned in
*	D0 rather than the stack-based copy.
*
*	Occasionally  you  can modify the 'scratch register' variables d0,
*	d1,  a0  and  a1,  but  you  must  check  the documentation of the
*	function  you  are  patching,  to  ensure  it  does not promise to
*	preserve any of these registers.
*
*	The result of your function call is always returned in D0, but E's
*	multiple return values (in D1 and D2) are ignored, and restored to
*	their original values.
*
*	Calling the original function:
*
*	You  are  also  given  a pointer to the original function you have
*	patched.  In  most  patches,  you  will  have to call the original
*	function sometime, so you would set up the registers appropriately
*	from  the parameters, including A6 as the library/device base, and
*	call  the  original  function.  Do  NOT  do  this by writing the E
*	construct "function()", as this will use an unspecified A-register
*	to  make  the  call. Instead, do it yourself with another register
*	that  you choose. If you need to pass A0 to A3 as parameters, then
*	you will have to preserve and use A4 or A5.
*
*	Patch removal:
*
*	Your  patch  can be either enabled or disabled. When disabled, the
*	assembler  wedge  simply  hops  to  the  original function, adding
*	nothing  to  the  stack. Simply exiting your program at this point
*	without  ENDing  the  object would free the object instance itself
*	but would leave the working wedge in place, consuming 136 bytes of
*	memory and adding 3 instructions to the function.
*
*	Some  people  would  advocate  exiting your program with the wedge
*	still in place, as the user is unlikely to do that often, but when
*	they do there will be no problem with exiting correctly.
*
*	Others  would always recommend total removal of the patch, even if
*	that  means  waiting. Unlike other wedges, the removal method used
*	by  this  object is very safe, only removes the patch if it is not
*	being  used,  and understands programs like SetFunction Manager or
*	SaferPatches which allow removal of patches in any order.
*
*	My  advice  is to always disable() the patch, then try to remove()
*	the  patch. If that fails, ask the user if you should keep trying,
*	or just exit.
*
*   NOTES
*	You  must NOT use Amiga E's 'debug' mode and EDBG on the code that
*	contains  the  patch you will be making. E introduces NOP commands
*	into  the  code,  which  EDBG turns to ILLEGAL commands, so it can
*	run the E code in the normal way, then give control back to itself
*	after  each  line.  However,  when  the  E code is called by other
*	tasks,  these  ILLEGALs  are not trapped by EDBG, and simply crash
*	the  task  involved.  A  simple  fix is to put the patch code in a
*	seperate module, and compile this without debug mode.
*
*	Exceptions  should never be thrown out of patches. If there is the
*	possibility  of an exception being raised, make the patch function
*	HANDLE it, not throw it out.
*
*	Some functions are marked as safe to be called from interrupts. If
*	this  is  the  case, you have to handle the possible deadlock that
*	may  occur  -  interrupt blocks a task, then goes into a loop that
*	waits for the blocked task to finish, which it will never do.
*
*	If  the function you are patching is part of the AmigaOS, remember
*	to check the function's autodocs for defined side effects that you
*	must emulate.
*
*	You  obviously  cannot  call  the function you patched through the
*	usual way, but you also cannot call a system/library function that
*	calls your patched function as part of its operation.
*
*	You cannot perform I/O on _your_ streams from another process, and
*	tasks  can't  even  call any DOS functions. Therefore, WriteF() in
*	your patch is out of the question. Use debug.m/kPrintF and Sushi.
*
*   WARNING
*	When your patch is enabled, the combination of assembler wedge and
*	E code will add a MINIMUM of 80 bytes - THEN extra bytes are added
*	for the variables in your patch!
*
*	You should minimise local variable usage - even register variables
*	add to stack usage - and avoid defining entire structures, STRINGs
*	or LISTs as local variables.
*
****************************************************************************
*
*
*/

EXPORT OBJECT patch PRIVATE
  code        -> pointer to the assembler wedge code
  entry       -> pointer to the original function code
  base        -> pointer to the base of the library which we have patched
  offset:INT  -> Library Vector Offset of the function patched
  running:INT -> TRUE if patch is installed, FALSE if removed
ENDOBJECT


/****** patch.m/install *******************************************
*
*   NAME
*	patch.install() -- Constructor.
*
*   SYNOPSIS
*	install(base, offset, patchfunc)
*	install(base, offset, patchfunc, userdata)
*	install(base, offset, patchfunc, userdata, stackuse)
*
*   FUNCTION
*	Initialises  an  instance of the patch class, and installs a patch
*	in the system. The patch will not be enabled to begin with, so you
*	must  call  enable()  on  the  patch  for it to start working. The
*	exception "MEM" will be raised if there is no memory for a wedge.
*
*	Read patched_function() to see how this patch is called.
*
*   INPUTS
*	base      - the  base  of  the library or device of whose function
*	            you  will  be  patching. It should remain open for the
*	            entire  life of the patch, otherwise it may be flushed
*	            from memory, rendering the patch useless.
*
*	offset    - This  is the Library Vector Offset of the function you
*	            are patching. The appropriate number is available from
*	            LVO files or the 'lvo' tool.
*
*	patchfunc - The address of the Amiga E function which will replace
*	            the specified device/library function.
*
*	userdata  - An optional parameter that can be anything you want it
*	            to be. It will be passed to your E function as a LONG,
*	            whether or not you define or use it. The default value
*	            for this parameter is zero.
*
*	stackuse  - An  optional  parameter to state the minimum amount of
*	            stack space your function will use. This does not need
*	            to include the 80 byte overhead of the assembler wedge
*	            that calls your function, as this is already included.
*
*   NOTE
*	The stack used by your function can be calculated as follows:
*	- the size of your local variables
*	- if you call any functions, add 8 bytes plus the size of its
*	  local variables only for the function with the largest stack use
*	- if you call a system/library function, add ????? bytes
*
*	Local Variable stack usage calculations:
*	- 4 bytes for every defined local variable (that means _every_
*	  variable - includes REGs, ARRAYs, STRINGs and LISTs)
*	- for a variable defined thus:,   add this many bytes:
*	  xx[size_x]:STRING               size_x + 1 (add 1 IF Odd(size_x+1))
*	  yy[size_x]:LIST                 size_x * 4
*	  zz:[size_x]:ARRAY OF blah       size_x * (SIZEOF blah + 4)
*	  zz:blah                         SIZEOF blah
*
*   SEE ALSO
*	end(), enable(), missed(), patched_function()
*
****************************************************************************
*
*
*/

EXPORT PROC install(base, offset, patchfunc, userdata=0, stackuse=0) OF patch
  DEF code, entry

  IF (code := ALLOC(CODESIZE, MEMF_PUBLIC))=NIL THEN Raise("MEM")

  Disable()

  self.entry    := entry := SetFunction(base, offset, code)
  self.base     := base
  self.code     := code
  self.offset   := offset
  self.running  := TRUE

  install_wedge(code, entry, patchfunc, stackuse + 76, userdata)

  CLEARCACHE
  Enable()
ENDPROC


/****** patch.m/end *******************************************
*
*   NAME
*	patch.end() -- Destructor.
*
*   SYNOPSIS
*	end()
*
*   FUNCTION
*	Frees  resources  used  by an instance of the patch class. It will
*	first  disable() the patch, then it will busy loop until the patch
*	is successfully removed.
*
*   SEE ALSO
*	disable(), remove(), install()
*
****************************************************************************
*
*
*/

EXPORT PROC end() OF patch
  self.disable()
  WHILE self.remove() = FALSE DO Delay(50)
  FREE(self.code, CODESIZE)
ENDPROC


/****** patch.m/remove *******************************************
*
*   NAME
*	patch.remove() -- attempt to remove the patch.
*
*   SYNOPSIS
*	removed := remove()
*
*   FUNCTION
*	Attempts  to  remove  the  patch  from the system, and restore the
*	original  function. If the patch is successfully removed, there is
*	nothing you can do but END the patch.
*
*   RESULT
*	removed - TRUE if removal of the patch was successful.
*
*   NOTE
*	You  may  have a greater chance of successful removal of the patch
*	if you disable() it first.
*
*   SEE ALSO
*	end(), disable()
*
****************************************************************************
*
*
*/

EXPORT PROC remove() OF patch
  DEF oldf
  IF self.running
    Disable()
    IF Long(self.code + USECOUNT) THEN RETURN Enable() BUT FALSE
    IF self.code <> (oldf := SetFunction(self.base, self.offset, self.entry))
      SetFunction(self.base, self.offset, oldf)
      RETURN Enable() BUT FALSE
    ENDIF
    self.running := FALSE
    Enable()
  ENDIF
ENDPROC TRUE


/****** patch.m/disable *******************************************
*
*   NAME
*	patch.disable() -- prevent further execution of the patch.
*
*   SYNOPSIS
*	disable()
*
*   FUNCTION
*	Stops the patch from being invoked again. All calls to the patched
*	function  will be passed directly to the original function, not to
*	your patch.
*
*	There  may,  however, still be invocations of the patch running at
*	the time this call returns.
*
*   SEE ALSO
*	enable()
*
****************************************************************************
*
*
*/

EXPORT PROC disable() OF patch IS PutInt(self.code + ENABLED, FALSE)


/****** patch.m/enable *******************************************
*
*   NAME
*	patch.enable() -- allow execution of the patch.
*
*   SYNOPSIS
*	enable()
*
*   FUNCTION
*	Toggles a switch in the assembler wedge which stops it passing all
*	calls of the patched function to the original function, and starts
*	passing them to your patch.
*
*	Your  patch  should  be ready to run at any time from the start of
*	the call to this method.
*
*   SEE ALSO
*	disable()
*
****************************************************************************
*
*
*/

EXPORT PROC enable() OF patch IS PutInt(self.code + ENABLED, TRUE)


/****** patch.m/missed *******************************************
*
*   NAME
*	patch.missed() -- return number of missed calls.
*
*   SYNOPSIS
*	number := missed()
*
*   FUNCTION
*	When tasks and processes do not have enough stack space to allow a
*	call  to your patch function, the assembler wedge will skip to the
*	original function and increment a 'missed' count.
*
*	When  you call this function, you discover how many calls you have
*	missed  due  to stack restrictions, and - at the same time - reset
*	the missed count back to 0.
*
*   SEE ALSO
*	install()
*
****************************************************************************
*
*
*/

EXPORT PROC missed() OF patch
  DEF missed
  missed := Long(self.code + MISSED)
  PutLong(self.code + MISSED, 0)
ENDPROC missed
