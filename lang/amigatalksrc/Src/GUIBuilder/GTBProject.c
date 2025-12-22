/****h* GTBProject.c [1.2] *****************************************
*
* NAME
*    GTBProject.c
*
* DESCRIPTION
*    A GUI for obtaining additional Project information for
*    GTBScanner.
*
* HISTORY
*    01-Nov-2004 - Added AmigaOS4 & gcc support.
*    30-Sep-2003 - Deleted the CommonFuncs checkbox.
*    22-Sep-2003 - Created this file.
*
* NOTES
*    FUNCTIONAL INTERFACE:
*    int rval = getProjectInfo( char *projectName, char *fileName );
*
*    $VER: GTBProject.c 1.2 (01-Nov-2004) by J.T. Steichen
********************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifndef   __amigaos4__

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct Library       *GadToolsBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct LocaleBase    *LocaleBase;

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *LocaleBase;
PUBLIC struct Library *GadToolsBase;

IMPORT struct DOSIFace       *IDOS;
IMPORT struct ExecIFace      *IExec;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct DiskfontIFace  *IDiskfont;
IMPORT struct LocaleIFace    *ILocale;
IMPORT struct UtilityIFace   *IUtility;

PUBLIC struct GadToolsIFace  *IGadTools;

#endif

#include <StringFunctions.h>

#include <proto/locale.h>

PUBLIC struct Catalog *catalog = NULL;

#define   CATCOMP_ARRAY    1
#include "GTBProjectLocale.h"

#define  MY_LANGUAGE "english"

#include <CommonFuncs.h>

#define AuthorStr      0
#define EMailStr       1
#define VersionStr     2
#define ProjectNameTxt 3
#define FileNameTxt    4
#define ASLChk         5
#define IconChk        6
#define ActiveScrChk   7
#define UnrollChk      8
#define ImageChk       9
#define PragmaChk      10
#define DoneBt         11

#define PI_CNT         12

#define AUTHOR_GAD     PIGadgets[ AuthorStr ]
#define EMAIL_GAD      PIGadgets[ EMailStr ]
#define VERSN_GAD      PIGadgets[ VersionStr ]

#define ASL_CHK_GAD       PIGadgets[ ASLChk ]
#define ICON_CHK_GAD      PIGadgets[ IconChk ]
#define ACTIVESCR_CHK_GAD PIGadgets[ ActiveScrChk ]
#define UNROLL_CHK_GAD    PIGadgets[ UnrollChk ]
#define IMAGE_CHK_GAD     PIGadgets[ ImageChk ]
#define PRAGMA_CHK_GAD    PIGadgets[ PragmaChk ]

#define AUTHOR_NAME    StrBfPtr( AUTHOR_GAD )
#define EMAIL_ADDR     StrBfPtr( EMAIL_GAD )
#define VERSION_STR    StrBfPtr( VERSN_GAD )

#ifndef  BUFF_SIZE
# define BUFF_SIZE 512
#endif

// ----------------------------------------------------------

PRIVATE struct Screen       *Scr = NULL;
PRIVATE UBYTE               *PubScreenName = (UBYTE *) "Workbench";
PRIVATE APTR                 VisualInfo = NULL;

PRIVATE struct Window       *PIWnd   = NULL;
PRIVATE struct Gadget       *PIGList = NULL;
PRIVATE struct TextFont     *Font    = NULL;
PRIVATE struct Gadget       *PIGadgets[ PI_CNT ] = { 0, };
PRIVATE struct IntuiMessage  PIMsg               = { 0, };

PRIVATE UWORD  PILeft   = 97;
PRIVATE UWORD  PITop    = 23;
PRIVATE UWORD  PIWidth  = 560;
PRIVATE UWORD  PIHeight = 330;
PRIVATE UBYTE *PIWdt    = NULL; // "AmigaTalk GTBScanner needs more Project information:";
PRIVATE UBYTE *ScrTitle = NULL; // "AmigaTalk GTBScanner 2003 by J.T. Steichen";

PRIVATE struct TextAttr helvetica13 = { "helvetica.font", 13, 0x00, 0x62 };

PRIVATE struct IntuiText PIIText = {

   2, 0, JAM1, 78, 150, &helvetica13, "Select which options you want:", NULL 
};

PRIVATE UWORD PIGTypes[] = {

   STRING_KIND,   STRING_KIND,   STRING_KIND,
   TEXT_KIND,     TEXT_KIND,     CHECKBOX_KIND,
   CHECKBOX_KIND, CHECKBOX_KIND, CHECKBOX_KIND,
   CHECKBOX_KIND, CHECKBOX_KIND, BUTTON_KIND
};

PRIVATE int AuthorStrClicked(    void );
PRIVATE int EMailStrClicked(     void );
PRIVATE int VersionStrClicked(   void );
PRIVATE int ASLChkClicked(       void );
PRIVATE int IconChkClicked(      void );
PRIVATE int ActiveScrChkClicked( void );
PRIVATE int UnrollChkClicked(    void );
PRIVATE int ImageChkClicked(     void );
PRIVATE int PragmaChkClicked(    void );
PRIVATE int DoneBtClicked(       void );

PRIVATE struct NewGadget PINGad[] = {

   138,  78, 350, 20, "Project Author:",       NULL, AuthorStr, 
   PLACETEXT_LEFT, NULL, (APTR) AuthorStrClicked,
   
   138, 103, 350, 20, "Project Author EMail:", NULL, EMailStr, 
   PLACETEXT_LEFT, NULL, (APTR) EMailStrClicked,
   
   138, 128, 130, 20, "Project Version:",      NULL, VersionStr, 
   PLACETEXT_LEFT, NULL, (APTR) VersionStrClicked,
   
   138,  28, 400, 20, "Project Name:",         NULL, ProjectNameTxt, 
   PLACETEXT_LEFT, NULL, NULL,
   
   138,  53, 400, 20, "Project FileName:",     NULL, FileNameTxt, 
   PLACETEXT_LEFT, NULL, NULL,

    78, 195,  26, 11, "ASL Support generation",   NULL, ASLChk, 
   PLACETEXT_RIGHT, NULL, (APTR) ASLChkClicked,
   
    78, 215,  26, 11, "Icon Support generation",  NULL, IconChk, 
   PLACETEXT_RIGHT, NULL, (APTR) IconChkClicked,
   
    78, 235,  26, 11, "Use Active Screen",        NULL, ActiveScrChk, 
   PLACETEXT_RIGHT, NULL, (APTR) ActiveScrChkClicked,
   
    78, 255,  26, 11, "Unroll Gadget Loop",       NULL, UnrollChk, 
   PLACETEXT_RIGHT, NULL, (APTR) UnrollChkClicked,
   
    78, 275,  26, 11, "Use BOOPSI getFile Image", NULL, ImageChk, 
   PLACETEXT_RIGHT, NULL, (APTR) ImageChkClicked,
   
    78, 295,  26, 11, "Include #pragmas",         NULL, PragmaChk, 
   PLACETEXT_RIGHT, NULL, (APTR) PragmaChkClicked,

   405, 295,  80, 26, "_DONE!", NULL, DoneBt, 
   PLACETEXT_IN, NULL, (APTR) DoneBtClicked
};

PRIVATE ULONG PIGTags[] = {

   GTST_MaxChars, BUFF_SIZE, GTST_String, (ULONG) "J.T. Steichen", TAG_DONE, // Free Advertising
   GTST_MaxChars, BUFF_SIZE, GTST_String, (ULONG) "jimbot@frontiernet.net", TAG_DONE,

   GTST_String, (ULONG) "1.0", GTST_MaxChars, 32, TAG_DONE,

   GTTX_Border, TRUE, TAG_DONE,
   GTTX_Border, TRUE, TAG_DONE,

   TAG_DONE,
   TAG_DONE,

   GTCB_Checked, TRUE, TAG_DONE,

   TAG_DONE,
   TAG_DONE,
   TAG_DONE,

   GT_Underscore, '_', TAG_DONE
};

// ---------------------------------------------------------------

/****i* CMsg() [1.0] *************************************************
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

PRIVATE STRPTR CMsg( int strIndex, char *defaultString )
{
   if (catalog && LocaleBase) // != NULL)
      return( (STRPTR) GetCatalogStr( catalog, strIndex, defaultString ) );
   else
      return( (STRPTR) defaultString );
}

/****i* SetupCatalog() [1.0] *****************************************
*
* NAME
*    SetupCatalog()
*
* DESCRIPTION
*    This is a test of the methods used to localize a program & is
*    not really necessary for the program since I never intend to
*    release this code for translations.
**********************************************************************
*
*/

