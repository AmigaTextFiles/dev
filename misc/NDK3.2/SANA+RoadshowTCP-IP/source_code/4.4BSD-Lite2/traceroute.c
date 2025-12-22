/*
 * traceroute.c
 *
 * Amiga port for Roadshow TCP/IP stack by Olaf Barthel,
 * public domain.
 *
 * :ts=4
 */

/*
 * Copyright (c) 1990, 1993
 * The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Van Jacobson.
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
 * traceroute host  - trace the route ip packets follow going to "host".
 *
 * Attempt to trace the route an ip packet would follow to some
 * internet host.  We find out intermediate hops by launching probe
 * packets with a small ttl (time to live) then listening for an
 * icmp "time exceeded" reply from a gateway.  We start our probes
 * with a ttl of one and increase by one until we get an icmp "port
 * unreachable" (which means we got to "host") or hit a max (which
 * defaults to 30 hops & can be changed with the -m flag).  Three
 * probes (change with -q flag) are sent at each ttl setting and a
 * line is printed showing the ttl, address of the gateway and
 * round trip time of each probe.  If the probe answers come from
 * different gateways, the address of each responding system will
 * be printed.  If there is no response within a 5 sec. timeout
 * interval (changed with the -w flag), a "*" is printed for that
 * probe.
 *
 * Probe packets are UDP format.  We don't want the destination
 * host to process them so the destination port is set to an
 * unlikely value (if some clod on the destination is using that
 * value, it can be changed with the -p flag).
 *
 * A sample use might be:
 *
 *     [yak 71]% traceroute nis.nsf.net.
 *     traceroute to nis.nsf.net (35.1.1.48), 30 hops max, 56 byte packet
 *      1  helios.ee.lbl.gov (128.3.112.1)  19 ms  19 ms  0 ms
 *      2  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  39 ms  19 ms
 *      3  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  39 ms  19 ms
 *      4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  39 ms  40 ms  39 ms
 *      5  ccn-nerif22.Berkeley.EDU (128.32.168.22)  39 ms  39 ms  39 ms
 *      6  128.32.197.4 (128.32.197.4)  40 ms  59 ms  59 ms
 *      7  131.119.2.5 (131.119.2.5)  59 ms  59 ms  59 ms
 *      8  129.140.70.13 (129.140.70.13)  99 ms  99 ms  80 ms
 *      9  129.140.71.6 (129.140.71.6)  139 ms  239 ms  319 ms
 *     10  129.140.81.7 (129.140.81.7)  220 ms  199 ms  199 ms
 *     11  nic.merit.edu (35.1.1.48)  239 ms  239 ms  239 ms
 *
 * Note that lines 2 & 3 are the same.  This is due to a buggy
 * kernel on the 2nd hop system -- lbl-csam.arpa -- that forwards
 * packets with a zero ttl.
 *
 * A more interesting example is:
 *
 *     [yak 72]% traceroute allspice.lcs.mit.edu.
 *     traceroute to allspice.lcs.mit.edu (18.26.0.115), 30 hops max
 *      1  helios.ee.lbl.gov (128.3.112.1)  0 ms  0 ms  0 ms
 *      2  lilac-dmc.Berkeley.EDU (128.32.216.1)  19 ms  19 ms  19 ms
 *      3  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  19 ms  19 ms
 *      4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  19 ms  39 ms  39 ms
 *      5  ccn-nerif22.Berkeley.EDU (128.32.168.22)  20 ms  39 ms  39 ms
 *      6  128.32.197.4 (128.32.197.4)  59 ms  119 ms  39 ms
 *      7  131.119.2.5 (131.119.2.5)  59 ms  59 ms  39 ms
 *      8  129.140.70.13 (129.140.70.13)  80 ms  79 ms  99 ms
 *      9  129.140.71.6 (129.140.71.6)  139 ms  139 ms  159 ms
 *     10  129.140.81.7 (129.140.81.7)  199 ms  180 ms  300 ms
 *     11  129.140.72.17 (129.140.72.17)  300 ms  239 ms  239 ms
 *     12  * * *
 *     13  128.121.54.72 (128.121.54.72)  259 ms  499 ms  279 ms
 *     14  * * *
 *     15  * * *
 *     16  * * *
 *     17  * * *
 *     18  ALLSPICE.LCS.MIT.EDU (18.26.0.115)  339 ms  279 ms  279 ms
 *
 * (I start to see why I'm having so much trouble with mail to
 * MIT.)  Note that the gateways 12, 14, 15, 16 & 17 hops away
 * either don't send ICMP "time exceeded" messages or send them
 * with a ttl too small to reach us.  14 - 17 are running the
 * MIT C Gateway code that doesn't send "time exceeded"s.  God
 * only knows what's going on with 12.
 *
 * The silent gateway 12 in the above may be the result of a bug in
 * the 4.[23]BSD network code (and its derivatives):  4.x (x <= 3)
 * sends an unreachable message using whatever ttl remains in the
 * original datagram.  Since, for gateways, the remaining ttl is
 * zero, the icmp "time exceeded" is guaranteed to not make it back
 * to us.  The behavior of this bug is slightly more interesting
 * when it appears on the destination system:
 *
 *      1  helios.ee.lbl.gov (128.3.112.1)  0 ms  0 ms  0 ms
 *      2  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  19 ms  39 ms
 *      3  lilac-dmc.Berkeley.EDU (128.32.216.1)  19 ms  39 ms  19 ms
 *      4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  39 ms  40 ms  19 ms
 *      5  ccn-nerif35.Berkeley.EDU (128.32.168.35)  39 ms  39 ms  39 ms
 *      6  csgw.Berkeley.EDU (128.32.133.254)  39 ms  59 ms  39 ms
 *      7  * * *
 *      8  * * *
 *      9  * * *
 *     10  * * *
 *     11  * * *
 *     12  * * *
 *     13  rip.Berkeley.EDU (128.32.131.22)  59 ms !  39 ms !  39 ms !
 *
 * Notice that there are 12 "gateways" (13 is the final
 * destination) and exactly the last half of them are "missing".
 * What's really happening is that rip (a Sun-3 running Sun OS3.5)
 * is using the ttl from our arriving datagram as the ttl in its
 * icmp reply.  So, the reply will time out on the return path
 * (with no notice sent to anyone since icmp's aren't sent for
 * icmp's) until we probe with a ttl that's at least twice the path
 * length.  I.e., rip is really only 7 hops away.  A reply that
 * returns with a ttl of 1 is a clue this problem exists.
 * Traceroute prints a "!" after the time if the ttl is <= 1.
 * Since vendors ship a lot of obsolete (DEC's Ultrix, Sun 3.x) or
 * non-standard (HPUX) software, expect to see this problem
 * frequently and/or take care picking the target host of your
 * probes.
 *
 * Other possible annotations after the time are !H, !N, !P (got a host,
 * network or protocol unreachable, respectively), !S or !F (source
 * route failed or fragmentation needed -- neither of these should
 * ever occur and the associated gateway is busted if you see one).  If
 * almost all the probes result in some kind of unreachable, traceroute
 * will give up and exit.
 *
 * Notes
 * -----
 * This program must be run by root or be setuid.  (I suggest that
 * you *don't* make it setuid -- casual use could result in a lot
 * of unnecessary traffic on our poor, congested nets.)
 *
 * This program requires a kernel mod that does not appear in any
 * system available from Berkeley:  A raw ip socket using proto
 * IPPROTO_RAW must interpret the data sent as an ip datagram (as
 * opposed to data to be wrapped in a ip datagram).  See the README
 * file that came with the source to this program for a description
 * of the mods I made to /sys/netinet/raw_ip.c.  Your mileage may
 * vary.  But, again, ANY 4.x (x < 4) BSD KERNEL WILL HAVE TO BE
 * MODIFIED TO RUN THIS PROGRAM.
 *
 * The udp port usage may appear bizarre (well, ok, it is bizarre).
 * The problem is that an icmp message only contains 8 bytes of
 * data from the original datagram.  8 bytes is the size of a udp
 * header so, if we want to associate replies with the original
 * datagram, the necessary information must be encoded into the
 * udp header (the ip id could be used but there's no way to
 * interlock with the kernel's assignment of ip id's and, anyway,
 * it would have taken a lot more kernel hacking to allow this
 * code to set the ip id).  So, to allow two or more users to
 * use traceroute simultaneously, we use this task's pid as the
 * source port (the high bit is set to move the port number out
 * of the "likely" range).  To keep track of which probe is being
 * replied to (so times and/or hop counts don't get confused by a
 * reply that was delayed in transit), we increment the destination
 * port number before each probe.
 *
 * Don't use this as a coding example.  I was trying to find a
 * routing problem and this code sort-of popped out after 48 hours
 * without sleep.  I was amazed it ever compiled, much less ran.
 *
 * I stole the idea for this program from Steve Deering.  Since
 * the first release, I've learned that had I attended the right
 * IETF working group meetings, I also could have stolen it from Guy
 * Almes or Matt Mathis.  I don't know (or care) who came up with
 * the idea first.  I envy the originators' perspicacity and I'm
 * glad they didn't keep the idea a secret.
 *
 * Tim Seaver, Ken Adelman and C. Philip Wood provided bug fixes and/or
 * enhancements to the original distribution.
 *
 * I've hacked up a round-trip-route version of this that works by
 * sending a loose-source-routed udp datagram through the destination
 * back to yourself.  Unfortunately, SO many gateways botch source
 * routing, the thing is almost worthless.  Maybe one day...
 *
 *  -- Van Jacobson (van@helios.ee.lbl.gov)
 *     Tue Dec 20 03:50:13 PST 1988
 */

