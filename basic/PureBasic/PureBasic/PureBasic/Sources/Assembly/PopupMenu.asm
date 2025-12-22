; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU Lesser General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
; Place - Suite 330, Boston, MA 02111-1307, USA, or go to
; http://www.gnu.org/copyleft/lesser.txt.
;
; Note: As PureBasic is a compiler, the programs created with PureBasic are not
; covered by the LGPL license, but are fully free, license free and royality free
; software.
;
; --------------------------------------------------------------------------------------
;  04/09/2005
;    -Doobrey- Added save/restore regs to API style
;              Removed hardcoded address offsets to subroutines in libbase 
;              (Phxass optimiser could cause big problems if the offsets changed!)

;Version 1.00
 INCLUDE "PopupMenu.i"
 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"


LibraryName = l_LibraryName - LibBase
Objects     = l_Objects     - LibBase
NbObjects   = l_NbObjects   - LibBase
PopupBase   = l_PopupBase   - LibBase
TagList     = l_TagList     - LibBase
PopupMenu   = l_PopupMenu   - LibBase
SubMenu     = l_SubMenu     - LibBase
Error       = l_Error       - LibBase
IMessage    = l_IMessage    - LibBase          

Sub_1 = l_Sub_1 - LibBase
Sub_2 = l_Sub_2 - LibBase
Sub_3 = l_Sub_3 - LibBase

 initlib "PopupMenu", "PopupMenu", "FreePopupMenus", 0, 1, 0

;------------------------------------------------------------------------------------------
;regs d2,d3,d4, a2,a5,a6
 
 name      "FreePopupMenus", "()"
 flags     ; No returnvalue.
 amigalibs _ExecBase,d4
 params
 debugger  1

.PB_FreePopupMenus
  MOVEM.l  d2-d4/a2/a5-a6,-(a7) ; Save registers
  MOVE.l   Objects(a5),d3       ; get Objects
  BEQ.w    quit0                ; ...

  MOVE.w   NbObjects(a5),d2     ; get NbObjects
  MOVE.l   d3,a2                ; ...
  MOVE.l   PopupBase(a5),d0     ; get PopupBase
  BEQ.w    l1                   ; ...

  MOVE.l   d0,a6                ; use PopupBase

loop0
  MOVE.l   (a2),d0              ; ...
  BEQ.w    l0                   ; ...

  MOVE.l   d0,a1                ; arg1.
  JSR     _PM_FreePopupMenu(a6) ; (menu) - a1

l0
  ADD.l    #16,a2               ; ...
  DBRA     d2,loop0             ; ...

l1
  MOVE.l   d4,a6                ; use execbase

  MOVE.l   PopupBase(a5),d0     ; ...
  BEQ.w    l2                   ; ...

  MOVE.l   d0,a1                ; arg1.
  JSR     _CloseLibrary(a6)     ; (library) - a1

l2
  MOVE.l   d3,a1                ; arg1.
  JSR     _FreeVec(a6)          ; (memptr) - a1
  MOVEM.l  (a7)+,d2-d4/a2/a5-a6 ; Save registers
quit0
  RTS

 endfunc 1

;------------------------------------------------------------------------------------------

 name      "InitPopupMenu", "(#Menus.l)"
 flags     LongResult ; Return PopupMenuBase
 amigalibs _ExecBase,a6
 params    d0_l
 debugger  2,Error1

