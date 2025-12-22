head	0.13;
access;
symbols;
locks
	MORB:0.13; strict;
comment	@# @;


0.13
date	98.02.13.13.24.59;	author MORB;	state Exp;
branches;
next	0.12;

0.12
date	98.02.13.13.15.55;	author MORB;	state Exp;
branches;
next	0.11;

0.11
date	97.12.14.19.59.38;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	97.11.03.20.45.26;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	97.10.01.15.42.44;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.10.01.15.09.15;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.09.11.21.42.31;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.09.09.00.09.42;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.08.26.15.18.48;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.25.23.20.06;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.24.17.59.14;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.34.16;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.26.32;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.32;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.13
log
@Correction numero de version de keymap.library
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Initialisation
* $Id: Init.s 0.12 1998/02/13 13:15:55 MORB Exp MORB $
*

Startup:
	 move.l    (AbsExecBase).w,a6
	 sub.l     a1,a1
	 CALL      FindTask
	 move.l    d0,a4
	 tst.l     pr_CLI(a4)
	 bne.s     _Init
	 lea       pr_MsgPort(a4),a0
	 CALL      WaitPort
	 lea       pr_MsgPort(a4),a0
	 CALL      GetMsg
	 move.l    d0,-(a7)
	 bsr.s     _Init
	 move.l    (AbsExecBase).w,a6
	 CALL      Forbid
	 move.l    (a7)+,a1
	 CALL      ReplyMsg
	 moveq     #0,d0
	 rts

_Init:
	 clr.l     pr_WindowPtr(a4)
	 move.l    (AbsExecBase).w,a6
	 lea       DosName(pc),a1
	 moveq     #39,d0
	 CALL      OpenLibrary
	 move.l    d0,Dos_Base
	 beq       CleanUp
	 lea       IntName(pc),a1
	 moveq     #39,d0
	 CALL      OpenLibrary
	 move.l    d0,Int_Base
	 beq       CleanUp
	 lea       GfxName,a1
	 moveq     #39,d0
	 CALL      OpenLibrary
	 move.l    d0,Gfx_Base
	 beq       CleanUp
	 lea       LowName,a1
	 moveq     #40,d0
	 CALL      OpenLibrary
	 move.l    d0,Low_Base
	 beq       CleanUp
	 lea       KeymapName,a1
	 moveq     #37,d0
	 CALL      OpenLibrary
	 move.l    d0,Keymap_Base
	 beq       CleanUp

	 bsr       _OOInit
	 tst.l     d0
	 beq       CleanUp

	 moveq     #0,d0
	 move.l    #512,d1
	 move.l    d1,d2
	 CALL      CreatePool
	 move.l    d0,_ObjMemPool
	 beq       CleanUp

	 move.l    Dos_Base,a6
	 moveq     #DOS_EXALLCONTROL,d1
	 CALL      AllocDosObject
	 move.l    d0,FRExallCtrl
	 beq       CleanUp

	 moveq     #DOS_FIB,d1
	 CALL      AllocDosObject
	 move.l    d0,FRFib
	 beq       CleanUp

	 move.l    Low_Base,a6
	 moveq     #0,d0
	 pea       TAG_DONE
	 pea       SJA_TYPE_MOUSE
	 pea       SJA_Type
	 move.l    a7,a1
	 CALL      SetJoyPortAttrsA
	 lea       12(a7),a7
	 tst.l     d0
	 ;beq.s     CleanUp

	 moveq     #0,d0
	 CALL      ReadJoyPort

	 moveq     #1,d0
	 pea       TAG_DONE
	 pea       SJA_TYPE_JOYSTK
	 pea       SJA_Type
	 move.l    a7,a1
	 CALL      SetJoyPortAttrsA
	 lea       12(a7),a7
	 tst.l     d0
	 beq       CleanUp

	 moveq     #1,d0
	 CALL      ReadJoyPort

	 ;lea       _KeyBoardInt,a0
	 ;sub.l     a1,a1
	 ;CALL      AddKBInt
	 ;move.l    d0,KBIHandle
	 ;beq       CleanUp

	 bsr       _InstallKBHandler

	 move.l    (AbsExecBase).w,a6

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem1
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap1

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem2
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap2

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem3
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap3

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,CBpMem
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_ClearBitmap

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem4
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap4

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem5
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap5

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,BpMem6
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_Bitmap6

	 move.l    #BufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,CBpMem2
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_ClearBitmap2

	 move.l    #GuiBufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,_GuiBpMem
	 beq       CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_GuiBitmap

	 move.l    #GuiSelBufferSize+8,d0
	 move.l    #MEMF_CHIP|MEMF_CLEAR,d1
	 CALL      AllocVec
	 move.l    d0,_GuiSelMem
	 beq.s     CleanUp
	 addq.l    #8,d0
	 and.l     #$fffffff8,d0
	 move.l    d0,_GuiSelBitmap

	 move.l    Gfx_Base,a6
	 CALL      OwnBlitter
	 move.l    gb_ActiView(a6),d7
	 sub.l     a1,a1
	 CALL      LoadView

	 move.l    (AbsExecBase).w,a6
	 ;CALL      Disable
	 CALL      SuperState
	 move.l    d0,_SStack
	 ;move.l    a7,_A7Save

	 bsr       _Main

