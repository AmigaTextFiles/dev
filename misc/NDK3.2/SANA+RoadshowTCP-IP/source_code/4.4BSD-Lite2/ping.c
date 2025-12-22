/*
 * ping.c
 *
 * Amiga port for Roadshow TCP/IP stack by Olaf Barthel,
 * public domain.
 *
 * :ts=4
 */

/*
 * Copyright (c) 1989, 1993
 * The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Mike Muuss.
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
 * This product includes software developed by the University of
 * California, Berkeley and its contributors.
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
 *                      P I N G . C
 *
 * Using the InterNet Control Message Protocol (ICMP) "ECHO" facility,
 * measure round-trip-delays and packet loss across network paths.
 *
 * Author -
 *      Mike Muuss
 *      U. S. Army Ballistic Research Laboratory
 *      December, 1983
 *
 * Status -
 *      Public Domain.  Distribution Unlimited.
 * Bugs -
 *      More statistics could always be gathered.
 *      This program has to run SUID to ROOT to access the ICMP socket.
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/errno.h>

#include <netinet/in_systm.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <netinet/ip_var.h>
#include <netdb.h>
#include <ctype.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

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

#define __USE_OLD_TIMEVAL__
#include <devices/timer.h>

/****************************************************************************/

#define NO_INLINE_STDARG
#undef __NOGLOBALIFACE__
#define __NOLIBBASE__

#include <proto/bsdsocket.h>
#include <proto/timer.h>
#include <proto/exec.h>
#include <proto/dos.h>

/****************************************************************************/

#include "ping_rev.h"

/****************************************************************************/

#define BUSY ((struct IORequest *)NULL)

/****************************************************************************/

typedef LONG *NUMBER;
typedef LONG SWITCH;
typedef STRPTR KEY;

/****************************************************************************/

long __oslibversion = 37;

/****************************************************************************/

struct RDArgs *rda;

/****************************************************************************/

struct Library *SocketBase;

/****************************************************************************/

#if defined(__amigaos4__)
struct SocketIFace * ISocket;
struct TimerIFace *ITimer;
#endif /* __amigaos4__ */

/****************************************************************************/

struct MsgPort *TimePort;
struct timerequest *TimeRequest;
struct timerequest *TimeoutRequest;
struct Device *TimerBase;

/****************************************************************************/

BOOL TimeRequestSent;
BOOL TimeoutRequestSent;
BOOL TimerCatches;

/****************************************************************************/

int h_errno;

/****************************************************************************/

extern struct Library *SysBase;
extern struct Library *DOSBase;

/****************************************************************************/

int getopt (int argc, char *argv[], char *opts);
void alarm (ULONG seconds);
void catcher (void);
void pinger (void);
void pr_pack (char *buf, int cc, struct sockaddr_in *from);
int in_cksum (UWORD * addr, int len);
void tvsub(struct timeval *out, const struct timeval *in);
void finish (void);
void pr_icmph (struct icmp *icp);
void pr_iph (struct ip *ip);
char *pr_addr (ULONG l);
void pr_retip (struct ip *ip);

/****************************************************************************/

/* These arithmetic functions come from Harry S. Warren, Jr.'s book "Hacker's delight".
 * They are used for converting EClock time information into "normal" system time,
 * as returned by GetSysTime().
 */
#if defined(__SASC)

/* Computes the high-order half of the 64-bit product, unsigned. Derived from Knuth's Algorithm M. */
static ULONG mulhu (ULONG u, ULONG v)
{
	ULONG u0, u1, v0, v1, w0, w1, w2, t;

	u0 = u & 0xFFFF;
	u1 = u >> 16;

	v0 = v & 0xFFFF;
	v1 = v >> 16;

	w0 = u0 * v0;

	t = u1 * v0 + (w0 >> 16);

	w1 = t & 0xFFFF;
	w2 = t >> 16;
	w1 = u0 * v1 + w1;

	return u1 * v1 + w2 + (w1 >> 16);
}

/* Compute the number of leading zeros in a word. */
static int nlz (ULONG x)
{
	int n;

	if (x == 0)
	{
		n = 32;
	}
	else
	{
		n = 0;

		if (x <= 0x0000FFFFUL)
		{
			n = n + 16;
			x = x << 16;
		}

		if (x <= 0x00FFFFFFUL)
		{
			n = n + 8;
			x = x << 8;
		}

		if (x <= 0x0FFFFFFFUL)
		{
			n = n + 4;
			x = x << 4;
		}

		if (x <= 0x3FFFFFFFUL)
		{
			n = n + 2;
			x = x << 2;
		}

		if (x <= 0x7FFFFFFFUL)
			n = n + 1;
	}

	return n;
}

/* Long division, unsigned (64/32 ==> 32).
 * This procedure performs unsigned "long division" i.e., division of a
 * 64-bit unsigned dividend by a 32-bit unsigned divisor, producing a
 * 32-bit quotient.	 In the overflow cases (divide by 0, or quotient
 * exceeds 32 bits), it returns a remainder of 0xFFFFFFFF (an impossible
 * value).
 * The dividend is u1 and u0, with u1 being the most significant word.
 * The divisor is parameter v. The value returned is the quotient.
 */
static ULONG divlu (ULONG u1, ULONG u0, ULONG v, ULONG *r)
{
	const ULONG b = 65536;	/* Number base (16 bits). */

	ULONG	un1, un0,			/* Norm. dividend LSD's. */
			vn1, vn0,			/* Norm. divisor digits. */
			q1, q0,				/* Quotient digits. */
			un32, un21, un10,	/* Dividend digit pairs. */
			rhat;				/* A remainder. */

	int s; /* Shift amount for normalization. */

	/* If overflow, set remainder to an impossible value,
	 * and return the largest possible quotient.
	 */
	if (u1 >= v)
	{
		if (r != NULL)
			(*r) = 0xFFFFFFFFUL;

		return 0xFFFFFFFFUL;
	}

	/* 0 <= s <= 31. */
	s = nlz (v);

	/* Normalize divisor. */
	v = v << s;

	/* Break divisor up into two 16-bit digits. */
	vn1 = v >> 16;

	vn0 = v & 0xFFFF;

	/* Shift dividend left. */
	un32 = (u1 << s) | (u0 >> 32 - s) & (-s >> 31);
	un10 = u0 << s;

	/* Break right half of dividend into two digits. */
	un1 = un10 >> 16;
	un0 = un10 & 0xFFFF;

	/* Compute the first quotient digit, q1. */
	q1 = un32 / vn1;

	rhat = un32 - q1 * vn1;

 again1:

	if (q1 >= b || q1 * vn0 > b * rhat + un1)
	{
		q1 = q1 - 1;

		rhat = rhat + vn1;
		if (rhat < b)
			goto again1;
	}

	/* Multiply and subtract. */
	un21 = un32 * b + un1 - q1 * v;

	/* Compute the second quotient digit, q0. */
	q0 = un21 / vn1;

	rhat = un21 - q0 * vn1;

 again2:

	if (q0 >= b || q0 * vn0 > b * rhat + un0)
	{
		q0 = q0 - 1;

		rhat = rhat + vn1;
		if (rhat < b)
			goto again2;
	}

	/* If remainder is wanted, return it. */
	if (r != NULL)
		(*r) = (un21 * b + un0 - q0 * v) >> s;

	return q1 * b + q0;
}

