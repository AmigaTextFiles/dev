; AMOS Extension for OpalVision support.
; (C) 1992 Opal Technology PTY LTD.
;
; Written By Martin Boyd.


	opt C-

ExtNb		EQU	21-1	;NOTE: Extension number is 21.

	incdir "asm:include/"
 	Include	"_Equ.s"	;These files are included with AMOS.
	RsSet	DataLong
	Include "_Pointe.s"
	Include "_CEqu.s"
	Include	"_WEqu.s"
	Include	"_LEqu.s"

	include "exec/types.i"
	include "exec/exec_lib.i"
	include "opal/opallib.i"
;	include "graphics/gfxbase.i"


;from gfxbase.i

    IFND    EXEC_LISTS_I
    include 'exec/lists.i'
    ENDC
    IFND    EXEC_LIBRARIES_I
    include 'exec/libraries.i'
    ENDC
    IFND    EXEC_INTERRUPTS_I
    include 'exec/interrupts.i'
    ENDC

 STRUCTURE  GfxBase,LIB_SIZE
    APTR    gb_ActiView     ; struct *View
    APTR    gb_copinit	    ; struct *copinit; ptr to copper start up list
    APTR    gb_cia	; for 6526 resource use
    APTR    gb_blitter	    ; for blitter resource use
    APTR    gb_LOFlist	    ; current copper list being run
    APTR    gb_SHFlist	    ; current copper list being run
    APTR    gb_blthd	    ; struct *bltnode
    APTR    gb_blttl	    ;
    APTR    gb_bsblthd	    ;
    APTR    gb_bsblttl	    ;
    STRUCT  gb_vbsrv,IS_SIZE
    STRUCT  gb_timsrv,IS_SIZE
    STRUCT  gb_bltsrv,IS_SIZE
    STRUCT  gb_TextFonts,LH_SIZE
    APTR    gb_DefaultFont
    UWORD   gb_Modes	    ; copy of bltcon0
    BYTE    gb_VBlank
    BYTE    gb_Debug
    UWORD   gb_BeamSync
    WORD    gb_system_bplcon0
    BYTE    gb_SpriteReserved
    BYTE    gb_bytereserved

    WORD    gb_Flags
    WORD    gb_BlitLock
	WORD	gb_BlitNest
	STRUCT	gb_BlitWaitQ,LH_SIZE
	APTR	gb_BlitOwner
	STRUCT	gb_TOF_WaitQ,LH_SIZE

	WORD	gb_DisplayFlags
	APTR	gb_SimpleSprites
	WORD	gb_MaxDisplayRow
	WORD	gb_MaxDisplayColumn
	WORD	gb_NormalDisplayRows
	WORD	gb_NormalDisplayColumns
	WORD	gb_NormalDPMX
	WORD	gb_NormalDPMY

	APTR	gb_LastChanceMemory
	APTR	gb_LCMptr

	WORD	gb_MicrosPerLine	; usecs per line times 256
	WORD	gb_MinDisplayColumn

	UBYTE	gb_ChipRevBits0		; agnus/denise new features
	STRUCT	gb_crb_reserved,5

	STRUCT	gb_monitor_id,2	; normally null
	STRUCT	gb_hedley,4*8
	STRUCT	gb_hedley_sprites,4*8
	STRUCT	gb_hedley_sprites1,4*8
	WORD	gb_hedley_count
	WORD	gb_hedley_flags
	WORD	gb_hedley_tmp
	APTR	gb_hash_table
	UWORD	gb_current_tot_rows
	UWORD	gb_current_tot_cclks
	UBYTE	gb_hedley_hint
	UBYTE	gb_hedley_hint2
	STRUCT	gb_nreserved,4*4
	APTR	gb_a2024_sync_raster
	WORD	gb_control_delta_pal
	WORD	gb_control_delta_ntsc
	APTR	gb_current_monitor
	STRUCT	gb_MonitorList,LH_SIZE
	APTR	gb_default_monitor
	APTR	gb_MonitorListSemaphore
	APTR	gb_DisplayInfoDataBase
	APTR	gb_ActiViewCprSemaphore
	APTR	gb_UtilityBase
	APTR	gb_ExecBase
    LABEL   gb_SIZE


