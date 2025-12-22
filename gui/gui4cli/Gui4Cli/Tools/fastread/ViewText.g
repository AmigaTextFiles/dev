G4C

WINBIG 0 11 634 220 ""
winsmall 0 -1 150 21
wintype 11110001
resinfo 8 640 256
varpath "fastread.gc"

xonopen
	ifexists window fastread.gc
	    ;Nop
	else
	    setgad viewtext.g 3 off
	    setgad viewtext.g 4 off
	    setgad viewtext.g 5 off
	endif

xonclose
	set translation on
	lvuse viewtext.g 1
	lvclear
	ifexists window fastread.gc
	    gosub fastread.gc exit
	endif

xonrmb
	set translation on
	lvuse viewtext.g 1
	lvclear
	ifexists window fastread.gc
	    update viewtext.g 2 ""
	    guiwindow fastread.gc front
	    guiwindow fastread.gc on
	else
	    guiclose viewtext.g
	endif

XTEXTBOX 0 0 371 15 '' ''
	attr tbstyle 1/0/plain/left
	attr tbox    2/1/0/button/out
	gadid 2
	attr resize 0020

;text 10 0 350 12 "" 50 nobox
;	gadid 2

XLISTVIEW 0 15 633 204 "" "" "" 20 num
	gadid  1
	attr resize 0022
	gadfont #mono 8 000


XBUTTON 372 0 60 15 Macro
	attr resize 2000
	gadid 3
	if $VTMACRO > ""
	andifexists file $VTMACRO
	    run 'newshell "con:0/11/640/200/OUTPUT/CLOSE WAIT" from $VTMACRO'
	else
	    reqfile -1 -1 200 -60 "Run Macro..." load macro GCHELP:
	    if $macro != ""
	        run 'newshell "con:0/11/640/200/OUTPUT/CLOSE WAIT" from $macro'
	        macro = ""
	    endif
	endif

XBUTTON 432 0 50 15 Prev
	attr resize 2000
	gadid 4
	lvuse fastread.gc 1
	lvgo prev
	topic = $$lv.rec
	gosub fastread.gc fetchtext 

XBUTTON 482 0 50 15 Next
	attr resize 2000
	gadid 5
	lvuse fastread.gc 1
	lvgo next
	topic = $$lv.rec
	gosub fastread.gc fetchtext 

XBUTTON 532 0 50 15 Grab
	attr resize 2000
	gosub viewtext.g grabtext

XBUTTON 582 0 50 15 Quit
	attr resize 2000
	guiclose viewtext.g

xroutine grabtext
	reqfile -1 -1 200 -60 "Save Text As.." save txt SYS:
	if $txt != ""
	    lvuse viewtext.g 1
	    lvsave $txt
	endif
