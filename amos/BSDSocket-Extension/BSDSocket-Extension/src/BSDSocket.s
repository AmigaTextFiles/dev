; BSDSocket Extension for AMOS Professional
; Copyright 2023-2024 John Bintz
; Licensed under the MIT License
;
; Writing this code the right way, 25 years later.

; extension number 18
ExtNb           equ 18-1
Version         MACRO
                dc.b "1.1.4-20240502"
                ENDM
VerNumber       equ $1

;---------------------------------------------------------------------
;       Include the files automatically calculated by
;       Library_Digest.AMOS
;---------------------------------------------------------------------
        Incdir "AMOSPro_Sources:"
        Incdir "AMOSPro_Sources:includes/"
        Include "BSDSocket_Size.s"
        Include "BSDSocket_Labels.s"
        Include "+AMOS_Includes.s"
        Include "bsdsocket_lvo.i"

; get the effective address of something in extension memory
Dlea    MACRO
        MOVE.L ExtAdr+ExtNb*16(A5),\2
        ADD.W #\1-MB,\2
        ENDM

; load the base of extension memory into a register
Dload   MACRO
        MOVE.L ExtAdr+ExtNb*16(A5),\1
        ENDM

; call an AmigaOS function via LVO(A6)
CALLLIB MACRO
        JSR _LVO\1(A6)
        ENDM

; bsdsocket library stuff
; ported from the various C include headers
SOCK_STREAM EQU 1
PF_INET     EQU 2
AF_INET     EQU PF_INET
IPPROTO_TCP EQU 6

INADDR_ANY  EQU 0

FIONBIO     EQU $8004667E
FIONASYNC   EQU $8004667D

SOL_SOCKET  EQU $FFFF
SO_REUSEADDR EQU $4

MAX_SOCKETS EQU 64

len_sockaddr_in        EQU 16
sockaddr_in_sin_family EQU 1
sockaddr_in_sin_port   EQU 2
sockaddr_in_sin_addr   EQU 4

; global errors
Error_OtherError             EQU -1
Error_LibraryNotOpen         EQU -2
Error_PortOutOfRange         EQU -11
Error_FdsetOutOfRange        EQU -11
Error_UnableToBind           EQU -12

; socket herrno and tag lists
; built from:
; * https://wiki.amigaos.net/amiga/autodocs/bsdsocket.doc.txt
; * https://github.com/deplinenoise/amiga-sdk/blob/master/netinclude/amitcp/socketbasetags.h
; * http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node012E.html

TAG_USER EQU (1<<31)
SBTF_REF EQU $8000
SBTB_CODE EQU 1
SBTS_CODE EQU $3FFF
SBTC_HERRNO EQU 6

HerrnoTag EQU (TAG_USER|SBTF_REF|((SBTC_HERRNO&SBTS_CODE)<<SBTB_CODE))

; wrap code that doesn't take arguments with these
PreserveStackInstruction MACRO
  MOVEM.L A2-A6/D6-D7,-(SP)
  ENDM
RestoreStackInstruction MACRO
  MOVEM.L (SP)+,A2-A6/D6-D7
  ENDM

; wrap code that takes arguments with these
PreserveStackFunction MACRO
  MOVEM.L A2/A4-A6/D6-D7,-(SP)
  ENDM
RestoreStackFunction MACRO
  MOVEM.L (SP)+,A2/A4-A6/D6-D7
  ENDM

LoadBSDSocketBase MACRO
  MOVE.L BSDSocketBase-MB(A3),A6
  ENDM

WithDataStorage MACRO
  MOVE.L A3,-(SP)
  Dload A3
  ENDM

EndDataStorage MACRO
  MOVE.L (SP)+,A3
  ENDM

; fdset macros
EnsureValidFdset MACRO
    CMP.L #MaxFd_sets,\1
    BLT \2

    MOVE.L #Error_FdsetOutOfRange,D3
    RestoreStackFunction
    Ret_Int
    ENDM

EnsureValidFdsetBit MACRO
    CMP.L #64,\1
    BGE _EnsureValidFdsetBit_Fail\@
    BRA \2
_EnsureValidFdsetBit_Fail\@:
    MOVE.L \3,D3
    RestoreStackFunction
    Ret_Int
    ENDM

LeaFdset MACRO
    MOVE.L \1,-(SP)
    Dlea fd_sets,\2 ; base of all, these are longs
    ROL.L #3,\1     ; multiply by 8
    ADD.L \1,\2     ; add to base of all
    MOVE.L (SP)+,\1
    ENDM

; LeaFdsetForBit fd_set reg,target address,target bit in address
LeaFdsetForBit MACRO
  LeaFdset \1,\2 ; get fdset base address in \2
  MOVEM.L D3-D4,-(SP)
    MOVE.L \3,D3 ; Put target bit into D3
    ROR.L #5,D3  ; lop off the first 5 bits
    AND.L #$7,D3 ; only keep the top three
    ROL.L #2,D3  ; multiply by 4
    ADD.L D3,\2  ; add that value to the fdset address

    MOVE.L \3,D4
    AND.L #$1F,D4 ; only keep 0-31 in \3

    MOVEQ #1,D3
    ROL.L D4,D3   ; shift that bit left as many as target
    MOVE.L D3,\3  ; put that in the target
  MOVEM.L (SP)+,D3-D4

  ENDM

; d0 = value to be divided
; d1 = divisor
; returns:
; d0 = divided value
; d1 = remainder
LongDivideD0ByD1 MACRO
  CMP.L D0,D1
  BMI _LongDivide_StartDivide\@

  MOVE.L D0,D1
  MOVEQ #0,D0
  BRA _LongDivide_Skip\@

_LongDivide_StartDivide\@:

  MOVEM.L D2-D4,-(SP)
    MOVEQ #0,D2      ; remainder
    MOVE.L #31,D3    ; bit tracking
                     ; d4 tracks the status register

_LongDivide_ContinueDivide\@:
    ASL.L #1,D0
    SCS D4      ; bit that got rolled out
    AND.L #1,D4
    ROL.L #1,D2
    ADD.L D4,D2 ; roll the value onto the remainder

    MOVE.L D2,D4
    SUB.L D1,D4

    BMI _LongDivide_NotDivisible\@
    ADDQ #1,D0
    MOVE.L D4,D2

_LongDivide_NotDivisible\@:
    DBRA D3,_LongDivide_ContinueDivide\@
    MOVE.L D2,D1
  MOVEM.L (SP)+,D2-D4

_LongDivide_Skip\@:
  ENDM

EvenOutStringAddress MACRO
    MOVE.W \1,\2
    AND.W #$0001,\2
    ADD.W \2,\1
    ENDM

; check if we've opened the bsd socket library
; we do this a lot, this could probably become something
; we jsr to...
; TODO make into routine
EnsureBSDSocketLibrary MACRO
    MOVEM.L A2,-(SP)
      Dload A2
      TST.L BSDSocketBase-MB(A2)
    MOVEM.L (SP)+,A2

    BNE \1

    MOVE.L #Error_LibraryNotOpen,D3
    ENDM

; TODO token casing consistency

