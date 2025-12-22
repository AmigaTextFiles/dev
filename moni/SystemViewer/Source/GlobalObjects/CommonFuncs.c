/****h* CommonFuncs.c [2.1] *********************************************
*
* NAME
*    CommonFuncs.c
*
* DESCRIPTION
*    Functions that get used a lot for GUI programming, especially for
*    GadToolsBox-generated GUIs.  This file is used to generate 
*    CommonFuncs.o - a Link-able Object for the SAS-C (V6.58) compiler.
*
*    This a link-able object because there are far too many shared 
*    libraries for the Amiga OS as it is, I couldn't see cluttering 
*    someone's hard drive with another one (especially my own!).
*
* HISTORY
*    03-Apr-2001 - Added the SetupList() function.
*    25-Sep-2000 - Added the GetActiveScreen() function.
*    24-Sep-2000 - Added DisplayTitle() & UserInfo() functions.
*    17-Sep-2000 - Added SetTagPair(), Guarded_FreeLV(), &
*                  Guarded_AllocLV() functions.
*    28-Aug-2000 - Added GetPathName() function.
*    18-May-2000 - Added FontXDim() function.
*    17-May-2000 - Added GetScreenModeID() function.
*    19-Jan-2000 - Changed FileReq() to check for NULL parameter. 
*                  Added File_DirReq() function.
*
* AUTHOR
*    James T. Steichen
*    2217 N. Tamarack Dr.
*    Slayton, Mn. 56172-1155, USA
*    jimbot@rconnect.com
*
* NOTES
*    $VER: CommonFuncs.c 2.1 (03-Apr-2001) by J.T. Steichen
*
* COPYRIGHT
*    CommonFuncs.c & CommonFuncs.h (c) 1999-2001 by J.T. Steichen
*************************************************************************
*
*/

#include <stdio.h>

#include <AmigaDOSErrs.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/libraries.h>

#include <libraries/asl.h>
#include <libraries/gadtools.h>

#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>

#include <graphics/view.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>

#include <workbench/workbench.h>

#include <dos/dos.h>

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>

#include "CommonFuncs.h"

IMPORT __far struct IntuitionBase *IntuitionBase;
IMPORT __far struct GfxBase       *GfxBase;
IMPORT __far struct Library       *GadToolsBase;
IMPORT __far struct Library       *AslBase;

// ----------------------------------------------------------------------

/****h* SetupList() *****************************************************
*
* NAME
*    SetupList()
*
* SYNOPSIS
*    void SetupList( struct List *lst, struct ListViewMem *lvm );
*
* DESCRIPTION
*    Initialize a List structure for a ListView Gadget.
*************************************************************************
*
*/

PUBLIC void SetupList( struct List *list, struct ListViewMem *lvm )
{
   int i, len = lvm->lvm_NodeLength;

   if (lvm->lvm_NumItems < 256)
      {
      // We can prioritize the nodes:
      for (i = 0; i < lvm->lvm_NumItems; i++)
         {
         lvm->lvm_Nodes[i].ln_Name = &lvm->lvm_NodeStrs[ i * len ];
         lvm->lvm_Nodes[i].ln_Pri  = lvm->lvm_NumItems - i - 129;
         lvm->lvm_Nodes[i].ln_Type = NT_USER;
         }

      NewList( list );

      for (i = 0; i < lvm->lvm_NumItems; i++)
         Enqueue( list, &(lvm->lvm_Nodes[i]) );
      }
   else
      {
      // Too many nodes to use priorities:
      for (i = 0; i < lvm->lvm_NumItems; i++)
         {
         lvm->lvm_Nodes[i].ln_Name = &lvm->lvm_NodeStrs[ i * len ];
         lvm->lvm_Nodes[i].ln_Pri  = 0;
         lvm->lvm_Nodes[i].ln_Type = NT_USER;
         }

      NewList( list );

      for (i = 0; i < lvm->lvm_NumItems; i++)
         AddTail( list, &(lvm->lvm_Nodes[i]) );
      }

   return;
}

/****h* GetActiveScreen() ***********************************************
*
* NAME
*    GetActiveScreen()
*
* SYNOPSIS
*    struct Screen *active = GetActiveScreen( void );
*
* DESCRIPTION
*    Return a pointer to the Active Screen.
*************************************************************************
*
*/

PUBLIC struct Screen *GetActiveScreen( void )
{
   struct Screen *rval  = NULL;
   ULONG          ilock = 0L;

   if (IntuitionBase == NULL)
      return( rval );         // Kill any potential bugs here.
      
   ilock = LockIBase( NULL );
   
      rval = IntuitionBase->ActiveScreen;
      
   UnlockIBase( ilock );
   
   return( rval );     
}

/****h* DisplayTitle() **************************************************
*
* NAME
*    DisplayTitle()
*
* SYNOPSIS
*    void DisplayTitle( struct Window *wptr, char *windowTitle );
*
* DESCRIPTION
*    Display the given text as a title for the given Window.
*
* NOTES
*    The title is silently limited to 79 characters in length.
*************************************************************************
*
*/

PUBLIC void DisplayTitle( struct Window *wptr, char *txt )
{
   static char tbuf[80];

   if (txt == NULL)
      return;         // Stop bugs in their tracks!
      
   if (wptr == NULL)
      return;         // Stop bugs in their tracks!
         
   strncpy( &tbuf[0], txt, 79 );

   SetWindowTitles( wptr, (UBYTE *) &tbuf[0], (UBYTE *) -1 );
   
   return;
}

// ----------------------------------------------------------------------

PUBLIC int LVMError = 0; // Error # for Guarded_AllocLV() function.

/****h* Guarded_FreeLV() ************************************************
*
* NAME
*    Guarded_FreeLV()
*
* SYNOPSIS
*    void Guarded_FreeLV( struct ListViewMem *lvm );
*
* DESCRIPTION
*    Free the memory associated with a ListView Gadget & reset 
*    the Guard. 
*************************************************************************
*
*/

