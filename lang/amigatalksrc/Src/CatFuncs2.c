/****h* AmigaTalk/CatFuncs2.c [3.0] ********************************
*
* NAME
*    CatFuncs2.c
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
*    $VER: AmigaTalk:Src/CatFuncs2.c 3.0 (04-Jan-2005) by J.T. Steichen
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

/****h* CatalogDisk2() [3.0] **************************************** 
*
* NAME 
*   CatalogDisk2()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
*********************************************************************
*/

PUBLIC int CatalogDisk2( void ) // Disk2.c
{
   IMPORT UBYTE            D1Wdt[80];
   IMPORT struct NewGadget D1NGad[];
      
   StringNCopy( D1Wdt, CMsg( MSG_D2_WTITLE, MSG_D2_WTITLE_STR ), 80 );

   D1NGad[0].ng_GadgetText = CMsg( MSG_D2_BARYLV_GAD, MSG_D2_BARYLV_GAD_STR );
   D1NGad[1].ng_GadgetText = CMsg( MSG_D2_DONE_GAD,   MSG_D2_DONE_GAD_STR   );

   return( 0 );
}

PUBLIC STRPTR DiskCMsg( int whichString ) // For Disk.c & Disk2.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_DI_ERR_NOERR_DISK:
         msgString = CMsg( MSG_DI_ERR_NOERR, MSG_DI_ERR_NOERR_STR );
         break;
      
      case MSG_DI_ERR_UNDET_DISK:
         msgString = CMsg( MSG_DI_ERR_UNDET, MSG_DI_ERR_UNDET_STR );
         break;

      case MSG_DI_ERR_SECHDR_DISK:
         msgString = CMsg( MSG_DI_ERR_SECHDR, MSG_DI_ERR_SECHDR_STR );
         break;

      case MSG_DI_ERR_SECPRE_DISK:
         msgString = CMsg( MSG_DI_ERR_SECPRE, MSG_DI_ERR_SECPRE_STR );
         break;

      case MSG_DI_ERR_SECIDT_DISK:
         msgString = CMsg( MSG_DI_ERR_SECIDT, MSG_DI_ERR_SECIDT_STR );
         break;

      case MSG_DI_ERR_HDRSUM_DISK:
         msgString = CMsg( MSG_DI_ERR_HDRSUM, MSG_DI_ERR_HDRSUM_STR );
         break;

      case MSG_DI_ERR_SECSUM_DISK:
         msgString = CMsg( MSG_DI_ERR_SECSUM, MSG_DI_ERR_SECSUM_STR );
         break;

      case MSG_DI_ERR_SECNUM_DISK:
         msgString = CMsg( MSG_DI_ERR_SECNUM, MSG_DI_ERR_SECNUM_STR );
         break;

      case MSG_DI_ERR_NOREAD_DISK:
         msgString = CMsg( MSG_DI_ERR_NOREAD, MSG_DI_ERR_NOREAD_STR );
         break;

      case MSG_DI_ERR_WRTPROT_DISK:
         msgString = CMsg( MSG_DI_ERR_WRTPROT, MSG_DI_ERR_WRTPROT_STR );
         break;

      case MSG_DI_ERR_DSKCHG_DISK:
         msgString = CMsg( MSG_DI_ERR_DSKCHG, MSG_DI_ERR_DSKCHG_STR );
         break;

      case MSG_DI_ERR_SEEKERR_DISK:
         msgString = CMsg( MSG_DI_ERR_SEEKERR, MSG_DI_ERR_SEEKERR_STR );
         break;

      case MSG_DI_ERR_NOMEM_DISK:
         msgString = CMsg( MSG_DI_ERR_NOMEM, MSG_DI_ERR_NOMEM_STR );
         break;

      case MSG_DI_ERR_BADUNIT_DISK:
         msgString = CMsg( MSG_DI_ERR_BADUNIT, MSG_DI_ERR_BADUNIT_STR );
         break;

      case MSG_DI_ERR_BADTYPE_DISK:
         msgString = CMsg( MSG_DI_ERR_BADTYPE, MSG_DI_ERR_BADTYPE_STR );
         break;

      case MSG_DI_ERR_USEDDR_DISK:
         msgString = CMsg( MSG_DI_ERR_USEDDR, MSG_DI_ERR_USEDDR_STR );
         break;

      case MSG_DI_ERR_RESET_DISK:
         msgString = CMsg( MSG_DI_ERR_RESET, MSG_DI_ERR_RESET_STR );
         break;

      case MSG_DI_ERR_EJECT_DISK:
         msgString = CMsg( MSG_DI_ERR_EJECT, MSG_DI_ERR_EJECT_STR );
         break;

      case MSG_DI_ERR_UNKNOWN_DISK:
         msgString = CMsg( MSG_DI_ERR_UNKNOWN, MSG_DI_ERR_UNKNOWN_STR );
         break;

      case MSG_DI_REMOVABLE_DISK:
         msgString = CMsg( MSG_DI_REMOVABLE, MSG_DI_REMOVABLE_STR );
         break;

      case MSG_DI_NOREMOVABLE_DISK:
         msgString = CMsg( MSG_DI_NOREMOVABLE, MSG_DI_NOREMOVABLE_STR );
         break;

      case MSG_DI_TYPE_DACC_DISK:
         msgString = CMsg( MSG_DI_TYPE_DACC, MSG_DI_TYPE_DACC_STR );
         break;

      case MSG_DI_TYPE_SACC_DISK:
         msgString = CMsg( MSG_DI_TYPE_SACC, MSG_DI_TYPE_SACC_STR );
         break;

      case MSG_DI_TYPE_PRTR_DISK:
         msgString = CMsg( MSG_DI_TYPE_PRTR, MSG_DI_TYPE_PRTR_STR );
         break;

      case MSG_DI_TYPE_PROC_DISK:
         msgString = CMsg( MSG_DI_TYPE_PROC, MSG_DI_TYPE_PROC_STR );
         break;

      case MSG_DI_TYPE_WORM_DISK:
         msgString = CMsg( MSG_DI_TYPE_WORM, MSG_DI_TYPE_WORM_STR );
         break;

      case MSG_DI_TYPE_CDROM_DISK:
         msgString = CMsg( MSG_DI_TYPE_CDROM, MSG_DI_TYPE_CDROM_STR );
         break;

      case MSG_DI_TYPE_SCANR_DISK:
         msgString = CMsg( MSG_DI_TYPE_SCANR, MSG_DI_TYPE_SCANR_STR );
         break;

      case MSG_DI_TYPE_OPTDSK_DISK:
         msgString = CMsg( MSG_DI_TYPE_OPTDSK, MSG_DI_TYPE_OPTDSK_STR );
         break;

      case MSG_DI_TYPE_MEDCHG_DISK:
         msgString = CMsg( MSG_DI_TYPE_MEDCHG, MSG_DI_TYPE_MEDCHG_STR );
         break;

      case MSG_DI_TYPE_COMM_DISK:
         msgString = CMsg( MSG_DI_TYPE_COMM, MSG_DI_TYPE_COMM_STR );
         break;

      case MSG_DI_TYPE_UNKNOWN_DISK:
         msgString = CMsg( MSG_DI_TYPE_UNKNOWN, MSG_DI_TYPE_UNKNOWN_STR );
         break;

      case MSG_FMT_DI_READERR_DISK:
         msgString = CMsg( MSG_FORMAT_DI_READERR, MSG_FORMAT_DI_READERR_STR );
         break;

      case MSG_FMT_DI_WRITERR_DISK:
         msgString = CMsg( MSG_FORMAT_DI_WRITERR, MSG_FORMAT_DI_WRITERR_STR );
         break;

      case MSG_FMT_DI_SEEKERR_DISK:
         msgString = CMsg( MSG_FORMAT_DI_SEEKERR, MSG_FORMAT_DI_SEEKERR_STR );
         break;

      case MSG_FMT_DI_UNKGEOM_DISK:
         msgString = CMsg( MSG_FORMAT_DI_UNKGEOM, MSG_FORMAT_DI_UNKGEOM_STR );
	 break;

      // Disk2.c Strings: ----------------------------------------------------

      case MSG_D2_DSPBTS_FUNC_DISK2:
         msgString = CMsg( MSG_D2_DSPBTS_FUNC, MSG_D2_DSPBTS_FUNC_STR );
	 break;

      case MSG_FMT_ALLCLV_DISK2:
         msgString = CMsg( MSG_FORMAT_ALLCLV, MSG_FORMAT_ALLCLV_STR );
	 break;
	 
      case MSG_D2_BAILOUT_BUTTONS_DISK2:
         msgString = CMsg( MSG_D2_BAILOUT_BUTTONS, MSG_D2_BAILOUT_BUTTONS_STR );
	 break;
      }
      
   return( msgString );
}

