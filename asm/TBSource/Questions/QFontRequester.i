		ds.l	0
	
FontRequest1:	dc.w	$2				;MUST BE REQVERSION !!!
FontRTitle:	dc.l	0				;frq_Title
		dc.l	FontDir				;frq_Dir
		dc.l	0				;frq_File
		dc.l	FontName			;frq_PathName
		dc.l	0				;frq_Window
		dc.w	0				;frq_MaxExtendedSelect
		dc.w	0,0				;frq_NumLines,NumColumns
		dc.w	0				;frq_DevColumns
FontRFlags:	dc.l	FRQABSOLUTEXYM+FRQGETFONTSM	;frq_Flags
		dc.w	2,1				;frq_DirNamesColor,FileNamesColor
		dc.w	3,1				;frq_DeviceNamesColor,FontNamesColor
		dc.w	2				;frq_FontSizesColor
		dc.w	0,0				;frq_DetailColor,BlockColor
		dc.w	0,0				;frq_GadgetTextColor,TextMessageColor
		dc.w	0,0				;frq_StringNameColor,StringGadgetColor
		dc.w	0,0				;frq_BoxBorderColor,GadgetBoxColor
		dcb.b	36,0				;frq_RFU_Stuff
		dcb.b	12,0				;frq_DateStamp
		dc.w	128,6				;frq_WindowLeftEdge,WindowTopEdge
FontRFYSize:	dc.w	0,0				;frq_FontYSize,FontStyle
		dc.l	0				;frq_ExtendSelect
		dcb.b	32,0				;frq_Hide
		dcb.b	32,0				;frq_Show
		dc.w	0,0				;frq_FileBufferPos,FileDispPos
		dc.w	0,0				;frq_DirBufferPos,DirDispPos
		dc.w	0,0				;frq_HideBufferPos,HideDispPos
		dc.w	0,0				;frq_ShowBufferPos,ShowPispPos
		dc.l	0,0				;frq_Memory,Memory2
		dc.l	0				;frq_Lock
		dcb.b	132,0				;frq_PrivateDirBuffer
		dc.l	0				;frq_FileInfoBlock
		dc.w	0				;frq_NumEntries
		dc.w	0				;frq_NumHiddenEntries
		dc.w	0				;frq_FileStartNumber
		dc.w	0				;frq_DevicesStartNumber


FontDir:	dc.b	"FONTS:"
		dcb.b	32-6,0

;DSIZE = 130
;FSIZE = 30
;WILDLENGTH = 30