PUBLIC void Guarded_FreeLV( struct ListViewMem *lvm )
{
   if (lvm == NULL)
      return;
      
   if (lvm->lvm_NodeStrs != NULL)
      {
      FreeVec( lvm->lvm_NodeStrs );
      lvm->lvm_NodeStrs = NULL;
      }

   if (lvm->lvm_Nodes != NULL)
      {
      FreeVec( lvm->lvm_Nodes );
      lvm->lvm_Nodes = NULL;
      }

   if (lvm != NULL)
      {
      FreeVec( lvm );
      lvm = NULL;
      }

   return;
}

/****h* ReportAllocLVError() ********************************************
*
* NAME
*    ReportAllocLVError()
*
* SYNOPSIS
*    void ReportAllocLVError( void );
*
* DESCRIPTION
*    Display a requester informing the User the error that 
*    Guarded_AllocLV() found.
*
* SEE ALSO
*    Guarded_AllocLV(), Guarded_FreeLV()
*************************************************************************
*
*/

PUBLIC void ReportAllocLVError( void )
{
   IMPORT int LVMError;

   char msg[256];
      
   switch (LVMError)
      {
      case LVM_ERROR_NONE:
         sprintf( &msg[0], "No Guarded_AllocLV() error found!" );
         break;
       
      case LVM_ERROR_WRONG_SIZE:
         sprintf( &msg[0], "Guarded_AllocLV() sizes < 1 (Wrong Size!)" );
         break;
         
      case LVM_ERROR_NOMEM:
         sprintf( &msg[0], "Guarded_AllocLV() ran out of Memory!" );
         break;
      } 

   UserInfo( &msg[0], "ERROR Report:" );

   return;
}

/****h* Guarded_AllocLV() ***********************************************
*
* NAME
*    Guarded_AllocLV()
*
* SYNOPSIS
*    struct ListViewMem *lvm = Guarded_AllocLV( int numitems, 
*                                               int itemsize
*                                             );
*
* DESCRIPTION
*    Allocate the memory associated with a ListView Gadget.
*************************************************************************
*
*/

PUBLIC struct ListViewMem *Guarded_AllocLV( int numitems, int itemsize )
{
   IMPORT int LVMError;
   
   struct ListViewMem *rval = NULL;
   
   if ((numitems < 1) || (itemsize < 1))
      {
      LVMError = LVM_ERROR_WRONG_SIZE;
      
      return( NULL );
      }

   // --------- ALLOCATION SECTION: -----------------------------------

   rval = (struct ListViewMem *) AllocVec( sizeof( struct ListViewMem ),
                                           MEMF_CLEAR
                                         );  
   
   if (rval == NULL)
      {
      LVMError = LVM_ERROR_NOMEM;

      return( NULL );
      }

   rval->lvm_Nodes = (struct Node *) 
                      AllocVec( numitems * sizeof( struct Node ),
                                MEMF_CLEAR 
                              );

   if (rval->lvm_Nodes == NULL)
      {
      Guarded_FreeLV( rval );

      LVMError = LVM_ERROR_NOMEM;

      return( NULL );
      }

   rval->lvm_NodeStrs = (UBYTE *) AllocVec( numitems * itemsize, 
                                            MEMF_CLEAR
                                          );

   if (rval->lvm_NodeStrs == NULL)
      {
      Guarded_FreeLV( rval );

      LVMError = LVM_ERROR_NOMEM;

      return( NULL );
      }

   // --------- END OF ALLOCATION SECTION: ----------------------------

   rval->lvm_NumItems   = numitems;
   rval->lvm_NodeLength = itemsize;   

   LVMError = LVM_ERROR_NONE; // Weesa be okey-dokey!

   return( rval );
}

/****h* GetPathName() ***************************************************
*
* NAME
*    GetPathName()
*  
* SYNOPSIS
*    char *path = GetPathName( char *pathbuf, char *filename, int size );
*
* DESCRIPTION
*    Return with the Path portion of a filename string.
*************************************************************************
*
*/

PUBLIC char *GetPathName( char *path, char *filename, int size )
{
   int   i;
   char *last = PathPart( filename );

   for (i = 0; (i < size) && (filename != last); i++, filename++)
      *(path + i) = *filename;
      
   *(path + i) = '\0';
   
   return( path ); 
}


/****h* FontXDim() ******************************************************
*
* NAME
*    FontXDim()
*
* SYNOPSIS
*    int length = FontXDim( struct TextAttr *font );
*
* DESCRIPTION
*    Determine the horizontal distance for one character in the given
*    font.
*************************************************************************
*
*/

PUBLIC int FontXDim( struct TextAttr *font )
{
   struct IntuiText t = { 0, };
    
   t.IText     = " ";
   t.ITextFont = font;
   
   return( IntuiTextLength( &t ) );
}

/****h* getScreenModeID() ***********************************************
*
* NAME
*    getScreenModeID()
*
* SYNOPSIS
*    ULONG mode = getScreenModeID( struct TagItem *taglist, 
*                                  struct Screen  *screen,
*                                  char           *req_title
*                                ); 
*
* DESCRIPTION
*    Obtain a user-selected (via ASL) ScreenModeID value.  NULL will
*    be returned if you supply a NULL value for the screen pointer,
*    or if you press & release the Cancel Gadget on the Requester.
*************************************************************************
*
*/

