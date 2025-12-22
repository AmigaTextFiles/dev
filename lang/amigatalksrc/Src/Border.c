/****h AmigaTalk/Border.c [3.0] ****************************************
*
* NAME
*    Border.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk Border & BitMap primitives.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC ULONG FindIntuiPointer( char *title, int which );
*
*    PUBLIC OBJECT *HandleBorders( int numargs, OBJECT **args ); <187>
*
*    PUBLIC OBJECT *HandleBitMaps( int numargs, OBJECT **args ); <189>
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/Border.c 3.0 (24-Oct-2004) by J.T. Steichen
*    
* TODO 
*    Add error checking to ReadBitMap() & WriteBitMap().
************************************************************************
*/

#include <stdio.h>
#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <graphics/gfx.h> // For struct BitMap.

#include <dos/dos.h>

#ifdef    __SASC
# include <clib/exec_protos.h>
#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

IMPORT struct ExecIFace      *IExec;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct IntuitionIFace *IIntuition;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"
 
#include "FuncProtos.h"

IMPORT OBJECT *o_nil;
IMPORT UBYTE  *AllocProblem;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// ------------------------------------------------------------------

PRIVATE SHORT Def_Pts[10] = { 0,0, 81,0, 81,13, 0,13, 0,0 };
     
PRIVATE struct Border  Default_Border = {

   0, 0, 1, 0, JAM2, 5, &Def_Pts[0], NULL
};

// --------- Functions: ---------------------------------------------

/****h* FindIntuiPointer() [1.9] ************************************
*
* NAME
*    FindIntuiPointer()
*
* SYNOPSIS
*    ULONG ptr = FindIntuiPointer( char *title, int which );
*
*    if which = 0, return a screen pointer.
*    else          return a window pointer.
*
* DESCRIPTION
*    Return a pointer to either a Screen or Window from
*    IntuitionBase.
*********************************************************************
*
*/

PUBLIC ULONG FindIntuiPointer( char *title, int which )
{
#  ifdef  __SASC
   IMPORT struct IntuitionBase *IntuitionBase;
#  else
   IMPORT struct Library *IntuitionBase;
#  endif
   
   ULONG rval  = 0L;
   
   if (which == 0) // find a Screen Pointer?
      rval = (ULONG) FindScreenPtr( title ); // In Global.c
   else            // find a Window Pointer: 
      rval = (ULONG) FindWindowPtr( title ); // In Global.c 
 
   return( rval );
}

/****i* CopyDefaultBorder() [1.9] ***********************************
*
* NAME
*    CopyDefaultBorder()
*
* DESCRIPTION
*    Set a Border struct to Default values.
*********************************************************************
*
*/

SUBFUNC void CopyDefaultBorder( struct Border *newbord )
{
   CopyMem( (char *) &Default_Border, (char *) newbord, 
            (long) sizeof( struct Border )
          );
   return;
}

/****i* BorderRemove() [1.9] ****************************************
*
* NAME
*    BorderRemove()
*
* DESCRIPTION
*    Free the Border from the AmigaTalk Program.
*    <primitive 187 0 private>
*********************************************************************
*
*/

METHODFUNC void BorderRemove( OBJECT *borderObj )
{
   struct Border *bptr = (struct Border *) CheckObject( borderObj );

   if (NullChk( (OBJECT *) bptr ) == TRUE)
      return;
      
   if (bptr->XY != &Def_Pts[0])
      {
      AT_FreeVec( bptr->XY, "borderPoints", TRUE );
      AT_FreeVec( bptr    , "border"      , TRUE );
      }

   return;
}

#ifdef    __SASC
# define  CHIPMEM  MEMF_PUBLIC | MEMF_CHIP | MEMF_CLEAR
# define  FASTMEM  MEMF_PUBLIC | MEMF_FAST | MEMF_CLEAR
#else
# define  CHIPMEM  MEMF_SHARED | MEMF_CHIP | MEMF_CLEAR
# define  FASTMEM  MEMF_SHARED | MEMF_FAST | MEMF_CLEAR
#endif

/****i* BorderAdd() [1.9] *******************************************
*
* NAME
*    BorderAdd()
*
* DESCRIPTION
*    Add a Border with the given number of points to the
*    AmigaTalk Program.
*    ^ <primitive 187 1 numPts>
*********************************************************************
*
*/