#include <sys/errno.h>
#include <sys/socket.h>

#include <netinet/in_systm.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <netinet/udp.h>

#include <arpa/inet.h>

#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include <signal.h>

#ifdef __SASC
#include <constructor.h>
#endif /* __SASC */

#include <libraries/bsdsocket.h>

#include <exec/execbase.h>

#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <dos/dosasl.h>
#include <dos/rdargs.h>
#include <dos/stdio.h>

#define __USE_OLD_TIMEVAL__
#include <devices/timer.h>

#define NO_INLINE_STDARG
#undef __NOGLOBALIFACE__
#define __NOLIBBASE__

#include <proto/bsdsocket.h>
#include <proto/timer.h>
#include <proto/exec.h>
#include <proto/dos.h>

/****************************************************************************/

int __stack_size = 10000;

/****************************************************************************/

#include "traceroute_rev.h"

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
struct Device *TimerBase;
struct MsgPort *TimePort;
struct timerequest *TimeRequest;

/****************************************************************************/

#if defined(__amigaos4__)
struct SocketIFace * ISocket;
struct TimerIFace * ITimer;
#endif /* __amigaos4__ */

/****************************************************************************/

extern struct Library *SysBase;
extern struct Library *DOSBase;

/****************************************************************************/

static int
open_bsdsocket(void)
{
	struct TagItem tags[2];
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
		fprintf (stderr, "traceroute: Error opening \"%s\" V%ld.\n", "bsdsocket.library", 3);
		goto out;
	}

	TimePort = CreateMsgPort ();
	if (TimePort == NULL)
	{
		fprintf (stderr, "traceroute: Could not create timer message port.\n");
		goto out;
	}

	TimeRequest = (struct timerequest *) CreateIORequest (TimePort, sizeof (*TimeRequest));
	if (TimeRequest == NULL)
	{
		fprintf (stderr, "traceroute: Could not create timer I/O request.\n");
		goto out;
	}

	if (OpenDevice (TIMERNAME, UNIT_VBLANK, (struct IORequest *) TimeRequest, 0) != 0)
	{
		fprintf (stderr, "traceroute: Could not open '%s' unit %ld.\n", TIMERNAME, UNIT_VBLANK);
		goto out;
	}

	TimerBase = TimeRequest->tr_node.io_Device;

	#if defined(__amigaos4__)
	{
		if(TimerBase != NULL)
		{
			ITimer = (struct TimerIFace *)GetInterface(TimerBase, "main", 1, 0);
			if (ITimer == NULL)
			{
				fprintf (stderr, "traceroute: Could not open '%s' unit %ld.\n", TIMERNAME, UNIT_VBLANK);
				goto out;
			}
		}
	}
	#endif /* __amigaos4__ */

	tags[0].ti_Tag	= SBTM_SETVAL (SBTC_ERRNOPTR (sizeof (errno)));
	tags[0].ti_Data	= (ULONG)&errno;
	tags[1].ti_Tag	= TAG_END;

	SocketBaseTagList(tags);

	result = 0;