PUBLIC STRPTR DriveCMsg( int whichString ) // Drive.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_DV_TESTD_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_TESTD_FUNC, MSG_DV_TESTD_FUNC_STR );
         break;

      case MSG_DV_LEXER_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_LEXER_FUNC, MSG_DV_LEXER_FUNC_STR );
         break;

      case MSG_FMT_DV_ERROR_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_ERROR, MSG_FORMAT_DV_ERROR_STR );
         break;

      case MSG_DV_LEXIR_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_LEXIR_FUNC, MSG_DV_LEXIR_FUNC_STR );
         break;

      case MSG_DV_GENCD_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_GENCD_FUNC, MSG_DV_GENCD_FUNC_STR );
         break;

      case MSG_DV_BYTECODE_DRIVE:
         msgString = CMsg( MSG_DV_BYTECODE, MSG_DV_BYTECODE_STR );
         break;

      case MSG_DV_BIG_CODE_DRIVE:
         msgString = CMsg( MSG_DV_BIG_CODE, MSG_DV_BIG_CODE_STR );
         break;

      case MSG_DV_CODE_IDX_DRIVE:
         msgString = CMsg( MSG_DV_CODE_IDX, MSG_DV_CODE_IDX_STR );
         break;

      case MSG_DV_CODE_OVFLW_DRIVE:
         msgString = CMsg( MSG_DV_CODE_OVFLW, MSG_DV_CODE_OVFLW_STR );
         break;

      case MSG_DV_GENHL_ERR1_DRIVE:
         msgString = CMsg( MSG_DV_GENHL_ERR1, MSG_DV_GENHL_ERR1_STR );
         break;

      case MSG_DV_GENHL_ERR2_DRIVE:
         msgString = CMsg( MSG_DV_GENHL_ERR2, MSG_DV_GENHL_ERR2_STR );
         break;

      case MSG_DV_RESET_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_RESET_FUNC, MSG_DV_RESET_FUNC_STR );
         break;

      case MSG_FMT_DV_UNKVAR_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_UNKVAR, MSG_FORMAT_DV_UNKVAR_STR );
         break;

      case MSG_FMT_DV_VAR1_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_VAR1, MSG_FORMAT_DV_VAR1_STR );
         break;

      case MSG_DV_JUMP_TRAIN_DRIVE:
         msgString = CMsg( MSG_DV_JUMP_TRAIN, MSG_DV_JUMP_TRAIN_STR );
         break;

      case MSG_DV_DRVINI_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_DRVINI_FUNC, MSG_DV_DRVINI_FUNC_STR );
         break;

      case MSG_DV_DRVFRE_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_DRVFRE_FUNC, MSG_DV_DRVFRE_FUNC_STR );
         break;

      case MSG_DV_ISBIN_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_ISBIN_FUNC, MSG_DV_ISBIN_FUNC_STR );
         break;

      case MSG_DV_EXPCT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_FUNC, MSG_DV_EXPCT_FUNC_STR );
         break;

      case MSG_FMT_DV_EXPECT_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_EXPECT, MSG_FORMAT_DV_EXPECT_STR );
         break;

      case MSG_DV_ADDLIT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_ADDLIT_FUNC, MSG_DV_ADDLIT_FUNC_STR );
         break;

      case MSG_FMT_DV_LITTOP_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_LITTOP, MSG_FORMAT_DV_LITTOP_STR ); 
         break;

      case MSG_FMT_DV_ALITL_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_ALITL, MSG_FORMAT_DV_ALITL_STR );
         break;

      case MSG_DV_UNK_PSEUDO_DRIVE:
         msgString = CMsg( MSG_DV_UNK_PSEUDO, MSG_DV_UNK_PSEUDO_STR );
         break;

      case MSG_DV_ALITRL_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_ALITRL_FUNC, MSG_DV_ALITRL_FUNC_STR );
         break;

      case MSG_DV_EXPCT_RBKT_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_RBKT, MSG_DV_EXPCT_RBKT_STR );
         break;

      case MSG_DV_EXPCT_ARRAY_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_ARRAY, MSG_DV_EXPCT_ARRAY_STR );
         break;

      case MSG_DV_EXPCT_RPAREN_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_RPAREN, MSG_DV_EXPCT_RPAREN_STR );
         break;

      case MSG_DV_EXPCT_LITRL_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_LITRL, MSG_DV_EXPCT_LITRL_STR );
         break;

      case MSG_DV_GENSND_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_GENSND_FUNC, MSG_DV_GENSND_FUNC_STR );
         break;

      case MSG_DV_UCONT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_UCONT_FUNC, MSG_DV_UCONT_FUNC_STR );
         break;

      case MSG_DV_BCONT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BCONT_FUNC, MSG_DV_BCONT_FUNC_STR );
         break;

      case MSG_DV_KCONT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_KCONT_FUNC, MSG_DV_KCONT_FUNC_STR );
         break;

      case MSG_DV_CEXPR_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_CEXPR_FUNC, MSG_DV_CEXPR_FUNC_STR );
         break;

      case MSG_DV_GENVAR_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_GENVAR_FUNC, MSG_DV_GENVAR_FUNC_STR );
         break;

      case MSG_DV_APRIM_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_APRIM_FUNC, MSG_DV_APRIM_FUNC_STR );
         break;

      case MSG_DV_ASSIGN_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_ASSIGN_FUNC, MSG_DV_ASSIGN_FUNC_STR );
         break;

      case MSG_DV_EXPR_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_EXPR_FUNC, MSG_DV_EXPR_FUNC_STR );
         break;

      case MSG_DV_BLOCK1_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BLOCK1_FUNC, MSG_DV_BLOCK1_FUNC_STR );
         break;

      case MSG_DV_BLOCK2_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BLOCK2_FUNC, MSG_DV_BLOCK2_FUNC_STR );
         break;

      case MSG_DV_EXPCT_BAR_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_BAR, MSG_DV_EXPCT_BAR_STR );
         break;

      case MSG_DV_EXPCT_BLKEND_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_BLKEND, MSG_DV_EXPCT_BLKEND_STR );
         break;

      case MSG_DV_BLOCK3_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BLOCK3_FUNC, MSG_DV_BLOCK3_FUNC_STR );
         break;

      case MSG_FMT_DV_BLKBIG_DRIVE:
         msgString = CMsg( MSG_FORMAT_DV_BLKBIG, MSG_FORMAT_DV_BLKBIG_STR );
         break;

      case MSG_DV_BLOCK4_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BLOCK4_FUNC, MSG_DV_BLOCK4_FUNC_STR );
         break;

      case MSG_DV_PRIMY_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_PRIMY_FUNC, MSG_DV_PRIMY_FUNC_STR );
         break;

      case MSG_DV_UNK_PSEUDOV_DRIVE:
         msgString = CMsg( MSG_DV_UNK_PSEUDOV, MSG_DV_UNK_PSEUDOV_STR );
         break;

      case MSG_DV_EXPCT_PRMNUM_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_PRMNUM, MSG_DV_EXPCT_PRMNUM_STR );
         break;

      case MSG_DV_EXPCT_PRMEND_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_PRMEND, MSG_DV_EXPCT_PRMEND_STR );
         break;

      case MSG_DV_EXPCT_PREXPR_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_PREXPR, MSG_DV_EXPCT_PREXPR_STR );
         break;

      case MSG_DV_BLDINT_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_BLDINT_FUNC, MSG_DV_BLDINT_FUNC_STR );
         break;

      case MSG_DV_PARSE_FUNC_DRIVE:
         msgString = CMsg( MSG_DV_PARSE_FUNC, MSG_DV_PARSE_FUNC_STR );
         break;
	 
      case MSG_DV_EXPCT_EXPEND_DRIVE:
         msgString = CMsg( MSG_DV_EXPCT_EXPEND, MSG_DV_EXPCT_EXPEND_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR DTypeCMsg( int whichString ) // DTInterface.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_DT_ERROR_STR_DTYPE:
         msgString = CMsg( MSG_DT_ERROR_STR, MSG_DT_ERROR_STR_STR );
         break;

      case MSG_BO_NO_ERR_DTYPE:
         msgString = CMsg( MSG_BO_NO_ERR, MSG_BO_NO_ERR_STR );
         break;

      case MSG_DT_DOS_ERROR_DTYPE:
         msgString = CMsg( MSG_DT_DOS_ERROR, MSG_DT_DOS_ERROR_STR );
         break;

      case MSG_DT_ENV_ERROR_DTYPE:
         msgString = CMsg( MSG_DT_ENV_ERROR, MSG_DT_ENV_ERROR_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR FileCMsg( int whichString ) // File.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_F_FILE:
         msgString = CMsg( MSG_FORMAT_F_FILE, MSG_FORMAT_F_FILE_STR );
         break;

      case MSG_FMT_F_UNOPENED_FILE:
         msgString = CMsg( MSG_FORMAT_F_UNOPENED, MSG_FORMAT_F_UNOPENED_STR );
         break;

      case MSG_F_BAD_READ_FILE:
         msgString = CMsg( MSG_F_BAD_READ, MSG_F_BAD_READ_STR );
         break;

      case MSG_F_UNK_MODE_FILE:
         msgString = CMsg( MSG_F_UNK_MODE, MSG_F_UNK_MODE_STR );
         break;

      case MSG_F_BAD_WRITE_FILE:
         msgString = CMsg( MSG_F_BAD_WRITE, MSG_F_BAD_WRITE_STR );
         break;

      case MSG_F_UNK_WMODE_FILE:
         msgString = CMsg( MSG_F_UNK_WMODE, MSG_F_UNK_WMODE_STR );
         break;

      case MSG_F_BAD_ATTEMPT_FILE:
         msgString = CMsg( MSG_F_BAD_ATTEMPT, MSG_F_BAD_ATTEMPT_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR GadgCMsg( int whichString ) // For Gadget.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_GA_STRGAD_BUF_GADGET:
         msgString = CMsg( MSG_GA_STRGAD_BUF, MSG_GA_STRGAD_BUF_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR GToolCMsg( int whichString ) // For GadTools.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_GT_NEWGS_FUNC_GTOOL:
         msgString = CMsg( MSG_GT_NEWGS_FUNC, MSG_GT_NEWGS_FUNC_STR );
         break;

      case MSG_GT_SSA_FUNC_GTOOL:
         msgString = CMsg( MSG_GT_SSA_FUNC, MSG_GT_SSA_FUNC_STR );
         break;

      case MSG_GT_MENU_ITEMS_GTOOL:
         msgString = CMsg( MSG_GT_MENU_ITEMS, MSG_GT_MENU_ITEMS_STR );
         break;

      case MSG_GT_NEWMN_FUNC_GTOOL:
         msgString = CMsg( MSG_GT_NEWMN_FUNC, MSG_GT_NEWMN_FUNC_STR );
         break;

      case MSG_GT_FILLM_FUNC_GTOOL:
         msgString = CMsg( MSG_GT_FILLM_FUNC, MSG_GT_FILLM_FUNC_STR ); 
         break;

      case MSG_GT_WRONG_ARGS_GTOOL:
         msgString = CMsg( MSG_GT_WRONG_ARGS, MSG_GT_WRONG_ARGS_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR GameCMsg( int whichString ) // GamePort.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_GP_GAMEPORT_STR_GAME:
         msgString = CMsg( MSG_GP_GAMEPORT_STR, MSG_GP_GAMEPORT_STR_STR );
         break;

      case MSG_GP_OPEN_FUNC_GAME:
         msgString = CMsg( MSG_GP_OPEN_FUNC, MSG_GP_OPEN_FUNC_STR );
         break;

      case MSG_GP_GAMEPORT_MSG_GAME:
         msgString = CMsg( MSG_GP_GAMEPORT_MSG, MSG_GP_GAMEPORT_MSG_STR );
         break;

      case MSG_FMT_GP_UNIT_GAME:
         msgString = CMsg( MSG_FORMAT_GP_UNIT, MSG_FORMAT_GP_UNIT_STR );
         break;

      case MSG_GP_ASKT_FUNC_GAME:
         msgString = CMsg( MSG_GP_ASKT_FUNC, MSG_GP_ASKT_FUNC_STR );
         break;

      case MSG_GP_GAMEPORT_CT_GAME:
         msgString = CMsg( MSG_GP_GAMEPORT_CT, MSG_GP_GAMEPORT_CT_STR );
         break;

#     ifdef DEBUG
      case MSG_FMT_GP_SETCT_GAME:
         msgString = CMsg( MSG_FORMAT_GP_SETCT, MSG_FORMAT_GP_SETCT_STR );
         break;

      case MSG_FMT_GP_GETCT_GAME:
         msgString = CMsg( MSG_FORMAT_GP_GETCT, MSG_FORMAT_GP_GETCT_STR );
         break;

      case MSG_FMT_GP_BUTCD_GAME:
         msgString = CMsg( MSG_FORMAT_GP_BUTCD, MSG_FORMAT_GP_BUTCD_STR );
         break;

      case MSG_FMT_GP_QUALS_GAME:
         msgString = CMsg( MSG_FORMAT_GP_QUALS, MSG_FORMAT_GP_QUALS_STR );
         break;

      case MSG_FMT_GP_XPOS_GAME:
         msgString = CMsg( MSG_FORMAT_GP_XPOS, MSG_FORMAT_GP_XPOS_STR );
         break;

      case MSG_FMT_GP_YPOS_GAME:
         msgString = CMsg( MSG_FORMAT_GP_YPOS, MSG_FORMAT_GP_YPOS_STR );
         break;

      case MSG_FMT_GP_IEADR_GAME:
         msgString = CMsg( MSG_FORMAT_GP_IEADR, MSG_FORMAT_GP_IEADR_STR );
         break;

      case MSG_FMT_GP_TIME_GAME:
         msgString = CMsg( MSG_FORMAT_GP_TIME, MSG_FORMAT_GP_TIME_STR );
         break;
#     endif
      }
      
   return( msgString );
}

/****h* CatalogIcon() [3.0] ***************************************** 
*
* NAME 
*   CatalogIcon()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
*********************************************************************
*/

PUBLIC int CatalogIcon( void ) // Icon.c
{
   IMPORT UBYTE            IpWdt[ 80 ];
   IMPORT struct IntuiText IpIText[ 2 ];
   IMPORT struct NewGadget IpNGad;
   
   StringNCopy( IpWdt, CMsg( MSG_IC_IP_WTITLE, MSG_IC_IP_WTITLE_STR ), 80 );

   IpIText[0].IText = CMsg( MSG_IC_IMAGE_STR,  MSG_IC_IMAGE_STR_STR  );
   IpIText[1].IText = CMsg( MSG_IC_SELECT_STR, MSG_IC_SELECT_STR_STR );

   IpNGad.ng_GadgetText = CMsg( MSG_ID_OKAY_GAD, MSG_ID_OKAY_GAD_STR );
   
   return( 0 );
}


PUBLIC STRPTR IconCMsg( int whichString ) // For Icon.c & IconDsp.c 
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_IC_UNKNOWNICON_ICON:
         msgString = CMsg( MSG_IC_UNKNOWNICON, MSG_IC_UNKNOWNICON_STR );
         break;

      case MSG_FMT_IC_NOTFOUND_ICON:
         msgString = CMsg( MSG_FORMAT_IC_NOTFOUND, MSG_FORMAT_IC_NOTFOUND_STR );
         break;

      case MSG_IC_YES_ABORT_BUTTONS_ICON:
         msgString = CMsg( MSG_IC_YES_ABORT_BUTTONS, MSG_IC_YES_ABORT_BUTTONS_STR );
         break;

      case MSG_IC_IP_WTITLE_ICON:
         msgString = CMsg( MSG_IC_IP_WTITLE, MSG_IC_IP_WTITLE_STR );
         break;

      case MSG_IC_NO_DEFAULT_ICON:
         msgString = CMsg( MSG_IC_NO_DEFAULT, MSG_IC_NO_DEFAULT_STR );
         break;

      case MSG_TT_TTEDITOR_ICON:
         msgString = CMsg( MSG_TT_TTEDITOR, MSG_TT_TTEDITOR_STR );
	 break;

      case MSG_TT_ICONEDITOR_ICON:
         msgString = CMsg( MSG_TT_ICONEDITOR, MSG_TT_ICONEDITOR_STR );
         break;
	       
      // IconDsp.c Strings: -------------------------------------------------
      case MSG_ID_PROJ_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_PROJ_WTITLE, MSG_ID_PROJ_WTITLE_STR );
         break;

      case MSG_ID_DEVC_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_DEVC_WTITLE, MSG_ID_DEVC_WTITLE_STR );
         break;

      case MSG_ID_KICK_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_KICK_WTITLE, MSG_ID_KICK_WTITLE_STR );
         break;

      case MSG_ID_APPI_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_APPI_WTITLE, MSG_ID_APPI_WTITLE_STR );
         break;

      case MSG_ID_DISK_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_DISK_WTITLE, MSG_ID_DISK_WTITLE_STR );
         break;

      case MSG_ID_DRAW_WTITLE_ICONDSP:
         msgString = CMsg( MSG_ID_DRAW_WTITLE, MSG_ID_DRAW_WTITLE_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogIconDsp() [3.0] ************************************** 
*
* NAME 
*   CatalogIconDsp()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
*********************************************************************
*/

PUBLIC int CatalogIconDsp( void ) // IconDsp.c
{
   IMPORT UBYTE           *TIWdt;
   IMPORT struct IntuiText TIIText[];
   IMPORT struct NewGadget TINGad[];

   IMPORT UBYTE           *PIWdt;
   IMPORT struct IntuiText PIIText[];
   IMPORT struct NewGadget PINGad[];

   IMPORT UBYTE           *DIWdt;
   IMPORT struct IntuiText DIIText[];
   IMPORT struct NewGadget DINGad[];

   IMPORT UBYTE           *CIWdt;
   IMPORT struct IntuiText CIIText[];
   IMPORT struct NewGadget CINGad[];

   IMPORT UBYTE *prjIText;
   IMPORT UBYTE *devIText;
   IMPORT UBYTE *kckIText;
   IMPORT UBYTE *appIText;
   IMPORT UBYTE *dskIText;
   IMPORT UBYTE *drwIText;
   
   TIWdt = CMsg( MSG_ID_TOOL_WTITLE, MSG_ID_TOOL_WTITLE_STR );

   TIIText[0].IText = CMsg( MSG_ID_ICONTOOLTYPE, MSG_ID_ICONTOOLTYPE_STR );
   TIIText[1].IText = CMsg( MSG_ID_ICONIMAGES,   MSG_ID_ICONIMAGES_STR   );

   TINGad[0].ng_GadgetText = CMsg( MSG_ID_STACK_GAD,  MSG_ID_STACK_GAD_STR );
   TINGad[1].ng_GadgetText = CMsg( MSG_ID_TOOLS_GAD,  MSG_ID_TOOLS_GAD_STR );
   TINGad[2].ng_GadgetText = CMsg( MSG_ID_OKAY_GAD,   MSG_ID_OKAY_GAD_STR );
   TINGad[3].ng_GadgetText = CMsg( MSG_ID_COORDS_GAD, MSG_ID_COORDS_GAD_STR );
   TINGad[4].ng_GadgetText = CMsg( MSG_ID_LOC_GAD,    MSG_ID_LOC_GAD_STR );

   PIWdt = CMsg( MSG_ID_PROJ_WTITLE, MSG_ID_PROJ_WTITLE_STR );

   PIIText[0].IText = CMsg( MSG_ID_ICONPROJTYPE, MSG_ID_ICONPROJTYPE_STR );
   PIIText[1].IText = CMsg( MSG_ID_ICONIMAGES,   MSG_ID_ICONIMAGES_STR );

   PINGad[0].ng_GadgetText = CMsg( MSG_ID_STACK_GAD,   MSG_ID_STACK_GAD_STR );
   PINGad[1].ng_GadgetText = CMsg( MSG_ID_TOOLS_GAD,   MSG_ID_TOOLS_GAD_STR );
   PINGad[2].ng_GadgetText = CMsg( MSG_ID_OKAY_GAD,    MSG_ID_OKAY_GAD_STR );
   PINGad[3].ng_GadgetText = CMsg( MSG_ID_COORDS_GAD,  MSG_ID_COORDS_GAD_STR );
   PINGad[4].ng_GadgetText = CMsg( MSG_ID_LOC_GAD,     MSG_ID_LOC_GAD_STR );
   PINGad[5].ng_GadgetText = CMsg( MSG_ID_DEFTOOL_GAD, MSG_ID_DEFTOOL_GAD_STR );

   prjIText = CMsg( MSG_ID_ICONPROJTYPE, MSG_ID_ICONPROJTYPE_STR );
   devIText = CMsg( MSG_ID_ICONDEVCTYPE, MSG_ID_ICONDEVCTYPE_STR );
   kckIText = CMsg( MSG_ID_ICONKICKTYPE, MSG_ID_ICONKICKTYPE_STR );
   appIText = CMsg( MSG_ID_ICONAPPITYPE, MSG_ID_ICONAPPITYPE_STR );

   DIWdt = CMsg( MSG_ID_DISK_WTITLE, MSG_ID_DISK_WTITLE_STR );

   DIIText[0].IText = CMsg( MSG_ID_ICONDISKTYPE, MSG_ID_ICONDISKTYPE_STR );
   DIIText[1].IText = CMsg( MSG_ID_ICONIMAGES,   MSG_ID_ICONIMAGES_STR );

   DINGad[0].ng_GadgetText = CMsg( MSG_ID_OKAY_GAD,    MSG_ID_OKAY_GAD_STR );
   DINGad[1].ng_GadgetText = CMsg( MSG_ID_COORDS_GAD,  MSG_ID_COORDS_GAD_STR );
   DINGad[2].ng_GadgetText = CMsg( MSG_ID_LOC_GAD,     MSG_ID_LOC_GAD_STR );
   DINGad[3].ng_GadgetText = CMsg( MSG_ID_WCOORDS_GAD, MSG_ID_WCOORDS_GAD_STR );
   DINGad[4].ng_GadgetText = CMsg( MSG_ID_DEFTOOL_GAD, MSG_ID_DEFTOOL_GAD_STR );
   
   dskIText = CMsg( MSG_ID_ICONDISKTYPE, MSG_ID_ICONDISKTYPE_STR );
   drwIText = CMsg( MSG_ID_ICONDRAWTYPE, MSG_ID_ICONDRAWTYPE_STR );

   CIWdt    = CMsg( MSG_ID_TRSH_WTITLE, MSG_ID_TRSH_WTITLE_STR );

   CIIText[0].IText = CMsg( MSG_ID_ICONTRSHTYPE, MSG_ID_ICONTRSHTYPE_STR );
   CIIText[1].IText = CMsg( MSG_ID_ICONIMAGES,   MSG_ID_ICONIMAGES_STR );

   CINGad[0].ng_GadgetText = CMsg( MSG_ID_OKAY_GAD,    MSG_ID_OKAY_GAD_STR );
   CINGad[1].ng_GadgetText = CMsg( MSG_ID_COORDS_GAD,  MSG_ID_COORDS_GAD_STR );
   CINGad[2].ng_GadgetText = CMsg( MSG_ID_LOC_GAD,     MSG_ID_LOC_GAD_STR );
   CINGad[3].ng_GadgetText = CMsg( MSG_ID_WCOORDS_GAD, MSG_ID_WCOORDS_GAD_STR );

   return( 0 );
}

PUBLIC STRPTR IFFCMsg( int whichString ) // IFF.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_OPEN_IFF_FUNC_IFF:
         msgString = CMsg( MSG_IFF_OPEN_IFF_FUNC, MSG_IFF_OPEN_IFF_FUNC_STR );
         break;

      case MSG_IFFHANDLE_FUNC_IFF:
         msgString = CMsg( MSG_IFF_IFFHANDLE_FUNC, MSG_IFF_IFFHANDLE_FUNC_STR );
         break;

      case MSG_FMT_IFFERR_IFF:
         msgString = CMsg( MSG_FORMAT_IFFERR, MSG_FORMAT_IFFERR_STR );
         break;

      case MSG_INITIFF_FUNC_IFF:
         msgString = CMsg( MSG_IFF_INITIFF_FUNC, MSG_IFF_INITIFF_FUNC_STR );
         break;

      case MSG_INITDOS_FUNC_IFF:
         msgString = CMsg( MSG_IFF_INITDOS_FUNC, MSG_IFF_INITDOS_FUNC_STR );
         break;

      case MSG_INITCLIP_FUNC_IFF:
         msgString = CMsg( MSG_IFF_INITCLIP_FUNC, MSG_IFF_INITCLIP_FUNC_STR );
         break;

      case MSG_CLOSECLIP_FUNC_IFF:
         msgString = CMsg( MSG_IFF_CLOSECLIP_FUNC, MSG_IFF_CLOSECLIP_FUNC_STR );
         break;

      case MSG_OPENCLIP_FUNC_IFF:
         msgString = CMsg( MSG_IFF_OPENCLIP_FUNC, MSG_IFF_OPENCLIP_FUNC_STR );
         break;

      case MSG_PARSE_FUNC_IFF:
         msgString = CMsg( MSG_IFF_PARSE_FUNC, MSG_IFF_PARSE_FUNC_STR );
         break;

      case MSG_READCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_READCHK_FUNC, MSG_IFF_READCHK_FUNC_STR );
         break;

      case MSG_FMT_BARY_SMALL_IFF:
         msgString = CMsg( MSG_FORMAT_BARY_SMALL, MSG_FORMAT_BARY_SMALL_STR ); 
         break;

      case MSG_READCHKR_FUNC_IFF:
         msgString = CMsg( MSG_IFF_READCHKR_FUNC, MSG_IFF_READCHKR_FUNC_STR );
         break;

      case MSG_WRTCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_WRTCHK_FUNC, MSG_IFF_WRTCHK_FUNC_STR );
         break;

      case MSG_TRUNCATED_IFF:
         msgString = CMsg( MSG_IFF_TRUNCATED, MSG_IFF_TRUNCATED_STR );
         break;

      case MSG_WRTCHKR_FUNC_IFF:
         msgString = CMsg( MSG_IFF_WRTCHKR_FUNC, MSG_IFF_WRTCHKR_FUNC_STR );
         break;

      case MSG_FMT_INVALIDTYPE_IFF:
         msgString = CMsg( MSG_FORMAT_INVALIDTYPE, MSG_FORMAT_INVALIDTYPE_STR );
         break;

      case MSG_FMT_INVALID_ID_IFF:
         msgString = CMsg( MSG_FORMAT_INVALID_ID, MSG_FORMAT_INVALID_ID_STR );
         break;

      case MSG_STOPCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_STOPCHK_FUNC, MSG_IFF_STOPCHK_FUNC_STR );
         break;

      case MSG_CRNTCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_CRNTCHK_FUNC, MSG_IFF_CRNTCHK_FUNC_STR );
         break;

      case MSG_PROPCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_PROPCHK_FUNC, MSG_IFF_PROPCHK_FUNC_STR );
         break;

      case MSG_FINDPROP_FUNC_IFF:
         msgString = CMsg( MSG_IFF_FINDPROP_FUNC, MSG_IFF_FINDPROP_FUNC_STR );
         break;

      case MSG_COLLCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_COLLCHK_FUNC, MSG_IFF_COLLCHK_FUNC_STR );
         break;

      case MSG_FINDCOLL_FUNC_IFF:
         msgString = CMsg( MSG_IFF_FINDCOLL_FUNC, MSG_IFF_FINDCOLL_FUNC_STR );
         break;

      case MSG_STOPEXIT_FUNC_IFF:
         msgString = CMsg( MSG_IFF_STOPEXIT_FUNC, MSG_IFF_STOPEXIT_FUNC_STR );
         break;

      case MSG_ENTRHAND_FUNC_IFF:
         msgString = CMsg( MSG_IFF_ENTRHAND_FUNC, MSG_IFF_ENTRHAND_FUNC_STR );
         break;

      case MSG_EXITHAND_FUNC_IFF:
         msgString = CMsg( MSG_IFF_EXITHAND_FUNC, MSG_IFF_EXITHAND_FUNC_STR );
         break;

      case MSG_STOPCHKS_FUNC_IFF:
         msgString = CMsg( MSG_IFF_STOPCHKS_FUNC, MSG_IFF_STOPCHKS_FUNC_STR );
         break;

      case MSG_PROPCHKS_FUNC_IFF:
         msgString = CMsg( MSG_IFF_PROPCHKS_FUNC, MSG_IFF_PROPCHKS_FUNC_STR );
         break;

      case MSG_COLLCHKS_FUNC_IFF:
         msgString = CMsg( MSG_IFF_COLLCHKS_FUNC, MSG_IFF_COLLCHKS_FUNC_STR );
         break;

      case MSG_BAD_CLIPNUM_IFF:
         msgString = CMsg( MSG_IFF_BAD_CLIPNUM, MSG_IFF_BAD_CLIPNUM_STR );
         break;

      case MSG_PUSHCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_PUSHCHK_FUNC, MSG_IFF_PUSHCHK_FUNC_STR );
         break;

      case MSG_POPCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_POPCHK_FUNC, MSG_IFF_POPCHK_FUNC_STR );
         break;

      case MSG_PARCHK_FUNC_IFF:
         msgString = CMsg( MSG_IFF_PARCHK_FUNC, MSG_IFF_PARCHK_FUNC_STR );
         break;

      case MSG_ALLC_FUNC_IFF:
         msgString = CMsg( MSG_IFF_ALLC_FUNC, MSG_IFF_ALLC_FUNC_STR );
         break;

      case MSG_LCLDATA_FUNC_IFF:
         msgString = CMsg( MSG_IFF_LCLDATA_FUNC, MSG_IFF_LCLDATA_FUNC_STR );
         break;

      case MSG_STOLI_FUNC_IFF:
         msgString = CMsg( MSG_IFF_STOLI_FUNC, MSG_IFF_STOLI_FUNC_STR );
         break;

      case MSG_STOIC_FUNC_IFF:
         msgString = CMsg( MSG_IFF_STOIC_FUNC, MSG_IFF_STOIC_FUNC_STR );
         break;

      case MSG_FINDPROPC_FUNC_IFF:
         msgString = CMsg( MSG_IFF_FINDPROPC_FUNC, MSG_IFF_FINDPROPC_FUNC_STR );
         break;

      case MSG_FINDLCLI_FUNC_IFF:
         msgString = CMsg( MSG_IFF_FINDLCLI_FUNC, MSG_IFF_FINDLCLI_FUNC_STR );
         break;

      case MSG_FREELI_FUNC_IFF:
         msgString = CMsg( MSG_IFF_FREELI_FUNC, MSG_IFF_FREELI_FUNC_STR );
         break;

      case MSG_SETPURGE_FUNC_IFF:
         msgString = CMsg( MSG_IFF_SETPURGE_FUNC, MSG_IFF_SETPURGE_FUNC_STR );
         break;

      case MSG_BAD_ID_IFF:
         msgString = CMsg( MSG_IFF_BAD_ID, MSG_IFF_BAD_ID_STR );
         break;

      case MSG_GETPROPF_FUNC_IFF:
         msgString = CMsg( MSG_IFF_GETPROPF_FUNC, MSG_IFF_GETPROPF_FUNC_STR );
         break;

      case MSG_GETCOLLF_FUNC_IFF:
         msgString = CMsg( MSG_IFF_GETCOLLF_FUNC, MSG_IFF_GETCOLLF_FUNC_STR );
         break;

      case MSG_BAD_ERRNUM_IFF:
         msgString = CMsg( MSG_IFF_BAD_ERRNUM, MSG_IFF_BAD_ERRNUM_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogIFF() [3.0] *********************************
*
* NAME
*    CatalogIFF()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
************************************************************
*
*/

PUBLIC int CatalogIFF( void ) // IFF.c
{
   IMPORT char *iffErrStrs[15];
   
   iffErrStrs[0]  = CMsg( MSG_IFF_ERR_RET2CLIENT, MSG_IFF_ERR_RET2CLIENT_STR ); // IFF_RETURN2CLIENT -12L
   iffErrStrs[1]  = CMsg( MSG_IFF_ERR_NOHOOK,  MSG_IFF_ERR_NOHOOK_STR  );    // IFFERR_NOHOOK
   iffErrStrs[2]  = CMsg( MSG_IFF_ERR_NOTIFF,  MSG_IFF_ERR_NOTIFF_STR  );    // IFFERR_NOTIFF
   iffErrStrs[3]  = CMsg( MSG_IFF_ERR_SYNTAX,  MSG_IFF_ERR_SYNTAX_STR  );    // IFFERR_SYNTAX
   iffErrStrs[4]  = CMsg( MSG_IFF_ERR_MANGLED, MSG_IFF_ERR_MANGLED_STR );    // IFFERR_MANGLED
   iffErrStrs[5]  = CMsg( MSG_IFF_ERR_SEEK,    MSG_IFF_ERR_SEEK_STR    );    // IFFERR_SEEK
   iffErrStrs[6]  = CMsg( MSG_IFF_ERR_WRITE,   MSG_IFF_ERR_WRITE_STR   );    // IFFERR_WRITE
   iffErrStrs[7]  = CMsg( MSG_IFF_ERR_READ,    MSG_IFF_ERR_READ_STR    );    // IFFERR_READ
   iffErrStrs[8]  = CMsg( MSG_IFF_ERR_NOMEM,   MSG_IFF_ERR_NOMEM_STR   );    // IFFERR_NOMEM
   iffErrStrs[9]  = CMsg( MSG_IFF_ERR_NOSCOPE, MSG_IFF_ERR_NOSCOPE_STR );    // IFFERR_NOSCOPE
   iffErrStrs[10] = CMsg( MSG_IFF_ERR_EOC,     MSG_IFF_ERR_EOC_STR     );    // IFFERR_EOC
   iffErrStrs[11] = CMsg( MSG_IFF_ERR_EOF,     MSG_IFF_ERR_EOF_STR     );    // IFFERR_EOF
   iffErrStrs[12] = CMsg( MSG_IFF_ERR_NONE,    MSG_IFF_ERR_NONE_STR    );    // NO ERROR 0
   iffErrStrs[13] = CMsg( MSG_IFF_ERR_UNKNOWN, MSG_IFF_ERR_UNKNOWN_STR );    // Unknown ERROR # 1
   
   return( 0 );
}

PUBLIC STRPTR IntrpCMsg( int whichString ) // For Interp.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_FMT_INP_PUSH_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_PUSH, MSG_FORMAT_INP_PUSH_STR );
         break;

      case MSG_RQTITLE_FATAL_INTERROR_INTERP:
         msgString = CMsg( MSG_RQTITLE_FATAL_INTERROR, MSG_RQTITLE_FATAL_INTERROR_STR ); 
         break;

      case MSG_INP_PUSH2_INTERP:
         msgString = CMsg( MSG_INP_PUSH2, MSG_INP_PUSH2_STR );
         break;

      case MSG_INP_HUH_INTERP:
         msgString = CMsg( MSG_INP_HUH, MSG_INP_HUH_STR ); 
         break;

      case MSG_INP_NEXTBYTE_INTERP:
         msgString = CMsg( MSG_INP_NEXTBYTE, MSG_INP_NEXTBYTE_STR );
         break;

      case MSG_INP_POPSTACK_INTERP:
         msgString = CMsg( MSG_INP_POPSTACK, MSG_INP_POPSTACK_STR );
         break;

      case MSG_LX_NIL_STR_INTERP:
         msgString = CMsg( MSG_LX_NIL_STR, MSG_LX_NIL_STR_STR );
         break;

      case MSG_LX_TRUE_STR_INTERP:
         msgString = CMsg( MSG_LX_TRUE_STR, MSG_LX_TRUE_STR_STR );
         break;

      case MSG_LX_FALSE_STR_INTERP:
         msgString = CMsg( MSG_LX_FALSE_STR, MSG_LX_FALSE_STR_STR );
         break;

      case MSG_FMT_INP_OTHER_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_OTHER, MSG_FORMAT_INP_OTHER_STR );
         break;

      case MSG_FMT_INP_CLASS_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_CLASS, MSG_FORMAT_INP_CLASS_STR );
         break;

      case MSG_FMT_INP_BASZ_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_BASZ, MSG_FORMAT_INP_BASZ_STR );
         break;

      case MSG_FMT_INP_INTP_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_INTP, MSG_FORMAT_INP_INTP_STR );
         break;

      case MSG_FMT_INP_PROC_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_PROC, MSG_FORMAT_INP_PROC_STR );
         break;

      case MSG_FMT_INP_BLOK_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_BLOK, MSG_FORMAT_INP_BLOK_STR );
         break;

      case MSG_FMT_INP_FILE_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_FILE, MSG_FORMAT_INP_FILE_STR );
         break;

      case MSG_FMT_INP_FLOAT_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_FLOAT, MSG_FORMAT_INP_FLOAT_STR );
         break;

      case MSG_FMT_INP_SPECL_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_SPECL, MSG_FORMAT_INP_SPECL_STR ); 
         break;

      case MSG_FMT_INP_INTG_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_INTG, MSG_FORMAT_INP_INTG_STR );
         break;

      case MSG_FMT_INP_143_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_143, MSG_FORMAT_INP_143_STR );
         break;

      case MSG_FMT_INP_RECVR_INTERP:
         msgString = CMsg( MSG_FORMAT_INP_RECVR, MSG_FORMAT_INP_RECVR_STR );
         break;

      case MSG_FMT_BCODE_1X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_1X, MSG_FORMAT_BCODE_1X_STR );
         break;

      case MSG_FMT_BCODE_2X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_2X, MSG_FORMAT_BCODE_2X_STR ); 
         break;

      case MSG_FMT_BCODE_3X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_3X, MSG_FORMAT_BCODE_3X_STR );
         break;

      case MSG_FMT_BCODE_4X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_4X, MSG_FORMAT_BCODE_4X_STR );
         break;

      case MSG_FMT_BCODE_5X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5X, MSG_FORMAT_BCODE_5X_STR );
         break;

      case MSG_FMT_BCODE_5A_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5A, MSG_FORMAT_BCODE_5A_STR );
         break;

      case MSG_FMT_BCODE_5B_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5B, MSG_FORMAT_BCODE_5B_STR );
         break;

      case MSG_FMT_BCODE_5C_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5C, MSG_FORMAT_BCODE_5C_STR );
         break;

      case MSG_FMT_BCODE_5D_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5D, MSG_FORMAT_BCODE_5D_STR );
         break;

      case MSG_FMT_BCODE_5E_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5E, MSG_FORMAT_BCODE_5E_STR );
         break;

      case MSG_FMT_BCODE_5F_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5F, MSG_FORMAT_BCODE_5F_STR );
         break;

      case MSG_FMT_BCODE_5Z_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_5Z, MSG_FORMAT_BCODE_5Z_STR ); 
         break;

      case MSG_FMT_BCODE_6X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_6X, MSG_FORMAT_BCODE_6X_STR ); 
         break;

      case MSG_FMT_BCODE_7X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_7X, MSG_FORMAT_BCODE_7X_STR );
         break;

      case MSG_FMT_BCODE_8X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_8X, MSG_FORMAT_BCODE_8X_STR );
         break;

      case MSG_FMT_BCODE_9X_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_9X, MSG_FORMAT_BCODE_9X_STR ); 
         break;

      case MSG_FMT_BCODE_AX_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_AX, MSG_FORMAT_BCODE_AX_STR );
         break;

      case MSG_FMT_BCODE_BX_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_BX, MSG_FORMAT_BCODE_BX_STR );
         break;

      case MSG_FMT_BCODE_C0_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C0, MSG_FORMAT_BCODE_C0_STR );
         break;

      case MSG_FMT_BCODE_C1_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C1, MSG_FORMAT_BCODE_C1_STR );
         break;

      case MSG_FMT_BCODE_C2_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C2, MSG_FORMAT_BCODE_C2_STR );
         break;

      case MSG_FMT_BCODE_C3_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C3, MSG_FORMAT_BCODE_C3_STR );
         break;

      case MSG_FMT_BCODE_C41_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C41, MSG_FORMAT_BCODE_C41_STR );
         break;

      case MSG_FMT_BCODE_C42_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C42, MSG_FORMAT_BCODE_C42_STR ); 
         break;

      case MSG_FMT_BCODE_C5_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C5, MSG_FORMAT_BCODE_C5_STR );
         break;

      case MSG_FMT_BCODE_C6_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C6, MSG_FORMAT_BCODE_C6_STR );
         break;

      case MSG_FMT_BCODE_C7_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C7, MSG_FORMAT_BCODE_C7_STR ); 
         break;

      case MSG_FMT_BCODE_C8_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C8, MSG_FORMAT_BCODE_C8_STR ); 
         break;

      case MSG_FMT_BCODE_C9_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C9, MSG_FORMAT_BCODE_C9_STR ); 
         break;

      case MSG_FMT_BCODE_CA_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CA, MSG_FORMAT_BCODE_CA_STR ); 
         break;

      case MSG_FMT_BCODE_CB_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CB, MSG_FORMAT_BCODE_CB_STR ); 
         break;

      case MSG_FMT_BCODE_CC_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CC, MSG_FORMAT_BCODE_CC_STR ); 
         break;

      case MSG_FMT_BCODE_CD_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CD, MSG_FORMAT_BCODE_CD_STR ); 
         break;

      case MSG_FMT_BCODE_CE_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CE, MSG_FORMAT_BCODE_CE_STR );
         break;

      case MSG_FMT_BCODE_CF_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CF, MSG_FORMAT_BCODE_CF_STR );
         break;

      case MSG_FMT_BCODE_CX_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_CX, MSG_FORMAT_BCODE_CX_STR ); 
         break;

      case MSG_FMT_BCODE_C10_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_C10, MSG_FORMAT_BCODE_C10_STR );
         break;

      case MSG_FMT_BCODE_DX_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_DX, MSG_FORMAT_BCODE_DX_STR );
         break;

      case MSG_FMT_BCODE_EX_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_EX, MSG_FORMAT_BCODE_EX_STR );
         break;

      case MSG_FMT_BCODE_F0_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F0, MSG_FORMAT_BCODE_F0_STR );
         break;

      case MSG_FMT_BCODE_F1_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F1, MSG_FORMAT_BCODE_F1_STR );
         break;

      case MSG_FMT_BCODE_F2_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F2, MSG_FORMAT_BCODE_F2_STR );
         break;

      case MSG_FMT_BCODE_F3_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F3, MSG_FORMAT_BCODE_F3_STR );
         break;

      case MSG_FMT_BCODE_F4_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F4, MSG_FORMAT_BCODE_F4_STR );
         break;

      case MSG_FMT_BCODE_F5_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F5, MSG_FORMAT_BCODE_F5_STR ); 
         break;

      case MSG_FMT_BCODE_F6_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F6, MSG_FORMAT_BCODE_F6_STR );
         break;

      case MSG_FMT_BCODE_F7_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F7, MSG_FORMAT_BCODE_F7_STR );
         break;

      case MSG_FMT_BCODE_F8_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F8, MSG_FORMAT_BCODE_F8_STR );
         break;

      case MSG_FMT_BCODE_F9_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_F9, MSG_FORMAT_BCODE_F9_STR );
         break;

      case MSG_FMT_BCODE_FA_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_FA, MSG_FORMAT_BCODE_FA_STR );
         break;

      case MSG_FMT_BCODE_FB_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_FB, MSG_FORMAT_BCODE_FB_STR );
         break;

      case MSG_FMT_BCODE_FC_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_FC, MSG_FORMAT_BCODE_FC_STR );
         break;

      case MSG_FMT_BCODE_FD_INTERP:
         msgString = CMsg( MSG_FORMAT_BCODE_FD, MSG_FORMAT_BCODE_FD_STR );
         break;

      case MSG_TAKEN_STRING_INTERP:
         msgString = CMsg( MSG_TAKEN_STRING, MSG_TAKEN_STRING_STR );
         break;

      case MSG_NOTTAKEN_STRING_INTERP:
         msgString = CMsg( MSG_NOTTAKEN_STRING, MSG_NOTTAKEN_STRING_STR );
         break;
      }

   return( msgString );
}

