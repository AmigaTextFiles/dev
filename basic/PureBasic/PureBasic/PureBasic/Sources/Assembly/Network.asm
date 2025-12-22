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
;
; Very fast & easy TCP/IP support for PureBasic.
;
; 10/10/2005
;   -Doobrey- Minor changes to preserve regs.
;             Changed OpenNetworkConnexion to OpenNetworkConnection 
;             and  CloseNetworkConnexion to CloseNetworkConnection ( to match other PB versions)
;
;----------------------------------------------------------------------------------------------------------------
; 07/08/2000
;   Finished the work :-)
;   Added Send/Recieve Strings..
;
; 06/08/2000
;   Continued the work...
;
; 30/07/2000
;   First version
;
;

 INCLUDE "PureBasic:Library SDK/PhxAss/MakeResident.asm"

MEMF_CLEAR = 1 << 16

TAG_USER   = 1 << 31
TAG_MORE   = 2

AT_INET    = 2
FIONREAD   = $4004667F
FIOASYNC   = -2147195267
FIONBIO    = -2147195266

MSG_PEEK   = 2

MODE_OLDFILE   = 1005
MODE_NEWFILE   = 1006
MODE_READWRITE = 1004

_BSDBase      = 0
_ClientSocket = _BSDBase+4
_Host         = _ClientSocket+4
_TmpBuffer    = _Host+32
_DataLength   = _TmpBuffer+4
_ServerHost   = _DataLength+4
_ServerSocket = _ServerHost+16
_NbClients    = _ServerSocket+4
_ClientArray  = _NbClients+2
_ServerDataLength = _ClientArray+32*4
_LastClient   = _ServerDataLength+4


 initlib "Network", "Network", "FreeNetwork", 100, 1, 0

;
; Now do the functions...
;
;-------------------------------------------------------------------------------------------------
 name      "InitNetwork", "()"
 flags      LongResult
 amigalibs _ExecBase, a6
 params
 debugger   1

   LEA.l   _BSDName(pc),a1
   MOVEQ.l  #0,d0
   JSR     _OpenLibrary(a6)     ; (LibName, Version) - a1/d0
   MOVE.l   d0, _BSDBase(a5)
   TST.l    d0
   BEQ      IN_Exit
   MOVE.l   #16000, d0
   MOVE.l   #MEMF_CLEAR, d1
   JSR     _AllocVec(a6)        ; (Size, Flags) - d0/d1
   MOVE.l   d0, _TmpBuffer(a5)
IN_Exit:
   RTS

_BSDName:
  Dc.b      "bsdsocket.library",0

 endfunc    1

;-------------------------------------------------------------------------------------------------

 name      "FreeNetwork", "()"
 flags
 amigalibs _ExecBase, d5
 params
 debugger   2

   MOVEM.l  d3-d4/a6,-(a7)      ; Save registers
   MOVE.l  _BSDBase(a5), d0
   BEQ      FN_NotOpened
   MOVE.l   d0,a6
   MOVE.l  _ClientSocket(a5), d0
   CMP.l    #-1,d0
   BEQ      FN_NoClient         ; No client opened..
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
FN_NoClient:
   MOVE.l  _ServerSocket(a5),d3 ; Close all the socket on the server side..
   CMP.l    #-1,d0
   BEQ      FN_Next             ;
   MOVEQ.l  #31, d4             ;
   LEA.l   _ClientArray(a5), a0 ;
FN_Loop:                        ; Loop to close all the client sockets which where connected to the server
   MOVE.l   (a0)+, d0           ;
   CMP.l    #-1, d0             ;
   BEQ      FN_SkipClient       ;
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
FN_SkipClient:
   DBRA     d4, FN_Loop
   MOVE.l   d3,d0               ; Close the server socket
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
FN_Next:
   MOVE.l   a6, a1
   MOVE.l   d5, a6
   JSR     _CloseLibrary(a6)  ; (*Library) - a1
   MOVE.l  _TmpBuffer(a5), a1
   JSR     _FreeVec(a6)
FN_NotOpened:
   MOVEM.l (a7)+,d3-d4/a6        ; Restore registers
   RTS

 endfunc    2

