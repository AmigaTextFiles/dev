
;FHPRINTF.ASM
;
;  Handles formatted printing to Amiga file handles   w/ fhprintf
;

	    section CODE

	    xdef  _fhprintf
	    xref  _Write
	    xref  _LVORawDoFmt
	    xref  _SysBase

_fhprintf
	    jsr      xformat   ;same thing
	    jsr      _Write
	    lea.l    268(A7),A7
	    rts

	    ;XFORMAT takes a Xprintf(xx, cs, arg, arg...)  where xx is any
	    ;integer and returns (xx, buf, bytes) on the stack suitable for an
	    ;immediate call to xwrite() or Write().  The caller must deallocate
	    ;268 bytes from the stack when done.
	    ;
	    ;	      (oret)
	    ;  A2 A3 A4 A5 A6 RET FI BUF NUM <thebuffer> printfret fi cs args
	    ;  ^   ^	     ^
	    ;  1   2	     3


xformat
	    move.l   A7,A0	    ;sp now at pos. #3	A0 = pos #3
	    sub.l    #268,A7	    ;sp now at pos. #2	SP = pos #2
	    move.l   (A0),(A7)      ;copy return address
	    move.l   8(A0),4(A7)    ;copy fi or fh  to FI
	    lea.l    16(A7),A1      ;address of buffer
	    move.l   A1,8(A7)       ;place in     BUF
	    movem.l  A2-A6,-(A7)    ;save regs   SP = pos #1
	    move.l   A1,A3	    ;A3 = buffer pointer
	    lea.l    16(A0),A1      ;A1 = lea of printf arg list
	    move.l   12(A0),A0      ;A0 = control string
	    move.l   #_xc,A2	    ;A2 = call vector

	    move.l   _SysBase,A6    ;exec library call
	    jsr      _LVORawDoFmt(A6)

	    move.l   28(A7),A3      ;buffer start
loop	    tst.b    (A3)+          ;find end of string
	    bne      loop
	    sub.l    28(A7),A3      ;get string length
	    subq.l   #1,A3
	    move.l   A3,32(A7)      ;place in     NUM
	    movem.l  (A7)+,A2-A6    ;restore registers used
	    rts

_xc
	    move.b   D0,(A3)+
	    rts

	    END

