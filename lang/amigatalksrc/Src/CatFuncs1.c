/****h* AmigaTalk/CatFuncs1.c [3.0] ********************************
*
* NAME
*    CatFuncs1.c
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
*    $VER: AmigaTalk:Src/CatFuncs1.c 3.0 (04-Jan-2005) by J.T. Steichen
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

PUBLIC struct Catalog *ATPCatalog = NULL; // for the ATalkEnviron.cd
PUBLIC struct Catalog *ATECatalog = NULL; // for the Amigatalk.ini interface.
PUBLIC struct Catalog *catalog    = NULL; // for the main bunch of locale strings.

#define   CATCOMP_ARRAY 1
#include "ATalkLocale.h"
#include "ATalkEnvironLocale.h"

#include "object.h"
#include "FuncProtos.h"

#include "CantHappen.h"
#include "StringIndexes.h"

/****h* CMsg() [2.3] *************************************************
*
* NAME
*    CMsg()
*
* DESCRIPTION
*    Obtain a string from the locale catalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PUBLIC STRPTR CMsg( int strIndex, STRPTR defaultString )
{
   if (catalog) // != NULL)
      return( (char *) GetCatalogStr( catalog, strIndex, defaultString ) );
   else
      return( defaultString );
}

/****h* ATECMsg() [3.0] **********************************************
*
* NAME
*    ATECMsg()
*
* DESCRIPTION
*    Obtain a string from the locale ATECatalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PUBLIC STRPTR ATECMsg( int strIndex, STRPTR defaultString )
{
   if (ATECatalog)
      return( (char *) GetCatalogStr( ATECatalog, strIndex, defaultString ) );
   else
      return( defaultString );
}

/****h* ATPCMsg() [3.0] **********************************************
*
* NAME
*    ATPCMsg()
*
* DESCRIPTION
*    Obtain a string from the locale ATPCatalog file, failing that,
*    return the default string.
**********************************************************************
*
*/

PUBLIC STRPTR ATPCMsg( int strIndex, STRPTR defaultString )
{
   if (ATPCatalog)
      return( (char *) GetCatalogStr( ATPCatalog, strIndex, defaultString ) );
   else
      return( defaultString );
}

PUBLIC STRPTR PalCMsg( int whichString ) // ATalkPalette.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ATP_WTITLE_PAL:
         msgString = ATPCMsg( MSG_PAL_WTITLE, MSG_PAL_WTITLE_STR ); // WA_Title
         break;
	 
      case MSG_GAD_Pal_PAL:
         msgString = CMsg( MSG_GAD_PaletteGad, MSG_GAD_PaletteGad_STR );
         break;
	 
      case MSG_GAD_Red_PAL:
         msgString = CMsg( MSG_GAD_RedSlider, MSG_GAD_RedSlider_STR );
         break;
	 
      case MSG_GAD_Green_PAL:
         msgString = CMsg( MSG_GAD_GreenSlider, MSG_GAD_GreenSlider_STR );
         break;
	 
      case MSG_GAD_Blue_PAL:
         msgString = CMsg( MSG_GAD_BlueSlider, MSG_GAD_BlueSlider_STR );
         break;
	 
      case MSG_GAD_PenNameTxt_PAL:
         msgString = CMsg( MSG_GAD_PNameTxt, MSG_GAD_PNameTxt_STR );
         break;
	 
      case MSG_GAD_SaveBt_PAL:
         msgString = CMsg( MSG_GAD_SaveBt, MSG_GAD_SaveBt_STR );
         break;
	 
      case MSG_GAD_ResetBt_PAL:
         msgString = CMsg( MSG_GAD_ResetBt, MSG_GAD_ResetBt_STR );
         break;
	 
      case MSG_GAD_CancelBt_PAL:
         msgString = CMsg( MSG_GAD_CancelBt, MSG_GAD_CancelBt_STR );
         break;
	 
      case MSG_GAD_UseBt_PAL:
         msgString = CMsg( MSG_GAD_UseBt, MSG_GAD_UseBt_STR );
         break;
	 
      case MSG_GAD_CColorTxt_PAL:
         msgString = CMsg( MSG_GAD_CColorTxt, MSG_GAD_CColorTxt_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN00_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN00, MSG_ATEGRP_ITEM_PEN00_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN01_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN01, MSG_ATEGRP_ITEM_PEN01_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN02_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN02, MSG_ATEGRP_ITEM_PEN02_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN03_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN03, MSG_ATEGRP_ITEM_PEN03_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN04_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN04, MSG_ATEGRP_ITEM_PEN04_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN05_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN05, MSG_ATEGRP_ITEM_PEN05_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN06_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN06, MSG_ATEGRP_ITEM_PEN06_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN07_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN07, MSG_ATEGRP_ITEM_PEN07_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN08_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN08, MSG_ATEGRP_ITEM_PEN08_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN09_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN09, MSG_ATEGRP_ITEM_PEN09_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0A_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0A, MSG_ATEGRP_ITEM_PEN0A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0B_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0B, MSG_ATEGRP_ITEM_PEN0B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0C_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0C, MSG_ATEGRP_ITEM_PEN0C_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0D_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0D, MSG_ATEGRP_ITEM_PEN0D_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0E_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0E, MSG_ATEGRP_ITEM_PEN0E_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0F_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN0F, MSG_ATEGRP_ITEM_PEN0F_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN10_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN10, MSG_ATEGRP_ITEM_PEN10_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN11_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN11, MSG_ATEGRP_ITEM_PEN11_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN12_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN12, MSG_ATEGRP_ITEM_PEN12_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN13_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN13, MSG_ATEGRP_ITEM_PEN13_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN14_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN14, MSG_ATEGRP_ITEM_PEN14_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN15_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN15, MSG_ATEGRP_ITEM_PEN15_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN16_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN16, MSG_ATEGRP_ITEM_PEN16_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN17_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN17, MSG_ATEGRP_ITEM_PEN17_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN18_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN18, MSG_ATEGRP_ITEM_PEN18_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN19_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN19, MSG_ATEGRP_ITEM_PEN19_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1A_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1A, MSG_ATEGRP_ITEM_PEN1A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1B_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1B, MSG_ATEGRP_ITEM_PEN1B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1C_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1C, MSG_ATEGRP_ITEM_PEN1C_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1D_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1D, MSG_ATEGRP_ITEM_PEN1D_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1E_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1E, MSG_ATEGRP_ITEM_PEN1E_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1F_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN1F, MSG_ATEGRP_ITEM_PEN1F_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN20_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN20, MSG_ATEGRP_ITEM_PEN20_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN21_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN21, MSG_ATEGRP_ITEM_PEN21_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN22_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN22, MSG_ATEGRP_ITEM_PEN22_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN23_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN23, MSG_ATEGRP_ITEM_PEN23_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN24_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN24, MSG_ATEGRP_ITEM_PEN24_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN25_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN25, MSG_ATEGRP_ITEM_PEN25_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN26_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN26, MSG_ATEGRP_ITEM_PEN26_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN27_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN27, MSG_ATEGRP_ITEM_PEN27_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN28_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN28, MSG_ATEGRP_ITEM_PEN28_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN29_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN29, MSG_ATEGRP_ITEM_PEN29_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2A_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN2A, MSG_ATEGRP_ITEM_PEN2A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2B_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN2B, MSG_ATEGRP_ITEM_PEN2B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2C_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_PEN2C, MSG_ATEGRP_ITEM_PEN2C_STR ); 
         break;
	 
      case MSG_ATEGRP_PALETTE_PAL:
         msgString = CMsg( MSG_ATEGRP_PALETTE, MSG_ATEGRP_PALETTE_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_NUM_PENS_PAL:
         msgString = CMsg( MSG_ATEGRP_ITEM_NUM_PENS, MSG_ATEGRP_ITEM_NUM_PENS_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR APrintCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_AP_REOPEN_APRINTF:
         msgString = CMsg( MSG_FORMAT_AP_REOPEN, MSG_FORMAT_AP_REOPEN_STR );
	 break;
	 
      case MSG_FMT_AP_NOCONSOLE_APRINTF:
         msgString = CMsg( MSG_FORMAT_AP_NOCONSOLE, MSG_FORMAT_AP_NOCONSOLE_STR );
	 break;
      }
      
   return( msgString );
}

PUBLIC STRPTR AboutCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_AR_ABOUT:
         msgString = CMsg( MSG_FORMAT_AR_ABOUT, MSG_FORMAT_AR_ABOUT_STR );
         break;
	 
      case MSG_FMT_AR_TITLE_ABOUT:
         msgString = CMsg( MSG_FORMAT_AR_TITLE, MSG_FORMAT_AR_TITLE_STR );
         break;
      }

   return( msgString );
}

