/****h* AmigaTalk/Layers.c [3.0] *************************************
*
* NAME 
*   Layers.c
*
* DESCRIPTION
*   Functions that handle Layers to AmigaTalk primitives <207 0-46>.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleLayers( int numargs, OBJECT **args ); <207>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    15-Nov-2002 - Ready for first compilation.
*    27-Dec-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/Layers.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <graphics/gfx.h>
#include <graphics/clip.h>
#include <graphics/layers.h>
#include <graphics/rastport.h>
#include <graphics/regions.h>

#include <utility/hooks.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/graphics_protos.h>
# include <clib/layers_protos.h>

#else

# define __USE_INLINE__

# include <proto/layers.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

PRIVATE struct Library     *LayersBase;
PRIVATE struct LayersIFace *ILayers;
 
#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

typedef struct Layer_Info *LIPTR;

SUBFUNC BOOL NilChk( APTR var )
{
   if (!var || (var == (APTR) o_nil))
      return( TRUE );
   else
      return( FALSE );
}

/****i* disposeLayerInfo() [3.0] **************************************
*
* NAME
*    disposeLayerInfo()
*
* DESCRIPTION
*    ^ <primitive 207 0 private>
***********************************************************************
*
*/

METHODFUNC void disposeLayerInfo( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );

   if (li) // != NULL)
      DisposeLayerInfo( li );
      
   return;
}

/****i* newLayerInfo() [3.0] ******************************************
*
* NAME
*    newLayerInfo()
*
* DESCRIPTION
*    ^ <primitive 207 1>
***********************************************************************
*
*/

METHODFUNC OBJECT *newLayerInfo( void )
{
   LIPTR   li   = (LIPTR) NULL;
   OBJECT *rval = o_nil;
   
   if ((li = NewLayerInfo())) // != NULL)
      rval = AssignObj( new_address( (ULONG) li ) );
      
   return( rval );   
}
    
/****i* createUpFrontLayer() [3.0] ************************************
*
* NAME
*    createUpFrontLayer()
*
* DESCRIPTION
*    ^ <primitive 207 2 private thisBitMap x0 y0 x1 y1 flags bitMap2>
***********************************************************************
*
*/

METHODFUNC OBJECT *createUpFrontLayer( OBJECT *liObj, 
                                       OBJECT *bmObj1,
                                       LONG    x0,
                                       LONG    y0,
                                       LONG    x1,
                                       LONG    y1,
                                       LONG    flags,
                                       OBJECT *bmObj2
                                     )
{
   struct BitMap *bm1   = (struct BitMap *) CheckObject( bmObj1 );
   struct BitMap *bm2   = (struct BitMap *) CheckObject( bmObj2 );
   struct Layer  *newli = (struct Layer  *) NULL;

   LIPTR   li   = (LIPTR) CheckObject( liObj );
   OBJECT *rval = o_nil;

   if (li && bm1) // != NULL)
      newli = CreateUpfrontLayer( li, bm1, x0, y0, x1, y1, flags, bm2 );

   if (newli) // != NULL)
      rval = AssignObj( new_address( (ULONG) newli ) );
      
   return( rval );        
}

/****i* createBehindLayer() [3.0] *************************************
*
* NAME
*    createBehindLayer()
*
* DESCRIPTION
*    ^ <primitive 207 3 private thisBitMap x0 y0 x1 y1 flags bitMap2>
***********************************************************************
*
*/

METHODFUNC OBJECT *createBehindLayer( OBJECT *liObj, 
                                      OBJECT *bmObj1,
                                      LONG    x0,
                                      LONG    y0,
                                      LONG    x1,
                                      LONG    y1,
                                      LONG    flags,
                                      OBJECT *bmObj2
                                    )
{
   struct BitMap *bm1   = (struct BitMap *) CheckObject( bmObj1 );
   struct BitMap *bm2   = (struct BitMap *) CheckObject( bmObj2 );
   struct Layer  *newli = (struct Layer  *) NULL;

   LIPTR   li   = (LIPTR) CheckObject( liObj );
   OBJECT *rval = o_nil;

   if (NilChk( (APTR) li ) == FALSE && NilChk( (APTR) bm1 ) == FALSE)
      newli = CreateBehindLayer( li, bm1, x0, y0, x1, y1, flags, bm2 );

   if (newli) // != NULL)
      rval = AssignObj( new_address( (ULONG) newli ));
      
   return( rval );        
}

/****i* deleteLayer() [3.0] *******************************************
*
* NAME
*    deleteLayer()
*
* DESCRIPTION
*    ^ <primitive 207 4 dummy layerObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *deleteLayer( LONG dummy, OBJECT *layerObj )
{
   OBJECT       *rval = o_false;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );

   if (NilChk( (APTR) layr ) == FALSE)   
      if (DeleteLayer( dummy, layr ) == 0)
         rval = o_true;
      
   return( rval );
}

/****i* moveLayer() [3.0] *********************************************
*
* NAME
*    moveLayer()
*
* DESCRIPTION
*    ^ <primitive 207 5 dummy layerObject dx dy>
***********************************************************************
*
*/

METHODFUNC OBJECT *moveLayer( LONG dummy, OBJECT *layerObj, LONG dx, LONG dy )
{
   OBJECT       *rval = o_false;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      if (MoveLayer( dummy, layr, dx, dy ) == 0)
         rval = o_true;
      
   return( rval );
}

/****i* sizeLayer() [3.0] *********************************************
*
* NAME
*    sizeLayer()
*
* DESCRIPTION
*    ^ <primitive 207 6 dummy layerObject dx dy>
***********************************************************************
*
*/

