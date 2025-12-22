#
#
#            PAsm - String OS dependant routines (AmigaOS PowerPC)
#            -----------------------------------------------------
#
#
# 02/05/2001
#   First version
#
#

# PB_NeedString = 1
# PB_StringBankSize = 5000

# PB_NeedFastAllocateString = 0
# PB_NeedStringEqual        = 0
# PB_NeedStringSup          = 0
# PB_NeedStringInf          = 0


# --------------------------------------------------
# InitString()
#

 .macro PB_InitString

 .if PB_NeedString

        liw     r4,PB_StringBankSize
        liw     r5,65536
        li      r6,0
        CALLPOWERPC AllocVecPPC
        mr      r29,r3
        clrw    r4
        liw     r5,40
        mr      r6,r5
        CALLPOWERPC CreatePoolPPC
        stw     r3,(r14)

 .endif
 .endm


# --------------------------------------------------
# FreeString()
#

 .macro PB_FreeString

 .if PB_NeedString

   lwz     r4, (r14)
   CALLPOWERPC DeletePoolPPC

 .endif
 .endm


# --------------------------------------------------
# StringSubRoutines()
#

 .macro PB_StringSubRoutines

 .if PB_NeedString


PB_StringEqual:
        tstw    r5
        bne    _PB_StringEqualNext1
        la      r5,PB_NullString
_PB_StringEqualNext1:
        tstw    r6
        bne    _PB_StringEqualNext2
        la      r6,PB_NullString
_PB_StringEqualNext2:
_PB_StringEqualLoop:
        lbz     r3,(r6)
        lbz     r4,(r5)
        extsb   r3,r3
        extsb   r4,r4
        cmpw    r3,r4
        bne    _PB_StringFail
        tstb    r3
        bne    _PB_StringEqualLoop
        li      r3,r3,1
        blr
_PB_StringFail:
        li      r3,r3,0
        blr
#
PB_AllocateString:
        pushlr
        mr      r16,r5
        lwz     r3,(r30)
        tstw    r3
        beq    _Skip_Free
        lwz     r5,(r30)
        mr      r6,r5
_PB_GetSize:
        lbz     r3,(r6)
        addi    r6,r6,1
        tstb    r3
        bne    _PB_GetSize
        sub     r6,r6,r5
        lwz     r4,(r14)
        CALLPOWERPC FreePooledPPC
_Skip_Free:
        mr      r5,r29
        sub     r5,r5,r16
        addi    r5,r5,1
        lwz     r4,(r14)
        CALLPOWERPC AllocPooledPPC
        stw     r3,(r30)
        mr      r4,r16
_PB_CopyLoop:
        lbz     r5,(r4)
        stb     r5,(r3)
        addi    r3,r3,1
        addi    r4,r4,1
        tstb    r5
        bne    _PB_CopyLoop
        mr      r29,r16
        poplr
        blr
#
PB_CopyString:
        tstw    r5
        beq    _PB_CopyStringEnd
_PB_CopyStringLoop:
        lbz     r3,(r5)
        stb     r3,(r29)
        addi    r5,r5,1
        addi    r29,r29,1
        tstb    r3
        bne    _PB_CopyStringLoop
_PB_CopyStringEnd:
        blr
        .tocd

 .endif
 .endm


# PB_InitString
# PB_FreeString
# PB_StringSubRoutines
