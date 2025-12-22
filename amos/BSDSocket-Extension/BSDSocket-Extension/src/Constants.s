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
sockaddr_in_sin_len    EQU 0
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
