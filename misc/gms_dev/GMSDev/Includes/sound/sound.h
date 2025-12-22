#ifndef SOUND_SOUND_H
#define SOUND_SOUND_H TRUE

/*
**    $VER: sound.h
**
**    Sound definitions.
**
**    (C) Copyright 1996-1998 DreamWorld Productions.
**        All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************/

#define SND_ModVersion  1
#define SND_ModRevision 4

/*****************************************************************************
** Sound object.
*/

#define VER_SOUND  1
#define TAGS_SOUND ((ID_SPCTAGS<<16)|ID_SOUND)

typedef struct Sound {
  struct Head Head;    /* [00] Standard structure header */
  WORD   emp;          /* [12] */
  WORD   Priority;     /* [14] Priority */
  APTR   Data;         /* [16] Address of sample data */
  LONG   Length;       /* [20] Length of sample data in bytes */
  WORD   Octave;       /* [24] Octave/Note setting */
  WORD   Volume;       /* [26] Volume of sample (0 - 100) */
  LONG   Attrib;       /* [28] Sound attributes */
  APTR   Source;       /* [32] File for the sound, if required */
  LONG   Frequency;    /* [36] Frequency of sampled sound */
  struct Sound *Pair;  /* [40] Pair a sound for modulation */

  /*** Private fields below ***/

  APTR   prvHeader;      /* Ptr to sample info header, if any */
  BYTE   prvAFlags;      /* Allocation flags */
  BYTE   prvPad;         /* Private */
  WORD   prvLastChannel; /* Last channel to play through */
} OBJ_SOUND;

#define SA_Priority  (14|TWORD)
#define SA_Data      (16|TAPTR)
#define SA_Length    (20|TLONG)
#define SA_Octave    (24|TWORD)
#define SA_Volume    (26|TWORD)
#define SA_Attrib    (28|TAPTR)
#define SA_Source    (32|TAPTR)
#define SA_Frequency (36|TLONG)
#define SA_Pair      (40|TAPTR)

/*** Flags for Attrib ***/

/*#define SDF_BIT16  0x00000001       Sound data is 16 bit (otherwise it's 8) */
#define SDF_MODVOL   0x00000002    /* Modulate volume with next channel */
#define SDF_MODPER   0x00000004    /* Modulate period with next channel */
#define SDF_REPEAT   0x00000008    /* Repeat sample forever */
#define SDF_EMPTY    0x00000010    /* Only play sound if channel is empty */
#define SDF_LEFT     0x00000020    /* Left speaker preferred */
#define SDF_RIGHT    0x00000040    /* Right speaker preferred */
#define SDF_FORCE    0x00000080    /* Enforce use of selected speaker */
#define SDF_STOPLAST 0x00000100    /* Play sound only on given channel */

/*****************************************************************************
** Octave definitions for Sound->Octave.  An 'S' at the end of an octave
** definition indicates a sharp note.
*/

#define OCT_G0S  0
#define OCT_G0   2
#define OCT_F0S  4
#define OCT_F0   6
#define OCT_E0   8
#define OCT_D0S 10
#define OCT_D0  12
#define OCT_C0S 14
#define OCT_C0  16
#define OCT_B0  18
#define OCT_A0S 20
#define OCT_A0  22

#define OCT_G1S 24
#define OCT_G1  26
#define OCT_F1S 28
#define OCT_F1  30
#define OCT_E1  32
#define OCT_D1S 34
#define OCT_D1  36
#define OCT_C1S 38
#define OCT_C1  40
#define OCT_B1  42
#define OCT_A1S 44
#define OCT_A1  46

#define OCT_G2S 48
#define OCT_G2  50
#define OCT_F2S 52
#define OCT_F2  54
#define OCT_E2  56
#define OCT_D2S 58
#define OCT_D2  60
#define OCT_C2S 62
#define OCT_C2  64
#define OCT_B2  66
#define OCT_A2S 68
#define OCT_A2  70

#define OCT_G3S 72
#define OCT_G3  74
#define OCT_F3S 76
#define OCT_F3  78
#define OCT_E3  80
#define OCT_D3S 82
#define OCT_D3  84
#define OCT_C3S 86
#define OCT_C3  88
#define OCT_B3  90
#define OCT_A3S 92
#define OCT_A3  94

#define OCT_G4S 96
#define OCT_G4  98
#define OCT_F4S 100
#define OCT_F4  102
#define OCT_E4  104
#define OCT_D4S 106
#define OCT_D4  108
#define OCT_C4S 110
#define OCT_C4  112
#define OCT_B4  114
#define OCT_A4S 116
#define OCT_A4  118

#define OCT_G5S 120
#define OCT_G5  122
#define OCT_F5S 124
#define OCT_F5  126
#define OCT_E5  128
#define OCT_D5S 130
#define OCT_D5  132
#define OCT_C5S 134
#define OCT_C5  136
#define OCT_B5  138
#define OCT_A5S 140
#define OCT_A5  142

#define OCT_G6S 144
#define OCT_G6  146
#define OCT_F6S 148
#define OCT_F6  150
#define OCT_E6  152
#define OCT_D6S 154
#define OCT_D6  156
#define OCT_C6S 158
#define OCT_C6  160
#define OCT_B6  162
#define OCT_A6S 164
#define OCT_A6  166

#define OCT_G7S 168
#define OCT_G7  170
#define OCT_F7S 172
#define OCT_F7  174
#define OCT_E7  176
#define OCT_D7S 178
#define OCT_D7  180
#define OCT_C7S 182
#define OCT_C7  184
#define OCT_B7  186
#define OCT_A7S 188

#endif /* SOUND_SOUND_H */
