OPT MODULE, EXPORT

-> exec/libraries.e (MorphOS)
-> comments from original libraries.h.

MODULE 'exec/nodes'

MODULE 'utility/tagitem'

MODULE 'emul/emulinterface'

CONST LIB_VECTSIZE = 6
CONST LIB_RESERVED = 4
CONST LIB_BASE     = -LIB_VECTSIZE
CONST LIB_USERDEF  = LIB_BASE - 24
CONST LIB_NONSTD   = LIB_USERDEF

CONST LIB_OPEN         = -6
CONST LIB_CLOSE        = -12
CONST LIB_EXPUNGE      = -18
CONST LIB_EXTFUNC      = -24
CONST LIB_GETQUERYATTR = -24   /* LIBF_QUERY */


OBJECT lib
   ln:ln
   flags:CHAR
   pad:CHAR
   negsize:INT
   possize:INT
   version:INT
   revision:INT
   idstring:PTR TO CHAR
   sum:LONG
   opencnt:INT
ENDOBJECT /* SIZEOF = 34 */

CONST LIBF_SUMMING   = 1 SHL 0
CONST LIBF_CHANGED   = 1 SHL 1
CONST LIBF_SUMUSED   = 1 SHL 2
CONST LIBF_DELEXP    = 1 SHL 3

/*
* Private
*/
CONST LIBF_RAMLIB    = 1 SHL 4
/*
 * Needs to be set if the GetQueryAttr function is legal
 */
CONST LIBF_QUERYINFO = 1 SHL 5
/*
 * The remaining bits are reserved and aren`t allowed to be touched
 */


/* NewSetFunction extensions
 */

CONST SETFUNCTAG_Dummy    = TAG_USER + $01000000

/* Set the machine type of the function
 * Default is 68k
 */
CONST SETFUNCTAG_MACHINE  = SETFUNCTAG_Dummy + $1

/* Function type specifier
 */

CONST SETFUNCTAG_TYPE     = SETFUNCTAG_Dummy + $2

/* ID String
 */

CONST SETFUNCTAG_IDNAME   = SETFUNCTAG_Dummy + $3


/*
 * Set to TRUE if the replaced function will never be used
 * again.
 */
CONST SETFUNCTAG_DELETE   = SETFUNCTAG_Dummy + $4

/* See emul/emulinterface.h for more informations
 */

/* Save Emulation PPC Registers
 * Call Function
 * Restore Emulation PPC Registers
 * REG_D0 = Result
 */
CONST SETFUNCTYPE_NORMAL        = 0

/* Call Function
 * Must use the global register settings of the emulation
 * REG_D0 = Result
 */
CONST SETFUNCTYPE_QUICK         = 1

/* Save Emulation PPC Registers
 * Call Function
 * Restore Emulation PPC Registers
 * No Result
 * Needed to replace functions like
 * forbid,obtainsemaphores which are
 * defined as trashing no registers
 */
CONST SETFUNCTYPE_NORMALNR      = 2

/* Call Function
 * Must use the global register settings of the emulation
 * No Result
 * Needed to replace functions like
 * forbid,obtainsemaphores which are
 * defined as trashing no registers
 */
CONST SETFUNCTYPE_QUICKNR       = 3

CONST SETFUNCTYPE_NORMALSR      = 4

CONST SETFUNCTYPE_NORMALSRNR    = 5

CONST SETFUNCTYPE_NORMALD0_D1   = 6

CONST SETFUNCTYPE_NORMALRESTORE = 7

CONST SETFUNCTYPE_SYSTEMV       = 8

CONST SETFUNCTYPE_NORMALD0D1SR  = 9

CONST SETFUNCTYPE_NORMALD0D1A0A1SR = 10



/* CreateLibrary extensions
 */

CONST LIBTAG_BASE         = TAG_USER + $01000100

/*
 * Function/Vector Array
 */
CONST LIBTAG_FUNCTIONINIT = LIBTAG_BASE + $0
/*
 * Struct Init
 */
CONST LIBTAG_STRUCTINIT   = LIBTAG_BASE + $1
/*
 * Library Init
 */
CONST LIBTAG_LIBRARYINIT  = LIBTAG_BASE + $2
/*
 * Init Code Type
 */
CONST LIBTAG_MACHINE      = LIBTAG_BASE + $3
/*
 * Library Base Size
 */
CONST LIBTAG_BASESIZE     = LIBTAG_BASE + $4
/*
 * SegList Ptr
 */
CONST LIBTAG_SEGLIST      = LIBTAG_BASE + $5
/*
 * Library Priority
 */
CONST LIBTAG_PRI          = LIBTAG_BASE + $6
/*
 * Library Type..Library,Device,Resource,whatever
 */
CONST LIBTAG_TYPE         = LIBTAG_BASE + $7
/*
 * Library Version
 * (UWORD)
 */
CONST LIBTAG_VERSION      = LIBTAG_BASE + $8
/*
 * Library Flags
 */
