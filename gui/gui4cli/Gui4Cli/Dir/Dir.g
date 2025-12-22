G4C  

; This file contains the 3 pop-up on Right-Mouse-Button click GUIs.

; ==================================================================
; The 1st RMB pop-up gui (name = dir.g)
; ==================================================================

WinBig 0 0 80 105 ""
WinType 00001000
winonmouse 30 22 
varpath dir.gc
resinfo 8 640 256

xOnRMB 
	guiclose Dir.g

xOnInactive
	guiclose Dir.g

xOnOpen				; upon opening the window
	id = $$lv.id			; get the listview's id
	if $id < 1
	   id = 1
	endif
	if $id = 2			; set the copy/move gadgets pointing
	   setgad Dir.g 1 HIDE	        ; correctly according to the LV's id.
	   setgad Dir.g 2 HIDE
	   setgad Dir.g 11 show
	   setgad Dir.g 22 show
	   destid  = 1          	; store destination lv id
	else
	   setgad Dir.g 11 HIDE
	   setgad Dir.g 22 HIDE
	   setgad Dir.g 1 show
	   setgad Dir.g 2 show
	   destid = 2
	endif
	redraw Dir.g
	lvuse dir.gc $destid		; use the destination lv
	destdir = $$lv.dir		; store the destination dir
	lvuse dir.gc $id		; restore the source lv

;=============================== Next GUI button

xbutton 0 0 0 15 More..
	guiopen Dir.g3			; open an other gui with more options
	guiclose Dir.g

;=============================== copy button

xbutton 0 15 0 15 Copy->
	gadhelp 'Copy files from LEFT to RIGHT listview'
	gadid 1
	gosub Dir.g copy

xbutton 0 15 0 15 <-Copy
	gadhelp 'Copy files from RIGHT to LEFT listview'
	gadid 11
	gosub Dir.g copy

xroutine copy
	guiclose Dir.g
	lvaction copy $destdir		      	; copy all selected files/dirs
	lvuse dir.gc $destid
	lvdir refresh       			; refresh destination

;============================= copy new files (same logic as copy)

xbutton 0 30 0 15 "Copy New"
	gadhelp 'Only copy newer files'
	guiclose Dir.g
	lvaction copynew $destdir		; same as copy, above
	lvuse dir.gc $destid
	lvdir refresh

;=============================== Move (same logic as copy)

xbutton 0 45 0 15 Move->
	gadhelp 'Move selected files'
	gadid 2
	gosub Dir.g move

xbutton 0 45 0 15 <-Move
	gadhelp 'Move selected files'
	gadid 22
	gosub Dir.g move

xroutine move
	guiclose Dir.g
	lvaction move $destdir
	lvuse dir.gc $destid
	lvdir refresh


;============================== delete

xbutton 0 60 0 15 Delete
	gadhelp 'Delete selected Files/Directories'
	guiclose Dir.g
	lvaction delete REQ


;============================= rename
; This routine reads the dir listview in the normal first/next method
; using the lvmulti command and passes the files to guis:tools/rtn/GetString
; GetString calls the routine "ren" for every file..

xbutton 0 75 0 15 Rename
	gadhelp 'Rename selected files'
	guiclose Dir.g
	lvuse dir.gc $id
	lvmulti first              ; get the first record
	renfile = $dir.gc/lv_file  ; store name to be safe
	if $renfile > ' '
	   guiload guis:tools/rtn/GetString "Rename $renfile :" "$renfile" dir.g ren multi
	endif

xRoutine ren newname
	rename $renfile $newname
	lvuse dir.gc $id
	lvmulti off
	extract newname file newname
	lvput $newname
	lvmulti next               ; get the next record
	renfile = $dir.gc/lv_file  
	if $renfile > ' '
	   guiload guis:tools/rtn/GetString "Rename $renfile :" "$renfile" dir.g ren multi
	else
	   lvdir refresh
	   guiquit GetString
	endif


;============================== makedir

xbutton 0 90 0 15 MakeDir
	gadhelp 'Create a Directory'
	tempdir = $$lv.dir
	if $tempdir[-1][1] = ":"     ; add the / if not a device
	or $tempdir[-2][2] = ':\"'   ; taking care of quotes
	   ;
	elseif $tempdir[-1][1] = '\"'
	   tempdir[-1][1] = '/'
	   appvar tempdir '\"'
	else
	   appvar tempdir '/'
	endif
	guiload guis:tools/rtn/GetString "Create Directory:" "$dir.g/tempdir" dir.g mkdir

