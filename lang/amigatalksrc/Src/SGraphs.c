/****h* AmigaTalk/SimpleGraphs.c [3.0] *********************************
*
* NAME
*    SimpleGraphs.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk simple 
*    graphic primitives & Image struct manipulation.
*
*  PUBLIC OBJECT *HandleSimpleGraphs( int numargs, OBJECT **args );
*
*  PUBLIC void RemoveImage( OBJECT *ImageObj );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    28-Dec-2003 - Finally got the GrabImage code to work for 
*                  Cybergraphics!
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
*    10-May-2002 - Added the Area Drawing functions.
*
*    06-Feb-2002 - Added checking for cybergraphics.library presence &
*                  whether we're using a ScreenModeID that needs 
*                  cybergraphics to the Image functions.
* NOTES
*    vport = &(wp->WScreen->ViewPort); // not ViewPortAddress( wp );
*
*    $VER: AmigaTalk:Src/SimpleGraphs.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <intuition/imageclass.h>

#include <graphics/gfxmacros.h>            // for SetOPen() & DrawEllipse()!!


#ifdef __SASC

# include <clib/intuition_protos.h>         // Added for V2.1 
# include <clib/graphics_protos.h>          // Added for V2.0 
# include <clib/cybergraphics_protos.h>     // Added for V2.0

# include <cybergraphx/cybergraphics.h>     // Added for V2.1
# include <pragmas/cybergraphics_pragmas.h> // Added for V2.0

#else

# define __USE_INLINE__

# include <proto/graphics.h>          // Added for V2.0 
# include <proto/intuition.h>         // Added for V2.0 
# include <proto/cybergraphics.h>     // Added for V2.0 

# include <cybergraphics.h>           // Located in SDK:Local/Include/ Added for V2.1
//# include <cybergraphics_pragmas.h>   // Located in SDK:Local/Include/ Added for V2.0

IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;

IMPORT struct CyberGfxIFace  *ICyberGfx;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

#endif


#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"
#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;

IMPORT UBYTE  *UserPgmError;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *SystemProblem;

IMPORT struct Library *CyberGfxBase;     // Added for V2.0
IMPORT BOOL            HaveCyberLibrary; // Added for V2.0

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

#define CHIPMEM   MEMF_CLEAR | MEMF_CHIP | MEMF_PUBLIC
#define FASTMEM   MEMF_CLEAR | MEMF_FAST | MEMF_PUBLIC

// primitives 200 0 to 6 are in the HandleSimpleGraphs function.

/****i* DrawBox() [1.6] **********************************************
*
* NAME
*    DrawBox()
*
* DESCRIPTION
*    <primitive 200 7 winObj x1 y1 x2 y2>
**********************************************************************
*
*/

METHODFUNC void DrawBox( struct RastPort *rp, int x1, int y1, int x2, int y2 )
{
   Move( rp, (long) x1, (long) y1 );

   Draw( rp, (long) x2, (long) y1 );
   Draw( rp, (long) x2, (long) y2 );
   Draw( rp, (long) x1, (long) y2 );
   Draw( rp, (long) x1, (long) y1 );

   return;
}

// primitives 200 8 & 9 are in the HandleSimpleGraphs function.

/****i* DrawPolygon() [1.6] ******************************************
*
* NAME
*    DrawPolygon()
*
* DESCRIPTION
*    Draw a complex border into the RastPort rp.
*    <primitive 200 10 winObj borderObj>
**********************************************************************
*
*/

METHODFUNC void DrawPolygon( struct RastPort *rp, OBJECT *BorderObj )
{
   struct Border *b = (struct Border *) CheckObject( BorderObj );
   int            j = 0;

   if (!b) // == NULL)
      return;
      
   Move( rp, b->XY[ j ], b->XY[ j + 1 ] );
   
   j = 2;

   while (j < b->Count)
      {
      Draw( rp, b->XY[ j ], b->XY[ j + 1 ] );

      j += 2;
      }

   return;
}

PRIVATE USHORT DefaultData[9] = {
   
   0xFFFF, 0xC0FF, 0xCCFF, 0xC003,
   0xFCF3, 0xFCF3, 0xFCF3, 0xFC03, 0xFFFF
};

PRIVATE struct Image DefaultImage = {
   
   0, 0, 16, 9, 1, &DefaultData[0], 0x1, 0x0, NULL
};

// primitive 200 11 is in the HandleSimpleGraphs function.
   
/****h* RemoveImage() [1.9] ******************************************
*
* NAME
*    RemoveImage()
*
* DESCRIPTION
*    Remove an image struct from AmigaTalk program space.
*    <primitive 200 12 private>
**********************************************************************
*
*/

// METHODFUNC

PUBLIC void RemoveImage( OBJECT *ImageObj )
{
   struct Image *im = (struct Image *) CheckObject( ImageObj );

   if (!im) //== NULL)
      return;

   if (im == &DefaultImage) // Don't remove Default image!
      return;

   if (im->ImageData) // != NULL)      
      AT_FreeVec( im->ImageData, "imageData", TRUE );

   AT_FreeVec( im, "Image", TRUE );

   im = NULL;
   
   return;
}

/****i* CopyDefaultImage() [1.6] *************************************
*
* NAME
*    CopyDefaultImage()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void CopyDefaultImage( struct Image *newimage )
{
   CopyMem( (char *) &DefaultImage, (char *) newimage, 
            (long) sizeof( struct Image )
          );
   return;
}

/****i* AddImage() [1.9] *********************************************
*
* NAME
*    AddImage()
*
* DESCRIPTION
*    ^ <primitive 200 13 winObj w h d>
**********************************************************************
*
*/

