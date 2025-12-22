#ifndef _SGESOUND_H
#define _SGESOUND_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgesound.h
 * @brief Sound and music
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeSound
 * @brief Sound and music
 *
 * Functions to play sound effects and music.
 *
 * @{
 */

#include <sge.h>

/**
 * @struct SGESOUND
 * 
 * Internal information about a sound element
 */
typedef struct {
	/** @brief is sound playing? */
	int playing;
	/** @brief channel the sound is playing */
	int channel;
	/** @privatesection */
	char *internalID;
	Mix_Chunk *data;
} SGESOUND;

/**
 * @brief set the sample rate of the audio device
 * @param rate the rate in kHz
 *
 * Use before @link sgeInit @endlink
 */
void sgeSetDefaultSampleRate(int rate);

/**
 * @brief get the sample rate of the audio device
 * @return the rate in kHz
 */
int sgeGetDefaultSampleRate(void);

/**
 * @brief set the global playing volume
 * @param volume the new volume
 *
 * The maximum volume is MIX_MAX_VOLUME
 */
void sgeSetVolume(int volume);

/**
 * brief get the current global volume
 * return the current volume
 */
int sgeGetVolume(void);

/**
 * @brief create a sound from a sge data archive
 * @param f a pointer to a opened @link SGEFILE @endlink
 * @param name the file name in the archive
 */
SGESOUND *sgeSoundNew(SGEFILE *f, const char *name);

/**
 * @brief destroy a sound struct and free memory
 * @param m pointer to @link SGESOUND @endlink
 */
void sgeSoundDestroy(SGESOUND *m);

/**
 * @brief play a sound
 * @param m pointer to @link SGESOUND @endlink
 * @param loop YES/NO if the sound should be played looping
 * @param fadeinms Fade the volume in over n miliseconds
 */
void sgeSoundPlay(SGESOUND *m, int loop, int fadeinms);

/**
 * @brief stop a sound
 * @param m pointer to @link SGESOUND @endlink
 * @param fadeoutms Fade the volume out over n miliseconds
 */
void sgeSoundStop(SGESOUND *m, int fadeoutms);

/**
 * @brief check if a sound is playing
 * @param m pointer to @link SGESOUND @endlink
 * @return 0 if sound is not playing or the channel number the sound is playing
 */
int sgeSoundIsPlaying(SGESOUND *m);

// }@

#ifdef __cplusplus
}
#endif

#endif