PUBLIC STRPTR MainCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_DELETE_COMMAND_MAIN:
         msgString = CMsg( MSG_DELETE_COMMAND, MSG_DELETE_COMMAND_STR );
	 break;
      
      case MSG_NOMAKE_NULL_MAIN:
         msgString = CMsg( MSG_M_NOMAKE_NULL, MSG_M_NOMAKE_NULL_STR );
	 break;
	 
      case MSG_FMT_PRE_UNOPEN_MAIN:
         msgString = CMsg( MSG_FORMAT_PRE_UNOPEN, MSG_FORMAT_PRE_UNOPEN_STR );
	 break;

      case MSG_FMT_PRE_READING_MAIN:
         msgString = CMsg( MSG_FORMAT_PRE_READING, MSG_FORMAT_PRE_READING_STR );
         break;
      
      case MSG_USAGE1_MAIN:
         msgString = CMsg( MSG_M_USAGE1, MSG_M_USAGE1_STR );
	 break;

      case MSG_USAGE2_MAIN:
         msgString = CMsg( MSG_M_USAGE2, MSG_M_USAGE2_STR );
	 break;
	 
      case MSG_USAGE3_MAIN:
         msgString = CMsg( MSG_M_USAGE3, MSG_M_USAGE3_STR );
	 break;

      case MSG_USAGE4_MAIN:
         msgString = CMsg( MSG_M_USAGE4, MSG_M_USAGE4_STR );
	 break;

      case MSG_USAGE5_MAIN:
         msgString = CMsg( MSG_M_USAGE5, MSG_M_USAGE5_STR );
	 break;
	 
      case MSG_USAGE6_MAIN:
         msgString = CMsg( MSG_M_USAGE6, MSG_M_USAGE6_STR );
	 break;
	 
      case MSG_USAGE7_MAIN:
         msgString = CMsg( MSG_M_USAGE7, MSG_M_USAGE7_STR );
	 break;
	 
      case MSG_USAGE8_MAIN:
         msgString = CMsg( MSG_M_USAGE8, MSG_M_USAGE8_STR );
	 break;
	 
      case MSG_USAGE9_MAIN:
         msgString = CMsg( MSG_M_USAGE9, MSG_M_USAGE9_STR );
	 break;
	 
      case MSG_USAGE10_MAIN:
         msgString = CMsg( MSG_M_USAGE10, MSG_M_USAGE10_STR );
	 break;
	 
      case MSG_USAGE11_MAIN:
         msgString = CMsg( MSG_M_USAGE11, MSG_M_USAGE11_STR );
	 break;
	 
      case MSG_USAGE12_MAIN:
         msgString = CMsg( MSG_M_USAGE12, MSG_M_USAGE12_STR );
         break;
	 
      case MSG_USAGE13_MAIN:
         msgString = CMsg( MSG_M_USAGE13, MSG_M_USAGE13_STR );
	 break;

      case MSG_SYSDIRECTIVES_MAIN:
         msgString = CMsg( MSG_M_SYSDIRECTIVES, MSG_M_SYSDIRECTIVES_STR );
         break;

      case MSG_SYS_SUMMARY_MAIN:
         msgString = CMsg( MSG_M_SYS_SUMMARY, MSG_M_SYS_SUMMARY_STR );
	 break;

      case MSG_OPTION_LOADLIB_MAIN:
         msgString = CMsg( MSG_M_OPTION_LOADLIB, MSG_M_OPTION_LOADLIB_STR );
         break;
      
      case MSG_OPTION_LOADCMD_MAIN:
         msgString = CMsg( MSG_M_OPTION_LOADCMD, MSG_M_OPTION_LOADCMD_STR );
	 break; 
   
      case MSG_OPTION_CLASSES_MAIN:
         msgString = CMsg( MSG_M_OPTION_CLASSES, MSG_M_OPTION_CLASSES_STR );
	 break; 

      case MSG_RDA_TEMPLATE_MAIN:
         msgString = CMsg( MSG_RDA_TEMPLATE, MSG_RDA_TEMPLATE_STR );
	 break;

      case MSG_PROCARGS_FUNC_MAIN:
         msgString = CMsg( MSG_M_PROCARGS_FUNC, MSG_M_PROCARGS_FUNC_STR );
	 break;

      case MSG_OPTION_NOSTD_MAIN:
         msgString = CMsg( MSG_M_OPTION_NOSTD, MSG_M_OPTION_NOSTD_STR );
	 break;

      case MSG_OPTION_LEXDBG_MAIN:
         msgString = CMsg( MSG_M_OPTION_LEXDBG, MSG_M_OPTION_LEXDBG_STR );
         break;

      case MSG_AM_LEXPRT_MENU_MAIN:
         msgString = CMsg( MSG_AM_LEXPRT_MENU, MSG_AM_LEXPRT_MENU_STR );
	 break;

      case MSG_OPTION_HELP_MAIN:
         msgString = CMsg( MSG_M_OPTION_HELP, MSG_M_OPTION_HELP_STR );
	 break;
      
      case MSG_OPTION_LOGO_MAIN:
         msgString = CMsg( MSG_M_OPTION_LOGO, MSG_M_OPTION_LOGO_STR );
	 break;

      case MSG_OPTION_SUMMARY_MAIN:
         msgString = CMsg( MSG_M_OPTION_SUMMARY, MSG_M_OPTION_SUMMARY_STR );
	 break;

      case MSG_AM_PRALLOC_MENU_MAIN:
         msgString = CMsg( MSG_AM_PRALLOC_MENU, MSG_AM_PRALLOC_MENU_STR );
	 break;

      case MSG_OPTION_DBGLVL_MAIN:
         msgString = CMsg( MSG_M_OPTION_DBGLVL, MSG_M_OPTION_DBGLVL_STR );
	 break;
	 
      case MSG_AM_DEBUG_MENU_MAIN:
         msgString = CMsg( MSG_AM_DEBUG_MENU, MSG_AM_DEBUG_MENU_STR );
	 break;

      case MSG_OPTION_PRTCMD_MAIN:
         msgString = CMsg( MSG_M_OPTION_PRTCMD, MSG_M_OPTION_PRTCMD_STR );
	 break;

      case MSG_AM_REPORT0_MENU_MAIN:
         msgString = CMsg( MSG_AM_REPORT0_MENU, MSG_AM_REPORT0_MENU_STR );
	 break;

      case MSG_AM_REPORT1_MENU_MAIN:
         msgString = CMsg( MSG_AM_REPORT1_MENU, MSG_AM_REPORT1_MENU_STR );
	 break;

      case MSG_AM_REPORT2_MENU_MAIN:
         msgString = CMsg( MSG_AM_REPORT2_MENU, MSG_AM_REPORT2_MENU_STR );
	 break;

      case MSG_OPTION_NOSUMM_MAIN:
         msgString = CMsg( MSG_M_OPTION_NOSUMM, MSG_M_OPTION_NOSUMM_STR );
	 break;

      case MSG_AM_SILENCE_MENU_MAIN:
         msgString = CMsg( MSG_AM_SILENCE_MENU, MSG_AM_SILENCE_MENU_STR );
	 break;

      case MSG_OPTION_NOSTAT_MAIN:
         msgString = CMsg( MSG_M_OPTION_NOSTAT, MSG_M_OPTION_NOSTAT_STR );
	 break;
      
      case MSG_AM_ENBSTAT_MENU_MAIN:
         msgString = CMsg( MSG_AM_ENBSTAT_MENU, MSG_AM_ENBSTAT_MENU_STR );
	 break;

      case MSG_FMT_ADRS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_ADRS_ALLC, MSG_FORMAT_ADRS_ALLC_STR );
	 break; 

      case MSG_FMT_INTS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_INTS_ALLC, MSG_FORMAT_INTS_ALLC_STR );
         break;

      case MSG_FMT_FLTS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_FLTS_ALLC, MSG_FORMAT_FLTS_ALLC_STR );
         break;

      case MSG_FMT_BLKS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_BLKS_ALLC, MSG_FORMAT_BLKS_ALLC_STR );
         break;

      case MSG_FMT_BARY_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_BARY_ALLC, MSG_FORMAT_BARY_ALLC_STR );
         break;

      case MSG_FMT_STRS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_STRS_ALLC, MSG_FORMAT_STRS_ALLC_STR );
         break;

      case MSG_FMT_INTR_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_INTR_ALLC, MSG_FORMAT_INTR_ALLC_STR );
         break;

      case MSG_FMT_CLSS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_CLSS_ALLC, MSG_FORMAT_CLSS_ALLC_STR );
         break;

      case MSG_FMT_SYMS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_SYMS_ALLC, MSG_FORMAT_SYMS_ALLC_STR );
         break;

      case MSG_FMT_ENTR_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_ENTR_ALLC, MSG_FORMAT_ENTR_ALLC_STR );
         break;

      case MSG_FMT_WALLOCS_MAIN:
         msgString = CMsg( MSG_FORMAT_WALLOCS, MSG_FORMAT_WALLOCS_STR );
         break;

      case MSG_FMT_WALLSZ_MAIN:
         msgString = CMsg( MSG_FORMAT_WALLSZ, MSG_FORMAT_WALLSZ_STR );
         break;

      case MSG_FMT_SYMSPC_MAIN:
         msgString = CMsg( MSG_FORMAT_SYMSPC, MSG_FORMAT_SYMSPC_STR );
         break;

      case MSG_FMT_OBJS_ALLC_MAIN:
         msgString = CMsg( MSG_FORMAT_OBJS_ALLC, MSG_FORMAT_OBJS_ALLC_STR );
         break;

      case MSG_CLEAN_MAIN:
         msgString = CMsg( MSG_CLEAN, MSG_CLEAN_STR );
	 break;

      case MSG_FMT_PROBLEM_W_MAIN:
         msgString = CMsg( MSG_FORMAT_PROBLEM_W, MSG_FORMAT_PROBLEM_W_STR );
	 break;

      case MSG_CLEANUP_MAIN:
         msgString = CMsg( MSG_M_CLEANUP, MSG_M_CLEANUP_STR );
	 break;

      case MSG_FMT_VERSION_MAIN:
         msgString = CMsg( MSG_FORMAT_M_VERSION, MSG_FORMAT_M_VERSION_STR );
	 break;

      case MSG_FMT_INITING_MAIN:
         msgString = CMsg( MSG_FORMAT_M_INITING, MSG_FORMAT_M_INITING_STR );
	 break;

      case MSG_INITCLASSES_MAIN:
         msgString = CMsg( MSG_M_INITCLASSES, MSG_M_INITCLASSES_STR );
	 break;

      case MSG_FMT_WELCOME_MAIN:
         msgString = CMsg( MSG_FORMAT_M_WELCOME, MSG_FORMAT_M_WELCOME_STR );
	 break;

      case MSG_NOT_REOPEN_STAT_MAIN:
         msgString = CMsg( MSG_NOT_REOPEN_STAT, MSG_NOT_REOPEN_STAT_STR );
	 break;

      case MSG_UPDATE_BRWSR_MAIN:
         msgString = CMsg( MSG_M_UPDATE_BRWSR, MSG_M_UPDATE_BRWSR_STR );
	 break;

      case MSG_WRITE_NEWSYMS_MAIN:
         msgString = CMsg( MSG_M_WRITE_NEWSYMS, MSG_M_WRITE_NEWSYMS_STR );
	 break;

      case MSG_FMT_SYMERR_MAIN:
         msgString = CMsg( MSG_FORMAT_M_SYMERR, MSG_FORMAT_M_SYMERR_STR );
	 break;

      case MSG_INVALID_SCRMODE_MAIN:
         msgString = CMsg( MSG_M_INVALID_SCRMODE, MSG_M_INVALID_SCRMODE_STR );
	 break;

      case MSG_NO_ICONLIB_MAIN:
         msgString = CMsg( MSG_M_NO_ICONLIB, MSG_M_NO_ICONLIB_STR );
	 break;
      
      case MSG_FMT_STARTUPMSG_MAIN:
         msgString = CMsg( MSG_FORMAT_STARTUPMSG, MSG_FORMAT_STARTUPMSG_STR );
	 break;

      case MSG_CHECKSYSTEM_MAIN:
         msgString = CMsg( MSG_M_CHECKSYSTEM, MSG_M_CHECKSYSTEM_STR );
	 break;

      case MSG_LASTMESSAGE1_MAIN:
         msgString = CMsg( MSG_M_LASTMESSAGE1, MSG_M_LASTMESSAGE1_STR );
	 break;
	 
      case MSG_LASTMESSAGE2_MAIN:
         msgString = CMsg( MSG_M_LASTMESSAGE2, MSG_M_LASTMESSAGE2_STR );
	 break;

      case MSG_DEFAULT_BUTTONS:
         msgString = CMsg( MSG_DEFAULT_BUTTONS_STR, MSG_DEFAULT_BUTTONS_STR_STR );
	 break;

      case MSG_FMT_MEM_CHECK_MAIN:
         msgString = CMsg( MSG_MM_FMT_MEM_CHECK, MSG_MM_FMT_MEM_CHECK_STR );
	 break;

      case MSG_RQTITLE_ATALK_PROBLEM_MAIN:
         msgString = CMsg( MSG_RQTITLE_ATALK_PROBLEM, MSG_RQTITLE_ATALK_PROBLEM_STR );
	 break;
      }

   return( msgString );
}

PUBLIC STRPTR EnvCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ATI_WTITLE_ENV:
         msgString = ATECMsg( MSG_ATI_WTITLE, MSG_ATI_WTITLE_STR );
	 break;
	 
      case MSG_ATI_STITLE_ENV:
         msgString = ATECMsg( MSG_ATI_STITLE, MSG_ATI_STITLE_STR );
	 break;
	 
      case MSG_ATEGRP_MEMORY_ENV:
         msgString = ATECMsg( MSG_ATEGRP_MEMORY, MSG_ATEGRP_MEMORY_STR );
	 break;

      case MSG_ATEGRP_PATHS_ENV:
         msgString = ATECMsg( MSG_ATEGRP_PATHS, MSG_ATEGRP_PATHS_STR );
         break;

      case MSG_ATEGRP_SUPPORT_ENV:
         msgString = ATECMsg( MSG_ATEGRP_SUPPORT, MSG_ATEGRP_SUPPORT_STR );
         break;

      case MSG_ATEGRP_MISC_ENV:
         msgString = ATECMsg( MSG_ATEGRP_MISC, MSG_ATEGRP_MISC_STR );
         break;

      case MSG_ATEGRP_GUI_ENV:
         msgString = ATECMsg( MSG_ATEGRP_GUI, MSG_ATEGRP_GUI_STR );
         break;

      case MSG_ATEGRP_PALETTE_ENV:
         msgString = ATECMsg( MSG_ATEGRP_PALETTE, MSG_ATEGRP_PALETTE_STR );
         break;

      case MSG_GAD_ItemsLV_ENV:
         msgString = ATECMsg( MSG_GAD_ItemsLV, MSG_GAD_ItemsLV_STR );
         break;

      case MSG_GAD_ItemTxt_ENV:
         msgString = ATECMsg( MSG_GAD_ItemTxt, MSG_GAD_ItemTxt_STR );
         break;

      case MSG_GAD_ValueStr_ENV:
         msgString = ATECMsg( MSG_GAD_ValueStr, MSG_GAD_ValueStr_STR );
         break;

      case MSG_GAD_SelectBt_ENV:
         msgString = ATECMsg( MSG_GAD_SelectBt, MSG_GAD_SelectBt_STR );
         break;

      case MSG_GAD_FormatTxt_ENV:
         msgString = ATECMsg( MSG_GAD_FormatTxt, MSG_GAD_FormatTxt_STR );
         break;

      case MSG_GAD_DoneBt_ENV:
         msgString = ATECMsg( MSG_GAD_DoneBt, MSG_GAD_DoneBt_STR );
         break;

      case MSG_GAD_RestoreBt_ENV:
         msgString = ATECMsg( MSG_GAD_RestoreBt, MSG_GAD_RestoreBt_STR );
         break;

      case MSG_GAD_AbortBt_ENV:
         msgString = ATECMsg( MSG_GAD_AbortBt, MSG_GAD_AbortBt_STR );
         break;

      case MSG_GAD_HelpBt_ENV:
         msgString = ATECMsg( MSG_GAD_HelpBt, MSG_GAD_HelpBt_STR );
         break;

      case MSG_SELECT_PATH_NAME_ENV:
         msgString = ATECMsg( MSG_SELECT_PATH_NAME, MSG_SELECT_PATH_NAME_STR );
         break;

      case MSG_SELECT_CMD_NAME_ENV:
         msgString = ATECMsg( MSG_SELECT_CMD_NAME, MSG_SELECT_CMD_NAME_STR );
         break;

      case MSG_SELECT_SCR_MODE_ENV:
         msgString = ATECMsg( MSG_SELECT_SCR_MODE, MSG_SELECT_SCR_MODE_STR );
         break;

      case MSG_SELECT_FONT_NAME_ENV:
         msgString = ATECMsg( MSG_SELECT_FONT_NAME, MSG_SELECT_FONT_NAME_STR );
         break;

      case MSG_ATEGRP_ITEM_SCREENMODEID_ENV:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_SCREENMODEID, MSG_ATEGRP_ITEM_SCREENMODEID_STR );
         break;

      case MSG_ATEGRP_ITEM_FONT_NAME_ENV:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_FONT_NAME, MSG_ATEGRP_ITEM_FONT_NAME_STR );
         break;

      case MSG_NO_SELECTION_ENV:
         msgString = ATECMsg( MSG_NO_SELECTION, MSG_NO_SELECTION_STR ); 
         break;

      case MSG_USER_INFO_RQTITLE_ENV:
         msgString = ATECMsg( MSG_USER_INFO_RQTITLE, MSG_USER_INFO_RQTITLE_STR );
         break;

      case MSG_HELP_VIEWER_CMD_ENV:
         msgString = ATECMsg( MSG_HELP_VIEWER_CMD, MSG_HELP_VIEWER_CMD_STR );
         break;

      case MSG_HELP_FILE_ENV:
         msgString = ATECMsg( MSG_HELP_FILE, MSG_HELP_FILE_STR );
         break;

      case MSG_BAD_COMMAND_RQTITLE_ENV:
         msgString = ATECMsg( MSG_BAD_COMMAND_RQTITLE, MSG_BAD_COMMAND_RQTITLE_STR );
         break;
      }

   return( msgString );
}

