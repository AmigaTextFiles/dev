 {     File format for font preferences   }


{$I "Include:Libraries/IffParse.i"}
{$I "Include:Graphics/Text.i"}

{***************************************************************************}

const
 ID_FONT = 1179602516;


 FONTNAMESIZE = 128;

type
 FontPrefs = Record
    fp_Reserved     : Array[0..2] of Integer;
    fp_Reserved2    : WORD;
    fp_Type         : WORD;
    fp_FrontPen,
    fp_BackPen,
    fp_DrawMode     : Byte;
    fp_TextAttr     : TextAttr;
    fp_Name         : Array[0..FONTNAMESIZE-1] of Char;
 end;
 FontPrefsPtr = ^FontPrefs;

const
{ constants for FontPrefs.fp_Type }
 FP_WBFONT     = 0;
 FP_SYSFONT    = 1;
 FP_SCREENFONT = 2;


{***************************************************************************}


