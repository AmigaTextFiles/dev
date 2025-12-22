/*
 * $Id$
 *
 * :ts=4
 *
 * This implementation is based upon the 'dossh' code which is
 * Copyright (c) 2000 by Nagy Daniel. It was 'condensed' and
 * adapted for use with the Amiga port of CVS 1.11 by
 * Olaf Barthel <obarthel@gmx.net> and
 * Jens Langner <Jens.Langner@light-speed.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 */

#include <sys/select.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <errno.h>

/****************************************************************************/

#include "ssh.h"
#include "md5.h"
#include "rsa.h"
#include "des.h"
#include "crc.h"
#include "macros.h"
#include "blowfish.h"
#include "ssh_protocol.h"

/****************************************************************************/

#define SSH_VERSION "0.8"

/****************************************************************************/

static int recv_all(int socket, void *data, int len);
static int sock_gets(int sock, char *buf, int n);
static int check_emulation(int remote_major, int remote_minor, int *return_major, int *return_minor);
static int exchange_identification(struct ssh_protocol_context *spc);
static int create_keys(struct ssh_protocol_context *spc);
static int send_password(struct ssh_protocol_context *spc, char *password);
static int set_maximum_packet_size(struct ssh_protocol_context *spc);
static int convert_received_data(struct ssh_protocol_context *spc);
static void prepare_packet_header(struct ssh_protocol_context *spc, int type, int len);
static int write_packet(struct ssh_protocol_context *spc);
static int read_packet(struct ssh_protocol_context *spc);
static int read_packet_and_check_type(struct ssh_protocol_context *spc, int type);
static int send_ssh_data(struct ssh_protocol_context *spc, int type, void *data, int len);

/****************************************************************************/

/* Parameters of a pseudo-random-number generator from Knuth's
 * "The Art of Computer Programming, Volume 2: Seminumerical
 *  Algorithms" (3rd edition), pp. 185-186.
 */
#define MM 2147483647	/* a Mersenne prime */
#define AA 48271		/* this does well in the spectral test */
#define QQ 44488		/* (int32_t)(MM/AA) */
#define RR 3399			/* MM % AA; it is important that RR < QQ */

int32_t
get_random_number(void)
{
	static int32_t X;

	/* This seeds the random number generator; X is never zero. */
	if(X == 0)
		X = (int32_t)time(NULL);

	X = AA * (X % QQ) - RR * (int32_t)(X / QQ);
	if(X < 0)
		X += MM;

	return(X);
}

/****************************************************************************/

/* A variation of 'recv()' which will attempt to satisfy the
 * entire read request.
 */
static int
recv_all(int socket,void * data,int len)
{
	uint8_t * m = data;
	int total = 0;
	int n;

	while(len > 0)
	{
		n = recv(socket,m,len,0);
		if(n < 0)
		{
			total = n;
			break;
		}
		else if(n == 0)
		{
			break;
		}

		m += n;
		len -= n;
		total += n;
	}

	return(total);
}

/****************************************************************************/

/* Similar to 'fgets()', but operates on a socket. */
static int
sock_gets(int sock, char *buf, int n)
{
	int result = 0;
	int len;
	char c;

	n--;
	while(n > 0)
	{
		len = recv(sock, &c, 1, 0);
		if(len > 0)
		{
			(*buf++) = c;
			result++;
			n--;

			if(c == '\n')
				break;
		}
		else
		{
			break;
		}
	}

	(*buf) = '\0';

	return(result);
}

/****************************************************************************/

/* check_emulation: take the remote party's version number as
 * arguments and return our possibly modified version number back
 * (relevant only for clients).
 *
 * Return values:
 * EMULATE_VERSION_OK means we can work together
 *
 * EMULATE_VERSION_TOO_OLD if the other party has too old version
 * which we cannot emulate,
 *
 * EMULATE_MAJOR_VERSION_MISMATCH if the other party has different
 * major version and thus will probably not understand anything we
 * say, and
 *
 * EMULATE_VERSION_NEWER if the other party has never code than we
 * have.
 */