PUBLIC STRPTR SetupCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ATEGRP_ITEM_PEN00_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN00, MSG_ATEGRP_ITEM_PEN00_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN01_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN01, MSG_ATEGRP_ITEM_PEN01_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN02_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN02, MSG_ATEGRP_ITEM_PEN02_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN03_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN03, MSG_ATEGRP_ITEM_PEN03_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN04_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN04, MSG_ATEGRP_ITEM_PEN04_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN05_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN05, MSG_ATEGRP_ITEM_PEN05_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN06_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN06, MSG_ATEGRP_ITEM_PEN06_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN07_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN07, MSG_ATEGRP_ITEM_PEN07_STR );
         break;
	 
      case MSG_ATEGRP_ITEM_PEN08_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN08, MSG_ATEGRP_ITEM_PEN08_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN09_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN09, MSG_ATEGRP_ITEM_PEN09_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0A_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0A, MSG_ATEGRP_ITEM_PEN0A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0B_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0B, MSG_ATEGRP_ITEM_PEN0B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0C_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0C, MSG_ATEGRP_ITEM_PEN0C_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0D_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0D, MSG_ATEGRP_ITEM_PEN0D_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0E_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0E, MSG_ATEGRP_ITEM_PEN0E_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN0F_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN0F, MSG_ATEGRP_ITEM_PEN0F_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN10_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN10, MSG_ATEGRP_ITEM_PEN10_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN11_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN11, MSG_ATEGRP_ITEM_PEN11_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN12_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN12, MSG_ATEGRP_ITEM_PEN12_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN13_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN13, MSG_ATEGRP_ITEM_PEN13_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN14_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN14, MSG_ATEGRP_ITEM_PEN14_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN15_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN15, MSG_ATEGRP_ITEM_PEN15_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN16_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN16, MSG_ATEGRP_ITEM_PEN16_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN17_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN17, MSG_ATEGRP_ITEM_PEN17_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN18_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN18, MSG_ATEGRP_ITEM_PEN18_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN19_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN19, MSG_ATEGRP_ITEM_PEN19_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1A_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1A, MSG_ATEGRP_ITEM_PEN1A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1B_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1B, MSG_ATEGRP_ITEM_PEN1B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1C_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1C, MSG_ATEGRP_ITEM_PEN1C_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1D_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1D, MSG_ATEGRP_ITEM_PEN1D_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1E_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1E, MSG_ATEGRP_ITEM_PEN1E_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN1F_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN1F, MSG_ATEGRP_ITEM_PEN1F_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN20_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN20, MSG_ATEGRP_ITEM_PEN20_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN21_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN21, MSG_ATEGRP_ITEM_PEN21_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN22_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN22, MSG_ATEGRP_ITEM_PEN22_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN23_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN23, MSG_ATEGRP_ITEM_PEN23_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN24_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN24, MSG_ATEGRP_ITEM_PEN24_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN25_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN25, MSG_ATEGRP_ITEM_PEN25_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN26_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN26, MSG_ATEGRP_ITEM_PEN26_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN27_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN27, MSG_ATEGRP_ITEM_PEN27_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN28_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN28, MSG_ATEGRP_ITEM_PEN28_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN29_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN29, MSG_ATEGRP_ITEM_PEN29_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2A_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN2A, MSG_ATEGRP_ITEM_PEN2A_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2B_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN2B, MSG_ATEGRP_ITEM_PEN2B_STR ); 
         break;
	 
      case MSG_ATEGRP_ITEM_PEN2C_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PEN2C, MSG_ATEGRP_ITEM_PEN2C_STR ); 
         break;

      case MSG_ATEGRP_MEMORY_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_MEMORY, MSG_ATEGRP_MEMORY_STR );
         break;

      case MSG_ATEGRP_ITEM_OBJECT_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_OBJECT_SIZE, MSG_ATEGRP_ITEM_OBJECT_SIZE_STR ); 
         break;

      case MSG_ATEGRP_ITEM_BYTEARRAY_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_BYTEARRAY_SIZE, MSG_ATEGRP_ITEM_BYTEARRAY_SIZE_STR );
         break;

      case MSG_ATEGRP_ITEM_INTEGER_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_INTEGER_SIZE, MSG_ATEGRP_ITEM_INTEGER_SIZE_STR ); 
         break;

      case MSG_ATEGRP_ITEM_INTERP_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_INTERP_SIZE, MSG_ATEGRP_ITEM_INTERP_SIZE_STR ); 
         break;

      case MSG_ATEGRP_ITEM_SYMBOL_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_SYMBOL_SIZE, MSG_ATEGRP_ITEM_SYMBOL_SIZE_STR ); 
         break;

      case MSG_ATEGRP_PATHS_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_PATHS, MSG_ATEGRP_PATHS_STR );
         break;

      case MSG_ATEGRP_ITEM_LIBRARY_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_LIBRARY_PATH, MSG_ATEGRP_ITEM_LIBRARY_PATH_STR ); 
         break;

      case MSG_ATEGRP_ITEM_COMMAND_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_COMMAND_PATH, MSG_ATEGRP_ITEM_COMMAND_PATH_STR );
         break;

      case MSG_ATEGRP_ITEM_HELP_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_HELP_PATH, MSG_ATEGRP_ITEM_HELP_PATH_STR );
         break;

      case MSG_ATEGRP_ITEM_GENERAL_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_GENERAL_PATH, MSG_ATEGRP_ITEM_GENERAL_PATH_STR );
         break;

      case MSG_ATEGRP_ITEM_INTUITION_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_INTUITION_PATH, MSG_ATEGRP_ITEM_INTUITION_PATH_STR );
         break;

      case MSG_ATEGRP_ITEM_SYSTEM_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_SYSTEM_PATH, MSG_ATEGRP_ITEM_SYSTEM_PATH_STR );
         break;

      case MSG_ATEGRP_ITEM_USER_PATH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_USER_PATH, MSG_ATEGRP_ITEM_USER_PATH_STR );
         break;

      case MSG_ATEGRP_SUPPORT_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_SUPPORT, MSG_ATEGRP_SUPPORT_STR );
         break;

      case MSG_ATEGRP_ITEM_FILE_DISPLAYER_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_FILE_DISPLAYER, MSG_ATEGRP_ITEM_FILE_DISPLAYER_STR );
         break;

      case MSG_ATEGRP_ITEM_HELP_PROGRAM_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_HELP_PROGRAM, MSG_ATEGRP_ITEM_HELP_PROGRAM_STR );
         break;

      case MSG_ATEGRP_ITEM_EDITOR_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_EDITOR, MSG_ATEGRP_ITEM_EDITOR_STR );
         break;

      case MSG_ATEGRP_ITEM_PARSER_NAME_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_PARSER_NAME, MSG_ATEGRP_ITEM_PARSER_NAME_STR );
         break;

      case MSG_ATEGRP_ITEM_LOGO_COMMAND_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_LOGO_COMMAND, MSG_ATEGRP_ITEM_LOGO_COMMAND_STR );
         break;

      case MSG_ATEGRP_MISC_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_MISC, MSG_ATEGRP_MISC_STR );
         break;

      case MSG_ATEGRP_ITEM_INIT_SCRIPT_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_INIT_SCRIPT, MSG_ATEGRP_ITEM_INIT_SCRIPT_STR );
         break;

      case MSG_ATEGRP_ITEM_UPDATE_SCRIPT_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_UPDATE_SCRIPT, MSG_ATEGRP_ITEM_UPDATE_SCRIPT_STR );
         break;

      case MSG_ATEGRP_ITEM_AREXX_PORTNAME_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_AREXX_PORTNAME, MSG_ATEGRP_ITEM_AREXX_PORTNAME_STR );
         break;

      case MSG_ATEGRP_ITEM_TAB_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_TAB_SIZE, MSG_ATEGRP_ITEM_TAB_SIZE_STR );
         break;

      case MSG_ATEGRP_ITEM_STATUS_HLENGTH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_STATUS_HLENGTH, MSG_ATEGRP_ITEM_STATUS_HLENGTH_STR );
         break;

      case MSG_ATEGRP_ITEM_LOGO_NAME_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_LOGO_NAME, MSG_ATEGRP_ITEM_LOGO_NAME_STR );
         break;

      case MSG_ATEGRP_ITEM_IMAGE_FILE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_IMAGE_FILE, MSG_ATEGRP_ITEM_IMAGE_FILE_STR );
         break;

      case MSG_ATEGRP_ITEM_SYMBOL_FILE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_SYMBOL_FILE, MSG_ATEGRP_ITEM_SYMBOL_FILE_STR );
         break;

      case MSG_ATEGRP_GUI_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_GUI, MSG_ATEGRP_GUI_STR );
         break;

      case MSG_ATEGRP_ITEM_SCREENMODEID_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_SCREENMODEID, MSG_ATEGRP_ITEM_SCREENMODEID_STR );
         break;

      case MSG_ATEGRP_ITEM_FONT_NAME_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_FONT_NAME, MSG_ATEGRP_ITEM_FONT_NAME_STR ); 
         break;

      case MSG_ATEGRP_ITEM_FONT_SIZE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_FONT_SIZE, MSG_ATEGRP_ITEM_FONT_SIZE_STR ); 
         break;

      case MSG_ATEGRP_ITEM_GUI_WIDTH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_GUI_WIDTH, MSG_ATEGRP_ITEM_GUI_WIDTH_STR ); 
         break;

      case MSG_ATEGRP_ITEM_GUI_HEIGHT_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_GUI_HEIGHT, MSG_ATEGRP_ITEM_GUI_HEIGHT_STR ); 
         break;

      case MSG_ATEGRP_ITEM_STATUS_WIDTH_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_STATUS_WIDTH, MSG_ATEGRP_ITEM_STATUS_WIDTH_STR ); 
         break;

      case MSG_ATEGRP_ITEM_STATUS_HEIGHT_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_STATUS_HEIGHT, MSG_ATEGRP_ITEM_STATUS_HEIGHT_STR ); 
         break;

      case MSG_ATEGRP_PALETTE_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_PALETTE, MSG_ATEGRP_PALETTE_STR );
         break;

      case MSG_ATEGRP_ITEM_NUM_PENS_SETUP:
         msgString = ATECMsg( MSG_ATEGRP_ITEM_NUM_PENS, MSG_ATEGRP_ITEM_NUM_PENS_STR ); 
         break;

      case MSG_FMT_INCS_DECS_SETUP:
         msgString = CMsg( MSG_FORMAT_INCS_DECS, MSG_FORMAT_INCS_DECS_STR ); 
         break;

      case MSG_GL_SELECT_FONT_SETUP:
         msgString = CMsg( MSG_GL_SELECT_FONT, MSG_GL_SELECT_FONT_STR ); 
         break;

      case MSG_FMT_ATGADGETS_SETUP:
         msgString = CMsg( MSG_FORMAT_ATGADGETS, MSG_FORMAT_ATGADGETS_STR );
         break;

      case MSG_CMDLINE_GADGET_STR_SETUP:
         msgString = CMsg( MSG_CMDLINE_GADGET_STR, MSG_CMDLINE_GADGET_STR_STR );
         break;

      case MSG_SINGLE_GADGET_STR_SETUP:
         msgString = CMsg( MSG_SINGLE_GADGET_STR, MSG_SINGLE_GADGET_STR_STR );
         break;

      case MSG_PARSEBT_GADGET_STR_SETUP:
         msgString = CMsg( MSG_PARSEBT_GADGET_STR, MSG_PARSEBT_GADGET_STR_STR );
         break;

      case MSG_CANT_NO_ERROR_SETUP:
         msgString = CMsg( MSG_CANT_NO_ERROR, MSG_CANT_NO_ERROR_STR );
         break;

      case MSG_CANT_NO_MEM_SETUP:
         msgString = CMsg( MSG_CANT_NO_MEM, MSG_CANT_NO_MEM_STR );
         break;

      case MSG_CANT_ARRAY_SIZE_SETUP:
         msgString = CMsg( MSG_CANT_ARRAY_SIZE, MSG_CANT_ARRAY_SIZE_STR );
         break;

      case MSG_CANT_NO_BLK_RET_SETUP:
         msgString = CMsg( MSG_CANT_NO_BLK_RET, MSG_CANT_NO_BLK_RET_STR );
         break;

      case MSG_CANT_NON_CLASS_SETUP:
         msgString = CMsg( MSG_CANT_NON_CLASS, MSG_CANT_NON_CLASS_STR );
         break;

      case MSG_CANT_CASE_ERR_SETUP:
         msgString = CMsg( MSG_CANT_CASE_ERR, MSG_CANT_CASE_ERR_STR );
         break;

      case MSG_CANT_DECR_UNK_SETUP:
         msgString = CMsg( MSG_CANT_DECR_UNK, MSG_CANT_DECR_UNK_STR );
         break;

      case MSG_CANT_NO_CLASS_SETUP:
         msgString = CMsg( MSG_CANT_NO_CLASS, MSG_CANT_NO_CLASS_STR );
         break;

      case MSG_CANT_PRIM_FREE_SETUP:
         msgString = CMsg( MSG_CANT_PRIM_FREE, MSG_CANT_PRIM_FREE_STR );
         break;

      case MSG_CANT_INTERP_ERR_SETUP:
         msgString = CMsg( MSG_CANT_INTERP_ERR, MSG_CANT_INTERP_ERR_STR );
         break;

      case MSG_CANT_NON_BLOCK_SETUP:
         msgString = CMsg( MSG_CANT_NON_BLOCK, MSG_CANT_NON_BLOCK_STR );
         break;

      case MSG_CANT_NO_SYMSPC_SETUP:
         msgString = CMsg( MSG_CANT_NO_SYMSPC, MSG_CANT_NO_SYMSPC_STR );
         break;

      case MSG_CANT_NO_BCSPC_SETUP:
         msgString = CMsg( MSG_CANT_NO_BCSPC, MSG_CANT_NO_BCSPC_STR );
         break;

      case MSG_CANT_DEADLOCK_SETUP:
         msgString = CMsg( MSG_CANT_DEADLOCK, MSG_CANT_DEADLOCK_STR );
         break;

      case MSG_CANT_FREE_SYM_SETUP:
         msgString = CMsg( MSG_CANT_FREE_SYM, MSG_CANT_FREE_SYM_STR );
         break;

      case MSG_CANT_INV_PSTATE_SETUP:
         msgString = CMsg( MSG_CANT_INV_PSTATE, MSG_CANT_INV_PSTATE_STR );
         break;

      case MSG_CANT_BUFF_OVFLW_SETUP:
         msgString = CMsg( MSG_CANT_BUFF_OVFLW, MSG_CANT_BUFF_OVFLW_STR );
         break;

      case MSG_CANT_NO_PRELUDE_SETUP:
         msgString = CMsg( MSG_CANT_NO_PRELUDE, MSG_CANT_NO_PRELUDE_STR );
         break;

      case MSG_CANT_SYS_FILE_SETUP:
         msgString = CMsg( MSG_CANT_SYS_FILE, MSG_CANT_SYS_FILE_STR );
         break;

      case MSG_CANT_FASTSAVE_SETUP:
         msgString = CMsg( MSG_CANT_FASTSAVE, MSG_CANT_FASTSAVE_STR );
         break;

      case MSG_CANT_BACKTRACE_SETUP:
         msgString = CMsg( MSG_CANT_BACKTRACE, MSG_CANT_BACKTRACE_STR );
         break;

      case MSG_CANT_HI_BITS_SETUP:
         msgString = CMsg( MSG_CANT_HI_BITS, MSG_CANT_HI_BITS_STR );
         break;

      case MSG_CANT_NON_SYMBOL40_SETUP:
         msgString = CMsg( MSG_CANT_NON_SYMBOL40, MSG_CANT_NON_SYMBOL40_STR );
         break;

      case MSG_CANT_NON_SYMBOL80_SETUP:
         msgString = CMsg( MSG_CANT_NON_SYMBOL80, MSG_CANT_NON_SYMBOL80_STR );
         break;

      case MSG_CANT_NON_SYMBOL90_SETUP:
         msgString = CMsg( MSG_CANT_NON_SYMBOL90, MSG_CANT_NON_SYMBOL90_STR );
         break;

      case MSG_CANT_LO_BITSC0_SETUP:
         msgString = CMsg( MSG_CANT_LO_BITSC0, MSG_CANT_LO_BITSC0_STR );
         break;

      case MSG_CANT_LO_BITSF0_SETUP:
         msgString = CMsg( MSG_CANT_LO_BITSF0, MSG_CANT_LO_BITSF0_STR );
         break;

      case MSG_CANT_BLK_COUNT_SETUP:
         msgString = CMsg( MSG_CANT_BLK_COUNT, MSG_CANT_BLK_COUNT_STR );
         break;

      case MSG_CANT_NULL_OBJ_SETUP:
         msgString = CMsg( MSG_CANT_NULL_OBJ, MSG_CANT_NULL_OBJ_STR );
         break;

      case MSG_CANT_NO_SPECIAL_SETUP:
         msgString = CMsg( MSG_CANT_NO_SPECIAL, MSG_CANT_NO_SPECIAL_STR ); // SPECIAL_NOT_SYMBOL
         break;

      case MSG_CANT_NO_LIBRARY_SETUP:
         msgString = CMsg( MSG_CANT_NO_LIBRARY, MSG_CANT_NO_LIBRARY_STR );
         break;

      case MSG_CANT_NO_INTSPC_SETUP:
         msgString = CMsg( MSG_CANT_NO_INTSPC,  MSG_CANT_NO_INTSPC_STR  );
         break;

      case MSG_CANT_IMPOSSIBLE_SETUP:
         msgString = CMsg( MSG_CANT_IMPOSSIBLE, MSG_CANT_IMPOSSIBLE_STR );
         break;

      case MSG_W_PROGRAM_TITLE_SETUP:
         msgString = CMsg( MSG_W_PROGRAM_TITLE, MSG_W_PROGRAM_TITLE_STR );
         break;

      case MSG_INIFILE_ERROR_SETUP:
         msgString = CMsg( MSG_INIFILE_ERROR, MSG_INIFILE_ERROR_STR );
         break;

      case MSG_RQTITLE_FATAL_ERROR_SETUP:
         msgString = CMsg( MSG_RQTITLE_FATAL_ERROR, MSG_RQTITLE_FATAL_ERROR_STR );
         break;

      case MSG_PGM_LV_GADGET_STR_SETUP:
         msgString = CMsg( MSG_PGM_LV_GADGET_STR, MSG_PGM_LV_GADGET_STR_STR ); 
         break;
      }

   return( msgString );
}

