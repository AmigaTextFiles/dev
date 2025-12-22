#ifndef _SGESPRITEIMAGE_H
#define _SGESPRITEIMAGE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgespriteimage.h
 * @brief Single sprite image
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeSpriteImage
 * @brief Single sprite image low level functions
 *
 * Usually you would want to use @link sgeSprite @endlink. sgeSpriteImage
 * is more like a low level acess to the sprite data itself.
 *
 * @{
 */

/**
 * @struct SGESPRITEIMAGE
 *
 * Information about a single sprite image
 */
typedef struct {
	/** @brief use alpha information (slower) */
	int useAlpha;
	/** @brief if no alpha used, use this color as 'transparent' (for collision only) */
	Uint32 collisionColor;
	/** @brief the x position of the image */
	int x;
	/** @brief the y position of the image */
	int y;
	/** @brief width of the image */
	int w;
	/** @brief height of the image */
	int h;
	/** @brief the sdl surface element of the image */
	SDL_Surface *image;
} SGESPRITEIMAGE;

/**
 * @brief create a empty sprite image
 * @return a pointer to @link SGESPRITEIMAGE @endlink
 * */
SGESPRITEIMAGE *sgeSpriteImageNew(void);

/**
 * @brief create a sprite image from a file
 * @param f a pointer to @link SGEFILE @endlink
 * @param name the name of the file
 * @return a pointer to @link SGESPRITEIMAGE @endlink
 * */
SGESPRITEIMAGE *sgeSpriteImageNewFile(SGEFILE *f, const char *name);

/**
 * @brief destroy a sprite image and free memory
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 */
void sgeSpriteImageDestroy(SGESPRITEIMAGE *s);

/**
 * @brief duplicate (copy) a sprite image
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 * @return a pointer to a new copy of the image
 */
SGESPRITEIMAGE *sgeSpriteImageDuplicate(SGESPRITEIMAGE *s);

/**
 * @brief change or set the actual image of a sprite image
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 * @param image a pointer to a SDL_Surface
 * @return a pointer to a new copy of the image
 *
 * Either sets the new image, or replaces a existing one.
 * If there already was a SDL_Surface, it's memory is freed.
 */
void sgeSpriteImageSetImage(SGESPRITEIMAGE *s, SDL_Surface *image);

/**
 * @brief draw a sprite image on its position
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 * @param alpha a alpha value (0-255)
 * @param dest the destination surface, either a SDL_Surface or screen
 *
 * The position of the sprite is taken from the @link SGESPRITEIMAGE @endlink
 * x and y values.
 */
void sgeSpriteImageDraw(SGESPRITEIMAGE *s, Uint8 alpha, SDL_Surface *dest);

/**
 * @brief draw a sprite image on its position
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 * @param x the x position to draw the image at
 * @param y the y position to draw the image at
 * @param alpha a alpha value (0-255)
 * @param dest the destination surface, either a SDL_Surface or screen
 *
 * This overrides the position information from @link SGESPRITEIMAGE @endlink
 */
void sgeSpriteImageDrawXY(SGESPRITEIMAGE *s, int x, int y, Uint8 alpha, SDL_Surface *dest);

/**
 * @brief check if the outbox of two images overlap
 * @param a a pointer to the first @link SGESPRITEIMAGE @endlink
 * @param b a pointer to the second @link SGESPRITEIMAGE @endlink
 * @return 0 or 1 if there is overlapping
 *
 * This is a fast check if two images overlap at all, it is
 * not pixel based.
 */
int sgeSpriteImageBoxCollide(SGESPRITEIMAGE *a, SGESPRITEIMAGE *b);

/**
 * @brief pixel exact collision detection between two images
 * @param a a pointer to the first @link SGESPRITEIMAGE @endlink
 * @param b a pointer to the second @link SGESPRITEIMAGE @endlink
 * @return 0 or 1 if there is a collision
 *
 * This uses @link sgeSpriteImageBoxCollide @endlink to speed
 * up the test, you do not need to call it yourself.
 */
int sgeSpriteImageCollide(SGESPRITEIMAGE *a, SGESPRITEIMAGE *b);

/**
 * @brief use image alpha information for collision detection
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 */
void sgeSpriteImageUseAlpha(SGESPRITEIMAGE *s);

/**
 * @brief use a certain color of the image for collision detection
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 */
void sgeSpriteImageIgnoreAlpha(SGESPRITEIMAGE *s);

/**
 * @brief set the collision color if no alpha is used
 * @param s a pointer to a @link SGESPRITEIMAGE @endlink
 * @param r the red value of the color (0-255)
 * @param g the green value of the color (0-255)
 * @param b the blue value of the color (0-255)
 * @param a the alpha value of the color (0-255)
 *
 * Sets the color which is used as 'transparent' if collision
 * detection is not using alpha.
 * @see sgeSpriteImageIgnoreAlpha
 */
void sgeSpriteImageSetCollisionColor(SGESPRITEIMAGE *s, int r, int g, int b, int a);

// }@

#ifdef __cplusplus
}
#endif

#endif
