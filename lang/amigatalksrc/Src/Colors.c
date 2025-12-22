/****h* AmigaTalk/Colors.c [3.0] **************************************
*
* NAME
*    Colors.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk color register primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    02-Dec-2003 - Added primitives 184 8 through 15 for the
*                  LargeColors Class.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/Colors.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

#endif

#include <proto/locale.h>

IMPORT struct Catalog *catalog;

#define  CATCOMP_ARRAY 1
#include "ATalkLocale.h"

// #include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "StringConstants.h"
#include "FuncProtos.h"
#include "IStructs.h"

#include "CantHappen.h"

IMPORT OBJECT *o_nil;
IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

/****i* FreeCMap() [1.0] *******************************************
*
* NAME
*    FreeCMap()
*
* DESCRIPTION
*    Remove a ColorMap from the AmigaTalk program space.
*    <primtivie 184 0 private>
********************************************************************
*
*/

METHODFUNC void FreeCMap( OBJECT *cmapObj )
{
   struct ColorMap *cm = (struct ColorMap *) CheckObject( cmapObj );

   if (cm) // != NULL)   
      FreeColorMap( cm );

   return;
}

/****i* GetCMap() [1.0] ********************************************
*
* NAME
*    GetCMap()
*
* DESCRIPTION
*    ^ <primitive 184 1 cmapObj size>
********************************************************************
*
*/

METHODFUNC OBJECT *GetCMap( OBJECT *cmapObj, int size )
{
//   IMPORT struct ColorMap *GetColorMap( int );

   struct ColorMap *cm = (struct ColorMap *) CheckObject( cmapObj );

   if (cmapObj == o_nil)
      {
      cm = GetColorMap( size );

      return( AssignObj( new_address( (ULONG) cm ) ) );
      }

   if (cm) // != NULL)
      {
      if (size == cm->Count)
         return( cmapObj );
      // else Do we want to change the ColorMap size?????
      }
   else
      {
      cm = GetColorMap( size );

      return( AssignObj( new_address( (ULONG) cm ) ) );
      }
}

/****i* LoadRGBs() [1.0] *******************************************
*
* NAME
*    LoadRGBs()
*
* DESCRIPTION
*    File of color register values will be loaded into the 
*    window colormap & into the ColorMapList[] if possible.
*    <primitive 184 2 windowObject numberofcolors colorfile>
* TODO
*    Add more error checking here.
********************************************************************
*
*/

METHODFUNC void LoadRGBs( OBJECT *winObj, int numcolors, char *filename )
{
   struct Window   *wp = (struct Window *) CheckObject( winObj ); 
   struct ViewPort *vp = NULL;
   struct ColorMap *cm = NULL;

   if (!wp) // == NULL)   
      return;

   vp = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );
   cm = vp->ColorMap;
   
   if (cm) // != NULL)
      {
      FILE  *infile  = NULL;
      char  nil[10] = { 0, }, *n = &nil[0];
      int   j = 0;
                  
      if (!(infile = fopen( filename, FILE_READ_STR ))) // == NULL)
         {
         return;
         }

      while (j < numcolors)
         {
         // n is 0x0rgb (UWORD), where r, g & b are 0 to 15:
         
         (void) fgets( n, 9, infile );

         *((UWORD *) cm->ColorTable + j) = (UWORD) atoi( n );

         j++;
         }

      fclose( infile );

      LoadRGB4( vp, cm->ColorTable, numcolors );
      }

   return;   
}

/****i* GetRGB() [1.0] *********************************************
*
* NAME
*    GetRGB()
*
* DESCRIPTION
*    Get an RGB value from the given source.
*    ^ <primitive 184 3 srcType srcObj whichReg>
********************************************************************
*
*/

