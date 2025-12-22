*-Revision Header-*************************************************************
*                                                                             *
*    Project: GameSupport                                 _____       ____    *
*                                                        /    |\    /|    \   *
*    Version: 1.0                                       /     | \  / |     \  *
*                                                      /      |  \/  |     /  *
*       File: GameSupport.s                           /-------|      |-----   *
*                                                    /        |      |     \  *
*     Author: Alastair M. Robinson                  /         |      |      \ *
*                                                                             *
****Revision: 0019                                                   © - 1996 *
*                                                                             *
*******************************************************************************
*            *                                                                *
*    Date    *                            Comment                             *
*            *                                                                *
*******************************************************************************
*            *                                                                *
* 12.07.1996 * This revision header added.                           (V1.0) *
*            *                                                                *
* 02.08.1996 * ProTracker global volume command added.               (V1.1) *
*            *                                                                *
* 01.09.1996 * Gsiconify() fixed.                                    (V1.2) *
****************************************************************-RevisionTail-*

;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; GameSupport extension code
;---------------------------------------------------------------------
; ©1996 by Alastair M. Robinson
;---------------------------------------------------------------------
;

Version         MACRO
                dc.b    "1.2"
                ENDM

ExtNb           equ     23-1
                incdir  "AMOSIncludes/"
                Include "|AMOS_Includes.s"
                incdir  "text_include:"
                include "AMOSIncludes/GSGameport_lib.i"
                include "AMOSIncludes/GSChunky2Planar_lib.i"
                include "AMOSIncludes/GSChunky2Planar.i"
                include "AMOSIncludes/GSCodeModule.i"
                include "libraries/lowlevel_lib.i"
                include "workbench/wb_lib.i"
                include "workbench/icon_lib.i"
                include "workbench/workbench.i"
DLea            MACRO
                move.l  ExtAdr+ExtNb*16(a5),\2
                add.w   #\1-MB,\2
                ENDM

DLoad           MACRO
                move.l  ExtAdr+ExtNb*16(a5),\1
                ENDM

******************************************************************
*       AMOSPro GAMESUPPORT EXTENSION
;
; First, a pointer to the token list
Start   dc.l    C_Tk-C_Off
;
; Then, a pointer to the first library function
        dc.l    C_Lib-C_Tk
;
; Then to the title
        dc.l    C_Title-C_Lib
;
; From title to the end of the program
        dc.l    C_End-C_Title

        dc.w    0

******************************************************************
*       Offset to library

C_Off   dc.w (L1-L0)/2,(L2-L1)/2,(L3-L2)/2,(L4-L3)/2,(L5-L4)/2
        dc.w (L6-L5)/2,(L7-L6)/2,(L8-L7)/2,(L9-L8)/2,(L10-L9)/2
        dc.w (L11-L10)/2,(L12-L11)/2,(L13-L12)/2,(L14-L13)/2,(L15-L14)/2
        dc.w (L16-L15)/2,(L17-L16)/2,(L18-L17)/2,(L19-L18)/2,(L20-L19)/2
        dc.w (L21-L20)/2,(L22-L21)/2,(L23-L22)/2,(L24-L23)/2,(L25-L24)/2
        dc.w (L26-L25)/2,(L27-L26)/2,(L28-L27)/2,(L29-L28)/2,(L30-L29)/2
        dc.w (L31-L30)/2,(L32-L31)/2,(L33-L32)/2,(L34-L33)/2,(L35-L34)/2
        dc.w (L36-L35)/2,(L37-L36)/2,(L38-L37)/2,(L39-L38)/2,(L40-L39)/2
        dc.w (L41-L40)/2,(L42-L41)/2,(L43-L42)/2,(L44-L43)/2,(L45-L44)/2
        dc.w (L46-L45)/2,(L47-L46)/2,(L48-L47)/2,(L49-L48)/2,(L50-L49)/2
        dc.w (L51-L50)/2,(L52-L51)/2,(L53-L52)/2,(L54-L53)/2,(L55-L54)/2
        dc.w (L56-L55)/2,(L57-L56)/2,(L58-L57)/2,(L59-L58)/2,(L60-L59)/2
        dc.w (L61-L60)/2,(L62-L61)/2,(L63-L62)/2,(L64-L63)/2,(L65-L64)/2
        dc.w (L66-L65)/2,(L67-L66)/2,(L68-L67)/2,(L69-L68)/2,(L70-L69)/2
        dc.w (L71-L70)/2,(L72-L71)/2,(L73-L72)/2,(L74-L73)/2,(L75-L74)/2
        dc.w (L76-L75)/2,(L77-L76)/2,(L78-L77)/2,(L79-L78)/2,(L80-L79)/2
        dc.w (L81-L80)/2,(L82-L81)/2,(L83-L82)/2,(L84-L83)/2,(L85-L84)/2
        dc.w (L86-L85)/2,(L87-L86)/2,(L88-L87)/2,(L89-L88)/2,(L90-L89)/2
        dc.w (L91-L90)/2,(L92-L91)/2,(L93-L92)/2,(L94-L93)/2,(L95-L94)/2
        dc.w (L96-L95)/2,(L97-L96)/2,(L98-L97)/2,(L99-L98)/2,(L100-L99)/2
        dc.w (L101-L100)/2,(L102-L101)/2