Start   dc.l    C_Tk-C_Off
        dc.l    C_Lib-C_Tk
        dc.l    C_Title-C_Lib
        dc.l    C_End-C_Title
        ; don't copy first library routine unless needed
        dc.w    0
        ; API we're using
        dc.b    "AP20"

;---------------------------------------------------------------------
;       Creates the pointers to functions
;---------------------------------------------------------------------
        MCInit
C_Off
        REPT    Lib_Size
        MC
        ENDR

; make it way harder to get these confused
AddTokenInstruction MACRO
        dc.w L_\1,L_Nul
        ENDM

AddTokenFunction MACRO
        dc.w L_Nul,L_\1
        ENDM

******************************************************************
*   TOKEN TABLE + Addresses

;       TOKEN_START
C_Tk    dc.w    1,0
        dc.b    $80,-1

        AddTokenFunction SocketLibraryOpen
        dc.b    "socket library ope","n"+$80,"0",-1

        AddTokenInstruction SocketLibraryClose
        dc.b    "socket library clos","e"+$80,"I",-1

        AddTokenFunction SocketCreateInetSocket
        dc.b    "socket create inet socke","t"+$80,"0",-1

        AddTokenFunction SocketConnect
        dc.b    "socket connec","t"+$80,"00t2,0",-1

        AddTokenFunction SocketSendString
        dc.b    "socket send","$"+$80,"00,2",-1

        AddTokenFunction SocketBind
        dc.b    "socket bin","d"+$80,"00t2,0",-1

        AddTokenFunction SocketErrno
        dc.b    "socket errn","o"+$80,"0",-1

        AddTokenFunction SocketListen
        dc.b    "socket liste","n"+$80,"00",-1

        AddTokenFunction SocketAccept
        dc.b    "socket accep","t"+$80,"00",-1

        AddTokenFunction SocketSetNonblocking
        dc.b    "socket set nonblockin","g"+$80,"00,0",-1

        AddTokenFunction SocketSetsockoptInt
        dc.b    "socket setsockopt in","t"+$80,"00,0,0",-1

        AddTokenFunction SocketFdsetZero
        dc.b    "socket fdset zer","o"+$80,"00",-1

        AddTokenFunction SocketFdsetSet
        dc.b    "socket fdset se","t"+$80,"00,0t0",-1

        AddTokenFunction SocketFdsetIsSet
        dc.b    "socket fdset is se","t"+$80,"00,0",-1

        AddTokenFunction SocketSelect
        dc.b    "socket selec","t"+$80,"00,0,0,0,0",-1

        AddTokenFunction SocketGetDebugArea
        dc.b    "socket get debug are","a"+$80,"0",-1

        AddTokenFunction SocketGetHost
        dc.b    "socket get hos","t"+$80,"00",-1

        AddTokenFunction SocketInetNtoA
        dc.b    "socket inet ntoa","$"+$80,"20",-1

        AddTokenFunction SocketRecvString
        dc.b    "socket recv","$"+$80,"20,0",-1

        AddTokenFunction SocketRecvData
        dc.b    "socket rec","v"+$80,"00t0,0",-1

        AddTokenFunction SocketGetPort
        dc.b    "socket get por","t"+$80,"00",-1

        AddTokenFunction SocketGetsockoptInt
        dc.b    "socket getsockopt in","t"+$80,"00,0",-1

        AddTokenFunction SocketSendData
        dc.b    "socket sen","d"+$80,"00,0,0",-1

        AddTokenFunction SocketWaitAsyncWriting
        dc.b    "socket wait async writin","g"+$80,"00,0",-1

        AddTokenFunction SocketWaitAsyncReading
        dc.b    "socket wait async readin","g"+$80,"00,0",-1

        AddTokenFunction SocketReuseAddr
        dc.b    "socket reuse add","r"+$80,"00",-1

        AddTokenFunction DnsGetHostAddressByName
        dc.b    "dns get address by name","$"+$80,"22",-1

        AddTokenFunction SocketSetTimeout
        dc.b    "socket set timeou","t"+$80,"00,0",-1

        AddTokenFunction SocketCloseSocket
        dc.b    "socket close socke","t"+$80,"00",-1

        AddTokenFunction SocketHerrno
        dc.b    "socket herrn","o"+$80,"0",-1

;       TOKEN_END
        dc.w    0
        dc.l    0          ; Important!


;---------------------------------------------------------------------
    Lib_Ini 0
;---------------------------------------------------------------------

C_Lib

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   COLD START
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def Cold
; - - - - - - - - - - - - -
    cmp.l   #"APex",d1          Version 1.10 or over?
    bne.s   BadVer
    movem.l a3-a6,-(sp)

    ; ensure we can get to our data area
    lea MB(pc),a2
    move.l a2,ExtAdr+ExtNb*16(a5)

    ; cleanup on exit code in editor
    lea Warm(pc),a0
    move.l  a0,ExtAdr+ExtNb*16+4(a5)

    ; cleanup when shutting down program
    lea End(pc),a0
    move.l  a0,ExtAdr+ExtNb*16+8(a5)

    movem.l (sp)+,a3-a6
    moveq   #ExtNb,d0       ; * NO ERRORS
    move.w  #VerNumber,d1   ; * Current version
    rts
; In case this extension is runned on AMOSPro V1.00
BadVer  moveq   #-1,d0      ; * Bad version number
    sub.l   a0,a0
    rts

MB:
BSDSocketBase       dc.l 0 ; library base

IoctlSockOptScratch ds.l 2
len_sockaddr_in_ptr dc.l len_sockaddr_in

MaxFd_sets          EQU 16
fd_sets             dcb.l (MaxFd_sets*2),0
select_timeval      dcb.l 2,0
timeout_timeval     dcb.l (MAX_SOCKETS*2),0
getsockopt_len      ds.l 1

MaxSocketSeen       dc.w 0

sockaddr_ram        ds.l 1

; also used for errno tags
AcceptScratchArea   ds.b 16
SelectScratchArea   ds.l 2

DebugArea           dcb.l 8,0

BSDSocketLibrary    dc.b "bsdsocket.library",0
INADDR_ANY_String   dc.b "INADDR_ANY",0
     even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   SCREEN RESET: back to AMOS requester (Called by AMOSPro)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Warm
; - - - - - - - - - - - - -
    Rbsr L_DoSocketLibraryClose
    rts

; Program shutdown
End
    Rbsr L_DoSocketLibraryClose
    rts

;--------------------------------------------------------------------

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Leave one empty routine here!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Empty
; - - - - - - - - - - - - -


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Library Open
;
;   Attempt to open bsdsocket.library version 4
;
;   @return int address of library if opened, 0 if opening failed
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketLibraryOpen
; - - - - - - - - - - - - -
    PreserveStackInstruction

   ; ensure the library is closed before we try to reopen it
    Rbsr L_DoSocketLibraryClose

    Dload A3
    MOVEQ #4,D0
    Dlea BSDSocketLibrary,A1
    MOVEA.L 4,A6
    CALLLIB OpenLibrary

    MOVE.L D0,BSDSocketBase-MB(A3)
    BEQ _SocketLibraryOpen_Finish

    ; reserve ram for sockaddr_ins
    MOVE.L #MAX_SOCKETS*len_sockaddr_in,D0
    Rjsr L_RamFast
    BEQ _SocketLibraryOpen_Finish

    MOVE.L D0,sockaddr_ram-MB(A3)