OPALBASE	EQU	0



A_CALLOPAL	MACRO
		move.l	A6,-(SP)
		move.l	ExtAdr+ExtNb*16(a5),A6
		move.l	(A6),A6
		jsr	_LVO\1(a6)
		move.l	(SP)+,A6
		move.l	D0,D3
		moveq	#0,D2
		ENDM



Start	dc.l	C_Tk-C_Off	;Pointer to the token list
	dc.l	C_Lib-C_Tk	;Pointer to the first library function
	dc.l	C_Title-C_Lib	;Pointer to the title
	dc.l	C_End-C_Title	;From title to the end of the program
	dc.w	0	

******************************************************************
*	Offset to functions

C_Off	dc.w (L1-L0)/2,(L2-L1)/2,(L3-L2)/2,(L4-L3)/2,(L5-L4)/2,(L6-L5)/2
	dc.w (L7-L6)/2,(L8-L7)/2,(L9-L8)/2,(L10-L9)/2,(L11-L10)/2,(L12-L11)/2
	dc.w (L13-L12)/2,(L14-L13)/2,(L15-L14)/2,(L16-L15)/2,(L17-L16)/2,(L18-L17)/2
	dc.w (L19-L18)/2,(L20-L19)/2,(L21-L20)/2,(L22-L21)/2,(L23-L22)/2,(L24-L23)/2
	dc.w (L25-L24)/2,(L26-L25)/2,(L27-L26)/2,(L28-L27)/2,(L29-L28)/2,(L30-L29)/2
	dc.w (L31-L30)/2,(L32-L31)/2,(L33-L32)/2,(L34-L33)/2,(L35-L34)/2,(L36-L35)/2
	dc.w (L37-L36)/2,(L38-L37)/2,(L39-L38)/2,(L40-L39)/2,(L41-L40)/2,(L42-L41)/2
	dc.w (L43-L42)/2,(L44-L43)/2,(L45-L44)/2,(L46-L45)/2,(L47-L46)/2,(L48-L47)/2
	dc.w (L49-L48)/2,(L50-L49)/2,(L51-L50)/2,(L52-L51)/2,(L53-L52)/2,(L54-L53)/2
	dc.w (L55-L54)/2,(L56-L55)/2,(L57-L56)/2,(L58-L57)/2,(L59-L58)/2,(L60-L59)/2
	dc.w (L61-L60)/2,(L62-L61)/2,(L63-L62)/2,(L64-L63)/2,(L65-L64)/2,(L66-L65)/2
	dc.w (L67-L66)/2,(L68-L67)/2,(L69-L68)/2,(L70-L69)/2,(L71-L70)/2,(L72-L71)/2
	dc.w (L73-L72)/2,(L74-L73)/2,(L75-L74)/2,(L76-L75)/2,(L77-L76)/2,(L78-L77)/2
	dc.w (L79-L78)/2,(L80-L79)/2,(L81-L80)/2,(L82-L81)/2


******************************************************************
*	TOKEN TABLE

; The next two lines needs to be unchanged...
C_Tk:	dc.w 	1,0
	dc.b 	$80,-1


