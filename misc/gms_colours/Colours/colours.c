/*
** Module:    Colours.
** Type:      Function based.
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1998.  All rights reserved.
**
** --------------------------------------------------------------------------
**
** TERMS AND CONDITIONS
**
** This source code is made available on the condition that it is only used
** to further enhance the Games Master System.  IT IS NOT DISTRIBUTED FOR THE
** USE IN OTHER PRODUCTS.  Developers may edit and re-release this source
** code only in the form of its GMS module.  Use of this code outside of the
** module is not permitted under any circumstances.
**
** This source code stays the copyright of DreamWorld Productions regardless
** of what changes or additions are made to it by 3rd parties.  A joint
** copyright can be granted if the 3rd party wishes to retain some ownership
** of said modifications.
**
** In exchange for our distribution of this source code, we also ask you to
** distribute the source when releasing a modified version of this module.
** This is not compulsory if any additions are sensitive to 3rd party
** copyrights, or if it would damage any commercial product(s).
**
** --------------------------------------------------------------------------
**
** BUGS AND MISSING FEATURES
** -------------------------
** If you correct a bug or fill in a missing feature, the source should be
** e-mailed to pmanias@ihug.co.nz for inclusion in the next update of this
** module.
**
** + To be added:
**
**      ConvertHSVToRGB(*HSV)
**      AdjustContrast(RGB, Percent)   [Adjust RGB from -100 to 100%]
**      AdjustBrightness(RGB, Percent)
**      AdjustColour(RGB, Percent)
**      AnalyseBitmap(Bitmap)          [Counts colours in a Bitmap]
**      BlurPixel()
**      XORPixel()
**      NOTPixel()
**      SetPenEffect(EffectNo,Setting)
**        PNE_LIGHTEN, PNE_DARKEN, PNE_BLUR
**
** + If you have colour functions or other special effects that are suited
**   for inclusion in this module, they would be much appreciated!
**
** DCC COMPILE
** -----------
** 1> dcc -c -l0 -mD -mi colours.c -o colours.o
** 1> dcc -c -l0 -mD -mi colours_data.c -o colours_data.o
** 1> dlink colours_data.o colours.o -o GMS:System/colours.mod
**
** CHANGES
** -------
** 26 May Development starts today.
** 16 Aug Publicly released.
*/

#include <proto/dpkernel.h>
#include <system/all.h>

#include "defs.h"

/***********************************************************************************/

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "June 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1996-1998.  All rights reserved.";
BYTE ModName[]      = "Colours";

struct Function JumpTableV1[] = {
  { LIBBlurArea,        "BlurArea(a0l,d0w,d1w,d2w,d3w,d4w)"    },
  { LIBClosestColour,   "ClosestColour(d0l,a0l)"               },
  { LIBConvertHSVToRGB, "ConvertHSVToRGB(a0l)"                 },
  { LIBConvertRGBToHSV, "ConvertRGBToHSV(d0l,a0l)"             },
  { LIBCopyPalette,     "CopyPalette(a0l,a1l,d0l,d1l,d2l)"     },
  { LIBDarkenArea,      "DarkenArea(a0l,d0w,d1w,d2w,d3w,d4w)"  },
  { LIBLightenArea,     "LightenArea(a0l,d0w,d1w,d2w,d3w,d4w)" },
  { LIBRemapBitmap,     "RemapBitmap(a0l,a1l,d0w)"             },
  { LIBDarkenPixel,     "DarkenPixel(a0l,d0w,d1w,d2w)"         },
  { LIBLightenPixel,    "LightenPixel(a0l,d0w,d1w,d2w)"        },
  { LIBCalcBrightness,  "CalcBrightness(d0l)"                  },
  { NULL, NULL }
};

/************************************************************************************
** Command: Init()
** Short:   Called when our module is being loaded for the first time.
*/

