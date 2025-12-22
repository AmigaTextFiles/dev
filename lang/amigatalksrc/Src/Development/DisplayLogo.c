/****** AmigaTalk/DisplayLogo.c [2.0] **********************************
*
* NAME
*    DisplayLogo.c
*
* HISTORY
*    06-Nov-2004 - Added AmigaOS4 & gcc support.
*
*    07-Dec-2001 - Added code to center the display in the Screen.
*
* NOTES
*   1. The user calls this program via:
*
*      forkl( CommandPath/"DisplayLogo", 
*             CommandPath/"DisplayLogo", 
*             LogoName, ScreenName, NULL, &env, &procid 
*           );
*
*   2. The user kills this program via:
*
*       mainproc = (struct Process *) FindTask( 0L );
*       mainport = &mainproc->pr_MsgPort; 
*       PutMsg( procid.child );
*       wait( &procid );
*
*   3. Derived from dtimage.c 1.1 (17.3.97) in 
*      CData:DataType/datatypes_library/Examples/dtimage/
*      Written 1996/97 by Roland 'Gizzy' Mainz
*
*   $VER: DisplayLogo 2.0 (06-Nov-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <assert.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <exec/memory.h>
#include <exec/libraries.h>

#include <dos/dos.h>
#include <dos/stdio.h>

#include <graphics/gfx.h>
#include <graphics/displayinfo.h>

#include <intuition/intuition.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <datatypes/datatypes.h>
#include <datatypes/datatypesclass.h>
#include <datatypes/pictureclass.h>

#ifndef __amigaos4__

# include <clib/macros.h>
# include <clib/alib_protos.h>
# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/graphics_protos.h>
# include <clib/intuition_protos.h>
# include <clib/datatypes_protos.h>

# include <pragmas/exec_pragmas.h>
# include <pragmas/dos_pragmas.h>
# include <pragmas/graphics_pragmas.h>
# include <pragmas/intuition_pragmas.h>
# include <pragmas/datatypes_pragmas.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;

struct GfxBase       *GfxBase;
struct IntuitionBase *IntuitionBase;
struct Library       *DataTypesBase;

#else // __amigaos4__ is defined:

# include <exec/exectags.h> // for ASOT_PORT, etc...

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>
# include <proto/gadtools.h>
# include <proto/datatypes.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *DataTypesBase;

PUBLIC struct Library *GadToolsBase; // Visible to CommonFuncsPPC.o

IMPORT struct DOSIFace       *IDOS;
IMPORT struct ExecIFace      *IExec;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct DataTypesIFace *IDataTypes;

PUBLIC struct GadToolsIFace  *IGadTools;

#endif

/*********************************************************************/

struct FrameInfo gfri = { 0 };

PRIVATE char ver[] = "\0$VER: 2.0 DisplayLogoPPC " __DATE__ " by J.T. Steichen";

/*********************************************************************/

/* If condition is false, replace tag with TAG_IGNORE */

#define XTAG( expr, tagid ) ((Tag)((expr)?(tagid):(TAG_IGNORE)))

/*********************************************************************/

const char TEMPLATE[] = "NAME/A,PUBSCREEN/K";

#define OPT_NAME         (0)
#define OPT_PUBSCREEN    (1)
#define NUM_OPTS         (2)


/*********************************************************************/

PRIVATE void PrintErrorMsg( ULONG errnum, STRPTR name )
{
   STRPTR format;
   TEXT   errbuff[ 120 ];

   if (errnum >= DTERROR_UNKNOWN_DATATYPE )
      {
      format = GetDTString( errnum );

      if ((ULONG) (strlen( format ) + strlen( name )) < 110UL)
         {
         sprintf( errbuff, format, name );
         }
      else
         {
         /* buffer overflow */
         errbuff[ 0 ] = 0U;
         }
      }
   else
      {
      Fault( errnum, NULL, errbuff, sizeof( errbuff ) );
      }

   Printf( "%s\nerror #%ld\n", errbuff, errnum );

   return;
}