_SocketLibraryOpen_Finish:
    MOVE.L BSDSocketBase-MB(A3),D3

    RestoreStackInstruction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Socket Library Close
;
;   Close bsdsocket.library if it was opened before. Does nothing if it's not.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketLibraryClose
; - - - - - - - - - - - - -
    PreserveStackInstruction

    Rbsr L_DoSocketLibraryClose

    RestoreStackInstruction
    RTS


; Utility functions


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   DoSocketSockaddrFree(sockaddr address D3)
;
;   Free memory from sockaddrin
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    Lib_Def DoSocketSockaddrFree

    MOVEM.L A1/D0,-(SP)
      MOVE.L D3,A1 ; address
      MOVE.L #len_sockaddr_in,D0
      Rjsr L_RamFree
    MOVEM.L (SP)+,A1/D0

    RTS


; - - - - -  - - - - -
; d0 = SocketIPAddressPortToSockaddr(socket d0, ip address d1, port d2)
;
; Turn an IP address and port into a sockaddr_in strucure
;
; d0 - address of sockaddr_in on success, -1 on failure
; - - - - - - - -
    Lib_Def SocketIPAddressPortToSockaddr

    ; bail early if the port is too big
    CMP.L #65535,D2
    BLS _ToSockaddr_PortOK

    MOVE.L #Error_PortOutOfRange,D0
    RTS

_ToSockaddr_PortOK:

    MOVEM.L A0/A3/D3,-(SP)

      Dload A3
      MOVE.L #len_sockaddr_in,D3
      MULU D0,D3  ; D0 is socket
      MOVE.L sockaddr_ram-MB(A3),A0
      ADD.L D3,A0 ; A0 contains our offset in ram

      MOVEM.L A0-A3/D3,-(SP)
        MOVE.L D1,A1    ; ip string address
        MOVE.W (A1)+,D3 ; string length

        BNE _ToSockaddr_StringHasLength
      MOVEM.L (SP)+,A0-A3/D3
    MOVEM.L (SP)+,A0/A3/D3

    MOVE.L #-14,D0
    RTS

_ToSockaddr_StringHasLength:

        ; temporarily store a null-terminated copy of the ip string in A0
        MOVE.L A0,A2
        SUBQ #1,D3      ; DBRA loop runs D3 + 1 times
_ToSockaddr_CopyIPString:
        MOVE.B (A1)+,(A2)+
        DBRA D3,_ToSockaddr_CopyIPString
        MOVE.B #0,(A2)  ; end of string

        ; if the string contains "INADDR_ANY", we use that value instead
        MOVE.L A0,A1
        Dlea INADDR_ANY_String,A2
        MOVEQ #0,D3

_ToSockaddr_KeepCheckingString_1:
        MOVE.B (A2)+,D3
        BNE _ToSockaddr_KeepCheckingString_2

        MOVE.L #INADDR_ANY,D0
        BRA _ToSockaddr_DoneParsing

_ToSockaddr_KeepCheckingString_2:
        CMP.B (A1)+,D3
        BEQ _ToSockaddr_KeepCheckingString_1

_ToSockaddr_ParseIPAddress:
        Dload A3
        LoadBSDSocketBase
        CALLLIB inet_addr

_ToSockaddr_DoneParsing:
      MOVEM.L (SP)+,A0-A3/D3

      ; create struct sockaddr_in
      MOVE.B #len_sockaddr_in,(A0)
      MOVE.B #AF_INET,sockaddr_in_sin_family(A0)
      MOVE.W D2,sockaddr_in_sin_port(A0)
      LEA sockaddr_in_sin_addr(A0),A3
      MOVE.L D0,(A3)+
      CLR.L (A3)+
      CLR.L (A3)+

      MOVE.L A0,D0
    MOVEM.L (SP)+,A0/A3/D3
    RTS

; basics

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Create Inet Socket
;
;   Create an Internet-ready socket, the one you're most
;   likely wanting to create.
;
;   @return number of socket, -1 on failure, -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketCreateInetSocket
; - - - - - - - - - - - - -
    PreserveStackInstruction

    EnsureBSDSocketLibrary _SocketCreateInetSocket_LibraryOpen

    RestoreStackInstruction
    Ret_Int

_SocketCreateInetSocket_LibraryOpen:

    MOVE.L #PF_INET,D0
    MOVE.L #SOCK_STREAM,D1
    MOVE.L #IPPROTO_TCP,D2
    Dload A3
    LoadBSDSocketBase
    CALLLIB socket

    MOVE.L D0,D3

    ; if this socket number is higher than the last one we've seen
    ; increment it
    BMI _SocketCreateInetSocket_Done

    MOVEQ #0,D1
    MOVE.W MaxSocketSeen-MB(A3),D1
    CMP.L D0,D1
    BGT _SocketCreateInetSocket_Done

    MOVE.W D0,MaxSocketSeen-MB(A3)
    

_SocketCreateInetSocket_Done:

    RestoreStackInstruction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Connect(LONG SocketID to String IP Address, LONG Port)
;
;   Connect a socket to a remote IP address and port.
;
;   @return:
;     0 on connect
;     -1 on other error
;     -2 on library not open
;     -11 on port out of range
;     -12 on unable to connect
;     -13 on unable to allocate ram for sockaddr
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketConnect
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D2    ; port
    MOVE.L (A3)+,D1 ; ip address
    MOVE.L (A3)+,D0 ; socket id

    EnsureBSDSocketLibrary _SocketConnect_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketConnect_LibraryOpen:
    MOVE.L D0,-(SP) ; socket id onto stack

      Rbsr L_SocketIPAddressPortToSockaddr
      TST.L D0
      BGT _SocketConnect_SockaddrIn

    MOVE.L (SP)+,D1

    MOVE.L D0,D3
    RestoreStackFunction
    Ret_Int

_SocketConnect_SockaddrIn:

      MOVE.L D0,A0
    MOVE.L (SP)+,D0

    MOVE.L D0,-(SP)
      MOVEM.L A0/A3,-(SP)
        Dload A3
                                   ; socket id is in D0
                                   ; sockaddr_in is in A0
        MOVE.L #len_sockaddr_in,D1 ; len
        LoadBSDSocketBase
        CALLLIB connect
      MOVEM.L (SP)+,A0/A3

      MOVE.L D0,D3
    MOVE.L (SP)+,D0

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Send$(LONG SocketID, String Data)
;
;   Send a string to a connected socket
;
;   @return:
;     number of characters sent
;     -1 on other error
;     -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSendString
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,A0    ; string
    MOVE.L (A3)+,D0 ; socket id
    MOVE.W (A0)+,D1 ; string length, increment pointer

    EnsureBSDSocketLibrary _SocketSendString_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketSendString_LibraryOpen:
   MOVEQ #0,D2     ; flags

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB send
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Send(LONG SocketID, void * Data, LONG length)
;
;   Send a block of data to a connected socket
;
;   @return:
;     number of characters sent
;     -1 on other error
;     -2 on library not open
;     -3 on negative length
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSendData
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D1    ; length
    MOVE.L (A3)+,A0 ; data
    MOVE.L (A3)+,D0 ; socket

    EnsureBSDSocketLibrary _SocketSendData_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketSendData_LibraryOpen:
    TST.L D1
    BGE _SocketSendData_NotNegative

    MOVE.L #-3,D3

    RestoreStackFunction
    Ret_Int