LIBFUNC LONG CMDInit(mreg(__a0) LONG argModule,
                  mreg(__a1) LONG argDPKBase,
                  mreg(__a2) LONG argGVBase,
                  mreg(__d0) LONG argDPKVersion,
                  mreg(__d1) LONG argDPKRevision)
{
  WORD error = ERR_FAILED;

  DPKBase    = (APTR)argDPKBase;
  GVBase     = (struct GVBase *)argGVBase;
  Public     = ((struct Module *)argModule)->Public;
  BlitterMod = NULL;

  if ((argDPKVersion < 0) OR ((argDPKVersion IS 0) AND (argDPKRevision < 0))) {
     DPrintF("!Colours:","The colours module requires V%d.%d of the dpkernel library.",DPKVersion,DPKRevision);
     return(ERR_FAILED);
  }
  else {
     if (BlitterMod = Get(ID_MODULE|GET_NOTRACK)) {
        BlitterMod->Number = MOD_BLITTER;
        if (Init(BlitterMod,NULL)) {
           BLTBase = BlitterMod->ModBase;
           error = ERR_OK;
        }
     }
  }

exit:
  if (error) FreeModule();
  return(error);
}

/************************************************************************************
** Command: Open()
** Short:   Called when our module is being opened, i.e. Init(Module).
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
  Module->FunctionList = JumpTableV1;
  Public->OpenCount++;
  return(ERR_OK);
}

/************************************************************************************
** Command: Expunge()
** Short:   Called on expunge - if no program has us opened and no objects are
**          in the system, then we can give permission to have us shut us down.
*/

LIBFUNC LONG CMDExpunge(void)
{
  if (Public) {
     if (Public->OpenCount IS NULL) {
        FreeModule();
        return(ERR_OK); /* Okay to expunge */
     }
  }
  else DPrintF("!Colours:","I have no public base reference.");

  return(ERR_FAILED); /* Do not expunge */
}

/************************************************************************************
** Command: Close()
** Short:   Called whenever someone is closing a link to our module.
*/

LIBFUNC void CMDClose(mreg(__a0) struct Module *Module)
{
  Public->OpenCount--;
}

/***********************************************************************************/

void FreeModule(void)
{
  if (BlitterMod) { Free(BlitterMod); BlitterMod = NULL; }
}

/************************************************************************************
** Function: BlurArea()
** Short:    Blurs an area of a Bitmap.
** Synopsis: void BlurArea(*Bitmap [a0], WORD X [d0], WORD Y [d1],
**             WORD Width [d2], WORD Height [d3], WORD Setting [d4])
**
** The Setting argument alters how heavy the blurring is.
*/

LIBFUNC void LIBBlurArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD XStart,
                      mreg(__d1) WORD YStart, mreg(__d2) WORD Width,
                      mreg(__d3) WORD Height, mreg(__d4) WORD Setting)
{
  WORD x, y;
  LONG colour;
  LONG R1,R2,R3,R4;
  WORD Red, Green, Blue;

  if (Setting < 1) return;
  if ((Height < 1) OR (Width < 1)) return;

  if (Bitmap) {
     for (y = YStart; y < (YStart + Height); y++) {
        for (x = XStart; x < (XStart + Width); x++) {
           if ((R1 = ReadRGBPixel(Bitmap,x,y-1)) < 0) R1 = NULL;
           if ((R2 = ReadRGBPixel(Bitmap,x,y+1)) < 0) R2 = NULL;
           if ((R3 = ReadRGBPixel(Bitmap,x-1,y)) < 0) R3 = NULL;
           if ((R4 = ReadRGBPixel(Bitmap,x+1,y)) < 0) R4 = NULL;

           /* Calculate the averages */

           Red    = ((R1>>16) + (R2>>16) + (R3>>16) + (R4>>16))/4;
           Green  = ((R1>>8 & 0xff) + (R2>>8 & 0xff) + (R3>>8 & 0xff) + (R4>>8 & 0xff))/4;
           Blue   = ((R1 & 0xff) + (R2 & 0xff) + (R3 & 0xff) + (R4 & 0xff))/4;
           colour = (Red<<16)|(Green<<8)|(Blue);
           DrawRGBPixel(Bitmap,x,y,colour);
        }
     }
  }
  else ErrCode(ERR_ARGS);
}