.PB_InitPopupMenu
  MOVEM.l  d6-d7/a5,-(a7)       ; Save registers
  MOVE.w   d0,d7                ; save NbObjects

  ADDQ.w   #1,d0                ; atleast one object
  LSL.w    #4,d0                ; calculate needed mem

  MOVE.l   d0,d6                ; save size of Objects
  MOVEQ    #108,d1              ; size of taglist & imsg
  ADD.l    d1,d0                ; add Objects, taglist & imsg size

  MOVEQ    #1,d1                ; } ...
  SWAP     d1                   ; } arg2.
  JSR     _AllocVec(a6)         ; (size,requirement) - d0/d1
  MOVE.l   d0,Objects(a5)       ; set Objects
  BEQ      quit10               ; if no mem then quit

  ADD.l    d0,d6                ; add ptr & size to get taglist
  MOVE.w   d7,NbObjects(a5)     ; set NbObjects

  LEA      LibraryName(a5),a1   ; arg1.
  MOVEQ    #9,d0                ; arg2.
  JSR     _OpenLibrary(a6)      ; (libname,version) - a1/d0
  MOVE.l   d0,PopupBase(a5)     ; set PopupBase

  MOVE.l   d6,TagList(a5)       ; set taglist
  MOVEQ    #80,d1               ; size of taglist
  ADD.l    d1,d6                ; calc ptr to imsg
  MOVE.l   d6,IMessage(a5)      ; set imsg
quit10
  MOVEM.l  (a7)+,d6-d7/a5       ; Restore registers
  RTS

 endfunc 2

;------------------------------------------------------------------------------------------

 name      "PopupMenuTitle", "(Text$)"
 flags     LongResult ; Return PopupMenu
 amigalibs
 params    d0_l
 debugger  3,Error2

.PB_PopupMenuTitle
  MOVEM.l d2-d4/d6-d7/a5-a6,-(a7) ; Save registers
  JSR     Sub_1(a5)             ; Sub_1

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Title
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_NoSelect,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_NoSelect
  MOVEM.l d2-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1
  MOVE.l  d0,d6                 ; ...

  MOVE.l  d7,a0                 ; ...

  MOVE.b  #PM_WideTitleBar,d2   ; ...
  MOVE.l  d2,(a0)+              ; set #PM_WideTitleBar
  MOVEM.l d2-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  d7,a0                 ; ...

  MOVE.b  #PM_Item,d2           ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d6,(a0)+              ; set Tag data
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d0,(a0)+              ; set Tag data
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeMenuA(a6)      ; (taglist) - a1

  MOVE.l  d0,PopupMenu(a5)      ; set popupmenu
  MOVEM.l (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 3

;------------------------------------------------------------------------------------------

 name      "PopupMenuItem", "(Item.w,Text$,ShortCut$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_w,d1_l,a0_l
 debugger  4,Error3

.PB_PopupMenuItem
  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7) ; Save registers
  JSR     Sub_2(a5)                ; Sub_2

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d1,(a0)+              ; set Tag data

  MOVE.b  #PM_UserData,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_UserData
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_ID,d2             ; ...
  MOVE.l  d2,(a0)+              ; set #PM_ID
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_CommKey,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_CommKey
  MOVE.l  d6,(a0)+              ; set Tag data
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  PopupMenu(a5),d1      ; get popupmenu
  JSR     Sub_3(a5)             ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 4

;------------------------------------------------------------------------------------------

 name      "PopupMenuCheckItem", "(Item.w,Text$,ShortCut$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_w,d1_l,a0_l
 debugger  5,Error3

.PB_PopupMenuCheckItem

  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7) ; Save registers
  JSR     Sub_2(a5)                ; Sub_2

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d1,(a0)+              ; set Tag data

  MOVE.b  #PM_UserData,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_UserData
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_ID,d2             ; ...
  MOVE.l  d2,(a0)+              ; set #PM_ID
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_CommKey,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_CommKey
  MOVE.l  d6,(a0)+              ; set Tag data

  MOVE.b  #PM_Checkit,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Checkit
  MOVE.l  d0,(a0)+              ; set Tag data <<<<
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  PopupMenu(a5),d1      ; get popupmenu
  JSR     Sub_3(a5)             ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 5

;------------------------------------------------------------------------------------------

 name      "PopupMenuInfo", "(Text$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_l
 debugger  6,Error3

