#ifndef  CLIB_SOUND_PROTOS_H
#define  CLIB_SOUND_PROTOS_H

/*
**   $VER: sound_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

APTR AllocSoundMem(LONG Size, LONG Flags);
LONG CheckSound(struct Sound *);
void FreeSoundMem(APTR MemBlock);
LONG SetVolume(struct Sound *, WORD Volume);
void StopAudio(void);

#endif /* CLIB_SOUND_PROTOS_H */