; Do not forget the LAST label!!!

******************************************************************
*       TOKEN TABLE

; The next two lines needs to be unchanged...
C_Tk:   dc.w    1,0
        dc.b    $80,-1

; Now the real tokens...
        dc.w    -1,L_GSReadPort
        dc.b    "gsreadpor","t"+$80,"00",-1
        dc.w    -1,L_GSTimer
        dc.b    "gstime","r"+$80,"0",-1
        dc.w    -1,L_GSMouseDX
        dc.b    "gsmoused","x"+$80,"00",-1
        dc.w    -1,L_GSMouseDY
        dc.b    "gsmoused","y"+$80,"00",-1
        dc.w    L_GSSetMouseSpeed,-1
        dc.b    "gssetmousespee","d"+$80,"I0",-1
        dc.w    -1,L_GSIconify2
        dc.b    "!gsiconif","y"+$80,"02",-2
        dc.w    -1,L_GSIconify
        dc.b    $80,"02,2",-1
        dc.w    -1,L_GSSqr
        dc.b    "gssq","r"+$80,"00",-1
        dc.w    L_GSForbid,-1
        dc.b    "gsmulti of","f"+$80,"I",-1
        dc.w    L_GSPermit,-1
        dc.b    "gsmulti o","n"+$80,"I",-1
        dc.w    L_GSTrackStop,-1
        dc.b    "gstrack sto","p"+$80,"I",-1
        dc.w    -1,L_GSCMD8Data
        dc.b    "gscmd8dat","a"+$80,"0",-1
        dc.w    L_GSTrackTranspose,-1
        dc.b    "gstrack transpos","e"+$80,"I0",-1
        dc.w    L_GSTrackPlay3,-1
        dc.b    "!gstrack pla","y"+$80,"I0",-2
        dc.w    L_GSTrackPlay2,-1
        dc.b    $80,"I0,0",-2
        dc.w    L_GSTrackPlay1,-1
        dc.b    $80,"I0,0t0",-1
        dc.w    L_GSTrackLoopOn,-1
        dc.b    "gstrack loop o","n"+$80,"I",-2
        dc.w    L_GSTrackLoopOff,-1
        dc.b    "gstrack loop of","f"+$80,"I",-2
        dc.w    L_GSTrackLoop,-1
        dc.b    "gstrack loo","p"+$80,"I0",-2
        dc.w    L_GSTrackLoop2,-1
        dc.b    "gstrack loo","p"+$80,"I0t0",-2
        dc.w    L_GSTrackLoopDefer,-1
        dc.b    "gstrack loop defe","r"+$80,"I0t0",-1
        dc.w    L_GSTrackGosub,-1
        dc.b    "!gstrack gosu","b"+$80,"I0t0",-2
        dc.w    L_GSTrackGosub2,-1
        dc.b    $80,"I0",-1
        dc.w    L_GSTrackVolume,-1
        dc.b    "gstrack volum","e"+$80,"I0",-1
        dc.w    -1,L_GSPassCode
        dc.b    "gspasscod","e"+$80,"22,0,0",-1
        dc.w    -1,L_GSPassDeCode
        dc.b    "gspassdecod","e"+$80,"02,2,0",-1
        dc.w    -1,L_GSControllerType
        dc.b    "gscontrollertyp","e"+$80,"0",-1
        dc.w    -1,L_GSReadSega
        dc.b    "gsreadseg","a"+$80,"0",-1
        dc.w    -1,L_GSPyth
        dc.b    "gspyt","h"+$80,"00,0",-1

        dc.w    -1,L_OpenC2PLib
        dc.b    "gsopenc2pli","b"+$80,"02",-1
        dc.w    L_CloseC2PLib,-1
        dc.b    "gsclosec2pli","b"+$80,"I",-1
        dc.w    -1,L_C2PGo
        dc.b    "gschunky2plana","r"+$80,"0",-1
        dc.w    L_GSSetC2PPalette,-1
        dc.b    "gssetc2pcolou","r"+$80,"I0,0",-1
        dc.w    L_GSC2PSetRegion,-1
        dc.b    "gssetc2pregio","n"+$80,"I0,0t0,0",-1
        dc.w    -1,L_GSGetC2PInfo
        dc.b    "gsc2pinf","o"+$80,"0",-1
        dc.w    L_GSC2PDebug,-1
        dc.b    "gsc2pdebu","g"+$80,"I",-1

        dc.w    -1,L_GSLoadCodeMod
        dc.b    "gsloadcodemo","d"+$80,"02",-1
        dc.w    L_GSUnloadCodeMod,-1
        dc.b    "gsunloadcodemo","d"+$80,"I0",-1
        dc.w    L_GSSetAttr,-1
        dc.b    "gssetatt","r"+$80,"I0,2,0",-1
        dc.w    -1,L_GSGetAttr
        dc.b    "gsgetatt","r"+$80,"00,2",-1
        dc.w    -1,L_GSFindAttr
        dc.b    "gsfindatt","r"+$80,"00,2",-1
        dc.w    L_GSCallMod,-1
        dc.b    "gscallmo","d"+$80,"I0,2",-1
        dc.w    0


