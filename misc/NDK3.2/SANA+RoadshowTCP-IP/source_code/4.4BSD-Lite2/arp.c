/*
 * arp.c
 *
 * Amiga port for Roadshow TCP/IP stack by Olaf Barthel,
 * public domain.
 *
 * :ts=4
 */

/*
 * Copyright (c) 1984, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Sun Microsystems, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * arp - display, set, and delete arp table entries
 */

#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <net/if_types.h>
#include <net/route.h>

#include <netinet/in.h>
#include <netinet/if_ether.h>

#include <arpa/inet.h>

#include <errno.h>
#include <netdb.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>

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

#include <utility/tagitem.h>

#include <devices/timer.h>

/****************************************************************************/

#define NO_INLINE_STDARG

#undef __NOGLOBALIFACE__
#define __NOLIBBASE__
#include <proto/bsdsocket.h>
#include <proto/utility.h>
#include <proto/exec.h>
#include <proto/dos.h>

/****************************************************************************/

#include "arp_rev.h"

/****************************************************************************/

#define UNIX_TIME_OFFSET 252460800UL

/****************************************************************************/

typedef LONG *NUMBER;
typedef LONG SWITCH;
typedef STRPTR KEY;

/****************************************************************************/

long __oslibversion = 37;

/****************************************************************************/

struct RDArgs *rda;

/****************************************************************************/

#if defined(__amigaos4__)
struct UtilityIFace *IUtility;
struct SocketIFace *ISocket;
#endif /* __amigaos4__ */

/****************************************************************************/

struct Library *UtilityBase;
struct Library *SocketBase;

/****************************************************************************/

extern struct Library *SysBase;
extern struct Library *DOSBase;

/****************************************************************************/

struct rt_msghdr *route_info;
int h_errno;

/****************************************************************************/

#if defined(write)
#undef write
#endif /* write */

#if defined(read)
#undef read
#endif /* read */

#define inet_ntoa(in) Inet_NtoA((in).s_addr)
#define getpid() ((unsigned long)FindTask(NULL))
#define write(s,buf,len) send(s,buf,len,0)
#define read(s,buf,len) recv(s,buf,len,0)

/****************************************************************************/

#define NOT !

/****************************************************************************/

int
open_bsdsocket (void)
{
	struct TagItem tags[3];
	LONG have_routing_api = FALSE;
	int result = -1;

	UtilityBase = OpenLibrary ("utility.library", 37);

	#if defined(__amigaos4__)
	{
		if (UtilityBase != NULL)
		{
			IUtility = (struct UtilityIFace *) GetInterface (UtilityBase, "main", 1, 0);
			if (IUtility == NULL)
			{
				CloseLibrary (UtilityBase);
				UtilityBase = NULL;
			}
		}
	}
	#endif /*__amigaos4__ */

	if (UtilityBase == NULL)
	{
		fprintf (stderr, "arp: Error opening \"%s\" V%ld.\n", "utility.library", 37);
		goto out;
	}

	SocketBase = OpenLibrary ("bsdsocket.library", 4);

	#if defined(__amigaos4__)
	{
		if (SocketBase != NULL)
		{
			ISocket = (struct SocketIFace *) GetInterface (SocketBase, "main", 1, 0);
			if (ISocket == NULL)
			{
				CloseLibrary (SocketBase);
				SocketBase = NULL;
			}
		}
	}
	#endif /* __amigaos4__ */

	if (SocketBase == NULL)
	{
		fprintf (stderr, "arp: Error opening \"%s\" V%ld.\n", "bsdsocket.library", 4);
		goto out;
	}

	tags[0].ti_Tag	= SBTM_GETREF (SBTC_HAVE_ROUTING_API);
	tags[0].ti_Data	= (ULONG) &have_routing_api;
	tags[1].ti_Tag	= TAG_END;

	if (SocketBaseTagList (tags) != 0)
		have_routing_api = FALSE;

	if (NOT have_routing_api)
	{
		fprintf (stderr, "arp: \"%s\" V%ld.%ld does not support the route query method used by this program.\n",
			SocketBase->lib_Node.ln_Name, SocketBase->lib_Version, SocketBase->lib_Revision);

		goto out;
	}

	tags[0].ti_Tag	= SBTM_SETVAL (SBTC_ERRNOPTR (sizeof (errno)));
	tags[0].ti_Data	= (ULONG)&errno;
	tags[1].ti_Tag	= SBTM_SETVAL (SBTC_HERRNOLONGPTR);
	tags[1].ti_Data	= (ULONG)&h_errno;
	tags[2].ti_Tag	= TAG_END;

	SocketBaseTagList (tags);

	result = 0;

out:

	return (result);
}

