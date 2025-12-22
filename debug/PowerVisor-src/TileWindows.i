 * Part of PowerVisor source   Copyright © 1992   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH


	;Available flags for Logical windows
LWF_FILE			equ	1				;Print on file
LWF_SCREEN		equ	2				;Print on screen
LWF_MORE			equ	4				;Output per page
LWF_DIRTY		equ	8				;Logical window information is not correct
LWF_PRIVATESB	equ	16				;If false we update the scrollbar according
											;to the position of the visual part of the
											;logical window (LogWin_UpdateScrollBar)
											;otherwise, updating is done by some other
											;function
LWF_TOTALHOME0	equ	32				;Total home is equal to (0,0) top
LWF_NOSTATUS	equ	64				;If true no status line is used
LWF_NOBREAK		equ	128			;If not true we can't interrupt/pause output here
LWF_SNAPOUTPUT	equ	256			;If true we always scroll to output
LWF_SBARIFMODE	equ	512			;If false we add a scrollbar depending on the
											;global 'mode sbar' setting
LWF_SCROLLBAR	equ	1024			;If true we always add a scrollbar to the
											;to the logwin box (the previous flag is
											;ignored)

LWB_FILE			equ	0
LWB_SCREEN		equ	1
LWB_MORE			equ	2
LWB_DIRTY		equ	3
LWB_PRIVATESB	equ	4
LWB_TOTALHOME0	equ	5
LWB_NOSTATUS	equ	6
LWB_NOBREAK		equ	7
LWB_SNAPOUTPUT	equ	8
LWB_SBARIFMODE	equ	9
LWB_SCROLLBAR	equ	10

	;------------------------------------------------------------------------------
	;Global object
	;------------------------------------------------------------------------------

	STRUCTURE	Global,MLN_SIZE

	;PW list
		STRUCT	Global_PWList,LH_SIZE
	;Active LW
		APTR		Global_ActiveLW
		ULONG		Global_SigSet
		APTR		Global_PhysWin		;OBSOLETE
		LABEL		Global_SIZE

	;------------------------------------------------------------------------------
	;Box object
	;------------------------------------------------------------------------------

	;Top border for logical windows
LW_TOPBORDER	equ	8+3

	;Types for a box
UPDOWN			equ	0
LEFTRIGHT		equ	1
ATOMIC			equ	2

	;Drag tolerance
DRAG_TOLERANCEY1	equ	0
DRAG_TOLERANCEY2	equ	9
DRAG_TOLERANCEX1	equ	3
DRAG_TOLERANCEX2	equ	3

	;Size tolerance
SIZE_TOLERANCEY	equ	20
SIZE_TOLERANCEX	equ	15

	;Parameters for PhysWin_SplitBox
	;MAKE_#? & 1 is equal to LEFTRIGHT or UPDOWN
	;MAKE_#? & 2 is equal to number of child
MAKE_LEFT		equ	1
MAKE_RIGHT		equ	3
MAKE_UP			equ	0
MAKE_DOWN		equ	2

	STRUCTURE	Box,0

	;Parent box. NULL if box is parent.
		APTR		Box_Parent
	;Two children for this box. Only if Box_Type != ATOMIC
		APTR		Box_ChildA
		APTR		Box_ChildB
	;Pointer to logical window in this box. Only if Box_Type == ATOMIC
		APTR		Box_LogWin
	;Pointer back to PW
		APTR		Box_PhysWin
	;Percentage*10 for child A
		UWORD		Box_ShareA
	;One of ATOMIC, LEFTRIGHT or UPDOWN
		UBYTE		Box_Type
	;If true our box needs a cleanup
		UBYTE		Box_Dirty
	;Inner box used by this box
		UBYTE		Box_BorderLeft
		UBYTE		Box_BorderTop
		UBYTE		Box_BorderRight
		UBYTE		Box_BorderBottom
	;Real size for box after accounting for the window and the inner box
	;This means that these variables are the coordinates of the box that
	;we really can use for output in the box
		UWORD		Box_x
		UWORD		Box_y
		UWORD		Box_w
		UWORD		Box_h
	;Location for titlebar
		UWORD		Box_sx1
		UWORD		Box_sy1
		UWORD		Box_sx2
		UWORD		Box_sy2
	;Pointer to a scrollbar gadget (gadtools)
		APTR		Box_Gadget
		APTR		Box_NewGadget
		LABEL		Box_SIZE

	;------------------------------------------------------------------------------
	;PhysWindow object
	;------------------------------------------------------------------------------

	;Messages for PhysWin
