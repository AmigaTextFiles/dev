/****h* AmigaTalk/WBench.c [3.0] *************************************
*
* NAME 
*   WBench.c
*
* DESCRIPTION
*   Functions that handle Workbench, Utility, Memory, AmigaGuide &
*   Exec to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleLibIntfc( int numargs, OBJECT **args ); <209 ???>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*    21-May-2002 - Added HandleDB??() functions (in DBase.c).
*    25-Mar-2002 - Added HandleMoreExec() to HandleLibIntfc().
*    26-Feb-2002 - Added HandleExec() to HandleLibIntfc().
*    20-Feb-2002 - File ready for compilation.
*    19-Feb-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/WBench.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <utility/tagitem.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/wb_protos.h>
# include <clib/exec_protos.h>
#else

# define __USE_INLINE__

# include <proto/wb.h>
# include <proto/exec.h>
# include <proto/intuition.h>

#endif


#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray ); // in TagFuncs.c

// From DBase.c: ------------------------------------------------------

IMPORT OBJECT *HandleDBase(   int numargs, OBJECT **args ); // <209 6 xx ??>
IMPORT OBJECT *HandleDBMemo(  int numargs, OBJECT **args ); // <209 7 xx ??>
IMPORT OBJECT *HandleDBIndex( int numargs, OBJECT **args ); // <209 8 xx ??>
IMPORT OBJECT *HandleDBField( int numargs, OBJECT **args ); // <209 9 xx ??>
IMPORT OBJECT *ObjectPrims(   int numargs, OBJECT **args ); // <209 10 xx ??>

// From GrabMem.c: ----------------------------------------------------

IMPORT OBJECT *HandleGrabMem( int numargs, OBJECT **args );

// From AGuide.c: -----------------------------------------------------

IMPORT OBJECT *HandleAmigaGuide( int numargs, OBJECT **args );

// From Utility.c: ----------------------------------------------------

IMPORT OBJECT *HandleUtility( int numargs, OBJECT **args );

// From Exec.c: -------------------------------------------------------

IMPORT OBJECT *HandleExec( int numargs, OBJECT **args );

// From ExecAlloc.c: --------------------------------------------------

IMPORT OBJECT *HandleMoreExec( int numargs, OBJECT **args );

/****i* closeWorkbenchObject() [2.0] **********************************
*
* NAME
*    closeWorkbenchObject()
*
* DESCRIPTION
*    ^ <primitive 209 1 0 objName tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *closeWorkbenchObject( char *objName, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
   
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }
   
   chk = CloseWorkbenchObjectA( objName, tags );
   
   if (chk == TRUE)
      rval = o_true;

   if (tags) // != NULL)
      AT_FreeVec( tags, "wbenchObjectTags", TRUE );
   
   return( rval );
}

/****i* openWorkbenchObject() [2.0] ***********************************
*
* NAME
*    openWorkbenchObject()
*
* DESCRIPTION
*    ^ <primitive 209 1 1 objName tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *openWorkbenchObject( char *objName, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
   
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }
            
   chk = OpenWorkbenchObjectA( objName, tags );
   
   if (chk == TRUE)
      rval = o_true;

   if (tags) // != NULL)
      AT_FreeVec( tags, "wbenchObjectTags", TRUE );
         
   return( rval );
}

/****i* removeAppWindow() [2.0] ***************************************
*
* NAME
*    removeAppWindow()
*
* DESCRIPTION
*    ^ <primitive 209 1 2 appWindowObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAppWindow( OBJECT *awObj )
{
   struct AppWindow *aw   = (struct AppWindow *) CheckObject( awObj );
   OBJECT           *rval = o_false;
   BOOL              chk  = FALSE;
      
   chk = RemoveAppWindow( aw );

   if (chk == TRUE)
      rval = o_true;
      
   return( rval );
}

/****i* addAppWindow() [2.0] ******************************************
*
* NAME
*    addAppWindow()
*
* DESCRIPTION
*    ^ <primitive 209 1 3 id userData windowObj msgPort tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAppWindow( ULONG id, ULONG userData, 
                                 OBJECT *winObj, OBJECT *msgPObj, OBJECT *tagArray 
                               )
{
   struct Window    *wptr  = (struct Window  *) CheckObject( winObj  );
   struct MsgPort   *mport = (struct MsgPort *) CheckObject( msgPObj );
   struct TagItem   *tags  = NULL;
   struct AppWindow *aw    = NULL;
   OBJECT           *rval  = o_nil;
   
   if (!wptr || !mport) // == NULL)
      return( rval );

   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }
            
   aw = AddAppWindowA( id, userData, wptr, mport, tags );
   
   if (aw) // != NULL)
      rval = AssignObj( new_address( (ULONG) aw ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "appWindowTags", TRUE );
   
   return( rval );   
}

/****i* addAppIcon() [2.0] ********************************************
*
* NAME
*    addAppIcon()
*
* DESCRIPTION
*    ^ <primitive 209 1 4 id userData test msgPort fileLock diskObj tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAppIcon( ULONG id, ULONG userData, UBYTE *text, 
                               OBJECT *msgPObj, OBJECT *flObj, 
                               OBJECT *dskObj,  OBJECT *tagArray
                             )
{
   BPTR               flock =                (BPTR) CheckObject( flObj   );
   struct MsgPort    *mport = (struct MsgPort    *) CheckObject( msgPObj );
   struct DiskObject *dobj  = (struct DiskObject *) CheckObject( dskObj  );
   struct TagItem    *tags  = NULL;
   struct AppIcon    *ai    = NULL;
   OBJECT            *rval  = o_nil;
   
   if (!flock || !mport || !dobj) // == NULL)
      return( rval );

   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   ai = AddAppIconA( id, userData, text, mport, flock, dobj, tags );

   if (ai) // != NULL)
      rval = AssignObj( new_address( (ULONG) ai ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "appIconTags", TRUE );
   
   return( rval );   
}

/****i* removeAppIcon() [2.0] *****************************************
*
* NAME
*    removeAppIcon()
*
* DESCRIPTION
*    ^ <primitive 209 1 5 appIconObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAppIcon( OBJECT *appObj )
{
   struct AppIcon *ai   = (struct AppIcon *) CheckObject( appObj );
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
   
   chk = RemoveAppIcon( ai );

   if (chk == TRUE)
      rval = o_true;
      
   return( rval );
}

/****i* addAppMenuItem() [2.0] ****************************************
*
* NAME
*    addAppMenuItem()
*
* DESCRIPTION
*    ^ <primitive 209 1 6 id userData text msgPObj tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAppMenuItem( ULONG id, ULONG userData, UBYTE *text, 
                                   OBJECT *msgPObj, OBJECT *tagArray
                                 )
{
   struct MsgPort     *mport = (struct MsgPort *) CheckObject( msgPObj );
   struct TagItem     *tags  = NULL;
   struct AppMenuItem *ami   = NULL;
   OBJECT             *rval  = o_nil;

   if (!mport) // == NULL)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   ami = AddAppMenuItemA( id, userData, text, mport, tags );

   if (ami) // != NULL)
      rval = AssignObj( new_address( (ULONG) ami ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "appMenuTags", TRUE );
   
   return( rval );   
}

/****i* removeAppMenuItem() [2.0] *************************************
*
* NAME
*    removeAppMenuItem()
*
* DESCRIPTION
*    ^ <primitive 209 1 7 appMenuItemObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAppMenuItem( OBJECT *appObj )
{
   struct AppMenuItem *ami  = (struct AppMenuItem *) CheckObject( appObj );
   OBJECT             *rval = o_false;
   BOOL                chk  = FALSE;
    
   chk = RemoveAppMenuItem( ami );
   
   if (chk == TRUE)
      rval = o_true;
      
   return( rval );
}

/****i* workbenchInfo() [2.0] *****************************************
*
* NAME
*    workbenchInfo()
*
* DESCRIPTION
*    <primitive 209 1 8 fileLock objName screenObject>
***********************************************************************
*
*/