; Now the real tokens...
	dc.w	-1,L_OpenScreen24
	dc.b	"ovopenscreen2","4"+$80,"00",-1
	dc.w	L_CloseScreen24,-1
	dc.b	"ovclosescreen2","4"+$80,"I",-1
	dc.w	L_WritePixel24,-1
	dc.b	"ovwritepixel2","4"+$80,"I0,0,0",-1
	dc.w	L_ReadPixel24,-1
	dc.b	"ovreadpixel2","4"+$80,"I0,0,0",-1
	dc.w	L_ClearScreen24,-1
	dc.b	"ovclearscreen2","4"+$80,"I0",-1
	dc.w	L_ILBMtoOV,-1
	dc.b	"ovilbmtoo","v"+$80,"I0,0,0,0,0,0",-1
	dc.w	L_UpdateDelay24,-1
	dc.b	"ovupdatedelay2","4"+$80,"I0",-1
	dc.w	L_Refresh24,-1
	dc.b	"ovrefresh2","4"+$80,"I",-1
	dc.w	L_SetDisplayBottom24,-1
	dc.b	"ovsetdisplaybottom2","4"+$80,"I0",-1
	dc.w	L_ClearDisplayBottom24,-1
	dc.b	"ovcleardisplaybottom2","4"+$80,"I",-1
	dc.w	L_SetSprite24,-1
	dc.b	"ovsetsprite2","4"+$80,"I0,0",-1
	dc.w	L_AmigaPriority,-1
	dc.b	"ovamigapriorit","y"+$80,"I",-1
	dc.w	L_OVPriority,-1
	dc.b	"ovpriorit","y"+$80,"I",-1
	dc.w	L_DualDisplay24,-1
	dc.b	"ovdualdisplay2","4"+$80,"I",-1
	dc.w	L_SingleDisplay24,-1
	dc.b	"ovsingledisplay2","4"+$80,"I",-1
	dc.w	L_AppendCopper24,-1
	dc.b	"ovappendcopper2","4"+$80,"I0",-1
	dc.w	L_RectFill24,-1
	dc.b	"ovrectfill2","4"+$80,"I0,0,0,0,0",-1
	dc.w	L_UpdateCoPro24,-1
	dc.b	"ovupdatecopro2","4"+$80,"I",-1
	dc.w	L_SetControlBit24,-1
	dc.b	"ovsetcontrolbit2","4"+$80,"I0,0,0",-1
	dc.w	L_PaletteMap24,-1
	dc.b	"ovpalettemap2","4"+$80,"I0",-1
	dc.w	L_UpdatePalette24,-1
	dc.b	"ovupdatepalette2","4"+$80,"I",-1
	dc.w	L_Scroll24,-1
	dc.b	"ovscroll2","4"+$80,"I0,0",-1
	dc.w	-1,L_LoadIFF24
	dc.b	"ovloadimage2","4"+$80,"00,2,0",-1
	dc.w	L_SetScreen24,-1
	dc.b	"ovsetscreen2","4"+$80,"I0",-1
	dc.w	-1,L_SaveIFF24
	dc.b	"ovsaveiff2","4"+$80,"00,2,0,0",-1
	dc.w	-1,L_CreateScreen24
	dc.b	"ovcreatescreen2","4"+$80,"00,0,0",-1
	dc.w	L_FreeScreen24,-1
	dc.b	"ovfreescreen2","4"+$80,"I0",-1
	dc.w	L_UpdateRegs24,-1
	dc.b	"ovupdateregs2","4"+$80,"I",-1
	dc.w	L_SetLoadAddress24,-1
	dc.b	"ovsetloadaddress2","4"+$80,"I",-1
	dc.w	L_RGBtoOV,-1
	dc.b	"ovrgbtoo","v"+$80,"I0,0,0,0,0,0",-1
	dc.w	-1,L_ActiveScreen24
	dc.b	"ovactivescreen2","4"+$80,"0",-1
	dc.w	L_FadeIn24,-1
	dc.b	"ovfadein2","4"+$80,"I0",-1
	dc.w	L_FadeOut24,-1
	dc.b	"ovfadeout2","4"+$80,"I0",-1
	dc.w	L_ClearQuick24,-1
	dc.b	"ovclearquick2","4"+$80,"I",-1
	dc.w	-1,L_WriteThumbnail24
	dc.b	"ovwritethumbnail2","4"+$80,"00,0",-1
	dc.w	L_SetRGB24,-1
	dc.b	"ovsetrgb2","4"+$80,"I0,0,0,0",-1
	dc.w	L_DrawLine24,-1
	dc.b	"ovdrawline2","4"+$80,"I0,0,0,0,0",-1
	dc.w	L_StopUpdate24,-1
	dc.b	"ovstopupdate2","4"+$80,"I",-1
	dc.w	L_WritePFPixel24,-1
	dc.b	"ovwritepfpixel2","4"+$80,"I0,0,0",-1
	dc.w	L_WritePRPixel24,-1
	dc.b	"ovwriteprpixel2","4"+$80,"I0,0,0",-1
	dc.w	L_OVtoRGB,-1
	dc.b	"ovtorg","b"+$80,"I0,0,0,0,0,0",-1
	dc.w	L_OVtoILBM,-1
	dc.b	"ovtoilb","m"+$80,"I0,0,0,0,0",-1
	dc.w	L_UpdateAll24,-1
	dc.b	"ovupdateall2","4"+$80,"I",-1
	dc.w	L_UpdatePFStencil24,-1
	dc.b	"ovupdatepfstencil2","4"+$80,"I",-1
	dc.w	L_EnablePRStencil24,-1
	dc.b	"ovenableprstencil2","4"+$80,"I",-1
	dc.w	L_DisablePRStencil24,-1
	dc.b	"ovdisableprstencil2","4"+$80,"I",-1
	dc.w	L_ClearPRStencil24,-1
	dc.b	"ovclearprstencil2","4"+$80,"I0",-1
	dc.w	L_SetPRStencil24,-1
	dc.b	"ovsetprstencil2","4"+$80,"I0",-1
	dc.w	L_DisplayFrame24,-1
	dc.b	"ovdisplayframe2","4"+$80,"I0",-1
	dc.w	L_WriteFrame24,-1
	dc.b	"ovwriteframe2","4"+$80,"I0",-1
	dc.w	L_BitPlanetoOV,-1
	dc.b	"ovbitplanetoo","v"+$80,"I0,0,0,0,0,0",-1
	dc.w	L_SetCoPro24,-1
	dc.b	"ovsetcopro2","4"+$80,"I0,0",-1
	dc.w	L_RegWait24,-1
	dc.b	"ovregwait2","4"+$80,"I",-1
	dc.w	L_DualPlayField24,-1
	dc.b	"ovdualplayfield2","4"+$80,"I",-1
	dc.w	L_SinglePlayField24,-1
	dc.b	"ovsingleplayfield2","4"+$80,"I",-1
	dc.w	L_ClearPFStencil24,-1
	dc.b	"ovclearpfstencil2","4"+$80,"I0",-1
	dc.w	L_SetPFStencil24,-1
	dc.b	"ovsetpfstencil2","4"+$80,"I0",-1
	dc.w	L_ReadPRPixel24,-1
	dc.b	"ovreadprpixel2","4"+$80,"I0,0,0",-1
	dc.w	L_ReadPFPixel24,-1
	dc.b	"ovreadpfpixel2","4"+$80,"I0,0,0",-1
	dc.w	L_OVtoBitPlane,-1
	dc.b	"ovtobitplan","e"+$80,"I0,0,0,0,0",-1
	dc.w	L_FreezeFrame24,-1
	dc.b	"ovfreezeframe2","4"+$80,"I0",-1
	dc.w	-1,L_LowMemUpdate24
	dc.b	"ovlowmemupdate2","4"+$80,"00,0",-1
	dc.w	-1,L_DisplayThumbnail24
	dc.b	"ovdisplaythumbnail2","4"+$80,"00,2,0,0",-1
	dc.w	-1,L_Config24
	dc.b	"ovconfig2","4"+$80,"0",-1
	dc.w	L_AutoSync24,-1
	dc.b	"ovautosync2","4"+$80,"I0",-1
	dc.w	L_DrawEllipse24,-1
	dc.b	"ovdrawellipse2","4"+$80,"I0,0,0,0,0",-1
	dc.w	L_LatchDisplay24,-1
	dc.b	"ovlatchdisplay2","4"+$80,"I0",-1
	dc.w	L_SetHires24,-1
	dc.b	"ovsethires2","4"+$80,"I0,0",-1
	dc.w	L_SetLores24,-1
	dc.b	"ovsetlores2","4"+$80,"I0,0",-1
	dc.w	-1,L_DownLoadFrame24
	dc.b	"ovdownloadframe2","4"+$80,"00,0,0,0,0",-1
	dc.w	-1,L_SaveJPEG24
	dc.b	"ovsavejpeg2","4"+$80,"00,2,0,0",-1
	dc.w	-1,L_LowMem2Update24
	dc.b	"ovlowmem2update2","4"+$80,"00,0",-1
	dc.w	-1,L_LoadIFF24
	dc.b	"ovloadiff2","4"+$80,"00,2,0",-1
	dc.w	L_SetPen24,-1
	dc.b	"ovsetpen2","4"+$80,"I0,0,0,0",-1
	dc.w	-1,L_GetRed24
	dc.b	"ovgetred2","4"+$80,"00",-1
	dc.w	-1,L_GetGreen24
	dc.b	"ovgetgreen2","4"+$80,"00",-1
	dc.w	-1,L_GetBlue24
	dc.b	"ovgetblue2","4"+$80,"00",-1
	dc.w	-1,L_CopperRefresh
	dc.b	"ovcopperrefres","h"+$80,"00",-1
	dc.w 	0