xroutine mkdir     ; called by getstring as above
	makedir $$arg.0
	lvdir refresh      ; hoping it's still the same listview..


; ==================================================================
;###################################################################
; ==================================================================
NEWFILE dir.g3    ; The more.. gui (from the RMB pop-up gui)
; ==================================================================


WinBig 0 0 160 105 ""
WinType 00001000
winonmouse 50 8 
resinfo 8 640 256
varpath dir.gc/cli.gc/fsearch.gc

xOnRMB 
	guiclose Dir.g3

xOnInactive
	guiclose Dir.g3

xOnOpen
	id = $$LV.ID     	  ; Get the id of the current lvdir

xOnClose
	setwintitle dir.g3 ""     ; because ezreq will change the wintitle..


;================================ buttons (left bank)

xbutton 0 0 40 15  <<		; previous
	guiopen dir.g
	guiclose dir.g3

xbutton 40 0 40 15  >>		; next
	guiopen dir.g4
	guiclose dir.g3

xbutton 0 15 80 15 View
  gadhelp 'View selected files according to their type'
  guiclose dir.g3
  ; look for a user-defined gui named "viewer.g"
  extract dir.gc path dirpath
  joinfile $dirpath "usr/viewer.g" viewgui
  ifexists file $viewgui
     guiload $viewgui dir.gc $id
  else
     lvuse dir.gc $id
     lvmulti first
     while $lv_file > ""
        guiload guis:tools/rtn/getfiletype $dir.gc/lv_file
        filetype = $$ret.0
        if $filetype != NONE
           guiload guis:tools/rtn/ViewFile $dir.gc/lv_file $dir.g3/filetype CLI
        endif
        lvmulti next
     endwhile
  endif


xbutton 0 30 80 15 Protect
	gadhelp 'Protect selected files'
	guiclose dir.g3
	guiload  :dir.prot
	guiopen  dir.prot

xbutton 0 45 80 15 Size
	gadhelp 'Show & sum size of selected items'
	guiclose dir.g3
	lvuse dir.gc $id
	lvaction SIZE lv_size
	SetWinTitle dir.gc '$lv_size bytes of $$lv.dir'

xbutton 0 60 80 15 Assign
	gadhelp 'Assign Current directory'
	tempdir = $$lv.dir
	guiclose dir.g3
	guiload guis:tools/rtn/GetString "Assign $dir.g3/tempdir as:" "" dir.g3 asn

xroutine asn        ; called by getstring as above
	assign $$arg.0 $tempdir

xbutton 0 75 80 15 'CliGui'
	gadhelp 'Open Guis:tools/cli.gc'
	cd $$lv.dir
	guiclose dir.g3
	guiload guis:tools/cli.gc  "" CLI  ; will open itself

xbutton 0 90 80 15 Shell
	gadhelp 'Open a new Shell'
	guiclose dir.g3
	cd $$LV.DIR
	run 'newshell $$g4c.output'


; ------------------ Buttons right bank

xbutton 80  0 80 15 User..
	gadhelp 'Open the Dir/Dir.user pop-up gui'
	guiload :dir.user
	guiclose dir.g3

xbutton 80 15 80 15 Search
	gadhelp 'Search for files and/or text in current dir'
	guiclose dir.g3
	; store it here, because gui has lv and will loose it..
	spath = $$lv.dir
	guiload guis:g4c/fsearch/fsearch.gc $dir.g3/spath

xbutton 80 30 80 15 Replace
	gadhelp 'Replace text in selected files'
	guiclose dir.g3
	guiload  :dir.rep
	guiopen  dir.rep

xbutton 80 45 80 15 ReWrap
	gadhelp 'Re-Wrap selected files'
	guiclose dir.g3
	guiload :dir.wrap

xbutton 80 60 80 15 "AddIcon"
	gadhelp 'Add icons (if icon for file type exists in guis:tools/icons/def)'
	guiclose dir.g3
	lvuse dir.gc $id
	lvmulti first
	while $lv_file > ''
	   if $lv_file[-1][1] = '\"'  ; care for possible quotes
	      fname = $lv_file
	      fname[-1][1] = '.'
	      fname = '$fname\info\"'
	   else
	      fname = $lv_file\.info
	   endif
	   if $$lv.type == DIR
	      copy guis:tools/icons/def/DRAWER.info $fname
	   else
	      guiload guis:tools/rtn/getfiletype $dir.gc/lv_file
	      filetype = $$ret.0
	      infoname = "guis:tools/icons/def/$filetype\.info"
	      ifexists file $infoname
	         copy $infoname $fname
	      endif
	   endif
	   lvmulti off
	   lvmulti next
	endwhile
	lvdir refresh

