/****h* AmigaTalk/CatFuncs3.c [3.0] ********************************
*
* NAME
*    CatFuncs3.c
* 
* DESCRIPTION
*    A central location for all Error Message strings throughout 
*    AmigaTalkPPC.  Almost every source code file depends on AmigaTalk.cd.
*    Consequently, a change in amigatalk.cd forces a re-compilation of
*    almost every file in the program.  By locating all accesses to the
*    Catalog strings in here, only this file will need compiling when
*    amigatalk.cd changes.
*
* HISTORY
*    04-Jan-2005
*
* NOTES
*    $VER: AmigaTalk:Src/CatFuncs3.c 3.0 (04-Jan-2005) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#ifdef __SASC

# include <clib/exec_protos.h>

#else

# define __USE_INLINE__
# include <proto/exec.h>
# include <proto/locale.h>

#endif

IMPORT struct Catalog *catalog; // for the main bunch of locale strings.

#define   CATCOMP_ARRAY 1
#include "ATalkLocale.h"

#include "object.h"
#include "FuncProtos.h"

#include "CantHappen.h"
#include "StringIndexes.h"

PUBLIC STRPTR NumbCMsg( int whichString ) // Number.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_INT_OVERFLOW_NUMB:
         msgString = CMsg( MSG_FORMAT_INT_OVERFLOW, MSG_FORMAT_INT_OVERFLOW_STR );
         break;

      case MSG_RQTITLE_FATAL_ERROR_NUMB:
         msgString = CMsg( MSG_RQTITLE_FATAL_ERROR, MSG_RQTITLE_FATAL_ERROR_STR );
         break;

      case MSG_GET_INTEGER_FILE_NUMB:
         msgString = CMsg( MSG_GET_INTEGER_FILE, MSG_GET_INTEGER_FILE_STR ); 
         break;

      case MSG_FILE_IS_EMPTY_NUMB:
         msgString = CMsg( MSG_FILE_IS_EMPTY, MSG_FILE_IS_EMPTY_STR );
         break;

      case MSG_RQTITLE_ATALK_PROBLEM_NUMB:
         msgString = CMsg( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR );
         break;

      case MSG_FMT_F_UNOPENED_NUMB:
         msgString = CMsg( MSG_FORMAT_F_UNOPENED, MSG_FORMAT_F_UNOPENED_STR ); 
         break;

      case MSG_N_NEW_FLOAT_NUMB:
         msgString = CMsg( MSG_N_NEW_FLOAT, MSG_N_NEW_FLOAT_STR );
         break;

      case MSG_N_FREE_FLOAT_NUMB:
         msgString = CMsg( MSG_N_FREE_FLOAT, MSG_N_FREE_FLOAT_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR ObjCMsg( int whichString ) // Object.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_O_REFCOUNT_ERR_OBJ:
         msgString = CMsg( MSG_O_REFCOUNT_ERR, MSG_O_REFCOUNT_ERR_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR ParCMsg( int whichString ) // Parallel.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_PA_MISC_REMOVE_PAR:
         msgString = CMsg( MSG_PA_MISC_REMOVE, MSG_PA_MISC_REMOVE_STR );
         break;

      case MSG_PAERR_BADNUMBER_PAR:
         msgString = CMsg( MSG_PAERR_BADNUMBER, MSG_PAERR_BADNUMBER_STR );
         break;

      case MSG_PARALLEL_CLASSNAME_PAR:
         msgString = CMsg( MSG_PARALLEL_CLASSNAME, MSG_PARALLEL_CLASSNAME_STR );
         break;

      case MSG_FMT_PA_ODEVICE_PAR:
         msgString = CMsg( MSG_FORMAT_PA_ODEVICE, MSG_FORMAT_PA_ODEVICE_STR );
         break;

      case MSG_PA_MISC_ALLOC_PAR:
         msgString = CMsg( MSG_PA_MISC_ALLOC, MSG_PA_MISC_ALLOC_STR );
         break;

      case MSG_PAERR_NO_REOPEN_PAR:
         msgString = CMsg( MSG_PAERR_NO_REOPEN, MSG_PAERR_NO_REOPEN_STR );
         break;

      case MSG_FMT_PA_NOTEMP_PAR:
         msgString = CMsg( MSG_FORMAT_PA_NOTEMP, MSG_FORMAT_PA_NOTEMP_STR );
         break;

      case MSG_PAERR_WRONG_AMT_PAR:
         msgString = CMsg( MSG_PAERR_WRONG_AMT, MSG_PAERR_WRONG_AMT_STR ); 
         break;
      }
      
   return( msgString );
}

/****i* CatalogParallel() [3.0] **************************************
*
* NAME
*    CatalogParallel()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

#ifndef  AT_MISCNAME
# define AT_MISCNAME "AmigaTalk_Misc"
#endif

PUBLIC int CatalogParallel( void ) // Parallel.c
{
   IMPORT UBYTE MiscName[32];
   IMPORT char *errors[12];
   
   errors[0]  = CMsg( MSG_PAERR_BUSY,         MSG_PAERR_BUSY_STR );
   errors[1]  = CMsg( MSG_PAERR_NOMEMORY,     MSG_PAERR_NOMEMORY_STR );
   errors[2]  = CMsg( MSG_PAERR_PARMINVALID,  MSG_PAERR_PARMINVALID_STR );
   errors[3]  = CMsg( MSG_PAERR_PLINE_ERROR,  MSG_PAERR_PLINE_ERROR_STR );
   errors[4]  = CMsg( MSG_PAERR_NODEVICE,     MSG_PAERR_NODEVICE_STR );
   errors[5]  = CMsg( MSG_PAERR_RESETPORT,    MSG_PAERR_RESETPORT_STR );
   errors[6]  = CMsg( MSG_PAERR_INIT_ERROR,   MSG_PAERR_INIT_ERROR_STR );
   errors[7]  = CMsg( MSG_PAERR_UNK_ERROR,    MSG_PAERR_UNK_ERROR_STR );
   errors[8]  = CMsg( MSG_PAERR_NOMSGPORT,    MSG_PAERR_NOMSGPORT_STR );
   errors[9]  = CMsg( MSG_PAERR_NOEXTIO,      MSG_PAERR_NOEXTIO_STR );
   errors[10] = CMsg( MSG_PAERR_DEVICECLOSED, MSG_PAERR_DEVICECLOSED_STR );

   StringNCopy( MiscName, AT_MISCNAME, 32 );
   
   return( 0 );
}

PUBLIC STRPTR PlotCMsg( int whichString ) // PlotFuncs.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_TOO_MANY_PLOTS_PLOT:
         msgString = CMsg( MSG_FORMAT_TOO_MANY_PLOTS, MSG_FORMAT_TOO_MANY_PLOTS_STR );
         break;

      case MSG_UNKNOWN_PLOT_PLOT:
         msgString = CMsg( MSG_UNKNOWN_PLOT, MSG_UNKNOWN_PLOT_STR );
         break;

      case MSG_FMT_NO_FINDPLOT_PLOT:
         msgString = CMsg( MSG_FORMAT_NO_FINDPLOT, MSG_FORMAT_NO_FINDPLOT_STR );
         break;

      case MSG_PL_PLOT_ARC_PLOT:
         msgString = CMsg( MSG_PL_PLOT_ARC, MSG_PL_PLOT_ARC_STR );
         break;

      case MSG_PL_PLOT_ENV_PLOT:
         msgString = CMsg( MSG_PL_PLOT_ENV, MSG_PL_PLOT_ENV_STR );
         break;

      case MSG_FMT_PEN_ERR_PLOT:
         msgString = CMsg( MSG_FORMAT_PEN_ERR, MSG_FORMAT_PEN_ERR_STR ); 
         break;

      case MSG_FMT_PLOT_WINDOW_PLOT:
         msgString = CMsg( MSG_FORMAT_PLOT_WINDOW, MSG_FORMAT_PLOT_WINDOW_STR );
         break;

      case MSG_PL_IMPOSSIBLE_PLOT:
         msgString = CMsg( MSG_PL_IMPOSSIBLE, MSG_PL_IMPOSSIBLE_STR );
         break;

      case MSG_PL_ALL_CLOSED_PLOT:
         msgString = CMsg( MSG_PL_ALL_CLOSED, MSG_PL_ALL_CLOSED_STR );
         break;

      case MSG_PL_PLOT_CLEAR_PLOT:
         msgString = CMsg( MSG_PL_PLOT_CLEAR, MSG_PL_PLOT_CLEAR_STR );
         break;

      case MSG_PL_PLOT_MOVE_PLOT:
         msgString = CMsg( MSG_PL_PLOT_MOVE, MSG_PL_PLOT_MOVE_STR );
         break;

      case MSG_PL_PLOT_CONT_PLOT:
         msgString = CMsg( MSG_PL_PLOT_CONT, MSG_PL_PLOT_CONT_STR );
         break;

      case MSG_PL_PLOT_POINT_PLOT:
         msgString = CMsg( MSG_PL_PLOT_POINT, MSG_PL_PLOT_POINT_STR );
         break;

      case MSG_PL_PLOT_CIRCLE_PLOT:
         msgString = CMsg( MSG_PL_PLOT_CIRCLE, MSG_PL_PLOT_CIRCLE_STR );
         break;

      case MSG_PL_PLOT_BOX_PLOT:
         msgString = CMsg( MSG_PL_PLOT_BOX, MSG_PL_PLOT_BOX_STR );
         break;

      case MSG_PL_PLOT_SETPENS_PLOT:
         msgString = CMsg( MSG_PL_PLOT_SETPENS, MSG_PL_PLOT_SETPENS_STR );
         break;

      case MSG_PL_PLOT_LINE_PLOT:
         msgString = CMsg( MSG_PL_PLOT_LINE, MSG_PL_PLOT_LINE_STR );
         break;

      case MSG_PL_PLOT_LABEL_PLOT:
         msgString = CMsg( MSG_PL_PLOT_LABEL, MSG_PL_PLOT_LABEL_STR );
         break;

      case MSG_PL_PLOT_LINETYPE_PLOT:
         msgString = CMsg( MSG_PL_PLOT_LINETYPE, MSG_PL_PLOT_LINETYPE_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR PFuncCMsg( int whichString ) // PrimFuncs.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_PR_FINDOBJCLASS_PFUNC:
         msgString = CMsg( MSG_PR_FINDOBJCLASS, MSG_PR_FINDOBJCLASS_STR );
         break;

      case MSG_PR_FINDSUPEROBJ_PFUNC:
         msgString = CMsg( MSG_PR_FINDSUPEROBJ, MSG_PR_FINDSUPEROBJ_STR );
         break;

      case MSG_PR_CLASS2NEW_PFUNC:
         msgString = CMsg( MSG_PR_CLASS2NEW, MSG_PR_CLASS2NEW_STR );
         break;

      case MSG_PR_OBJECTSIZE_PFUNC:
         msgString = CMsg( MSG_PR_OBJECTSIZE, MSG_PR_OBJECTSIZE_STR );
         break;

      case MSG_PR_OBJHASHNUM_PFUNC:
         msgString = CMsg( MSG_PR_OBJHASHNUM, MSG_PR_OBJHASHNUM_STR );
         break;

      case MSG_PR_OBJECTSAME_PFUNC:
         msgString = CMsg( MSG_PR_OBJECTSAME, MSG_PR_OBJECTSAME_STR );
         break;

      case MSG_PR_OBJECTEQUAL_PFUNC:
         msgString = CMsg( MSG_PR_OBJECTEQUAL, MSG_PR_OBJECTEQUAL_STR );
         break;

      case MSG_PR_TOGGLEDEBUG_PFUNC:
         msgString = CMsg( MSG_PR_TOGGLEDEBUG, MSG_PR_TOGGLEDEBUG_STR );
         break;

      case MSG_PR_SETPRNTCMD_PFUNC:
         msgString = CMsg( MSG_PR_SETPRNTCMD, MSG_PR_SETPRNTCMD_STR );
         break;

      case MSG_PR_SETDEBUG_PFUNC:
         msgString = CMsg( MSG_PR_SETDEBUG, MSG_PR_SETDEBUG_STR );
         break;

      case MSG_FMT_GENERAL1_PFUNC:
         msgString = CMsg( MSG_FORMAT_GENERAL1, MSG_FORMAT_GENERAL1_STR );
         break;

      case MSG_FMT_GENERAL2_PFUNC:
         msgString = CMsg( MSG_FORMAT_GENERAL2, MSG_FORMAT_GENERAL2_STR );
         break;

      case MSG_FMT_GENERAL3_PFUNC:
         msgString = CMsg( MSG_FORMAT_GENERAL3, MSG_FORMAT_GENERAL3_STR );
         break;

      case MSG_PR_GENERALCOMP_PFUNC:
         msgString = CMsg( MSG_PR_GENERALCOMP, MSG_PR_GENERALCOMP_STR );
         break;

      case MSG_PR_ADDINTS_PFUNC:
         msgString = CMsg( MSG_PR_ADDINTS, MSG_PR_ADDINTS_STR );
         break;

      case MSG_PR_SUBINTS_PFUNC:
         msgString = CMsg( MSG_PR_SUBINTS, MSG_PR_SUBINTS_STR );
         break;

      case MSG_PR_INTLESSTHAN_PFUNC:
         msgString = CMsg( MSG_PR_INTLESSTHAN, MSG_PR_INTLESSTHAN_STR );
         break;

      case MSG_PR_INTGREATER_PFUNC:
         msgString = CMsg( MSG_PR_INTGREATER, MSG_PR_INTGREATER_STR );
         break;

      case MSG_PR_INTCHARLEQ_PFUNC:
         msgString = CMsg( MSG_PR_INTCHARLEQ, MSG_PR_INTCHARLEQ_STR );
         break;

      case MSG_PR_INTCHARGEQ_PFUNC:
         msgString = CMsg( MSG_PR_INTCHARGEQ, MSG_PR_INTCHARGEQ_STR );
         break;

      case MSG_PR_INTCHAR_EQ_PFUNC:
         msgString = CMsg( MSG_PR_INTCHAR_EQ, MSG_PR_INTCHAR_EQ_STR );
         break;

      case MSG_PR_INTCHARNEQ_PFUNC:
         msgString = CMsg( MSG_PR_INTCHARNEQ, MSG_PR_INTCHARNEQ_STR );
         break;

      case MSG_PR_MULT_INT_PFUNC:
         msgString = CMsg( MSG_PR_MULT_INT, MSG_PR_MULT_INT_STR );
         break;

      case MSG_PR_DSLASHINT_PFUNC:
         msgString = CMsg( MSG_PR_DSLASHINT, MSG_PR_DSLASHINT_STR );
         break;

      case MSG_PR_GCD_INTS_PFUNC:
         msgString = CMsg( MSG_PR_GCD_INTS, MSG_PR_GCD_INTS_STR );
         break;

      case MSG_PR_BITAT_PFUNC:
         msgString = CMsg( MSG_PR_BITAT, MSG_PR_BITAT_STR );
         break;

      case MSG_PR_BITOR_PFUNC:
         msgString = CMsg( MSG_PR_BITOR, MSG_PR_BITOR_STR );
         break;

      case MSG_PR_BITAND_PFUNC:
         msgString = CMsg( MSG_PR_BITAND, MSG_PR_BITAND_STR );
         break;

      case MSG_PR_BITXOR_PFUNC:
         msgString = CMsg( MSG_PR_BITXOR, MSG_PR_BITXOR_STR );
         break;

      case MSG_PR_BITSHIFT_PFUNC:
         msgString = CMsg( MSG_PR_BITSHIFT, MSG_PR_BITSHIFT_STR );
         break;

      case MSG_PR_PRNTRADIX_PFUNC:
         msgString = CMsg( MSG_PR_PRNTRADIX, MSG_PR_PRNTRADIX_STR );
         break;

      case MSG_PR_FPRNTRADIX_PFUNC:
         msgString = CMsg( MSG_PR_FPRNTRADIX, MSG_PR_FPRNTRADIX_STR );
         break;

      case MSG_PR_INT_RADIX_PFUNC:
         msgString = CMsg( MSG_PR_INT_RADIX, MSG_PR_INT_RADIX_STR );
         break;

      case MSG_PR_DIV_INTS_PFUNC:
         msgString = CMsg( MSG_PR_DIV_INTS, MSG_PR_DIV_INTS_STR );
         break;

      case MSG_PR_INT_MODULUS_PFUNC:
         msgString = CMsg( MSG_PR_INT_MODULUS, MSG_PR_INT_MODULUS_STR );
         break;

      case MSG_PR_DOPRIM2ARGS_PFUNC:
         msgString = CMsg( MSG_PR_DOPRIM2ARGS, MSG_PR_DOPRIM2ARGS_STR );
         break;

      case MSG_PR_RANDOM_FLOAT_PFUNC:
         msgString = CMsg( MSG_PR_RANDOM_FLOAT, MSG_PR_RANDOM_FLOAT_STR );
         break;

      case MSG_PR_BITINVERSE_PFUNC:
         msgString = CMsg( MSG_PR_BITINVERSE, MSG_PR_BITINVERSE_STR );
         break;

      case MSG_PR_HIGHBIT_PFUNC:
         msgString = CMsg( MSG_PR_HIGHBIT, MSG_PR_HIGHBIT_STR );
         break;

      case MSG_PR_RANDOM_NUM_PFUNC:
         msgString = CMsg( MSG_PR_RANDOM_NUM, MSG_PR_RANDOM_NUM_STR );
         break;

      case MSG_PR_INT2CHAR_PFUNC:
         msgString = CMsg( MSG_PR_INT2CHAR, MSG_PR_INT2CHAR_STR );
         break;

      case MSG_PR_INT2STRING_PFUNC:
         msgString = CMsg( MSG_PR_INT2STRING, MSG_PR_INT2STRING_STR );
         break;

      case MSG_PR_FACTORIALI_PFUNC:
         msgString = CMsg( MSG_PR_FACTORIALI, MSG_PR_FACTORIALI_STR );
         break;

      case MSG_PR_FACTORIALG_PFUNC:
         msgString = CMsg( MSG_PR_FACTORIALG, MSG_PR_FACTORIALG_STR );
         break;

      case MSG_PR_INT2FLOAT_PFUNC:
         msgString = CMsg( MSG_PR_INT2FLOAT, MSG_PR_INT2FLOAT_STR );
         break;

      case MSG_PR_DIGITVALUE_PFUNC:
         msgString = CMsg( MSG_PR_DIGITVALUE, MSG_PR_DIGITVALUE_STR );
         break;

      case MSG_PR_IS_VOWEL_PFUNC:
         msgString = CMsg( MSG_PR_IS_VOWEL, MSG_PR_IS_VOWEL_STR );
         break;

      case MSG_PR_IS_ALPHA_PFUNC:
         msgString = CMsg( MSG_PR_IS_ALPHA, MSG_PR_IS_ALPHA_STR );
         break;

      case MSG_PR_IS_LOWER_PFUNC:
         msgString = CMsg( MSG_PR_IS_LOWER, MSG_PR_IS_LOWER_STR );
         break;

      case MSG_PR_IS_UPPER_PFUNC:
         msgString = CMsg( MSG_PR_IS_UPPER, MSG_PR_IS_UPPER_STR );
         break;

      case MSG_PR_IS_SPACE_PFUNC:
         msgString = CMsg( MSG_PR_IS_SPACE, MSG_PR_IS_SPACE_STR );
         break;

      case MSG_PR_IS_ALNUM_PFUNC:
         msgString = CMsg( MSG_PR_IS_ALNUM, MSG_PR_IS_ALNUM_STR );
         break;

      case MSG_PR_CHANGECASE_PFUNC:
         msgString = CMsg( MSG_PR_CHANGECASE, MSG_PR_CHANGECASE_STR );
         break;

      case MSG_PR_CHAR2STRING_PFUNC:
         msgString = CMsg( MSG_PR_CHAR2STRING, MSG_PR_CHAR2STRING_STR );
         break;

      case MSG_PR_CHAR2INT_PFUNC:
         msgString = CMsg( MSG_PR_CHAR2INT, MSG_PR_CHAR2INT_STR );
         break;

      case MSG_PR_ADDFLOATS_PFUNC:
         msgString = CMsg( MSG_PR_ADDFLOATS, MSG_PR_ADDFLOATS_STR );
         break;

      case MSG_PR_SUBFLOATS_PFUNC:
         msgString = CMsg( MSG_PR_SUBFLOATS, MSG_PR_SUBFLOATS_STR );
         break;

      case MSG_PR_FLOAT_LT_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_LT, MSG_PR_FLOAT_LT_STR );
         break;

      case MSG_PR_FLOAT_GT_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_GT, MSG_PR_FLOAT_GT_STR );
         break;

      case MSG_PR_FLOAT_LEQ_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_LEQ, MSG_PR_FLOAT_LEQ_STR );
         break;

      case MSG_PR_FLOAT_GEQ_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_GEQ, MSG_PR_FLOAT_GEQ_STR );
         break;

      case MSG_PR_FLOAT_EQ_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_EQ, MSG_PR_FLOAT_EQ_STR );
         break;

      case MSG_PR_FLOAT_NEQ_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT_NEQ, MSG_PR_FLOAT_NEQ_STR );
         break;

      case MSG_PR_MULTFLOATS_PFUNC:
         msgString = CMsg( MSG_PR_MULTFLOATS, MSG_PR_MULTFLOATS_STR );
         break;

      case MSG_PR_DIVFLOATS_PFUNC:
         msgString = CMsg( MSG_PR_DIVFLOATS, MSG_PR_DIVFLOATS_STR );
         break;

      case MSG_PR_NATURALLOG_PFUNC:
         msgString = CMsg( MSG_PR_NATURALLOG, MSG_PR_NATURALLOG_STR );
         break;

      case MSG_PR_SQUAREROOT_PFUNC:
         msgString = CMsg( MSG_PR_SQUAREROOT, MSG_PR_SQUAREROOT_STR );
         break;

      case MSG_PR_FLOOR_PFUNC:
         msgString = CMsg( MSG_PR_FLOOR, MSG_PR_FLOOR_STR );
         break;

      case MSG_PR_CEILING_PFUNC:
         msgString = CMsg( MSG_PR_CEILING, MSG_PR_CEILING_STR );
         break;

      case MSG_PR_INT_PART_PFUNC:
         msgString = CMsg( MSG_PR_INT_PART, MSG_PR_INT_PART_STR );
         break;

      case MSG_PR_FRACTION_PFUNC:
         msgString = CMsg( MSG_PR_FRACTION, MSG_PR_FRACTION_STR );
         break;

      case MSG_PR_GAMMA_PFUNC:
         msgString = CMsg( MSG_PR_GAMMA, MSG_PR_GAMMA_STR );
         break;

      case MSG_PR_GAMMA_FUNC_PFUNC:
         msgString = CMsg( MSG_PR_GAMMA_FUNC, MSG_PR_GAMMA_FUNC_STR );
         break;

      case MSG_FMT_PR_NOTIMP_PFUNC:
         msgString = CMsg( MSG_FORMAT_PR_NOTIMP, MSG_FORMAT_PR_NOTIMP_STR );
         break;

      case MSG_PR_FLOAT2STRING_PFUNC:
         msgString = CMsg( MSG_PR_FLOAT2STRING, MSG_PR_FLOAT2STRING_STR );
         break;

      case MSG_PR_EXPONENT_PFUNC:
         msgString = CMsg( MSG_PR_EXPONENT, MSG_PR_EXPONENT_STR );
         break;

      case MSG_PR_NORM_RADIAN_PFUNC:
         msgString = CMsg( MSG_PR_NORM_RADIAN, MSG_PR_NORM_RADIAN_STR );
         break;

      case MSG_PR_SIN_PFUNC:
         msgString = CMsg( MSG_PR_SIN, MSG_PR_SIN_STR );
         break;

      case MSG_PR_COS_PFUNC:
         msgString = CMsg( MSG_PR_COS, MSG_PR_COS_STR );
         break;

      case MSG_PR_ASIN_PFUNC:
         msgString = CMsg( MSG_PR_ASIN, MSG_PR_ASIN_STR );
         break;

      case MSG_PR_ACOS_PFUNC:
         msgString = CMsg( MSG_PR_ACOS, MSG_PR_ACOS_STR );
         break;

      case MSG_PR_ATAN_PFUNC:
         msgString = CMsg( MSG_PR_ATAN, MSG_PR_ATAN_STR );
         break;

      case MSG_FMT_PR_POWER_PFUNC:
         msgString = CMsg( MSG_FORMAT_PR_POWER, MSG_FORMAT_PR_POWER_STR );
         break;

      case MSG_PR_POWER_PFUNC:
         msgString = CMsg( MSG_PR_POWER, MSG_PR_POWER_STR );
         break;

      case MSG_PR_FLOATRADIX_PRT_PFUNC:
         msgString = CMsg( MSG_PR_FLOATRADIX_PRT, MSG_PR_FLOATRADIX_PRT_STR );
         break;

      case MSG_PR_SYMBOLCOMP_PFUNC:
         msgString = CMsg( MSG_PR_SYMBOLCOMP, MSG_PR_SYMBOLCOMP_STR );
         break;

      case MSG_PR_SYM2STRING_PFUNC:
         msgString = CMsg( MSG_PR_SYM2STRING, MSG_PR_SYM2STRING_STR );
         break;

      case MSG_PR_SYMASSTRING_PFUNC:
         msgString = CMsg( MSG_PR_SYMASSTRING, MSG_PR_SYMASSTRING_STR );
         break;

      case MSG_PR_SYMBOL_PRT_PFUNC:
         msgString = CMsg( MSG_PR_SYMBOL_PRT, MSG_PR_SYMBOL_PRT_STR );
         break;

      case MSG_PR_FMT_BUILTIN_ERR_PFUNC:
         msgString = CMsg( MSG_PR_FMT_BUILTIN_ERR, MSG_PR_FMT_BUILTIN_ERR_STR );
         break;

      case MSG_PR_FMT_INDEX_TOO_BIG_PFUNC:
         msgString = CMsg( MSG_PR_FMT_INDEX_TOO_BIG, MSG_PR_FMT_INDEX_TOO_BIG_STR );
         break;

      case MSG_PR_INSTVAR_ACCESS_PFUNC:
         msgString = CMsg( MSG_PR_INSTVAR_ACCESS, MSG_PR_INSTVAR_ACCESS_STR );
         break;

      case MSG_PR_ASCII_VALUE_PFUNC:
         msgString = CMsg( MSG_PR_ASCII_VALUE, MSG_PR_ASCII_VALUE_STR );
         break;

      case MSG_PR_NEW_CLASS_PFUNC:
         msgString = CMsg( MSG_PR_NEW_CLASS, MSG_PR_NEW_CLASS_STR );
         break;

      case MSG_PR_INSTALL_CLASS1_PFUNC:
         msgString = CMsg( MSG_PR_INSTALL_CLASS1, MSG_PR_INSTALL_CLASS1_STR );
         break;

      case MSG_PR_INSTALL_CLASS2_PFUNC:
         msgString = CMsg( MSG_PR_INSTALL_CLASS2, MSG_PR_INSTALL_CLASS2_STR );
         break;

      case MSG_FMT_PR_NOCLASS_PFUNC:
         msgString = CMsg( MSG_FORMAT_PR_NOCLASS, MSG_FORMAT_PR_NOCLASS_STR );
         break;

      case MSG_PR_FIND_CLASS_PFUNC:
         msgString = CMsg( MSG_PR_FIND_CLASS, MSG_PR_FIND_CLASS_STR );
         break;

      case MSG_PR_STRINGLEN_PFUNC:
         msgString = CMsg( MSG_PR_STRINGLEN, MSG_PR_STRINGLEN_STR );
         break;

      case MSG_PR_STRINGCOMP_PFUNC:
         msgString = CMsg( MSG_PR_STRINGCOMP, MSG_PR_STRINGCOMP_STR );
         break;

      case MSG_PR_STRCP_NOCASE_PFUNC:
         msgString = CMsg( MSG_PR_STRCP_NOCASE, MSG_PR_STRCP_NOCASE_STR );
         break;

      case MSG_PR_STRINGCAT_PFUNC:
         msgString = CMsg( MSG_PR_STRINGCAT, MSG_PR_STRINGCAT_STR );
         break;

      case MSG_PR_STRING_AT_PFUNC:
         msgString = CMsg( MSG_PR_STRING_AT, MSG_PR_STRING_AT_STR );
         break;

      case MSG_PR_STRING_ATPUT_PFUNC:
         msgString = CMsg( MSG_PR_STRING_ATPUT, MSG_PR_STRING_ATPUT_STR );
         break;

      case MSG_PR_COPYFROM_PFUNC:
         msgString = CMsg( MSG_PR_COPYFROM, MSG_PR_COPYFROM_STR );
         break;

      case MSG_PR_STRINGCOPY_PFUNC:
         msgString = CMsg( MSG_PR_STRINGCOPY, MSG_PR_STRINGCOPY_STR );
         break;

      case MSG_PR_STR_AS_SYM_PFUNC:
        msgString = CMsg( MSG_PR_STR_AS_SYM, MSG_PR_STR_AS_SYM_STR );
         break;

      case MSG_PR_STR_PRTSTR_PFUNC:
         msgString = CMsg( MSG_PR_STR_PRTSTR, MSG_PR_STR_PRTSTR_STR );
         break;

      case MSG_PR_NEW_OBJECT_PFUNC:
         msgString = CMsg( MSG_PR_NEW_OBJECT, MSG_PR_NEW_OBJECT_STR );
         break;

      case MSG_FMT_RE_NULL_POINTER_PFUNC:
         msgString = CMsg( MSG_FORMAT_RE_NULL_POINTER, MSG_FORMAT_RE_NULL_POINTER_STR );
         break;

      case MSG_RQTITLE_USERPGM_ERROR_PFUNC:
         msgString = CMsg( MSG_RQTITLE_USERPGM_ERROR, MSG_RQTITLE_USERPGM_ERROR_STR );
         break;

      case MSG_PR_OBJECT_AT_PFUNC:
         msgString = CMsg( MSG_PR_OBJECT_AT, MSG_PR_OBJECT_AT_STR );
         break;

      case MSG_PR_OBJECT_ATPUT_PFUNC:
         msgString = CMsg( MSG_PR_OBJECT_ATPUT, MSG_PR_OBJECT_ATPUT_STR );
         break;

      case MSG_PR_OBJECT_GROW_PFUNC:
         msgString = CMsg( MSG_PR_OBJECT_GROW, MSG_PR_OBJECT_GROW_STR );
         break;

      case MSG_PR_NEW_ARRAY_PFUNC:
         msgString = CMsg( MSG_PR_NEW_ARRAY, MSG_PR_NEW_ARRAY_STR );
         break;

      case MSG_PR_NEW_STRING_PFUNC:
         msgString = CMsg( MSG_PR_NEW_STRING, MSG_PR_NEW_STRING_STR );
         break;

      case MSG_FMT_BY_BADRNGE_PFUNC:
         msgString = CMsg( MSG_FORMAT_BY_BADRNGE, MSG_FORMAT_BY_BADRNGE_STR );
         break;

      case MSG_PR_NEW_BARRAY_PFUNC:
         msgString = CMsg( MSG_PR_NEW_BARRAY, MSG_PR_NEW_BARRAY_STR );
         break;

      case MSG_PR_BARRAY_SIZE_PFUNC:
         msgString = CMsg( MSG_PR_BARRAY_SIZE, MSG_PR_BARRAY_SIZE_STR );
         break;

      case MSG_PR_BARRAY_AT_PFUNC:
         msgString = CMsg( MSG_PR_BARRAY_AT, MSG_PR_BARRAY_AT_STR );
         break;

      case MSG_PR_BARRAY_ATPUT_PFUNC:
         msgString = CMsg( MSG_PR_BARRAY_ATPUT, MSG_PR_BARRAY_ATPUT_STR );
         break;

      case MSG_PR_PRINT_NORET_PFUNC:
         msgString = CMsg( MSG_PR_PRINT_NORET, MSG_PR_PRINT_NORET_STR );
         break;

      case MSG_PR_PRINT_RETN_PFUNC:
         msgString = CMsg( MSG_PR_PRINT_RETN, MSG_PR_PRINT_RETN_STR );
         break;

      case MSG_PR_FMT_ERR_PFUNC:
         msgString = CMsg( MSG_PR_FORMAT_ERR, MSG_PR_FORMAT_ERR_STR );
         break;

      case MSG_PR_ERROR_PRT_PFUNC:
         msgString = CMsg( MSG_PR_ERROR_PRT, MSG_PR_ERROR_PRT_STR );
         break;

      case MSG_PR_SYS_CALL_PFUNC:
         msgString = CMsg( MSG_PR_SYS_CALL, MSG_PR_SYS_CALL_STR );
         break;

      case MSG_PR_PRINT_AT_PFUNC:
         msgString = CMsg( MSG_PR_PRINT_AT, MSG_PR_PRINT_AT_STR );
         break;

      case MSG_NO_CURSES_PKG_PFUNC:
         msgString = CMsg( MSG_NO_CURSES_PKG, MSG_NO_CURSES_PKG_STR );
         break;

      case MSG_PR_BLOCK_RETN_PFUNC:
         msgString = CMsg( MSG_PR_BLOCK_RETN, MSG_PR_BLOCK_RETN_STR );
         break;

      case MSG_NO_BLK_CTXT_PFUNC:
         msgString = CMsg( MSG_NO_BLK_CTXT, MSG_NO_BLK_CTXT_STR );
         break;

      case MSG_PR_REF_ERROR_PFUNC:
         msgString = CMsg( MSG_PR_REF_ERROR, MSG_PR_REF_ERROR_STR );
         break;

      case MSG_FMT_OBJ_REFCNT_PFUNC:
         msgString = CMsg( MSG_FORMAT_OBJ_REFCNT, MSG_FORMAT_OBJ_REFCNT_STR );
         break;

      case MSG_FMT_RSP_ERROR_PFUNC:
         msgString = CMsg( MSG_FORMAT_RSP_ERROR, MSG_FORMAT_RSP_ERROR_STR );
         break;

      case MSG_PR_NO_RESPONSE_PFUNC:
         msgString = CMsg( MSG_PR_NO_RESPONSE, MSG_PR_NO_RESPONSE_STR );
         break;

      case MSG_FMT_NO_RESPOND_PFUNC:
         msgString = CMsg( MSG_FORMAT_NO_RESPOND, MSG_FORMAT_NO_RESPOND_STR );
         break;

      case MSG_PR_FILE_OPEN_PFUNC:
         msgString = CMsg( MSG_PR_FILE_OPEN, MSG_PR_FILE_OPEN_STR );
         break;

      case MSG_PR_FILE_READ_PFUNC:
         msgString = CMsg( MSG_PR_FILE_READ, MSG_PR_FILE_READ_STR );
         break;

      case MSG_PR_FILE_WRITE_PFUNC:
         msgString = CMsg( MSG_PR_FILE_WRITE, MSG_PR_FILE_WRITE_STR );
         break;

      case MSG_PR_SETFILE_MODE_PFUNC:
         msgString = CMsg( MSG_PR_SETFILE_MODE, MSG_PR_SETFILE_MODE_STR );
         break;

      case MSG_PR_GETFILE_SIZE_PFUNC:
         msgString = CMsg( MSG_PR_GETFILE_SIZE, MSG_PR_GETFILE_SIZE_STR );
         break;

      case MSG_PR_SETFILE_POS_PFUNC:
         msgString = CMsg( MSG_PR_SETFILE_POS, MSG_PR_SETFILE_POS_STR );
         break;

      case MSG_PR_GETFILE_POS_PFUNC:
         msgString = CMsg( MSG_PR_GETFILE_POS, MSG_PR_GETFILE_POS_STR );
         break;

      case MSG_PR_FILE_CLOSE_PFUNC:
         msgString = CMsg( MSG_PR_FILE_CLOSE, MSG_PR_FILE_CLOSE_STR );
         break;

      case MSG_PR_BLOCK_EXEC_PFUNC:
         msgString = CMsg( MSG_PR_BLOCK_EXEC, MSG_PR_BLOCK_EXEC_STR );
         break;

      case MSG_NO_BLK_EXEC_PFUNC:
         msgString = CMsg( MSG_NO_BLK_EXEC, MSG_NO_BLK_EXEC_STR );
         break;

      case MSG_FMT_WRONG_ARGS_PFUNC:
         msgString = CMsg( MSG_FORMAT_WRONG_ARGS, MSG_FORMAT_WRONG_ARGS_STR );
         break;

      case MSG_PR_NEW_PROCESS_PFUNC:
         msgString = CMsg( MSG_PR_NEW_PROCESS, MSG_PR_NEW_PROCESS_STR );
         break;

      case MSG_PR_TERM_PROCESS_PFUNC:
         msgString = CMsg( MSG_PR_TERM_PROCESS, MSG_PR_TERM_PROCESS_STR );
         break;

      case MSG_PR_PRFM_WARGS_PFUNC:
         msgString = CMsg( MSG_PR_PRFM_WARGS, MSG_PR_PRFM_WARGS_STR );
         break;

      case MSG_PERFORM_NOTRAP_PFUNC:
         msgString = CMsg( MSG_PERFORM_NOTRAP, MSG_PERFORM_NOTRAP_STR );
         break;

      case MSG_PROC_READY_PFUNC:
         msgString = CMsg( MSG_PROC_READY, MSG_PROC_READY_STR );
         break;

      case MSG_PROC_SUSPENDED_PFUNC:
         msgString = CMsg( MSG_PROC_SUSPENDED, MSG_PROC_SUSPENDED_STR );
         break;

      case MSG_PROC_BLOCKED_PFUNC:
         msgString = CMsg( MSG_PROC_BLOCKED, MSG_PROC_BLOCKED_STR );
         break;

      case MSG_PROC_UNBLOCKED_PFUNC:
         msgString = CMsg( MSG_PROC_UNBLOCKED, MSG_PROC_UNBLOCKED_STR );
         break;

      case MSG_INVALID_STATE_PR_PFUNC:
         msgString = CMsg( MSG_INVALID_STATE_PR, MSG_INVALID_STATE_PR_STR );
         break;

      case MSG_PR_SET_PROCSTATE_PFUNC:
         msgString = CMsg( MSG_PR_SET_PROCSTATE, MSG_PR_SET_PROCSTATE_STR );
         break;

      case MSG_PROC_TERMINATED_PFUNC:
         msgString = CMsg( MSG_PROC_TERMINATED, MSG_PROC_TERMINATED_STR );
         break;

      case MSG_PROC_CUR_STATE_PFUNC:
         msgString = CMsg( MSG_PROC_CUR_STATE, MSG_PROC_CUR_STATE_STR );
         break;

      case MSG_PR_GET_PROCSTATE_PFUNC:
         msgString = CMsg( MSG_PR_GET_PROCSTATE, MSG_PR_GET_PROCSTATE_STR );
         break;

      case MSG_PR_BEGIN_ATOMIC_PFUNC:
         msgString = CMsg( MSG_PR_BEGIN_ATOMIC, MSG_PR_BEGIN_ATOMIC_STR );
         break;

      case MSG_NOT_ATOMIC_PFUNC:
         msgString = CMsg( MSG_NOT_ATOMIC, MSG_NOT_ATOMIC_STR );
         break;

      case MSG_PR_END_ATOMIC_PFUNC:
         msgString = CMsg( MSG_PR_END_ATOMIC, MSG_PR_END_ATOMIC_STR );
         break;

      case MSG_PR_EDIT_CLASSFILE_PFUNC:
         msgString = CMsg( MSG_PR_EDIT_CLASSFILE, MSG_PR_EDIT_CLASSFILE_STR );
         break;

      case MSG_FMT_COPY_CMD_PFUNC:
         msgString = CMsg( MSG_FORMAT_COPY_CMD, MSG_FORMAT_COPY_CMD_STR );
         break;

      case MSG_PR_FIND_SUPERCLASS_PFUNC:
         msgString = CMsg( MSG_PR_FIND_SUPERCLASS, MSG_PR_FIND_SUPERCLASS_STR );
         break;

      case MSG_NIL_EQUAL_PFUNC:
         msgString = CMsg( MSG_NIL_EQUAL, MSG_NIL_EQUAL_STR );
         break;

      case MSG_PR_GET_CLASSNAME_PFUNC:
         msgString = CMsg( MSG_PR_GET_CLASSNAME, MSG_PR_GET_CLASSNAME_STR );
         break;

      case MSG_PR_CLASS_NEW_PFUNC:
         msgString = CMsg( MSG_PR_CLASS_NEW, MSG_PR_CLASS_NEW_STR );
         break;

      case MSG_LX_NIL_STR_PFUNC:
         msgString = CMsg( MSG_LX_NIL_STR, MSG_LX_NIL_STR_STR );
         break;

      case MSG_ARGUMENTS_STRING_PFUNC:
         msgString = CMsg( MSG_ARGUMENTS_STRING, MSG_ARGUMENTS_STRING_STR );
         break;

      case MSG_PR_PRNT_MSGS_PFUNC:
         msgString = CMsg( MSG_PR_PRNT_MSGS, MSG_PR_PRNT_MSGS_STR );
         break;

      case MSG_PR_CLASS_RESPONSE_PFUNC:
         msgString = CMsg( MSG_PR_CLASS_RESPONSE, MSG_PR_CLASS_RESPONSE_STR );
         break;

      case MSG_PR_VIEW_CLASS_PFUNC:
         msgString = CMsg( MSG_PR_VIEW_CLASS, MSG_PR_VIEW_CLASS_STR );
         break;

      case MSG_PR_LIST_SUBS_PFUNC:
         msgString = CMsg( MSG_PR_LIST_SUBS, MSG_PR_LIST_SUBS_STR );
         break;

      case MSG_PR_CLASS_INSTS_PFUNC:
         msgString = CMsg( MSG_PR_CLASS_INSTS, MSG_PR_CLASS_INSTS_STR );
         break;

      case MSG_PR_GET_BARRAY_PFUNC:
         msgString = CMsg( MSG_PR_GET_BARRAY, MSG_PR_GET_BARRAY_STR );
         break;

      case MSG_PR_GET_CTIME_PFUNC:
         msgString = CMsg( MSG_PR_GET_CTIME, MSG_PR_GET_CTIME_STR );
         break;

      case MSG_PR_TIME_CNTR_PFUNC:
         msgString = CMsg( MSG_PR_TIME_CNTR, MSG_PR_TIME_CNTR_STR );
         break;

      case MSG_PR_CLR_SCREEN_PFUNC:
         msgString = CMsg( MSG_PR_CLR_SCREEN, MSG_PR_CLR_SCREEN_STR );
         break;

      case MSG_PR_GET_STRING_PFUNC:
         msgString = CMsg( MSG_PR_GET_STRING, MSG_PR_GET_STRING_STR );
         break;

      case MSG_PR_STR2INT_PFUNC:
         msgString = CMsg( MSG_PR_STR2INT, MSG_PR_STR2INT_STR );
         break;

      case MSG_PR_STR2FLOAT_PFUNC:
         msgString = CMsg( MSG_PR_STR2FLOAT, MSG_PR_STR2FLOAT_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR PrimCMsg( int whichString ) // Primitive.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_PR_CHKFILEATTR_PRIM:
         msgString = CMsg( MSG_PR_CHKFILEATTR, MSG_PR_CHKFILEATTR_STR );
         break;

      case MSG_PR_WRITEABLE_PRIM:
         msgString = CMsg( MSG_PR_WRITEABLE, MSG_PR_WRITEABLE_STR );
         break;

      case MSG_PR_RETURNERROR_PRIM:
         msgString = CMsg( MSG_PR_RETURNERROR, MSG_PR_RETURNERROR_STR );
         break;

      case MSG_FMT_PR_ERROR_PRIM:
         msgString = CMsg( MSG_FORMAT_PR_ERROR, MSG_FORMAT_PR_ERROR_STR );
         break;

      case MSG_PR_PRTARGTYPEERR_PRIM:
         msgString = CMsg( MSG_PR_PRTARGTYPEERR, MSG_PR_PRTARGTYPEERR_STR );
         break;

      case MSG_FMT_PR_ARGTYPE_PRIM:
         msgString = CMsg( MSG_FORMAT_PR_ARGTYPE, MSG_FORMAT_PR_ARGTYPE_STR );
         break;

      case MSG_PR_PRTNUMBERERR_PRIM:
         msgString = CMsg( MSG_PR_PRTNUMBERERR, MSG_PR_PRTNUMBERERR_STR );
         break;

      case MSG_PR_NUMERICALERR_PRIM:
         msgString = CMsg( MSG_PR_NUMERICALERR, MSG_PR_NUMERICALERR_STR );
         break;

      case MSG_PR_PRTINDEXERR_PRIM:
         msgString = CMsg( MSG_PR_PRTINDEXERR, MSG_PR_PRTINDEXERR_STR );
         break;

      case MSG_PR_PRIMINDEXERR_PRIM:
         msgString = CMsg( MSG_PR_PRIMINDEXERR, MSG_PR_PRIMINDEXERR_STR );
         break;

      case MSG_PR_PRTARRAYERR_PRIM:
         msgString = CMsg( MSG_PR_PRTARRAYERR, MSG_PR_PRTARRAYERR_STR );
         break;

      case MSG_PR_PRIMARRAYERR_PRIM:
         msgString = CMsg( MSG_PR_PRIMARRAYERR, MSG_PR_PRIMARRAYERR_STR );
         break;

      case MSG_PR_UNKCLASSNAME_PRIM:
         msgString = CMsg( MSG_PR_UNKCLASSNAME, MSG_PR_UNKCLASSNAME_STR );
         break;

      case MSG_PR_BOOTSTRAP_PRIM:
         msgString = CMsg( MSG_PR_BOOTSTRAP, MSG_PR_BOOTSTRAP_STR );
         break;

      case MSG_PR_UNKPRIMITIVE_PRIM:
         msgString = CMsg( MSG_PR_UNKPRIMITIVE, MSG_PR_UNKPRIMITIVE_STR );
         break;

      case MSG_FMT_PR_UNUSED_PRIM:
         msgString = CMsg( MSG_FORMAT_PR_UNUSED, MSG_FORMAT_PR_UNUSED_STR );
         break;

      case MSG_PR_PROGRMR_ERR_PRIM:
         msgString = CMsg( MSG_PR_PROGRMR_ERR, MSG_PR_PROGRMR_ERR_STR );
         break;

      case MSG_PR_ARGCNT_ERR_PRIM:
         msgString = CMsg( MSG_PR_ARGCNT_ERR, MSG_PR_ARGCNT_ERR_STR );
         break;

      case MSG_FMT_PR_ARGCNT_PRIM:
         msgString = CMsg( MSG_FORMAT_PR_ARGCNT, MSG_FORMAT_PR_ARGCNT_STR );
         break;

      case MSG_PR_FILEUNOPENED_PRIM:
         msgString = CMsg( MSG_PR_FILEUNOPENED, MSG_PR_FILEUNOPENED_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR PrtCMsg( int whichString ) // Printer.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_PRT_PDERR_NOERR_PRT:
         msgString = CMsg( MSG_PRT_PDERR_NOERR, MSG_PRT_PDERR_NOERR_STR );
         break;

      case MSG_FMT_PRT_DRIVE_ERR_PRT:
         msgString = CMsg( MSG_FORMAT_PRT_DRIVE_ERR, MSG_FORMAT_PRT_DRIVE_ERR_STR );
         break;

      case MSG_FMT_PRT_PDERR_UNK_PRT:
         msgString = CMsg( MSG_FORMAT_PRT_PDERR_UNK, MSG_FORMAT_PRT_PDERR_UNK_STR );
         break;

      case MSG_PRT_INVALID_OBJ_PRT:
         msgString = CMsg( MSG_PRT_INVALID_OBJ, MSG_PRT_INVALID_OBJ_STR );
         break;

      case MSG_OPENPRT_FUNC_PRT:
         msgString = CMsg( MSG_OPENPRT_FUNC, MSG_OPENPRT_FUNC_STR );
         break;

      case MSG_PRINTER_CLASSNAME_PRT:
         msgString = CMsg( MSG_PRINTER_CLASSNAME, MSG_PRINTER_CLASSNAME_STR );
         break;

      case MSG_RASTPORT_CLASSNAME_PRT:
         msgString = CMsg( MSG_RASTPORT_CLASSNAME, MSG_RASTPORT_CLASSNAME_STR );
         break;

      case MSG_COLORMAP_CLASSNAME_PRT:
         msgString = CMsg( MSG_COLORMAP_CLASSNAME, MSG_COLORMAP_CLASSNAME_STR );
         break;

      case MSG_PRINTER_DRIVER_PRT:
         msgString = CMsg( MSG_PRINTER_DRIVER, MSG_PRINTER_DRIVER_STR );
         break;

      case MSG_READ_PRINTERPREFS_PRT:
         msgString = CMsg( MSG_READ_PRINTERPREFS, MSG_READ_PRINTERPREFS_STR );
         break;

      case MSG_WRITE_PRINTERPREFS_PRT:
         msgString = CMsg( MSG_WRITE_PRINTERPREFS, MSG_WRITE_PRINTERPREFS_STR );
         break;

      case MSG_EDIT_PRINTERPREFS_PRT:
         msgString = CMsg( MSG_EDIT_PRINTERPREFS, MSG_EDIT_PRINTERPREFS_STR );
         break;

      case MSG_PRT_ERROR_HOOK_PRT:
         msgString = CMsg( MSG_PRT_ERROR_HOOK, MSG_PRT_ERROR_HOOK_STR );
         break;

      case MSG_PRINTER_UNOPENED_PRT:
         msgString = CMsg( MSG_PRINTER_UNOPENED, MSG_PRINTER_UNOPENED_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogPrinter() [3.0] ***************************************
*
* NAME
*    CatalogPrinter()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogPrinter( void ) // Printer.c
{
   IMPORT char *PrtClasses[];
   IMPORT char *PrtCClasses[ 18 ];
   IMPORT char *PrtErrors[ 15 ];

   PrtClasses[0] = CMsg( MSG_PCLASS_PPC_BWALPHA, MSG_PCLASS_PPC_BWALPHA_STR ); // == 0x00
   PrtClasses[1] = CMsg( MSG_PCLASS_PPC_BWGFX,   MSG_PCLASS_PPC_BWGFX_STR   ); // == 0x01
   PrtClasses[2] = CMsg( MSG_PCLASS_PPC_COLORALPHA, MSG_PCLASS_PPC_COLORALPHA_STR ); // == 0x02
   PrtClasses[3] = CMsg( MSG_PCLASS_PPC_COLORGFX, MSG_PCLASS_PPC_COLORGFX_STR ); // == 0x03
   PrtClasses[4] = CMsg( MSG_PCLASS_PPC_EXTEND,   MSG_PCLASS_PPC_EXTEND_STR   ); // == 0x04
   PrtClasses[5] = CMsg( MSG_PCLASS_IMPOSSIBLE,   MSG_PCLASS_IMPOSSIBLE_STR   );
   PrtClasses[6] = CMsg( MSG_PCLASS_IMPOSSIBLE,   MSG_PCLASS_IMPOSSIBLE_STR   );
   PrtClasses[7] = CMsg( MSG_PCLASS_IMPOSSIBLE,   MSG_PCLASS_IMPOSSIBLE_STR   );
   PrtClasses[8] = CMsg( MSG_PCLASS_PPCF_NOSTRIP, MSG_PCLASS_PPCF_NOSTRIP_STR ); // == 0x08

   PrtCClasses[0]  = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[1]  = CMsg( MSG_PRT_PCC_BW,  MSG_PRT_PCC_BW_STR  ); // == 0x01
   PrtCClasses[2]  = CMsg( MSG_PRT_PCC_YMC, MSG_PRT_PCC_YMC_STR ); // == 0x02
   PrtCClasses[3]  = CMsg( MSG_PRT_PCC_YMC_BW, MSG_PRT_PCC_YMC_BW_STR ); // == 0x03
   PrtCClasses[4]  = CMsg( MSG_PRT_PCC_YMCB,   MSG_PRT_PCC_YMCB_STR   ); // == 0x04
   PrtCClasses[5]  = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[6]  = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[7]  = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[8]  = CMsg( MSG_PRT_PCC_ADDITIVE,   MSG_PRT_PCC_ADDITIVE_STR   ); // == 0x08
   PrtCClasses[9]  = CMsg( MSG_PRT_PCC_WB,         MSG_PRT_PCC_WB_STR     ); // == 0x09
   PrtCClasses[10] = CMsg( MSG_PRT_PCC_BGR,        MSG_PRT_PCC_BGR_STR    ); // == 0x0A
   PrtCClasses[11] = CMsg( MSG_PRT_PCC_BGR_WB,     MSG_PRT_PCC_BGR_WB_STR ); // == 0x0B
   PrtCClasses[12] = CMsg( MSG_PRT_PCC_BGRW,       MSG_PRT_PCC_BGRW_STR   ); // == 0x0C
   PrtCClasses[13] = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[14] = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[15] = CMsg( MSG_PRT_PCC_IMPOSSIBLE, MSG_PRT_PCC_IMPOSSIBLE_STR );
   PrtCClasses[16] = CMsg( MSG_PRT_PCC_MULTI,      MSG_PRT_PCC_MULTI_STR      ); // == 0x10

   PrtErrors[0]  = CMsg( MSG_PRT_PDERR_BADLEN,    MSG_PRT_PDERR_BADLEN_STR    ); // == -4
   PrtErrors[1]  = CMsg( MSG_PRT_PDERR_NOCMD,     MSG_PRT_PDERR_NOCMD_STR     ); // == -3 
   PrtErrors[2]  = CMsg( MSG_PRT_PDERR_ABORTED,   MSG_PRT_PDERR_ABORTED_STR   ); // == -2
   PrtErrors[3]  = CMsg( MSG_PRT_PDERR_OPENFAIL,  MSG_PRT_PDERR_OPENFAIL_STR  ); // == -1
   PrtErrors[4]  = CMsg( MSG_PRT_PDERR_NOERR,     MSG_PRT_PDERR_NOERR_STR     ); // == 0
   PrtErrors[5]  = CMsg( MSG_PRT_PDERR_CANCEL,    MSG_PRT_PDERR_CANCEL_STR    ); // == 1
   PrtErrors[6]  = CMsg( MSG_PRT_PDERR_NOTGFX,    MSG_PRT_PDERR_NOTGFX_STR    ); // etc...
   PrtErrors[7]  = CMsg( MSG_PRT_PDERR_INVERTHAM, MSG_PRT_PDERR_INVERTHAM_STR );
   PrtErrors[8]  = CMsg( MSG_PRT_PDERR_BAD_DIM,   MSG_PRT_PDERR_BAD_DIM_STR   );
   PrtErrors[9]  = CMsg( MSG_PRT_PDERR_DIM_OVFLW, MSG_PRT_PDERR_DIM_OVFLW_STR );
   PrtErrors[10] = CMsg( MSG_PRT_PDERR_MEMORY,    MSG_PRT_PDERR_MEMORY_STR    );
   PrtErrors[11] = CMsg( MSG_PRT_PDERR_BUFF_MEM,  MSG_PRT_PDERR_BUFF_MEM_STR  );
   PrtErrors[12] = CMsg( MSG_PRT_PDERR_CONTROL,   MSG_PRT_PDERR_CONTROL_STR   );
   PrtErrors[13] = CMsg( MSG_PRT_PDERR_BAD_PREFS, MSG_PRT_PDERR_BAD_PREFS_STR );
   
   return( 0 );
}

PUBLIC STRPTR ProcCMsg( int whichString ) // Process.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_WARN1_PROC:
         msgString = CMsg( MSG_PROC_WARN1, MSG_PROC_WARN1_STR );
         break;

      case MSG_WARN2_PROC:
         msgString = CMsg( MSG_PROC_WARN2, MSG_PROC_WARN2_STR );
         break;

      case MSG_WARN3_PROC:
         msgString = CMsg( MSG_PROC_WARN3, MSG_PROC_WARN3_STR );
         break;

      }
      
   return( msgString );
}

PUBLIC STRPTR RErrsCMsg( int whichString ) // ReportErrs.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_TAKE_A_PAUSE_RERR:
         msgString = CMsg( MSG_TAKE_A_PAUSE, MSG_TAKE_A_PAUSE_STR ); 
         break;

      case MSG_PRESS_OKAY_TOGO_RERR:
         msgString = CMsg( MSG_PRESS_OKAY_TOGO, MSG_PRESS_OKAY_TOGO_STR ); 
         break;

      case MSG_FMT_RE_NOT_PERFORM_RERR:
         msgString = CMsg( MSG_FORMAT_RE_NOT_PERFORM, MSG_FORMAT_RE_NOT_PERFORM_STR );
         break;

      case MSG_FMT_RE_NULL_POINTER_RERR:
         msgString = CMsg( MSG_FORMAT_RE_NULL_POINTER, MSG_FORMAT_RE_NULL_POINTER_STR );
         break;

      case MSG_FMT_RE_CANT_HAPPEN_RERR:
         msgString = CMsg( MSG_FORMAT_RE_CANT_HAPPEN, MSG_FORMAT_RE_CANT_HAPPEN_STR );
         break;

      case MSG_PR_ARGCNT_ERR_RERR:
         msgString = CMsg( MSG_PR_ARGCNT_ERR, MSG_PR_ARGCNT_ERR_STR );
         break;

      case MSG_RQTITLE_ARGCNT_ERR_RERR:
         msgString = CMsg( MSG_RQTITLE_ARGCNT_ERR, MSG_RQTITLE_ARGCNT_ERR_STR );
         break;

      case MSG_FMT_RE_OUTOF_RANGE_RERR:
         msgString = CMsg( MSG_FORMAT_RE_OUTOF_RANGE, MSG_FORMAT_RE_OUTOF_RANGE_STR );
         break;

      case MSG_FMT_RE_FOUND_NULLPTR_RERR:
         msgString = CMsg( MSG_FORMAT_RE_FOUND_NULLPTR, MSG_FORMAT_RE_FOUND_NULLPTR_STR ); 
         break;

      case MSG_FMT_RE_ALREADYOPEN_RERR:
         msgString = CMsg( MSG_FORMAT_RE_ALREADYOPEN, MSG_FORMAT_RE_ALREADYOPEN_STR ); 
         break;

      case MSG_FMT_RE_ZERO_OBJ_RERR:
         msgString = CMsg( MSG_FORMAT_RE_ZERO_OBJ, MSG_FORMAT_RE_ZERO_OBJ_STR );
         break;

      case MSG_FMT_RE_CHKTOOL_RERR:
         msgString = CMsg( MSG_FORMAT_RE_CHKTOOL, MSG_FORMAT_RE_CHKTOOL_STR );
         break;

      case MSG_FMT_RE_NOT_FOUND_RERR:
         msgString = CMsg( MSG_FORMAT_RE_NOT_FOUND, MSG_FORMAT_RE_NOT_FOUND_STR );
         break;

      case MSG_FMT_RE_ASK_INVALID_RERR:
         msgString = CMsg( MSG_FORMAT_RE_ASK_INVALID, MSG_FORMAT_RE_ASK_INVALID_STR );
         break;

      case MSG_FMT_RE_NO_MEMORY_RERR:
         msgString = CMsg( MSG_FORMAT_RE_NO_MEMORY, MSG_FORMAT_RE_NO_MEMORY_STR );
         break;

      case MSG_FMT_RE_NO_SUPPORT_RERR:
         msgString = CMsg( MSG_FORMAT_RE_NO_SUPPORT, MSG_FORMAT_RE_NO_SUPPORT_STR );
         break;

      case MSG_FMT_RE_CANNOT_RERR:
         msgString = CMsg( MSG_FORMAT_RE_CANNOT, MSG_FORMAT_RE_CANNOT_STR );
         break;

      case MSG_RE_OPENFILE_RERR:
         msgString = CMsg( MSG_RE_OPENFILE, MSG_RE_OPENFILE_STR );
         break;

      case MSG_RE_CREATEPORT_RERR:
         msgString = CMsg( MSG_RE_CREATEPORT, MSG_RE_CREATEPORT_STR );
         break;

      case MSG_RE_CREATESTDIO_RERR:
         msgString = CMsg( MSG_RE_CREATESTDIO, MSG_RE_CREATESTDIO_STR );
         break;

      case MSG_RE_CREATEEXTIO_RERR:
         msgString = CMsg( MSG_RE_CREATEEXTIO, MSG_RE_CREATEEXTIO_STR );
         break;

      case MSG_RE_OPENDEVICE_RERR:
         msgString = CMsg( MSG_RE_OPENDEVICE, MSG_RE_OPENDEVICE_STR );
         break;

      case MSG_RE_CREATE_STR_RERR:
         msgString = CMsg( MSG_RE_CREATE_STR, MSG_RE_CREATE_STR_STR );
         break;

      case MSG_RE_SETUP_STR_RERR:
         msgString = CMsg( MSG_RE_SETUP_STR, MSG_RE_SETUP_STR_STR );
         break;

      case MSG_RE_OPEN_STR_RERR:
         msgString = CMsg( MSG_RE_OPEN_STR, MSG_RE_OPEN_STR_STR );
         break;

      case MSG_RE_ASCREEN_RERR:
         msgString = CMsg( MSG_RE_ASCREEN, MSG_RE_ASCREEN_STR );
         break;

      case MSG_RE_AWINDOW_RERR:
         msgString = CMsg( MSG_RE_AWINDOW, MSG_RE_AWINDOW_STR );
         break;

      case MSG_RE_AFILE_RERR:
         msgString = CMsg( MSG_RE_AFILE, MSG_RE_AFILE_STR );
         break;

      case MSG_RE_ANIMAGEFILE_RERR:
         msgString = CMsg( MSG_RE_ANIMAGEFILE, MSG_RE_ANIMAGEFILE_STR );
         break;

      case MSG_RE_ALIBRARY_RERR:
         msgString = CMsg( MSG_RE_ALIBRARY, MSG_RE_ALIBRARY_STR );
         break;

      case MSG_RE_STATUSWINDOW_RERR:
         msgString = CMsg( MSG_RE_STATUSWINDOW, MSG_RE_STATUSWINDOW_STR );
         break;

      case MSG_RE_ADISKFONT_RERR:
         msgString = CMsg( MSG_RE_ADISKFONT, MSG_RE_ADISKFONT_STR );
         break;

      case MSG_RE_ANOBJECT_RERR:
         msgString = CMsg( MSG_RE_ANOBJECT, MSG_RE_ANOBJECT_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogErrStrings() [3.0] ************************************
*
* NAME
*    CatalogErrStrings()
*
* DESCRIPTION
*    Setup localized error strings.  Called by SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogErrStrings( void ) // ReportErrs.c
{
   IMPORT STRPTR ArgHelp;
   IMPORT STRPTR RDATemplate;

   IMPORT UBYTE *ATalkProblem;
   IMPORT UBYTE *SystemProblem;
   IMPORT UBYTE *AllocProblem;
   IMPORT UBYTE *UserProblem;
   IMPORT UBYTE *UserPgmError;
   IMPORT UBYTE *FATAL_ERROR;
   IMPORT UBYTE *FATAL_USER_ERROR;
   IMPORT UBYTE *FATAL_INTERROR;
   IMPORT UBYTE *InternalError;
   IMPORT UBYTE *AaarrggButton;
   IMPORT UBYTE *DefaultButtons;

   ArgHelp     = CMsg( MSG_ARG_HELP,     MSG_ARG_HELP_STR     );
   RDATemplate = CMsg( MSG_RDA_TEMPLATE, MSG_RDA_TEMPLATE_STR );
   
   // ---------- Common Error Requester titles: ----------------------

   ATalkProblem     = CMsg( MSG_RQTITLE_ATALK_PROBLEM,    MSG_RQTITLE_ATALK_PROBLEM_STR );
   SystemProblem    = CMsg( MSG_RQTITLE_SYSTEM_PROBLEM,   MSG_RQTITLE_SYSTEM_PROBLEM_STR );
   AllocProblem     = CMsg( MSG_RQTITLE_ALLOC_PROBLEM,    MSG_RQTITLE_ALLOC_PROBLEM_STR );
   UserProblem      = CMsg( MSG_RQTITLE_USER_ERROR,       MSG_RQTITLE_USER_ERROR_STR );
   UserPgmError     = CMsg( MSG_RQTITLE_USERPGM_ERROR,    MSG_RQTITLE_USERPGM_ERROR_STR );
   FATAL_ERROR      = CMsg( MSG_RQTITLE_FATAL_ERROR,      MSG_RQTITLE_FATAL_ERROR_STR );
   FATAL_USER_ERROR = CMsg( MSG_RQTITLE_FATAL_USER_ERROR, MSG_RQTITLE_FATAL_USER_ERROR_STR );
   FATAL_INTERROR   = CMsg( MSG_RQTITLE_FATAL_INTERROR,   MSG_RQTITLE_FATAL_INTERROR_STR );
   InternalError    = CMsg( MSG_RQTITLE_INTERNAL_ERROR,   MSG_RQTITLE_INTERNAL_ERROR_STR );

   // ---------- For The Buttons: ------------------------------------

   AaarrggButton  = CMsg( MSG_HURTZ_BUTTON_STR,    MSG_HURTZ_BUTTON_STR_STR    );
   DefaultButtons = CMsg( MSG_DEFAULT_BUTTONS_STR, MSG_DEFAULT_BUTTONS_STR_STR );
   
   return( 0 );
}

PUBLIC STRPTR ReqCMsg( int whichString ) // Requester.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_REQADD_FUNC_REQ:
         msgString = CMsg( MSG_REQ_REQADD_FUNC, MSG_REQ_REQADD_FUNC_STR );
         break;

      }
      
   return( msgString );
}

PUBLIC STRPTR RexxCMsg( int whichString ) // Rexx.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_OPEN_AREXX_FUNC_REXX:
         msgString = CMsg( MSG_OPEN_AREXX_FUNC, MSG_OPEN_AREXX_FUNC_STR );
         break;

      case MSG_PUBLIC_REXXPORT_REXX:
         msgString = CMsg( MSG_PUBLIC_REXXPORT, MSG_PUBLIC_REXXPORT_STR );
         break;

      case MSG_RXERR_OUTOF_RANGE_REXX:
         msgString = CMsg( MSG_RXERR_OUTOF_RANGE, MSG_RXERR_OUTOF_RANGE_STR );
         break;

      case MSG_REXX_TOO_MANY_ARGS_REXX:
         msgString = CMsg( MSG_REXX_TOO_MANY_ARGS, MSG_REXX_TOO_MANY_ARGS_STR );
         break;

      case MSG_FMT_TERM_CODE_REXX:
         msgString = CMsg( MSG_FORMAT_TERM_CODE, MSG_FORMAT_TERM_CODE_STR );
         break;

      case MSG_PARM_OUTOF_RANGE_REXX:
         msgString = CMsg( MSG_PARM_OUTOF_RANGE, MSG_PARM_OUTOF_RANGE_STR ); 
         break;
      }
      
   return( msgString );
}

/****h* CatalogRexx() [3.0] ******************************************
*
* NAME
*    CatalogRexx()
*
* DESCRIPTION
*    Localize error strings.  Called by SetupMiscCatalogs() 
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogRexx( void ) // RExx.c
{
   IMPORT char *rxErrors[ 50 ];
   
   rxErrors[ 0] = CMsg( MSG_RXERR_NO_ERROR,       MSG_RXERR_NO_ERROR_STR );
   rxErrors[ 1] = CMsg( MSG_RXERR_PGM_NOTFOUND,   MSG_RXERR_PGM_NOTFOUND_STR );
   rxErrors[ 2] = CMsg( MSG_RXERR_EX_HALTED,      MSG_RXERR_EX_HALTED_STR );
   rxErrors[ 3] = CMsg( MSG_RXERR_NO_MEMORY,      MSG_RXERR_NO_MEMORY_STR );
   rxErrors[ 4] = CMsg( MSG_RXERR_CHAR_INVALID,   MSG_RXERR_CHAR_INVALID_STR );
   rxErrors[ 5] = CMsg( MSG_RXERR_QUOTE_UNMATCH,  MSG_RXERR_QUOTE_UNMATCH_STR );
   rxErrors[ 6] = CMsg( MSG_RXERR_CMNT_UNTERMD,   MSG_RXERR_CMNT_UNTERMD_STR );
   rxErrors[ 7] = CMsg( MSG_RXERR_LONG_CLAUSE,    MSG_RXERR_LONG_CLAUSE_STR );
   rxErrors[ 8] = CMsg( MSG_RXERR_TOKEN_UNKNOWN,  MSG_RXERR_TOKEN_UNKNOWN_STR );
   rxErrors[ 9] = CMsg( MSG_RXERR_TOO_LONG,       MSG_RXERR_TOO_LONG_STR );
   rxErrors[10] = CMsg( MSG_RXERR_PKT_INVALID,    MSG_RXERR_PKT_INVALID_STR );
   rxErrors[11] = CMsg( MSG_RXERR_CMDSTR_ERROR,   MSG_RXERR_CMDSTR_ERROR_STR );
   rxErrors[12] = CMsg( MSG_RXERR_FUNC_ERROR,     MSG_RXERR_FUNC_ERROR_STR );
   rxErrors[13] = CMsg( MSG_RXERR_HOST_UNKNOWN,   MSG_RXERR_HOST_UNKNOWN_STR );
   rxErrors[14] = CMsg( MSG_RXERR_LIB_NOTFOUND,   MSG_RXERR_LIB_NOTFOUND_STR );
   rxErrors[15] = CMsg( MSG_RXERR_FUNC_NOTFOUND,  MSG_RXERR_FUNC_NOTFOUND_STR );
   rxErrors[16] = CMsg( MSG_RXERR_NO_RETVALUE,    MSG_RXERR_NO_RETVALUE_STR );
   rxErrors[17] = CMsg( MSG_RXERR_ARGCNT_WRONG,   MSG_RXERR_ARGCNT_WRONG_STR );
   rxErrors[18] = CMsg( MSG_RXERR_ARG_INVALID,    MSG_RXERR_ARG_INVALID_STR );
   rxErrors[19] = CMsg( MSG_RXERR_PROC_INVALID,   MSG_RXERR_PROC_INVALID_STR );
   rxErrors[20] = CMsg( MSG_RXERR_UNEXP_THEN,     MSG_RXERR_UNEXP_THEN_STR );
   rxErrors[21] = CMsg( MSG_RXERR_UNEXP_WHEN,     MSG_RXERR_UNEXP_WHEN_STR );
   rxErrors[22] = CMsg( MSG_RXERR_UNEXP_LEAVE,    MSG_RXERR_UNEXP_LEAVE_STR );
   rxErrors[23] = CMsg( MSG_RXERR_STMT_INVALID,   MSG_RXERR_STMT_INVALID_STR );
   rxErrors[24] = CMsg( MSG_RXERR_THEN_MISSING,   MSG_RXERR_THEN_MISSING_STR );
   rxErrors[25] = CMsg( MSG_RXERR_OTHER_MISSING,  MSG_RXERR_OTHER_MISSING_STR );
   rxErrors[26] = CMsg( MSG_RXERR_END_MISSING,    MSG_RXERR_END_MISSING_STR );
   rxErrors[27] = CMsg( MSG_RXERR_MISMATCH,       MSG_RXERR_MISMATCH_STR );
   rxErrors[28] = CMsg( MSG_RXERR_DO_INVALID,     MSG_RXERR_DO_INVALID_STR );
   rxErrors[29] = CMsg( MSG_RXERR_DO_INCOMPLETE,  MSG_RXERR_DO_INCOMPLETE_STR );
   rxErrors[30] = CMsg( MSG_RXERR_LABEL_NOTFOUND, MSG_RXERR_LABEL_NOTFOUND_STR );
   rxErrors[31] = CMsg( MSG_RXERR_EXP_SYMBOL,     MSG_RXERR_EXP_SYMBOL_STR );
   rxErrors[32] = CMsg( MSG_RXERR_EXP_STRING,     MSG_RXERR_EXP_STRING_STR );
   rxErrors[33] = CMsg( MSG_RXERR_KEY_INVALID,    MSG_RXERR_KEY_INVALID_STR );
   rxErrors[34] = CMsg( MSG_RXERR_KEY_MISSING,    MSG_RXERR_KEY_MISSING_STR );
   rxErrors[35] = CMsg( MSG_RXERR_EXTRA_CHARS,    MSG_RXERR_EXTRA_CHARS_STR );
   rxErrors[36] = CMsg( MSG_RXERR_KEY_CONFLICT,   MSG_RXERR_KEY_CONFLICT_STR );
   rxErrors[37] = CMsg( MSG_RXERR_TEMP_INVALID,   MSG_RXERR_TEMP_INVALID_STR );
   rxErrors[38] = CMsg( MSG_RXERR_TRACE_INVALID,  MSG_RXERR_TRACE_INVALID_STR );
   rxErrors[39] = CMsg( MSG_RXERR_VAR_UNINITD,    MSG_RXERR_VAR_UNINITD_STR );
   rxErrors[40] = CMsg( MSG_RXERR_VAR_INVALID,    MSG_RXERR_VAR_INVALID_STR );
   rxErrors[41] = CMsg( MSG_RXERR_EXPR_INVALID,   MSG_RXERR_EXPR_INVALID_STR );
   rxErrors[42] = CMsg( MSG_RXERR_PAREN_MISSING,  MSG_RXERR_PAREN_MISSING_STR );
   rxErrors[43] = CMsg( MSG_RXERR_LEVEL_EXCEED,   MSG_RXERR_LEVEL_EXCEED_STR );
   rxErrors[44] = CMsg( MSG_RXERR_RESULT_INVALID, MSG_RXERR_RESULT_INVALID_STR );
   rxErrors[45] = CMsg( MSG_RXERR_EXPR_REQUIRED,  MSG_RXERR_EXPR_REQUIRED_STR );
   rxErrors[46] = CMsg( MSG_RXERR_BOOL_INVALID,   MSG_RXERR_BOOL_INVALID_STR );
   rxErrors[47] = CMsg( MSG_RXERR_ARITH_ERROR,    MSG_RXERR_ARITH_ERROR_STR );
   rxErrors[48] = CMsg( MSG_RXERR_OPER_INVALID,   MSG_RXERR_OPER_INVALID_STR );
   
   return( 0 );
}

PUBLIC STRPTR ScrnCMsg( int whichString ) // Screen.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_NO_CLOSE_SCRN:
         msgString = CMsg( MSG_SCRN_NO_CLOSE, MSG_SCRN_NO_CLOSE_STR );
         break;

      case MSG_MODE_NOT_FOUND_SCRN:
         msgString = CMsg( MSG_SCRN_MODE_NOT_FOUND, MSG_SCRN_MODE_NOT_FOUND_STR );
         break;

      case MSG_UNOPENED_SCRN:
         msgString = CMsg( MSG_SCRN_UNOPENED, MSG_SCRN_UNOPENED_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogScreen() [3.0] *************************************
*
* NAME
*    CatalogScreen()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
*******************************************************************
*
*/