out:

	return (result);
}

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
	const ULONG b = 65536; /* Number base (16 bits). */

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

	if (TimeRequest != NULL)
	{
		if (TimeRequest->tr_node.io_Device != NULL)
			CloseDevice ((struct IORequest *) TimeRequest);

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
		exit(RETURN_FAIL);
}

void __attribute__ ((destructor))
_close_bsdsocket(void)
{
	close_bsdsocket();
}

#endif /* __GNUC__ */

/****************************************************************************/

void
finish(void)
{
	signal (SIGINT, SIG_IGN);

	fflush (stdout);
	fflush (stderr);

	PrintFault (ERROR_BREAK,NULL);

	exit (RETURN_WARN);
}

/****************************************************************************/

#ifdef __SASC

void __regargs
_CXBRK (void)
{
	finish();
}

#endif /* __SASC */

/****************************************************************************/

#define getpid() ((unsigned long)FindTask(NULL))
#define gettimeofday(timeval,timezone) get_eclock_time(timeval)
#define select(nfds,readfds,writefds,exceptfds,timeval) WaitSelect(nfds,readfds,writefds,exceptfds,timeval,NULL)
#define inet_ntoa(in) Inet_NtoA((in).s_addr)

/****************************************************************************/

int wait_for_reply (int sock, struct sockaddr_in *from);
void send_probe (int seq, int ttl);
double deltaT (struct timeval *t1p, struct timeval *t2p);
char *pr_type (UBYTE t);
int packet_ok (UBYTE * buf, int cc, struct sockaddr_in *from, int seq);
void print (UBYTE * buf, int cc, struct sockaddr_in *from);
void tvsub(struct timeval *out, const struct timeval *in);
char *inetname (struct in_addr in);

/****************************************************************************/

#define MAXPACKET 65535 /* max ip packet size */

/*
 * format of a (udp) probe packet.
 */
struct opacket
{
	struct ip ip;
	struct udphdr udp;
	UBYTE seq;				/* sequence number of this packet */
	UBYTE ttl;				/* ttl packet left with */
	struct timeval tv;		/* time packet left */
};

UBYTE packet[512];			/* last inbound (icmp) packet */
struct opacket *outpacket;	/* last output (udp) packet */

int s;						/* receive (icmp) socket file descriptor */
int sndsock;				/* send (udp) socket file descriptor */
/*struct timezone tz;*/		/* leftover */

struct sockaddr whereto;	/* Who to try to reach */
int datalen;				/* How much data */

char *source = 0;
char *hostname;

int nprobes = 3;
int max_ttl = 30;
UWORD ident;
UWORD port = 32768 + 666;	/* start udp dest port # for probe packets */
int options;				/* socket options */
int verbose;
int waittime = 5;			/* time to wait for response (in seconds) */
int nflag;					/* print addresses numerically */

