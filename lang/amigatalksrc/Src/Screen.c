/****h* AmigaTalk/Screen.c [3.0] **************************************
*
* NAME
*    Screen.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk screen primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
*    13-Jan-2002 - Added OpenScreenWithTags() function.  Worked over
*                  the entire file to remove AList stuff.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleScreens( int numargs, OBJECT **args ); <180>
*
* NOTES
*    $VER: AmigaTalk:Src/.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <graphics/displayinfo.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/graphics_protos.h>

#else

# define __USE_INLINE__

# include <proto/graphics.h>
# include <proto/intuition.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "IStructs.h"

#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;

IMPORT UBYTE  *ErrMsg;

IMPORT UBYTE  *ATalkProblem;
IMPORT UBYTE  *SystemProblem;
IMPORT UBYTE  *UserPgmError;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );

IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT struct Screen *FindScreenPtr( char *screentitle );

// -------------------------------------------------------------------

PUBLIC char *ScrErrStrs[ 12 ] = { NULL, }; // VIsible to CatalogScreen();

/****i* ScreenErrStr() [1.0] *****************************************
*
* NAME
*    ScreenErrStr()
*
* DESCRIPTION
*    Translate the vaule from SA_ErrorCode into a string.
**********************************************************************
*
*/

SUBFUNC char *ScreenErrStr( int errnum )
{
   char *rval = NULL;
   
   switch (errnum)
      {
      case OSERR_NOMONITOR:
      case OSERR_NOCHIPS:
      case OSERR_NOMEM:
      case OSERR_NOCHIPMEM:
      case OSERR_PUBNOTUNIQUE:
      case OSERR_UNKNOWNMODE:
      case OSERR_TOODEEP:
      case OSERR_ATTACHFAIL:
      case OSERR_NOTAVAILABLE:
         rval = ScrErrStrs[ errnum ];
         break;
      
      default:
         rval = ScrErrStrs[0];
         break;   
      }

   return( rval );
}

/****i* TranslateScreenErrStr() [1.9] ********************************
*
* NAME
*    TranslateScreenErrStr()
*
* DESCRIPTION
*    Translate the vaule from SA_ErrorCode into a string.
*    ^ <primitive 180 10 errNumber>
**********************************************************************
*
*/

METHODFUNC OBJECT *TranslateScreenErrStr( int errnum )
{
   return( new_str( ScreenErrStr( errnum ) ) );
}

/****i* CloseAScreen() [1.0] *****************************************
*
* NAME
*    CloseAScreen()
*
* DESCRIPTION
*    Close the screen & remove it from AmigaTalk program space.
*    <primitive 180 0 private>
**********************************************************************
*
*/

METHODFUNC void CloseAScreen( struct Screen *sptr )
{
   char *screentitle = sptr->Title;
      
   if (CloseScreen( sptr ) == FALSE)
      {
      sprintf( ErrMsg, ScrnCMsg( MSG_NO_CLOSE_SCRN ), screentitle );

      UserInfo( ErrMsg, SystemProblem );
         
      return;
      }
         
   sptr = NULL;

   return;
}

PRIVATE struct NewScreen hidden_ns = {

   0, 0, 640, 480, 4, 0, 1,
   HIRES, CUSTOMSCREEN, NULL, NULL,
   NULL, NULL
};

/****i* CopyDefaultScreen() [1.0] ************************************
*
* NAME
*    CopyDefaultScreen()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void CopyDefaultScreen( struct NewScreen *newscrn )
{
   CopyMem( (char *) &hidden_ns, (char *) newscrn, 
            (long) sizeof( struct NewScreen )
          );

   return;
}

/****i* ReOpenScreen() [1.0] *****************************************
*
* NAME
*    ReOpenScreen()
*
* DESCRIPTION
*    Re-open the screen with the new parameters.  The parameters were
*    set by calls to <primitive 180 3 x x 'ScreenTitle'>, which sets
*    the hidden_ns NewScreen structure fields. 
*    CopyDefaultScreen copies the hidden_ns structure into the 
*    passed screentitle.
**********************************************************************
*
*/