PUBLIC ULONG getScreenModeID( struct TagItem *taglist, 
                              struct Screen  *scr,
                              char           *title 
                            )
{
   struct ScreenModeRequester *smr = NULL;

   ULONG  rval    = NULL;
   BOOL   result  = FALSE;
   BOOL   libflag = FALSE;
   
   if (scr == NULL)
      {
      return( NULL ); // Better safe than sorry!
      }
      
   if (FindTagItem( ASLSM_Screen, taglist ) == NULL)
      {
      return( NULL ); // Missing the ONLY necessary tag!
      }
   else
      SetTagItem( taglist, ASLSM_Screen, (ULONG) scr );

   if (FindTagItem( ASLSM_TitleText, taglist ) != NULL)
      SetTagItem( taglist, ASLSM_TitleText, (ULONG) title );
                  
   if ((AslBase = OpenLibrary( AslName, 37L )) != NULL)
      libflag = TRUE;

   if (AslBase != NULL)
      {
      smr = (struct ScreenModeRequester *) 
             AllocAslRequest( ASL_ScreenModeRequest, NULL );

      if (smr != NULL)
         {
         result = AslRequest( smr, taglist );

         if (result == TRUE)
            {
            rval = smr->sm_DisplayID;
            } 

         FreeAslRequest( smr );
         }
      else                   // No ScreenModeRequester!
         {
         if (libflag != FALSE)
            CloseLibrary( AslBase );

         return( NULL );
         }

      if (libflag != FALSE)
         CloseLibrary( AslBase );
      }
   else
      {
      return( NULL );          // AslBase couldn't be opened!
      }

   if (result == TRUE)
      return( rval );
   else
      return( NULL );
}
 
/****h* Byt2Str() ***************************************************
*
* NAME
*    Byt2Str()
*
* SYNOPSIS
*    char *hexstr = Byt2Str( char *output, UBYTE input_byte );
*
* DESCRIPTION
*    Take an input binary character & generate a displayable 
*    two-character ASCII 
*    string that displays the HexaDecimal value of each byte.
*
* WARNINGS
*    The output buffer has to be TWO times as long as the input
*    buffer (+ 1 for nil); in other words supply a buffer that's
*    three characters long!
*********************************************************************
*
*/

PUBLIC char *Byt2Str( char *out, UBYTE input )
{
   UBYTE hexch[] = "0123456789ABCDEF";

   UBYTE low     = hexch[  input & 0x0F       ];
   UBYTE high    = hexch[ (input & 0xF0) >> 4 ];

   *out       = high;
   *(out + 1) = low;
   *(out + 2) = '\0';

   return( out );
}

/****h* MakeHexASCIIStr() *******************************************
*
* NAME
*    MakeHexASCIIStr()
*
* SYNOPSIS
*    unsigned int length = MakeHexASCIIStr( char *output, 
*                                           char *input,
*                                           int   inputlength
*                                         );
*
* DESCRIPTION
*    Take an input binary string & generate a displayable ASCII 
*    string that displays the HexaDecimal value of each byte as
*    well as the ASCII representation (for characters >= 0x20 &
*    <= 0x7E).
*
*    Output will be as follows:
*
*    /------------ Hex Bytes ----------\ /--- ASCII ----\
*
*    22334455 22334455 A7223344 7F223344 "3DU"3DU."3D."3D 
*
* WARNINGS
*    The output buffer has to be FOUR times as long as the input
*    buffer!  The maximum value for inlen should be 20 bytes, with
*    16 being the nominal value.
*********************************************************************
*
*/

PUBLIC unsigned int MakeHexASCIIStr( char *out, char *input, int inlen )
{
   UBYTE hexch[] = "0123456789ABCDEF";
   int   i, j, k;

   for (i = 0; i < (4 * inlen); i++)
      *(out + i) = ' ';         // Initialize the output buffer.

   // Output the binary as ASCII characters:  

   for (i = 0, j = 0, k = 0; i < inlen; i++, j++, k++)
      {
      UBYTE low, high;
         
      low  = hexch[  *(input + i) & 0x0F       ];
      high = hexch[ (*(input + i) & 0xF0) >> 4 ];

      *(out + k + j)     = high;
      *(out + k + j + 1) = low;
      
      if ((i + 1) % 4 == 0) // Insert a space between each long word.
         k++;
      }

   *(out + k + j) = '\0';
   i = strlen( out );      // compute the start of the ASCII string.
   *(out + k + j) = ' ';

   // Output the ASCII representation:   

   for (j = 0; j < inlen; j++, i++) 
      {
      if ((*(input + j) < 0x20) || (*(input + j) > 0x7E))
         *(out + i) = 0x2E; /* Output an ASCII period. */
      else
         *(out + i) = *(input + j);
      }

   return( (unsigned int) strlen( out ) );
}

/****h* File_DirReq() ***************************************************
* 
* NAME
*    File_DirReq()
*
* SYNOPSIS
*    int len = File_DirReq( char           *filename, 
*                           char           *dirname,
*                           struct TagItem *taglist
*                         );
*
* DESCRIPTION
*    Display the ASL file requester with the given taglist.  Return
*    the size of the file selected as well as the filename & Directory.
*
*    The suggested taglist items should be:
*
*    ASLFR_Window,          (ULONG) WindowPointer // definitely needed!
*
*    ASLFR_TitleText,       (ULONG) "Example title..." 
*    ASLFR_InitialHeight,   200,
*    ASLFR_InitialWidth,    400,
*    ASLFR_InitialTopEdge,  16,
*    ASLFR_InitialLeftEdge, 50,
*    ASLFR_PositiveText,    (ULONG) "OKAY!",
*    ASLFR_NegativeText,    (ULONG) "CANCEL!",
*    ASLFR_InitialPattern,  (ULONG) "#?",
*    ASLFR_InitialFile,     (ULONG) "",
*    ASLFR_InitialDrawer,   (ULONG) "RAM:",
*    ASLFR_Flags1,          FRF_DOPATTERNS,
*    ASLFR_Flags2,          FRF_REJECTICONS,
*    ASLFR_SleepWindow,     1,
*    ASLFR_PrivateIDCMP,    1,
*    TAG_END
************************************************************************
*
*/

