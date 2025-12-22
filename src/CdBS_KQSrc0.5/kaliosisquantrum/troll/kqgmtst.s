;$Id
;fs "Includes"
	incdir    "include:"
	include   "Libraries/GadTools_lib.i"
	include   "Libraries/GadTools.i"
	include   "exec/exec_lib.i"
	include   "exec/exec.i"
	include   "exec/memory.i"
	include   "devices/timer.i"
	include   "dos/dos_lib.i"
	include   "dos/dos.i"
	include   "dos/dosextens.i"
	include   "dos/dostags.i"
	include   "intuition/intuition_lib.i"
	include   "intuition/intuition.i"
	include   "intuition/screens.i"
	include   "graphics/graphics_lib.i"
	include   "graphics/rastport.i"
	include   "graphics/rpattr.i"
	include   "graphics/text.i"
	include   "graphics/layers_lib.i"

;fe
;fs "Equates"
exec_base EQU       4
TRUE      EQU       -1
FALSE     EQU       0
MaxX      EQU       256
MaxY      EQU       256
MaxY2     EQU       65536
K         EQU       512  ;2^9=512
	mc68040
;fe
;fs "Variables"
	rsreset
StackPointer        rs.l      1
PictWindowAddress   rs.l      1
MappedWindowAddress rs.l      1
PictWindowUserPort  rs.l      1
PictRastPort        rs.l      1
MappedRastPort      rs.l      1
ScreenAddress       rs.l      1
ScreenRastPort      rs.l      1
WBarHeight          rs.b      1
BorderTop           rs.b      1
BorderLeft          rs.b      1
LastMessage         rs.l      1
Y                   rs.l      3
Base                rs.l      1
Inc                 rs.l      1
SIZEOF_VARS         rs.b      0
;fe
;fs "Macros"
Call      macro
	IFGT      NARG-1
	Move.l    \2_base,a6
	ENDC
	Jsr       _LVO\1(a6)
	endm

OpenLib   macro     ;         OpenLib   name, rev, ?fail->
	Bra       \1_next
	IFND      \1_base
\1_base:  Ds.l      1
	ENDC
\1_name:  Dc.b      "\1.library",0
	Even
\1_next:  Lea       \1_name(pc),a1
	Moveq.l   \2,d0
	Call      OpenLibrary,exec
	Move.l    d0,\1_base
	Beq       \3
	endm

CloseLib  macro
	Move.l    \1_base(pc),a1
	Call      CloseLibrary,exec
	endm
;fe
;fs "chaine de version"
VERSION:  bra.s     Init
	Dc.b      "$VER: Ground Mapper for Kaliosys Quantrum 0.1 (06/12/97) ©1997, CdBS (Troll)"
	Even
;fe
;fs "Code"
;fs " Init"
Init:
	OpenLib   intuition,#39,LibError
	OpenLib   dos,#39,LibError
	OpenLib   gadtools,#39,LibError
	OpenLib   graphics,#39,LibError
	Call      OpenWorkBench,intuition
	Move.l    d0,a0
	Clr.l     d0
	Move.b    sc_BarHeight(a0),d0
	Move.b    d0,WBarHeight(a5)
	Move.l    #SIZEOF_VARS,d0
	Move.l    #MEMF_CLEAR,d1
	Call      AllocVec,exec
	Tst.l     d0
	Beq       MemError
	Move.l    d0,a5
	Move.l    a7,StackPointer(a5)
;fe
;fs " OpenScreen"
;OpenScreen:
;          Sub.l     a0,a0
;          Lea       ScreenTagList,a1
;          Call      OpenScreenTagList,intuition
;          Move.l    d0,a1
;          Move.l    d0,ScreenAddress(a5)
;          Move.l    86(a1),d5
;          Move.l    d5,ScreenRastPort(a5)
;          Move.l    d0,Win1Scr
;          Move.l    d0,Win2Scr
;fe
;fs " Openwindows"
OpenWindows:
	Sub.l     a0,a0
	Lea       PictWindowTagList,a1
	Call      OpenWindowTagList,intuition
	Tst.l     d0
	Beq       Win1Error
	Move.l    d0,a2
	Move.l    d0,PictWindowAddress(a5)
	Move.l    86(a2),d5
	Move.l    d5,PictWindowUserPort(a5)
	Move.l    50(a2),d5
	Move.l    d5,PictRastPort(a5)
	Move.b    54(a2),BorderTop(a5)
	Move.b    55(a2),BorderLeft(a5)
	Move.l    d5,a1
	Move.l    #1,d0
	Call      SetRast,graphics
	bsr       _FillWin1
	Sub.l     a0,a0
	Lea       MappedWindowTagList,a1
	Call      OpenWindowTagList,intuition
	Tst.l     d0
	Beq       Win2Error
	Move.l    d0,a2
	Move.l    d0,MappedWindowAddress(a5)
	Move.l    50(a2),MappedRastPort(a5)
	bsr       _MapWindow
