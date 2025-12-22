G4C

; gui to create a new node or guide

WINBIG 299 24 306 180 AddNode.g
WinType 11110001
resinfo 8 640 256

BOX 0 0 305 130 OUT button
BOX 0 130 305 25 OUT button
BOX 0 155 305 25 OUT button

xOnLoad mode name ; = NODE or GUIDE
gosub addnode.g getname
gosub addnode.g startup

xonreload mode name
gosub addnode.g getname
gosub addnode.g startup

; -------------------------------------------------------
;       get fields
; -------------------------------------------------------

XTEXTIN 70 5 225 14 "Title" title "" 100
gadid 1
SetGad addnode.g 2 ON

XTEXTIN 70 5 225 14 "Author" author "" 100
gadid 11
SetGad addnode.g 12 ON

; -------------------------------------------------------

XTEXTIN 70 20 200 14 "Next" next "" 100
gadid 2
SetGad addnode.g 3 ON

XICON 270 20 :icons/open
gadid 21
ReqFile -1 -1 300 -36 "Select node:" LOAD next '#$path'
update addnode.g 2 '$next'

XTEXTIN 70 20 225 14 "(C)" copyright "" 100
gadid 12
SetGad addnode.g 13 ON

; -------------------------------------------------------

XTEXTIN 70 35 200 14 "Prev"  prev "" 100
gadid 3
SetGad addnode.g 4 ON

XICON 270 35 :icons/open
gadid 22
ReqFile -1 -1 300 -36 "Select node:" LOAD prev '#$path'
update addnode.g 3 '$prev'

XTEXTIN 70 35 225 14 "Version" version "" 100
gadid 13
SetGad addnode.g 4 ON

; -------------------------------------------------------

XTEXTIN 70 50 200 14 "Help" help "" 100
gadid 4
if $mode = GUIDE
   SetGad addnode.g 6 ON
else
   SetGad addnode.g 5 ON
endif

XICON 270 50 :icons/open
ReqFile -1 -1 300 -36 "Select node:" LOAD help '#$path'
update addnode.g 4 '$help'

; -------------------------------------------------------

XTEXTIN 70 65 200 14 "TOC" toc "" 100
gadid 5
SetGad addnode.g 6 ON

XICON 270 65 :icons/open
gadid 23 ; to hide it..
ReqFile -1 -1 300 -36 "Select node:" LOAD toc '#$path\/Main'
update addnode.g 5 '$toc'

; -------------------------------------------------------

XTEXTIN 70 80 200 14 "OnOpen" onopen "" 100
gadid 6
SetGad addnode.g 7 ON

