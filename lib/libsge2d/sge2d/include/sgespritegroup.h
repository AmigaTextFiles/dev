#ifndef _SGESPRITEGROUP_H
#define _SGESPRITEGROUP_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgespritegroup.h
 * @brief Sprite groups
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeSpriteGroup
 * @brief Sprite groups
 *
 * Functions to handle sprites in groups, for
 * example for group drawing or group colliding.
 *
 * @{
 */

/**
 * @struct SGESPRITEGROUP
 * @brief holds a @link SGEARRAY @endlink with all sprites of the group
 */
typedef struct {
	/** @brief a @link SGEARRAY @endlink with all the sprites of the group */
	SGEARRAY *sprite;
} SGESPRITEGROUP;

/**
 * @brief creates a new empty spritegroup
 * @return a pointer to @link SGESPRITEGROUP @endlink
 */
SGESPRITEGROUP *sgeSpriteGroupNew(void);

/**
 * @brief destroy a spritegroup and free resources
 * @param g pointer to @link SGESPRITEGROUP @endlink
 */
void sgeSpriteGroupDestroy(SGESPRITEGROUP *g);

/**
 * @brief adds a sprite to the group
 * @param g pointer to @link SGESPRITEGROUP @endlink
 * @param g pointer to @link SGESPRITE @endlink
 */
void sgeSpriteGroupAddSprite(SGESPRITEGROUP *g, SGESPRITE *s);

/**
 * @brief checks if two sprite groups collide anywhere
 * @param g pointer to the first @link SGESPRITEGROUP @endlink
 * @param cg pointer to the second @link SGESPRITEGROUP @endlink
 * @return YES/NO if any sprite of group g collides any sprite of group cg
 */
int sgeSpriteGroupCollide(SGESPRITEGROUP *g, SGESPRITEGROUP *cg);

/**
 * @brief checks if a sprite collides a sprite group
 * @param g pointer to the @link SGESPRITEGROUP @endlink
 * @param s pointer to the @link SGESPRITE @endlink
 * @return YES/NO if sprite s collides with any sprite in group g
 *
 * This is a simple way for example to check of the player collides with
 * any opponent.
 */
int sgeSpriteGroupCollideSprite(SGESPRITEGROUP *g, SGESPRITE *s);

/**
 * @brief get the first sprite of group g which collides with group cg
 * @param g pointer to the first @link SGESPRITEGROUP @endlink
 * @param cg pointer to the second @link SGESPRITEGROUP @endlink
 * @return a pointer to @link SGESPRITE @endlink from group g which collides group cg, or NULL if there is none
 */
SGESPRITE *sgeSpriteGroupGetCollider(SGESPRITEGROUP *g, SGESPRITEGROUP *cg);

/**
 * @brief get the first sprite of group g which collides with sprite s
 * @param g pointer to the first @link SGESPRITEGROUP @endlink
 * @param s pointer to the @link SGESPRITE @endlink
 * @return a pointer to @link SGESPRITE @endlink from group g which collides with sprite s, or NULL if there is none
 */
SGESPRITE *sgeSpriteGroupGetColliderSprite(SGESPRITEGROUP *g, SGESPRITE *s);

/**
 * @brief draw a complete sprite group to the screen
 * @param g pointer to the first @link SGESPRITEGROUP @endlink
 */
void sgeSpriteGroupDraw(SGESPRITEGROUP *g);

/**
 * @brief draw a complete sprite group to the screen, relative to a 'camera' position
 * @param g pointer to the first @link SGESPRITEGROUP @endlink
 * @param camx the x coordinate of the camera
 * @param camy the y coordinate of the camera
 */
void sgeSpriteGroupDrawRelative(SGESPRITEGROUP *g, int camx, int camy);

// }@

#ifdef __cplusplus
}
#endif

#endif