/****i* CatalogADOS1() [3.0] ***************************************
*
* NAME
*    CatalogADOS1()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs() 
*    in Setup.c only.
********************************************************************
*
*/

PUBLIC int CatalogADOS1( void )
{
   IMPORT char *ioErrStrs[ 67 ];
   
   ioErrStrs[0]  = CMsg( MSG_AD1_ERR_NONE,       MSG_AD1_ERR_NONE_STR );       // 0
   ioErrStrs[1]  = CMsg( MSG_AD1_ERR_WARN,       MSG_AD1_ERR_WARN_STR );
   ioErrStrs[2]  = CMsg( MSG_AD1_ERR_ERROR,      MSG_AD1_ERR_ERROR_STR );
   ioErrStrs[3]  = CMsg( MSG_AD1_ERR_FAIL,       MSG_AD1_ERR_FAIL_STR );
   ioErrStrs[4]  = CMsg( MSG_AD1_ERR_NO_MEM,     MSG_AD1_ERR_NO_MEM_STR );
   ioErrStrs[5]  = CMsg( MSG_AD1_ERR_TABLEFULL,  MSG_AD1_ERR_TABLEFULL_STR );  // 5
   ioErrStrs[6]  = CMsg( MSG_AD1_ERR_BADTEMPL,   MSG_AD1_ERR_BADTEMPL_STR );
   ioErrStrs[7]  = CMsg( MSG_AD1_ERR_BADNUM,     MSG_AD1_ERR_BADNUM_STR );
   ioErrStrs[8]  = CMsg( MSG_AD1_ERR_MISSARG,    MSG_AD1_ERR_MISSARG_STR );
   ioErrStrs[9]  = CMsg( MSG_AD1_ERR_NO_ARG,     MSG_AD1_ERR_NO_ARG_STR );
   ioErrStrs[10] = CMsg( MSG_AD1_ERR_WRGARGS,    MSG_AD1_ERR_WRGARGS_STR );    // 10
   ioErrStrs[11] = CMsg( MSG_AD1_ERR_NOQUOTE,    MSG_AD1_ERR_NOQUOTE_STR );
   ioErrStrs[12] = CMsg( MSG_AD1_ERR_TOOLONG,    MSG_AD1_ERR_TOOLONG_STR );
   ioErrStrs[13] = CMsg( MSG_AD1_ERR_NOT_OBJ,    MSG_AD1_ERR_NOT_OBJ_STR );
   ioErrStrs[14] = CMsg( MSG_AD1_ERR_NO_LIB,     MSG_AD1_ERR_NO_LIB_STR );
   ioErrStrs[15] = CMsg( MSG_AD1_ERR_NO_DDIR,    MSG_AD1_ERR_NO_DDIR_STR );    // 15
   ioErrStrs[16] = CMsg( MSG_AD1_ERR_OBJ_USED,   MSG_AD1_ERR_OBJ_USED_STR );
   ioErrStrs[17] = CMsg( MSG_AD1_ERR_OBJ_EXTS,   MSG_AD1_ERR_OBJ_EXTS_STR );
   ioErrStrs[18] = CMsg( MSG_AD1_ERR_NO_DIR,     MSG_AD1_ERR_NO_DIR_STR );
   ioErrStrs[19] = CMsg( MSG_AD1_ERR_NO_OBJ,     MSG_AD1_ERR_NO_OBJ_STR );
   ioErrStrs[20] = CMsg( MSG_AD1_ERR_BAD_NAME,   MSG_AD1_ERR_BAD_NAME_STR );   // 20
   ioErrStrs[21] = CMsg( MSG_AD1_ERR_LRG_OBJ,    MSG_AD1_ERR_LRG_OBJ_STR );
   ioErrStrs[22] = CMsg( MSG_AD1_ERR_UNK_ACTION, MSG_AD1_ERR_UNK_ACTION_STR );
   ioErrStrs[23] = CMsg( MSG_AD1_ERR_INV_COMP,   MSG_AD1_ERR_INV_COMP_STR );
   ioErrStrs[24] = CMsg( MSG_AD1_ERR_INV_LOCK,   MSG_AD1_ERR_INV_LOCK_STR );
   ioErrStrs[25] = CMsg( MSG_AD1_ERR_WRG_OBJ,    MSG_AD1_ERR_WRG_OBJ_STR );    // 25
   ioErrStrs[26] = CMsg( MSG_AD1_ERR_INV_DISK,   MSG_AD1_ERR_INV_DISK_STR );
   ioErrStrs[27] = CMsg( MSG_AD1_ERR_WRT_PROT,   MSG_AD1_ERR_WRT_PROT_STR );
   ioErrStrs[28] = CMsg( MSG_AD1_ERR_RENAME,     MSG_AD1_ERR_RENAME_STR );
   ioErrStrs[29] = CMsg( MSG_AD1_ERR_FULL_DIR,   MSG_AD1_ERR_FULL_DIR_STR );
   ioErrStrs[30] = CMsg( MSG_AD1_ERR_LEVELS,     MSG_AD1_ERR_LEVELS_STR );     // 30
   ioErrStrs[31] = CMsg( MSG_AD1_ERR_NO_DEV,     MSG_AD1_ERR_NO_DEV_STR );
   ioErrStrs[32] = CMsg( MSG_AD1_ERR_SEEKERR,    MSG_AD1_ERR_SEEKERR_STR );
   ioErrStrs[33] = CMsg( MSG_AD1_ERR_BIG_CMT,    MSG_AD1_ERR_BIG_CMT_STR );
   ioErrStrs[34] = CMsg( MSG_AD1_ERR_FULL_DSK,   MSG_AD1_ERR_FULL_DSK_STR );
   ioErrStrs[35] = CMsg( MSG_AD1_ERR_NO_DEL,     MSG_AD1_ERR_NO_DEL_STR );     // 35
   ioErrStrs[36] = CMsg( MSG_AD1_ERR_NO_WRIT,    MSG_AD1_ERR_NO_WRIT_STR );
   ioErrStrs[37] = CMsg( MSG_AD1_ERR_NO_READ,    MSG_AD1_ERR_NO_READ_STR );
   ioErrStrs[38] = CMsg( MSG_AD1_ERR_NOT_DOS,    MSG_AD1_ERR_NOT_DOS_STR );
   ioErrStrs[39] = CMsg( MSG_AD1_ERR_NO_DISK,    MSG_AD1_ERR_NO_DISK_STR );
   ioErrStrs[40] = CMsg( MSG_AD1_ERR_ENTRIES,    MSG_AD1_ERR_ENTRIES_STR );    // 40
   ioErrStrs[41] = CMsg( MSG_AD1_ERR_SOFT_LNK,   MSG_AD1_ERR_SOFT_LNK_STR );
   ioErrStrs[42] = CMsg( MSG_AD1_ERR_LNK_OBJ,    MSG_AD1_ERR_LNK_OBJ_STR );
   ioErrStrs[43] = CMsg( MSG_AD1_ERR_BAD_HUNK,   MSG_AD1_ERR_BAD_HUNK_STR );
   ioErrStrs[44] = CMsg( MSG_AD1_ERR_NOT_IMPL,   MSG_AD1_ERR_NOT_IMPL_STR );
   ioErrStrs[45] = CMsg( MSG_AD1_ERR_NO_RLOCK,   MSG_AD1_ERR_NO_RLOCK_STR );   // 45
   ioErrStrs[46] = CMsg( MSG_AD1_ERR_LCK_COLL,   MSG_AD1_ERR_LCK_COLL_STR );
   ioErrStrs[47] = CMsg( MSG_AD1_ERR_LCK_TIME,   MSG_AD1_ERR_LCK_TIME_STR );
   ioErrStrs[48] = CMsg( MSG_AD1_ERR_UNLOCK,     MSG_AD1_ERR_UNLOCK_STR );
   ioErrStrs[49] = CMsg( MSG_AD1_ERR_DSK_ABRT,   MSG_AD1_ERR_DSK_ABRT_STR );
   ioErrStrs[50] = CMsg( MSG_AD1_ERR_DSK_BUSY,   MSG_AD1_ERR_DSK_BUSY_STR );   // 50
   ioErrStrs[51] = CMsg( MSG_AD1_ERR_BUF_OVFLW,  MSG_AD1_ERR_BUF_OVFLW_STR );
   ioErrStrs[52] = CMsg( MSG_AD1_ERR_BRK_CHAR,   MSG_AD1_ERR_BRK_CHAR_STR );
   ioErrStrs[53] = CMsg( MSG_AD1_ERR_NO_EXE,     MSG_AD1_ERR_NO_EXE_STR );
   ioErrStrs[54] = CMsg( MSG_AD1_ERR_NO_UPDATE,  MSG_AD1_ERR_NO_UPDATE_STR );  // 54, My Additions:
   ioErrStrs[55] = CMsg( MSG_AD1_ERR_UNF_TAPE,   MSG_AD1_ERR_UNF_TAPE_STR );   // 55
   ioErrStrs[56] = CMsg( MSG_AD1_ERR_TAPE_URDY,  MSG_AD1_ERR_TAPE_URDY_STR );
   ioErrStrs[57] = CMsg( MSG_AD1_ERR_TAPE_PROB,  MSG_AD1_ERR_TAPE_PROB_STR );
   ioErrStrs[58] = CMsg( MSG_AD1_ERR_NO_SCRN,    MSG_AD1_ERR_NO_SCRN_STR );
   ioErrStrs[59] = CMsg( MSG_AD1_ERR_NO_WIND,    MSG_AD1_ERR_NO_WIND_STR );
   ioErrStrs[60] = CMsg( MSG_AD1_ERR_NO_GADT,    MSG_AD1_ERR_NO_GADT_STR );    // 60
   ioErrStrs[61] = CMsg( MSG_AD1_ERR_LIB_CLOSE,  MSG_AD1_ERR_LIB_CLOSE_STR );
   ioErrStrs[62] = CMsg( MSG_AD1_ERR_BAD_MNUM,   MSG_AD1_ERR_BAD_MNUM_STR );
   ioErrStrs[63] = CMsg( MSG_AD1_ERR_BAD_MINUM,  MSG_AD1_ERR_BAD_MINUM_STR );
   ioErrStrs[64] = CMsg( MSG_AD1_ERR_BAD_MSNUM,  MSG_AD1_ERR_BAD_MSNUM_STR );
   ioErrStrs[65] = CMsg( MSG_AD1_ERR_NULL_PTR,   MSG_AD1_ERR_NULL_PTR_STR );   // 65
   
   return( 0 );
}