static int
check_emulation(int remote_major, int remote_minor, int *return_major, int *return_minor)
{
	(*return_major) = PROTOCOL_MAJOR;

	if(remote_major == PROTOCOL_MAJOR && remote_minor < PROTOCOL_MINOR)
		(*return_minor) = remote_minor;
	else
		(*return_minor) = PROTOCOL_MINOR;

	if(remote_major < PROTOCOL_MAJOR)
	{
		return(EMULATE_MAJOR_VERSION_MISMATCH);
	}
	else if (remote_major == 1 && remote_minor == 0)
	{
		return(EMULATE_VERSION_TOO_OLD);  /* We no longer support 1.0. */
	}
	else if (remote_major > PROTOCOL_MAJOR || (remote_major == PROTOCOL_MAJOR && remote_minor > PROTOCOL_MINOR))
	{
		/* The remote software is newer than we. If we are the client,
		 * no matter - the server will decide. If we are the server, we
		 * cannot emulate a newer client and decide to stop.
		 */
		return(EMULATE_VERSION_NEWER);
	}
	else
	{
		return(EMULATE_VERSION_OK);
	}
}

/****************************************************************************/

/* SSH version string exchange */
static int
exchange_identification(struct ssh_protocol_context *spc)
{
	char buf[256];
	int remote_major, remote_minor, n;
	int my_major, my_minor;
	int result = -1;
	int len;

	/* Read other side's version identification. */
	n = sock_gets(spc->spc_Socket, buf, sizeof(buf));
	if(n == 0)
	{
		fprintf(stderr,"SSH: Bad remote protocol identification.\n");
		goto out;
	}

	/* Check that the versions match.  In future this might accept several
	 * versions and set appropriate flags to handle them.
	 */
	if(sscanf(buf, "SSH-%d.%d", &remote_major, &remote_minor) != 2)
	{
		fprintf(stderr,"SSH: Bad remote protocol version identification.\n");
		goto out;
	}

	switch(check_emulation(remote_major, remote_minor, &my_major, &my_minor))
	{
		case EMULATE_VERSION_TOO_OLD:

			/* Remote machine has too old SSH software version */
			fprintf(stderr,"SSH: Remote secure shell version %d.%d is too old.\n",remote_major,remote_major);
			goto out;

		case EMULATE_MAJOR_VERSION_MISMATCH:

			/* Major protocol versions incompatible */
			fprintf(stderr,"SSH: Major secure shell version %d.%d is incompatible with local implementation.\n",remote_major,remote_major);
			goto out;

		case EMULATE_VERSION_NEWER:

			/* We will emulate the old version. */
			break;

		case EMULATE_VERSION_OK:

			break;
	}

	sprintf(buf, "SSH-%d.%d-%s\n", my_major, my_minor, SSH_VERSION);

	len = strlen(buf);

	n = send(spc->spc_Socket, buf, len, 0);
	if(n != len)
	{
		fprintf(stderr,"SSH: Error sending protocol identification (%d, %s).\n",errno,strerror(errno));
		result = n;
		goto out;
	}

	/* Wait for a public key packet from the server. */
	n = read_packet_and_check_type(spc,SSH_SMSG_PUBLIC_KEY);
	if(n == -2)
	{
		fprintf(stderr,"SSH: Corrupt packet data received.\n");
		result = -1;
		goto out;
	}
	else if (n != 0)
	{
		fprintf(stderr,"SSH: Error reading public key packet");

		if(n == -1 && errno != 0)
			fprintf(stderr," (%d, %s)",errno,strerror(errno));

		fprintf(stderr,".\n");

		result = n;
		goto out;
	}

	result = 0;

 out:

	return(result);
}

/****************************************************************************/

