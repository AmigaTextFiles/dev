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

#ifdef _SSH
#define blowfish_encrypt_cbc	SSH_blowfish_encrypt_cbc
#define blowfish_decrypt_cbc	SSH_blowfish_decrypt_cbc
#define blowfish_setkey			SSH_blowfish_setkey
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	unsigned long S0[256], S1[256], S2[256], S3[256], P[18];
	unsigned long biv0, biv1; /* for CBC mode */
} BlowfishContext;

#define SSH_SESSION_KEY_LENGTH	32

/****************************************************************************/

void blowfish_encrypt_cbc(unsigned char *blk, int len, BlowfishContext *ctx);
void blowfish_decrypt_cbc(unsigned char *blk, int len, BlowfishContext *ctx);
void blowfish_setkey(BlowfishContext *ctx, const unsigned char *key, short keybytes);

/****************************************************************************/

#endif /* _BLOWFISH_H */