.PB_PopupMenuInfoItem
  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7)  ; Save registers
  JSR     Sub_1(a5)                ; Sub_1

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Title
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_NoSelect,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_NoSelect
  MOVEM.l d2-d4,(a0)            ; ...

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  PopupMenu(a5),d1        ; get popupmenu
  JSR     Sub_3(a5)               ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 6

;------------------------------------------------------------------------------------------

 name      "PopupMenuBar", "()"
 flags     ; No returnvalue.
 amigalibs
 params
 debugger  7,Error3

.PB_PopupMenuBar
  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7) ; Save registers
  JSR     Sub_1(a5)                ; Sub_1

  MOVE.b  #PM_TitleBar,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_TitleBar
  MOVEM.l d2-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  PopupMenu(a5),d1        ; get popupmenu
  JSR     Sub_3(a5)               ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 7

;------------------------------------------------------------------------------------------

 name      "PopupMenuSubMenuItem", "(Text$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_l
 debugger  8,Error3

.PB_PopupMenuSubMenuItem
  MOVEM.L d2-d7/a5-a6,-(a7)     ; Save registers
  JSR     Sub_1(a5)             ; Sub_1  ..

  MOVE.l  d0,d5                 ; save text

  MOVE.b  #PM_Hidden,d2         ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Hidden
  MOVEM.l d2-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  d0,SubMenu(a5)        ; set SubMenu
  MOVE.l  d7,a0                 ; ...

  MOVE.b  #PM_Item,d2           ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d0,(a0)+              ; set Tag data
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeMenuA(a6)      ; (taglist) - a1

  MOVE.l  d7,a0                 ; use taglist

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Title
  MOVE.l  d5,(a0)+              ; set Tag data

  MOVE.b  #PM_Sub,d2            ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Sub
  MOVE.l  d0,(a0)+              ; set Tag data
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  PopupMenu(a5),d1      ; get popupmenu
  JSR     Sub_3(a5)             ; Sub_3
  MOVEM.L (a7)+,d2-d7/a5-a6     ; Restore registers
  RTS

 endfunc 8

;------------------------------------------------------------------------------------------

 name      "PopupMenuSubItem", "(SubItem.w,Text$,ShortCut$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_w,d1_l,a0_l
 debugger  9,Error4

.PB_PopupMenuSubItem
  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7)  ; Restore registers
  JSR     Sub_2(a5)                ; Sub_2

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d1,(a0)+              ; set Tag data

  MOVE.b  #PM_UserData,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_UserData
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_ID,d2             ; ...
  MOVE.l  d2,(a0)+              ; set #PM_ID
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_CommKey,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_CommKey
  MOVE.l  d6,(a0)+              ; set Tag data
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  SubMenu(a5),d1          ; get SubMenu
  JSR     Sub_3(a5)               ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6 ; Restore registers
  RTS

 endfunc 9

;------------------------------------------------------------------------------------------

 name      "PopupMenuCheckSubItem", "(SubItem.w,Text$,ShortCut$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_w,d1_l,a0_l
 debugger  10,Error4

.PB_PopupMenuCheckSubItem

   MOVEM.L d2-d4/d6-d7/a5-a6,-(a7)  ; Restore registers
  JSR     Sub_2(a5)                ; Sub_2

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Item
  MOVE.l  d1,(a0)+              ; set Tag data

  MOVE.b  #PM_UserData,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_UserData
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_ID,d2             ; ...
  MOVE.l  d2,(a0)+              ; set #PM_ID
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_CommKey,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_CommKey
  MOVE.l  d6,(a0)+              ; set Tag data

  MOVE.b  #PM_Checkit,d2        ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Checkit
  MOVE.l  d0,(a0)+              ; set Tag data <<<<
  MOVEM.l d3-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  d7,a0                 ; use taglist

  MOVE.l  SubMenu(a5),d1           ; get SubMenu
  JSR     Sub_3(a5)                ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6  ; Restore registers 
  RTS

 endfunc 10

;------------------------------------------------------------------------------------------

 name      "PopupMenuSubInfo", "(Text$)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_l
 debugger  11,Error4

