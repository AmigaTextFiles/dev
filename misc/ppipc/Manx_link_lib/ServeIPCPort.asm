*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 15

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _ServeIPCPort
_ServeIPCPort:
        GETPARM 1,A0
        IPCVECT  ServeIPCPort

        END


