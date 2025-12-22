*************************************************************************************
* ISAN: Instruction Stream ANalyzer  v1.2		© Jan 1994 L. Vanhelsuwé
* ---------------------------------------		------------------------
*
* Usage: ISAN <TASK $tcb_addr|PROCESS procnum>
*
* ISAN Is used to get an idea of which instructions a particular Exec Task or
* AmigaDOS Process is executing.
* This is achieved by adding a TRACE exception handler to the Task which keeps
* track of how many times a particular instruction or group of instructions has
* been executed.
* In parallel another Process (ISAN itself) regularly uses the results produced
* by the exception handler to display the statistics graphically in a Window.
*
* The instructions of interest are listed in a run-time file called ISAN.config.
* This file basically lists the numeric opcodes with a string to be used as
* "label" for this opcode.
*
* History:
* --------
* Tue 17/MAR/92: Started project (coded all initialization first)
* Wed 18/MAR/92: Got first tracing to work, added pattern mask feature
* Thu 19/MAR/92: Added TOTAL option
* Fri 20/MAR/92: Added Topaz font selection for Text output. Cleaned up code/comments.
* Tue 14/APR/92: Added Graphical Opcode Usage Mapping (pixels represent each opcode)
* Tue 21/APR/92: Added counters reset option (by clicking in window)
* Tue 28/APR/92: Fixed 'Task not found' bug. Embarrassing...
* Sat 02/MAY/92: Added task register monitoring option
* Sun 03/MAY/92: Optimized TRACE exception handler by using memory indirect adr modes.
* Tue 05/MAY/92: Fixed OpenWindow() failure bug (SORRY!!)
* Sun 09/JAN/94: Added FILE keyword to command line options
* Sat 22/JAN/94: Added PROFILE keyword for simplistic MODE 2 PC profiling
*
*************************************************************************************

		include	std			;include std macros, equates
		include	hardware/custom.i	;for intena reg


		RSRESET	Opcode	; Opcode Descriptor structure
opc_base_op	RS.W	1		;base opcode binary pattern (opcode template)
opc_nocare_mask	RS.W	1		;mask for bits which can be anything
opc_combis	RS.W	1		;# of combinations that mask gives us
opc_label	RS.L	1		;ptr to opcode mnemonic string
opc_label_len	RS.W	1		;length of label string (for Text() )
opc_freq	RS.L	1		;copy of the counter found in big array
opc_xfreq	RS.L	1		;normalized frequency
opc_sizeof	rs.w	0

CNTS_BLOCKSIZE	equ	65536*4		;each 680x0 opcode has a LONG counter

MAX_PC_HIST	equ	248		;max number of PCs remembered.

CHAR_WIDTH	equ	8		;for Topaz80
CHAR_HEIGHT	equ	8

WINDOW_WIDTH	equ	482		;width excluding fat right border
PANE_X		equ	6		;top-left offsets to body of window
PANE_Y		equ	10
HEXNUM_SPACE	equ	8*CHAR_WIDTH	;width of frequency field
GADG_WIDTH	equ	17		;width pixels that slider takes up

; Two special illegal opcode words for our "TOTAL" and underline special entries

SPECIAL1	equ	$AFFF		;in the A-line group
SPECIAL2	equ	$AFFE		;in the A-line group

GFXR		MACRO
		move.l	rastport,a1
		GFX	\1
		ENDM

_intena		equ	$DFF000+intena	;for DISABLE/ENABLE macros

;===================================================================================
;===================================================================================
;===============                   =================================================
;=============== START OF PROGRAM  =================================================
;===============                   =================================================
;===================================================================================
;===================================================================================

START_ISAN:	move.l	sp,stack_level		;for clean exits from any call level
		move.l	a0,arg_line		;remember where CLI arguments are

		bsr	init_isan		;init some vars, ptrs...

		bsr	open_libs		;open DOS,gfx,intui, get stdout
		beq	bail_out		;quit now if failed.

		move.l	4.w,a6			;check to see that this machine is
		move.w	AttnFlags(a6),d0	;at least 020 based
		btst	#AFB_68020,d0		;because I need 020 exception frames
		beq	need_020

		bsr	check_args		;validate argument line

		move.l	conf_file,a0		;attempt to load config file
		bsr	load_file
		beq	cant_find_conf

		move.l	d0,conf_size		;remember config file details
		move.l	a0,conf_buffer		;for deallocation when exiting

		bsr	read_configuration	;parse config file & create data structs.

		move.l	#CNTS_BLOCKSIZE,d0	;allocate 256K array of 64K LONG
		move.l	#MEMF_CLEAR|MEMF_PUBLIC,d1	;instruction counters
		EXEC	AllocMem
		move.l	d0,counters
		beq	no_memory		;exit if failed.

		move.l	#MAX_PC_HIST*2*4,d0	;allocate 2 arrays for PC history
		move.l	#MEMF_CLEAR|MEMF_PUBLIC,d1
		EXEC	AllocMem
		move.l	d0,PC_history_PCs
		beq	no_memory		;exit if failed.
		add.l	#MAX_PC_HIST*4,d0
		move.l	d0,PC_history_cnts

		bsr	open_windows		;try to get our display window(s)
		beq	cant_get_window		;error if failed.

		tst.l	opcode_map		;if user also asked for a graphical
		beq	no_map_req		;view of all opcodes used by Task

		bsr	open_screen
		beq	no_screen

;-- At this stage we've got our graphs window, our file, our counters etc...
;-- Now is the time to do the tricky bit: open heart surgery on an unsuspecting Task!

no_map_req	bsr	start_task_traceing	;enable TRACE mode of selected Task

;---------------
main_loop	move.l	DOS_LIB_PTR,a6		;depending on slider gadget setting:
		move.l	update_speed,d1
		DOS	Delay			;slow down graphical stats updating

		bsr	scan_stats		;go through opcode list & stats and
		bsr	update_windows		;update window graphs
		bsr	update_screen		;and opcode bitmap (if enabled)

		bsr	handle_IDCMP		;check slider gadget & close gadget

		tst.b	close_me		;user clicked on CLOSE gadget ?
		beq	main_loop		;no: do main loop again

		bsr	stop_task_traceing	;switch Task back to non-TRACE mode

;-----------------------------------
; This is the wind-down bit of ISAN:
; Close and deallocate everything that we got from system
;-----------------------------------

bail_out	move.l	GFX_LIB_PTR,a6		;doing Graphics closures...

		move.l	font_ptr,d0		;did we successfuly get Topaz font?
		beq	no_font
		move.l	d0,a1
		GFX	CloseFont		;yes, then release before quiting.
;---------------
no_font		move.l	INTUI_LIB_PTR,a6	;doing Intuition closures...

		move.l	window,d0		;if we managed to open our window,
		beq	no_window
		move.l	d0,a0
		INTUI	CloseWindow		;kill it now.

no_window	move.l	regs_window,d0		;same with registers window
		beq	no_regswindow
		move.l	d0,a0
		INTUI	CloseWindow		;kill it now.

no_regswindow	move.l	prof_window,d0		;same with PC profiling window
		beq	no_profwindow
		move.l	d0,a0
		INTUI	CloseWindow		;kill it now.

no_profwindow	move.l	map_screen,d0
		beq	no_scr
		move.l	d0,a0
		INTUI	CloseScreen		;same with opcode map screen
;---------------
no_scr		move.l	4.w,a6			;doing Exec closures...
		
		move.l	#MAX_PC_HIST*2*4,d0
		move.l	PC_history_PCs,d1
		beq	no_PC_history
		move.l	d1,a1
		EXEC	FreeMem			;free PC history if allocated

no_PC_history	move.l	array_size,d0
		move.l	opcode_list,d1
		beq	no_opc_list
		move.l	d1,a1
		EXEC	FreeMem			;free opcodes array if allocated

no_opc_list	move.l	#CNTS_BLOCKSIZE,d0
		move.l	counters,d1
		beq	no_counters
		move.l	d1,a1
		EXEC	FreeMem			;free counters array if allocated

no_counters	move.l	conf_size,d0
		beq	release_libs
		move.l	conf_buffer,a1
		EXEC	FreeMem			;free cached conf file.

release_libs	bsr	close_libs		;finally release our grip on libraries

		move.l	stack_level,sp		;restore original SP (allows quit from
END_ISAN:	rts				;subroutines)

;===================================================================================
;===================================================================================
;===============                   =================================================
;===============  END OF PROGRAM   =================================================
;===============                   =================================================
;===================================================================================
;===================================================================================

