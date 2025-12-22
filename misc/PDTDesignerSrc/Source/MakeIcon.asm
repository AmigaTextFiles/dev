	opt	c+,d+,l-
	incdir	sys:include/
	include	exec/exec_lib.i
	include	workbench/icon_lib.i
	include	workbench/workbench.i
	include	intuition/intuition.i


;   Small routine to re-create the icon used for program.  Saves to a disk
; called "DesignerV2:".
;
; Assemble to memory then execute.
;
;
; 28/11/93 Paul Turner.


	section	IconProg,code
Start:
	lea	IconLib,a1
	moveq	#0,d0
	CALLEXEC	OpenLibrary	; Open icon library.
	move.l	d0,_IconBase		; Store pointer.
	beq.s	.Failure		; Exit if library not available.
	lea	ObjectName,a0
	lea	Object,a1
	CALLICON	PutDiskObject	; Write icon to disk.
	move.l	_IconBase,a1
	CALLEXEC	CloseLibrary	; Close icon lib.
.Failure:
	rts

	section	IconStuff,data
_IconBase	dc.l	0
IconLib		ICONNAME
	even
ObjectName	dc.b	"DesignerV2:TheDesigner",0
	even

;   This is the disk object...

Object:
	dc.w	WB_DISKMAGIC		; A magic number used to ID icon.
	dc.w	WB_DISKVERSION		; Version of object structure.

; This is an embedded gadget structure...

	  dc.l	0		; No other gadgets.
	  dc.w	0,0		; Position not used by us.
	  dc.w	110,35		; The size of our "Hit box".
	  dc.w	(GADGIMAGE!GADGHIMAGE)	; Flags
	  dc.w	(GADGIMMEDIATE!RELVERIFY)	; Activation flags.
	  dc.w	BOOLGADGET		; Thats us!
	  dc.l	BaseImage	; Image used when not selected.
	  dc.l	SelImage	; Image used when selected.
	  dc.l	0,0,0		; All other data is 0...
	  dc.w	0
	  dc.l	0

	dc.b	WBTOOL		; And a useful one at that!!
	dc.l	0,0		; No defaults and no tool types.
	dc.l	NO_ICON_POSITION,NO_ICON_POSITION	; Any position.
	dc.l	0		; Were not a drawer.
	dc.l	0		; Future use
	dc.l	0		; Default stack.

BaseImage:
	dc.w	0,0,110,34,2	; Position & dimensions of image.
	dc.l	BaseData	; Ptr to image data.
	dc.b	3,0		; Plane pick & Plane on/off
	dc.l	0		; No other image.

SelImage:
	dc.w	0,0,110,34,2	; Position & dimensions of image.
	dc.l	SelData		; Ptr to image data.
	dc.b	3,0		; Plane pick & Plane on/off
	dc.l	0		; No other image.

	section	ChipStuff,data_c
BaseData:
	incbin	"MapDesignerV2.0:GfxData/MainIcon.raw"
	even
SelData:
	incbin	"MapDesignerV2.0:GfxData/MainIcon2.raw"
	even

	end