.PB_PopupMenuInfoSubItem

 MOVEM.L  d2-d4/d6-d7/a5-a6,-(a7)  ; Restore registers
  JSR     Sub_1(a5)                ; Sub_1

  MOVE.b  #PM_Title,d2          ; ...
  MOVE.l  d2,(a0)+              ; set #PM_Title
  MOVE.l  d0,(a0)+              ; set Tag data

  MOVE.b  #PM_NoSelect,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_NoSelect
  MOVEM.l d2-d4,(a0)            ; ...

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  SubMenu(a5),d1           ; get SubMenu
  JSR     Sub_3(a5)                ; Sub_3
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6  ; Restore registers
  RTS

 endfunc 11

;------------------------------------------------------------------------------------------

 name      "PopupMenuSubBar", "()"
 flags     ; No returnvalue.
 amigalibs
 params
 debugger  12,Error4

.PB_PopupMenuSubBar
  MOVEM.L d2-d4/d6-d7/a5-a6,-(a7)  ; Restore registers
  JSR     Sub_1(a5)                ; Sub_1 ...

  MOVE.b  #PM_TitleBar,d2       ; ...
  MOVE.l  d2,(a0)+              ; set #PM_TitleBar
  MOVEM.l d2-d4,(a0)            ; set #Tag_Done & Tag data

  MOVE.l  d7,a1                 ; arg1.
  JSR    _PM_MakeItemA(a6)      ; (taglist) - a1

  MOVE.l  SubMenu(a5),d1           ; get SubMenu
  JSR     Sub_2(a5)                ; Sub_3\
  MOVEM.L (a7)+,d2-d4/d6-d7/a5-a6  ; Restore registers
  RTS

 endfunc 12

;------------------------------------------------------------------------------------------

 name      "AttachPopupMenu", "(#PopupMenu.w,Window.l)"
 flags     ; Return error
 amigalibs
 params    d0_w,d1_l
 debugger  13,Error5

.PB_AttachPopupMenu
  MOVE.l  Objects(a5),a0               ; ...
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a0                 ; ...

  MOVE.l  PopupMenu(a5),d0             ; get popupmenu
  BEQ.w   quitC0                ; ...

  MOVE.l  d1,a1                 ; ...
  MOVE.l  d2,-(a7)              ; Save d2
  MOVE.l  86(a1),d2             ; get Win\UserPort

  MOVEM.l d0-d2,(a0)            ; set PopupMenu, Window, UserPort
  MOVE.l  (a7)+,d2              ; Restore it.
  MOVE.w  Error(a5),d0          ; get error

  CLR.l   PopupMenu(a5)         ; clear popupmenu
  CLR.l   SubMenu(a5)           ; clear SubMenu
  CLR.w   Error(a5)             ; clear error
  RTS

quitC0
  MOVEQ   #-1,d0                ; ...
  RTS

 endfunc 13

;------------------------------------------------------------------------------------------

 name      "FreePopupMenu", "(#PopupMenu.w)"
 flags     ; No returnvalue.
 amigalibs
 params    d0_w
 debugger  14,Error6

.PB_FreePopupMenu
  MOVE.L  a6,-(a7)    ; Save a6
  MOVE.l  Objects(a5),a0        
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a0                 ; ...

  MOVE.l  (a0),d0               ; ...
  BEQ.w   quitD0                ; ...

  CLR.l   (a0)                  
  MOVE.l  PopupBase(a5),a6      

  MOVE.l  d0,a1                 ; arg1.
  JSR    _PM_FreePopupMenu(a6)  ; (menu) - a1
  MOVEA.l (a7)+,a6    ; Restore a6
quitD0
  RTS

 endfunc 14

;------------------------------------------------------------------------------------------

 name      "WaitPopupMenuEvent", "(#PopupMenu.w)"
 flags     LongResult
 amigalibs _ExecBase,a6
 params    d0_w
 debugger  15,Error6