/* create session key and ID */
static int
create_keys(struct ssh_protocol_context *spc)
{
	int i, n, len;
	uint8_t session_key[32];
	uint8_t session_id[16];
	uint8_t *RSAblock = NULL, *keystr1, *keystr2;
	uint8_t cookie[8];
	R_RSAKey servkey, hostkey;
	MD5Context md5c;
	int result = 0;

	memset(&servkey,0,sizeof(servkey));
	memset(&hostkey,0,sizeof(hostkey));

	memcpy(cookie, spc->spc_PacketIn.body, 8);

	i = makekey(spc->spc_PacketIn.body + 8, &servkey, &keystr1);
	if(i < 0)
	{
		/* Out of memory */
		fprintf(stderr,"SSH: Not enough memory to create RSA server key.\n");

		result = -1;
		goto out;
	}

	if(makekey(spc->spc_PacketIn.body + 8 + i, &hostkey, &keystr2) < 0)
	{
		/* Out of memory */
		fprintf(stderr,"SSH: Not enough memory to create RSA host key.\n");

		result = -1;
		goto out;
	}

	MD5Init(&md5c);
	MD5Update(&md5c, keystr2, hostkey.bytes);
	MD5Update(&md5c, keystr1, servkey.bytes);
	MD5Update(&md5c, cookie, 8);
	MD5Final(session_id, &md5c);

	for(i = 0; i < 32; i++)
		session_key[i] = get_random_number() % 256;

	len = (hostkey.bytes > servkey.bytes ? hostkey.bytes : servkey.bytes);

	RSAblock = malloc(len);
	if(RSAblock == NULL)
	{
		/* Out of memory */
		fprintf(stderr,"SSH: Not enough memory for RSA key.\n");

		result = -1;
		goto out;
	}

	memset(RSAblock, 0, len);

	for(i = 0; i < 32; i++)
	{
		RSAblock[i] = session_key[i];
		if(i < 16)
			RSAblock[i] ^= session_id[i];
	}

	if(hostkey.bytes > servkey.bytes)
	{
		rsaencrypt(RSAblock, 32, &servkey);
		rsaencrypt(RSAblock, servkey.bytes, &hostkey);
	}
	else
	{
		rsaencrypt(RSAblock, 32, &hostkey);
		rsaencrypt(RSAblock, hostkey.bytes, &servkey);
	}

	prepare_packet_header(spc, SSH_CMSG_SESSION_KEY, len + 15);
	spc->spc_PacketOut.body[0] = spc->spc_CipherType;
	memcpy(spc->spc_PacketOut.body + 1, cookie, 8);
	spc->spc_PacketOut.body[9] = (len * 8) >> 8;
	spc->spc_PacketOut.body[10] = (len * 8) & 0xFF;
	memcpy(spc->spc_PacketOut.body + 11, RSAblock, len);
	spc->spc_PacketOut.body[len + 11] = spc->spc_PacketOut.body[len + 12] = 0;
	spc->spc_PacketOut.body[len + 13] = spc->spc_PacketOut.body[len + 14] = 0;

	n = write_packet(spc);
	if(n != 0)
	{
		fprintf(stderr,"SSH: Error sending public key packet (%d, %s).\n",errno,strerror(errno));

		result = n;
		goto out;
	}

	free(RSAblock);
	RSAblock = NULL;

	switch(spc->spc_CipherType)
	{
		case SSH_CIPHER_3DES:

			des_set_key(session_key, &spc->spc_Keys[0]);
			des_set_key(session_key + 8, &spc->spc_Keys[1]);
			des_set_key(session_key + 16, &spc->spc_Keys[2]);

			break;

		case SSH_CIPHER_BLOWFISH:

			blowfish_setkey(&spc->spc_EncryptContext, session_key, SSH_SESSION_KEY_LENGTH);
			spc->spc_EncryptContext.biv0 = 0;
			spc->spc_EncryptContext.biv1 = 0;
			spc->spc_DecryptContext = spc->spc_EncryptContext;

			break;
	}

	spc->spc_UseCipher = TRUE;

	/* Wait for key confirmation */
	n = read_packet_and_check_type(spc,SSH_SMSG_SUCCESS);
	if(n == -2)
	{
		fprintf(stderr,"SSH: Corrupt packet data received.\n");

		result = -1;
		goto out;
	}

	if(n != 0)
	{
		fprintf(stderr,"SSH: Remote failed to accept key exchange information (%d, %s).\n",errno,strerror(errno));

		result = n;
		goto out;
	}

 out:

	freekey(&servkey);
	freekey(&hostkey);

	if(RSAblock != NULL)
		free(RSAblock);

	return(result);
}

/****************************************************************************/