PUBLIC int File_DirReq( char           *filename, 
                        char           *dirname, 
                        struct TagItem *taglist
                      )
{
   struct FileRequester *fr;

   int    len, libflag = 0;

   if (filename == NULL)
      {
      return( -4 ); // Better safe than sorry!
      }
      
   if (FindTagItem( ASLFR_Window, taglist ) == NULL)
      {
      return( -3 ); // Missing the ONLY necessary tag!
      }
           
   if ((AslBase = OpenLibrary( AslName, 37L )) != NULL)
      libflag = 1;

   if (AslBase != NULL)
      {
      fr = (struct FileRequester *) 
                   AllocAslRequest( ASL_FileRequest, taglist );

      if (fr != NULL)
         {

         if (AslRequest( fr, NULL ))
            {
            (void) strcpy( filename, fr->fr_Drawer );
            len = strlen( filename ) - 1;

            if (*(filename + len) == '/' || *(filename + len) == ':')
               (void) strcat( filename, fr->fr_File );
            else
               {      
               // Add a slash to the end of the Path:
               (void) strcat( filename, "/" );
               (void) strcat( filename, fr->fr_File );
               }
            }

         if (dirname != NULL)
            strcpy( dirname, fr->fr_Drawer );

         FreeAslRequest( fr );
         }
      else                   // No FileRequester!
         {
         if (libflag > 0)
            CloseLibrary( AslBase );

         return( -2 );
         }

      if (libflag > 0)
         CloseLibrary( AslBase );
      }
   else
      {
      return( -1 );          // AslBase couldn't be opened!
      }

   return( strlen( filename ) );
}

/****h* FileReq() ******************************************************
* 
* NAME
*    FileReq()
*
* SYNOPSIS
*    int len = FileReq( char *filename, struct TagItem *taglist );
*
* DESCRIPTION
*    Display the ASL file requester with the given taglist.
*
* NOTES
*    This function is identical to File_DirReq() except that we
*    don't use the Directory parameter.
*
*    The suggested taglist items should be:
*
*    ASLFR_Window,          (ULONG) WindowPointer // definitely needed!
*
*    ASLFR_TitleText,       (ULONG) "Example title..." 
*    ASLFR_InitialHeight,   200,
*    ASLFR_InitialWidth,    400,
*    ASLFR_InitialTopEdge,  16,
*    ASLFR_InitialLeftEdge, 50,
*    ASLFR_PositiveText,    (ULONG) "OKAY!",
*    ASLFR_NegativeText,    (ULONG) "CANCEL!",
*    ASLFR_InitialPattern,  (ULONG) "#?",
*    ASLFR_InitialFile,     (ULONG) "",
*    ASLFR_InitialDrawer,   (ULONG) "RAM:",
*    ASLFR_Flags1,          FRF_DOPATTERNS,
*    ASLFR_Flags2,          FRF_REJECTICONS,
*    ASLFR_SleepWindow,     1,
*    ASLFR_PrivateIDCMP,    1,
*    TAG_END
************************************************************************
*
*/

PUBLIC int FileReq( char *filename, struct TagItem *taglist )
{
   return( File_DirReq( filename, NULL, taglist ) );
}

/* --------------------- User Notification: ------------------------ */

PRIVATE struct usernotify {
    
   struct EasyStruct un_ES;
   struct Window     *un_Window;
};

PRIVATE struct usernotify userinfo = {
    
   { sizeof( struct EasyStruct ), 0,
     "Program Problem!",
     "Problem (%ld) with Program.\nSelect 'ABORT' to quit:",
     "CONTINUE|ABORT",
   },

   NULL
};

/****h* SetNotifyWindow() [1.0] *************************************
*
* NAME
*    SetNotifyWindow()
*
* SYNOPSIS
*    (void) SetNotifyWindow( struct Window *wptr );
*
* DESCRIPTION
*    Set the window pointer that Handle_Problem() & other User-
*    Requesters will use for the EasyRequest() call.
*********************************************************************
*
*/

PUBLIC void SetNotifyWindow( struct Window *wptr )
{
   if (wptr != NULL)
      userinfo.un_Window = wptr;
   
   return;
}

/****h* SetReqButtons() [1.0] ***************************************
*
* NAME
*    SetReqButtons
*
* SYNOPSIS
*    (void) SetReqButtons( char *newbuttons );
*
* DESCRIPTION
*    Set the buttons for the Information requester to the given 
*    format string.
*
* NOTES
*    The user of this function should return the buttons to a
*    known string after Handle_Problem() or the other User-
*    requesters are called.
*********************************************************************
*
*/

PUBLIC void SetReqButtons( char *newbuttons )
{
   if (newbuttons != NULL)
      userinfo.un_ES.es_GadgetFormat = newbuttons;
   else
      userinfo.un_ES.es_GadgetFormat = "CONTINUE|ABORT!";
      
   return;
}

/****i* NotifyUser() [1.0] ******************************************
*
* NAME
*    NotifyUser() - Internal to CommonFuncs.o only (PRIVATE!)
*
* SYNOPSIS
*    int ans = NotifyUser( char          *info, 
*                          char          *title,
*                          struct Window *wptr, 
*                          int           *errnum
*                        );
*
* DESCRIPTION
*    Get a response from the user.
*
* FUNCTION
*    Return -1 if the user selected the far-right button (ABORT?),
*    else return 0 (CONTINUE?).
*
* INPUTS
*    info   - Information string for the user to act on.
*    title  - Title of the Problem Requester.
*    wptr   - The window to open the Requester on.
*    errnum - Optional error number (normally NULL).
*********************************************************************
*
*/

PRIVATE int NotifyUser( char          *problem,
                        char          *title,
                        struct Window *wptr,
                        int           errnum
                      )
{
   int rval = 0, answer = 0;
   int oldflags, newflags = wptr->IDCMPFlags;
   
   userinfo.un_ES.es_TextFormat = problem;
   userinfo.un_ES.es_Title      = title;
   oldflags                     = newflags;
   
   // Turn off verify IDCMP messages:
   newflags &= ~(IDCMP_SIZEVERIFY | IDCMP_REQVERIFY | IDCMP_MENUVERIFY);

   ModifyIDCMP( wptr, newflags );
   
   answer = EasyRequest( wptr, &userinfo.un_ES, NULL, errnum );

   switch (answer)
      {
      case 1:
         rval = RETURN_OK; // Continue Button.
         break;
         
      case 0:        // This is the far right button!
         rval = -1;
         break;
      }

   ModifyIDCMP( wptr, oldflags ); // Restore old IDCMP flags.
   return( rval );
}

