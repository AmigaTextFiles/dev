; Hello World
;
; Preass V1.20
; 
; (c) 1994 Cyborg 

	IncDir 	"sys:coder/"
	Include "preass/startrek.inc"

;---------------------------------------------------------------------------

	{* Start:START *}
	{* AutoLiban *}
	{* Delayaus *}

dc.b 0,`$VER: Hello World 20-11-94 (C) CYBORG 94`,0

even
start:
	Output()
	Write(d0,"Hello World\n",?)
	RTS