METHODFUNC OBJECT *sizeLayer( LONG dummy, OBJECT *layerObj, LONG dx, LONG dy )
{
   OBJECT       *rval = o_false;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      if (SizeLayer( dummy, layr, dx, dy ) == 0)
         rval = o_true;
      
   return( rval );
}

/****i* moveAndSizeLayer() [3.0] **************************************
*
* NAME
*    moveAndSizeLayer()
*
* DESCRIPTION
*    ^ <primitive 207 7 layerObject dx dy dw dh>
***********************************************************************
*
*/

METHODFUNC OBJECT *moveAndSizeLayer( OBJECT *layerObj, LONG dx, LONG dy,
                                     LONG dw, LONG dh  
                                   )
{
   OBJECT       *rval = o_false;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      if (MoveSizeLayer( layr, dx, dy, dw, dh ) == 0)
         rval = o_true;
      
   return( rval );
}

/****i* scrollLayer() [3.0] *******************************************
*
* NAME
*    scrollLayer()
*
* DESCRIPTION
*    ^ <primitive 207 8 dummy layerObject dx dy>
***********************************************************************
*
*/

METHODFUNC void scrollLayer( LONG dummy, OBJECT *layerObj, LONG dx, LONG dy )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      ScrollLayer( dummy, layr, dx, dy );
      
   return;
}

/****i* makeLayerLast() [3.0] *****************************************
*
* NAME
*    makeLayerLast()
*
* DESCRIPTION
*    ^ <primitive 207 9 dummy layerObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *makeLayerLast( LONG dummy, OBJECT *layerObj )
{
   OBJECT       *rval = o_nil;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      rval = AssignObj( new_int( (int) BehindLayer( dummy, layr ) ) );
      
   return( rval );
}

/****i* makeLayerFirst() [3.0] ****************************************
*
* NAME
*    makeLayerFirst()
*
* DESCRIPTION
*    ^ <primitive 207 10 dummy layerObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *makeLayerFirst( LONG dummy, OBJECT *layerObj )
{
   OBJECT       *rval = o_nil;
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)   
      rval = AssignObj( new_int( (int) UpfrontLayer( dummy, layr ) ) );
      
   return( rval );
}

/****i* placeLayer() [3.0] ********************************************
*
* NAME
*    placeLayer()
*
* DESCRIPTION
*    ^ <primitive 207 11 layerObject thisLayer>
***********************************************************************
*
*/

METHODFUNC OBJECT *placeLayer( OBJECT *layObj1, OBJECT *layObj2 )
{
   OBJECT       *rval = o_nil;
   struct Layer *lay1 = (struct Layer *) CheckObject( layObj1 );
   struct Layer *lay2 = (struct Layer *) CheckObject( layObj2 );
   
   if (NilChk( (APTR) lay1 ) == FALSE && NilChk( (APTR) lay2 ) == FALSE)   
      rval = AssignObj( new_int( (int) MoveLayerInFrontOf( lay1, lay2 )));
      
   return( rval );
}

/****i* whichLayerContains() [3.0] ************************************
*
* NAME
*    whichLayerContains()
*
* DESCRIPTION
*    ^ <primitive 207 12 private x y>
***********************************************************************
*
*/

METHODFUNC OBJECT *whichLayerContains( OBJECT *liObj, LONG x, LONG y )
{
   OBJECT       *rval = o_nil;
   struct Layer *layr = (struct Layer *) NULL;
   LIPTR         li   = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      {
      layr = WhichLayer( li, x, y );

      rval = AssignObj( new_address( (ULONG) layr ) );
      }
      
   return( rval );
}

/****i* swapBitsFrom() [3.0] ******************************************
*
* NAME
*    swapBitsFrom()
*
* DESCRIPTION
*    <primitive 207 13 rastPort clipRectObje>
***********************************************************************
*
*/

METHODFUNC void swapBitsFrom( OBJECT *rpObj, OBJECT *rectObj )
{
   struct RastPort *rp = (struct RastPort *) CheckObject( rpObj );
   struct ClipRect *cr = (struct ClipRect *) CheckObject( rectObj );
   
   if (NilChk( (APTR) rp ) == FALSE && NilChk( (APTR) cr ) == FALSE)
      SwapBitsRastPortClipRect( rp, cr );

   return;
}

/****i* beginLayerUpdate() [3.0] **************************************
*
* NAME
*    beginLayerUpdate()
*
* DESCRIPTION
*    ^ <primitive 207 14 layerObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *beginLayerUpdate( OBJECT *layerObj )
{
   OBJECT       *rval = o_nil;
   struct Layer *layr = (struct Layer *) NULL;
   
   if (NilChk( (APTR) layr ) == FALSE)
      rval = AssignObj( new_int( (int) BeginUpdate( layr )));
      
   return( rval );
}

/****i* endLayerUpdate() [3.0] ****************************************
*
* NAME
*    endLayerUpdate()
*
* DESCRIPTION
*    <primitive 207 15 layerObject flag>
***********************************************************************
*
*/

METHODFUNC void endLayerUpdate( OBJECT *layerObj, ULONG flag )
{
   struct Layer *layr = (struct Layer *) NULL;

   if (NilChk( (APTR) layr ) == FALSE)
      EndUpdate( layr, flag );
      
   return;
}

/****i* lockLayer() [3.0] *********************************************
*
* NAME
*    lockLayer()
*
* DESCRIPTION
*    <primitive 207 16 dummy layerObject>
***********************************************************************
*
*/