METHODFUNC OBJECT *ReOpenScreen( char *screentitle )
{
   struct Screen    *sptr = FindScreenPtr( screentitle );
   struct NewScreen  newscr;
   OBJECT           *rval = o_nil;
   
   if (sptr) // != NULL) 
      {      
      // Re-open the screen with the new parameters.  The parameters were
      // set by calls to <primitive 180 3 x x 'ScreenTitle'>, which sets
      // the hidden_ns NewScreen structure fields. CopyDefaultScreen copies
      // the hidden_ns structure into newscr:

      CopyDefaultScreen( &newscr );

      CloseScreen( sptr );

      if (!(sptr = (struct Screen *) OpenScreen( &newscr ))) // == NULL)
         return( rval );

      rval = AssignObj( new_address( (ULONG) sptr ) );
      }

   return( rval );   
}

/****i* OpenAScreen() [2.5] ******************************************
*
* NAME
*    OpenAScreen()
*
* DESCRIPTION
*    ^ private <- <180 1 screenModeID screenTitle>
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenAScreen( int type, char *screentitle )
{
   struct Screen     *sptr   = FindScreenPtr( screentitle );
   struct NewScreen   newscr;
   struct DisplayInfo buf;
   int                errnum = 0;
   OBJECT            *rval   = o_nil;
   
   if (GetDisplayInfoData( NULL, (UBYTE *) &buf, 
                           sizeof( struct DisplayInfo ), 
                           DTAG_DISP, type ) == 0)
      {
      sprintf( ErrMsg, ScrnCMsg( MSG_MODE_NOT_FOUND_SCRN ), type );

      UserInfo( ErrMsg, UserPgmError );
   
      return( rval );
      }

   hidden_ns.DefaultTitle = screentitle; // why we need newscr.

   if (sptr) // != NULL)
      {
      AlreadyOpen( screentitle );
      
      return( rval = AssignObj( new_address( (ULONG) sptr ) ) );
      }
   else
      {
      struct DimensionInfo di;

/*
struct DimensionInfo {

   UWORD  MaxDepth;	        // log2( max number of colors )
   UWORD  MinRasterWidth;       // minimum width in pixels
   UWORD  MinRasterHeight;      // minimum height in pixels
   UWORD  MaxRasterWidth;       // maximum width in pixels
   UWORD  MaxRasterHeight;      // maximum height in pixels
   
   struct Rectangle Nominal;    // "standard" dimensions
   struct Rectangle MaxOScan;   // fixed, hardware dependent
   struct Rectangle VideoOScan; // fixed, hardware dependent
   struct Rectangle TxtOScan;   // editable via preferences
   struct Rectangle StdOScan;   // editable via preferences
};
*/
      if (GetDisplayInfoData( NULL, (UBYTE *) &di, 
                              sizeof( struct DimensionInfo ), 
                              DTAG_DIMS, type ) == 0)
         {
         sprintf( ErrMsg, ScrnCMsg( MSG_MODE_NOT_FOUND_SCRN ), type );

         UserInfo( ErrMsg, UserPgmError );
   
         return( rval );
         }

      hidden_ns.Depth  = di.MaxDepth; 
      hidden_ns.Width  = di.Nominal.MaxX; // di.MaxRasterWidth;
      hidden_ns.Height = di.Nominal.MaxY; // di.MaxRasterHeight;
       
      CopyDefaultScreen( &newscr );

      sptr = OpenScreenTags( &newscr,
                             SA_ErrorCode, &errnum,
                             SA_DisplayID, type,
                             TAG_END
                           );
      if (sptr) // != NULL)
         return( rval = AssignObj( new_address( (ULONG) sptr ) ) );
      else
         {
         sprintf( ErrMsg, ScrnCMsg( MSG_UNOPENED_SCRN ), 
	                  ScreenErrStr( errnum )
                );
         
         NotOpened( 0 );
         
         return( rval );
         }
      }

   return( rval );  
}

