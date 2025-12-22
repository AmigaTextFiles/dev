/****h* AmigaTalk/CantHappen.h [1.8] **************************
*
* NAME
*    CantHappen.h
*
* DESCRIPTION
*    Define internal error number constants for the 
*    cant_happen() function in ReportErrs.c.
***************************************************************
* 
*/

#ifndef  CANTHAPPEN_H
# define CANTHAPPEN_H

# define CANT_NO_ERROR       0
# define NO_MEMORY           1
# define ARRAYSIZE_ERR       2  
# define BLKRETURN_FROMCALL  3
# define MAKEINST_NONCLASS   4
# define CASE_ERR_NEWINT     5
# define DECR_UNK_BUILTIN    6
# define NOFIND_CLASSOBJECT  7
# define WRONGOBJECT_FREED   8
# define INTERP_INTERN_ERR   9
# define NON_BLOCK_EXECUTE   10
# define NO_SYMBOL_SPACE     11
# define NO_BYTECODE_SPACE   12
# define ALL_PROCS_BLOCKED   13
# define CANT_FREE_SYMBOL    14
# define BADARG_SET_STATE    15
# define INTERNAL_BUFF_OVF   16
# define PRELUDE_UNOPENED    17
# define FILE_OPEN_ERROR     18
# define FASTSAVE_ERROR      19
# define PANIC_BACKTRACE     20
# define HIGHBITS_OVERSIZED  21
# define INTERP_NOSYMBOL     22
# define INTERP_NOMSGSYMBOL  23
# define INTERP_NOSUPSYMBOL  24
# define INTERP_ARITHLOWBITS 25
# define INTERP_SPCLOWBITS   26
# define BAD_BLOCK_ARG       27
# define CH_NULL_POINTER     28
# define SPECIAL_NOT_SYMBOL  29

# define NO_INTEGER_SPACE    32

# define ERR_LIBRARY_NOT_OPENED 30

# define LAST_KNOWN_ERR_STRING  33

# define IMPOSSIBLE_ERROR       999

// -----------------------------------------------------------------------

# ifdef ALLOCATE_ERR_STRINGS // Performed in Global.c only.

PUBLIC char *ch_errstrs[ 36 ] = { NULL, };

# else

IMPORT char *ch_errstrs[];

# endif

#endif

/* -------------------- END of CantHappen.h file! ------------------------ */