/****h* Handle_Problem() [1.0] **************************************
*
* NAME
*    Handle_Problem()
*
* SYNOPSIS
*    int ans = Handle_Problem( char *info, char *title, int *errnum );
*
* DESCRIPTION
*    Get a Yes/No Response from the user.
*
* FUNCTION
*    Return -1 if the user selected the ABORT (far-right) button,
*    else return the errnum value (normally 0).
*
* INPUTS
*    info   - Information string for the user to act on.
*    title  - Title of the Problem Requester.
*    errnum - Optional error number (normally NULL).
*
* NOTES
*    Be sure to call SetNotifyWindow( wptr ) BEFORE using this 
*    function for the first time!
*********************************************************************
*
*/

PUBLIC int Handle_Problem( char *info, char *title, int *errnum )
{
   int errornum = 0;
   
   if (errnum != NULL)
      errornum = *errnum;
      
   if (userinfo.un_Window == NULL)
      return( -2 );
      
   if (NotifyUser( info, title, userinfo.un_Window, errornum ) == -1)
      return( -1 );
   else
      return( errornum );  // User didn't press the ABORT button!
}

/****h* GetUserResponse() [1.0] *************************************
*
* NAME
*    GetUserResponse - Get a button response from the user.
*
* SYNOPSIS
*    int ans = GetUserResponse( char *info, char *title, int *errnum );
*
* FUNCTION
*    Return -1 if there's no window, otherwise return the ordinal
*    of the button the user pressed.  This means that there can be
*    more than two choice buttons for the User to choose from.
*
* INPUTS
*    info   - Information string for the user to act on.
*    title  - Title of the Problem Requester.
*    errnum - Optional error number.
*
* NOTES
*    GetUserResponse() will return 0 for the right-most button,
*    instead of n, where n is the number of buttons.  This is the
*    behavior of the EasyRequest() function (so don't blame me!).
*
*    Call SetReqButtons() before using this function &
*    be sure to call SetNotifyWindow( wptr ) BEFORE using this 
*    function for the first time!
*********************************************************************
*
*/

PUBLIC int  GetUserResponse( char *problem, char *title, int *errnum )
{
   struct Window *wptr = userinfo.un_Window;
   int            answer = 0;
   int            oldflags, newflags, errornum;
   
   if (wptr == NULL)
      return( -1 );
      
   if (errnum != NULL)
      errornum = *errnum;
      
   newflags                     = wptr->IDCMPFlags;
   userinfo.un_ES.es_TextFormat = problem;
   userinfo.un_ES.es_Title      = title;
   oldflags                     = newflags;
   
   // Turn off verify IDCMP messages:
   newflags &= ~(IDCMP_SIZEVERIFY | IDCMP_REQVERIFY | IDCMP_MENUVERIFY);

   ModifyIDCMP( wptr, newflags );
   
   answer = EasyRequest( wptr, &userinfo.un_ES, NULL, errnum );

   ModifyIDCMP( wptr, oldflags ); // Restore old IDCMP flags.

   return( answer );
   
}

/****h* SanityCheck() [1.0] **************************************
*
* NAME
*    SanityCheck - Get a Yes/No Response from the user.
*
* SYNOPSIS
*    Boolean answer = SanityCheck( char *question );
*
* FUNCTION
*    Return TRUE if the User pressed the 'YES' button.
*    Return FALSE if the User pressed the 'NO' button.
*
* INPUTS
*    question - question the User has to respond to.
*
* NOTES
*    Be sure to call SetNotifyWindow( wptr ) BEFORE using this 
*    function for the first time!
******************************************************************
*
*/

PUBLIC BOOL SanityCheck( char *question )
{
   BOOL rval = FALSE;

   SetReqButtons( "YES|NO" );   

   rval = Handle_Problem( question, "User SANITY CHECK:", NULL );

   SetReqButtons( "CONTINUE|ABORT" );   

   if (rval == 0)
      rval = TRUE;
   else 
      rval = FALSE;
      
   return( rval ); 
}

/****h* UserInfo() [1.0] *****************************************
*
* NAME
*    UserInfo()
*
* SYNOPSIS
*    void UserInfo( char *message, char *windowtitle );
*
* DESCRIPTION
*    Tell user some information.
*
* NOTES
*    Be sure to call SetNotifyWindow( wptr ) BEFORE using this 
*    function for the first time!
******************************************************************
*
*/

PUBLIC void UserInfo( char *msg, char *title )
{
   SetReqButtons( "OKAY" );   

   (void) Handle_Problem( msg, title, NULL );

   SetReqButtons( "CONTINUE|ABORT" );   

   return; 
} 

/****h* ComputeX() [1.0] ********************************************
*
* NAME
*    ComputeX()
*
* SYNOPSIS
*    UWORD size = ComputeX( UWORD fontxsize, UWORD value );
*
* DESCRIPTION
*    This function returns (fontxsize * value + 4) / 8
*
* NOTES
*    This function will probably be changed to private later.
*********************************************************************
*
*/

PUBLIC UWORD ComputeX( UWORD fontxsize, UWORD value )
{
   return( (UWORD) (((fontxsize * value) + 4) / 8) );
}

/****h* ComputeY() [1.0] ********************************************
*
* NAME
*    ComputeY()
*
* SYNOPSIS
*    UWORD size = ComputeY( UWORD fontysize, UWORD value );
*
* DESCRIPTION
*    This function returns (fontysize * value + 4) / 8
*
* NOTES
*    This function will probably be changed to private later.
*********************************************************************
*
*/