PRIVATE int SetupCatalog( void )
{
   ScrTitle      = (UBYTE *) CMsg( MSG_GTBP_STITLE, MSG_GTBP_STITLE_STR );
   PIWdt         = (UBYTE *) CMsg( MSG_GTBP_WTITLE, MSG_GTBP_WTITLE_STR );

   PIIText.IText = CMsg( MSG_SELECT_CHKS, MSG_SELECT_CHKS_STR );
   
   // Gadget Labels:
   PINGad[AuthorStr     ].ng_GadgetText = CMsg( MSG_AUTH_GAD, MSG_AUTH_GAD_STR );
   PINGad[EMailStr      ].ng_GadgetText = CMsg( MSG_EMAL_GAD, MSG_EMAL_GAD_STR );
   PINGad[VersionStr    ].ng_GadgetText = CMsg( MSG_VERS_GAD, MSG_VERS_GAD_STR );
   PINGad[ProjectNameTxt].ng_GadgetText = CMsg( MSG_PNAM_GAD, MSG_PNAM_GAD_STR );

   PINGad[FileNameTxt   ].ng_GadgetText = CMsg( MSG_PFNM_GAD, MSG_PFNM_GAD_STR );
   PINGad[ASLChk        ].ng_GadgetText = CMsg( MSG_ASLS_GAD, MSG_ASLS_GAD_STR );
   PINGad[IconChk       ].ng_GadgetText = CMsg( MSG_ICON_GAD, MSG_ICON_GAD_STR );
   PINGad[ActiveScrChk  ].ng_GadgetText = CMsg( MSG_ACTV_GAD, MSG_ACTV_GAD_STR );
   PINGad[UnrollChk     ].ng_GadgetText = CMsg( MSG_UNRL_GAD, MSG_UNRL_GAD_STR );
   PINGad[ImageChk      ].ng_GadgetText = CMsg( MSG_BOOP_GAD, MSG_BOOP_GAD_STR );
   PINGad[PragmaChk     ].ng_GadgetText = CMsg( MSG_PRAG_GAD, MSG_PRAG_GAD_STR );
   PINGad[DoneBt        ].ng_GadgetText = CMsg( MSG_DONE_GAD, MSG_DONE_GAD_STR );

   return( 0 );
}