/* Send password and look at the response. */
static int
send_password(struct ssh_protocol_context *spc,char *password)
{
	int result;
	int n;

	n = send_ssh_data(spc,SSH_CMSG_AUTH_PASSWORD,password,strlen(password));
	if(n < 0)
	{
		fprintf(stderr,"SSH: Error sending password (%d, %s).\n",errno,strerror(errno));
		result = n;
		goto out;
	}

	n = read_packet_and_check_type(spc,SSH_SMSG_SUCCESS);
	if(n == -2)
	{
		fprintf(stderr,"SSH: Corrupt packet data received.\n");
		result = -1;
		goto out;
	}
	else if (n != 0)
	{
		fprintf(stderr,"SSH: Remote failed to accept password (%d, %s).\n",errno,strerror(errno));
		result = n;
		goto out;
	}

	result = 0;

 out:

	return(result);
}

/****************************************************************************/

static int
set_maximum_packet_size(struct ssh_protocol_context *spc)
{
	int size = sizeof(spc->spc_InBuf);
	int result = 0;
	int n;

	prepare_packet_header(spc,SSH_CMSG_MAX_PACKET_SIZE,4);

	spc->spc_PacketOut.body[0] = 0;
	spc->spc_PacketOut.body[1] = 0;
	spc->spc_PacketOut.body[2] = size >> 8;
	spc->spc_PacketOut.body[3] = size & 0xFF;

	n = write_packet(spc);
	if(n != 0)
	{
		fprintf(stderr,"SSH: Failed to send packet size configuration packet (%d, %s).\n",errno,strerror(errno));
		result = n;
		goto out;
	}

	n = read_packet_and_check_type(spc,SSH_SMSG_SUCCESS);
	if(n == -2)
	{
		fprintf(stderr,"SSH: Corrupt packet data received.\n");
		result = -1;
		goto out;
	}
	else if (n != 0)
	{
		fprintf(stderr,"SSH: Remote failed to accept packet size (%d, %s).\n",errno,strerror(errno));
		result = n;
		goto out;
	}

 out:

	return(result);
}

/****************************************************************************/

void
ssh_disconnect(struct ssh_protocol_context *spc)
{
	if(spc != NULL)
	{
		if(spc->spc_Socket != -1)
			close(spc->spc_Socket);

		free(spc);
	}
}

/****************************************************************************/

struct ssh_protocol_context *
ssh_connect(char *remote_host_name,int port_number,char *user_name,char *password,int cipher_type)
{
	struct ssh_protocol_context *result = NULL;
	struct ssh_protocol_context *spc;
	struct sockaddr_in sin;
	struct hostent *phe;
	int n;

	spc = malloc(sizeof(*spc));
	if(spc == NULL)
	{
		fprintf(stderr,"SSH: Not enough memory for connection information.\n");
		/* Not enough memory */
		goto out;
	}

	memset(spc,0,sizeof(*spc));

	spc->spc_CipherType = cipher_type;
	spc->spc_UseCipher = FALSE;

	spc->spc_Socket = socket(AF_INET, SOCK_STREAM, 0);
	if(spc->spc_Socket < 0)
	{
		fprintf(stderr,"SSH: Could not create socket (%d, %s).\n",errno,strerror(errno));
		/* Could not create socket */
		goto out;
	}

	memset(&sin, 0, sizeof(sin));

	sin.sin_family = AF_INET;
	sin.sin_port = htons(port_number);

	phe = gethostbyname(remote_host_name);
	if(phe != NULL)
	{
		int i;

		for(i = 0 ; phe->h_addr_list[i] != NULL ; i++)
		{
			memcpy(&sin.sin_addr, phe->h_addr_list[i], phe->h_length);

			if(connect(spc->spc_Socket,(struct sockaddr *) &sin, sizeof(sin)) == 0)
				break;
		}

		if(phe->h_addr_list[i] == NULL)
		{
			fprintf(stderr,"SSH: Could not connect socket (%d, %s).\n",errno,strerror(errno));
			/* Unable to open connection */
			goto out;
		}
	}
	else
	{
		sin.sin_addr.s_addr = inet_addr(remote_host_name);
		if(sin.sin_addr.s_addr == INADDR_NONE)
		{
			fprintf(stderr,"SSH: Could not resolve host name '%s'.\n",remote_host_name);
			/* Cannot resolve this host name */
			goto out;
		}

		if(connect(spc->spc_Socket,(struct sockaddr *) &sin, sizeof(sin)) < 0)
		{
			fprintf(stderr,"SSH: Could not connect socket (%d, %s).\n",errno,strerror(errno));
			/* Unable to open connection */
			goto out;
		}
	}

	/* Start negotiation on network */
	n = exchange_identification(spc);
	if(n != 0)
		goto out;

	/* Create SSH keys */
	n = create_keys(spc);
	if(n != 0)
		goto out;

	/* Send the user name. */
	n = send_ssh_data(spc,SSH_CMSG_USER,user_name,strlen(user_name));
	if(n < 0)
	{
		fprintf(stderr,"SSH: Could not send user name (%d, %s).\n",errno,strerror(errno));
		goto out;
	}

	n = read_packet(spc);
	if(n == -2)
	{
		fprintf(stderr,"SSH: Corrupt packet data received.\n");
		goto out;
	}
	else if (n < 0)
	{
		fprintf(stderr,"SSH: Could not read response to user name (%d, %s).\n",errno,strerror(errno));
		goto out;
	}

	switch(spc->spc_PacketIn.type)
	{
		case SSH_SMSG_SUCCESS:	/* no authentication needed */

			break;

		case SSH_SMSG_FAILURE:	/* send password */

			n = send_password(spc,password);
			if(n != 0)
				goto out;

			break;

		default:

			/* Invalid packet received. */
			goto out;
	}

	n = set_maximum_packet_size(spc);
	if(n != 0)
		goto out;

	result = spc;

 out:

	if(result == NULL)
		ssh_disconnect(spc);

	return(result);
}