;-----------------------------------------------
; Parse argument line according to:
;
; TASK/K,PROCESS/K,SPEED/K,MODE/K,REGS/S,TOTAL/S,GRAFMAP/S,FILE/K,PROFILE/S
;
; e.g. 1> ISAN TASK $7d0432C SPEED 1 MODE 2 TOTAL
;-----------------------------------------------

check_args	bsr	clear_results		;set default results for ReadArgs

		move.l	#ISAN_template,d1	;our argument template
		move.l	#rda_results,d2
		bsr	ReadArgs		;parse command line (2.0 style)
		beq	give_syntax		;malformed arguments ? -> give help

		move.l	task_arg,d0		;if task AND process args are given:
		and.l	process_arg,d0		;sorry, need exactly one.
		bne	task_or_proc_please

		move.l	task_arg,d0		;if NEITHER task OR process args are
		or.l	process_arg,d0		;given: sorry need one.
		beq	give_syntax
;---------------
		tst.l	profile_flag		;user wants branching/loop profiling ?
		beq	which_mode
		move.l	#1,trace_mode		;force trace mode to MODE 2
		bra	which_speed		;skip user's mode selection
;---------------
which_mode	move.l	trace_mode,a0		;check out the trace mode argument
		moveq	#0,d0
		move.b	(a0),d0
		cmp.b	#'1',d0			;trace all instructions (MODE 1) ?
		beq	good_mode

		cmp.b	#'2',d0			;or trace program flow changes (MODE 2)
		bne	wrong_mode
good_mode	sub.b	#'1',d0
		move.l	d0,trace_mode		;store 0 or 1 (MODE 1 or 2 resp.)
;---------------
which_speed	move.l	update_speed,a0
		move.l	a0,a4
		bsr	DEC_TO_BIN		;get SPEED <decimal> argument
		cmp.l	a0,a4			;if argument wasn't decimal
		beq	invalid_update_sp	;error!
		tst.l	d1			;or delay is 0
		beq	invalid_update_sp

		move.l	#50*10,d0		;check that user doesn't give a huge
		cmp.l	d0,d1			;delay factor coz that would freeze
		bcs	decent_speed		;our IDCMP loop too !
		move.l	d0,d1
decent_speed	move.l	d1,update_speed		;else use user value as speed
;---------------
		move.l	task_arg,d0		;look for a Task or a Process?
		beq	get_Process

get_Task	move.l	d0,a0			;check task address syntax
		cmp.b	#'$',(a0)+
		bne	want_dollar_hex

		bsr	hex_to_bin		;convert Task hex address to bin
		move.l	d0,tcb_ptr		;remember Task address

		bsr	check_taskaddr		;validate Task
		bne	task_doesnt_exist	;if Task exists,

		lea	window_info,a0		;-> window title append position
		move.l	#'TASK',(a0)+		;regardless of odd allignment (68030 **!!)
		move.w	#' $',(a0)+		;append string "TASK $hhhhhhhh)",0
		move.l	tcb_ptr,d0
		moveq	#8,d1
		bsr	bin_hex			;(reconvert Task addr to clean 8 chars)

		lea	task_addr_str+8,a0
		move.w	#')'<<8,(a0)+		;finish off title string
		rts
;---------------
get_Process	move.l	process_arg,a0		;-> decimal process number
		move.l	a0,a4
		bsr	DEC_TO_BIN		;get decimal number
		cmp.l	a0,a4
		beq	bad_procnum

		move.l	d1,d7
		bsr	check_process		;find Process N
		move.l	d2,tcb_ptr		;if found, store its TCB addr.
		beq	proc_doesnt_exist

		lea	window_info,a0		;now add string "PROCESS N)",0
		move.l	#'PROC',(a0)+		;to end of window title
		move.l	#'ESS ',(a0)+
		move.l	process_arg,a1
		move.b	(a1)+,(a0)+		;copy 1st process ID decimal digit
		cmp.b	#9,d7			;was process number 2 digits ?
		ble	end_title
		move.b	(a1)+,(a0)+		;copy 2nd digit

end_title	move.w	#')'<<8,(a0)+		;finish off title string
		rts
;-----------------------------------------------
; Open graphs Window (sized according to how long opcode list is).
; Set the TextFont to "topaz 8" so that any Preferences font doesn't
; screw up our neat display.
;
; Return EQ if failed.
;-----------------------------------------------

open_windows	move.l	INTUI_LIB_PTR,a6	;using Intuition...
		move.l	#MyNewWindow,a0
		INTUI	OpenWindow		;open output window (incl. slider gadg)
		move.l	d0,window		;if ISAN.conf list too big then window
		req				;won't be able to open (too high)

		move.l	d0,a0
		move.l	wd_UserPort(a0),msgport	;also find Window's IDCMP msg port
		move.l	wd_RPort(a0),rastport	;and graphics RastPort

		move.l	GFX_LIB_PTR,a6		;using graphics.library...
		lea	textattr,a0
		GFX	OpenFont		;get Topaz 8 ROM font
		move.l	d0,font_ptr
		req

		move.l	d0,a0
		GFXR	SetFont			;use this font for our Window
;---------------
		tst.l	show_regs		;should we also open a register info
		beq	no_regswin

		move.l	INTUI_LIB_PTR,a6	;using Intuition again...

		move.l	#MyNewWindow,a0		;modify initial NewWindow struct
		add.w	#(WINDOW_WIDTH-386)/2,nw_LeftEdge(a0)
		move.w	#386,nw_Width(a0)
		move.w	#55,nw_Height(a0)
		move.w	#50,nw_TopEdge(a0)
		clr.l	nw_FirstGadget(a0)
		clr.l	nw_IDCMPFlags(a0)	;window generates NO messages
		and.l	#~WINDOWCLOSE,nw_Flags(a0)	;no close gadget on this win.
		
		move.l	#regswin_title,nw_Title(a0)
		INTUI	OpenWindow		;open output window (incl. slider gadg)
		move.l	d0,regs_window		;if ISAN.conf list too big then window
		req				;won't be able to open (too high)

		move.l	d0,a0
		move.l	wd_RPort(a0),regswin_rp

		move.l	GFX_LIB_PTR,a6		;switch to graphics library
		move.l	font_ptr,a0
		move.l	regswin_rp,a1
		GFX	SetFont			;use 8*8 font for our Window

		bsr	draw_regswin_txt
;---------------
no_regswin	tst.l	profile_flag		;should we also open a PC stats win?
		beq	no_profile_win

		move.l	INTUI_LIB_PTR,a6	;using Intuition again...
		move.l	#MyNewWindow,a0
		move.w	#512,nw_Height(a0)
		move.w	#640,nw_Width(a0)
		clr.w	nw_LeftEdge(a0)
		clr.w	nw_TopEdge(a0)
		clr.l	nw_FirstGadget(a0)
		clr.l	nw_IDCMPFlags(a0)	;window generates NO messages
		and.l	#~WINDOWCLOSE,nw_Flags(a0)	;no close gadget on this win.
		
		move.l	#prof_win_title,nw_Title(a0)
		INTUI	OpenWindow		;open output window (incl. slider gadg)
		move.l	d0,prof_window		;if ISAN.conf list too big then window
		req				;won't be able to open (too high)

		move.l	d0,a0
		move.l	wd_RPort(a0),profwin_rp ;init its RastPort ptr

		move.l	GFX_LIB_PTR,a6		;switch to graphics library
		move.l	font_ptr,a0
		move.l	profwin_rp,a1
		GFX	SetFont			;use 8*8 font for our Window

		move.l	profwin_rp,a1
		moveq	#1,d0			;use Black for text
		GFX	SetAPen
;---------------
no_profile_win	moveq	#-1,d0			;NE = OK!
		rts
;-----------------------------------------------
; Draw some static text in the freshly opened REGISTERS window.
;-----------------------------------------------
draw_regswin_txt:
		move.l	regswin_rp,a1
		moveq	#1,d0			;use Black for text
		GFX	SetAPen

		lea	regstrings,a3		;-> strings to print
		moveq	#4-1,d7			;print 4 lines of 4 registers
		moveq	#PANE_Y+CHAR_HEIGHT,d4

pr_regline	moveq	#4-1,d6
		moveq	#PANE_X,d3		;reset cursor X