C_Lib
******************************************************************
*		COLD START

L0	movem.l	A3-A6,-(SP)
	lea	OB(PC),A0
	move.l	A0,ExtAdr+ExtNb*16(a5)
	lea	OpalName(PC),A1
	moveq	#0,D0
	CALLEXEC OpenLibrary
	lea	_OpalBase(PC),A0
	move.l	D0,(A0)
	movem.l	(SP)+,A3-A6
	moveq	#ExtNb,D0		;NO ERRORS
	rts

;	RDATA

*********************************************************************
*		OpalVision extension data zone
OB:
_OpalBase:	dc.l	0
OpalName:	OPALLIBNAME
		even
StringBuff:	ds.b	300
		even

*********************************************************************
L1
L2

L_OpenScreen24		EQU	3
L3
	move.l	(A3)+,D5
	lea	-$7fa(a5),A0
	moveq	#1,D0
	A_CALLOPAL AmosPatch24
	move.l	D5,D0
	A_CALLOPAL OpenScreen24
	move.l	D0,A0
	clr.b	OS_Pen_R(A0)
	move.b	#$FF,OS_Pen_G(A0)
	rts

L_CloseScreen24		EQU	4
L4
	A_CALLOPAL CloseScreen24
	movem.l	D0-D3,-(SP)
	lea	-$7fa(a5),A0
	moveq	#0,D0
	A_CALLOPAL AmosPatch24
	movem.l	(SP)+,D0-D3
	rts

