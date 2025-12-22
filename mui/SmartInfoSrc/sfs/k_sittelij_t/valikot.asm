*-----------------------------------------------*
*	@AvaaTiedotjaIkkuna			*
*-----------------------------------------------*

AvaaTietojaIkkuna:
	GETSTR	MSG_TRANSLATOR
	move.l	d0,(a4)
	GETSTR2	MSG_ABOUT
	move.l	d0,a2
	bra	InfoRequester

*-----------------------------------------------*
*	@AvaaAsetusIkkuna			*
*-----------------------------------------------*

AvaaAsetusIkkuna:
	move.l	intui(a4),a6
	move.l	WI_PrefsWindow-t(a5),a0
	SETI	MUIA_Window_Open,TRUE
.x	rts