_SocketSendData_NotNegative:
    MOVEQ #0,D2     ; flags

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB send
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Bind(LONG SocketID to String IP Address, LONG Port)
;
;   Bind a socket to a local IP address and port
;
;   @return:
;     0 on success
;     -1 on other error
;     -2 on library not open
;     -11 on port out of range
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketBind
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D2    ; port
    MOVE.L (A3)+,D1 ; ip address
    MOVE.L (A3)+,D0 ; socket id

    EnsureBSDSocketLibrary _SocketBind_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketBind_LibraryOpen:
    ; store current socket id for later
    MOVE.L D0,-(SP)

      Rbsr L_SocketIPAddressPortToSockaddr
      TST.L D0
      BGE _SocketBind_SockaddrIn

    MOVE.L (SP)+,D1
    MOVE.L D0,D3
    RestoreStackFunction
    Ret_Int

_SocketBind_SockaddrIn:
      MOVE.L D0,A0
    MOVE.L (SP)+,D0

    WithDataStorage
      ; socket id is in D0
      ; sockaddr_in is in A0
      MOVE.L #len_sockaddr_in,D1 ; len
      LoadBSDSocketBase
      CALLLIB bind
    EndDataStorage

    MOVE.L D0,D3
    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Errno
;
;   Get the BSDSocket error number of the last failed command
;
;   @return:
;     Last BSD Socket error
;     -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketErrno
; - - - - - - - - - - - - -
    PreserveStackFunction

    EnsureBSDSocketLibrary _SocketErrno_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketErrno_LibraryOpen:
    WithDataStorage
      LoadBSDSocketBase
      CALLLIB Errno
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    RTS

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Listen(Socket ID LONG)
;
;   Start listening on a socket
;
;   @return:
;     0 on sucess
;     -1 on failure
;     -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketListen
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D0 ; Socket ID

    EnsureBSDSocketLibrary _SocketListen_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketListen_LibraryOpen:
   MOVE.L D3,D2
    MOVEQ #5,D1

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB listen
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    RTS

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Accept(Socket ID LONG)
;
;   Accept a connection on a socket. This is blocking unless you set
;   Ioctl to be non-blocking!
;
;   @return:
;     remote socket
;     -1 on failure
;     -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketAccept
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D0 ; socket

    EnsureBSDSocketLibrary _SocketAccept_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketAccept_LibraryOpen:

   MOVE.L D3,D2

    WithDataStorage
      Dlea AcceptScratchArea,A0
      Dlea len_sockaddr_in_ptr,A1
      LoadBSDSocketBase
      CALLLIB accept
    EndDataStorage

    MOVE.L D0,D3
    BMI _SocketAccept_Failed

    Dload A0

    ; update highest socket number seen
    MOVEQ #0,D1
    MOVE.W MaxSocketSeen-MB(A0),D1
    CMP.L D0,D1

    BGT _SocketAccept_CopySockaddrIn
    MOVE.W D0,MaxSocketSeen-MB(A0)

_SocketAccept_CopySockaddrIn:
    ; we're putting sockaddr in info into our own storage area
    MOVE.L D0,D1 ; new socket in d1
    MULU #len_sockaddr_in,D1
    MOVE.L sockaddr_ram-MB(A0),A0
    ADD.L D1,A0  ; new socket sockaddr_in target in A0

    Dlea AcceptScratchArea,A1
    MOVEQ #len_sockaddr_in,D1
    SUBQ #1,D1
_SocketAccept_CopyLoop:
    MOVE.B (A1)+,(A0)+
    DBRA D1,_SocketAccept_CopyLoop

_SocketAccept_Failed:
    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Set Nonblocking(Socket ID LONG, Mode BOOLEAN)
;
;   Configure a socket to be nonblocking (true) or blocking (false)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSetNonblocking
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L (A3)+,D0 ; socket
    MOVE.L D3,D1    ; mode

    EnsureBSDSocketLibrary _SocketSetNonblocking_LibraryOpen

    RestoreStackFunction
    RTS

_SocketSetNonblocking_LibraryOpen:
    TST.L D1
    BEQ _SocketSetNonblocking_IsBlocking
    MOVEQ #1,D1
    BRA _SocketSetNonblocking_Ioctl

_SocketSetNonblocking_IsBlocking:
    MOVEQ #0,D1

_SocketSetNonblocking_Ioctl:

    WithDataStorage
      MOVE.L D1,IoctlSockOptScratch-MB(A3)
      Dlea IoctlSockOptScratch,A0
      MOVE.L #FIONBIO,D1
      LoadBSDSocketBase
      CALLLIB IoctlSocket
      
      MOVE.L D0,D3
    EndDataStorage

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Setsockopt Int(Socket ID LONG, Option LONG, Value LONG)
;
;   Set a socket option
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSetsockoptInt
; - - - - - - - - - - - - -
    PreserveStackFunction

                    ; Value is in D3
    MOVE.L (A3)+,D2 ; Option
    MOVE.L (A3)+,D0 ; Socket ID

    EnsureBSDSocketLibrary _SocketSetsockoptInt_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketSetsockoptInt_LibraryOpen:
    Rbsr L_SetSockoptInt

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Getsockopt Int(Socket ID LONG, Option LONG)
;
;   Get a socket option's value
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketGetsockoptInt
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D2          ; option
    MOVE.L (A3)+,D0       ; socket

    EnsureBSDSocketLibrary _SocketGetsockoptInt_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketGetsockoptInt_LibraryOpen:
    MOVE.L #SOL_SOCKET,D1 ; level

    MOVE.L A3,-(SP)
      WithDataStorage
        Dlea IoctlSockOptScratch,A0 ; optval
        MOVE.L #4,getsockopt_len-MB(A3)
        Dlea getsockopt_len,A1

        LoadBSDSocketBase
        CALLLIB getsockopt
      EndDataStorage
    MOVE.L (SP)+,A3

    MOVE.L D0,D3
    BPL _SocketGetsockoptInt_GetValue

    RestoreStackFunction
    Ret_Int

_SocketGetsockoptInt_GetValue
    Dlea IoctlSockOptScratch,A0
    MOVE.L (A0),D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Fdset Zero(fd_set LONG)
;
;   Clear out the indicated fd_set.
;
;   @return Address of fd_set (2 longs), -1 if our of range, -2 no library
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketFdsetZero
; - - - - - - - - - - - - -
    PreserveStackFunction
    EnsureBSDSocketLibrary _SocketFdsetZero_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketFdsetZero_LibraryOpen:
    EnsureValidFdset D3,_SocketFdsetZero_ClearFdset