METHODFUNC OBJECT *GetRGB( int type, OBJECT *source, int whichreg )
{
   if (type == 1)
      {
      struct Window   *wp = (struct Window *) CheckObject( source );
      struct ViewPort *vp = NULL;
      
      if (!wp) // == NULL)   
         return( o_nil );

      vp = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );

      return( AssignObj( (OBJECT *) new_int( GetRGB4( vp->ColorMap, whichreg ))));
      }
   else
      {  
      struct ColorMap *cm = (struct ColorMap *) CheckObject( source );
   
      if (!cm) // == NULL)
         return( o_nil );

      return( AssignObj( (OBJECT *) new_int( *((int *) cm->ColorTable + whichreg ))));
      }
}

/****i* SetRGB() [1.0] *********************************************
*
* NAME
*    SetRGB()
*
* DESCRIPTION
*    Set the given Color register to the values given.
*    <primitive 184 4 windowObj whichReg red green blue>
********************************************************************
*
*/

METHODFUNC void SetRGB( OBJECT *winObj, int whichreg, 
                        int red, int green, int blue
                      )
{
   struct Window   *wp = (struct Window *) CheckObject( winObj );
   struct ViewPort *vp = NULL;
   
   if (!wp) // == NULL)   
      return;

   vp = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );

   SetRGB4( vp, whichreg, red, green, blue );

   return;
}

/****i* SetRGBCM() [1.0] *******************************************
*
* NAME
*    SetRGBCM()
*
* DESCRIPTION
*    <primitive 184 5 type srcObj whichReg red green blue>
********************************************************************
*
*/

METHODFUNC void SetRGBCM( int type, OBJECT *source, int whichreg,
                          int red, int green, int blue
                        )
{
   if (type == 1)
      {
      struct Window   *wp = (struct Window *) CheckObject( source );
      struct ViewPort *vp = NULL;
      
      if (!wp) // == NULL)   
         return;

      vp = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );

      SetRGB4CM( vp->ColorMap, whichreg, red, green, blue );

      return;
      }
   else
      {
      struct ColorMap *cm = (struct ColorMap *) CheckObject( source );

      if (!cm) // == NULL)
         return;

      SetRGB4CM( cm, whichreg, red, green, blue );
      }

   return;
}

/****i* CopyMap() [1.0] ********************************************
*
* NAME
*    CopyMap()
*
* DESCRIPTION
*    Copy the given ColorMap to the given destination.
*    <primitive 184 6 srcObj destObj srcType> 
********************************************************************
*
*/

METHODFUNC void CopyMap( OBJECT *source, OBJECT *dest, int sourcetype )
{
   int   len = sizeof( struct ColorMap );
   int   k   = 0;
   char  *src, *dst;
      
   if (sourcetype == 1) // From Window to ColorMap:
      {
      struct Window   *wp = (struct Window   *) CheckObject( source );
      struct ViewPort *vp = NULL;
      struct ColorMap *cm = (struct ColorMap *) CheckObject( dest );
      
      if ((!wp) || (!cm))
         return;

      vp  = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );
      
      src = (char *) vp->ColorMap;
      dst = (char *) cm;

      while (k < len)
         {
         *(dst + k) = *(src + k);
         k++;
         }   
      }
   else // From ColorMap to Window:
      {
      struct Window   *wp = (struct Window   *) CheckObject( dest   );
      struct ViewPort *vp = NULL;
      struct ColorMap *cm = (struct ColorMap *) CheckObject( source );

      if ((!wp) || (!cm)) // == NULL))
         return;

      vp  = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );
      src = (char *) cm;
      dst = (char *) vp->ColorMap;

      while (k < len)
         {
         *(dst + k) = *(src + k);
         k++;
         }   
      }

   return;
}

/****i* SaveRGBs() [1.0] *******************************************
*
* NAME
*    SaveRGBs()
*
* DESCRIPTION
*    Save the color register values only to a file.
*         <primtivie 184 7 windowObj fileName> 
* TODO
*    Add some error reporting.
********************************************************************
*
*/