#endif /* __SASC */

/****************************************************************************/

/* Obtain the current system time, as expressed in the number of EClock ticks
 * since the system was started. This number is converted into "normal"
 * time format, as returned by GetSysTime().
 */
static void get_eclock_time(struct timeval * eclock_time_now)
{
	/* On AmigaOS4 the time resolution is very high and it is not
	 * necessary to obtain time information through more complicated
	 * means.
	 */
	#if defined(__amigaos4__)
	{
		GetUpTime(eclock_time_now);
	}
	#else
	{
		struct EClockVal now;
		ULONG eclock_frequency;
		ULONG microseconds_remainder;

		eclock_frequency = ReadEClock(&now);

		#if defined(__GNUC__)
		{
			unsigned long long eclock_now = (((unsigned long long)now.ev_hi) << 32) | now.ev_lo;

			/* Turn the number of EClock ticks into the number of seconds
			 * and a remainder value which still needs to be normalized
			 * in order to yield the proper number of microseconds.
			 */
			eclock_time_now->tv_secs = eclock_now / eclock_frequency;
			microseconds_remainder = eclock_now % eclock_frequency;

			/* The remainder of the EClock frequency division needs to be
			 * normalized so that it comes out as the number of microseconds.
			 */
			eclock_time_now->tv_micro = (microseconds_remainder * 1000000) / eclock_frequency;
		}
		#else
		{
			ULONG microseconds_hi,microseconds_lo;

			/* Turn the number of EClock ticks into the number of seconds
			 * and a remainder value which still needs to be normalized
			 * in order to yield the proper number of microseconds.
			 */
			eclock_time_now->tv_secs = divlu(now.ev_hi, now.ev_lo, eclock_frequency, &microseconds_remainder);

			/* The remainder of the EClock frequency division needs to be
			 * normalized so that it comes out as the number of microseconds.
			 */
			microseconds_hi = mulhu(microseconds_remainder,1000000);
			microseconds_lo = microseconds_remainder * 1000000;

			eclock_time_now->tv_micro = divlu(microseconds_hi, microseconds_lo, eclock_frequency, NULL);
		}
		#endif /* __GNUC__ */

		/* Paranoia: make sure that the output is really "normal". */
		while(eclock_time_now->tv_micro > 1000000)
		{
			eclock_time_now->tv_secs++;

			eclock_time_now->tv_micro -= 1000000;
		}
	}
	#endif /* __amigaos4__ */
}

/****************************************************************************/

static int
open_bsdsocket(void)
{
	struct TagItem tags[4];
	int result = -1;

	SocketBase = OpenLibrary ("bsdsocket.library", 3);

	#if defined(__amigaos4__)
	{
		if(SocketBase != NULL)
		{
			ISocket = (struct SocketIFace *)GetInterface(SocketBase, "main", 1, 0);
			if (ISocket == NULL)
			{
				CloseLibrary(SocketBase);
				SocketBase = NULL;
			}
		}
	}
	#endif /* __amigaos4__ */

	if (SocketBase == NULL)
	{
		fprintf (stderr, "ping: Error opening \"%s\" V%ld.\n", "bsdsocket.library", 3);
		goto out;
	}

	TimePort = CreateMsgPort ();
	if (TimePort == NULL)
	{
		fprintf (stderr, "ping: Could not create timer message port.\n");
		goto out;
	}

	TimeRequest = (struct timerequest *) CreateIORequest (TimePort, sizeof (*TimeRequest));
	if (TimeRequest == NULL)
	{
		fprintf (stderr, "ping: Could not create timer I/O request.\n");
		goto out;
	}

	TimeoutRequest = (struct timerequest *) CreateIORequest (TimePort, sizeof (*TimeoutRequest));
	if (TimeoutRequest == NULL)
	{
		fprintf (stderr, "ping: Could not create timer I/O request.\n");
		goto out;
	}

	if (OpenDevice (TIMERNAME, UNIT_VBLANK, (struct IORequest *) TimeRequest, 0) != 0)
	{
		fprintf (stderr, "ping: Could not open '%s' unit %ld.\n", TIMERNAME, UNIT_VBLANK);
		goto out;
	}

	(*TimeoutRequest) = (*TimeRequest);
	TimeoutRequest->tr_node.io_Message.mn_Node.ln_Type = NT_REPLYMSG;

	TimerBase = TimeRequest->tr_node.io_Device;

	#if defined(__amigaos4__)
	{
		if(TimerBase != NULL)
		{
			ITimer = (struct TimerIFace *)GetInterface(TimerBase, "main", 1, 0);
			if (ITimer == NULL)
			{
				fprintf (stderr, "ping: Could not open '%s' unit %ld.\n", TIMERNAME, UNIT_VBLANK);
				goto out;
			}
		}
	}
	#endif /* __amigaos4__ */
	
	tags[0].ti_Tag	= SBTM_SETVAL (SBTC_ERRNOPTR (sizeof (errno)));
	tags[0].ti_Data = (ULONG)&errno;
	tags[1].ti_Tag	= SBTM_SETVAL (SBTC_BREAKMASK);
	tags[1].ti_Data = (SIGBREAKF_CTRL_C | (1UL << TimePort->mp_SigBit));
	tags[2].ti_Tag	= SBTM_SETVAL (SBTC_HERRNOLONGPTR);
	tags[2].ti_Data = (ULONG)&h_errno;
	tags[3].ti_Tag	= TAG_END;

	SocketBaseTagList(tags);

	result = 0;

out:

	return (result);
}

/****************************************************************************/