XICON 270 80 :icons/open
ReqFile -1 -1 300 -36 "Select node:" LOAD onopen 'rexx:'
if $onopen > ''
   if $onopen H= /*
      update addnode.g 6 '$onopen'
   else
      ezreq 'Must choose a rexx script!' Ok ''
   endif
endif

; -------------------------------------------------------

XTEXTIN 70 95 200 14 "OnClose" onclose "" 100
gadid 7
SetGad addnode.g 8 ON

XICON 270 95 :icons/open
ReqFile -1 -1 300 -36 "Select node:" LOAD onclose 'rexx:'
if $onopen > ''
   if $onopen H= /*
      update addnode.g 7 '$onclose'
   else
      ezreq 'Must choose a rexx script!' Ok ''
   endif
endif

; -------------------------------------------------------

XTEXTIN 70 110 200 14 "Font" font "" 100
gadid 8

XICON 270 110 :icons/open
tfont = ''
ReqFile -1 -1 300 -36 "Select node:" LOAD tfont 'fonts:'
if $tfont > ''
   extract tfont file fsize
   extract tfont path tfont
   extract tfont file font
   appvar font ' $fsize'
endif
update addnode.g 8 '$font'

; -------------------------------------------------------
;       smartwrap/wordwrap and tab
; -------------------------------------------------------

XCYCLER 16 135 130 14 "" wrap
gadid 15
CSTR "No wrap"   ''
CSTR "SmartWrap" SMARTWRAP
CSTR "WordWrap"  WORDWRAP

XHSLIDER 197 135 70 14 "Tab" tab 2 16 8 "%ld"
gadid 16

; -------------------------------------------------------
;       Make node
; -------------------------------------------------------


XBUTTON 116 160 81 14 "_Create!"
guiclose addnode.g
sendrexx $cedbar.gc/cedport 'open new'
sendrexx $cedbar.gc/cedport 'open $name'  ; if new Ced creates it..

; add all lines for which there is an entry

if $author > ' '
   sendrexx $cedbar.gc/cedport 'text @AUTHOR $author\n'
endif
if $copyright > ' '
   sendrexx $cedbar.gc/cedport 'text @(C) $copyright\n'
endif
if $version > ' '
   sendrexx $cedbar.gc/cedport 'text \$VER: $version\n'
endif

if $title > ' '
   sendrexx $cedbar.gc/cedport 'text @TITLE \"$title\"\n'
endif
if $next > ' '
   sendrexx $cedbar.gc/cedport 'text @NEXT $next\n'
endif
if $prev > ' '
   sendrexx $cedbar.gc/cedport 'text @PREV $prev\n'
endif
if $help > ' '
   sendrexx $cedbar.gc/cedport 'text @HELP $help\n'
endif
if $toc > ' '
   sendrexx $cedbar.gc/cedport 'text @TOC $toc\n'
endif
if $onopen > ' '
   sendrexx $cedbar.gc/cedport 'text @ONOPEN $onopen\n'
endif
if $onclose > ' '
   sendrexx $cedbar.gc/cedport 'text @ONCLOSE $onclose\n'
endif
if $font > ' '
   sendrexx $cedbar.gc/cedport 'text @FONT $font\n'
endif

if $tab != 8
   sendrexx $cedbar.gc/cedport 'text @TAB $tab\n'
endif
if $wrap > ' '
   sendrexx $cedbar.gc/cedport 'text @$wrap\n'
endif

if $mode = GUIDE  ; save header, edit main
   sendrexx $cedbar.gc/cedport 'save'
   joinfile $path MAIN fullname
   guiload :addnode.g NODE $fullname ; call ourselves again..
else
   SendRexx $cedbar.gc/cedport "expand view"
   name = '' ; for next time..
endif

; save it yourself..


; -------------------------------------------------------
;       routine to get name
; -------------------------------------------------------

xroutine GetName

ifexists port ~$cedbar.gc/cedport
   ; if no ced, exit..
   guiquit addnode.g
endif

if $mode = NODE
   ; get path from current file name
   sendrexx $cedbar.gc/cedport 'status filename'
   curfilename = $$rexxret
   extract curfilename path path
   if $name = ''
      ReqFile  -1 -1 300 -36 'Enter Node name' LOAD name '#$path'
      if $name = ''
         guiclose addnode.g
         stop
      endif
   endif
else  ; GUIDE
   ReqFile  -1 -1 300 -36 'Enter Guide Dir name' LOAD name ''
   if $name = ''
      guiclose addnode.g
      stop
   endif
   makedir $name
   ifexists dir $name
      path = $name
      ; the file which will contain all header commands
      joinfile $name CBAG_Header name
   else
      guiclose addnode.g
      stop
   endif
endif


; -------------------------------------------------------
;       routine to startup the gui
; -------------------------------------------------------

xroutine startup
; reset all values every time
update addnode.g 1 ''
update addnode.g 2 ''
update addnode.g 3 ''
update addnode.g 4 ''
update addnode.g 5 ''
update addnode.g 6 ''
update addnode.g 7 ''
update addnode.g 8 ''
update addnode.g 11 ''
update addnode.g 12 ''
update addnode.g 13 ''
update addnode.g 15 8
update addnode.g 16 0
tab = 8
wrap = ''
setgadvalues addnode.g

setgad addnode.g 1/100 SHOW
if $mode = NODE
   setgad addnode.g 11/13 HIDE
   setgad addnode.g 5 ON
   extract name file plain_name ; node name
   ongad = 1
else
   setgad addnode.g 1/3 HIDE
   setgad addnode.g 5 HIDE
   setgad addnode.g 21/23 HIDE
   extract name path plain_name ; dir name
   extract plain_name file plain_name
   ongad = 11
endif

guiopen addnode.g
setwintitle addnode.g 'New $mode : $plain_name                         '
SetGad addnode.g $ongad ON ; 1st textin


