
/*
**    $VER: music.e
**
**    Music definitions.
**
**    (C) Copyright 1998 DreamWorld Productions.
**        All Rights Reserved.
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

CONST VER_MusicModule = 1,
      REV_MusicModule = 0

/*****************************************************************************
** Music object.
*/

CONST VER_MUSIC  = 1,
      TAGS_MUSIC = $FFFB0000 OR ID_MUSIC

OBJECT music
  head[1]       :ARRAY OF head /* 00 [--] System header */
  source        :LONG          /* 12 [RI] Filename/location of module */
  flags         :LONG          /* 16 [RI] Special flags */
  title         :PTR TO CHAR   /* 20 [RI] Title of the music */
  artist        :PTR TO CHAR   /* 24 [RI] Who wrote the music */
  tempo         :INT           /* 28 [RI] Speed between 0 and 100 */
  volume        :INT           /* 30 [RI] Overall volume of music (0-100) */
  priority      :INT           /* 32 [RI] Priority over sound effects -100 to +100 */
  position      :INT           /* 34 [-W] Current position of the module */
  channels      :PTR TO CHAR   /* 36 [R-] Channels on/off */
  prvdata       :PTR TO CHAR   /* 40 [--] Pointer to loaded data */
  totalchannels :INT           /* 44 [R-] Total available channels */
ENDOBJECT

CONST MSF_LOOP = $00000001    /* Restart module at end */

/*****************************************************************************
** Music tags.
*/

CONST MSA_Source   = TAPTR OR 12,
      MSA_Flags    = TLONG OR 16,
      MSA_Title    = TAPTR OR 20,
      MSA_Artist   = TAPTR OR 24,
      MSA_Tempo    = TWORD OR 28,
      MSA_Volume   = TWORD OR 30,
      MSA_Priority = TWORD OR 32

/*****************************************************************************
** Jukebox object.
*/

CONST VER_JUKEBOX  = 1,
      TAGS_JUKEBOX = $FFFB0000 OR ID_JUKEBOX

OBJECT jukebox
  head[1] :ARRAY OF head /* 00 [--] Standard header */
  music   :LONG          /* 12 [R-] Chain of music objects (tracks) */
  track   :LONG          /* 16 [R-] The musical track that we are playing */
  source  :LONG          /* 20 [RI] Source of juke-box information */
ENDOBJECT

CONST JBA_Source = TAPTR OR 20