Couic:
	 move.l    (AbsExecBase).w,a6
	 move.l    _SStack,d0
	 CALL      UserState
	 ;CALL      Enable

	 ;lea       _Main(pc),a5
	 ;CALL      Supervisor
	 move.l    Gfx_Base,a6
	 move.l    Int_Base,a1
	 lea       ib_ViewLord(a1),a1
	 CALL      LoadView
	 CALL      DisownBlitter
	 move.l    Int_Base,a6
	 CALL      RemakeDisplay
CleanUp:
	 move.l    (AbsExecBase).w,a6

	 move.l    _GuiSelMem,a1
	 CALL      FreeVec
	 move.l    _GuiBpMem,a1
	 CALL      FreeVec

	 move.l    CBpMem2(pc),a1
	 CALL      FreeVec
	 move.l    BpMem6(pc),a1
	 CALL      FreeVec
	 move.l    BpMem5(pc),a1
	 CALL      FreeVec
	 move.l    BpMem4(pc),a1
	 CALL      FreeVec

	 move.l    CBpMem(pc),a1
	 CALL      FreeVec
	 move.l    BpMem3(pc),a1
	 CALL      FreeVec
	 move.l    BpMem2(pc),a1
	 CALL      FreeVec
	 move.l    BpMem1(pc),a1
	 CALL      FreeVec

	 bsr       _RemoveKBHandler

	 ;move.l    Low_Base,a6
	 ;move.l    KBIHandle(pc),a1
	 ;CALL      RemKBInt

	 moveq     #0,d0
	 pea       TAG_DONE
	 pea       0
	 pea       SJA_Reinitialize
	 move.l    a7,a1
	 CALL      SetJoyPortAttrsA
	 lea       12(a7),a7

	 moveq     #1,d0
	 pea       TAG_DONE
	 pea       0
	 pea       SJA_Reinitialize
	 move.l    a7,a1
	 CALL      SetJoyPortAttrsA
	 lea       12(a7),a7

	 move.l    Dos_Base,d0
	 beq.s     .NoDos
	 move.l    d0,a6

	 move.l    FRFib,d2
	 beq.s     .NoFib
	 moveq     #DOS_FIB,d1
	 CALL      FreeDosObject
.NoFib:

	 move.l    FRExallCtrl,d2
	 beq.s     .NoDos
	 moveq     #DOS_EXALLCONTROL,d1
	 CALL      FreeDosObject
.NoDos:

	 move.l    (AbsExecBase).w,a6
	 move.l    _ObjMemPool(pc),d0
	 beq.s     .NoMemPool
	 move.l    d0,a0
	 CALL      DeletePool
.NoMemPool:

	 bsr       _OOCleanUp

	 move.l    Keymap_Base,a1
	 CALL      CloseLibrary
	 move.l    Low_Base,a1
	 CALL      CloseLibrary
	 move.l    Gfx_Base,a1
	 CALL      CloseLibrary
	 move.l    Int_Base,a1
	 CALL      CloseLibrary
	 move.l    Dos_Base,a1
	 CALL      CloseLibrary
	 moveq     #0,d0
	 rts
_SStack:
	 ds.l      1
Dos_Base:
	 ds.l      1
Int_Base:
	 ds.l      1
Gfx_Base:
	 ds.l      1
