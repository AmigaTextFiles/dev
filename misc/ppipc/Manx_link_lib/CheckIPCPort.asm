*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _CheckIPCPort
_CheckIPCPort:
        GETPARM 1,A0
        GETPARM 2,D0
        IPCVECT  CheckIPCPort

        END


