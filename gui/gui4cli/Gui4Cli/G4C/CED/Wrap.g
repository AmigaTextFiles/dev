G4C

WINBIG 223 27 398 48 'Re-Wrap selected text:'
WinType 11110001
resinfo 8 640 256

BOX 0 0 0 0 out button

xOnLoad
   GuiOpen Wrap.g
   setgadvalues wrap.g
   
xOnreload
   Guiopen Wrap.g
   just = ''

; ====================================================
;       get the line length
; ====================================================

CTEXT 14 4 "Set new line length" #screen 8 2 0 0001

XHSLIDER 13 17 351 13 "" chars 20 120 60 "%ld"
gadid 1
update wrap.g 2 $chars

; --- > for bigger lines enter it manually here.

XTEXTIN 176 2 67 13 "" chars 60 10
gadid 2
if $chars > 120
   setgad wrap.g 1 OFF
else
   setgad wrap.g 1 ON
   update wrap.g 1 $chars
endif

; ====================================================
;       get the starting characters to ignore
; ====================================================

XTEXTIN 144 31 85 14 "Starting chars:" hdchars "" 50

; ====================================================
;       justify ?
; ====================================================

XCYCLER 248 2 116 14 "" just
CSTR Normal     ''
CSTR Justify    JUST
CSTR Un-Justify UNJUST
CSTR Center     CENTER
CSTR Reset      RESET

; ====================================================
;       do your stuff..
; ====================================================

XBUTTON 279 31 85 14 "Apply"
   SendRexx $cedbar.gc/cedport cut
   lvuse CedClip.g 1
   lvchange 'CLIPS:$cedbar.gc/cedClip'
   call LVFormat wrap '$chars' $just $hdchars
   lvsave 'CLIPS:$cedbar.gc/cedClip'
   SendRexx $cedbar.gc/cedport paste



