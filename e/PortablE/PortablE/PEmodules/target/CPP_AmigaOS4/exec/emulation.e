/* $Id: emulation.h,v 1.14 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <exec/emulation.h>}
NATIVE {EXEC_EMULATION_H} CONST

/* The following structure can be used to switch from 68k into PPC code,
 * in general its use is discouraging but necessary in a few places.
 */
NATIVE {EmuTrap} OBJECT emutrap
    {Instruction}	instruction	:ULONG                 /* TRAPINST, see below    */
    {Type}	type	:UINT                        /* TRAPTYPE or TRAPTYPENR */
    {Function}	function	:NATIVE {ULONG  (*)(ULONG *Reg68K)} PTR  /* PPC function address,
                                         * also see "enRegConst" below
                                         * but watch out byteoffsets!
                                         */
ENDOBJECT

NATIVE {TRAPINST}   CONST TRAPINST   = $4ef80000  /* jmp.w 0, indicate switch            */
NATIVE {TRAPTYPE}   CONST TRAPTYPE   = $0004      /* type of this trap (result in r3/d0) */
NATIVE {TRAPTYPENR} CONST TRAPTYPENR = $0005      /* same as above but no return value   */

/****************************************************************************/

NATIVE {enRegConst} DEF
NATIVE {REG68K_D0}  CONST REG68K_D0  = 0
NATIVE {REG68K_D1}  CONST REG68K_D1  = 4
NATIVE {REG68K_D2}  CONST REG68K_D2  = 8
NATIVE {REG68K_D3}  CONST REG68K_D3  = 12
NATIVE {REG68K_D4}  CONST REG68K_D4  = 16
NATIVE {REG68K_D5}  CONST REG68K_D5  = 20
NATIVE {REG68K_D6}  CONST REG68K_D6  = 24
NATIVE {REG68K_D7}  CONST REG68K_D7  = 28
NATIVE {REG68K_A0}  CONST REG68K_A0  = 32
NATIVE {REG68K_A1}  CONST REG68K_A1  = 36
NATIVE {REG68K_A2}  CONST REG68K_A2  = 40
NATIVE {REG68K_A3}  CONST REG68K_A3  = 44
NATIVE {REG68K_A4}  CONST REG68K_A4  = 48
NATIVE {REG68K_A5}  CONST REG68K_A5  = 52
NATIVE {REG68K_A6}  CONST REG68K_A6  = 56
NATIVE {REG68K_A7}  CONST REG68K_A7  = 60

NATIVE {REG68K_FP0} CONST REG68K_FP0 = 64
NATIVE {REG68K_FP1} CONST REG68K_FP1 = 72
NATIVE {REG68K_FP2} CONST REG68K_FP2 = 80
NATIVE {REG68K_FP3} CONST REG68K_FP3 = 88
NATIVE {REG68K_FP4} CONST REG68K_FP4 = 96
NATIVE {REG68K_FP5} CONST REG68K_FP5 = 104
NATIVE {REG68K_FP6} CONST REG68K_FP6 = 112
NATIVE {REG68K_FP7} CONST REG68K_FP7 = 120


/****************************************************************************/

/*
 * Tag Items for Emulate() system call
 */
NATIVE {ET_RegisterD0}     CONST ET_REGISTERD0     = (TAG_USER +  1)
NATIVE {ET_RegisterD1}     CONST ET_REGISTERD1     = (TAG_USER +  2)
NATIVE {ET_RegisterD2}     CONST ET_REGISTERD2     = (TAG_USER +  3)
NATIVE {ET_RegisterD3}     CONST ET_REGISTERD3     = (TAG_USER +  4)
NATIVE {ET_RegisterD4}     CONST ET_REGISTERD4     = (TAG_USER +  5)
NATIVE {ET_RegisterD5}     CONST ET_REGISTERD5     = (TAG_USER +  6)
NATIVE {ET_RegisterD6}     CONST ET_REGISTERD6     = (TAG_USER +  7)
NATIVE {ET_RegisterD7}     CONST ET_REGISTERD7     = (TAG_USER +  8)

NATIVE {ET_RegisterA0}     CONST ET_REGISTERA0     = (TAG_USER +  9)
NATIVE {ET_RegisterA1}     CONST ET_REGISTERA1     = (TAG_USER + 10)
NATIVE {ET_RegisterA2}     CONST ET_REGISTERA2     = (TAG_USER + 11)
NATIVE {ET_RegisterA3}     CONST ET_REGISTERA3     = (TAG_USER + 12)
NATIVE {ET_RegisterA4}     CONST ET_REGISTERA4     = (TAG_USER + 13)
NATIVE {ET_RegisterA5}     CONST ET_REGISTERA5     = (TAG_USER + 14)
NATIVE {ET_RegisterA6}     CONST ET_REGISTERA6     = (TAG_USER + 15)
NATIVE {ET_RegisterA7}     CONST ET_REGISTERA7     = (TAG_USER + 16)

NATIVE {ET_NoJIT}          CONST ET_NOJIT          = (TAG_USER + 17)

NATIVE {ET_FPRegisters}    CONST ET_FPREGISTERS    = (TAG_USER + 18)
NATIVE {ET_FPRegisterMask} CONST ET_FPREGISTERMASK = (TAG_USER + 19)

NATIVE {ET_SuperState}     CONST ET_SUPERSTATE     = (TAG_USER + 20)

NATIVE {ET_Offset}         CONST ET_OFFSET         = (TAG_USER + 21)

NATIVE {ET_StackPtr}       CONST ET_STACKPTR       = (TAG_USER + 22)

NATIVE {ET_SaveRegs}       CONST ET_SAVEREGS       = (TAG_USER + 23)
NATIVE {ET_SaveParamRegs}  CONST ET_SAVEPARAMREGS  = (TAG_USER + 24)

/****************************************************************************/

NATIVE {enEmulateFPFlags} DEF
NATIVE {EFPF_FP0} CONST EFPF_FP0 = $1
NATIVE {EFPF_FP1} CONST EFPF_FP1 = $2
NATIVE {EFPF_FP2} CONST EFPF_FP2 = $4
NATIVE {EFPF_FP3} CONST EFPF_FP3 = $8
NATIVE {EFPF_FP4} CONST EFPF_FP4 = $10
NATIVE {EFPF_FP5} CONST EFPF_FP5 = $20
NATIVE {EFPF_FP6} CONST EFPF_FP6 = $40
NATIVE {EFPF_FP7} CONST EFPF_FP7 = $80
