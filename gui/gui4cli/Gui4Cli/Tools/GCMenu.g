G4C

; -----------------------------------------------------------------
; A general purpose menu which can be shared among guis
; -----------------------------------------------------------------

xMenu Project 'New Gui..' '' N          ; new gui
	guiload guis:tools/guiedit.gc
	gosub guiedit.gc newfile
	if $$ret.0 = 1                          ; a gui was chosen
	   guiopen guiedit.gc
	endif

xmenu Project Gui.. '' ''               ; use the status requester
	status

xMenu Project BARLABEL '' ''

xMenu Project #guis:Gui4Cli '' ''
	ezreq 'Gui4Cli\n(c)1995-98 D.Keletsekis\ndck@hol.gr' 'OK' ''

xMenu Project 'Quit Gui4Cli' '' ''
	quit

; --------------- guis menu


xMenu Guis "File Manager   " '' ''
	guiload guis:dir/dir.gc
	guiopen dir.gc

xMenu Guis FSearch.gc '' ''
	guiload guis:g4c/fsearch/fsearch.gc Sys:

xMenu Guis Rep.gc '' ''
	guiload guis:g4c/rep.gc

xMenu Guis CedBar.gc '' ''
	guiload guis:g4c/ced/cedbar.gc

xMenu Guis "BARLABEL" '' ''

xMenu Guis Demo '' ''
	guiload guis:demo.gc
	guiopen demo.gc

xMenu Guis Tutorials '' ''
	guiload guis:docs/tutorials.gc
	guiopen tutorials.gc

; --------------- Help menu

xMenu Help "Gui4Cli Guide " '' ''
	run 'multiview guis:docs/gui4cli.guide'

xMenu Help "BARLABEL" '' ''

xMenu Help "Gui4Cli ReadMe" '' ''
	guiload guis:tools/read.gc guis:readme.now

xMenu Help "Command List" '' ''
	guiload guis:tools/read.gc guis:docs/PrintMe

xMenu Help "Version Changes" '' ''
	guiload guis:tools/read.gc guis:docs/Changes

xMenu Help "BARLABEL" '' ''

xMenu Help "CLI Commands Guide  " '' ''
	run 'multiview guis:docs/CLICommands.guide'

xMenu Help "Routines Guide" '' ''
	run 'multiview guis:docs/Routines.guide'

xMenu Help "BARLABEL" '' ''

xMenu Help Tutorials.. '' ''
	guiload guis:docs/tutorials.gc
	guiopen tutorials.gc