/*********************************************************************/

PRIVATE struct DataType *dtn        = NULL;
PRIVATE struct Screen   *scr        = NULL;
PRIVATE struct Window   *win        = NULL;
PRIVATE APTR             drawhandle = 0;
PRIVATE Object          *dto        = NULL;
PRIVATE ULONG            modeid     = (ULONG) INVALID_ID;
PRIVATE BOOL             useScreen  = FALSE;
PRIVATE BOOL             going      = TRUE;

/* Tell the object about the environment it will be going into */

PRIVATE ULONG DoDTFrameBoxSpecify( Object *dto, 
                                   struct Window *win, 
                                   struct Requester *req, 
                                   struct FrameInfo *fri
                                 )
{
   if (dto && fri) // != NULL)
      {
      struct Screen       *scr = win->WScreen;
      struct DisplayInfo   di;
      ULONG                modeid;
      struct dtFrameBox    dtf;

      /* Get the display information */
      modeid = GetVPModeID( (&(scr->ViewPort)) );

      (void) GetDisplayInfoData( NULL, (APTR) &di, 
                                 sizeof( struct DisplayInfo ), 
                                 DTAG_DISP, modeid
                               );

      /* Fill in the frame info */
      memset( (void *) fri, 0, sizeof( struct FrameInfo ) );

      fri->fri_PropertyFlags     = di.PropertyFlags;
      fri->fri_Resolution        = *( &(di.Resolution) );
      fri->fri_RedBits           = di.RedBits;
      fri->fri_GreenBits         = di.GreenBits;
      fri->fri_BlueBits          = di.BlueBits;
      fri->fri_Dimensions.Width  = scr->Width;
      fri->fri_Dimensions.Height = scr->Height;
      fri->fri_Dimensions.Depth  = scr->BitMap.Depth;
      fri->fri_Screen            = scr;
      fri->fri_ColorMap          = scr->ViewPort.ColorMap;

      /* Send the message */
      dtf.MethodID          = DTM_FRAMEBOX;
      dtf.dtf_GInfo         = NULL;
      dtf.dtf_ContentsInfo  = fri;
      dtf.dtf_FrameInfo     = NULL;
      dtf.dtf_SizeFrameInfo = sizeof( struct FrameInfo );
      dtf.dtf_FrameFlags    = FRAMEF_SPECIFY;

      return( (ULONG) DoDTMethodA( dto, win, req, (Msg) &dtf ) );
      }

   return( 0UL );
}

/* NOTE:  ReadArgs() & related variables will probably be removed
**        at a later date.
*/