L_WritePixel24		EQU	5
L5
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL WritePixel24
	rts

L_ReadPixel24		EQU	6
L6
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL ReadPixel24
	rts

L_ClearScreen24		EQU	7
L7
	move.l	(A3)+,A0
	A_CALLOPAL ClearScreen24
	rts

L_ILBMtoOV		EQU	8
L8
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL ILBMtoOV
	rts

L_UpdateDelay24		EQU	9
L9
	move.l	(A3)+,D0
	A_CALLOPAL UpdateDelay24
	rts

L_Refresh24		EQU	10
L10
	A_CALLOPAL Refresh24
	rts

L_SetDisplayBottom24	EQU	11
L11
	move.l	(A3)+,D0
	A_CALLOPAL SetDisplayBottom24
	rts

L_ClearDisplayBottom24	EQU	12
L12
	A_CALLOPAL ClearDisplayBottom24
	rts

L_SetSprite24		EQU	13
L13
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL SetSprite24
	rts

L_AmigaPriority		EQU	14
L14
	A_CALLOPAL AmigaPriority
	rts

L_OVPriority		EQU	15
L15
	A_CALLOPAL OVPriority
	rts

L_DualDisplay24		EQU	16
L16
	A_CALLOPAL DualDisplay24
	rts

L_SingleDisplay24	EQU	17
L17
	A_CALLOPAL SingleDisplay24
	rts

L_AppendCopper24	EQU	18
L18
	move.l	(A3)+,A0
	A_CALLOPAL AppendCopper24
	rts

L_RectFill24		EQU	19
L19
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL RectFill24
	rts

