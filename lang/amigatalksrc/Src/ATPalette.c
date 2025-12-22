/****h* ATPalette.c [3.0] **********************************************
*
* NAME
*    ATPalette.c
*
* DESCRIPTION
*    ATPalette.c is a GUI for AmigaTalk Users to
*    select/set colors for the AmigaTalk.ini file and the currently running 
*    instance of AmigaTalk itself.
*
* SYNOPSIS
*    int error = ATalkPalette( UBYTE *iniFileName );
*
* HISTORY
*    Feb-21-2007 - Created this file.
*
* COPYRIGHT
*    ATPalette.c Feb-21-2007(C) by J.T. Steichen
*
* NOTES
*    Program set up to compile with gcc & AmigaOS4 also.
*
*    $VER: ATPalette.c 3.0 (Feb-21-2007) by J.T. Steichen
************************************************************************
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
#include <libraries/asl.h>

#include <utility/tagitem.h>
#include <dos/dostags.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>
# include <clib/diskfont_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>
# include <proto/diskfont.h>

#endif

#include <proto/locale.h>

#include "StringIndexes.h" // For PalCMsg() arguments
#include "FuncProtos.h"

IMPORT struct Catalog *ATPCatalog; // For atalkenviron.catalog

#include "CPGM:GlobalObjects/CommonFuncs.h"
#include "CPGM:GlobalObjects/IniFuncs.h"

#define   CATCOMP_ARRAY    1
#include "ATalkEnvironLocale.h"

#define ID_PaletteGad 	0
#define ID_RedSlider 	1
#define ID_GreenSlider 	2
#define ID_BlueSlider 	3
#define ID_PNameTxt 	   4
#define ID_SaveBt 	   5
#define ID_ResetBt 	   6
#define ID_CancelBt 	   7
#define ID_UseBt 	      8
#define ID_CColorTxt 	9

#define PAL_CNT 		   10

#define PEN_NAME_GAD PALGadgets[ ID_PNameTxt ]
#define CCOLOR_GAD   PALGadgets[ ID_CColorTxt ]

// ----------------------------------------------------

#ifndef __amigaos4__

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *GadToolsBase;
IMPORT struct LocaleBase    *LocaleBase;

#else

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;
IMPORT struct Library *IntuitionBase;
IMPORT struct Library *GfxBase;
IMPORT struct Library *UtilityBase;
IMPORT struct Library *LocaleBase;
IMPORT struct Library *GadToolsBase;

IMPORT struct ExecIFace      *IExec;
IMPORT struct DOSIFace       *IDOS;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;
IMPORT struct UtilityIFace   *IUtility;
IMPORT struct LocaleIFace    *ILocale;
IMPORT struct GadToolsIFace  *IGadTools;

#endif

// From Setup.c file: ---------------------------------

IMPORT int    numberOfPens;     // = 45;
IMPORT ULONG  colorPens[ 256 ];
IMPORT UBYTE *penNames[  256 ];

IMPORT struct TagItem   LoadTags[];
IMPORT struct Screen   *Scr;
IMPORT UBYTE           *PubScreenName;
IMPORT APTR             VisualInfo;
IMPORT UBYTE           *ErrMsg;

IMPORT struct TextFont     *ATFont;
IMPORT struct TextAttr     *Font;
IMPORT struct CompFont      CFont;
IMPORT struct TextAttr      helvetica13;
// ----------------------------------------------------

PRIVATE struct Window       *PALWnd   = NULL;
PRIVATE struct Gadget       *PALGList = NULL;
PRIVATE struct Gadget       *PALGadgets[ PAL_CNT ] = { 0, };

PRIVATE struct IntuiMessage  PALMsg = { 0, };

PRIVATE UWORD  PALLeft   = 340;
PRIVATE UWORD  PALTop    = 115;
PRIVATE UWORD  PALWidth  = 490;
PRIVATE UWORD  PALHeight = 616;
PRIVATE UBYTE *PALWdt    = NULL;   // WA_Title

//PRIVATE struct TextAttr DejaVu_Sans13 = { "DejaVu Sans.font", 13, 0x00, 0x62 };

PRIVATE aiPTR  ai        = (aiPTR) NULL;

PRIVATE UBYTE *hexDigit  = "0123456789ABCDEF";
PRIVATE ULONG  numColors = 0;
PRIVATE ULONG  red, green, blue;
PRIVATE ULONG  colorIndex, ncolors;
PRIVATE ULONG  table[ 5 ];
PRIVATE ULONG  *originalpalette;  // Allocate later at depth of screen

PRIVATE UWORD PALGTypes[ PAL_CNT ] = {

     PALETTE_KIND,      SLIDER_KIND,      SLIDER_KIND,
      SLIDER_KIND,        TEXT_KIND,      BUTTON_KIND,
      BUTTON_KIND,      BUTTON_KIND,      BUTTON_KIND,
        TEXT_KIND
};

PRIVATE int PaletteGadClicked(  int whichPen );
PRIVATE int RedSliderClicked(   int dummy );
PRIVATE int GreenSliderClicked( int dummy );
PRIVATE int BlueSliderClicked(  int dummy );
// --- READ_ONLY: --- PRIVATE int PNameTxtClicked( int dummy );
PRIVATE int SaveBtClicked(      int dummy );
PRIVATE int ResetBtClicked(     int dummy );
PRIVATE int CancelBtClicked(    int dummy );
PRIVATE int UseBtClicked(       int dummy );
// --- READ_ONLY: --- PRIVATE int CColorTxtClicked( int dummy );

PRIVATE struct NewGadget PALNGad[ PAL_CNT ] = {

   128,  78, 345, 327, "Colors Available:", NULL,
   ID_PaletteGad, PLACETEXT_ABOVE, 0L, (APTR) PaletteGadClicked,

   128, 409, 314,  29, "_Red:", NULL,
   ID_RedSlider, PLACETEXT_LEFT, 0L, (APTR) RedSliderClicked,

   128, 447, 314,  29, "_Green:", NULL,
   ID_GreenSlider, PLACETEXT_LEFT, 0L, (APTR) GreenSliderClicked,

   128, 486, 314,  29, "_Blue:", NULL,
   ID_BlueSlider, PLACETEXT_LEFT, 0L, (APTR) BlueSliderClicked,

   128, 523, 229,  25, "Pen Name:", NULL,
   ID_PNameTxt, PLACETEXT_LEFT, 0L, (APTR) NULL,

    15, 561,  84,  33, "_SAVE", NULL,
   ID_SaveBt, PLACETEXT_IN, 0L, (APTR) SaveBtClicked,

   257, 561,  84,  33, "R_ESET", NULL,
   ID_ResetBt, PLACETEXT_IN, 0L, (APTR) ResetBtClicked,

   384, 561,  84,  33, "_CANCEL!", NULL,
   ID_CancelBt, PLACETEXT_IN, 0L, (APTR) CancelBtClicked,

   130, 561,  84,  33, "_USE", NULL,
   ID_UseBt, PLACETEXT_IN, 0L, (APTR) UseBtClicked,

    10,  78, 113, 104, "Current Color:", NULL,
   ID_CColorTxt, PLACETEXT_ABOVE, 0L, (APTR) NULL
};

#define DEPTH_TAG  1

PRIVATE ULONG PALGTags[] = {

   GTPA_Depth, 8, GTPA_Color, 1, GTPA_ColorOffset, 0, TAG_DONE,

   GTSL_Max, 255, GTSL_MaxLevelLen, 4, GTSL_LevelFormat, (ULONG) "%03ld",
   GTSL_LevelPlace, PLACETEXT_RIGHT, PGA_Freedom, LORIENT_HORIZ,
	GA_RelVerify, TRUE, GT_Underscore, '_', TAG_DONE,
  
   GTSL_Max, 255, GTSL_MaxLevelLen, 4, GTSL_LevelFormat, (ULONG) "%03ld",
   GTSL_LevelPlace, PLACETEXT_RIGHT, PGA_Freedom, LORIENT_HORIZ,
	GA_RelVerify, TRUE, GT_Underscore, '_', TAG_DONE,
  
   GTSL_Max, 255, GTSL_MaxLevelLen, 4, GTSL_LevelFormat, (ULONG) "%03ld",
   GTSL_LevelPlace, PLACETEXT_RIGHT, PGA_Freedom, LORIENT_HORIZ,
	GA_RelVerify, TRUE, GT_Underscore, '_', TAG_DONE,
  
   GTTX_Border, FALSE, TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GT_Underscore, '_', TAG_DONE,

   GTTX_Text, (ULONG) "0x00000000", 
	GTTX_Border, TRUE, STRINGA_Justification, GACT_STRINGCENTER,
	TAG_DONE,
};

// ----------------------------------------------------

PRIVATE void SetupPaletteCatalog( int numColors )
{
   PALWdt  = PalCMsg( MSG_ATP_WTITLE_PAL ); // CMsg( MSG_PAL_WTITLE, MSG_PAL_WTITLE_STR ); // WA_Title

   PALNGad[ 0 ].ng_GadgetText = PalCMsg( MSG_GAD_Pal_PAL );//CMsg( MSG_GAD_PaletteGad,  MSG_GAD_PaletteGad_STR ); // 
   PALNGad[ 1 ].ng_GadgetText = PalCMsg( MSG_GAD_Red_PAL );//CMsg( MSG_GAD_RedSlider,   MSG_GAD_RedSlider_STR ); // 
   PALNGad[ 2 ].ng_GadgetText = PalCMsg( MSG_GAD_Green_PAL );//CMsg( MSG_GAD_GreenSlider, MSG_GAD_GreenSlider_STR ); // 
   PALNGad[ 3 ].ng_GadgetText = PalCMsg( MSG_GAD_Blue_PAL );//CMsg( MSG_GAD_BlueSlider,  MSG_GAD_BlueSlider_STR ); // 
   PALNGad[ 4 ].ng_GadgetText = PalCMsg( MSG_GAD_PenNameTxt_PAL );//CMsg( MSG_GAD_PNameTxt,    MSG_GAD_PNameTxt_STR ); // 
   PALNGad[ 5 ].ng_GadgetText = PalCMsg( MSG_GAD_SaveBt_PAL );//CMsg( MSG_GAD_SaveBt,      MSG_GAD_SaveBt_STR ); // 
   PALNGad[ 6 ].ng_GadgetText = PalCMsg( MSG_GAD_ResetBt_PAL );//CMsg( MSG_GAD_ResetBt,     MSG_GAD_ResetBt_STR ); // 
   PALNGad[ 7 ].ng_GadgetText = PalCMsg( MSG_GAD_CancelBt_PAL );//CMsg( MSG_GAD_CancelBt,    MSG_GAD_CancelBt_STR ); // 
   PALNGad[ 8 ].ng_GadgetText = PalCMsg( MSG_GAD_UseBt_PAL );//CMsg( MSG_GAD_UseBt,       MSG_GAD_UseBt_STR ); // 
   PALNGad[ 9 ].ng_GadgetText = PalCMsg( MSG_GAD_CColorTxt_PAL );//CMsg( MSG_GAD_CColorTxt,   MSG_GAD_CColorTxt_STR ); // 

   if (StringLength( &penNames[0] ) < 1)
	   {
      if (numColors > 11)
         {
         penNames[  0] = PalCMsg( MSG_ATEGRP_ITEM_PEN00_PAL ); 
         penNames[  1] = PalCMsg( MSG_ATEGRP_ITEM_PEN01_PAL ); 
         penNames[  2] = PalCMsg( MSG_ATEGRP_ITEM_PEN02_PAL ); 
         penNames[  3] = PalCMsg( MSG_ATEGRP_ITEM_PEN03_PAL ); 
         penNames[  4] = PalCMsg( MSG_ATEGRP_ITEM_PEN04_PAL ); 
         penNames[  5] = PalCMsg( MSG_ATEGRP_ITEM_PEN05_PAL ); 
         penNames[  6] = PalCMsg( MSG_ATEGRP_ITEM_PEN06_PAL ); 
         penNames[  7] = PalCMsg( MSG_ATEGRP_ITEM_PEN07_PAL ); 
         penNames[  8] = PalCMsg( MSG_ATEGRP_ITEM_PEN08_PAL ); 
         penNames[  9] = PalCMsg( MSG_ATEGRP_ITEM_PEN09_PAL ); 
         penNames[ 10] = PalCMsg( MSG_ATEGRP_ITEM_PEN0A_PAL ); 
         penNames[ 11] = PalCMsg( MSG_ATEGRP_ITEM_PEN0B_PAL ); 
         penNames[ 12] = PalCMsg( MSG_ATEGRP_ITEM_PEN0C_PAL ); 
         penNames[ 13] = PalCMsg( MSG_ATEGRP_ITEM_PEN0D_PAL ); 
         penNames[ 14] = PalCMsg( MSG_ATEGRP_ITEM_PEN0E_PAL ); 
         penNames[ 15] = PalCMsg( MSG_ATEGRP_ITEM_PEN0F_PAL ); 
         penNames[ 16] = PalCMsg( MSG_ATEGRP_ITEM_PEN10_PAL ); 
         penNames[ 17] = PalCMsg( MSG_ATEGRP_ITEM_PEN11_PAL ); 
         penNames[ 18] = PalCMsg( MSG_ATEGRP_ITEM_PEN12_PAL ); 
         penNames[ 19] = PalCMsg( MSG_ATEGRP_ITEM_PEN13_PAL ); 
         penNames[ 20] = PalCMsg( MSG_ATEGRP_ITEM_PEN14_PAL ); 
         penNames[ 21] = PalCMsg( MSG_ATEGRP_ITEM_PEN15_PAL ); 
         penNames[ 22] = PalCMsg( MSG_ATEGRP_ITEM_PEN16_PAL ); 
         penNames[ 23] = PalCMsg( MSG_ATEGRP_ITEM_PEN17_PAL ); 
         penNames[ 24] = PalCMsg( MSG_ATEGRP_ITEM_PEN18_PAL ); 
         penNames[ 25] = PalCMsg( MSG_ATEGRP_ITEM_PEN19_PAL ); 
         penNames[ 26] = PalCMsg( MSG_ATEGRP_ITEM_PEN1A_PAL ); 
         penNames[ 27] = PalCMsg( MSG_ATEGRP_ITEM_PEN1B_PAL ); 
         penNames[ 28] = PalCMsg( MSG_ATEGRP_ITEM_PEN1C_PAL ); 
         penNames[ 29] = PalCMsg( MSG_ATEGRP_ITEM_PEN1D_PAL ); 
         penNames[ 30] = PalCMsg( MSG_ATEGRP_ITEM_PEN1E_PAL ); 
         penNames[ 31] = PalCMsg( MSG_ATEGRP_ITEM_PEN1F_PAL ); 
         penNames[ 32] = PalCMsg( MSG_ATEGRP_ITEM_PEN20_PAL ); 
         penNames[ 33] = PalCMsg( MSG_ATEGRP_ITEM_PEN21_PAL ); 
         penNames[ 34] = PalCMsg( MSG_ATEGRP_ITEM_PEN22_PAL ); 
         penNames[ 35] = PalCMsg( MSG_ATEGRP_ITEM_PEN23_PAL ); 
         penNames[ 36] = PalCMsg( MSG_ATEGRP_ITEM_PEN24_PAL ); 
         penNames[ 37] = PalCMsg( MSG_ATEGRP_ITEM_PEN25_PAL ); 
         penNames[ 38] = PalCMsg( MSG_ATEGRP_ITEM_PEN26_PAL ); 
         penNames[ 39] = PalCMsg( MSG_ATEGRP_ITEM_PEN27_PAL ); 
         penNames[ 40] = PalCMsg( MSG_ATEGRP_ITEM_PEN28_PAL ); 
         penNames[ 41] = PalCMsg( MSG_ATEGRP_ITEM_PEN29_PAL ); 
         penNames[ 42] = PalCMsg( MSG_ATEGRP_ITEM_PEN2A_PAL ); 
         penNames[ 43] = PalCMsg( MSG_ATEGRP_ITEM_PEN2B_PAL ); 
         penNames[ 44] = PalCMsg( MSG_ATEGRP_ITEM_PEN2C_PAL ); 
         }
      else if (numColors > 8)
         {
         penNames[  0] = PalCMsg( MSG_ATEGRP_ITEM_PEN00_PAL ); 
         penNames[  1] = PalCMsg( MSG_ATEGRP_ITEM_PEN01_PAL ); 
         penNames[  2] = PalCMsg( MSG_ATEGRP_ITEM_PEN02_PAL ); 
         penNames[  3] = PalCMsg( MSG_ATEGRP_ITEM_PEN03_PAL ); 
         penNames[  4] = PalCMsg( MSG_ATEGRP_ITEM_PEN04_PAL ); 
         penNames[  5] = PalCMsg( MSG_ATEGRP_ITEM_PEN05_PAL ); 
         penNames[  6] = PalCMsg( MSG_ATEGRP_ITEM_PEN06_PAL ); 
         penNames[  7] = PalCMsg( MSG_ATEGRP_ITEM_PEN07_PAL ); 
         penNames[  8] = PalCMsg( MSG_ATEGRP_ITEM_PEN08_PAL ); 
         penNames[  9] = PalCMsg( MSG_ATEGRP_ITEM_PEN09_PAL ); 
         penNames[ 10] = PalCMsg( MSG_ATEGRP_ITEM_PEN0A_PAL ); 
         penNames[ 11] = PalCMsg( MSG_ATEGRP_ITEM_PEN0B_PAL ); 
         }
      else
         {         
         penNames[  0] = PalCMsg( MSG_ATEGRP_ITEM_PEN00_PAL ); 
         penNames[  1] = PalCMsg( MSG_ATEGRP_ITEM_PEN01_PAL ); 
         penNames[  2] = PalCMsg( MSG_ATEGRP_ITEM_PEN02_PAL ); 
         penNames[  3] = PalCMsg( MSG_ATEGRP_ITEM_PEN03_PAL ); 
         penNames[  4] = PalCMsg( MSG_ATEGRP_ITEM_PEN04_PAL ); 
         penNames[  5] = PalCMsg( MSG_ATEGRP_ITEM_PEN05_PAL ); 
         penNames[  6] = PalCMsg( MSG_ATEGRP_ITEM_PEN06_PAL ); 
         penNames[  7] = PalCMsg( MSG_ATEGRP_ITEM_PEN07_PAL ); 
         penNames[  8] = PalCMsg( MSG_ATEGRP_ITEM_PEN08_PAL ); 
         }
		}
		
   return;
}

// ----------------------------------------------------------------

SUBFUNC void setCurrentColorValueString( void )
{
	char penValueStr[32] = { 0, };
		
   sprintf( &penValueStr[0], "0x%c%c%c%c%c%c00\0",
                             hexDigit[ (red   & 0xF0) >> 4 ],
			                    hexDigit[ (red   & 0x0F)      ],
                             hexDigit[ (green & 0xF0) >> 4 ],
			                    hexDigit[ (green & 0x0F)      ],
                             hexDigit[ (blue  & 0xF0) >> 4 ],
			                    hexDigit[ (blue  & 0x0F)      ]
	       );

   GT_SetGadgetAttrs( CCOLOR_GAD, PALWnd, NULL, GTTX_Text, (UBYTE *) &penValueStr[0], TAG_DONE );
	
	return;
}

PRIVATE int SetTable( void )
{
   table[0] = (1L << 16) + colorIndex;
   table[1] = red   << 24 | 0x00FFFFFF;
   table[2] = green << 24 | 0x00FFFFFF;
   table[3] = blue  << 24 | 0x00FFFFFF;
   table[4] = (ULONG) NULL;

// SetRGB32( &Scr->ViewPort, colorIndex, table[1], table[2], table[3] );
   LoadRGB32( &Scr->ViewPort, table );

   GT_SetGadgetAttrs( PEN_NAME_GAD, PALWnd, NULL, GTTX_Text, penNames[colorIndex], TAG_DONE );

   setCurrentColorValueString();

   return( 0 );
}

SUBFUNC int toHexDigit( UBYTE chr )
{
   chr = toupper( chr );

   if (chr >= '0' && chr <= '9')
      return( chr - '0' );
   else if (chr >= 'A' && chr <= 'F')
      return( chr - 'A' + 10 );
   else
      return( chr - '0' );
}

SUBFUNC void decomposeColorValue( UBYTE *value, int colorNum )
{
   if (!value)
      return;
      
   if (*value == '0' && *(value + 1) == 'x')
      {
      value++;
      value++;
      }

   red  = (toHexDigit( *value ) << 4);
   value++;
   red += toHexDigit( *value );      
   value++;

   green  = (toHexDigit( *value ) << 4);
   value++;
   green += toHexDigit( *value );
   value++;

   blue   = (toHexDigit( *value ) << 4);
   value++;
   blue  += toHexDigit( *value );

   colorIndex = colorNum;
   SetTable();

   return;
}


//    10,  78, 113, 104, "Current Color:", NULL,
#define FBX  12     // Current Color Indicator box values.
#define FBY  80
#define FBW  111
#define FBH  102 

PRIVATE void FillColorBox( void )
{
   // Current Color indicator box:
   RectFill( PALWnd->RPort, 
             PALWnd->BorderLeft + FBX,
             PALWnd->BorderTop  + FBY,
             PALWnd->BorderLeft + FBX + FBW, 
             PALWnd->BorderTop  + FBY + FBH
           );

   return;
}

PRIVATE int ResetPalette( void )
{
   LoadRGB32( &Scr->ViewPort, originalpalette );
   GetRGB32( Scr->ViewPort.ColorMap, colorIndex, 1, &table[1] );
   
   red   = table[1] >> 24;
   green = table[2] >> 24;
   blue  = table[3] >> 24;
   
   SetAPen( PALWnd->RPort, colorIndex );
   FillColorBox();

   setCurrentColorValueString();

   GT_SetGadgetAttrs( PALGadgets[ ID_RedSlider ], PALWnd, NULL,
                      GTSL_Level, red, TAG_END
                    );

   GT_SetGadgetAttrs( PALGadgets[ ID_GreenSlider ], PALWnd, NULL,
                      GTSL_Level, green, TAG_END
                    );
     
   GT_SetGadgetAttrs( PALGadgets[ ID_BlueSlider ], PALWnd, NULL,
                      GTSL_Level, blue, TAG_END
                    );

   GT_SetGadgetAttrs( PEN_NAME_GAD, PALWnd, NULL, GTTX_Text, penNames[colorIndex], TAG_DONE );

   return( 0 );
}

// ----------------------------------------------------------------

PRIVATE void ClosePALWindow( void )
{
   if (PALWnd)
      {
      CloseWindow( PALWnd );

      PALWnd = NULL;
      }

   if (PALGList)
      {
      FreeGadgets( PALGList );

      PALGList = NULL;
      }

   return;
}

// ----------------------------------------------------------------

PRIVATE int PaletteGadClicked( int whichColor )
{
   colorIndex = whichColor;

   GetRGB32( Scr->ViewPort.ColorMap, colorIndex, 1, &table[1] );

   red   = table[1] >> 24;
   green = table[2] >> 24;
   blue  = table[3] >> 24;

   SetDrMd( PALWnd->RPort, JAM2 );
   SetAPen( PALWnd->RPort, colorIndex );
   FillColorBox();

   GT_SetGadgetAttrs( PALGadgets[ ID_RedSlider ], PALWnd, NULL,
                      GTSL_Level, red, TAG_END
                    );

   GT_SetGadgetAttrs( PALGadgets[ ID_GreenSlider ], PALWnd, NULL,
                      GTSL_Level, green, TAG_END
                    );

   GT_SetGadgetAttrs( PALGadgets[ ID_BlueSlider ], PALWnd, NULL,
                      GTSL_Level, blue, TAG_END
                    );

   GT_SetGadgetAttrs( PEN_NAME_GAD, PALWnd, NULL, GTTX_Text, penNames[whichColor], TAG_DONE );

   setCurrentColorValueString();

   return( TRUE );
}

PRIVATE int RedSliderClicked( int value )
{
   red = value;
   SetTable();

   return( TRUE );
}

PRIVATE int GreenSliderClicked( int value )
{
   green = value;
   SetTable();

   return( TRUE );
}

PRIVATE int BlueSliderClicked( int value )
{
   blue = value;
   SetTable();

   return( TRUE );
}

PRIVATE int SaveBtClicked( int dummy )
{
   int    idx, i;

   (void) iniFirstGroup( ai );
      
   idx = iniFindGroup( ai, PalCMsg( MSG_ATEGRP_PALETTE_PAL ) );
   
   DBG( fprintf( stderr, "SaveBtClicked() found %d for Palette group\n", idx ) );

   if (idx > 0)
      {
      if (idx = iniFindItem( ai, PalCMsg( MSG_ATEGRP_ITEM_NUM_PENS_PAL )))
         numColors = atoi( iniGetItemValue( ai, idx++ ) );
	 
      DBG( fprintf( stderr, "number of colors = %d\n", numColors ) );

      if (numColors > 0)
         {
	      UBYTE penString[32] = { 0, };
	 
	      DBG( fprintf( stderr, "Saving %d pens...\n", numColors ) );

   	   for (i = 0; i < numColors; i++)
	         {
            GetRGB32( Scr->ViewPort.ColorMap, i, 1, &table[1] );

            red   = table[1] >> 24;
            green = table[2] >> 24;
            blue  = table[3] >> 24;
            
	         sprintf( &penString[0], "0x%c%c%c%c%c%c00\0",
	                             hexDigit[ (red   & 0xF0) >> 4 ],
				                    hexDigit[ (red   & 0x0F)      ],
	                             hexDigit[ (green & 0xF0) >> 4 ],
				                    hexDigit[ (green & 0x0F)      ],
	                             hexDigit[ (blue  & 0xF0) >> 4 ],
				                    hexDigit[ (blue  & 0x0F)      ]
		             );
	    
            (void) iniSetItemValue( ai, idx + i, &penString[0] );
	         }
	 
	      (void) iniWrite( ai );
     	   }
      }

   return( FALSE );
}

PRIVATE int ResetBtClicked( int dummy )
{
   ResetPalette(); // Action for ResetBt:

   return( TRUE );
}

PRIVATE int CancelBtClicked( int dummy )
{
   ResetPalette(); // Action for CancelBt:

   return( FALSE );
}

PRIVATE int UseBtClicked( int dummy )
{
   return( FALSE );
}

// ----------------------------------------------------------------

PRIVATE int OpenPALWindow( void )
{
   struct NewGadget  ng = { 0, };
   struct Gadget    *g  = NULL;
   UWORD             lc, tc;
    WORD             zCoords[] = { 100, 0, 300, 25 };
   UWORD             wleft, wtop, ww, wh;

   ComputeFont( Scr, Font, &CFont, PALWidth, PALHeight );

   ww = ComputeX( CFont.FontX, PALWidth  );
   wh = ComputeY( CFont.FontY, PALHeight );

   wleft = (Scr->Width  - PALWidth ) / 2;
   wtop  = (Scr->Height - PALHeight) / 2;

   if (!(g = CreateContext( &PALGList )))
	   {
      DBG( fprintf( stderr, "CreateContext() in OpenPALWindow() FAILED!\n" ) );
      return( -1 );
	   }

   for (lc = 0, tc = 0; lc < PAL_CNT; lc++)
      {
      CopyMem( (char *) &PALNGad[ lc ], (char *) &ng,
               (long) sizeof( struct NewGadget )
             );

      ng.ng_VisualInfo = VisualInfo;
      ng.ng_TextAttr   = Font; // &helvetica13;
      ng.ng_LeftEdge   = CFont.OffX + ComputeX( CFont.FontX, ng.ng_LeftEdge );
      ng.ng_TopEdge    = CFont.OffY + ComputeY( CFont.FontY, ng.ng_TopEdge );

      PALGadgets[ lc ] = g
                       = CreateGadgetA( (ULONG) PALGTypes[ lc ],
                                        g,
                                        &ng,
                                        (struct TagItem *) &PALGTags[ tc ]
                                      );

      while (PALGTags[ tc ] != TAG_DONE)
         tc += 2;

      tc++;

      if (!g)
		   {
         DBG( fprintf( stderr, "CreateGadgetA( %d ) in OpenPALWindow() FAILED!\n", lc ) );
         return( -2 );
		   }
      }

   if (!(PALWnd = OpenWindowTags( NULL,

         WA_Left,          wleft,
         WA_Top,           wtop,
         WA_Width,         ww + CFont.OffX + Scr->WBorRight,
         WA_Height,        wh + CFont.OffY + Scr->WBorBottom,

         WA_IDCMP,        PALETTEIDCMP | SLIDERIDCMP | TEXTIDCMP | BUTTONIDCMP
           | IDCMP_VANILLAKEY | IDCMP_RAWKEY | IDCMP_REFRESHWINDOW | IDCMP_CLOSEWINDOW,

         WA_Flags,         WFLG_ACTIVATE | WFLG_DRAGBAR | WFLG_DEPTHGADGET
           | WFLG_RMBTRAP | WFLG_CLOSEGADGET | WFLG_HASZOOM,

         WA_Zoom,          (ULONG) &zCoords[0],
         WA_Gadgets,       PALGList,
         WA_Title,         PALWdt,
         WA_CustomScreen,  Scr,
         TAG_DONE )))
      {
      DBG( fprintf( stderr, "OpenWindowTags() in OpenPALWindow() FAILED!\n" ) );
      return( -4 );
      }

   GT_RefreshWindow( PALWnd, NULL );

   return( 0 );
}


PRIVATE int PALVanillaKey( int whichKey )
{
   int rval = TRUE;

   switch (whichKey)
      {
      case 'q':
      case 'Q': // Force User to use the buttons!
         break;
			
		case 's':
		case 'S':
         rval = SaveBtClicked( 0 );
			break;
			
		case 'c':
		case 'C':
		   rval = CancelBtClicked( 0 );
		   break;
			
		case 'u':
		case 'U':
		   rval = UseBtClicked( 0 );
		   break;
			
		case 'e':
		case 'E':
		   break;
            rval = ResetBtClicked( 0 );
				break;
				
      case 'r':
         red = (++red) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_RedSlider ], PALWnd, NULL, 
                            GTSL_Level, red, TAG_END
                          );
         SetTable();
         break;
     
      case 'R':
         red = (--red) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_RedSlider ], PALWnd, NULL, 
                            GTSL_Level, red, TAG_END
                          );
         SetTable();
         break;

      case 'g':
         green = (++green) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_GreenSlider ], PALWnd, NULL, 
                            GTSL_Level, green, TAG_END
                          );
         SetTable();
         break;

      case 'G':
         green = (--green) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_GreenSlider ], PALWnd, NULL, 
                            GTSL_Level, green, TAG_END
                          );
         SetTable();
         break;
      
      case 'b':
         blue = (++blue) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_BlueSlider ], PALWnd, NULL, 
                            GTSL_Level, blue, TAG_END
                          );
         SetTable();
         break;

      case 'B':
         blue = (--blue) & 0xFF;
         GT_SetGadgetAttrs( PALGadgets[ ID_BlueSlider ], PALWnd, NULL, 
                            GTSL_Level, blue, TAG_END
                          );
         SetTable();
         break;
                         	
      default:
         break;

      }

   return( rval );
}

PRIVATE int PALRawKey( struct IntuiMessage *m )
{
   IMPORT int ATHelpProgram( void ); // In ATMenus.c file
	
   int rval = TRUE;

   switch (m->Code)
      {
      case HELP: // 0x5F == 95
		   rval = ATHelpProgram();
         break;

      default:
         break;

      }

   return( rval );
}

PRIVATE int HandlePALIDCMP( void )
{
   struct IntuiMessage *m;
   int                (*func)( int );
   BOOL                 running = TRUE;

   while (running == TRUE)
      {
      if (!(m = GT_GetIMsg( PALWnd->UserPort )))
         {
         (void) Wait( 1L << PALWnd->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) m, (char *) &PALMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      GT_ReplyIMsg( m );

      switch (PALMsg.Class)
         {
            case IDCMP_CLOSEWINDOW:
				   ClosePALWindow();
               running = FALSE;
               break;

            case IDCMP_GADGETDOWN:
               if ((func = (int (*)( int )) ((struct Gadget *) PALMsg.IAddress)->UserData))
                  running = func( PALMsg.Code );

               break;

            case IDCMP_GADGETUP:
               if ((func = (int (*)( int )) ((struct Gadget *) PALMsg.IAddress)->UserData))
                  running = func( PALMsg.Code );

               break;

            case IDCMP_VANILLAKEY:
               running = PALVanillaKey( PALMsg.Code );
               break;

            case IDCMP_RAWKEY:
               running = PALRawKey( &PALMsg );
               break;
/*
         case IDCMP_CHANGEWINDOW:
            (void) PalClicked( colorIndex );
            break;
*/

            case IDCMP_REFRESHWINDOW:
               GT_BeginRefresh( PALWnd );

               GT_EndRefresh( PALWnd, TRUE );

               break;
         }
      }

   return( running );
}

