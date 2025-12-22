
;---;  gtfdefs.r  ;------------------------------------------------------------
*
*	****	DEFINITIONS FOR GTFACE    ****
*
*	Author		Stefan Walter
*	Version		1.09
*	Last Revision	16.10.95
*	Identifier	gtf_d_defined
*	Prefix		gtf_	(GadToolsFace)
*				 ¯  ¯    ¯
;------------------------------------------------------------------------------

;------------------
	ifnd	gtf_d_defined
gtf_d_defined	=1

*--------------------------------------------------------------------
* Various
*


*
* Minimal IDCMP flags required for proper functioning. 
*
gtf_MINIDCMP		equ	$02000004


*
* Miscellanous definitions
*
POSINFO			equ	-1	;for own 'generic' gadgets


*--------------------------------------------------------------------
* Bit definitions used in the flag field of a GTFace gadget entry.
* There are three kind of flags:
*
*	0-3	are checked for each kind of gadgets before it is created.
*	4-5	are checked for each kind of gadgets after it is created.
*		The flag handlers tinker with the created gadget structure.
*	6-15	have seperate meanings for different gadget types. There
*		are flags that are valid for more than one gadget kind,
*		i.e. RightJustify or Label.
*
* The bits to choose are generally set via macros.
*


*
* General
*
gtf_b_Underscore	equ	0
gtf_b_Disabled		equ	1

gtf_b_ToggleSelect	equ	4
gtf_b_Selected		equ	5


*
* CheckBox
*
gtf_b_Checked		equ	8


*
* Integer
*
gtf_b_Number		equ	8
gtf_b_MaxChars		equ	9		;also for String
gtf_b_NoTabCycle	equ	10
gtf_b_RightJustified	equ	11		;also for String


*
* ListView
*
gtf_b_Labels		equ	8		;also for MX and Cycle
gtf_b_ReadOnly		equ	9
gtf_b_ShowSelected	equ	10
gtf_b_LVSelected	equ	11


*
* MX (Mutual Exclude)
*
;gtf_b_Labels		equ	8		;see ListView
gtf_b_Active		equ	9
gtf_b_Spacing		equ	10


*
* Slider
*
gtf_b_RelVerify		equ	8
gtf_b_Min		equ	9
gtf_b_Max		equ	10
gtf_b_Level		equ	11
gtf_b_MaxLevelLen	equ	12
gtf_b_LevelFormat	equ	13
gtf_b_LevelPlace	equ	14
gtf_b_DispFunc		equ	15


*
* Cycle
*
;gtf_b_Labels		equ	8		;see ListView
;gtf_b_Active		equ	9		;see MX


*
* String
*
gtf_b_String		equ	8
;gtf_b_MaxChars		equ	9		;see Integer
gtf_b_TabCycle		equ	10
;gtf_b_RightJustified	equ	11		;see Integer
gtf_b_EditHook		equ	12


*
* Text
*
gtf_b_Text		equ	8
gtf_b_CopyText		equ	9
gtf_b_Border		equ	10


*--------------------------------------------------------------------
* The object structures.
*

*
* Object
*
			rsreset
gfb_next		rs.l	1
gfb_flag		rs.b	1
gfb_type		rs.b	1
gfb_xpos		rs.w	1
gfb_ypos		rs.w	1

gfb_style		rsval
gfb_width		rs.w	1
gfb_text		rsval
gfb_heigth		rs.w	1
gfb_filled		rs.w	1

gfb_SIZEOF		rsval



*--------------------------------------------------------------------
* The key structures. When GTFace deals with windows and gadgets, it
* does this by using a key structure which holds all the information
* that is neccessary.
*

*
* WindowKey
*
	rsreset
gfw_window		rs.l	1	;window pointer
gfw_font		rs.l	1	;font used for window
gfw_textattr		rs.l	1	;TextAttr structure for that font
gfw_visualinfo		rs.l	1	;VisualInfo structure pointer
gfw_fontx		rs.w	1	;\  Size of font. GTFace will only
gfw_fonty		rs.w	1	;/  handle nonproportional fonts!
gfw_lefto		rs.w	1	;\  Size of left and top bar, taken
gfw_topo		rs.w	1	;/  from the window structure.
gfw_glists		rs.l	3	;list of gadget lists that are added
gfw_clear		rs.w	1	;contains color number of background
gfw_horbd		rs.w	1	;size of left and right border together
gfw_vertbd		rs.w	1	;size of top and bottom border together

gfw_idcmp		rs.l	1	;IDCMP always needed
gfw_menu		rs.l	1	;menu appended

gfw_msgidcmp		rs.l	1	;\
gfw_msgcode		rs.w	1	; |  These will contain a copy of
gfw_msgqualifier	rs.w	1	; |  the information from a
gfw_msgaddr		rs.l	1	; |  message comming from gadtools
gfw_msgmousex		rs.w	1	; |  or someone else that sends
gfw_msgmousey		rs.w	1	; |  to the window port.
gfw_msgseconds		rs.l	1	; |
gfw_msgmicros		rs.l	1	;/

gfw_winxpos		rs.w	1	;\   Window dimensions of main window.
gfw_winypos		rs.w	1	; |  These are tracked by GetGTFMsg.
gfw_winwidth		rs.w	1	; |
gfw_winheigth		rs.w	1	;/
gfw_winiwidth		rs.w	1	;\   For OpenWindowScaled these are
gfw_winiheigth		rs.w	1	;/   also stored!
gfw_zoomxpos		rs.w	1	;\   Zoomed window dimensions. Also
gfw_zoomypos		rs.w	1	; |  tracked and updated by GetGTFMsg.
gfw_zoomwidth		rs.w	1	; |
gfw_zoomheigth		rs.w	1	;/

gfw_noscale		rs.b	1	;set if no scaling for window...
					;used for OpenWindowScaledLast
gfw_domenu		rs.b	1	;set while doing menu callers. Must
					;be cleared when menu caller changes
					;window or menu.

gfw_SIZEOF	rsval			;


*
* GadgetKey
*
	rsreset
gfg_next	rs.l	1		;\ Used to link several lists to a window
gfg_prev	rs.l	1		;/ for easy refreshing.
gfg_numof	rs.l	1		;number of gadgets in created list.
gfg_gnumof	rs.l	1		;number of gadtools gadgets
gfg_gadgets	rs.l	1		;first gadget
gfg_window	rs.l	1		;window the gadgets are rendered for
gfg_table	rs.l	1		;table of gadget addresses
gfg_remkey	rs.l	1		;remember key for objects	
gfg_objects	rs.l	1		;remember key for objects	
gfg_idcmp	rs.l	1		;IDCMP for these gadgets
gfg_SIZEOF	rsval			;


*
* PosInfo
*
	rsreset
gfp_xpos	rs.w	1		;x-position of object
gfp_ypos	rs.w	1		;y-position (")
gfp_width	rs.w	1		;width of object
gfp_heigth	rs.w	1		;height of object
gfp_SIZEOF	rsval

*--------------------------------------------------------------------

;------------------
	endif
	end