/************************************************************************************
** Function: ClosestColour()
** Synopsis: LONG ClosestColour(LONG RGB, LONG *Palette)
**
** Returns the colour number in the palette that best matches the given RGB colour.
*/

LIBFUNC LONG LIBClosestColour(mreg(__d0) LONG RGB,
                           mreg(__a0) struct RGBPalette *Palette)
{
  WORD Red, Green, Blue, SrcRed, SrcGreen, SrcBlue, i;
  LONG BestMatch = 0x7fffffff, Match, BestColour = NULL;

  #define HIQUALITY TRUE  /* Affects the speed of the routine - should be in GMSPrefs */

  #ifdef MISSION_CRITICAL
  if (Palette->ID != PALETTE_ARRAY) return(NULL);
  if (Palette->AmtColours <= 0)     return(NULL);
  #endif

  SrcRed   = (RGB & 0x00ff0000)>>16;
  SrcGreen = (RGB & 0x0000ff00)>>8;
  SrcBlue  = (RGB & 0x000000ff);

  for (i=0; i < Palette->AmtColours; i++) {

   #ifndef HIQUALITY

     /* Average quality but fast routine */

     Red = SrcRed - (WORD)(Palette->Col[i].Red);
     if (Red < 0) Red = -Red;

     Green = SrcGreen - (WORD)(Palette->Col[i].Green);
     if (Green < 0) Green = -Green;

     Blue = SrcBlue - (WORD)(Palette->Col[i].Blue);
     if (Blue < 0) Blue = -Blue;

     Match = Red + Green + Blue;

   #else

     /* Good quality but slower routine */

     Red   = SrcRed - (WORD)(Palette->Col[i].Red);
     Green = SrcGreen - (WORD)(Palette->Col[i].Green);
     Blue  = SrcBlue - (WORD)(Palette->Col[i].Blue);
     Match = (Red * Red) + (Green * Green) + (Blue * Blue);

   #endif

     if (Match < BestMatch) {
        BestMatch = Match;
        BestColour = i;
     }
  }

  return(BestColour);
}

/************************************************************************************
** Function: LONG Brightness(LONG RGB)
** Short:    Calculates the brightness of a colour, on a scale of 0 - 255.
**
** This is the original floating point based formula:
**
**   ret = (0.239 * rgb.r) + (0.686 * rgb.g) + (0.075 * rgb.b));
*/

LIBFUNC LONG LIBCalcBrightness(mreg(__d0) LONG RGB)
{
  WORD Red   = (WORD)((RGB>>16) & 0x0000ff);
  WORD Green = (WORD)((RGB>>8) & 0x0000ff);
  WORD Blue  = (WORD)(RGB & 0x0000ff);

  return(((239 * Red) + (686 * Green) + (75 * Blue))/1000);
}

/************************************************************************************
** Function: ConvertHSVToRGB()
** Synopsis: LONG ConvertHSVToRGB(struct HSV *HSV [a0])
*/

LIBFUNC LONG LIBConvertHSVToRGB(mreg(__a0) struct HSV *HSV)
{

  /* Put code in here */

  return(NULL);
}

/************************************************************************************
** Function: ConvertRGBToHSV()
** Synopsis: LONG ConvertRGBToHSV(LONG RGB)
**
** Hue is between 0 and 360.
** Value is between 0 and 100.
** Saturation is between 0 and 100.
*/