Low_Base:
	 ds.l      1
Keymap_Base:
	 ds.l      1
_ObjMemPool:
	 ds.l      1
FRExallCtrl:
	 ds.l      1
FRFib:
	 ds.l      1
KBIHandle:
	 ds.l      1
BpMem1:
	 ds.l      1
BpMem2:
	 ds.l      1
BpMem3:
	 ds.l      1
CBpMem:
	 ds.l      1
BpMem4:
	 ds.l      1
BpMem5:
	 ds.l      1
BpMem6:
	 ds.l      1
CBpMem2:
	 ds.l      1
DosName:
	 dc.b      "dos.library",0
IntName:
	 dc.b      "intuition.library",0
GfxName:
	 dc.b      "graphics.library",0
LowName:
	 dc.b      "lowlevel.library",0
KeymapName:
	 dc.b      "keymap.library",0
	 even
_Gna:
	 dc.l      -1
_Debug:
	 ds.l      2
_Debug2:
	 ds.l      2
@


0.12
log
@Modifs pour nouveau code clavier
@
text
@d6 1
a6 1
* $Id: Init.s 0.11 1997/12/14 19:59:38 MORB Exp MORB $
d53 1
a53 1
	 moveq     #39,d0
@


0.11
log
@Truc pour OO
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: Init.s 0.10 1997/11/03 20:45:26 MORB Exp MORB $
d52 5
d107 7
a113 5
	 lea       _KeyBoardInt,a0
	 sub.l     a1,a1
	 CALL      AddKBInt
	 move.l    d0,KBIHandle
	 beq       CleanUp
d262 5
a266 3
	 move.l    Low_Base,a6
	 move.l    KBIHandle(pc),a1
	 CALL      RemKBInt
d309 2
d331 2
d365 2
@


0.10
log
@COUIN peut maintenant être lancé depuis le WB
@
text
@d6 1
a6 1
* $Id: Init.s 0.9 1997/10/01 15:42:44 MORB Exp MORB $
d10 18
a27 16
         move.l    (AbsExecBase).w,a6
         sub.l     a1,a1
         CALL      FindTask
         move.l    d0,a4
         tst.l     pr_CLI(a4)
         bne.s     _Init
         lea       pr_MsgPort(a4),a0
         CALL      WaitPort
         lea       pr_MsgPort(a4),a0
         CALL      GetMsg
         move.l    d0,-(a7)
         bsr.s     _Init
         move.l    (a7)+,a1
         CALL      ReplyMsg
         moveq     #0,d0
         rts
d30 181
a210 176
         move.l    (AbsExecBase).w,a6
         lea       DosName(pc),a1
         moveq     #39,d0
         CALL      OpenLibrary
         move.l    d0,Dos_Base
         beq       CleanUp
         lea       IntName(pc),a1
         moveq     #39,d0
         CALL      OpenLibrary
         move.l    d0,Int_Base
         beq       CleanUp
         lea       GfxName,a1
         moveq     #39,d0
         CALL      OpenLibrary
         move.l    d0,Gfx_Base
         beq       CleanUp
         lea       LowName,a1
         moveq     #40,d0
         CALL      OpenLibrary
         move.l    d0,Low_Base
         beq       CleanUp

         moveq     #0,d0
         move.l    #512,d1
         move.l    d1,d2
         CALL      CreatePool
         move.l    d0,_ObjMemPool
         beq       CleanUp

         move.l    Dos_Base,a6
         moveq     #DOS_EXALLCONTROL,d1
         CALL      AllocDosObject
         move.l    d0,FRExallCtrl
         beq       CleanUp

         moveq     #DOS_FIB,d1
         CALL      AllocDosObject
         move.l    d0,FRFib
         beq       CleanUp

         move.l    Low_Base,a6
         moveq     #0,d0
         pea       TAG_DONE
         pea       SJA_TYPE_MOUSE
         pea       SJA_Type
         move.l    a7,a1
         CALL      SetJoyPortAttrsA
         lea       12(a7),a7
         tst.l     d0
         ;beq.s     CleanUp

         moveq     #0,d0
         CALL      ReadJoyPort

         moveq     #1,d0
         pea       TAG_DONE
         pea       SJA_TYPE_JOYSTK
         pea       SJA_Type
         move.l    a7,a1
         CALL      SetJoyPortAttrsA
         lea       12(a7),a7
         tst.l     d0
         beq       CleanUp

         moveq     #1,d0
         CALL      ReadJoyPort

         lea       _KeyBoardInt,a0
         sub.l     a1,a1
         CALL      AddKBInt
         move.l    d0,KBIHandle
         beq       CleanUp

         move.l    (AbsExecBase).w,a6

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem1
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap1

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem2
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap2

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem3
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap3

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,CBpMem
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_ClearBitmap

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem4
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap4

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem5
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap5

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,BpMem6
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_Bitmap6

         move.l    #BufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,CBpMem2
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_ClearBitmap2

         move.l    #GuiBufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,_GuiBpMem
         beq       CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_GuiBitmap

         move.l    #GuiSelBufferSize+8,d0
         move.l    #MEMF_CHIP|MEMF_CLEAR,d1
         CALL      AllocVec
         move.l    d0,_GuiSelMem
         beq.s     CleanUp
         addq.l    #8,d0
         and.l     #$fffffff8,d0
         move.l    d0,_GuiSelBitmap

         move.l    Gfx_Base,a6
         CALL      OwnBlitter
         move.l    gb_ActiView(a6),d7
         sub.l     a1,a1
         CALL      LoadView

         move.l    (AbsExecBase).w,a6
         ;CALL      Disable
         CALL      SuperState
         move.l    d0,_SStack
         ;move.l    a7,_A7Save