/****h* TraceCatalog() [2.5] *****************************************
*
* NAME
*    TraceCatalog()
*
* DESCRIPTION
**********************************************************************
*
*/

PUBLIC int TraceCatalog( void )
{
   IMPORT UBYTE           *BTWdt;
   IMPORT struct NewGadget BTNGad[];
   
   BTWdt = CMsg( MSG_BT_WTITLE, MSG_BT_WTITLE_STR ); // WA_Title

   BTNGad[ 0 ].ng_GadgetText = CMsg( MSG_GAD_TraceLV, MSG_GAD_TraceLV_STR );
   BTNGad[ 1 ].ng_GadgetText = CMsg( MSG_GAD_ContBt,  MSG_GAD_ContBt_STR );
   BTNGad[ 2 ].ng_GadgetText = CMsg( MSG_GAD_StopBt,  MSG_GAD_StopBt_STR );
   BTNGad[ 3 ].ng_GadgetText = CMsg( MSG_GAD_ExamBt,  MSG_GAD_ExamBt_STR );
   BTNGad[ 4 ].ng_GadgetText = CMsg( MSG_GAD_ExitBt,  MSG_GAD_ExitBt_STR );

   return( 0 );
}

PUBLIC STRPTR ATTCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_CMD_ERR_TRACE:
         msgString = CMsg( MSG_FORMAT_CMD_ERR, MSG_FORMAT_CMD_ERR_STR );
	 break;

      case MSG_RQTITLE_USER_ERROR_TRACE:
         msgString = CMsg( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR ); 
         break;
      }

   return( msgString );
}

/****h* CatalogATGadgets() [2.3] *******************************
*
* NAME
*    CatalogATGadgets()
*
* DESCRIPTION
*    Initialize the ATNGad[]'s with localized labels.
*    Used by SetupMiscCatalogs() in Setup.c only.
****************************************************************
* 
*/

PUBLIC int CatalogATGadgets( void )
{
   IMPORT struct NewGadget ATNGad[];
   
   ATNGad[0].ng_GadgetText = CMsg( MSG_AG_CLHSTR_GAD, MSG_AG_CLHSTR_GAD_STR );
   ATNGad[1].ng_GadgetText = CMsg( MSG_AG_SLISTR_GAD, MSG_AG_SLISTR_GAD_STR );
   ATNGad[2].ng_GadgetText = CMsg( MSG_AG_PARSER_GAD, MSG_AG_PARSER_GAD_STR );
   
   return( 0 );
}

PUBLIC STRPTR GadCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_AG_LV_FULL_GAD:
         msgString = CMsg( MSG_AG_LV_FULL, MSG_AG_LV_FULL_STR );
         break;

      case MSG_YES_NO_BUTTONS_GAD:
         msgString = CMsg( MSG_YES_NO_BUTTONS, MSG_YES_NO_BUTTONS_STR );
         break;

      case MSG_AG_HELPER_GAD:
         msgString = CMsg( MSG_AG_HELPER, MSG_AG_HELPER_STR );
         break;

      case MSG_CANNOT_OPEN_GAD:
         msgString = CMsg( MSG_CANNOT_OPEN, MSG_CANNOT_OPEN_STR );
         break;

      case MSG_ATALK_FILE_PROB_GAD:
         msgString = CMsg( MSG_ATALK_FILE_PROB, MSG_ATALK_FILE_PROB_STR );
         break;
      }

   return( msgString );
}

PUBLIC STRPTR ATHBCMsg( int whichString ) // ATHB.c file
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case ATHB_CLASSREQ_ATHB:
         msgString = CMsg( MSG_ATHB_CLASSREQ, MSG_ATHB_CLASSREQ_STR );
	 break;
	 
      case MSG_SELECT_ATHB:
         msgString = CMsg( MSG_ATHB_SELECT, MSG_ATHB_SELECT_STR);
         break;

      case MSG_GAD_OKAY_ATHB:
         msgString = CMsg( MSG_ATHB_GO_GAD, MSG_ATHB_GO_GAD_STR );
         break;

      case MSG_GAD_CANCEL_ATHB:
         msgString = CMsg( MSG_ATHB_CANCEL_GAD, MSG_ATHB_CANCEL_GAD_STR );
         break;

      case MSG_GENERAL_ATHB:
         msgString = CMsg( MSG_ATHB_GENERAL_GAD, MSG_ATHB_GENERAL_GAD_STR );
         break;

      case MSG_INTUITION_ATHB:
         msgString = CMsg( MSG_ATHB_INTUITION_GAD, MSG_ATHB_INTUITION_GAD_STR );
         break;

      case MSG_SYSTEM_ATHB:
         msgString = CMsg( MSG_ATHB_SYSTEM_GAD, MSG_ATHB_SYSTEM_GAD_STR );
         break;

      case MSG_USER_ATHB:
         msgString = CMsg( MSG_ATHB_USER_GAD, MSG_ATHB_USER_GAD_STR );
         break;

      case ATHB_GENCLASS_ATHB:
         msgString = CMsg( MSG_ATHB_GENCLASS, MSG_ATHB_GENCLASS_STR );
         break;

      case ATHB_INTCLASS_ATHB:
         msgString = CMsg( MSG_ATHB_INTCLASS, MSG_ATHB_INTCLASS_STR );
         break;

      case ATHB_SYSTEM_ATHB:
         msgString = CMsg( MSG_ATHB_SYSCLASS, MSG_ATHB_SYSCLASS_STR );
         break;

      case ATHB_USER_ATHB:
         msgString = CMsg( MSG_ATHB_USECLASS, MSG_ATHB_USECLASS_STR );
	 break;
      
      case ATHB_WTITLE_ATHB:
         msgString = CMsg( MSG_ATHB_WTITLE, MSG_ATHB_WTITLE_STR );
	 break;
      }

   return( msgString );
}

/****h* SetupCatalog() [1.0] *****************************************
*
* NAME
*    SetupCatalog()
*
* DESCRIPTION
**********************************************************************
*
*/

PUBLIC int CatalogUserScript( void )
{
   IMPORT UBYTE           *USWdt;
   IMPORT struct NewGadget USNGad[];
   IMPORT struct TagItem   FileTags[];
   
   USWdt = CMsg( MSG_US_WTITLE, MSG_US_WTITLE_STR ); // WA_Title

   USNGad[ 0 ].ng_GadgetText = CMsg( MSG_GAD_MenuStr,     MSG_GAD_MenuStr_STR     );
   USNGad[ 1 ].ng_GadgetText = CMsg( MSG_GAD_FileNameStr, MSG_GAD_FileNameStr_STR );
   USNGad[ 2 ].ng_GadgetText = CMsg( MSG_GAD_FindBt,      MSG_GAD_FindBt_STR      );
   USNGad[ 3 ].ng_GadgetText = CMsg( MSG_ID_OKAY_GAD,     MSG_ID_OKAY_GAD_STR     );
   USNGad[ 4 ].ng_GadgetText = CMsg( MSG_ID_CANCEL_GAD,   MSG_ID_CANCEL_GAD_STR   );

   FileTags[1].ti_Data = (ULONG) CMsg( MSG_IO_GET_A_FILE, MSG_IO_GET_A_FILE_STR );
   FileTags[6].ti_Data = (ULONG) CMsg( MSG_OKAY_GAD,      MSG_OKAY_GAD_STR      );
   FileTags[7].ti_Data = (ULONG) CMsg( MSG_CANCEL_GAD,    MSG_CANCEL_GAD_STR    );

   return( 0 );
}

PUBLIC STRPTR USRCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_NEED_MENU_NAME_USR:
         msgString = CMsg( MSG_NEED_MENU_NAME, MSG_NEED_MENU_NAME_STR );
         break;

      case MSG_RQTITLE_USER_ERROR_USR:
         msgString = CMsg( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR ); 
         break;

      case MSG_NEED_FILE_NAME_USR:
         msgString = CMsg( MSG_NEED_FILE_NAME, MSG_NEED_FILE_NAME_STR ); 
         break;
      }

   return( msgString );
}

// ------- ATHelper.c Functions: ---------------------------------------------------