;

C_Lib
******************************************************************
*               COLD START
*
; The first routine of the library will perform all initialisations in the
; booting of AMOS.
;

L0      movem.l a3-a6,-(sp)

        lea     MyVBLRoutine(pc),a3
        move.l  a3,VblRout(a5)

; Here I store the address of the extension data zone in the special area
        lea     MyBase(pc),a3
        move.l  a3,ExtAdr+ExtNb*16(a5)
;
; Here, I store the address of the routine called by DEFAULT, or RUN
        lea     MyDefault(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+4(a5)
;
; Here, the address of the END routine,
        lea     MyEnd(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+8(a5)
;
; And now the Bank check routine..
        lea     MyBankCheck(pc),a0
        move.l  a0,ExtAdr+ExtNb*16+12(a5)

        DLoad   a3
        lea     LowLevelName-MyBase(a3),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)
        move.l  d0,MyLowLevelBase-MyBase(a3)

        lea     WorkbenchName-MyBase(a3),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)
        move.l  d0,MyWorkbenchBase-MyBase(a3)

        lea     IconName-MyBase(a3),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)
        move.l  d0,MyIconBase-MyBase(a3)

        lea     GSDriverName-MyBase(a3),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)
        move.l  d0,GSDriverPort0Base-MyBase(a3)

        movem.l (sp)+,a3-a6
        moveq   #ExtNb,d0               * NO ERRORS
        rts

******* SCREEN RESET
; This routine is called each time a DEFAULT occurs...

MyDefault
        movem.l a3-6,-(a7)
        DLoad   a1
        tst.b   mt_Enable-MyBase(a1)
        beq.s   .skip