_SocketFdsetZero_ClearFdset
    LeaFdset D3,A0
    MOVE.L A0,D3
    CLR.L (A0)+
    CLR.L (A0)+

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Fdset Set(fd_set LONG, bit LONG to value BOOL)
;
;   Set or unset an fd_set's bit
;
;   @return Address of fd_set (2 longs), -1 if out of range, -2 no library
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketFdsetSet
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D2    ; value
    MOVE.L (A3)+,D1 ; bit
    MOVE.L (A3)+,D0 ; fd_set

    EnsureBSDSocketLibrary _SocketFdsetSet_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketFdsetSet_LibraryOpen:
    EnsureValidFdset D0,_SocketFdsetSet_CheckBit

_SocketFdsetSet_CheckBit:
    EnsureValidFdsetBit D1,_SocketFdsetSet_CheckNegative,#Error_FdsetOutOfRange

_SocketFdsetSet_CheckNegative:
    CMP.L #0,D1
    BGE _SocketFdsetSet_SetFdset

    MOVE.L #Error_FdsetOutOfRange,D3

    RestoreStackFunction
    Ret_Int

_SocketFdsetSet_SetFdset:
    ; get correct fdset

    MOVE.L A0,-(SP)
      LeaFdsetForBit D0,A0,D1 ; D1 contains bit mask

      TST.L D2         ; zero/false for clearing
      BEQ _SocketFdsetSet_Clear

      ; setting
      MOVE.L (A0),D3
      OR.L D1,D3
      BRA _SocketFdsetSet_Done

_SocketFdsetSet_Clear:
      MOVE.L #$FFFFFFFF,D4
      SUB.L D1,D4

      MOVE.L (A0),D3
      AND.L D4,D3

_SocketFdsetSet_Done:
      MOVE.L D3,(A0)
    MOVE.L (SP)+,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Fdset Is Set(fd_set LONG, Bit LONG)
;
;   Return the status of a bit in an fd_set.
;
;   @return 0 if not set, -1 if it is set, -2 on library not open
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketFdsetIsSet
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D1    ; bit
    MOVE.L (A3)+,D0 ; fdset

    EnsureBSDSocketLibrary _SocketFdsetIsSet_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketFdsetIsSet_LibraryOpen:
    EnsureValidFdset D0,_SocketFdsetIsSet_CheckBit

_SocketFdsetIsSet_CheckBit:
    EnsureValidFdsetBit D1,_SocketFdsetIsSet_CheckNegative,#Error_FdsetOutOfRange

_SocketFdsetIsSet_CheckNegative:
    CMP.L #0,D1
    BGE _SocketFdsetIsSet_CheckFdsetBit

    MOVE.L #Error_FdsetOutOfRange,D1

    RestoreStackFunction
    Ret_Int

_SocketFdsetIsSet_CheckFdsetBit:
    ; get correct fdset
    LeaFdsetForBit D0,A0,D1 ; D1 contains bit mask

    MOVE.L (A0),D3
    AND.L D1,D3    ; compare mask to value

    BNE _SocketFdsetIsSet_IsSet

    MOVEQ #0,D3
    BRA _SocketFdsetIsSet_Done

_SocketFdsetIsSet_IsSet:
    MOVE.L #-1,D3

_SocketFdsetIsSet_Done:
    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Select(Max Socket long, Read fd_set long, Write fd_set long, error fd_set long, ms timeout long)
;
;   Wait on the socket identifiers in the fd_sets, until the timeout expires.
;
;   @return
;     -2 on library not open
;     -20 on read fd_set out of range
;     -21 on write fd_set out of range
;     -22 on error fd_set out of range
;     -23 on ms must be positive
;     number of sockets found on success
;     0 on timeout
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSelect
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D4    ; ms timeout
    MOVE.L (A3)+,D3 ; error fd_set
    MOVE.L (A3)+,D2 ; write fd_set
    MOVE.L (A3)+,D1 ; read fd_set
    MOVE.L (A3)+,D0 ; fd count

    EnsureBSDSocketLibrary _SocketSelect_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketSelect_LibraryOpen:
    EnsureValidFdsetBit D1,_SocketSelect_CheckWrite,#-20

_SocketSelect_CheckWrite:
    EnsureValidFdsetBit D2,_SocketSelect_CheckError,#-21

_SocketSelect_CheckError:
    EnsureValidFdsetBit D3,_SocketSelect_CheckTimeout,#-22

_SocketSelect_CheckTimeout:
    CMP.L #0,D4
    BGE _SocketSelect_MaybeReadFdset

    MOVE.L #-23,D3

    RestoreStackFunction
    Ret_Int

_SocketSelect_MaybeReadFdset:
    MOVE.L #0,A0
    CMP.L #-1,D1
    BEQ _SocketSelect_MaybeWriteFdset
    LeaFdset D1,A0

_SocketSelect_MaybeWriteFdset
    MOVE.L #0,A1
    CMP.L #-1,D2
    BEQ _SocketSelect_MaybeErrorFdset
    LeaFdset D2,A1

_SocketSelect_MaybeErrorFdset
    MOVE.L #0,A2
    CMP.L #-1,D3
    BEQ _SocketSelect_PerformSelect
    LeaFdset D3,A2

_SocketSelect_PerformSelect
    MOVE.L A3,-(SP)
                                   ; D4 contains microseconds
      Rbsr L_MicrosecondsToTimeval ; A3 contains select_timeval

      MOVEQ #0,D1

      Dload A4

      MOVE.L BSDSocketBase-MB(A4),A6
      CALLLIB WaitSelect
    MOVE.L (SP)+,A3

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Get Debug Area
;
;   Get the memory location for debug info. Put stuff in debug area while
;   working on this extension and look it up in AMOS later.
;
;   @return address of debug area
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketGetDebugArea
; - - - - - - - - - - - - -
    PreserveStackFunction

    Dlea DebugArea,A0
    MOVE.L A0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Get Host(Socket LONG)
;
;   Get the host long value for this socket's sockaddr_in.
;
;   @return host long value
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketGetHost
; - - - - - - - - - - - - -
    PreserveStackFunction

    EnsureBSDSocketLibrary _SocketGetHost_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketGetHost_LibraryOpen:
    MULU #len_sockaddr_in,D3
    Dload A0
    MOVE.L sockaddr_ram-MB(A0),A0
    ADD.L D3,A0
    MOVE.L sockaddr_in_sin_addr(A0),D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Get Port(Socket LONG)
;
;   Get the port word value for this socket's sockaddr_in.
;
;   @return port word value
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketGetPort
; - - - - - - - - - - - - -
    PreserveStackFunction

    EnsureBSDSocketLibrary _SocketGetPort_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketGetPort_LibraryOpen:

    MULU #len_sockaddr_in,D3
    Dload A0
    MOVE.L sockaddr_ram-MB(A0),A0
    ADD.L D3,A0
    MOVEQ #0,D3
    MOVE.W sockaddr_in_sin_port(A0),D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Inet Ntoa$(host LONG)