PUBLIC int CatalogATHelper( void )
{
   IMPORT UBYTE           *DVWdt, *WhatDidYouDo;
   IMPORT struct NewGadget DVNGad[];
   IMPORT struct TagItem   FileTags[];
   IMPORT char             DefParentDir[128];     // "AmigaTalk:Help";
   IMPORT char             DefFileExtFilter[128]; // "(#?.guide|#?.doc)";
   IMPORT char             DefFileViewer[128];    // "MultiView";
      
   DVWdt        = CMsg( MSG_AH_WTITLE,   MSG_AH_WTITLE_STR   );
   WhatDidYouDo = CMsg( MSG_AH_WHAT_DID, MSG_AH_WHAT_DID_STR );

   StringNCopy( DefParentDir,     "AmigaTalk:Help",    128 );
   StringNCopy( DefFileExtFilter, "(#?.guide|#?.doc)", 128 );
   StringNCopy( DefFileViewer,    "MultiView",         128 );

   DVNGad[0].ng_GadgetText = CMsg( MSG_AH_HELPLV_GAD,  MSG_AH_HELPLV_GAD_STR  );
   DVNGad[2].ng_GadgetText = CMsg( MSG_AH_FILESTR_GAD, MSG_AH_FILESTR_GAD_STR );
   DVNGad[3].ng_GadgetText = CMsg( MSG_AH_CHGDIR_GAD,  MSG_AH_CHGDIR_GAD_STR  );
   DVNGad[4].ng_GadgetText = CMsg( MSG_AH_VIEW_GAD,    MSG_AH_VIEW_GAD_STR    );

   SetTagItem( FileTags, ASLFR_TitleText, (ULONG) CMsg( MSG_SELECT_FILE, MSG_SELECT_FILE_STR ) );

   SetTagItem( FileTags, ASLFR_PositiveText, (ULONG) CMsg( MSG_OKAY_GAD, MSG_OKAY_GAD_STR ) );
             
   SetTagItem( FileTags, ASLFR_NegativeText, (ULONG) CMsg( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR ) );

   return( 0 );
}

PUBLIC STRPTR HelpCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_AH_CANTPARSE_HELP:
         msgString = CMsg( MSG_FORMAT_AH_CANTPARSE, MSG_FORMAT_AH_CANTPARSE_STR );
         break;

      case MSG_AH_FILEEXT_BRK_HELP:
         msgString = CMsg( MSG_AH_FILEEXT_BRK, MSG_AH_FILEEXT_BRK_STR );
         break;

      case MSG_FMT_AH_CANTLOCK_HELP:
         msgString = CMsg( MSG_FORMAT_AH_CANTLOCK, MSG_FORMAT_AH_CANTLOCK_STR );
         break;

      case MSG_FMT_AH_NOTDIR_HELP:
         msgString = CMsg( MSG_FORMAT_AH_NOTDIR, MSG_FORMAT_AH_NOTDIR_STR );
         break;

      case MSG_AH_HELPER_FUNC_HELP:
         msgString = CMsg( MSG_AH_HELPER_FUNC, MSG_AH_HELPER_FUNC_STR );
         break;

      case MSG_FMT_KILLLV_HELP:
	 msgString = CMsg( MSG_FORMAT_KILLLV, MSG_FORMAT_KILLLV_STR );
         break;

      case MSG_FMT_ALLOCLV_HELP:
	 msgString = CMsg( MSG_FORMAT_ALLOCLV, MSG_FORMAT_ALLOCLV_STR );
         break;

      case MSG_FMT_AH_NOFILES_HELP:
         msgString = CMsg( MSG_FORMAT_AH_NOFILES, MSG_FORMAT_AH_NOFILES_STR );
         break;

      case MSG_AH_SELECT_NEW_HELP:
         msgString = CMsg( MSG_AH_SELECT_NEW, MSG_AH_SELECT_NEW_STR );
         break;

      case MSG_AH_SELECT_DOC_HELP:
         msgString = CMsg( MSG_AH_SELECT_DOC, MSG_AH_SELECT_DOC_STR ); 
         break;

      case MSG_AH_WTITLE2_HELP:
         msgString = CMsg( MSG_AH_WTITLE2, MSG_AH_WTITLE2_STR );
         break;

      case MSG_AH_CONTINUE_HELP:
         msgString = CMsg( MSG_AH_CONTINUE, MSG_AH_CONTINUE_STR );
         break;

      case MSG_AH_MEMORYOUT_HELP:
         msgString = CMsg( MSG_AH_MEMORYOUT, MSG_AH_MEMORYOUT_STR );
         break;

      case MSG_AH_WTITLE3_HELP:
         msgString = CMsg( MSG_AH_WTITLE3, MSG_AH_WTITLE3_STR );
         break;

      case MSG_AH_FILEVIEWER_HELP:
         msgString = CMsg( MSG_AH_FILEVIEWER, MSG_AH_FILEVIEWER_STR );
         break;

      case MSG_AH_ENTER_FILE_HELP:
         msgString = CMsg( MSG_AH_ENTER_FILE, MSG_AH_ENTER_FILE_STR );
         break;

      case MSG_FMT_AH_ABOUTMSG_HELP:
         msgString = CMsg( MSG_FORMAT_AH_ABOUTMSG, MSG_FORMAT_AH_ABOUTMSG_STR );
         break;

      case MSG_AH_ABOUT_HELP:
         msgString = CMsg( MSG_AH_ABOUT, MSG_AH_ABOUT_STR );   
         break;

      case MSG_AH_SETUP_FUNC_HELP:
         msgString = CMsg( MSG_AH_SETUP_FUNC, MSG_AH_SETUP_FUNC_STR );
         break;

      case MSG_AH_UNDERSTAND_HELP:
         msgString = CMsg( MSG_AH_UNDERSTAND, MSG_AH_UNDERSTAND_STR );
         break;

      case MSG_AH_SELECTASAP_HELP:
         msgString = CMsg( MSG_AH_SELECTASAP, MSG_AH_SELECTASAP_STR );
         break;

      case MSG_AH_PARENTDIR_HELP:
         msgString = CMsg( MSG_AH_PARENTDIR, MSG_AH_PARENTDIR_STR );
         break;
      }

   return( msgString );
}

/****h* CatalogATMenus() [2.3] ****************************************
*
* NAME
*    CatalogATMenus()
*
* DESCRIPTION
*    Setup localized menu lebels & CommKeys.  Called by 
*    SetupMiscCatalogs() in Setup.c only.
***********************************************************************
*
*/

PUBLIC int CatalogATMenus( void )
{
   IMPORT UBYTE *ATFileProblem;
   IMPORT STRPTR Report0Str; // AM_REPORT0;
   IMPORT STRPTR Report1Str; // AM_REPORT1;
   IMPORT STRPTR Report2Str; // AM_REPORT2;
   IMPORT struct NewMenu ATNewMenu[];
   
   ATFileProblem = CMsg( MSG_AM_FILEPROBLEM, MSG_AM_FILEPROBLEM_STR );

   Report0Str = CMsg( MSG_AM_REPORT0_MENU, MSG_AM_REPORT0_MENU_STR );
   Report1Str = CMsg( MSG_AM_REPORT1_MENU, MSG_AM_REPORT1_MENU_STR );  
   Report2Str = CMsg( MSG_AM_REPORT2_MENU, MSG_AM_REPORT2_MENU_STR );

   ATNewMenu[0].nm_Label  = CMsg( MSG_AM_PROJECT_MENU, MSG_AM_PROJECT_MENU_STR );
    ATNewMenu[1].nm_Label  = CMsg( MSG_AM_LOAD_MENU,    MSG_AM_LOAD_MENU_STR    );
    ATNewMenu[2].nm_Label  = CMsg( MSG_AM_INCL_MENU,    MSG_AM_INCL_MENU_STR    );
    ATNewMenu[3].nm_Label  = CMsg( MSG_AM_SAVE_MENU,    MSG_AM_SAVE_MENU_STR    );
    ATNewMenu[4].nm_Label  = CMsg( MSG_AM_SAVEAS_MENU,  MSG_AM_SAVEAS_MENU_STR  );
    ATNewMenu[5].nm_Label  = CMsg( MSG_AM_SETPAL_MENU,  MSG_AM_SETPAL_MENU_STR  );
    ATNewMenu[6].nm_Label  = CMsg( MSG_AM_QUIT_MENU,    MSG_AM_QUIT_MENU_STR    );
    // SEPARATOR_BAR = [7]
    ATNewMenu[8].nm_Label  = CMsg( MSG_AM_ADDITEM_MENU,  MSG_AM_ADDITEM_MENU_STR  );
    ATNewMenu[9].nm_Label  = CMsg( MSG_AM_REMITEM_MENU,  MSG_AM_REMITEM_MENU_STR  );
    // SEPARATOR_BAR = [10]
    ATNewMenu[11].nm_Label  = CMsg( MSG_AM_ABOUT_MENU,  MSG_AM_ABOUT_MENU_STR  );
    ATNewMenu[12].nm_Label  = CMsg( MSG_AM_HELP_MENU,   MSG_AM_HELP_MENU_STR   );
    ATNewMenu[13].nm_Label  = CMsg( MSG_AM_SYSDIR_MENU, MSG_AM_SYSDIR_MENU_STR );
    // SEPARATOR_BAR = [14]
    ATNewMenu[15].nm_Label = CMsg( MSG_AM_OPENB_MENU,   MSG_AM_OPENB_MENU_STR   );
    ATNewMenu[16].nm_Label = CMsg( MSG_AM_EDITOR_MENU,  MSG_AM_EDITOR_MENU_STR  );

   ATNewMenu[17].nm_Label = CMsg( MSG_AM_BEHAVE_MENU,  MSG_AM_BEHAVE_MENU_STR  );
    ATNewMenu[18].nm_Label = CMsg( MSG_AM_RPTLVL_MENU,  MSG_AM_RPTLVL_MENU_STR  );
     ATNewMenu[19].nm_Label = CMsg( MSG_AM_REPORT0_MENU, MSG_AM_REPORT0_MENU_STR );
     ATNewMenu[20].nm_Label = CMsg( MSG_AM_REPORT1_MENU, MSG_AM_REPORT1_MENU_STR );
     ATNewMenu[21].nm_Label = CMsg( MSG_AM_REPORT2_MENU, MSG_AM_REPORT2_MENU_STR );
   
    ATNewMenu[22].nm_Label = CMsg( MSG_AM_DEBUG_MENU,   MSG_AM_DEBUG_MENU_STR   );
    ATNewMenu[23].nm_Label = CMsg( MSG_AM_EXAMINE_MENU, MSG_AM_EXAMINE_MENU_STR );
    ATNewMenu[24].nm_Label = CMsg( MSG_AM_TRACE_MENU,   MSG_AM_TRACE_MENU_STR   );
    ATNewMenu[25].nm_Label = CMsg( MSG_AM_LEXPRT_MENU,  MSG_AM_LEXPRT_MENU_STR  );
    ATNewMenu[26].nm_Label = CMsg( MSG_AM_SILENCE_MENU, MSG_AM_SILENCE_MENU_STR );
    ATNewMenu[27].nm_Label = CMsg( MSG_AM_PRALLOC_MENU, MSG_AM_PRALLOC_MENU_STR );
    ATNewMenu[28].nm_Label = CMsg( MSG_AM_ENBSTAT_MENU, MSG_AM_ENBSTAT_MENU_STR );

   ATNewMenu[29].nm_Label = CMsg( MSG_AM_USERSCRIPTS_MENU, MSG_AM_USERSCRIPTS_MENU_STR );

   // ------ Shortcut Keys: --------------------
   
   ATNewMenu[1].nm_CommKey  = CMsg( MSG_AM_LOAD_MENUKEY,    MSG_AM_LOAD_MENUKEY_STR   );
   ATNewMenu[3].nm_CommKey  = CMsg( MSG_AM_SAVE_MENUKEY,    MSG_AM_SAVE_MENUKEY_STR   );
   ATNewMenu[4].nm_CommKey  = CMsg( MSG_AM_SAVEAS_MENUKEY,  MSG_AM_SAVEAS_MENUKEY_STR );
   ATNewMenu[5].nm_CommKey  = CMsg( MSG_AM_PALETTE_MENUKEY, MSG_AM_PALETTE_MENUKEY_STR );
   ATNewMenu[6].nm_CommKey  = CMsg( MSG_AM_QUIT_MENUKEY,    MSG_AM_QUIT_MENUKEY_STR   );

   ATNewMenu[8].nm_CommKey  = CMsg( MSG_AM_ADDITEM_MENUKEY,   MSG_AM_ADDITEM_MENUKEY_STR );
   ATNewMenu[9].nm_CommKey  = CMsg( MSG_AM_REMITEM_MENUKEY,   MSG_AM_REMITEM_MENUKEY_STR );
   
   ATNewMenu[11].nm_CommKey  = CMsg( MSG_AM_ABOUT_MENUKEY, MSG_AM_ABOUT_MENUKEY_STR );
   ATNewMenu[12].nm_CommKey  = CMsg( MSG_AM_HELP_MENUKEY,  MSG_AM_HELP_MENUKEY_STR  );

   ATNewMenu[15].nm_CommKey = CMsg( MSG_AM_BROWSE_MENUKEY, MSG_AM_BROWSE_MENUKEY_STR );
   ATNewMenu[16].nm_CommKey = CMsg( MSG_AM_EDITOR_MENUKEY, MSG_AM_EDITOR_MENUKEY_STR );
   ATNewMenu[24].nm_CommKey = CMsg( MSG_AM_TRACE_MENUKEY,  MSG_AM_TRACE_MENUKEY_STR  );

   return( 0 );
}