/****i* GetScreenPart() [1.0] ****************************************
*
* NAME
*    GetScreenPart()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *GetScreenPart( int whichpart, struct Screen *sc )
{
   OBJECT *rval = o_nil;
   
   if (whichpart > 23 || whichpart < 0)
      return( rval );

   switch (whichpart)
      {
      case 0:
         rval = AssignObj( new_int( sc->LeftEdge ) );
         break;
         
      case 1:
         rval = AssignObj( new_int( sc->TopEdge ) );
         break;
         
      case 2:
         rval = AssignObj( new_int( sc->Width ) );
         break;
         
      case 3:
         rval = AssignObj( new_int( sc->Height ) );
         break;
         
      case 4:
         rval = AssignObj( new_int( sc->DetailPen ) );
         break;
         
      case 5:
         rval = AssignObj( new_int( sc->BlockPen ) );
         break;
         
      case 6:
         rval = AssignObj( new_int( sc->Flags ) );
         break;

      case 7:
         rval = AssignObj( new_str( sc->Font->ta_Name ) );
         break;
         
      case 8:
         rval = AssignObj( new_str( sc->Title ) );
         break;
         
      case 9:
         {
         struct DrawInfo *di = GetScreenDrawInfo( sc );

         if (di) // != NULL)
            rval = AssignObj( new_int( di->dri_Depth ) );
         else
            rval = AssignObj( new_int( 0 ) );
         }
         
         break;

      case 10:
         rval = AssignObj( new_int( GetVPModeID( &(sc->ViewPort) ) ) );
         break;

      case 11: 
         rval = AssignObj( new_int( sc->ViewPort.Modes ) );
         break;

      case 12:
         rval = AssignObj( new_address( (ULONG) &sc->BitMap ) );
         break;

      case 13:
         rval = AssignObj( new_address( (ULONG) sc->Font ) );
         break;
         
      case 14: // getBarHeightSize (added on 27-Feb-2002):
         rval = AssignObj( new_int( (int) sc->BarHeight ) );
         break;
         
      case 15: // getBarVBorderSize
         rval = AssignObj( new_int( (int) sc->BarVBorder ) );
         break;
         
      case 16: // getBarHBorderSize
         rval = AssignObj( new_int( (int) sc->BarHBorder ) );
         break;
         
      case 17: // getMenuVBorderSize
         rval = AssignObj( new_int( (int) sc->MenuVBorder ) );
         break;
         
      case 18: // getMenuHBorderSize
         rval = AssignObj( new_int( (int) sc->MenuHBorder ) );
         break;
         
      case 19: // getWBorTopSize
         rval = AssignObj( new_int( (int) sc->WBorTop ) );
         break;
         
      case 20: // getWBorLeftSize
         rval = AssignObj( new_int( (int) sc->WBorLeft ) );
         break;
         
      case 21: // getWBorRightSize
         rval = AssignObj( new_int( (int) sc->WBorRight ) );
         break;
         
      case 22: // getWBorBottomSize
         rval = AssignObj( new_int( (int) sc->WBorBottom ) );
         break;
         
      case 23: // getUserData
         rval = AssignObj( new_address( (ULONG) sc->UserData ) );
         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* SetScreenPart() [1.0] ****************************************
*
* NAME
*    SetScreenPart()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void SetScreenPart( int whichpart, OBJECT *whatvalue )
{
   if (whichpart > 12 || whichpart < 0)
      return;

   switch (whichpart)
      {
      case 0:  
         hidden_ns.LeftEdge  = int_value( whatvalue );
         break;

      case 1:
         hidden_ns.TopEdge   = int_value( whatvalue );
         break;

      case 2:
         hidden_ns.Width     = int_value( whatvalue );
         break;

      case 3:
         hidden_ns.Height    = int_value( whatvalue );
         break;

      case 4:
         hidden_ns.DetailPen = int_value( whatvalue );
         break;

      case 5:
         hidden_ns.BlockPen  = int_value( whatvalue );
         break;

      case 6:
         hidden_ns.Type      = int_value( whatvalue );
         break;

      case 9:
         hidden_ns.Depth     = int_value( whatvalue );
         break;

      case 10:
         hidden_ns.ViewModes = int_value( whatvalue );
         break;

      case 11:
         hidden_ns.Type      = int_value( whatvalue );
         break;
         
      case 7:
         {
         struct TextAttr *ta = (struct TextAttr *) CheckObject( whatvalue );
         
         hidden_ns.Font = ta; // NULL is valid for ta 
         }
         
         break;
         
      case 8:
         hidden_ns.DefaultTitle = string_value( (STRING *) whatvalue );
         break;
         
      case 12:
         {
         struct BitMap *bm = (struct BitMap *) CheckObject( whatvalue );
         
         hidden_ns.CustomBitMap = bm; // NULL is valid for bm.
         }

         break;
         
      default:
         break;
      }

   return;
}

PRIVATE char  *ScreenFuncs[5] = {
      
   "DisplayBeep", "ScreenToBack", "ScreenToFront", "TurnOffTitle",
   "ShowTitle"
};
   
/****i* ExecScreenFunc() [1.0] ***************************************
*
* NAME
*    ExecScreenFunc()
*
* DESCRIPTION
*
**********************************************************************
*
*/
   