// ----------------------------------------------------------------

PRIVATE void ShutdownProgram( void )
{
   ClosePALWindow();

   if (ai)
	   iniExit( ai );

   return;
}

SUBFUNC int getIniColors( aiPTR ai )
{
   int rval = 0, idx = 0, i = 0;
   
   (void) iniFirstGroup( ai );

   idx = iniFindGroup( ai, PalCMsg( MSG_ATEGRP_PALETTE_PAL ) );

   DBG( fprintf( stderr, "iniFindGroup() in getIniColors() returned %d\n", idx ) );

   if (idx > 0)
      {
      if (idx = iniFindItem( ai, PalCMsg( MSG_ATEGRP_ITEM_NUM_PENS_PAL )))
         rval = atoi( iniGetItemValue( ai, idx++ ) );
	 
      DBG( fprintf( stderr, "number of colors in getIniColors() is %d\n", rval ) );

      if (rval > 0)
         {
	      UBYTE *colorValue = NULL;
	 
	      for (i = 0; i < rval; i++)
	         {
	         colorValue = iniGetItemValue( ai, idx + i );
	    
	         decomposeColorValue( colorValue, i );
	         }
	      }
      }

//   DBG( fprintf( stderr, "Exiting getIniColors().\n" ) );
      
   return( rval );
}