pr_reg		move.l	regswin_rp,a1
		move.w	d3,d0
		move.w	d4,d1
		GFX	Move

		moveq	#3,d0
		move.l	a3,a0
		move.l	regswin_rp,a1
		GFX	Text			;print a string "Rn="

		lea	3(a3),a3		;point to next string
		add.w	#12*CHAR_WIDTH,d3
		dbra	d6,pr_reg
	
		add.w	#CHAR_HEIGHT,d4		;go down a line
		dbra	d7,pr_regline
;---------------
		move.l	regswin_rp,a1
		moveq	#PANE_X,d0		;reset cursor X
		move.w	d4,d1
		GFX	Move

		moveq	#3,d0
		move.l	a3,a0
		move.l	regswin_rp,a1
		GFX	Text			;"PC="

		rts
;-----------------------------------------------
; If user requested the GRAFMAP command line option,
; open lo-res 256*256 screen and draw the nibble reference grid.
;
; Every single opcode used by the traced Task will light up one pixel
; corresponding to its exact opcode (0..65535 !).
;-----------------------------------------------
open_screen	move.l	INTUI_LIB_PTR,a6	;because the opcode map screen is so
		move.l	ib_FirstScreen(a6),a0	;extremely narrow (256 pixels wide),
		move.w	sc_Width(a0),d0		;find out width of Workbench (+-)
		lsr.w	#1,d0			;(convert to lores pixels)
		sub.w	#256,d0			;and center our screen on monitor...
		lsr.w	#1,d0

		lea	map_newscreen,a0
		move.w	d0,ns_LeftEdge(a0)

		INTUI	OpenScreen		;open graphical opcode usage display
		move.l	d0,map_screen
		req

		move.l	d0,a0
		lea	sc_RastPort(a0),a2
		move.l	GFX_LIB_PTR,a6

		move.l	a2,a1
		moveq	#2,d0			;write reference grid in plane 1
		GFX	SetAPen

		moveq	#16-1,d7		;write 16 horizontal lines
		move.w	#12,d2			;starting Y with (0,12)-(255,12)

draw_horiz	moveq	#0,d0
		move.w	d2,d1
		move.l	a2,a1			;get RastPort ptr
		GFX	Move

		move.w	#255,d0
		move.w	d2,d1
		move.l	a2,a1
		GFX	Draw

		add.w	#16,d2			;increment Y
		dbra	d7,draw_horiz
;---------------
		moveq	#16-1,d7		;write 16 vertical lines
		moveq	#0,d2			;starting with (0,12)-(0,255+12)

draw_vert	move.w	d2,d0
		moveq	#12,d1
		move.l	a2,a1
		GFX	Move

		move.w	d2,d0
		move.w	#12+255,d1
		move.l	a2,a1
		GFX	Draw

		add.w	#16,d2			;increment X
		dbra	d7,draw_vert

		moveq	#-1,d0			;return OK.
		rts
;-----------------------------------------------
; Error EXITS (print error, clean up and quit)
;-----------------------------------------------
no_memory	lea	no_arr_mem,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
want_dollar_hex	lea	dollars_please,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
bad_procnum	lea	dec_procnum,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
give_syntax	lea	syntax,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
cant_find_conf	lea	no_conf,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
task_doesnt_exist
		lea	bad_task,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
proc_doesnt_exist
		lea	bad_proc,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
wrong_mode	lea	bad_trace_mode,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
invalid_update_sp
		lea	bad_speed,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
cant_get_window	lea	win_too_big,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
task_or_proc_please
		lea	plonker,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
need_020	lea	wrong_machine,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
bad_conf_err	lea	bad_conf_file,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
no_mem_for_descr
		lea	no_descr_mem,a0
		bsr	print_error
		bra	bail_out
;-----------------------------------------------
no_screen	lea	no_screen_str,a0
		bsr	print_error
		bra	bail_out

;-----------------------------------------------
; Check our Window's IDCMP MessagePort for any Intuition events.
;-----------------------------------------------

handle_IDCMP
while_msgs	move.l	4.w,a6
		move.l	msgport,a0
		EXEC	GetMsg			;dequeue IntuiMessage.
		tst.l	d0
		req				;if no event: exit

		move.l	d0,a1			;A1 -> IntuiMessage
		move.l	im_Class(a1),imsg_class	;copy relevant message info
		move.w	im_Code(a1),imsg_code
		move.l	im_IAddress(a1),imsg_iaddr
		move.l	im_MouseX(a1),imsg_ratcords	;relative to window
		EXEC	ReplyMsg		;and return msg to Intuition

		move.l	imsg_class,d0		;now find routine to execute
		lea	event_routines,a0	;for this event
		bra	wh_msg_types

possible_event	move.l	(a0)+,a1		;assuming this type: get vector
		cmp.l	d0,d1			;is this the event type we got ?
		beq	handle_event		;yes: go exec handler for this type.

wh_msg_types	move.l	(a0)+,d1		;get possible event type
		bpl	possible_event
		bra	while_msgs
;---------------
handle_event	jsr	(a1)			;yes, process event
		bra	while_msgs		;any other events queued up?

;=======================================================================
		EVEN
event_routines
;		dc.l	MOUSEMOVE,follow_mouse	;when moving about in gadget
;		dc.l	GADGETDOWN,gadget_on	;when first clicked
;		dc.l	MENUPICK,handle_menus	;when selecting menu items
;		dc.l	RAWKEY,keypress		;for value entry & arrow keys

		dc.l	GADGETUP,gadget_off	;when released
		dc.l	MOUSEBUTTONS,handle_click ;any clicks in Window
		dc.l	CLOSEWINDOW,kill_program

		dc.l	-1			;end of list
;=======================================================================

;-----------------------------------------------
; User messed around with our slider gadget and finally released it.
; Read new knob position and adjust program update speed accordingly.
;-----------------------------------------------

gadget_off	lea	GadgetSInfo,a0		;-> PropInfo struct for our slider

		moveq	#0,d0
		move.w	pi_VertPot(a0),d0	;get new pot setting	(0..64K)
		moveq	#9,d1
		lsr.w	d1,d0			;scale it down a bit	(0..127)
		move.l	d0,update_speed		;max Delay() is 2.54 secs (127)
		rts
;-----------------------------------------------
; Any click inside our window resets all counters (resets graphs to zero).
;-----------------------------------------------
handle_click	move.w	imsg_code,d0		;discard release clicks
		and.w	#$0080,d0
		rne

		move.l	counters,a0		;-> array of LONG counters
		moveq	#-1,d0
		moveq	#0,d1
reset_counters	move.l	d1,(a0)+		;wipe all 65536 counters clean
		dbra	d0,reset_counters

wipe_counters	move.l	GFX_LIB_PTR,a6
		moveq	#0,d0			;switch to background color for wipe
		GFXR	SetAPen

		moveq	#PANE_X,d0		;top-left corner for rectfill
		moveq	#PANE_Y+2,d1
		add.w	label_len,d0

		move.w	d0,d2			;calc bot-right corner coords
		move.w	d1,d3
		add.w	#HEXNUM_SPACE-1,d2
		add.w	contents_height,d3
		add.w	#1,d3
		GFXR	RectFill		;wipe previous counters

		rts
;-----------------------------------------------
kill_program	st	close_me		;signal main loop to exit.
		rts

;-----------------------------------------------
; Analyse cached "ISAN.config" file.
; Validate format and create data structures for contents, the free file.
; Each line is either a comment line or a line with three comma-separated fields:
;    OPCODE,MASK,LABEL
;
; If argument flag "TOTAL" was present, add two special entries to show TOTAL
; number of instructions counted !!
;-----------------------------------------------

read_configuration
		clr.w	opcodes			;clr # of opcodes encountered
		lea	count_opcodes,a5
		bsr	scan_file		;go through file and count opcode lines

		tst.l	total_flag		;did user ask for automatic TOTAL too?
		beq	get_descr_array
		addq.w	#2,opcodes		;make room for 2 more special entries

get_descr_array	move.l	4.w,a6
		move.w	opcodes,d0		;now allocate a memory block to hold
		beq	bad_conf_err		;exactly N Opcode descriptors structs

		mulu	#opc_sizeof,d0
		move.l	d0,array_size
		move.l	#MEMF_CLEAR|MEMF_PUBLIC,d1
		EXEC	AllocMem
		move.l	d0,opcode_list		;opcode_list -> array to fill in.
		beq	no_mem_for_descr

		moveq	#0,d7			;max label length so far..

		move.l	opcode_list,a4		;-> descriptor array to initialise
		tst.l	total_flag		;if total flag is set add our two
		beq	fill_descriptors	;special entries at the top of list
