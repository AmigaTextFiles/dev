G4C

; Helper routines etc for GCView.gc

; ------------------------------------------------------
; Palette changer
; ------------------------------------------------------

xRoutine InitPalette ; call  from xOnLoad
	; Initialise palette changer - look for palettes in same dir 
	; as gcview, if not found, use the palettes in guis:
	palette = 0
	extract gcview.g guipath mypath
	JoinFile $mypath Palettes PalPath
	lvuse #this 20
	ifexists dir ~$PalPath
		PalPath = guis:tools/palette
	endif
	lvdir #$PalPath

	; set WB palette if available
	ifexists screen Workbench
		palette get Workbench tempimage
		palette set tempimage GCView
		freeimage tempimage
	endif

XLISTVIEW 0 0 0 0 '' palfile '' 0 DIR
	gadid 20

xRoutine NextPalette
	lvuse #this 20
	lvmulti none
	lvgo #$palette
	if $$lv.line = ''
		palette = 0
		lvgo #0
	endif
	lvmulti on
	lvdir NoRefresh
	lvmulti first
	if $palfile H= 'G4C'
		guiload $palfile gcview.gc
	else
		palette load $palfile tempimage
		palette set tempimage GCView
		freeimage tempimage
	endif
	++palette

; ------------------------------------------------------
;	Start GCView
; ------------------------------------------------------

xRoutine StartGCView
	; start gcview - should be in the same dir as us
	ifexists port ~gcview
		ifexists file gcview
			run gcview
		else
			extract gcview.g guipath mypath
			joinfile $mypath gcview gcvname
			run $gcvname
		endif
		wait port gcview 30
		if $$retcode > 0
			ezreq 'Could not find & run GCView!\n' Abort ''
			guiquit gcview.gc
		endif
	endif

; ------------------------------------------------------
;	Open GCView & Init Screen position
;  - set gcview.gc/ scpos
; ------------------------------------------------------

xRoutine OpenGCView
	local scheight/barheight/tempvar/winheight
	scheight	 = 256	; defaults
	barheight = 12
	call gcview info pubscreen GCView
	tempvar = $$call.ret
	parsevar tempvar
	if $$parse.total > 3
		scheight	 = $$parse.3
		barheight = $$parse.5
	endif

	; open window right below menu bar & get actual height
	; changegad #this 0 -1 $barheight 0 95 '' ; doesn't work.. ?
	guiopen gcview.gc
	info gui gcview.gc
	winheight = $$win.h

	; move screen down..
	gcview.gc/scpos = $($scheight - $barheight - $winheight)
	movescreen gcview.gc 0 $gcview.gc/scpos
	call gcview set pointer on

  	update gcview.gc 27 'Time: $$sys.time[0][5]'

; ------------------------------------------------------
;	GETBOXSIZE - Get edit box size
;  - if no edit box drawn, use full pic size
;  - set gcview.gc/ x, y, w, h
; ------------------------------------------------------

xRoutine GetBoxSize
	local size

	; get edit box size
	call gcview info boxsize mypic
	size = $$call.ret
	parsevar size
	gcview.gc/x = $$parse.0
	gcview.gc/y = $$parse.1
	gcview.gc/w = $$parse.2
	gcview.gc/h = $$parse.3

	if $gcview.gc/w <= 0		; no box? - use full picture size
		call gcview info size mypic
		size = $$call.ret
		parsevar size
		gcview.gc/w = $$parse.0
		gcview.gc/h = $$parse.1
		gcview.gc/x = 0
		gcview.gc/y = 0
	endif

; ------------------------------------------------------
;	GETTYPE - Get File type: (NONE, PIC or ANIM)
;  - set gcview.gc/ type
; ------------------------------------------------------

xRoutine gettype
	local header
	readvar $gcview.gc/file 0 16 header		; read the header
	set deeptrans off
	; add here any other formats you have datatypes for
	gcview.gc/type = NONE
	docase $header
		case S= 'FORM????ILBM' ; IFF
		case S= "??????JFIF"	  ; JPEG
		case S= "ÿØÿÄ"			  ; JPEG
		case S= "GIF"			  ; GIF
		case S= "?PNG"			  ; PNG
			gcview.gc/type = PIC
			break
		case S= 'FORM????ANIM' ; ANIM
			gcview.gc/type = ANIM
	endcase
	set deeptrans on

