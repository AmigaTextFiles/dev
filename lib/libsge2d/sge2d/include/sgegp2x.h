#ifndef _GPEGP2X_H
#define _GPEGP2X_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgegp2x.h
 * @brief gp2x defines
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeGp2x
 * @brief gp2x defines
 *
 * Defines for handling gpx2 user input, usually only for interal use
 *
 * @{
 */

// original gp2x defines
enum MAP_KEY {
	VK_UP         , // 0
	VK_UP_LEFT    , // 1
	VK_LEFT       , // 2
	VK_DOWN_LEFT  , // 3
	VK_DOWN       , // 4
	VK_DOWN_RIGHT , // 5
	VK_RIGHT      , // 6
	VK_UP_RIGHT   , // 7
	VK_START      , // 8
	VK_SELECT     , // 9
	VK_FL         , // 10
	VK_FR         , // 11
	VK_FA         , // 12
	VK_FB         , // 13
	VK_FX         , // 14
	VK_FY         , // 15
	VK_VOL_UP     , // 16
	VK_VOL_DOWN   , // 17
	VK_TAT          // 18
};

// }@

#ifdef __cplusplus
}
#endif

#endif
