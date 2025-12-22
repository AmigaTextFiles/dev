\ Opallib.j

\ Opal Library Includes File For JForth 3.0.

\ Version 1.0

\ 22 December 1992

\ By Marlin Schwanke

\ InterNet marlins@crash.cts.com
\ GEnie M.SCHWANKE
\ FIDO 1:202/1111

EXISTS? LIBRARIES_OPAL_H NOT .IF
1   constant LIBRARIES_OPAL_H

EXISTS? EXEC_TYPES_H NOT .IF
include ji:exec/types.j
.THEN

EXISTS? LIBRARIES_DOS_H NOT .IF
include ji:libraries/dos.j
.THEN

decimal
290 constant MAXCOPROINS   ( Number of CoPro instructions )

hex
\ Screen Flags
1     constant HIRES24        ( High resolution screen. )
2     constant ILACE24        ( Interlaced screen. )
4     constant OVERSCAN24     ( Overscan screen. )
8     constant NTSC24         ( NTSC Screen - Not user definable )
10    constant CLOSEABLE24    ( Screen is closeable. )
20    constant PLANES8        ( Screen has 8 bitplanes. )
40    constant PLANES15       ( Screen has 15 bitplanes. )
2000  constant CONTROLONLY24	( Used for updating control bits only. )
4000  constant PALMAP24       ( Screen is in palette mapped mode. )
8000  constant INCHIP24       ( In chip ram - Not user definable. )
CONTROLONLY24 PALMAP24 | CLOSEABLE24 | PLANES8 |
PLANES15 | OVERSCAN24 | ILACE24 | HIRES24 |
constant FLAGSMASK24

\ LoadIFF24 Flags
1  constant FORCE24           ( Force conversion of palette mapped to 24 bit. )
2  constant KEEPRES24         ( Keep the current screen resolution. )
4  constant LOADMASK24        ( Load mask plane if it exists. )
8  constant VIRTUALSCREEN24   ( Load complete image into fast ram. )

\ SaveIFF24 Flags
1  constant OVFASTFORMAT   ( Save as opalvision fast format. )
4  constant NOTHUMBNAIL    ( Inhibit thumbnail chunk. )
8  constant SAVEMASK24     ( Save MaskPlane with image. )

\ Config Flags
1  constant OVCF_OPALVISION   ( Display board is an OpalVision. )
2  constant OVCF_COLORBURST	( Display board is a ColorBurst. )

hex
\ Coprocessor bits.
1  constant VIDMODE0	      \ Video control bit 1 (S0)
2  constant VIDMODE1	      \ Video control bit 1 (S1)
4  constant DISPLAYBANK2	\ Select display bank 2
8  constant HIRESDISP	   \ Enable hi-res display
10 constant DUALDISPLAY	   \ Select dual display mode (active low)
20 constant OVPRI		      \ Set OpalVision priority
40 constant PRISTENCIL	   \ Enable priority stencil
80 constant ADDLOAD		   \ Address load bit. Active low
0  constant VIDMODE0_B
1  constant VIDMODE1_B
2  constant DISPLAYBANK2_B
3  constant HIRESDISP_B
4  constant DUALDISPLAY_B
5  constant OVPRI_B
6  constant PRISTENCIL_B
7  constant ADDLOAD_B

hex
\ Control line bits
1     constant VALID0
2     constant VALID1
4     constant VALID2
8     constant VALID3
10    constant WREN
20    constant COL_COPRO
40    constant AUTO
80    constant DUALPLAYFIELD
100   constant FIELD
200   constant AUTOFIELD
400   constant DISPLAYLATCH
800   constant FRAMEGRAB
1000  constant RWR1
2000  constant RWR2
4000  constant GWR1
8000  constant GWR2
10000 constant BWR1
20000 constant BWR2
40000 constant VLSIPROG
80000 constant FREEZEFRAME
decimal
0  constant VALID0_B
1  constant VALID1_B
2  constant VALID2_B
3  constant VALID3_B
4  constant WREN_B
5  constant COL_COPRO_B
6  constant AUTO_B
7  constant DUALPLAYFIELD_B
8  constant FIELD_B
9  constant AUTOFIELD_B
10 constant DISPLAYLATCH_B
11 constant FRAMEGRAB_B
12 constant RWR1_B
13 constant RWR2_B
14 constant GWR1_B
15 constant GWR2_B
16 constant BWR1_B
17 constant BWR2_B
18 constant VLSIPROG_B
19 constant FREEZEFRAME_B
20 constant NUMCONTROLBITS
5  constant VALIDCODE

decimal
\ Opal Screen Structure
:STRUCT OpalScreen
	  ( %M JForth prefix ) SHORT os_Width
   SHORT os_Height
   SHORT os_Depth
	SHORT os_ClipX1
   SHORT os_ClipY1
   SHORT os_ClipX2
   SHORT os_ClipY2
   SHORT os_BytesPerLine
   USHORT os_Flags
   SHORT os_RelX
   SHORT os_RelY
   APTR os_UserPort
   SHORT os_MaxFrames
   SHORT os_VStart
   SHORT os_CoProOffset
   SHORT os_LastWait
   USHORT os_LastCoProIns
   24 4 *  BYTES os_BitPlanes
   APTR os_MaskPlane
   ULONG os_AddressReg
   UBYTE os_UpdateDelay
   UBYTE os_PalLoadAddress
   UBYTE os_PixelReadMask
   UBYTE os_CommandReg
   3 256 * BYTES os_Palette
   UBYTE os_Pen_R
   UBYTE os_Pen_G
   UBYTE os_Pen_B
   UBYTE os_Red
   UBYTE os_Green
   UBYTE os_Blue
   MAXCOPROINS BYTES os_CoProData
   SHORT os_Modulo
   38 BYTES os_Reserved
EXISTS? OPAL_PRIVATE .IF
   12 4 *  BYTES os_CopList_Cycle
   UBYTE os_Update_Cycles
   UBYTE os_Pad
.THEN
;STRUCT

decimal
\ Opal Library Error Codes
1 constant OL_ERR_OUTOFMEM
2 constant OL_ERR_OPENFILE
3 constant OL_ERR_NOTIFF
3 constant OL_ERR_FORMATUNKNOWN
4 constant OL_ERR_NOTILBM
5 constant OL_ERR_FILEREAD
6 constant OL_ERR_FILEWRITE
7 constant OL_ERR_BADIFF
8 constant OL_ERR_CANTCLOSE
9 constant OL_ERR_OPENSCREEN
10 constant OL_ERR_NOTHUMBNAIL
11 constant OL_ERR_BADJPEG
12 constant OL_ERR_UNSUPPORTED
13 constant OL_ERR_CTRLC
40 constant OL_ERR_MAXERR