; ------------------------------------------------------
; 	SHOWINFO - Update info display..
;  - set gcview.gc/ frtotal, frames
; ------------------------------------------------------

xroutine showinfo
	local info/oldtotal/frstart/frtotal/frcurr/name/loaded
	extract gcview.gc/file file name

	if $gcview.gc/type = ANIM
		call gcview info anim mypic
		info = $$call.ret
		parsevar info
		oldtotal = $gcview.gc/frloaded ; to know if it's changed
		frtotal	= $$parse.0
		frstart	= $$parse.1
		loaded   = $$parse.2
		frcurr   = $$parse.4

		if $loaded > 0
			update gcview.gc 10 '$frcurr\/$loaded $name ($frtotal)'
		else
			update gcview.gc 10 '$name : $frtotal'
		endif

		gcview.gc/start = $frstart

		; update sliders if No of frames has changed (new anim)..

		if $frtotal != $oldtotal
			changearg gcview.gc 3 7 $frtotal
			changearg gcview.gc 4 7 $frtotal
			redraw gcview.gc
		endif
		update gcview.gc 3 $frstart
		update gcview.gc 4 $loaded

	else
		update gcview.gc 10 '$gcview.gc/type : $name'

	endif

	gcview.gc/frloaded = $loaded
	gcview.gc/frtotal  = $frtotal
	gcview.gc/frames   = $loaded

; ------------------------------------------------------
;  TILE - if mirror=1 do mirror tile
; ------------------------------------------------------

xRoutine tilepic mirror
	local info
	guiwindow gcview.gc wait

	if $gcview.gc/type = ANIM
		if $mirror = 1
			call gcview tile mypic MIRROR
		else
			call gcview tile mypic
		endif

	else
		; if there is a box, get size and crop it..
		call gcview info boxsize mypic
		info = $$call.ret
		parsevar info
		if $$parse.2 > 0
			call gcview crop mypic
		endif

		call gcview rename mypic brush
		call gcview create mypic 640 512 8
		call gcview open mypic
		call gcview close brush
		call gcview set palette mypic brush
		if $mirror = 1
			call gcview tile brush mypic MIRROR
		else
			call gcview tile brush mypic
		endif
		call gcview unload brush
	endif

	guiwindow gcview.gc resume
	guiscreen gcview.gc front

; -----------------------------------------------------------
;	4 way mirror tile (for making bgnd patterns)
; -----------------------------------------------------------

xRoutine 4waymirrtile
	local size/depth/sw/sh

	if $gcview.gc/type = ANIM
		flash ; not for anims..
		stop
	endif

	; get sizes
	call gcview info size mypic
	size = $$call.ret
	parsevar size
	depth = $$parse.2

	gosub gcview.g getboxsize
	sw == $gcview.gc/w * 2
	sh == $gcview.gc/h * 2

	; prepare background for tiling..
	call gcview rename mypic brush
	call gcview create mypic $sw $sh $depth
	call gcview open mypic
	call gcview close brush
	call gcview set palette mypic brush

	; paste & flip & paste...
	call gcview paste brush mypic 0 0
	call gcview flip brush horizontal
	call gcview paste brush mypic $gcview.gc/w 0
	call gcview flip brush vertical
	call gcview paste brush mypic $gcview.gc/w $gcview.gc/h
	call gcview flip brush horizontal
	call gcview paste brush mypic 0 $gcview.gc/h

	; finished..
	call gcview unload brush
	guiscreen gcview.gc front

; -----------------------------------------------------------
;	BUILD full size pic - use marked area to fill blank part
; -----------------------------------------------------------

