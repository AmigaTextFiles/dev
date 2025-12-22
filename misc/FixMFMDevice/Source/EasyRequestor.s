;a1=body, a4=argsstack
DoOkEZReq	Lea	OKText(pc),a2

;a1=body, a2=buttons a4=argsstack

DoEZReq		Lea	EZReqTaglist(PC),a0
DoEZReqTag	Move.l	EZReqMem(a5),a3
		Move.l	_RTBase(a5),a6
		Jump	RTEzrequesta
