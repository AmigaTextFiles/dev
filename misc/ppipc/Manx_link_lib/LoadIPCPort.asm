*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _LoadIPCPort
_LoadIPCPort:
        GETPARM 1,A0
        IPCVECT  LoadIPCPort

        END