/****************************************************************************/

void
close_bsdsocket (void)
{
	if (rda != NULL)
	{
		FreeArgs (rda);
		rda = NULL;
	}

	if (route_info != NULL)
	{
		FreeRouteInfo (route_info);
		route_info = NULL;
	}

	#if defined(__amigaos4__)
	{
		if (ISocket != NULL)
		{
			DropInterface ((struct Interface *) ISocket);
			ISocket = NULL;
		}

		if (IUtility != NULL)
		{
			DropInterface ((struct Interface *) IUtility);
			IUtility = NULL;
		}
	}
	#endif /* __amigaos4__ */

	if (SocketBase != NULL)
	{
		CloseLibrary (SocketBase);
		SocketBase = NULL;
	}

	if (UtilityBase != NULL)
	{
		CloseLibrary (UtilityBase);
		UtilityBase = NULL;
	}
}

/****************************************************************************/

#if defined(__SASC)

CBMLIB_CONSTRUCTOR (open_bsdsocket)
{
	return (open_bsdsocket ());
}

CBMLIB_DESTRUCTOR (close_bsdsocket)
{
	close_bsdsocket ();
}

#endif /* __SASC */

/****************************************************************************/

#if defined(__GNUC__)

void 
__attribute__ ((constructor))
_open_bsdsocket (void)
{
	if (DOSBase->lib_Version < 37 || open_bsdsocket () != 0)
		exit (RETURN_FAIL);
}

void 
__attribute__ ((destructor))
_close_bsdsocket (void)
{
	close_bsdsocket ();
}

#endif /* __GNUC__ */

/****************************************************************************/

void
herror (const char *s)
{
	struct TagItem tags[2];
	LONG code;

	code = h_errno;

	tags[0].ti_Tag	= SBTM_GETREF (SBTC_HERRNOSTRPTR);
	tags[0].ti_Data	= (ULONG) & code;
	tags[1].ti_Tag	= TAG_END;

	SocketBaseTagList (tags);

	if (s != NULL)
		fprintf (stderr, "%s: ", s);

	fprintf (stderr, "%s\n", code);
}

/****************************************************************************/

char *
strerror (int error)
{
	struct TagItem tags[2];
	LONG code;

	code = error;

	tags[0].ti_Tag	= SBTM_GETREF (SBTC_ERRNOSTRPTR);
	tags[0].ti_Data	= (ULONG) & code;
	tags[1].ti_Tag	= TAG_END;

	SocketBaseTagList (tags);

	return ((char *) code);
}

/****************************************************************************/

typedef unsigned long u_long;
typedef unsigned char u_char;

/****************************************************************************/

static int pid;
static int nflag;
static int s = -1;

int file (char *name);
void getsocket (void);
int set (char *host, char *eaddr, int temp, int publish);
void get (char *host);
int delete (char *host, int proxy);
void dump (u_long addr);
void ether_print (u_char * cp);
int ether_aton (char *a, u_char * n);
int rtmsg (int cmd);

