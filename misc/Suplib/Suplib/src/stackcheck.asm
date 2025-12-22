
	    ;	STACKCHECK.ASM
	    ;
	    ;	SetStackCheck(#bytes)             fill stack downward #bytes
	    ;	long #bytes
	    ;
	    ;	#bytes = GetStackCheck(#bytes)    return stack used
	    ;	long #bytes
	    ;
	    ;	These routines are used to determine how much stack a
	    ;	subroutine takes up.  SetStackCheck() lays down a pattern
	    ;	on the stack below the sp (of #bytes).  Thus, do not
	    ;	specify a value larger than the actual stack that is
	    ;	available from point of call.
	    ;
	    ;	GetStackCheck() scans from the lowest bound upward until
	    ;	the pattern fails, and the number of bytes from the top
	    ;	to the fail point is returned.	The idea is to call
	    ;	SetStackCheck(), call some other subroutine(s), then
	    ;	call GetStackCheck() to see how much stack they had used.
	    ;
	    ;	Warning: values will differ as EXEC pushes stuff on the user
	    ;	stack during a context switch.	Always give yourself about
	    ;	100 bytes more stack than you seem to need, unless you are
	    ;	using the 68881 or other coprocessor in which case you need
	    ;	to give yourself more.
	    ;
	    ;	warning: do not specify values larger than 32767 (just to
	    ;	be safe, theoretically you can specify up to 128K).  due to
	    ;	the nature of these routines I doubt you would specify more
	    ;	than that anyway.  Remember not to specify more bytes than
	    ;	stack you actually have.

	    section CODE

	    XDEF    _SetStackCheck
	    XDEF    _GetStackCheck

_SetStackCheck:
	    move.l  4(sp),D0        ; # of bytes (max 32K)
	    lsr.l   #1,D0	    ; # of words
	    move.l  sp,A0
.ss1	    move.w  #$1234,-(A0)
	    dbf     D0,.ss1
	    rts

_GetStackCheck:
	    move.l  4(sp),D0
	    bclr    #0,D0	    ; world align
	    move.l  sp,A0
	    sub.l   D0,A0	    ; start at bottom and move upwards
	    lsr.l   #1,D0	    ; # of words
	    subq.l  #1,D0	    ; 1 less (else would overwrite retaddr)
.gs1	    cmp.w   #$1234,(A0)+    ; until done or not equal
	    dbne    D0,.gs1
	    move.l  sp,D0
	    sub.l   A0,D0
	    add.l   #8,D0	    ; 8 more used than that to include
	    rts 		    ;  stack used by Get/SetStackCheck

	    END