LIBFUNC void LIBConvertRGBToHSV(mreg(__d0) LONG rgb, mreg(__a0) struct HSV *HSV)
{
   WORD delta;
   WORD max, min;
   WORD Red   = (WORD)((rgb>>16) & 0x00ff);
   WORD Green = (WORD)((rgb>>8) & 0x00ff);
   WORD Blue  = (WORD)(rgb & 0x00ff);

   max = Blue;
   if (Green > max) max = Green;
   if (Red > max)   max = Red;

   min = Blue;
   if (Green < min) min = Green;
   if (Red < min)   min = Red;

   /*** Calculate Value ***/

   HSV->Val = (max * 100)/255;

   /* Calculate Saturation.  Note that if the Saturation is
   ** NULL then the Hue is also driven to NULL.
   */

   if (max > 0) {
      HSV->Sat = ((max-min)*100)/max;
      if (HSV->Sat IS NULL) {
         HSV->Hue = NULL;
         return;
      }
   }
   else {
      HSV->Sat = NULL;
      HSV->Hue = NULL;
      return;
   }

   /* Note:  The '<<8' is to get rid of the floating point numbers and
   ** keep the calculations integer based.  This causes us to be
   ** slightly innacurate (at most by 1) but we could improve this.
   */

   delta = max - min;
   if (max IS Red) {
      HSV->Hue = ((((Green - Blue)<<8)/delta)*60)>>8;
   }
   else if (max IS Green) {
      HSV->Hue = (((2<<8)+((Blue - Red)<<8)/delta)*60)>>8;
   }
   else {
      HSV->Hue = (((4<<8)+((Red - Green)<<8)/delta)*60)>>8;
   }

   if (HSV->Hue < 0) {
      HSV->Hue += 360;
   }
}

/************************************************************************************
** Function: CopyPalette()
** Synopsis: LONG CopyPalette(LONG *SrcPalette [a0], LONG *DestPalette [a1],
**             LONG ColStart [d0], LONG AmtColors [d1], LONG DestCol [d2])
*/

LIBFUNC LONG LIBCopyPalette(mreg(__a0) LONG argSrcPalette,
                            mreg(__a1) LONG argDestPalette, mreg(__d0) LONG ColStart,
                            mreg(__d1) LONG AmtColours, mreg(__d2) LONG DestCol)
{
  LONG *SrcPalette  = (LONG *)argSrcPalette;
  LONG *DestPalette = (LONG *)argDestPalette;

  if ((SrcPalette IS NULL) OR (DestPalette IS NULL)) {
     DPrintF("!CopyPalette:","Incorrect arguments.");
     return(ERR_ARGS);
  }

  if (AmtColours > (DestPalette[1] - DestCol)) {
     DPrintF("!CopyPalette:","Cannot copy - range too large.");
     return(ERR_FAILED);
  }

  DestCol  += 2;
  ColStart += 2;
  while (AmtColours) {
     DestPalette[DestCol++] = SrcPalette[ColStart++];
     AmtColours--;
  }

  return(ERR_OK);
}

/************************************************************************************
** Function: DarkenArea()
** Synopsis: void DarkenArea(*Bitmap [a0], WORD StartX [d0], WORD StartY [d1],
**             WORD EndX [d2], WORD EndY [d3], WORD Percent [d4])
**
** This function is used to darken a rectangular area on a Bitmap.  The percentage
** range is from light to dark, so 5% will give you a lightly shaded area, while 95%
** will give an extremely dark area.
*/

LIBFUNC void LIBDarkenArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X,
                           mreg(__d1) WORD Y,     mreg(__d2) WORD Height,
                           mreg(__d3) WORD Width, mreg(__d4) WORD Percent)
{
  WORD CurrentX, Red, Green, Blue;
  LONG Colour;
  WORD Value;

  if ((Bitmap IS NULL) OR (Percent < 0) OR (Percent > 100) OR (Bitmap->Head.ID != ID_BITMAP)) {
     DPrintF("!DarkenArea()","Incorrect arguments.");
     return;
  }

  /*** Clip the width and height ***/

  if (X < 0) { Width  += X; X = 0; }
  if (Y < 0) { Height += Y; Y = 0; }

  if ((X + Width) >= Bitmap->Width) {
     Width = Bitmap->Width - X;
  }

  if ((Y + Height) >= Bitmap->Height) {
     Height = Bitmap->Height - Y;
  }

  if ((Height < 1) OR (Width < 1)) return;

  Width += X;

  Value = ((-Percent+100)<<8)/100; /* Value is between 0 and 256 inclusive */

  while (Height > 0) {
     CurrentX = X;
     while (CurrentX < Width) {
        Colour = ReadRGBPixel(Bitmap,CurrentX,Y);
        Red    = (((Colour>>16) & 0x00ff) * Value)>>8;
        Green  = (((Colour>>8) & 0x00ff)  * Value)>>8;
        Blue   = ((Colour & 0x00ff)       * Value)>>8;
        DrawUCRGBPixel(Bitmap,CurrentX,Y,(Red<<16)|(Green<<8)|(Blue));
        CurrentX++;
     }
     Y++;
     Height--;
  }
}

