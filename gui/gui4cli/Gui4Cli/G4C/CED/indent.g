G4C

WINBIG 390 34 152 33 'Indent by:'
WinType 11110001
resinfo 8 640 256
BOX 0 0 152 33 out button

xOnLoad
   indentval = "\t"
   unindent  = OFF
   guiopen indent.g
   
xOnReLoad
   guiopen indent.g

xOnRMB
   guiclose indent.g

XTEXTIN 3 2 111 13 "" indentval "\t" 100
   gosub indent.g indent

XBUTTON 115 2 33 13 "Ok"
   gosub indent.g indent

xroutine indent
   SendRexx $cedbar.gc/cedport cut
   lvuse CedClip.g 1
   lvchange 'CLIPS:$cedbar.gc/cedClip'
	if $unindent = ON
		call LVFormat UnIndent
	endif
   call LVFormat INDENT  '$indentval'
   lvsave 'CLIPS:$cedbar.gc/cedClip'
   SendRexx $cedbar.gc/cedport paste

XCHECKBOX 114 15 34 15 "From start" unindent "ON" "OFF" OFF