L_UpdateCoPro24		EQU	20
L20
	A_CALLOPAL UpdateCoPro24
	rts

L_SetControlBit24	EQU	21
L21
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL SetControlBit24
	rts

L_PaletteMap24		EQU	22
L22
	move.l	(A3)+,D0
	A_CALLOPAL PaletteMap24
	rts

L_UpdatePalette24	EQU	23
L23
	A_CALLOPAL UpdatePalette24
	rts

L_Scroll24		EQU	24
L24
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL Scroll24
	rts

L_LoadIFF24		EQU	25
L25
	lea	-$7fa(a5),A0
	moveq	#1,D0
	A_CALLOPAL AmosPatch24

	move.l	(A3)+,D0	;OpalScreen pointer.
	move.l	(A3)+,A1	;pointer to name.
	move.w	(A1)+,D1	;string (name) length.
	subq	#1,D1

	move.l	ExtAdr+ExtNb*16(a5),A0
	add.w	#StringBuff-OB,A0
.lp:	move.b	(A1)+,(A0)+	;copy string
	dbra	D1,.lp
	clr.b	(A0)		;terminate string
	move.l	ExtAdr+ExtNb*16(a5),A1
	add.w	#StringBuff-OB,A1
	move.l	(A3)+,A0
	A_CALLOPAL LoadIFF24
	rts

L_SetScreen24		EQU	26
L26
	move.l	(A3)+,A0
	A_CALLOPAL SetScreen24
	rts

L_SaveIFF24		EQU	27
L27
	move.l	(A3)+,D0	;Flags
	move.l	(A3)+,A2	;ChunkFunc
	move.l	(A3)+,A1	;FileName
	move.w	(A1)+,D1	;string (name) length.
	subq	#1,D1

	move.l	ExtAdr+ExtNb*16(a5),A0
	add.w	#StringBuff-OB,A0
.lp:	move.b	(A1)+,(A0)+	;copy string
	dbra	D1,.lp
	clr.b	(A0)		;terminate string
	move.l	ExtAdr+ExtNb*16(a5),A1
	add.w	#StringBuff-OB,A1
	move.l	(A3)+,A0	;screen
	A_CALLOPAL SaveIFF24
	rts

L_CreateScreen24	EQU	28
L28
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL CreateScreen24
	rts

L_FreeScreen24		EQU	29
L29
	move.l	(A3)+,A0
	A_CALLOPAL FreeScreen24
	rts

L_UpdateRegs24		EQU	30
L30
	A_CALLOPAL UpdateRegs24
	rts

L_SetLoadAddress24	EQU	31
L31
	A_CALLOPAL SetLoadAddress24
	rts

L_RGBtoOV		EQU	32
L32
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL RGBtoOV
	rts

L_ActiveScreen24	EQU	33
L33
	A_CALLOPAL ActiveScreen24
	rts

L_FadeIn24		EQU	34
L34
	move.l	(A3)+,D0
	A_CALLOPAL FadeIn24
	rts

L_FadeOut24		EQU	35
L35
	move.l	(A3)+,D0
	A_CALLOPAL FadeOut24
	rts

L_ClearQuick24		EQU	36
L36
	A_CALLOPAL ClearQuick24
	rts

L_WriteThumbnail24	EQU	37
L37
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL WriteThumbnail24
	rts

L_SetRGB24		EQU	38
L38
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL SetRGB24
	rts

L_DrawLine24		EQU	39
L39
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL DrawLine24
	rts

L_StopUpdate24		EQU	40
L40
	A_CALLOPAL StopUpdate24
	rts

L_WritePFPixel24	EQU	41
L41
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL WritePFPixel24
	rts

L_WritePRPixel24	EQU	42
L42
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL WritePRPixel24
	rts

L_OVtoRGB		EQU	43
L43
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL OVtoRGB
	rts

L_OVtoILBM		EQU	44
L44
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL OVtoILBM
	rts

L_UpdateAll24		EQU	45
L45
	A_CALLOPAL UpdateAll24
	rts

L_UpdatePFStencil24	EQU	46
L46
	A_CALLOPAL UpdatePFStencil24
	rts


