*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 17

    INCLUDE 'IPClink.i'

        cseg

        XDEF  _MakeIPCId
_MakeIPCId:
        GETPARM 1,A0
        IPCVECT  MakeIPCId

        END