;---------------
		moveq	#5,d7			;max label length so far...

		move.w	#1,opc_combis(a4)
		move.w	#SPECIAL1,opc_base_op(a4)  ;use an A-line opcode to signal
		clr.w	opc_nocare_mask(a4)	   ;special TOTAL "opcode"
		move.l	#total_label,opc_label(a4) ;point to built-in label
		move.w	d7,opc_label_len(a4)
		add.l	#opc_sizeof,a4		;point to next free slot

		move.w	#1,opc_combis(a4)	   ;do a similar thing to get an
		move.w	#SPECIAL2,opc_base_op(a4)  ;"underline" entry !
		clr.w	opc_nocare_mask(a4)
		move.l	#underline_label,opc_label(a4)
		move.w	d7,opc_label_len(a4)
		add.l	#opc_sizeof,a4		;point to next free slot
;---------------
fill_descriptors
		lea	get_data,a5		;go through file again but grab data
		bsr	scan_file		;to fill in descriptors.
		bne	bad_conf_err

		mulu	#CHAR_WIDTH,d7		;calc howmany width pixels labels
		move.w	d7,label_len		;will take up.

		move.w	opcodes,d0		;calc howmany pixels high instruction
		mulu	#CHAR_HEIGHT,d0		;list will be
		sub.w	#3,d0			; - a bit to avoid wiping window edge
		move.w	d0,contents_height

		add.w	#PANE_Y+8,d0		;and automaticaly size
		move.w	d0,win_h		;window and
		sub.w	#16,d0
		move.w	d0,gad_h		;attached slider gadget.
;---------------
		rts
;-----------------------------------------------
; Go through cached ISAN.config file line-by-line and execute a user routine for
; every line starting with a "$".
; 
; A4 -> Opcode descriptor array ptr
; A5 -> user routine to execute
; RETURNS (NE) if error occurred.
;-----------------------------------------------
scan_file	move.l	conf_buffer,a0		;-> cached ISAN.conf file

		bra	wh_lines
;---------------
check_line	cmp.b	#'$',(a0)		;instruction line ?
		beq	handle_line		;no, skip over entire line

skip_comment	move.b	(a0)+,d0
		beq	file_eof
		cmp.b	#LF,d0
		bne	skip_comment
		bra	wh_lines
;---------------
handle_line	addq.w	#1,a0			;skip "$"
		jsr	(a5)			;exec routine for a line starting w. $
		bra	skip_comment
;---------------
wh_lines	tst.b	(a0)			;reached EOF yet ?
		bne	check_line
;---------------
file_eof	rts
		
;-----------------------------------------------
; Initial user routine for scan_file to count opcode lines
;-----------------------------------------------
count_opcodes	addq.w	#1,opcodes		;just keep track of "$" lines
		rts
;-----------------------------------------------
; Decode a $XXXX,$MMMM,"label" line
;
; A0 -> start of current line
; A4 -> next free Opcode descriptor slot
; D7 = maximum label length
;-----------------------------------------------

get_data	bsr	hex_to_bin		;get basic opcode pattern
		move.w	d0,opc_base_op(a4)

		cmp.b	#COMMA,(a0)+		;need delimiter
		bne	bad_conf_err
		cmp.b	#'$',(a0)+		;need hex number qualifier
		bne	bad_conf_err

		bsr	hex_to_bin		;get dont care mask
		move.w	d0,opc_nocare_mask(a4)

		bsr	count_ones_in_D0	;calc howmany opcode combinations
		moveq	#0,d1			;dont care mask means !
		bset	d0,d1
		move.w	d1,opc_combis(a4)

		cmp.b	#COMMA,(a0)+		;need delimiter
		bne	bad_conf_err
		cmp.b	#DOUBLE_QUOTE,(a0)+	;followed by start of string
		bne	bad_conf_err
	
		move.l	a0,opc_label(a4)	;store ptr to label string
		move.l	a0,a1

calc_lab_len	cmp.b	#DOUBLE_QUOTE,(a1)+
		bne	calc_lab_len		;find end of label

		sub.l	opc_label(a4),a1	;calc label length
		sub.w	#1,a1
		move.w	a1,opc_label_len(a4)

		cmp.w	d7,a1			;label longer than all prev ones?
		bcs	no_new_max
		move.w	a1,d7			;yes, update max length
no_new_max	

		add.l	#opc_sizeof,a4		;point to next free slot
		rts

;===================================================================================
; Go through opcode_list and stats array and generate list of opcode counters
; which we need to display.
; Find Maximum counter and scale all counters for clean display in window.
;
; LOOP REGISTERS:
;	D6 = maximum frequency so far
;	D7 = # of opcodes/groups to display
;	A4 -> current opcode descriptor
;	A5 -> base of counters array
;===================================================================================

scan_stats	move.l	4.w,a6			;stop target Task (and all others!)
		FORBID				;so we can make consistent freq counts

		moveq	#0,d6			;max freq so far
		clr.l	most_frequent		;clr ptr to slot of highest freq opc

		move.w	opcodes,d7		;# of opcodes (groups) to scan
		subq.w	#1,d7			;-1 DBRA 
		move.l	opcode_list,a4		;-> array of opcode descriptors
		move.l	counters,a5		;-> 1 LONG for every 680x0 opcode!

;---------------
check_op_group	move.w	opc_combis(a4),d5	;range of instructions or single ?
		subq.w	#1,d5			;(-1 DBRA)
		bne	handle_range

		moveq	#0,d0			;clear for LONG index !
		move.w	opc_base_op(a4),d0	;get opcode (all bits significant)
		cmp.w	#SPECIAL1,d0
		beq	calc_fast_total

		move.l	0(a5,d0.l*4),d1		;get current cnt for this instruction
		bra	update_max		;join main flow again...
;---------------
; Here we go through counters array linearly and find total sum of instructions
; executed so far. This is faster than using the general purpose mask technique.
;---------------
calc_fast_total	move.l	a5,a0
		moveq	#0,d1			;clear counter
		move.w	#(65536/8)-1,d0		;add up all 65536 LONG counters
zap_through_it	add.l	(a0)+,d1		;as quickly as possible...
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		add.l	(a0)+,d1
		dbra	d0,zap_through_it

;-- for TOTAL "opcode" we have a custom update_max which doesn't touch most_frequent
		move.l	d1,opc_freq(a4)		;remember locally
		cmp.l	d6,d1			;need to update maximum freq ?
		bcs	next_opc
		move.l	d1,d6			;new max freq = current inst freq
		bra	next_opc

;---------------
; Here we have to generate ALL possible opcodes given the opcode template and
; the Don't Care bits mask.
; This isn't as straightforward as you might think.
;
; D7 = outer opcodes loop counter
; D6 = maximum frequency so far
; D5 = # of combinations in this opcode group
;---------------

handle_range	move.w	opc_nocare_mask(a4),d4	;get dont care mask
		move.w	opc_base_op(a4),d3	;get opcode TEMPLATE

		move.w	d4,d2
		not.w	d2			;inverted dont care mask
		and.w	d2,d3			;d3 = 100% clean template mask

; Say we have a dont care mask of $0E43. That's a mask with 3 bitfields that we
; should increment as if it were ONE contiguous bitfield.
; This is achieved by forcing all bits inbetween the bitfields to '1' and adding
; an "add mask" (the LSb '1' in the original mask); this way carry bits from a
; bitfield are transported across a 1s "bridge" to the next bitfield etc..
; The final opcode is derived from this "work" opcode and the original template by
; some ANDing and ORing.

		move.w	d4,d0			;original don't care mask
		moveq	#-1,d1			;calc the "add mask"
find_first_lsb	addq.w	#1,d1			;(= the lowest 1 bit in the mask on
		lsr.w	#1,d0			;its own).
		bcc	find_first_lsb
		moveq	#0,d0
		bset	d1,d0			;D0 is add mask.

		sub.l	a0,a0			;clr accumulated freq of opc family
		moveq	#0,d1			;FOR CNT=0 TO COMBI-1
;--------
gen_codes	and.w	d4,d1			;mask out "scattered count"
		or.w	d3,d1			;or in clean template = final opcode

		add.l	0(a5,d1.l*4),a0		;add its freq to total group freq

		or.w	d2,d1			;0 holes = bitfields
		add.w	d0,d1			;"add" across bitfield voids

		dbra	d5,gen_codes		;all possible combinations generated?

		move.l	a0,d1			;sum total of opcode group