/************************************************************************************
** Function: LightenArea()
** Synopsis: void LightenArea(*Bitmap [a0], WORD X [d0], WORD Y [d1],
**             WORD Width [d2], WORD Height [d3], WORD Percent [d4])
**
** This function is used to lighten a rectangular area on a Bitmap.  The higher the
** percentage, the brighter the area will be.
*/

LIBFUNC void LIBLightenArea(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X,
                            mreg(__d1) WORD Y,      mreg(__d2) WORD Width,
                            mreg(__d3) WORD Height, mreg(__d4) WORD Percent)
{
  WORD CurrentX, Red, Green, Blue;
  LONG Colour;
  WORD Value;

  if ((Bitmap IS NULL) OR (Percent < 0) OR (Percent > 100) OR (Bitmap->Head.ID != ID_BITMAP)) {
     DPrintF("!LightenArea()","Incorrect arguments.");
     return;
  }

  /*** Clip the width and height ***/

  if (X < 0) { Width  += X; X = 0; }
  if (Y < 0) { Height += Y; Y = 0; }

  if ((X + Width) >= Bitmap->Width) {
     Width = Bitmap->Width - X;
  }

  if ((Y + Height) >= Bitmap->Height) {
     Height = Bitmap->Height - Y;
  }

  if ((Height < 1) OR (Width < 1)) return;

  Width += X;

  Value = (Percent<<8)/100; /* Value is between 0 and 256 inclusive */

  while (Height > 0) {
     CurrentX = X;
     while (CurrentX < Width) {
        Colour = ReadRGBPixel(Bitmap,CurrentX,Y);
        Red    = (Colour>>16) & 0x00ff;  Red   += ((255-Red)*Value)>>8;
        Green  = (Colour>>8)  & 0x00ff;  Green += ((255-Green)*Value)>>8;
        Blue   = (Colour)     & 0x00ff;  Blue  += ((255-Blue)*Value)>>8;
        DrawUCRGBPixel(Bitmap,CurrentX,Y,(Red<<16)|(Green<<8)|(Blue));
        CurrentX++;
     }
     Y++;
     Height--;
  }
}

/************************************************************************************
** Function: DarkenPixel()
** Synopsis: void DarkenPixel(*Bitmap [a0], WORD X [d0], WORD Y [d1], WORD Percent [d2])
** Short:    Darkens a pixel by the specified value.
*/

LIBFUNC void LIBDarkenPixel(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X,
                            mreg(__d1) WORD Y, mreg(__d2) WORD Percent)
{
  LONG Red, Green, Blue;
  LONG Colour;
  WORD Value;

  if (Bitmap IS NULL) return;
  #ifdef MISSION_CRITICAL
  if ((Percent < 0) OR (Percent > 100) OR (Bitmap->Head.ID != ID_BITMAP)) return;
  #endif

  Value  = ((-Percent+100)<<8)/100; /* Value is between 0 and 256 inclusive */
  Colour = ReadRGBPixel(Bitmap,X,Y);
  Red    = (((BYTE)(Colour>>16) * Value)<<8) & 0x00ff0000;
  Green  = ((BYTE)(Colour>>8) * Value) & 0x0000ff00;
  Blue   = ((BYTE)Colour * Value)>>8;
  DrawRGBPixel(Bitmap,X,Y,(Red)|(Green)|(Blue));
}