PUBLIC int CatalogScreen( void ) // Screen.c
{
   IMPORT char *ScrErrStrs[ 12 ];
   
   ScrErrStrs[0] = CMsg( MSG_SCRN_NO_ERROR,     MSG_SCRN_NO_ERROR_STR     );
   ScrErrStrs[1] = CMsg( MSG_SCRN_NOMON_SPEC,   MSG_SCRN_NOMON_SPEC_STR   );
   ScrErrStrs[2] = CMsg( MSG_SCRN_NEWER_CHIPS,  MSG_SCRN_NEWER_CHIPS_STR  );
   ScrErrStrs[3] = CMsg( MSG_SCRN_NO_NORMAL,    MSG_SCRN_NO_NORMAL_STR    );
   ScrErrStrs[4] = CMsg( MSG_SCRN_NO_CHIP,      MSG_SCRN_NO_CHIP_STR      );
   ScrErrStrs[5] = CMsg( MSG_SCRN_PUB_OPEN,     MSG_SCRN_PUB_OPEN_STR     );
   ScrErrStrs[6] = CMsg( MSG_SCRN_UNKNOWN_MODE, MSG_SCRN_UNKNOWN_MODE_STR );
   ScrErrStrs[7] = CMsg( MSG_SCRN_TOO_DEEP,     MSG_SCRN_TOO_DEEP_STR     );
   ScrErrStrs[8] = CMsg( MSG_SCRN_NO_ATTACH,    MSG_SCRN_NO_ATTACH_STR    );
   ScrErrStrs[9] = CMsg( MSG_SCRN_MODE_UNAVAIL, MSG_SCRN_MODE_UNAVAIL_STR );

   return( 0 );
}