PRIVATE int SetupProgram( UBYTE *iniFileName )
{
   int rval = RETURN_OK, numColors = 0;

   if (!(ai = iniOpenFile( iniFileName, FALSE, "= ;&" )))
      {
      rval = RETURN_FAIL;

      DBG( fprintf( stderr, "Could NOT open %s file!\n", iniFileName ) );

      goto exitSetup;
      }

   numColors = getIniColors( ai );

   if (LocaleBase)
      {
		if (!ATPCatalog)
		   {
         ATPCatalog = (struct Catalog *) OpenCatalog( NULL, "atalkenviron.catalog",
                                                      OC_BuiltInLanguage, "english", 
                                                      TAG_DONE 
                                                    );
			}
      }

   (void) SetupPaletteCatalog( numColors );
   DBG( fprintf( stderr, "Going to OpenPALWindow()...\n" ) );

   if (OpenPALWindow() != RETURN_OK)
      {
      rval = ERROR_ON_OPENING_WINDOW;

      ShutdownProgram();

      goto exitSetup;
      }

exitSetup:

   return( rval );
}

PUBLIC int ATalkPalette( UBYTE *iniFileName )
{
   int rval = RETURN_OK;

   if ((rval = SetupProgram( iniFileName )) != RETURN_OK)
      {
      DBG( fprintf( stderr, "Could NOT open Palette Window!\n" ) );
			
      return( rval );
      }
      
   SetNotifyWindow( PALWnd );

   ncolors               = 1 << Scr->BitMap.Depth;
   PALGTags[ DEPTH_TAG ] = Scr->BitMap.Depth;

   originalpalette = AllocVec( 8 + 12 * ncolors, MEMF_ANY | MEMF_CLEAR );

   if (originalpalette) // != NULL)
      {
		colorIndex = 0; 
		
      GetRGB32( Scr->ViewPort.ColorMap, 0, ncolors, &originalpalette[1] );

      originalpalette[0] = ncolors << 16 + 0;

      ResetPalette();

      (void) HandlePALIDCMP();

      FreeVec( originalpalette );
      }
   else
      rval = ERROR_NO_FREE_STORE;

   ShutdownProgram();

   return( rval );
}

/* --------------- END of ATPalette.c file! ------------------ */