;-------------------------------------------------------------------------------------------------

 name      "OpenNetworkConnection", "(HostName$, Port)"
 flags      LongResult
 amigalibs  
 params     d3_l, d4_l
 debugger   3

   MOVEM.l d2/a6,-(a7)            ; Save registers
   MOVE.l  _BSDBase(a5), a6
   MOVE.l   #AT_INET, d0          ; For the internet
   MOVEQ.l  #1, d1                ;
   MOVEQ.l  #0, d2                ; TCP procotol ID
   JSR     _socket(a6)            ; (Domain, Type, Protocol) - d0/d1/d2
   TST.l    d0
   BLT      ONC_Error             ; If = -1, quit
   MOVE.l   d0, _ClientSocket(a5)
   MOVE.l   d3, a0
   JSR     _gethostbyname(a6)     ; (Name$) - a0
   TST.l    d0
   BEQ      ONC_Error2

   MOVE.l   d0, a0
   MOVE.l   12(a0), d1            ; Get HostEnd\h_lengh
   MOVE.l   16(a0), a1            ; Get HostEnt\h_addr_entry\ItemA
   MOVE.l   (a1), a1              ;

   LEA.l   _Host(a5), a0
   MOVE.b   #AT_INET, 1(a0)       ; Host\sin_family
   MOVE.w   d4, 2(a0)             ; Host\port
   ADDQ.L   #4, a0                ; Point to Host\in_addr

ONC_CopyLoop:                     ; Copy the need info
   MOVE.l   (a1)+, (a0)+          ;
   DBRA     d1, ONC_CopyLoop      ;

   MOVE.l  _ClientSocket(a5), d0  ; *Socket
   LEA.l   _Host(a5), a0          ;
   MOVEQ.l  #16, d1               ; Length of 'SockAddrIn' structure
   JSR     _connect(a6)           ; (*Socket, *AddrName, Length) ; d0/a0/d1
   TST.l    d0
   BLT      ONC_Error2
   MOVE.l  _ClientSocket(a5), d0  ; Ok, the socket is connected to the server
   ADDQ.l   #1, d0                ; Warning !! Here it's the socket+1 which is returned !!
   MOVEM.l  (a7)+,d2/a6           ; Restore registers
   RTS

ONC_Error2:
   MOVE.l  _ClientSocket(a5), d0
   JSR     _CloseSocket(a6)       ; (*Socket) - d0
   CLR.l   _ServerSocket(a5)      ; Clear the socket ID
ONC_Error:
   MOVEM.l  (a7)+,d2/a6           ; Restore registers
   MOVEQ.l  #0, d0
   RTS

 endfunc    3

;-------------------------------------------------------------------------------------------------

 name      "CloseNetworkConnection", "()"
 flags      LongResult
 amigalibs
 params
 debugger   4

   MOVEM.l  d2-d3/a6,-(a7)       ; Save registers
   MOVE.l  _ClientSocket(a5), d3
   BLT      CNC_Exit

   MOVEA.l _TmpBuffer(a5), a0   ; Fill the buffer to send the deconnexion message. This is a PureBasic
   MOVE.l   #'PBMG',  (a0)      ; unique feature :*). Nice to know if a client quit a server.
   MOVE.l   #'DCXN', 4(a0)      ;

   MOVE.l   d3,d0               ; Socket
   MOVEQ.l  #8, d1              ; Length
   MOVEQ.l  #0, d2              ; Flags
   MOVE.l  _BSDBase(a5), a6     ; Test if the Init has been called...
   JSR     _send(a6)            ; (*Socket, *Buffer, Length, Flags) - d0/a0/d1/d2

   MOVE.l   #-1, _ServerSocket(a5)
   MOVE.l   d3,d0
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
CNC_Exit:
   MOVEM.l (a7)+,d2-d3/a6       ; Save registers.
   RTS

 endfunc    4