static void
close_bsdsocket(void)
{
	if (rda != NULL)
	{
		FreeArgs (rda);
		rda = NULL;
	}

	#if defined(__amigaos4__)
	{
		if(ISocket != NULL)
		{
			DropInterface((struct Interface *)ISocket);
			ISocket = NULL;
		}

		if(ITimer != NULL)
		{
			DropInterface((struct Interface *)ITimer);
			ITimer = NULL;
		}
	}
	#endif /* __amigaos4__ */

	if (TimeoutRequest != NULL)
	{
		if (TimeoutRequestSent)
		{
			if (CheckIO ((struct IORequest *) TimeoutRequest) == BUSY)
				AbortIO ((struct IORequest *) TimeoutRequest);

			WaitIO ((struct IORequest *) TimeoutRequest);

			TimeoutRequestSent = FALSE;
		}

		DeleteIORequest ((struct IORequest *) TimeoutRequest);
		TimeoutRequest = NULL;
	}

	if (TimeRequest != NULL)
	{
		if (TimeRequest->tr_node.io_Device != NULL)
		{
			if (TimeRequestSent)
			{
				if (CheckIO ((struct IORequest *) TimeRequest) == BUSY)
					AbortIO ((struct IORequest *) TimeRequest);

				WaitIO ((struct IORequest *) TimeRequest);
			}

			CloseDevice ((struct IORequest *) TimeRequest);
		}

		DeleteIORequest ((struct IORequest *) TimeRequest);
		TimeRequest = NULL;
	}

	if (TimePort != NULL)
	{
		DeleteMsgPort (TimePort);
		TimePort = NULL;
	}

	if (SocketBase != NULL)
	{
		CloseLibrary (SocketBase);
		SocketBase = NULL;
	}
}

/****************************************************************************/

#if defined(__SASC)

CBMLIB_CONSTRUCTOR (open_bsdsocket)
{
	return(open_bsdsocket());
}

CBMLIB_DESTRUCTOR (close_bsdsocket)
{
	close_bsdsocket();
}

#endif /* __SASC */

/****************************************************************************/

#if defined(__GNUC__)

void __attribute__ ((constructor))
_open_bsdsocket(void)
{
	if(DOSBase->lib_Version < 37 || open_bsdsocket() != 0)
		exit(EXIT_FAILURE);
}

void __attribute__ ((destructor))
_close_bsdsocket(void)
{
	close_bsdsocket();
}

#endif /* __GNUC__ */

/****************************************************************************/

void
alarm (ULONG seconds)
{
	if (TimeRequestSent)
	{
		if (CheckIO ((struct IORequest *) TimeRequest) == BUSY)
			AbortIO ((struct IORequest *) TimeRequest);

		WaitIO ((struct IORequest *) TimeRequest);
	}

	TimeRequest->tr_node.io_Command = TR_ADDREQUEST;
	TimeRequest->tr_time.tv_secs = seconds;
	TimeRequest->tr_time.tv_micro = 0;

	SendIO ((struct IORequest *) TimeRequest);
	TimeRequestSent = TRUE;
}

/****************************************************************************/

#if defined(__SASC)

void __regargs
_CXBRK (void)
{
	finish ();
}

#endif /* __SASC */

/****************************************************************************/

#define inet_ntoa(in) Inet_NtoA((in).s_addr)
#define getpid() ((unsigned long)FindTask(NULL))
#define gettimeofday(timeval,timezone) get_eclock_time(timeval)
#define select(nfds,readfds,writefds,exceptfds,timeval) WaitSelect(nfds,readfds,writefds,exceptfds,timeval,NULL)

/****************************************************************************/

#define DEFDATALEN	(64 - 8)			/* default data length */
#define MAXIPLEN	60
#define MAXICMPLEN	76
#define MAXPACKET	(65536 - 60 - 8)	/* max packet size */
#define MAXWAIT		10					/* max seconds to wait for response */
#define NROUTES		9					/* number of record route slots */

#define A(bit)		rcvd_tbl[(bit)>>3]		/* identify byte in array */
#define B(bit)		(1 << ((bit) & 0x07))	/* identify bit in byte */
#define SET(bit)	(A(bit) |= B(bit))
#define CLR(bit)	(A(bit) &= (~B(bit)))
#define TST(bit)	(A(bit) & B(bit))

/* various options */
int options;
#define F_FLOOD			0x001
#define F_INTERVAL		0x002
#define F_NUMERIC		0x004
#define F_PINGFILLED	0x008
#define F_QUIET			0x010
#define F_RROUTE		0x020
#define F_SO_DEBUG		0x040
#define F_SO_DONTROUTE	0x080
#define F_VERBOSE		0x100
#define F_BELL			0x200
#define F_ONE_REPLY		0x400

/*
 * MAX_DUP_CHK is the number of bits in received table, i.e. the maximum
 * number of received sequence numbers we can keep track of. Change 128
 * to 8192 for complete accuracy...
 */
#define MAX_DUP_CHK (8 * 128)
int mx_dup_ck = MAX_DUP_CHK;
char rcvd_tbl[MAX_DUP_CHK / 8];

struct sockaddr whereto;	/* who to ping */
int datalen = DEFDATALEN;
int s;						/* socket file descriptor */
UBYTE *outpack;
char BSPACE = '\b';			/* characters written for flood */
char DOT = '.';
char *hostname;
int ident;					/* process id to identify our packets */

/* counters */
long npackets;				/* max packets to transmit */
long nreceived;				/* # of packets we got back */
long nrepeats;				/* number of duplicates */
long ntransmitted;			/* sequence # for outbound packets = #sent */
int interval = 1;			/* interval between packets */

/* timing */
int timing;					/* flag to do timing */
double tmin = 999999999.0;	/* minimum round trip time */
double tmax = 0.0;			/* maximum round trip time */
double tsum = 0.0;			/* sum of all times, for doing average */

/****************************************************************************/