METHODFUNC void ExecScreenFunc( char *FuncName, struct Screen *sc )
{
   int whichfunc = 0;
   
   while (whichfunc < 5)
      if (StringComp( ScreenFuncs[ whichfunc ], FuncName ) == 0)
         break;
      else
         whichfunc++;
   
   switch (whichfunc)
      {
      case 0:  DisplayBeep( sc );
               break;
      case 1:  ScreenToBack( sc );
               break;
      case 2:  ScreenToFront( sc );
               break;
      case 3:  ShowTitle( sc, FALSE );
               break;
      case 4:  ShowTitle( sc, TRUE );
               break;
      }

   return;
}

/****i* PullScreenUp() [1.0] *****************************************
*
* NAME
*    PullScreenUp()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void PullScreenUp( int num_lines, struct Screen *sc )
{
   if ((-num_lines) > sc->Height)
      num_lines = -sc->Height;

   if (sc->TopEdge == 0)
      num_lines = 0;

   MoveScreen( sc, 0, num_lines );

   return;
}

/****i* PushScreenDown() [1.0] ***************************************
*
* NAME
*    PushScreenDown()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void PushScreenDown( int num_lines, struct Screen *sc )
{
   if (num_lines > sc->Height)
      num_lines = sc->Height;

   if (sc->TopEdge > 0)
      num_lines -= sc->TopEdge;

   MoveScreen( sc, 0, num_lines );

   return;
}

/****i* RedrawScreen() [1.0] *****************************************
*
* NAME
*    RedrawScreen()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void  RedrawScreen( struct Screen *sc )
{
   MakeScreen( sc );
   RethinkDisplay();

   return;
}

/****i* OpenScreenWithTags() [1.9] ***********************************
*
* NAME
*    OpenScreenWithTags()
*
* DESCRIPTION
*    ^ <primitive 180 9 tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenScreenWithTags( OBJECT *tagArray )
{
   IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

   OBJECT         *rval = o_nil;
   struct TagItem *tags = NULL;
   struct Screen  *scrn = NULL;

   if (NullChk( tagArray ) == TRUE)
      return( rval );
         
   if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
      return( rval ); // Probably an error by the User.
      
   if ((scrn = OpenScreenTagList( NULL, tags ))) // != NULL)
      {
      rval = AssignObj( new_address( (ULONG) scrn ) );
      }
      
   if (tags) // != NULL)   
      AT_FreeVec( tags, "screenTags", TRUE );
   
   return( rval );
}

/****i* lockPublicScreen() [2.0] *************************************
*
* NAME
*    lockPublicScreen()
*
* DESCRIPTION
*    ^ <primitive 180 11 screenName>
**********************************************************************
*
*/