d212 1
a212 1
         bsr       _Main
d215 14
a228 14
         move.l    (AbsExecBase).w,a6
         move.l    _SStack,d0
         CALL      UserState
         ;CALL      Enable

         ;lea       _Main(pc),a5
         ;CALL      Supervisor
         move.l    Gfx_Base,a6
         move.l    Int_Base,a1
         lea       ib_ViewLord(a1),a1
         CALL      LoadView
         CALL      DisownBlitter
         move.l    Int_Base,a6
         CALL      RemakeDisplay
d230 1
a230 1
         move.l    (AbsExecBase).w,a6
d232 51
a282 51
         move.l    _GuiSelMem,a1
         CALL      FreeVec
         move.l    _GuiBpMem,a1
         CALL      FreeVec

         move.l    CBpMem2(pc),a1
         CALL      FreeVec
         move.l    BpMem6(pc),a1
         CALL      FreeVec
         move.l    BpMem5(pc),a1
         CALL      FreeVec
         move.l    BpMem4(pc),a1
         CALL      FreeVec

         move.l    CBpMem(pc),a1
         CALL      FreeVec
         move.l    BpMem3(pc),a1
         CALL      FreeVec
         move.l    BpMem2(pc),a1
         CALL      FreeVec
         move.l    BpMem1(pc),a1
         CALL      FreeVec

         move.l    Low_Base,a6
         move.l    KBIHandle(pc),a1
         CALL      RemKBInt

         moveq     #0,d0
         pea       TAG_DONE
         pea       0
         pea       SJA_Reinitialize
         move.l    a7,a1
         CALL      SetJoyPortAttrsA
         lea       12(a7),a7

         moveq     #1,d0
         pea       TAG_DONE
         pea       0
         pea       SJA_Reinitialize
         move.l    a7,a1
         CALL      SetJoyPortAttrsA
         lea       12(a7),a7

         move.l    Dos_Base,d0
         beq.s     .NoDos
         move.l    d0,a6

         move.l    FRFib,d2
         beq.s     .NoFib
         moveq     #DOS_FIB,d1
         CALL      FreeDosObject
d285 4
a288 4
         move.l    FRExallCtrl,d2
         beq.s     .NoDos
         moveq     #DOS_EXALLCONTROL,d1
         CALL      FreeDosObject
d291 19
a309 16
         move.l    (AbsExecBase).w,a6
         move.l    _ObjMemPool(pc),d0
         beq.s     .NoMemPool
         move.l    d0,a0
         CALL      DeletePool
.NoMemPool
         move.l    Low_Base,a1
         CALL      CloseLibrary
         move.l    Gfx_Base,a1
         CALL      CloseLibrary
         move.l    Int_Base,a1
         CALL      CloseLibrary
         move.l    Dos_Base,a1
         CALL      CloseLibrary
         moveq     #0,d0
         rts