// ----------------------------------------------------------------

PRIVATE char newName[BUFF_SIZE] = { 0, };

PUBLIC void MassageFileName( char *fname )
{
   char *cp = NULL;
	
	// Added to insure that fname is ALWAYS valid!!
	if (!fname)
	   cp = "RAM:GTBDefaultProjectName.ini";
	else
	   cp = fname;
   
   while (*cp != '.' && *cp != '\0')
      cp++;
      
   if (*cp == '.')
      {
      if (StringNComp( cp, ".ini", 4 ) == 0)
         return;
      else
         {
         int  len = cp - fname, i = 0;
         
         for (i = 0; i < len; i++)
            newName[i] = fname[i];
            
         newName[i++] = '.';
         newName[i++] = 'i';
         newName[i++] = 'n';
         newName[i++] = 'i';

         StringNCopy( fname, &newName[0], BUFF_SIZE );

         return;          
         }
      }
   else
      {
      int  len = cp - fname, i = 0;
         
      for (i = 0; i < len; i++)
         newName[i] = fname[i];
            
      newName[i++] = '.';
      newName[i++] = 'i';
      newName[i++] = 'n';
      newName[i++] = 'i';

      StringNCopy( fname, &newName[0], BUFF_SIZE );      
      }
      
   return;
}

