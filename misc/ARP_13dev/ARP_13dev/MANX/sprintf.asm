	public	_LVOSPrintf
	public	_ArpBase

	public	_SPrintf
_SPrintf
	movem.l 4(sp),d0/a0             ; file, format string
	lea.l	12(sp),a1               ; data stream
	move.l	_ArpBase,a6
	jmp	_LVOSPrintf(a6)

	end

