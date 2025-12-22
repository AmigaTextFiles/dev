*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _UseIPCPort
_UseIPCPort:
        GETPARM 1,A0
        IPCVECT  UseIPCPort

        END


