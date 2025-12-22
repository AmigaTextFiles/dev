/* $Id: var.h 28624 2008-05-05 10:31:44Z sszymczy $ */
OPT NATIVE
MODULE 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <dos/var.h>}
NATIVE {DOS_VAR_H} CONST

/* This structure describes a local variable. The list is normally held in
   Process->pr_LocalVars. See <dos/dosextens.h> for more information about
   the list. Note that this structure is READ-ONLY! Allocate it with SetVar().
*/
NATIVE {LocalVar} OBJECT localvar
    {lv_Node}	node	:ln  /* Standard node structure as defined in
                               <exec/nodes.h>. See also below. */
    {lv_Flags}	flags	:UINT
    {lv_Value}	value	:ARRAY OF UBYTE /* The contents of the variable. */
    {lv_Len}	len	:ULONG   /* The length of the contents. */
ENDOBJECT

/* This structure is used by ScanVars() function to pass information about
   local and/or global variables to specified hook function. Note that this
   structure is READ-ONLY and its content is valid only during ScanVars()
   hook function call. Don't try to use a pointer to this structure outside
   ScanVars() hook function.
*/
NATIVE {ScanVarsMsg} OBJECT scanvarsmsg
    {sv_SVMSize}	svmsize	:ULONG  /* Size of ScanVarsMsg structure */
    {sv_Flags}	flags	:ULONG    /* The flags parameter given to ScanVars() */
    {sv_GDir}	gdir	:/*STRPTR*/ ARRAY OF CHAR    /* Directory patch for global variables or empty string
                          "\0" for local variables */
    {sv_Name}	name	:/*STRPTR*/ ARRAY OF CHAR    /* Name of the variable */
    {sv_Var}	var	:/*STRPTR*/ ARRAY OF CHAR     /* Pointer to the contents of the variable */
    {sv_VarLen}	varlen	:ULONG   /* Size of the variable */
ENDOBJECT

/* lv_Node.ln_Type */
NATIVE {LV_VAR}   CONST LV_VAR   = 0 /* This is a variable. */
NATIVE {LV_ALIAS} CONST LV_ALIAS = 1 /* This is an alias. */
/* This flag may be or'ed into lv_Node.ln_Type. It means that dos.library
   should ignore this entry. */
NATIVE {LVB_IGNORE} CONST LVB_IGNORE = 7
NATIVE {LVF_IGNORE} CONST LVF_IGNORE = $80

/* The following flags are used as flags for the dos variable functions. 
    GVB_BINARY_VAR and GVB_DONT_NULL_TERM are also saved in lv_Flags.	
*/
  /* The variable is not to be used locally. */
NATIVE {GVB_GLOBAL_ONLY}    CONST GVB_GLOBAL_ONLY    = 8
  /* The variable is not to be used globally. */
NATIVE {GVB_LOCAL_ONLY}     CONST GVB_LOCAL_ONLY     = 9
  /* The variable is a binary variable. lv_Value points to binary data. */
NATIVE {GVB_BINARY_VAR}     CONST GVB_BINARY_VAR     = 10
  /* lv_Value is not null-terminated. This is only allowed, if GVB_BINARY_VAR
     is also set. */
NATIVE {GVB_DONT_NULL_TERM} CONST GVB_DONT_NULL_TERM = 11
  /* This flag tells dos to save the variable to ENVARC: too. */
NATIVE {GVB_SAVE_VAR}       CONST GVB_SAVE_VAR       = 12

NATIVE {GVF_GLOBAL_ONLY}    CONST GVF_GLOBAL_ONLY    = $100
NATIVE {GVF_LOCAL_ONLY}     CONST GVF_LOCAL_ONLY     = $200
NATIVE {GVF_BINARY_VAR}     CONST GVF_BINARY_VAR     = $400
NATIVE {GVF_DONT_NULL_TERM} CONST GVF_DONT_NULL_TERM = $800
NATIVE {GVF_SAVE_VAR}       CONST GVF_SAVE_VAR       = $1000