L_EnablePRStencil24	EQU	47
L47
	A_CALLOPAL EnablePRStencil24
	rts

L_DisablePRStencil24	EQU	48
L48
	A_CALLOPAL DisablePRStencil24
	rts

L_ClearPRStencil24	EQU	49
L49
	move.l	(A3)+,A0
	A_CALLOPAL ClearPRStencil24
	rts

L_SetPRStencil24	EQU	50
L50
	move.l	(A3)+,A0
	A_CALLOPAL SetPRStencil24
	rts

L_DisplayFrame24	EQU	51
L51
	move.l	(A3)+,D0
	A_CALLOPAL DisplayFrame24
	rts

L_WriteFrame24		EQU	52
L52
	move.l	(A3)+,D0
	A_CALLOPAL WriteFrame24
	rts

L_BitPlanetoOV		EQU	53
L53
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL BitPlanetoOV
	rts

L_SetCoPro24		EQU	54
L54
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL SetCoPro24
	rts

L_RegWait24		EQU	55
L55
	A_CALLOPAL RegWait24
	rts

L_DualPlayField24	EQU	56
L56
	A_CALLOPAL DualPlayField24
	rts

L_SinglePlayField24	EQU	57
L57
	A_CALLOPAL SinglePlayField24
	rts

L_ClearPFStencil24	EQU	58
L58
	move.l	(A3)+,A0
	A_CALLOPAL ClearPFStencil24
	rts

L_SetPFStencil24	EQU	59
L59
	move.l	(A3)+,A0
	A_CALLOPAL SetPFStencil24
	rts

L_ReadPRPixel24		EQU	60
L60
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL ReadPRPixel24
	rts

L_ReadPFPixel24		EQU	61
L61
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL ReadPFPixel24
	rts

L_OVtoBitPlane		EQU	62
L62
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A1
	move.l	(A3)+,A0
	A_CALLOPAL OVtoBitPlane
	rts

L_FreezeFrame24		EQU	63
L63
	move.l	(A3)+,D0
	A_CALLOPAL FreezeFrame24
	rts

L_LowMemUpdate24	EQU	64
L64
	lea	-$7fa(a5),A0
	moveq	#1,D0
	A_CALLOPAL AmosPatch24
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL LowMemUpdate24
	rts

L_DisplayThumbnail24	EQU	65
L65
	move.l	(A3)+,D1	;Y coord
	move.l	(A3)+,D0	;X coord
	move.l	(A3)+,A1	;pointer to FileName.
	move.w	(A1)+,D2	;string (name) length.
	subq	#1,D2
	move.l	ExtAdr+ExtNb*16(a5),A0
	add.w	#StringBuff-OB,A0
.lp:	move.b	(A1)+,(A0)+	;copy string
	dbra	D2,.lp
	clr.b	(A0)		;terminate string
	move.l	ExtAdr+ExtNb*16(a5),A1
	add.w	#StringBuff-OB,A1
	move.l	(A3)+,A0	;screen
	A_CALLOPAL DisplayThumbnail24
	rts

L_Config24		EQU	66
L66
	A_CALLOPAL Config24
	rts

L_AutoSync24		EQU	67
L67
	move.l	(A3)+,D0
	A_CALLOPAL AutoSync24
	rts

L_DrawEllipse24		EQU	68
L68
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL DrawEllipse24
	rts

L_LatchDisplay24	EQU	69
L69
	move.l	(A3)+,D0
	A_CALLOPAL LatchDisplay24
	rts

L_SetHires24		EQU	70
L70
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL SetHires24
	rts

L_SetLores24		EQU	71
L71
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	A_CALLOPAL SetLores24
	rts

L_DownLoadFrame24	EQU	72
L72
	move.l	(A3)+,D3
	move.l	(A3)+,D2
	move.l	(A3)+,D1
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL DownLoadFrame24
	rts

L_SaveJPEG24		EQU	73
L73
	move.l	(A3)+,D1	;Quality
	move.l	(A3)+,D0	;Flags
	move.l	(A3)+,A1	;Filename
	move.w	(A1)+,D2	;string (name) length.
	subq	#1,D2
	move.l	ExtAdr+ExtNb*16(a5),A0
	add.w	#StringBuff-OB,A0
