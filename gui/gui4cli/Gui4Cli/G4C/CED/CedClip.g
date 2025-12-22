G4C

;       CedClip.g - clipboard viewer
; --------------------------------------------------------

WINBIG 115 44 395 116 'Clipboard Viewer'
WinType 11110001
resinfo 8 640 256

xOnLoad
	setgad cedclip.g 11 hide ; hide 2nd lv

; --------------------------------------------------------
;       Change the clipboard unit
; --------------------------------------------------------
 
XICON 156 1 :icons/left
	attr resize 0000
	--cedbar.gc/cedClip
	gosub CedClip.g changeunit

XICON 225 1 :icons/right
	attr resize 0000
	++cedbar.gc/cedClip
	gosub CedClip.g changeunit

XTEXTIN 170 0 53 14 "" unit '0' 10
	attr resize 0000
	gadid 2
	gosub CedClip.g changeunit

xRoutine ChangeUnit
	; make sure the cedbar.gc/cedClip is 0-255
	if $cedbar.gc/cedClip > 255
	   cedbar.gc/cedClip = 0
	elseif $cedbar.gc/cedClip < 0
	   cedbar.gc/cedClip = 255
	endif
	; load the given clip..
	lvuse CedClip.g 1
	lvchange "CLIPS:$cedbar.gc/cedClip"

	; update the text gad
	update CedClip.g 2 $cedbar.gc/cedClip

	; and update cedbar.gc also..
	update cedbar.gc 1 $cedbar.gc/cedClip
	cedbar.gc/cedSend = "set clipboard unit "
	AppVar cedbar.gc/cedSend $cedbar.gc/cedClip
	SendRexx $cedbar.gc/cedport $cedbar.gc/cedSend

; --------------------------------------------------------
;       Load a file into the current clipboard unit
; --------------------------------------------------------

XICON 0 0 :icons/Open
	attr resize 0000
	ReqFile  -1 -1 300 -30 'Choose file :' LOAD filename ''
	if $filename > ''
	   lvuse CedClip.g 1
	   lvchange $filename
	   ; now save it so as to write it to the clipboard
	   lvsave 'CLIPS:$cedbar.gc/cedClip'
	endif

; --------------------------------------------------------
;       Save the current clipboard unit as a file
; --------------------------------------------------------

XICON 25 0 :icons/save
	attr resize 0000
	ReqFile  -1 -1 300 -30 'Save as file :' SAVE savename ''
	if $savename > ' '
	   ifexists file $savename
	      ezreq 'File $savename exists.\nOverwrite ?' Overwrite|CANCEL choice
	      if $choice = 0
	         stop
	      endif
	   endif
	   lvsave $savename
	endif

; --------------------------------------------------------
;       Clear the current clipboard unit
; --------------------------------------------------------

XICON 50 0 :icons/Clear
	attr resize 0000
	lvuse CedClip.g 1
	lvclear
	; update the clipboard
	lvsave 'CLIPS:$cedbar.gc/cedClip'

; --------------------------------------------------------
;       Cut 
; --------------------------------------------------------

XICON 75 0 :icons/cut
	attr resize 0000
	guiwindow cedclip.g wait
	setgad cedclip.g 1 hide ; hide for speed
	lvuse cedclip.g 11
	lvclear
	lvuse cedclip.g 1
	lvmulti first
	while $$lv.line > ''
	   lvclip cut 1 add cedclip.g 11
	   lvmulti next
	endwhile
	setgad cedclip.g 1 show
	lvmulti show
	; write it to the clipboard
	lvsave 'CLIPS:$cedbar.gc/cedClip'
	guiwindow cedclip.g resume

; --------------------------------------------------------
;       Copy
; --------------------------------------------------------

; almost same as above..
XICON 100 0 :icons/copy
	attr resize 0000
	guiwindow cedclip.g wait
	setgad cedclip.g 1 hide ; hide for speed
	lvuse cedclip.g 11
	lvclear
	lvuse cedclip.g 1
	lvmulti first
	while $$lv.line > ''
	   lvclip copy 1 add cedclip.g 11
	   lvmulti next
	endwhile
	setgad cedclip.g 1 show
	lvmulti show
	lvsave 'CLIPS:$cedbar.gc/cedClip'
	guiwindow cedclip.g resume

; --------------------------------------------------------
;       Paste - Insert records after CURRENT record
; --------------------------------------------------------

XICON 125 0 :icons/paste
	attr resize 0000
	guiwindow cedclip.g wait
	lvuse cedclip.g 11
	lvgo first
	lvclip copy -1 insert cedclip.g 1
	lvuse cedclip.g 1
	lvsave 'CLIPS:$cedbar.gc/cedClip'
	guiwindow cedclip.g resume

; --------------------------------------------------------
;       The listviews
; --------------------------------------------------------

XLISTVIEW 1 15 393 100 "" clipline CLIPS:0 10 MULTI
	gadid 1
	attr resize 0022

; hiden listview - use it as my clip holder
XLISTVIEW 0 21 393 141 "" lv11 '' 10 MULTI
	gadid 11



