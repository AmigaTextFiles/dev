  {      File format for input preferences     }


{$I "Include:libraries/IffParse.i"}
{$I "Include:Devices/Timer.i"}

const
 ID_INPT = 1229869140;

Type
 InputPrefs = Record
    ip_Keymap      : Array[0..15] of Char;
    ip_PointerTicks : WORD;
    ip_DoubleClick,
    ip_KeyRptDelay,
    ip_KeyRptSpeed : TimeVal;
    ip_MouseAccel  : WORD;
 end;
 InputPrefsPtr = ^InputPrefs;