.stop
        lea     mt_Enable(pc),a0
        st      (a0)
        bsr     mt_end
        bsr     ResetCIAInt

.skip
        movem.l (a7)+,a3-6

        DLoad   a0
        move.b  #0,TransposeData-MyBase(a0)
        move.w  #0,FX8Mask-MyBase(a0)
        move.l  #-1,FirstPattern-MyBase(a0)
        move.l  #-1,LastPattern-MyBase(a0)
        move.l  #1,TrackLoop-MyBase(a0)
        move.w  #64,MasterVolume-MyBase(a0)
        moveq   #0,d1
        move.l  #8,MouseSpeed-MyBase(a0)
        move.w  $dff00c,d1
        and.w   #$ff,d1
        move.l  d1,LastXPort1-MyBase(a0)
        move.w  $dff00a,d1
        and.w   #$ff,d1
        move.l  d1,LastXPort0-MyBase(a0)
        move.w  $dff00c,d1
        lsr.w   #8,d1
        move.l  d1,LastYPort1-MyBase(a0)
        move.w  $dff00a,d1
        lsr.w   #8,d1
        move.l  d1,LastYPort0-MyBase(a0)

        move.l  a4,-(a7)
        lea     CodeModules-MyBase(a0),a4
        moveq   #15,d7

.modloop
        move.l  (a4),d1
        beq     .nocodemod
        move.l  DosBase(a5),a6
        move.l  (a4),d1
        move.l  #0,(a4)
        jsr     _LVOUnLoadSeg(a6)
.nocodemod
        lea     8(a4),a4
        dbf     d7,.modloop
        move.l  (a7)+,a4

        rts

******* QUIT

MyEnd:
        movem.l a3-6,-(a7)
;        clr.l   VblRout(a5)
        DLoad   a1

        tst.b   mt_Enable-MyBase(a1)
        beq.s   .skip
.stop
        lea     mt_Enable-MyBase(a1),a0
        st      (a0)
        bsr     mt_end
        bsr     ResetCIAInt

.skip
        movem.l (a7),a3-6

        DLoad   a3
        lea     CodeModules-MyBase(a3),a4
        moveq   #15,d7
.modloop
        move.l  (a4),d1
        beq     .nocodemod
        move.l  DosBase(a5),a6
        move.l  #0,(a4)
        jsr     _LVOUnLoadSeg(a6)
.nocodemod
        lea     8(a4),a4
        dbf     d7,.modloop

        movem.l (a7)+,a3-6

        DLoad   a3

        tst.l   MyLowLevelBase-MyBase(a3)
        beq     .skiplowlevel
        move.l  4,a6
        move.l  MyLowLevelBase-MyBase(a3),a1
        jsr     _LVOCloseLibrary(a6)
.skiplowlevel
        DLoad   a3
        tst.l   MyWorkbenchBase-MyBase(a3)
        beq     .skipworkbench
        move.l  4,a6
        move.l  MyWorkbenchBase-MyBase(a3),a1
        jsr     _LVOCloseLibrary(a6)
.skipworkbench
        DLoad   a3
        tst.l   MyIconBase-MyBase(a3)
        beq     .skipicon
        move.l  4,a6
        move.l  MyIconBase-MyBase(a3),a1
        jsr     _LVOCloseLibrary(a6)
.skipicon
        DLoad   a3
        tst.l   GSDriverPort0Base-MyBase(a3)
        beq     .skipgssega
        move.l  4,a6
        move.l  GSDriverPort0Base-MyBase(a3),a1
        jsr     _LVOCloseLibrary(a6)
.skipgssega
        rts

MyBankCheck
        movem.l a3-6,-(a7)
        DLoad   a1
        tst.b   mt_Enable-MyBase(a1)
        beq.s   .skip
        move.l  mt_data-MyBase(a1),a0
        cmp.l   #"ker ",-(a0)
        bne.s   .stop
        cmp.l   #"Trac",-(a0)
        beq.s   .skip