xbutton 80 75 80 15 "Select"
	guiload guis:tools/rtn/GetString "Enter substring to select:" "" dir.g3 select

xroutine select     ; called by select as above
	guiclose dir.g3
	pat = $$arg.0
	lvsearch '$pat' ci first
	while $$lv.line > ''
	   lvmulti on
	   lvsearch '$pat' ci next
	endwhile

xCycler 80 90 80 15 '' sortmode
	cstr Normal NORMAL
	cstr Date	DATE
	cstr Size	SIZE
	cstr Type	EXTENTION
	set lvsort $sortmode
	lvuse dir.gc 1
	lvdir refresh
	lvuse dir.gc 2
	lvdir refresh
	lvuse dir.gc $id


;#########################################################################

; ==================================================================
NEWFILE dir.g4    ; The more->more.. gui (from the RMB pop-up gui)
; ==================================================================

WinBig 0 0 160 105 ""
WinType 00001000
winonwin Dir.g3 0 0 
resinfo 8 640 256
varpath dir.gc

xOnRMB 
	guiclose Dir.g4

xOnInactive
	guiclose Dir.g4


;================================ buttons (left bank)

xbutton 0 0 80 15  <<
	guiopen dir.g3
	guiclose dir.g4

xbutton 0 15 80 15 Calc
	gadhelp 'Load Guis:tools/calc.gc'
	guiclose dir.g4
	guiload guis:tools/calc.gc

xbutton 0 30 80 15 Lock
	gadhelp 'Load Guis:tools/lock.gc'
	guiclose dir.g4
	guiload :dir.lock

xbutton 0 45 60 15 PPShow
	gadhelp 'View selected files using c:ppshow'
	guiclose dir.g4
	guiload :dir.ppshow

xbutton 60 45 20 15 ?
	gadhelp 'Open Gui for the PPShow graphics player'
	guiclose dir.g4
	guiload :dir.ppshow

xbutton 0 60 80 15 'Palette'
	gadhelp 'Opens the Palette gui'
	guiclose dir.g3
	guiload  guis:tools/palette.gc

xbutton 0 75 80 15 GfxCon
	gadhelp 'Opens gui for GfxCon picture converter'
	guiclose dir.g4
	guiload :dir.gfxcon

xbutton 0 90 80 15 Avail
	gadhelp 'Opens Gui for showing memory usage'
	guiclose dir.g4
	guiload :dir.avail

; ------------------ Buttons right bank

xbutton 80  0 80 15 'LHa Pack'
	gadhelp 'Pack Selected files with LhA'
	guiclose dir.g4
	guiload :dir.lha

xbutton 80 15 80 15 'XPK'
	gadhelp 'Load gui for XPK packers'
	guiclose dir.g4
	guiload :dir.xpack

xbutton 80 30 80 15 "ZIP"
	gadhelp 'Pack Selected files with ZIP'
	guiclose dir.g4
	guiload :dir.zip

xbutton 80 45 80 15 "GuiEdit"	; start up a gui editor kind of thing..
	gadhelp "Open gui with gadgets for copying (it'll get better..)"
	guiclose dir.g4
	guiload guis:tools/guiedit.gc
	guiopen guiedit.gc

xbutton 80 60 80 15 Config
	gadhelp 'Loads the configuration gui'
	guiclose dir.g4
	guiload guis:tools/config.gc

xbutton 80 75 80 15 Help
	gadhelp 'Loads the dir.gc guide'
	extract dir.gc guipath lv_path
	joinfile $lv_path dir.guide lv_guide
	run '$*DEF.GUIDE $lv_guide'
	delvar lv_path
	delvar lv_guide

xbutton 80 90 80 15 Quit
	guiclose dir.g4
	ezreq "QUIT ???!!..\nWho, me ?\n" 'DIE!|Well..' lv_ask
	if $lv_ask = 1
	   guiquit dir.gc
	endif

; the pop-up on double-click guis have been moved to file guis:dir/dir.g2