d311 1
a311 1
         ds.l      1
d313 1
a313 1
         ds.l      1
d315 1
a315 1
         ds.l      1
d317 1
a317 1
         ds.l      1
d319 1
a319 1
         ds.l      1
d321 1
a321 1
         ds.l      1
d323 1
a323 1
         ds.l      1
d325 1
a325 1
         ds.l      1
d327 1
a327 1
         ds.l      1
d329 1
a329 1
         ds.l      1
d331 1
a331 1
         ds.l      1
d333 1
a333 1
         ds.l      1
d335 1
a335 1
         ds.l      1
d337 1
a337 1
         ds.l      1
d339 1
a339 1
         ds.l      1
d341 1
a341 1
         ds.l      1
d343 1
a343 1
         ds.l      1
d345 1
a345 1
         dc.b      "dos.library",0
d347 1
a347 1
         dc.b      "intuition.library",0
d349 1
a349 1
         dc.b      "graphics.library",0
d351 2
a352 2
         dc.b      "lowlevel.library",0
         even
d354 1
a354 1
         dc.l      -1
d356 1
a356 1
         ds.l      2
d358 1
a358 1
         ds.l      2
@


0.9
log
@Agrûnt bug corrigé. Agrûnt includu exall.i paf
@
text
@d6 1
a6 1
* $Id: Init.s 0.8 1997/10/01 15:09:15 MORB Exp MORB $
d9 18
d63 5
d271 7
d313 2
@


0.8
log
@Ajout de l'allocation de FRExallCtrl pour GuiSupport.s.
@
text
@d6 1
a6 1
* $Id: Init.s 0.7 1997/09/11 21:42:31 MORB Exp MORB $
d42 1
a42 1
         move.l    d1,FRExallCtrl
@


0.7
log
@Deux trois modifs pour l'iconification
@
text
@d6 1
a6 1
* $Id: Init.s 0.6 1997/09/09 00:09:42 MORB Exp MORB $
d39 6
d245 9
d281 2
@


0.6
log
@Alloc
@
text
@d6 1
a6 1
* $Id: Init.s 0.5 1997/08/26 15:18:48 MORB Exp MORB $
d15 1
a15 1
         beq.s     CleanUp
d20 1
a20 1
         beq.s     CleanUp
d25 1
a25 1
         beq.s     CleanUp
d30 1
a30 1
         beq.s     CleanUp
d37 1
a37 1
         beq.s     CleanUp
d61 1
a61 1
         beq.s     CleanUp
d70 1
a70 1
         beq.s     CleanUp
d78 1
a78 1
         beq.s     CleanUp
d87 1
a87 1
         beq.s     CleanUp
d96 1
a96 1
         beq.s     CleanUp
d105 1
a105 1
         beq.s     CleanUp
d114 1
a114 1
         beq.s     CleanUp
d123 1
a123 1
         beq.s     CleanUp
d132 1
a132 1
         beq.s     CleanUp
d141 1
a141 1
         beq.s     CleanUp
d150 1
a150 1
         beq.s     CleanUp
d165 1
d169 1
d171 15
a185 2
         lea       _Main(pc),a5
         CALL      Supervisor
d190 1
d255 2
@


0.5
log
@Ajout de l'allocation des bitplanes pour le sélecteur
@
text
@d6 1
a6 1
* $Id: Init.s 0.4 1997/08/25 23:20:06 MORB Exp MORB $
d32 8
a39 1
         move.l    d0,a6
d81 1
a81 1
         move.l    d0,_WorkBitmap
d90 55
a144 1
         move.l    d0,_DispBitmap
d185 13
d224 5
d247 2
d254 12
@


0.4
log
@Ajout de l'initialisation de l'interruption clavier
@
text
@d6 1
a6 1
* $Id: Init.s 0.3 1997/08/24 17:59:14 MORB Exp MORB $
a83 1
         move.l    d0,$8f00000
d94 9
d119 2
@


0.3
log
@Ajout de quelques trucs pour la souris
@
text
@d6 1
a6 1
* $Id: Init.s 0.2 1997/08/22 18:34:16 MORB Exp MORB $
d41 1
a41 1
         beq.s     CleanUp
d59 6
d120 11
d157 2
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d33 13
@


0.1
log
@Bloub
@
text
@d6 1
a6 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 2
@