METHODFUNC OBJECT *AddImage( int imagewidth, int imageheight, int imagedepth )
{
   struct Image *newimage = NULL;
   UWORD        *newdata  = NULL;
   int           numWords = 0;
   OBJECT       *rval     = o_nil;
   
   if (imagewidth == 0 || imageheight == 0 || imagedepth == 0)
      return( rval );

   if ((imagewidth % 16 != 0) && (imagewidth > 16))
      {
      numWords  = (imagewidth + 16) / 16;     // Round up to next multiple of 16.
      
      numWords *= (imageheight * imagedepth); // # of WORDS.
      
      imagewidth = ((imagewidth + 16) / 16) * 16; // Reflect the increase in size. 
      }
   else if (imagewidth <= 16)
      {
      numWords       = imageheight * imagedepth;

      imagewidth = 16;                    // Has to be at least one UWORD in size.
      }
   else
      numWords = (imagewidth / 16) * imageheight * imagedepth; // We got lucky.
               
   newimage = (struct Image *) AT_AllocVec( sizeof( struct Image ), 
                                            CHIPMEM, "Image", TRUE 
                                          );

   newdata  = (UWORD *) AT_AllocVec( numWords * sizeof( UWORD ), // size in Bytes
                                     CHIPMEM, "imageData", TRUE 
                                   );
   
   if (!newimage || !newdata) // == NULL)) 
      {
      MemoryOut( SGrphCMsg( MSG_ADD_IMAGE_FUNC_SGRPH ) );

      if (newdata) // != NULL)
         AT_FreeVec( newdata, "imageData", TRUE );

      if (newimage) // != NULL)
         AT_FreeVec( newimage, "Image", TRUE );

      return( rval );   
      }
/*
#  ifdef DEBUG
   fprintf( stderr, "Image data = 0x%08LX, last = 0x%08LX, size = %d (words)\n",
                     newdata, newdata + 2 * size, size );
#  endif
*/
   CopyDefaultImage( newimage );

   newimage->Width     = imagewidth;
   newimage->Height    = imageheight;
   newimage->Depth     = imagedepth;
   newimage->ImageData = newdata;
   
   rval = AssignObj( new_address( (ULONG) newimage ) );
   
   return( rval );
}

/****i* GetImagePart() [1.9] *****************************************
*
* NAME
*    GetImagePart()
*
* DESCRIPTION
*     ^ <primitive 200 14 winObj whichPart private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetImagePart( int whichpart, OBJECT *ImageObj )
{
   struct Image *im = (struct Image *) CheckObject( ImageObj );
   OBJECT       *rval = o_nil;
   
   if (NullChk( (OBJECT *) im ) == TRUE)
      return( rval );
      
   switch (whichpart)
      {
      case 0:  
         return( AssignObj( new_int( (int) im->LeftEdge ) ) );

      case 1:  
         return( AssignObj( new_int( (int) im->TopEdge ) ) );

      case 2:  
         return( AssignObj( new_int( (int) im->Width ) ) );

      case 3:  
         return( AssignObj( new_int( (int) im->Height ) ) );

      case 4:  
         return( AssignObj( new_int( (int) im->Depth ) ) );

      case 6:  
         return( AssignObj( new_int( (int) im->PlanePick ) ) );

      case 7:  
         return( AssignObj( new_int( (int) im->PlaneOnOff ) ) );

      case 8:  
         return( AssignObj( new_address( (ULONG) im->NextImage ) ) );
               
      default: 
         return( rval );
      }
}

/****i* SetImagePart() [1.6] *****************************************
*
* NAME
*    SetImagePart()
*
* DESCRIPTION
*    <primitive 200 15 winObj whichPart value private>
**********************************************************************
*
*/
   
METHODFUNC void SetImagePart( int whichpart, OBJECT *whatvalue, OBJECT *ImageObj )
{
   struct Image *im = (struct Image *) CheckObject( ImageObj );
   struct Image *ni = NULL;
   
   if (!im) //== NULL)
      return;
   
   switch (whichpart)
      {
      case 0:
         im->LeftEdge = int_value( whatvalue );
         break;
 
      case 1:
         im->TopEdge = int_value( whatvalue );
         break;

      case 2:
         im->Width = int_value( whatvalue );
         break;

      case 3:
         im->Height = int_value( whatvalue );
         break;

      case 4:
         im->Depth = int_value( whatvalue );
         break;

      case 6:
         im->PlanePick = int_value( whatvalue );
         break;

      case 7:
         im->PlaneOnOff = int_value( whatvalue );
         break;

      case 8:
         ni = (struct Image *) CheckObject( whatvalue );

         im->NextImage = ni;
         break;
      
      default: 
         break;   
      }

   return;      
}

/****i* SetImageData() [1.6] *****************************************
*
* NAME
*    SetImageData()
*
* DESCRIPTION
*    Read an Image file & place it in the Image OBJECT:
*    <primitive 200 17 winObj fileName private>
**********************************************************************
*
*/

