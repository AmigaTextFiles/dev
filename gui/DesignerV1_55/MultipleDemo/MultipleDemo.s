; Compile me to get full executable

    include    multipledemoasm.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
WaitPort                 EQU    -384
ItemAddress              EQU    -144
GT_BeginRefresh          EQU    -90
GT_EndRefresh            EQU    -96
CloseScreen              EQU    -66
CreateMsgPort            EQU    -666
DeleteMsgPort            EQU    -672
AllocVec                 EQU    -684
FreeVec                  EQU    -690
AddTail                  EQU    -246
RemHead                  EQU    -258
Remove                   EQU    -252
GT_SetGadgetAttrs        EQU    -42
FreeMenus                EQU    -54

start

    jsr     OpenLibs
    tst.l   d0
    bne     NoLibs
    jsr     OpenDiskFonts
    movea.l _SysBase,a6
    jsr     CreateMsgPort(a6)
    tst.l   d0
    beq     NoMsgPort
    move.l  d0,MsgPort
    jsr     OpenOne
    tst.l   d0
    bne     NoWindow
WaitHere:
    move.l  MsgPort,a0
    move.l  _SysBase,a6
    jsr     WaitPort(a6)
GetMessage:
    move.l  MsgPort,a0
    move.l  _GadToolsBase,a6
    jsr     GT_GetIMsg(a6)
    tst.l   d0
    beq     WaitHere
    move.l  d0,a1
    move.l  20(a1),d2
    move.w  24(a1),d3
    move.l  28(a1),a4
    move.l  20(a1),d4
    move.l  44(a1),a3
    
    move.l  _GadToolsBase,a6
    jsr     GT_ReplyIMsg(a6)

    move.l  d2,d0
    move.w  d3,d1
    move.l  a4,a0
    
    jsr     ProcessWindow
    
    cmpi.l  #0,SizeOfList
    beq     Done
    
    jmp     GetMessage

Done:
    movea.l CommonMenu,a0
    move.l  a0,d0
    tst.l   d0
    beq     NoWindow
    movea.l _GadToolsBase,a6
    jsr     FreeMenus(a6)
NoWindow:
    movea.l MsgPort,a0
    movea.l _SysBase,a6
    jsr     DeleteMsgPort(a6)
NoMsgPort:
    jsr     CloseLibs
NoLibs:
    rts


CommonMenuSubItemNumber:
    dc.w    0
CommonMenuItemNumber:
    dc.w    0
CommonMenuItem:
    dc.l    0

ProcessMenuIDCMPCommonMenu:
    movem.l d1-d4/a0-a4/a6,-(sp)
CommonMenuHandleLoop:
    move.l  #0,d5
    move.w  d0,d5
    move.l  d5,d0
    movea.l CommonMenu,a0
    movea.l _IntuitionBase,a6
    jsr     ItemAddress(a6)
    move.l  d0,CommonMenuItem
    tst.l   d0
    beq     CommonMenuFinished
    move.l  d5,d0
    lsr     #5,d0
    lsr     #6,d0
    and.w   #31,d0
    move.w  d0,CommonMenuSubItemNumber
    move.w  d5,d0
    lsr     #5,d0
    and.w   #63,d0
    move.w  d0,CommonMenuItemNumber
    move.w  d5,d0
    and.w   #31,d0
    cmp.w   #31,d0
    bne     NoCommonMenuMenu
    jmp     CommonMenuItemDone
NoCommonMenuMenu:
    cmp.w   #CommonMenu_Options,d0
    bne     NotCommonMenu_Options
    move.w  CommonMenuItemNumber,d0
    cmp.w   #CommonMenu_Options_Item0,d0
    bne     NotCommonMenu_Options_Item0

MenuOneLoop:              ; Must be at least one so this is safe
    movea.l Head,a0
    movea.l (a0),a0    
    move.l  (a0),d0
    tst.l   d0
    beq     MenuOneDone
    jsr     CloseOne
    jmp     MenuOneLoop
MenuOneDone:
    
    jmp     CommonMenuItemDone
NotCommonMenu_Options_Item0:
    cmp.w   #CommonMenu_Options_Item2,d0
    bne     NotCommonMenu_Options_Item2
    
MenuQuitLoop:
    movea.l Head,a0
    move.l  (a0),d0
    tst.l   d0
    beq     MenuQuitDone
    jsr     CloseOne
    jmp     MenuQuitLoop
MenuQuitDone:

    jmp     CommonMenuItemDone
NotCommonMenu_Options_Item2:
    jmp     CommonMenuItemDone
NotCommonMenu_Options:

CommonMenuItemDone:

    movea.l CommonMenuItem,a0
    move.w  32(a0),d0
    jmp     CommonMenuHandleLoop