/****** ROADSHOW/ARP *********************************************************
*
*   NAME
*	ARP - Address resolution display and control
*
*   FORMAT
*	ARP [-a|ALL] [-d|DELETE] [-s|SET] [HOSTNAME <name>]
*	    [ADDRESS <address>] [TEMP] [PUB|PUBLISH] [PRO|PROXY]
*	    [{-f|FILE} <file name>] [-n|NONAMES|NUMBERS]
*
*   TEMPLATE
*	-a=ALL/S,-d=DELETE/S,-s=SET/S,HOSTNAME,ADDRESS,TEMP/S,PUB=PUBLISH/S,
*	PRO=PROXY/S,-f=FILE/K,-n=NONAMES/S=NUMBERS/S
*
*   FUNCTION
*	The ARP command displays and modifies the Internet-to-Ethernet
*	address translation tables used by the address resolution protocol.
*	With no flags, the program displays the current ARP entry for
*	hostname. The host may be specified by name or by number, using
*	Internet dot notation.
*
*   OPTIONS
*	ALL, -a
*	    The command displays all of the current ARP entries.
*
*	DELETE, -d
*	    Delete an entry for the host specified with the HOSTNAME
*	    parameter.
*
*	    Example: arp delete hostname
*
*	NONAMES, -n
*	    Show network addresses as numbers (normally arp attempts to
*	    display addresses symbolically).
*
*	SET, -s
*	    Create an ARP entry for a host with a Ethernet address. The
*	    Ethernet address is given as six hex bytes separated by colons.
*	    The entry will be permanent unless the TEMP option is given in the
*	    command. If the PUB option is given, the entry will be
*	    "published"; i.e., this system will act as an ARP server,
*	    responding to requests for hostname even though the host address
*	    is not its own.
*
*	    Example: arp set hostname 00:30:ab:0e:d5:ee temp pub
*
*	FILE, -f
*	    Causes the file filename to be read and multiple entries to be set
*	    in the ARP tables. Entries in the file should be of the form
*
*	        hostname ether_addr [temp] [pub]
*
*	    with argument meanings as given for the SET option.
*
******************************************************************************
*/

int
main (int argc, char **argv)
{
	struct
	{
		SWITCH all;
		SWITCH delete;
		SWITCH set;
		KEY hostname;
		KEY address;
		SWITCH temp;
		SWITCH publish;
		SWITCH proxy;
		KEY file;
		SWITCH nonames;
	}
	args;

	STRPTR args_template =
		"-a=ALL/S,"
		"-d=DELETE/S,"
		"-s=SET/S,"
		"HOSTNAME,"
		"ADDRESS,"
		"TEMP/S,"
		"PUB=PUBLISH/S,"
		"PRO=PROXY/S,"
		"-f=FILE/K,"
		"-n=NONAMES/S=NUMBERS/S"
		VERSTAG;

	memset (&args, 0, sizeof (args));

	rda = ReadArgs (args_template, (LONG *) & args, NULL);
	if (rda == NULL)
	{
		PrintFault (IoErr (), argv[0]);
		exit (RETURN_FAIL);
	}

	pid = getpid ();

	if (args.nonames)
		nflag = 1;

	if (args.all)
	{
		dump (INADDR_ANY);

		exit (RETURN_OK);
	}

	if (args.delete)
	{
		if (args.hostname == NULL)
		{
			PrintFault (ERROR_REQUIRED_ARG_MISSING, argv[0]);
			exit (RETURN_FAIL);
		}

		delete (args.hostname, args.proxy);

		exit (RETURN_OK);
	}

	if (args.set)
	{
		int result;

		if (args.hostname == NULL || args.address == NULL)
		{
			PrintFault (ERROR_REQUIRED_ARG_MISSING, argv[0]);
			exit (RETURN_FAIL);
		}

		result = set (args.hostname, args.address, args.temp, args.publish);
		if (result != 0)
			result = RETURN_ERROR;

		exit (result);
	}

	if (args.file != NULL)
	{
		int result;

		result = file (args.file);

		if (result != 0)
			result = RETURN_ERROR;

		exit (result);
	}

	if (args.hostname == NULL)
	{
		PrintFault (ERROR_REQUIRED_ARG_MISSING, argv[0]);
		exit (RETURN_FAIL);
	}

	get (args.hostname);

	exit (RETURN_OK);
}

/*
 * Process a file to set standard arp entries
 */