.PB_WaitPopupMenuEvent

  MOVEM.l d5-d7/a2-a6,-(a7)     ; Save registers

  MOVE.l  Objects(a5),a2               
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a2                 ; ...

  MOVEM.l (a2),d5-d7            ; get menu, win & port

  MOVE.l  d7,a0                 ; arg1.
  JSR    _WaitPort(a6)          ; (port) - a0

loopE0
  MOVE.l  d7,a0                 ; arg1.
  JSR    _GetMsg(a6)            ; (port) - a0

  TST.l   d0                    ; ...
  BEQ.w   lE0                   ; ...

  MOVEQ   #6,d1                 ; loop counter
  MOVE.l  d0,a0                 ; ...
  MOVE.l  IMessage(a5),a1       ; get imsg

loopE1
  MOVE.l  (a0)+,(a1)+           ; move some data
  DBRA    d1,loopE1             ; loop until -1

  MOVE.l  d0,a1                 ; arg1.
  JSR    _ReplyMsg(a6)          ; (message) - a1

  BRA     loopE0                ; ...

lE0
  MOVE.l  PopupBase(a5),a6              ; use PopupBase

  MOVE.l  d6,a1                 ; arg1.
  MOVE.l  d5,a2                 ; arg2.
  MOVE.l  IMessage(a5),a3             ; arg3.
  LEA     142(a5),a5            ; arg4.
  JSR    _PM_FilterIMsgA(a6)    ; (win,menu,msg,tags) a1/a2/a3/a5

  TST.l   d0                    ; ...
  BNE.w   quitE0                ; ...

  MOVE.l  20(a3),d0             ; ...

quitE0
  MOVEM.l (a7)+,d5-d7/a2-a6     ; Save registers
  RTS

 endfunc 15

;------------------------------------------------------------------------------------------

;- reg use d2,d5,d6,d7 / a2,a3,a5,a6
 name      "PopupMenuEvent", "(#PopupMenu.w)"
 flags     LongResult
 amigalibs _ExecBase,a6
 params    d0_w
 debugger  16,Error6

.PB_PopupMenuEvent

  MOVEM.l d2/d5-d7/a2-a3/a5-a6,-(a7) ; Save registers

  MOVE.l  Objects(a5),a2        
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a2                 ; ...

  CLR.l   d2                    ; ...
  MOVEM.l (a2),d5-d7            ; get menu, win & port

loopF0
  MOVE.l  d7,a0                 ; arg1.
  JSR    _GetMsg(a6)            ; (port) - a0

  TST.l   d0                    ; ...
  BEQ.w   lF0                   ; ...

  MOVEQ   #6,d1                 ; loop counter
  MOVE.l  d0,d2                 ; save imsg
  MOVE.l  d0,a0                 ; ...
  MOVE.l  IMessage(a5),a1       ; get imsg

loopF1
  MOVE.l  (a0)+,(a1)+           ; move some data
  DBRA    d1,loopF1             ; loop until -1

  MOVE.l  d0,a1                 ; arg1.
  JSR    _ReplyMsg(a6)          ; (message) - a1

  BRA     loopF0                ; ...

lF0
  MOVE.l  d2,d0                 ; ...
  BEQ.w   quitF0                ; ...

  MOVE.l  PopupBase(a5),a6      ; use PopupBase

  MOVE.l  d6,a1                 ; arg1.
  MOVE.l  d5,a2                 ; arg2.
  MOVE.l  IMessage(a5),a3             ; arg3.
  LEA     142(a5),a5            ; arg4.
  JSR    _PM_FilterIMsgA(a6)    ; (win,menu,msg,tags) a1/a2/a3/a5

  TST.l   d0                    ; ...
  BNE.w   quitF0                ; ...

  MOVE.l  d2,d0                 ; ...
  BEQ.w   quitF0                ; ...

  MOVE.l  20(a3),d0             ; ...

