/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_AHI_H
#define _PPCINLINE_AHI_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef AHI_BASE_NAME
#define AHI_BASE_NAME AHIBase
#endif /* !AHI_BASE_NAME */

#define AHI_AddAudioMode(Private) \
	LP1(0x96, ULONG, AHI_AddAudioMode, struct TagItem *, Private, a0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_AddAudioModeTags(tags...) \
	({ULONG _tags[] = { tags }; AHI_AddAudioMode((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_AllocAudioA(tagList) \
	LP1(0x2a, struct AHIAudioCtrl *, AHI_AllocAudioA, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_AllocAudio(tags...) \
	({ULONG _tags[] = { tags }; AHI_AllocAudioA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_AllocAudioRequestA(tagList) \
	LP1(0x78, struct AHIAudioModeRequester *, AHI_AllocAudioRequestA, struct TagItem *, tagList, a0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_AllocAudioRequest(tags...) \
	({ULONG _tags[] = { tags }; AHI_AllocAudioRequestA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_AudioRequestA(Requester, tagList) \
	LP2(0x7e, BOOL, AHI_AudioRequestA, struct AHIAudioModeRequester *, Requester, a0, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_AudioRequest(a0, tags...) \
	({ULONG _tags[] = { tags }; AHI_AudioRequestA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_BestAudioIDA(tagList) \
	LP1(0x72, ULONG, AHI_BestAudioIDA, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_BestAudioID(tags...) \
	({ULONG _tags[] = { tags }; AHI_BestAudioIDA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_ControlAudioA(AudioCtrl, tagList) \
	LP2(0x3c, ULONG, AHI_ControlAudioA, struct AHIAudioCtrl *, AudioCtrl, a2, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_ControlAudio(a0, tags...) \
	({ULONG _tags[] = { tags }; AHI_ControlAudioA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_FreeAudio(AudioCtrl) \
	LP1NR(0x30, AHI_FreeAudio, struct AHIAudioCtrl *, AudioCtrl, a2, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_FreeAudioRequest(Requester) \
	LP1NR(0x84, AHI_FreeAudioRequest, struct AHIAudioModeRequester *, Requester, a0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_GetAudioAttrsA(ID, Audioctrl, tagList) \
	LP3(0x6c, BOOL, AHI_GetAudioAttrsA, ULONG, ID, d0, struct AHIAudioCtrl *, Audioctrl, a2, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_GetAudioAttrs(a0, a1, tags...) \
	({ULONG _tags[] = { tags }; AHI_GetAudioAttrsA((a0), (a1), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_KillAudio() \
	LP0NR(0x36, AHI_KillAudio, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_LoadModeFile(Private) \
	LP1(0xa2, ULONG, AHI_LoadModeFile, STRPTR, Private, a0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_LoadSound(Sound, Type, Info, AudioCtrl) \
	LP4(0x5a, ULONG, AHI_LoadSound, UWORD, Sound, d0, ULONG, Type, d1, APTR, Info, a0, struct AHIAudioCtrl *, AudioCtrl, a2, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_NextAudioID(Last_ID) \
	LP1(0x66, ULONG, AHI_NextAudioID, ULONG, Last_ID, d0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_PlayA(Audioctrl, tagList) \
	LP2NR(0x8a, AHI_PlayA, struct AHIAudioCtrl *, Audioctrl, a2, struct TagItem *, tagList, a1, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AHI_Play(a0, tags...) \
	({ULONG _tags[] = { tags }; AHI_PlayA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define AHI_RemoveAudioMode(Private) \
	LP1(0x9c, ULONG, AHI_RemoveAudioMode, ULONG, Private, d0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_SampleFrameSize(SampleType) \
	LP1(0x90, ULONG, AHI_SampleFrameSize, ULONG, SampleType, d0, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_SetEffect(Effect, AudioCtrl) \
	LP2(0x54, ULONG, AHI_SetEffect, APTR, Effect, a0, struct AHIAudioCtrl *, AudioCtrl, a2, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_SetFreq(Channel, Freq, AudioCtrl, Flags) \
	LP4NR(0x48, AHI_SetFreq, UWORD, Channel, d0, ULONG, Freq, d1, struct AHIAudioCtrl *, AudioCtrl, a2, ULONG, Flags, d2, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_SetSound(Channel, Sound, Offset, Length, AudioCtrl, Flags) \
	LP6NR(0x4e, AHI_SetSound, UWORD, Channel, d0, UWORD, Sound, d1, ULONG, Offset, d2, LONG, Length, d3, struct AHIAudioCtrl *, AudioCtrl, a2, ULONG, Flags, d4, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_SetVol(Channel, Volume, Pan, AudioCtrl, Flags) \
	LP5NR(0x42, AHI_SetVol, UWORD, Channel, d0, Fixed, Volume, d1, sposition, Pan, d2, struct AHIAudioCtrl *, AudioCtrl, a2, ULONG, Flags, d3, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define AHI_UnloadSound(Sound, Audioctrl) \
	LP2NR(0x60, AHI_UnloadSound, UWORD, Sound, d0, struct AHIAudioCtrl *, Audioctrl, a2, \
	, AHI_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_AHI_H */