;---------------
update_max	move.l	d1,opc_freq(a4)		;total # of ops of this type counted
		cmp.l	d6,d1			;need to update maximum freq ?
		bcs	next_opc

		move.l	d1,d6			;new max freq = current inst freq
		move.l	a4,most_frequent	;remember most freq opc slot
;---------------
next_opc	add.l	#opc_sizeof,a4		;goto next descriptor
		dbra	d7,check_op_group	;all done ?

;-----------------------------
; We've gone through all opcodes we want to snoop on.
; From the found maximum frequency normalize all frequencies so that max = $FFFFFFFF
;-----------------------------

		or.b	#1,d6			;force max freq to have at least one 1 bit
		bfffo	d6{0:32},d0		;find # of LEFT shifts to normalize max

		move.w	opcodes,d7		;# of opcodes (groups) to scan
		subq.w	#1,d7			;-1 DBRA 
		move.l	opcode_list,a4		;-> array of opcode descriptors

norm_counts	move.l	opc_freq(a4),d1		;get original frequency
		lsl.l	d0,d1			;normalize it
		move.l	d1,opc_xfreq(a4)	;store normalized frequency

		add.l	#opc_sizeof,a4		;goto next descriptor
		dbra	d7,norm_counts		;all done ?

		move.l	4.w,a6			;thanks for hanging around guys...!
		PERMIT				;carry on now..
	
		rts
;-----------------------------------------------
; Redraw ENTIRE contents of Window.	(**!! Should optimize)
;-----------------------------------------------
update_windows	bsr	update_op_counters
		bsr	update_registers
		bsr	update_PC_counters
		rts
;-----------------------------------------------
; Update the main statistics window containing opcode usage frequencies.
;-----------------------------------------------
update_op_counters
		move.l	GFX_LIB_PTR,a6		;using graphics.library...
		moveq	#1,d0			;set color for labels & hex frequencies
		GFXR	SetAPen

		moveq	#PANE_X,d5		;initial cursor coords.
		moveq	#PANE_Y+CHAR_HEIGHT,d6

		move.w	opcodes,d7		;# of graphs/labels to draw
		subq.w	#1,d7
		move.l	opcode_list,a4		;-> array of opcode descriptors
;---------------
draw_labels	tst.b	add_labels		;have labels already been printed ?
		beq	skip_labels		;yes, don't print again (since static)

		move.w	d5,d0
		move.w	d6,d1
		GFXR	Move			;set text cursor for label

		move.l	opc_label(a4),a0
		move.w	opc_label_len(a4),d0
		GFXR	Text			;print label

skip_labels	move.l	opc_freq(a4),d0		;create hex string from freq.
		beq	zero_cnt		;if freq is zero then just print "0"

		moveq	#8,d1			;otherwise print hex number as eight
		lea	hex_output,a0		;full digits
		bsr	bin_hex

		move.w	d5,d0
		move.w	d6,d1
		add.w	label_len,d0		;just after labels...
		GFXR	Move			;set cursor for frequency

		moveq	#8,d0
		lea	hex_output,a0
		GFXR	Text			;print hex frequency 'xxxxxxxx'
		bra	do_labels
;--------
zero_cnt	move.w	d5,d0
		move.w	d6,d1
		add.w	label_len,d0		;just after labels...
		add.w	#7*CHAR_WIDTH,d0	;(strip leading zeros)
		GFXR	Move			;set cursor for frequency

		moveq	#1,d0
		lea	a_zero,a0
		GFXR	Text			;print hex frequency '       0'

do_labels	add.w	#CHAR_HEIGHT,d6		;down one line
		add.l	#opc_sizeof,a4		;goto next descriptor
		dbra	d7,draw_labels

		sf	add_labels		;from now: never draw labels again
;---------------
wipe_graph_area	moveq	#0,d0			;switch to background color for wipe
		GFXR	SetAPen

		moveq	#PANE_X+HEXNUM_SPACE,d0	;top-left corner for rectfill
		add.w	label_len,d0
		moveq	#PANE_Y+3,d1

		moveq	#PANE_X,d2		;calc bot-right corner coords
		add.w	win_width,d2
		sub.w	#GADG_WIDTH,d2
		move.w	contents_height,d3
		add.w	d1,d3
		GFXR	RectFill		;wipe previous graphs display
;---------------
		moveq	#0,d0
		move.w	win_width,d0		;total window width
		sub.w	label_len,d0		;- area where labels go
		sub.w	#PANE_X+HEXNUM_SPACE+5,d0 ;= available drawing length

		bfffo	d0{0:32},d4		;calc window width scale factor
		addq.w	#1,d4
;---------------
		moveq	#PANE_Y+4,d6
		moveq	#PANE_X+HEXNUM_SPACE,d5	;initial pen X,Y
		add.w	label_len,d5
		add.w	#2,d5

		move.w	opcodes,d7		;# of graphs/labels to draw
		subq.w	#1,d7
		move.l	opcode_list,a4		;-> array of opcode descriptors

draw_graph	tst.l	opc_xfreq(a4)		;any graph to draw at all ??
		beq	skip_graph		;yes, (freq non-zero)

		moveq	#2,d0			;assume normal graph color
		cmp.l	most_frequent,a4	;does this slot represent max freq?
		bne	draw_line		;yes,

		moveq	#1,d0			;highlight longest opcode graph

draw_line	GFXR	SetAPen			;select color for graph

		move.w	d5,d0
		move.w	d6,d1
		GFXR	Move			;Move to start of line

		move.l	opc_xfreq(a4),d0	;get LONG normalized inst. freq.
		lsr.l	d4,d0			;scale to fit window
		add.w	d5,d0			;add positioning offset
		move.w	d6,d1
		GFXR	Draw			;draw a bargraph line

skip_graph	add.w	#CHAR_HEIGHT,d6		;down one line
		add.l	#opc_sizeof,a4		;goto next descriptor
		dbra	d7,draw_graph
		rts
;-----------------------------------------------
;-- Now optionally dump all registers in REGISTER window
;-----------------------------------------------
update_registers
		tst.l	regswin_rp		;if no register window: don't
		req

		lea	regs_dump,a3		;-> 16 registers to display

		moveq	#4-1,d7			;print 4 lines of 4 registers
		moveq	#PANE_Y+CHAR_HEIGHT,d4

print_regline	moveq	#4-1,d6
		moveq	#PANE_X+3*CHAR_WIDTH,d3	;reset cursor X

print_reg	move.l	regswin_rp,a1
		move.w	d3,d0
		move.w	d4,d1
		GFX	Move

		move.l	(a3)+,d0		;get a register value
		moveq	#8,d1
		lea	hex_output,a0
		bsr	bin_hex			;convert to ASCII string

		moveq	#8,d0
		lea	hex_output,a0
		move.l	regswin_rp,a1
		GFX	Text

		add.w	#12*CHAR_WIDTH,d3
		dbra	d6,print_reg
	
		add.w	#CHAR_HEIGHT,d4
		dbra	d7,print_regline
;---------------
		move.l	(a3)+,d0		;get PC register value
		moveq	#8,d1
		lea	hex_output,a0
		bsr	bin_hex			;convert to ASCII string

		move.l	regswin_rp,a1
		moveq	#PANE_X+3*CHAR_WIDTH,d0	;reset cursor X
		move.w	d4,d1
		GFX	Move

		moveq	#8,d0
		lea	hex_output,a0
		move.l	regswin_rp,a1
		GFX	Text			;"PC=XXXXXXXX"
		rts
;-----------------------------------------------
; Optionally update PC counters in PC PROFILE window.
;-----------------------------------------------
update_PC_counters
		tst.l	profwin_rp		;if no register window: don't
		req

		tst.w	num_PCs			;if any PCs trapped yet...
		req

		move.l	PC_history_PCs,a3	;-> N PC statistics to display
		move.l	PC_history_cnts,a4	;->

		moveq	#0,d7			;print N lines ...

print_PC_line	moveq	#0,d0
		move.w	d7,d0			;list grows like newspaper columns
		divu	#42,d0
		move.l	d0,d1			;save quotient
		swap	d0			;get remainder down
		mulu	#CHAR_HEIGHT,d0
		add.w	#PANE_Y+CHAR_HEIGHT,d0

		mulu	#20*CHAR_WIDTH,d1
		add.w	#PANE_X,d1

		exg	d0,d1			;AARRGGHHH !!

		move.w	d0,d3
		move.w	d1,d4

		move.l	profwin_rp,a1
		GFX	Move

		move.l	(a3),d0			;get a PC register value
		moveq	#8,d1
		lea	hex_output,a0
		bsr	bin_hex			;convert to ASCII string

		moveq	#8,d0
		lea	hex_output,a0
		move.l	profwin_rp,a1
		GFX	Text
