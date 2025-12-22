	public	_LVOFPrintf
	public	_ArpBase

	public	_FPrintf
_FPrintf
	movem.l 4(sp),d0/a0		; file, format string
	lea.l	12(sp),a1		; data stream
	move.l	_ArpBase,a6
	jmp	_LVOFPrintf(a6)

	end