/****** ROADSHOW/PING ********************************************************
*
*   NAME
*	PING - Send ICMP ECHO_REQUEST packets to network hosts
*
*   FORMAT
*	PING [-c|COUNT <number>] [-d|DEBUG] [-i|INTERVAL <wait>]
*	     [-l|LOAD <preload>] [-n|NUMERICONLY|NUMERIC] [-o|ONEREPLY]
*	     [-q|QUIET] [-R|RECORDROUTE] [DONTROUTE] [-s|SIZE <packetsize>]
*	     [-t|TIMEOUT <seconds>] [-v|VERBOSE] [BELL]
*	     [HOST] <host name or IP address>
*
*   TEMPLATE
*	-c=COUNT/K/N,-d=DEBUG/S,-i=INTERVAL/K/N,-l=LOAD/K/N,
*	-n=NUMERICONLY/S=NUMERIC/S,-o=ONEREPLY/S,-q=QUIET/S,-R=RECORDROUTE/S,
*	DONTROUTE/S,-s=SIZE/K/N,-t=TIMEOUT/K/N,-v=VERBOSE/S,BELL/S,
*	HOST/A
*
*   FUNCTION
*	PING uses the ICMP protocol's mandatory ECHO_REQUEST datagram to
*	elicit an ICMP ECHO_RESPONSE from a host or gateway. ECHO_REQUEST
*	datagrams (``pings'') have an IP and ICMP header, followed by a
*	``struct timeval'' and then an arbitrary number of ``pad'' bytes used
*	to fill out the packet.
*
*   OPTIONS
*	-c, COUNT <number>
*	    Stop after sending (and receiving) <number> ECHO_RESPONSE packets.
*
*	-d, DEBUG
*	    Set the SO_DEBUG option on the socket being used.
*
*	-i, INTERVAL <wait>
*	    Wait <wait> seconds between sending each packet. The default is to
*	    wait for one second between each packet.
*
*	-l, LOAD <preload>
*	    If <preload> is specified, PING sends that many packets as fast as
*	    possible before falling into its normal mode of behavior.
*
*	-n, NUMERICONLY, NUMERIC
*	    Numeric output only.  No attempt will be made to lookup symbolic
*	    names for host addresses.
*
*	-o, ONEREPLY
*	    Exit as soon as one reply to a packet sent has been received.
*
*	-q, QUIET
*	    Quiet output.  Nothing is displayed except the summary lines at
*	    startup time and when finished.
*
*	-R, RECORDROUTE
*	    Record route. Includes the RECORD_ROUTE option in the
*	    ECHO_REQUEST packet and displays the route buffer on returned
*	    packets. Note that the IP header is only large enough for nine
*	    such routes. Many hosts ignore or discard this option.
*
*	DONTROUTE
*	    Bypass the normal routing tables and send directly to a host
*	    on an attached network. If the host is not on a
*	    directly-attached network, an error is returned. This option
*	    can be used to ping a local host through an interface that has
*	    no route through it.
*
*	-s, SIZE <packetsize>
*	    Specifies the number of data bytes to be sent. The default is
*	    56, which translates into 64 ICMP data bytes when combined
*	    with the 8 bytes of ICMP header data.
*
*	-t, TIMEOUT <seconds>
*	    Regardless of how many packets were received, this will make
*	    ping exit after the given number of seconds have elapsed. Note
*	    that the timeout value must be > 0.
*
*	-v, VERBOSE
*	    Verbose output. ICMP packets other than ECHO_RESPONSE that are
*	    received are listed.
*
*	BELL
*	    Print a 'bell' control character for each packet received, which
*	    on the Amiga either flashes the display or plays a sound.
*
*   NOTES
*	When using ping for fault isolation, it should first be run on the
*	local host, to verify that the local network interface is up and
*	running. Then, hosts and gateways further and further away should be
*	``pinged''. Round-trip times and packet loss statistics are computed.
*	If duplicate packets are received, they are not included in the packet
*	loss calculation, although the round trip time of these packets is
*	used in calculating the minimum/average/maximum round-trip time
*	numbers. When the specified number of packets have been sent (and
*	received) or if the program is terminated with a SIGINT, a brief
*	summary is displayed.
*
*	This program is intended for use in network testing, measurement and
*	management. Because of the load it can impose on the network, it is
*	unwise to use ping during normal operations or from automated scripts.
*
*   ICMP PACKET DETAILS
*	An IP header without options is 20 bytes. An ICMP ECHO_REQUEST packet
*	contains an additional 8 bytes worth of ICMP header followed by an
*	arbitrary amount of data. When a packetsize is given, this indicated
*	the size of this extra piece of data (the default is 56). Thus the
*	amount of data received inside of an IP packet of type ICMP ECHO_REPLY
*	will always be 8 bytes more than the requested data space (the ICMP
*	header).
*
*	If the data space is at least eight bytes large, ping uses the first
*	eight bytes of this space to include a timestamp which it uses in the
*	computation of round trip times. If less than eight bytes of pad are
*	specified, no round trip times are given.
*
*   DUPLICATE AND DAMAGED PACKETS
*	Ping will report duplicate and damaged packets. Duplicate packets
*	should never occur, and seem to be caused by inappropriate link-level
*	retransmissions. Duplicates may occur in many situations and are
*	rarely (if ever) a good sign, although the presence of low levels of
*	duplicates may not always be cause for alarm.
*
*	Damaged packets are obviously serious cause for alarm and often
*	indicate broken hardware somewhere in the ping packet's path (in the
*	network or in the hosts).
*
*   TRYING DIFFERENT DATA PATTERNS 
*	The (inter)network layer should never treat packets differently
*	depending on the data contained in the data portion. Unfortunately,
*	data-dependent problems have been known to sneak into networks and
*	remain undetected for long periods of time. In many cases the
*	particular pattern that will have problems is something that doesn't
*	have sufficient ``transitions'', such as all ones or all zeros, or a
*	pattern right at the edge, such as almost all zeros. It isn't
*	necessarily enough to specify a data pattern of all zeros (for
*	example) on the command line because the pattern that is of interest
*	is at the data link level, and the relationship between what you type
*	and what the controllers transmit can be complicated.
*
*	This means that if you have a data-dependent problem you will probably
*	have to do a lot of testing to find it. If you are lucky, you may
*	manage to find a file that either can't be sent across your network or
*	that takes much longer to transfer than other similar length files.
*	You can then examine this file for repeated patterns that you can test
*	using the -p option of ping.
*
*   TTL DETAILS
*	The TTL value of an IP packet represents the maximum number of IP
*	routers that the packet can go through before being thrown away. In
*	current practice you can expect each router in the Internet to
*	decrement the TTL field by exactly one.
*
*	The TCP/IP specification states that the TTL field for TCP packets
*	should be set to 60, but many systems use smaller values (4.3 BSD uses
*	30, 4.2 used 15).
*
*	The maximum possible value of this field is 255, and most Unix systems
*	set the TTL field of ICMP ECHO_REQUEST packets to 255. This is why you
*	will find you can ``ping'' some hosts, but not reach them with
*	telnet or ftp.
*
*	In normal operation ping prints the ttl value from the packet it
*	receives. When a remote system receives a ping packet, it can do one
*	of three things with the TTL field in its response:
* 
*	- Not change it; this is what Berkeley Unix systems did before the
*	  4.3BSD-Tahoe release.  In this case the TTL value in the received
*	  packet will be 255 minus the number of routers in the round-trip
*	  path.
*
*	- Set it to 255; this is what current Berkeley Unix systems do.  In
*	  this case the TTL value in the received packet will be 255 minus the
*	  number of routers in the path from the remote system to the pinging
*	  host.
*
*	- Set it to some other value.  Some machines use the same value for
*	  ICMP packets that they use for TCP packets, for example either 30 or
*	  60.  Others may use completely wild values.
*
*   BUGS
*	Many Hosts and Gateways ignore the RECORD_ROUTE option.
*
*	The maximum IP header length is too small for options like
*	RECORD_ROUTE to be completely useful. There's not much that that can
*	be done about this, however.
*
******************************************************************************
*/

