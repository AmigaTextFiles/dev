
;---;  structs.r  ;------------------------------------------------------------
*
*	****	STRUCTURE MACROS    ****
*
*	Author		Stefan Walter
*	Add. Coding	Daniel Weber
*	Version		1.12
*	Last Revision	25.07.93
*	Identifier	stc_defined
*       Prefix		stc_	(structure macros)
*				 ¯         ¯ ¯
*	Macros		PortStruct_,PortStructDX_, MSGStruct_, IOStruct_
*			BrokerStruct_, AppIconStruct_, ImageStruct_,
*			DiskObjectStruct_
*
;------------------------------------------------------------------------------

;------------------
	ifnd	stc_defined
stc_defined	=1

;------------------

;------------------------------------------------------------------------------
*
* PortStruct_	Public port structure with PA_SIGNAL as flag and a free name.
* PortStructDX_	Public port structure with PA_SIGNAL as flag and NO NAME.
*
* USAGE		PortStruct_	('port name')
*		PortStructDX_
*
;------------------------------------------------------------------------------

;------------------
PortStruct_	macro	

;------------------
; Put struct and insert name.
;
	ds.b	10,0

	ifeq	NARG,0
	dc.l	0		;no name
	else
	dc.l	*+24		;pointer to name => RELOC32!
	endif

	dc.b	0,0		;flag,sigbit
	dc.l	0		;sigtask
	ds.b	14,0		;MSG list
	
	ifne	NARG,0
	dc.b	\1,0
	even
	endif

	endm


;------------------
PortStructDX_	macro	

	IFNE	NARG,0
	FAIL	structs.r error: PortStructDX_ does not accept a port name.
	ENDIF

;------------------
; Put struct and insert name.
;
	dx.b	10
	dx.l	1		;no name
	dx.b	2		;flag,sigbit
	dx.l	1		;sigtask
	dx.b	14		;MSG list

	endm
;------------------


