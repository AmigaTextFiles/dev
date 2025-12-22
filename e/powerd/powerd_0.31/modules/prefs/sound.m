MODULE 'libraries/iffparse'

CONST ID_SOND=$534F4E44,
 SPTYPE_BEEP=0,
 SPTYPE_SAMPLE=1

OBJECT SoundPrefs
  Reserved[4]:LONG,
  DisplayQueue:BOOL,
  AudioQueue:BOOL,
  AudioType:UWORD,
  AudioVolume:UWORD,
  AudioPeriod:UWORD,
  AudioDuration:UWORD,
  AudioFileName[256]:UBYTE