PRIVATE struct Window *DisplayLogo( char *filename, char *screenname )
{
   struct dtFrameBox     dtf = { 0 };
   struct FrameInfo      fri = { 0 };
   STRPTR                name;
   
   /* Get a DataType object */

   dto = NewDTObject( (APTR) filename, 
                      GA_RelVerify, TRUE,
                      GA_Immediate, TRUE,
                      DTA_DataType, dtn,
                      TAG_DONE 
                    );

   if (!dto) // == NULL)
      {
      PrintErrorMsg( IoErr(), (STRPTR) filename );

      return( NULL );
      }


   /* Get information about the object */
   (void) GetDTAttrs( dto,
                      DTA_ObjName, (ULONG) &name,
                      PDTA_ModeID, (ULONG) &modeid,
                      TAG_DONE 
                    );

   /* Ask the object what kind of environment it needs */
   dtf.MethodID          = DTM_FRAMEBOX;
   dtf.dtf_FrameInfo     = &fri;
   dtf.dtf_ContentsInfo  = &fri;
   dtf.dtf_SizeFrameInfo = sizeof( struct FrameInfo );

   if (DoDTMethodA( dto, NULL, NULL, (Msg) &dtf )) // != NULL)
      {
      /* Really success ? */
      if ( fri.fri_Dimensions.Depth )
         {
         if ( (fri.fri_PropertyFlags) & DIPF_IS_HAM )
            useScreen = TRUE;

         if ( (fri.fri_PropertyFlags) & DIPF_IS_EXTRAHALFBRITE )
            useScreen = TRUE;

         if ( (fri.fri_PropertyFlags == 0UL) && (modeid & HAM_KEY) 
                && (modeid != INVALID_ID) )
            {
            useScreen = TRUE;
            }
         }
      }

   if (useScreen != 0)
      {
      Printf( "this object requires a private screen\n" );
      }

   /* Get a lock on the specified public screen */
   scr = LockPubScreen( (STRPTR) screenname );

#  ifdef DEBUG
   fprintf( stderr, "ScreenName = %s\n", screenname );
#  endif

   if (!scr) // == NULL)
      {
      fprintf( stderr, "Couldn't LockPubScreen()!\n" );

      return( NULL );
      }
   else
      {
      struct IBox domain;
      ULONG       nomwidth  = 0UL;
      ULONG       nomheight = 0UL;
      int         left, top;

#     ifndef __amigaos4__
      if (DoDTDomainA( dto, NULL, NULL, NULL, 
                       GDOMAIN_NOMINAL, &domain, 
                       NULL ))
         {
         nomwidth  = domain.Width;
         nomheight = domain.Height;

         // Printf( "nom box %d %d %d %d\n", domain );
         }
#     endif

      /* Make sure we have the right dimensions */
      nomwidth  = ((nomwidth)  ? (nomwidth)  : (320UL));
      nomheight = ((nomheight) ? (nomheight) : (240UL));

      left = (scr->Width  - nomwidth ) / 2;
      top  = (scr->Height - nomheight) / 2;

#     ifdef DEBUG
      fprintf( stderr, "Ready to open the window!\n" );
#     endif

      /* Open the window */
      if ((win = OpenWindowTags( NULL, 

                   WA_InnerWidth,    nomwidth,
                   WA_InnerHeight,   nomheight,
                   WA_Left,          left,
                   WA_Top,           top,
                   WA_IDCMP,         IDCMP_VANILLAKEY | IDCMP_RAWKEY,
                   WA_AutoAdjust,    TRUE,
                   WA_Activate,      TRUE,
                   WA_PubScreen,     scr,
                   TAG_DONE )

         )) // != NULL)
         {
         DoDTFrameBoxSpecify( dto, win, NULL, (&gfri) );

         if (drawhandle = ObtainDTDrawInfo( dto, 
                                            PDTA_Screen, scr, 
                                            TAG_DONE ))
            {
            (void) DrawDTObjectA( (win->RPort), dto,

                                  win->BorderLeft,
                                  win->BorderTop,
                                  
                                 (win->Width - (win->BorderLeft 
                                  + win->BorderRight)),
                                    
                                 (win->Height - (win->BorderTop 
                                  + win->BorderBottom)),

                                  0L, 0L, NULL 
                                );
            }
         }
      }

   return( win );
}

PRIVATE void CloseLibs( void )
{
#  ifdef __amigaos4__
   if (IGadTools)
      DropInterface( (struct Interface *) IGadTools );

   if (GadToolsBase) // != NULL)
      CloseLibrary( GadToolsBase );

#  else

   if (DataTypesBase) // != NULL)
      CloseLibrary( DataTypesBase );

   if (IntuitionBase) // != NULL)
      CloseLibrary( (struct Library *) IntuitionBase );

   if (GfxBase) // != NULL)
      CloseLibrary( (struct Library *) GfxBase );

   if (GadToolsBase) // != NULL)
      CloseLibrary( GadToolsBase );
#  endif

   return;
}

#ifndef __amigaos4__

