/*
 * rsh.c
 *
 * BSD Unix style remote shell client command
 *
 * :ts=4
 *
 * Copyright © 2001-2019 by Olaf Barthel. All Rights Reserved.
 */

/****************************************************************************/

#ifdef __SASC
#include <constructor.h>
#endif /* __SASC */

#include <exec/execbase.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/dosasl.h>
#include <dos/rdargs.h>
#include <dos/stdio.h>

#include <libraries/bsdsocket.h>
#include <libraries/usergroup.h>

#define __USE_OLD_TIMEVAL__
#include <devices/timer.h>

/****************************************************************************/

#define NO_INLINE_STDARG

#undef __NOGLOBALIFACE__
#define __NOLIBBASE__
#include <proto/bsdsocket.h>
#include <proto/usergroup.h>
#include <proto/exec.h>
#include <proto/dos.h>

/****************************************************************************/

#include <sys/filio.h>

/****************************************************************************/

#include <string.h>
#include <stdio.h>

/****************************************************************************/

#include "rsh_rev.h"

/****************************************************************************/

#define BUSY ((struct IORequest *)NULL)

/****************************************************************************/

typedef LONG *	NUMBER;
typedef LONG	SWITCH;
typedef STRPTR	KEY;

/****************************************************************************/

long __oslibversion = 37;

/****************************************************************************/

extern struct Library *	SysBase;
extern struct Library *	DOSBase;

/****************************************************************************/

#if defined(__amigaos4__)
struct SocketIFace *	ISocket;
struct UserGroupIFace *	IUserGroup;
#endif /* __amigaos4__ */

/****************************************************************************/

struct Library * SocketBase;
struct Library * UserGroupBase;

/****************************************************************************/

struct RDArgs * rda;

/****************************************************************************/

struct MsgPort *		TimePort;
struct timerequest * 	TimeRequest;
BOOL					TimeRequestPending;

/****************************************************************************/

/* DNS resolver error codes are stored here. */
int h_errno;

/****************************************************************************/

/* Local function prototypes. */
int setup(void);
void cleanup(void);
char * hstrerror(int error);
char * strerror(int error);
int bind_local_socket(int * local_port_ptr);
BOOL send_connection_strings(int socket, const char * local_user_name, const char * remote_user_name, const char * command);

/****************************************************************************/

int
setup(void)
{
	struct TagItem tags[3];
	int result = -1;

	SocketBase = OpenLibrary ("bsdsocket.library", 4);

	#if defined(__amigaos4__)
	{
		if(SocketBase != NULL)
		{
			ISocket = (struct SocketIFace *)GetInterface(SocketBase, "main", 1, 0);
			if(ISocket == NULL)
			{
				CloseLibrary(SocketBase);
				SocketBase = NULL;
			}
		}
	}
	#endif /* __amigaos4__ */

	if(SocketBase == NULL)
	{
		fprintf (stderr, "%s: Error opening \"%s\" V%ld.\n", "rsh", "bsdsocket.library", 4);
		goto out;
	}

	tags[0].ti_Tag	= SBTM_SETVAL (SBTC_ERRNOPTR (sizeof (errno)));
	tags[0].ti_Data	= (ULONG)&errno;
	tags[1].ti_Tag	= SBTM_SETVAL (SBTC_HERRNOLONGPTR);
	tags[1].ti_Data	= (ULONG)&h_errno;
	tags[2].ti_Tag	= TAG_END;

	SocketBaseTagList(tags);

	UserGroupBase = OpenLibrary ("usergroup.library", 0);

	#if defined(__amigaos4__)
	{
		if(UserGroupBase != NULL)
		{
			IUserGroup = (struct UserGroupIFace *)GetInterface(UserGroupBase, "main", 1, 0);
			if(IUserGroup == NULL)
			{
				CloseLibrary(UserGroupBase);
				UserGroupBase = NULL;
			}
		}
	}
	#endif /* __amigaos4__ */

	if(UserGroupBase == NULL)
	{
		fprintf (stderr, "%s: Error opening \"%s\".\n", "rsh", "usergroup.library");
		goto out;
	}

	TimePort = CreateMsgPort();
	if(TimePort == NULL)
	{
		fprintf (stderr, "%s: Could not create timer port.\n", "rsh");
		goto out;
	}

	TimeRequest = (struct timerequest *)CreateIORequest(TimePort, sizeof(*TimeRequest));
	if(TimePort == NULL)
	{
		fprintf (stderr, "%s: Could not create timer request.\n", "rsh");
		goto out;
	}

	if(OpenDevice(TIMERNAME,UNIT_VBLANK,(struct IORequest *)TimeRequest,0) != 0)
	{
		fprintf (stderr, "%s: Could open timer device.\n", "rsh");
		goto out;
	}

	result = 0;

out:

	return (result);
}