PUBLIC UWORD ComputeY( UWORD fontysize, UWORD value )
{
   return( (UWORD) (((fontysize * value) + 4) / 8) );
}

/****h* ComputeFont() [1.0] *****************************************
*
* NAME
*    ComputeFont()
*
* SYNOPSIS
*    void ComputeFont( struct Screen   *screen,
*                      struct TextAttr *font,
*                      struct CompFont *cfont,
*                      UWORD            width,
*                      UWORD            height
*                    );
*
* DESCRIPTION
*    Initialize the CompFont structure according to the supplied
*    values in the font, width & height.  If the results won't fit
*    the screen dimensions, use topaz (8) in the computations
*    instead.
*
* NOTES
*    GfxBase has to be open BEFORE calling this function!
*********************************************************************
*
*/

PUBLIC void ComputeFont( struct Screen   *Scr, 
                         struct TextAttr *Font,
                         struct CompFont *cf,
                         UWORD            width, 
                         UWORD            height
                       )
{
   if (GfxBase == NULL)
      goto UseTopaz;
      
   Forbid(); // ---------------------------------------------
     
     Font->ta_Name  = (STRPTR) 
                      GfxBase->DefaultFont->tf_Message.mn_Node.ln_Name;
     
     Font->ta_YSize = GfxBase->DefaultFont->tf_YSize;
     
     cf->FontY = GfxBase->DefaultFont->tf_YSize; 
     cf->FontX = GfxBase->DefaultFont->tf_XSize; 
     
   Permit(); // ---------------------------------------------

   cf->OffX = Scr->WBorLeft;
   cf->OffY = Scr->RastPort.TxHeight + Scr->WBorTop + 1;

   if ((width != 0) && (height != 0))
      {
      if ((ComputeX( cf->FontX, width ) 
           + cf->OffX + Scr->WBorRight) > Scr->Width)
         goto UseTopaz;
         
      if ((ComputeY( cf->FontY, height ) 
           + cf->OffY + Scr->WBorBottom) > Scr->Height)
         goto UseTopaz;
      }   

   return;
   
UseTopaz:

   Font->ta_Name  = (STRPTR) "topaz.font";
   Font->ta_YSize = 8;
   
   cf->FontX      = 8;
   cf->FontY      = 8;

   // These might be in error:
   cf->OffX       = Scr->WBorLeft;
   cf->OffY       = Scr->RastPort.TxHeight + Scr->WBorTop + 1;

   return;
}

/****h* FindTools() [1.0] *******************************************
*
* NAME
*    FindTools()
* 
* DESCRIPTION
*    Locate a tools array for a given name.
*
* SYNOPSIS
*    char **toolarray = FindTools( struct DiskObject *diskobj,
*                                  char              *filename,
*                                  BPTR               directory_lock
*                                );
*
* INPUTS
*    filename = null-terminated name of file to look for.
*    lock     = directory to look for file in.
*    diskobj  = storage (for a later call to FreeDiskObject()) 
*
* WARNINGS
*    Be sure to call FreeDiskObject() later in your program.
*    FindTools() doesn't do this because it doesn't know what 
*    you're going to do with the ToolTypes. 
*********************************************************************
*
*/

PUBLIC char **FindTools( struct DiskObject *diskobj, 
                         char              *name, 
                         BPTR               lock 
                       )
{
   BPTR   olddir = NULL;
   char **tools  = NULL;

   if (lock == NULL)
      return( NULL );
      
   olddir = CurrentDir( lock );
   
   if ((diskobj = (struct DiskObject *) GetDiskObject( name )) != NULL)
      tools = diskobj->do_ToolTypes;
   
   (void) CurrentDir( olddir );

   return( tools );
}

/****h* GetToolStr() [1.0] ******************************************
*
* NAME
*    GetToolStr()
*
* DESCRIPTION
*    Find the tooltype string that matches the given name.
*
* SYNOPSIS
*    toolstring = GetToolStr( char **toolarray,
*                             char  *toolname,
*                             char  *default_tool
*                           );
*
* INPUTS
*    toolarray    = pointer from FindTools() call.
*    toolname     = tool we're searching the icon for.
*    default_tool = default string to return if the tool isn't found.
*********************************************************************
*
*/

PUBLIC char *GetToolStr( char **toolptr, char *name, char *deflt )
{
   char *found = NULL;
   
   found = (char *) FindToolType( toolptr, name );

   return( (found != NULL) ? found : deflt );
}

/****h* GetToolInt() [1.0] ******************************************
*
* NAME
*    GetToolInt() 
*
* DESCRIPTION
*    Find the tooltype integer that matches the given name.
*
* SYNOPSIS
*    tool_int = GetToolInt( char **toolarray,
*                           char  *toolname,
*                           int    default_val
*                         );
*
* INPUTS
*    toolarray   = pointer from FindTools() call.
*    toolname    = tool we're searching the icon for.
*    default_val = default integer to return if the tool isn't found.
*********************************************************************
*
*/

PUBLIC int GetToolInt( char **toolptr, char *name, int defaultvalue )
{
   char *found = NULL;
   int   rval  = 0;
   
   found = (char *) FindToolType( toolptr, name );

   rval  = atoi( found );

   return( (rval > 0) ? rval : defaultvalue );
}

/****h* GetToolBoolean() [1.0] **************************************
*
* NAME
*    GetToolBoolean()
*
* DESCRIPTION
*    Find the tooltype boolean that matches the given name.
*
* SYNOPSIS
*    boolean ans = GetToolBoolean( char **toolptr,
*                                  char  *name,
*                                  int    defaultBool
*                                );
*
* INPUTS
*    toolptr     = pointer from FindTools() call.
*    name        = tool we're searching the icon for.
*    defaultBool = default boolean to return if the tool isn't found.
*
* NOTES
*    The following strings will return a Boolean value of TRUE:
*        
*        "TRUE", "YES", "OK" & "OKAY"
*
*    any other value will return FALSE.
*********************************************************************
*
*/

