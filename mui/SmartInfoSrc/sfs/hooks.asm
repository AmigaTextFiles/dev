Hook_MuotoileLaiteLista:
	ds.b	MLN_SIZE
	dc.l	MuotoileLaiteLista,0,0

Hook_J‰rjest‰LaiteLista:
	ds.b	MLN_SIZE
	dc.l	J‰rjest‰LaiteLista,0,0

Hook_AktiivinenLaite:
	ds.b	MLN_SIZE
	dc.l	AktiivinenLaite,0,0

Hook_Suorita_SFScheck:
	ds.b	MLN_SIZE
	dc.l	Suorita_SFScheck,0,0

Hook_Eheyt‰_SFS:
	ds.b	MLN_SIZE
	dc.l	Eheyt‰_SFS,0,0

Hook_Switch_Defrag:
	ds.b	MLN_SIZE
	dc.l	SwitchDefrag,0,0

Hook_SuljeDefrag:
	ds.b	MLN_SIZE
	dc.l	SuljeDefrag,0,0

Hook_Start_Defrag:
	ds.b	MLN_SIZE
	dc.l	StartDefrag,0,0

Hook_Abort_Defrag:
	ds.b	MLN_SIZE
	dc.l	AbortDefrag,0,0

Hook_Prefs_Save:
	ds.b	MLN_SIZE
	dc.l	SavePrefs,0,0

Hook_Prefs_Use:
	ds.b	MLN_SIZE
	dc.l	UsePrefs,0,0

Hook_Prefs_Cancel:
	ds.b	MLN_SIZE
	dc.l	CancelPrefs,0,0