METHODFUNC OBJECT *lockPublicScreen( OBJECT *scrName )
{
   char *title = (char *) CheckObject( scrName );
   
   if (scrName != o_nil && title) // != NULL)
      return( AssignObj( new_address( (ULONG) LockPubScreen( title ) ) ) );
   else
      return( AssignObj( new_address( (ULONG) LockPubScreen( NULL ) ) ) );
}

/****i* unlockPublicScreen() [2.0] ***********************************
*
* NAME
*    unlockPublicScreen()
*
* DESCRIPTION
*    <primitive 180 12 screenName screenObject>
**********************************************************************
*
*/

METHODFUNC void unlockPublicScreen( char *scrName, OBJECT *scrObj )
{
   struct Screen *scr = (struct Screen *) CheckObject( scrObj );
   
   if (scr && scrName) // != NULL)
      UnlockPubScreen( scrName, scr );
   else if (scr) // != NULL)
      UnlockPubScreen( NULL, scr );
      
   return;
}

/****i* getScrVisualInfo() [2.0] *************************************
*
* NAME
*    getScrVisualInfo()
*
* DESCRIPTION
*    getVisualInfo: tagArray [private]   " tagArray can be nil "
*       ^ <primitive 180 13 tagArray screenObject>
**********************************************************************
*
*/

METHODFUNC OBJECT *getScrVisualInfo( OBJECT *tagArray, OBJECT *scrObj )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct Screen  *scr  = (struct Screen  *) CheckObject( scrObj );
   APTR            vi   =             (APTR) NULL;
   OBJECT         *rval = o_nil;
   
   if (!scr) // == NULL)
      return( o_nil );
         
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   if (tags) // != NULL)
      {
      if ((vi = GetVisualInfoA( scr, tags ))) // != NULL)
         rval = (vi == (APTR) NULL) ? AssignObj( new_address( 0 ) ) 
                                    : AssignObj( new_address( (ULONG) vi ) );
      }
   else
      {
      if ((vi = GetVisualInfoA( scr, TAG_DONE ))) // != NULL)
         rval = (vi == NULL) ? AssignObj( new_address( 0  ) ) 
                             : AssignObj( new_address( (ULONG) vi ) );
      }

   if (tags) // != NULL)
      FreeVec( tags ); // AT_FreeVec( tags, "visualInfoTags", TRUE );
   
   return( rval );
}

/****i* disposeVisualInfo() [2.0] ************************************
*
* NAME
*    disposeVisualInfo()
*
* DESCRIPTION
*    disposeVisualInfo: viObj
*       <primitive 180 14 viObj>
**********************************************************************
*
*/

METHODFUNC void disposeVisualInfo( OBJECT *viObj )
{
   APTR vi = NULL;
   
   if (NullChk( viObj ) == FALSE)
      vi = (APTR) addr_value( viObj );
   else
      return;
         
   if (vi) // != NULL)
      FreeVisualInfo( vi );
      
   return;
}

/*
VOID   FreeScreenDrawInfo( struct Screen *screen, struct DrawInfo *drawInfo );
struct DrawInfo *GetScreenDrawInfo( struct Screen *screen );

struct ScreenBuffer *AllocScreenBuffer( struct Screen *sc, struct BitMap *bm, ULONG flags );
VOID   FreeScreenBuffer( struct Screen *sc, struct ScreenBuffer *sb );
ULONG  ChangeScreenBuffer( struct Screen *sc, struct ScreenBuffer *sb );

VOID   ScreenDepth( struct Screen *screen, ULONG flags, APTR reserved );
VOID   ScreenPosition( struct Screen *screen, ULONG flags, LONG x1, LONG y1, LONG x2, LONG y2);
LONG   GetScreenData( APTR buffer, ULONG size, ULONG type, CONST struct Screen *screen );

struct List *LockPubScreenList( VOID );
VOID   UnlockPubScreenList( VOID );

STRPTR NextPubScreen( CONST struct Screen *screen, STRPTR namebuf );
VOID   SetDefaultPubScreen( CONST_STRPTR name );
UWORD  SetPubScreenModes( ULONG modes );
UWORD  PubScreenStatus( struct Screen *screen, ULONG statusFlags );
VOID   GetDefaultPubScreen( STRPTR nameBuffer );
*/

