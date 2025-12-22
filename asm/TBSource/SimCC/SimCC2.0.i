;
;Here are the 2.0 stuff needed
;

_LVOOpenWindowTagList:	EQU -$25e
_LVOLockPubScreen:	EQU -$1fe
_LVOUnlockPubScreen:	EQU -$204


ZOOMED		EQU $10000000	; identifies "zoom state"

;utility/tagitem.i

; =======================================================================
; ====	TagItem	==========================================================
; =======================================================================
; This data type may propagate through the system for more general use.
; In the meantime, it is used as a general mechanism of extensible data
; arrays for parameter specification and property inquiry (coming soon
; to a display controller near you).
; 
; In practice, an array (or chain of arrays) of TagItems is used.

 STRUCTURE	TagItem,0
    ULONG	ti_Tag		; identifies the type of this item
    ULONG	ti_Data		; type-specific data, can be a pointer
    LABEL	ti_SIZEOF

; ----	system tag values -----------------------------
TAG_DONE   EQU	0	; terminates array of TagItems. ti_Data unused
TAG_IGNORE EQU	1	; ignore this item, not end of array
TAG_MORE   EQU	2	; ti_Data is pointer to another array of TagItems
			; note that this tag terminates the current array

; ----	user tag identification -----------------------
TAG_USER  EQU	$80000000	; differentiates user tags from system tags

; until further notice, tag bits 16-30 are RESERVED and should be zero.
; Also, the value (TAG_USER | 0) should never be used as a tag value.


;exec/types.i

**
** Enumerated variables.  Use ENUM to set a base number, and EITEM to assign
** incrementing values.  ENUM can be used to set a new base at any time.
**
ENUM	    MACRO   ;[new base]
	    IFC     '\1',''
EOFFSET	    SET	    0		; Default to zero
	    ENDC
	    IFNC    '\1',''
EOFFSET	    SET     \1
	    ENDC
	    ENDM

EITEM	    MACRO   ;label
\1	    EQU     EOFFSET
EOFFSET     SET     EOFFSET+1
	    ENDM


;Intuition/intuition.i

    ENUM TAG_USER+100

    ; these tags simply override NewWindow parameters
    EITEM WA_Left
    EITEM WA_Top
    EITEM WA_Width
    EITEM WA_Height
    EITEM WA_DetailPen
    EITEM WA_BlockPen
    EITEM WA_IDCMP
    EITEM WA_Flags	; not implemented at present
    EITEM WA_Gadgets
    EITEM WA_Checkmark
    EITEM WA_Title
    EITEM WA_ScreenTitle	; means you don't have to call SetWindowTitles
			 	; after you open your window

    EITEM WA_CustomScreen
    EITEM WA_SuperBitMap	; also implies SUPER_BITMAP property
    EITEM WA_MinWidth
    EITEM WA_MinHeight
    EITEM WA_MaxWidth
    EITEM WA_MaxHeight

    ; The following are specifications for new features

    EITEM WA_InnerWidth
    EITEM WA_InnerHeight ; You can specify the dimensions of the interior
			 ; region of your window, independent of what
			 ; the border widths will be.  These are
			 ; *supposed* to imply the EITEM WA_AutoAdjust property,
			 ; but there is a bug report that says they don't.


    EITEM WA_PubScreenName	; declares that you want the window to open as
			 ; a visitor on the public screen whose name is
			 ; pointed to by (UBYTE *) ti_Data

    EITEM WA_PubScreen	; open as a visitor window on the public screen
			; whose address is in (struct Screen *) ti_Data.
			; To insure that this screen remains open, you
			; should either be the screen's owner, have a
			; window open on the screen, or use LockPubScreen().

    EITEM WA_PubScreenFallBack	; A Boolean, specifies whether a visitor window
			 ; should "fall back" to the default public screen
			 ; (or Workbench) if the named public screen isn't
			 ; available

    EITEM WA_WindowName	; not implemented
    EITEM WA_Colors	; a ColorSpec array for colors to be set
			; when this window is active.  This is not
			; implemented, and may not be, since the default
			; values to restore would be hard to track.
			; We'd like to at least support per-window colors
			; for the mouse pointer sprite.

    EITEM WA_Zoom	; ti_Data points to an array of four WORD's,
			; the initial Left/Top/Width/Height values of
			; the "alternate" zoom position/dimensions.
			; It also specifies that you want a Zoom gadget
			; for your window, whether or not you have a
			; sizing gadget.

    EITEM WA_MouseQueue	; ti_Data contains initial value for the mouse
			; message backlog limit for this window.

    EITEM WA_BackFill	; unimplemented at present: provides a "backfill
			; hook" for your window's layer.

    EITEM WA_RptQueue	; initial value of repeat key backlog limit

    ; These Boolean tag items are alternatives to the NewWindow.Flags
    ; boolean flags with similar names.

    EITEM WA_SizeGadget
    EITEM WA_DragBar
    EITEM WA_DepthGadget
    EITEM WA_CloseGadget
    EITEM WA_Backdrop
    EITEM WA_ReportMouse
    EITEM WA_NoCareRefresh
    EITEM WA_Borderless
    EITEM WA_Activate
    EITEM WA_RMBTrap
    EITEM WA_WBenchWindow	; PRIVATE!!
    EITEM WA_SimpleRefresh	; only specify if TRUE
    EITEM WA_SmartRefresh	; only specify if TRUE
    EITEM WA_SizeBRight
    EITEM WA_SizeBBottom

    ; New Boolean properties
    EITEM WA_AutoAdjust	; shift or squeeze the window's position and
			; dimensions to fit it on screen.

    EITEM WA_GimmeZeroZero	; equiv. to NewWindow.Flags GIMMEZEROZERO
*** End of Window attribute enumeration ***