quitF0
  MOVEM.l (a7)+,a2-a3                ; restore regs
  MOVEM.l (a7)+,d2/d5-d7/a2-a3/a5-a6 ; Save registers
  RTS

 endfunc 16

;------------------------------------------------------------------------------------------

 name      "PopupMenuChecked", "(#PopupMenu.w,Item.w)"
 flags     ;Return True/False
 amigalibs
 params    d0_w,d1_w
 debugger  17,Error6

.PB_PopupMenuChecked
  MOVE.l  a6,-(a7)              ; Save a6
  MOVE.l  Objects(a5),a0        ; ...
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a0                 ; ...

  MOVE.l  (a0),d0               ; get PopupMenu/PopupMenu
  MOVE.l  PopupBase(a5),a6      ; use PopupBase

  MOVE.l  d0,a1                 ; arg1.
  EXT.l   d1                    ; arg2.
  JSR    _PM_ItemChecked(a6)    ; (menu, id) -a1/d1
  MOVEA.l (a7)+,a6              ; Restore a6

  CMPI.w  #-5,d0                ; is it a error
  BNE.w   quitG0                ; nop

  ADDQ.w  #5,d0                 ; delete error

quitG0
  RTS

 endfunc 17

;------------------------------------------------------------------------------------------

 name      "DisablePopupMenuItem", "(#PopupMenu.w,Item.w,State.w)"
 flags     ; Return True/False
 amigalibs
 params    d0_w,d1_w,d2_w
 debugger  18,Error6

.PB_DisablePopupMenuItem

  MOVEM.l d2/a2/a6,-(a7)  ;Save regs

  MOVE.l  Objects(a5),a0        ; ...
  LSL.w   #4,d0                 ; ...
  ADD.w   d0,a0                 ; ...

  MOVE.l  (a0),d0               ; get PopupMenu\PopupMenu
  MOVE.l  PopupBase(a5),a6              ; use PopupBase

  MOVE.l  d0,a1                 ; arg1.
  EXT.l   d1                    ; arg2.
  JSR    _PM_FindItem(a6)       ; (menu, id) - a1/d1

  LEA     tags3(pc),a1          ; arg2.
  MOVE.w  d2,6(a1)              ; set tag data

  MOVE.l  d0,a2                 ; arg1
  JSR    _PM_SetItemAttrsA(a6)  ; (item, tags) - a2/a1

  MOVEM.l (a7)+,d2/a2/a6        ; Restore registers
  RTS

  CNOP 0,4  ; Align.

tags3: Dc.l TAG_USER|PM_Disabled,0,0,0

 endfunc 18

;------------------------------------------------------------------------------------------

 base
LibBase:

l_Objects:   Dc.l 0 
l_NbObjects: Dc.w 0 
l_PopupBase: Dc.l 0 
l_TagList:   Dc.l 0 
             Dc.l 0,0

l_PopupMenu: Dc.l 0    ; connect items to
l_SubMenu:   Dc.l 0    ; connect subitems to
l_Error:     Dc.w 0    ; catch errors

l_IMessage:    Dc.l 0                     
l_LibraryName: Dc.b "popupmenu.library",0

 CNOP 0,4 ; Align


; Sub_1 changes d2,d3,d4,d7/a5,a6
;
l_Sub_1: 
  MOVE.l  PopupBase(a5),a6               ; get PopupBase
  MOVE.l  TagList(a5),d7               ; get taglist
  CLR.l   d2                     ; ...
  BSET    #31,d2                 ; TagUser
  MOVE.l  TagList+4(a5),d3
  MOVE.l  TagList+8(a5),d4       ; ...
  MOVE.l  d7,a0                  ; use taglist
  RTS

 CNOP 0,4 ; Align