PUBLIC STRPTR SCSICMsg( int whichString ) // SCSI.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_OPEN_FUNC_SCSI:
         msgString = CMsg( MSG_OPEN_SCSI_FUNC, MSG_OPEN_SCSI_FUNC_STR );
         break;

      case MSG_OBJECT_SCSI:
         msgString = CMsg( MSG_SCSI_OBJECT, MSG_SCSI_OBJECT_STR );
         break;

      case MSG_NOT_EXISTS_SCSI:
         msgString = CMsg( MSG_SCSI_NOT_EXISTS, MSG_SCSI_NOT_EXISTS_STR ); 
         break;

      case MSG_SENSE_RETURN_SCSI:
         msgString = CMsg( MSG_SCSI_SENSE_RETURN, MSG_SCSI_SENSE_RETURN_STR );
         break;

      case MSG_CMDPROBLEM_SCSI:
         msgString = CMsg( MSG_SCSI_CMDPROBLEM, MSG_SCSI_CMDPROBLEM_STR );
         break;

      case MSG_OUT_RANGE_SCSI:
         msgString = CMsg( MSG_SCSI_OUT_RANGE, MSG_SCSI_OUT_RANGE_STR );
         break;

      case MSG_NOT_ENOUGH_SCSI:
         msgString = CMsg( MSG_SCSI_NOT_ENOUGH, MSG_SCSI_NOT_ENOUGH_STR );
         break;

      case MSG_HFERR_SUNIT_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_SUNIT, MSG_SCSI_HFERR_SUNIT_STR );
         break;

      case MSG_HFERR_DMA_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_DMA, MSG_SCSI_HFERR_DMA_STR );
         break;

      case MSG_HFERR_PHASE_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_PHASE, MSG_SCSI_HFERR_PHASE_STR );
         break;

      case MSG_HFERR_PARITY_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_PARITY, MSG_SCSI_HFERR_PARITY_STR );
         break;

      case MSG_HFERR_TIMEOUT_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_TIMEOUT, MSG_SCSI_HFERR_TIMEOUT_STR );
         break;

      case MSG_HFERR_BADSTAT_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_BADSTAT, MSG_SCSI_HFERR_BADSTAT_STR );
         break;

      case MSG_HFERR_UNKNOWN_SCSI:
         msgString = CMsg( MSG_SCSI_HFERR_UNKNOWN, MSG_SCSI_HFERR_UNKNOWN_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR SDictCMsg( int whichString ) // SDict.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FILE_IS_EMPTY_SDICT:
         msgString = CMsg( MSG_FILE_IS_EMPTY, MSG_FILE_IS_EMPTY_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR SGrphCMsg( int whichString ) // SGraphs.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ADD_IMAGE_FUNC_SGRPH:
         msgString = CMsg( MSG_ADD_IMAGE_FUNC, MSG_ADD_IMAGE_FUNC_STR );
         break;

      case MSG_GRAB_IMAGE_FUNC_SGRPH:
         msgString = CMsg( MSG_GRAB_IMAGE_FUNC, MSG_GRAB_IMAGE_FUNC_STR );
         break;

      case MSG_NO_TRANSLATE_CYBER_SGRPH:
         msgString = CMsg( MSG_NO_TRANSLATE_CYBER, MSG_NO_TRANSLATE_CYBER_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR StrCMsg( int whichString ) // String.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FREE_FUNC_STRING:
         msgString = CMsg( MSG_FREE_STRING_FUNC, MSG_FREE_STRING_FUNC_STR );
         break;

      }
      
   return( msgString );
}

PUBLIC STRPTR SymCMsg( int whichString ) // Symbol.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_GET_SYMBOL_FILE_SYMBOL:
         msgString = CMsg( MSG_GET_SYMBOL_FILE, MSG_GET_SYMBOL_FILE_STR ); 
         break;

      case MSG_NO_MEMORY_ALLOC_SYMBOL:
         msgString = CMsg( MSG_NO_MEMORY_ALLOC, MSG_NO_MEMORY_ALLOC_STR );
         break;

      case MSG_FILE_IS_EMPTY_SYMBOL:
         msgString = CMsg( MSG_FILE_IS_EMPTY, MSG_FILE_IS_EMPTY_STR );
         break;

      case MSG_ADDING_STR_SYMBOL:
         msgString = CMsg( MSG_ADDING_STR, MSG_ADDING_STR_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR SysCMsg( int whichString ) // System.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_TASKSTATE_INVALID_SYS:
         msgString = CMsg( MSG_TASKSTATE_INVALID, MSG_TASKSTATE_INVALID_STR );  
         break;

      case MSG_TASKSTATE_ADDED_SYS:
         msgString = CMsg( MSG_TASKSTATE_ADDED, MSG_TASKSTATE_ADDED_STR );
         break;

      case MSG_TASKSTATE_RUNNING_SYS:
         msgString = CMsg( MSG_TASKSTATE_RUNNING, MSG_TASKSTATE_RUNNING_STR );
         break;

      case MSG_PROC_READY_SYS:
         msgString = CMsg( MSG_PROC_READY, MSG_PROC_READY_STR );
         break;

      case MSG_TASKSTATE_WAITING_SYS:
         msgString = CMsg( MSG_TASKSTATE_WAITING, MSG_TASKSTATE_WAITING_STR );
         break;

      case MSG_TASKSTATE_EXCEPTION_SYS:
         msgString = CMsg( MSG_TASKSTATE_EXCEPTION, MSG_TASKSTATE_EXCEPTION_STR );
         break;

      case MSG_TASKSTATE_REMOVED_SYS:
         msgString = CMsg( MSG_TASKSTATE_REMOVED, MSG_TASKSTATE_REMOVED_STR );
         break;

      case MSG_TASKFLAG_PROCTIME_SYS:
         msgString = CMsg( MSG_TASKFLAG_PROCTIME, MSG_TASKFLAG_PROCTIME_STR );
         break;

      case MSG_TASKFLAG_ETASK_SYS:
         msgString = CMsg( MSG_TASKFLAG_ETASK, MSG_TASKFLAG_ETASK_STR );
         break;

      case MSG_TASKFLAG_STACKCHK_SYS:
         msgString = CMsg( MSG_TASKFLAG_STACKCHK, MSG_TASKFLAG_STACKCHK_STR );
         break;

      case MSG_TASKFLAG_EXCEPT_SYS:
         msgString = CMsg( MSG_TASKFLAG_EXCEPT, MSG_TASKFLAG_EXCEPT_STR );
         break;

      case MSG_TASKFLAG_SWITCH_SYS:
         msgString = CMsg( MSG_TASKFLAG_SWITCH, MSG_TASKFLAG_SWITCH_STR );
         break;

      case MSG_TASKFLAG_LAUNCH_SYS:
         msgString = CMsg( MSG_TASKFLAG_LAUNCH, MSG_TASKFLAG_LAUNCH_STR );
         break;

      case MSG_PROCESSNAME_SYS:
         msgString = CMsg( MSG_PROCESSNAME, MSG_PROCESSNAME_STR );
         break;

      case MSG_TASKNAME_SYS:
         msgString = CMsg( MSG_TASKNAME, MSG_TASKNAME_STR );
         break;

      case MSG_FMT_STATE_PRI_SYS:
         msgString = CMsg( MSG_FORMAT_STATE_PRI, MSG_FORMAT_STATE_PRI_STR );
         break;

      case MSG_FMT_SIGNALS_SYS:
         msgString = CMsg( MSG_FORMAT_SIGNALS, MSG_FORMAT_SIGNALS_STR );
         break;

      case MSG_FMT_TRAPS_SYS:
         msgString = CMsg( MSG_FORMAT_TRAPS, MSG_FORMAT_TRAPS_STR );
         break;

      case MSG_FMT_SWITCH_SYS:
         msgString = CMsg( MSG_FORMAT_SWITCH, MSG_FORMAT_SWITCH_STR );
         break;

      case MSG_FMT_EXCEPTDATA_SYS:
         msgString = CMsg( MSG_FORMAT_EXCEPTDATA, MSG_FORMAT_EXCEPTDATA_STR ); 
         break;

      case MSG_FMT_STKPNTR_SYS:
         msgString = CMsg( MSG_FORMAT_STKPNTR, MSG_FORMAT_STKPNTR_STR );
         break;

      case MSG_FMT_NESTCOUNT_SYS:
         msgString = CMsg( MSG_FORMAT_NESTCOUNT, MSG_FORMAT_NESTCOUNT_STR );
         break;

      case MSG_FMT_MEMENTRY_SYS:
         msgString = CMsg( MSG_FORMAT_MEMENTRY, MSG_FORMAT_MEMENTRY_STR );
         break;

      case MSG_PROCESS_STRUCT_SYS:
         msgString = CMsg( MSG_PROCESS_STRUCT, MSG_PROCESS_STRUCT_STR );
         break;

      case MSG_NO_TITLE_SYS:
         msgString = CMsg( MSG_NO_TITLE, MSG_NO_TITLE_STR );
         break;

      case MSG_FMT_WINDOWPTR_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWPTR, MSG_FORMAT_WINDOWPTR_STR );
         break;

      case MSG_FMT_CRNTDIR_SYS:
         msgString = CMsg( MSG_FORMAT_CRNTDIR, MSG_FORMAT_CRNTDIR_STR );
         break;

      case MSG_NO_PATH_SYS:
         msgString = CMsg( MSG_NO_PATH, MSG_NO_PATH_STR );
         break;

      case MSG_FMT_WINDOWMPORT_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWMPORT, MSG_FORMAT_WINDOWMPORT_STR );
         break;

      case MSG_FMT_STACKBASE_SYS:
         msgString = CMsg( MSG_FORMAT_STACKBASE, MSG_FORMAT_STACKBASE_STR );
         break;

      case MSG_FMT_CIS_COS_SYS:
         msgString = CMsg( MSG_FORMAT_CIS_COS, MSG_FORMAT_CIS_COS_STR );
         break;

      case MSG_FMT_CONSTASK_SYS:
         msgString = CMsg( MSG_FORMAT_CONSTASK, MSG_FORMAT_CONSTASK_STR );
         break;

      case MSG_FMT_PKTWAIT_SYS:
         msgString = CMsg( MSG_FORMAT_PKTWAIT, MSG_FORMAT_PKTWAIT_STR );
         break;

      case MSG_FMT_ARGUMENTS_SYS:
         msgString = CMsg( MSG_FORMAT_ARGUMENTS, MSG_FORMAT_ARGUMENTS_STR );
         break;

      case MSG_NO_ARGS_SYS:
         msgString = CMsg( MSG_NO_ARGS, MSG_NO_ARGS_STR );
         break;

      case MSG_FMT_GLOBVEC_SYS:
         msgString = CMsg( MSG_FORMAT_GLOBVEC, MSG_FORMAT_GLOBVEC_STR );
         break;

      case MSG_CLI_STRUCTURE_SYS:
         msgString = CMsg( MSG_CLI_STRUCTURE, MSG_CLI_STRUCTURE_STR );
         break;

      case MSG_FMT_CMDDIR_SYS:
         msgString = CMsg( MSG_FORMAT_CMDDIR, MSG_FORMAT_CMDDIR_STR );
         break;

      case MSG_FMT_STDIO_SYS:
         msgString = CMsg( MSG_FORMAT_STDIO, MSG_FORMAT_STDIO_STR );
         break;

      case MSG_FMT_CURRENTIO_SYS:
         msgString = CMsg( MSG_FORMAT_CURRENTIO, MSG_FORMAT_CURRENTIO_STR );
         break;

      case MSG_FMT_MODULE_SYS:
         msgString = CMsg( MSG_FORMAT_MODULE, MSG_FORMAT_MODULE_STR );
         break;

      case MSG_BACKGROUND_STR_SYS:
         msgString = CMsg( MSG_BACKGROUND_STR, MSG_BACKGROUND_STR_STR );
         break;

      case MSG_INTERACTIVE_STR_SYS:
         msgString = CMsg( MSG_INTERACTIVE_STR, MSG_INTERACTIVE_STR_STR );
         break;

      case MSG_SCREENFLAG_CUSTOM_SYS:
         msgString = CMsg( MSG_SCREENFLAG_CUSTOM, MSG_SCREENFLAG_CUSTOM_STR );
         break;

      case MSG_SCREENFLAG_WBENCH_SYS:
         msgString = CMsg( MSG_SCREENFLAG_WBENCH, MSG_SCREENFLAG_WBENCH_STR );
         break;

      case MSG_SCREENFLAG_SHOWTITLE_SYS:
         msgString = CMsg( MSG_SCREENFLAG_SHOWTITLE, MSG_SCREENFLAG_SHOWTITLE_STR );
         break;

      case MSG_SCREENFLAG_BEEPING_SYS:
         msgString = CMsg( MSG_SCREENFLAG_BEEPING, MSG_SCREENFLAG_BEEPING_STR );
         break;

      case MSG_SCREENFLAG_CBITMAP_SYS:
         msgString = CMsg( MSG_SCREENFLAG_CBITMAP, MSG_SCREENFLAG_CBITMAP_STR );
         break;

      case MSG_VIEWMODE_HIRES_SYS:
         msgString = CMsg( MSG_VIEWMODE_HIRES, MSG_VIEWMODE_HIRES_STR );
         break;

      case MSG_VIEWMODE_SPRITES_SYS:
         msgString = CMsg( MSG_VIEWMODE_SPRITES, MSG_VIEWMODE_SPRITES_STR );
         break;

      case MSG_VIEWMODE_VP_HIDE_SYS:
         msgString = CMsg( MSG_VIEWMODE_VP_HIDE, MSG_VIEWMODE_VP_HIDE_STR );
         break;

      case MSG_VIEWMODE_EXTENDED_SYS:
         msgString = CMsg( MSG_VIEWMODE_EXTENDED, MSG_VIEWMODE_EXTENDED_STR );
         break;

      case MSG_VIEWMODE_HAM_SYS:
         msgString = CMsg( MSG_VIEWMODE_HAM, MSG_VIEWMODE_HAM_STR );
         break;

      case MSG_VIEWMODE_DUALPF_SYS:
         msgString = CMsg( MSG_VIEWMODE_DUALPF, MSG_VIEWMODE_DUALPF_STR );
         break;

      case MSG_VIEWMODE_GENLOCKA_SYS:
         msgString = CMsg( MSG_VIEWMODE_GENLOCKA, MSG_VIEWMODE_GENLOCKA_STR );
         break;

      case MSG_VIEWMODE_PFBA_SYS:
         msgString = CMsg( MSG_VIEWMODE_PFBA, MSG_VIEWMODE_PFBA_STR );
         break;

      case MSG_VIEWMODE_LACE_SYS:
         msgString = CMsg( MSG_VIEWMODE_LACE, MSG_VIEWMODE_LACE_STR );
         break;

      case MSG_VIEWMODE_DBLSCAN_SYS:
         msgString = CMsg( MSG_VIEWMODE_DBLSCAN, MSG_VIEWMODE_DBLSCAN_STR );
         break;

      case MSG_VIEWMODE_SUPERHIRES_SYS:
         msgString = CMsg( MSG_VIEWMODE_SUPERHIRES, MSG_VIEWMODE_SUPERHIRES_STR );
         break;

      case MSG_VIEWMODE_XTRAHALF_SYS:
         msgString = CMsg( MSG_VIEWMODE_XTRAHALF, MSG_VIEWMODE_XTRAHALF_STR );
         break;

      case MSG_VIEWMODE_GENLOCKV_SYS:
         msgString = CMsg( MSG_VIEWMODE_GENLOCKV, MSG_VIEWMODE_GENLOCKV_STR );
         break;

      case MSG_W_SIZEGADGET_STR_SYS:
         msgString = CMsg( MSG_W_SIZEGADGET_STR, MSG_W_SIZEGADGET_STR_STR );
         break;

      case MSG_W_DRAGBAR_STR_SYS:
         msgString = CMsg( MSG_W_DRAGBAR_STR, MSG_W_DRAGBAR_STR_STR );
         break;

      case MSG_W_DEPTHGADGET_STR_SYS:
         msgString = CMsg( MSG_W_DEPTHGADGET_STR, MSG_W_DEPTHGADGET_STR_STR );
         break;

      case MSG_W_CLOSEGADGET_STR_SYS:
         msgString = CMsg( MSG_W_CLOSEGADGET_STR, MSG_W_CLOSEGADGET_STR_STR );
         break;

      case MSG_W_SMARTREF_STR_SYS:
         msgString = CMsg( MSG_W_SMARTREF_STR, MSG_W_SMARTREF_STR_STR );
         break;

      case MSG_W_SIMPLEREF_STR_SYS:
         msgString = CMsg( MSG_W_SIMPLEREF_STR, MSG_W_SIMPLEREF_STR_STR );
         break;

      case MSG_W_SUPERBMAP_STR_SYS:
         msgString = CMsg( MSG_W_SUPERBMAP_STR, MSG_W_SUPERBMAP_STR_STR );
         break;

      case MSG_W_OTHERREF_STR_SYS:
         msgString = CMsg( MSG_W_OTHERREF_STR, MSG_W_OTHERREF_STR_STR );
         break;

      case MSG_W_GIMMEZERO_STR_SYS:
         msgString = CMsg( MSG_W_GIMMEZERO_STR, MSG_W_GIMMEZERO_STR_STR );
         break;

      case MSG_W_BACKDROP_STR_SYS:
         msgString = CMsg( MSG_W_BACKDROP_STR, MSG_W_BACKDROP_STR_STR );
         break;

      case MSG_W_REPORTMOUSE_STR_SYS:
         msgString = CMsg( MSG_W_REPORTMOUSE_STR, MSG_W_REPORTMOUSE_STR_STR );
         break;

      case MSG_W_BORDERLESS_STR_SYS:
         msgString = CMsg( MSG_W_BORDERLESS_STR, MSG_W_BORDERLESS_STR_STR );
         break;

      case MSG_W_ACTIVATE_STR_SYS:
         msgString = CMsg( MSG_W_ACTIVATE_STR, MSG_W_ACTIVATE_STR_STR );
         break;

      case MSG_W_SIZEBRITE_STR_SYS:
         msgString = CMsg( MSG_W_SIZEBRITE_STR, MSG_W_SIZEBRITE_STR_STR );
         break;

      case MSG_W_SIZEBOTT_STR_SYS:
         msgString = CMsg( MSG_W_SIZEBOTT_STR, MSG_W_SIZEBOTT_STR_STR );
         break;

      case MSG_W_RMBTRAP_STR_SYS:
         msgString = CMsg( MSG_W_RMBTRAP_STR, MSG_W_RMBTRAP_STR_STR );
         break;

      case MSG_W_NOCAREREF_STR_SYS:
         msgString = CMsg( MSG_W_NOCAREREF_STR, MSG_W_NOCAREREF_STR_STR );
         break;

      case MSG_W_WINDOWACTIVE_STR_SYS:
         msgString = CMsg( MSG_W_WINDOWACTIVE_STR, MSG_W_WINDOWACTIVE_STR_STR );
         break;

      case MSG_W_WBENCHWIN_STR_SYS:
         msgString = CMsg( MSG_W_WBENCHWIN_STR, MSG_W_WBENCHWIN_STR_STR );
         break;

      case MSG_W_HASZOOM_STR_SYS:
         msgString = CMsg( MSG_W_HASZOOM_STR, MSG_W_HASZOOM_STR_STR );
         break;

      case MSG_W_ZOOMED_STR_SYS:
         msgString = CMsg( MSG_W_ZOOMED_STR, MSG_W_ZOOMED_STR_STR );
         break;

      case MSG_ID_SIZEVERIFY_STR_SYS:
         msgString = CMsg( MSG_ID_SIZEVERIFY_STR, MSG_ID_SIZEVERIFY_STR_STR );
         break;

      case MSG_ID_NEWSIZE_STR_SYS:
         msgString = CMsg( MSG_ID_NEWSIZE_STR, MSG_ID_NEWSIZE_STR_STR );
         break;

      case MSG_ID_REFRESHW_STR_SYS:
         msgString = CMsg( MSG_ID_REFRESHW_STR, MSG_ID_REFRESHW_STR_STR );
         break;

      case MSG_ID_MOUSEBUTTS_STR_SYS:
         msgString = CMsg( MSG_ID_MOUSEBUTTS_STR, MSG_ID_MOUSEBUTTS_STR_STR );
         break;

      case MSG_ID_MOUSEMOVE_STR_SYS:
         msgString = CMsg( MSG_ID_MOUSEMOVE_STR, MSG_ID_MOUSEMOVE_STR_STR );
         break;

      case MSG_ID_GADGETDWN_STR_SYS:
         msgString = CMsg( MSG_ID_GADGETDWN_STR, MSG_ID_GADGETDWN_STR_STR );
         break;

      case MSG_ID_GADGETUP_STR_SYS:
         msgString = CMsg( MSG_ID_GADGETUP_STR, MSG_ID_GADGETUP_STR_STR );
         break;

      case MSG_ID_REQSET_STR_SYS:
         msgString = CMsg( MSG_ID_REQSET_STR, MSG_ID_REQSET_STR_STR );
         break;

      case MSG_ID_MENUPICK_STR_SYS:
         msgString = CMsg( MSG_ID_MENUPICK_STR, MSG_ID_MENUPICK_STR_STR );
         break;

      case MSG_ID_CLOSEW_STR_SYS:
         msgString = CMsg( MSG_ID_CLOSEW_STR, MSG_ID_CLOSEW_STR_STR );
         break;

      case MSG_ID_RAWKEY_STR_SYS:
         msgString = CMsg( MSG_ID_RAWKEY_STR, MSG_ID_RAWKEY_STR_STR );
         break;

      case MSG_ID_REQVERIFY_STR_SYS:
         msgString = CMsg( MSG_ID_REQVERIFY_STR, MSG_ID_REQVERIFY_STR_STR );
         break;

      case MSG_ID_REQCLEAR_STR_SYS:
         msgString = CMsg( MSG_ID_REQCLEAR_STR, MSG_ID_REQCLEAR_STR_STR );
         break;

      case MSG_ID_MENUVERIFY_STR_SYS:
         msgString = CMsg( MSG_ID_MENUVERIFY_STR, MSG_ID_MENUVERIFY_STR_STR );
         break;

      case MSG_ID_NEWPREFS_STR_SYS:
         msgString = CMsg( MSG_ID_NEWPREFS_STR, MSG_ID_NEWPREFS_STR_STR );
         break;

      case MSG_ID_DISKINS_STR_SYS:
         msgString = CMsg( MSG_ID_DISKINS_STR, MSG_ID_DISKINS_STR_STR );
         break;

      case MSG_ID_DISKREM_STR_SYS:
         msgString = CMsg( MSG_ID_DISKREM_STR, MSG_ID_DISKREM_STR_STR );
         break;

      case MSG_ID_WBENCHMSG_STR_SYS:
         msgString = CMsg( MSG_ID_WBENCHMSG_STR, MSG_ID_WBENCHMSG_STR_STR );
         break;

      case MSG_ID_ACTIVEW_STR_SYS:
         msgString = CMsg( MSG_ID_ACTIVEW_STR, MSG_ID_ACTIVEW_STR_STR );
         break;

      case MSG_ID_INACTIVEW_STR_SYS:
         msgString = CMsg( MSG_ID_INACTIVEW_STR, MSG_ID_INACTIVEW_STR_STR );
         break;

      case MSG_ID_DELTAMOVE_STR_SYS:
         msgString = CMsg( MSG_ID_DELTAMOVE_STR, MSG_ID_DELTAMOVE_STR_STR );
         break;

      case MSG_ID_VANILLA_STR_SYS:
         msgString = CMsg( MSG_ID_VANILLA_STR, MSG_ID_VANILLA_STR_STR );
         break;

      case MSG_ID_INTUITICKS_STR_SYS:
         msgString = CMsg( MSG_ID_INTUITICKS_STR, MSG_ID_INTUITICKS_STR_STR );
         break;

      case MSG_ID_UPDATE_STR_SYS:
         msgString = CMsg( MSG_ID_UPDATE_STR, MSG_ID_UPDATE_STR_STR );
         break;

      case MSG_ID_MENUHELP_STR_SYS:
         msgString = CMsg( MSG_ID_MENUHELP_STR, MSG_ID_MENUHELP_STR_STR );
         break;

      case MSG_ID_CHGWINDOW_STR_SYS:
         msgString = CMsg( MSG_ID_CHGWINDOW_STR, MSG_ID_CHGWINDOW_STR_STR );
         break;

      case MSG_ID_GADGETHELP_STR_SYS:
         msgString = CMsg( MSG_ID_GADGETHELP_STR, MSG_ID_GADGETHELP_STR_STR );
         break;

      case MSG_FMT_SCREENADDR_SYS:
         msgString = CMsg( MSG_FORMAT_SCREENADDR, MSG_FORMAT_SCREENADDR_STR );
         break;

      case MSG_FMT_DEFAULTTITLE_SYS:
         msgString = CMsg( MSG_FORMAT_DEFAULTTITLE, MSG_FORMAT_DEFAULTTITLE_STR );
         break;

      case MSG_FMT_SCRNCOORDS_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNCOORDS, MSG_FORMAT_SCRNCOORDS_STR ); 
         break;

      case MSG_FMT_SCRNBLEFT_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNBLEFT, MSG_FORMAT_SCRNBLEFT_STR ); 
         break;

      case MSG_FMT_SCRNBRITE_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNBRITE, MSG_FORMAT_SCRNBRITE_STR ); 
         break;

      case MSG_FMT_SCREENPENS_SYS:
         msgString = CMsg( MSG_FORMAT_SCREENPENS, MSG_FORMAT_SCREENPENS_STR ); 
         break;

      case MSG_FMT_SCRNVIEWADDR_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNVIEWADDR, MSG_FORMAT_SCRNVIEWADDR_STR ); 
         break;

      case MSG_FMT_SCRNBMAPADDR_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNBMAPADDR, MSG_FORMAT_SCRNBMAPADDR_STR ); 
         break;

      case MSG_FMT_SCRNEXTDATA_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNEXTDATA, MSG_FORMAT_SCRNEXTDATA_STR ); 
         break;

      case MSG_FMT_SCRNNEXTADDR_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNNEXTADDR, MSG_FORMAT_SCRNNEXTADDR_STR ); 
         break;

      case MSG_FMT_SCRNBARS_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNBARS, MSG_FORMAT_SCRNBARS_STR ); 
         break;

      case MSG_FMT_SCRNMENCOORDS_SYS:
         msgString = CMsg( MSG_FORMAT_SCRNMENCOORDS, MSG_FORMAT_SCRNMENCOORDS_STR ); 
         break;

      case MSG_VIEWMODES_COLON_SYS:
         msgString = CMsg( MSG_VIEWMODES_COLON, MSG_VIEWMODES_COLON_STR ); 
         break;

      case MSG_FMT_WINDOWADDR_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWADDR, MSG_FORMAT_WINDOWADDR_STR ); 
         break;

      case MSG_FMT_WSCRNADDR_SYS:
         msgString = CMsg( MSG_FORMAT_WSCRNADDR, MSG_FORMAT_WSCRNADDR_STR ); 
         break;

      case MSG_FMT_WINDOWCOORDS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWCOORDS, MSG_FORMAT_WINDOWCOORDS_STR );
         break;

      case MSG_FMT_WINDOWMINCRDS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWMINCRDS, MSG_FORMAT_WINDOWMINCRDS_STR );
         break;

      case MSG_FMT_WINDOWBDRCRDS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWBDRCRDS, MSG_FORMAT_WINDOWBDRCRDS_STR );
         break;

      case MSG_FMT_WINDOWOFFSETS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWOFFSETS, MSG_FORMAT_WINDOWOFFSETS_STR );
         break;

      case MSG_FMT_WINDOWCHKADDR_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWCHKADDR, MSG_FORMAT_WINDOWCHKADDR_STR );
         break;

      case MSG_FMT_WINDOWGADCNTS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWGADCNTS, MSG_FORMAT_WINDOWGADCNTS_STR );
         break;

      case MSG_FMT_WINDOWMENCNTS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWMENCNTS, MSG_FORMAT_WINDOWMENCNTS_STR );
         break;

      case MSG_FMT_WINDOWUPORT_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWUPORT, MSG_FORMAT_WINDOWUPORT_STR );
         break;

      case MSG_FMT_WINDOWWPORT_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWWPORT, MSG_FORMAT_WINDOWWPORT_STR );
         break;

      case MSG_FMT_WINDOWPTRCRDS_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWPTRCRDS, MSG_FORMAT_WINDOWPTRCRDS_STR );
         break;

      case MSG_FMT_WINDOWREQCNT_SYS:
         msgString = CMsg( MSG_FORMAT_WINDOWREQCNT, MSG_FORMAT_WINDOWREQCNT_STR );
         break;

      case MSG_IDCMPFLAGS_COLON_SYS:
         msgString = CMsg( MSG_IDCMPFLAGS_COLON, MSG_IDCMPFLAGS_COLON_STR );
         break;

      case MSG_TASKS_TITLE_SYS:
         msgString = CMsg( MSG_TASKS_TITLE, MSG_TASKS_TITLE_STR );
         break;

      case MSG_SCREENS_TITLE_SYS:
         msgString = CMsg( MSG_SCREENS_TITLE, MSG_SCREENS_TITLE_STR );
         break;

      case MSG_ADDRESS_PRI_STR_SYS:
         msgString = CMsg( MSG_ADDRESS_PRI_STR, MSG_ADDRESS_PRI_STR_STR );
         break;

      case MSG_ADDRESS_POS_STR_SYS:
         msgString = CMsg( MSG_ADDRESS_POS_STR, MSG_ADDRESS_POS_STR_STR );
         break;

      case MSG_OBJECT_IS_SYS:
         msgString = CMsg( MSG_OBJECT_IS, MSG_OBJECT_IS_STR );
         break;

      case MSG_FLAGS_COLON_SYS:
         msgString = CMsg( MSG_FLAGS_COLON, MSG_FLAGS_COLON_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogSystem() [2.3] ****************************************
*
* NAME
*    CatalogSystem()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogSystem( void ) // System.c
{
   IMPORT UBYTE            WTitle[ 80 ];
   IMPORT UBYTE            IWTitle[ 80 ];
   IMPORT struct NewGadget InfoNGad[ 3 ];
   
   InfoNGad[1].ng_GadgetText = CMsg( MSG_UPDATE_GAD, MSG_UPDATE_GAD_STR );
   InfoNGad[2].ng_GadgetText = CMsg( MSG_MORE_GAD,   MSG_MORE_GAD_STR   );
   
   StringNCopy( WTitle, CMsg( MSG_TASKS_TITLE, MSG_TASKS_TITLE_STR ), 80 );

   StringNCopy( IWTitle, 
                CMsg( MSG_TASKS_FULLINFO_TITLE, MSG_TASKS_FULLINFO_TITLE_STR ), 
                80 
              );
 
   return( 0 );
}

PUBLIC STRPTR TagCMsg( int whichString ) // TagFuncs.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ARG_NOT_ARRAY_TAG:
         msgString = CMsg( MSG_ARG_NOT_ARRAY, MSG_ARG_NOT_ARRAY_STR );
         break;

      case MSG_ARRAY2TAGLIST_FUNC_TAG:
         msgString = CMsg( MSG_ARRAY2TAGLIST_FUNC, MSG_ARRAY2TAGLIST_FUNC_STR );
         break;

      case MSG_BAD_ARRAY_SIZE_TAG:
         msgString = CMsg( MSG_BAD_ARRAY_SIZE, MSG_BAD_ARRAY_SIZE_STR );
         break;

      case MSG_ATGETTAGITEM_FUNC_TAG:
         msgString = CMsg( MSG_ATGETTAGITEM_FUNC, MSG_ATGETTAGITEM_FUNC_STR );
         break;

      case MSG_ADDTAGITEM_FUNC_TAG:
         msgString = CMsg( MSG_ADDTAGITEM_FUNC, MSG_ADDTAGITEM_FUNC_STR );
         break;

      case MSG_DELETETAGITEM_FUNC_TAG:
         msgString = CMsg( MSG_DELETETAGITEM_FUNC, MSG_DELETETAGITEM_FUNC_STR );
         break;

      case MSG_TAGLIST2ARRAY_FUNC_TAG:
         msgString = CMsg( MSG_TAGLIST2ARRAY_FUNC, MSG_TAGLIST2ARRAY_FUNC_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR ToolsCMsg( int whichString ) // Tools.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ICON_MISSING_TOOLS:
         msgString = CMsg( MSG_ICON_MISSING, MSG_ICON_MISSING_STR );
         break;

      case MSG_ICON_ENVFILE_TOOLS:
         msgString = CMsg( MSG_TT_ENVIRONFILE, MSG_TT_ENVIRONFILE_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogTools() [2.3] ******************************************
*
* NAME
*    CatalogTools()
*
* DESCRIPTION
*    Localize the names of ToolTypes.  Called by SetupMiscCatalogs()
*    in Setup.c only.
***********************************************************************
*
*/

PUBLIC int CatalogTools( void ) // Tools.c
{
   IMPORT UBYTE DefEnvironFile[ 128 ], *ENVIRONFILE;
   
   ENVIRONFILE = CMsg( MSG_TT_ENVIRONFILE, MSG_TT_ENVIRONFILE_STR );

   StringNCopy( DefEnvironFile, "AmigaTalk:AmigaTalk.ini", 128 );

   return;
}

PUBLIC STRPTR TraceCMsg( int whichString ) // Tracer.c & Tracer2.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_USERCLASS_HEADER_TRACE:
         msgString = CMsg( MSG_USERCLASS_HEADER, MSG_USERCLASS_HEADER_STR );
         break;

      case MSG_FMT_UNKNOWN_HEADER_TRACE:
         msgString = CMsg( MSG_FORMAT_UNKNOWN_HEADER, MSG_FORMAT_UNKNOWN_HEADER_STR );
         break;

      case MSG_FMT_CLASSSUPER_TRACE:
         msgString = CMsg( MSG_FORMAT_CLASSSUPER, MSG_FORMAT_CLASSSUPER_STR );
         break;

      case MSG_NO_SUPER_NAME_TRACE:
         msgString = CMsg( MSG_NO_SUPER_NAME, MSG_NO_SUPER_NAME_STR );
         break;

      case MSG_NO_CLASS_NAME_TRACE:
         msgString = CMsg( MSG_NO_CLASS_NAME, MSG_NO_CLASS_NAME_STR );
         break;

      case MSG_SPC_INST1_TRACE:
         msgString = CMsg( MSG_SPC_INST1, MSG_SPC_INST1_STR );
         break;

      case MSG_SPC4_INST_TRACE:
         msgString = CMsg( MSG_SPC4_INST, MSG_SPC4_INST_STR );
         break;

      case MSG_FMT_INST1_TRACE:
         msgString = CMsg( MSG_FORMAT_INST1, MSG_FORMAT_INST1_STR );
         break;

      case MSG_FMT2_INST_TRACE:
         msgString = CMsg( MSG_FORMAT2_INST, MSG_FORMAT2_INST_STR );
         break;

      case MSG_FMT4_INST_TRACE:
         msgString = CMsg( MSG_FORMAT4_INST, MSG_FORMAT4_INST_STR ); 
         break;

      case MSG_SPC2_INST_TRACE:
         msgString = CMsg( MSG_SPC2_INST, MSG_SPC2_INST_STR );
         break;

      case MSG_OBJECT_IS_TRACE:
         msgString = CMsg( MSG_OBJECT_IS, MSG_OBJECT_IS_STR );
         break;

      case MSG_CLASS_HEADER_TRACE:
         msgString = CMsg( MSG_CLASS_HEADER, MSG_CLASS_HEADER_STR );
         break;

      case MSG_BARRAY_HEADER_TRACE:
         msgString = CMsg( MSG_BARRAY_HEADER, MSG_BARRAY_HEADER_STR );
         break;

      case MSG_SYMBOL_HEADER_TRACE:
         msgString = CMsg( MSG_SYMBOL_HEADER, MSG_SYMBOL_HEADER_STR );
         break;

      case MSG_INTERP_HEADER_TRACE:
         msgString = CMsg( MSG_INTERP_HEADER, MSG_INTERP_HEADER_STR );
         break;

      case MSG_PROCESS_HEADER_TRACE:
         msgString = CMsg( MSG_PROCESS_HEADER, MSG_PROCESS_HEADER_STR );
         break;

      case MSG_BLOCK_HEADER_TRACE:
         msgString = CMsg( MSG_BLOCK_HEADER, MSG_BLOCK_HEADER_STR );
         break;

      case MSG_FILE_HEADER_TRACE:
         msgString = CMsg( MSG_FILE_HEADER, MSG_FILE_HEADER_STR );
         break;

      case MSG_CHAR_HEADER_TRACE:
         msgString = CMsg( MSG_CHAR_HEADER, MSG_CHAR_HEADER_STR );
         break;

      case MSG_INTEGER_HEADER_TRACE:
         msgString = CMsg( MSG_INTEGER_HEADER, MSG_INTEGER_HEADER_STR );
         break;

      case MSG_STRING_HEADER_TRACE:
         msgString = CMsg( MSG_STRING_HEADER, MSG_STRING_HEADER_STR );
         break;

      case MSG_FLOAT_HEADER_TRACE:
         msgString = CMsg( MSG_FLOAT_HEADER, MSG_FLOAT_HEADER_STR );
         break;

      case MSG_SPECIAL_HEADER_TRACE:
         msgString = CMsg( MSG_SPECIAL_HEADER, MSG_SPECIAL_HEADER_STR );
         break;

      case MSG_INITIALIZED_TRACE:
         msgString = CMsg( MSG_INITIALIZED, MSG_INITIALIZED_STR );
         break;

      case MSG_CLEAR_STR_TRACE:
         msgString = CMsg( MSG_CLEAR_STR, MSG_CLEAR_STR_STR );
         break;

      case MSG_ADDRESS_HEADER_TRACE:
         msgString = CMsg( MSG_ADDRESS_HEADER, MSG_ADDRESS_HEADER_STR );
         break;

      case MSG_FMT_TEMPOBJ_TRACE:
         msgString = CMsg( MSG_FORMAT_TEMPOBJ, MSG_FORMAT_TEMPOBJ_STR );
         break;

      case MSG_FMT_USEROBJ_TRACE:
         msgString = CMsg( MSG_FORMAT_USEROBJ, MSG_FORMAT_USEROBJ_STR );
         break;

      case MSG_NULL_QUESTION_TRACE:
         msgString = CMsg( MSG_NULL_QUESTION, MSG_NULL_QUESTION_STR );
         break;

      case MSG_FMT_SYMBOLVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_SYMBOLVAL, MSG_FORMAT_SYMBOLVAL_STR );
         break;

      case MSG_FMT_BARRAYVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_BARRAYVAL, MSG_FORMAT_BARRAYVAL_STR );
         break;

      case MSG_FMT_SYMBOLVAL2_TRACE:
         msgString = CMsg( MSG_FORMAT_SYMBOLVAL2, MSG_FORMAT_SYMBOLVAL2_STR );
         break;

      case MSG_FMT_INTERPVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_INTERPVAL, MSG_FORMAT_INTERPVAL_STR );
         break;

      case MSG_FMT_PROCESSADDR_TRACE:
         msgString = CMsg( MSG_FORMAT_PROCESSADDR, MSG_FORMAT_PROCESSADDR_STR );
         break;

      case MSG_FMT_INTERPADDR_TRACE:
         msgString = CMsg( MSG_FORMAT_INTERPADDR, MSG_FORMAT_INTERPADDR_STR );
         break;

      case MSG_FMT_FILEADDR_TRACE:
         msgString = CMsg( MSG_FORMAT_FILEADDR, MSG_FORMAT_FILEADDR_STR );
         break;

      case MSG_FMT_CHARVALUE_TRACE:
         msgString = CMsg( MSG_FORMAT_CHARVALUE, MSG_FORMAT_CHARVALUE_STR ); 
         break;

      case MSG_FMT_INTEGERVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_INTEGERVAL, MSG_FORMAT_INTEGERVAL_STR );
         break;

      case MSG_FMT_STRINGVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_STRINGVAL, MSG_FORMAT_STRINGVAL_STR ); 
         break;

      case MSG_FMT_FLOATVAL_TRACE:
         msgString = CMsg( MSG_FORMAT_FLOATVAL, MSG_FORMAT_FLOATVAL_STR ); 
         break;

      case MSG_CLASS_ARROW_TRACE:
         msgString = CMsg( MSG_CLASS_ARROW, MSG_CLASS_ARROW_STR );
         break;

      case MSG_BARRAY_ARROW_TRACE:
         msgString = CMsg( MSG_BARRAY_ARROW, MSG_BARRAY_ARROW_STR );
         break;

      case MSG_SYMBOL_ARROW_TRACE:
         msgString = CMsg( MSG_SYMBOL_ARROW, MSG_SYMBOL_ARROW_STR );
         break;

      case MSG_INTERP_ARROW_TRACE:
         msgString = CMsg( MSG_INTERP_ARROW, MSG_INTERP_ARROW_STR );
         break;

      case MSG_PROCESS_ARROW_TRACE:
         msgString = CMsg( MSG_PROCESS_ARROW, MSG_PROCESS_ARROW_STR );
         break;

      case MSG_BLOCK_ARROW_TRACE:
         msgString = CMsg( MSG_BLOCK_ARROW, MSG_BLOCK_ARROW_STR );
         break;

      case MSG_FILE_ARROW_TRACE:
         msgString = CMsg( MSG_FILE_ARROW, MSG_FILE_ARROW_STR );
         break;

      case MSG_CHAR_ARROW_TRACE:
         msgString = CMsg( MSG_CHAR_ARROW, MSG_CHAR_ARROW_STR );
         break;

      case MSG_INTEGER_ARROW_TRACE:
         msgString = CMsg( MSG_INTEGER_ARROW, MSG_INTEGER_ARROW_STR );
         break;

      case MSG_STRING_ARROW_TRACE:
         msgString = CMsg( MSG_STRING_ARROW, MSG_STRING_ARROW_STR );
         break;

      case MSG_FLOAT_ARROW_TRACE:
         msgString = CMsg( MSG_FLOAT_ARROW, MSG_FLOAT_ARROW_STR );
         break;

      // Tracer2.c Strings: -------------------------------------------------
      
      case MSG_INSTANCE_STR_TRACE:
         msgString = CMsg( MSG_INSTANCE_STR, MSG_INSTANCE_STR_STR );
         break;

      case MSG_CLASSGAD_STRING_TRACE:
         msgString = CMsg( MSG_CLASSGAD_STRING, MSG_CLASSGAD_STRING_STR );
         break;

      case MSG_SUPERGAD_STRING_TRACE:
         msgString = CMsg( MSG_SUPERGAD_STRING, MSG_SUPERGAD_STRING_STR );
         break;

      case MSG_DISP_LARGEARRAY_REQ_STR_TRACE:
         msgString = CMsg( MSG_DISP_LARGEARRAY_REQ_STR, MSG_DISP_LARGEARRAY_REQ_STR_STR ); 
         break;

      case MSG_NO_NAME_TRACE:
         msgString = CMsg( MSG_NO_NAME, MSG_NO_NAME_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC int CatalogTracer( void )
{
   IMPORT UBYTE           *TrWdt;
   IMPORT struct IntuiText TrIText[ 1 ];
   IMPORT struct NewGadget TrNGad[ 5 ];
      
   TrNGad[0].ng_GadgetText = CMsg( MSG_VARSLV_GAD,   MSG_VARSLV_GAD_STR   );
   TrNGad[1].ng_GadgetText = CMsg( MSG_VALUELV_GAD,  MSG_VALUELV_GAD_STR  );
   TrNGad[4].ng_GadgetText = CMsg( MSG_SHOWADDR_GAD, MSG_SHOWADDR_GAD_STR );

   TrIText[0].IText   = CMsg( MSG_PRESS_CLOSEGADGET, MSG_PRESS_CLOSEGADGET_STR );
   TrWdt              = CMsg( MSG_TRACER_TITLE,      MSG_TRACER_TITLE_STR      );

   return( 0 );
}

/****h* CatalogTracer2() [3.0] **************************************
*
* NAME
*    CatalogTracer2()
*
* DESCRIPTION
*    Initialize Tracer2 Gadget strings.  Called by 
*    SetupMiscCatalogs() in Setup.c only.
*********************************************************************
*
*/

PUBLIC int CatalogTracer2( void ) // Tracer2.c
{
   IMPORT UBYTE           *Tr2Wdt;
   IMPORT struct NewGadget Tr2NGad[ 6 ];
   
   Tr2NGad[0].ng_GadgetText = CMsg( MSG_CLASSTXT_GAD,    MSG_CLASSTXT_GAD_STR    );
   Tr2NGad[1].ng_GadgetText = CMsg( MSG_REFCOUNTTXT_GAD, MSG_REFCOUNTTXT_GAD_STR );
   Tr2NGad[2].ng_GadgetText = CMsg( MSG_SIZENUM_GAD,     MSG_SIZENUM_GAD_STR     );
   Tr2NGad[3].ng_GadgetText = CMsg( MSG_CLASSBT_GAD,     MSG_CLASSBT_GAD_STR     );
   Tr2NGad[4].ng_GadgetText = CMsg( MSG_SUPERBT_GAD,     MSG_SUPERBT_GAD_STR     );
   Tr2NGad[5].ng_GadgetText = CMsg( MSG_INSTLV_GAD,      MSG_INSTLV_GAD_STR      );

   Tr2Wdt = CMsg( MSG_TRACER_USERTITLE, MSG_TRACER_USERTITLE_STR );

   return( 0 );   
}

/* --------------------- END of CatFuncs3.c file! ----------------------- */