;-------------------------------------------------------------------------------------------------

 name      "NetworkEvent", "()"
 flags      LongResult
 amigalibs
 params
 debugger   5

   MOVE.l  a6,-(a7)		; Save registers
   MOVE.l  _ClientSocket(a5),d0 ; Socket
   MOVE.l   #FIONREAD, d1       ; Length
   LEA.l   _DataLength(a5),a0   ; Size of data actually in the socket
   MOVEA.l _BSDBase(a5), a6     ;
   JSR     _IoctlSocket(a6)     ; (*Socket, Action, *Buffer) - d0/d1/a0
   MOVE.l  _DataLength(a5), d0
   MOVE.l (a7)+,a6              ; Restore registers
   RTS

 endfunc    5

;-------------------------------------------------------------------------------------------------

 name      "SendNetworkData", "(ClientID, *MemoryBuffer, Length)"
 flags      LongResult
 amigalibs
 params     d0_l, a0_l, d1_l
 debugger   6
   
   MOVEM.l  d2/a6,-(a7)         ; Save registers.
   TST.l    d0
   BNE      SND_Next
   MOVE.l  _ClientSocket(a5),d0
SND_Next:
   MOVEQ.l  #0, d2              ; Flags
   MOVEA.l _BSDBase(a5), a6
   JSR     _send(a6)            ; (*Socket, *Buffer, Length, Flags) - d0/a0/d1/d2
   MOVEM.l (a7)+,d2/a6          ; Restore registers
   RTS                          ;

 endfunc    6

;-------------------------------------------------------------------------------------------------

 name      "SendNetworkFile", "(ClientID, FileName$)"
 flags      LongResult
 amigalibs _DosBase, a6 , _ExecBase, a2
 params     d0_l, d1_l
 debugger   7

   MOVEM.l  d2-d7/a2/a6,-(a7)          ; Save registers
   TST.l    d0
   BNE      SNF_Next
   MOVE.l  _ClientSocket(a5),d0
SNF_Next:
   MOVE.l   d0,d7

  MOVE.l    #1005, d2  ; Mode Read
  JSR      _Open(a6)   ; (FileName$, Mode) - d1/d2
  TST.l     d0         ;
  BEQ       SNF_Exit   ; File not found

  MOVE.l    d0, d5     ; Store the file ptr in 'd5'
  EXG.l     a2,a6         ; a6=exec, a2=dos
  MOVE.l    #260,d0       ; Size of FileInfoBlock struct
  MOVEQ     #0,d1         ;
  JSR      _AllocVec(a6)  ; Alloc some mem...
  MOVE.l    d0,d2         ;
  EXG.l     a6,a2         ; a6=dos, a2=exec
  MOVE.l    d5,d1         ;
  JSR      _ExamineFH(a6) ; (d1/d2) - Get some infos on the file...
  MOVE.l    d2,a1         ;
  MOVE.l    124(a1),d4    ; Get the size
  EXG.l     a6,a2         ;  a6=exec, a2=dos
  JSR      _FreeVec(a6)   ; (a1) - Free the mem

  MOVE.l    d4, d0
  ADD.l     #12, d0
  MOVEQ.l   #0, d1              ; Mem flags
  JSR      _AllocVec(a6)        ; d0/d1
  TST.l     d0
  BEQ       SNF_Exit
  MOVE.l    d0,d6

  EXG.l     a2,a6     ;  a6=dos, a2=exec
  MOVE.l    d5, d1    ; File ptr
  MOVE.l    d6, d2    ; Dest buffer
  ADD.l     #12, d2   ;
  MOVE.l    d4, d3    ;
  JSR      _Read(a6)  ; (File, Buffer, Length) - d1,d2,d3

  MOVE.l    d5, d1    ; Close the file
  JSR      _Close(a6) ; d1

  MOVE.l    d6, a0
  MOVE.l    #'PBMG',  (a0)
  MOVE.l    #'SFLE', 4(a0)
  MOVE.l    d4, 8(a0)
  MOVE.l    d7,d0     ; Socket
  MOVE.l    d4, d1
  ADD.l     #12, d1
  MOVEQ.l   #0, d2              ; Flags
  MOVEA.l  _BSDBase(a5), a6     ; a6=bsdsocketbase
  JSR      _send(a6)            ; (*Socket, *Buffer, Length, Flags) - d0/a0/d1/d2

  MOVE.l    d6,a1               ; Free the allocated file buffer...
  MOVE.l    a2,a6               ; Get execbase
  JSR      _FreeVec(a6)         ;
  MOVEQ.l   #1,d0