int
main (int argc, char **argv)
{
	struct
	{
		NUMBER count;
		SWITCH debug;
		NUMBER interval;
		NUMBER load;
		SWITCH numeric_only;
		SWITCH one_reply;
		SWITCH quiet;
		SWITCH record_route;
		SWITCH dont_route;
		NUMBER size;
		NUMBER timeout;
		SWITCH verbose;
		SWITCH bell;
		KEY host;
	} args;

	STRPTR args_template =
		"-c=COUNT/K/N,"
		"-d=DEBUG/S,"
		"-i=INTERVAL/K/N,"
		"-l=LOAD/K/N,"
		"-n=NUMERICONLY=NUMERIC/S,"
		"-o=ONEREPLY/S,"
		"-q=QUIET/S,"
		"-R=RECORDROUTE/S,"
		"DONTROUTE/S,"
		"-s=SIZE/K/N,"
		"-t=TIMEOUT/K/N,"
		"-v=VERBOSE/S,"
		"BELL/S,"
		"HOST/A"
		VERSTAG;

	struct hostent *hp;
	struct sockaddr_in *to;
	struct protoent *proto;
	int i;
	int hold, packlen, preload;
	UBYTE *datap, *packet;
	char *target, hnamebuf[MAXHOSTNAMELEN];
	char rspace[3 + 4 * NROUTES + 1]; /* record route space */

	memset (&args, 0, sizeof (args));

	rda = ReadArgs (args_template, (LONG *) & args, NULL);
	if (rda == NULL)
	{
		PrintFault (IoErr (), argv[0]);
		exit (EXIT_FAILURE);
	}

	outpack = malloc (MAXPACKET);
	if (outpack == NULL)
	{
		fprintf (stderr, "ping: not enough memory for packet output buffer.\n");
		exit (EXIT_FAILURE);
	}

	preload = 0;
	datap = &outpack[8 + sizeof (struct timeval)];

	if (args.count != NULL)
	{
		npackets = (*args.count);
		if (npackets <= 0)
		{
			fprintf (stderr, "ping: bad number of packets to transmit.\n");
			exit (EXIT_FAILURE);
		}
	}

	if (args.debug)
		options |= F_SO_DEBUG;

	if (args.interval != NULL)
	{
		interval = (*args.interval);
		if (interval <= 0)
		{
			fprintf (stderr, "ping: bad timing interval.\n");
			exit (EXIT_FAILURE);
		}

		options |= F_INTERVAL;
	}

	if (args.timeout && (*args.timeout) <= 0)
	{
		fprintf (stderr, "ping: timeout must be > 0.\n");
		exit (EXIT_FAILURE);
	}

	if (args.load != NULL)
	{
		preload = (*args.load);
		if (preload < 0)
		{
			fprintf (stderr, "ping: bad preload value.\n");
			exit (EXIT_FAILURE);
		}
	}

	if (args.numeric_only)
		options |= F_NUMERIC;

	if (args.one_reply)
		options |= F_ONE_REPLY;

	if (args.quiet)
		options |= F_QUIET;

	if (args.record_route)
		options |= F_RROUTE;

	if (args.dont_route)
		options |= F_SO_DONTROUTE;

	if (args.size != NULL)
	{
		datalen = (*args.size);

		if (datalen > MAXPACKET)
		{
			fprintf (stderr, "ping: packet size too large.\n");
			exit (EXIT_FAILURE);
		}

		if (datalen <= 0)
		{
			fprintf (stderr, "ping: illegal packet size.\n");
			exit (EXIT_FAILURE);
		}
	}

	if (args.verbose)
		options |= F_VERBOSE;

	if (args.bell)
		options |= F_BELL;

	target = args.host;

	memset (&whereto, 0, sizeof (struct sockaddr));
	to = (struct sockaddr_in *) &whereto;
	to->sin_family = AF_INET;
	to->sin_addr.s_addr = inet_addr (target);

	if (to->sin_addr.s_addr != (ULONG) - 1)
	{
		hostname = target;
	}
	else
	{
		hp = gethostbyname (target);
		if (!hp)
		{
			char * error_message;

			switch(h_errno)
			{
				case 1:

					error_message = "unknown host \"%s\"";
					break;

				case 2:

					error_message = "host name lookup failure for \"%s\"; try again";
					break;

				case 3:

					error_message = "unknown server error while looking up \"%s\"";
					break;

				case 4:

					error_message = "no address associated with \"%s\"";
					break;

				default:

					error_message = strerror(errno);
					break;
			}

			fprintf (stderr, "ping: ");
			fprintf (stderr, error_message, target);
			fprintf (stderr, "\n");

			exit (EXIT_FAILURE);
		}

		to->sin_family = hp->h_addrtype;

		memmove (&to->sin_addr, hp->h_addr, hp->h_length);
		strncpy (hnamebuf, hp->h_name, sizeof (hnamebuf) - 1);

		hostname = hnamebuf;
	}

	if (datalen >= (int)sizeof (struct timeval)) /* can we time transfer */
		timing = 1;

	packlen = datalen + MAXIPLEN + MAXICMPLEN;
	if (!(packet = (UBYTE *) malloc ((ULONG) packlen)))
	{
		fprintf (stderr, "ping: out of memory.\n");
		exit (EXIT_FAILURE);
	}

	for (i = 8; i < datalen; ++i)
		(*datap++) = i;

	ident = getpid () & 0xFFFF;

	if (!(proto = getprotobyname ("icmp")))
	{
		fprintf (stderr, "ping: unknown protocol icmp.\n");
		exit (EXIT_FAILURE);
	}

	if ((s = socket (AF_INET, SOCK_RAW, proto->p_proto)) < 0)
	{
		perror ("ping: socket");
		exit (EXIT_FAILURE);
	}

	hold = 1;

	if (options & F_SO_DEBUG)
		setsockopt (s, SOL_SOCKET, SO_DEBUG, (char *) &hold, sizeof (hold));

	if (options & F_SO_DONTROUTE)
		setsockopt (s, SOL_SOCKET, SO_DONTROUTE, (char *) &hold, sizeof (hold));

	/* record route option */
	if (options & F_RROUTE)
	{
		memset(rspace,0,sizeof(rspace));

		rspace[IPOPT_OPTVAL] = IPOPT_RR;
		rspace[IPOPT_OLEN] = sizeof (rspace) - 1;
		rspace[IPOPT_OFFSET] = IPOPT_MINOFF;

		if (setsockopt (s, IPPROTO_IP, IP_OPTIONS, rspace, sizeof (rspace)) < 0)
		{
			perror ("ping: record route");
			exit (EXIT_FAILURE);
		}
	}

	/*
	 * When pinging the broadcast address, you can get a lot of answers.
	 * Doing something so evil is useful if you are trying to stress the
	 * ethernet, or just want to fill the arp cache to get some stuff for
	 * /etc/ethers.
	 */
	hold = 48 * 1024;
	setsockopt (s, SOL_SOCKET, SO_RCVBUF, (char *) &hold, sizeof (hold));

	if (to->sin_family == AF_INET)
		printf ("PING %s (%s): %d data bytes\n", (hostname != NULL) ? hostname : "<unknown host>", inet_ntoa (*(struct in_addr *) &to->sin_addr.s_addr), datalen);
	else
		printf ("PING %s: %d data bytes\n", (hostname != NULL) ? hostname : "<unknown host>", datalen);

	TimerCatches = TRUE;

	#if defined(__GNUC__)
	{
		signal (SIGINT, finish);
	}
	#endif /* __GNUC__ */

	if (args.timeout && (*args.timeout) > 0)
	{
		TimeoutRequest->tr_node.io_Command = TR_ADDREQUEST;
		TimeoutRequest->tr_time.tv_secs = (*args.timeout);
		TimeoutRequest->tr_time.tv_micro = 0;

		SendIO ((struct IORequest *) TimeoutRequest);
		TimeoutRequestSent = TRUE;
	}

	while (preload--) /* fire off them quickies */
		pinger ();

	catcher (); /* start things going */

	for (;;)
	{
		struct sockaddr_in from;
		int cc;
		int fromlen;

		if (CheckSignal (1UL << TimePort->mp_SigBit))
		{
			if (TimeoutRequestSent && CheckIO ((struct IORequest *) TimeoutRequest) != BUSY)
			{
				WaitIO ((struct IORequest *) TimeoutRequest);
				TimeoutRequestSent = FALSE;

				finish();
			}

			if (TimeRequestSent && CheckIO ((struct IORequest *) TimeRequest) != BUSY)
			{
				WaitIO ((struct IORequest *) TimeRequest);
				TimeRequestSent = FALSE;

				if (TimerCatches)
					catcher ();
				else
					finish ();
			}
		}

		if (CheckSignal (SIGBREAKF_CTRL_C))
			finish ();

		fromlen = sizeof (from);

		if ((cc = recvfrom (s, (char *) packet, packlen, 0, (struct sockaddr *) &from, (void *) &fromlen)) < 0)
		{
			/* The alarm() timer elapsing, or the timeout occuring, as well
			 * as the Ctrl+C signal will interrupt the recvfrom() function.
			 * We will retest these signals in the loop code above.
			 */
			if (errno == EINTR)
				continue;

			perror ("ping: recvfrom");
			continue;
		}

		pr_pack ((char *) packet, cc, &from);

		if (npackets && nreceived >= npackets)
			break;
	}

	finish ();
}

