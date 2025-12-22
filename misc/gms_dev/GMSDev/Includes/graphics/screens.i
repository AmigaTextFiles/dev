	IFND GRAPHICS_SCREENS_I
GRAPHICS_SCREENS_I  SET  1

**
**  $VER: screens.i V1.0
**
**  Screen Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND	DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************
* Module definitions.

ScrModVersion  = 1
ScrModRevision = 0

*****************************************************************************
* Screen object.

SCRVERSION  = 1
TAGS_SCREEN = (ID_SPCTAGS<<16)|ID_SCREEN

    STRUCTURE	GS,HEAD_SIZEOF   ;[00] Standard header.
	APTR	GS_MemPtr1       ;[12] Ptr to screen 1.
	APTR	GS_MemPtr2       ;[16] Ptr to screen 2 (doubled buffer)
	APTR	GS_MemPtr3       ;[20] Ptr to screen 3 (tripled buffer)
	APTR	GS_Link          ;[24] ...
	APTR	GS_Raster        ;[28] Ptr to a raster object.
	WORD	GS_Width         ;[32] The width of the visible screen window.
	WORD	GS_Height        ;[34] The height of the visible screen window.
	WORD	GS_XOffset       ;[36] Hardware co-ordinate for TOS.
	WORD	GS_YOffset       ;[38] Hardware co-ordinate for LOS.
	WORD	GS_BmpXOffset    ;[40] Offset of the horizontal axis.
	WORD	GS_BmpYOffset    ;[42] Offset of the vertical axis.
	WORD	GS_ScrMode       ;[44] What screen mode is it?
	WORD	GS_Reserved      ;[46] ...
	LONG	GS_Attrib        ;[48] Special Attributes are?
	APTR	GC_Task          ;[52] Private.
	APTR	GS_Bitmap        ;[56] Pointer to bitmap structure (for blitting).
	WORD	GS_Switch        ;[60] Set to 1 when ready to switch buffers.

	;All of the following fields are private and you will break
	;compatibility with other GMS versions if you try and access them.

	WORD	GS_Prv           ;  1 
	APTR	GS_TypeEmulator  ;  2 Emulation.
	APTR	GS_Monitor       ;  3 Monitor driver.
	APTR	GS_EMemPtr1      ;  4 Chunky driver.
	APTR	GS_EMemPtr2      ;  5 Chunky driver.
	APTR	GS_EMemPtr3      ;  6 Chunky driver.
	APTR	GS_EFree1        ;  7 Chunky driver.
	APTR	GS_EFree2        ;  8 Chunky driver.
	APTR	GS_EFree3        ;  9 Chunky driver.
	BYTE	GS_ColBits       ; 10 0 = 12bit, 1 = 24bit.
	BYTE	GS_Pad           ; 11 Unused.
	LONG	GS_ShowKey       ; 12 Resource key if the screen is shown.
	LONG	GS_Scratch       ; 13 Scratch address!
	APTR	GS_ScreenPrefs   ; 14 Screen preferences for this screen.
	APTR	GC_LineWait      ; 15 Line Wait till bitplanes start.
	APTR	GC_End           ; 16 Ptr to the copper's jump end. (26!)
	WORD	GC_BurstLevel    ; 17 FMode setting for bitplanes.
	APTR	GC_Control       ; 18 BPLCON0
	APTR	GC_Modulo        ; 19 The screen modulo.
	APTR	GC_ScrPosition   ; 20 DIW's, DDF's, DIWHIGH
	APTR	GC_Start         ; 21 Start of main copperlist.
	APTR	GC_Sprites       ; 22 Pointer to the copper sprites.
	APTR	GC_Colours       ; 23 Pointer to the copper colours.
	WORD	GC_AmtBankCols   ; 24 Amount of colours per bank (AGA).
	WORD	GC_AmtBanks      ; 25 Amount of banks in total (AGA).
	WORD	GC_HiLoOffset    ; 26 Offset between hi and lo bits (AGA)
	APTR	GC_Bitplanes1    ; 27 Ptr to copper bitplane loaders #1.
	APTR	GC_Bitplanes2    ; 28 Ptr to copper bitplane loaders #2.
	APTR	GC_Bitplanes3    ; 29 Ptr to copper bitplane loaders #3.
	APTR	GC_ColListJmp    ; 30 Jumper to RasterList.
	LONG	GD_BmpXOffset    ; 31 X offset for scrolling.
	LONG	GD_BmpYOffset    ; 32 Y offset for scrolling.
	WORD	GD_ScrollBWidth  ; 33 Set to 2 if scrolling.
	APTR	GD_MemPtr1       ; 34 Original screen mem start (1).
	APTR	GD_MemPtr2       ; 35 Original screen mem start (2).
	APTR	GD_MemPtr3       ; 36 Original screen mem start (3).
	WORD	GD_BPLCON3       ; 37 BPLCON3 actual data (not a ptr).
	WORD	GD_AmtFields     ; 38 Amount of PlayFields on screen.
	WORD	GD_FieldNum      ; 39 Number of this field...
	WORD	GD_ScrLRWidth    ; 40 ScrWidth, in lo-resolution.
	WORD	GD_ScrLRBWidth   ; 41 ScrByteWidth, in lo-resolution.
	WORD	GD_PicLRWidth    ; 42 PicWidth, in lo-resolution.
	WORD	GD_TOSX          ; 43 Top of screen X for this screen.
	WORD	GD_TOSY          ; 44 Top of screen Y for this screen.
	APTR	GD_CopperMem     ; 45 Pointer to original screen mem start.
	APTR	GD_Bitmap        ; 46 Allocated bitmap.
	WORD	GD_BlitXOffset   ; 47 Offset to use for blitting (hard-scroll).
	APTR	GD_Palette       ; 48 Allocated palette.
	APTR	GD_BufPtr1       ; 49 
	APTR	GD_BufPtr2       ; 50 
	APTR	GD_BufPtr3       ; 51 
	APTR	GD_Rastport      ; 52

