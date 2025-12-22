 {      File format for pointer preferences }


{$I "Include:Libraries/IffParse.i"}


const
      ID_PNTR = 1347310674;


Type
 PointerPrefs = Record
    pp_Reserved : Array[0..3] of Integer;
    pp_Which,                             { 0=NORMAL, 1=BUSY }
    pp_Size,                              { see <intuition/pointerclass.h> }
    pp_Width,                             { Width in pixels }
    pp_Height,                            { Height in pixels }
    pp_Depth,                             { Depth }
    pp_YSize,                             { YSize }
    pp_X, pp_Y  : WORD;                   { Hotspot }

    { Color Table:  numEntries = (1 << pp_Depth) - 1 }

    { Data follows }
 end;
 PointerPrefsPtr = ^PointerPrefs;

{***************************************************************************}

Const
{ constants for PointerPrefs.pp_Which }
 WBP_NORMAL    =  0;
 WBP_BUSY      =  1;

{***************************************************************************}

Type
 RGBTable = Record
    t_Red,
    t_Green,
    t_Blue  : Byte;
 end;

{***************************************************************************}

