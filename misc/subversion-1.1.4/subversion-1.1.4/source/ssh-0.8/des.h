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

#include <stdint.h>

/****************************************************************************/

#ifdef _SSH
#define des_set_key			SSH_des_set_key
#define des_3cbc_encrypt	SSH_des_3cbc_encrypt
#define des_3cbc_decrypt	SSH_des_3cbc_decrypt
#endif /* _SSH */

/****************************************************************************/

typedef struct
{
	uint32_t k0246[16], k1357[16];
	uint32_t eiv0, eiv1;
	uint32_t div0, div1;
} DESCon;

/****************************************************************************/

void des_set_key(uint8_t *key, DESCon *sched);
void des_3cbc_encrypt(uint8_t *dest, const uint8_t *src, unsigned int len, DESCon *scheds);
void des_3cbc_decrypt(uint8_t *dest, const uint8_t *src, unsigned int len, DESCon *scheds);

/****************************************************************************/

#endif /* _DES_H */
