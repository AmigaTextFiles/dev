/*
 * $Id$
 *
 * :ts=4
 */

#ifndef _SSH_PROTOCOL_H
#define _SSH_PROTOCOL_H

/****************************************************************************/

#include <stdint.h>

/****************************************************************************/

#include "ssh.h"
#include "des.h"
#include "blowfish.h"

/****************************************************************************/

struct ssh_protocol_context
{
	int				spc_Socket;
	struct Packet	spc_PacketIn;
	struct Packet	spc_PacketOut;
	uint8_t			spc_InBuf[INBUF_SIZE];
	int				spc_UseCipher;
	int				spc_CipherType;
	DESCon			spc_Keys[3];
	BlowfishContext	spc_EncryptContext;
	BlowfishContext	spc_DecryptContext;
	int				spc_BytesLeft;
	uint8_t *		spc_Ptr;
};

/****************************************************************************/

void ssh_disconnect(struct ssh_protocol_context *spc);
struct ssh_protocol_context *ssh_connect(char *remote_host_name, int port_number, char *user_name, char *password, int cipher_type);
int ssh_execute_cmd(struct ssh_protocol_context *spc,char *command);
int ssh_write(struct ssh_protocol_context *spc, void *data, int len);
int ssh_read(struct ssh_protocol_context *spc, void *data, int len);

/****************************************************************************/

#endif /* _SSH_PROTOCOL_H */