SNF_Exit:
  MOVEM.l  (a7)+,d2-d7/a2/a6       ; Restore registers
  RTS

 endfunc    7

;-------------------------------------------------------------------------------------------------

 name      "CreateNetworkServer", "(Port)"
 flags      LongResult
 amigalibs
 params     d3_l
 debugger   8

   MOVEM.l d2/d4/a6,-(a7)         ; Save registers
   MOVE.l  _BSDBase(a5), a6
   MOVE.l   #AT_INET, d0          ; For the internet
   MOVEQ.l  #1, d1                ;
   MOVEQ.l  #0, d2                ; TCP procotol ID
   JSR     _socket(a6)            ; (Domain, Type, Protocol) - d0/d1/d2
   TST.l    d0
   BLT      CNS_Error             ; If = -1, quit
   MOVE.l   d0, _ServerSocket(a5) ;
   MOVE.l   d0, d4                ;
   MOVE.l   #FIONBIO, d1          ; State
   LEA.l   _State(pc),a0          ; Size of data actually in the socket
   JSR     _IoctlSocket(a6)       ; (*Socket, Action, *Buffer) - d0/d1/a0
   CMP.l    #-1,d0
   BEQ      CNS_Error2

   MOVE.l   d4, d0                ;
   LEA.l   _ServerHost(a5), a0    ;
   MOVE.w   d3, 2(a0)             ; Set the port to the host data
   MOVEQ.l  #16, d1               ;
   JSR     _bind(a6)              ; (*Socket, *Host, Length) - d0/a0/d1
   CMP.l    #-1,d0
   BEQ      CNS_Error2

   MOVE.l   d4, d0                ;
   MOVEQ.l  #32, d1               ;
   JSR     _listen(a6)            ; (*Socket, backlog) - d0/d1
   CMP.l    #-1,d0
   BEQ      CNS_Error2
   MOVE.l   d4, d0                ; WARNING - The returned socket number is 'number+1'
   ADDQ.l   #1, d0                ;
   MOVEM.l  (a7)+,d2/d4/a6        ; Restore registers
   RTS

CNS_Error2:
   MOVE.l   d4, d0
   JSR     _CloseSocket(a6)       ; (*Socket) - d0
   CLR.l   _ServerSocket(a5)      ; Clear the socket ID
CNS_Error:
   MOVEM.l  (a7)+,d2/d4/a6        ; Restore registers
   MOVEQ.l  #0, d0
   RTS
 
  CNOP 0,4  ; Align it for 040+

_State:
   DC.l     1

 endfunc    8

;-------------------------------------------------------------------------------------------------

 name      "NetworkServerEvent", "()"
 flags      LongResult
 amigalibs
 params
 debugger   9

   MOVEM.l  d2-d5/a6,-(a7)      ; Save registers

   MOVE.l  _ServerSocket(a5),d0 ; Socket
   LEA.l   _ServerHost(a5), a0  ;
   MOVE.l   #16,a1              ;
   MOVE.l  _BSDBase(a5), a6     ;
   JSR     _accept(a6)          ; (*Socket, Host, Length) - d0/a0/a1
   CMP.l    #-1,d0              ;
   BEQ     _SkipConnection      ; If <>-1, a new client has been connected...

   LEA.l   _ClientArray(a5),a0
   MOVE.l   d0,d1
   MOVE.l   d0, _LastClient(a5)
   LSL.l    #2,d1
   ADD.l    d1,a0
   MOVE.l   d0,(a0)
   ADD.w    #1, _NbClients(a5)  ; Update the number of connected clients...
   MOVEQ.l  #1, d0
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   RTS

_SkipConnection:
   LEA.l   _ClientArray(a5),a0
   MOVEQ.l  #31,d3              ;