METHODFUNC void lockLayer( LONG dummy, OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) NULL;

   if (NilChk( (APTR) layr ) == FALSE)
      LockLayer( dummy, layr );
      
   return;
}

/****i* unlockLayer() [3.0] *******************************************
*
* NAME
*    unlockLayer()
*
* DESCRIPTION
*    <primitive 207 17 layerObject>
***********************************************************************
*
*/

METHODFUNC void unlockLayer( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) NULL;

   if (NilChk( (APTR) layr ) == FALSE)
      UnlockLayer( layr );
      
   return;
}

/****i* lockAllLayers() [3.0] *****************************************
*
* NAME
*    lockAllLayers()
*
* DESCRIPTION
*    <primitive 207 18 private>
***********************************************************************
*
*/

METHODFUNC void lockAllLayers( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      LockLayers( li );
      
   return;
}

/****i* unlockAllLayers() [3.0] ***************************************
*
* NAME
*    unlockAllLayers()
*
* DESCRIPTION
*    <primitive 207 19 private>
***********************************************************************
*
*/

METHODFUNC void unlockAllLayers( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      UnlockLayers( li );
      
   return;
}

/****i* lockLayerInfo() [3.0] *****************************************
*
* NAME
*    lockLayerInfo()
*
* DESCRIPTION
*    <primitive 207 20 private>
***********************************************************************
*
*/

METHODFUNC void lockLayerInfo( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      LockLayerInfo( li );
      
   return;
}

/****i* unlockLayerInfo() [3.0] ***************************************
*
* NAME
*    unlockLayerInfo()
*
* DESCRIPTION
*    <primitive 207 21 private>
***********************************************************************
*
*/

METHODFUNC void unlockLayerInfo( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      UnlockLayerInfo( li );
      
   return;
}

/****i* installClipRegion() [3.0] *************************************
*
* NAME
*    installClipRegion()
*
* DESCRIPTION
*    ^ <primitive 207 22 layerObject aRegion>
***********************************************************************
*
*/

METHODFUNC OBJECT *installClipRegion( OBJECT *layerObj, OBJECT *regnObj )
{
   struct Layer  *layr = (struct Layer  *) CheckObject( layerObj );
   struct Region *regn = (struct Region *) CheckObject( regnObj );
   struct Region *rval = (struct Region *) NULL;
   
   if (NilChk( (APTR) layr ) == FALSE && NilChk( (APTR) regn ) == FALSE)
      rval = InstallClipRegion( layr, (const struct Region *) regn );
      
   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval )));
}

/****i* fattenLayerInfo() [3.0] ***************************************
*
* NAME
*    fattenLayerInfo()
*
* DESCRIPTION
*    ^ <primitive 207 23 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *fattenLayerInfo( OBJECT *liObj )
{
   LIPTR   li   = (LIPTR) CheckObject( liObj );
   OBJECT *rval = o_nil;

   if (NilChk( (APTR) li ) == FALSE)   
      rval = AssignObj( new_address( (ULONG) FattenLayerInfo( li )));

   return( rval );
}

/****i* thinLayerInfo() [3.0] *****************************************
*
* NAME
*    thinLayerInfo()
*
* DESCRIPTION
*    <primitive 207 24 private>
***********************************************************************
*
*/

METHODFUNC void thinLayerInfo( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );

   if (NilChk( (APTR) li ) == FALSE)   
      ThinLayerInfo( li );

   return;
}