int
file (char *name)
{
	FILE *fp;
	int i, retval;
	char line[100], arg[5][50];
	int temp, publish, j;

	if ((fp = fopen (name, "r")) == NULL)
	{
		fprintf (stderr, "arp: cannot open %s (%d, %s)\n", name, errno, strerror (errno));
		exit (RETURN_ERROR);
	}

	retval = 0;

	while (fgets (line, 100, fp) != NULL)
	{
		i = sscanf (line, "%s %s %s %s %s", arg[0], arg[1], arg[2], arg[3], arg[4]);
		if (i < 2)
		{
			fprintf (stderr, "arp: bad line: %s\n", line);
			retval = 1;
			continue;
		}

		temp = publish = 0;
		for (j = 0; j < 5; j++)
		{
			if (Stricmp (arg[j], "temp") == 0)
				temp = 1;

			if (Stricmp (arg[j], "pub") == 0)
				publish = 1;
		}

		if (set (arg[0], arg[1], temp, publish))
			retval = 1;
	}

	fclose (fp);

	return (retval);
}

void
getsocket (void)
{
	if (s < 0)
	{
		s = socket (PF_ROUTE, SOCK_RAW, 0);
		if (s < 0)
		{
			perror ("arp: socket");
			exit (RETURN_ERROR);
		}
	}
}

struct sockaddr_in so_mask = {8, 0, 0, { 0xffffffff}};
struct sockaddr_inarp blank_sin = {sizeof(blank_sin), AF_INET }, sin_m;
struct sockaddr_dl blank_sdl = {sizeof(blank_sdl), AF_LINK }, sdl_m;
int expire_time, flags, export_only, doing_proxy, found_entry;

struct
{
	struct	rt_msghdr m_rtm;
	char	m_space[512];
} m_rtmsg;

/*
 * Set an individual arp entry 
 */
int
set (char *host, char *eaddr, int temp, int publish)
{
	struct hostent *hp;
	register struct sockaddr_inarp *sin = &sin_m;
	register struct sockaddr_dl *sdl;
	register struct rt_msghdr *rtm = &(m_rtmsg.m_rtm);
	u_char *ea;

	getsocket ();

	sdl_m = blank_sdl;
	sin_m = blank_sin;

	sin->sin_addr.s_addr = inet_addr (host);
	if (sin->sin_addr.s_addr == -1)
	{
		if (!(hp = gethostbyname (host)))
		{
			fprintf (stderr, "arp: %s: ", host);
			herror ((char *) NULL);
			return (1);
		}

		bcopy ((char *) hp->h_addr, (char *) &sin->sin_addr, sizeof sin->sin_addr);
	}

	ea = (u_char *) LLADDR (&sdl_m);
	if (ether_aton (eaddr, ea) == 0)
		sdl_m.sdl_alen = 6;

	doing_proxy = flags = export_only = expire_time = 0;

	if (temp)
	{
		struct DateStamp ds;

		DateStamp (&ds);

		expire_time = UNIX_TIME_OFFSET + ((ds.ds_Days * 24 * 60) + ds.ds_Minute) * 60 + (ds.ds_Tick / TICKS_PER_SECOND) + 20 * 60;
	}
	else if (publish)
	{
		flags |= RTF_ANNOUNCE;
		doing_proxy = SIN_PROXY;
	}

 tryagain:

	if (rtmsg (RTM_GET) < 0)
	{
		perror (host);
		return (1);
	}

	sin = (struct sockaddr_inarp *) (rtm + 1);
	sdl = (struct sockaddr_dl *) (sin->sin_len + (char *) sin);

	if (sin->sin_addr.s_addr == sin_m.sin_addr.s_addr)
	{
		if (sdl->sdl_family == AF_LINK && (rtm->rtm_flags & RTF_LLINFO) && !(rtm->rtm_flags & RTF_GATEWAY))
		{
			switch (sdl->sdl_type)
			{
				case IFT_ETHER:
				case IFT_FDDI:
				case IFT_ISO88023:
				case IFT_ISO88024:
				case IFT_ISO88025:

					goto overwrite;
			}
		}

		if (doing_proxy == 0)
		{
			printf ("set: can only proxy for %s\n", host);
			return (1);
		}

		if (sin_m.sin_other & SIN_PROXY)
		{
			printf ("set: proxy entry exists for non 802 device\n");
			return (1);
		}

		sin_m.sin_other = SIN_PROXY;
		export_only = 1;
		goto tryagain;
	}

 overwrite:

	if (sdl->sdl_family != AF_LINK)
	{
		printf ("cannot intuit interface index and type for %s\n", host);
		return (1);
	}

	sdl_m.sdl_type = sdl->sdl_type;
	sdl_m.sdl_index = sdl->sdl_index;

	return (rtmsg (RTM_ADD));
}

