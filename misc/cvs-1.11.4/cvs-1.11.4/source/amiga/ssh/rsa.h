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

#ifdef _SSH
#define makekey		SSH_makekey
#define rsaencrypt	SSH_rsaencrypt
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	unsigned int bits;
	unsigned int bytes;
	void *modulus;
	void *exponent;
} R_RSAKey;

/****************************************************************************/

int makekey(unsigned char *data, R_RSAKey *result, unsigned char **keystr);
void rsaencrypt(unsigned char *data, int length, R_RSAKey *key);

/****************************************************************************/

#endif /* _RSA_H */
