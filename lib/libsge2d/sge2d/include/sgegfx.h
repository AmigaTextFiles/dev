#ifndef _SGEGFX_H
#define _SGEGFX_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgegfx.h
 * @brief Low level graphics and drawing functions
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeGFX
 * @brief Low level graphics and drawing functions
 *
 * @{
 */

/**
 * @brief clear the whole screen to black
 */
#define sgeClearScreen() SDL_FillRect(screen, NULL, 0)

/**
 * @struct SGEPIXELINFO
 *
 * color and alpha values of a pixel
 */
typedef struct {
	/** @brief the red value of the pixel (0-255) */
	Uint8 r;
	/** @brief the green value of the pixel (0-255) */
	Uint8 g;
	/** @brief the blue value of the pixel (0-255) */
	Uint8 b;
	/** @brief the alpha value of the pixel (0-255) */
	Uint8 a;
} SGEPIXELINFO;

/**
 * @struct SGEPOSITION
 *
 * A 2 dimensional position information
 */
typedef struct {
	/** @brief the x position in pixels */
	int x;
	/** @brief the y position in pixels */
	int y;
} SGEPOSITION;

/**
 * @brief create a new @link SGEPOSITION @endlink
 * @param x the x position in pixels
 * @param y the y position in pixels
 * @return a pointer to a @link SGEPOSITION @endlink
 */
SGEPOSITION *sgePositionNew(int x, int y);

/**
 * @brief destroy a @link SGEPOSITION @endlink and free resources
 * @param p a pointer to a @link SGEPOSITION @endlink
 */
void sgePositionDestroy(SGEPOSITION *p);

/**
 * @brief create a new @link SGEPIXELINFO @endlink
 * @param r the red value of the pixel (0-255)
 * @param g the green value of the pixel (0-255)
 * @param b the blue value of the pixel (0-255)
 * @param a the alpha value of the pixel (0-255)
 * @return a pointer to a @link SGEPIXELINFO @endlink
 */
SGEPIXELINFO *sgePixelInfoNew(Uint8 r, Uint8 g, Uint8 b, Uint8 a);

/**
 * @brief destroy a @link SGEPIXELINFO @endlink and free resources
 * @param p a pointer to a @link SGEPIXELINFO @endlink
 */
void sgePixelInfoDestroy(SGEPIXELINFO *i);

/**
 * @brief create a new hardware dependant color
 * @param surface the SDL_Surface it should be created for
 * @param r the red value of the pixel (0-255)
 * @param g the green value of the pixel (0-255)
 * @param b the blue value of the pixel (0-255)
 * @param a the alpha value of the pixel (0-255)
 *
 * example:
 *
 * Draw a red, @b non transparent pixel on the screen at 100/50
 *
 * @code sgeDrawPixel(screen, 100, 50, sgeMakeColor(screen, 255, 0, 0, 255)); @endcode
 */
Uint32 sgeMakeColor(SDL_Surface *surface, int r, int g, int b, int a);

/**
 * @brief draw a filled rectangle
 * @param dest the destination surface
 * @param x the x coordinate of upper left corner of the rectangle
 * @param y the y coordinate of upper left corner of the rectangle
 * @param w the width of the rectangle
 * @param h the height of the rectangle
 * @param color the color of the rectangle (see @link sgeMakeColor @endlink)
 */
void sgeFillRect(SDL_Surface *dest, int x, int y, int w, int h, Uint32 color);

/**
 * @brief draw the outlines of a rectangle
 * @param dest the destination surface
 * @param x the x coordinate of upper left corner of the rectangle
 * @param y the y coordinate of upper left corner of the rectangle
 * @param w the width of the rectangle
 * @param h the height of the rectangle
 * @param linewidth the line width in pixels of the outline
 * @param color the color of the rectangle (see @link sgeMakeColor @endlink)
 *
 * example:
 *
 * Draw a white rectangle with a border with of 4 pixels on the screen
 *
 * @block sgeDrawRect(screen, 20, 10, 200, 100, 4, sgeMakeColor(screen, 255, 255, 255, 255)); @endblock
 */
void sgeDrawRect(SDL_Surface *dest, int x, int y, int w, int h, int linewidth, Uint32 color);

/**
 * @brief draw a pixel
 * @param dest the destination surface
 * @param x the x coordinate of the pixel
 * @param y the y coordinate of the pixel
 * @param color the color of the rectangle (see @link sgeMakeColor @endlink)
 */
void sgeDrawPixel(SDL_Surface *dest, int x, int y, Uint32 color);

/**
 * @brief get the color of a pixel
 * @param dest the SDL_Surface to read the pixel from
 * @param x the x coordinate of the pixel
 * @param y the y coordinate of the pixel
 * @return the pixel information as @link SGEPIXELINFO @endlink
 */
SGEPIXELINFO *sgeGetPixel(SDL_Surface *dest, int x, int y);

/**
 * @brief draw a line
 * @param dest the destination surface
 * @param x the starting x coordinate of the line
 * @param y the starting y coordinate of the line
 * @param x2 the ending x coordinate of the line
 * @param y2 the ending y coordinate of the line
 * @param color the color of the rectangle (see @link sgeMakeColor @endlink)
 */
void sgeDrawLine(SDL_Surface *dest, int x, int y, int x2, int y2, Uint32 color);

/**
 * @brief draw a image
 * @param dest the destination surface
 * @param image the actual image to draw onto dest
 * @param x the x position on dest to draw to
 * @param y the y position on dest to draw to
 *
 * example:
 *
 * Draw a image on the upper left position on the screen
 *
 * @code sgeDrawImage(screen, myImage, 0, 0); @endcode
 */
void sgeDrawImage(SDL_Surface *dest, SDL_Surface *image, int x, int y);

/**
 * @brief disable alpha blending on a SDL_Surface
 * @param s a pointer to a SDL_Surface
 */
void sgeIgnoreAlpha(SDL_Surface *s);

/**
 * @brief enable alpha blending on a SDL_Surface
 * @param s a pointer to a SDL_Surface
 */
void sgeUseAlpha(SDL_Surface *s);

/**
 * @brief creates a new SDL_Surface from a source which displays a rotated and zoomed copy of source
 * @param source a pointer to a SDL_Surface which will be used as source of the rotation/zoom
 * @param rotation the rotation of the result in radians
 * @param zoom the zoom of the result
 * @return a new SDL_Surface with rotation and zoom applied
 *
 * The rotation is in radians:
 *
 * http://en.wikipedia.org/wiki/Radians
 *
 * example:
 *
 * Create a new SDL_Surface which is roughly 180 degrees rotated
 * and two times the size of myImage
 *
 * @code SDL_Surface *new=sgeRotoZoom(myImage, 3.14, 2.0); @endcode
 */
SDL_Surface *sgeRotoZoom(SDL_Surface *source, float rotation, float zoom);

/**
 * @brief copies a SDL_Surface and returns a new SDL_Surface with new overall alpha values
 * @param s a pointer to a SDL_Surface
 * @param alpha the new alpha of the target (0-255)
 * @return a pointer to a new SDL_Surface
 */
SDL_Surface *sgeChangeSDLSurfaceAlpha(SDL_Surface *s, Uint8 alpha);

/**
 * @brief create a new SDL_Surface into application RAM
 * @param width the width of the new surface
 * @param height the height of the new surface
 * @param depth the bit depth of the new surface
 * @param sdlflags the sdl flags of the new surface, or 0 for default flags
 */
SDL_Surface *sgeCreateSDLSurface(int width, int height, int depth, Uint32 sdlflags);

/**
 * @brief create a new accelerated SDL_Surface into video RAM (if possible)
 * @param width the width of the new surface
 * @param height the height of the new surface
 * @param depth the bit depth of the new surface
 * @param sdlflags the sdl flags of the new surface, or 0 for default flags
 *
 * Will return a standard SDL_Surface if not enough video ram is free
 */
SDL_Surface *sgeCreateVideoSurface(int width, int height, int depth, Uint32 sdlflags);

// }@

#ifdef __cplusplus
}
#endif

#endif