/*
 * catcher --
 *      This routine causes another PING to be transmitted, and then
 * schedules another SIGALRM for 1 second from now.
 *
 * bug --
 *      Our sense of time will slowly skew (i.e., packets will not be
 * launched exactly at 1-second intervals).  This does not affect the
 * quality of the delay and loss statistics.
 */
void
catcher (void)
{
	int waittime;

	pinger ();

	TimerCatches = TRUE;

	if (!npackets || ntransmitted < npackets)
	{
		alarm ((ULONG) interval);
	}
	else
	{
		if (nreceived)
		{
			waittime = 2 * tmax / 1000;
			if (!waittime)
				waittime = 1;
		}
		else
		{
			waittime = MAXWAIT;
		}

		TimerCatches = FALSE;

		alarm ((ULONG) waittime);
	}
}

/*
 * pinger --
 *      Compose and transmit an ICMP ECHO REQUEST packet.  The IP packet
 * will be added on by the kernel.  The ID field is our UNIX process ID,
 * and the sequence number is an ascending integer.  The first 8 bytes
 * of the data portion are used to hold a UNIX "timeval" struct in VAX
 * byte-order, to compute the round-trip time.
 */
void
pinger (void)
{
	struct icmp *icp;
	int cc;
	int i;

	icp = (struct icmp *) outpack;
	icp->icmp_type = ICMP_ECHO;
	icp->icmp_code = 0;
	icp->icmp_cksum = 0;
	icp->icmp_seq = ntransmitted++;
	icp->icmp_id = ident; /* ID */

	CLR (icp->icmp_seq % mx_dup_ck);

	if (timing)
		gettimeofday ((struct timeval *) &outpack[8], (struct timezone *) NULL);

	cc = datalen + 8; /* skips ICMP portion */

	/* compute ICMP checksum here */
	icp->icmp_cksum = in_cksum ((UWORD *) icp, cc);

	i = sendto (s, (char *) outpack, cc, 0, &whereto, sizeof (struct sockaddr));

	if (i < 0 || i != cc)
	{
		if (i < 0)
			perror ("ping: sendto");

		printf ("ping: wrote %s %d chars, ret=%d\n", (hostname != NULL) ? hostname : "<unknown host>", cc, i);
	}
}

/*
 * pr_pack --
 *      Print out the packet, if it came from us.  This logic is necessary
 * because ALL readers of the ICMP socket get a copy of ALL ICMP packets
 * which arrive ('tis only fair).  This permits multiple copies of this
 * program to be run without having intermingled output (or statistics!).
 */