_NextClient:
   MOVE.l   (a0)+, d0           ; Read the array to know if a client has connected
   CMP.l    #-1,d0              ;
   BEQ     _SkipClient          ; If = -1, no way

   MOVE.l   d0, _LastClient(a5)

   MOVE.l   a0, d5
   MOVE.l   d0, d4
   MOVE.l   #FIONREAD, d1           ; Length
   LEA.l   _ServerDataLength(a5),a0 ; Size of data actually in the socket
   CLR.l    (a0)                    ; Delete any other previous values (may be not needed...)
   JSR     _IoctlSocket(a6)         ; (*Socket, Action, *Buffer) - d0/d1/a0
   MOVE.l   d5,a0
   MOVE.l  _ServerDataLength(a5),d0 ;
   BEQ     _SkipClient              ; Nothing to read in this socket, go to the next client

   CMP.l    #8,d0
   BLT     _RawData
   MOVE.l   d4,d0
   LEA.l   _ServerBuffer(pc),a0
   MOVEQ.l  #8,d1
   MOVE.l   #MSG_PEEK,d2
   JSR     _recv(a6)            ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2

   LEA.l   _ServerBuffer(pc),a0
   MOVE.l   (a0)+,d0
   CMP.l    #'PBMG',d0
   BNE     _RawData

   MOVE.l   (a0),d0
   CMP.l    #'SFLE',d0
   BEQ     _RecieveFile

   CMP.l    #'STRG',d0
   BEQ     _RecieveString

   CMP.l    #'DCXN',d0
   BEQ     _Deconnexion
   BRA     _RawData

_SkipClient:
   DBRA     d3, _NextClient
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   MOVEQ.l  #0,d0
   RTS

_RecieveFile:
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   MOVEQ.l  #3,d0
   RTS

_RecieveString:
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   MOVEQ.l  #5,d0                 ;
   RTS                            ;

_Deconnexion:
   MOVE.l   d5,a0               ; Clear the deconnected socket in the socket array
   MOVE.l   #-1, -(a0)          ;
   MOVE.l   d4, d0
   JSR     _CloseSocket(a6)     ; Finally, close the unused socket
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   MOVEQ.l  #4,d0
   RTS

_RawData:
   MOVEM.l  (a7)+,d2-d5/a6      ; Restore registers
   MOVEQ.l  #2,d0
   RTS

   CNOP 0,4 ; Align it.

_ServerBuffer:
   Dc.l     0,0,0

 endfunc    9

;-------------------------------------------------------------------------------------------------

 name      "CloseNetworkServer", "()"
 flags      LongResult
 amigalibs
 params
 debugger   10

   MOVEM.l  d3-d4/a6,-(a7)      ; Save registers.
   MOVE.l  _BSDBase(a5), a6
   MOVE.l  _ServerSocket(a5),d3 ; Close all the socket on the server side..
   BLT      CNS_Exit            ;
   MOVEQ.l  #31, d4             ;
   LEA.l   _ClientArray(a5), a0 ;
CNS_Loop:                       ; Loop to close all the client sockets which where connected to the server
   MOVE.l   (a0)+, d0           ;
   CMP.l    #-1, d0             ;
   BEQ      CNS_SkipClient      ;
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
CNS_SkipClient:
   DBRA     d4, CNS_Loop
   MOVE.l   #-1, _ServerSocket(a5)
   MOVE.l   d3,d0               ; Close the server socket
   JSR     _CloseSocket(a6)     ; (*Socket) - d0
CNS_Exit:
   MOVEM.l (a7)+,d3-d4/a6       ; Restore registers
   RTS


 endfunc    10

;-------------------------------------------------------------------------------------------------

 name      "ReceiveNetworkData", "(ConnectionID, DataBuffer, Length)"
 flags      LongResult
 amigalibs
 params     d0_l, a0_l, d1_l
 debugger   11

   MOVE.l   a6,-(a7)    ; Save registers
   CMP.l    #0, d0
   BNE      RND_ServerClient
   MOVE.l  _ClientSocket(a5),d0
   BRA      RND_Next
