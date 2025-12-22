#ifndef _SGESPRITE_H
#define _SGESPRITE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgesprite.h
 * @brief Sprite handling
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeSprite
 * @brief Sprite handling
 *
 * @{
 */

/**
 * @struct SGESPRITEWAYPOINT
 * @brief a sprite waypoint
 *
 * for defining a way for the sprite to walk along automatically
 */
typedef struct {
	/** @brief x position of the waypoint */
	int x;
	/** @brief y position of the waypoint */
	int y;
} SGESPRITEWAYPOINT;

/** @struct SGESPRITE
 * a sprite, a image that can be animated and detect collision with other sprites */
typedef struct {
	/** @brief the x position of the sprite */
	int x;
	/** @brief the y position of the sprite */
	int y;
	/** @brief the current frame of the durrent anim bank */
	Uint32 currentFrame;
	/** @brief a @link SGEARRAY @endlink holding SGEARRAYS with the sprites */
	SGEARRAY *sprite;
	/** @brief a @link SGEARRAY @endlink holding the waypoints of the sprite */
	SGEARRAY *wayPoints;
	/** @brief a void pointer for adding your own userdata to the sprite */
	void *userData;
	/** @brief the number of anim banks the sprite has */
	int numberOfBanks;
	/** @brief the current anim bank of the sprite */
	int currentBank;
	/** @brief do animate the sprite (YES/NO) */
	int animate;
	/** @brief the alpha of the sprite (0-255) */
	Uint8 alpha;
	/** @brief the speed for automatic sprite movement */
	float moveSpeed;
	/** @privatesection */
	Uint32 framesPerSecond;
	Uint32 lastFrame;
	SGEARRAY *bankSize;
	Uint32 isMoving;
	float fX, fY;
	float dirX, dirY;
	int initialized;
	int initMove;
} SGESPRITE;

/**
 * @brief create a new empty sprite
 * @return a pointer to @link SGESPRITE @endlink
 * */
SGESPRITE *sgeSpriteNew(void);

/**
 * @brief create a new sprite from a file
 * @param f a pointer to @link SGEFILE @endlink
 * @param filename the filename of the image in the sge archive
 * @return a pointer to @link SGESPRITE @endlink
 *
 * example:
 *
 * @code SGESPRITE *s=sgeSpriteNewFile(myFile, "data/sprites/player.png"); @endcode
 */
SGESPRITE *sgeSpriteNewFile(SGEFILE *f, const char *filename);

/**
 * @brief create a new animated sprite from a range of images
 * @param f a pointer to @link SGEFILE @endlink
 * @param templ a format string like you use it in printf
 * @param start the first value of the range
 * @param end the last value of the range
 * @return a pointer to @link SGESPRITE @endlink
 *
 * example:
 *
 * @code SGESPRITE *s=sgeSpriteNewFileRange(myFile, "sprites/player%04d", 1, 60); @endcode
 */
SGESPRITE *sgeSpriteNewFileRange(SGEFILE *f, const char *templ, Uint32 start, Uint32 end);

/**
 * @brief create a new sprite from a SDL_Surface
 * @param surface a pointer to SDL_Surface
 * @return a pointer to @link SGESPRITE @endlink
 */
SGESPRITE *sgeSpriteNewSDLSurface(SDL_Surface *surface);

/**
 * @brief destroy a sprite and release all resources
 * @param s a pointer to @link SGESPRITE @endlink
 */
void sgeSpriteDestroy(SGESPRITE *s);

/**
 * @brief get the current @link SGESPRITEIMAGE @endlink of the current frame
 * @param s a pointer to @link SGESPRITE @endlink
 * @return a pointer to @link SGESPRITEIMAGE @endlink of the current frame
 */
SGESPRITEIMAGE *sgeSpriteGetCurrentFrame(SGESPRITE *s);

/**
 * @brief set the animation speed in frames per second
 * @param s a pointer to @link SGESPRITE @endlink
 * @param fps the frames per second the animation should play
 */
void sgeSpriteSetFPS(SGESPRITE *s, Uint32 fps);

/**
 * @brief add a new frame to the current anim bank from a SDL_Surface
 * @param s a pointer to @link SGESPRITE @endlink
 * @param surface a pointer to a SDL_Surface
 */
void sgeSpriteAddSDLSurface(SGESPRITE *s, SDL_Surface *surface);

/**
 * @brief add a new frame to the current anim bank from a @link SGESPRITEIMAGE @endlink
 * @param s a pointer to @link SGESPRITE @endlink
 * @param i a pointer to the new @link SGESPRITEIMAGE @endlink
 */
void sgeSpriteAddSpriteImage(SGESPRITE *s, SGESPRITEIMAGE *i);

/**
 * @brief add a new frame to the current anim bank from a sge archive file
 * @param s a pointer to @link SGESPRITE @endlink
 * @param f a pointer to a @link SGEFILE @endlink
 * @param name the filename of the sprite image
 */
void sgeSpriteAddFile(SGESPRITE *s, SGEFILE *f, const char *name);

/**
 * @brief add new frames to the current anim bank from a range of files from a sge archive
 * @param s a pointer to @link SGESPRITE @endlink
 * @param f a pointer to a @link SGEFILE @endlink
 * @param templ a format string like you use it in printf
 * @param start the first value of the range
 * @param end the last value of the range
 *
 * example:
 *
 * @code sgeSpriteAddFileRange(mySprite, myFile, "sprites/player%04d", 1, 60); @endcode
 */
void sgeSpriteAddFileRange(SGESPRITE *s, SGEFILE *f, const char *templ, Uint32 start, Uint32 end);

/**
 * @brief get the SDL_Surface of the current frame of a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @return a pointer to the SDL_Surface of the current frame
 */
SDL_Surface *sgeSpriteGetSDLSurface(SGESPRITE *s);

/**
 * @brief draw the sprite on a surface or screen
 * @param s a pointer to @link SGESPRITE @endlink
 * @param dest a pointer to a SDL_Surface where it is drawn
 *
 * Uses the position information from s->x and s->y
 *
 * example:
 *
 * Draw a sprite using the global SDL_Surface screen
 *
 * @code sgeSpriteDraw(mySprite, screen); @endcode
 */
void sgeSpriteDraw(SGESPRITE *s, SDL_Surface *dest);

/**
 * @brief draw the sprite on a surface or screen on a certain position
 * @param s a pointer to @link SGESPRITE @endlink
 * @param x the x position to draw
 * @param y the y position to draw
 * @param dest a pointer to a SDL_Surface where it is drawn
 */
void sgeSpriteDrawXY(SGESPRITE *s, int x, int y, SDL_Surface *dest);

/**
 * @brief draw the sprite with zoom and rotation values
 * @param s a pointer to @link SGESPRITE @endlink
 * @param rotation the rotation of the sprite in radians as float
 * @param zoom the zoom level of the sprite as float
 * @param dest a pointer to a SDL_Surface where it is drawn
 *
 * The rotation is in radians:
 *
 * http://en.wikipedia.org/wiki/Radians
 */
void sgeSpriteDrawRotoZoomed(SGESPRITE *s, float rotation, float zoom, SDL_Surface *dest);

/**
 * @brief draw the sprite at a certain position with zoom and rotation values
 * @param s a pointer to @link SGESPRITE @endlink
 * @param x the x position to draw
 * @param y the y position to draw
 * @param rotation the rotation of the sprite in radians as float
 * @param zoom the zoom level of the sprite as float
 * @param dest a pointer to a SDL_Surface where it is drawn
 *
 * The rotation is in radians:
 *
 * http://en.wikipedia.org/wiki/Radians
 *
 * example:
 *
 * @code sgeSpriteDrawXYRotoZoomed(mySprite, 100, 50, 3.14, 2.0, screen); @endcode
 */
void sgeSpriteDrawXYRotoZoomed(SGESPRITE *s, int x, int y, float rotation, float zoom, SDL_Surface *dest);

/**
 * @brief switch all sprites of the current animation to use alpha data for collision information
 * @param s a pointer to @link SGESPRITE @endlink
 *
 * This is default, you only need this if you have switched some not to use alpha info
 */
void sgeAnimatedSpriteUseAlpha(SGESPRITE *s);

/**
 * @brief switch all sprites of the current animation to NOT use alpha data for collision information
 * @param s a pointer to @link SGESPRITE @endlink
 *
 * Every sprite image can have a collision color defined to alternatively use this as collision transparent
 * information.
 */
void sgeAnimatedSpriteIgnoreAlpha(SGESPRITE *s);

/**
 * @brief test collision between the bounding box of two sprites
 * @param a a pointer to fist @link SGESPRITE @endlink
 * @param b a pointer to second @link SGESPRITE @endlink
 * @return 0/1 if the bounding boxes of two sprites overlap
 *
 * Used automatically by all pixel exact sprite collision functions
 * for performance reasons.
 */
int sgeSpriteBoxCollide(SGESPRITE *a, SGESPRITE *b);

/**
 * @brief test a collision between two sprites
 * @param a a pointer to fist @link SGESPRITE @endlink
 * @param b a pointer to second @link SGESPRITE @endlink
 * @return 0/1 if the sprites collide
 *
 * example:
 *
 * @code if (sgeSpriteCollide(titanic, iceberg)) {
 * 	printf("Abandon ship!\n");
 * } @endcode
 */
int sgeSpriteCollide(SGESPRITE *a, SGESPRITE *b);

/**
 * @brief test collision between the bounding box of a sprite and a spriteimage
 * @param a a pointer to @link SGESPRITE @endlink
 * @param b a pointer to @link SGESPRITEIMAGE @endlink
 * @return 0/1 if the bounding boxes of two images overlap
 *
 * Used automatically by all pixel exact sprite collision functions
 * for performance reasons.
 */
int sgeSpriteBoxCollideSpriteImage(SGESPRITE *a, SGESPRITEIMAGE *b);

/**
 * @brief test a collision between a sprite and a spriteimage
 * @param a a pointer to fist @link SGESPRITE @endlink
 * @param b a pointer to @link SGESPRITEIMAGE @endlink
 * @return 0/1 if the images collide
 */
int sgeSpriteCollideSpriteImage(SGESPRITE *a, SGESPRITEIMAGE *b);

/**
 * @brief get the with of a sprite image
 * @param s a pointer to @link SGESPRITE @endlink
 * @return the width of the image in pixels as int
 */
int sgeSpriteWidth(SGESPRITE *s);

/**
 * @brief get the height of a sprite image
 * @param s a pointer to @link SGESPRITE @endlink
 * @return the height of the image in pixels as int
 */
int sgeSpriteHeight(SGESPRITE *s);

/**
 * @brief add a way point to a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @param x the x position of the way point
 * @param y the y position of the way point
 *
 * Way points are coordinates to let a sprite
 * walk automatically along.
 */
void sgeSpriteAddWayPoint(SGESPRITE *s, int x, int y);

/**
 * @brief remove the next (aka current) way point from a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 */
void sgeSpriteRemoveNextWayPoint(SGESPRITE *s);

/**
 * @brief remove all remaining way points from a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 */
void sgeSpriteClearWayPoints(SGESPRITE *s);

/**
 * @brief start the automatic movement of a sprite along its way points
 * @param s a pointer to @link SGESPRITE @endlink
 * @param speed the movement speed as float
 *
 * The movement speed is a relative value depending on the games
 * frames per second.
 */
void sgeSpriteStartMovement(SGESPRITE *s, float speed);

/**
 * @brief stop automatic movement of a sprite and remove all remaining way points
 * @param s a pointer to @link SGESPRITE @endlink
 */
void sgeSpriteAbortMovement(SGESPRITE *s);

/**
 * @brief move a sprite one step towards a certain coordinate
 * @param s a pointer to @link SGESPRITE @endlink
 * @param x the x position to move towards
 * @param y the y position to move towards
 *
 * Depends on the sprites move speed
 */
void sgeSpriteMoveTowards(SGESPRITE *s, int x, int y);

/**
 * @brief add custom user data to a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @param data a pointer to your data, cast to (void *)
 */
void sgeSpriteSetUserData(SGESPRITE *s, void *data);

/**
 * @brief get custom user data from a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @return a void pointer to custom userdata
 */
void *sgeSpriteGetUserData(SGESPRITE *s);

/**
 * @brief copies the sprite position to the current frame
 * @param s a pointer to @link SGESPRITE @endlink
 *
 * The frames and the sprite do have its own position
 * values, this function copies the position information of
 * the @link SGESPRITE @endlink to the current frame.
 *
 * You normally do not need this function directly unless you
 * are neither using @link sgeSpriteDraw @endlink (or
 * the other drawing functions) nor
 * @link sgeSpriteUpdate @endlink on your sprite.
 */
void sgeSpriteUpdatePosition(SGESPRITE *s);

/**
 * @brief updates a sprite without drawing it
 * @param s a pointer to @link SGESPRITE @endlink
 *
 * You should call this every frame on every sprite
 * you are @b NOT drawing but change position or want
 * the animation to be continued.
 *
 * Updates position and animation values without drawing
 * the sprite.
 */
void sgeSpriteUpdate(SGESPRITE *s);

/**
 * @brief get the number of frames in the current anim bank
 * @param s a pointer to @link SGESPRITE @endlink
 * @return the number of frames in the current anim bank
 */
Uint32 sgeSpriteGetNumberOfFrames(SGESPRITE *s);

/**
 * @brief set the number of frames in the current anim bank
 * @param s a pointer to @link SGESPRITE @endlink
 * @param number the new number of frames
 */
void sgeSpriteSetNumberOfFrames(SGESPRITE *s, Uint32 number);

/**
 * @brief get the current array of frames
 * @param s a pointer to @link SGESPRITE @endlink
 * @return a pointer to @link SGEARRAY @endlink holding @link SGESPRITEIMAGE @endlink of all frames of the current anim bank
 */
SGEARRAY *sgeSpriteGetCurrentSpriteArray(SGESPRITE *s);

/**
 * @brief switch to a anim bank (aka animation)
 * @param s a pointer to @link SGESPRITE @endlink
 * @param bank the index of the anim bank
 */
void sgeSpriteSetAnimBank(SGESPRITE *s, Uint32 bank);

/**
 * @brief add a new anim bank (aka animation) the the sprite
 * @param s a pointer to @link SGESPRITE @endlink
 *
 * Switches to the new anim bank immediately, all new
 * added images will be added to the new anim bank
 */
void sgeSpriteAddAnimBank(SGESPRITE *s);

/**
 * @brief get the index of the current anim bank
 * @param s a pointer to @link SGESPRITE @endlink
 * @return the index of the current anim bank
 */
Uint32 sgeSpriteGetAnimBank(SGESPRITE *s);

/**
 * @brief enable/disable animation of a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @param state YES/NO depending on to animate the sprite or not
 */
void sgeSpriteAnimate(SGESPRITE *s, int state);

/**
 * @brief forces next frame to be frame 0 of the current anim bank
 * @param s a pointer to @link SGESPRITE @endlink
 */
void sgeSpriteResetAnimation(SGESPRITE *s);

/**
 * @brief sets a specific frame of the current animation
 * @param s a pointer to @link SGESPRITE @endlink
 * @param frame the frame to set
 */
void sgeSpriteForceFrame(SGESPRITE *s, Uint32 frame);

/**
 * @brief duplicate (copy) a sprite
 * @param s a pointer to @link SGESPRITE @endlink
 * @return a exact copy of s
 *
 * All resources are copied, so you could destroy sprite
 * s and the new one still has all images
 */
SGESPRITE *sgeSpriteDuplicate(SGESPRITE *s);

// }@

#ifdef __cplusplus
}
#endif

#endif