METHODFUNC OBJECT *BorderAdd( int num_pts )
{
   struct Border  *bptr   = NULL;
   OBJECT         *rval   = o_nil;
   SHORT          *newpts = (SHORT *) NULL;

   if (!(bptr = (struct Border *) AT_AllocVec( sizeof( struct Border ),
                                               CHIPMEM, "border", TRUE ))) // ==  NULL)
      {
      MemoryOut( BdrCMsg( MSG_BD_BORDERCLASSNAME_BORDER ) );

      return( rval );
      }

   if (num_pts > 0)
      {
      newpts = (SHORT *) AT_AllocVec( num_pts * 2 * sizeof( SHORT ), 
                                      CHIPMEM, "borderPoints", TRUE
                                    );
      }

   if (!newpts) // == NULL)
      {
      MemoryOut( BdrCMsg( MSG_BD_BORDERCLASSNAME_BORDER ) );

      AT_FreeVec( bptr, "border", TRUE );

      return( rval );
      }

   CopyDefaultBorder( bptr );

   bptr->XY    = newpts;   // Override default values here.
   bptr->Count = num_pts;

   rval = AssignObj( new_address( (ULONG) bptr ) );

   return( rval );
}

/****i* GetBorderPart() [1.9] ***************************************
*
* NAME
*    GetBorderPart()
*
* DESCRIPTION
*    Return a requested part of a Border structure.
*    ^ <primitive 187 2 whichPart private>
*********************************************************************
*
*/

METHODFUNC OBJECT *GetBorderPart( int whichpart, OBJECT *borderObj )
{
   struct Border *bptr = (struct Border *) CheckObject( borderObj );
   OBJECT        *rval = o_nil;
   ULONG          chk  = 0L;

   if (NullChk( (OBJECT *) bptr ) == TRUE)
      return( rval );
               
   switch (whichpart)
      {
      case 0:  chk = (ULONG) bptr->LeftEdge;     break;
      case 1:  chk = (ULONG) bptr->TopEdge;      break;
      case 2:  chk = (ULONG) bptr->FrontPen;     break;
      case 3:  chk = (ULONG) bptr->BackPen;      break;
      case 4:  chk = (ULONG) bptr->DrawMode;     break;
      case 5:  chk = (ULONG) bptr->Count;        break;

      case 6:
         chk  = (ULONG) bptr->NextBorder;   
         
         rval = AssignObj( new_address( (ULONG) chk ));
         
         return( rval );
      
      default: 
         return( rval );
      }

   return( rval = AssignObj( new_int( (int) chk ) ) );
}

/****i* SetBorderPart() [1.9] ***************************************
*
* NAME
*    SetBorderPart()
*
* DESCRIPTION
*    Set the given Border structure part to the given value.
*    <primitive 187 3 whichPart value private>
*********************************************************************
*
*/

METHODFUNC void SetBorderPart( int     whichpart,
                               OBJECT *whatvalue, 
                               OBJECT *borderObj
                             )
{
   struct Border *bptr = (struct Border *) CheckObject( borderObj );
   
   if (!bptr) // == NULL)
      return;

   switch (whichpart)
      {
      case 0:
         bptr->LeftEdge = int_value( whatvalue );
         break;
         
      case 1:
         bptr->TopEdge = int_value( whatvalue );
         break;
         
      case 2:
         bptr->FrontPen = int_value( whatvalue );
         break;
         
      case 3:
         bptr->BackPen = int_value( whatvalue );
         break;
         
      case 4:
         bptr->DrawMode = int_value( whatvalue );
         break;
         
      case 5:
         bptr->Count = int_value( whatvalue );
         break;
         
      case 6:  
         {
         struct Border *nb = (struct Border *) CheckObject( whatvalue );
         
         bptr->NextBorder = nb;
         }
         
         break;
      
      default: break;
      }

   return;
}

/****i* SetBorderPoint() [1.9] **************************************
*
* NAME
*    SetBorderPoint()
*
* DESCRIPTION
*
* NOTES 
*    whichpoint == 1, 2, 3, 4, ...
*    <primitive 187 4 which x y private>   
*********************************************************************
*
*/

