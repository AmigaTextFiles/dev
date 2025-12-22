 { Only V39+ }

 {  Interface definitions for DataType picture objects.  }

{$I "Include:Utility/TagItem.i"}
{$I "Include:DataTypes/DataTypesClass.i"}
{$I "Include:Libraries/IFFParse.i"}

const
{***************************************************************************}

   PICTUREDTCLASS        =  "picture.datatype";

{***************************************************************************}

{ Picture attributes }
   PDTA_ModeID           =  (DTA_Dummy + 200);
        { Mode ID of the picture }

   PDTA_BitMapHeader     =  (DTA_Dummy + 201);

   PDTA_BitMap           =  (DTA_Dummy + 202);
        { Pointer to a class-allocated bitmap, that will end
         * up being freed by picture.class when DisposeDTObject()
         * is called }

   PDTA_ColorRegisters   =  (DTA_Dummy + 203);
   PDTA_CRegs            =  (DTA_Dummy + 204);
   PDTA_GRegs            =  (DTA_Dummy + 205);
   PDTA_ColorTable       =  (DTA_Dummy + 206);
   PDTA_ColorTable2      =  (DTA_Dummy + 207);
   PDTA_Allocated        =  (DTA_Dummy + 208);
   PDTA_NumColors        =  (DTA_Dummy + 209);
   PDTA_NumAlloc         =  (DTA_Dummy + 210);

   PDTA_Remap            =  (DTA_Dummy + 211);
        { Boolean : Remap picture (defaults to TRUE) }

   PDTA_Screen           =  (DTA_Dummy + 212);
        { Screen to remap to }

   PDTA_FreeSourceBitMap =  (DTA_Dummy + 213);
        { Boolean : Free the source bitmap after remapping }

   PDTA_Grab             =  (DTA_Dummy + 214);
        { Pointer to a Point structure }

   PDTA_DestBitMap       =  (DTA_Dummy + 215);
        { Pointer to the destination (remapped) bitmap }

   PDTA_ClassBitMap      =  (DTA_Dummy + 216);
        { Pointer to class-allocated bitmap, that will end
         * up being freed by the class after DisposeDTObject()
         * is called }

   PDTA_NumSparse        =  (DTA_Dummy + 217);
        { (UWORD) Number of colors used for sparse remapping }

   PDTA_SparseTable      =  (DTA_Dummy + 218);
        { (UBYTE *) Pointer to a table of pen numbers indicating
         * which colors should be used when remapping the image.
         * This array must contain as many entries as there
         * are colors specified with PDTA_NumSparse }

{***************************************************************************}

{  Masking techniques  }
   mskNone                = 0;
   mskHasMask             = 1;
   mskHasTransparentColor = 2;
   mskLasso               = 3;
   mskHasAlpha            = 4;

{  Compression techniques  }
   cmpNone                = 0;
   cmpByteRun1            = 1;
   cmpByteRun2            = 2;

Type
{  Bitmap header (BMHD) structure  }
 BitMapHeader = Record
    bmh_Width,                         { Width in pixels }
    bmh_Height,                        { Height in pixels }
    bmh_Left,                          { Left position }
    bmh_Top      : WORD;               { Top position }
    bmh_Depth,                         { Number of planes }
    bmh_Masking,                       { Masking type }
    bmh_Compression,                   { Compression type }
    bmh_Pad      : Byte;
    bmh_Transparent : WORD;            { Transparent color }
    bmh_XAspect,
    bmh_YAspect     : Byte;
    bmh_PageWidth,
    bmh_PageHeight  : WORD;
 end;
 BitMapHeaderPtr = ^BitMapHeader;

{***************************************************************************}

{  Color register structure }
 ColorRegister = Record
   red, green, blue : Byte;
 end;
 ColorRegisterPtr = ^ColorRegister;

{***************************************************************************}

const
{ IFF types that may be in pictures }
   ID_ILBM         = 1229734477;
   ID_BMHD         = 1112361028;
   ID_BODY         = 1112491097;
   ID_CMAP         = 1129136464;
   ID_CRNG         = 1129467463;
   ID_GRAB         = 1196572994;
   ID_SPRT         = 1397772884;
   ID_DEST         = 1145394004;
   ID_CAMG         = 1128353095;