void
pr_pack (char *buf, int cc, struct sockaddr_in *from)
{
	struct icmp *icp;
	ULONG l;
	int i, j;
	UBYTE *cp, *dp;
	static int old_rrlen;
	static char old_rr[MAX_IPOPTLEN];
	struct ip *ip;
	struct timeval tv, *tp;
	double triptime = 0.0;
	int hlen, dupflag;

	gettimeofday (&tv, (struct timezone *) NULL);

	/* Check the IP header */
	ip = (struct ip *) buf;
	hlen = ip->ip_hl << 2;
	if (cc < hlen + ICMP_MINLEN)
	{
		if (options & F_VERBOSE)
			fprintf (stderr, "ping: packet too short (%d bytes) from %s\n", cc, inet_ntoa (*(struct in_addr *) &from->sin_addr.s_addr));

		return;
	}

	/* Now the ICMP part */
	cc -= hlen;
	icp = (struct icmp *) (buf + hlen);
	if (icp->icmp_type == ICMP_ECHOREPLY)
	{
		if (icp->icmp_id != ident)
			return; /* 'Twas not our ECHO */

		++nreceived;

		if (timing)
		{
			tp = (struct timeval *) icp->icmp_data;
			tvsub (&tv, tp);
			triptime = ((double) tv.tv_secs) * 1000.0 + ((double) tv.tv_micro) / 1000.0;
			tsum += triptime;

			if (triptime < tmin)
				tmin = triptime;

			if (triptime > tmax)
				tmax = triptime;
		}

		if (TST (icp->icmp_seq % mx_dup_ck))
		{
			++nrepeats;
			--nreceived;
			dupflag = 1;
		}
		else
		{
			SET (icp->icmp_seq % mx_dup_ck);
			dupflag = 0;
		}

		if (options & F_ONE_REPLY)
		{
			if (ntransmitted > 0 && nreceived > 0)
				finish ();
		}

		if (options & F_QUIET)
			return;

		if (options & F_BELL)
			printf ("\a");

		printf ("%d bytes from %s: icmp_seq=%u", cc, inet_ntoa (*(struct in_addr *) &from->sin_addr.s_addr), icp->icmp_seq);
		printf (" ttl=%d", ip->ip_ttl);

		if (timing)
			printf (" time=%.3f ms", triptime);

		if (dupflag)
			printf (" (DUP!)");

		/* check the data */
		cp = (UBYTE *) & icp->icmp_data[8];
		dp = &outpack[8 + sizeof (struct timeval)];

		for (i = 8; i < datalen; ++i, ++cp, ++dp)
		{
			if (*cp != *dp)
			{
				printf ("\nwrong data byte #%d should be 0x%x but was 0x%x", i, *dp, *cp);
				cp = (UBYTE *) & icp->icmp_data[0];

				for (i = 8; i < datalen; ++i, ++cp)
				{
					if ((i % 32) == 8)
						printf ("\n\t");

					printf ("%x ", *cp);
				}

				break;
			}
		}
	}
	else
	{
		/* We've got something other than an ECHOREPLY */
		if (!(options & F_VERBOSE))
			return;

		printf ("%d bytes from %s: ", cc, pr_addr (from->sin_addr.s_addr));

		pr_icmph (icp);
	}

	/* Display any IP options */
	cp = (UBYTE *) buf + sizeof (struct ip);

	for (; hlen > (int) sizeof (struct ip); --hlen, ++cp)
	{
		switch (*cp)
		{
			case IPOPT_EOL:

				hlen = 0;
				break;

			case IPOPT_LSRR:

				printf ("\nLSRR: ");

				hlen -= 2;

				j = *++cp;

				++cp;

				if (j > IPOPT_MINOFF)
				{
					for (;;)
					{
						l = *++cp;
						l = (l << 8) + *++cp;
						l = (l << 8) + *++cp;
						l = (l << 8) + *++cp;

						if (l == 0)
							printf ("\t0.0.0.0");
						else
							printf ("\t%s", pr_addr (ntohl (l)));

						hlen -= 4;

						j -= 4;

						if (j <= IPOPT_MINOFF)
							break;

						putchar ('\n');
					}
				}

				break;

			case IPOPT_RR:

				j = *++cp; /* get length */
				i = *++cp; /* and pointer */
				hlen -= 2;

				if (i > j)
					i = j;

				i -= IPOPT_MINOFF;

				if (i <= 0)
					continue;

				if (i == old_rrlen && cp == (UBYTE *) buf + sizeof (struct ip) + 2 && !memcmp (cp, old_rr, i))
				{
					printf ("\t(same route)");
					i = ((i + 3) / 4) * 4;
					hlen -= i;
					cp += i;
					break;
				}

				old_rrlen = i;
				memmove (old_rr, cp, i);
				printf ("\nRR: ");

				for (;;)
				{
					l = *++cp;
					l = (l << 8) + *++cp;
					l = (l << 8) + *++cp;
					l = (l << 8) + *++cp;

					if (l == 0)
						printf ("\t0.0.0.0");
					else
						printf ("\t%s", pr_addr (ntohl (l)));

					hlen -= 4;
					i -= 4;

					if (i <= 0)
						break;

					putchar ('\n');
				}

				break;

			case IPOPT_NOP:

				printf ("\nNOP");
				break;

			default:
				printf ("\nunknown option %x", *cp);
				break;
		}
	}

	putchar ('\n');
	fflush (stdout);
}

/*
 * in_cksum --
 *      Checksum routine for Internet Protocol family headers (C Version)
 */
int
in_cksum (UWORD * addr, int len)
{
	int nleft = len;
	UWORD *w = addr;
	int sum = 0;
	UWORD answer = 0;

	/*
	 * Our algorithm is simple, using a 32 bit accumulator (sum), we add
	 * sequential 16 bit words to it, and at the end, fold back all the
	 * carry bits from the top 16 bits into the lower 16 bits.
	 */
	while (nleft > 1)
	{
		sum += *w++;
		nleft -= 2;
	}

	/* mop up an odd byte, if necessary */
	if (nleft == 1)
	{
		*(UBYTE *) (&answer) = *(UBYTE *) w;
		sum += answer;
	}

	/* add back carry outs from top 16 bits to low 16 bits */
	sum = (sum >> 16) + (sum & 0xffff);		/* add hi 16 to low 16 */
	sum += (sum >> 16);						/* add carry */
	answer = ~sum;							/* truncate to 16 bits */
	return (answer);
}

/*
 * tvsub --
 *	Subtract 2 timeval structs:  out = out - in.  Out is assumed to
 * be >= in.
 */
void
tvsub(struct timeval *out, const struct timeval *in)
{
	if(out->tv_micro < in->tv_micro)
	{
		--out->tv_sec;

		out->tv_micro = 1000000 - in->tv_micro + out->tv_micro;
	}
	else
	{
		out->tv_micro -= in->tv_micro;
	}

	out->tv_sec -= in->tv_sec;
}

/*
 * finish --
 *      Print out statistics, and give up.
 */
void
finish (void)
{
	signal (SIGINT, SIG_IGN);
	putchar ('\n');
	fflush (stdout);

	printf ("--- %s ping statistics ---\n", (hostname != NULL) ? hostname : "<unknown host>");
	printf ("%ld packets transmitted, ", ntransmitted);
	printf ("%ld packets received, ", nreceived);

	if (nrepeats > 0)
		printf ("+%ld duplicates, ", nrepeats);

	if (ntransmitted)
	{
		if (nreceived > ntransmitted)
			printf ("-- somebody's printing up packets!");
		else
			printf ("%d%% packet loss", (int) (((ntransmitted - nreceived) * 100) / ntransmitted));
	}

	putchar ('\n');

	if (nreceived + nrepeats > 0 && timing)
		printf ("round-trip min/avg/max = %.3f/%.3f/%.3f ms\n", tmin, tsum / (nreceived + nrepeats), tmax);

	/* If a specific number of packets have been sent, but not as
	 * many responses have arrived, allow a script to test for the
	 * packets missing.
	 */
	if (npackets > 0 && nreceived < npackets)
		exit (RETURN_WARN);

	exit (EXIT_SUCCESS);
}