METHODFUNC void  SetBorderPoint( int whichpoint, int newx, int newy, 
                                 OBJECT *borderObj
                               )
{
   struct Border *bptr = (struct Border *) CheckObject( borderObj );
   
   if (!bptr) // == NULL)
      return;

   if (whichpoint < 1)
      return;

   bptr->XY[ 2 * (whichpoint - 1) ] = newx;
   bptr->XY[ 2 *  whichpoint - 1  ] = newy;

   return;
}

/****i* SetBorderParent() [1.9] *************************************
*
* NAME
*    SetBorderParent()
*
* DESCRIPTION
*    <primitive 187 5 parentObj self>
*********************************************************************
*
*/

METHODFUNC OBJECT *SetBorderParent( OBJECT *parentObj, OBJECT *bdrObj )
{
   ULONG oldParent = 0L;

   if (NullChk( bdrObj ) == TRUE)
      return( o_nil );
      
   oldParent = (ULONG) addr_value( bdrObj->inst_var[1] );

   if (is_bltin( parentObj ) == FALSE)
      {
      if (oldParent) // != NULL)
         {
         // De-reference count the old parent object:
         (void) obj_dec( bdrObj->inst_var[1] );

         bdrObj->inst_var[1] = AssignObj( parentObj );   
         }    
      }
   else
      return( o_nil );
      
   return( parentObj );
}

/****i* DrawABorder() [1.9] *****************************************
*
* NAME
*    DrawABorder()
*
* DESCRIPTION
*    DrawBorder() if and only if the parent object is a Screen or
*    Window (Requesters & Gadgets do this via Intuition).
*    <primitive 187 6 self>
*********************************************************************
*
*/

METHODFUNC void DrawABorder( OBJECT *borderObj )
{
   struct Window *wptr = NULL;
   struct Screen *sptr = NULL;
   struct Border *bptr = (struct Border *) CheckObject( borderObj );

   if (!bptr) // == NULL)
      return;

   wptr = (struct Window *) addr_value( borderObj->inst_var[1] );
   sptr = (struct Screen *) addr_value( borderObj->inst_var[1] );
   
   if (wptr && (wptr == (struct Window *) FindIntuiPointer( wptr->Title, 1 )))
      {
      DrawBorder( wptr->RPort, bptr, 0, 0 );
      }
   else if (sptr && (sptr == (struct Screen *) FindIntuiPointer( sptr->Title, 0 )))
      {
      DrawBorder( &(sptr->RastPort), bptr, 0, 0 );
      }
            
   return;
}

/****h* HandleBorders() [1.9] ***************************************
*
* NAME
*    HandleBorders()
*
* DESCRIPTION
*    Translate a primitive number (187) to a Border function.
*********************************************************************
*
*/

PUBLIC OBJECT *HandleBorders( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 187 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // remove <primitive 187 0 private>
         if (NullChk( args[1] ) == FALSE)
            {
            BorderRemove( args[1] );
            }
            
         break;
      
      case 1: // new: numPoints
              //   private <- <primitive 187 1 numPoints>
         if ( is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 187 );
         else
            rval = BorderAdd( int_value( args[1] ) );

         break;

      case 2: // getBorderPart
              // ^ <primitive 187 2 whichPart private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 187 );
         else
            rval = GetBorderPart( int_value( args[1] ), args[2] );

         break;
      
      case 3: // setBorderPart
              // <primitive 187 3 whichPart valueObj private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 187 );
         else
            SetBorderPart( int_value( args[1] ), args[2], args[3] );

         break;

      case 4: // setBorderPoint: thePt to: newPoint
              // <primitive 187 4 thePt (newPoint x) (newPoint y) private>
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ) )
            (void) PrintArgTypeError( 187 );
         else
            SetBorderPoint( int_value( args[1] ), int_value( args[2] ),
                            int_value( args[3] ),            args[4]
                          );
         break;

      case 5: // registerTo: parentObj
              // parent <- <primitive 187 5 parentObj self>
         SetBorderParent( args[1], args[2] ); // Border Object self.

         break;

      case 6: // draw
              // <primitive 187 6 self>
         DrawABorder( args[1] );
         break;
         
      default:
         (void) PrintArgTypeError( 187 );
         break;
      }
 
   return( rval );
}