RND_ServerClient
RND_Next:
   MOVE.l  _BSDBase(a5), a6
   MOVEQ.l  #0,d2
   JSR     _recv(a6)            ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2
   MOVEA.l  (a7)+,a6            ; Restore a6
   RTS

 endfunc    11

;-------------------------------------------------------------------------------------------------

 name      "NetworkClientID", "()"
 flags      LongResult | InLine
 amigalibs
 params
 debugger   12

   MOVE.l  _LastClient(a5),d0
   I_RTS

 endfunc    12

;-------------------------------------------------------------------------------------------------

 name      "ReceiveNetworkFile", "(ConnectionID, FileName$)"
 flags      LongResult
 amigalibs _DosBase, a6
 params     d0_l, d1_l
 debugger   13

   MOVEM.l d2-d6/a2/a6,-(a7)    ; Save registers..
   MOVE.l   a6,a2               ; Save dosbase to a2  

   TST.l    d0
   BNE      RNF_ServerClient
   MOVE.l  _ClientSocket(a5),d0
   BRA      RNF_Next
RNF_ServerClient:
RNF_Next:
   MOVE.l   d0, d4
   MOVE.l   #MODE_NEWFILE, d2    ; Open Mode (here create a new file or delete+create if exists)
   JSR     _Open(a6)             ; (FileName$, Mode) - d1/d2
   TST.l    d0                   ;
   BEQ      RNF_Exit             ; Can't write file
   MOVE.l   d0, d5               ; Store the file ptr in 'd5'

   MOVE.l  _BSDBase(a5),a6       ; Get *SocketLibrary base
   MOVE.l   d4,d0
   LEA.l    RNF_TmpLength(pc),a0
   MOVEQ.l  #12,d1
   MOVEQ.l  #0,d2
   JSR     _recv(a6)             ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2
   LEA.l    RNF_TmpLength(pc),a0
   MOVE.l   8(a0), d6            ; Get the file size for later use...

RNF_ReadNextPart:
   MOVE.l  _BSDBase(a5),a6       ; Get *SocketLibrary base
   MOVE.l   d4, d0
   MOVE.l   #FIONREAD, d1        ; Length
   LEA.l    RNF_TmpLength(pc),a0 ; Size of data actually in the socket
   JSR     _IoctlSocket(a6)      ; (*Socket, Action, *Buffer) - d0/d1/a0
   MOVE.l   RNF_TmpLength(pc),d0 ;

   CMP.l    d0,d6
   BGE      RNF_Ok
   MOVE.l   d6,d0
RNF_Ok:
   TST.l    d0
   BEQ      RNF_SkipRead

   CMP.l    #16000,d0
   BLE      RNF_NoOverFlow
   MOVE.l   #16000,d0
RNF_NoOverFlow:

   SUB.l    d0,d6

   MOVE.l  _BSDBase(a5),a6      ; Get *SocketLibrary base
   MOVE.l   d0,d3               ; Save Length
   MOVE.l   d4, d0              ; Put socket to read from
   MOVE.l  _TmpBuffer(a5),a0    ; Get our Tmp Area
   MOVE.l   d3,d1               ; Length
   MOVEQ.l  #0,d2               ; Raw read
   JSR     _recv(a6)            ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2

   MOVE.l   a2,a6               ; Get DosBase
   MOVE.l   d5, d1              ; File
   MOVE.l  _TmpBuffer(a5),d2    ; Buffer
                                ; Length already is in 'd3'
   JSR     _Write(a6)           ; (File, Buffer, Length) - d1/d2/d3

RNF_SkipRead:
   TST.l    d6                  ; Test if the whole file has been read..
   BGT      RNF_ReadNextPart    ;

   MOVE.l   a2,a6               ; quicker from a reg.
   MOVE.l   d5, d1              ;
   JSR     _Close(a6)           ;

RNF_Exit:
   MOVEM.l (a7)+,d2-d6/a2/a6,-(a7) ; Restore registers..
   RTS

  CNOP 0,4  ; Align it.

RNF_TmpLength:
   Dc.l     0,0,0

;-DosLib:
;-   Dc.l     0


 endfunc    13

