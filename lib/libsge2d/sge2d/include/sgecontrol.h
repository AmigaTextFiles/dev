#ifndef _SGECONTROL_H
#define _SGECONTROL_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgecontrol.h
 * @brief Low level control functions
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeControl
 * @brief Low level control functions
 *
 * Functions for managing timing and gameloops.
 * These are mostly for internal tasks or for complex
 * requirements. In most cases you should use the
 * gamestate system. @see sgeGameStateNew
 *
 * @{
 */

/**
 * @def SGEREDRAW
 * The redraw event ID
 */
#define SGEREDRAW 0xf00

/**
 * @def SGETIMER
 * The timer ID, currently only a alias to SDL_TimerID, but may change
 */
#define SGETIMER SDL_TimerID

/**
 * @brief Remove a timer from the event system
 * @param timer The timer ID returned by @link sgeAddTimer @endlink
 */
#define sgeRemoveTimer(timer) SDL_RemoveTimer(timer)

/**
 * @brief The actual game loop
 * @param event A SGEEVENT variable to handle the events
 * @param quitvar A integer variable which ends the gameloop when set to 1
 */
#define sgeGameLoop(event,quitvar) while ((SDL_WaitEvent(&event)&&(!quit)))

/**
 * @brief A shortcut to start a game
 * @param function A function pointer to your main game loop
 * @param fps The frames per second the game should run
 */
#define sgeStartGame(function, fps) \
	SGETIMER t=sgeStartRedrawTimer(fps);\
	function();\
	sgeStopRedrawTimer(t);

/**
 * @brief Add a function which is called in a regular time interval
 *
 * @param ms Miliseconds the function is called
 * @param function A function pointer to call
 * @return A SGETIMER handle
 */
SGETIMER sgeAddTimer(int ms, void *function);

/**
 * @brief Start the timer system
 * @param fps The frames per second to call the SGEREDRAW event
 * @return A SGETIMER handle
 */
SGETIMER sgeStartRedrawTimer(int fps);

/**
 * @brief Stop the timer
 * @param sgetimer The SGETIMER handle
 */
void sgeStopRedrawTimer(SGETIMER sgetimer);

/**
 * @brief Check the frames per second the game is currently running
 */
Uint32 sgeGetFPS(void);

// }@

#ifdef __cplusplus
}
#endif

#endif