METHODFUNC void SetImageData( char *infilename, OBJECT *ImageObj )
{
   struct Image *im     = (struct Image *) CheckObject( ImageObj );
   FILE         *infile = NULL;
      
   if (!im) //== NULL)
      return;

   if (!(infile = fopen( infilename, FILE_READ_STR ))) // == NULL)
      {
      NotOpened( 3 );

      return;
      }
   else
      {
      int le, te, w, h, d, i, numWords;

      //   fgetHexStr() in Global.c:     
      le = fgetHexStr( infile, 4, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (comma)

      te = fgetHexStr( infile, 4, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (comma)

      w  = fgetHexStr( infile, 4, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (comma)

      h  = fgetHexStr( infile, 4, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (comma)

      d  = fgetHexStr( infile, 4, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (comma)

      numWords = fgetHexStr( infile, 8, "\n, " );
      (void) fgetc( infile ); // Throw away delimiter (newline)
      
      if ((w * h * d) < 1)
         return;

      im->LeftEdge = (WORD) le;
      im->TopEdge  = (WORD) te;
      im->Width    = (WORD) w;
      im->Height   = (WORD) h;
      im->Depth    = (WORD) d;
      
      for (i = 0; i < numWords; i++)
         {
         im->ImageData[i] = fgetHexStr( infile, 4, "\n, " );
   
         (void) fgetc( infile ); // Throw away delimiter (comma or newline)
         }

      im->PlanePick  = fgetHexStr( infile, 2, "\n, " );

      (void) fgetc( infile ); // Throw away delimiter (comma)

      im->PlaneOnOff = fgetHexStr( infile, 2, "\n, " );
      }

   fclose( infile );

   return;
}

/****i* saveTheImage() [1.9] *****************************************
*
* NAME
*    saveTheImage()
*
* DESCRIPTION
*    Write the Image *ip to the given fileName:
**********************************************************************
*
*/

SUBFUNC int saveTheImage( char *fileName, struct Image *ip )
{
   FILE *fout      = fopen( fileName, FILE_WRITE_STR );
   int   numWords  = 0;
   int   realwidth = 0;
   int   i, j;
   
   BOOL  addNewLine = FALSE;

   // ----------------------------------------------------------------

   if (!fout) // == NULL)
      return( -1 );
      
   if ((ip->Width % 16 != 0) && (ip->Width > 16))
      {
      realwidth = (ip->Width + 16) / 16; // Round up to next multiple of 16.
      
      numWords   = realwidth * ip->Height * ip->Depth;

      realwidth *= 16; // realwidth is number of pixels in a line.
      }
   else if (ip->Width <= 16)
      {
      numWords  = ip->Height * ip->Depth;
      realwidth = 16;
      }
   else
      {
      numWords  = (ip->Width / 16) * ip->Height * ip->Depth;
      realwidth = ip->Width;
      }

   fprintf( fout, "%04LX,%04LX,%04LX,%04LX,%04LX,",
                   ip->LeftEdge, ip->TopEdge, realwidth,
                   ip->Height, ip->Depth
          );   
   
   fprintf( fout, "%08LX\n", numWords ); // Number of UWORDS of Data.  

   j = 0;
          
   for (i = 0; i < numWords; i++)
      {
      if (j < 15)
         {
         fprintf( fout, "%04LX,", ip->ImageData[i] );
         j++;
         addNewLine = TRUE;
         }
      else
         {
         fprintf( fout, "%04LX\n", ip->ImageData[i] );
         j = 0;
         addNewLine = FALSE;
         }
      }

   if (addNewLine == TRUE)
      fprintf( fout, "\n%02LX,%02LX\n", ip->PlanePick, ip->PlaneOnOff );
   else
      fprintf( fout, "%02LX,%02LX\n", ip->PlanePick, ip->PlaneOnOff );
      
   fclose( fout );

   return( 0 );
}

/****i* SaveImage() [1.9] ********************************************
*
* NAME
*    SaveImage()
*
* DESCRIPTION
*    ^ <primitive 200 18 winObj fileName private>
**********************************************************************
*
*/

METHODFUNC OBJECT *SaveImage( char *fileName, OBJECT *imageObj )
{
   struct Image *im   = (struct Image *) CheckObject( imageObj );
   OBJECT       *rval = o_false;   

   if (!im) //== NULL)
      return( rval );

   if (saveTheImage( fileName, im ) != 0)
      return( rval );
   else
      return( o_true );
}

/****i* DrawAnImage() [1.6] ******************************************
*
* NAME
*    DrawAnImage()
*
* DESCRIPTION
*    <primitive 200 16 winObj x y private>
**********************************************************************
*
*/

METHODFUNC void DrawAnImage( struct RastPort *rport, int LeftOffset,
                             int TopOffset, OBJECT *ImageObj
                           )
{
   struct Image *im = (struct Image *) CheckObject( ImageObj );
   
   if (!im) //== NULL)
      return;
      
   DrawImage( rport, im, LeftOffset, TopOffset );

   return;
}

PRIVATE int A_pen     = 1;
PRIVATE int B_pen     = 0;
PRIVATE int O_pen     = 0;
PRIVATE int Draw_Mode = JAM1;

PRIVATE UWORD LinePattn = 0xFFFF;

/****i* DisplayIntuiText() [1.6] *************************************
*
* NAME
*    DisplayIntuiText()
*
* DESCRIPTION
*    <primitive 200 19 winObj text x y>
**********************************************************************
*
*/

METHODFUNC void DisplayIntuiText( struct RastPort *rp, char *text,
                                  int x, int y 
                                )
{

   struct IntuiText itext = { 0, 1, JAM1, 0, 0, NULL, NULL, NULL };

   itext.FrontPen = A_pen;
   itext.BackPen  = B_pen;
   itext.DrawMode = Draw_Mode;
   itext.IText    = (UBYTE *) text;

   PrintIText( rp, &itext, x, y );

   return;
}

/****i* translateColors() [3.0] *************************************
*
* NAME
*    translateColors()
*
* DESCRIPTION
*    Transform RGB data into a color Register Number array.
*    Part of GrabImage() code.
*********************************************************************
*
*/

SUBFUNC void translateColors( struct ColorMap *cm,
                              UBYTE           *rgbData, 
                              UBYTE           *colorData, 
                              int              colorSize 
                            )
{
   ULONG red, green, blue;
   int   idx = 0, rgb = 0, incSize = 3;

   for (idx = 0, rgb = 0; idx < colorSize; idx++, rgb += incSize)
      {
      int colorNum = 0;
      
      red    = (ULONG) (rgbData[ rgb     ] << 24);
//      red   += (ULONG) (rgbData[ rgb     ] << 16);
//      red   += (ULONG) (rgbData[ rgb     ] <<  8);
//      red   += (ULONG)  rgbData[ rgb     ];

      green  = (ULONG) (rgbData[ rgb + 1 ] << 24);
//      green += (ULONG) (rgbData[ rgb + 1 ] << 16);
//      green += (ULONG) (rgbData[ rgb + 1 ] <<  8);
//      green += (ULONG)  rgbData[ rgb + 1 ];

      blue   = (ULONG) (rgbData[ rgb + 2 ] << 24);
//      blue  += (ULONG) (rgbData[ rgb + 2 ] << 16);
//      blue  += (ULONG) (rgbData[ rgb + 2 ] <<  8);
//      blue  += (ULONG)  rgbData[ rgb + 2 ];

      colorNum = FindColor( cm, red, green, blue, -1 ); 

      if (colorNum >= 0)
         colorData[idx] = colorNum;
      else
         colorData[idx] = 0;
      }

   return;
}

/****i* getNumberOfColors() [3.0] ***********************************
*
* NAME
*    getNumberOfColors()
*
* DESCRIPTION
*    Transform Image Depth number into number of Colors for
*    that depth.  Part of GrabImage() code.
*********************************************************************
*
*/

SUBFUNC UWORD getNumberOfColors( UWORD depth )
{
   UWORD rval = 0;
   
   switch (depth)
      {
      default:
      case 8:
         rval = 256;
         break;
         
      case 7:
         rval = 128;
         break;
         
      case 6:
         rval = 64;
         break;
         
      case 5:
         rval = 32;
         break;
         
      case 4:
         rval = 16;
         break;
         
      case 3:
         rval = 8;
         break;
         
      case 2:
         rval = 4;
         break;
         
      case 1:
         rval = 2;
         break;
         
      case 0:
         rval = 1;
         break;
      }

   return( rval );
}

/****i* convertRawData() [3.0] **************************************
*
* NAME
*    convertRawData()
*
* DESCRIPTION
*    Transform CyberGraphic pixels into Image Struct ImageData
*    Part of GrabImage() code.
*********************************************************************
*
*/

SUBFUNC BOOL convertRawData( struct Window *window, 
                             APTR           rawdata, 
                             struct Image  *destImage 
                           )
{
   struct ColorMap *cm = NULL;

   UBYTE *rawData   = (UBYTE *) rawdata;
   UBYTE *data      = (UBYTE *) destImage->ImageData;
   UBYTE *colData   = NULL;
   
   UWORD pixelWidth = destImage->Width;
   UWORD height     = destImage->Height;
   UBYTE depth      = destImage->Depth;
   
   int   disp, drow, column, row, numColors;
   UBYTE bit1, bit2, bit3, bit4, bit5, bit6, bit7, bit8;

   // -------------------------------------------------------------
           
   disp = pixelWidth / 8 * height; // Image Plane offset adjust

//   fprintf( stderr, "Image Plane size (in bytes): %d\n", disp );

   if (!(colData = (UBYTE *) AT_AllocVec( pixelWidth * height, 
                                          MEMF_CLEAR | MEMF_ANY,
                                          "convertRawData", TRUE ))) // == NULL)
      {
      MemoryOut( SGrphCMsg( MSG_GRAB_IMAGE_FUNC_SGRPH ) );

      fprintf( stderr, "ran out of memory in convertRawData()!\n" );

      return( FALSE );
      }

   numColors = getNumberOfColors( depth );
   cm        = GetColorMap( numColors );

   // This should NOT be necessary:
   // GetRGB32( cm, 0, numColors, &ctable[0] );
   // LoadRGB32( &(window->WScreen->ViewPort), &ctable[0] );
               
   if (cm) // != NULL)
      translateColors( cm, rawData, colData, pixelWidth * height ); 
   else
      translateColors( window->WScreen->ViewPort.ColorMap, 
                       rawData, colData, pixelWidth * height 
                     ); 
      
   for (row = 0; row < height; row++) // Traverse vertically
      {
      for (column = 0; column < pixelWidth; column++) // Traverse horizontally
         {
         int rowOff = row * pixelWidth;
         
         drow = row * pixelWidth / 8;
         
         if (colData[ column + rowOff ] != 0)
            {
            int xcoord = column / 8;
            int bitNum = column % 8;
            
            switch (depth)
               {
               default:
               case 8:
                  bit8 = colData[ column + rowOff ] & 0x80; // 1 << (7 - bitNum)

                  if (bit8 != 0)
                     data[ xcoord + drow + 7 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 7:
                  bit7 = colData[ column + rowOff ] & 0x40;

                  if (bit7 != 0)
                     data[ xcoord + drow + 6 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 6:
                  bit6 = colData[ column + rowOff ] & 0x20;

                  if (bit6 != 0)
                     data[ xcoord + drow + 5 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 5:
                  bit5 = colData[ column + rowOff ] & 0x10;

                  if (bit5 != 0)
                     data[ xcoord + drow + 4 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 4:
                  bit4 = colData[ column + rowOff ] & 0x08;

                  if (bit4 != 0)
                     data[ xcoord + drow + 3 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 3:
                  bit3 = colData[ column + rowOff ] & 0x04;

                  if (bit3 != 0)
                     data[ xcoord + drow + 2 * disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 2:
                  bit2 = colData[ column + rowOff ] & 0x02;

                  if (bit2 != 0)
                     data[ xcoord + drow + disp ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 1:
                  bit1 = colData[ column + rowOff ] & 0x01;

                  if (bit1 != 0)
                     data[ xcoord + drow ] |= 1 << (7 - bitNum);

                  // FALL THROUGH
                  
               case 0:
                  break;
               }
            }
         }
      }

   if (cm) // != NULL)
      FreeColorMap( cm );
   
   AT_FreeVec( colData, "convertRawData", TRUE );
              
   return( TRUE );
}

/****i* makePixelArray() [3.0] *************************************
*
* NAME
*    makePixelArray()
*
* DESCRIPTION 
*    Allocate some color Memory & read in an Array of Pixels
*    Part of GrabImage() code.
********************************************************************
*
*/

SUBFUNC APTR makePixelArray( struct RastPort *rp, 
                             UWORD            x, 
                             UWORD            y, 
                             UWORD            pixelWidth, 
                             UWORD            pixelHeight 
                           )
{
   APTR  array = NULL;
   ULONG rval  = 0L;

   if (!rp) // == NULL)
      return( NULL );

   if (!(array = (APTR) AT_AllocVec( 3 * pixelWidth * pixelHeight, 
                                     MEMF_CLEAR | MEMF_ANY,
                                     "makePixelArray", TRUE ))) // == NULL)
      {
      MemoryOut( SGrphCMsg( MSG_GRAB_IMAGE_FUNC_SGRPH ) );

      fprintf( stderr, "Ran out of memory in makePixelArray()!\n" );

      return( NULL );
      }

   rval = ReadPixelArray( array, 0, 0, 3 * pixelWidth, rp, 
                          x, y, pixelWidth, pixelHeight, RECTFMT_RGB
                        );
   return( array );
}

/****i* TranslateCyberBitsToImage() [3.0] *****************************
*
* NAME
*    TranslateCyberBitsToImage()
*
* DESCRIPTION
*    Transform a region of a Cyber BitMap into an Image struct
*    Part of GrabImage() code.
***********************************************************************
*
*/

SUBFUNC int TranslateCyberBitsToImage( struct Window *wptr, struct Image *dest,
                                       struct Rectangle *rect // int x, int y, int w, int h
                                     )
{
   struct RastPort *rp       = wptr->RPort;
   APTR             srcArray = NULL;
   UWORD            x        = (UWORD) rect->MinX;
   UWORD            y        = (UWORD) rect->MinY;
   UWORD            w        = (UWORD) rect->MaxX;
   UWORD            h        = (UWORD) rect->MaxY;
   int              rval     = RETURN_OK;
         
   // w & h were coordinates, NOT width & height in method,
   // so we have to subtract starting coordinates:

   w -= x;
   h -= y;
   
   srcArray = makePixelArray( rp, x, y, w, h );

   if (convertRawData( wptr, srcArray, dest ) != TRUE)
      {
      rval = ERROR_NO_FREE_STORE;
      }
      
   AT_FreeVec( srcArray, "makePixelArray", TRUE );

   return( rval );
}

/****i* GrabRegularImage() [2.5] *************************************
*
* NAME
*    GrabRegularImage()
*
* DESCRIPTION
*    Obtain an Image Struct from a Window BitMap.
**********************************************************************
*
*/

SUBFUNC OBJECT *GrabRegularImage( struct Window *wptr, 
                                  struct Image  *im,
                                  int            x,
                                  int            y
                                )
{
   struct BitMap *bm = wptr->RPort->BitMap;
   
   char *data = (char *) im->ImageData;
   int   d, i, j, rowY, columnX, size;
   
   int   depth = im->Depth;
   int   w     = im->Width;
   int   h     = im->Height;
   
   size = w * h / 16; // In Words
   
   for (d = 0; d < depth; d++)
      {
      PLANEPTR pptr = bm->Planes[d];

      for (rowY = y, j = 0; rowY < (y + h); rowY++, j++)
         {
         for (columnX = x, i = 0; columnX < (x + im->Width); columnX++, i++)
            {
            int rowOffset = j * w; // d * size is ImagePlane Offset
  
            data[ i + rowOffset + d * size ] = pptr[ columnX + rowY + rowOffset ];
            }
         }
      }
               
   return( o_true );
}

/****i* GrabImage() [2.0] ********************************************
*
* NAME
*    GrabImage()
*
* DESCRIPTION
*    Slurp up some of the data from a Window RastPort & place it in the
*    given Image Object.
*    x, y, w & h are dimensioned in pixels.
**********************************************************************
*
*/

METHODFUNC OBJECT *GrabImage( struct Window *wp, int x, int y,
                              int w, int h, OBJECT *ImageObj 
                            )
{
   IMPORT struct Screen *Scr;
   IMPORT ULONG          CurrentScrModeID, ATScreenModeID; // in Setup.c.

   struct Image   *im   = (struct Image *) CheckObject( ImageObj );
   OBJECT         *rval = o_false;

   // ----------------------------------------------------------------
      
   if (NullChk( (OBJECT *) im ) == TRUE)
      return( rval );

   if (HaveCyberLibrary == TRUE)
      {
      if ((CurrentScrModeID = GetVPModeID( &(wp->WScreen->ViewPort) )) == INVALID_ID)
         CurrentScrModeID = ATScreenModeID;
      
      if (IsCyberModeID( CurrentScrModeID ) == TRUE)
         {
         struct Rectangle r   = { 0, };
         int              chk = 0;

         CurrentScrModeID = ATScreenModeID; // Restore CurrentScrModeID
                           
         r.MinX = (WORD) x;   
         r.MinY = (WORD) y;   
         r.MaxX = (WORD) w;
         r.MaxY = (WORD) h;

         // Check that the Screen Depth is > 8 also!!!
         chk = GetCyberMapAttr( wp->WScreen->RastPort.BitMap, CYBRMATTR_DEPTH );
         
         if (chk < 0)
            {
            return( GrabRegularImage( wp, im, x, y ) );
            }
         else  // if (chk > 8)
            { 
            // We have a CyberGraphics BitMap to deal with:
            if (TranslateCyberBitsToImage( wp, im, &r ) != RETURN_OK)
               {
               UserInfo( SGrphCMsg( MSG_NO_TRANSLATE_CYBER_SGRPH ),
                               SystemProblem 
                       );

               return( rval );
               }
            }
//         else // Probably need to delete this!
//            {
//            return( GrabRegularImage( wp, im, x, y ) );
//            }
         }
      else
         {
         CurrentScrModeID = ATScreenModeID; // Restore CurrentScrModeID

         return( GrabRegularImage( wp, im, x, y ) );
         }
      }
   else
      {
      return( GrabRegularImage( wp, im, x, y ) );
      }
   
   return( o_true );
}

/****i* drawImageState() [2.1] ***************************************
*
* NAME	
*    drawImageState()
*
* DESCRIPTION
*    Draw an (extended) Intuition Image with special visual state.
*      <primitive 200 22 ownerWindow private state (aPoint x) (aPoint y)>
*
* FUNCTION
*    This function draws an Intuition Image structure in a variety of
*    "visual states," which are defined by constants in
*    intuition/imageclass.h.  These include:
**********************************************************************
*
*/

METHODFUNC void drawImageState( struct Window *wp, OBJECT *imgObj, 
                                LONG left, LONG top, ULONG state
                              )
{
   struct Screen   *sptr  = wp->WScreen;
   struct Image    *image = (struct Image *) CheckObject( imgObj );
   struct DrawInfo *di    = NULL;
   
   BOOL             validstate = FALSE;

   // ---------------------------------------------------------------
   
   if (!image || !sptr) // == NULL)
      return;
         
   switch (state) // why we need #include <intuition/imageclass.h>
      {
      case IDS_NORMAL:           // like DrawImage()
      case IDS_SELECTED:         // represents the "selected state" of a Gadget
      case IDS_DISABLED:         // the "ghosted state" of a gadget
      case IDS_BUSY:             // for future functionality
      case IDS_INDETERMINATE:    // for future functionality
      case IDS_INACTIVENORMAL:   // for gadgets in window border
      case IDS_INACTIVESELECTED: // for gadgets in window border
      case IDS_INACTIVEDISABLED: // for gadgets in window border
      case IDS_SELECTEDDISABLED: // disabled and selected
         validstate = TRUE;
      
      default:
         break;
      }

   if (validstate == FALSE)
      state = IDS_NORMAL;
               
   di = GetScreenDrawInfo( sptr );
   
   DrawImageState( wp->RPort, image, left, top, state, di ); 

   if (di) // != NULL)
      FreeScreenDrawInfo( sptr, di );
   
   return;
}

/****i* pointInImage() [2.1] *****************************************
*
* NAME
*    pointInImage()
*
* DESCRIPTION
*    ^ <primitive 200 23 imageObj x y> 
**********************************************************************
*
*/

METHODFUNC OBJECT *pointInImage( OBJECT *imgObj, int x, int y )
{
   struct Image *image = (struct Image *) CheckObject( imgObj );
   ULONG         point = (x & 0xFFFF) << 16 + (y & 0xFFFF);
   
   if (!image) // == NULL)
      return( o_false );
      
   if (PointInImage( point, image ) == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* eraseImage() [2.1] *******************************************
*
* NAME
*    eraseImage()
*
* DESCRIPTION
*    ^ <primitive 200 24 ownerWindow imageObj left top> 
**********************************************************************
*
*/

METHODFUNC void eraseImage( struct RastPort *rp, OBJECT *imgObj, LONG left, LONG top )
{
   struct Image *image = (struct Image *) CheckObject( imgObj );
   
   if (rp && image) // != NULL) 
      EraseImage( rp, image, left, top );
      
   return;
}

/****i* areaEllipse() [2.1] ******************************************
*
* NAME
*    areaEllipse()
*
* DESCRIPTION
*    ^ <primitive 200 25 rport xc yc aAxis bAxis> 
**********************************************************************
*
*/

METHODFUNC OBJECT *areaEllipse( struct RastPort *rp, LONG xCenter, LONG yCenter,
                                LONG a, LONG b )
{
   if (rp) // != NULL)
      return( AssignObj( new_int( (int) AreaEllipse( rp, xCenter, yCenter, a, b ))));
   else
      return( o_nil );
}                                

// <primitive 200 26> is another call to areaEllipse() for areaCircle().
                  
/****i* areaMove() [2.1] *********************************************
*
* NAME
*    areaMove()
*
* DESCRIPTION
*    ^ <primitive 200 27 rport x y> 
**********************************************************************
*
*/

METHODFUNC OBJECT *areaMove( struct RastPort *rp, LONG x, LONG y )
{
   if (rp) // != NULL)
      return( AssignObj( new_int( (int) AreaMove( rp, x, y ))));
   else
      return( o_nil );
}

/****i* areaDraw() [2.1] *********************************************
*
* NAME
*    areaDraw()
*
* DESCRIPTION
*    ^ <primitive 200 28 rport x y> 
**********************************************************************
*
*/

METHODFUNC OBJECT *areaDraw( struct RastPort *rp, LONG x, LONG y )
{
   if (rp) // != NULL)
      return( AssignObj( new_int( (int) AreaDraw( rp, x, y ))));
   else
      return( o_nil );
}

/****i* rectFill() [2.1] *********************************************
*
* NAME
*    rectFill()
*
* DESCRIPTION
*    <primitive 200 29 rport xMin yMin xMax yMax> 
**********************************************************************
*
*/

METHODFUNC void rectFill( struct RastPort *rp, LONG xMin, LONG yMin, 
                                               LONG xMax, LONG yMax 
                        )
{
   if (rp) // != NULL)
      RectFill( rp, xMin, yMin, xMax, yMax );
      
   return;
}

/****i* flood() [2.1] ************************************************
*
* NAME
*    flood()
*
* DESCRIPTION
*    ^ <primitive 200 30 rport mode x y> 
**********************************************************************
*
*/

METHODFUNC OBJECT *flood( struct RastPort *rp, ULONG mode, LONG x, LONG y )
{
   OBJECT *rval = o_false;
   
   if (rp) // != NULL)
      {
      if (Flood( rp, mode, x, y ) != TRUE)
         return( rval );
      else
         return( o_true );
      }
   else
      return( rval );
}

/****i* areaEnd() [2.1] **********************************************
*
* NAME
*    areaEnd()
*
* DESCRIPTION
*    ^ <primitive 200 31 rport> 
**********************************************************************
*
*/

METHODFUNC OBJECT *areaEnd( struct RastPort *rp )
{
   if (rp) // != NULL)
      return( AssignObj( new_int( (int) AreaEnd( rp ))));
   else
      return( o_nil );
}
        
/****i* setAreaPattern() [2.1] ***************************************
*
* NAME
*    setAreaPattern()
*
* DESCRIPTION
*    ^ <primitive 200 32 rport pattArray size> 
**********************************************************************
*
*/

METHODFUNC void setAreaPattern( struct RastPort *rp, OBJECT *pattArray, LONG size )
{
   UWORD *patt = (UWORD *) ((BYTEARRAY *) pattArray)->bytes;
   
   if (!rp) // == NULL)
      return;

   /* size is the number of lines the Pattern covers (expressed as a 
   ** power of two).  byteArray size is 2 * (2 ^ size) + 1, so 
   */
   if ((((BYTEARRAY *) pattArray)->bsize - 1) != (1 << (size + 1)))
      return;
      
   SetAfPt( rp, patt, size );
   
   return;         
}

/****i* initArea() [2.1] *********************************************
*
* NAME
*    initArea()
*
* DESCRIPTION
*    ^ <primitive 200 33 rport numPoints xTmpRasSize yTmpRasSize> 
**********************************************************************
*
*/

METHODFUNC OBJECT *initArea( struct RastPort *rp, LONG numpoints,
                             LONG xTmpSize, LONG yTmpSize
                           )
{
   struct   AreaInfo *ai      = NULL;
   struct   TmpRas   *tr      = NULL;
   PLANEPTR           space   = AllocRaster( xTmpSize, yTmpSize );
   OBJECT            *rval    = o_nil;
   WORD              *buffer  = NULL;
   int                bufSize = numpoints * 5;

   if (!space) // == NULL)
      return( rval );

   if (!(tr = (struct TmpRas *) AT_AllocVec( sizeof( struct TmpRas),
                                             MEMF_CLEAR | MEMF_ANY,
                                             "tempRAS", TRUE ))) // == NULL)
      {
      FreeRaster( space, xTmpSize, yTmpSize );
      
      return( rval );
      }
            
   if (!(buffer = (WORD *) AT_AllocVec( bufSize * sizeof( WORD ),
                                        MEMF_CLEAR | MEMF_ANY,
                                        "rasBuff", TRUE ))) // == NULL)
      {
      AT_FreeVec( tr, "tempRAS", TRUE );

      FreeRaster( space, xTmpSize, yTmpSize );
      
      return( rval );
      }

   if (!(ai = (struct AreaInfo *) AT_AllocVec( sizeof( struct AreaInfo ),
                                               MEMF_CLEAR | MEMF_ANY,
                                               "areaInfo", TRUE ))) // == NULL)
      {
      AT_FreeVec( tr, "tempRAS", TRUE );

      FreeRaster( space, xTmpSize, yTmpSize );
      
      AT_FreeVec( buffer, "rasBuff", TRUE );

      return( rval );
      }

   (void) InitTmpRas( tr, space, ((xTmpSize + 15) >> 4) * yTmpSize );

   InitArea( ai, buffer, sizeof( WORD ) * bufSize );

   rp->TmpRas   = tr;
   rp->AreaInfo = ai;
   
   return( new_address( (ULONG) buffer ) );
}

/****i* disposeArea() [2.1] ******************************************
*
* NAME
*    disposeArea()
*
* DESCRIPTION
*    bufferPointer is the value returned from initArea().
*    <primitive 200 34 rport bufferPointer [xTmpSize yTmpSize]> 
**********************************************************************
*
*/

METHODFUNC void disposeArea( struct RastPort *rp, OBJECT *buffer, LONG xSize, LONG ySize )
{
   WORD *buff = (WORD *) CheckObject( buffer );
   
   if (rp) // != NULL)
      {
      FreeRaster( rp->TmpRas->RasPtr, xSize, ySize );

      if (rp->TmpRas) // != NULL)
         AT_FreeVec( rp->TmpRas, "tempRAS", TRUE );
         
      if (buff) // != NULL)
         AT_FreeVec( buff, "rasBuff", TRUE );
      
      rp->AreaInfo = NULL;      
      }

   return;
}

// <primitive 200 35 rp> is in HandleSimpleGraphs() (outlineOff())
// <primitive 200 36 rp> is in HandleSimpleGraphs() (outlineOn())
         

/****h* HandleSimpleGraphs() [2.0] ***********************************
*
* NAME
*    HandleSimpleGraphs()
*
* DESCRIPTION
*    Translate primitive 200 calls into graphics commands.
*
* NOTES
*    args[0] == which graphic function.
*    args[1] == WindowObject.
*    args[2] == integer argument 1 (Pen#, DrawMode, ImageName, BorderName, 
*                                   X1, X or Text String). 
*
*    args[3] == integer argument 2 (Y1, ImageObj, or Y).
*    args[4] == integer argument 3 (Radius1 or X2).
*    args[5] == integer argument 4 (Radius2 or Y2).
**********************************************************************
*
*/

PUBLIC OBJECT *HandleSimpleGraphs( int numargs, OBJECT **args )
{
   struct RastPort *rport = NULL;
   struct Window   *wp    = (struct Window *) CheckObject( args[1] );
   OBJECT          *rval  = o_nil;
         
   if (is_integer( args[0] ) == FALSE)
      return( rval );
   
   if (!wp) // == NULL)
      return( rval );

   rport = wp->RPort; // wp was valid, so this should be valid also!

   switch (int_value( args[0] ))
      {
      case 0: // setAPen: [ownerWindow] pen
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            {
            SetAPen( rport, (unsigned long) int_value( args[2] ) );
            A_pen = int_value( args[2] );
            }

         break;

      case 1: // setBPen: [ownerWindow] pen
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            {
            SetBPen( rport, (unsigned long) int_value( args[2] ) );
            B_pen = int_value( args[2] );
            }

         break;

      case 2: // setOPen: [ownerWindow] pen
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else 
            {
            SetOPen( rport, int_value( args[2] ) );
            O_pen = int_value( args[2] );
            }

         break;

      case 3: // setDrawMode: [ownerWindow] newMode
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            {
            SetDrMd( rport, (unsigned long) int_value( args[2] ) );  
            Draw_Mode = int_value( args[2] );
            }

         break;

      case 4: // movePenTo: [ownerWindow] newPoint
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) )
            (void) PrintArgTypeError( 200 );
         else
            Move( rport, (long) int_value( args[2] ), 
                         (long) int_value( args[3] )
                );

         break;

      case 5: // drawTo: [ownerWindow] aPoint
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) )
            (void) PrintArgTypeError( 200 );
         else
            Draw( rport, (long) int_value( args[2] ), 
                         (long) int_value( args[3] )
                );

         break;

      case 6: // drawLineFrom: [ownerWindow] fPoint to: tPoint
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ) )
            (void) PrintArgTypeError( 200 );
         else
            {
            Move( rport, (long) int_value( args[2] ), 
                         (long) int_value( args[3] )
                );

            Draw( rport, (long) int_value( args[4] ), 
                         (long) int_value( args[5] )
                );
            }

         break;

      case 7: // <primitive 200 7 ownerWindow x1 y1 x2 y2> 
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ) )
            (void) PrintArgTypeError( 200 );
         else
            DrawBox( rport, int_value( args[2] ), 
                            int_value( args[3] ), 
                            int_value( args[4] ), 
                            int_value( args[5] )
                   );
         break;

      case 8: // <primitive 200 8 ownerWindow x y r>
              // Draw a circle (no aspect ratio adjustment):
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) 
                                     || !is_integer( args[4] ) )
            (void) PrintArgTypeError( 200 );
         else
            DrawEllipse( rport, (long) int_value( args[2] ), 
                                (long) int_value( args[3] ),
                                (long) int_value( args[4] ),
                                (long) int_value( args[4] ) 
                       );
         break;

      case 9: // drawEllipse: [ownerWindow] cPoint minaxis: a maxaxis: b
         if ( !is_integer( args[2] ) || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ) )
            (void) PrintArgTypeError( 200 );
         else
            DrawEllipse( rport, (long) int_value( args[2] ), 
                                (long) int_value( args[3] ),
                                (long) int_value( args[4] ), 
                                (long) int_value( args[5] )
                       );
         break;

      case 10: // <primitive 200 10 ownerWindow borderObj>
         DrawPolygon( rport, args[2] );
         break;

      case 11: // drawPixelAt: [ownerWindow] aPoint
         (void) WritePixel( rport, (long) int_value( args[2] ), 
                                   (long) int_value( args[3] )
                          );
         break;

      case 12: // disposeImage [private]
         if (NullChk( args[1] ) == FALSE)
            {
            RemoveImage( args[1] );
            }

         break;

      case 13: // addImage: width height: h depth: d
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = AddImage( int_value( args[2] ), int_value( args[3] ),    
                             int_value( args[4] )
                           );
         break;

      case 14: // getImagePart [ownerWindow whichPart private] 
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            rval = GetImagePart( int_value( args[2] ), args[3] ); 

         break;

      case 15: // setImagePart: [ownerWindow whichPart] valueObj [private]
         if (!is_integer( args[2] ))
            (void) PrintArgTypeError( 200 );
         else
            SetImagePart( int_value( args[2] ), args[3], args[4] );
         break;

      case 16: // drawImageAt: [ownerWindow] aPoint [private]
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 200 );
         else
            DrawAnImage( rport, int_value( args[2] ), 
                                int_value( args[3] ),
                                           args[4]
                       );
         break;
         
      case 17: // setImageDataFrom: [ownerWindow] fileName [private]
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            SetImageData( string_value( (STRING *) args[2] ), args[3] );
   
         break;
         
      case 18: // saveImageTo: [ownerWindow] fileName [private]
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            rval = SaveImage( string_value( (STRING *) args[2] ), args[3] );
         
         break;
          
      case 19:  // <primitive 200 19 windowObject text x y>
         if (!is_string( args[2] ) || !is_integer( args[3] ) 
                                   || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            DisplayIntuiText( rport, 
                              string_value( (STRING *) args[2] ),
                              int_value( args[3] ),
                              int_value( args[4] )
                            );
         break;

      case 20:  // grabImageFrom: windowObj startPoint: s endPoint: e [private]
                // <primitive 200 20 windowObj x y w h private>      
         if (!is_integer( args[2] ) || !is_integer( args[3] ) 
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = GrabImage( wp, int_value( args[2] ), int_value( args[3] ),
                                  int_value( args[4] ), int_value( args[5] ),
                                             args[6]
                            );
         break;
       
      case 21: // setLinePattern: longPatternBits
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 200 );
         else
            {
            SetDrPt( rport, (UWORD) int_value( args[2] ) ); // gfxMacros.h

            LinePattn = (UWORD) int_value( args[2] );
            }

         break;

      case 22: // drawImageAt: [ownerWindow private] aPoint inState: state
               //   <primitive 200 22 ownerWindow private state (aPoint x) (aPoint y)>
         if (!is_integer( args[3] ) || !is_integer( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 200 );
         else
            drawImageState( wp, args[2], (LONG) int_value( args[4] ), // leftOffset
                                         (LONG) int_value( args[5] ), // topOffset
                                        (ULONG) int_value( args[3] )  // state
                          );
         break;

      case 23: // pointInImage: [private] testPoint
               // ^ <primitive 200 23 private (testPoint x) (testPoint y)> 
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = pointInImage( args[2], int_value( args[3] ), 
                                          int_value( args[4] )
                               );
         break;

      case 24: // eraseImagestartingAt: [ownerWindow private] aPoint
               //   <primitive 200 24 ownerWindow private (aPoint x) (aPoint y)> 
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            eraseImage( rport, args[2], (LONG) int_value( args[3] ),
                                        (LONG) int_value( args[4] ) 
                      );
         break;
         
      case 25: // drawFilledEllipse: [ownerWindow] cPoint minaxis: a maxaxis: b
               // ^ <primitive 200 25 ownerWindow (cPoint x) (cPoint y) a b>
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = areaEllipse( rport, (LONG) int_value( args[2] ), 
                                       (LONG) int_value( args[3] ),
                                       (LONG) int_value( args[4] ),
                                       (LONG) int_value( args[5] )
                              );      
         break;
                  
      case 26: // drawFilledCircle: [ownerWindow] cPoint radius: r
               // ^ <primitive 200 26 ownerWindow (cPoint x) (cPoint y) r>
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = areaEllipse( rport, (LONG) int_value( args[2] ), 
                                       (LONG) int_value( args[3] ),
                                       (LONG) int_value( args[4] ),
                                       (LONG) int_value( args[4] )
                              );      
         break;

      case 27: // areaMoveTo: [ownerWindow] newPoint
               //   <primitive 200 27 ownerWindow (newPoint x) (newPoint y)>   
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = areaMove( rport, (LONG) int_value( args[2] ), 
                                    (LONG) int_value( args[3] )
                           );      
         break;
         
      case 28: // areaDrawTo: [ownerWindow] aPoint
               //   <primitive 200 28 ownerWindow (aPoint x) (aPoint y)>
         if (!is_integer( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = areaDraw( rport, (LONG) int_value( args[2] ), 
                                    (LONG) int_value( args[3] )
                           );      
         break;
         
      case 29: // drawFilledBoxFrom: [ownerWindow] fPoint to: tPoint
               //   <primitive 200 29 ownerWindow (fPoint x) (fPoint y) (tPoint x) (tPoint y)>
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] ))
            (void) PrintArgTypeError( 200 );
         else
            rectFill( rport, (LONG) int_value( args[2] ), 
                             (LONG) int_value( args[3] ),
                             (LONG) int_value( args[4] ),
                             (LONG) int_value( args[5] )
                    );      
         break;
                  
      case 30: // floodFill: [ownerWindow] mode at: aPoint
               // ^ <primitive 200 30 ownerWindow mode (aPoint x) (aPoint y)>  
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = flood( rport, (ULONG) int_value( args[2] ), 
                                  (LONG) int_value( args[3] ),
                                  (LONG) int_value( args[4] )
                        );      
         break;
         
      case 31: // areaEnd [ownerWindow]  ^ <primitive 200 31 ownerWindow> 
         rval = areaEnd( rport );

         break;
         
      case 32: // setAreaPattern: [ownerWindow] patternWords size: size
               //   <primitive 200 32 ownerWindow patternWords size>
         if (!is_bytearray( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 200 );
         else
            setAreaPattern( rport, args[2], (LONG) int_value( args[3] ) );      
         break;
         
      case 33: // initializeArea: [ownerWindow] numpoints tmpXSize: xSize tmpYSize: ySize
               //   ^ <primitive 200 33 ownerWindow numpoints xSize ySize
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            rval = initArea( rport, (LONG) int_value( args[2] ),
                                    (LONG) int_value( args[3] ),
                                    (LONG) int_value( args[4] )
                           );
         break;
         
      case 34: // disposeArea: [ownerWindow private] xSize y: ySize
               //   <primitive 200 34 ownerWindow private xSize ySize>
         if (!is_integer( args[3] ) || !is_integer( args[4] ))
            (void) PrintArgTypeError( 200 );
         else
            {
            disposeArea( rport, args[2], (LONG) int_value( args[3] ),
                                         (LONG) int_value( args[4] )
                       );
            }

         break;
         
      case 35: // outlineOff [ownerWindow]  <primitive 200 35 ownerWindow>
         BNDRYOFF( rport );

         break;

      case 36: // outlineOn [ownerWindow]   <primitive 200 26 ownerWindow>
         rport->Flags |= AREAOUTLINE;
         
         break;
                  
      default:
         break;
      }          

   return( rval );
}

/* ------------------- END of SimpleGraphs.c file! ------------------- */