;------------------------------------------------------------------------------
*
* MSGStruct_	Message structure with extension.
*
* USAGE		MSGStruct_	(# of additional bytes)
*
;------------------------------------------------------------------------------

;------------------
MSGStruct_	macro	

;------------------
; Build message struct and extension space.
;
	dc.l	0,0
	dc.b	5,0	;type message
	dc.l	0	;no name...
	dc.l	0	;reply port

	ifeq	NARG,0
	dc.w	20
	else
	dc.w	20+\1
	ds.b	\1,0
	even
	endif	

	endm

;------------------

;------------------------------------------------------------------------------
*
* IOStruct_	Input/Output Structure.
*
* USAGE		IOStruct_	(# of extension bytes)
*
;------------------------------------------------------------------------------

;------------------
IOStruct_	macro	

;------------------
; Build IO struct and extension space.
;
	ds.b 48,0
	ifne	NARG,0
	ds.b	\1,0
	endif	
	endm

;------------------------------------------------------------------------------
*
* BrokerStruct_	
*
* USAGE		BrokerStruct_ <Name:24>,<Title:40>,Uniqe,Flags,Pri,<Desc:40>
*
* DEFAULT	Uniqe:	NBU_NOTIFY!NBU_UNIQUE
*		Flags:	COF_SHOW_HIDE
*		Pri:	0
*
*		:24/:40	max. allowd length of text
*
;------------------------------------------------------------------------------

;------------------
BrokerStruct_	MACRO

;------------------
;Build a NewBroker Structure
;
.\@:	dc.b	NB_VERSION		; Commodities-Version (NEEDED)
	dc.b	0			; Reserve1
	dc.l	.BrokerName\@		; Name of broker (for Exchange-Prg)
	dc.l	.BrokerTitle\@		; Title   (for Exchange-Prg)
	dc.l	.BrokerDesc\@		; Broker-Description (for Exchange-Prg)
	IFC	'','\3'
	dc.w	NBU_NOTIFY!NBU_UNIQUE	; Notify broker, we are unique (default)
	ELSE
	dc.w	\3			; Uniqe
	ENDC
	IFC	'','\4'
	dc.w	COF_SHOW_HIDE		; Flags: We can be hidden/shown
	ELSE
	dc.w	\4			; Flags: \4
	ENDC
	IFC	'','\5'
	dc.w	0			; Pri of broker plus an alignment byte
	ELSE
	dc.b	\5,0			; Pri of broker plus an alignment byte
	ENDC
	dc.l	0			; Port-Pointer
	dc.w	0			; Reserved Channel			
	IIF	(*-.\@)-NewBroker_SIZEOF FAIL ** NewBroker structure corrupt **

.BrokerName\@:
	dc.b	\1,0
	even
.BrokerTitle\@:
	dc.b	\2,0
	even
.BrokerDesc\@:
	dc.b	\6,0
	even

	ENDM


;------------------------------------------------------------------------------
*
* AppIconStruct_	- AppIcon structure
* DiskObjectStruct_	- DiskObject structure
* ImageStruct_		- AppIcon Image structure
*
* USAGE:
*
* AppIconStruct_ <name>,<pointer to image structure>,width,height[,Xpos,Ypos]
* AppIconImageStruct_  [<pointer to image data>,<width>,<height>,<depth>]
*
* width, height		of icon hit-box (must be >= image dimensions)
* Xpos,Ypos		of icon  (default: NO_ICON_POSITION (recommended))
*
*
* tip from C=:
*
* (an easy way to create one of these (a DiskObject) is to create an icon
*  with the V2.0 icon editor and save it out.  Your application can then
*  call GetDiskObject on it and pass that to AddAppIcon.)
*
;------------------------------------------------------------------------------

		RSRESET
app_AppIconDef	RS.W	2

		RS.L	1
		RS.W	2
app_ai_Width	RS.W	1
app_ai_Height	RS.W	1
app_ai_Flags	RS.W	1
		RS.W	2
app_ai_pic	RS.L	1
		RS.L	4
		RS.W	1
		RS.L	1

		RS.B	2
		RS.L	2
app_ai_Xpos	RS.L	1
app_ai_Ypos	RS.L	1
		RS.L	3
app_AppPort	RS.L	1		;AppIcon.r extended datas
app_AppIcon	RS.L	1
app_AppImage	RS.L	1		;might only be set by InitAppIconImage!
app_AppText	RSVAL
app_SIZEOF	RSVAL


;------------------
		RSRESET
		RS.W	2		;Image Structure
app_am_Width	RS.W	1
app_am_Height	RS.W	1
app_am_Depth	RS.W	1
app_am_Image	RS.L	1
app_am_PlanePick RS.B	1
		RS.B	1
		RS.L	1
app_am_SIZEOF	RSVAL


;------------------
DiskObjectStruct_	MACRO
		AppIconStruct_ \1,\2,\3,\4,\5,\6
		ENDM

;------------------
AppIconStruct_	MACRO
;
; DiskObject structure (refer to AddAppIconA in autodocs/wb.doc).
;
		dc.w	0,0			;do_Magic, do_Version

		dc.l	0			;gadget structure!
		dc.w	0,0
		IFNC	'',\3
		dc.w	\3			;width
		ELSE
		dc.w	0
		ENDC
		IFNC	'',\4
		dc.w	\4			;height
		ELSE
		dc.w	0
		ENDC
		dc.w	0			;Flags (NULL or GADGHIMAGE=2)
		dc.w	0,0
		IFNC	'',\2
		dc.l	\2			;appicon pic
		ELSE
		dc.l	0			;no appicon pic
		ENDC
		dc.l	0			;select render - pointer to
		dc.l	0,0,0			;                alternate Image
		dc.w	0
		dc.l	0

		dc.b	0,0
		dc.l	0
		dc.l	0
		IFNC	'',\5
		dc.l	\5
		ELSE
		dc.l	$80000000	;x position of icon (NO_ICON_POSITION)
		ENDC
		IFNC	'',\6
		dc.l	\6
		ELSE
		dc.l	$80000000	;y position of icon (NO_ICON_POSITION)
		ENDC
		dc.l	0
		dc.l	0
		dc.l	0

.appport\@:	dc.l	0			;reserved for AppIconPort
.appdef\@:	dc.l	0			;AppIcon definition
.appimage\@:	dc.l	0			;pointer to AppIcon Memory

.apptext\@:	dc.b	\1,0
		even

		ENDM


;------------------
ImageStruct_	MACRO
;
; Image structure (refer to intiuition.i for more details)
;
		dc.w	0
		dc.w	0
		IFNC	'',\2
		dc.w	\2		;width
		ELSE
		dc.w	0
		ENDC
		IFNC	'',\3
		dc.w	\3		;height
		ELSE
		dc.w	0
		ENDC
		IFNC	'',\4
		dc.w	\4		;depth
		ELSE
		dc.w	0
		ENDC
		IFNC	'',\1
		dc.l	\1
		ELSE
		dc.l	0
		ENDC
		IFNC	'',\4
		dc.b	(1<<\4)-1	;planepick (planemask)
		ELSE
		dc.b	0
		ENDC
		dc.b	0
		dc.l	0
		ENDM


;--------------------------------------------------------------------

;------------------
	endif

 end