/*
 * pr_icmph --
 *      Print a descriptive string about an ICMP header.
 */
void
pr_icmph (struct icmp *icp)
{
	switch (icp->icmp_type)
	{
		case ICMP_ECHOREPLY:

			printf ("Echo Reply\n"); /* XXX ID + Seq + Data */
			break;

		case ICMP_UNREACH:

			switch (icp->icmp_code)
			{
				case ICMP_UNREACH_NET:

					printf ("Destination Net Unreachable\n");
					break;

				case ICMP_UNREACH_HOST:

					printf ("Destination Host Unreachable\n");
					break;

				case ICMP_UNREACH_PROTOCOL:

					printf ("Destination Protocol Unreachable\n");
					break;

				case ICMP_UNREACH_PORT:

					printf ("Destination Port Unreachable\n");
					break;

				case ICMP_UNREACH_NEEDFRAG:

					printf ("frag needed and DF set\n");
					break;

				case ICMP_UNREACH_SRCFAIL:

					printf ("Source Route Failed\n");
					break;

				default:

					printf ("Dest Unreachable, Bad Code: %d\n", icp->icmp_code);
					break;
			}

			/* Print returned IP header information */
			pr_retip ((struct ip *) icp->icmp_data);
			break;

		case ICMP_SOURCEQUENCH:

			printf ("Source Quench\n");
			pr_retip ((struct ip *) icp->icmp_data);
			break;

		case ICMP_REDIRECT:

			switch (icp->icmp_code)
			{
				case ICMP_REDIRECT_NET:

					printf ("Redirect Network");
					break;

				case ICMP_REDIRECT_HOST:

					printf ("Redirect Host");
					break;

				case ICMP_REDIRECT_TOSNET:

					printf ("Redirect Type of Service and Network");
					break;

				case ICMP_REDIRECT_TOSHOST:

					printf ("Redirect Type of Service and Host");
					break;

				default:

					printf ("Redirect, Bad Code: %d", icp->icmp_code);
					break;
			}

			printf ("(New addr: 0x%08lx)\n", icp->icmp_gwaddr.s_addr);
			pr_retip ((struct ip *) icp->icmp_data);
			break;

		case ICMP_ECHO:

			printf ("Echo Request\n"); /* XXX ID + Seq + Data */
			break;

		case ICMP_TIMXCEED:

			switch (icp->icmp_code)
			{
				case ICMP_TIMXCEED_INTRANS:

					printf ("Time to live exceeded\n");
					break;

				case ICMP_TIMXCEED_REASS:

					printf ("Frag reassembly time exceeded\n");
					break;

				default:

					printf ("Time exceeded, Bad Code: %d\n", icp->icmp_code);
					break;
			}

			pr_retip ((struct ip *) icp->icmp_data);
			break;

		case ICMP_PARAMPROB:

			printf ("Parameter problem: pointer = 0x%02x\n", icp->icmp_hun.ih_pptr);
			pr_retip ((struct ip *) icp->icmp_data);
			break;

		case ICMP_TSTAMP:

			printf ("Timestamp\n"); /* XXX ID + Seq + 3 timestamps */
			break;

		case ICMP_TSTAMPREPLY:

			printf ("Timestamp Reply\n"); /* XXX ID + Seq + 3 timestamps */
			break;

		case ICMP_IREQ:

			printf ("Information Request\n"); /* XXX ID + Seq */
			break;

		case ICMP_IREQREPLY:

			printf ("Information Reply\n");/* XXX ID + Seq */
			break;

		case ICMP_MASKREQ:

			printf ("Address Mask Request\n");
			break;

		case ICMP_MASKREPLY:

			printf ("Address Mask Reply\n");
			break;

		default:

			printf ("Bad ICMP type: %d\n", icp->icmp_type);
			break;
	}
}

/*
 * pr_iph --
 *      Print an IP header with options.
 */
void
pr_iph (struct ip *ip)
{
	int hlen;
	UBYTE *cp;

	hlen = ip->ip_hl << 2;
	cp = (UBYTE *) ip + 20; /* point to options */

	printf ("Vr HL TOS  Len   ID Flg  off TTL Pro  cks      Src      Dst Data\n");
	printf (" %1x  %1x  %02x %04x %04x", ip->ip_v, ip->ip_hl, ip->ip_tos, ip->ip_len, ip->ip_id);
	printf ("   %1x %04x", ((ip->ip_off) & 0xe000) >> 13, (ip->ip_off) & 0x1fff);
	printf ("  %02x  %02x %04x", ip->ip_ttl, ip->ip_p, ip->ip_sum);
	printf (" %s ", inet_ntoa (*(struct in_addr *) &ip->ip_src.s_addr));
	printf (" %s ", inet_ntoa (*(struct in_addr *) &ip->ip_dst.s_addr));

	/* dump and option bytes */
	while (hlen-- > 20)
		printf ("%02x", *cp++);

	putchar ('\n');
}

/*
 * pr_addr --
 *      Return an ascii host address as a dotted quad and optionally with
 * a hostname.
 */
char *
pr_addr (ULONG l)
{
	struct hostent *hp;
	static char buf[MAXHOSTNAMELEN + 80];

	if ((options & F_NUMERIC) || !(hp = gethostbyaddr ((char *) &l, 4, AF_INET)))
		sprintf (buf, "%s", inet_ntoa (*(struct in_addr *) &l));
	else
		sprintf (buf, "%s (%s)", hp->h_name, inet_ntoa (*(struct in_addr *) &l));

	return (buf);
}

/*
 * pr_retip --
 *      Dump some info on a returned (via ICMP) IP packet.
 */
void
pr_retip (struct ip *ip)
{
	int hlen;
	UBYTE *cp;

	pr_iph (ip);
	hlen = ip->ip_hl << 2;
	cp = (UBYTE *) ip + hlen;

	if (ip->ip_p == 6)
		printf ("TCP: from port %u, to port %u (decimal)\n", (*cp * 256 + *(cp + 1)), (*(cp + 2) * 256 + *(cp + 3)));
	else if (ip->ip_p == 17)
		printf ("UDP: from port %u, to port %u (decimal)\n", (*cp * 256 + *(cp + 1)), (*(cp + 2) * 256 + *(cp + 3)));
}