/****************************************************************************/

void
cleanup(void)
{
	if(TimeRequestPending)
	{
		if(CheckIO((struct IORequest *)TimeRequest) == BUSY)
			AbortIO((struct IORequest *)TimeRequest);

		WaitIO((struct IORequest *)TimeRequest);
		TimeRequestPending = FALSE;
	}

	if(TimeRequest != NULL)
	{
		if(TimeRequest->tr_node.io_Device != NULL)
			CloseDevice((struct IORequest *)TimeRequest);

		DeleteIORequest((struct IORequest *)TimeRequest);
		TimeRequest = NULL;
	}

	if(TimePort != NULL)
	{
		DeleteMsgPort(TimePort);
		TimePort = NULL;
	}

	if(rda != NULL)
	{
		FreeArgs (rda);
		rda = NULL;
	}

	#if defined(__amigaos4__)
	{
		if(IUserGroup != NULL)
		{
			DropInterface((struct Interface *)IUserGroup);
			IUserGroup = NULL;
		}

		if(ISocket != NULL)
		{
			DropInterface((struct Interface *)ISocket);
			ISocket = NULL;
		}
	}
	#endif /* __amigaos4__ */

	if(UserGroupBase != NULL)
	{
		CloseLibrary (UserGroupBase);
		UserGroupBase = NULL;
	}

	if(SocketBase != NULL)
	{
		CloseLibrary (SocketBase);
		SocketBase = NULL;
	}
}

/****************************************************************************/

#if defined(__SASC)

CBMLIB_CONSTRUCTOR (setup)
{
	return(setup());
}

CBMLIB_DESTRUCTOR (cleanup)
{
	cleanup();
}

#endif /* __SASC */

/****************************************************************************/

#if defined(__GNUC__)

void __attribute__ ((constructor))
_setup(void)
{
	if(DOSBase->lib_Version < 37 || setup() != 0)
		exit(RETURN_FAIL);
}

void __attribute__ ((destructor))
_cleanup(void)
{
	cleanup();
}

#endif /* __GNUC__ */

/****************************************************************************/

char *
hstrerror(int error)
{
	struct TagItem tags[2];
	LONG code;

	code = error;

	tags[0].ti_Tag	= SBTM_GETREF(SBTC_HERRNOSTRPTR);
	tags[0].ti_Data = (ULONG)&code;
	tags[1].ti_Tag	= TAG_END;

	SocketBaseTagList(tags);

	return((char *)code);
}

/****************************************************************************/

char *
strerror(int error)
{
	struct TagItem tags[2];
	LONG code;

	code = error;

	tags[0].ti_Tag	= SBTM_GETREF(SBTC_ERRNOSTRPTR);
	tags[0].ti_Data = (ULONG)&code;
	tags[1].ti_Tag	= TAG_END;

	SocketBaseTagList(tags);

	return((char *)code);
}

/****************************************************************************/

/* Create a socket which will be connected to the remote shell service.
 * This socket must be bound to a local port in the reserved range.
 */
int
bind_local_socket(int * local_port_ptr)
{
	struct sockaddr_in sin;
	int result = -1;
	int local_port;
	int s;

	s = socket(AF_INET, SOCK_STREAM, 0);
	if(s < 0)
		goto out;

	local_port = (*local_port_ptr);

	/* Try to bind the socket to the local reserved port
	 * number given; if that fails, retry with a smaller
	 * reserved port number until we hit the middle of
	 * the reserved port range without succeeding.
	 */
	while(TRUE)
	{
		if(local_port <= IPPORT_RESERVED / 2)
		{
			errno = EAGAIN;
			goto out;
		}

		memset(&sin, 0, sizeof(sin));

		sin.sin_family		= AF_INET;
		sin.sin_addr.s_addr	= INADDR_ANY;
		sin.sin_port		= htons(local_port);

		if(bind(s, (struct sockaddr *)&sin, sizeof(sin)) != -1)
			break;

		if(errno != EADDRINUSE)
			goto out;

		local_port--;
	}

	(*local_port_ptr) = local_port;

	result = s;
	s = -1;

 out:

	if(s != -1)
		CloseSocket(s);

	return(result);
}