/****** ROADSHOW/TRACEROUTE **************************************************
*
*   NAME
*	TRACEROUTE - print the route packets take to network host
*
*   FORMAT
*	TRACEROUTE [-m|MAXTTL <ttl>] [-n|NUMERIC] [-p|PORT <number>]
*	           [-q|QUERIES <number>] [-r|DONTROUTE] [-s|SOURCE <address>]
*	           [-t|TOS <type>] [-w|WAIT <time>] [-v|VERBOSE] [HOST <name>]
*	           [PACKETSIZE <size>]
*
*   TEMPLATE
*	-d=DEBUG/S,-m=MAXTTL/K/N,-n=NUMERIC/S,-p=PORT/K/N,-q=QUERIES/K/N,
*	-r=DONTROUTE/S,-s=SOURCE/K,-t=TOS/K/N,-v=VERBOSE/S,-w=WAIT/K/N,
*	HOST/A,PACKETSIZE/N
*
*   FUNCTION
*	The Internet is a large and complex aggregation of network hardware,
*	connected together by gateways. Tracking the route one's packets follow
*	(or finding the miscreant gateway that's discarding your packets) can be
*	difficult. Traceroute utilizes the IP protocol `time to live' field and
*	attempts to elicit an ICMP TIME_EXCEEDED response from each gateway along
*	the path to some host.
*
*	The only mandatory parameter is the destination host name or IP number.
*	The default probe datagram length is 38 bytes, but this may be increased
*	by specifying a packet size (in bytes) after the destination host name.
*
*   OPTIONS
*	-m, MAXTTL <ttl>
*	    Set the max time-to-live (max number of hops) used in outgoing
*	    probe packets. The default is 30 hops (the same default used for
*	    TCP connections).
*
*	-n, NUMERIC
*	    Print hop addresses numerically rather than symbolically and
*	    numerically (saves a nameserver address-to-name lookup for each
*	    gateway found on the path).
*
*	-p, PORT <number>
*	    Set the base UDP port number used in probes (default is 33434).
*	    Traceroute hopes that nothing is listening on UDP ports base to
*	    base+nhops-1 at the destination host (so an ICMP PORT_UNREACHABLE
*	    message will be returned to terminate the route tracing). If
*	    something is listening on a port in the default range, this
*	    option can be used to pick an unused port range.
*
*	-q, QUERIES <number>
*	    Set the number of probes per ``ttl'' (default is three probes).
*
*	-r, DONTROUTE
*	    Bypass the normal routing tables and send directly to a host on
*	    an attached network. If the host is not on a directly-attached
*	    network, an error is returned. This option can be used to ping a
*	    local host through an interface that has no route through it.
*
*	-s, SOURCE <address>
*	    Use the following IP address (which must be given as an IP
*	    number, not a hostname) as the source address in outgoing probe
*	    packets. On hosts with more than one IP address, this option can
*	    be used to force the source address to be something other than
*	    the IP address of the interface the probe packet is sent on. If
*	    the IP address is not one of this machine's interface addresses,
*	    an error is returned and nothing is sent.
*
*	-t, TOS <type>
*	    Set the type-of-service in probe packets to the following value
*	    (default zero). The value must be a decimal integer in the range
*	    0 to 255. This option can be used to see if different
*	    types-of-service result in different paths. Not all values of TOS
*	    are legal or meaningful - see the IP spec for definitions. Useful
*	    values are probably `-t 16' (low delay) and `-t 8' (high
*	    throughput).
*
*	-v, VERBOSE
*	    Verbose output. Received ICMP packets other than TIME_EXCEEDED
*	    and UNREACHABLEs are listed.
*
*	-w, WAIT <time>
*	    Set the time (in seconds) to wait for a response to a probe
*	    (default 3 sec.).
*
*   DESCRIPTION
*	This program attempts to trace the route an IP packet would follow to
*	some internet host by launching UDP probe packets with a small ttl
*	(time to live) then listening for an ICMP "time exceeded" reply from a
*	gateway. We start our probes with a ttl of one and increase by one
*	until we get an ICMP "port unreachable" (which means we got to "host")
*	or hit a max (which defaults to 30 hops & can be changed with the -m
*	flag). Three probes (changed with -q flag) are sent at each ttl
*	setting and a line is printed showing the ttl, address of the gateway
*	and round trip time of each probe. If the probe answers come from
*	different gateways, the address of each responding system will be
*	printed. If there is no response within a 3 sec. timeout interval
*	(changed with the -w flag), a "*" is printed for that probe.
*
*	We don't want the destination host to process the UDP probe packets so
*	the destination port is set to an unlikely value (if some clod on the
*	destination is using that value, it can be changed with the -p flag).
*
*	A sample use and output might be:
*
*	[yak 71]% traceroute nis.nsf.net.
*	traceroute to nis.nsf.net (35.1.1.48), 30 hops max, 56 byte packet
*	1  helios.ee.lbl.gov (128.3.112.1)  19 ms  19 ms  0 ms
*	2  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  39 ms  19 ms
*	3  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  39 ms  19 ms
*	4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  39 ms  40 ms  39 ms
*	5  ccn-nerif22.Berkeley.EDU (128.32.168.22)  39 ms  39 ms  39 ms
*	6  128.32.197.4 (128.32.197.4)  40 ms  59 ms  59 ms
*	7  131.119.2.5 (131.119.2.5)  59 ms  59 ms  59 ms
*	8  129.140.70.13 (129.140.70.13)  99 ms  99 ms  80 ms
*	9  129.140.71.6 (129.140.71.6)  139 ms  239 ms  319 ms
*	10  129.140.81.7 (129.140.81.7)  220 ms  199 ms  199 ms
*	11  nic.merit.edu (35.1.1.48)  239 ms  239 ms  239 ms
*
*	Note that lines 2 & 3 are the same. This is due to a buggy kernel on
*	the 2nd hop system - lbl-csam.arpa - that forwards packets with a zero
*	ttl (a bug in the distributed version of 4.3 BSD). Note that you have
*	to guess what path the packets are taking cross-country since the
*	NSFNet (129.140) doesn't supply address-to-name translations for its
*	NSSes.
*
*	A more interesting example is:
*
*	[yak 72]% traceroute allspice.lcs.mit.edu.
*	traceroute to allspice.lcs.mit.edu (18.26.0.115), 30 hops max
*	1  helios.ee.lbl.gov (128.3.112.1)  0 ms  0 ms  0 ms
*	2  lilac-dmc.Berkeley.EDU (128.32.216.1)  19 ms  19 ms  19 ms
*	3  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  19 ms  19 ms
*	4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  19 ms  39 ms  39 ms
*	5  ccn-nerif22.Berkeley.EDU (128.32.168.22)  20 ms  39 ms  39 ms
*	6  128.32.197.4 (128.32.197.4)  59 ms  119 ms  39 ms
*	7  131.119.2.5 (131.119.2.5)  59 ms  59 ms  39 ms
*	8  129.140.70.13 (129.140.70.13)  80 ms  79 ms  99 ms
*	9  129.140.71.6 (129.140.71.6)  139 ms  139 ms  159 ms
*	10  129.140.81.7 (129.140.81.7)  199 ms  180 ms  300 ms
*	11  129.140.72.17 (129.140.72.17)  300 ms  239 ms  239 ms
*	12  * * *
*	13  128.121.54.72 (128.121.54.72)  259 ms  499 ms  279 ms
*	14  * * *
*	15  * * *
*	16  * * *
*	17  * * *
*	18  ALLSPICE.LCS.MIT.EDU (18.26.0.115)  339 ms  279 ms  279 ms
*
*	Note that the gateways 12, 14, 15, 16 & 17 hops away either don't send
*	ICMP "time exceeded" messages or send them with a ttl too small to
*	reach us. 14 - 17 are running the MIT C Gateway code that doesn't send
*	"time exceeded"s. God only knows what's going on with 12.
*
*	The silent gateway 12 in the above may be the result of a bug in the
*	4.[23] BSD network code (and its derivatives): 4.x (x <= 3) sends an
*	unreachable message using whatever ttl remains in the original
*	datagram. Since, for gateways, the remaining ttl is zero, the ICMP
*	"time exceeded" is guaranteed to not make it back to us. The behavior
*	of this bug is slightly more interesting when it appears on the
*	destination system:
*
*	1  helios.ee.lbl.gov (128.3.112.1)  0 ms  0 ms  0 ms
*	2  lilac-dmc.Berkeley.EDU (128.32.216.1)  39 ms  19 ms  39 ms
*	3  lilac-dmc.Berkeley.EDU (128.32.216.1)  19 ms  39 ms  19 ms
*	4  ccngw-ner-cc.Berkeley.EDU (128.32.136.23)  39 ms  40 ms  19 ms
*	5  ccn-nerif35.Berkeley.EDU (128.32.168.35)  39 ms  39 ms  39 ms
*	6  csgw.Berkeley.EDU (128.32.133.254)  39 ms  59 ms  39 ms
*	7  * * *
*	8  * * *
*	9  * * *
*	10  * * *
*	11  * * *
*	12  * * *
*	13  rip.Berkeley.EDU (128.32.131.22)  59 ms !  39 ms !  39 ms !
*
*	Notice that there are 12 "gateways" (13 is the final destination) and
*	exactly the last half of them are "missing". What's really happening
*	is that rip (a Sun-3 running Sun OS3.5) is using the ttl from our
*	arriving datagram as the ttl in its ICMP reply. So, the reply will
*	time out on the return path (with no notice sent to anyone since
*	ICMP's aren't sent for ICMP's) until we probe with a ttl that's at
*	least twice the path length. I.e., rip is really only 7 hops away. A
*	reply that returns with a ttl of 1 is a clue this problem exists.
*	Traceroute prints a "!" after the time if the ttl is <= 1. Since
*	vendors ship a lot of obsolete (DEC's Ultrix, Sun 3.x) or non-standard
*	(HPUX) software, expect to see this problem frequently and/or take
*	care picking the target host of your probes. Other possible
*	annotations after the time are !H, !N, !P (got a host, network or
*	protocol unreachable, respectively), !S or !F (source route failed or
*	fragmentation needed - neither of these should ever occur and the
*	associated gateway is busted if you see one). If almost all the probes
*	result in some kind of unreachable, traceroute will give up and exit.
*
*	This program is intended for use in network testing, measurement and
*	management. It should be used primarily for manual fault isolation.
*	Because of the load it could impose on the network, it is unwise to
*	use traceroute during normal operations or from automated scripts.
*
*   AUTHOR
*	Implemented by Van Jacobson from a suggestion by Steve Deering.
*	Debugged by a cast of thousands with particularly cogent suggestions
*	or fixes from C. Philip Wood, Tim Seaver and Ken Adelman.
******************************************************************************
*/