METHODFUNC void SaveRGBs( OBJECT *winObj, char *savefile )
{
   struct Window   *wp = (struct Window *) CheckObject( winObj );
   struct ViewPort *vp = NULL;
   
   if (!wp) // == NULL)
      return;

   vp = &(wp->WScreen->ViewPort); // Instead of ViewPortAddress( wp );

   if (vp->ColorMap) // != NULL)
      {
      FILE  *outfile = NULL;
      char  nil[10] = { 0, }, *n = &nil[0];
      UWORD *c = NULL;   
      int   j  = 0;
      
      if (!(outfile = fopen( savefile, FILE_WRITE_STR ))) // == NULL)
         return;
         
      while (j < vp->ColorMap->Count)
         {
         // c is 0x0rgb (UWORD), where r, g & b are 0 to 15:

         c = (UWORD *) ((UWORD *) vp->ColorMap->ColorTable + j);
#        ifdef __SASC
         (void) stcu_d( n, *c ); // UWORD to decimal string (0 to 4095 max).
#        else
         sprintf( n, "%d", *c );
#        endif

         fputs( n, outfile );

         fputs( NEWLINE_STR, outfile );

         j++;   
         }

      fclose( outfile );
      }

   return;
}

/****i* findColorMatch() [3.0] **************************************
*
* NAME
*    findColorMatch()
*
* DESCRIPTION
*    Find the closest matching color to the RGB values given.
*    ^ colorRegisterNumber <- <184 8 red green blue private>
*********************************************************************
*
*/

METHODFUNC OBJECT *findColorMatch( int red, int green, int blue, 
                                   struct ColorMap *cm
                                 )
{
   OBJECT *rval  = o_nil;
   ULONG   color = 0L;

   if (NullChk( (OBJECT *) cm ) == TRUE)
      return( rval );
      
   color = FindColor( cm, red, green, blue, -1 );
   rval  = new_int( (int) color );
   
   return( rval );   
}

/****i* obtainBestPenMatch() [3.0] **********************************
*
* NAME
*    obtainBestPenMatch()
*
* DESCRIPTION
*    Find the closest matching color or allocate one.
*    ^ colorPenNumber <- <184 9 red green blue tagArray private>
*********************************************************************
*
*/

METHODFUNC OBJECT *obtainBestPenMatch( int red, int green, int blue,
                                       OBJECT          *tagArray,
                                       struct ColorMap *cm 
                                     )
{
   OBJECT         *rval = o_nil;
   struct TagItem *tags = NULL;
   LONG            pen  = 0L;
   
   if (NullChk( (OBJECT *) cm ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == TRUE)
      return( rval );

   if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
      return( rval ); // Probably an error by the User.
   
   pen  = ObtainBestPenA( cm, red, green, blue, tags );

   rval = new_int( (int) pen );
         
   if (tags) // != NULL)
      AT_FreeVec( tags, "obtainBestPenMatchTags", TRUE );
      
   return( rval );   
}

/****i* obtainPen() [3.0] *******************************************
*
* NAME
*    obtainPen()
*
* DESCRIPTION
*    Obtain a free palette entry.
*    ^ colorPenNumber <- <184 10 red green blue flags private>
*********************************************************************
*
*/

METHODFUNC OBJECT *obtainPen( int red, int green, int blue,
                              ULONG flags, struct ColorMap *cm 
                            )
{
   OBJECT *rval = o_nil;
   LONG    pen  = 0L;
   
   if (NullChk( (OBJECT *) cm ) == TRUE)
      return( rval );
      
   pen = ObtainPen( cm, -1, red, green, blue, flags );

   if (pen < 0)
      return( rval ); // return o_nil because we didn't get a pen!
   else
      rval = new_int( (int) pen );
         
   return( rval );   
}

/****i* getRGB32() [3.0] ********************************************
*
* NAME
*    getRGB32()
*
* DESCRIPTION
*    Get a series of color registers for this Viewport
*    <184 11 firstPen numColors colorArray private>
*********************************************************************
*
*/

METHODFUNC void getRGB32( int firstPen, int numColors, OBJECT *array,
                          struct ColorMap *cm
                        )
{
   ULONG *table = NULL;
   int    size  = objSize( array ), i, tableSize = numColors * 3;
   
   if (NullChk( (OBJECT *) cm ) == TRUE)
      return;
      
   if (size < tableSize)
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_COLORTABLE_SMALL,
                             MSG_FORMAT_COLORTABLE_SMALL_STR ), 
                       size, numColors 
             );

      UserInfo( ErrMsg, CMsg( MSG_RQTITLE_USERPGM_ERROR,
                              MSG_RQTITLE_USERPGM_ERROR_STR ) 
              );
      
      return;
      }
   else
      {
      if (!(table = (ULONG *) AT_AllocVec( tableSize * sizeof( ULONG ),
                                           MEMF_CLEAR | MEMF_ANY,
                                           "getRGB32Table", TRUE ))) // == NULL)
         {
         MemoryOut( "getRGB32()" );

         fprintf( stderr, "Ran out of memory in getRGB32()!\n" );
         
         cant_happen( NO_MEMORY );
         
         return;         
         }
      
      for (i = 0; i < tableSize; i++)
         (void) obj_dec( array->inst_var[i] );
            
      GetRGB32( cm, firstPen, numColors, table );
      
      for (i = 0; i < tableSize; i++)
         array->inst_var[i] = AssignObj( new_int( table[i] ) ); 
         
      AT_FreeVec( table, "getRGB32Table", TRUE );
      }      

   return;
}