Loop:
	bsr       Main
	Bra       Loop

;fe
;fs " Main"
Main:
	Movem.l   d0-7/a0-6,-(a7)
	Move.l    PictWindowUserPort(a5),a0
	Call      WaitPort,exec

EmptyPort:
	Move.l    PictWindowUserPort(a5),a0
	Call      GT_GetIMsg,gadtools
	move.l    d0,LastMessage(a5)
	Beq       Main
	Move.l    d0,a3
	Move.l    im_Class(a3),d0
	Cmp.l     #IDCMP_CLOSEWINDOW,d0
	Beq       CloseAll
	Cmp.l     #IDCMP_RAWKEY,d0
	Beq       CloseAll
	Cmp.l     #IDCMP_REFRESHWINDOW,d0
	Bne       ComeBack
	Move.l    PictWindowAddress(a5),a0
	Move.l    MappedWindowAddress(a5),a2
	Bra       RefreshWin
ComeBack:
	Move.l    LastMessage(a5),a1
	Call      GT_ReplyIMsg,gadtools
	Movem.l   (a7)+,d0-7/a0-6
	Rts


RefreshWin:
	Movem.l   d0/a0,-(a7)
	Move.l    a0,d7
	Call      GT_BeginRefresh,gadtools
	Move.l    d7,a0
	Move.l    #-1,d0
	Call      GT_EndRefresh,gadtools
	Move.l    a2,a0
	Call      GT_BeginRefresh
	Move.l    a2,a0
	Move.l    #-1,d0
	Call      GT_EndRefresh
	Movem.l   (a7)+,d0/a0
	Bra       Main
;fe
;fs " CloseAll"
CloseAll:
	Move.l    #0,d7
	Move.l    StackPointer(a5),a7
CloseW2:
	Move.l    MappedWindowAddress(a5),a0
	Call      CloseWindow,intuition
CloseW1:
.Loop:
	Move.l    PictWindowUserPort(a5),a0
	Call      GT_GetIMsg,gadtools
	Move.l    d0,a3
	Tst.l     a3
	Beq       .EndLoop
	Move.l    (a3),d0
	Move.l    a3,a1
	Call      GT_ReplyIMsg,gadtools
	Bra       .Loop
.EndLoop:
	Move.l    PictWindowAddress(a5),a0
	Call      CloseWindow,intuition
CloseScreen:
	Move.l    ScreenAddress(a5),a0
	Call      CloseScreen
UnAllocMem:
	Move.l    a5,a1
	Call      FreeVec,exec
CloseLibs:
	CloseLib  intuition
	CloseLib  gadtools
	CloseLib  dos
End:
	Move.l    d7,d0
	Rts
;fe
;fs " Errors"
LibError:
	Move.l    #10,d7
	Bra       End

Win1Error:
	Move.l    #11,d7
	Bra       UnAllocMem

Win2Error:
	Move.l    #12,d7
	Bra       CloseW1

MemError:
	Move.l    #13,d7
	Bra       CloseLibs
;fe
;fs "_MapWindow"
_MapWindow:
	Move.l    #MaxY,d3
	Move.l    PictRastPort(a5),a1
	Move.l    graphics_base,a6
.YLoop:
;          bsr       Main
	Move.l    #0,d2
	bsr       _CalcY
	bsr       _CalcBase
	bsr       _CalcInc
	Fmove.l   fp4,fp1
;          Fmod.l    #MaxX,fp1
	fabs      fp1

.XLoop:
	Move.l    PictRastPort(a5),a1
	Fmod.x    #MaxX,fp1
	Fmove.l   fp1,d0
	Move.l    Y(a5),d1
;          Move.l    d3,d1
	Call      ReadPixel
;          Cmp.l     #-1,d0
;          Beq       .End
	Move.l    MappedRastPort(a5),a1
	Call      SetAPen
	Move.l    d3,d1
	Move.l    d2,d0
	Call      WritePixel
;          Tst.l     d0
;          Bne       .End
	Fadd.x    fp3,fp1
	Addq.l    #1,d2
	cmp.l     #MaxX-1,d2
	Bne       .XLoop
	Sub.l     #1,d3
	cmp.l     1,d3
	Bne       .YLoop
.End:
	Rts
