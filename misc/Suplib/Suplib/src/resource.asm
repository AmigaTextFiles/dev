
 ;
 ;  EXEC resource support
 ;			       4(sp)  8(sp)
 ;	AutoAllocMiscResource(resno, value)
 ;	    resno:  MR_SERIALPORT, SERIALBITS, PARALLELPORT, PARALLELBITS
 ;	    value:  -1 to allocate, 0 to check
 ;
 ;	    returns 0 on success
 ;
 ;	AutoFreeMiscResource(resno)
 ;			      4(sp)
 ;	    Free a misc resource you allocated
 ;
 ;	No need to open the misc.resource


	    section CODE

	    xdef    _AutoAllocMiscResource
	    xdef    _AutoFreeMiscResource
	    xref    _LVOOpenResource

_AutoAllocMiscResource:
	    move.l  A6,-(sp)
	    bsr     OpenMiscResource
	    beq     amfail
	    move.l  8(sp),D0
	    move.l  12(sp),A1
	    jsr     -6(A6)
	    bra     amret
amfail	    moveq.l #-1,D0
amret	    move.l  (sp)+,A6
	    rts

_AutoFreeMiscResource:
	    move.l  A6,-(sp)
	    bsr     OpenMiscResource
	    beq     fmret
	    move.l  8(sp),D0
	    jsr     -12(A6)
fmret	    move.l  (sp)+,A6
	    rts

OpenMiscResource:
	    move.l  4,A6
	    lea.l   MiscName,A1
	    jsr     _LVOOpenResource(A6)
	    move.l  D0,A6
	    tst.l   D0
	    rts

MiscName:   dc.b    "misc.resource",0

	    END


