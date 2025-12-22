/* $VER: var.h 36.11 (2.6.1992) */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <dos/var.h>}
NATIVE {DOS_VAR_H} CONST

/* the structure in the pr_LocalVars list */
/* Do NOT allocate yourself, use SetVar()!!! This structure may grow in */
/* future releases!  The list should be left in alphabetical order, and */
/* may have multiple entries with the same name but different types.	*/

NATIVE {LocalVar} OBJECT localvar
	{lv_Node}	node	:ln
	{lv_Flags}	flags	:UINT
	{lv_Value}	value	:ARRAY OF UBYTE
	{lv_Len}	len	:ULONG
ENDOBJECT

/*
 * The lv_Flags bits are available to the application.	The unused
 * lv_Node.ln_Pri bits are reserved for system use.
 */

/* bit definitions for lv_Node.ln_Type: */
NATIVE {LV_VAR}			CONST LV_VAR			= 0	/* an variable */
NATIVE {LV_ALIAS}		CONST LV_ALIAS		= 1	/* an alias */
/* to be or'ed into type: */
NATIVE {LVB_IGNORE}		CONST LVB_IGNORE		= 7	/* ignore this entry on GetVar, etc */
NATIVE {LVF_IGNORE}		CONST LVF_IGNORE		= $80

/* definitions of flags passed to GetVar()/SetVar()/DeleteVar() */
/* bit defs to be OR'ed with the type: */
/* item will be treated as a single line of text unless BINARY_VAR is used */
NATIVE {GVB_GLOBAL_ONLY}		CONST GVB_GLOBAL_ONLY		= 8
NATIVE {GVF_GLOBAL_ONLY}		CONST GVF_GLOBAL_ONLY		= $100
NATIVE {GVB_LOCAL_ONLY}		CONST GVB_LOCAL_ONLY		= 9
NATIVE {GVF_LOCAL_ONLY}		CONST GVF_LOCAL_ONLY		= $200
NATIVE {GVB_BINARY_VAR}		CONST GVB_BINARY_VAR		= 10		/* treat variable as binary */
NATIVE {GVF_BINARY_VAR}		CONST GVF_BINARY_VAR		= $400
NATIVE {GVB_DONT_NULL_TERM}	CONST GVB_DONT_NULL_TERM	= 11	/* only with GVF_BINARY_VAR */
NATIVE {GVF_DONT_NULL_TERM}	CONST GVF_DONT_NULL_TERM	= $800

/* this is only supported in >= V39 dos.  V37 dos ignores this. */
/* this causes SetVar to affect ENVARC: as well as ENV:.	*/
NATIVE {GVB_SAVE_VAR}		CONST GVB_SAVE_VAR		= 12	/* only with GVF_GLOBAL_VAR */
NATIVE {GVF_SAVE_VAR}		CONST GVF_SAVE_VAR		= $1000