/*
 * Display an individual arp entry
 */
void
get (char *host)
{
	struct hostent *hp;
	struct sockaddr_inarp *sin = &sin_m;

	sin_m = blank_sin;

	sin->sin_addr.s_addr = inet_addr (host);
	if (sin->sin_addr.s_addr == -1)
	{
		if (!(hp = gethostbyname (host)))
		{
			fprintf (stderr, "arp: %s: ", host);
			herror ((char *) NULL);
			exit (RETURN_ERROR);
		}

		bcopy ((char *) hp->h_addr, (char *) &sin->sin_addr, sizeof sin->sin_addr);
	}

	dump (sin->sin_addr.s_addr);

	if (found_entry == 0)
	{
		printf ("%s (%s) -- no entry\n", host, inet_ntoa (sin->sin_addr));
		exit (RETURN_WARN);
	}
}

/*
 * Delete an arp entry 
 */
int
delete (char *host, int proxy)
{
	struct hostent *hp;
	register struct sockaddr_inarp *sin = &sin_m;
	register struct rt_msghdr *rtm = &m_rtmsg.m_rtm;
	struct sockaddr_dl *sdl;

	if (proxy)
		export_only = 1;

	getsocket ();

	sin_m = blank_sin;
	sin->sin_addr.s_addr = inet_addr (host);

	if (sin->sin_addr.s_addr == -1)
	{
		if (!(hp = gethostbyname (host)))
		{
			fprintf (stderr, "arp: %s: ", host);
			herror ((char *) NULL);
			return (1);
		}

		bcopy ((char *) hp->h_addr, (char *) &sin->sin_addr, sizeof sin->sin_addr);
	}

 tryagain:

	if (rtmsg (RTM_GET) < 0)
	{
		perror (host);
		return (1);
	}

	sin = (struct sockaddr_inarp *) (rtm + 1);
	sdl = (struct sockaddr_dl *) (sin->sin_len + (char *) sin);

	if (sin->sin_addr.s_addr == sin_m.sin_addr.s_addr)
	{
		if (sdl->sdl_family == AF_LINK && (rtm->rtm_flags & RTF_LLINFO) && !(rtm->rtm_flags & RTF_GATEWAY))
		{
			switch (sdl->sdl_type)
			{
				case IFT_ETHER:
				case IFT_FDDI:
				case IFT_ISO88023:
				case IFT_ISO88024:
				case IFT_ISO88025:

					goto delete;
			}
		}
	}

	if (sin_m.sin_other & SIN_PROXY)
	{
		fprintf (stderr, "delete: can't locate %s\n", host);
		return (1);
	}
	else
	{
		sin_m.sin_other = SIN_PROXY;
		goto tryagain;
	}

 delete:

	if (sdl->sdl_family != AF_LINK)
	{
		printf ("cannot locate %s\n", host);
		return (1);
	}

	if (rtmsg (RTM_DELETE))
		return (1);

	printf ("%s (%s) deleted\n", host, inet_ntoa (sin->sin_addr));

	return (0);
}

/*
 * Dump the entire arp table
 */
