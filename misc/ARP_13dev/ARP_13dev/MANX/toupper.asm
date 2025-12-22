	public	_LVOToupper
	public	_ArpBase

	public	_Toupper
_Toupper
	IF	INT32
	move.l	4(sp),d0
	ELSE
	move.w	4(sp),d0
	ENDC
	move.l	_ArpBase,a6
	jmp	_LVOToupper(a6)

	end
