#ifndef _SGEINIT_H
#define _SGEINIT_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgeinit.h
 * @brief Initialize the library
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeInit
 * @brief Initialize the library
 *
 * @{
 */

// FIXME: maybe not needed anymore:
// extern SDL_Joystick *defaultjoystick;

/** @brief Initialize the engine
 * @param useAudio either AUDIO or NOAUDIO to initialize the audio part or not
 * @param useJoystick either JOYSTICK or NOJOYSTICK to initialize the joystick part or not
 */
void sgeInit(int useAudio, int useJoystick);

/**
 * @privatesection
 */
void sgeTerminate(void);

// }@

#ifdef __cplusplus
}
#endif

#endif