xRoutine BuildPic
	local size/depth/width/sw/sh/w

	if $gcview.gc/type = ANIM
		flash ; not for anims..
		stop
	endif

	; store the marked area
	gosub gcview.g getboxsize
	sw = $gcview.gc/w
	sh = $gcview.gc/h
	call gcview copy mypic myclip

	; get pic size & depth
	call gcview info size mypic
	size = $$call.ret
	parsevar size
	width = $$parse.0
	depth = $$parse.2

	; prepare background..
	call gcview rename mypic brush
	call gcview create mypic 640 512 $depth
	call gcview open mypic
	call gcview close brush
	call gcview set palette mypic brush
	call gcview paste brush mypic 0 0
   call gcview unload brush

   ; paste brush the right way
	w = $($width + $sw)
   while $w < 640
		call gcview paste myclip mypic $w 0
		w = $($w + ($sw * 2))
	endwhile

	; flip & paste between
	call gcview flip myclip horizontal
	w = $width
   while $w < 640
		call gcview paste myclip mypic $w 0
		w = $($w + ($sw * 2))
	endwhile

	; finished..
	call gcview unload myclip
	guiscreen gcview.gc front

; -----------------------------------------------------------
;	SAVE - pic/anim
; -----------------------------------------------------------

xRoutine Save
	local fname/fileline/savename

	if $gcview.gc/file > ' '		; file name for reqfile
		fname = $gcview.gc/file
	else
		fname = T:GCPic
	endif

	; store the current line in lv, so we can go back to it
	lvuse gcview.gc 1
	fileline = $$lv.line

	savename = ''
	call gcview move pubscreen GCView 0 15
	ReqFile -1 -1 300 -40 'Save current picture:' SAVE savename #$fname
	call gcview move pubscreen GCView 0 $gcview.gc/scpos

	if $savename > ''
		ifexists file $savename
			ezreq 'File already exists:\n- $savename\nOverwite ?' OverWrite|Cancel choice
			if $choice = 0
				stop ; user cancelled
			endif
		endif
		guiwindow gcview.gc wait
		call gcview save mypic '$savename'
		gcview.gc/lastfileloaded = $savename
		guiwindow gcview.gc resume

		; refresh the dir, and go to previously current line
		lvdir refresh
		lvmove #$fileline
		lvgo #$fileline
		lvmulti on
	endif

; -----------------------------------------------------------
;	SHOWFILE
; -----------------------------------------------------------

xRoutine showfile
	gosub gcview.g gettype

	if $gcview.gc/type  != NONE			; Picture
	and $gcview.gc/type != ANIM
		if $gcview.gc/dmode = BG			; normal background
			call gcview info size mypic
			if $$call.ret = ''	; no pic yet..
				call gcview load $gcview.gc/file mypic
				call gcview open mypic
			else

				call gcview rename mypic oldpic
				call gcview load $gcview.gc/file mypic
				call gcview open mypic
				call gcview unload oldpic
				
				; #### COMMENTED OUT - NO Fade..
				; call gcview rename mypic oldpic
				; call gcview load $gcview.gc/file mypic
				; if $$retcode > 0					; no memory..
					; call gcview unload oldpic
					; call gcview load $gcview.gc/file mypic
					call gcview open mypic
				; else
					; call gcview open mypic behind
					; call gcview tranzit oldpic mypic FADE 3
					; call gcview unload oldpic
				; endif

			endif
			if $gcview.gc/usepalette = ON
				call gcview set palette mypic mypal
			endif
			gcview.gc/bgdir = $$lv.dir
			gosub gcview.g showinfo
		elseif $gcview.gc/dmode = BR		; paste brush mode
			gosub GCVIEW.GC pastebrush
		endif

	elseif $gcview.gc/type = ANIM
		if $gcview.gc/dmode = BG
			gcview.gc/bgdir = $$lv.dir
			gosub #this playanim 0			; 0=load as many frames as posible
			if $gcview.gc/usepalette = ON
				call gcview set palette mypic mypal
			endif
			gosub gcview.g showinfo
		else										; paste anims onto each other
			gosub GCVIEW.GC pastebrush
		endif

	else
		; use default gui to handle file
		guiload guis:tools/rtn/filepop $gcview.gc/file
		gosub gcview.g showinfo
	endif

; -----------------------------------------------------------
;	PASTEBRUSH - paste brush into edit box
; -----------------------------------------------------------