PRIVATE int OpenLibs( void )
{
   if (!(GfxBase = (struct GfxBase *) OpenLibrary( "graphics.library", 39L ))) // == NULL)
      return( ERROR_INVALID_RESIDENT_LIBRARY );
      
   if (!(IntuitionBase = (struct IntuitionBase *) OpenLibrary( "intuition.library", 39L ))) // == NULL)
      {
      CloseLibrary( (struct Library *) GfxBase );

      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   if (!(DataTypesBase = OpenLibrary( "datatypes.library", 44UL ))) // == NULL)
      {
      CloseLibs();

      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   return( RETURN_OK );
}

#else // __amigaos4__ is defined:

PRIVATE int OpenLibs( void )
{
   if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L ))) // != NULL)
      {
      if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
         {
	 CloseLibs();
	 
	 return( ERROR_INVALID_RESIDENT_LIBRARY );
	 }
      }
   else
      {
      CloseLibs();
      
      return( ERROR_INVALID_RESIDENT_LIBRARY );
      }

   return( RETURN_OK );
}

#endif

int CXBRK(    void ) { return( 0 ); }
int chkabort( void ) { return( 0 ); }
    
PRIVATE int BreakCheck( ULONG signals )
{
   return( (int) (SetSignal( 0L, 0L ) & signals) );
}

PRIVATE void BreakReset( ULONG signals )
{
   SetSignal( 0L, signals );

   return;
}

PRIVATE BOOL CheckVanillaKey( int whichkey )
{
   BOOL rval = FALSE;
   
   switch (whichkey)
      {
      case 'q': // quit
      case 'Q':
      case 'e': // end
      case 'E':
      case 'x': // exit
      case 'X':
         rval = TRUE;

      default:
         break;
      }

   return( rval );
}

PRIVATE BOOL CheckRawKey( int whichkey, int quals )
{
   BOOL rval = FALSE;

   if ((quals & IEQUALIFIER_CONTROL) != 0)
      {
      switch (whichkey)
         {
         case 'c': // CTRL-C
         case 'C':
         case 'd': // CTRL-D
         case 'D':
            rval = TRUE;
            break;
	 
         default:
	    rval = FALSE;
            break;
         }
      }

   return( rval );
}

PRIVATE ULONG WaitMask = SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D;

PRIVATE BOOL CheckForBreakKey( struct Window *wptr )
{
   struct IntuiMessage *m = NULL, pmsg = { 0, };
   ULONG                temp, winbit = 1L << wptr->UserPort->mp_SigBit;
   BOOL                 rval = FALSE;
   
   WaitMask = WaitMask | winbit;
   
   temp = BreakCheck( WaitMask );

   if ((temp & winbit) == winbit) 
      {
      // Here's why GadToolsBase has to be opened:
      m = (struct IntuiMessage *) GT_GetIMsg( wptr->UserPort ); // GetMsg( wptr->UserPort );

      if (m) // != NULL)
         {
         CopyMem( (char *) m, (char *) &pmsg, 
                  (long) sizeof( struct IntuiMessage )
                );

         GT_ReplyIMsg( m ); // ReplyMsg( m );
         
         switch (pmsg.Class)
            {
            case IDCMP_VANILLAKEY:
               rval = CheckVanillaKey( pmsg.Code );
               break;
               
            case IDCMP_RAWKEY:
               rval = CheckRawKey( pmsg.Code, pmsg.Qualifier );
               break;
               
            default:
	       rval = FALSE;
               break;
            }
         }
      }  
   else if ((temp & SIGBREAKF_CTRL_C) == SIGBREAKF_CTRL_C)
      {
      BreakReset( SIGBREAKF_CTRL_C );
      rval = TRUE;
      }
   else if ((temp & SIGBREAKF_CTRL_D) == SIGBREAKF_CTRL_D)
      {
      BreakReset( SIGBREAKF_CTRL_D );
      rval = TRUE;
      }

   return( rval );
}

PRIVATE STRPTR          myPortName = "ATALK_DISPLAYLOGO";
PRIVATE struct MsgPort *myport     = (struct MsgPort *) NULL;

