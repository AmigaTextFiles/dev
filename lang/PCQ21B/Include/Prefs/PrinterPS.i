 {      File format for PostScript printer preferences   }


{$I "Include:Libraries/IffParse.i"}


const
 ID_PSPD = 1347637316;

Type
 PrinterPSPrefs = Record
    ps_Reserved     : Array[0..3] of Integer;               { System reserved }

    { Global printing attributes }
    ps_DriverMode,
    ps_PaperFormat  : Byte;
    ps_Reserved1    : Array[0..1] of Byte;
    ps_Copies,
    ps_PaperWidth,
    ps_PaperHeight,
    ps_HorizontalDPI,
    ps_VerticalDPI  : Integer;

    { Text Options }
    ps_Font,
    ps_Pitch,
    ps_Orientation,
    ps_Tab          : Byte;
    ps_Reserved2    : Array[0..7] of Byte;

    { Text Dimensions }
    ps_LeftMargin,
    ps_RightMargin,
    ps_TopMargin,
    ps_BottomMargin,
    ps_FontPointSize,
    ps_Leading      : Integer;
    ps_Reserved3    : Array[0..7] of Byte;

    { Graphics Options }
    ps_LeftEdge,
    ps_TopEdge,
    ps_Width,
    ps_Height       : Integer;
    ps_Image,
    ps_Shading,
    ps_Dithering    : Byte;
    ps_Reserved4    : Array[0..8] of Byte;

    { Graphics Scaling }
    ps_Aspect,
    ps_ScalingType,
    ps_Reserved5,
    ps_Centering    : Byte;
    ps_Reserved6    : Array[0..7] of byte;
 end;
 PrinterPSPrefsPtr = ^PrinterPSPrefs;

const
{ All measurements are in Millipoints which is 1/1000 of a point, or
 * in other words 1/72000 of an inch
 }

{ constants for PrinterPSPrefs.ps_DriverMode }
 DM_POSTSCRIPT  = 0;
 DM_PASSTHROUGH = 1;

{ constants for PrinterPSPrefs.ps_PaperFormat }
 PF_USLETTER = 0;
 PF_USLEGAL  = 1;
 PF_A4       = 2;
 PF_CUSTOM   = 3;

{ constants for PrinterPSPrefs.ps_Font }
 FONT_COURIER      = 0;
 FONT_TIMES        = 1;
 FONT_HELVETICA    = 2;
 FONT_HELV_NARROW  = 3;
 FONT_AVANTGARDE   = 4;
 FONT_BOOKMAN      = 5;
 FONT_NEWCENT      = 6;
 FONT_PALATINO     = 7;
 FONT_ZAPFCHANCERY = 8;

{ constants for PrinterPSPrefs.ps_Pitch }
 PITCH_NORMAL     = 0;
 PITCH_COMPRESSED = 1;
 PITCH_EXPANDED   = 2;

{ constants for PrinterPSPrefs.ps_Orientation }
 ORIENT_PORTRAIT  = 0;
 ORIENT_LANDSCAPE = 1;

{ constants for PrinterPSPrefs.ps_Tab }
 TAB_4     = 0;
 TAB_8     = 1;
 TAB_QUART = 2;
 TAB_HALF  = 3;
 TAB_INCH  = 4;

{ constants for PrinterPSPrefs.ps_Image }
 IM_POSITIVE = 0;
 IM_NEGATIVE = 1;

{ constants for PrinterPSPrefs.ps_Shading }
 SHAD_BW        = 0;
 SHAD_GREYSCALE = 1;
 SHAD_COLOR     = 2;

{ constants for PrinterPSPrefs.ps_Dithering }
 DITH_DEFAULT = 0;
 DITH_DOTTY   = 1;
 DITH_VERT    = 2;
 DITH_HORIZ   = 3;
 DITH_DIAG    = 4;

{ constants for PrinterPSPrefs.ps_Aspect }
 ASP_HORIZ = 0;
 ASP_VERT  = 1;

{ constants for PrinterPSPrefs.ps_ScalingType }
 ST_ASPECT_ASIS    = 0;
 ST_ASPECT_WIDE    = 1;
 ST_ASPECT_TALL    = 2;
 ST_ASPECT_BOTH    = 3;
 ST_FITS_WIDE      = 4;
 ST_FITS_TALL      = 5;
 ST_FITS_BOTH      = 6;

{ constants for PrinterPSPrefs.ps_Centering }
 CENT_NONE  = 0;
 CENT_HORIZ = 1;
 CENT_VERT  = 2;
 CENT_BOTH  = 3;