/****i* writeOutProjectInfo() [1.0] ****************************
*
* NAME
*    writeOutProjectInfo()
*
* DESCRIPTION
*    Take the information gathered by the GUI & update
*    the project file with it.
****************************************************************
*
*/

PRIVATE char  ProjectFile[BUFF_SIZE] = "";

PRIVATE char *ProjectName   = NULL;
PRIVATE char *authorName    = NULL;
PRIVATE char *authorEMail   = NULL;
PRIVATE char *versionString = NULL;

PRIVATE BOOL iconSupport    = FALSE;
PRIVATE BOOL aslSupport     = FALSE;
PRIVATE BOOL activeSupport  = FALSE;
PRIVATE BOOL imageSupport   = FALSE;
PRIVATE BOOL pragmaSupport  = FALSE;
PRIVATE BOOL unrollSupport  = FALSE;

PRIVATE int writeOutProjectInfo( void )
{
   FILE *out = MYNULL;

   MassageFileName( ProjectFile ); // Ensure an extension of .ini on FileName
   
   if (!(out = fopen( ProjectFile, "w" )))
      {
      char err[BUFF_SIZE] = { 0, };
      
      sprintf( err, CMsg( MSG_GTBP_FMT_NO_FILEOPEN, MSG_GTBP_FMT_NO_FILEOPEN_STR ),
                          ProjectFile 
             );

      UserInfo( err, CMsg( MSG_GTBP_SYSTEM_PROBLEM, MSG_GTBP_SYSTEM_PROBLEM_STR ) );
              
      return( IoErr() );
      }
   else
      {
      fprintf( out, "%s\n", CMsg( MSG_GRP_PDATATAGS, MSG_GRP_PDATATAGS_STR ) );
      
      // ------------- Now for the item Strings: -----------------------

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_NAME, 
                                   MSG_ITEM_PRJ_NAME_STR ), ProjectName );
         
      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_FILENAME, 
                                       MSG_ITEM_PRJ_FILENAME_STR ), ProjectFile );
         
      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_AUTHORNAME, 
                                   MSG_ITEM_PRJ_AUTHORNAME_STR ), authorName );
         
         
      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_AUTHOREMAIL, 
                                   MSG_ITEM_PRJ_AUTHOREMAIL_STR ), authorEMail );
         
      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_VERSION, 
                                   MSG_ITEM_PRJ_VERSION_STR ), versionString );
         
         
      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_ICONFLAG, 
                                       MSG_ITEM_PRJ_ICONFLAG_STR ),
                                 (iconSupport == TRUE ? "1" : "0" ) );
         

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_ASLFLAG, 
                                       MSG_ITEM_PRJ_ASLFLAG_STR ),
                                 (aslSupport == TRUE ? "1" : "0" ) );
         

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_SCRNFLAG, 
                                       MSG_ITEM_PRJ_SCRNFLAG_STR ),
                                 (activeSupport == TRUE ? "1" : "0" ) );
         

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_UNROLLFLAG, 
                                       MSG_ITEM_PRJ_UNROLLFLAG_STR ),
                                 (unrollSupport == TRUE ? "1" : "0" ) );
         

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_PRAGMAFLAG, 
                                       MSG_ITEM_PRJ_PRAGMAFLAG_STR ),
                                 (pragmaSupport == TRUE ? "1" : "0" ) );
         

      fprintf( out, "%s = %s\n", CMsg( MSG_ITEM_PRJ_GENIMAGE, 
                                       MSG_ITEM_PRJ_GENIMAGE_STR ),
                                 (imageSupport == TRUE ? "1" : "0" ) );
         
      fclose( out );
      }
         
   return( RETURN_OK );
}