/************************************************************************************
** Function: LightenPixel()
** Synopsis: void LightenPixel(*Bitmap [a0], WORD X [d0], WORD Y [d1], WORD Percent [d2])
** Short:    Lightens a pixel by the specified value.
**
*/

LIBFUNC void LIBLightenPixel(mreg(__a0) struct Bitmap *Bitmap, mreg(__d0) WORD X,
                             mreg(__d1) WORD Y, mreg(__d2) WORD Percent)
{
  WORD Red, Green, Blue;
  LONG Colour;
  WORD Value;

  if (Bitmap IS NULL) return;
  #ifdef MISSION_CRITICAL
  if ((Percent < 0) OR (Percent > 100) OR (Bitmap->Head.ID != ID_BITMAP)) return;
  #endif

  Value  = (Percent<<8)/100; /* Value is between 0 and 256 inclusive */
  Colour = ReadRGBPixel(Bitmap,X,Y);
  Red    = (Colour>>16) & 0x00ff;  Red   += ((255-Red)*Value)>>8;
  Green  = (Colour>>8)  & 0x00ff;  Green += ((255-Green)*Value)>>8;
  Blue   = (Colour)     & 0x00ff;  Blue  += ((255-Blue)*Value)>>8;
  DrawRGBPixel(Bitmap,X,Y,(Red<<16)|(Green<<8)|(Blue));
}

/************************************************************************************
** Function: RemapBitmap()
** Synopsis: LONG RemapBitmap(*SrcBitmap [a0], *DestBitmap [a1],
**             WORD Performance [d0])
**
** You can use this function to remap the colours of a Bitmap to a new set of
** colour values.
** 
** INPUTS
** SrcBitmap
**   The Bitmap that is acting as the source.
**
** DestBitmap
**   The Bitmap that will receive the remapped data.
**
** Performance
**   This is a performance rating from 0 - 100%.  If you specify 50% you will
**   get a straight remap to the destination.  A setting of 100% would enable
**   anti-aliasing and smoothing facilities, at a cost of being a lot slower.
**
** RESULT
** Returns ERR_OK if successful.
*/

LIBFUNC LONG LIBRemapBitmap(mreg(__a0) LONG argSource, mreg(__a1) LONG argDest,
                            mreg(__d0) WORD Performance)
{
  struct Bitmap *Src  = (struct Bitmap *)argSource;
  struct Bitmap *Dest = (struct Bitmap *)argDest;
  WORD MaxWidth, y, MaxHeight;

  DPrintF("RemapBitmap()","Source: $%x,  Dest: $%x", Src, Dest);

  /*** Validate arguments ***/

  if ((Src IS NULL) OR (Dest IS NULL) OR (Src IS Dest)) {
     return(ErrCode(ERR_ARGS));
  }

  /*** Get the maximum width and height ***/

  if (Src->Width < Dest->Width) {
     MaxWidth = Src->Width;
  }
  else {
     MaxWidth = Dest->Width;
  }

  if (Src->Height < Dest->Height) {
     MaxHeight = Src->Height;
  }
  else {
     MaxHeight = Dest->Height;
  }

  /*** Remapping process ***/

  for (y=0; y < MaxHeight; y++) {
     CopyLine(Src,Dest,y,y,MaxWidth,1); /* Easy remap! */

     /*** Clear off any trailing pixels if DestWidth > SrcWidth ***/

     if (MaxWidth < Dest->Width) {
        DrawLine(Dest,MaxWidth,y,Dest->Width-1,y,0,0xffffffff);
     }
  }

  /*** Clear off any trailing pixels from the bottom ***/

  if (Dest->Height > Src->Height) {
     for (y=y; y < Dest->Height; y++) {
        DrawLine(Dest,0,y,Dest->Width-1,y,0,0);
     }
  }

  return(ERR_OK);
}