.stop
        lea     mt_Enable(pc),a0
        st      (a0)
        bsr     mt_end
        bsr     ResetCIAInt

.skip
        movem.l (a7)+,a3-6
        rts

***********************************************************
*
*       Protracker replay routines
*
***********************************************************

        include "SubRoutines/PlayRoutine.s"

MyVBLRoutine
        lea     MyVPOSR(pc),a0
        move.l  $dff004,(a0)
        move.l  C2PVBlankHook(pc),d0
        beq     .dontcall
        move.l  d0,a0
        jsr     (a0)
.dontcall
        lea     MyBase(pc),a2
        move.l  LastYPort0-MyBase(a2),d0
        moveq   #0,d1
        move.w  $dff00a,d1
        lsr.w   #8,d1
        move.l  d1,LastYPort0-MyBase(a2)
        sub.l   d0,d1
        bsr     .fixdeltamouse
        add.l   d1,MouseDY0-MyBase(a2)

        move.l  LastXPort0-MyBase(a2),d0
        moveq   #0,d1
        move.w  $dff00a,d1
        and.w   #$ff,d1
        move.l  d1,LastXPort0-MyBase(a2)
        sub.l   d0,d1
        bsr     .fixdeltamouse

        add.l   d1,MouseDX0-MyBase(a2)

        rts

.fixdeltamouse
        cmp.l   #128,d1
        bge     .sub
        cmp.l   #-128,d1
        bge     .dontadd
        add.l   #256,d1
.dontadd
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts
.sub
        sub.l   #256,d1
        move.l  MouseSpeed-MyBase(a2),d0
        muls    d0,d1
        asr.l   #3,d1
        rts

MyVPOSR
        dc.l    0

*********************************************************************
*               extension data zone

MyBase:
TrackLoop
        dc.l    0
FirstPattern
        dc.l    0
LastPattern
        dc.l    0
FirstPattern2
        dc.l    0
LastPattern2
        dc.l    0
UserData
        dc.l    0
MasterVolume
        dc.w    64
MyIconFilename
        dc.l    0
MyIconTitle
        dc.l    0
MyAppIcon
        dc.l    0
MyDiskObject
        dc.l    0
IconMsgPort
        dc.l    0
MouseSpeed
        dc.l    0
MouseDX0
        dc.l    0
MouseDY0
        dc.l    0
LastXPort0
        dc.l    0
LastYPort0
        dc.l    0
LastXPort1
        dc.l    0
LastYPort1
        dc.l    0
MyEClock
        dc.l    0,0
MyLowLevelBase
        dc.l    0
MyWorkbenchBase
        dc.l    0
MyIconBase
        dc.l    0
GSC2PBase
        dc.l    0
C2PInfo
        dc.l    0
GSDriverPort0Base
        dc.l    0
GSDriverPort1Base
        dc.l    0
GSDriverPort2Base
        dc.l    0
GSDriverPort3Base
        dc.l    0
C2PVBlankHook
        dc.l    0
CodeModules
        dcb.b   128,0
LowLevelName
        dc.b    "lowlevel.library",0
WorkbenchName
        dc.b    "workbench.library",0
IconName
        dc.b    "icon.library",0
GSDriverName
        dc.b    "GSDrivers/gsjoystick.library",0
GSC2PName
        dc.b    "GSChunky2Planar/"
C2PLibraryName
        dcb.b   32,0
        EVEN
                Rdata

;********************************************************************

        include "Labels1-9.s"   ; Controller routines.

        include "MusicRoutines.s" ; Music routines.

L_GSPassCode equ 36
L36
        include "SubRoutines/Encode.s"

L_GSPassDeCode equ 37
L37
        include "SubRoutines/Decode.s"
L38
L39
L40
L41
L42
L43
L44
L45
L46
L47
L48
L49
L50
L51
L52
L53
L54
L55
L56
L57
L58
L59
L60
L61
L62
L63
L64
L65
L66
L67
L68
L69
L70
L71
L72
L73
L74
L75
L76
L77
L78
L79