;------
just_print_cnt	move.w	d3,d0
		add.w	#10*CHAR_WIDTH,d0
		move.w	d4,d1
		move.l	profwin_rp,a1
		GFX	Move

		move.l	#'    ',hex_output
		move.l	#'   0',hex_output+4
		move.l	(a4)+,d0		;get # of times PC got here (counter)
		moveq	#8,d1
		lea	hex_output,a0
		bsr	bin_hex			;convert to ASCII string

		moveq	#8,d0
		lea	hex_output,a0
		move.l	profwin_rp,a1
		GFX	Text

		addq.w	#4,a3			;-> next PC value
		addq.w	#1,d7
		cmp.w	num_PCs,d7		;done entire list ?
		bne	print_PC_line

		rts
;-----------------------------------------------
; Go through counters array and plot a pixel in the map screen for every non-zero
; counter.
; We don't use a pixel plot routine (much too slow), instead we check 32 opcodes
; in one go, creating a bunch of 32 pixels in a data reg and then we write this
; to the screen.
;-----------------------------------------------

LINE_SIZE	equ	32			;bytes for a 256 pixels line

update_screen	tst.l	opcode_map		;is screen enabled ?
		req				;yep,

		move.l	map_screen,a1
		lea	sc_BitMap+bm_Planes(a1),a1
		move.l	(a1),a1			;get bitplane 0 ptr
		add.l	#12*LINE_SIZE,a1	;skip Screen Title/Dragbar area.

		move.l	counters,a0		;get base address of counters array
		move.w	#(65536/32)-1,d7	;check all opcodes in blocks of 32

plot_counters	moveq	#32-1,d1		;construct 32 pixels in register
		moveq	#0,d0			;clear pixel line LONG

