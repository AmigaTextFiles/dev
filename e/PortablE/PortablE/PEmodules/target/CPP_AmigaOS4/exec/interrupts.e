/* $Id: interrupts.h,v 1.22 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types'
{#include <exec/interrupts.h>}
NATIVE {EXEC_INTERRUPTS_H} CONST

CONST SF_SAR  = $8000
CONST SIH_QUEUES = 5
CONST SF_SINT = $2000
CONST SF_TQE  = $4000

NATIVE {Interrupt} OBJECT is
    {is_Node}	ln	:ln
    {is_Data}	data	:APTR    /* server data segment */
    {is_Code}	code	:NATIVE {VOID      (*)()} PTR /* server code entry */
ENDOBJECT

/****************************************************************************/

NATIVE {IntVector} OBJECT iv
    {iv_Data}	data	:APTR
    {iv_Code}	code	:NATIVE {VOID       (*)()} PTR
    {iv_Node}	node	:PTR TO ln
ENDOBJECT

/****************************************************************************/

NATIVE {SoftIntList} OBJECT sh
    {sh_List}	lh	:lh
    {sh_Pad}	pad	:UINT
ENDOBJECT

/****************************************************************************/

/*
** This structure holds volatile registers during an exception.
** They will be copied back to the appropriate registers after
** returning from the exception handler.
**
** Note: During exception processing, all other registers are considered
**       non-volatile. 
*/

NATIVE {ExceptionContext} OBJECT exceptioncontext
    {Flags}	flags	:ULONG    /* Flags, describing the context (READ-ONLY)*/
    {Traptype}	traptype	:ULONG /* Type of trap (READ-ONLY) */
    {msr}	msr	:ULONG      /* Machine state */
    {ip}	ip	:ULONG       /* Return instruction pointer */
    {gpr}	gpr[32]	:ARRAY OF ULONG  /* r0 - r31 */
    {cr}	cr	:ULONG       /* Condition code register */
    {xer}	xer	:ULONG      /* Extended exception register */
    {ctr}	ctr	:ULONG      /* Count register */
    {lr}	lr	:ULONG       /* Link register */
    {dsisr}	dsisr	:ULONG    /* DSI status register. Only set when valid */
    {dar}	dar	:ULONG      /* Data address register. Only set when valid */
->    {fpr}	fpr[32]	:ARRAY OF #float64  /* Floating point registers */
    {fpscr}	fpscr	:UBIGVALUE    /* Floating point control and status register */
    /* The following are only used on AltiVec */
    {vscr}	vscr[16]	:ARRAY OF UBYTE /* AltiVec vector status and control register */
    {vr}	vr[512]	:ARRAY OF UBYTE  /* AltiVec vector register storage */
    {vrsave}	vrsave	:ULONG   /* AltiVec VRSAVE register */
ENDOBJECT

/* Flags for ExceptionContext */
NATIVE {enECFlags} DEF
NATIVE {ECF_FULL_GPRS} CONST ECF_FULL_GPRS = $1 /* Set if all register have been saved */
NATIVE {ECF_FPU}       CONST ECF_FPU       = $2 /* Set if the FPU registers have been saved */
NATIVE {ECF_FULL_FPU}  CONST ECF_FULL_FPU  = $4 /* Set if all FPU registers have been saved */
NATIVE {ECF_VECTOR}    CONST ECF_VECTOR    = $8 /* Set if vector registers have been saved */
NATIVE {ECF_VRSAVE}    CONST ECF_VRSAVE    = $10  /* Set if VRSAVE reflects state of vector */
                          /* registers saved */


NATIVE {SIH_PRIMASK} CONST SIH_PRIMASK = ($f0)

/****************************************************************************/

/* this is a fake INT definition, used only for AddIntServer and the like */
NATIVE {INTB_NMI} CONST INTB_NMI = 15
NATIVE {INTF_NMI} CONST INTF_NMI = $8000

/* 
** These are used with AddIntServer/SetIntVector to install global
** trap handlers and with SetTaskTrap to install local task traps
** Note: Use of these global trap handlers should be
** restricted to system and debugger use. You should normally
** use the task's local trap handler.
*/

NATIVE {enTrapNumbers} DEF
NATIVE {TRAPNUM_BUS_ERROR}              CONST TRAPNUM_BUS_ERROR              = $01000000 /* Bus error exception/machine check */
NATIVE {TRAPNUM_DATA_SEGMENT_VIOLATION} CONST TRAPNUM_DATA_SEGMENT_VIOLATION = $02000000 /* Data segment violation */
NATIVE {TRAPNUM_INST_SEGMENT_VIOLATION} CONST TRAPNUM_INST_SEGMENT_VIOLATION = $03000000 /* Instruction segment violation */
NATIVE {TRAPNUM_ALIGNMENT}              CONST TRAPNUM_ALIGNMENT              = $04000000 /* Alignemnt violation */
NATIVE {TRAPNUM_ILLEGAL_INSTRUCTION}    CONST TRAPNUM_ILLEGAL_INSTRUCTION    = $05000000 /* Illegal instruction */
NATIVE {TRAPNUM_PRIVILEGE_VIOLATION}    CONST TRAPNUM_PRIVILEGE_VIOLATION    = $06000000 /* Privilege violation */
NATIVE {TRAPNUM_TRAP}                   CONST TRAPNUM_TRAP                   = $07000000 /* Trap instruction */
NATIVE {TRAPNUM_FPU}                    CONST TRAPNUM_FPU                    = $08000000 /* Floating point related (FPU disabled, imprecise) */
NATIVE {TRAPNUM_TRACE}                  CONST TRAPNUM_TRACE                  = $09000000 /* Single step trace exception */
NATIVE {TRAPNUM_DATA_BREAKPOINT}        CONST TRAPNUM_DATA_BREAKPOINT        = $0a000000 /* Data breakpoint */
NATIVE {TRAPNUM_INST_BREAKPOINT}        CONST TRAPNUM_INST_BREAKPOINT        = $0b000000 /* Instruction breakpoint */
NATIVE {TRAPNUM_PERFORMANCE}            CONST TRAPNUM_PERFORMANCE            = $0c000000 /* Performance monitor (System use only) */
NATIVE {TRAPNUM_THERMAL}                CONST TRAPNUM_THERMAL                = $0d000000 /* Thermal management (System use only) */
NATIVE {TRAPNUM_ALTIVEC_ASSIST}         CONST TRAPNUM_ALTIVEC_ASSIST         = $0f000000 /* AltiVec Assist */

NATIVE {TRAPNUM_NUMTRAPS}               CONST TRAPNUM_NUMTRAPS               = 15          /* Number of hardware traps */
