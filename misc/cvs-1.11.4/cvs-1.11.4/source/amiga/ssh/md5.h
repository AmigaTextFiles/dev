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

#ifdef _SSH
#define MD5Init		SSH_MD5Init
#define MD5Update	SSH_MD5Update
#define MD5Final	SSH_MD5Final
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	unsigned long h[4];
} MD5_Core_State;

typedef struct MD5Context
{
	MD5_Core_State core;
	unsigned char block[64];
	int blkused;
	unsigned long lenhi, lenlo;
} MD5Context;

/****************************************************************************/

void MD5Init(struct MD5Context *s);
void MD5Update(struct MD5Context *s, unsigned char const *p, unsigned len);
void MD5Final(unsigned char output[16], struct MD5Context *s);

/****************************************************************************/

#endif /* _MD5_H */