;
;   Turn a host into a string
;
;   @return host long value
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketInetNtoA
; - - - - - - - - - - - - -
    PreserveStackFunction
    EnsureBSDSocketLibrary _SocketInetNtoa_LibraryOpen

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_SocketInetNtoa_LibraryOpen:
    MOVE.L D3,D0
    WithDataStorage
      LoadBSDSocketBase
      CALLLIB Inet_NtoA
    EndDataStorage

    MOVEQ #0,D3
    MOVE.L D0,A0
    MOVE.L D0,A2 ; A0/A1 will get nuked by L_Demande

_SocketInetNtoA_StringSizeLoop:
    TST.B (A0)+
    BNE _SocketInetNtoA_StringSizeLoop

    MOVE.L A0,D4
    SUB.L A2,D4 ; D4 = length
    SUBQ #1,D4 ; get rid of the null terminator

    ; add 2 and even out the space
    MOVE.L D4,D3
    AND.W #$FFFE,D3
    ADDQ.W #2,D3

    Rjsr L_Demande ; string base address is in A0/A1

    LEA 2(A0,D3.W),A1

    MOVE.L A1,HiChaine(A5)
    MOVE.L A0,A1

    MOVE.W D4,(A0)+ ; length of string
    SUBQ #1,D4

_SocketInetNtoA_StringCopyLoop:
    MOVE.B (A2,D4),(A0,D4)
    DBRA D4,_SocketInetNtoA_StringCopyLoop

    MOVE.L A1,D3 ; string return

    RestoreStackFunction
    Ret_String

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Recv$(socket LONG, max length LONG)
;
;   Receive at most length bytes of data from the socket
;
;   @return string of bytes
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketRecvString
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L (A3)+,D1 ; socket
    MOVE.L D3,D0    ; length

    EnsureBSDSocketLibrary _SocketRecvString_LibraryOpen

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_SocketRecvString_LibraryOpen:
    TST.L D0
    BGT _SocketRecvString_NotNegative

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_SocketRecvString_NotNegative:
    CMP.L #65536,D0
    BLT _SocketRecvString_NotTooLong

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_SocketRecvString_NotTooLong:
    MOVE.L A3,-(SP) ; preserve A3

      MOVE.L D0,-(SP) ; preserve D0
        ; reserve memory for recv buffer
        Rjsr L_RamFast ; D0 now contains memory pointer
        BNE _SocketRecvString_BufferAllocated
        ; reserve failed
      MOVE.L (SP)+,D0

    MOVE.L (SP)+,A3

    MOVE.L ChVide(A5),D3 ; empty string
    RestoreStackFunction
    Ret_String

_SocketRecvString_BufferAllocated:
        MOVE.L D0,A0  ; buffer address
        MOVE.L D1,D0  ; socket
      MOVE.L (SP)+,D1 ; reserved ram buffer length
      MOVEQ #0,D2     ; flags

      MOVEM.L A0-A1/D1,-(SP)

        WithDataStorage
          LoadBSDSocketBase
          CALLLIB recv ; D0 has received length or -1
        EndDataStorage

      MOVEM.L (SP)+,A0-A1/D1

      ; did we receive data? if we didn't get a single byte, we're done
      TST.L D0
      BGT _SocketRecvString_DataReceived

      ; free ram
      MOVE.L D1,D0
      MOVE.L A0,A1
      Rjsr L_RamFree

    MOVE.L (SP)+,A3

    MOVE.L ChVide(A5),D3
    RestoreStackFunction
    Ret_String

    ; TODO received data is wrong somewhere
_SocketRecvString_DataReceived:
      ; D0 contains socket receive length

      ; TODO: handle zero return length

      MOVE.L A0,A2 ; A2 contains read buffer

      MOVE.L D1,-(SP) ; reserved ram buffer length
        ; demande/hichaine string setup
        MOVEQ #0,D3
        MOVE.W D0,D3
        AND.W #$FFFE,D3
        ADDQ #2,D3
        Rjsr L_Demande ; A0/A1 contain string address

        LEA 2(A0,D3.W),A1
        MOVE.L A1,HiChaine(A5)
        MOVE.L A0,A1

        MOVE.W D0,(A1)+ ; put in string length
        SUBQ #1,D0      ; reduce by one for DBRA
        MOVE.L A2,A3    ; A3 now contains start of buffer

_SocketRecvString_CopyData:
        MOVE.B (A2,D0),(A1,D0)
        DBRA D0,_SocketRecvString_CopyData
      MOVE.L (SP)+,D0 ;  reserved ram buffer length

      MOVE.L A0,-(SP)
        MOVE.L A3,A1
        Rjsr L_RamFree
      MOVE.L (SP)+,D3 ; string return
    MOVE.L (SP)+,A3

    RestoreStackFunction
    Ret_String


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Recv(socket LONG to address LONG, max size LONG)
;
;   Receive at most length bytes of data from the socket into an existing
;   memory area
;
;   @return length read, -? on failure
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketRecvData
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D1    ; length
    MOVE.L (A3)+,A0 ; address
    MOVE.L (A3)+,D0 ; socket
    MOVEQ #0,D2     ; flags

    EnsureBSDSocketLibrary _SocketRecvData_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketRecvData_LibraryOpen:
    TST.L D1
    BGT _SocketRecvData_PositiveLength

    MOVE.L #-3,D3

    RestoreStackFunction
    Ret_Int

_SocketRecvData_PositiveLength:
    WithDataStorage
      LoadBSDSocketBase
      CALLLIB recv ; D0 has received length or -1
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int



    ; actually close the library

    Lib_Def DoSocketLibraryClose

    Dload A3
    TST.L sockaddr_ram-MB(A3)
    BEQ _DoSocketLibraryClose_CloseLibrary

    MOVE.L sockaddr_ram-MB(A3),A1
    MOVE.L #MAX_SOCKETS*len_sockaddr_in,D0
    Rjsr L_RamFree
    CLR.L sockaddr_ram-MB(A3) ; prevent double free

_DoSocketLibraryClose_CloseLibrary:

    MOVE.L BSDSocketBase-MB(A3),D0

    BEQ _DoSocketLibraryClose_Skip
    CLR.L BSDSocketBase-MB(A3) ; prevent double free

    MOVE.L D0,A1
    MOVE.L 4,A6
    CALLLIB CloseLibrary

