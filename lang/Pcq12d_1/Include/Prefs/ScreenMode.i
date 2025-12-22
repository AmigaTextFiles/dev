  {     File format for screen mode preferences }


{$I "Include:Libraries/IffParse.i"}

const
 ID_SCRM = 1396920909;


Type
 ScreenModePrefs = Record
    smp_Reserved        : Array[0..3] of Integer;
    smp_DisplayID       : Integer;
    smp_Width,
    smp_Height,
    smp_Depth,
    smp_Control         : Word;
 end;
 ScreenModePrefsPtr = ^ScreenModePrefsPtr;

const
{ flags for ScreenModePrefs.smp_Control }
 SMB_AUTOSCROLL = 1;

 SMF_AUTOSCROLL = 1;