/****************************************************************************/

/* Our own paranoid variant of send() which knows how to deal
 * with the unexpected EAGAIN error and the number of bytes
 * transmitted with each call to send() being smaller than
 * what was asked for.
 */
int
send_all(int socket, const char *buffer, int buffer_length)
{
	int num_bytes_sent = 0;
	int result = -1;
	int n;

	while(num_bytes_sent < buffer_length)
	{
		n = send(socket, (void *)&buffer[num_bytes_sent], buffer_length - num_bytes_sent, 0);
		if(n == -1)
		{
			if(errno != EAGAIN)
				goto out;
		}
		else
		{
			num_bytes_sent += n;
		}
	}

	result = num_bytes_sent;

 out:

	return(result);
}

/****************************************************************************/

/* Send the local/remote user names to the remote shell service,
 * as well as the shell command, including parameters, to execute.
 * Note that user names are truncated to 16 characters.
 */
BOOL
send_connection_strings(
	int				socket,
	const char *	local_user_name,
	const char *	remote_user_name,
	const char *	command)
{
	char user_name_buffer[16+1];
	BOOL success = FALSE;
	size_t len;

	/* No secondary stream (for stderr) is provided. */
	if(send_all(socket, "", 1) == -1)
		goto out;

	/* Local user name may not be longer than 16 characters. */
	len = strlen(local_user_name);
	if(len > 16)
		len = 16;

	memcpy(user_name_buffer, local_user_name, len);
	user_name_buffer[len] = '\0';

	if(send_all(socket, user_name_buffer, len+1) == -1)
		goto out;

	/* Remote user name may not be longer than 16 characters. */
	len = strlen(remote_user_name);
	if(len > 16)
		len = 16;

	memcpy(user_name_buffer, remote_user_name, len);
	user_name_buffer[len] = '\0';

	if(send_all(socket, user_name_buffer, len+1) == -1)
		goto out;

	/* Finally, send the shell command and its arguments. */
	if(send_all(socket, (void *)command, strlen(command)+1) == -1)
		goto out;

	success = TRUE;

 out:

	return(success);
}

/****************************************************************************/

/****** ROADSHOW/RSH *********************************************************
*
*   NAME
*	rsh -- remote shell command execution
*
*   FORMAT
*	rsh [-n] [-l <User name>] [TIMEOUT=<Seconds>] <Host name> <Command>
*
*   TEMPLATE
*	-n=NULL/S,-l=USERNAME/K,TIMEOUT/K/N,HOST/A,COMMAND/A/F
*
*   PATH
*	C:rsh
*
*   FUNCTION
*	The "rsh" command executes shell commands on a remote host. The output of
*	the command running on the remote host will be sent to the Amiga shell
*	standard output, which also includes error messages sent by the remote
*	server (which go to the standard error output).
*
*	The "rsh" command only tells the remote server which command and
*	which command options should be used. It is not an interactive remote
*	shell, i.e. the AmigaDOS "Break" command or pressing the [Ctrl]+C
*	keys in the Amiga shell directly affect the local Amiga "rsh" command
*	only. However, if you stop the local Amiga "rsh" command, the connection
*	to the remote server will be closed and the remote command will be
*	shut down by receiving a termination signal.
*
*   OPTIONS
*	-n | NULL
*	    Other than error messages sent by the remote server, command output
*	    will not be printed on the Amiga side. The "rsh" command will keep
*	    waiting for the remote server to send its data, though.
*
*	-l <Remote user name> | USERNAME=<Remote user name>
*	    The "rsh" command will tell the remote server which user account
*	    the command to execute will be using. The default is to use the
*	    local Amiga default user (which for Roadshow might be "root").
*	    You can override the default user name with this option.
*
*	TIMEOUT
*	    The maximum number of seconds to wait for the remote command
*	    command to send its output before exiting. If this timeout
*	    elapses, the "rsh" command will close the connection to the
*	    remote server regardless of how much output was received.
*
*	HOST
*	    The name or IP address of the remote shell server to use.
*
*	COMMAND
*	    The name of the command, as well as all command line options
*	    to send to the remote shell server. You may have to enclose
*	    the entire command line in double quotes.
*
*   NOTES
*	The "rsh" command will use the shell/tcp service on the remote
*	server, which defaults to port number 514.
*
*	The lengths of the local and the remote user names, as transmitted to
*	the remote server, are limited to 16 characters. If the respective
*	names given are longer than 16 characters, they will be transmitted
*	in truncated form.
*
*	The shell service requires only a valid login, and you will
*	not be prompted to enter a password. Modern Unix systems generally
*	do not enable the shell service by default because of security
*	concerns. Some assembly may be required to even get the shell service
*	to work in the first place.
*
*	The server may refuse to run the command, and send an error or
*	warning message instead. This is not the command output, and it
*	will be printed on the standard error stream. Also, the "rsh"
*	command will print the message "Remote server has closed
*	connection" and then exit with return code 10 (error).
*
*	If the TIMEOUT option is used, and the timeout occurs before the
*	remote server has printed all its output, the "rsh" command will
*	print the message "Request timed out" and exit with return
*	code 5 (warning).
*
*   FILES
*	DEVS:Internet/services
*
******************************************************************************
*/

