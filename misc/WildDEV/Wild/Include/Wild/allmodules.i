	IFND	WildAllMods
WildAllMods	SET	1

_LVOSetModuleTags	EQU	-30	; a0 wapp 	a1 tags
_LVOGetModuleTags	EQU	-36	; a0 wapp	a1 tags
_LVOSetupModule		EQU	-42	; a0 wapp	
_LVOCloseModule		EQU	-48	; a0 wapp
_LVORefreshModule	EQU	-54	; a0 wapp

	include	wild/display.i
	include	wild/tdcore.i
	include	wild/light.i
	include	wild/fx.i
	include	wild/draw.i
	include	wild/sound.i
	include	wild/music.i

	ENDC	