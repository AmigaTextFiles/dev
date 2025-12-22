;
; Comm v1.00. Written by S.Klemola at 24.7.
;
; (C)1993 SH-Ware, Inc. All Rights Reserved.
;

      include "Macros"
      include "exec/execbase.i"
      include "libraries/commodities.i"

Error MACRO * errnum
      moveq #\1,d0
      bra Err
      ENDM

ELib MACRO * routinename
      xref _LVO\1
      movea.l d6,a6
      jsr _LVO\1(a6)
      ENDM

SLib MACRO * routinename
      xref _LVO\1
      movea.l d7,a6
      jsr _LVO\1(a6)
      ENDM

      movea.l 4,a6
      lea NewBr(pc),a2
      lea CxPrt(pc),a3
      move.l ThisTask(a6),MP_SIGTASK(a3)
      moveq #-1,d0
      Lib AllocSignal
      move.b d0,MP_SIGBIT(a3)
      movea.l a3,a1
      Lib AddPort
      move.l a6,d6
      OpenLib sh,d7
      beq CJmp1
      movea.l d7,a6
      lea MP_MSGLIST(a3),a0
      Lib InitList
      movea.l d6,a6
      OpenLib comm,a6,36
      move.l a6,d5
      bne Jump1
      Error 0

Jump1 movea.l a2,a0
      clr.l d0
      Lib CxBroker		;Create broker
      move.l d0,d4
      beq ClnUp

      lea Filts(pc),a0		;Create filter object
      suba.l a1,a1
      moveq #CX_FILTER,d0
      Lib CreateCxObj
      move.l d0,d3

      movea.l d4,a0		;Broker as headobj
      movea.l d0,a1
      Lib AttachCxObj

      movea.l a3,a0		;Create send object
      suba.l a1,a1		;a3=Port
      moveq #CX_SEND,d0
      Lib CreateCxObj

      movea.l d3,a0		;Previous obj as headobj
      move.l d0,d3
      movea.l d0,a1
      Lib AttachCxObj

      suba.l a0,a0		;Create translate object
      suba.l a1,a1
      moveq #CX_TRANSLATE,d0
      Lib CreateCxObj

      movea.l d3,a0
      movea.l d0,a1
      Lib AttachCxObj

      movea.l d4,a0		;Activate Broker
      moveq #1,d0
      Lib ActivateCxObj
      movea.l d7,a6
      Print Inits

Main  movea.l d6,a6		;Wait for messages
      movea.l a3,a0
      Lib WaitPort

      movea.l a3,a0
      Lib GetMsg		;Get message
      movea.l d0,a4

      movea.l d5,a6
      movea.l a4,a0
      Lib CxMsgType		;What type of message is it?
      move.l d0,d2

      movea.l a4,a0
      Lib CxMsgID		;What are we told to do?
      move.l d0,d3

      movea.l a4,a1
      Lib ReplyMsg,d6		;Give a polite answer

      movea.l d7,a6
      cmpi.l #CXM_COMMAND,d2	;d2 = Message type
      beq Jump3
Jump2 Print Text1                   ; APPEAR
      bra Main
Jump3 cmpi.l #CXCMD_APPEAR,d3	;d3 = Command given
      beq Jump2
      cmpi.l #CXCMD_DISAPPEAR,d3
      bne Jump4
      Print Text2                   ; DISAPPEAR
      bra Main
Jump4 cmpi.l #CXCMD_KILL,d3
      beq Jump5
      cmpi.l #CXCMD_UNIQUE,d3
      bne Jump6
Jump5 Print Text3                   ; KILL
      bra ClnUp
Jump6 cmpi.l #CXCMD_ENABLE,d3
      bne Jump7

      movea.l d4,a0                 ; ENABLE
      moveq #1,d0
      Lib ActivateCxObj,d5
      movea.l d7,a6
      Print Text5
      bra Main
Jump7 cmpi.l #CXCMD_DISABLE,d3
      bne Jump8

      movea.l d4,a0                 ; DISABLE
      clr.l d0
      Lib ActivateCxObj,d5
      movea.l d7,a6
      Print Text6
      bra Main

Jump8 Print Text4		;Unknown command
      bra Main

ClnUp tst.l d4
      beq CJmp2
      movea.l d4,a0
      Lib DeleteCxObjAll,d5
CJmp2 movea.l d6,a6
      tst.l d5
      beq CJmp1
      CloseLib d5
CJmp1 movea.l a3,a1
      Lib RemPort
      clr.l d0
      move.b MP_SIGBIT(a3),d0
      Lib FreeSignal
      clr.l d0
      rts

Err   lea Alert(pc),a0
      lea Errst(pc),a1
      lsl.l #2,d0
      movea.l 0(a1,d0),a1
      clr.l d0
      SLib ShowAlert
      bra ClnUp

NewBr dc.b NB_VERSION,0
      dc.l Name,Title,Descr
      dc.w NBU_UNIQUE!NBU_NOTIFY,COF_SHOW_HIDE
      dc.b 0,0
      dc.l CxPrt
      dc.w 0

CxPrt dc.l 0,0
      dc.b NT_MSGPORT,0
      dc.l PName
      dc.b PA_SIGNAL,0
      ds.l 4
      dc.b NT_MESSAGE,0

Errst dc.l  Errs1

Alert dc.b 'Comm Failed',0

Errs1 dc.b 'Unable to open commodities.library',0

sh    dc.b 'sh.library',0
comm  dc.b 'commodities.library',0

Name  dc.b 'Comm',0
Title dc.b 'Comm v1.0 by S.Klemola',0
Descr dc.b 'Commodities example',0

PName dc.b 'Comm CX Port',0

Filts dc.b 'lcommand lshift help',0

Inits dc.b 'Comm installed.',10,0

Text1 dc.b 'ACTIVATION',10,0
Text2 dc.b 'DEACTIVATION',10,0
Text3 dc.b 'GOOD BYE',10,0
Text4 dc.b 'UNKNOWN COMMAND',10,0
Text5 dc.b 'ENABLED',10,0
Text6 dc.b 'DISABLED',10,0