_DoSocketLibraryClose_Skip:
    RTS

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Wait Async Writing(Socket long, ms timeout long)
;
;   Wait for this socket to be ready for writing, with a timeout
;
;   @return
;     1 on success
;     -1 on error, check Socket Errno
;     -2 on library not open
;     -3 on not interesting yet
;     0 on timeout
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketWaitAsyncWriting
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D4    ; ms timeout
    MOVE.L (A3)+,D0 ; socket

    EnsureBSDSocketLibrary _SocketWaitAsyncWriting_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncWriting_LibraryOpen:
    MOVEM.L A3-A4,-(SP)
      Dload A4

      MOVE.L D4,-(SP)
        MOVEQ #0,D1
        LeaFdset D1,A0
        ; Clear fdset
        CLR.L (A0)+
        CLR.L (A0)+

        ; we'll use the first FdSet
        MOVE.L D0,D2
        LeaFdsetForBit D1,A0,D2
        MOVE.L D2,(A0)
      MOVE.L (SP)+,D4

      Rbsr L_MicrosecondsToTimeval ; A3 contains timeval

      Dload A4
      MOVEM.L D0,-(SP)
        ; set up WaitSelect
        MOVEQ #0,D1
        LeaFdset D1,A1 ; write fdset

        MOVE.L #0,A0   ; read fdset
        MOVE.L #0,A2   ; error fdset
        MOVEQ #0,D0
        MOVE.W MaxSocketSeen-MB(A4),D0
        ADDQ #1,D0                     ; number of file descriptors + 1
        MOVEQ #0,D1    ; mask

        MOVE.L BSDSocketBase-MB(A4),A6
        CALLLIB WaitSelect

        ; returns:
        ; * 0 on timeout
        ; * >0 on socket was seen
        ; * -1 on error
        TST.L D0
        BEQ _SocketWaitAsyncWriting_Timeout
        BMI _SocketWaitAsyncWriting_Error
      MOVEM.L (SP)+,D0 ; D0 contains socket again

      Dload A4
      ; a socket became interesting, check the Fdset
      MOVE.L D0,-(SP)
        MOVE.L D0,D3               ; socket in D3
        MOVEQ #0,D1                ; fdset in D1
        LeaFdsetForBit D1,A0,D3    ; A0 is mem, D3 is mask
        AND.L D3,(A0)              ; D3 should mask (A0)
        BEQ _SocketWaitAsyncWriting_CheckSockopt ; if yes, is ready
      MOVE.L (SP)+,D0

    ; not interesting yet
    MOVEM.L (SP)+,A3-A4
    MOVE.L #-3,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncWriting_CheckSockopt:
      MOVE.L (SP)+,D0     ; socket
      MOVE.L #$1007,D2    ; option
      MOVE.L #SOL_SOCKET,D1 ; level

      MOVE.L A3,-(SP)

        WithDataStorage
          Dlea IoctlSockOptScratch,A0 ; optval
          MOVE.L #4,getsockopt_len-MB(A3)
          Dlea getsockopt_len,A1

          LoadBSDSocketBase
          CALLLIB getsockopt
        EndDataStorage

      MOVE.L (SP)+,A3

      TST.L D0
      BMI _SocketWaitAsyncWriting_Error2

      Dlea IoctlSockOptScratch,A0
      MOVE.L (A0),D0
      BEQ _SocketWaitAsyncWriting_Ready

    ; still not ready
    MOVEM.L (SP)+,A3-A4
    MOVE.L #-3,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncWriting_Ready:
    MOVEM.L (SP)+,A3-A4
    MOVEQ #1,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncWriting_Error:
      MOVE.L (SP)+,D1
_SocketWaitAsyncWriting_Error2:
    MOVEM.L (SP)+,A3-A4

    MOVE.L #-1,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncWriting_Timeout:
      MOVE.L (SP)+,D1
    MOVEM.L (SP)+,A3-A4

    MOVEQ #0,D3

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Wait Async Reading(Socket long, ms timeout long)
;
;   Wait for this socket to be ready for reading, with a timeout
;
;   @return
;     1 on success
;     -2 on library not open
;     -3 on not interesting yet
;     0 on timeout
;     -1 on error
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketWaitAsyncReading
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D4    ; ms timeout
    MOVE.L (A3)+,D0 ; socket

    EnsureBSDSocketLibrary _SocketWaitAsyncReading_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncReading_LibraryOpen:
    MOVEM.L A3-A4,-(SP)
      Dload A4

      MOVE.L D4,-(SP)
        MOVEQ #0,D1
        LeaFdset D1,A0
        ; Clear fdset
        CLR.L (A0)+
        CLR.L (A0)+

        ; we'll use the first FdSet
        MOVE.L D0,D2
        LeaFdsetForBit D1,A0,D2
        MOVE.L D2,(A0)
      MOVE.L (SP)+,D4

      Rbsr L_MicrosecondsToTimeval ; A3 contains timeval

      Dload A4
      MOVE.L D0,-(SP)
        ; set up WaitSelect
        MOVEQ #0,D1
        LeaFdset D1,A0 ; read fdset

        MOVE.L #0,A1   ; write fdset
        MOVE.L #0,A2   ; error fdset
        MOVEQ #0,D0
        MOVE.W MaxSocketSeen-MB(A4),D0
        ADDQ #1,D0                     ; number of file descriptors + 1
        MOVEQ #0,D1

        MOVE.L BSDSocketBase-MB(A4),A6
        CALLLIB WaitSelect

        TST.L D0 ; timeout, pass through
        BEQ _SocketWaitAsyncReading_Done
        BMI _SocketWaitAsyncReading_Done
      MOVE.L (SP)+,D0 ; D0 contains socket again

      ; a socket became interesting, check the Fdset
      MOVE.L D0,D3               ; socket in D3
      MOVEQ #0,D1                ; fdset in D1
      LeaFdsetForBit D1,A0,D3    ; A0 is mem, D3 is mask
      AND.L D3,(A0)              ; D3 should mask (A0)
      BEQ _SocketWaitAsyncReading_Ready ; if yes, is ready

    ; not interesting yet
    MOVEM.L (SP)+,A3-A4
    MOVE.L #-3,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncReading_Ready:
    MOVEM.L (SP)+,A3-A4
    MOVEQ #1,D3

    RestoreStackFunction
    Ret_Int

_SocketWaitAsyncReading_Done:
      MOVE.L (SP)+,D1
    MOVEM.L (SP)+,A3-A4

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Reuse Addr(Socket ID LONG)
;
;   Specifically set the SO_REUSEADDR function on a socket
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketReuseAddr
; - - - - - - - - - - - - -
    PreserveStackFunction
    EnsureBSDSocketLibrary _SocketReuseAddr_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketReuseAddr_LibraryOpen:
    MOVE.L D3,D0
    MOVE.L #SO_REUSEADDR,D2
    MOVEQ  #1,D3

    Rbsr L_SetSockoptInt

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   A3 MicrosecondsToTimeval(Microseconds D4)
;
;   Create a Timeval struct from microseconds
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    Lib_Def MicrosecondsToTimeval

    MULU #1000,D4      ; we accept milliseconds
    ; turn this into seconds and microseconds via divide

    MOVEM.L D0/D1/A5,-(SP)
      MOVE.L D4,D0
      MOVE.L #1000000,D1

      LongDivideD0ByD1

      Dlea select_timeval,A3
      MOVE.L D0,(A3)+
      MOVE.L D1,(A3)+
    MOVEM.L (SP)+,D0/D1/A5
    Dlea select_timeval,A3

    RTS

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   D0 SetSockoptInt(Socket D0, Option D2, Value D3)
;
;   Set a socket option
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    Lib_Def SetSockoptInt

    MOVEM.L A0/D1-D3,-(SP)

      MOVE.L #SOL_SOCKET,D1 ; Level

      WithDataStorage
        Dlea IoctlSockOptScratch,A0 ; optval
        MOVE.L D3,A0
        MOVEQ #4,D3

        LoadBSDSocketBase
        CALLLIB setsockopt
      EndDataStorage

    MOVEM.L (SP)+,A0/D1-D3
    RTS


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Dns Get Address By Name$(Name String)
;
;   Convert a host name to an IP address
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par DnsGetHostAddressByName

    PreserveStackFunction
    EnsureBSDSocketLibrary _DnsGetHostAddressByName_LibraryOpen

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_DnsGetHostAddressByName_LibraryOpen:
    ; string so you need demande, hichaine, and chvide
    MOVE.L D3,A0 ; name
    MOVEQ #0,D0
    MOVE.W (A0)+,D0 ; d0 contains length
    MOVE.L D0,D1    ; d1 also has length
    MOVE.L D0,D2    ; d2 also has length
    Rjsr L_RamFast  ; d0 contains address
    BNE _DnsGetHostAddressByName_StringRamAllocated

    MOVE.L ChVide(A5),D3

    RestoreStackFunction
    Ret_String

