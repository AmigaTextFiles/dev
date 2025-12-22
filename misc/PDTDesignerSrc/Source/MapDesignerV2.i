			IFND	MAP_DESIGNER_V_2_I
MAP_DESIGNER_V_2_I	SET	1

	include	exec/types.i


custom		equ	$dff000		; Amiga custom chips base.

;   This is the stack frame used by the routine DisplayMapSection...

dms_Modulo	equ	-4	; Modulo to add to map pointer each line.
dms_SOffset	equ	-8	; Offset into Source place to get tile from.
dms_DOffset	equ	-12	; Offset into Dest. plane to write tile to.
dms_Width	equ	-16	; Width, in tiles, of output.
dms_Height	equ	-20	; Height, in tiles, of output.
dms_SIZEOF	equ	-20	; Size of stack frame.

;   Here are some register equates to make the Source for DisplayMapSection a
; bit more readable...

dms_CCnt	equr	d7	; Column counter.
dms_LCnt	equr	d6	; Line counter.
dms_Depth	equr	d5	; dbra depth control.
dms_BSize	equr	d4	; Value to write into BLTSIZE.
dms_Plane	equr	d3	; Plane index register.
dms_SBMap	equr	a0	; Pointer to Source bit map. (Tiles).
dms_DBMap	equr	a1	; Pointer to Dest. bit map. (Edit screen).
dms_MapPtr	equr	a2	; Pointer to map data.

;   These defines are for the setting up of various IDCMP ports...

STATUSIDCMP	equ	(RAWKEY!GADGETUP!MOUSEMOVE!MENUPICK) ; Status window.
TILESIDCMP	equ	(RAWKEY!MOUSEBUTTONS)	; For tile selections.
TBLKIDCMP	equ	(RAWKEY!MOUSEBUTTONS!MOUSEMOVE) ; Tile block defs.
MAPIDCMP	equ	(RAWKEY!MOUSEBUTTONS!MOUSEMOVE) ; Edit window.


;   This file contains the definition for the MapInfo structure as used by
; the Map Designer Version 2 Utility.  It also contains the bit definitions
; for the flags.

;   Note that the top section of this structure also doubles as the V2.xx
; map file header...


	    STRUCTURE	MapInfo,0
	    	 LONG	minfo_ID	; Identification code.
		UWORD	minfo_CTile	; Current tile number.
		UWORD	minfo_MTile	; Maximum tile number.
		UWORD	minfo_TRasX	; Width of tiles raster.
		UWORD	minfo_TRasY	; Height of tiles raster.
		UWORD	minfo_TX	; Width of tiles.
		UWORD	minfo_TY	; Height of tiles.
		UWORD	minfo_Flags	; Various flags. (See below).
		UWORD	minfo_MX	; Width of map, in tiles.
		UWORD	minfo_MY	; Height of map, in tiles.
		UWORD	minfo_MXP	; Current X offset into map.
		UWORD	minfo_MYP	; Current Y offset into map.
		UWORD	minfo_Depth	; Depth of map and tiles screens.
		UWORD	minfo_Res	; Resolution of map screen.
		UWORD	minfo_MRasX	; Width of Map Screen raster.
		LABEL	minfo_FileHeader	; All of the above saved as
						; V2.0 Map file header.

		UWORD	minfo_CXP	; Current X Pos of cursor in map.
		UWORD	minfo_CYP	; Current Y Pos of cursor in map.
	       STRUCT	minfo_Name,150	; Array of chars to hold filespec for
					; map.
		UWORD	minfo_BX	; Width of current block, if defined.
		UWORD	minfo_BY	; Height of block if defined.
		 APTR	minfo_Block	; Pointer to array of block data.
		 APTR	minfo_Map	; Pointer to array of map data.
		 APTR	minfo_TilesPort		; Pointer to ViewPort.
		 APTR	minfo_TilesScreen	; Pointer to Screen struct.
		 APTR	minfo_TilesWindow	; Pointer to window struct.
		 APTR	minfo_MapScreen		; Pointer to Screen...
		 APTR	minfo_MapWindow
		 APTR	minfo_StatusScreen
		 APTR	minfo_StatusWindow
		 WORD	minfo_OSX	; On Screen X co-ord of cursor.
		 WORD	minfo_OSY	; On Screen Y co-ord of cursor.
		 WORD	minfo_OSW	; Pixel width of on screen cursor.
		 WORD	minfo_OSH	; Pixel height of on screen cursor.

;   These two are used by the SetMapSize functions to store the size of the
; new map whist it is being constucted.

		 WORD	minfo_NX	; Width of new map being built.
		 WORD	minfo_NY	; Height of new map.
		LABEL	minfo_SIZEOF	; Size of data struct.



**------------------ Flag Definitions ------------------**

MIFB_TILES	equ	0	; Set if tiles loaded.
MIFB_MAP	equ	1	; Set if map data allocated / loaded.
MIFB_BLOCK	equ	2	; Set if block defined.
MIFB_INCTILES	equ	3	; Set if tiles are to be saved in map file.
MIFB_MODE	equ	4	; 0 = Tiles mode.  1 = Block mode.
MIFB_CHANGED	equ	5	; Set if map has been changed and not saved.
MIFB_NOCURS	equ	6	; Set if no cursor is to be drawn.
MIFB_CDRAWN	equ	7	; Set if cursor is currently drawn.
MIFB_QUIT	equ	8	; Set if user is quitting.

;   The flags have been extended to handle the enhancements / additions of
; Version 2.10.

MIFB_PAINT	equ	9	; 0 = Place mode.  1 = Paint mode.
MIFB_ICON	equ	10	; Set if an icon is to be created.
MIFB_BDOWN	equ	11	; Set if LMB is down in map screen.

;  This flag was added to handle the "mode display" enhancements of version
; 2.13.

MIFB_BSELECT	equ	12	; 0 = Normal operations.  1 = User currently
				; selecting a block.


MIFF_TILES	equ	(1<<MIFB_TILES)
MIFF_MAP	equ	(1<<MIFB_MAP)
MIFF_BLOCK	equ	(1<<MIFB_BLOCK)
MIFF_INCTILES	equ	(1<<MIFB_INCTILES)
MIFF_MODE	equ	(1<<MIFB_MODE)
MIFF_CHANGED	equ	(1<<MIFB_CHANGED)
MIFF_NOCURS	equ	(1<<MIFB_NOCURS)
MIFF_CDRAWN	equ	(1<<MIFB_CDRAWN)
MIFF_QUIT	equ	(1<<MIFB_QUIT)
MIFF_PAINT	equ	(1<<MIFB_PAINT)
MIFF_ICON	equ	(1<<MIFB_ICON)
MIFF_BDOWN	equ	(1<<MIFB_BDOWN)
MIFF_BSELECT	equ	(1<<MIFB_BSELECT)

MIFMASK		equ	$1FFF	; Currently used bits.
MIFIOMASK	equ	$0608	; Use on IO to remove un-needed bits.

MIMODE_TILES	equ	$01EF	; AND with flags to switch to tiles mode.
MIMODE_BLOCK	equ	$0010	; OR with flags to switch to block mode.

		ENDC	; Map Designer include.
