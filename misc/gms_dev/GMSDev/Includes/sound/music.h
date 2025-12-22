#ifndef SOUND_MUSIC_H
#define SOUND_MUSIC_H

/*
**    $VER: music.h
**
**    Music definitions.
**
**    (C) Copyright 1998 DreamWorld Productions.
**        All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#define VER_MusicModule 1
#define REV_MusicModule 0

/*****************************************************************************
** Music object.
*/

#define VER_MUSIC  1
#define TAGS_MUSIC ((ID_SPCTAGS<<16)|ID_MUSIC)

typedef struct Music {
  struct Head Head;     /* 00 [--] System header */
  APTR   Source;        /* 12 [RI] Filename/location of module */
  LONG   Flags;         /* 16 [RI] Special flags */
  BYTE   *Title;        /* 20 [RI] Title of the music */
  BYTE   *Artist;       /* 24 [RI] Who wrote the music */
  WORD   Tempo;         /* 28 [RI] Speed between 0 and 100 */
  WORD   Volume;        /* 30 [RI] Overall volume of music (0-100) */
  WORD   Priority;      /* 32 [RI] Priority over sound effects -100 to +100 */
  WORD   Position;      /* 34 [-W] Current position of the module */
  BYTE   *Channels;     /* 36 [R-] Channels on/off */
  BYTE   *prvData;      /* 40 [--] Pointer to loaded data */
  WORD   TotalChannels; /* 44 [R-] Total available channels */
} OBJ_MUSIC;

#define MSF_LOOP 0x00000001    /* Restart module at end */

/*****************************************************************************
** Music tags.
*/

#define MSA_Source   (TAPTR|12)
#define MSA_Flags    (TLONG|16)
#define MSA_Title    (TAPTR|20)
#define MSA_Artist   (TAPTR|24)
#define MSA_Tempo    (TWORD|28)
#define MSA_Volume   (TWORD|30)
#define MSA_Priority (TWORD|32)

/*****************************************************************************
** Jukebox object.
*/

#define VER_JUKEBOX  1
#define TAGS_JUKEBOX ((ID_SPCTAGS<<16)|ID_JUKEBOX)

typedef struct JukeBox {
  struct Head Head;      /* 00 [--] Standard header */
  struct Chain *Music;   /* 12 [R-] Chain of music objects (tracks) */
  LONG   Track;          /* 16 [R-] The musical track that we are playing */
  APTR   Source;         /* 20 [RI] Source of juke-box information */
} OBJ_JUKEBOX;

#define JBA_Source (TAPTR|20)

#endif /* SOUND_MUSIC_H */
