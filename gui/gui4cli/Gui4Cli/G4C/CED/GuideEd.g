G4C

WINBIG 620 24 25 114 'AG'
WinType 010000
usetopaz
varpath cedbar.gc

xOnLoad
	guiopen #this

xOnReload
	guiopen #this

xOnRMB
	GuiClose #this

; -----------------------------------------------------
;	Edit guide
; -----------------------------------------------------

XICON 0 0 ":icons/AGNew"
	gadid 11
	guiload :addnode.g GUIDE

XICON 0 14 ":icons/AGNode"
	gadid 11
	guiload :addnode.g NODE

XICON 0 42 ":icons/AGLink"
	gadid 11
	guiload :addlink.g

XICON 0 28 ":icons/AGfx"
	gadid 11
	guiload :addeffect.g

XICON 0 56 ":icons/AGClear"
	gadid 11
	; cut the selected text into our lv
	SendRexx $cedport cut
	lvuse CedClip.g 1
	lvchange 'CLIPS:$cedClip'
	; ask the CedHandler program to process it
	call LVFormat agclean

	; paste it back into ced
	lvsave 'CLIPS:$cedClip'
	SendRexx $cedport paste

; -----------------------------------------------------
;	View guide
; -----------------------------------------------------

XICON 0 72 ":icons/eye"
	gadid 11
	guiwindow cedmark.g wait
	;  close previous window & file, if any
	ifexists port CEDGUIDE
	   sendrexx CEDGUIDE QUIT
	endif
	; get current file name
	sendrexx $cedport 'status filename'
	filename = $$rexxret
	; save file if it's been changed
	sendrexx $cedport 'status numchanges'
	if $$rexxret > 0
	   sendrexx $cedport 'save'
	endif
	; load into lv, make it a node, save as tempnode & show it
	lvuse cedbar.gc 20
	lvchange $filename
	lvgo first
	if $$lv.rec[0][5] == "@data"
	   ; if it's a node add the @database stuff..
	else
	   lvinsert -1 '@database Test\n@node MAIN "Main"\n'
	   lvadd '@endnode\n'
	endif
	lvsave t:tempnode
	run 'amigaguide t:tempnode screen=$cedscreen port=CEDGUIDE'
	guiwindow cedmark.g resume

; -----------------------------------------------------
;	Join/Split guide
; -----------------------------------------------------

XICON 0 88 ":icons/AGSplit"
	gadid 11
	guiload :splitguide.g

XICON 0 102 ":icons/AGJoin"
	gadid 11
	guiload :joinguide.g


