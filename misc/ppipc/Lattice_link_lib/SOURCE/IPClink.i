*** Convenience Macros for PPIPC linkage routines
***     Pete Goodeve 1989 April 15

        INCLUDE 'IPC_lib.i'


** call IPC library vector by name (and return directly):
IPCVECT MACRO   * VectorName
            LINKLIB _LVO\1,_IPCBase
            rts
        ENDM

** get parameter from stack into register:
GETPARM MACRO   * ParamNum[1..n],Reg
            move.l  \1*4(A7),\2
        ENDM

**********************************************

        XREF _IPCBase