;---------------------------------------------------------------------------;
;Screen Buffer names, these are asked for in the blitter functions.

BUFFER1 = GS_MemPtr1
BUFFER2 = GS_MemPtr2
BUFFER3 = GS_MemPtr3

;---------------------------------------------------------------------------;
;Screen attributes and options (flags for GS_ScrAttrib).

B_DBLBUFFER    =  0
B_TPLBUFFER    =  1
B_PLAYFIELD    =  2
B_HSCROLL      =  3
B_VSCROLL      =  4
B_SPRITES      =  5
B_SBUFFER      =  6
B_CENTRE       =  7
B_BLKBDR       =  8
B_NOSCRBDR     =  9
B_PUBLIC       = 10

SCR_DBLBUFFER    = (1<<B_DBLBUFFER)    ;For double buffering.
SCR_TPLBUFFER    = (1<<B_TPLBUFFER)    ;Triple buffering!!
SCR_PLAYFIELD    = (1<<B_PLAYFIELD)    ;Set if it's part of a playfield.
SCR_HSCROLL      = (1<<B_HSCROLL)      ;Gotta set this to do scrolling.
SCR_VSCROLL      = (1<<B_VSCROLL)      ;For vertical scrolling.
SCR_SPRITES      = (1<<B_SPRITES)      ;Set this if you want sprites.
SCR_SBUFFER      = (1<<B_SBUFFER)      ;Create a scroll buffer for up to 100 screens.
SCR_CENTRE       = (1<<B_CENTRE)       ;Centre the screen (sets ScrXOffset/ScrYOffset).
SCR_BLKBDR       = (1<<B_BLKBDR)       ;Gives a blackborder on AGA machines.
SCR_NOSCRBDR     = (1<<B_NOSCRBDR)     ;For putting sprites in the border.

;---------------------------------------------------------------------------;
;Screen modes (flags for GS_ScrMode).

B_HIRES   =  0
B_SHIRES  =  1
B_LACED   =  2
B_LORES   =  3
B_SLACED  =  5

SM_HIRES   =  $0001  ;High resolution.
SM_SHIRES  =  $0002  ;Super-High resolution.
SM_LACED   =  $0004  ;Interlaced.
SM_LORES   =  $0008  ;Low resolution (default).
SM_SLACED  =  $0020  ;Higher Laced resolution.

;---------------------------------------------------------------------------;
;Screen Attribute tags.

GSA_MemPtr1    = TAPTR|GS_MemPtr1
GSA_MemPtr2    = TAPTR|GS_MemPtr2
GSA_MemPtr3    = TAPTR|GS_MemPtr3
GSA_Raster     = TAPTR|GS_Raster
GSA_Width      = TWORD|GS_Width
GSA_Height     = TWORD|GS_Height
GSA_XOffset    = TWORD|GS_XOffset
GSA_YOffset    = TWORD|GS_YOffset
GSA_BmpXOffset = TWORD|GS_BmpXOffset
GSA_BmpYOffset = TWORD|GS_BmpYOffset
GSA_Attrib     = TLONG|GS_Attrib
GSA_ScrMode    = TWORD|GS_ScrMode

GSA_BitmapTags = TSTEPIN|GS_Bitmap

*****************************************************************************
* Structure header for raster commands.

    STRUCTURE	RasterV1,HEAD_SIZEOF
	APTR	RAS_Command	;Pointer to the first command.
	APTR	RAS_Screen	;Pointer to our Screen owner.
	LONG	RAS_Flags	;Special flags.

*****************************************************************************
* Rasterlist Definitions.

ID_RASTWAIT       = 1
ID_RASTFLOOD      = 2
ID_RASTCOLOUR     = 3
ID_RASTCOLOURLIST = 4
ID_RASTMIRROR     = 5

ID_LASTCOMMAND    = 6

    STRUCTURE	RStatsV1,0
	LONG	RSTAT_CopSize
	APTR	RSTAT_CopPos
	LABEL	RSTATS_SIZEOF

    STRUCTURE	RHeadV1,0
	WORD	RSH_ID
	WORD	RSH_Version
	APTR	RSH_Stats
	APTR 	RSH_Prev
	APTR	RSH_Next
	LABEL	RHEAD_SIZEOF

    STRUCTURE	RWaitV1,RHEAD_SIZEOF
	WORD	RSW_Line

    STRUCTURE	RFloodV1,RHEAD_SIZEOF

    STRUCTURE	RColourV1,RHEAD_SIZEOF
	LONG	RSC_Colour
	LONG	RSC_Value

    STRUCTURE	RColourListV1,RHEAD_SIZEOF
	WORD	RCL_Start
	WORD	RCL_Skip
	LONG	RCL_Colour
	APTR	RCL_Values

  ENDC	;GRAPHICS_SCREENS_I
