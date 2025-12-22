#ifndef _SGESTAGE_H
#define _SGESTAGE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgestage.h
 * @brief Parallax scrolling world with camera
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeStage
 * @brief Parallax scrolling world with camera
 *
 * @{
 */

/**
 * @define ABSOLUTE
 *
 * Interpret coordinates without camera position in mind
 */
#define ABSOLUTE 0

/**
 * @define RELATIVE
 *
 * Interpret coordinates relative to the camera position
 */
#define RELATIVE 1

/**
 * @brief get a sprite group from the stage
 * @param stage a pointer to @link SGESTAGE @endlink
 * @param group the index of the sprite group
 * @return a pointer to @link SGESPRITEGROUP @endlink
 *
 * example:
 *
 * get the first sprite group in the current scene
 *
 * @code
 * SGESPRITEGROUP *g=sgeStageGetSpriteGroup(myStage, 0);
 * @endcode
 */
#define sgeStageGetSpriteGroup(stage, group) sgeArrayGet(stage->spriteGroups, group)

/**
 * @brief information about a layer
 */
typedef struct {
	/** @brief the x position of the layer */
	int x;
	/** @brief the y position of the layer */
	int y;
	/** @brief the width of the layer */
	int w;
	/** @brief the height of the layer */
	int h;
	/** @brief the sprite (image) of the layer */
	SGESPRITE *sprite;
} SGELAYER;

/**
 * @brief information about the stage
 */
typedef struct {
	/** @brief the x position of the camera */
	int cameraX;
	/** @brief the y position of the camera */
	int cameraY;
	/** @brief the width of the stage */
	int w;
	/** @brief the height of the stage */
	int h;
	/** @brief a @link SGEARRAY @endlink holding all layers of the stage */
	SGEARRAY *layers;
	/** @brief a @link SGEARRAY @endlink holding all sprite groups of the stage */
	SGEARRAY *spriteGroups;
} SGESTAGE;

/**
 * @brief create a new layer from a sprite
 * @param sprite a pointer to @link SGESPRITE @endlink
 * @return a pointer to a new @link SGELAYER @endlink
 *
 * a layer is a background image layer which moves depending
 * on its with.
 *
 * For example on a side scroller you would have a layer for the
 * sky, which is less wide then a layer over it of the hills, which
 * is less wide then a layer of nearer objects like houses and street
 * lamps.
 */
SGELAYER *sgeLayerNew(SGESPRITE *sprite);

/**
 * @brief destroy a layer and free the resources
 * @param l a pointer to @link SGELAYER @endlink
 */
void sgeLayerDestroy(SGELAYER *l);

/**
 * @brief create a new stage
 * @param width the width of the stage
 * @param height the height of the stage
 * @return a pointer to @link SGESTAGE @endlink
 *
 * If you use layers, you usually want to be the stage the same
 * width as the largest foreground layer (or height if you go
 * for a vertical scrolling game)
 */
SGESTAGE *sgeStageNew(int width, int height);

/**
 * @brief destroy a stage and free resources
 * @param s a pointer to @link SGESTAGE @endlink
 */
void sgeStageDestroy(SGESTAGE *s);

/**
 * @brief add a sprite as new layer to the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param sprite a pointer to the @link SGESPRITE @endlink to use as layer
 * @param x the x position of the layer in the stage
 * @param y the y position of the layer in the stage
 * @return the position in the @link SGEARRAY @endlink of s->layers
 */
int sgeStageAddLayer(SGESTAGE *s, SGESPRITE *sprite, int x, int y);

/**
 * @brief change the height of a layer in the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param layer the index of the layer in s->layers
 * @param height the new height of the layer
 */
void sgeStageSetLayerHeight(SGESTAGE *s, int layer, int height);

/**
 * @brief change the width of a layer in the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param layer the index of the layer in s->layers
 * @param width the new width of the layer
 */
void sgeStageSetLayerWidth(SGESTAGE *s, int layer, int width);

/**
 * @brief draw a layer
 * @param s a pointer to @link SGESTAGE @endlink
 * @param dest a SDL_Surface to draw on (e.g. screen)
 * @param layer the index of the layer in s->layers
 */
void sgeStageDrawLayer(SGESTAGE *s, SDL_Surface *dest, int layer);

/**
 * @brief add a sprite group to the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param g a pointer to @link SGESPRITEGROUP @endlink
 * @return the position in the @link SGEARRAY @endlink of s->spriteGroups
 */
int sgeStageAddSpriteGroup(SGESTAGE *s, SGESPRITEGROUP *g);

/**
 * @brief add a sprite to the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param spriteGroup the index of the @link SGESPRITEGROUP @endlink in s->spriteGroup
 * @param sprite a pointer to @link SGESPRITE @endlink
 */
int sgeStageAddSprite(SGESTAGE *s, int spriteGroup, SGESPRITE *sprite);

/**
 * @brief draw a sprite group to the screen
 * @param s a pointer to @link SGESTAGE @endlink
 * @param spriteGroup the index of the @link SGESPRITEGROUP @endlink in s->spriteGroup
 */
void sgeStageDrawSpriteGroup(SGESTAGE *s, int spriteGroup);

/**
 * @brief draw all sprite groups on the screen
 * @param s a pointer to @link SGESTAGE @endlink
 */
void sgeStageDrawSpriteGroups(SGESTAGE *s);

/**
 * @brief test if a sprite collides a sprite group
 * @param s a pointer to @link SGESTAGE @endlink
 * @param b the index of the @link SGESPRITEGROUP @endlink in s->spriteGroup
 * @param a a pointer to @link SGESPRITE @endlink
 * @param orientation RELATIVE/ABSOLUTE if the sprite coordinates should be treated as relative to the camera position or not
 * @return YES/NO if there is a collision
 *
 * Normally you want to use RELATIVE as orientation, which
 * takes the camera coordinations in account.
 *
 * @code
 * #define ENEMY_GROUP 2
 * if (sgeStageSpriteGroupCollideSprite(myStage, ENEMY_GROUP, player, RELATIVE)) {
 *     // player hits enemy, start player die animation
 * }
 * @endcode
 */
int sgeStageSpriteGroupCollideSprite(SGESTAGE *s, int b, SGESPRITE *a, int orientation);

/**
 * @brief test if two sprite groups within a scene have a collision
 * @param s a pointer to @link SGESTAGE @endlink
 * @param a the index of the first @link SGESPRITEGROUP @endlink in s->spriteGroup
 * @param b the index of the second @link SGESPRITEGROUP @endlink in s->spriteGroup
 * @param orientation RELATIVE/ABSOLUTE if the sprite coordinates should be treated as relative to the camera position or not
 * @return YES/NO if there is a collision
 * @see sgeStageSpriteGroupCollideSprite
 */
int sgeStageSpriteGroupCollideSpriteGroup(SGESTAGE *s, int a, int b, int orientationa);

/**
 * @brief calculate thie position of a coordinate on screen within the stage
 * @param s a pointer to @link SGESTAGE @endlink
 * @param x the x position on the screen
 * @param y the y position on the screen
 * @return a pointer to @link SGEPOSITION @endlink
 * @see SGEPOSITION
 *
 * example:
 *
 * test where the mouseclick would end up in the stage
 *
 * @code
 *
 * SGEPOSITION *pos=sgeStageScreenToReal(myStage, mouseX, mouseY);
 * printf("you clicked on stage position %d,%d\n",pos->x, pos->y);
 * sgePositionDestroy(pos);
 *
 * @endcode
 */
SGEPOSITION *sgeStageScreenToReal(SGESTAGE *s, int x, int y);

// }@

#ifdef __cplusplus
}
#endif

#endif
