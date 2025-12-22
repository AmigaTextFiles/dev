	IFND SOUND_MUSIC_I
SOUND_MUSIC_I  SET  1

**
**	$VER: music.i
**
**	Music Definitions.
**
**	(C) Copyright 1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************
* Module definitions.

Music_ModVersion  = 1
Music_ModRevision = 0

*****************************************************************************
* Music object.

VER_MUSIC  =	1
TAGS_MUSIC =	(ID_SPCTAGS<<16)|ID_MUSIC

   STRUCTURE	MUS,HEAD_SIZEOF
	APTR	MUS_Source        ;12 [RI] Filename/location of module.
	LONG	MUS_Flags         ;16 [RI] Special flags.
	APTR	MUS_Title         ;20 [RI] Title of the music.
	APTR	MUS_Artist        ;24 [RI] Who wrote the music.
	WORD	MUS_Tempo         ;28 [RI] Speed between 0 and 100.
	WORD	MUS_Volume        ;30 [RI] Overall volume of music (0 - 100)
	WORD	MUS_Priority      ;32 [RI] Priority over sounds (-100 to +100)
	WORD	MUS_Position      ;34 [R-] Current position of the module.
	APTR	MUS_Channels      ;36 [R-] Channel states.
	APTR	MUS_prvData       ;40 [--] Pointer to loaded data */
	WORD	MUS_TotalChannels ;44 [R-] Total available channels */

MSF_LOOP = $00000001            ;Restart module when finished.

* Music Tags.

MSA_Source   = (TAPTR|MUS_Source)
MSA_Flags    = (TLONG|MUS_Flags)
MSA_Title    = (TAPTR|MUS_Title)
MSA_Artist   = (TAPTR|MUS_Artist)
MSA_Tempo    = (TWORD|MUS_Tempo)
MSA_Volume   = (TWORD|MUS_Volume)
MSA_Priority = (TWORD|MUS_Priority)

*****************************************************************************
* Jukebox object.

VER_JUKEBOX  = 1
TAGS_JUKEBOX = ((ID_SPCTAGS<<16)|ID_JUKEBOX)

   STRUCTURE	JB,HEAD_SIZEOF
	APTR	JB_Music     ;12 [R-] Chain of music objects (tracks).
	LONG	JB_Track     ;16 [R-] The musical track that we are playing.
	APTR	JB_Source    ;20 [RI] Source of juke-box information.

JBA_Source = (TAPTR|JB_Source)

  ENDC	;SOUND_MUSIC_I