/****h* HandleScreens() [1.9] ****************************************
*
* NAME
*    HandleScreens()
*
* DESCRIPTION
*    Translate primitive 180 calls to Screen handler functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleScreens( int numargs, OBJECT **args )
{
   struct Screen *sptr = NULL;
   OBJECT        *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 180 );
      return( rval );
      }
         
   sptr = (struct Screen *) CheckObject( args[1] );

   switch (int_value( args[0] ))
      {
      case 0: // <primitive 180 0 private> 
         if (sptr == NULL)
            (void) PrintArgTypeError( 180 );
         else
            {
            CloseAScreen( sptr );
            }

         break;
      
      case 1: // private <- <primitive 180 1 modeID savedTitle>
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 180 );
         else
            rval = OpenAScreen( int_value(               args[1] ), 
                                string_value( (STRING *) args[2] )
                              );
         break;
      
      case 2: // <primitive 180 2 partNum private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            {
            if ((sptr = (struct Screen *) CheckObject( args[2] )) != NULL)
               rval = GetScreenPart( int_value( args[1] ), sptr );
            }

         break;

      case 3: // <primitive 180 3 partNum valueObj>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            SetScreenPart( int_value( args[1] ), args[2] );

         break;
      
      case 4: // <primitive 180 4 'function' private>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            {
            if ((sptr = (struct Screen *) CheckObject( args[2] )) != NULL)
               ExecScreenFunc( string_value( (STRING *) args[1] ), sptr );
            }
               
         break;
  
      case 5: // <primitive 180 5 numLines private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            {
            if ((sptr = (struct Screen *) CheckObject( args[2] )) != NULL)
               PullScreenUp( int_value( args[1] ), sptr );
            }

         break;
  
      case 6: // <primitive 180 6 numLines private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            {
            if ((sptr = (struct Screen *) CheckObject( args[2] )) != NULL)
               PushScreenDown( int_value( args[1] ), sptr );
            }

         break;
      
      case 7: // <primitive 180 7 private>
         if (!sptr) // == NULL)
            (void) PrintArgTypeError( 180 );
         else
            RedrawScreen( sptr );

         break;

      case 8: // private <- <primitive 180 8 savedTitle>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            rval = ReOpenScreen( string_value( (STRING *) args[1] ) );

         break;

      case 9: // openScreenWithTags: tagArray
         if (is_array( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            rval = OpenScreenWithTags( args[1] );

         break;

      case 10: // TranslateScreenErrStr( int errnum )
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 180 );
         else
            TranslateScreenErrStr( int_value( args[1] ) );

         break;

      case 11: // lockPublicScreen: screenName (can be nil)
         rval = lockPublicScreen( args[1] );
         
         break;

      case 12: // unlockPublicScreen: screenObject named: screenName (can be nil)
         unlockPublicScreen( string_value( (STRING *) args[1] ), args[2] );
         break;

      case 13: // getVisualInfo: tagArray [private] " tagArray can be nil "
         rval = getScrVisualInfo( args[1], args[2] );
         break;

      case 14: // disposeVisualInfo: viObj <primitive 180 14 viObj>
         disposeVisualInfo( args[1] );

         break;
         
      default:
         (void) PrintArgTypeError( 180 );
         break;
      }

   return( rval );
}

/* ------------------ END of Screen.c file! --------------------------- */