METHODFUNC void workbenchInfo( OBJECT *flObj, char *objName, OBJECT *scrObj )
{
   struct Screen *sptr  = (struct Screen *) CheckObject( scrObj );
   BPTR           flock =            (BPTR) CheckObject( flObj  );
   
   WBInfo( flock, objName, sptr );

   return;
}

/****i* workbenchControl() [2.0] **************************************
*
* NAME
*    workbenchControl()
*
* DESCRIPTION
*    ^ <primitive 209 1 9 objName tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *workbenchControl( char *objName, OBJECT *tagArray )
{     
   struct TagItem *tags = NULL;
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   chk = WorkbenchControlA( objName, tags );
   
   if (chk == TRUE)
      rval = o_true;

   if (tags) // != NULL)
      AT_FreeVec( tags, "wbenchControlTags", TRUE );

   return( rval );
}

/****i* addAppWindowDropZone() [2.0] **********************************
*
* NAME
*    addAppWindowDropZone()
*
* DESCRIPTION
*    ^ <primitive 209 1 10 appWindowObj id userData tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAppWindowDropZone( OBJECT *appObj, ULONG id, 
                                         ULONG userData, OBJECT *tagArray 
                                       )
{
   struct AppWindowDropZone *adz  = NULL;
   struct AppWindow         *aw   = (struct AppWindow *) CheckObject( appObj );
   struct TagItem           *tags = NULL;
   OBJECT                   *rval = o_nil;

   if (!aw) // == NULL)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   adz = AddAppWindowDropZoneA( aw, id, userData, tags );

   if (adz) // != NULL)
      rval = AssignObj( new_address( (ULONG) adz ) );
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "appWindowDropZoneTags", TRUE );

   return( rval );
}

/****i* removeAppWindowDropZone() [2.0] *******************************
*
* NAME
*    removeAppWindowDropZone()
*
* DESCRIPTION
*    ^ <primitive 209 1 11 appWindowObj dropZoneObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAppWindowDropZone( OBJECT *appObj, OBJECT *dzObj )
{
   struct AppWindowDropZone *adz  = (struct AppWindowDropZone *) CheckObject( dzObj );

   struct AppWindow         *aw   = (struct AppWindow *) CheckObject( appObj );
   OBJECT                   *rval = o_false;
   BOOL                      chk  = FALSE;
   
   if (!adz || !aw) // == NULL)
      return( rval );
      
   chk = RemoveAppWindowDropZone( aw, adz );
   
   if (chk == TRUE)
      rval = o_true;
      
   return( rval );
}
 
/****i* changeWorkbenchSelection() [2.0] ******************************
*
* NAME
*    changeWorkbenchSelection()
*
* DESCRIPTION
*    ^ <primitive 209 1 12 objName hookObj tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *changeWorkbenchSelection( char   *objName, 
                                             OBJECT *hookObj,
                                             OBJECT *tagArray
                                           )
{
   struct Hook    *hook = (struct Hook *) CheckObject( hookObj );
   struct TagItem *tags = NULL;
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
    
   if (!hook) // == NULL)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   chk = ChangeWorkbenchSelectionA( objName, hook, tags );

   if (chk != FALSE)
      rval = o_true;
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "chgWBenchSelectionTags", TRUE );

   return( rval );
}

/****i* makeWorkbenchObjectVisible() [2.0] ****************************
*
* NAME
*    makeWorkbenchObjectVisible()
*
* DESCRIPTION
*    ^ <primitive 209 1 13 objName tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *makeWorkbenchObjectVisible( char *objName, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   OBJECT         *rval = o_false;
   BOOL            chk  = FALSE;
   
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray ); 
      }

   chk = MakeWorkbenchObjectVisibleA( objName, tags );

   if (chk != FALSE)
      rval = o_true;
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "wbenchObjectVisibleTags", TRUE );      

   return( rval );
}

/****i* closeWorkbench() [2.1] ****************************************
*
* NAME
*    closeWorkbench()
*
* DESCRIPTION
*    ^ <primitive 209 1 14>
***********************************************************************
*
*/

