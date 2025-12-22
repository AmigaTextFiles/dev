	public	_LVOPrintf
	public	_ArpBase

	public	_Printf
_Printf
	move.l	4(sp),a0
	lea.l	8(sp),a1
	move.l	_ArpBase,a6
	jmp	_LVOPrintf(a6)

	end

