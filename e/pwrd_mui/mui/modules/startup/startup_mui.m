GOPT	HEAD='startup_mui.o'

MODULE	'dos','exec','intuition','graphics','muimaster'

EDEF	ExecBase:PTR TO ExecBase,
		DOSBase:PTR TO Lib,
		IntuitionBase:PTR TO Lib,
		GfxBase:PTR TO Lib,
		MUIMasterBase:PTR TO Lib,
		arg:PTR TO CHAR,stdout,stdin,
		wbmessage

CONST	MUI_TRUE=1