/****i* makeColorTable() [3.0] **************************************
*
* NAME
*    makeColorTable()
*
* DESCRIPTION
*    Format the colorArray into what LoadRGB32() expects to find.
*    The Colors dispose method MUST get rid of this (private2) as 
*    well.
*
*    ^ private2 <- <184 12 firstColor numColors colorArray>
*********************************************************************
*
*/

METHODFUNC OBJECT *makeColorTable( int firstColor, int numColors, OBJECT *array )
{
   OBJECT *rval = o_nil;
   int     size = objSize( array ) + 2; // Number of Long words
   int     i, j, asize = objSize( array );
   
   rval = new_array( size, FALSE );
   
   rval->inst_var[0] = AssignObj( new_int( (numColors << 16) + firstColor ) );

   for (i = 1, j = 0; j < asize; i++, j++)
      rval->inst_var[i] = array->inst_var[j];
      
   rval->inst_var[ size - 1 ] = AssignObj( new_int( 0 ) );   

   return( rval );
}

/****i* loadRGB32() [3.0] *******************************************
*
* NAME
*    loadRGB32()
*
* DESCRIPTION
*    Set a series of color registers for this Viewport
*    <184 13 parentObj colorArray>
*
*    Passing a NULL "table" is ignored.
*    The format of the table passed to this function is a series of records,
*    each with the following format:
*
*            1 Word with the number of colors to load
*            1 Word with the first color to be loaded.
*            3 longwords representing a left justified 32 bit rgb triplet.
*            The list is terminated by a count value of 0.
*
*       examples:
*            ULONG table[]={1l<<16+0,0xffffffff,0,0,0} loads color register
*                    0 with 100% red.
*
*            ULONG table[]={256l<<16+0,r1,g1,b1,r2,g2,b2,.....0} can be used
*                    to load an entire 256 color palette.
*
*********************************************************************
*
*/

METHODFUNC void loadRGB32( struct Window *wptr, OBJECT *array )
{
   ULONG *table = NULL;
   int    size  = objSize( array ), i;
   
   if (NullChk( (OBJECT *) wptr ) == TRUE)
      return;
      
   if (!(table = (ULONG *) AT_AllocVec( size * sizeof( ULONG ),
                                        MEMF_CLEAR | MEMF_ANY,
                                        "loadRGB32Table", TRUE ))) // == NULL)
      {
      MemoryOut( "loadRGB32()" );

      fprintf( stderr, "Ran out of memory in loadRGB32()!\n" );
         
      cant_happen( NO_MEMORY );
         
      return;         
      }

   for (i = 0; i < size; i++)
      table[i] = (ULONG) int_value( array->inst_var[i] );
      
   LoadRGB32( &(wptr->WScreen->ViewPort), table );
      
   AT_FreeVec( table, "loadRGB32Table", TRUE );

   return;
}