/* -------------- primitive functions for BitMaps: -------------------- */

/****i* KillBitMap() [1.9] ******************************************
*
* NAME
*    KillBitMap()
*
* DESCRIPTION
*    Deallocate the PLANEPTRs of a BitMap.
*********************************************************************
*
*/

SUBFUNC void KillBitMap( struct BitMap *b )
{
   if (b) // != NULL)
      {
      int w = b->BytesPerRow;
      int h = b->Rows;
      int d = b->Depth;
      int i;
      
      for (i = 0; i < d; i++)
         {
         if (b->Planes[i] != NULL)
            FreeRaster( b->Planes[i], w, h );
         }
      }

   return;
}

/****h* BitMapRemove() [1.9] ****************************************
*
* NAME
*    BitMapRemove()
*
* DESCRIPTION
*    Deallocate a BitMap from AmigaTalk.
*    <primitive 189 0 private>
*********************************************************************
*
*/

METHODFUNC void BitMapRemove( OBJECT *bitmapObj )
{
   struct BitMap *bp = (struct BitMap *) CheckObject( bitmapObj );

   if (!bp) // == NULL)
      return;

   KillBitMap( bp );

   AT_FreeVec( bp, "BitMap", TRUE );

   return;
}

/****i* AmigaTalk/BitMapAdd() [1.9] *********************************
*
* NAME
*    BitMapAdd()
*
* NOTES
*    Screen & Window primitives grab BitMaps
*    & set the ParentName to their title.
*    ^ <primitive 189 1 width height depth>
*********************************************************************
*
*/

METHODFUNC OBJECT *BitMapAdd( int width, int height, int depth, int flags )
{
   struct BitMap *bptr      = NULL;
   PLANEPTR       allocated = (PLANEPTR) 1;
   OBJECT        *rval      = o_nil;
   int            j;
            
   // Now, set everything up:

   bptr = (struct BitMap *) AT_AllocVec( sizeof( struct BitMap ), 
                                         CHIPMEM, "BitMap", TRUE
                                       );

   if (!bptr) // == NULL)
      {
      MemoryOut( BdrCMsg( MSG_BD_BITMAPCLASSNAME_BORDER ) );

      return( rval );
      }

   InitBitMap( bptr, depth, width, height );

   for (j = 0; j < depth; j++)
      {
      allocated = (bptr->Planes[j] = (PLANEPTR) AllocRaster( width, height ));

      if (!allocated) // == NULL)
         {
         MemoryOut( BdrCMsg( MSG_BD_BITMAPCLASSNAME_BORDER ) );

         KillBitMap( bptr );

         AT_FreeVec( bptr, "BitMap", TRUE );
                  
         return( rval );
         }
      }

   bptr->Flags = flags & 0xFF; // Flags is a UBYTE
      
   rval = AssignObj( new_address( (ULONG) bptr ) );

   return( rval );
}

/****i* GetBitMapPart() [1.9] ***************************************
*
* NAME
*    GetBitMapPart()
*
* DESCRIPTION
*    Return the requested part of the BitMap structure.
*    <primitive 189 2 whichPart private>
*
* NOTES
*    BitMap values are always positive, this is why we can use
*    negative numbers to indicate failures.
*********************************************************************
*
*/

METHODFUNC OBJECT *GetBitMapPart( int whichpart, OBJECT *bitmapObj )
{
   struct BitMap *bp   = (struct BitMap *) CheckObject( bitmapObj );
   OBJECT        *rval = o_nil;
   
   if (!bp) // == NULL)
      return( rval );

   switch (whichpart)
      {
      case 0:  return( AssignObj( new_int( bp->BytesPerRow ) ));
      case 1:  return( AssignObj( new_int( bp->Rows ) ));
      case 2:  return( AssignObj( new_int( bp->Flags ) ));
      case 3:  return( AssignObj( new_int( bp->Depth ) ));

      default: return( rval );
      }
}

/****i* SetBitMapPart() [1.9] ***************************************
*
* NAME
*    SetBitMapPart()
*
* DESCRIPTION
*    setBitMapPart: value <primitive 189 3 whichPart value private>
*********************************************************************
*
*/