;fe
;fs "_CalcY"
_CalcY:                 ;d3=Yb -> d3=Yb Y(a5)=Ya
	FMove.l   d3,fp3
	FMove.x   #K,fp0
	Fadd.x    #MaxY,fp0
	Fmul.x    fp3,fp0
	Fsub.x    #MaxY2,fp0
	Fmove.x   #K,fp1
	Fsub.x    #MaxY,fp1
	FAdd.x    fp3,fp1
	Fdiv.x    fp1,fp0
	Fmove.l   fp0,d0
	Move.l    d0,Y(a5)
	Rts
;fe
;fs "_CalcBase"
_CalcBase:                              ;d3=Yb ->d3=Yb fp4=Base
	FMove.l   d3,fp3
	FMove.x   #MaxY,fp0
	FSub.x    fp3,fp0
	FAdd.x    #K,fp0
	FMove.x   #MaxX,fp2
	Fdiv.x    #2,fp2
	Fneg.x    fp2
	FMul.x    fp2,fp0
	FMove.x   #K,fp2
	Fdiv.x    fp2,fp0
	Fmove.x   #MaxX,fp1
	Fdiv.x    #2,fp1
	Fadd.x    fp1,fp0
	FMove.x   fp0,fp4
	Rts
;fe
;fs "_CalcInc"
_CalcInc:                     ;d3=Yb -> d3=Yb fp3=Inc
	FMove.l   d3,fp3
	fMove.x   #MaxY,fp0
	FSub.x    fp3,fp0
	FAdd.x    #K,fp0
	FMove.x   #K,fp2
	Fdiv.x    fp2,fp0
	FMove.x   fp0,fp3
	Rts
;fe
;fs "_FillWin1"
_FillWin1:
	Move.l    #MaxY,d3
	Move.l    PictRastPort(a5),a1
	Move.l    #32,d0
	Call      SetAPen,graphics
.LoopY:
	Move.l    PictRastPort(a5),a1
	Move.l    #0,d0
	Move.l    d3,d1
	Call      Move
	Move.l    #MaxX,d0
	Move.l    d3,d1
	Move.l    PictRastPort(a5),a1
	Call      Draw
	Sub.l     #8,d3
	Bne       .LoopY
	Move.l    #512,d3
.LoopX:
	Move.l    PictRastPort(a5),a1
	Move.l    #0,d1
	Move.l    d3,d0
	Call      Move
	Move.l    #MaxY,d1
	Move.l    d3,d0
	Move.l    PictRastPort(a5),a1
	Call      Draw
	Sub.l     #8,d3
	Bne      .LoopX
	Rts
;fe
;fe
;fs "Datas"
;fs " Windows Definition"
;fs "  PictWindow"
PictWindowTagList:
	Dc.l      WA_Width,MaxX+1
	Dc.l      WA_Height,MaxY+1
	Dc.l      WA_Left,20
	Dc.l      WA_Top,20
	Dc.l      WA_Title,PictWindowTitle
;          Dc.l      WA_CustomScreen
;Win1Scr:  Dc.l      0
	Dc.l      WA_ScreenTitle,ScreenTitle
	Dc.l      WA_CloseGadget,TRUE
	Dc.l      WA_Activate,TRUE
	Dc.l      WA_DragBar,TRUE
	Dc.l      WA_SizeGadget,FALSE
	Dc.l      WA_DepthGadget,TRUE
	Dc.l      WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|IDCMP_RAWKEY
	Dc.l      TAG_DONE

PictWindowTitle:
	Dc.b      "Picture to be mapped ...",0
	Even

ScreenTitle:
	Dc.b      "Kaliosys Quantrum Ground Mapper v0.1 by TROLL",0
	Even
;fe
;fs "  MappedWindow"
MappedWindowTagList:
	Dc.l      WA_Width,MaxX+1
	Dc.l      WA_Height,MaxY+1
	Dc.l      WA_Left,300
	Dc.l      WA_Top,20
	Dc.l      WA_Title,MappedWindowTitle
	Dc.l      WA_ScreenTitle,ScreenTitle
	Dc.l      WA_CustomScreen
;Win2Scr:  Dc.l      0
;          Dc.l      WA_CloseGadget,FALSE
	Dc.l      WA_Activate,TRUE
	Dc.l      WA_DragBar,TRUE
	Dc.l      WA_SizeGadget,FALSE
	Dc.l      WA_DepthGadget,TRUE
	Dc.l      TAG_DONE

MappedWindowTitle:
	Dc.b      "Mapped Picture ...",0
	Even
;fe
;fe
;fs " Screen Definition"
ScreenTagList:
	Dc.l      SA_LikeWorkbench,TRUE
	Dc.l      SA_ShowTitle,TRUE
	Dc.l      0

MainScreenTitle:
	Dc.b      "Exemple Pour Seb v0.1",0
;fe
;fs " Junk"
;fe
;fe