CONST LIBTAG_FLAGS        = LIBTAG_BASE + $9
/*
 * Library Name
 */
CONST LIBTAG_NAME         = LIBTAG_BASE + $a
/*
 * Library IDString
 */
CONST LIBTAG_IDSTRING     = LIBTAG_BASE + $b
/*
 * AddDevice(),AddLibrary(),AddResource()..
 * depends on LibNode.ln_Type field which
 * can be set by some Init function, Struct Scripts
 * or LIBTAG_TYPE.
 * If you set LIBTAG_PUBLIC the library
 * is added to the right system list.
 */
CONST LIBTAG_PUBLIC       = LIBTAG_BASE + $c
/*
 * Library Revision
 * (UWORD)
 */
CONST LIBTAG_REVISION     = LIBTAG_BASE + $d
/*
 * Library QueryInfo Flag
 * (Boolean)
 */
CONST LIBTAG_QUERYINFO    = LIBTAG_BASE + $e



/* Private
 * don`t touch...floating design
 */
OBJECT funcentry
    emullibentry:emullibentry
    oldfunction:LONG          /* Needed for bookkeeping */
ENDOBJECT

OBJECT funcoldentry
   command:INT
   funcentry:PTR TO funcentry
ENDOBJECT


/*
 * EmulLibEntry.Extension
 */
CONST FUNCENTRYEXTF_LIBRARY          = $1   /* Entry created by the OS */

/*
 * Functionarray first ULONG ID defines the format
 * of the functionarray for MakeFunctions()/MakeLibrary().
 *
 * If there`s not such id the functionarray is a
 * 32Bit 68k function ptr array.
 * (ULONG) $ffffffff stops it
 */

/* 68k 16bit relative functionarray ptrs
 * (UWORD) $ffff stops it
 */

CONST FUNCARRAY_16BIT_OLD            = $ffffffff

/* PPC 32bit functionarray ptrs
 * (ULONG) $ffff stops it
 */
CONST FUNCARRAY_32BIT_NATIVE         = $fffefffe

/* Starts a functionarray block.
 * This way it`s possible to mix 68k and PPC
 * function definitions.
 * BASE:
 *  FUNCTIONARRAY_BEGIN
 *   FUNCARRAY_32BIT_NATIVE
 *    FUNC0
 *    FUNC1
 *    .
 *    FUNCn
 *    $ffffffff
 *   FUNCn+1  (No ID->32Bit 68k)
 *    FUNCn+2
 *    .
 *    FUNCm
 *    $ffffffff
 *   FUNCARRAY_16BIT_OLD
 *    FUNCm+1-BASE
 *    FUNCm+2-BASE
 *    .
 *    FUNCo-BASE
 *    $ffff
 *  FUNCTIONARRAY_END
 */

CONST FUNCARRAY_BEGIN                = $fffdfffd

/* Ends a functionarray block.
 */
CONST FUNCARRAY_END                  = $fffcfffc

/* PPC 32bit Quick functionarray ptrs.
 * These functions must comply to the emulation's
 * register layout which is defined inside the
 * emul/emulregs.h. That means the register layout
 * MUST also be valid during interrupts/task switches.
 * You can't just destroy A7(r31), SR or PC.
 *
 * You shouldn't use this for any normal code
 * as there's no real reason to do so. If you
 * really think you need to use it please ask
 * us first on the dev mailinglist.
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_QUICK_NATIVE   = $fffbfffb

/* PPC 32bit QuickNR(No Result) functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_QUICKNR_NATIVE = $fffafffa

/* PPC 32bit no result functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_NR_NATIVE      = $fff9fff9

/* PPC 32bit SR functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_SR_NATIVE      = $fff8fff8

/* PPC 32bit SR(no result) functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_SRNR_NATIVE    = $fff7fff7

/* PPC 32bit D0_D1 functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_D0D1_NATIVE    = $fff6fff6

/* PPC 32bit Restore1 functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_RESTORE_NATIVE = $fff5fff5

/* PPC 32bit SystemV ABI entry
 * these function entries DON'T comply
 * to the amiga register modell REG_D0-A6
 * but comply to the PPC SystemV ABI so
 * you can directly use PPC C Argument
 * parsing. That way you're also not limited
 * with the register count.
 * Such library functions can't be used
 * by 68k emulation, so you can only use
 * them for new code.
 * As we allow these new functions to be
 * used with old functions we keep the
 * 6 bytes function entry steps in the library.
 * Layout is
 *
 * CODE_JMP, &FuncEntry ; Old Entry
 * CODE_ILLEGAL, Function ; SystemV ABI Entry
 *
 *
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_SYSTEMV        = $fff4fff4

/* PPC 32bit D0D1SR functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_D0D1SR_NATIVE    = $fff3fff3

/* PPC 32bit D0D1A0A1SR functionarray ptrs
 * (ULONG) $ffffffff stops it
 */
CONST FUNCARRAY_32BIT_D0D1A0A1SR_NATIVE   =  $fff2fff2