/****h* CatalogInterp() [2.3] **************************************
*
* NAME
*    CatalogInterp()
*
* DESCRIPTION
*    Localize strings used by the interpreter.  Called from
*    SetupMiscCatalogs() in Setup.c only.
********************************************************************
*
*/

PUBLIC int CatalogInterp( void ) // Interp.c
{
   IMPORT char *PrimStrings[ 257 ];
   
   PrimStrings[0] = CMsg( MSG_PRMS_NoOP,               MSG_PRMS_NoOP_STR );
   PrimStrings[1] = CMsg( MSG_PRMS_FindObjectClass,    MSG_PRMS_FindObjectClass_STR );
   PrimStrings[2] = CMsg( MSG_PRMS_FindSuperObject,    MSG_PRMS_FindSuperObject_STR );
   PrimStrings[3] = CMsg( MSG_PRMS_ClassRespondsToNew, MSG_PRMS_ClassRespondsToNew_STR );
   PrimStrings[4] = CMsg( MSG_PRMS_ObjectSize,         MSG_PRMS_ObjectSize_STR );
   PrimStrings[5] = CMsg( MSG_PRMS_HashNum,            MSG_PRMS_HashNum_STR );
   PrimStrings[6] = CMsg( MSG_PRMS_ObjectSameType,     MSG_PRMS_ObjectSameType_STR );
   PrimStrings[7] = CMsg( MSG_PRMS_ObjectsEqual,       MSG_PRMS_ObjectsEqual_STR );
   PrimStrings[8] = CMsg( MSG_PRMS_ToggleDebug,        MSG_PRMS_ToggleDebug_STR );
   PrimStrings[9] = CMsg( MSG_PRMS_Generality,         MSG_PRMS_Generality_STR );

   PrimStrings[10] = CMsg( MSG_PRMS_AddInts,    MSG_PRMS_AddInts_STR  );
   PrimStrings[11] = CMsg( MSG_PRMS_SubInts,    MSG_PRMS_SubInts_STR  );
   PrimStrings[12] = CMsg( MSG_PRMS_IntC_LT,    MSG_PRMS_IntC_LT_STR  ); // 12 & 42
   PrimStrings[13] = CMsg( MSG_PRMS_IntC_GT,    MSG_PRMS_IntC_GT_STR  ); // 13 & 43
   PrimStrings[14] = CMsg( MSG_PRMS_IntC_LEQ,   MSG_PRMS_IntC_LEQ_STR ); // 14 & 44
   PrimStrings[15] = CMsg( MSG_PRMS_IntC_GEQ,   MSG_PRMS_IntC_GEQ_STR ); // 15 & 45
   PrimStrings[16] = CMsg( MSG_PRMS_IntC_EQ,    MSG_PRMS_IntC_EQ_STR  ); // 16 & 46
   PrimStrings[17] = CMsg( MSG_PRMS_IntC_NEQ,   MSG_PRMS_IntC_NEQ_STR ); // 17 & 47
   PrimStrings[18] = CMsg( MSG_PRMS_MultInts,   MSG_PRMS_MultInts_STR );
   PrimStrings[19] = CMsg( MSG_PRMS_DSlashInts, MSG_PRMS_DSlashInts_STR );

   PrimStrings[20] = CMsg( MSG_PRMS_GCDInts,  MSG_PRMS_GCDInts_STR  );
   PrimStrings[21] = CMsg( MSG_PRMS_BITAT,    MSG_PRMS_BITAT_STR    );
   PrimStrings[22] = CMsg( MSG_PRMS_BITOR,    MSG_PRMS_BITOR_STR    );
   PrimStrings[23] = CMsg( MSG_PRMS_BITAND,   MSG_PRMS_BITAND_STR   );
   PrimStrings[24] = CMsg( MSG_PRMS_BITXOR,   MSG_PRMS_BITXOR_STR   );
   PrimStrings[25] = CMsg( MSG_PRMS_BITSHIFT, MSG_PRMS_BITSHIFT_STR );
   PrimStrings[26] = CMsg( MSG_PRMS_IntRadix, MSG_PRMS_IntRadix_STR );
   PrimStrings[27] = CMsg( MSG_PRMS_NOT_USED, MSG_PRMS_NOT_USED_STR );
   PrimStrings[28] = CMsg( MSG_PRMS_DivInts,  MSG_PRMS_DivInts_STR  );
   PrimStrings[29] = CMsg( MSG_PRMS_ModInts,  MSG_PRMS_ModInts_STR  );
    
   PrimStrings[30] = CMsg( MSG_PRMS_DoPrim2A,    MSG_PRMS_DoPrim2A_STR    );
   PrimStrings[31] = CMsg( MSG_PRMS_NOT_USED,    MSG_PRMS_NOT_USED_STR    );
   PrimStrings[32] = CMsg( MSG_PRMS_RandomFloat, MSG_PRMS_RandomFloat_STR );
   PrimStrings[33] = CMsg( MSG_PRMS_BITINV,      MSG_PRMS_BITINV_STR      );
   PrimStrings[34] = CMsg( MSG_PRMS_HIGHBIT,     MSG_PRMS_HIGHBIT_STR     );
   PrimStrings[35] = CMsg( MSG_PRMS_RANDOMNum,   MSG_PRMS_RANDOMNum_STR   );
   PrimStrings[36] = CMsg( MSG_PRMS_Int2Ch,      MSG_PRMS_Int2Ch_STR      );
   PrimStrings[37] = CMsg( MSG_PRMS_Int2Str,     MSG_PRMS_Int2Str_STR     );
   PrimStrings[38] = CMsg( MSG_PRMS_FACTORIAL,   MSG_PRMS_FACTORIAL_STR   );
   PrimStrings[39] = CMsg( MSG_PRMS_Int2Float,   MSG_PRMS_Int2Float_STR   );
    
   PrimStrings[40] = CMsg( MSG_PRMS_NOT_USED, MSG_PRMS_NOT_USED_STR );
   PrimStrings[41] = CMsg( MSG_PRMS_NOT_USED, MSG_PRMS_NOT_USED_STR );
   PrimStrings[42] = CMsg( MSG_PRMS_IntC_LT,  MSG_PRMS_IntC_LT_STR  );
   PrimStrings[43] = CMsg( MSG_PRMS_IntC_GT,  MSG_PRMS_IntC_GT_STR  );
   PrimStrings[44] = CMsg( MSG_PRMS_IntC_LEQ, MSG_PRMS_IntC_LEQ_STR );
   PrimStrings[45] = CMsg( MSG_PRMS_IntC_GEQ, MSG_PRMS_IntC_GEQ_STR );
   PrimStrings[46] = CMsg( MSG_PRMS_IntC_EQ,  MSG_PRMS_IntC_EQ_STR  );
   PrimStrings[47] = CMsg( MSG_PRMS_IntC_NEQ, MSG_PRMS_IntC_NEQ_STR );
   PrimStrings[48] = CMsg( MSG_PRMS_NOT_USED, MSG_PRMS_NOT_USED_STR );
   PrimStrings[49] = CMsg( MSG_PRMS_NOT_USED, MSG_PRMS_NOT_USED_STR );

   PrimStrings[50] = CMsg( MSG_PRMS_DigitValue, MSG_PRMS_DigitValue_STR );
   PrimStrings[51] = CMsg( MSG_PRMS_IsVowel, MSG_PRMS_IsVowel_STR );
   PrimStrings[52] = CMsg( MSG_PRMS_IsAlpha, MSG_PRMS_IsAlpha_STR );
   PrimStrings[53] = CMsg( MSG_PRMS_IsLower, MSG_PRMS_IsLower_STR );
   PrimStrings[54] = CMsg( MSG_PRMS_IsUpper, MSG_PRMS_IsUpper_STR );
   PrimStrings[55] = CMsg( MSG_PRMS_IsSpace, MSG_PRMS_IsSpace_STR );
   PrimStrings[56] = CMsg( MSG_PRMS_IsAlNum, MSG_PRMS_IsAlNum_STR );
   PrimStrings[57] = CMsg( MSG_PRMS_ChangeCase, MSG_PRMS_ChangeCase_STR );
   PrimStrings[58] = CMsg( MSG_PRMS_Ch2Str,  MSG_PRMS_Ch2Str_STR );
   PrimStrings[59] = CMsg( MSG_PRMS_Ch2Int,  MSG_PRMS_Ch2Int_STR );

   PrimStrings[60] = CMsg( MSG_PRMS_AddFloats, MSG_PRMS_AddFloats_STR );
   PrimStrings[61] = CMsg( MSG_PRMS_SubFloats, MSG_PRMS_SubFloats_STR );
   PrimStrings[62] = CMsg( MSG_PRMS_FLOAT_LT,  MSG_PRMS_FLOAT_LT_STR  );
   PrimStrings[63] = CMsg( MSG_PRMS_FLOAT_GT,  MSG_PRMS_FLOAT_GT_STR  );
   PrimStrings[64] = CMsg( MSG_PRMS_FLOAT_LEQ, MSG_PRMS_FLOAT_LEQ_STR );
   PrimStrings[65] = CMsg( MSG_PRMS_FLOAT_GEQ, MSG_PRMS_FLOAT_GEQ_STR );
   PrimStrings[66] = CMsg( MSG_PRMS_FLOAT_EQ,  MSG_PRMS_FLOAT_EQ_STR  );
   PrimStrings[67] = CMsg( MSG_PRMS_FLOAT_NEQ, MSG_PRMS_FLOAT_NEQ_STR );
   PrimStrings[68] = CMsg( MSG_PRMS_MultFloats,MSG_PRMS_MultFloats_STR );
   PrimStrings[69] = CMsg( MSG_PRMS_DivFloats, MSG_PRMS_DivFloats_STR );

   PrimStrings[70] = CMsg( MSG_PRMS_NatLog,    MSG_PRMS_NatLog_STR );
   PrimStrings[71] = CMsg( MSG_PRMS_SQRT,      MSG_PRMS_SQRT_STR   );
   PrimStrings[72] = CMsg( MSG_PRMS_FLOOR,     MSG_PRMS_FLOOR_STR  );
   PrimStrings[73] = CMsg( MSG_PRMS_CEIL,      MSG_PRMS_CEIL_STR   );
   PrimStrings[74] = CMsg( MSG_PRMS_NOT_USED,  MSG_PRMS_NOT_USED_STR );
   PrimStrings[75] = CMsg( MSG_PRMS_IntPart,   MSG_PRMS_IntPart_STR  );
   PrimStrings[76] = CMsg( MSG_PRMS_Fraction,  MSG_PRMS_Fraction_STR );
   PrimStrings[77] = CMsg( MSG_PRMS_GAMMA,     MSG_PRMS_GAMMA_STR    );
   PrimStrings[78] = CMsg( MSG_PRMS_Float2Str, MSG_PRMS_Float2Str_STR );
   PrimStrings[79] = CMsg( MSG_PRMS_EXP,       MSG_PRMS_EXP_STR      );
   
   PrimStrings[80] = CMsg( MSG_PRMS_NORM_RAD,      MSG_PRMS_NORM_RAD_STR );
   PrimStrings[81] = CMsg( MSG_PRMS_SIN,           MSG_PRMS_SIN_STR );
   PrimStrings[82] = CMsg( MSG_PRMS_COS,           MSG_PRMS_COS_STR );
   PrimStrings[83] = CMsg( MSG_PRMS_NOT_USED,      MSG_PRMS_NOT_USED_STR );
   PrimStrings[84] = CMsg( MSG_PRMS_ASIN,          MSG_PRMS_ASIN_STR );
   PrimStrings[85] = CMsg( MSG_PRMS_ACOS,          MSG_PRMS_ACOS_STR );
   PrimStrings[86] = CMsg( MSG_PRMS_ATAN,          MSG_PRMS_ATAN_STR );
   PrimStrings[87] = CMsg( MSG_PRMS_NOT_USED,      MSG_PRMS_NOT_USED_STR );
   PrimStrings[88] = CMsg( MSG_PRMS_POWER,         MSG_PRMS_POWER_STR );
   PrimStrings[89] = CMsg( MSG_PRMS_FloatRadixPrt, MSG_PRMS_FloatRadixPrt_STR );
   
   PrimStrings[90] = CMsg( MSG_PRMS_MiscSymOps,   MSG_PRMS_MiscSymOps_STR ); // added on 28-Mar-2002 to Symbol.c
   PrimStrings[91] = CMsg( MSG_PRMS_SymComp,      MSG_PRMS_SymComp_STR    );
   PrimStrings[92] = CMsg( MSG_PRMS_Sym2Str,      MSG_PRMS_Sym2Str_STR    );
   PrimStrings[93] = CMsg( MSG_PRMS_SymAsStr,     MSG_PRMS_SymAsStr_STR   );
   PrimStrings[94] = CMsg( MSG_PRMS_SymPrint,     MSG_PRMS_SymPrint_STR   );
   PrimStrings[95] = CMsg( MSG_PRMS_INSTVAR,      MSG_PRMS_INSTVAR_STR    ); // Added on 07-Oct-2003
   PrimStrings[96] = CMsg( MSG_PRMS_ASCIIVALUE,   MSG_PRMS_ASCIIVALUE_STR   );
   PrimStrings[97] = CMsg( MSG_PRMS_NewClass,     MSG_PRMS_NewClass_STR     );
   PrimStrings[98] = CMsg( MSG_PRMS_InstallClass, MSG_PRMS_InstallClass_STR );
   PrimStrings[99] = CMsg( MSG_PRMS_FindClass,    MSG_PRMS_FindClass_STR    );
   
   PrimStrings[100] = CMsg( MSG_PRMS_StrLen,   MSG_PRMS_StrLen_STR   );
   PrimStrings[101] = CMsg( MSG_PRMS_StrCmp,   MSG_PRMS_StrCmp_STR   );
   PrimStrings[102] = CMsg( MSG_PRMS_StrCmpNC, MSG_PRMS_StrCmpNC_STR );
   PrimStrings[103] = CMsg( MSG_PRMS_StrCat,   MSG_PRMS_StrCat_STR   );
   PrimStrings[104] = CMsg( MSG_PRMS_StrAt,    MSG_PRMS_StrAt_STR    );
   PrimStrings[105] = CMsg( MSG_PRMS_StrAtPut, MSG_PRMS_StrAtPut_STR );
   PrimStrings[106] = CMsg( MSG_PRMS_CPYLEN,   MSG_PRMS_CPYLEN_STR   );
   PrimStrings[107] = CMsg( MSG_PRMS_StrCpy,   MSG_PRMS_StrCpy_STR   );
   PrimStrings[108] = CMsg( MSG_PRMS_StrAsSym, MSG_PRMS_StrAsSym_STR );
   PrimStrings[109] = CMsg( MSG_PRMS_PRT_STR,  MSG_PRMS_PRT_STR_STR  );
   
   PrimStrings[110] = CMsg( MSG_PRMS_NewObject,   MSG_PRMS_NewObject_STR   );
   PrimStrings[111] = CMsg( MSG_PRMS_ObjectAt,    MSG_PRMS_ObjectAt_STR    );
   PrimStrings[112] = CMsg( MSG_PRMS_ObjectAtPut, MSG_PRMS_ObjectAtPut_STR );
   PrimStrings[113] = CMsg( MSG_PRMS_ObjectGrow,  MSG_PRMS_ObjectGrow_STR  );
   PrimStrings[114] = CMsg( MSG_PRMS_NewArray,    MSG_PRMS_NewArray_STR    );
   PrimStrings[115] = CMsg( MSG_PRMS_NewStr,      MSG_PRMS_NewStr_STR      );
   PrimStrings[116] = CMsg( MSG_PRMS_NewBArray,   MSG_PRMS_NewBArray_STR   );
   PrimStrings[117] = CMsg( MSG_PRMS_BArray_Size, MSG_PRMS_BArray_Size_STR );
   PrimStrings[118] = CMsg( MSG_PRMS_BArrayAt,    MSG_PRMS_BArrayAt_STR    );
   PrimStrings[119] = CMsg( MSG_PRMS_BArrayAtPut, MSG_PRMS_BArrayAtPut_STR );
   
   PrimStrings[120] = CMsg( MSG_PRMS_PRT_NORET,   MSG_PRMS_PRT_NORET_STR   );
   PrimStrings[121] = CMsg( MSG_PRMS_PRT_RET,     MSG_PRMS_PRT_RET_STR     );
   PrimStrings[122] = CMsg( MSG_PRMS_FORMATERROR, MSG_PRMS_FORMATERROR_STR );
   PrimStrings[123] = CMsg( MSG_PRMS_ERR_PRT,     MSG_PRMS_ERR_PRT_STR     );
   PrimStrings[124] = CMsg( MSG_PRMS_CURSES_PRM,  MSG_PRMS_CURSES_PRM_STR  );
   PrimStrings[125] = CMsg( MSG_PRMS_SYSCALL,     MSG_PRMS_SYSCALL_STR     );
   PrimStrings[126] = CMsg( MSG_PRMS_PRTAT,       MSG_PRMS_PRTAT_STR       );
   PrimStrings[127] = CMsg( MSG_PRMS_BLK_RETN,    MSG_PRMS_BLK_RETN_STR    );
   PrimStrings[128] = CMsg( MSG_PRMS_REF_ERR,     MSG_PRMS_REF_ERR_STR     );
   PrimStrings[129] = CMsg( MSG_PRMS_NO_RESPONSE, MSG_PRMS_NO_RESPONSE_STR );
   
   PrimStrings[130] = CMsg( MSG_PRMS_FILEOPEN,     MSG_PRMS_FILEOPEN_STR  );
   PrimStrings[131] = CMsg( MSG_PRMS_FILEREAD,     MSG_PRMS_FILEREAD_STR  );
   PrimStrings[132] = CMsg( MSG_PRMS_FILEWRITE,    MSG_PRMS_FILEWRITE_STR );
   PrimStrings[133] = CMsg( MSG_PRMS_SET_FMODE,    MSG_PRMS_SET_FMODE_STR );
   PrimStrings[134] = CMsg( MSG_PRMS_FILESIZE,     MSG_PRMS_FILESIZE_STR  );
   PrimStrings[135] = CMsg( MSG_PRMS_SET_FPOS,     MSG_PRMS_SET_FPOS_STR  );
   PrimStrings[136] = CMsg( MSG_PRMS_GET_FPOS,     MSG_PRMS_GET_FPOS_STR );
   PrimStrings[137] = CMsg( MSG_PRMS_H_CLASSINFO,  MSG_PRMS_H_CLASSINFO_STR );  // added 27-Jan-2002 ClDict.c
   PrimStrings[138] = CMsg( MSG_PRMS_H_SUPERVISOR, MSG_PRMS_H_SUPERVISOR_STR ); // added 31-Jan-2002 Global.c
   PrimStrings[139] = CMsg( MSG_PRMS_FILE_CLOSE,   MSG_PRMS_FILE_CLOSE_STR   ); // Added 04-Sep-2003
        
   PrimStrings[140] = CMsg( MSG_PRMS_Blk_Exec,     MSG_PRMS_Blk_Exec_STR     );
   PrimStrings[141] = CMsg( MSG_PRMS_NEWPROC,      MSG_PRMS_NEWPROC_STR      );
   PrimStrings[142] = CMsg( MSG_PRMS_TERM_PROC,    MSG_PRMS_TERM_PROC_STR    );
   PrimStrings[143] = CMsg( MSG_PRMS_PERF_ARGS,    MSG_PRMS_PERF_ARGS_STR    );
   PrimStrings[144] = CMsg( MSG_PRMS_BLK_NARGS,    MSG_PRMS_BLK_NARGS_STR    );
   PrimStrings[145] = CMsg( MSG_PRMS_SETPROCSTATE, MSG_PRMS_SETPROCSTATE_STR );
   PrimStrings[146] = CMsg( MSG_PRMS_GETPROCSTATE, MSG_PRMS_GETPROCSTATE_STR );
   PrimStrings[147] = CMsg( MSG_PRMS_NOT_USED,     MSG_PRMS_NOT_USED_STR     );
   PrimStrings[148] = CMsg( MSG_PRMS_BEGIN_ATOM,   MSG_PRMS_BEGIN_ATOM_STR   );
   PrimStrings[149] = CMsg( MSG_PRMS_END_ATOM,     MSG_PRMS_END_ATOM_STR     );
   
   PrimStrings[150] = CMsg( MSG_PRMS_EDITCLASS,       MSG_PRMS_EDITCLASS_STR       );
   PrimStrings[151] = CMsg( MSG_PRMS_FindSuperClass,  MSG_PRMS_FindSuperClass_STR  );
   PrimStrings[152] = CMsg( MSG_PRMS_GetClassName,    MSG_PRMS_GetClassName_STR    );
   PrimStrings[153] = CMsg( MSG_PRMS_ClassNew,        MSG_PRMS_ClassNew_STR        );
   PrimStrings[154] = CMsg( MSG_PRMS_PrtMessages,     MSG_PRMS_PrtMessages_STR     );
   PrimStrings[155] = CMsg( MSG_PRMS_ClassResponds2,  MSG_PRMS_ClassResponds2_STR  );
   PrimStrings[156] = CMsg( MSG_PRMS_ViewClass,       MSG_PRMS_ViewClass_STR       );
   PrimStrings[157] = CMsg( MSG_PRMS_ListSubClasses,  MSG_PRMS_ListSubClasses_STR  );
   PrimStrings[158] = CMsg( MSG_PRMS_ClassesInstVars, MSG_PRMS_ClassesInstVars_STR );
   PrimStrings[159] = CMsg( MSG_PRMS_Get_BArray,      MSG_PRMS_Get_BArray_STR      );
   
   PrimStrings[160] = CMsg( MSG_PRMS_Get_CTIME,  MSG_PRMS_Get_CTIME_STR  );
   PrimStrings[161] = CMsg( MSG_PRMS_TIME_CNTR,  MSG_PRMS_TIME_CNTR_STR  );
   PrimStrings[162] = CMsg( MSG_PRMS_CLR_SCREEN, MSG_PRMS_CLR_SCREEN_STR );
   PrimStrings[163] = CMsg( MSG_PRMS_GetStr,     MSG_PRMS_GetStr_STR     );
   PrimStrings[164] = CMsg( MSG_PRMS_Str2Int,    MSG_PRMS_Str2Int_STR    );
   PrimStrings[165] = CMsg( MSG_PRMS_Str2Float,  MSG_PRMS_Str2Float_STR  );
   PrimStrings[166] = CMsg( MSG_PRMS_NOT_USED,   MSG_PRMS_NOT_USED_STR   );
   PrimStrings[167] = CMsg( MSG_PRMS_NOT_USED,   MSG_PRMS_NOT_USED_STR   );
   PrimStrings[168] = CMsg( MSG_PRMS_PlotArc,    MSG_PRMS_PlotArc_STR    );
   PrimStrings[169] = CMsg( MSG_PRMS_PlotEnv,    MSG_PRMS_PlotEnv_STR    );
   
   PrimStrings[170] = CMsg( MSG_PRMS_PlotClr,     MSG_PRMS_PlotClr_STR     );
   PrimStrings[171] = CMsg( MSG_PRMS_PlotMove,    MSG_PRMS_PlotMove_STR    );
   PrimStrings[172] = CMsg( MSG_PRMS_PlotCont,    MSG_PRMS_PlotCont_STR    );
   PrimStrings[173] = CMsg( MSG_PRMS_PlotPt,      MSG_PRMS_PlotPt_STR      );
   PrimStrings[174] = CMsg( MSG_PRMS_PlotCir,     MSG_PRMS_PlotCir_STR     );
   PrimStrings[175] = CMsg( MSG_PRMS_PlotBox,     MSG_PRMS_PlotBox_STR     );
   PrimStrings[176] = CMsg( MSG_PRMS_PlotSetPens, MSG_PRMS_PlotSetPens_STR );
   PrimStrings[177] = CMsg( MSG_PRMS_PlotLine,    MSG_PRMS_PlotLine_STR    );
   PrimStrings[178] = CMsg( MSG_PRMS_PlotLabel,   MSG_PRMS_PlotLabel_STR   );
   PrimStrings[179] = CMsg( MSG_PRMS_PlotLType,   MSG_PRMS_PlotLType_STR   );
        
   PrimStrings[180] = CMsg( MSG_PRMS_H_Screens, MSG_PRMS_H_Screens_STR );
   PrimStrings[181] = CMsg( MSG_PRMS_H_Windows, MSG_PRMS_H_Windows_STR );
   PrimStrings[182] = CMsg( MSG_PRMS_H_Menus,   MSG_PRMS_H_Menus_STR   );
   PrimStrings[183] = CMsg( MSG_PRMS_H_Gadgets, MSG_PRMS_H_Gadgets_STR );
   PrimStrings[184] = CMsg( MSG_PRMS_H_Colors,  MSG_PRMS_H_Colors_STR  );
   PrimStrings[185] = CMsg( MSG_PRMS_H_Reqs,    MSG_PRMS_H_Reqs_STR    );
   PrimStrings[186] = CMsg( MSG_PRMS_H_IO,      MSG_PRMS_H_IO_STR      );
   PrimStrings[187] = CMsg( MSG_PRMS_H_Borders, MSG_PRMS_H_Borders_STR );
   PrimStrings[188] = CMsg( MSG_PRMS_H_IText,   MSG_PRMS_H_IText_STR   );
   PrimStrings[189] = CMsg( MSG_PRMS_H_BitMaps, MSG_PRMS_H_BitMaps_STR );
   
   PrimStrings[190] = CMsg( MSG_PRMS_H_Libraries, MSG_PRMS_H_Libraries_STR );
   PrimStrings[191] = CMsg( MSG_PRMS_H_MsgPorts,  MSG_PRMS_H_MsgPorts_STR  );
   PrimStrings[192] = CMsg( MSG_PRMS_H_Tasks,     MSG_PRMS_H_Tasks_STR     );
   PrimStrings[193] = CMsg( MSG_PRMS_H_Procs,     MSG_PRMS_H_Procs_STR     );
   PrimStrings[194] = CMsg( MSG_PRMS_H_Memory,    MSG_PRMS_H_Memory_STR    );
   PrimStrings[195] = CMsg( MSG_PRMS_H_Lists,     MSG_PRMS_H_Lists_STR     );
   PrimStrings[196] = CMsg( MSG_PRMS_H_Intrs,     MSG_PRMS_H_Intrs_STR     );
   PrimStrings[197] = CMsg( MSG_PRMS_H_Semas,     MSG_PRMS_H_Semas_STR     );
   PrimStrings[198] = CMsg( MSG_PRMS_H_Signals,   MSG_PRMS_H_Signals_STR   );
   PrimStrings[199] = CMsg( MSG_PRMS_H_Excepts,   MSG_PRMS_H_Excepts_STR   );
   
   PrimStrings[200] = CMsg( MSG_PRMS_H_SGraphs,   MSG_PRMS_H_SGraphs_STR   );
   PrimStrings[201] = CMsg( MSG_PRMS_H_Areas,     MSG_PRMS_H_Areas_STR     );
   PrimStrings[202] = CMsg( MSG_PRMS_H_ViewPorts, MSG_PRMS_H_ViewPorts_STR );
   PrimStrings[203] = CMsg( MSG_PRMS_Views,       MSG_PRMS_Views_STR       );
   PrimStrings[204] = CMsg( MSG_PRMS_H_PlayF,     MSG_PRMS_H_PlayF_STR     );
   PrimStrings[205] = CMsg( MSG_PRMS_H_Unused,    MSG_PRMS_H_Unused_STR    );
   PrimStrings[206] = CMsg( MSG_PRMS_H_SDict,     MSG_PRMS_H_SDict_STR     );
   PrimStrings[207] = CMsg( MSG_PRMS_H_Layers,    MSG_PRMS_H_Layers_STR    );
   PrimStrings[208] = CMsg( MSG_PRMS_H_Unused,    MSG_PRMS_H_Unused_STR    );
   PrimStrings[209] = CMsg( MSG_PRMS_H_LibIntfc,  MSG_PRMS_H_LibIntfc_STR  );
   
   PrimStrings[210] = CMsg( MSG_PRMS_H_DT,     MSG_PRMS_H_DT_STR     );
   PrimStrings[211] = CMsg( MSG_PRMS_H_ARexx,  MSG_PRMS_H_ARexx_STR  );
   PrimStrings[212] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[213] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[214] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[215] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[216] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[217] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[218] = CMsg( MSG_PRMS_H_MDevs,  MSG_PRMS_H_MDevs_STR  );
   PrimStrings[219] = CMsg( MSG_PRMS_H_Icons,  MSG_PRMS_H_Icons_STR  );

   PrimStrings[220] = CMsg( MSG_PRMS_H_Audio,       MSG_PRMS_H_Audio_STR       );
   PrimStrings[221] = CMsg( MSG_PRMS_H_Clips,       MSG_PRMS_H_Clips_STR       );
   PrimStrings[222] = CMsg( MSG_PRMS_H_ConsoleKeys, MSG_PRMS_H_ConsoleKeys_STR );
   PrimStrings[223] = CMsg( MSG_PRMS_H_GamePort,    MSG_PRMS_H_GamePort_STR    );
   PrimStrings[224] = CMsg( MSG_PRMS_H_Para,        MSG_PRMS_H_Para_STR        );
   PrimStrings[225] = CMsg( MSG_PRMS_H_Prntr,       MSG_PRMS_H_Prntr_STR       );
   PrimStrings[226] = CMsg( MSG_PRMS_H_SCSI,        MSG_PRMS_H_SCSI_STR        );
   PrimStrings[227] = CMsg( MSG_PRMS_H_Serial,      MSG_PRMS_H_Serial_STR      );
   PrimStrings[228] = CMsg( MSG_PRMS_H_Unused,      MSG_PRMS_H_Unused_STR      );
   PrimStrings[229] = CMsg( MSG_PRMS_H_Disk,        MSG_PRMS_H_Disk_STR        );
                
   PrimStrings[230] = CMsg( MSG_PRMS_H_Narr,   MSG_PRMS_H_Narr_STR   );
   PrimStrings[231] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[232] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[233] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[234] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[235] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[236] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[237] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[238] = CMsg( MSG_PRMS_H_BOOPSI, MSG_PRMS_H_BOOPSI_STR );
   PrimStrings[239] = CMsg( MSG_PRMS_H_GTools, MSG_PRMS_H_GTools_STR );
            
   PrimStrings[240] = CMsg( MSG_PRMS_H_IFF,    MSG_PRMS_H_IFF_STR    );
   PrimStrings[241] = CMsg( MSG_PRMS_H_IFF,    MSG_PRMS_H_IFF_STR    );
   PrimStrings[242] = CMsg( MSG_PRMS_H_IFF,    MSG_PRMS_H_IFF_STR    );
   PrimStrings[243] = CMsg( MSG_PRMS_H_IFF,    MSG_PRMS_H_IFF_STR    );
   PrimStrings[244] = CMsg( MSG_PRMS_H_IFF,    MSG_PRMS_H_IFF_STR    );
   PrimStrings[245] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[246] = CMsg( MSG_PRMS_H_ADOS1,  MSG_PRMS_H_ADOS1_STR  );
   PrimStrings[247] = CMsg( MSG_PRMS_H_ADOS2,  MSG_PRMS_H_ADOS2_STR  );
   PrimStrings[248] = CMsg( MSG_PRMS_H_ADOS3,  MSG_PRMS_H_ADOS3_STR  );
   PrimStrings[249] = CMsg( MSG_PRMS_H_ADOS4,  MSG_PRMS_H_ADOS4_STR  );
   
   PrimStrings[250] = CMsg( MSG_PRMS_H_Sys,    MSG_PRMS_H_Sys_STR    );
   PrimStrings[251] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[252] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[253] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[254] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
   PrimStrings[255] = CMsg( MSG_PRMS_H_Unused, MSG_PRMS_H_Unused_STR );
}

