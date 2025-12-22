    {   File format for sound preferences  }

{$I "Include:Libraries/IffParse.i"}

const
 ID_SOND = 1397706308;

Type
 SoundPrefs = Record
    sop_Reserved        : Array[0..3] of Integer;            { System reserved            }
    sop_DisplayQueue,               { Flash the display?         }
    sop_AudioQueue      : Boolean;  { Make some sound?           }
    sop_AudioType,                  { Type of sound, see below   }
    sop_AudioVolume,                { Volume of sound, 0..64     }
    sop_AudioPeriod,                { Period of sound, 127..2500 }
    sop_AudioDuration   : WORD;     { Length of simple beep      }
    sop_AudioFileName   : Array[0..255] of Char;     { Filename of 8SVX file      }
 end;
 SoundPrefsPtr = ^SoundPrefs;

const
{ constants for SoundPrefs.sop_AudioType }
 SPTYPE_BEEP    = 0;       { simple beep sound }
 SPTYPE_SAMPLE  = 1;       { sampled sound     }