L_OpenC2PLib equ 80
L80
        move.l  (a3)+,a0
        movem.l a1-6,-(a7)
        move.w  (a0)+,d7
        subq    #1,d7
        bmi     .dontbother
        DLoad   a1
        lea     C2PLibraryName-MyBase(a1),a2
.copyloop
        move.b  (a0)+,(a2)+
        dbf     d7,.copyloop
        move.b  #0,(a2)+

        lea     GSC2PName-MyBase(a1),a1
        moveq   #0,d0
        move.l  4,a6
        jsr     _LVOOpenLibrary(a6)

        DLoad   a1
        move.l  d0,GSC2PBase-MyBase(a1)

        tst.l   d0
        beq     .dontbother

        move.l  d0,a6

        jsr     _LVOGSGetC2PInfo(a6)
        move.l  d0,C2PInfo-MyBase(a1)

        jsr     _LVOGSInitialiseC2P(a6)

        move.l  d0,d3
        move.l  #0,d2
        movem.l (a7)+,a1-6
        rts

.dontbother
        move.l  #0,d3
        move.l  #0,d2
        movem.l (a7)+,a1-6
        rts

L_CloseC2PLib equ 81
L81
        movem.l a1-6,-(a7)
        DLoad   a1
        move.l  GSC2PBase-MyBase(a1),d0
        beq     .dontbother
        move.l  d0,a6
        jsr     _LVOGSCleanupC2P(a6)
        movem.l (a7),a1-6
        DLoad   a1
        move.l  4,a6
        move.l  GSC2PBase-MyBase(a1),a1
        jsr     _LVOCloseLibrary(a6)
.dontbother
        movem.l (a7)+,a1-6
        rts

L_C2PGo equ 82
L82
        movem.l a1-6,-(a7)
        DLoad   a1
        move.l  GSC2PBase-MyBase(a1),d0
        beq     .dontbother
        move.l  d0,a6
        jsr     _LVOGSGoC2P(a6)

        move.l  d0,d3
        move.l  #0,d2

        movem.l (a7)+,a1-6
        rts

.dontbother
        move.l  #0,d3
        move.l  #0,d2

        movem.l (a7)+,a1-6
        rts

L_GSSetC2PPalette equ 83
L83
        DLoad   a1
        move.l  (a3)+,d0
        move.l  (a3)+,d1
        move.l  C2PInfo-MyBase(a1),d2
        beq     .nocolourmap
        move.l  d2,a0
        move.w  #-1,GSC2P_ColourMapDirty(a0)
        move.l  GSC2P_ColourMap(a0),d2
        beq     .nocolourmap
        move.l  d2,a0
        lsl.l   #2,d1
        move.l  d0,(a0,d1)
.nocolourmap
        rts

L_GSC2PSetRegion equ 84
L84
        DLoad   a0
        move.l  (a3)+,d0
        move.l  (a3)+,d1
        move.l  (a3)+,d2
        move.l  (a3)+,d3
        move.l  C2PInfo-MyBase(a0),d4
        beq     .dontbother
        move.l  d4,a0
        move.w  d3,GSC2P_LeftEdge(a0)
        move.w  d2,GSC2P_TopEdge(a0)
        move.w  d1,GSC2P_RightEdge(a0)
        move.w  d0,GSC2P_BottomEdge(a0)
.dontbother
        rts

L_GSGetC2PInfo equ 85
L85
        DLoad   a0
        move.l  C2PInfo-MyBase(a0),d3
        moveq   #0,d2
        rts

L_GSC2PDebug equ 86
L86
        DLoad   a0
        move.l  C2PInfo-MyBase(a0),a0
        not.w   GSC2P_DebugMode(a0)
        rts
L87
L88
L89

        include "subroutines/codemods.s"

L96

L_GSPyth equ 97
L97
        move.l  (a3)+,d0
        bpl     .dontneg0
        neg.l   d0
.dontneg0
        move.l  (a3)+,d1
        bpl     .dontneg1
        neg.l   d1