PUBLIC STRPTR IOCMsg( int whichString ) // IO.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_IO_ENTER_STRING_IO:
         msgString = CMsg( MSG_IO_ENTER_STRING, MSG_IO_ENTER_STRING_STR );
         break;

      case MSG_IO_GET_A_FILE_IO:
         msgString = CMsg( MSG_IO_GET_A_FILE, MSG_IO_GET_A_FILE_STR ); 
         break;

      case MSG_IO_SELECT_SCRNMODE_IO:
         msgString = CMsg( MSG_IO_SELECT_SCRNMODE, MSG_IO_SELECT_SCRNMODE_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC int CatalogIO( void ) // IO.c
{
   IMPORT struct NewGadget IONGad[ 3 ];
   
   IONGad[0].ng_GadgetText = CMsg( MSG_IO_STRING_GAD, MSG_IO_STRING_GAD_STR );
   IONGad[1].ng_GadgetText = CMsg( MSG_D2_DONE_GAD,   MSG_D2_DONE_GAD_STR   );
   IONGad[2].ng_GadgetText = CMsg( MSG_CANCEL_GAD,    MSG_CANCEL_GAD_STR    );

   return( 0 );
}

PUBLIC STRPTR ITxtCMsg( int whichString ) // ITextFont.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_ITF_FONTADD_FUNC_ITEXT:
         msgString = CMsg( MSG_ITF_FONTADD_FUNC, MSG_ITF_FONTADD_FUNC_STR );
         break;

      case MSG_ITF_SETFONT_FUNC_ITEXT:
         msgString = CMsg( MSG_ITF_SETFONT_FUNC, MSG_ITF_SETFONT_FUNC_STR );
         break;

      case MSG_ITF_DEFAULT_TXT_ITEXT:
         msgString = CMsg( MSG_ITF_DEFAULT_TXT, MSG_ITF_DEFAULT_TXT_STR );
         break;

      case MSG_ITF_SETPART_FUNC_ITEXT:
         msgString = CMsg( MSG_ITF_SETPART_FUNC, MSG_ITF_SETPART_FUNC_STR );
         break;

      case MSG_ITF_TXTADD_FUNC_ITEXT:
         msgString = CMsg( MSG_ITF_TXTADD_FUNC, MSG_ITF_TXTADD_FUNC_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR LexCMsg( int whichString ) // Lex.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_LX_NOTHING_LEX:
         msgString = CMsg( MSG_LX_NOTHING, MSG_LX_NOTHING_STR );
         break;

      case MSG_LX_IMPOSSIBLE_LEX:
         msgString = CMsg( MSG_LX_IMPOSSIBLE, MSG_LX_IMPOSSIBLE_STR );
         break;

      case MSG_LX_PUTBAK1_LEX:
         msgString = CMsg( MSG_LX_PUTBAK1, MSG_LX_PUTBAK1_STR );
         break;

      case MSG_LX_PUTBAK2_LEX:
         msgString = CMsg( MSG_LX_PUTBAK2, MSG_LX_PUTBAK2_STR );
         break;

      case MSG_LX_FATALERR_LEX:
         msgString = CMsg( MSG_LX_FATALERR, MSG_LX_FATALERR_STR );
         break;

      case MSG_LX_LEXSAVE_LEX:
         msgString = CMsg( MSG_LX_LEXSAVE, MSG_LX_LEXSAVE_STR );
         break;

      case MSG_LX_NO_SYMBOLS_LEX:
         msgString = CMsg( MSG_LX_NO_SYMBOLS, MSG_LX_NO_SYMBOLS_STR );
         break;

      case MSG_LX_NEXTLEX_LEX:
         msgString = CMsg( MSG_LX_NEXTLEX, MSG_LX_NEXTLEX_STR );
         break;

      case MSG_UNTERMD_COMMENT_LEX:
         msgString = CMsg( MSG_UNTERMD_COMMENT, MSG_UNTERMD_COMMENT_STR );
         break;

      case MSG_LX_LONG_TOKEN_LEX:
         msgString = CMsg( MSG_LX_LONG_TOKEN, MSG_LX_LONG_TOKEN_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR LCmdCMsg( int whichString ) // LexCmd.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_CANNOT_OPEN_LXC:
         msgString = CMsg( MSG_CANNOT_OPEN, MSG_CANNOT_OPEN_STR );
         break;

      case MSG_NO_INCLUDE_LXC:
         msgString = CMsg( MSG_LXC_NO_INCLUDE, MSG_LXC_NO_INCLUDE_STR );
         break;

      case MSG_NO_EDITOR_LXC:
         msgString = CMsg( MSG_LXC_NO_EDITOR, MSG_LXC_NO_EDITOR_STR );
         break;

      case MSG_UNKNOWNCMD_LXC:
         msgString = CMsg( MSG_LXC_UNKNOWNCMD, MSG_LXC_UNKNOWNCMD_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR LineCMsg( int whichString ) // Line.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_NO_FILES_LINE:
         msgString = CMsg( MSG_LN_NO_FILES, MSG_LN_NO_FILES_STR );
         break;

      case MSG_BUF_OVFLW_LINE:
         msgString = CMsg( MSG_LN_BUF_OVFLW, MSG_LN_BUF_OVFLW_STR );
         break;
      }
      
   return( msgString );
}

PUBLIC STRPTR MenusCMsg( int whichString ) // Menus.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_MENUADD_FUNC_MEN:
         msgString = CMsg( MSG_MEN_MENUADD_FUNC, MSG_MEN_MENUADD_FUNC_STR );
         break;

      case MSG_UNDEF_ITEXT_MEN:
         msgString = CMsg( MSG_MEN_UNDEF_ITEXT, MSG_MEN_UNDEF_ITEXT_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogMenu() [3.0] ******************************************
*
* NAME
*    CatalogMenu()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogMenu( void ) // Menus.c
{
   IMPORT struct Menu      DefaultMenu;
   IMPORT struct IntuiText DefaultItemText;
   
   DefaultMenu.MenuName  = CMsg( MSG_MEN_DEFAULTMENU, MSG_MEN_DEFAULTMENU_STR );
   DefaultItemText.IText = CMsg( MSG_MEN_DEFAULTITEM, MSG_MEN_DEFAULTITEM_STR );

   return( 0 );
}

PUBLIC STRPTR MPortCMsg( int whichString ) // MsgPort.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_MP_MSGPORTCLASSNAME_MPORT:
         msgString = CMsg( MSG_MP_MSGPORTCLASSNAME, MSG_MP_MSGPORTCLASSNAME_STR );
         break;

      case MSG_MP_UNKNOWN_MPORT:
         msgString = CMsg( MSG_MP_UNKNOWN, MSG_MP_UNKNOWN_STR );
         break;

      case MSG_MP_NO_TASKNAME_MPORT:
         msgString = CMsg( MSG_MP_NO_TASKNAME, MSG_MP_NO_TASKNAME_STR );  
         break;

      case MSG_MP_NO_TASKNODE_MPORT:
         msgString = CMsg( MSG_MP_NO_TASKNODE, MSG_MP_NO_TASKNODE_STR );   
         break;

      case MSG_MP_NO_TASKPTR_MPORT:
         msgString = CMsg( MSG_MP_NO_TASKPTR, MSG_MP_NO_TASKPTR_STR );   
         break;

      case MSG_MP_NO_STARNAME_MPORT:
         msgString = CMsg( MSG_MP_NO_STARNAME, MSG_MP_NO_STARNAME_STR );
         break;

      case MSG_MP_UPDATEPORTLV_MPORT:
         msgString = CMsg( MSG_MP_UPDATEPORTLV, MSG_MP_UPDATEPORTLV_STR );
         break;

      case MSG_MP_CANT_SETUP_MPORT:
         msgString = CMsg( MSG_MP_CANT_SETUP, MSG_MP_CANT_SETUP_STR );
         break;

      case MSG_MP_KILLPORT_FUNC_MPORT:
         msgString = CMsg( MSG_MP_KILLPORT_FUNC, MSG_MP_KILLPORT_FUNC_STR );
         break;

      case MSG_MP_GETMSG_FUNC_MPORT:
         msgString = CMsg( MSG_MP_GETMSG_FUNC, MSG_MP_GETMSG_FUNC_STR );
         break;

      case MSG_MP_SENDMSG_FUNC_MPORT:
         msgString = CMsg( MSG_MP_SENDMSG_FUNC, MSG_MP_SENDMSG_FUNC_STR );
         break;

      case MSG_MP_NO_SNDMSG_SPC_MPORT:
         msgString = CMsg( MSG_MP_NO_SNDMSG_SPC, MSG_MP_NO_SNDMSG_SPC_STR );
         break;

      case MSG_MP_NEWPORT_FUNC_MPORT:
         msgString = CMsg( MSG_MP_NEWPORT_FUNC, MSG_MP_NEWPORT_FUNC_STR );
         break;

      case MSG_MP_SNDMSGOUT_SRC_MPORT:
         msgString = CMsg( MSG_MP_SNDMSGOUT_SRC, MSG_MP_SNDMSGOUT_SRC_STR );
         break;

      case MSG_MP_SNDMSGOUT_DST_MPORT:
         msgString = CMsg( MSG_MP_SNDMSGOUT_DST, MSG_MP_SNDMSGOUT_DST_STR );
         break;

      case MSG_MP_NO_DESTPORT_MPORT:
         msgString = CMsg( MSG_MP_NO_DESTPORT, MSG_MP_NO_DESTPORT_STR );
         break;

      case MSG_MP_NO_SRCPORT_MPORT:
         msgString = CMsg( MSG_MP_NO_SRCPORT, MSG_MP_NO_SRCPORT_STR );
         break;

      case MSG_FMT_MP_MSG_MPORT:
         msgString = CMsg( MSG_FORMAT_MP_MSG, MSG_FORMAT_MP_MSG_STR );
         break;
      }
      
   return( msgString );
}

/****h* CatalogMsgPort() [3.0] ***************************************
*
* NAME
*    CatalogMsgPort()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
**********************************************************************
*
*/

PUBLIC int CatalogMsgPort( void ) // MsgPort.c
{
   IMPORT struct NewGadget MPNGad[ 5 ];
   IMPORT UBYTE           *MPWdt;

   MPNGad[0].ng_GadgetText = CMsg( MSG_MP_LV_GAD,     MSG_MP_LV_GAD_STR     );
   MPNGad[2].ng_GadgetText = CMsg( MSG_MP_DONE_GAD,   MSG_MP_DONE_GAD_STR   );
   MPNGad[3].ng_GadgetText = CMsg( MSG_MP_UPDATE_GAD, MSG_MP_UPDATE_GAD_STR );
   MPNGad[4].ng_GadgetText = CMsg( MSG_MP_CANCEL_GAD, MSG_MP_CANCEL_GAD_STR );
   
   MPWdt = CMsg( MSG_MP_WTITLE, MSG_MP_WTITLE_STR );

   return( 0 );
}

PUBLIC STRPTR NarrCMsg( int whichString ) // Narrator.c
{
   STRPTR msgString = NULL;
   
   switch (whichString)
      {
      case MSG_NAERR_BADNUMBER_NARR:
         msgString = CMsg( MSG_NAERR_BADNUMBER, MSG_NAERR_BADNUMBER_STR );
         break;

      case MSG_AVAIL_COMMAND_NARR:
         msgString = CMsg( MSG_AVAIL_COMMAND, MSG_AVAIL_COMMAND_STR );
         break;

      case MSG_NA_MODE_ROBOTIC_NARR:
         msgString = CMsg( MSG_NA_MODE_ROBOTIC, MSG_NA_MODE_ROBOTIC_STR );
         break;

      case MSG_NA_MODE_MANUAL_NARR:
         msgString = CMsg( MSG_NA_MODE_MANUAL, MSG_NA_MODE_MANUAL_STR );
         break;

      case MSG_FMT_NA_TOOSMALL_NARR:
         msgString = CMsg( MSG_FORMAT_NA_TOOSMALL, MSG_FORMAT_NA_TOOSMALL_STR ); 
         break;

      case MSG_NA_TRANSLATED_FUNC_NARR:
         msgString = CMsg( MSG_NA_TRANSLATED_FUNC, MSG_NA_TRANSLATED_FUNC_STR ); 
         break;

      case MSG_FMT_NA_TOOLARGE_NARR:
         msgString = CMsg( MSG_FORMAT_NA_TOOLARGE, MSG_FORMAT_NA_TOOLARGE_STR );
         break;
      }

   return( msgString );
}

/****i* CatalogNarrator() [3.0] ****************************************
*
* NAME
*    CatalogNarrator()
*
* DESCRIPTION
*    Localize various strings.  Called from SetupMiscCatalogs()
*    in Setup.c only.
************************************************************************
*
*/

PUBLIC char *NarrErrMsgs[33] = { NULL, }; // Visible to CatalogNarrator();

PUBLIC int CatalogNarrator( void ) // Narrator.c
{
   NarrErrMsgs[0]  = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[1]  = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );

   NarrErrMsgs[2]  = CMsg( MSG_NAERR_NO_MEMORY,    MSG_NAERR_NO_MEMORY_STR ); // -2
   NarrErrMsgs[3]  = CMsg( MSG_NAERR_CANT_OPEN,    MSG_NAERR_CANT_OPEN_STR );
   NarrErrMsgs[4]  = CMsg( MSG_NAERR_MAKELIB_ERR,  MSG_NAERR_MAKELIB_ERR_STR );
   NarrErrMsgs[5]  = CMsg( MSG_NAERR_WRONG_UNIT,   MSG_NAERR_WRONG_UNIT_STR );
   NarrErrMsgs[6]  = CMsg( MSG_NAERR_NO_CHANNEL,   MSG_NAERR_NO_CHANNEL_STR );
   NarrErrMsgs[7]  = CMsg( MSG_NAERR_UNIMP_CMD,    MSG_NAERR_UNIMP_CMD_STR );
   NarrErrMsgs[8]  = CMsg( MSG_NAERR_READ_WRONG,   MSG_NAERR_READ_WRONG_STR );
   NarrErrMsgs[9]  = CMsg( MSG_NAERR_DEFERRED_EXP, MSG_NAERR_DEFERRED_EXP_STR );  // -9

   NarrErrMsgs[10] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[11] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[12] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[13] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[14] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[15] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[16] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[17] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[18] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );
   NarrErrMsgs[19] = CMsg( MSG_NAERR_INVALID_NUM, MSG_NAERR_INVALID_NUM_STR );

   NarrErrMsgs[20] = CMsg( MSG_NAERR_BAD_PHONEME,  MSG_NAERR_BAD_PHONEME_STR );   // -20
   NarrErrMsgs[21] = CMsg( MSG_NAERR_BAD_RATE,     MSG_NAERR_BAD_RATE_STR );
   NarrErrMsgs[22] = CMsg( MSG_NAERR_BAD_PITCH,    MSG_NAERR_BAD_PITCH_STR );
   NarrErrMsgs[23] = CMsg( MSG_NAERR_INVALID_SEX,  MSG_NAERR_INVALID_SEX_STR );
   NarrErrMsgs[24] = CMsg( MSG_NAERR_INVALID_MODE, MSG_NAERR_INVALID_MODE_STR );
   NarrErrMsgs[25] = CMsg( MSG_NAERR_BAD_SFREQ,    MSG_NAERR_BAD_SFREQ_STR );
   NarrErrMsgs[26] = CMsg( MSG_NAERR_BAD_VOLUME,   MSG_NAERR_BAD_VOLUME_STR );
   NarrErrMsgs[27] = CMsg( MSG_NAERR_BAD_CENTRAL,  MSG_NAERR_BAD_CENTRAL_STR );
   NarrErrMsgs[28] = CMsg( MSG_NAERR_INVALID_PH,   MSG_NAERR_INVALID_PH_STR );
   NarrErrMsgs[29] = CMsg( MSG_NAERR_NO_PORT,      MSG_NAERR_NO_PORT_STR );       // -29
   NarrErrMsgs[30] = CMsg( MSG_NAERR_NO_EXTIO,     MSG_NAERR_NO_EXTIO_STR );
   NarrErrMsgs[31] = CMsg( MSG_NAERR_USER_ERROR,   MSG_NAERR_USER_ERROR_STR );

   return( 0 );
}

/* --------------------- END of CatFuncs2.c file! ----------------------- */