METHODFUNC OBJECT *closeWorkbench( void )
{
   if (CloseWorkBench() == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* openWorkbench() [2.1] *****************************************
*
* NAME
*    openWorkbench()
*
* DESCRIPTION
*    ^ <primitive 209 1 15>
***********************************************************************
*
*/

METHODFUNC OBJECT *openWorkbench( void )
{
   if (OpenWorkBench()) // != NULL)
      return( o_true );
   else
      return( o_false );
}

/****i* wbenchToBack() [2.1] ******************************************
*
* NAME
*    wbenchToBack()
*
* DESCRIPTION
*    ^ <primitive 209 1 16>
***********************************************************************
*
*/

METHODFUNC OBJECT *wbenchToBack( void )
{
   if (WBenchToBack() == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* wbenchToFront() [2.1] *****************************************
*
* NAME
*    wbenchToFront()
*
* DESCRIPTION
*    ^ <primitive 209 1 17>
***********************************************************************
*
*/

METHODFUNC OBJECT *wbenchToFront( void )
{
   if (WBenchToFront() == FALSE)
      return( o_false );
   else
      return( o_true );
}

/* Functions from intuition.library that pertain to Workbench:

LONG  QueryOverscan( ULONG displayID, struct Rectangle *rect, LONG oScanType );
BOOL  DoubleClick( ULONG sSeconds, ULONG sMicros, ULONG cSeconds, ULONG cMicros );
VOID  CurrentTime( ULONG *seconds, ULONG *micros );

struct Preferences *GetDefPrefs( struct Preferences *preferences, LONG size );
struct Preferences *GetPrefs( struct Preferences *preferences, LONG size );
struct Preferences *SetPrefs( CONST struct Preferences *preferences, LONG size, LONG inform );
*/
    
/****h* HandleWBench() [2.0] *******************************************
*
* NAME
*    HandleWBench() {Primitive 209 1 ??}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    WorkBench.
*
* NOTES
*    Class Workbench :Object ! private ! "appWindow appWindowDropZone appIcon appMenuItem"
************************************************************************
*
*/      

PUBLIC OBJECT *HandleWBench( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // ^ boolean <- <209 1 0 objName tagArray>
              // closeWorkbenchObject: objName tags: tagArray
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = closeWorkbenchObject( string_value( (STRING *) args[1] ),
                                                                  args[2] 
                                       );
         break;
      
      case 1: // ^ boolean <- <209 1 1 objName tagArray>
              // openWorkbenchObject: objName tags: tagArray
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = openWorkbenchObject( string_value( (STRING *) args[1] ),
                                                                 args[2] 
                                      );
         break;
         
      case 2: // ^ boolean <- <primitive 209 1 2 appWindowObject>
              // removeAppWindow: appWindowObject
         rval = removeAppWindow( args[1] );
         break;

      case 3: // ^ appWinObj <- <primitive 209 1 3 id userData windowObj msgPort tagArray>
              // addAppWindow: windowObj port: msgPort id: id data: userData tags: tagArray
         if (!is_integer( args[1] ) || !is_address( args[2] )
                                    || !is_array(   args[5] )) 
            (void) PrintArgTypeError( 209 );
         else
            rval = addAppWindow( (ULONG) int_value( args[1] ),
                                 (ULONG) addr_value( args[2] ),
                                 args[3], args[4], args[5]
                               );
         break;
         
      case 4: // ^ appIconObj <- <primitive 209 1 4 id userData test msgPort fileLock diskObj tagArray>
              // addAppIcon: text: port: msgPort id: id data: userData 
              //       lock: fileLock icon: diskObj
         if (!is_integer( args[1] ) || !is_address( args[2] )
                                    || !is_string(  args[3] )
                                    || !is_array(   args[7] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = addAppIcon( (ULONG)       int_value( args[1] ), 
                               (ULONG)      addr_value( args[2] ),
                               (UBYTE *) string_value( (STRING *) args[3] ), 
                               args[4], args[5], args[6], args[7] 
                             );
         break;
         
      case 5: // ^ boolean <- <primitive 209 1 5 appIconObject>
              // removeAppIcon: appIconObject
         rval = removeAppIcon( args[1] );
         break;
         
      case 6: // ^ appMenuObj <primitive 209 1 6 id userData text msgPObj tagArray>
              // addAppMenuItem: text port: msgPort id: id data: userData tags: tagArray
         if (!is_integer( args[1] ) || !is_address( args[2] )
                                    || !is_string(  args[3] )
                                    || !is_array(   args[5] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = addAppMenuItem( (ULONG)      int_value( args[1] ), 
                                   (ULONG)     addr_value( args[2] ),
                                   (UBYTE *) string_value( (STRING *) args[3] ),
                                   args[4], args[5]
                                 );
         break;

      case 7: // ^ boolean <- <primitive 209 1 7 appMenuItemObject>
              // removeAppMenuItem: appMenuItemObject
         rval = removeAppMenuItem( args[1] );
         break;
         
      case 8: // <primitive 209 1 8 fileLock objName screenObject>
              // workbenchInfo: objName lock: fileLock screen: ScreenObject
         if ( is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            workbenchInfo( args[1], string_value( (STRING *) args[2] ),
                           args[3] 
                         );
         break;
         
      case 9: // ^ boolean <- <primitive 209 1 9 objName tagArray>
              // workbenchControl: objName tags: tagArray      
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = workbenchControl( string_value( (STRING *) args[1] ),
                                     args[2]
                                   );
         break;
         
      case 10: // ^ appdzObj <- <primitive 209 1 10 appWindowObj id userData tagArray>
               // addAppWindowDropZone: appWindow id: id data: userData tags: tagArray
         if (!is_integer( args[2] ) || !is_address( args[3] )
                                    || !is_array(   args[4] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = addAppWindowDropZone(                     args[1], 
                                         (ULONG)  int_value( args[2] ),
                                         (ULONG) addr_value( args[3] ),
                                                             args[4]
                                       );
         break;

      case 11: // ^ boolean <- <primitive 209 1 11 appWindowObj dropZoneObj>
               // removeAppWindowDropZone: appWindow dropZone: appWindowDropZoneObject
         rval = removeAppWindowDropZone( args[1], args[2] );
         break;
         
      case 12: // ^ boolean <- <primitive 209 1 12 objName hookObj tagArray>
               // changeWorkbenchSelection: objName hook: hookObject tags: tagArray
         if (!is_string( args[1] ) || !is_array( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = changeWorkbenchSelection( string_value( (STRING *) args[1] ),
                                                                      args[2],
                                                                      args[3]
                                           );
         break;
         
      case 13: // ^ boolean <- <primitive 209 1 13 objName tagArray>
               // makeWorkbenchObjectVisible: objName tags: tagArray
         if (!is_string( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = makeWorkbenchObjectVisible( string_value( (STRING *) args[1] ),
                                                                        args[2]
                                             );
         break;

      case 14: // ^ longInt <- <primitive 209 1 14>
         rval = closeWorkbench();
         break;
      
      case 15: // openWorkbench    
               // ^ ulongInt <- <primitive 209 1 15>
         rval = openWorkbench();
         break;

      case 16: // wbenchToBack
               // ^ boolean <- <primitive 209 1 16>
         rval = wbenchToBack();
         break;

      case 17: // wbenchToFront
               // ^ boolean <- <primitive 209 1 17>
         rval = wbenchToFront();
         break;

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

      
/****h* HandleLibIntfc() [2.0] *****************************************
*
* NAME
*    HandleLibIntfc() {Primitive 209 x yy ?}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    WBench, AmigaGuide, Utility & Memory interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleLibIntfc( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // <209 0 xx private>
         rval = HandleGrabMem( numargs, &args[1] ); // See GrabMem.c

         break;

      case 1: // <209 1 xx ??>
         rval = HandleWBench( numargs, &args[1] );  // In this file
         
         break;
         
      case 2: // <209 2 xx ??>                      // See AGuide.c
         rval = HandleAmigaGuide( numargs, &args[1] );

         break;
      
      case 3: // <209 3 xx ??>
         rval = HandleUtility( numargs, &args[1] );

         break;
      
      case 4: // <209 4 xx ??>                      // See Exec.c
         rval = HandleExec( numargs, &args[1] );

         break;

      case 5: // <209 5 xx ??>                      // See ExecAlloc.c
         rval = HandleMoreExec( numargs, &args[1] );
         
         break;

      case 6: // <209 6 xx ??>                      // See DBase.c
         rval = HandleDBase( numargs, &args[1] );
         
         break;
                
      case 7: // <209 7 xx ??>                      // See DBase.c
         rval = HandleDBMemo( numargs, &args[1] );
         
         break;
                
      case 8: // <209 8 xx ??>                      // See DBase.c
         rval = HandleDBIndex( numargs, &args[1] );
         
         break;
                
      case 9: // <209 9 xx ??>                      // See DBase.c
         rval = HandleDBField( numargs, &args[1] );
         
         break;

      case 10: // <209 10 xx ??>                    // See DBase.c
         rval = ObjectPrims( numargs, &args[1] );
         
         break;
                         
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

/* ---------------------- END of WBench.c file! ----------------------- */