PWMSG_SNAP		equ	1

	STRUCTURE	PhysWin,LN_SIZE
		STRUCT	PhysWin_NewWindow,nw_SIZE
		APTR		PhysWin_Window
		UBYTE		PhysWin_pad0
		UBYTE		PhysWin_pad1
		UBYTE		PhysWin_pad2
		UBYTE		PhysWin_pad3
		UWORD		PhysWin_LastCode
		UWORD		PhysWin_LastQualifier
      UBYTE		PhysWin_BorderLeft
      UBYTE		PhysWin_BorderTop
      UBYTE		PhysWin_BorderRight
      UBYTE		PhysWin_BorderBottom
      APTR		PhysWin_Box						;Master Box
      APTR		PhysWin_Global					;Pointer back to global
		STRUCT	PhysWin_LWList,LH_SIZE		;LW list
		APTR		PhysWin_CurGadget
		APTR		PhysWin_CurGList
		LABEL		PhysWin_SIZE

	;------------------------------------------------------------------------------
	;LogWindow object
	;------------------------------------------------------------------------------

	STRUCTURE	LogWin,LN_SIZE
		APTR		LogWin_Box			;Box for this logical window
		WORD		LogWin_rx			;Real world coordinates (in PhysWin)
		WORD		LogWin_ry			;	(computed by _LogWin_Recalc)
		WORD		LogWin_rw
		WORD		LogWin_rh
		WORD		LogWin_viscol		;First visible coordinate in logical window
		WORD		LogWin_visrow		;	(starting with 0)
		WORD		LogWin_col			;Text coordinates in buffer
		WORD		LogWin_row
		WORD		LogWin_width		;Visible width and height in characters
		WORD		LogWin_height		;	(minimum of LogWin_Vis<xxx> and LogWin_Num<xxx>
		LONG		LogWin_Flags		;Special flags (only word used for now)
		STRUCT	LogWin_TA,ta_SIZEOF
		APTR		LogWin_Font
		WORD		LogWin_FontX		;Font X and Ysize
		WORD		LogWin_FontY
		WORD		LogWin_FontBase	;Font baseline
		APTR		LogWin_PhysWin		;Pointer back to physical window
		WORD		LogWin_ocol			;Optimal number of columns and rows
		WORD		LogWin_orow
		WORD		LogWin_NumLines	;Number of lines and columns in screen buffer
		WORD		LogWin_NumColumns
		APTR		LogWin_Buffer		;Pointer to screen buffer lines
		BPTR		LogWin_File			;Attached file
		WORD		LogWin_LinesPassed	;For LWF_MORE
		APTR		LogWin_SnapHandler	;Routine used to handle snap message
		APTR		LogWin_Title		;Extra title for this logical window
		UBYTE		LogWin_Active		;If TRUE we are active
		UBYTE		LogWin_TopBorder	;Border not used for text at the top (statusline)
		UWORD		LogWin_rtop			;Real top coordinate = LW_ry-LW_TopBorder
		LONG		LogWin_UserData
		UWORD		LogWin_HiLine		;Number of hilighted line (or -1 if no line is hilighted)
		APTR		LogWin_ScrollHandler		;Routine used to handle the scrollbar
		APTR		LogWin_RefreshHandler	;Routine used to handle refresh
		APTR		LogWin_CreateSBHandler	;Routine used when scrollbar is created
		WORD		LogWin_VisWidth	;Visible width in characters
		WORD		LogWin_VisHeight	;Visible height in characters
		LABEL		LogWin_SIZE