/****************************************************************************/

/* Convert raw, encrypted packet to readable structure,
 * return type of packet received.
 */
static int
convert_received_data(struct ssh_protocol_context *spc)
{
	uint8_t *data = spc->spc_InBuf;
	uint32_t crc;
	int32_t len, biglen;
	int i, pad;
	int result;

	for(i = len = 0; i < 4; i++)
		len = (len << 8) + data[i];

	pad = 8 - (len % 8);
	biglen = len + pad;

	spc->spc_PacketIn.length = biglen - 4 - pad;

	if(spc->spc_UseCipher)
	{
		switch(spc->spc_CipherType)
		{
			case SSH_CIPHER_3DES:

				des_3cbc_decrypt(data + 4, data + 4, biglen, spc->spc_Keys);
				break;

			case SSH_CIPHER_BLOWFISH:

				blowfish_decrypt_cbc(data + 4, biglen, &spc->spc_DecryptContext);
				break;
		}
	}

	for(i = crc = 0; i < 4; i++)
		crc = (crc << 8) + data[biglen + i];

	if(crc == ssh_crc32(data + 4, biglen - 4))
	{
		memcpy(spc->spc_PacketIn.data, data + 4, biglen);

		spc->spc_PacketIn.type = spc->spc_PacketIn.data[pad];
		spc->spc_PacketIn.body = spc->spc_PacketIn.data + pad + 1;

		result = spc->spc_PacketIn.type;
	}
	else
	{
		/* Packet checksum does not match packet data! */
		result = -1;
	}

	return(result);
}

/****************************************************************************/

/* create header for raw outgoing packet */
static void 
prepare_packet_header(struct ssh_protocol_context *spc, int type, int len)
{
	int pad;

	len += 5; /* type and CRC */
	pad = 8 - (len % 8);

	spc->spc_PacketOut.length = len - 5;

	spc->spc_PacketOut.type = type;
	spc->spc_PacketOut.body = spc->spc_PacketOut.data + 4 + pad + 1;
}

/****************************************************************************/

