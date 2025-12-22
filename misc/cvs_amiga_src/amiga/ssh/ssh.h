/*
 * SSH constants and protocol structure
 *
 */

#ifndef _SSH_H
#define _SSH_H

/****************************************************************************/

#define INBUF_SIZE 32768        /* Input buffer size */

/****************************************************************************/

#define SSH_PORT 22

/****************************************************************************/

#define SSH_MSG_NONE                            0       /* no message */
#define SSH_MSG_DISCONNECT                      1       /* cause (string) */
#define SSH_SMSG_PUBLIC_KEY                     2       /* ck,msk,srvk,hostk */
#define SSH_CMSG_SESSION_KEY                    3       /* key (MP_INT) */
#define SSH_CMSG_USER                           4       /* user (string) */
#define SSH_CMSG_AUTH_RHOSTS                    5       /* user (string) */
#define SSH_CMSG_AUTH_RSA                       6       /* modulus (MP_INT) */
#define SSH_SMSG_AUTH_RSA_CHALLENGE             7       /* int (MP_INT) */
#define SSH_CMSG_AUTH_RSA_RESPONSE              8       /* int (MP_INT) */
#define SSH_CMSG_AUTH_PASSWORD                  9       /* pass (string) */
#define SSH_CMSG_REQUEST_PTY                    10      /* TERM, tty modes */
#define SSH_CMSG_WINDOW_SIZE                    11      /* row,col,xpix,ypix */
#define SSH_CMSG_EXEC_SHELL                     12      /* */
#define SSH_CMSG_EXEC_CMD                       13      /* cmd (string) */
#define SSH_SMSG_SUCCESS                        14      /* */
#define SSH_SMSG_FAILURE                        15      /* */
#define SSH_CMSG_STDIN_DATA                     16      /* data (string) */
#define SSH_SMSG_STDOUT_DATA                    17      /* data (string) */
#define SSH_SMSG_STDERR_DATA                    18      /* data (string) */
#define SSH_CMSG_EOF                            19      /* */
#define SSH_SMSG_EXITSTATUS                     20      /* status (int) */
#define SSH_MSG_CHANNEL_OPEN_CONFIRMATION       21      /* channel (int) */
#define SSH_MSG_CHANNEL_OPEN_FAILURE            22      /* channel (int) */
#define SSH_MSG_CHANNEL_DATA                    23      /* ch,data (int,str) */
#define SSH_MSG_CHANNEL_CLOSE                   24      /* channel (int) */
#define SSH_MSG_CHANNEL_CLOSE_CONFIRMATION      25      /* channel (int) */

/* new channel protocol */
#define SSH_MSG_CHANNEL_INPUT_EOF               24
#define SSH_MSG_CHANNEL_OUTPUT_CLOSED           25

/*      SSH_CMSG_X11_REQUEST_FORWARDING         26         OBSOLETE */
#define SSH_SMSG_X11_OPEN                       27      /* channel (int) */
#define SSH_CMSG_PORT_FORWARD_REQUEST           28      /* p,host,hp (i,s,i) */
#define SSH_MSG_PORT_OPEN                       29      /* ch,h,p (i,s,i) */
#define SSH_CMSG_AGENT_REQUEST_FORWARDING       30      /* */
#define SSH_SMSG_AGENT_OPEN                     31      /* port (int) */
#define SSH_MSG_IGNORE                          32      /* string */
#define SSH_CMSG_EXIT_CONFIRMATION              33      /* */
#define SSH_CMSG_X11_REQUEST_FORWARDING         34      /* proto,data (s,s) */
#define SSH_CMSG_AUTH_RHOSTS_RSA                35      /* user,mod (s,mpi) */
#define SSH_MSG_DEBUG                           36      /* string */
#define SSH_CMSG_REQUEST_COMPRESSION            37      /* level 1-9 (int) */
#define SSH_CMSG_MAX_PACKET_SIZE                38      /* max_size (int) */

/* Support for TIS authentication server
   Contributed by Andre April <Andre.April@cediti.be>. */
#define SSH_CMSG_AUTH_TIS                       39      /* */
#define SSH_SMSG_AUTH_TIS_CHALLENGE             40      /* string */
#define SSH_CMSG_AUTH_TIS_RESPONSE              41      /* pass (string) */

/* Support for kerberos authentication by Glenn Machin and Dug Song
   <dugsong@umich.edu> */
#define SSH_CMSG_AUTH_KERBEROS                  42      /* string (KTEXT) */
#define SSH_SMSG_AUTH_KERBEROS_RESPONSE         43      /* string (KTEXT) */
#define SSH_CMSG_HAVE_KERBEROS_TGT              44      /* string (credentials) */

/* Reserved for official extensions, do not use these */
#define SSH_CMSG_RESERVED_START                 45
#define SSH_CMSG_RESERVED_END                   63

/****************************************************************************/

#define EMULATE_OLD_CHANNEL_CODE 0x0001
#define EMULATE_OLD_AGENT_BUG    0x0002

#define EMULATE_VERSION_OK                      0
#define EMULATE_MAJOR_VERSION_MISMATCH          1
#define EMULATE_VERSION_TOO_OLD                 2
#define EMULATE_VERSION_NEWER                   3

/****************************************************************************/

/* Major protocol version.  Different version indicates major incompatiblity
   that prevents communication.  */
#define PROTOCOL_MAJOR          1

/* Minor protocol version.  Different version indicates minor incompatibility
   that does not prevent interoperation. */
#define PROTOCOL_MINOR          5

/****************************************************************************/

#define SSH_CIPHER_NONE         0
#define SSH_CIPHER_IDEA         1
#define SSH_CIPHER_DES          2
#define SSH_CIPHER_3DES         3
#define SSH_CIPHER_RC4          5
#define SSH_CIPHER_BLOWFISH     6

/****************************************************************************/

struct Packet
{
    long length;
    int type;
    unsigned char data[INBUF_SIZE];
    unsigned char *body;
};

/****************************************************************************/

#endif /* _SSH_H */
