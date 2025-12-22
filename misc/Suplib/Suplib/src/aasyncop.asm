
	    section CODE

	    xdef    _PutA4A5
	    xdef    _CallAMFunc

	    ;
	    ;	load the lw array ptr with a4 & a5

_PutA4A5:   move.l  4(sp),A0
	    move.l  A4,(A0)+
	    move.l  A5,(A0)+
	    rts

_CallAMFunc:
	    move.l  4(sp),A0    ; &a4,a5
	    move.l  8(sp),A1    ; &func,arg1,arg2,arg3
	    movem.l D2/D3/A4/A5/A6,-(sp)
	    move.l  (A0)+,A4
	    move.l  (A0)+,A5
	    move.l  12(A1),-(sp)
	    move.l  8(A1),-(sp)
	    move.l  4(A1),-(sp)
	    move.l  (A1),A1
	    jsr     (A1)
	    add.w   #12,sp
	    movem.l (sp)+,D2/D3/A4/A5/A6
	    rts

	    END