int
main (int argc, char **argv)
{
	struct
	{
		SWITCH debug;
		NUMBER max_ttl;
		SWITCH numeric;
		NUMBER port;
		NUMBER queries;
		SWITCH dont_route;
		KEY source;
		NUMBER tos;
		SWITCH verbose;
		NUMBER wait;
		KEY host;
		NUMBER packet_size;
	} args;

	STRPTR args_template =
		"-d=DEBUG/S,"
		"-m=MAXTTL/K/N,"
		"-n=NUMERIC/S,"
		"-p=PORT/K/N,"
		"-q=QUERIES/K/N,"
		"-r=DONTROUTE/S,"
		"-s=SOURCE/K,"
		"-t=TOS/K/N,"
		"-v=VERBOSE/S,"
		"-w=WAIT/K/N,"
		"HOST/A,"
		"PACKETSIZE/N"
		VERSTAG;

	struct hostent *hp;
	struct protoent *pe;
	struct sockaddr_in from, *to;
	int i, on, probe, seq, tos, ttl;

	memset (&args, 0, sizeof (args));

	rda = ReadArgs (args_template, (LONG *) & args, NULL);
	if (rda == NULL)
	{
		PrintFault (IoErr (), argv[0]);
		exit (RETURN_FAIL);
	}

	#if defined(__GNUC__)
	{
		signal(SIGINT,finish);
	}
	#endif /* __GNUC__ */

	on = 1;
	seq = tos = 0;
	to = (struct sockaddr_in *) &whereto;

	if (args.debug)
		options |= SO_DEBUG;

	if (args.max_ttl != NULL)
	{
		max_ttl = (*args.max_ttl);
		if (max_ttl <= 1)
		{
			fprintf (stderr, "traceroute: max ttl must be >1.\n");

			exit (RETURN_ERROR);
		}
	}

	if (args.numeric)
		nflag++;

	if (args.port != NULL)
	{
		port = (*args.port);
		if (port < 1)
		{
			fprintf (stderr, "traceroute: port must be >0.\n");

			exit (RETURN_ERROR);
		}
	}

	if (args.queries != NULL)
	{
		nprobes = (*args.queries);
		if (nprobes < 1)
		{
			fprintf (stderr, "traceroute: nprobes must be >0.\n");

			exit (RETURN_ERROR);
		}
	}

	if (args.dont_route)
		options |= SO_DONTROUTE;

	if (args.source != NULL)
	{
		/*
		 * set the ip source address of the outbound
		 * probe (e.g., on a multi-homed host).
		 */
		source = args.source;
	}

	if (args.tos != NULL)
	{
		tos = (*args.tos);
		if (tos < 0 || tos > 255)
		{
			fprintf (stderr, "traceroute: tos must be 0 to 255.\n");

			exit (RETURN_ERROR);
		}
	}

	if (args.verbose)
		verbose++;

	if (args.wait != NULL)
	{
		waittime = (*args.wait);
		if (waittime <= 1)
		{
			fprintf (stderr, "traceroute: wait must be >1 sec.\n");

			exit (RETURN_ERROR);
		}
	}

	memset((char *) &whereto, 0, sizeof (struct sockaddr));
	to->sin_family = AF_INET;
	to->sin_addr.s_addr = inet_addr (args.host);

	if (to->sin_addr.s_addr != (~0UL))
	{
		hostname = args.host;
	}
	else
	{
		hp = gethostbyname (args.host);
		if (hp)
		{
			to->sin_family = hp->h_addrtype;
			memcpy (&to->sin_addr, hp->h_addr, hp->h_length);
			hostname = hp->h_name;
		}
		else
		{
			fprintf (stderr, "traceroute: unknown host %s\n", args.host);

			exit (RETURN_ERROR);
		}
	}

	if (args.packet_size != NULL)
	{
		datalen = (*args.packet_size);
		if (datalen < 0 || datalen >= MAXPACKET - (int)sizeof (struct opacket))
		{
			fprintf (stderr, "traceroute: packet size must be 0 <= s < %ld.\n", MAXPACKET - sizeof (struct opacket));

			exit (RETURN_ERROR);
		}
	}

	datalen += sizeof (struct opacket);

	outpacket = (struct opacket *) malloc ((unsigned) datalen);
	if (!outpacket)
	{
		perror ("traceroute: malloc");
		exit (RETURN_FAIL);
	}

	memset((char *) outpacket, 0, datalen);
	outpacket->ip.ip_dst = to->sin_addr;
	outpacket->ip.ip_tos = tos;
	outpacket->ip.ip_v = IPVERSION;
	outpacket->ip.ip_id = 0;

	ident = (getpid () & 0xffff) | 0x8000;

	if ((pe = getprotobyname ("icmp")) == NULL)
	{
		fprintf (stderr, "icmp: unknown protocol\n");
		exit (RETURN_FAIL);
	}

	if ((s = socket (AF_INET, SOCK_RAW, pe->p_proto)) < 0)
	{
		perror ("traceroute: icmp socket");
		exit (RETURN_FAIL);
	}

	if (options & SO_DEBUG)
		setsockopt (s, SOL_SOCKET, SO_DEBUG, (char *) &on, sizeof (on));

	if (options & SO_DONTROUTE)
		setsockopt (s, SOL_SOCKET, SO_DONTROUTE, (char *) &on, sizeof (on));

	if ((sndsock = socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0)
	{
		perror ("traceroute: raw socket");
		exit (RETURN_FAIL);
	}

	if (setsockopt (sndsock, SOL_SOCKET, SO_SNDBUF, (char *) &datalen, sizeof (datalen)) < 0)
	{
		perror ("traceroute: SO_SNDBUF");
		exit (RETURN_FAIL);
	}

	if (setsockopt (sndsock, IPPROTO_IP, IP_HDRINCL, (char *) &on, sizeof (on)) < 0)
	{
		perror ("traceroute: IP_HDRINCL");
		exit (RETURN_FAIL);
	}

	if (options & SO_DEBUG)
		setsockopt (sndsock, SOL_SOCKET, SO_DEBUG, (char *) &on, sizeof (on));

	if (options & SO_DONTROUTE)
		setsockopt (sndsock, SOL_SOCKET, SO_DONTROUTE, (char *) &on, sizeof (on));

	if (source)
	{
		memset((char *) &from, 0, sizeof (struct sockaddr));

		from.sin_family = AF_INET;
		from.sin_addr.s_addr = inet_addr (source);

		if (from.sin_addr.s_addr == (~0UL))
		{
			printf ("traceroute: unknown host %s\n", source);
			exit (RETURN_ERROR);
		}

		outpacket->ip.ip_src = from.sin_addr;
	}

	fprintf (stderr, "traceroute to %s (%s)", hostname, inet_ntoa (to->sin_addr));

	if (source)
		fprintf (stderr, " from %s", source);

	fprintf (stderr, ", %d hops max, %d byte packets\n", max_ttl, datalen);

	fflush (stderr);

	for (ttl = 1; ttl <= max_ttl; ++ttl)
	{
		ULONG lastaddr = 0;
		int got_there = 0;
		int unreachable = 0;

		printf ("%2d ", ttl);

		for (probe = 0; probe < nprobes; ++probe)
		{
			int cc;
			struct timeval t1, t2;
			/*struct timezone tz;*/
			struct ip *ip;

			gettimeofday (&t1, &tz);
			send_probe (++seq, ttl);

			while ((cc = wait_for_reply (s, &from)) != 0)
			{
				gettimeofday (&t2, &tz);

				if ((i = packet_ok (packet, cc, &from, seq)))
				{
					if (from.sin_addr.s_addr != lastaddr)
					{
						print (packet, cc, &from);
						lastaddr = from.sin_addr.s_addr;
					}

					printf ("  %.3f ms", deltaT (&t1, &t2));

					switch (i - 1)
					{
						case ICMP_UNREACH_PORT:

							ip = (struct ip *) packet;
							if (ip->ip_ttl <= 1)
								printf (" !");

							++got_there;
							break;

						case ICMP_UNREACH_NET:

							++unreachable;
							printf (" !N");
							break;

						case ICMP_UNREACH_HOST:

							++unreachable;
							printf (" !H");
							break;

						case ICMP_UNREACH_PROTOCOL:

							++got_there;
							printf (" !P");
							break;

						case ICMP_UNREACH_NEEDFRAG:

							++unreachable;
							printf (" !F");
							break;

						case ICMP_UNREACH_SRCFAIL:

							++unreachable;
							printf (" !S");
							break;
					}

					break;
				}
			}

			if (cc == 0)
				printf (" *");

			fflush (stdout);
		}

		putchar ('\n');

		if (got_there || unreachable >= nprobes - 1)
			exit (RETURN_OK);
	}
}

int
wait_for_reply (int sock, struct sockaddr_in *from)
{
	fd_set fds;
	struct timeval wait;
	int cc = 0;
	int fromlen = sizeof (*from);

	FD_ZERO (&fds);
	FD_SET (sock, &fds);
	wait.tv_secs = waittime;
	wait.tv_micro = 0;

	if (select (sock + 1, &fds, (fd_set *) 0, (fd_set *) 0, &wait) > 0)
		cc = recvfrom (s, (char *) packet, sizeof (packet), 0, (struct sockaddr *) from, (void *) &fromlen);

	return (cc);
}

void
send_probe (int seq, int ttl)
{
	struct opacket *op = outpacket;
	struct ip *ip = &op->ip;
	struct udphdr *up = &op->udp;
	int i;

	ip->ip_off = 0;
	ip->ip_hl = sizeof (*ip) >> 2;
	ip->ip_p = IPPROTO_UDP;
	ip->ip_len = datalen;
	ip->ip_ttl = ttl;
	ip->ip_v = IPVERSION;
	ip->ip_id = htons (ident + seq);

	up->uh_sport = htons (ident);
	up->uh_dport = htons (port + seq);
	up->uh_ulen = htons ((UWORD) (datalen - sizeof (struct ip)));
	up->uh_sum = 0;

	op->seq = seq;
	op->ttl = ttl;
	gettimeofday (&op->tv, &tz);

	i = sendto (sndsock, (char *) outpacket, datalen, 0, &whereto, sizeof (struct sockaddr));
	if (i < 0 || i != datalen)
	{
		if (i < 0)
			perror ("sendto");

		printf ("traceroute: wrote %s %d chars, ret=%d\n", hostname, datalen, i);

		fflush (stdout);
	}
}

double
deltaT (struct timeval *t1p, struct timeval *t2p)
{
	double dt;
	struct timeval delta;

	/* Subtract the seconds */
	delta.tv_secs = t2p->tv_secs - t1p->tv_secs;

	/* Check for underrun */
	if (t2p->tv_micro < t1p->tv_micro)
	{
		/* Borrow one second. */
		delta.tv_secs--;

		/* Put it all together again */
		delta.tv_micro = 1000000 - t1p->tv_micro + t2p->tv_micro;
	}
	else
	{
		/* No overrun -> just a normal subtraction */
		delta.tv_micro = t2p->tv_micro - t1p->tv_micro;
	}

	dt = ((double)delta.tv_secs) * 1000.0 + ((double)delta.tv_micro) / 1000.0;

/* This has issues if t2p->tv_micro < t1p->tv_micro
	dt = (double) (t2p->tv_secs - t1p->tv_secs) * 1000.0 +
		(double) (t2p->tv_micro - t1p->tv_micro) / 1000.0;
*/
	return (dt);
}

/*
 * Convert an ICMP "type" field to a printable string.
 */
char *
pr_type (UBYTE t)
{
	static char *ttab[] =
	{
		"Echo Reply", "ICMP 1", "ICMP 2", "Dest Unreachable",
		"Source Quench", "Redirect", "ICMP 6", "ICMP 7",
		"Echo", "ICMP 9", "ICMP 10", "Time Exceeded",
		"Param Problem", "Timestamp", "Timestamp Reply", "Info Request",
		"Info Reply"
	};

	if (t > 16)
		return ("OUT-OF-RANGE");

	return (ttab[t]);
}

int
packet_ok (UBYTE * buf, int cc, struct sockaddr_in *from, int seq)
{
	struct icmp *icp;
	UBYTE type, code;
	int hlen;
	struct ip *ip;

	ip = (struct ip *) buf;
	hlen = ip->ip_hl << 2;
	if (cc < hlen + ICMP_MINLEN)
	{
		if (verbose)
			printf ("packet too short (%d bytes) from %s\n", cc, inet_ntoa (from->sin_addr));

		return (0);
	}

	cc -= hlen;
	icp = (struct icmp *) (buf + hlen);
	type = icp->icmp_type;
	code = icp->icmp_code;

	if ((type == ICMP_TIMXCEED && code == ICMP_TIMXCEED_INTRANS) || type == ICMP_UNREACH)
	{
		struct ip *hip;
		struct udphdr *up;

		hip = &icp->icmp_ip;
		hlen = hip->ip_hl << 2;
		up = (struct udphdr *) ((UBYTE *) hip + hlen);

		if (hlen + 12 <= cc && hip->ip_p == IPPROTO_UDP && up->uh_sport == htons (ident) && up->uh_dport == htons (port + seq))
			return (type == ICMP_TIMXCEED ? -1 : code + 1);
	}

	if (verbose)
	{
		int i;
		ULONG *lp = (ULONG *) & icp->icmp_ip;

		printf ("\n%d bytes from %s to %s", cc, inet_ntoa (from->sin_addr), inet_ntoa (ip->ip_dst));
		printf (": icmp type %d (%s) code %d\n", type, pr_type (type), icp->icmp_code);
		for (i = 4; i < cc; i += sizeof (long))
			printf ("%2d: x%8.8lx\n", i, *lp++);
	}

	return (0);
}

void
print (UBYTE * buf, int cc, struct sockaddr_in *from)
{
	struct ip *ip;
	int hlen;

	ip = (struct ip *) buf;
	hlen = ip->ip_hl << 2;
	cc -= hlen;

	if (nflag)
		printf (" %s", inet_ntoa (from->sin_addr));
	else
		printf (" %s (%s)", inetname (from->sin_addr), inet_ntoa (from->sin_addr));

	if (verbose)
		printf (" %d bytes to %s", cc, inet_ntoa (ip->ip_dst));
}

/*
 * Subtract 2 timeval structs:  out = out - in
 * Out is assumed to be >= in.
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

static int _stricmp(const char *s1, const char * s2)
{
	int result;
	int c1,c2;
	
	while(tolower(*s1) == tolower(*s2))
	{
		if((*s1) == '\0')
			break;

		s1++;
		s2++;
	}

	/* The comparison must be performed as if the
	   characters were unsigned characters. */
	c1 = tolower(*(unsigned char *)s1);
	c2 = tolower(*(unsigned char *)s2);

	result = c1 - c2;

	return(result);
}

