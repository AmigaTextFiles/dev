/* Automatically generated header! Do not edit! */

#ifndef _INLINE_AHI_SUB_H
#define _INLINE_AHI_SUB_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif /* !__INLINE_MACROS_H */

#ifndef AHI_SUB_BASE_NAME
#define AHI_SUB_BASE_NAME AHIsubBase
#endif /* !AHI_SUB_BASE_NAME */

#define AHIsub_AllocAudio(tagList, AudioCtrl) \
	LP2(0x1e, ULONG, AHIsub_AllocAudio, struct TagItem *, tagList, a1, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_Disable(AudioCtrl) \
	LP1NR(0x2a, AHIsub_Disable, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_Enable(AudioCtrl) \
	LP1NR(0x30, AHIsub_Enable, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_FreeAudio(AudioCtrl) \
	LP1NR(0x24, AHIsub_FreeAudio, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_GetAttr(Attribute, Argument, Default, tagList, AudioCtrl) \
	LP5(0x6c, LONG, AHIsub_GetAttr, ULONG, Attribute, d0, LONG, Argument, d1, LONG, Default, d2, struct TagItem *, tagList, a1, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_HardwareControl(Attribute, Argument, AudioCtrl) \
	LP3(0x72, LONG, AHIsub_HardwareControl, ULONG, Attribute, d0, LONG, Argument, d1, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_LoadSound(Sound, Type, Info, AudioCtrl) \
	LP4(0x60, ULONG, AHIsub_LoadSound, UWORD, Sound, d0, ULONG, Type, d1, APTR, Info, a0, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_SetEffect(Effect, AudioCtrl) \
	LP2(0x5a, ULONG, AHIsub_SetEffect, APTR, Effect, a0, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_SetFreq(Channel, Freq, AudioCtrl, Flags) \
	LP4(0x4e, ULONG, AHIsub_SetFreq, UWORD, Channel, d0, ULONG, Freq, d1, struct AHIAudioCtrlDrv *, AudioCtrl, a2, ULONG, Flags, d2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_SetSound(Channel, Sound, Offset, Length, AudioCtrl, Flags) \
	LP6(0x54, ULONG, AHIsub_SetSound, UWORD, Channel, d0, UWORD, Sound, d1, ULONG, Offset, d2, LONG, Length, d3, struct AHIAudioCtrlDrv *, AudioCtrl, a2, ULONG, Flags, d4, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_SetVol(Channel, Volume, Pan, AudioCtrl, Flags) \
	LP5(0x48, ULONG, AHIsub_SetVol, UWORD, Channel, d0, Fixed, Volume, d1, sposition, Pan, d2, struct AHIAudioCtrlDrv *, AudioCtrl, a2, ULONG, Flags, d3, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_Start(Flags, AudioCtrl) \
	LP2(0x36, ULONG, AHIsub_Start, ULONG, Flags, d0, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_Stop(Flags, AudioCtrl) \
	LP2(0x42, ULONG, AHIsub_Stop, ULONG, Flags, d0, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_UnloadSound(Sound, Audioctrl) \
	LP2(0x66, ULONG, AHIsub_UnloadSound, UWORD, Sound, d0, struct AHIAudioCtrlDrv *, Audioctrl, a2, \
	, AHI_SUB_BASE_NAME)

#define AHIsub_Update(Flags, AudioCtrl) \
	LP2(0x3c, ULONG, AHIsub_Update, ULONG, Flags, d0, struct AHIAudioCtrlDrv *, AudioCtrl, a2, \
	, AHI_SUB_BASE_NAME)

#endif /* !_INLINE_AHI_SUB_H */
