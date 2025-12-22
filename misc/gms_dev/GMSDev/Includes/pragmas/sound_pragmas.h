#ifndef _INCLUDE_PRAGMA_SOUND_LIB_H
#define _INCLUDE_PRAGMA_SOUND_LIB_H

#ifndef CLIB_SOUND_PROTOS_H
#include <clib/sound_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(SNDBase,0x006,AllocSoundMem(d0,d1))
#pragma amicall(SNDBase,0x00C,StopAudio())
#pragma amicall(SNDBase,0x012,CheckSound(a0))
#pragma amicall(SNDBase,0x018,FreeSoundMem(d0))
#pragma amicall(SNDBase,0x01E,SetVolume(a0,d0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall SNDBase AllocSoundMem        006 1002
#pragma libcall SNDBase StopAudio            00C 00
#pragma libcall SNDBase CheckSound           012 801
#pragma libcall SNDBase FreeSoundMem         018 001
#pragma libcall SNDBase SetVolume            01E 0802
#endif

#endif	/*  _INCLUDE_PRAGMA_SOUND_LIB_H  */
