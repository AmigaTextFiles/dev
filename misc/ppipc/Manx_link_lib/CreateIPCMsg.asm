*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _CreateIPCMsg
_CreateIPCMsg:
        GETPARM 1,D0
        GETPARM 2,D1
        GETPARM 3,A0
        IPCVECT  CreateIPCMsg

        END


