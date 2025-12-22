#ifndef _SGEMISC_H
#define _SGEMISC_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgemisc.h
 * @brief Miscellaneous helper functions
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeMisc
 * @brief Miscellaneous helper functions
 *
 * @{
 */

/**
 * @brief get the distance of two coordinates
 * @param x x position of point 1
 * @param y y position of point 1
 * @param XX x position of point 2
 * @param yy y position of point 2
 * @return the distance of the two points
 */
int sgeGetDistance(int x, int y, int xx, int yy);

/**
 * @brief get a md5 sum from data
 * @param data a unsigned char pointer to your data
 * @param datalen the length in bytes of your data
 * @returns a new allocated char * pointer representing the hex string of the md5
 *
 * example:
 *
 * @code
 * const char testtext[]="some text";
 *
 * char *md5=sgeMD5((const unsigned char *)testtext, (unsigned int) strlen(testtext));
 * printf("%s\n",md5);
 * sgeFree(md5);
 * @endcode
 */
char *sgeMD5(const unsigned char *data, unsigned int datalen);

/**
 * @brief get a sha1 hash from data
 * @param data a unsigned char pointer to your data
 * @param datalen the length in bytes of your data
 * @returns a new allocated char * pointer representing the hex string of the sha1
 *
 * example:
 *
 * @code
 * char *sha1=sgeSHA1((const unsigned char *)testtext, (unsigned int) strlen(testtext));
 * printf("%s\n",sha1);
 * sgeFree(sha1);
 * @endcode
 */
char *sgeSHA1(const unsigned char *data, unsigned int datalen);

// }@

#ifdef __cplusplus
}
#endif

#endif