_DnsGetHostAddressByName_StringRamAllocated:
    MOVE.L D0,A1 ; a1 contains address
    SUBQ #1,D1   ; reduce by one for DBRA

_DnsGetHostAddressByName_KeepCopyingAMOSString:
    MOVE.B (A0)+,(A1)+ ; byte copy
    DBRA D1,_DnsGetHostAddressByName_KeepCopyingAMOSString ; keep copying
    MOVE.B #0,(A1)+ ; null terminate string
    MOVE.L D0,A0 ; first param of gethostbyname

    MOVEM.L A0/D2,-(SP)
      WithDataStorage
        LoadBSDSocketBase
        CALLLIB gethostbyname
      EndDataStorage
    MOVEM.L (SP)+,A0/D2

    ; free the ram before we go any farther
    MOVE.L D0,-(SP)
      MOVE.L A0,A1
      MOVE.L D2,D0
      Rjsr L_RamFree
    MOVE.L (SP)+,D0

    TST.L D0
    BNE _DnsGetHostAddressByName_GetIPAddress

    RestoreStackFunction

    MOVE.L ChVide(A5),D3
    Ret_String

_DnsGetHostAddressByName_GetIPAddress:
    MOVE.L D0,A0
    MOVE.L 16(A0),A1 ; **h_addr_list
    MOVE.L (A1),A1 ; *h_addr_list
    MOVE.L (A1),D0 ; h_addr_list[0]

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB Inet_NtoA
    EndDataStorage

    MOVE.L D0,A2
    MOVE.L A2,-(SP)
      MOVEQ #0,D3

_DnsGetHostAddressByName_GetIPAddressLength:
      ADDQ #1,D3
      TST.B (A2)+
      BNE _DnsGetHostAddressByName_GetIPAddressLength
    MOVE.L (SP)+,A2

    SUBQ #1,D3
    MOVE.L D3,D4

    AND.W #$FFFE,D3
    ADDQ #2,D3

    Rjsr L_Demande ; string is in A0/A1
    LEA 2(A0,D3.W),A1
    MOVE.L A1,HiChaine(A5)
    MOVE.L A0,A1

    MOVE.W D4,(A1)+

    SUBQ #1,D4

_DnsGetHostAddressByName_KeepCopying:
    MOVE.B (A2)+,(A1)+
    DBRA D4,_DnsGetHostAddressByName_KeepCopying

    MOVE.L A0,D3

    RestoreStackFunction

    Ret_String

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Set Timeout(Socket ID LONG, ms Long)
;
;   Set SO_SNDTIMEO and SO_RCVTIMEO on a socket
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketSetTimeout
; - - - - - - - - - - - - -
    PreserveStackFunction

    MOVE.L D3,D4    ; milliseconts
    MOVE.L (A3)+,D0 ; socket id

    EnsureBSDSocketLibrary _SocketSetTimeout_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketSetTimeout_LibraryOpen:
    MOVE.L A3,-(SP)
      Rbsr L_MicrosecondsToTimeval
      MOVE.L A3,A0  ; select_timeval
    MOVE.L (SP)+,A3

    MOVE.L D0,D1 ; socket id
    ROL.L #1,D1  ; *2
    Dlea timeout_timeval,A1
    ADD.L D1,A1
    MOVE.L (A0)+,(A1)+ ; copy timeval
    MOVE.L (A0)+,(A1)+
    SUB.L #8,A1 ; go back

    WithDataStorage
      ; socket is d0
      MOVE.L #SOL_SOCKET,D1 ; Level
      MOVE.L #$1005,D2 ; SO_SNDTIMEO
      MOVE.L A1,A0 ; timeval
      MOVEQ #8,D3

      MOVEM.L D0/A0,-(SP)
        LoadBSDSocketBase
        CALLLIB setsockopt

        TST.L D0
        BNE _SocketSetTimeout_Fail
      MOVEM.L (SP)+,D0/A0 ; socket/timeval

      MOVE.L #SOL_SOCKET,D1
      MOVE.L #$1006,D2 ; SO_RCVTIMEO
      MOVEQ #8,D3

      LoadBSDSocketBase
      CALLLIB setsockopt

    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

_SocketSetTimeout_Fail:
      MOVEM.L (SP)+,D1/A0
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   =Socket Close Socket(Socket ID LONG)
;
;   Close a socket
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketCloseSocket
; - - - - - - - - - - - - -
    PreserveStackFunction
    EnsureBSDSocketLibrary _SocketCloseSocket_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketCloseSocket_LibraryOpen:

    MOVE.L D3,D0

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB CloseSocket
    EndDataStorage

    MOVE.L D0,D3

    RestoreStackFunction
    Ret_Int

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Int=Socket Herrno
;
;   Return Herrno value, errors related to DNS resolution
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par SocketHerrno
; - - - - - - - - - - - - -
    PreserveStackFunction
    EnsureBSDSocketLibrary _SocketHerrno_LibraryOpen

    RestoreStackFunction
    Ret_Int

_SocketHerrno_LibraryOpen:
    ; set up tag list memory and place for herrno to go
    Dlea AcceptScratchArea,A0
    MOVE.L A0,A2
    Dlea SelectScratchArea,A1

    ; build the tag list
    MOVE.L HerrnoTag,(A0)+
    MOVE.L A1,(A0)+
    MOVE.L 0,(A0)+
    MOVE.L 0,(A0)+
    MOVE.L A2,A0

    WithDataStorage
      LoadBSDSocketBase
      CALLLIB SocketBaseTagList
    EndDataStorage

    TST.L D0
    BEQ _SocketHerrno_success

    ; failed
    MOVE.L #-1,D3

    RestoreStackFunction
    Ret_Int

_SocketHerrno_success:
    MOVE.L (A1),D3

    RestoreStackFunction
    Ret_Int
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Even if you do not have error messages, you MUST
;   leave TWO routines empty at the end...
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Empty
    Lib_Empty
; - - - - - - - - - - - - -

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Finish the library
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_End
; - - - - - - - - - - - - -

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;       TITLE OF THE EXTENSION
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C_Title     dc.b    "AMOSPro BSD Socket Library "
        Version
        dc.b    " (code.hackerbun.dev)"
        dc.b    0,"$VER: "
        Version
        dc.b    0
        Even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;       END OF THE EXTENSION
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C_End       dc.w    0
        even