METHODFUNC void SetBitMapPart( int     whichpart, 
                               int     whatvalue, 
                               OBJECT *bitmapObj
                             )
{
   struct BitMap *bp = (struct BitMap *) CheckObject( bitmapObj );
   
   if (!bp) // == NULL)
      return;

   switch (whichpart)
      {
      case 0:
         if (whatvalue <= 0)
            whatvalue = 1;

         bp->BytesPerRow = whatvalue;
         break;
  
      case 1:
         if (whatvalue <= 0)
            whatvalue = 1;

         bp->Rows = whatvalue;
         break;
      
      case 2:
         if (whatvalue < 0)
            whatvalue = BMF_STANDARD; // 0;

         /* Valid values for Flags are 
         ** BMF_CLEAR       = 1, 
         ** BMF_DISPLAYABLE = 2,
         ** BMF_INTERLEAVED = 4,
         ** BMF_STANDARD    = 8,
         ** BMF_MINPLANES   = 16
         */
         bp->Flags = whatvalue;
         break;
      
      case 3:
         if (whatvalue <= 0 || whatvalue > 8)
            whatvalue = 1;

         bp->Depth = whatvalue;
      
      default:
         break;
      }

   return;
}

/****i* SetBitMapData() [1.9] ***************************************
*
* NAME
*    SetBitMapData()
*
* DESCRIPTION
*    Read in BitMap Data (& size fields) from the given filename.
*    <primitive 189 4 bitMapFileName private>
*********************************************************************
*
*/

METHODFUNC OBJECT *SetBitMapData( char *filename, OBJECT *bitmapObj )
{
   struct BitMap *bp   = (struct BitMap *) CheckObject( bitmapObj );
   OBJECT        *rval = o_false;

   BPTR   infile = 0; // NULL;
   UBYTE *Data   = NULL;

   char  nil1[9] = { 0, }, *n1 = &nil1[0];
   char  nil2[3] = { 0, }, *n2 = &nil2[0];

   int   j, bufsize;

   UWORD w, h;
   UBYTE d, f;
   
   if (!bp) // == NULL)
      return( rval );

   if (!(infile = Open( filename, MODE_OLDFILE ))) // == NULL)
      return( rval );

   if (Read( infile, n1, 6 ) != 6)
      {
      Close( infile );

      return( rval );
      }

   n2[0] = n1[0];   n2[1] = n1[1];   n2[2] = NIL_CHAR;

   w     = (UWORD) atoi( n2 );

   n2[0] = n1[2];   n2[1] = n2[3];   n2[2] = NIL_CHAR;

   h     = (UWORD) atoi( n2 );

   d     = n1[4];
   f     = n1[5];

   if (w != bp->BytesPerRow
         || h != bp->Rows
         || d != bp->Depth)
      {
      int okay;
      
      KillBitMap( bp );
      InitBitMap( bp, d, w, h );

      for (j = 0; j < d; j++)
         {
         okay = (int) (bp->Planes[j] 
                      = (PLANEPTR) AllocRaster( w, h ) );

         if (!okay) // == NULL)
            {
            KillBitMap( bp );

            return( rval );
            }
         }
      
      }
         
   bufsize = w * h * d;
   Data    = (UBYTE *) AT_AllocVec( bufsize, FASTMEM, "BitMapData", TRUE );

   if (!Data) // == NULL)
      {
      Close( infile );

      return( rval );
      }

   if (Read( infile, Data, bufsize ) != bufsize)
      {
      AT_FreeVec( Data, "BitMapData", TRUE ); 

      Close( infile );

      return( rval );
      }

   for (j = 0; j < d; j++)
      {
      int   planesize = w * h;
      UBYTE *p        = bp->Planes[j];
      int   k;
            
      for (k = 0; k < planesize; k++)
         *(p + k) = *(Data + k);
      }

   AT_FreeVec( Data, "BitMapData", TRUE ); 

   Close( infile );

   return( rval = o_true );
}

/****i* WriteBitMap() [1.9] *****************************************
*
* NAME
*    WriteBitMap()
*
* DESCRIPTION
*    Write BitMap Data (& size fields) to the given filename.
*    <primitive 189 5 bitMapFileName private>
*********************************************************************
*
*/

