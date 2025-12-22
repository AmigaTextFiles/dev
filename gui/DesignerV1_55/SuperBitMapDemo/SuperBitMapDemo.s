; Compile me to get full executable

    include    superbitmapdemowin.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
WaitPort                 EQU    -384
ItemAddress              EQU    -144
GT_BeginRefresh          EQU    -90
GT_EndRefresh            EQU    -96
CloseScreen              EQU    -66
DrawBorder               EQU    -108

start

    jsr     OpenLibs
    tst.l   d0
    bne     NoLibs
    lea     PubScreenName,a1
    jsr     OpenSBWinWindow
    tst.l   d0
    bne     NoWindow
    
    move.l  #0,d0
    movea.l SBWin,a0
    move.b  54(a0),d0          ; get borleft
    ext.w   d0
    move.w  d0,borleft
    move.b  55(a0),d0          ; get bortop
    ext.w   d0
    move.w  d0,bortop

WaitHere:
    move.l  SBWin,a1
    move.l  86(a1),a2
    move.l  a2,a0
    move.l  _SysBase,a6
    jsr     WaitPort(a6)
GetMessage:
    move.l  SBWin,a1
    move.l  86(a1),a2
    move.l  a2,a0
    move.l  _GadToolsBase,a6
    jsr     GT_GetIMsg(a6)
    tst.l   d0
    beq     WaitHere
    move.l  d0,a1
    move.l  20(a1),d4
    move.l  #0,d5
    move.w  24(a1),d5          ; code in d5
    
    move.l  _GadToolsBase,a6
    jsr     GT_ReplyIMsg(a6)

    
    cmpi.l  #$200,d4           ; Close window
    beq     Done
    
    
    cmpi.l  #$40,d4            ; Palette message, if more than one gadget you must check gadget id
    bne     NotGadgetUp
    move.b  d5,myborderfrontpen
    jmp     GetMessage
NotGadgetUp:


    cmpi.l  #8,d4              ; mousebuttons
    bne     NotMouseButtons
    cmpi.w  #$E8,d5            ; selectup
    bne     NotSelectUp
    move.w  #0,drawing
    jmp     GetMessage
NotSelectUp:
    cmpi.w  #$68,d5            ; selectdown
    bne     NotSelectDown
    jsr     inbox
    tst.l   d0
    beq     NotSelectDown
    move.w  #1,drawing
    movea.l SBWin,a0
    move.w  14(a0),d0          ; get mousex
    move.w  borleft,d1
    sub.w   d1,d0
    move.w  d0,oldx
    move.w  12(a0),d0          ; get mousey
    move.w  bortop,d1
    sub.w   d1,d0
    move.w  d0,oldy
NotSelectDown:
    jmp     GetMessage
NotMouseButtons:
    
    
    cmpi.l  #$10,d4            ; mousemove
    bne     NotMouseMove
    move.w  drawing,d0
    tst.w   d0
    beq     GetMessage
    jsr     inbox
    tst.l   d0
    beq     NotInBox
    movea.l SBWin,a0
    move.w  14(a0),d0          ; get mousex
    move.w  borleft,d1
    sub.w   d1,d0
    move.w  d0,newx
    move.w  12(a0),d0          ; get mousey
    move.w  bortop,d1
    sub.w   d1,d0
    move.w  d0,newy    
    move.w  oldx,d0
    cmpi.w  #$FFFF,d0
    beq     SkipCallBorder
    movea.l _IntuitionBase,a6
    movea.l SBWin,a0
    movea.l 50(a0),a0
    lea.l   myborder,a1
    move.l  #0,d0
    move.l  #0,d1
    jsr     DrawBorder(a6)
SkipCallBorder:
    move.w  newx,d0
    move.w  d0,oldx
    move.w  newy,d0
    move.w  d0,oldy
    jmp     GetMessage
NotInBox:
    move.w  #$FFFF,oldx
    jmp     GetMessage
NotMouseMove:
    
    
    jmp     GetMessage
Done:
    move.l  SBWin,d0
    tst.l   d0
    beq     NoWindow
    jsr     CloseSBWinWindow
NoWindow:
    jsr     CloseLibs
NoLibs:
    rts


inbox:
    movea.l SBWin,a0
    move.w  14(a0),d0          ; get mousex
    move.w  borleft,d1
    sub.w   d1,d0
    move.w  d0,newx
    move.w  12(a0),d0          ; get mousey
    move.w  bortop,d1
    sub.w   d1,d0
    move.w  d0,newy    
    
    move.w  newx,d0
    sub.w   #276,d0
    bpl     outbox
    
    move.w  newx,d0
    sub.w   #8,d0
    bmi     outbox
    
    move.w  newy,d0
    sub.w   #146,d0
    bpl     outbox
    
    move.w  newy,d0
    sub.w   #39,d0
    bmi     outbox
    
    move.l  #1,d0
inboxdone:
    rts
outbox:
    move.l  #0,d0
    jmp     inboxdone

myborder:
    dc.w    0,0
myborderfrontpen:
    dc.b    1,0,1,2
    dc.l    oldx
    dc.l    0
oldx:
    dc.w    65535
oldy:
    dc.w    65535
newx:
    dc.w    0
newy:
    dc.w    0
bortop:
    dc.w    0
borleft     
    dc.w    0
drawing:
    dc.w    0
PubScreenName:
    dc.b    'DesignerDemoPubScreen',0

    end