PUBLIC int main( int argc, char **argv )
{
   struct Process *myprocess = (struct Process *) NULL;
   struct Message *msg       = (struct Message *) NULL;
   struct Window  *display   = (struct Window  *) NULL;

#  ifdef __amigaos4__
   BOOL            allocdMsgPort = FALSE;
#  endif

   myprocess = (struct Process *) FindTask( 0 );
   myport    = &myprocess->pr_MsgPort;

   if ((argc != 3) || !strcmp( argv[1], "?" ))
      {
      fprintf( stderr, "USAGE: %s %s\n", argv[0], TEMPLATE );

      return( RETURN_ERROR );
      }

   if (OpenLibs() != RETURN_OK)
      return( ERROR_INVALID_RESIDENT_LIBRARY );

   display = DisplayLogo( argv[1], argv[2] );

   if (!display) // == NULL)
      {
      if (drawhandle) // != NULL) 
         ReleaseDTDrawInfo( dto, drawhandle );
  
      if (dto) // != NULL)
         DisposeDTObject( dto );

      if (dtn) // != NULL)
         ReleaseDataType( dtn );
  
      CloseLibs();

      return( RETURN_FAIL );
      }

   fprintf( stderr, "Logo displayed!\n" );

#  ifndef DEBUG
#  ifdef __amigaos4__
   if (!(myport = AllocSysObjectTags( ASOT_PORT, ASOPORT_Name, myPortName, TAG_DONE )))
      {
      myport = &myprocess->pr_MsgPort; // Did NOT alloc a MsgPort!
      }	
   else
      {
      allocdMsgPort = TRUE;
      } 
#  endif

   WaitPort( myport );      // Wait for Hari-kari message.
   msg = GetMsg( myport );

     if (drawhandle) // != NULL) 
        ReleaseDTDrawInfo( dto, drawhandle );

     CloseWindow( display );
   
     UnlockPubScreen( NULL, scr );
   
     if (dto) // != NULL)
        DisposeDTObject( dto );

     if (dtn) // != NULL)
        ReleaseDataType( dtn );

   ReplyMsg( msg );

#  ifdef __amigaos4__
   if (allocdMsgPort == TRUE)
      FreeSysObject( ASOT_PORT, myport );
#  endif
      
   CloseLibs();

   return( (int) display );

#  else         // DEBUG is defined:
#  ifdef __amigaos4__
   fprintf( stderr, "Need to make a new MsgPort...\n" );

   if (!(myport = (struct MsgPort *) AllocSysObjectTags( ASOT_PORT, ASOPORT_Name, myPortName, TAG_DONE )))
      {
      fprintf( stderr, "Did NOT get a new MsgPort!\n" );
      myport = &myprocess->pr_MsgPort; // Did NOT alloc a MsgPort!
      }
   else
      {
      fprintf( stderr, "MsgPort added (%s)\n", myport->mp_Node.ln_Name );
      allocdMsgPort = TRUE;
      } 
#  endif
   
   msg = (struct Message *) NULL;

   fprintf( stderr, "Waiting for break key (CTRL-C)...\n" );

   while (CheckForBreakKey( display ) == FALSE)
      ; // This is a busy-loop!

   // User found a correct keystroke, so we can now exit the program!   

   if (drawhandle) // != NULL) 
      ReleaseDTDrawInfo( dto, drawhandle );

   CloseWindow( display );

   UnlockPubScreen( NULL, scr );

   if (dto) // != NULL)
      DisposeDTObject( dto );
   
   if (dtn) // != NULL)
      ReleaseDataType( dtn );

#  ifdef __amigaos4__
   if (allocdMsgPort == TRUE)
      {
      while ((msg = GetMsg( myport ))) // Clean off messages
         ReplyMsg( msg ); // Should never happen!

      FreeSysObject( ASOT_PORT, myport );
      }
#  endif
      
   CloseLibs();

   return( (int) display );
#  endif
}

/* ------------------- END of DisplayLogo.c file! --------------------- */
