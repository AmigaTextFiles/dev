#ifndef _SGEPATHFINDER_H
#define _SGEPATHFINDER_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgepathfinder.h
 * @brief A* path finding
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgePathFinder
 * @brief A* path finding
 *
 * Finds the shortest route between two points in a n by n
 * grid.
 *
 * @{
 */

/**
 * @define disable diagonal movement
 */
#define DISABLE_DIAGONAL 0

/**
 * @define enable diagonal movement
 */
#define ENABLE_DIAGONAL 1

/**
 * @struct SGEPATHFINDERINFO
 * @brief holds information about a possible path
 *
 * Is used for internal calculations and to hold the final path positions
 */
typedef struct {
	/** @brief the x position in the data grid */
	int x;
	/** @brief the y position in the data grid */
	int y;
	/** @privatesection */
	int startWeight;
	int targetWeight;
	void *parent;
} SGEPATHFINDERINFO;

/**
 * @struct SGEPATHFINDER
 * @brief a pathfinder struct
 */
typedef struct {
	/** @brief The width of the grid */
	int width;
	/** @brief The height of the grid */
	int height;
	/** @privatesection */
	unsigned char *map;
	SGEARRAY *path;
	int useDiagonal;
} SGEPATHFINDER;

/**
 * @brief create a new path finder with a grid of width x height, diagonal movement enabled
 * @param width the width of the data grid
 * @param height the height of the data grid
 * @return a pointer to @link SGEPATHFINDER @endlink
 */
SGEPATHFINDER *sgePathFinderNew(int width, int height);

/**
 * @brief create a new path finder with a grid of width x height
 * @param width the width of the data grid
 * @param height the height of the data grid
 * @param diagonal YES/NO if there should be diagonal movement between the grid fields
 * @return a pointer to @link SGEPATHFINDER @endlink
 */
SGEPATHFINDER *sgePathFinderNewDiagonal(int width, int height, int diagonal);

/**
 * @brief destroy a @link SGEPATHFINDER @endlink
 * @param p a pointer to @link SGEPATHFINDER @endlink
 */
void sgePathFinderDestroy(SGEPATHFINDER *p);

/**
 * @brief create a new @link SGEPATHFINDERINFO @endlink
 * @param x the x position in the grid
 * @param y the y position in the grid
 * @param startWeight the weight to the start
 * @param targetWeight the weight to the target
 * @param parent the parent @link SGEPATHFINDERINFO @endlink
 * @return a pointer to @link SGEPATHFINDERINFO @endlink
 */
SGEPATHFINDERINFO *sgePathFinderInfoNew(int x, int y, int startWeight, int targetWeight, void *parent);

/**
 * @brief destroy a @link SGEPATHFINDERINFO @endlink
 * @param pi a pointer to @link SGEPATHFINDERINFO @endlink
 */
void sgePathFinderInfoDestroy(SGEPATHFINDERINFO *pi);

/**
 * @brief enable or disable diagonal movement
 * @param p a pointer to @link SGEPATHFINDER @endlink
 * @param diagonal YES/NO to enable of disable diagonal movement
 */
inline void sgePathFinderDiagonal(SGEPATHFINDER *p, int diagonal);

/**
 * @brief set a position in the data grid
 * @param p a pointer to @link SGEPATHFINDER @endlink
 * @param x the x position to set
 * @param y the y position to set
 * @param value 0 or 1 depending on if it is walkable or a obstacle
 */
void sgePathFinderSet(SGEPATHFINDER *p, int x, int y, int value);

/**
 * @brief get the value of a position in the data grid
 * @param p a pointer to @link SGEPATHFINDER @endlink
 * @param x the x position to get
 * @param y the y position to get
 * @return 0 if the position is walkable, 1 if there is a obstacle on it
 */
int sgePathFinderGet(SGEPATHFINDER *p, int x, int y);

/**
 * @brief find a path between two points on the datagrid
 * @param p a pointer to @link SGEPATHFINDER @endlink
 * @param startx the x position of the starting point
 * @param starty the y position of the starting point
 * @param destx the x position of the destination point
 * @param desty the y position of the destination point
 * @return YES/NO depending if there was a solution possible
 *
 * The resulting path, if there was one, is saved as a @link SGEARRAY @endlink
 * of @link SGEPATHFINDERINFO @endlink structures.
 */
int sgePathFinderFind(SGEPATHFINDER *p, int startx, int starty, int destx, int desty);

// }@

#ifdef __cplusplus
}
#endif

#endif
