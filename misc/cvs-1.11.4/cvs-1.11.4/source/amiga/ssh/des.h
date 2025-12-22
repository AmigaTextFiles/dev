/*
 * DES / 3DES cipher structures and functions
 *
 * $Id$
 *
 * :ts=4
 */

#ifndef _DES_H
#define _DES_H

/****************************************************************************/

#ifdef _SSH
#define des_set_key			SSH_des_set_key
#define des_3cbc_encrypt	SSH_des_3cbc_encrypt
#define des_3cbc_decrypt	SSH_des_3cbc_decrypt
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	unsigned long k0246[16], k1357[16];
	unsigned long eiv0, eiv1;
	unsigned long div0, div1;
} DESCon;

/****************************************************************************/

void des_set_key(unsigned char *key, DESCon *sched);
void des_3cbc_encrypt(unsigned char *dest, const unsigned char *src, unsigned int len, DESCon *scheds);
void des_3cbc_decrypt(unsigned char *dest, const unsigned char *src, unsigned int len, DESCon *scheds);

/****************************************************************************/

#endif /* _DES_H */