#define strcmp(a, b) _stricmp(a, b)

#define C(x) ((x) & 0xff)

/*
 * Construct an Internet address representation.
 * If the nflag has been supplied, give
 * numeric value, otherwise try for symbolic name.
 */
char *
inetname (struct in_addr in)
{
	char *cp;
	static char line[MAXHOSTNAMELEN+1];
	struct hostent *hp;
	static char domain[MAXHOSTNAMELEN+1];
	static int first = 1;

	if (first && !nflag)
	{
		first = 0;

		if (gethostname (domain, sizeof(MAXHOSTNAMELEN)-1) == 0 && (cp = strchr (domain, '.')) != NULL)
			memmove(domain,cp+1,strlen(cp+1)+1);
		else
			domain[0] = '\0';
	}

	cp = NULL;

	if (!nflag && in.s_addr != INADDR_ANY)
	{
		hp = gethostbyaddr ((char *) &in, sizeof (in), AF_INET);
		if (hp != NULL)
		{
			cp = strchr (hp->h_name, '.');
			if(cp != NULL)
			{
				if(strcmp (cp + 1, domain) == 0)
					(*cp) = '\0';
			}

			cp = hp->h_name;
		}
	}

	if (cp != NULL)
	{
		int len;

		len = strlen(cp);
		if(len > (int)sizeof(line)-1)
			len = sizeof(line)-1;

		memcpy (line, cp, len);
		line[len] = '\0';
	}
	else
	{
		in.s_addr = ntohl (in.s_addr);

		sprintf (line, "%lu.%lu.%lu.%lu",
			C(in.s_addr >> 24),
			C(in.s_addr >> 16),
			C(in.s_addr >> 8),
			C(in.s_addr));
	}

	return (line);
}
