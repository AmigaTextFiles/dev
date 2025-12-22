G4C

WINBIG 199 27 442 35 "Link selection to:"
WinType 11110001
resinfo 8 640 256

BOX 0 0 0 0 out button

xOnLoad
linkmode = NODE
guiopen addlink.g

xonreload
guiopen addlink.g

xonopen
linkname = ''
update addlink.g 1 ''

xONQUIT
guiquit getlinkmode

; -------------------------------------------------------------
;       Get link name
; -------------------------------------------------------------

XTEXTIN 5 3 433 14 "" linkname "" 140
gadhelp 'Enter the name of the node or file or rexx script'
gadid 1
gosub addlink.g dolink

XBUTTON 276 18 80 13 "Browse.."
gadhelp 'Select node or file through a requester'
docase $linkmode
  case = NODE
    ; get current filename
    sendrexx $cedbar.gc/cedport 'status filename'
    filename = $$rexxret
    extract filename PATH filepath
    extract filename FILE filename
    ReqFile -1 -1 300 -40 "Select Node" LOAD linkname #$filepath
    extract linkname file linkname
    update addlink.g 1 $linkname
    break
  case = FILE
    ReqFile -1 -1 300 -40 "Select File" LOAD linkname sys:
    JoinFile $linkname "MAIN" linkname
    update addlink.g 1 $linkname
    break
  case = SYSTEM
    ReqFile -1 -1 300 -40 "Select Command" LOAD linkname c:
    update addlink.g 1 $linkname
    break
  case = RX
    ReqFile -1 -1 300 -40 "Select Rexx script" LOAD linkname sys:
    update addlink.g 1 $linkname
    break
  case = RXS
    ;
    break
endcase
setgad addlink.g 1 ON

; -------------------------------------------------------------
;       OK..
; -------------------------------------------------------------

XBUTTON 357 18 80 13 "OK"
gadhelp 'Proceed..'
gadkey #13
gosub addlink.g dolink

; do the actual link insertion - also called from the textin
xRoutine dolink
guiclose addlink.g
if $linkname > ' '
  SendRexx $cedbar.gc/cedport cut
  SendRexx $cedbar.gc/cedport 'text @{\" '
  SendRexx $cedbar.gc/cedport paste
  SendRexx $cedbar.gc/cedport 'text  \" '
  if $linkmode = NODE
  or $linkmode = FILE
    SendRexx $cedbar.gc/cedport 'text LINK \"$linkname\"}'
  else
    SendRexx $cedbar.gc/cedport 'text $linkmode \"$linkname\"}'
  endif
endif

; -------------------------------------------------------------
;       Choose type of link
; -------------------------------------------------------------

CTEXT 6 18 "Type:" #screen 8 2 0 00011

TEXT 75 18 195 13 'Link to Node' 100 BOX
gadhelp 'Displays the link type'
gadid 2

XBUTTON 48 18 23 13 "?"
gadhelp 'Change link type'
guiopen getlinkmode


; #############################################################
;       GETLINKMODE
; #############################################################

NEWFILE getlinkmode
WINBIG 156 78 158 61 ''
WinType 00001000
winonmouse 15 15
resinfo 8 660 270
varpath addlink.g
BOX 0 0 0 0 out button

xONRMB
guiclose getlinkmode

xONInactive
guiclose getlinkmode

XRADIO 10 5 17 9 linkmode 2
gadhelp 'Choose type of link'
gadtitle right
RSTR "Link to Node" NODE
RSTR "Link to File" FILE
RSTR "Run Command" SYSTEM
RSTR "Run Rexx script" RX
RSTR "Run Rexx line" RXS
guiclose getlinkmode
docase $linkmode
  case = NODE
    update addlink.g 2 'Link to Node'
    break
  case = FILE
    update addlink.g 2 'Link to File'
    break
  case = SYSTEM
    update addlink.g 2 'Run Command'
    break
  case = RX
    update addlink.g 2 'Run Rexx script'
    break
  case = RXS
    update addlink.g 2 'Run Rexx line'
    break
endcase
; reset any entries since we've changed mode
linkname = ''
update addlink.g 1 ''