PUBLIC STRPTR MenuCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_DEFAULT_BUTTONS:
         msgString = CMsg( MSG_DEFAULT_BUTTONS_STR, MSG_DEFAULT_BUTTONS_STR_STR );
         break;

      case MSG_AH_MEMORYOUT_MENU:
         msgString = CMsg( MSG_AH_MEMORYOUT, MSG_AH_MEMORYOUT_STR ); 
         break;

      case MSG_RQTITLE_SYSTEM_PROBLEM_MENU:
         msgString = CMsg( MSG_RQTITLE_SYSTEM_PROBLEM, MSG_RQTITLE_SYSTEM_PROBLEM_STR );
         break;

      case MSG_NO_MORE_ITEMS_MENU:
         msgString = CMsg( MSG_NO_MORE_ITEMS, MSG_NO_MORE_ITEMS_STR ); 
         break;

      case MSG_RQTITLE_USER_ERROR_MENU:
         msgString = CMsg( MSG_RQTITLE_USER_ERROR, MSG_RQTITLE_USER_ERROR_STR );
         break;

      case MSG_NO_MENU_ATTACH_MENU:
         msgString = CMsg( MSG_NO_MENU_ATTACH, MSG_NO_MENU_ATTACH_STR );
         break;

      case MSG_NO_LESS_ITEMS_MENU:
         msgString = CMsg( MSG_NO_LESS_ITEMS, MSG_NO_LESS_ITEMS_STR );
         break;

      case MSG_AM_TRACE_MENU_MENU:
         msgString = CMsg( MSG_AM_TRACE_MENU, MSG_AM_TRACE_MENU_STR );
         break;

      case MSG_AM_ENTER_TFILE_MENU:
         msgString = CMsg( MSG_AM_ENTER_TFILE, MSG_AM_ENTER_TFILE_STR ); 
         break;

      case MSG_AM_NOTRACE_MENU:
         msgString = CMsg( MSG_AM_NOTRACE, MSG_AM_NOTRACE_STR );
         break;

      case MSG_FMT_AM_NIL_MENU:
         msgString = CMsg( MSG_FORMAT_AM_NIL, MSG_FORMAT_AM_NIL_STR );
         break;

      case MSG_FMT_AM_TRUE_MENU:
         msgString = CMsg( MSG_FORMAT_AM_TRUE, MSG_FORMAT_AM_TRUE_STR );
         break;

      case MSG_FMT_AM_FALSE_MENU:
         msgString = CMsg( MSG_FORMAT_AM_FALSE, MSG_FORMAT_AM_FALSE_STR );
         break;

      case MSG_FMT_AM_DRIVER_MENU:
         msgString = CMsg( MSG_FORMAT_AM_DRIVER, MSG_FORMAT_AM_DRIVER_STR );
         break;

      case MSG_GL_LOAD_STR_MENU:
         msgString = CMsg( MSG_GL_LOAD_STR, MSG_GL_LOAD_STR_STR );
         break;

      case MSG_GL_SAVE_STR_MENU:
	 msgString = CMsg( MSG_GL_SAVE_STR, MSG_GL_SAVE_STR_STR );
         break;

      case MSG_YES_NO_BUTTONS_MENU:
         msgString = CMsg( MSG_YES_NO_BUTTONS, MSG_YES_NO_BUTTONS_STR );
         break;

      case MSG_AM_SURE_QUIT_MENU:
         msgString = CMsg( MSG_AM_SURE_QUIT, MSG_AM_SURE_QUIT_STR );
         break;

      case MSG_TT_HELPPROGRAM_MENU:
         msgString = CMsg( MSG_TT_HELPPROGRAM, MSG_TT_HELPPROGRAM_STR );
         break;
      }
      
   return( msgString );
}

// Global.c String Functions: ----------------------------------------------

/****h* CatalogGlobal() [2.3] ****************************************
*
* NAME
*    CatalogGlobal()
*
* DESCRIPTION
*    Localize various strings.  Called by SetupMiscCatalogs() in
*    Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogGlobal( void )
{
   IMPORT struct TagItem FontTags[];
   IMPORT struct TagItem ScreenTags[];
   IMPORT struct TagItem LoadTags[];
   IMPORT struct TagItem SaveTags[];
   
   SetTagItem( FontTags, ASLFO_TitleText,    
               (ULONG) CMsg( MSG_GL_SELECT_FONT, MSG_GL_SELECT_FONT_STR )
             );

   SetTagItem( FontTags, ASLFO_PositiveText, 
               (ULONG) CMsg( MSG_OKAY_GAD, MSG_OKAY_GAD_STR )
             );

   SetTagItem( FontTags, ASLFO_NegativeText, 
               (ULONG) CMsg( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR )
             );
             
   SetTagItem( FontTags, ASLFO_SampleText, 
               (ULONG) CMsg( MSG_GL_FONT_EXAMPLE, MSG_GL_FONT_EXAMPLE_STR )
             );

   SetTagItem( ScreenTags, ASLSM_TitleText,    
               (ULONG) CMsg( MSG_GL_SELECT_MODE, MSG_GL_SELECT_MODE_STR ) 
             );

   SetTagItem( ScreenTags, ASLSM_PositiveText, 
               (ULONG) CMsg( MSG_OKAY_GAD, MSG_OKAY_GAD_STR )
             );
   
   SetTagItem( ScreenTags, ASLSM_NegativeText, 
               (ULONG) CMsg( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR )
             );

   SetTagItem( LoadTags, ASLFR_TitleText,    
               (ULONG) CMsg( MSG_GL_LOAD_STR, MSG_GL_LOAD_STR_STR )
             );

   SetTagItem( LoadTags, ASLFR_PositiveText, 
               (ULONG) CMsg( MSG_OKAY_GAD, MSG_OKAY_GAD_STR )
             );

   SetTagItem( LoadTags, ASLFR_NegativeText, 
               (ULONG) CMsg( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR )
             );

   SetTagItem( SaveTags, ASLFR_TitleText,    
               (ULONG) CMsg( MSG_GL_SAVE_STR, MSG_GL_SAVE_STR_STR )
             );

   SetTagItem( SaveTags, ASLFR_PositiveText, 
               (ULONG) CMsg( MSG_OKAY_GAD, MSG_OKAY_GAD_STR )
             );

   SetTagItem( SaveTags, ASLFR_NegativeText,
               (ULONG) CMsg( MSG_CANCEL_GAD, MSG_CANCEL_GAD_STR )
             );

   return( 0 );
}

PUBLIC STRPTR GlobCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_GL_STATUS_TITLE_GLOB:
         msgString = CMsg( MSG_GL_STATUS_TITLE, MSG_GL_STATUS_TITLE_STR );
	 break;
      
      case MSG_GL_BAD_INDEX_GLOB:
	 msgString = CMsg( MSG_GL_BAD_INDEX, MSG_GL_BAD_INDEX_STR );
	 break;

      case MSG_METHOD_COLON_GLOB:
	 msgString = CMsg( MSG_METHOD_COLON, MSG_METHOD_COLON_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- Block.c String functions: -----------------------------

PUBLIC STRPTR BlkCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_BL_WRONG_ARGS_BLOCK:
         msgString = CMsg( MSG_BL_WRONG_ARGS, MSG_BL_WRONG_ARGS_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- Audio.c String functions: -----------------------------

PUBLIC STRPTR AudCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_AU_ALLOC_FUNC_AUDIO:
         msgString = CMsg( MSG_AU_ALLOC_FUNC, MSG_AU_ALLOC_FUNC_STR );
	 break;

      case MSG_AU_AUDIO_MSG_AUDIO:	 
         msgString = CMsg( MSG_AU_AUDIO_MSG, MSG_AU_AUDIO_MSG_STR );
	 break;

      case MSG_AU_AUDIOCLASSNAME_AUDIO:
         msgString = CMsg( MSG_AU_AUDIOCLASSNAME, MSG_AU_AUDIOCLASSNAME_STR );
	 break;

      case MSG_AU_TOO_SMALL_AUDIO:
         msgString = CMsg( MSG_AU_TOO_SMALL, MSG_AU_TOO_SMALL_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- BOOPSI.c String functions: ---------------------------

PUBLIC STRPTR BoopCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_BO_BOOPSI_ERR_BOOPSI:
         msgString = CMsg( MSG_BO_BOOPSI_ERR, MSG_BO_BOOPSI_ERR_STR );
         break;

      case MSG_BO_NO_ERR_BOOPSI:
         msgString = CMsg( MSG_BO_NO_ERR, MSG_BO_NO_ERR_STR );
         break;
      }
      
   return( msgString );
}

// ----------------- Border.c String functions: ---------------------------

PUBLIC STRPTR BdrCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_BD_BORDERCLASSNAME_BORDER: 
         msgString = CMsg( MSG_BD_BORDERCLASSNAME, MSG_BD_BORDERCLASSNAME_STR );
	 break;

      case MSG_BD_BITMAPCLASSNAME_BORDER: 
         msgString = CMsg( MSG_BD_BITMAPCLASSNAME, MSG_BD_BITMAPCLASSNAME_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- CDROM.c String functions: ----------------------------

PUBLIC STRPTR CDROMCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_CR_OPEN_FUNC_CDROM:
         msgString = CMsg( MSG_CR_OPEN_FUNC, MSG_CR_OPEN_FUNC_STR );
         break;

      case MSG_FMT_CR_ERR_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_ERR, MSG_FORMAT_CR_ERR_STR );
         break;

      case MSG_CR_PROBLEM_CDROM:
         msgString = CMsg( MSG_CR_PROBLEM, MSG_CR_PROBLEM_STR );
         break;

      case MSG_CR_CDROM_STR_CDROM:
         msgString = CMsg( MSG_CR_CDROM_STR, MSG_CR_CDROM_STR_STR );
         break;

      case MSG_FMT_CR_BY_UNEVEN_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_BY_UNEVEN, MSG_FORMAT_CR_BY_UNEVEN_STR );
         break;

      case MSG_FMT_CR_BY_ODD_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_BY_ODD, MSG_FORMAT_CR_BY_ODD_STR );
         break;

      case MSG_CR_GEOOBJ_FUNC_CDROM:
         msgString = CMsg( MSG_CR_GEOOBJ_FUNC, MSG_CR_GEOOBJ_FUNC_STR );
         break;

      case MSG_FMT_CR_TR_UNEVEN_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_TR_UNEVEN, MSG_FORMAT_CR_TR_UNEVEN_STR );
         break;

      case MSG_FMT_CR_TR_ODD_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_TR_ODD, MSG_FORMAT_CR_TR_ODD_STR );
         break;

      case MSG_FMT_CR_ST_UNEVEN_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_ST_UNEVEN, MSG_FORMAT_CR_ST_UNEVEN_STR );
         break;

      case MSG_FMT_CR_ST_ODD_CDROM:
         msgString = CMsg( MSG_FORMAT_CR_ST_ODD, MSG_FORMAT_CR_ST_ODD_STR ); 
         break;
      }
      
   return( msgString );
}

/****h* CatalogCDROM() [3.0] ******************************************
*
* NAME
*    CatalogCDROM()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
***********************************************************************
*
*/

