
#ifndef TEK_KN_SOCKCOMMON
#define TEK_KN_SOCKCOMMON

/*****************************************************************************
**
**	server socket
**
*****************************************************************************/

struct knsrvnode									/* server connection node */
{
	TNODE node;
	int connID;										/* connection ID */
	int desc;										/* socket descriptor */
	knsockobj sendername;							/* sender name object */
	TUINT bytesdone;								/* number of bytes read/written so far */
	TUINT bytestowrite;								/* number of bytes to be written */
	knnetmsg netmsg;								/* netmsg header */
	TMSG *bufmsg;									/* full msg */
	TFLOAT timestamp;								/* timestamp of last incoming data */
};

struct knservsocket									/* server socket */
{
	kn_sockenv_t sockenv;							/* platform specific socket environment */

	TAPTR mmu;										/* memory manager */
	TAPTR msgmmu;									/* memory manager for messages */

	int desc;										/* this socket's descriptor */
	int connID;

	fd_set readset;									/* active fd set for reading */
	fd_set writeset;								/* active fd set for writing */

	TLIST freelist;									/* list of free connection nodes */
	TLIST readlist;									/* list of read connections */
	TLIST writelist;								/* list of write connections */
	TLIST deliverlist;								/* list of netmsgs to be delivered to userland */
	TLIST userlandlist;								/* list of netmsgs in userland */

	struct knsrvnode nodebuf[KNSOCK_MAXLISTEN];		/* connection node buffer */
	
	TUINT maxmsgsize;								/* max size of a message. connections sending larger messages
													** will be dropped. -1 indicates unlimited size */

	TKNOB *timer;									/* kernel timer object */
	TFLOAT readtimeout;								/* timeout for no activity on a connection */
};



/*****************************************************************************
**
**	client socket
**
*****************************************************************************/

#define SOCKSTATUS_CONNECTING		0
#define SOCKSTATUS_CONNECTED		1
#define SOCKSTATUS_BROKEN			2

struct knclinode									/* client message node */
{
	TNODE node;
	TMSG *msg;										/* message being processed */
	knnethead nethead;								/* net msg header */
	TUINT bytesdone;								/* bytes written */
	TUINT bytestowrite;
	TUINT msgID;
	TFLOAT timestamp;								/* msg outgoing time */
};

struct knclientsocket								/* client socket */
{
	kn_sockenv_t sockenv;							/* platform specific socket environment */

	TAPTR mmu;										/* memory manager */

	int desc;										/* this socket's descriptor */
	knsockobj *remotename;							/* remote socket's name */

	fd_set readset;									/* active fd set for reading */
	fd_set writeset;								/* active fd set for writing */

	int status;										/* socket status */

	TUINT msgID;									/* running message ID */

	knnethead nethead;								/* net header currently being read */
	TUINT bytesdone;
	struct knclinode *clientnode;					/* client node to receive a reply, if identified */

	TLIST freelist;									/* list of free connection nodes */
	TLIST readlist;									/* list of read connections */
	TLIST writelist;								/* list of write connections */
	TLIST deliverlist;								/* list of replies to be delivered */

	struct knclinode nodebuf[KNSOCK_MAXPENDING];	/* client connection node buffer */

	knnetmsg netmsg;								/* netmsg common to all client nodes */

	TKNOB *timer;									/* kernel timer object */
	TFLOAT msgtimeout;								/* reply timeout */
};


#endif