METHODFUNC void WriteBitMap( char *filename, OBJECT *bitmapObj )
{
   struct BitMap *bp      = (struct BitMap *) CheckObject( bitmapObj );
   BPTR           outfile = 0; // NULL;
   
   int   j;
   int   planesize;
   UWORD w, h;
   UBYTE d, f;
   char  nil[7], *buffer = &nil[0];
   
   if (!bp) // == NULL)
      return;

   w         = bp->BytesPerRow;
   h         = bp->Rows;
   d         = bp->Depth;
   f         = bp->Flags;
   planesize = w * h;

   if (!(outfile = Open( filename, MODE_NEWFILE ))) // == NULL)
      return;

   buffer[0] = w & 0xFF00; buffer[1] = w & 0x00FF;
   buffer[2] = h & 0xFF00; buffer[3] = h & 0x00FF;
   buffer[4] = d;          buffer[5] = f;
   buffer[6] = NIL_CHAR;

   (void) Write( outfile, buffer, 6 );
   
   for (j = 0; j < d; j++)
      (void) Write( outfile, bp->Planes[j], planesize );   

   Close( outfile );

   return;
}

// ------------------------------------------------------------------

SUBFUNC OBJECT *stealWindowBitMap( struct Window *wptr )
{
   return( AssignObj( new_address( (ULONG) wptr->RPort->BitMap ) ) );
}

/****i* stealWindowBitMap() [1.9] ***********************************
*
* NAME
*    stealWindowBitMap()
*
* DESCRIPTION
*    Return the BitMap pointer from the given window.
*    ^ <primitive 189 6 windowObj>
*********************************************************************
*
*/

METHODFUNC OBJECT *stealWindowBitMapMethod( OBJECT *windowObj )
{
   struct Window *wptr = (struct Window *) CheckObject( windowObj );
   OBJECT        *rval = o_nil;
   
   if (!wptr) // == NULL)
      return( rval );

   rval = AssignObj( new_address( (ULONG) wptr->RPort->BitMap ) );
   
   return( rval );
}

// ------------------------------------------------------------------

SUBFUNC OBJECT *stealScreenBitMap( struct Screen *sptr )
{
   return( AssignObj( new_address( (ULONG) sptr->RastPort.BitMap )));
}

/****i* stealScreenBitMap() [1.9] ***********************************
*
* NAME
*    stealScreenBitMap()
*
* DESCRIPTION
*    Return the BitMap pointer from the given screen.
*    ^ <primitive 189 7 screenObj>
*********************************************************************
*
*/

METHODFUNC OBJECT *stealScreenBitMapMethod( OBJECT *screenObj )
{
   struct Screen *sptr = (struct Screen *) CheckObject( screenObj );
   OBJECT        *rval = o_nil;
   
   if (!sptr) // == NULL)
      return( rval );
      
   rval = AssignObj( new_address( (ULONG) sptr->RastPort.BitMap ) );
   
   return( rval );
}

/****i* stealTitleWindowBitMap() [1.9] ******************************
*
* NAME
*    stealTitleWindowBitMap()
*
* DESCRIPTION
*    Return the BitMap pointer from the given window.
*    ^ <primitive 189 8 windowTitle>
*********************************************************************
*
*/

METHODFUNC OBJECT *stealTitleWindowBitMap( char *windowTitle )
{
   struct Window *wptr = (struct Window *) FindIntuiPointer( windowTitle, 1 );
   OBJECT        *rval = o_nil;
   
   if (!wptr) //  == NULL)
      return( rval );
      
   rval = stealWindowBitMap( wptr );
   
   return( rval );
}

/****i* stealTitleScreenBitMap() [1.9] ******************************
*
* NAME
*    stealTitleScreenBitMap()
*
* DESCRIPTION
*    Return the BitMap pointer from the given screen.
*    ^ <primitive 189 9 screenTitle>
*********************************************************************
*
*/

METHODFUNC OBJECT *stealTitleScreenBitMap( char *screenTitle )
{
   struct Screen *sptr = (struct Screen *) FindIntuiPointer( screenTitle, 0 );
   OBJECT        *rval = o_nil;
   
   if (!sptr) // == NULL)
      return( rval );
      
   rval = stealScreenBitMap( sptr );
   
   return( rval );
}