int
main(int argc, char ** argv)
{
	struct
	{
		SWITCH	null;
		KEY		username;
		NUMBER	timeout;
		KEY		host;
		KEY		command;
	} args;

	STRPTR args_template =
		"-n=NULL/S,"
		"-l=USERNAME/K,"
		"TIMEOUT/K/N,"
		"HOST/A,"
		"COMMAND/A/F"
		VERSTAG;

	struct UserGroupCredentials *credentials;
	int server_connection_timeout;
	char * local_user_name;
	char * remote_user_name;
	struct servent * service;
	struct hostent * host;
	int local_socket;
	struct sockaddr_in sin;
	int local_port;
	BOOL connected;
	int error;
	int num_sockets_ready;
	int num_bytes_read;
	fd_set fds;
	int yes = 1;
	ULONG time_signal;
	ULONG signals;
	char c;
	int i;

	memset(&args, 0, sizeof (args));

	rda = ReadArgs(args_template, (LONG *)&args, NULL);
	if(rda == NULL)
	{
		PrintFault(IoErr(), argv[0]);
		exit(RETURN_FAIL);
	}

	if(args.command[0] == '\0' || (args.username != NULL && args.username[0] == '\0'))
	{
		PrintFault(ERROR_REQUIRED_ARG_MISSING, argv[0]);
		exit(RETURN_FAIL);
	}

	time_signal = (1UL << TimePort->mp_SigBit);

	/* Grab the default user credentials. We are interested in the
	 * user name only, which is transmitted to the remote shell
	 * service.
	 */
	credentials = getcredentials(NULL);

	local_user_name		= (char *)credentials->cr_login;
	remote_user_name	= args.username ? (char *)args.username : local_user_name;

	service = getservbyname("shell", "tcp");
	if(service == NULL)
	{
		fprintf(stderr, "%s: Service shell/tcp not known.\n", argv[0]);
		exit(RETURN_FAIL);
	}

	host = gethostbyname(args.host);
	if(host == NULL)
	{
		fprintf(stderr, "%s: Host \"%s\" lookup failure (%s).\n", argv[0], args.host, hstrerror(h_errno));
		exit(RETURN_FAIL);
	}

	/* We need to open a connection to the remote shell service
	 * using a local socket bound to a reserved port number.
	 * If this is a multi-homed server, we will try to connect
	 * to each IPv4 server address reported by gethostbyname().
	 */
	server_connection_timeout = 1;
	local_socket = -1;
	local_port = IPPORT_RESERVED - 1;
	connected = FALSE;
	error = 0;

	for(i = 0 ; host->h_addr_list[i] != NULL ; (void)NULL)
	{
		/* No socket ready to connect yet? */
		if(local_socket == -1)
		{
			local_socket = bind_local_socket(&local_port);
			if(local_socket == -1)
			{
				if(errno == EAGAIN)
					fprintf(stderr, "%s: All local network ports are in use.\n", argv[0]);
				else
					fprintf(stderr, "%s: Could not bind local network socket (%s).\n", argv[0], strerror(errno));

				exit(RETURN_FAIL);
			}
		}

		/* Try to connect the socket to the remote shell service. */
		memset(&sin, 0, sizeof(sin));

		memcpy(&sin.sin_addr, host->h_addr_list[i], host->h_length);
		sin.sin_family = host->h_addrtype;
		sin.sin_port = service->s_port;

		if(connect(local_socket, (struct sockaddr *)&sin, sizeof(sin)) == 0)
		{
			connected = TRUE;
			break;
		}

		error = errno;

		/* Close the socket now, open a new one in the
		 * next loop iteration.
		 */
		CloseSocket(local_socket);
		local_socket = -1;

		/* Connection refused? Wait a few seconds and try again. */
		if (error == ECONNREFUSED && server_connection_timeout <= 16)
		{
			/* Wait for a few seconds... */
			TimeRequest->tr_node.io_Command	= TR_ADDREQUEST;
			TimeRequest->tr_time.tv_secs	= server_connection_timeout;
			TimeRequest->tr_time.tv_micro	= 0;

			SetSignal(0, time_signal);
			SendIO((struct IORequest *)TimeRequest);

			TimeRequestPending = TRUE;

			/* Wait for the timer to elapse or the user
			 * to abort the operation.
			 */
			do
			{
				signals = Wait(SIGBREAKF_CTRL_C | time_signal);

				if((signals & SIGBREAKF_CTRL_C) != 0)
				{
					PrintFault(ERROR_BREAK, argv[0]);
					exit(RETURN_WARN);
				}
			}
			while((signals & time_signal) == 0);

			WaitIO((struct IORequest *)TimeRequest);

			TimeRequestPending = FALSE;

			server_connection_timeout *= 2;
		}
		/* Try a different local port number? */
		else if (error == EADDRINUSE)
		{
			local_port--;
		}
		/* Connection didn't work out. Try the next server IPv4 address. */
		else
		{
			/* Is there another server IPv4 address to try?
			 * If so, report the connection error and
			 * the IPv4 address of the next server.
			 */
			if(host->h_addr_list[i+1] != NULL)
			{
				fprintf(stderr, "connect to address %s: %s\n", Inet_NtoA(sin.sin_addr.s_addr), strerror(error));

				memcpy(&sin.sin_addr, host->h_addr_list[i+1], host->h_length);

				fprintf(stderr, "Trying %s...\n", Inet_NtoA(sin.sin_addr.s_addr));
			}

			/* Try the next server address. */
			local_port = IPPORT_RESERVED - 1;
			server_connection_timeout = 1;

			i++;
		}
	}

	if(!connected)
	{
		fprintf(stderr, "%s: Could not connect to server \"%s\" (%s).\n", argv[0], args.host, strerror(error));
		exit(RETURN_FAIL);
	}

	if(!send_connection_strings(local_socket,
		local_user_name,
		remote_user_name,
		(char *)args.command))
	{
		fprintf(stderr, "%s: Could not send command to remote server \"%s\" (%s).\n", argv[0], args.host, strerror(errno));
		exit(RETURN_FAIL);
	}

	/* When trying to read further data from our side, the server will only see an EOF. */
	shutdown(local_socket, 1);

	/* Pick up the remote server's logon message, if any. */
	while((num_bytes_read = recv(local_socket, &c, 1, 0)) != 1)
	{
		if (num_bytes_read == 0)
		{
			fprintf(stderr, "%s: Remote server \"%s\" has closed the connection.\n", argv[0], args.host);
			exit(RETURN_ERROR);
		}
		else if (num_bytes_read == -1 && errno != EAGAIN)
		{
			fprintf(stderr,"%s: Could not read remote server \"%s\" logon message (%s).\n", argv[0], args.host, strerror(errno));
			exit(RETURN_FAIL);
		}
	}

	/* Print the server's logon error message? */
	if(c != '\0')
	{
		/* Print the entire error message, terminated by a line feed. */
		while(TRUE)
		{
			num_bytes_read = recv(local_socket, &c, 1, 0);
			if (num_bytes_read == 1)
			{
				if(putc(c, stderr) == EOF)
				{
					/* If we couldn't print that single character then
					 * a couple more will probably not print either, but
					 * at least we tried...
					 */
					fprintf(stderr, "%s: Could not print remote server \"%s\" logon message (%s).\n", argv[0], args.host, strerror(errno));
					exit(RETURN_ERROR);
				}

				if(c == '\n')
					break;
			}
			else if (num_bytes_read == 0)
			{
				fprintf(stderr, "%s: Remote server \"%s\" has closed the connection.\n", argv[0], args.host);
				exit(RETURN_ERROR);
			}
			else if (num_bytes_read == -1 && errno != EAGAIN)
			{
				fprintf(stderr,"%s: Could not read remote server \"%s\" logon message (%s).\n", argv[0], args.host, strerror(errno));
				exit(RETURN_FAIL);
			}
		}

		exit(RETURN_FAIL);
	}

	/* Do not block when reading from the socket. */
	IoctlSocket(local_socket, FIONBIO, (char *)&yes);

	/* If requested, limit how much time may be spent reading from the server. */
	if(args.timeout != NULL && (*args.timeout) > 0)
	{
		TimeRequest->tr_node.io_Command	= TR_ADDREQUEST;
		TimeRequest->tr_time.tv_secs	= (*args.timeout);
		TimeRequest->tr_time.tv_micro	= 0;

		SetSignal(0, time_signal);
		SendIO((struct IORequest *)TimeRequest);

		TimeRequestPending = TRUE;
	}

	/* Read the shell command's output and display it. Stop if a
	 * timeout occurs or if the user hits Ctrl+C.
	 */
	while(TRUE)
	{
		errno = 0;

		FD_ZERO(&fds);
		FD_SET(local_socket,&fds);

		/* If the timeout is in effect, this will tell WaitSignal()
		 * to check for the time request returning.
		 */
		signals = TimeRequestPending ? time_signal : 0;

		/* Wait for data to become available for reading, or for
		 * the timeout to elapse.
		 */
		num_sockets_ready = WaitSelect(local_socket+1, &fds, NULL, NULL, NULL, TimeRequestPending ? &signals : NULL);

		/* If WaitSelect() has returned -1 and an error code
		 * is set, have a closer look at what we got.
		 */
		if(num_sockets_ready == -1 && errno != 0)
		{
			if (errno == EINTR)
			{
				PrintFault(ERROR_BREAK, argv[0]);
				exit(RETURN_WARN);
			}
			else if (errno == EAGAIN)
			{
				continue;
			}
			else
			{
				fprintf(stderr, "%s: Could not read remote server \"%s\" response (%s).\n", argv[0], args.host, strerror(errno));
				exit(RETURN_FAIL);
			}
		}

		/* If the timeout has elapsed, exit immediately. */
		if((signals & time_signal) != 0)
		{
			fprintf(stderr, "%s: Could not print remote server \"%s\" response (timeout).\n", argv[0], args.host);
			exit(RETURN_WARN);
		}

		/* Data is available for reading? */
		if(num_sockets_ready > 0)
		{
			char data[BUFSIZ];

			errno = 0;

			/* Read as much data as is currently available. This is a non-blocking
			 * read operation, due to the IoctlSocket() call above.
			 */
			while((num_bytes_read = recv(local_socket, data, (int)sizeof(data), 0)) > 0)
			{
				/* If the timeout is in effect, also poll the timer to see if
				 * we should quit immediately.
				 */
				if(TimeRequestPending && (SetSignal(0, time_signal) & time_signal) != 0)
				{
					fprintf(stderr, "%s: Could not print remote server \"%s\" response (timeout).\n", argv[0], args.host);
					exit(RETURN_WARN);
				}

				/* Do not suppress the output? */
				if(!args.null)
				{
					if(fwrite(data, num_bytes_read, 1, stdout) != 1)
					{
						fprintf(stderr, "%s: Could not print remote server \"%s\" response (%s).\n", argv[0], args.host, strerror(errno));
						exit(RETURN_ERROR);
					}
				}

				errno = 0;
			}

			/* Did we get a read error? */
			if (num_bytes_read == -1)
			{
				/* The user hit Ctrl+C */
				if (errno == EINTR)
				{
					PrintFault(ERROR_BREAK, argv[0]);
					exit(RETURN_WARN);
				}
				/* Anything else is an error to report, except for EAGAIN,
				 * which indicates that the connection has not been closed,
				 * but there is no further data to be read just now.
				 */
				else if (errno != EAGAIN)
				{
					fprintf(stderr, "%s: Could not read remote server \"%s\" response (%s).\n", argv[0], args.host, strerror(errno));
					exit(RETURN_FAIL);
				}
			}
			/* This indicates an end of file. */
			else if (num_bytes_read == 0)
			{
				break;
			}
		}
	}

	return(RETURN_OK);
}