PUBLIC BOOL GetToolBoolean( char **toolptr, char *name, int defaultBool )
{
   char *found = NULL;
   
   found = (char *) FindToolType( toolptr, name );

   if (found != NULL)
      {
      if (strcmp( found, "TRUE" ) == 0)
         return( TRUE );
      else if (strcmp( found, "YES"  ) == 0)
         return( TRUE );
      else if (strcmp( found, "OK"   ) == 0)
         return( TRUE );
      else if (strcmp( found, "OKAY" ) == 0)
         return( TRUE );
      else
         return( FALSE );
      }
   else
      return( (BOOL) defaultBool );
}

/****h* FindIcon() [1.0] ********************************************
*
* NAME
*    FindIcon()
*
* DESCRIPTION
*    Find the icon associated with pgmname (if any) & process the
*    ToolTypes array in the icon with ToolProc().
*
* SYNOPSIS
*    void *rval = FindIcon( void              *(ToolProc)(char **), 
*                           struct DiskObject *dobj,
*                           char              *pgmname
*                         );
*
* INPUTS
*    ToolProc() - a Pointer to a function that will perform an
*                 operation on the ToolTypes array from the Icon
*                 if the icon was found.
*
*    dobj       - storage (for a later call to FreeDiskObject())
*
*    pgmname    - The name of the icon to look for (without the
*                 ".info" at the end of the string). 
*
* NOTES
*    If the user starts a program from the CLI, & the icon is in
*    the same directory, we will get the ToolTypes from the icon
*    instead of using the built-in defaults.
*********************************************************************
*
*/

PUBLIC void *FindIcon( void              *(ToolProc)(char **), 
                       struct DiskObject *dobj,
                       char              *pgmname
                     )
{
   BPTR   dirlock = NULL;
   char **toolptr = NULL;
   void  *rval    = NULL;
   
   dirlock = GetProgramDir(); // AmigaDOS function.
   
   if (dirlock != NULL)
      {
      toolptr = FindTools( dobj, pgmname, dirlock );
      rval    = ToolProc( toolptr ); // Do something with the tools!
      }

   return( rval );
}

/****h* CloseLibs() [1.0] *******************************************
*
* NAME
*    CloseLibs()
*
* SYNOPSIS
*    void CloseLibs( void );
*
* DESCRIPTION
*    Close the three most-commonly used libraries - 
*
*       intuition.library, graphics.library & gadtools.library.
*********************************************************************
*
*/

PUBLIC void CloseLibs( void )
{
   if (IntuitionBase != NULL)
      CloseLibrary( (struct Library *) IntuitionBase );

   if (GfxBase != NULL)
      CloseLibrary( (struct Library *) GfxBase );

   if (GadToolsBase != NULL)
      CloseLibrary( GadToolsBase );
      
   return;
}

/****h* OpenLibs() [1.0] ********************************************
*
* NAME
*    OpenLibs()
*
* SYNOPSIS
*    int result = OpenLibs( void );
*
* DESCRIPTION
*    Open the three most-commonly used libraries (V39+) - 
*
*       intuition.library, graphics.library & gadtools.library.
*
* RETURN VALUE
*    Negative integer if a library could NOT be opened, zero if
*    all was successful.
*********************************************************************
*
*/

PUBLIC int OpenLibs( void )
{
   IntuitionBase = (struct IntuitionBase *)
                   OpenLibrary( "intuition.library", 39L );

   if (IntuitionBase == NULL)
      return( -1 );

   GfxBase = (struct GfxBase *)
             OpenLibrary( "graphics.library", 39L );

   if (GfxBase == NULL)
      {
      CloseLibs();
      return( -2 );
      }

   GadToolsBase = OpenLibrary( "gadtools.library", 39L );

   if (GadToolsBase == NULL)
      {
      CloseLibs();
      return( -3 );
      }

   return( 0 );
}

/****h* RGB2HSV() ***************************************************
*
* NAME
*    RGB2HSV()
*
* SYNOPSIS
*    struct ColorCoords *ans = RGB2HSV( struct ColorCoords *input );
*
* DESCRIPTION
*    Convert an RGB color coordinate set into HSV (Hue,
*    Saturation & Luminance).
*
* NOTES
*    red, green & blue are values from 0 to 255 (normally).
*
* WARNINGS
*    If you want the input structure for later, save it before
*    passing it to this function, since it modifies it & returns it.
*********************************************************************
*
*/

PUBLIC struct ColorCoords *RGB2HSV( struct ColorCoords *input )
{
   float hue, saturation, luminance;
   float red, green, blue;
   float ma, mi, d;
   
   red   = (float) input->Red_Hue          / 15;
   green = (float) input->Green_Saturation / 15;
   blue  = (float) input->Blue_Luminance   / 15;

   ma = (red > blue)  ? red : blue;
   ma = (ma  > green) ? ma  : green;
   mi = (red < blue)  ? red : blue;
   mi = (mi  < green) ? mi  : green;

   luminance = ma;
   
   if (ma != 0)
      saturation = (ma - mi) / ma;
   else
      saturation = 0;
      
   if (saturation == 0)
      hue = 0;
   else
      {
      d = ma - mi;
      
      if (red == ma)
         hue = (green - blue) / d;
      else if (green == ma)
         hue = 2 + (blue - red) / d;
      else
         hue = 4 + (red - green) / d;

      hue *= 60;
      
      if (hue < 0)
         hue += 360;
      }

   input->Red_Hue          = (LONG) hue;
   input->Green_Saturation = (LONG) 100 * saturation;
   input->Blue_Luminance   = (LONG) 100 * luminance;

   return( input );
}