;-------------------------------------------------------------------------------------------------

 name      "SendNetworkString", "(ClientID, String$)"
 flags      LongResult
 amigalibs
 params     d0_l, a0_l
 debugger   14

   MOVEM.l  d2/a6,-(a7)        ; Save registers
   MOVE.l  _TmpBuffer(a5), a1
   MOVE.l   #'PBMG', (a1)+
   MOVE.l   #'STRG', (a1)+
   MOVE.l   a0, d2
   BNE      SNS_StringNotNull
   LEA.l    SNS_StringNull(pc),a0
SNS_StringNotNull:
   MOVEQ.l  #0, d1
   ADDQ.l   #4, a1
SNS_StringLength:               ; Get the string length...
   ADDQ.l   #1, d1              ; The zero byte is counted too (a null string will have a size of 1)
   MOVE.b   (a0)+, d2           ;
   MOVE.b   d2, (a1)+           ; Directly the string to the buffer
   TST.b    d2                  ;
   BNE      SNS_StringLength    ;

   TST.l    d0                  ; Handle if it's the Client or the Server
   BNE      SNS_Next            ;
   MOVE.l  _ClientSocket(a5),d0 ;
SNS_Next:                       ;

   MOVE.l  _TmpBuffer(a5), a0   ;
   MOVE.l   d1, 8(a0)           ; Set the string size.
   ADD.l    #12, d1
   MOVEQ.l  #0, d2
   MOVEA.l _BSDBase(a5), a6
   JSR     _send(a6)            ; (*Socket, *Buffer, Length, Flags) - d0/a0/d1/d2
   MOVEM.l  (a7)+,d2/a6         ; Restore
   RTS                          ;

SNS_StringNull:
   Dc.w     0

 endfunc    14

;-------------------------------------------------------------------------------------------------

 name      "ReceiveNetworkString", "(ConnectionID)"
 flags      StringResult
 amigalibs
 params     d0_l
 debugger   15

   MOVEM.l  d2-d3/a6,-(a7)       ; Save registers
   TST.l    d0
   BNE      RNS_Next
   MOVE.l  _ClientSocket(a5),d0
RNS_Next:

   MOVE.l  _BSDBase(a5),a6       ; Get *SocketLibrary base
   MOVE.l   d0,d4
   LEA.l    RNS_TmpLength(pc),a0
   MOVEQ.l  #12,d1
   MOVEQ.l  #0,d2
   JSR     _recv(a6)             ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2
   LEA.l    RNS_TmpLength(pc),a0
   MOVE.l   8(a0), d3            ; Get the string size for later use...
 
   MOVE.l   d4, d0
   MOVE.l   a3, a0
   MOVE.l   d3, d1
   MOVEQ.l  #0, d2
   JSR     _recv(a6)             ; (*Socket, *Mem, Length, Flags) - d0/a0/d1/d2
   ADD.l    d3, a3
   SUBQ.l   #1, a3
   MOVEM.l  (a7)+,d2-d3/a6       ; Restore registers
   RTS

   CNOP 0,4 ; Align

RNS_TmpLength:
   Dc.l     0,0,0

 endfunc    15

;-------------------------------------------------------------------------------------------------

 base

  Dc.l      0       ; BSDBase
  Dc.l      -1      ; ClientSocket
  Dc.l      0,0,0,0 ; Client Host data
  Dc.l      0,0,0,0 ;
  Dc.l      0       ; TmpBuffer
  Dc.l      0       ; DataLength
  Dc.b      16, 1   ; Server Data: Length, Family
  Dc.l      0,0,0   ; Server Data...
  Dc.w      0       ;
  Dc.l      -1      ; ServerSocket
  Dc.w      0       ; NbClients
  Dcb.l     32, -1  ; Clients area
  Dc.l      0       ; ServerDataLength
  Dc.l      -1      ; LastClient

 endlib

;-------------------------------------------------------------------------------------------------

 startdebugger

Error2 ; Check if InitNetwork() was success.
  TST.l  (a5)
  BEQ.w  Err2
  RTS

Err2: DebugError "InitNetwork() has failed... Don't use any Network functions !"

 enddebugger