.dontneg1
        move.l  d0,d2
        add.l   d1,d2
        add.l   d1,d2
        muls    d1,d1
        muls    d0,d0
        add.l   d1,d0

        tst.l   d0
        beq     .done   ; to handle a parameter of zero
        lsr.l   #1,d2   ; approx starting point.
        ext.l   d2
        addq    #7,d2
        moveq   #6,d3
.loop
        move.l  d2,d1
        move.l  d0,d2
        divu    d1,d2
        ext.l   d2
        add.l   d1,d2
        lsr.l   #1,d2
        cmp.l   d1,d2
        beq     .done
        dbf     d3,.loop
.done
        move.l  d2,d3
        moveq   #0,d2

        rts

L_GSControllerType equ 98
L98
        move.l  a6,-(a7)
        DLoad   a2
        move.l  GSDriverPort0Base-MyBase(a2),d0
        beq     .error
        move.l  d0,a6
        jsr     _LVOGSReadCType(a6)
        move.l  d0,d3
        moveq   #0,d2
        move.l  (a7)+,a6
        rts
.error
        move.l  (a7)+,a6
        moveq   #0,d3
        moveq   #0,d2
        rts

L_GSReadSega equ 99
L99
        move.l  a6,-(a7)
        DLoad   a2
        move.l  GSDriverPort0Base-MyBase(a2),d0
        beq     .error
        move.l  d0,a6
        moveq   #0,d0
        jsr     _LVOGSReadButtons(a6)
        move.l  d0,d3
        move.l  #0,d2
        move.l  (a7)+,a6
        rts

.error
        move.l  (a7)+,a6
        move.l  #0,d3
        move.l  #0,d2
        rts

*********************************************************************
*       ERROR MESSAGES...
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

L_Custom        equ     100
L100    lea     ErrMess(pc),a0
        moveq   #0,d1                   * Can be trapped
        moveq   #ExtNb,d2               * Number of extension
        moveq   #0,d3                   * IMPORTANT!!!
        Rjmp    L_ErrorExt              * Jump to routine...
* Messages...
ErrMess dc.b    "lowlevel.library not available",0                      *0
        dc.b    "mouse speed must be between 0 and 32761",0             *1
        dc.b    "unknown GamePort (must be 0 or 1)",0                   *2
        dc.b    "workbench libraries not available",0                   *3
        dc.b    "can't iconify",0                                       *4
        dc.b    "not a tracker bank",0                                  *5
        dc.b    "too many code modules",0                               *6
        dc.b    "attribute not found",0                                 *7
        dc.b    "function not found",0                                  *8

* IMPORTANT! Always EVEN!
        even

******* "No errors" routine
; If you compile with -E0, the compiler will replace the previous
; routine by this one. This one just sets D3 to -1, and does not
; load messages in A0. Anyway, values in D1 and D2 must be valid.
;
; THIS ROUTINE MUST BE THE LAST ONE IN THE LIBRARY!
;

L101    moveq   #0,d1
        moveq   #ExtNb,d2
        moveq   #-1,d3
        Rjmp    L_ErrorExt

; Do not forget the last label to delimit the last library routine!
L102

; ---------------------------------------------------------------------
; Now the title of the extension, just the string.
;
; TITLE MESSAGE
C_Title dc.b    "AMOSPro GameSupport extension V "
        Version
        dc.b    0,"$VER: "
        Version
        dc.b    0
        Even
;
; Note : magic title!
; ~~~~~~~~~~~~~~~~~~~
; If your extension begins with "MAGIC***", AMOSPro will call the
; address located after the string (even of course!). You can do whatever
; you want to the editor screen (the current at the moment), but
; restore it.
; You also handle the user key press, and the PREVIOUS/NEXT/CANCEL
; selection, buy returning a number in D0:
;       D0=-1   Cancel
;       D0=0    Previous extension
;       D0=1    Next extension
; Example of magic title:
;       C_Title         dc.b    "MAGIC***"
;                       bra     Magic_Title


; END OF THE EXTENSION
C_End   dc.w    0
        even