/****h* HSV2RGB() ***************************************************
*
* NAME
*    HSV2RGB()
*
* SYNOPSIS
*    struct ColorCoords *ans = HSV2RGB( struct ColorCoords *input );
*
* DESCRIPTION 
*    Convert an HSV (Hue, Saturation & Luminance) coordinate into
*    RGB (red, green & blue).
*
* NOTES
*    red, green & blue are values from 0 to 255 (normally).
*
* WARNINGS
*    If you want the input structure for later, save it before
*    passing it to this function, since it modifies it & returns it.
*
*********************************************************************
*
*/

PUBLIC struct ColorCoords *HSV2RGB( struct ColorCoords *input )
{
   float hue, saturation, luminance;
   float red, green, blue;
   float p1, p2, p3, f;
   int   i = 0;

  hue        = (float) input->Red_Hue          / 60;
  luminance  = (float) input->Blue_Luminance   / 100;
  saturation = (float) input->Green_Saturation / 100;

  while ((f = hue - i) > 1)
    i++;

  p1 = luminance * (1 - saturation);
  p2 = luminance * (1 - (saturation * f));
  p3 = luminance * (1 - (saturation * (1 - f)));

  switch (i)
    {
    case 0:
      red   = luminance;
      green = p3;
      blue  = p1;
      break;

    case 1:
      red   = p2;
      green = luminance;
      blue  = p1;
      break;

    case 2:
      red   = p1;
      green = luminance;
      blue  = p3;
      break;

    case 3:
      red   = p1;
      green = p2;
      blue  = luminance;
      break;

    case 4:
      red   = p3;
      green = p1;
      blue  = luminance;
      break;

    case 5:
      red   = luminance;
      green = p1;
      blue  = p2;
      break;
    }

  input->Red_Hue          = (UWORD) (red   * 15);
  input->Green_Saturation = (UWORD) (green * 15);
  input->Blue_Luminance   = (UWORD) (blue  * 15);

  return( input );

}

/****h* SetTagItem() [1.0] ******************************************
*
* NAME
*    SetTagItem()
*
* SYNOPSIS
*    void SetTagItem( struct TagItem *taglist, ULONG tag, ULONG value );
*
* DESCRIPTION
*    This function searches the given taglist for the given tag.  If
*    the tag is found, its value (ti_Data) is changed to the given
*    value.  This function completes the functionality for using 
*    TagLists.
*********************************************************************
*
*/

PUBLIC void SetTagItem( struct TagItem *taglist, ULONG tag, ULONG value )
{
   struct TagItem *item = (struct TagItem *) FindTagItem( tag, taglist );
   
   if (item != NULL)
      item->ti_Data = value;
   
   return;
}

/****h* SetTagPair() [1.0] ******************************************
*
* NAME
*    SetTagPair()
*
* SYNOPSIS
*    void SetTagPair( struct TagItem *taglist, ULONG tag, ULONG value );
*
* DESCRIPTION
*    Add a Tag & value to a TagItem list.  If taglist is NULL, 
*    nothing is done by this function.
*    This function completes the functionality for using TagLists.
*
* NOTES
*    taglist is really an array of ULONG values organized into pairs.
*
* WARNINGS
*    No check is done to see if there is space in the Tag list
*    for the added pair (so why not reserve space by using: 
*    {TAG_IGNORE, NULL} in the taglist you provide?).
*********************************************************************
*
*/

PUBLIC void SetTagPair( struct TagItem *taglist, ULONG tag, ULONG value )
{
   if (taglist == NULL)
      return;            // Do NOT cause Enforcer hits.
      
   taglist->ti_Tag  = tag;
   taglist->ti_Data = value;   

   return;
}

/****h* FGetS() [1.0] **********************************************
*
* NAME
*    FGetS()
*
* SYNOPSIS
*    char *str = FGetS( char *buffer, int readlength, FILE *fptr );
*
* DESCRIPTION
*    This function is identical to the C library function fgets()
*    except that it changes the \n at the end of a line to a \0.
********************************************************************
*
*/

PUBLIC char *FGetS( char *buffer, int length, FILE *fileptr )
{
   char *rval = NULL, *cp = NULL;
   int   len  = 0;
   
   rval = fgets( buffer, length, fileptr );
   
   if (rval != NULL)
      {
      len = strlen( buffer ) - 1;
      
      cp = &buffer[ len ];
      
      if (*cp == '\n')
         *cp = '\0';
      }

   return( rval );
}

/****h* HideListFromView() ******************************************
*
* NAME
*    HideListFromView()
*
* SYNOPSIS
*    void HideListFromView( struct Gadget *listview_gadget,
*                           struct Window *window_pointer
*                         );
*
* DESCRIPTION
*    Turn off the Given ListView Gadget for the window, so that it
*    can be modified elsewhere.
*
* SEE ALSO
*    ModifyListView()
*********************************************************************
*
*/ 

PUBLIC void HideListFromView( struct Gadget *lv, struct Window *w )
{
   GT_SetGadgetAttrs( lv, w, NULL, GTLV_Labels, ~0, TAG_DONE );
   return;
}

/****h* ModifyListView() ********************************************
*
* NAME
*    ModifyListView()
*
* SYNOPSIS
*    void ModifyLsitView( struct Gadget *listview_gadget,
*                         struct Window *window_pointer,
*                         struct List   *listview_contents,
*                         struct Gadget *string_gadget
*                       ); 
*
* DESCRIPTION
*    Change the Given ListView Gadget for the window to the 
*    new parameters, which will re-display it.
*
* SEE ALSO
*    HideListFromView()
*********************************************************************
*
*/ 

PUBLIC void ModifyListView( struct Gadget *lv, 
                            struct Window *w,
                            struct List   *list,
                            struct Gadget *strgadget
                          )
{
   GT_SetGadgetAttrs( lv, w, NULL,
                      GTLV_Labels,       list,
                      GTLV_ShowSelected, strgadget,
                      GTLV_Selected,     0,
                      TAG_DONE
                    );
   return;
}

/* ---------------- END of CommonFuncs.c file! ----------------------- */