/****i* ChangeData() [1.9] ******************************************
*
* NAME
*    ChangeData()
*
* DESCRIPTION
*    Change the BitMap data at the given offset.
*    ^ <primitive 189 10 newData offset private>  DEBUG THIS!!!
*********************************************************************
*
*/

METHODFUNC OBJECT *ChangeData( int newData, int offset, OBJECT *bitmapObj )
{
   struct BitMap *bp       = (struct BitMap *) CheckObject( bitmapObj );
   PLANEPTR       thePlane = NULL;
   int            maxsize  = 0, planesize = 0;      
   OBJECT        *rval     = o_false;
   UWORD          w, h;
   UBYTE          d;
      
   if (!bp) // == NULL)
      return( rval );

   w        = bp->BytesPerRow;
   h        = bp->Rows;
   d        = bp->Depth;
   thePlane = bp->Planes[0];
      
   maxsize   = w * h * d;
   planesize = w * h;

   if (planesize == 0 || maxsize == 0)
      return( rval ); // User sent broken parameters!!
         
   if (offset > maxsize) // Outside the BitMap??
      return( rval );

   *(thePlane + offset    ) = (UBYTE) (newData & 0xFF000000) >> 24;
   *(thePlane + offset + 1) = (UBYTE) (newData & 0x00FF0000) >> 16;
   *(thePlane + offset + 2) = (UBYTE) (newData & 0x0000FF00) >> 8;
   *(thePlane + offset + 3) = (UBYTE)  newData & 0x000000FF;

   rval = o_true;
      
   return( rval );
}

/****h* HandleBitMaps() [1.9] ***************************************
*
* NAME
*    HandleBitMaps()
*
* DESCRIPTION
*    Translate primitive numbers (189) to BitMap commands.
*********************************************************************
*
*/

PUBLIC OBJECT *HandleBitMaps( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 189 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // remove <primitive 189 0 private>
         if (NullChk( args[1] ) == FALSE)
            {
            BitMapRemove( args[1] );
            }

         break;

      case 1: // makeBitMap
              // private <- <primitive 189 1 width height depth flags>
         if ( !is_integer( args[1] ) || !is_integer( args[1] ) 
                                     || !is_integer( args[3] )
                                     || !is_integer( args[4] ) )
            (void) PrintArgTypeError( 189 );
         else
            rval = BitMapAdd( int_value( args[1] ), int_value( args[2] ),
                              int_value( args[3] ), int_value( args[4] )
                            );
         break;

      case 2: // getBitMapPart ^ <primitive 189 2 whichPart private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 189 );
         else
            rval = GetBitMapPart( int_value( args[1] ), args[2] );

         break;
      
      case 3: // setBitMapPart: value <primitive 189 3 whichPart value private>
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 189 );
         else
            SetBitMapPart( int_value( args[1] ), int_value( args[2] ), args[3] );

         break;
      
      case 4: // readBitMapFile: filename [private]
              // ^ bool <- <primitive 189 4 filename private>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 189 );
         else
            rval = SetBitMapData( string_value( (STRING *) args[1] ), args[2] );

         break;

      case 5:// writeBitMapFile: filename
             // <primitive 189 5 filename private>
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 189 );
         else
            WriteBitMap( string_value( (STRING *) args[1] ), args[2] );

         break;

      case 6: // stealBitMapFromWindow: windowObj
         rval = stealWindowBitMapMethod( args[1] );

         break;      

      case 7: // stealBitMapFromScreen: screenObj
         rval = stealScreenBitMapMethod( args[1] );

         break;      

      case 8: // stealBitMapFromWindowTitled: windowTitle
         if ( is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 189 );
         else
            rval = stealTitleWindowBitMap( string_value( (STRING *) args[1] ) );

         break;      

      case 9: // stealBitMapFromScreenTitled: screenTitle
         if ( is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 189 );
         else
            rval = stealTitleScreenBitMap( string_value( (STRING *) args[1] ) );

         break;

      case 10: // changeDataTo: longWord at: offset [private]
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 189 );
         else
            rval = ChangeData( int_value( args[1] ), int_value( args[2] ), args[3] );
            
      default:
         (void) PrintArgTypeError( 189 );
         break;
      }

   return( rval );
}

/* -------------------- END of Border.c file! ------------------------ */