xroutine pastebrush
	local bname

	bname = ''
	movescreen gcview.gc 0 12
	ReqFile -1 -1 350 -30 'Choose brush:' LOAD bname '.Art:'
	movescreen #this 0 $gcview.gc/scpos
	if $bname = ''
		stop
	endif

	if $bname H= 'FORM????ANIM' ; ANIM
		call gcview anload $bname brush 0 1000 FORWARD
	else
		call gcview load $bname brush
	endif
	; store dir
	extract bname path gcview.gc/brushdir

	; get edit box size
	gosub gcview.g getboxsize

	; adjust & paste brush
	call gcview resize brush $gcview.gc/w $gcview.gc/h
	call gcview paste brush mypic $gcview.gc/x $gcview.gc/y
	call gcview unload brush
	guiscreen gcview.gc front

; -----------------------------------------------------------
;	PLAYANIM
; -----------------------------------------------------------

xRoutine playanim userange			; play anim - if userange=1, use the
	;local userange

	call gcview unload mypic		; start/frame values as set

	if $gcview.gc/loadall == ON
		if $userange = 1
			call gcview anload $gcview.gc/file mypic $gcview.gc/start $gcview.gc/frames $gcview.gc/andir
		else
			call gcview anload $gcview.gc/file mypic 0 1000 $gcview.gc/andir
		endif
	else
		call gcview load $gcview.gc/file mypic
	endif

	call gcview open mypic
	guiscreen gcview.gc front

; -----------------------------------------------------------
;	RAW & VANILLA KEYs
; -----------------------------------------------------------

xRoutine dorawkey
	docase $$rawkey.code
		case = 78							; right arrow - inc speed
			call gcview set speed mypic +1
			break
		case = 79							; left arrow  - dec speed
			call gcview set speed mypic -1
			break
		case = 76							; up arrow    - next frame
			call gcview set frame mypic +1
			gosub gcview.g showinfo
			break
		case = 77							; down arrow  - prev frame
			call gcview set frame mypic -1
			gosub gcview.g showinfo
			break
	endcase

xRoutine dovankey
	docase $$vankey.code
		case = 13							; next pic
		case = 32
			gosub gcview.gc ViewNext
			break
	endcase

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	NEWFILE gettext	; get a string

; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
; &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

WINBIG 13 11 617 21 "Enter or alter text:"
WinType 11110010
usetopaz
BOX 0 0 0 0 out button

xOnOpen
	setgad getstring 1 ON

XTEXTIN 3 3 490 15 "" string "" 1000
	attr resize 0022
	gadid 1
	; guiclose #this
	; gosub #this txtpaste

XBUTTON 495 3 28 15 "Tx"	; load text
	attr resize 2002
	local tc
	txtfile = ''
	movescreen #this 0 12
	ReqFile -1 -1 350 -30 'Choose text:' LOAD txtfile 'EH2:store/wrd'
	if $txtfile > ''
		ifexists file ~$txtfile				; correct ending space (old)
			cutvar txtfile cut char -1 tc
			appvar txtfile ' $tc'
		endif
		copy $txtfile env:.txtfile
		update #this 1 '$.txtfile'
	endif
	movescreen #this 0 $gcview.gc/scpos

XBUTTON 525 3 28 15 "Kb"	; Keyboard
	attr resize 2002
	guiload s:gui/keybd.g
	
XBUTTON 555 3 28 15 "Sv"	; Save
	attr resize 2002
	local c
	if $string > ''
		dir = ''
		ReqFile -1 -1 300 -60 'Save in which dir?' DIR dir "EH2:store/wrd"
		guiclose #this
		if $dir > ''
			.dummy = "$string"
			; make file name - discard ending spaces
			name = $string[0][30]
			extract name clean name
			JoinFile $dir "$name" name
			copy env:.dummy $name
			copy env:.dummy ram:.SENTENCE
		else
			flash
		endif
	endif

XBUTTON 585 3 28 15 "Ok"	; finished editing
	attr resize 2002
	gosub #this txtpaste

xRoutine txtpaste
	local bright/dark
	guiscreen #this back
	call gcview getcolor mypic 200 200 200
	bright = $$call.ret
	cutvar bright cut word 1 bright
	call gcview getcolor mypic 50 50 50
	dark = $$call.ret
	cutvar dark cut word 1 dark
	call gcview set pens $bright $dark OUTLINE
	gosub gcview.g GetBoxSize
	call gcview text mypic $gcview.gc/x $gcview.gc/y '$string'
	guiclose #this