.lp:	move.b	(A1)+,(A0)+	;copy string
	dbra	D2,.lp
	clr.b	(A0)		;terminate string
	move.l	ExtAdr+ExtNb*16(a5),A1
	add.w	#StringBuff-OB,A1
	move.l	(A3)+,A0	;Screen
	A_CALLOPAL SaveJPEG24
	rts

L_LowMem2Update24	EQU	74
L74
	lea	-$7fa(a5),A0
	moveq	#1,D0
	A_CALLOPAL AmosPatch24
	move.l	(A3)+,D0
	move.l	(A3)+,A0
	A_CALLOPAL LowMem2Update24
	rts

L_SetPen24		EQU	75
L75	move.l	(A3)+,D2	;Blue
	move.l	(A3)+,D1	;Green
	move.l	(A3)+,D0	;Red
	move.l	(A3)+,A0	;screen
	move.b	D0,OS_Pen_R(A0)
	move.b	D1,OS_Pen_G(A0)
	move.b	D2,OS_Pen_B(A0)
	rts

L_GetRed24		EQU	76
L76	move.l	(A3)+,A0	;Screen
	moveq	#0,D3
	move.b	OS_Red(A0),D3
	moveq	#0,D2
	rts

L_GetGreen24		EQU	77
L77	move.l	(A3)+,A0	;Screen
	moveq	#0,D3
	move.b	OS_Green(A0),D3
	moveq	#0,D2
	rts

L_GetBlue24		EQU	78
L78	move.l	(A3)+,A0	;Screen
	moveq	#0,D3
	move.b	OS_Blue(A0),D3
	moveq	#0,D2
	rts

L_CopperRefresh		EQU	79
L79	lea	-$7fa(a5),A0
	moveq	#1,D0
	A_CALLOPAL AmosPatch24
	rts

*********************************************************************
*	ERROR MESSAGES...
;
; You know that the compiler have a -E1 option (with errors) and a 
; a -E0 (without errors). To achieve that, the compiler copies one of
; the two next routines, depending on the -E flag. If errors are to be
; copied along with the program, then the next next routine is used. If not,
; then the next one is copied.
; The compiler assumes that the two last routines in the library handles
; the errors: the previous last is WITH errors, the last is WITHOUT. So,
; remember:
;
; THESE ROUTINES MUST BE THE LAST ONES IN THE LIBRARY
;
; The AMOS interpretor always needs errors. So make all your custom errors
; calls point to the L_Custom routine, and everything will work fine...
;
******* "With messages" routine.
; The following routine is the one your program must call to output
; a extension error message. It will be used under interpretor and under
; compiled program with -E1

L_Custom	EQU	80
L80	lea	ErrMess(pc),a0
	moveq	#0,d1			* Can be trapped
	moveq	#ExtNb,d2		* Number of extension
	moveq	#0,d3			* IMPORTANT!!!
	RJmp	L_ErrorExt		* Jump to routine...
* Messages...
ErrMess	dc.b	"Can't Open Opal.Library",0		*0
	even

******* "No errors" routine
; If you compile with -E0, the compiler will replace the previous
; routine by this one. This one just sets D3 to -1, and does not
; load messages in A0. Anyway, values in D1 and D2 must be valid.
;	
; THIS ROUTINE MUST BE THE LAST ONE IN THE LIBRARY!
;

L81	moveq	#0,d1
	moveq	#ExtNb,d2
	moveq	#-1,d3
	RJmp	L_ErrorExt

; Do not forget the last label to delimit the last library routine!
L82

*********************************************************************
; Now the title of the extension. If you come from V1.23 note that
; the cursor is no more located on the screen, instead a CDOWN (31)
; control code is used...

******* TITLE MESSAGE
C_Title	dc.b	31,"OpalVision V1.1, ©1992 Opal Technology Pty Ltd.",0
	even

******* END OF THE EXTENSION
C_End	dc.w	0