/****i* releasePen() [3.0] ******************************************
*
* NAME
*    releasePen()
*
* DESCRIPTION
*    Release an allocated palette entry to the free pool.
*    <184 14 penNumber private>
*********************************************************************
*
*/

METHODFUNC void releasePen( ULONG penNumber, struct ColorMap *cm )
{
   if (NullChk( (OBJECT *) cm ) == TRUE)
      return;

   ReleasePen( cm, penNumber );
   
   return;       
}
 
/****i* attachPalExtra() [3.0] **************************************
*
* NAME
*    attachPalExtra()
*
* DESCRIPTION
*    Allocate & attach extra palette info to the ColorMap.
*    <184 15 private parentObj>
*********************************************************************
*
*/

METHODFUNC void attachPalExtra( struct ColorMap *cm, struct Window *wptr )
{
   LONG chk = 0;
   
   if (NullChk( (OBJECT *) cm ) == TRUE)
      return;

   if (NullChk( (OBJECT *) wptr ) == TRUE)
      return;

   if ((chk = AttachPalExtra( cm, &(wptr->WScreen->ViewPort) )) != 0)
      {
      sprintf( ErrMsg, CMsg( MSG_FORMAT_EXTRAPAL_ERROR, 
                             MSG_FORMAT_EXTRAPAL_ERROR_STR ), 
                       chk 
             );
      
      UserInfo( ErrMsg, CMsg( MSG_RQTITLE_ALLOC_PROBLEM, 
                              MSG_RQTITLE_ALLOC_PROBLEM_STR ) 
              );
      }   
   
   return;
}
           
/****h* HandleColors() [1.9] ***************************************
*
* NAME
*    HandleColors()
*
* DESCRIPTION
*    Translate primitive numbers (184) into ColorMap & Color
*    Register commands to the OS. 
********************************************************************
*
*/

