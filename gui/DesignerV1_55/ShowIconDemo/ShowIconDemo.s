; Compile me to get full executable

    include    showicondemowin.i

GT_ReplyIMsg             EQU    -78
GT_GetIMsg               EQU    -72
Wait                     EQU    -318
GetMsg                   EQU    -372
ReplyMsg                 EQU    -378
CreateMsgPort            EQU    -666
DeleteMsgPort            EQU    -672
PutStr                   EQU    -948
NameFromLock             EQU    -402

start

    jsr     OpenLibs
    tst.l   d0
    bne     NoLibs
    movea.l _SysBase,a6
    jsr     CreateMsgPort(a6)
    move.l  d0,AppMsgPort
    tst.l   d0
    beq     NoAppMsgPort
    movea.l AppMsgPort,a2
    movea.l #1,a3
    jsr     OpenWin0Window
    tst.l   d0
    bne     NoWindow

    move.l  #0,d0
    movea.l AppMsgPort,a0
    move.b  15(a0),d0
    bset    d0,Signals
    
    move.l  #0,d0
    move.l  #0,d1
    movea.l Win0,a0
    movea.l 86(a0),a0
    move.b  15(a0),d1
    bset    d1,d0
    add.l   d0,Signals

WaitHere:
    
    move.l  Signals,d0
    move.l  _SysBase,a6
    jsr     Wait(a6)

GetNextIMsg:
    move.l  _GadToolsBase,a6
    movea.l Win0,a0
    movea.l 86(a0),a0
    jsr     GT_GetIMsg(a6)
    tst.l   d0
    beq     NoMoreGTMsgs
    movea.l d0,a1
    move.l  20(a1),d4
    jsr     GT_ReplyIMsg(a6)

    cmpi.l  #$200,d4
    beq     Done
    jmp     GetNextIMsg

NoMoreGTMsgs:
GetNextAppMsg:
    movea.l _SysBase,a6
    movea.l AppMsgPort,a0
    jsr     GetMsg(a6)
    tst.l   d0
    beq     GotAllAppMsgs
    
    move.l  d0,a3
    
    movea.l _DOSBase,a6
    
    lea     DirStr,a0
    move.l  a0,d1
    jsr     PutStr(a6)
    
    move.l  34(a3),a0
    move.l  (a0),d1
    lea     Buffer,a0
    move.l  a0,d2
    move.l  #250,d3
    jsr     NameFromLock(a6)
    lea     Buffer,a0
    move.l  a0,d1
    jsr     PutStr(a6)
    
    lea     EOL,a0
    move.l  a0,d1
    jsr     PutStr(a6)
    
    lea     FileStr,a0
    move.l  a0,d1
    jsr     PutStr(a6)
    
    move.l  34(a3),a0
    move.l  4(a0),d1
    jsr     PutStr(a6)
    
    lea     EOL,a0
    move.l  a0,d1
    jsr     PutStr(a6)
    
    
    movea.l a3,a1
    movea.l _SysBase,a6
    jsr     ReplyMsg(a6)
    
    jmp     GetNextAppMsg
GotAllAppMsgs:

    jmp     WaitHere
Done:
    jsr     CloseWin0Window
NoWindow:
    movea.l _SysBase,a6
ClearNextMsg:
    movea.l AppMsgPort,a0
    jsr     GetMsg(a6)
    tst.l   d0
    beq     ClearedMsgPort
    movea.l d0,a1
    jsr     ReplyMsg(a6)
    bra.s   ClearNextMsg
ClearedMsgPort:
    movea.l AppMsgPort,a0
    jsr     DeleteMsgPort(a6)
NoAppMsgPort:
    jsr     CloseLibs
NoLibs:
    rts

AppMsgPort:
    dc.l    0
Signals:
    dc.l    0
DirStr:
    dc.b    'Dir =  ',0
FileStr:
    dc.b    'File = ',0
EOL:
    dc.b    10,0
Buffer:
    ds.b    250
    
    end
