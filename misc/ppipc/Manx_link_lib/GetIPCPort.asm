*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _GetIPCPort
_GetIPCPort:
        GETPARM 1,A0
        IPCVECT  GetIPCPort

        END


