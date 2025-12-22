/*
 * MD5 hash structures and functions
 *
 * $Id$
 *
 * :ts=4
 */

#ifndef _MD5_H
#define _MD5_H

/****************************************************************************/

#include <stdint.h>

/****************************************************************************/

#ifdef _SSH
#define MD5Init		SSH_MD5Init
#define MD5Update	SSH_MD5Update
#define MD5Final	SSH_MD5Final
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	uint32_t h[4];
} MD5_Core_State;

typedef struct MD5Context
{
	MD5_Core_State core;
	uint8_t block[64];
	int blkused;
	uint32_t lenhi, lenlo;
} MD5Context;

/****************************************************************************/

void MD5Init(struct MD5Context *s);
void MD5Update(struct MD5Context *s, uint8_t const *p, unsigned len);
void MD5Final(uint8_t output[16], struct MD5Context *s);

/****************************************************************************/

#endif /* _MD5_H */
