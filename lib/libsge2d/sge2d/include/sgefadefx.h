#ifndef _SGEFADEEFFECTS_H
#define _SGEFADEEFFECTS_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgefadefx.h
 * @brief Effects for fading between screens
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeFadeFX
 * @brief Effects for fading between screens
 *
 * Functions to automatically blend between two images.
 *
 * @{
 */
enum SGEFADEFX_TYPES {
	SGEFADEFX_FADE, /*!< cross fade between two images */
	SGEFADEFX_WIPE_LEFT, /*!< wipe the new image from the left side over the old image */
	SGEFADEFX_WIPE_RIGHT, /*!< wipe the new image from the right side over the old image */
	SGEFADEFX_WIPE_TOP, /*!< wipe the new image from the top over the old image */
	SGEFADEFX_WIPE_BOTTOM, /*!< wipe the new image from the bottom over the old image */
	SGEFADEFX_SCROLL_LEFT, /*!< scroll the new image in from the left side */
	SGEFADEFX_SCROLL_RIGHT, /*!< scroll the new image in from the right side */
	SGEFADEFX_SCROLL_TOP, /*!< scroll the new image in from the top */
	SGEFADEFX_SCROLL_BOTTOM /*!< scroll the new image in from the bottom */
};

typedef struct {
	/** @brief is the effect finished? */
	Uint8 finished;
	/** @brief a pointer to the update function */
	void (*updateFunction)(void *);
	/** @privatesection */
	Uint32 type;
	Uint32 runTime;
	Uint32 startTime;
	Uint32 realStartTime;
	Uint32 current;
	SDL_Surface *src;
	SDL_Surface *dst;
	SGESPRITE *srcSprite;
	SGESPRITE *dstSprite;
	Uint32 preDelay;
	Uint32 postDelay;
	Uint8 deleteSurfaces;
	SDL_Surface *surface;
} SGEFADEFX;

/**
 * @brief create a new fade effect from between two sprites
 * @param type the type of the effect ( @link SGEFADEFX_TYPES @endlink )
 * @param runTime the time the fade should take place in miliseconds
 * @param source the source @link SGESPRITE @endlink
 * @param destination the destination @link SGEPRITE @endlink
 * @return a pointer to a new @link SGEFADEFX @endlink
 * @see SGEFADEFX_TYPES
 */
SGEFADEFX *sgeFadeFXNew(Uint32 type, Uint32 runTime, SGESPRITE *source, SGESPRITE *destination);

/**
 * @brief create a new fade effect from between two SDL_Surface images
 * @param type the type of the effect ( @link SGEFADEFX_TYPES @endlink )
 * @param runTime the time the fade should take place in miliseconds
 * @param source the source, as SDL_Surface
 * @param destination the destinatio, as SDL_Surface
 * @return a pointer to a new @link SGEFADEFX @endlink
 * @see SGEFADEFX_TYPES
 */
SGEFADEFX *sgeFadeFXNewSDLSurface(Uint32 type, Uint32 runTime, SDL_Surface *source, SDL_Surface *destination);

/**
 * @brief destroy the @link SGEFADEFX @endlink and free resources
 * @param fx a pointer to a @link SGEFADEFX @endlink
 */
void sgeFadeFXDestroy(SGEFADEFX *fx);

/**
 * @brief when destroying the effect, should the image resources be destroyed too?
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @param yesno YES/NO to destroy or not destroy the images
 *
 * default behaviour is @b NOT to free the image resources
 */
void sgeFadeFXDeleteSurfaces(SGEFADEFX *fx, Uint8 yesno);

/**
 * @brief when destroying the effect, should the image resources be destroyed too?
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @param yesno YES/NO to destroy or not destroy the images
 *
 * default behaviour is @b NOT to free the image resources
 */
#define sgeFadeFXDeleteSprites(fx, yesno) sgeFadeFXDeleteSurfaces(fx, yesno)

/**
 * @brief set a delay before starting the fade
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @param delay the delay in miliseconds
 */
void sgeFadeFXPreDelay(SGEFADEFX *fx, Uint32 delay);

/**
 * @brief set a delay between the actual fade beeing finished and @link sgeFadeFXFinished @endlink returning true
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @param delay the delay in miliseconds
 */
void sgeFadeFXPostDelay(SGEFADEFX *fx, Uint32 delay);

/**
 * @brief set the render target of the effect
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @param surface the target SDL_Surface
 * 
 * By default the effect is rendered to @b screen, but can
 * be rendered to any SDL_Surface
 */
void sgeFadeFXSetTarget(SGEFADEFX *fx, SDL_Surface *surface);

/**
 * @brief draw the effect
 * @param fx a pointer to a @link SGEFADEFX @endlink
 */
void sgeFadeFXDraw(SGEFADEFX *fx);

/**
 * @brief check if the effect is finished
 * @param fx a pointer to a @link SGEFADEFX @endlink
 * @return YES/NO
 */
int sgeFadeFXFinished(SGEFADEFX *fx);

/**
 * @privatesection
 */
void sgeFadeFXFadeUpdate(void *fxdata);
void sgeFadeFXWipeScrollUpdate(void *fxdata);

// }@

#ifdef __cplusplus
}
#endif

#endif
