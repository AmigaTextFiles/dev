/*
 * RSA key structure
 *
 */

#ifndef _RSA_H
#define _RSA_H

/****************************************************************************/

#ifdef _SSH
#define freekey		SSH_freekey
#define makekey		SSH_makekey
#define rsaencrypt	SSH_rsaencrypt
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	unsigned long bits;
	unsigned long bytes;
	void *modulus;
	void *exponent;
} R_RSAKey;

/****************************************************************************/

void freekey(R_RSAKey * key);
int makekey(unsigned char *data, R_RSAKey *result, unsigned char **keystr);
int rsaencrypt(unsigned char *data, int length, R_RSAKey *key);

/****************************************************************************/

#endif /* _RSA_H */