/* create outgoing packet */
static int
write_packet(struct ssh_protocol_context *spc)
{
	int pad, len, biglen, n, i;
	uint32_t crc;
	int result = 0;

	len = spc->spc_PacketOut.length + 5; /* type and CRC */
	pad = 8 - (len % 8);
	biglen = len + pad;

	spc->spc_PacketOut.body[-1] = spc->spc_PacketOut.type;
	for(i = 0; i < pad; i++)
		spc->spc_PacketOut.data[i + 4] = get_random_number() % 256;

	crc = ssh_crc32(spc->spc_PacketOut.data + 4, biglen - 4);

	spc->spc_PacketOut.data[biglen + 0] = (uint8_t) ((crc >> 24) & 0xFF);
	spc->spc_PacketOut.data[biglen + 1] = (uint8_t) ((crc >> 16) & 0xFF);
	spc->spc_PacketOut.data[biglen + 2] = (uint8_t) ((crc >>  8) & 0xFF);
	spc->spc_PacketOut.data[biglen + 3] = (uint8_t) ( crc        & 0xFF);

	spc->spc_PacketOut.data[0] = (len >> 24) & 0xFF;
	spc->spc_PacketOut.data[1] = (len >> 16) & 0xFF;
	spc->spc_PacketOut.data[2] = (len >>  8) & 0xFF;
	spc->spc_PacketOut.data[3] =  len        & 0xFF;

	if(spc->spc_UseCipher)
	{
		switch(spc->spc_CipherType)
		{
			case SSH_CIPHER_3DES:

				des_3cbc_encrypt(spc->spc_PacketOut.data + 4, spc->spc_PacketOut.data + 4, biglen, spc->spc_Keys);
				break;

			case SSH_CIPHER_BLOWFISH:

				blowfish_encrypt_cbc(spc->spc_PacketOut.data + 4, biglen, &spc->spc_EncryptContext);
				break;
		}
	}

	n = send(spc->spc_Socket, spc->spc_PacketOut.data, biglen + 4, 0);
	if(n != biglen + 4)
		result = n;

	return(result);
}

/****************************************************************************/

/* Read a packet with blocking */
static int 
read_packet(struct ssh_protocol_context *spc)
{
	int result = 0;
	int biglen;
	int type;
	int len;
	int n;
	int i;

	do
	{
		n = recv_all(spc->spc_Socket, spc->spc_InBuf, 4);
		if(n != 4)
		{
			result = n;
			break;
		}

		for(i = len = 0; i < 4; i++)
			len = (len << 8) + spc->spc_InBuf[i];  /* Get packet size */

		biglen = len + 8 - (len % 8);

		n = recv_all(spc->spc_Socket, spc->spc_InBuf + 4, biglen);  /* Read it */
		if(n != biglen)
		{
			result = n;
			break;
		}

		type = convert_received_data(spc);
		if(type < 0)
		{
			result = -2;
			break;
		}
		else if (type == SSH_MSG_DISCONNECT)
		{
			errno = 0;
			result = -1;
			break;
		}
	}
	while(spc->spc_PacketIn.type == SSH_MSG_DEBUG ||
	      spc->spc_PacketIn.type == SSH_MSG_IGNORE);

	return(result);
}

/****************************************************************************/

/* Read a packet and check its type against the one expected. */
static int
read_packet_and_check_type(struct ssh_protocol_context *spc,int type)
{
	int n;

	n = read_packet(spc);
	if(n == 0)
	{
		if(spc->spc_PacketIn.type != type) /* Invalid answer from server */
		{
			errno = EACCES;
			n = -1;
		}
	}

	return(n);
}

/****************************************************************************/

/* Send data using the SSH protocol, in several steps if necessary. */
static int
send_ssh_data(struct ssh_protocol_context *spc,int type,void *data,int len)
{
	uint8_t * m = data;
	int total = 0;
	int l,n;

	while(len > 0)
	{
		if(len > (int)sizeof(spc->spc_InBuf)-(4+8+1+4))
			n = sizeof(spc->spc_InBuf)-(4+8+1+4);
		else
			n = len;

		prepare_packet_header(spc,type,n+4);

		spc->spc_PacketOut.body[0] = (n >> 24) & 0xFF;
		spc->spc_PacketOut.body[1] = (n >> 16) & 0xFF;
		spc->spc_PacketOut.body[2] = (n >>  8) & 0xFF;
		spc->spc_PacketOut.body[3] =  n        & 0xFF;

		memcpy(&spc->spc_PacketOut.body[4],m,n);

		l = write_packet(spc);
		if(l < 0)
		{
			total = l;
			break;
		}

		total += n;
		len -= n;
		m += n;
	}

	return(total);
}

