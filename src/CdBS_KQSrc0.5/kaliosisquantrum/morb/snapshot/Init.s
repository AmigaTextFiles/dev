*
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