void
dump (u_long addr)
{
	char *host, *buf, *next;
	struct rt_msghdr *rtm;
	struct sockaddr_inarp *sin;
	struct sockaddr_dl *sdl;
	struct hostent *hp;

	route_info = GetRouteInfo (AF_INET, RTF_LLINFO);
	if (route_info == NULL)
	{
		fprintf (stderr, "arp: routing table could not be retrieved (%s).\n", strerror (errno));
		exit (RETURN_FAIL);
	}

	buf = (char *) route_info;

	for (next = buf; ((struct rt_msghdr *) next)->rtm_msglen > 0; next += rtm->rtm_msglen)
	{
		rtm = (struct rt_msghdr *) next;
		sin = (struct sockaddr_inarp *) (rtm + 1);
		sdl = (struct sockaddr_dl *) (sin + 1);

		if (addr)
		{
			if (addr != sin->sin_addr.s_addr)
				continue;

			found_entry = 1;
		}

		if (nflag == 0)
			hp = gethostbyaddr ((APTR) & sin->sin_addr, sizeof sin->sin_addr, AF_INET);
		else
			hp = NULL;

		if (hp)
		{
			host = hp->h_name;
		}
		else
		{
			host = "?";
			if (h_errno == TRY_AGAIN)
				nflag = 1;
		}

		printf ("%s (%s) at ", host, inet_ntoa (sin->sin_addr));
		if (sdl->sdl_alen)
			ether_print ((u_char *) LLADDR (sdl));
		else
			printf ("(incomplete)");

		if (rtm->rtm_rmx.rmx_expire == 0)
			printf (" permanent");

		if (sin->sin_other & SIN_PROXY)
			printf (" published (proxy only)");

		if (rtm->rtm_addrs & RTA_NETMASK)
		{
			sin = (struct sockaddr_inarp *) (sdl->sdl_len + (char *) sdl);

			if (sin->sin_addr.s_addr == 0xffffffff)
				printf (" published");

			if (sin->sin_len != 8)
				printf ("(wierd)");
		}

		printf ("\n");
	}
}

void
ether_print (u_char * cp)
{
	printf ("%02x:%02x:%02x:%02x:%02x:%02x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]);
}

int
ether_aton (char *a, u_char * n)
{
	int i, o[6];

	i = sscanf (a, "%x:%x:%x:%x:%x:%x", &o[0], &o[1], &o[2], &o[3], &o[4], &o[5]);
	if (i != 6)
	{
		fprintf (stderr, "arp: invalid Ethernet address '%s'\n", a);
		return (1);
	}

	for (i = 0; i < 6; i++)
		n[i] = o[i];

	return (0);
}

int
rtmsg (int cmd)
{
	static int seq;
	int rlen;
	register struct rt_msghdr *rtm = &m_rtmsg.m_rtm;
	register char *cp = m_rtmsg.m_space;
	register int l;

	errno = 0;
	if (cmd == RTM_DELETE)
		goto doit;

	bzero ((char *) &m_rtmsg, sizeof (m_rtmsg));
	rtm->rtm_flags = flags;
	rtm->rtm_version = RTM_VERSION;

	switch (cmd)
	{
		default:

			fprintf (stderr, "arp: internal wrong cmd\n");
			exit (RETURN_ERROR);

		case RTM_ADD:

			rtm->rtm_addrs |= RTA_GATEWAY;
			rtm->rtm_rmx.rmx_expire = expire_time;
			rtm->rtm_inits = RTV_EXPIRE;
			rtm->rtm_flags |= (RTF_HOST | RTF_STATIC);

			sin_m.sin_other = 0;

			if (doing_proxy)
			{
				if (export_only)
				{
					sin_m.sin_other = SIN_PROXY;
				}
				else
				{
					rtm->rtm_addrs |= RTA_NETMASK;
					rtm->rtm_flags &= ~RTF_HOST;
				}
			}

			/*
			 * FALLTHROUGH 
			 */

		case RTM_GET:
			rtm->rtm_addrs |= RTA_DST;
	}

	#define NEXTADDR(w, s) \
		if (rtm->rtm_addrs & (w)) { \
			bcopy((char *)&s, cp, sizeof(s)); cp += sizeof(s);}

	NEXTADDR (RTA_DST, sin_m);
	NEXTADDR (RTA_GATEWAY, sdl_m);
	NEXTADDR (RTA_NETMASK, so_mask);

	rtm->rtm_msglen = cp - (char *) &m_rtmsg;

 doit:

	l = rtm->rtm_msglen;
	rtm->rtm_seq = ++seq;
	rtm->rtm_type = cmd;

	if ((rlen = write (s, (char *) &m_rtmsg, l)) < 0)
	{
		if (errno != ESRCH || cmd != RTM_DELETE)
		{
			perror ("writing to routing socket");
			return (-1);
		}
	}

	do
	{
		l = read (s, (char *) &m_rtmsg, sizeof (m_rtmsg));
	}
	while (l > 0 && (rtm->rtm_seq != seq || rtm->rtm_pid != pid));

	if (l < 0)
		(void) fprintf (stderr, "arp: read from routing socket: %s\n", strerror (errno));

	return (0);
}