PUBLIC int CatalogCDROM( void )
{
   IMPORT UBYTE *CDErrStrs[30];
   
   CDErrStrs[0]  = CMsg( MSG_CR_ERR_HARDFAIL, MSG_CR_ERR_HARDFAIL_STR );  // -7    0
   CDErrStrs[1]  = CMsg( MSG_CR_ERR_BUSY,     MSG_CR_ERR_BUSY_STR );      // -6    1
   CDErrStrs[2]  = CMsg( MSG_CR_ERR_INVADDR,  MSG_CR_ERR_INVADDR_STR );
   CDErrStrs[3]  = CMsg( MSG_CR_ERR_INVLEN,   MSG_CR_ERR_INVLEN_STR );
   CDErrStrs[4]  = CMsg( MSG_CR_ERR_NOCMD,    MSG_CR_ERR_NOCMD_STR );
   CDErrStrs[5]  = CMsg( MSG_CR_ERR_EARLY,    MSG_CR_ERR_EARLY_STR );
   CDErrStrs[6]  = CMsg( MSG_CR_ERR_UNITFAIL, MSG_CR_ERR_UNITFAIL_STR );
   CDErrStrs[7]  = CMsg( MSG_CR_ERR_NO_ERR,   MSG_CR_ERR_NO_ERR_STR );    // 0     7
   CDErrStrs[8]  = CMsg( MSG_CR_ERR_UNSP_ERR, MSG_CR_ERR_UNSP_ERR_STR );  // 20    8
   CDErrStrs[9]  = CMsg( MSG_CR_ERR_NOSECHDR, MSG_CR_ERR_NOSECHDR_STR );
   CDErrStrs[10] = CMsg( MSG_CR_ERR_SECPRE,   MSG_CR_ERR_SECPRE_STR );
   CDErrStrs[11] = CMsg( MSG_CR_ERR_BAD_ID,   MSG_CR_ERR_BAD_ID_STR );
   CDErrStrs[12] = CMsg( MSG_CR_ERR_HDRSUM,   MSG_CR_ERR_HDRSUM_STR );
   CDErrStrs[13] = CMsg( MSG_CR_ERR_DATASUM,  MSG_CR_ERR_DATASUM_STR );   // 25
   CDErrStrs[14] = CMsg( MSG_CR_ERR_NOSECS,   MSG_CR_ERR_NOSECS_STR );
   CDErrStrs[15] = CMsg( MSG_CR_ERR_SECHDR,   MSG_CR_ERR_SECHDR_STR );
   CDErrStrs[16] = CMsg( MSG_CR_ERR_WRTPROT,  MSG_CR_ERR_WRTPROT_STR );
   CDErrStrs[17] = CMsg( MSG_CR_ERR_NO_CD,    MSG_CR_ERR_NO_CD_STR );
   CDErrStrs[18] = CMsg( MSG_CR_ERR_SEEKERR,  MSG_CR_ERR_SEEKERR_STR );   // 30
   CDErrStrs[19] = CMsg( MSG_CR_ERR_NO_MEM,   MSG_CR_ERR_NO_MEM_STR );
   CDErrStrs[20] = CMsg( MSG_CR_ERR_BADNUM,   MSG_CR_ERR_BADNUM_STR );
   CDErrStrs[21] = CMsg( MSG_CR_ERR_BAD_DEV,  MSG_CR_ERR_BAD_DEV_STR );
   CDErrStrs[22] = CMsg( MSG_CR_ERR_USED,     MSG_CR_ERR_USED_STR );
   CDErrStrs[23] = CMsg( MSG_CR_ERR_RESET,    MSG_CR_ERR_RESET_STR );     // 35
   CDErrStrs[24] = CMsg( MSG_CR_ERR_UNKDATA,  MSG_CR_ERR_UNKDATA_STR );
   CDErrStrs[25] = CMsg( MSG_CR_ERR_INVCMD,   MSG_CR_ERR_INVCMD_STR );    // 37    25
   CDErrStrs[26] = CMsg( MSG_CR_ERR_BADPHASE, MSG_CR_ERR_BADPHASE_STR );  // 42    26
   CDErrStrs[27] = CMsg( MSG_CR_ERR_FAILOPEN, MSG_CR_ERR_FAILOPEN_STR );  // 50    27

   return( 0 );
}

// ----------------- Class.c String functions: ----------------------------

PUBLIC STRPTR ClassCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_CL_NO_NEW_CLASS:
         msgString = CMsg( MSG_FORMAT_CL_NO_NEW, MSG_FORMAT_CL_NO_NEW_STR );
         break;
      }
      
   return( msgString );
}

// ----------------- ClDict.c String functions: --------------------------

PUBLIC STRPTR CLDCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_CD_OBJECT_CLDICT:
         msgString = CMsg( MSG_FORMAT_CD_OBJECT, MSG_FORMAT_CD_OBJECT_STR ); 
	 break;
      }
      
   return( msgString );
}

// ----------------- Clipboard.c String Functions: -----------------------

/****h* CatalogClipboard() [3.0] ********************************
*
* NAME
*    CatalogClipboard()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
*****************************************************************
*
*/

PUBLIC int CatalogClipboard( void )
{
   IMPORT char *CBErrMsgs[16];
   
   CBErrMsgs[0]  = CMsg( MSG_CB_ERR_NONE,     MSG_CB_ERR_NONE_STR );     // 0 
   CBErrMsgs[1]  = CMsg( MSG_CB_ERR_EOF,      MSG_CB_ERR_EOF_STR );      // IFFERR_EOF     = -1
   CBErrMsgs[2]  = CMsg( MSG_CB_ERR_EOC,      MSG_CB_ERR_EOC_STR );      // IFFERR_EOC     = -2
   CBErrMsgs[3]  = CMsg( MSG_CB_ERR_NOSCOPE,  MSG_CB_ERR_NOSCOPE_STR );  // IFFERR_NOSCOPE = -3
   CBErrMsgs[4]  = CMsg( MSG_CB_ERR_NOMEM,    MSG_CB_ERR_NOMEM_STR );    // IFFERR_NOMEM   = -4
   CBErrMsgs[5]  = CMsg( MSG_CB_ERR_READ,     MSG_CB_ERR_READ_STR );     // IFFERR_READ    = -5
   CBErrMsgs[6]  = CMsg( MSG_CB_ERR_WRITE,    MSG_CB_ERR_WRITE_STR );    // IFFERR_WRITE   = -6
   CBErrMsgs[7]  = CMsg( MSG_CB_ERR_SEEK,     MSG_CB_ERR_SEEK_STR );     // IFFERR_SEEK    = -7
   CBErrMsgs[8]  = CMsg( MSG_CB_ERR_CRUPT,    MSG_CB_ERR_CRUPT_STR );    // IFFERR_MANGLED = -8
   CBErrMsgs[9]  = CMsg( MSG_CB_ERR_SYNTAX,   MSG_CB_ERR_SYNTAX_STR );   // IFFERR_SYNTAX  = -9
   CBErrMsgs[10] = CMsg( MSG_CB_ERR_NOIFF,    MSG_CB_ERR_NOIFF_STR );    // IFFERR_NOTIFF  = -10
   CBErrMsgs[11] = CMsg( MSG_CB_ERR_MISSHOOK, MSG_CB_ERR_MISSHOOK_STR ); // IFFERR_NOHOOK  = -11
   CBErrMsgs[12] = CMsg( MSG_CB_ERR_RTC,      MSG_CB_ERR_RTC_STR );
   CBErrMsgs[13] = CMsg( MSG_CB_ERR_BADNUM,   MSG_CB_ERR_BADNUM_STR );   // -12 My Additions
   CBErrMsgs[14] = CMsg( MSG_CB_ERR_NOSTREAM, MSG_CB_ERR_NOSTREAM_STR ); // -13

   return( 0 );
}

PUBLIC STRPTR ClipCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_CB_ERR_NO_HOOK_CLIP:
         msgString = CMsg( MSG_CB_ERR_NO_HOOK, MSG_CB_ERR_NO_HOOK_STR );
	 break;

      case MSG_CB_ERR_HOOK_CTRL_CLIP:	 
         msgString = CMsg( MSG_CB_ERR_HOOK_CTRL, MSG_CB_ERR_HOOK_CTRL_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- Console.c String functions: ---------------------------

PUBLIC STRPTR ConCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_CN_ATTACH_FUNC_CON:
         msgString = CMsg( MSG_CN_ATTACH_FUNC, MSG_CN_ATTACH_FUNC_STR );
	 break;

      case MSG_CN_CONSOLECLASSNAME_CON:
         msgString = CMsg( MSG_CN_CONSOLECLASSNAME, MSG_CN_CONSOLECLASSNAME_STR );
	 break;
      }
      
   return( msgString );
}

PUBLIC int CatalogConsole( void )
{
   IMPORT UBYTE *ConsProblem;
   
   ConsProblem = CMsg( MSG_CN_CONS_PROB, MSG_CN_CONS_PROB_STR );
   
   return( 0 );
}

// ----------------- Courier.c String functions: ---------------------------

PUBLIC STRPTR CourCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_CO_BACKTRC_COUR:
         msgString = CMsg( MSG_FORMAT_CO_BACKTRC, MSG_FORMAT_CO_BACKTRC_STR );
	 break;

      case MSG_CO_NULL_RCVR_COUR:
         msgString = CMsg( MSG_CO_NULL_RCVR, MSG_CO_NULL_RCVR_STR );
	 break;

      case MSG_CO_NO_ENTRY_COUR:
         msgString = CMsg( MSG_CO_NO_ENTRY, MSG_CO_NO_ENTRY_STR );
	 break;

      case MSG_CO_NOT_CLASS_COUR:
         msgString = CMsg( MSG_CO_NOT_CLASS, MSG_CO_NOT_CLASS_STR );
	 break;

      case MSG_FMT_CO_INTERP_COUR:
         msgString = CMsg( MSG_FORMAT_CO_INTERP, MSG_FORMAT_CO_INTERP_STR );
	 break;
      }
      
   return( msgString );
}

// ----------------- Curses.c String functions: ----------------------------

PUBLIC STRPTR CursCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_CP_ALLCWL_FUNC_CURSE:
         msgString = CMsg( MSG_CP_ALLCWL_FUNC, MSG_CP_ALLCWL_FUNC_STR );
	 break;

      case MSG_CP_TOO_MANY_CURSE:
         msgString = CMsg( MSG_CP_TOO_MANY, MSG_CP_TOO_MANY_STR );
	 break;
      }

   return( msgString );
}

// ----------------- DBase.c String functions: -----------------------------

PUBLIC STRPTR DBaseCMsg( int whichString )
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_DB_NO_OPEN_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_NO_OPEN, MSG_FORMAT_DB_NO_OPEN_STR );
	 break;

      case MSG_FMT_DB_NO_CREAT_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_NO_CREAT, MSG_FORMAT_DB_NO_CREAT_STR );
	 break;

      case MSG_DB_GETINFO_FUNC_DBASE:
         msgString = CMsg( MSG_DB_GETINFO_FUNC, MSG_DB_GETINFO_FUNC_STR );
	 break;

      case MSG_FMT_DB_NO_CLDCT_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_NO_CLDCT, MSG_FORMAT_DB_NO_CLDCT_STR );
	 break;

      case MSG_FMT_DB_WRG_FMT_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_WRG_FMT, MSG_FORMAT_DB_WRG_FMT_STR );
	 break;

      case MSG_DB_READTMP_FUNC_DBASE:
         msgString = CMsg( MSG_DB_READTMP_FUNC, MSG_DB_READTMP_FUNC_STR );
	 break;

      case MSG_FMT_DB_NO_CLOSE_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_NO_CLOSE, MSG_FORMAT_DB_NO_CLOSE_STR );
	 break;

      case MSG_DB_MCREAT_FUNC_DBASE:
         msgString = CMsg( MSG_DB_MCREAT_FUNC, MSG_DB_MCREAT_FUNC_STR );
	 break;

      case MSG_DB_MOPEN_FUNC_DBASE:
         msgString = CMsg( MSG_DB_MOPEN_FUNC, MSG_DB_MOPEN_FUNC_STR );
	 break;

      case MSG_DB_ICREAT_FUNC_DBASE:
         msgString = CMsg( MSG_DB_ICREAT_FUNC, MSG_DB_ICREAT_FUNC_STR );
	 break;

      case MSG_DB_IOPEN_FUNC_DBASE:
         msgString = CMsg( MSG_DB_IOPEN_FUNC, MSG_DB_IOPEN_FUNC_STR );
	 break;

      case MSG_FMT_DB_TKEYFAIL_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_TKEYFAIL, MSG_FORMAT_DB_TKEYFAIL_STR );
	 break;

      case MSG_DB_IDX_PROB_DBASE:
         msgString = CMsg( MSG_DB_IDX_PROB, MSG_DB_IDX_PROB_STR );
	 break;

      case MSG_FMT_DB_GETNXT_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_GETNXT, MSG_FORMAT_DB_GETNXT_STR );
	 break;

      case MSG_FMT_DB_GETPRV_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_GETPRV, MSG_FORMAT_DB_GETPRV_STR );
	 break;

      case MSG_FMT_DB_GETREC_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_GETREC, MSG_FORMAT_DB_GETREC_STR );
	 break;

      case MSG_FMT_DB_READKEY_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_READKEY, MSG_FORMAT_DB_READKEY_STR );
	 break;

      case MSG_DB_CREATF_FUNC_DBASE:
         msgString = CMsg( MSG_DB_CREATF_FUNC, MSG_DB_CREATF_FUNC_STR );
	 break;

      case MSG_FMT_DB_CREAT_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_CREAT, MSG_FORMAT_DB_CREAT_STR );
	 break;

      case MSG_FMT_DB_UNKTYPE_DBASE:
         msgString = CMsg( MSG_FORMAT_DB_UNKTYPE, MSG_FORMAT_DB_UNKTYPE_STR );
	 break;

      case MSG_DB_NO_209SPC_DBASE:
         msgString = CMsg( MSG_DB_NO_209SPC, MSG_DB_NO_209SPC_STR );
	 break;

      case MSG_DB_BREAK_PNT_DBASE:
         msgString = CMsg( MSG_DB_BREAK_PNT, MSG_DB_BREAK_PNT_STR );
	 break;
      }

   return( msgString );
}

/* -------------------- END of CatFuncs1.c file! ------------------------ */
