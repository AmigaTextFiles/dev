/*
 * RSA key structure
 *
 * $Id$
 *
 * :ts=4
 */

#ifndef _RSA_H
#define _RSA_H

/****************************************************************************/

#include <stdint.h>

/****************************************************************************/

#ifdef _SSH
#define freekey		SSH_freekey
#define makekey		SSH_makekey
#define rsaencrypt	SSH_rsaencrypt
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	uint32_t bits;
	uint32_t bytes;
	void *modulus;
	void *exponent;
} R_RSAKey;

/****************************************************************************/

void freekey(R_RSAKey * key);
int makekey(uint8_t *data, R_RSAKey *result, uint8_t **keystr);
int rsaencrypt(uint8_t *data, int length, R_RSAKey *key);

/****************************************************************************/

#endif /* _RSA_H */