constr_pixline	tst.l	(a0)+			;opcode used at all ?
		beq	unused_opcode		;yes,
		bset	d1,d0			;set its pixel (use DBRA counter as bit #)

unused_opcode	dbra	d1,constr_pixline

		move.l	d0,(a1)+		;blast 32 pixels into screen at a time
		dbra	d7,plot_counters
		rts
;-----------------------------------------------
; Set all program parameters to defaults before parsing argument line.
;-----------------------------------------------

clear_results	clr.l	task_arg		;
		clr.l	process_arg		;

		move.l	#twenty,update_speed	;DOS Delay() factor
		move.l	#one,trace_mode		;default TRACE mode = 1

		clr.l	total_flag		;don't add total counter !
		clr.l	profile_flag		;don't use profiling

		move.w	#WINDOW_WIDTH,win_width	

		move.l	#default_conf,conf_file

dummy		rts

;-----------------------------------------------
; Validate user's Process ID.
; Return EQ if Task exists
;
; IN : D7.L = Process #
;
; OUT: D2.L = Process TCB addr or NULL
;-----------------------------------------------

check_process	move.l	4.w,a6			;-> Exec Library

		DISABLE				;no list altering while we look!
		lea	TaskWait(a6),a5		;scan TaskWait list first (most likely)
		bsr	find_process
		bne	is_process

		lea	TaskReady(a6),a5	;if not on Wait list, maybe on Ready
		bsr	find_process

is_process	ENABLE
		rts
;-----------------------------------------------
; Try to find Process N on given Task list
; A5 -> List Head
; D7.L = Process number
;-----------------------------------------------
find_process	move.l	(a5),d1			;get head of list
		beq	plist_end

		move.l	d1,a5			;move LN_SUCC to curr Node ptr

		cmp.b	#NT_PROCESS,LN_TYPE(a5)	;is this a Process ?
		bne	find_process		;no, goto next Task

		cmp.l	pr_TaskNum(a5),d7	;ok, is this the Process we want ?
		bne	find_process

		move.l	a5,d2			;yes: return tcb addr.
		rts
;---------------
plist_end	moveq	#0,d2			;didn't find Process (return NULL)
		rts
;-----------------------------------------------
; Validate user's TASK address.
; Return EQ if Task exists
;-----------------------------------------------

check_taskaddr	move.l	4.w,a6			;-> Exec Library
		move.l	tcb_ptr,a0		;find Task node with this start adr

		DISABLE				;no list altering while we look!
		move.l	TaskWait(a6),a5		;scan TaskWait list first (most likely)
		bsr	find_task
		beq	is_task

		move.l	TaskReady(a6),a5	;maybe a CPU hog then ?
		bsr	find_task
		beq	is_task

		ENABLE
		moveq	#-1,d0			;NE = nope, couldn't find Task
		rts

is_task		ENABLE
		moveq	#0,d0			;EQ = yep, found Task
		rts
;-----------------------------------------------
; Try to find Task X on given Task list
; A5 -> List Head
; A0 -> Task addr
;-----------------------------------------------
find_task	tst.l	(a5)			;is this node the Tail of list ?
		beq	list_tail		;nope.

		cmp.l	a5,a0			;check against user input
		beq	task_present		;if match return EQ

		move.l	(a5),a5
		bra	find_task

list_tail	moveq	#-1,d0			;else NE
task_present	rts
;-----------------------------------------------
; Modify the target Task's trace bits in its SR (stored in its saved context).
; Point its TC_TRAP vectors to our stuff to handle all those TRACE exceptions.
;-----------------------------------------------

start_task_traceing
		move.l	tcb_ptr,a5		;-> Task/Process to snoop on.

		move.l	counters,TC_TRAPDATA(a5)	;tell handler where counters are
		move.l	TC_TRAPCODE(a5),old_trapcode	;save any old trap handlers

		lea	default_handler,a0	;choose which trace handler to use

		tst.l	profile_flag
		beq	use_regs_maybe

		lea	proftrace_handler,a0
		bra	curse_task

use_regs_maybe	tst.l	show_regs
		beq	curse_task
		lea	rgtrace_handler,a0

curse_task	move.l	a0,TC_TRAPCODE(a5)	;install our TRACE handler

		move.b	#$80,d0			;assume normal TRACE mode (T1=1,T0=0)
		tst.l	trace_mode
		beq	normal_trace
		move.b	#$40,d0			;T1=0, T0=0

normal_trace	move.l	4.w,a6
		DISABLE
		move.l	TC_SPREG(a5),a1		;find Task's saved context
		and.b	#$3F,8(a1)		;clear any trace bits already set.
		or.b	d0,8(a1)		;go set TRACE bits in saved SR reg !
		ENABLE
		rts
;-----------------------------------------------
; We've got enough info on traced Task. Switch it back to normal mode.
; **!! This doesn't check whether the Task is still actually there or not !
;-----------------------------------------------

stop_task_traceing
		move.l	tcb_ptr,a5		;get Task's TCB address

		move.l	4.w,a6			;using Exec..
		DISABLE				;freeze multi-tasking while modifying

;**!!		move.l	old_trapcode,TC_TRAPCODE(a5)	;restore original handler
;		clr.l	TC_TRAPDATA(a5)

		move.l	TC_SPREG(a5),a1		;find Task's saved context
		and.b	#$3F,8(a1)		;clear T1, T0
		ENABLE
		rts

;------------------------------------------------------------------------------------
; This EXCEPTION handler is executed after EVERY instruction of the
; target Task/Process once we switched "its" CPU into TRACE mode.
;
; ** THIS IS EFFECTIVELY THE CORE OF THE ENTIRE PROGRAM **
;
;------------------------------------------------------------------------------------


REGS_SAVED1	equ	2			;size of "stack frame"


default_handler:
		addq.l	#4,SP			;discard garbage that Exec added.

		move.l	a0,-(sp)		;handler has to be transparent (like IRQ)
		move.l	d0,-(sp)		;(2 * move is faster than movem)

		move.l	([4]ThisTask),a0	;find address of Task that trapped
		move.l	TC_TRAPDATA(a0),a0	;get ptr to array of LONG counters

		moveq	#0,d0			;clear MSW for following casting...
		move.w	([sp,8+REGS_SAVED1*4]),d0  ;get opcode (cast to LONG)
		addq.l	#1,0(a0,d0.l*4)		;increment this opcode's counter

		move.l	(sp)+,d0		;restore used registers
		move.l	(sp)+,a0

		rte	;ret to Task for just ONE instruction and come back here !
;-----------------------------------------------
;**!! The original trace handler used to use conservative 68000 addressing modes
;**!! By using the new 68020+ modes we're able to use one address register less
;**!! than before which in turns means less to save/restore.

; The old code looked like this:

;		move.l	4.w,a0			;find address of Task that trapped.
;		move.l	ThisTask(a0),a0
;		move.l	TC_TRAPDATA(a0),a1	;get ptr to array of LONG counters

;		move.l	8+12(sp),a0		;get address of opcode that trapped
;		move.w	(a0),d0			;get opcode

;-----------------------------------------------
; This is an alternative (slower) handler that also dumps all 680x0 registers.
; This handler is only used when the user specifies the REGS option.
;-----------------------------------------------

REGS_SAVED2	equ	2


rgtrace_handler:addq.l	#4,SP

		movem.l	d0-d7/a0-a6,regs_dump	;dump all Dn/An registers
		move.l	8(sp),regs_dump+16*4	;and PC
;---------------
		move.l	a0,-(sp)
		move.l	d0,-(sp)

		move.l	USP,a0
		move.l	a0,regs_dump+15*4

		move.l	([4]ThisTask),a0
		move.l	TC_TRAPDATA(a0),a0

		moveq	#0,d0
		move.w	([sp,8+REGS_SAVED2*4]),d0
		addq.l	#1,0(a0,d0.l*4)

		move.l	(sp)+,d0
		move.l	(sp)+,a0
		rte
;-----------------------------------------------
; This is another alternative handler which also some PC register statistics.
; This handler is only used when the user specifies the PROFILE option.
;-----------------------------------------------

REGS_SAVED3	equ	4

proftrace_handler:
		addq.l	#4,SP

		movem.l	d0-d7/a0-a6,regs_dump	;dump all Dn/An registers
		move.l	8(sp),regs_dump+16*4	;and PC
;---------------
		movem.l	d0-d1/a0-a1,-(sp)

		move.l	USP,a0
		move.l	a0,regs_dump+15*4

		move.l	([4]ThisTask),a0
		move.l	TC_TRAPDATA(a0),a0

		moveq	#0,d0
		move.w	([sp,8+REGS_SAVED3*4]),d0
		addq.l	#1,0(a0,d0.l*4)

		move.l	regs_dump+16*4,d0
		cmp.l	#$00F80000,d0
		bcs	non_ROM_PC
		cmp.l	#$01000000,d0
		bcs	skip_ROM_PC

non_ROM_PC	bsr	update_PC_hist

skip_ROM_PC	movem.l	(sp)+,d0-d1/a0-a1
		rte
;-----------------------------------------------
; Go through PC History array and update/add
; a PC entry.
;-----------------------------------------------
update_PC_hist	move.l	PC_history_PCs,a0	;-> N PC values followed by N counters
		move.l	regs_dump+16*4,d1	;get PC value of TRACE exception

		move.w	num_PCs,d0		;how long is list to check ?
		beq	add_new_PC

		subq.w	#1,d0

check_history	cmp.l	(a0)+,d1		;does this PC already occur in list?
		dbeq	d0,check_history
		bne	add_new_PC

inc_PC_counter	add.l	#(MAX_PC_HIST*4)-4,a0
		addq.l	#1,(a0)			;yes, just incr. its counter
		rts

add_new_PC	cmp.w	#MAX_PC_HIST,num_PCs	;stop storing new ones when full
		rcc

		move.l	PC_history_PCs,a0	;otherwise
		move.l	PC_history_cnts,a1

		move.w	num_PCs,d0	
		move.l	d1,(a0,d0*4)		;add new PC to list
		moveq	#1,d1
		move.l	d1,(a1,d0*4)		;& init its counter

		addq.w	#1,num_PCs		;keep track of size of list
		rts
;-----------------------------------------------
; Initialize some variables
;-----------------------------------------------
init_isan	clr.l	window			;clr ptrs to ensure safe freeing
		clr.l	regs_window		;in case of allocation failure
		clr.l	prof_window

		clr.l	map_screen
		clr.l	font_ptr

		clr.l	PC_history_PCs
		clr.l	opcode_list

		clr.w	num_PCs			;no PCs so far.

		sf	close_me		;no need to quit just now...
		st	add_labels		;first update pass we want labels

		rts
;-----------------------------------------------
; Open Dos, Graphics and Intuition libraries.
;-----------------------------------------------
open_libs	move.l	4.w,a6			;using Exec..
		lea	dosname,a1
		moveq	#0,d0
		EXEC	OpenLibrary		;open DOS
		move.l	d0,DOS_LIB_PTR
		beq	beg_your_pardon

		lea	gfxname,a1
		moveq	#0,d0
		EXEC	OpenLibrary
		move.l	d0,GFX_LIB_PTR		;open GFX
		beq	beg_your_pardon

		lea	intuiname,a1
		moveq	#0,d0
		EXEC	OpenLibrary		;open Intuition
		move.l	d0,INTUI_LIB_PTR

		move.l	DOS_LIB_PTR,a6		;and using DOS
		DOS	Output			;get standard output filehandle
		move.l	d0,stdout

beg_your_pardon	rts
;-----------------------------------------------
close_libs	move.l	4.w,a6			;using Exec..
		move.l	DOS_LIB_PTR,d0
		beq	no_dos
		move.l	d0,a1
		EXEC	CloseLibrary		;close DOS

no_dos		move.l	GFX_LIB_PTR,d0
		beq	no_gfx
		move.l	d0,a1
		EXEC	CloseLibrary		;close GFX

no_gfx		move.l	INTUI_LIB_PTR,d0
		beq	done_lib_closures
		move.l	d0,a1
		EXEC	CloseLibrary		;close Intuition
done_lib_closures
		rts
;-----------------------------------------------
; Convert hex string pointed to by A0 into binary.
; Return in D0.L
;-----------------------------------------------
hex_to_bin	moveq	#0,d0			;clear accumulator
		bra	wh_nibbles

add_nibble	lsl.l	#4,d0
		add.b	d1,d0

wh_nibbles	moveq	#0,d1			;(clear high byte of index reg)
		move.b	(a0)+,d1		;get char

		sub.b	#'0',d1			;make sure char is in set of legal
		bcs	not_hex			;hex chars
		cmp.b	#'f'-'0',d1
		bhi	not_hex

		move.b	h2bin(PC,d1.w),d1	;use char as index into lookup table
		bpl	add_nibble		;if lookup gives valid nibble
;---------------
not_hex		subq.w	#1,a0			;backtrack to first non-hex char
		rts

h2bin		dc.b	0,1,2,3,4,5,6,7,8,9,-1,-1,-1,-1,-1,-1
		dc.b	-1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1	;@..'O'
		dc.b	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1	;'P'.._
		dc.b	-1,10,11,12,13,14,15
;-----------------------------------------------
; Count number of '1' bits in D0.L
; Return in D0.L
;-----------------------------------------------
		EVEN
count_ones_in_D0
		moveq	#0,d1			;zero count.
		moveq	#0,d2			;dummy addition operand for ADDX

count_ones	add.l	d0,d0			;shift a '0' or a '1' out in Carry
		addx.l	d2,d1			;add 1 to count if C=1
		tst.l	d0
		bne	count_ones

found_all_ones	move.w	d1,d0
		rts

;-----------------------------------------------
; Leading Zero stripped BIN_HEX
;-----------------------------------------------
bin_hex		move.l	a0,-(sp)
		move.l	d1,-(sp)
		bsr	BIN_HEX
		move.l	(sp)+,d1
		move.l	(sp)+,a0

		subq.w	#2,d1			;-2 to leave at least 1 '0'
kill_leading_0	cmp.b	#'0',(a0)
		rne
		move.b	#' ',(a0)+
		dbra	d1,kill_leading_0
		rts
;-----------------------------------------------
; Here I IMPORT some handy MODULES
;-----------------------------------------------
		include	SRC:UTILS/ReadArgs.s	;argline parser (with std template)
		include	SRC:UTILS/load_file.s	;entire file loader
		include SRC:MODULES/LIB1/BIN_HEX
		include	SRC:MODULES/LIB1/DEC_TO_BIN
;-----------------------------------------------
		EVEN

MyNewWindow:
	dc.w	640-WINDOW_WIDTH-13	;window XY origin relative to TopLeft of screen
	dc.w	0
	dc.w	WINDOW_WIDTH+13		;window width and
win_h	dc.w	131			;height (FILLED IN)
	dc.b	0,1			;detail and block pens

;IDCMP flags
	dc.l	CLOSEWINDOW+GADGETUP+MOUSEBUTTONS

;Window flags
	dc.l	WINDOWDRAG+WINDOWDEPTH+WINDOWCLOSE+ACTIVATE+NOCAREREFRESH+REPORTMOUSE

	dc.l	Gadgets			;first gadget in gadget list
	dc.l	NULL			;custom CHECKMARK imagery
	dc.l	WindowName		;window title
	dc.l	NULL			;custom screen pointer
	dc.l	NULL			;custom bitmap
	dc.w	5,5			;minimum width and height
	dc.w	-1,-1			;maximum width and height
	dc.w	WBENCHSCREEN		;destination screen type

Gadgets	dc.l	NULL			;next gadget
	dc.w	WINDOW_WIDTH-7		;origin XY of hit box relative to window TopLeft
	dc.w	13

	dc.w	15			;hit box width and
gad_h	dc.w	100			;height (FILLED IN)
	dc.w	NULL			;gadget flags
	dc.w	RELVERIFY		;activation flags
	dc.w	PROPGADGET		;gadget type flags
	dc.l	KnobImage		;gadget border or image to be rendered
	dc.l	NULL			;alternate imagery for selection
	dc.l	NULL			;first IntuiText structure
	dc.l	NULL			;gadget mutual-exclude long word
	dc.l	GadgetSInfo		;SpecialInfo structure
	dc.w	NULL			;user-definable data
	dc.l	NULL			;pointer to user-definable data

GadgetSInfo:
	dc.w	AUTOKNOB+FREEVERT	;PropInfo flags
	dc.w	0,$2800			;horizontal and vertical pot values
	dc.w	3276,3276		;horizontal and vertical body values
	dc.w	0,0,0,0,0,0		;Intuition initialized and maintained variables

KnobImage:
	dc.w	0,$1E			;XY origin relative to container TopLeft
	dc.w	7,5			;Image width and height in pixels
	dc.w	0			;number of bitplanes in Image
	dc.l	NULL			;pointer to ImageData
	dc.b	$0000,$0000		;PlanePick and PlaneOnOff
	dc.l	NULL			;next Image structure

map_newscreen:
	dc.w	50,0			;screen XY origin relative to View
	dc.w	256,256+12		;screen width and height
	dc.w	2			;screen depth (number of bitplanes)
	dc.b	0,1			;detail and block pens
	dc.w	0			;display modes for this screen
	dc.w	CUSTOMSCREEN		;screen type
	dc.l	NULL			;pointer to default screen font
	dc.l	NewScreenName		;screen title
	dc.l	NULL			;first in list of custom screen gadgets
	dc.l	NULL			;pointer to custom BitMap structure

textattr	dc.l	topazname
		dc.w	CHAR_HEIGHT	;ta_YSize = 8
		dc.b	0,0		;Style and Flags = 0

topazname	dc.b	"topaz.font",0

;-----------------------------------------------
; Strings section
;-----------------------------------------------

one		dc.b	"1",0		;default trace mode
twenty		dc.b	"20",0		;default trace update speed
a_zero		dc.b	"0"		;a lonely zero char for printing a zero count
default_conf	dc.b	"S:ISAN.config",0

NewScreenName	dc.b	"ISAN Opcode Map (Opcode=$0000)",0

* Tag for VERSION command
version		dc.b	"$VER: ISAN 1.2 ©LVA 22/JAN/94",0
WindowName:	dc.b	      "ISAN 1.2 ©LVA 22/JAN/94   ("
window_info	dc.b	"TASK $"
task_addr_str	dc.b	"XXYYZZQQ)",0	;**!! Watch out that string doesn't overflow

regswin_title	dc.b	"Task Registers",0
prof_win_title	dc.b	"PC Profiling Info",0

syntax		dc.b	"Example:",LF
		dc.b	"  1> ISAN PROCESS 5 MODE 2 REGS GRAFMAP",0

no_arr_mem	dc.b	"Not enough contiguous RAM for statistics arrays.",0
no_descr_mem	dc.b	"No memory for instruction descriptors array (running LOW!).",0
dollars_please	dc.b	"Task addresses should have a '$' to denote hexadecimal.",0
dec_procnum	dc.b	"Process number should be a small decimal number.",0
no_conf		dc.b	"Couldn't find 'ISAN.config' file anywhere !",0
bad_conf_file	dc.b	"ISAN.config file contains garbage.",0
bad_task	dc.b	"Task not found on Waiting or Ready list.",0
bad_proc	dc.b	"Process not found on Waiting or Ready list.",0
bad_trace_mode	dc.b	"Trace mode should be 1 or 2 (1=trace all, 2=trace flow)",0
bad_speed	dc.b	"Speed must be in 1..500 range.",0
win_too_big	dc.b	"Couldn't open Window (opcode list too long?).",0
plonker		dc.b	"Please specify either a Task or a Process (not both).",0
wrong_machine	dc.b	"ISAN Only works on 68020+ machines. Sorry (better than crashing, innit ?)",0
no_screen_str	dc.b	"Couldn't open Screen for opcode bitmap display.",0

ISAN_template	dc.b	"TASK/K,PROCESS/K,SPEED/K,MODE/K,REGS/S,TOTAL/S,GRAFMAP/S,FILE/K,PROFILE/S",0

		EVEN
hex_output	dc.b	"XXXXYYYY",0
regstrings	dc.b	"D0=D1=D2=D3=D4=D5=D6=D7="
		dc.b	"A0=A1=A2=A3=A4=A5=A6=A7=PC="

total_label	dc.b	"TOTAL"
underline_label	dc.b	"-----"

dosname		DOSNAME
intuiname	INTNAME
gfxname		GRAFNAME

;-----------------------------------------------
; Variables (pointers, handles, counters, flags...)
;-----------------------------------------------

		SECTION	isan_vars,BSS

DOS_LIB_PTR	ds.l	1
GFX_LIB_PTR	ds.l	1
INTUI_LIB_PTR	ds.l	1

stack_level	ds.l	1
arg_line	ds.l	1
stdout		ds.l	1

tcb_ptr		ds.l	1	;TCB ptr to task we're messing with
old_trapcode	ds.l	1	;ptr to original trap exception handler (to restore)

window		ds.l	1	;pointer to our Window
regs_window	ds.l	1	;-> Registers Window (if requested)
prof_window	ds.l	1	;-> PC Profiling Win (if requested)

rastport	ds.l	1	;and their RastPorts
regswin_rp	ds.l	1
profwin_rp	ds.l	1

font_ptr	ds.l	1	;ptr to Topaz Font

map_screen	ds.l	1	;ptr to opcode map screen (if asked for)

msgport		ds.l	1	;Window's IDCMP Message Port
imsg_class	ds.l	1
imsg_iaddr	ds.l	1
imsg_ratcords	ds.l	1
imsg_code	ds.w	1

conf_size	ds.l	1	;# of configuration file buffer
conf_buffer	ds.l	1	;ptr to cached configuration file

counters	ds.l	1	;-> 256K of LONG counters (1 long per opcode)
array_size	ds.l	1	;szie of descriptor array
opcode_list	ds.l	1	;array of opcode descriptors to scan each time
most_frequent	ds.l	1	;address of slot representing most frequent opcode

regs_dump	ds.l	16+1	;room for D0-D7/A0-USP, PC

opcodes		ds.w	1	;# of opcodes to check.

win_width	ds.w	1
label_len	ds.w	1
contents_height	ds.w	1	;height of used rectangle within window

close_me	ds.b	1	;close window request flag
add_labels	ds.b	1	;print labels first time only

num_PCs		ds.w	1	;number of different non-sequential PCs so far

PC_history_PCs	ds.l	1	;ptr to array of encountered PC values
PC_history_cnts	ds.l	1

; Here we have the contiguous block of LONGs that ReadArgs() fills in
;--------------------------------------------------------------------
		EVEN
rda_results
task_arg	ds.l	1	;ptr to TASK address argument
process_arg	ds.l	1	;ptr to PROCESS number argument
update_speed	ds.l	1	;DOS Delay() value
trace_mode	ds.l	1	;1 or 2 for TT=10 or TT=01
show_regs	ds.l	1	;open extra Window to display Task's register set
total_flag	ds.l	1
opcode_map	ds.l	1	;open opcode map screen
conf_file	ds.l	1	;ptr to filename for configuration
profile_flag	ds.l	1	;do PC profiling in MODE 2 tracing


		END