/****i* createTopLayerHook() [3.0] ************************************
*
* NAME
*    createTopLayerHook()
*
* DESCRIPTION
*    ^ <primitive 207 25 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *createTopLayerHook( OBJECT *liObj, 
                                       OBJECT *bmObj1,
                                       LONG    x0, LONG y0,
                                       LONG    x1, LONG y1,
                                       LONG    flags,
                                       OBJECT *hookObj,
                                       OBJECT *bmObj2
                                     )
{
   struct BitMap *bm1  = (struct BitMap *) CheckObject( bmObj1 );
   struct BitMap *bm2  = (struct BitMap *) CheckObject( bmObj2 );
   struct Hook   *hook = (struct Hook   *) CheckObject( hookObj );
   struct Layer  *layr = (struct Layer  *) NULL;
   
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   OBJECT *rval = o_nil;
   
   if (  (NilChk( (APTR) bm1  ) == TRUE)
      || (NilChk( (APTR) li   ) == TRUE)
      || (NilChk( (APTR) hook ) == TRUE))
      {
      return( rval );
      }
   else
      {
      layr = CreateUpfrontHookLayer( li, bm1, x0, y0, 
                                     x1, y1, flags, hook, bm2 
                                   );
      
      if (layr) // != NULL)
         rval = AssignObj( new_address( (ULONG) layr ) );
      }

   return( rval );      
}

/****i* createLastLayerHook() [3.0] ***********************************
*
* NAME
*    createLastLayerHook()
*
* DESCRIPTION
*    ^ <primitive 207 26 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *createLastLayerHook( OBJECT *liObj, 
                                        OBJECT *bmObj1,
                                        LONG    x0, LONG y0,
                                        LONG    x1, LONG y1,
                                        LONG    flags,
                                        OBJECT *hookObj,
                                        OBJECT *bmObj2
                                      )
{
   struct BitMap *bm1  = (struct BitMap *) CheckObject( bmObj1 );
   struct BitMap *bm2  = (struct BitMap *) CheckObject( bmObj2 );
   struct Hook   *hook = (struct Hook   *) CheckObject( hookObj );
   struct Layer  *layr = (struct Layer *) NULL;
   
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   OBJECT *rval = o_nil;
   
   if (  (NilChk( (APTR) bm1  ) == TRUE)
      || (NilChk( (APTR) li   ) == TRUE)
      || (NilChk( (APTR) hook ) == TRUE))
      {
      return( rval );
      }
   else
      {
      layr = CreateBehindHookLayer( li, bm1, x0, y0, 
                                    x1, y1, flags, hook, bm2 
                                  );
      
      if (layr) // != NULL)
         rval = AssignObj( new_address( (ULONG) layr ) );
      }

   return( rval );      
}

/****i* installLayerHook() [3.0] **************************************
*
* NAME
*    installLayerHook()
*
* DESCRIPTION
*    ^ <primitive 207 27 private hookObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *installLayerHook( OBJECT *layerObj, OBJECT *hookObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   struct Hook  *hook = (struct Hook  *) CheckObject( hookObj  );
   struct Hook  *rhk  = (struct Hook  *) NULL;
   
   OBJECT *rval = o_nil;
   
   if (  (NilChk( (APTR) layr ) == TRUE)
      || (NilChk( (APTR) hook ) == TRUE))
      {
      return( rval );
      }
   else
      {
      rhk = InstallLayerHook( layr, hook );
      
      if (rhk) // != NULL)
         rval = AssignObj( new_address( (ULONG) rhk ) );
      }

   return( rval );      
}

/****i* installLayerInfoHook() [3.0] **********************************
*
* NAME
*    installLayerInfoHook()
*
* DESCRIPTION
*    ^ <primitive 207 28 private hookObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *installLayerInfoHook( OBJECT *liObj, OBJECT *hookObj )
{
   struct Hook *hook = (struct Hook *) CheckObject( hookObj );
   struct Hook *rhk  = (struct Hook *) NULL;
   LIPTR        li   = (LIPTR) CheckObject( liObj );
   OBJECT      *rval = o_nil;
   
   if (  (NilChk( (APTR) li   ) == TRUE)
      || (NilChk( (APTR) hook ) == TRUE))
      {
      return( rval );
      }
   else
      {
      rhk = InstallLayerInfoHook( li, (const struct Hook *) hook );
      
      if (rhk) // != NULL)
         rval = AssignObj( new_address( (ULONG) rhk ) );
      }

   return( rval );      
}

/****i* sortLayerCR() [3.0] *******************************************
*
* NAME
*    sortLayerCR()
*
* DESCRIPTION
*    <primitive 207 29 layerObject dx dy>
***********************************************************************
*
*/

METHODFUNC void sortLayerCR( OBJECT *layerObj, LONG dx, LONG dy )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)
      SortLayerCR( layr, dx, dy );
   
   return;   
}

/****i* doClipRectHook() [3.0] ****************************************
*
* NAME
*    doClipRectHook()
*
* DESCRIPTION
*    <primitive 207 30 hookObj rastPortObj x0 y0 x1 y1>
***********************************************************************
*
*/

METHODFUNC void doClipRectHook( OBJECT *hookObj,
                                OBJECT *rportObj,
                                int x0, int y0, int x1, int y1
                              )
{
   struct Hook      *hook  = (struct Hook      *) CheckObject( hookObj  );
   struct RastPort  *rport = (struct RastPort  *) CheckObject( rportObj );
   struct Rectangle  rect  = { 0, };

   if ((NilChk( (APTR) hook  ) == TRUE) || (NilChk( (APTR) rport ) == TRUE))
      return;
   
   rect.MinX = x0;
   rect.MinY = y0;
   rect.MaxX = x1;
   rect.MaxY = y1;
   
   DoHookClipRects( hook, rport, (const struct Rectangle *) &rect ); 

   return;
}

/****i* initLayers() [3.0] ********************************************
*
* NAME
*    initLayers()
*
* DESCRIPTION
*    <primitive 207 31 private>
***********************************************************************
*
*/

METHODFUNC void initLayers( OBJECT *liObj )
{
   LIPTR li = (LIPTR) CheckObject( liObj );
   
   if (NilChk( (APTR) li ) == FALSE)
      InitLayers( li );
      
   return;
}

/****i* lockLayerROM() [3.0] ******************************************
*
* NAME
*    lockLayerROM()
*
* DESCRIPTION
*    <primitive 207 32 layerObject>
***********************************************************************
*
*/

METHODFUNC void lockLayerROM( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)
      LockLayerRom( layr );
      
   return;
}

/****i* unlockLayerROM() [3.0] ****************************************
*
* NAME
*    unlockLayerROM()
*
* DESCRIPTION
*    <primitive 207 33 layerObject>
***********************************************************************
*
*/

METHODFUNC void unlockLayerROM( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == FALSE)
      UnlockLayerRom( layr );
      
   return;
}

/****i* attemptToLockLayerROM() [3.0] *********************************
*
* NAME
*    attemptToLockLayerROM()
*
* DESCRIPTION
*    ^ <primitive 207 34 layerObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *attemptToLockLayerROM( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   OBJECT       *rval = o_false;
   
   if (NilChk( (APTR) layr ) == FALSE)
      if (AttemptLockLayerRom( layr ) == TRUE)
         rval = o_true;
      
   return( rval );
}

/****i* newRegion() [3.0] *********************************************
*
* NAME
*    newRegion()
*
* DESCRIPTION
*    ^ <primitive 207 35 >
***********************************************************************
*
*/

