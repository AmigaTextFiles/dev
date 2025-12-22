; Compile me to get full executable

    include    pubscreendemop1win.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
WaitPort                 EQU    -384
ItemAddress              EQU    -144
GT_BeginRefresh          EQU    -90
GT_EndRefresh            EQU    -96
CloseScreen              EQU    -66
PubScreenStatus          EQU    -552

Scr:
    dc.l    0
Gad:
    dc.l    0

start

    jsr     OpenLibs
    tst.l   d0
    bne     NoLibs
    jsr     OpenMyPubScrScreen
    tst.l   d0
    beq     NoScreen
    move.l  d0,Scr
    movea.l Scr,a0
    move.l  #0,d0
    movea.l _IntuitionBase,a6
    jsr     PubScreenStatus(a6)
    movea.l Scr,a1
    jsr     OpenScrWinWindow
    tst.l   d0
    bne     NoWindow
WaitHere:
    move.l  ScrWin,a1
    move.l  86(a1),a2
    move.l  a2,a0
    move.l  _SysBase,a6
    jsr     WaitPort(a6)
GetMessage:
    move.l  _GadToolsBase,a6
    move.l  ScrWin,a1
    move.l  86(a1),a2
    move.l  a2,a0
    jsr     GT_GetIMsg(a6)
    tst.l   d0
    beq     WaitHere
    move.l  d0,a1
    move.l  20(a1),d4
    move.l  #0,d5
    move.w  24(a1),d5
    move.l  28(a1),Gad
    move.l  _GadToolsBase,a6
    jsr     GT_ReplyIMsg(a6)
    
    
    cmpi.l  #$200,d4                      ; CloseWindow
    bne     NotCloseWindow
    
    jsr     CloseScrWinWindow
    movea.l Scr,a0
    movea.l _IntuitionBase,a6
    jsr     CloseScreen(a6)
    tst.l   d0
    beq     CloseScreenFailed
    move.l  #0,Scr
    jmp     NoScreen

CloseScreenFailed:                        ; attempt to reopen window
    movea.l Scr,a1
    jsr     OpenScrWinWindow
    tst.l   d0
    bne     NoWindow                      ; mega failure, say goodbye.

    jmp     MessageDone
NotCloseWindow:
    
    cmpi.l  #$40,d4                       ; GadgetUp
    bne     NotStateGadgetUp
    
    move.l  #0,d0
    movea.l  Gad,a0
    move.w  38(a0),d0
    cmp.w   #GD_State,d0
    bne     NotStateGadgetUp
    
    move.l  d5,d0
    tst.l   d0
    bne     PrivScreen
    movea.l Scr,a0
    move.l  #0,d0
    movea.l _IntuitionBase,a6
    jsr     PubScreenStatus(a6)
    jmp     MessageDone
PrivScreen:
    movea.l Scr,a0
    move.l  #1,d0
    movea.l _IntuitionBase,a6
    jsr     PubScreenStatus(a6)
    jmp     MessageDone
NotStateGadgetUp:
    
MessageDone:
    jmp     GetMessage
Done:
    jsr     CloseScrWinWindow
NoWindow:
    movea.l Scr,a0
    move.l  a0,d0
    tst.l   d0
    beq     NoScreen
    movea.l _IntuitionBase,a6
    jsr     CloseScreen(a6)
NoScreen:
    jsr     CloseLibs
NoLibs:
    rts

    end