CommonMenuFinished:
    movem.l (sp)+,d1-d4/a0-a4/a6
    rts

ProcessWindow:                       ; a3 =  idcmp_window
    movem.l d1-d4/a0-a6,-(sp)
    move.l  120(a3),a2               ; node in a2
    cmp.l   #$40,d0
    bne     NotGADGETUP
    move.w  38(a0),d0
    cmp.w   #GD_CommonWin_Gad0,d0
    bne     NotCommonWin_Gad0Up
    jsr     OpenOne
    jmp     winDoneMessage
NotCommonWin_Gad0Up:
    cmp.w   #GD_CommonWin_Gad1,d0
    bne     NotCommonWin_Gad1Up
    jsr     OpenOne
    jsr     OpenOne
    jsr     OpenOne
    jsr     OpenOne
    jsr     OpenOne
    jmp     winDoneMessage
NotCommonWin_Gad1Up:
    jmp     winDoneMessage
NotGADGETUP:
    cmp.l   #$200,d0
    bne     NotCLOSEWINDOW
    movea.l a2,a0
    jsr     CloseOne
    jmp     winDoneMessage
NotCLOSEWINDOW:
    cmp.l   #$100,d0
    bne     NotMENUPICK
    move.l  d1,d0
    jsr     ProcessMenuIDCMPCommonMenu
    jmp     winDoneMessage
NotMENUPICK:
    cmp.l   #4,d0
    bne     NotREFRESHWINDOW
    movea.l 8(a2),a0
    movea.l _GadToolsBase,a6
    jsr     GT_BeginRefresh(a6)
    move.l  #1,d0
    movea.l 8(a2),a0
    jsr     GT_EndRefresh(a6)
    jmp     winDoneMessage
NotREFRESHWINDOW:
winDoneMessage:
    movem.l (sp)+,d1-d4/a0-a6
    rts
    
OpenOne:
    move.l  #28,d0
    move.l  #0,d1
    movea.l _SysBase,a6
    jsr     AllocVec(a6)
    tst.l   d0
    beq     CouldNotAllocNode
    movea.l d0,a4
    movea.l MsgPort,a0
    move.l  #0,WinNode
    move.l  #0,WinNodeGList
    move.l  #0,WinNodeVisualInfo
    jsr     OpenWinNodeWindow
    tst.l   d0
    bne     OpenOneNoWindow
    movea.l WinNode,a1
    move.l  a4,120(a1)
    move.l  WinNode,8(a4)
    move.l  WinNodeGList,12(a4)
    move.l  WinNodeVisualInfo,16(a4)
    move.l  WinNodeDrawInfo,24(a4)
    lea.l   WinNodeGadgets,a0
    move.l  #CommonWin_Gad2,d0
    mulu    #4,d0
    adda.l  d0,a0
    move.l  (a0),20(a4)
    lea.l   List,a0
    movea.l a4,a1
    movea.l _SysBase,a6
    jsr     AddTail(a6)
    add.l   #1,SizeOfList
    jsr     NumberWindows
    move.l  #0,d0
OpenOneDone:
    rts    
OpenOneNoWindow:
    movea.l a4,a1
    movea.l _SysBase,a6
    jsr     FreeVec
CouldNotAllocNode:
    move.l  #1,d0
    jmp     OpenOneDone
    
CloseOne:            ; WindowNode in a0
    movea.l a0,a1
    movea.l a1,a4
    movea.l _SysBase,a6
    jsr     Remove(a6) 
    sub.l   #1,SizeOfList
    move.l  8(a4),WinNode
    move.l  12(a4),WinNodeGList
    move.l  16(a4),WinNodeVisualInfo
    move.l  24(a4),WinNodeDrawInfo
    jsr     CloseWinNodeWindow
    move.l  a4,a1
    jsr     FreeVec(a6)
    jsr     NumberWindows
    rts

NumberWindows:
    move.l  #0,d3
    movea.l Head,a4
NumberLoop:
    movea.l (a4),a5
    move.l  a5,d0
    tst.l   d0
    beq     NumberDone
    move.l  d3,tags+4
    movea.l 8(a4),a1
    movea.l 20(a4),a0
    movea.l #0,a2
    lea     tags,a3
    movea.l _GadToolsBase,a6
    jsr     GT_SetGadgetAttrs(a6)
    movea.l a5,a4
    add.l   #1,d3
    jmp     NumberLoop
NumberDone:
    rts

tags:
    dc.l    $8008000D,0,0           ;GTNM_Number

List:
Head:
    dc.l    Tail
Tail:
    dc.l    0,Head
    
SizeOfList:
    dc.l    0

MsgPort:
    dc.l    0

; Node:
;  Succ
;  Pred
;  Win
;  GList
;  VisualInfo
;  TextGadget
;  DrawInfo

    end
