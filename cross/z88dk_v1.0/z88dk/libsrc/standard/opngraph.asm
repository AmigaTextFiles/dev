
	XLIB	opengraphics

	XREF	base_graphics

if QDOS
	include "#memory_def"
	include "#map_def"
	include "#screen_def"
else
	if z88
		include ":*//memory.def"
		include ":*//map.def"
		include ":*//screen.def"
	else
		include "#memory.def"
		include "#map.def"
		include "#screen.def"
	endif
endif


; *****************************************************************************
;
;	Open	graphics window, static size of 256x64 pixels, and bind graphics
;	memory into specified address	space segment.
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	This	routine must be called before	using any	library graphics routines,
;	since they expect the graphics memory to be available through the
;	<base_graphics> pointer.
;
;	in:	A = window ID ('1' to '6')
;		B = MM_Sx	mask	(for	segment 0, 1, 2 or 3)
;
;	out:	(base_graphics) contains	pointer to base of graphics area.
;		Further, the graphics area is	bound into the	segment specified
;		by the input B	register.
;
;	registers	changed after return:
;		afbcdehl/ixiy	same
;		......../....	different
;
.opengraphics		push	hl
				push	de
				push	bc
				push	af

				push	bc
				ld	bc, mp_gra
				ld	hl,255
				call_oz(os_map)		; create map width of 256 pixels
				ld	b,0
				ld	hl,0				; dummy address
				ld	a,sc_hr0
				call_oz(os_sci)		; get base address of map area (hires0)
				push	bc
				push	hl
				call_oz(os_sci)		; (and re-write original	address)
				pop	hl
				pop	bc
				pop	de
				ld	c,d
				rlc	c
				rlc	c				; convert	MM_Sx to MS_Sx	segment specifier
				call_oz(os_mpb)		; bind hires0 memory into specified segment
				ld	a,h
				and	@00111111
				or	d
				ld	h,a				; base of	graphics points at segment
				ld	(base_graphics),hl	; initialize base address of hires0

				pop	af
				pop	bc
				pop	de
				pop	hl
				ret