// ----------------------------------------------------------------

PRIVATE BOOL UnlockFlag = FALSE;

PRIVATE int SetupScreen( void )
{
   struct Screen *chk = GetActiveScreen();

   if (!(Font = OpenDiskFont( &helvetica13 )))
      return( -5 );

   if (!(Scr = LockPubScreen( (STRPTR) PubScreenName )))
      return( -1 );

   if (chk != Scr)
      {
      UnlockPubScreen( NULL, Scr );
      Scr        = chk;
      UnlockFlag = FALSE;      
      }
   else
      UnlockFlag = TRUE;

   if (!(VisualInfo = GetVisualInfo( Scr, TAG_DONE )))
      return( -2 );

   return( 0 );
}

PRIVATE void CloseDownScreen( void )
{
   if (VisualInfo)
      {
      FreeVisualInfo( VisualInfo );
      VisualInfo = NULL;
      }

   if ((UnlockFlag == TRUE) && Scr)
      {
      UnlockPubScreen( NULL, Scr );
      Scr = NULL;
      }

   if (Font)
      {
      CloseFont( Font );
      Font = NULL;
      }

   return;
}

PRIVATE void ClosePIWindow( void )
{
   if (PIWnd)
      {
      CloseWindow( PIWnd );
      PIWnd = NULL;
      }

   if (PIGList)
      {
      FreeGadgets( PIGList );
      PIGList = NULL;
      }
      
   return;
}

// --------------------------------------------------------------------

PRIVATE int AuthorStrClicked( void )
{
   if (StringLength( AUTHOR_NAME ) > 0)
      {
      authorName = AUTHOR_NAME;
      }
      
   return( TRUE );
}

PRIVATE int EMailStrClicked( void )
{
   if (StringLength( EMAIL_ADDR ) > 0)
      {
      authorEMail = EMAIL_ADDR;
      }

   return( TRUE );
}

PRIVATE int VersionStrClicked( void )
{
   if (StringLength( VERSION_STR ) > 0)
      {
      versionString = VERSION_STR;
      }

   return( TRUE );
}