METHODFUNC OBJECT *newRegion( void )
{
   struct Region *rval = NewRegion();
   
   if (!rval) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* disposeRegion() [3.0] *****************************************
*
* NAME
*    disposeRegion()
*
* DESCRIPTION
*    <primitive 207 36 regionObject>
***********************************************************************
*
*/

METHODFUNC void disposeRegion( OBJECT *regnObj )
{
   struct Region *regn = (struct Region *) CheckObject( regnObj );
   
   if (NilChk( (APTR) regn ) == FALSE)
      DisposeRegion( regn );
      
   return;
}

/****i* andRegion() [3.0] *********************************************
*
* NAME
*    andRegion()
*
* DESCRIPTION
*    <primitive 207 37 regionObj x0 y0 x1 y1>
***********************************************************************
*
*/

METHODFUNC void andRegion( OBJECT *regnObj,
                             int x0, int y0, int x1, int y1
                           )
{
   struct Region    *regn = (struct Region *) CheckObject( regnObj );
   struct Rectangle  rect = { 0, };

   if (NilChk( (APTR) regn ) == TRUE)
      return;
      
   rect.MinX = x0;
   rect.MinY = y0;
   rect.MaxX = x1;
   rect.MaxY = y1;
   
   AndRectRegion( regn, (const struct Rectangle *) &rect );

   return;
}

/****i* orRegion() [3.0] **********************************************
*
* NAME
*    orRegion()
*
* DESCRIPTION
*    ^ <primitive 207 38 regionObject x0 y0 x1 y1>
***********************************************************************
*
*/

METHODFUNC OBJECT *orRegion( OBJECT *regnObj,
                             int x0, int y0, int x1, int y1
                           )
{
   struct Region    *regn = (struct Region *) CheckObject( regnObj );
   struct Rectangle  rect = { 0, };

   if (NilChk( (APTR) regn ) == TRUE)
      return( o_nil );

   rect.MinX = x0;
   rect.MinY = y0;
   rect.MaxX = x1;
   rect.MaxY = y1;
   
   if (OrRectRegion( regn, (const struct Rectangle *) &rect ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* xorRegion() [3.0] *********************************************
*
* NAME
*    xorRegion()
*
* DESCRIPTION
*    ^ <primitive 207 39 regionObject x0 y0 x1 y1>
***********************************************************************
*
*/

METHODFUNC OBJECT *xorRegion( OBJECT *regnObj,
                              int x0, int y0, int x1, int y1
                            )
{
   struct Region    *regn = (struct Region *) CheckObject( regnObj );
   struct Rectangle  rect = { 0, };

   if (NilChk( (APTR) regn ) == TRUE)
      return( o_nil );

   rect.MinX = x0;
   rect.MinY = y0;
   rect.MaxX = x1;
   rect.MaxY = y1;
   
   if (XorRectRegion( regn, (const struct Rectangle *) &rect ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* clearRectRegion() [3.0] ***************************************
*
* NAME
*    clearRectRegion()
*
* DESCRIPTION
*    ^ <primitive 207 40 regionObject x0 y0 x1 y1>
***********************************************************************
*
*/

METHODFUNC OBJECT *clearRectRegion( OBJECT *regnObj, 
                                    int x0, int y0, int x1, int y1
                                  )
{
   struct Region    *regn = (struct Region *) CheckObject( regnObj );
   struct Rectangle  rect = { 0, };

   if (NilChk( (APTR) regn ) == TRUE)
      return( o_nil );

   rect.MinX = x0;
   rect.MinY = y0;
   rect.MaxX = x1;
   rect.MaxY = y1;
   
   if (ClearRectRegion( regn, (const struct Rectangle *) &rect ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* orRegionRegion() [3.0] ****************************************
*
* NAME
*    orRegionRegion()
*
* DESCRIPTION
*    ^ <primitive 207 41 regionObject regiojnObject2>
***********************************************************************
*
*/

METHODFUNC OBJECT *orRegionRegion( OBJECT *regnObj1, OBJECT *regnObj2 )
{
   struct Region *regn1 = (struct Region *) CheckObject( regnObj1 );
   struct Region *regn2 = (struct Region *) CheckObject( regnObj2 );
   
   if (NilChk( (APTR) regn1) == TRUE || NilChk( (APTR) regn2 ) == TRUE)
      return( o_nil );

   if (OrRegionRegion( regn1, regn2 ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* xorRegionRegion() [3.0] ***************************************
*
* NAME
*    xorRegionRegion()
*
* DESCRIPTION
*    ^ <primitive 207 42 srcRegionObject destRegionObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *xorRegionRegion( OBJECT *regnObj1, OBJECT *regnObj2 )
{
   struct Region *regn1 = (struct Region *) CheckObject( regnObj1 );
   struct Region *regn2 = (struct Region *) CheckObject( regnObj2 );
   
   if (NilChk( (APTR) regn1) == TRUE || NilChk( (APTR) regn2 ) == TRUE)
      return( o_nil );

   if (XorRegionRegion( regn1, regn2 ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* andRegionRegion() [3.0] ***************************************
*
* NAME
*    andRegionRegion()
*
* DESCRIPTION
*    ^ <primitive 207 43 srcRegionObject destRegionObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *andRegionRegion( OBJECT *regnObj1, OBJECT *regnObj2 )
{
   struct Region *regn1 = (struct Region *) CheckObject( regnObj1 );
   struct Region *regn2 = (struct Region *) CheckObject( regnObj2 );
   
   if (NilChk( (APTR) regn1) == TRUE || NilChk( (APTR) regn2 ) == TRUE)
      return( o_nil );

   if (AndRegionRegion( regn1, regn2 ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* clearRegion() [3.0] *******************************************
*
* NAME
*    clearRegion()
*
* DESCRIPTION
*    <primitive 207 44 regionObject>
***********************************************************************
*
*/

METHODFUNC void clearRegion( OBJECT *regnObj )
{
   struct Region *regn = (struct Region *) CheckObject( regnObj );
   
   if (NilChk( (APTR) regn ) == TRUE)
      return;

   ClearRegion( regn );

   return;
}

/****i* synchronizeSuperBitMap() [3.0] ********************************
*
* NAME
*    synchronizeSuperBitMap()
*
* DESCRIPTION
*    <primitive 207 45 layerObject>
***********************************************************************
*
*/

METHODFUNC void synchronizeSuperBitMap( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == TRUE)
      return;
   else
      SyncSBitMap( layr );
      
   return;
}

/****i* copySuperBitMap() [3.0] ***************************************
*
* NAME
*    copySuperBitMap()
*
* DESCRIPTION
*    <primitive 207 46 layerObject>
***********************************************************************
*
*/

METHODFUNC void copySuperBitMap( OBJECT *layerObj )
{
   struct Layer *layr = (struct Layer *) CheckObject( layerObj );
   
   if (NilChk( (APTR) layr ) == TRUE)
      return;
   else
      CopySBitMap( layr );
      
   return;
}
    
/****h* HandleLayers() [3.0] ******************************************
*
* NAME
*    HandleLayers() {Primitive 207 0-46}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    Layers interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleLayers( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   BOOL    openedLayersLib = FALSE;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 207 );

      return( rval );
      }

   numargs--;

   if (!LayersBase)
      {
      if ((LayersBase = OpenLibrary( "layers.library", 0 )))
         {
         openedLayersLib = TRUE;
#        ifdef __amigaos4__
         if (!(ILayers = (struct LayersIFace *) GetInterface( LayersBase, "main", 1, NULL )))
	    {
	    openedLayersLib = FALSE;

            return( rval );
	    }
	 else
	    openedLayersLib = TRUE;
#        endif
	 }
      }

   switch (int_value( args[0] ))
      {
      case 0: // disposeLayerInfo [private]
         disposeLayerInfo( args[1] );

         break;

      case 1: // ^ private <- newLayerInfo
         rval = newLayerInfo();
         break;
      
      case 2: // createUpFrontLayer:start:end:flags:second:
              // ^ <primitive 207 2 private thisBitMap x0 y0 x1 y1 flags bitMap2>

         if (ChkArgCount( 8, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[3] ) || !is_integer( args[4] )
            || !is_integer( args[5] ) || !is_integer( args[6] )
            || !is_integer( args[7] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = createUpFrontLayer( args[1], args[2],
                                       (LONG) int_value( args[3] ), 
                                       (LONG) int_value( args[4] ), 
                                       (LONG) int_value( args[5] ), 
                                       (LONG) int_value( args[6] ), 
                                       (LONG) int_value( args[7] ),
                                       args[8]
                                     ); 
            }

         break;

      case 3: // createBehindLayer:start:end:flags:second:
              // ^ <primitive 207 3 private thisBitMap x0 y0 x1 y1 flags bitMap2>
     
         if (ChkArgCount( 8, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[3] ) || !is_integer( args[4] )
            || !is_integer( args[5] ) || !is_integer( args[6] )
            || !is_integer( args[7] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = createBehindLayer( args[1], args[2],
                                      (LONG) int_value( args[3] ), 
                                      (LONG) int_value( args[4] ), 
                                      (LONG) int_value( args[5] ), 
                                      (LONG) int_value( args[6] ), 
                                      (LONG) int_value( args[7] ),
                                      args[8]
                                    ); 
            }

         break;

      case 4: // deleteLayer: layerObject
              // ^ <primitive 207 4 dummy layerObject>
      
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 207 );
         else
            rval = deleteLayer( (LONG) int_value( args[1] ), args[2] ); 

         break;
         
      case 5: // moveLayer: layerObject to: newPoint
              // ^ <primitive 207 5 dummy layerObject dx dy>

         if (   !is_integer( args[1] ) || !is_integer( args[3] )
             || !is_integer( args[4] ))
            (void) PrintArgTypeError( 207 );
         else
            rval = moveLayer( (LONG) int_value( args[1] ),
                                                args[2],
                              (LONG) int_value( args[3] ),
                              (LONG) int_value( args[4] )
                            ); 
         break;
         
      case 6: // sizeLayer: layerObject by: lowRightCornerPoint
              // ^ <primitive 207 6 dummy layerObject dx dy>
      
         if (   !is_integer( args[1] ) || !is_integer( args[3] )
             || !is_integer( args[4] ))
            (void) PrintArgTypeError( 207 );
         else
            rval = sizeLayer( (LONG) int_value( args[1] ),
                                                args[2],
                              (LONG) int_value( args[3] ),
                              (LONG) int_value( args[4] )
                            ); 
         break;
         
      case 7: // moveAndSizeLayer: layerObject to: newPoint sizeChange: dPoint
              // ^ <primitive 207 7 layerObject dx dy dw dh>

         if (   !is_integer( args[2] ) || !is_integer( args[3] )
             || !is_integer( args[4] ) || !is_integer( args[5] ))
            (void) PrintArgTypeError( 207 );
         else
            rval = moveAndSizeLayer(                   args[1],
                                     (LONG) int_value( args[2] ),
                                     (LONG) int_value( args[3] ),
                                     (LONG) int_value( args[4] ),
                                     (LONG) int_value( args[5] )
                                   ); 
         break;
         
      case 8: // scrollLayer: layerObject by: deltaPoint
              // <primitive 207 8 layerObject dx dy>

         if (!is_integer( args[1] ) || !is_integer( args[3] )
            || !is_integer( args[4] ))
            (void) PrintArgTypeError( 207 );
         else
            scrollLayer( (LONG) int_value( args[1] ),
                                           args[2], 
                         (LONG) int_value( args[3] ),
                         (LONG) int_value( args[4] )
                       ); 
         break;
         
      case 9: // makeLayerLast: layerObject
              // ^ <primitive 207 9 dummy layerObject>

         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 207 );
         else
            rval = makeLayerLast( (LONG) int_value( args[1] ), args[2] );

         break;
         
      case 10: // makeLayerFirst: layerObject
               // ^ <primitive 207 10 dummy layerObject>
      
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 207 );
         else
            rval = makeLayerFirst( (LONG) int_value( args[1] ), args[2] );

         break;
         
      case 11: // placeLayer: layerObject inFrontOf: thisLayer
               // ^ <primitive 207 11 layerObject thisLayer>
         rval = placeLayer( args[1], args[2] );
         break;
          
      case 12: // whichLayerContains: thisPoint
               // ^ <primitive 207 12 private x y>

         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 207 );
         else
            rval = whichLayerContains(                   args[1], 
                                       (LONG) int_value( args[2] ), 
                                       (LONG) int_value( args[3] )
                                     );
         break;
         
      case 13: // swapBitsFrom: rastPort with: clipRectangleObj
               // <primitive 207 13 rastPort clipRectangleObj>

         swapBitsFrom( args[1], args[2] );
         break;
         
      case 14: // beginLayerUpdate: layerObject
               // ^ <primitive 207 14 layerObject>
         rval = beginLayerUpdate( args[1] );
         break;

      case 15: // endLayerUpdate: layerObject flag: flag
               // <primitive 207 15 layerObject flag>

         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 207 );
         else
            endLayerUpdate( args[1], (LONG) int_value( args[2] ) );

         break;
         
      case 16: // lockLayer: layerObject
               // <primitive 207 16 dummy layerObject>

         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 207 );
         else
            lockLayer( (LONG) int_value( args[1] ), args[2] );

         break;
         
      case 17: // unlockLayer: layerObject
               // <primitive 207 17 layerObject>
         unlockLayer( args[1] );
         break;

      case 18: // lockAllLayers
               // <primitive 207 18 private>
         lockAllLayers( args[1] );
         break;

      case 19: // unlockAllLayers
               // <primitive 207 19 private>
         unlockAllLayers( args[1] );
         break;

      case 20: // lockLayerInfo
               // <primitive 207 20 private>
         lockLayerInfo( args[1] );
         break;

      case 21: // unlockLayerInfo
               // <primitive 207 21 private>
         unlockLayerInfo( args[1] );
         break;

      case 22: // installClipRegion: aRegion to: layerObject
               // ^ <primitive 207 22 layerObject aRegion>
         rval = installClipRegion( args[1], args[2] );
         break;

      case 23: // fattenLayerInfo
               // ^ <primitive 207 23 private>
         rval = fattenLayerInfo( args[1] );
         break;

      case 24: // thinLayerInfo
               // <primitive 207 24 private>
         thinLayerInfo( args[1] );
         break;

      case 25: // createTopLayerHook: hook with: thisBitMap 
               //               from: sPoint to: ePoint flags: f second: bitMap2
               // ^ <primitive 207 25 private thisBitMap x0 y0 x1 y1 f hook bitMap2>

         if (ChkArgCount( 9, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[3] ) || !is_integer( args[4] )
            || !is_integer( args[5] ) || !is_integer( args[6] )
            || !is_integer( args[7] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = createTopLayerHook( args[1], args[2],
                                       (LONG) int_value( args[3] ), 
                                       (LONG) int_value( args[4] ), 
                                       (LONG) int_value( args[5] ), 
                                       (LONG) int_value( args[6] ), 
                                       (LONG) int_value( args[7] ),
                                       args[8], args[9]
                                     ); 
            }

         break;

      case 26: // createLastLayerHook: hook with: thisBitMap 
               //                from: sPoint to: ePoint flags: f second: bitMap2
               // ^ <primitive 207 26 private thisBitMap x0 y0 x1 y1 f hook bitMap2>

         if (ChkArgCount( 9, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[3] ) || !is_integer( args[4] )
            || !is_integer( args[5] ) || !is_integer( args[6] )
            || !is_integer( args[7] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = createLastLayerHook( args[1], args[2],
                                        (LONG) int_value( args[3] ), 
                                        (LONG) int_value( args[4] ), 
                                        (LONG) int_value( args[5] ), 
                                        (LONG) int_value( args[6] ), 
                                        (LONG) int_value( args[7] ),
                                        args[8], args[9]
                                      ); 
            }

         break;

      case 27: // installLayerHook: hook to: layerObject
               // ^ <primitive 207 27 layerObject hook>
         rval = installLayerHook( args[1], args[2] );
         break;

      case 28: // installLayerInfoHook: hook
               // ^ <primitive 207 28 private hook>

         rval = installLayerInfoHook( args[1], args[2] );
         break;

      case 29: // sortLayerCR: layerObject at: aPoint
               // <primitive 207 29 layerObject dx dy>

         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 207 );
         else
            sortLayerCR(                   args[1], 
                         (LONG) int_value( args[2] ), 
                         (LONG) int_value( args[3] )
                       );
         break;
         
      case 30: // doClipRectHook: hook on: rastPortObj with: rectangleObj
               // <primitive 207 30 hook rastPortObj x0 y0 x1 y1>

         if (ChkArgCount( 6, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[3] ) || !is_integer( args[4] )
            || !is_integer( args[5] ) || !is_integer( args[6] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            doClipRectHook( args[1], args[2],
                            (LONG) int_value( args[3] ), 
                            (LONG) int_value( args[4] ), 
                            (LONG) int_value( args[5] ), 
                            (LONG) int_value( args[6] )
                          ); 
            }

         break;

      case 31: // initLayers: layerInfoObject
               // <primitive 207 31 private>
         initLayers( args[1] );
         break;

      case 32: // lockLayerROM: layerObject
               // <primitive 207 32 layerObject>

         lockLayerROM( args[1] );
         break;

      case 33: // unlockLayerROM: layerObject
               // <primitive 207 33 layerObject>

         unlockLayerROM( args[1] );
         break;

      case 34: // attemptToLockLayerROM: layerObject
               // ^ <primitive 207 34 layerObject>

         attemptToLockLayerROM( args[1] );
         break;

      case 35: // newRegion  ^ <primitive 207 35>

         rval = newRegion();
         break;

      case 36: // disposeRegion: regionObject
               // <primitive 207 36 regionObject>

         disposeRegion( args[1] );
         break;

      case 37: // andRegion: aRegion with: aRectangle
               // <primitive 207 37 aRegion x0 y0 x1 y1>

         if (ChkArgCount( 5, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[2] ) || !is_integer( args[3] )
            || !is_integer( args[4] ) || !is_integer( args[5] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            andRegion( args[1], (LONG) int_value( args[2] ), 
                                (LONG) int_value( args[3] ), 
                                (LONG) int_value( args[4] ), 
                                (LONG) int_value( args[5] )
                     ); 
            }

         break;

      case 38: // orRegion: aRegion with: aRectangle
               // ^ <primitive 207 38 aRegion x0 y0 x1 y1>

         if (ChkArgCount( 5, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[2] ) || !is_integer( args[3] )
            || !is_integer( args[4] ) || !is_integer( args[5] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = orRegion( args[1], (LONG) int_value( args[2] ), 
                                      (LONG) int_value( args[3] ), 
                                      (LONG) int_value( args[4] ), 
                                      (LONG) int_value( args[5] )
                           ); 
            }

         break;

      case 39: // xorRegion: aRegion with: aRectangle
               // ^ <primitive 207 39 aRegion x0 y0 x1 y1>

         if (ChkArgCount( 5, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[2] ) || !is_integer( args[3] )
            || !is_integer( args[4] ) || !is_integer( args[5] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = xorRegion( args[1], (LONG) int_value( args[2] ), 
                                       (LONG) int_value( args[3] ), 
                                       (LONG) int_value( args[4] ), 
                                       (LONG) int_value( args[5] )
                            ); 
            }

         break;

      case 40: // clearRegion: aRegion in: aRectangle
               // ^ <primitive 207 40 aRegion x0 y0 x1 y1>

         if (ChkArgCount( 5, numargs, 207 ) != 0)
            return( ReturnError() );

         if (  !is_integer( args[2] ) || !is_integer( args[3] )
            || !is_integer( args[4] ) || !is_integer( args[5] ))
            {
            (void) PrintArgTypeError( 207 );
            }
         else
            {
            rval = clearRectRegion( args[1], (LONG) int_value( args[2] ), 
                                             (LONG) int_value( args[3] ), 
                                             (LONG) int_value( args[4] ), 
                                             (LONG) int_value( args[5] )
                                  ); 
            }

         break;

      case 41: // orRegionRegion: destRegion to: srcRegion
               // ^ <primitive 207 41 srcRegion destRegion>
         rval = orRegionRegion( args[1], args[2] );
         break;

      case 42: // xorRegionRegion: srcRegion and: destRegion
               // ^ <primitive 207 42 srcRegion destRegion>

         rval = xorRegionRegion( args[1], args[2] );
         break;

      case 43: // andRegionRegion: srcRegion and: destRegion 
               // <primitive 207 43 srcRegion destRegion>

         rval = andRegionRegion( args[1], args[2] );
         break;

      case 44: // clearRegion: aRegion
               // <primitive 207 44 aRegion>

         clearRegion( args[1] );
         break;

      case 45: // synchronizeSuperBitMap: layerObject
               // <primitive 207 45 layerObject>

         synchronizeSuperBitMap( args[1] );
         break;

      case 46: // copySuperBitMap: layerObject
               // <primitive 207 46 layerObject>
      
         copySuperBitMap( args[1] );
         break;

      default:
         (void) PrintArgTypeError( 207 );

         break;
      }

   if (openedLayersLib == TRUE)
      {
#     ifdef __amigaos4__
      if (ILayers)
         {
         DropInterface( (struct Interface *) ILayers );
	 ILayers = NULL;
	 }
#     endif

      if (LayersBase)
         {
         CloseLibrary( LayersBase );

	 LayersBase = NULL;
	 }
      }

   return( rval );
}

/* ---------------------- END of Layers.c file! ----------------------- */