/****************************************************************************/

int
ssh_execute_cmd(struct ssh_protocol_context *spc,char *command)
{
	int result;
	int len;

	if(command != NULL)
		len = strlen(command);
	else
		len = 0;

	if(len > 0)
	{
		result = send_ssh_data(spc,SSH_CMSG_EXEC_CMD,command,len);
		if(result < 0)
			fprintf(stderr,"SSH: Failed to execute command '%s' (%d, %s).\n",command,errno,strerror(errno));
	}
	else
	{
		result = 0;
	}

	return(result);
}

/****************************************************************************/

int
ssh_write(struct ssh_protocol_context *spc, void *data, int len)
{
	int result;

	result = send_ssh_data(spc,SSH_CMSG_STDIN_DATA,data,len);

	return(result);
}

/****************************************************************************/

int
ssh_read(struct ssh_protocol_context *spc, void *data, int len)
{
	int total = 0;

	if(spc->spc_BytesLeft >= 0)
	{
		uint8_t * m = data;

		while(len > 0)
		{
			if(spc->spc_BytesLeft == 0)
			{
				int payload_size,packet_size,n,i;

				/* Careful there: we don't want to linger in this
				 * routine any longer than is really necessary. If
				 * the previous iteration managed to obtain some
				 * data already, do not attempt to read any more
				 * data as that might cause this routine to block
				 * for no good reason at all.
				 */
				if(total > 0)
				{
					fd_set read_set;
					struct timeval tv;

					FD_ZERO(&read_set);
					FD_SET(spc->spc_Socket,&read_set);
					memset(&tv,0,sizeof(tv));

					/* If there is no additional data waiting,
					 * call it a day and return what we've already
					 * got.
					 */
					if(select(spc->spc_Socket+1,&read_set,NULL,NULL,&tv) <= 0)
						break;
				}

				n = recv_all(spc->spc_Socket,spc->spc_InBuf,4);
				if(n != 4)
				{
					spc->spc_BytesLeft = -1;

					if(n < 0)
						total = n;

					break;
				}

				for(i = payload_size = 0; i < 4; i++)
					payload_size = (payload_size << 8) + spc->spc_InBuf[i];

				packet_size = payload_size + (8 - (payload_size % 8));

				n = recv_all(spc->spc_Socket,&spc->spc_InBuf[4],packet_size);
				if(n != packet_size)
				{
					spc->spc_BytesLeft = -1;

					if(n < 0)
						total = n;

					break;
				}

				switch(convert_received_data(spc))
				{
					case SSH_SMSG_STDERR_DATA:

						fwrite(&spc->spc_PacketIn.body[4],spc->spc_PacketIn.length-5,1,stderr);
						break;

					case SSH_SMSG_STDOUT_DATA:

						spc->spc_BytesLeft = spc->spc_PacketIn.length-5;
						spc->spc_Ptr = &spc->spc_PacketIn.body[4];

						break;

					case SSH_SMSG_EXITSTATUS:

						prepare_packet_header(spc,SSH_CMSG_EXIT_CONFIRMATION,0);
						write_packet(spc);

						spc->spc_BytesLeft = -1;
						goto out;

					case SSH_MSG_DISCONNECT:

						spc->spc_BytesLeft = -1;
						goto out;

					case SSH_SMSG_SUCCESS:
					case SSH_MSG_IGNORE:

						break;

					case -1:

						fprintf(stderr,"SSH: Corrupt packet data received.\n");
						spc->spc_BytesLeft = -1;
						goto out;

					default:

						break;
				}
			}

			if(spc->spc_BytesLeft > 0)
			{
				int n;

				if(len > spc->spc_BytesLeft)
					n = spc->spc_BytesLeft;
				else
					n = len;

				memcpy(m,spc->spc_Ptr,n);
				m += n;
				total += n;
				len -= n;

				spc->spc_Ptr += n;
				spc->spc_BytesLeft -= n;
			}
		}
	}

 out:

	return(total);
}
