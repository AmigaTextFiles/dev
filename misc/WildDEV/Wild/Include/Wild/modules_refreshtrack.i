	STRUCTURE	RefreshTrack,0
		APTR	rt_Actual		; Taglist with Actual tags
		APTR	rt_Precedent		; Taglist with Precedent tags
		LABEL	rt_SIZE
				
; Changed is initialized to a empty taglist (with all supported tags)
; Actual is initialized to a copy of wap_Tags at start (with only supported tags)
; When SetModuleTags(Wapp,New)
; Actual is changed according to New.
; New is Filtered, becomes NewChanges.

; a2:RefreshTrack struct,A3:NewTags,A6:UtyBase	
TrackRefresh	movea.l	a3,a1
		movea.l	rt_Actual(a2),a0
		Call	ApplyTagChanges
		rts

; a2:RefreshTrack struct (empty),A6:UtyBase
InitTrack	bsr	FreeTrack
		lea.l	Supported,a0
		Call	CloneTagItems
		move.l	d0,rt_Actual(a2)
		movea.l	d0,a0
		Call	CloneTagItems
		move.l	d0,rt_Precedent(a2)
		rts

; a2:RefreshTrack struct,A6:UtyBase
ReInitTrack	movea.l	rt_Actual(a2),a1
		movea.l	rt_Precedent(a2),a0
		Call	RefreshTagItemClones
		rts

; a2:RefreshTrack struct,A6:UtyBase. RETURNS A TAGLIST IN A0: YOU MUST FREE IT !
HaveChanges	movea.l	rt_Actual(a2),a0
		Call	CloneTagItems
		movea.l	d0,a0
		movea.l	rt_Precedent(a2),a1
		movea.l	d0,a2
		moveq.l	#-1,d0
		Call	FilterTagChanges
		movea.l	a2,a0
		rts
	
; a2:RefreshTrack struct,a6:UtyBase
FreeTrack	move.l	rt_Actual(a2),d0
		beq.b	.noa
		movea.l	d0,a0
		Call	FreeTagItems
.noa		move.l	rt_Precedent(a2),d0
		beq.b	.noc
		movea.l	d0,a0
		Call	FreeTagItems
.noc		rts

