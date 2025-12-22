/*
 * Blowfish cipher structures and functions
 *
 * $Id$
 *
 * :ts=4
 */

#ifndef _BLOWFISH_H
#define _BLOWFISH_H

/****************************************************************************/

#include <stdint.h>

/****************************************************************************/

#ifdef _SSH
#define blowfish_encrypt_cbc	SSH_blowfish_encrypt_cbc
#define blowfish_decrypt_cbc	SSH_blowfish_decrypt_cbc
#define blowfish_setkey			SSH_blowfish_setkey
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	uint32_t S0[256], S1[256], S2[256], S3[256], P[18];
	uint32_t biv0, biv1; /* for CBC mode */
} BlowfishContext;

#define SSH_SESSION_KEY_LENGTH	32

/****************************************************************************/

void blowfish_encrypt_cbc(uint8_t *blk, int len, BlowfishContext *ctx);
void blowfish_decrypt_cbc(uint8_t *blk, int len, BlowfishContext *ctx);
void blowfish_setkey(BlowfishContext *ctx, const uint8_t *key, short keybytes);

/****************************************************************************/

#endif /* _BLOWFISH_H */
