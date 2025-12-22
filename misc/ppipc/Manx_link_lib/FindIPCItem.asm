*** C linkage routines (Manx/Aztec version) for PPIPC Library
***     Pete Goodeve 1989 April 17

    INCLUDE 'IPClink.i'

        cseg


        XDEF  _FindIPCItem
_FindIPCItem:
        GETPARM 1,A0
        GETPARM 2,D0
        GETPARM 3,A1
        IPCVECT  FindIPCItem

        END


