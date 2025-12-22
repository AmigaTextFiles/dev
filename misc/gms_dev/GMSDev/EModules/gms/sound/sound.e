
/*
**  $VER: sound.e
**
**  Sound definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** Sound Object.
*/

CONST VER_SOUND  = 1,
      TAGS_SOUND = $FFFB0000 OR ID_SOUND

OBJECT sound
  head[1]   :ARRAY OF head  /* Standard structure header */
  emp       :INT            /* */
  priority  :INT            /* Priority */
  data      :PTR TO CHAR    /* Address of sample data */
  length    :LONG           /* Length of sample data in bytes */
  octave    :INT            /* Octave/Note setting */
  volume    :INT            /* Volume of sample (0 - 100) */
  attrib    :LONG           /* Sound attributes */
  source    :LONG           /* File for the sound, if required */
  frequency :LONG           /* Frequency of sampled sound */       
  pair      :PTR TO sound   /* Pair a sound for modulation */
ENDOBJECT

CONST SA_Priority  = 14 OR TWORD,
      SA_Data      = 16 OR TAPTR,
      SA_Length    = 20 OR TLONG,
      SA_Octave    = 24 OR TWORD,
      SA_Volume    = 26 OR TWORD,
      SA_Attrib    = 28 OR TAPTR,
      SA_Source    = 32 OR TAPTR,
      SA_Frequency = 36 OR TLONG,
      SA_Pair      = 40 OR TAPTR

/*** Flags for Attrib ***/

CONST SDF_MODVOL   = $00000002,  /* Modulate volume with next channel */ 
      SDF_MODPER   = $00000004,  /* Modulate period with next channel  */
      SDF_REPEAT   = $00000008,  /* Repeat sample forever */
      SDF_EMPTY    = $00000010,  /* Play only if channel is empty */
      SDF_LEFT     = $00000020,  /* Left speaker preferred */
      SDF_RIGHT    = $00000040,  /* Right speaker preferred */
      SDF_FORCE    = $00000080,  /* Enforce use of selected speaker */
      SDF_STOPLAST = $00000100   /* Play sound only on given channel */

/*****************************************************************************
** Octave definitions for Sound->Octave.  An 'S' at the end of an octave
** definition indicates a sharp note.
*/

CONST OCT_G0S = 0,
 OCT_G0  = 2,
 OCT_F0S = 4,
 OCT_F0  = 6,
 OCT_E0  = 8,
 OCT_D0S = 10,
 OCT_D0  = 12,
 OCT_C0S = 14,
 OCT_C0  = 16,
 OCT_B0  = 18,
 OCT_A0S = 20,
 OCT_A0  = 22,

 OCT_G1S = 24,
 OCT_G1  = 26,
 OCT_F1S = 28,
 OCT_F1  = 30,
 OCT_E1  = 32,
 OCT_D1S = 34,
 OCT_D1  = 36,
 OCT_C1S = 38,
 OCT_C1  = 40,
 OCT_B1  = 42,
 OCT_A1S = 44,
 OCT_A1  = 46,

 OCT_G2S = 48,
 OCT_G2  = 50,
 OCT_F2S = 52,
 OCT_F2  = 54,
 OCT_E2  = 56,
 OCT_D2S = 58,
 OCT_D2  = 60,
 OCT_C2S = 62,
 OCT_C2  = 64,
 OCT_B2  = 66,
 OCT_A2S = 68,
 OCT_A2  = 70,

 OCT_G3S = 72,
 OCT_G3  = 74,
 OCT_F3S = 76,
 OCT_F3  = 78,
 OCT_E3  = 80,
 OCT_D3S = 82,
 OCT_D3  = 84,
 OCT_C3S = 86,
 OCT_C3  = 88,
 OCT_B3  = 90,
 OCT_A3S = 92,
 OCT_A3  = 94,

 OCT_G4S = 96,
 OCT_G4  = 98,
 OCT_F4S = 100,
 OCT_F4  = 102,
 OCT_E4  = 104,
 OCT_D4S = 106,
 OCT_D4  = 108,
 OCT_C4S = 110,
 OCT_C4  = 112,
 OCT_B4  = 114,
 OCT_A4S = 116,
 OCT_A4  = 118,

 OCT_G5S = 120,
 OCT_G5  = 122,
 OCT_F5S = 124,
 OCT_F5  = 126,
 OCT_E5  = 128,
 OCT_D5S = 130,
 OCT_D5  = 132,
 OCT_C5S = 134,
 OCT_C5  = 136,
 OCT_B5  = 138,
 OCT_A5S = 140,
 OCT_A5  = 142,

 OCT_G6S = 144,
 OCT_G6  = 146,
 OCT_F6S = 148,
 OCT_F6  = 150,
 OCT_E6  = 152,
 OCT_D6S = 154,
 OCT_D6  = 156,
 OCT_C6S = 158,
 OCT_C6  = 160,
 OCT_B6  = 162,
 OCT_A6S = 164,
 OCT_A6  = 166,

 OCT_G7S = 168,
 OCT_G7  = 170,
 OCT_F7S = 172,
 OCT_F7  = 174,
 OCT_E7  = 176,
 OCT_D7S = 178,
 OCT_D7  = 180,
 OCT_C7S = 182,
 OCT_C7  = 184,
 OCT_B7  = 186,
 OCT_A7S = 188