PRIVATE int ASLChkClicked( void )
{
   if ((ASL_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( ASL_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      aslSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( ASL_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      aslSupport = FALSE;
      }
      
   return( TRUE );
}

PRIVATE int IconChkClicked( void )
{
   if ((ICON_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( ICON_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      iconSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( ICON_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      iconSupport = FALSE;
      }
      
   return( TRUE );
}

PRIVATE int ActiveScrChkClicked( void )
{
   if ((ACTIVESCR_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( ACTIVESCR_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      activeSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( ACTIVESCR_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      activeSupport = FALSE;
      }

   return( TRUE );
}

PRIVATE int UnrollChkClicked( void )
{
   if ((UNROLL_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( UNROLL_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      unrollSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( UNROLL_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      unrollSupport = FALSE;
      }
      
   return( TRUE );
}

PRIVATE int ImageChkClicked( void )
{
   if ((IMAGE_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( IMAGE_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      imageSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( IMAGE_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      imageSupport = FALSE;
      }
      
   return( TRUE );
}

PRIVATE int PragmaChkClicked( void )
{
   if ((PRAGMA_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      {
      GT_SetGadgetAttrs( PRAGMA_CHK_GAD, PIWnd, NULL, GTCB_Checked, TRUE, TAG_DONE );

      pragmaSupport = TRUE;
      }
   else
      {
      GT_SetGadgetAttrs( PRAGMA_CHK_GAD, PIWnd, NULL, GTCB_Checked, FALSE, TAG_DONE );

      pragmaSupport = FALSE;
      }

   return( TRUE );
}

PRIVATE int DoneBtClicked( void )
{
   if (StringLength( AUTHOR_NAME ) < 1)
      {
      UserInfo( CMsg( MSG_GTBP_NEED_AUTHOR, MSG_GTBP_NEED_AUTHOR_STR ),
                CMsg( MSG_GTBP_USER_ERROR,  MSG_GTBP_USER_ERROR_STR  ) 
              );
      
      return( TRUE );
      }
   else
      {
      // Copy String gadget contents to global variables:  
      (void) AuthorStrClicked();
      (void) EMailStrClicked();
      (void) VersionStrClicked();
      
      if (writeOutProjectInfo() != RETURN_OK)
         {
         UserInfo( CMsg( MSG_GTBP_FILE_WRITE_ERR, MSG_GTBP_FILE_WRITE_ERR_STR ),
                   CMsg( MSG_GTBP_SYSTEM_PROBLEM, MSG_GTBP_SYSTEM_PROBLEM_STR  ) 
                 );
         }
      }
            
   ClosePIWindow();
     
   return( FALSE );
}

PRIVATE int PIVanillaKey( int whichKey )
{
   int rval = TRUE;
   
   switch (whichKey)
      {
      case 'd':
      case 'D':
         rval = DoneBtClicked();
         break;
      }
      
   return( rval );
}

// --------------------------------------------------------------------

PRIVATE void PIRender( void )
{
   UWORD offx, offy;

   offx = PIWnd->BorderLeft;
   offy = PIWnd->BorderTop;

   DrawBevelBox( PIWnd->RPort, offx + 30, offy + 140, 
                 285, 155, GT_VisualInfo, VisualInfo, TAG_DONE 
               );

   PrintIText( PIWnd->RPort, &PIIText, offx, offy );

   // Why is this necessary??
   SetWindowTitles( PIWnd, CMsg( MSG_GTBP_WTITLE, MSG_GTBP_WTITLE_STR ),
                           CMsg( MSG_GTBP_STITLE, MSG_GTBP_STITLE_STR ) 
                  );
   return;
}

PRIVATE int OpenPIWindow( void )
{
   struct NewGadget  ng;
   struct Gadget    *g;
   UWORD             lc, tc;
   UWORD             wl, wt;

   wl = (Scr->Width  - PIWidth ) / 2;
   wt = (Scr->Height - PIHeight) / 2;
   
   if (!(g = CreateContext( &PIGList )))
      return( -1 );

   for (lc = 0, tc = 0; lc < PI_CNT; lc++) 
      {
      CopyMem( (char *) &PINGad[ lc ], (char *) &ng, 
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = &helvetica13;

      PIGadgets[ lc ] = g 
                      = CreateGadgetA( (ULONG) PIGTypes[ lc ], 
                                       g, 
                                       &ng, 
                                       (struct TagItem *) &PIGTags[ tc ]
                                     );

      while (PIGTags[ tc ] != TAG_DONE) 
         tc += 2;

      tc++;

      if (!g)
         return( -2 );
      }

   if (!(PIWnd = OpenWindowTags( NULL,
   
            WA_Left,         wl,
            WA_Top,          wt,
            WA_Width,        PIWidth,
            WA_Height,       PIHeight,

            WA_IDCMP,        STRINGIDCMP | TEXTIDCMP | CHECKBOXIDCMP
              | BUTTONIDCMP | IDCMP_VANILLAKEY | IDCMP_REFRESHWINDOW,

            WA_Flags,        WFLG_DRAGBAR | WFLG_DEPTHGADGET
              | WFLG_SMART_REFRESH | WFLG_ACTIVATE | WFLG_RMBTRAP,

            WA_Gadgets,      PIGList,
            WA_Title,        PIWdt,
            WA_CustomScreen, Scr,
            WA_ScreenTitle,  ScrTitle,
            TAG_DONE )))
      {
      return( -4 );
      }

   GT_RefreshWindow( PIWnd, NULL );

   PIRender();

   return( 0 );
}

PRIVATE int HandlePIIDCMP( void )
{
   struct IntuiMessage  *m;
   int                 (*func)( void );
   BOOL                  running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( PIWnd->UserPort )))
         {
         (void) Wait( 1L << PIWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &PIMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (PIMsg.Class) 
         {
         case   IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( PIWnd );
            PIRender();
            GT_EndRefresh( PIWnd, TRUE );
            break;

         case   IDCMP_VANILLAKEY:
            running = PIVanillaKey( PIMsg.Code );
            break;

         case   IDCMP_GADGETUP:
            if ((func = (int (*) ( void )) ((struct Gadget *) PIMsg.IAddress )->UserData))
               running = func();
            
            break;
         }
      }
   
   return( running );
}

PRIVATE void ShutdownProgram( void )
{
   ClosePIWindow();
   CloseDownScreen();

   if (catalog)                // catalog can be NULL!
      CloseCatalog( catalog );

#  ifdef __amigaos4__
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );
      
   if (GadToolsBase)
      CloseLibrary( GadToolsBase );
#  endif

   return;   
}

PRIVATE int setupErrorNum = RETURN_OK;

PRIVATE int SetupProgram( void )
{
#  ifdef __amigaos4__
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
	 CloseLibrary( GadToolsBase );
	 
	 return( -1 );
	 }
      }
   else
      return( -1 );
#  endif
      
   if (SetupScreen() < 0)
      {
      ShutdownProgram();

      setupErrorNum = ERROR_ON_OPENING_SCREEN;
      
      return( -5 );
      }   

   if (OpenPIWindow() < 0)
      {
      ShutdownProgram();

      setupErrorNum = ERROR_ON_OPENING_WINDOW;
      
      return( -6 );
      }   

   // NULL is for the Locale (from OpenLocale()): 
   catalog = OpenCatalog( (struct Locale *) NULL, "gtbproject.catalog",
                                                  OC_BuiltInLanguage, MY_LANGUAGE,
                                                  TAG_DONE 
                        );

   (void) SetupCatalog();

   return( 0 );
}

SUBFUNC void setupChkFlags( void )
{
   if ((ICON_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      iconSupport = TRUE;
   else
      iconSupport = FALSE;
   
   if ((ASL_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      aslSupport = TRUE;
   else
      aslSupport = FALSE;
   
   if ((ACTIVESCR_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      activeSupport = TRUE;
   else
      activeSupport = FALSE;
   
   if ((IMAGE_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      imageSupport = TRUE;
   else
      imageSupport = FALSE;
   
   if ((PRAGMA_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      pragmaSupport = TRUE;
   else
      pragmaSupport = FALSE;
   
   if ((UNROLL_CHK_GAD->Flags & GFLG_SELECTED) != FALSE)
      unrollSupport = TRUE;
   else
      unrollSupport = FALSE;
   
   return;
}

PUBLIC int getProjectInfo( char *projectName, char *fileName )
{
   int rval = RETURN_OK;
   
   if (SetupProgram() < 0)
      {
      fprintf( stderr, CMsg( MSG_GTBP_FMT_NOGUI_ERR, MSG_GTBP_FMT_NOGUI_ERR_STR ),
                       setupErrorNum
             );

      return( setupErrorNum );
      }

   SetNotifyWindow( PIWnd );

   StringNCopy( ProjectFile, fileName, 511 );

   ProjectName = projectName;
      
   GT_SetGadgetAttrs( PIGadgets[ ProjectNameTxt ], PIWnd, NULL, 
                      GTTX_Text, projectName, TAG_DONE 
                    );
      
   GT_SetGadgetAttrs( PIGadgets[ FileNameTxt ], PIWnd, NULL, 
                      GTTX_Text, fileName, TAG_DONE 
                    );

   setupChkFlags();
      
   (void) HandlePIIDCMP();
   
   SetNotifyWindow( GetActiveWindow() );

   ShutdownProgram();
   
   return( rval );
}

/* ------------- END of GTBProject file! ------------------- */