PUBLIC OBJECT *HandleColors( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 184 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
               //  cmapObject -- FreeColorMap:
      case 0:
         if (NullChk( args[1] ) == FALSE)
            {
            FreeCMap( args[1] );
            }         

         break; 

               //  cmapObject numberofcolors -- GetColorMap:
      case 1:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 184 );
         else
            rval = GetCMap( args[1], int_value( args[2] ) );

         break;

               // windowObject numberofcolors colorfile -- LoadRGB4:
      case 2:
         if (!is_integer( args[2] ) || !is_string( args[3]  ) )
            (void) PrintArgTypeError( 184 );
         else
            LoadRGBs( args[1], int_value( args[2] ),
                      string_value( (STRING *) args[3] )
                    );
         break;

               // type srcObj whichentry  -- GetRGB4:
      case 3:
         if ( !is_integer( args[1] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 184 );
         else
            rval = GetRGB( int_value( args[1] ),
                                      args[2]  ,
                           int_value( args[3] ) 
                         );
         break;

               // windowObj whichentry red green blue  -- SetRGB4:
      case 4:
         if (ChkArgCount( 6, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[2] ) || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ) )
            (void) PrintArgTypeError( 184 );
         else
            SetRGB( args[1], int_value( args[2] ), 
                             int_value( args[3] ),    
                             int_value( args[4] ), 
                             int_value( args[5] ) 
                  );
         break;

               // type srcObj whichentry red green blue -- SetRGB4CM:
      case 5:
         if (ChkArgCount( 7, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[3] )
                                     || !is_integer( args[4] ) 
                                     || !is_integer( args[5] )
                                     || !is_integer( args[6] ) )
            (void) PrintArgTypeError( 184 );
         else
            SetRGBCM( int_value( args[1] ), 
                                 args[2]  ,
                      int_value( args[3] ), 
                      int_value( args[4] ),
                      int_value( args[5] ), 
                      int_value( args[6] )
                    );
         break;

               // source destination sourcetype -- CopyMap:
      case 6:
         if (is_integer( args[3] ) == FALSE) 
            (void) PrintArgTypeError( 184 );
         else
            CopyMap( args[1], args[2], int_value( args[3] ) );

         break;
               // windowTitle ColorSaveFile -- SaveRGBs:
      case 7:
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 184 );
         else
            SaveRGBs( args[1], string_value( (STRING *) args[2] ));

         break;

      case 8: // closestMatchingColor: red green: g blue: b [privateCM]
         if (ChkArgCount( 4, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ) 
                                     || !is_address( args[4] ))
            (void) PrintArgTypeError( 184 );
         else
            rval = findColorMatch( int_value( args[1] ), 
                                   int_value( args[2] ),
                                   int_value( args[3] ), 
                                   (struct ColorMap *) addr_value( args[4] )
                                 );
         break;
      
      case 9: // obtainBestPenMatch: red green: g blue: b tags: tarArray [private]
         if (ChkArgCount( 5, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_array(   args[4] ) 
                                     || !is_address( args[5] ))
            (void) PrintArgTypeError( 184 );
         else
            rval = obtainBestPenMatch( int_value( args[1] ), 
                                       int_value( args[2] ),
                                       int_value( args[3] ), 
                                                  args[4],
                                       (struct ColorMap *) addr_value( args[5] )
                                     );
         break;

      case 10: // obtainPen: red green: g blue: b flags: f [private]      
               // ^ colorPenNumber <- <184 10 red green blue flags private>
         if (ChkArgCount( 5, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_integer( args[4] ) 
                                     || !is_address( args[5] ))
            (void) PrintArgTypeError( 184 );
         else

            rval = obtainPen( int_value( args[1] ), 
                              int_value( args[2] ),
                              int_value( args[3] ), 
                              (ULONG) int_value( args[4] ),
                              (struct ColorMap *) addr_value( args[5] )
                            );
         break;
      
      case 11: // getRGB32: firstPen number: ncolors into: colorArray [private ]  
         if (ChkArgCount( 4, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_array(   args[3] )
                                     || !is_address( args[4] )) 
            (void) PrintArgTypeError( 184 );
         else
            getRGB32( int_value( args[1] ), 
                      int_value( args[2] ),
                                 args[3]  , 
                      (struct ColorMap *) addr_value( args[4] )
                    );
         break;

      case 12: // ^ private2 <- <184 12 firstColor numColors colorArray>
         if (ChkArgCount( 3, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_array(   args[3] ))
            (void) PrintArgTypeError( 184 );
         else
            rval = makeColorTable( int_value( args[1] ),
                                   int_value( args[2] ), args[3] 
                                 );
         break;
      
      case 13: // loadRGB32 [parentObj private2] <184 13 parentObj private2>
         if (ChkArgCount( 2, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 184 );
         else
            loadRGB32( (struct Window *) addr_value( args[1] ),
                                                     args[2] 
                     );
         break;
         
      case 14: // releasePen  <184 14 penNumber private>
         if (ChkArgCount( 2, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_integer( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 184 );
         else
            releasePen( (ULONG) int_value( args[1] ),
                        (struct ColorMap *) addr_value( args[2] )
                      );
         break;
      
      case 15: // attachPalExtra  <184 15 private parentObj>
         if (ChkArgCount( 2, numargs, 184 ) != 0)
            return( ReturnError() );

         if ( !is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 184 );
         else
            attachPalExtra( (struct ColorMap *) addr_value( args[1] ),
                            (struct Window   *) addr_value( args[2] )
                          );
         break;

      default:
         (void) PrintArgTypeError( 184 );
         break;
      }

   return( rval );
}

/* -------------------- END of Colors.c file! ----------------------- */
