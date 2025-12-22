#ifndef _SGESCREEN_H
#define _SGESCREEN_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgescreen.h
 * @brief Sceen control
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeScreen
 * @brief Sceen control
 *
 * @{
 */

/**
 * @brief Global variable to access the screen
 *
 * You can access the screen from anywhere in your code.
 */
extern SDL_Surface *screen;

/**
 * @brief Open a window/screen
 * @param title The title displayed in the window handle (if not fullscreen)
 * @param width The with in pixels
 * @param height The height in pixels
 * @param depth The screen depth in bit (e.g. 16, 24, 32)
 * @param fullscreen Either FULLSCREEN or NOFULLSCREEN to start the game in fullscreen or window
 */
void sgeOpenScreen(const char *title, int width, int height, int depth, int fullscreen);

/**
 * @brief Close a window/screen
 *
 * Should be called, right before exiting your game
 */
void sgeCloseScreen(void);

/**
 * @brief Do NOT show a mouse cursor
 */
void sgeHideMouse(void);

/**
 * @brief Show a mouse cursor
 */
void sgeShowMouse(void);

/**
 * @brief Flip screen buffer
 *
 * All your drawing operations are taking place in a buffer which
 * is not actually displayed until you call this function.
 */
void sgeFlip(void);

// }@

#ifdef __cplusplus
}
#endif

#endif