; Sub_2 changes  d0,d2,d3,d4,d6,d7/a5,a6
;
l_Sub_2: 
  MOVE.l  PopupBase(a5),a6       ; get PopupBase
  MOVE.l  TagList(a5),d7         ; get taglist
  EXT.l   d0                     ; ...
  CLR.l   d2                     ; ...
  BSET    #31,d2                 ; set TagUser
  MOVE.l  TagList+4(a5),d3
  MOVE.l  TagList+8(a5),d4       ; ...
  TST.b   (a0)                   ; is it a zero string
  BNE.w   l007                   ; nop

  SUB.l   a0,a0                  ; ...

l007
  MOVE.l  a0,d6                  ; ...
  MOVE.l  d7,a0                  ; use taglist
  RTS

 CNOP 0,4 ; Align

;
; Sub_3 changes d2
;   a6 must be PopupBase

l_Sub_3:
  MOVE.l  d7,a0                  ; use taglist

  MOVE.b  #PM_Insert_Last,d2     ; ...
  MOVE.l  d2,(a0)+               ; set #PM_Insert_Last
  MOVE.l  d1,(a0)+               ; set Tag data

  MOVE.b  #PM_Insert_Item,d2     ; ...
  MOVE.l  d2,(a0)+               ; set #PM_Insert_Item
  MOVE.l  d0,(a0)+               ; set Tag data
  MOVEM.l d3-d4,(a0)             ; set #Tag_Done & Tag data

  MOVE.l  d1,a0                  ; arg1.
  MOVE.l  d7,a1                  ; arg2.
  JSR    _PM_InsertMenuItemA(a6) ; (popupmenu,taglist) - a0/a1

  SUBQ.w  #1,d0                  ; ...
  ADD.w   d0,Error(a5)           ; add to error
  RTS

  CNOP 0,4  ; Align
tags: Dc.l TAG_USER|PM_AutoPullDown, 1, 0, 0

 endlib

;------------------------------------------------------------------------------------------

 startdebugger

Error1 ; Check param1 in InitPopupMenu().
  TST.w  d0
  BMI.w  Err1
  CMPI.w #2046,d0
  BGT.w  Err1
  RTS

Error2 ; Check if InitPopupMenu() was success.
  TST.l  Objects(a5)
  BEQ.w  Err2
  TST.l  PopupBase(a5)
  BEQ.w  Err2
  RTS

Error3 ; Error2 + Check if PopupMenuTitle() was called.
  TST.l  Objects(a5)
  BEQ.w  Err2
  TST.l  PopupBase(a5)
  BEQ.w  Err2

  TST.l  PopupMenu(a5)
  BEQ.w  Err3
  RTS

Error4 ; Error2 + Check if PopupMenuSubMenuItem() was called.
  TST.l  Objects(a5)
  BEQ.w  Err2
  TST.l  PopupBase(a5)
  BEQ.w  Err2

  TST.l  SubMenu(a5)
  BEQ.w  Err3
  RTS

Error5 ; Error2 + Error3 + Check if param1 are in bounds.
  TST.l  Objects(a5)
  BEQ.w  Err2
  TST.l  PopupBase(a5)
  BEQ.w  Err2

  TST.l  PopupMenu(a5)
  BEQ.w  Err5

  TST.w  d0
  BMI.w  Err6
  CMP.w  NbObjects(a5),d0
  BGT.w  Err6
  RTS

Error6 ; Error2 + Check if param1 are in bounds.
  TST.l  Objects(a5)
  BEQ.w  Err2
  TST.l  PopupBase(a5)
  BEQ.w  Err2

  TST.w  d0
  BMI.w  Err6
  CMP.w  NbObjects(a5),d0
  BGT.w  Err6
  RTS


Err1: DebugError "#Menus out of Range"
Err2: DebugError "Incorrect InitCode or Lack of ErrorTest"
Err3: DebugError "Call PopupMenuTitle() First"
Err4: DebugError "Call PopupMenuSubMenuItem() First"
Err5: DebugError "No PopupMenu is Created"
Err6: DebugError "#PopupMenu out of Range"

 enddebugger

