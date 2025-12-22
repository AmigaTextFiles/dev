/*
 *		  Unofficial release 1.1.3
 *			B I N G
 *
 * Using the InterNet Control Message Protocol (ICMP) "ECHO" facility,
 * measure point-to-point bandwidth.
 *
 * Hack by Pierre Beyssac (pb@fasterix.freenix.fr), based on FreeBSD ping.
 * Comments and bug reports welcome !
 *
 * Original ping author -
 *	Mike Muuss
 *	U. S. Army Ballistic Research Laboratory
 *	December, 1983
 *
 *
 * Copyright (c) 1995,1997 Pierre Beyssac.
 * All rights reserved.
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
 *	This product includes software developed by Pierre Beyssac,
 *	Mike Muss, the University of California, Berkeley and its contributors.
 * 4. Neither the name of the author nor the names of any co-contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY PIERRE BEYSSAC AND CONTRIBUTORS ``AS IS'' AND
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
 *
 */

/* The original UCB copyright notice follows */

/*
 * Copyright (c) 1989 The Regents of the University of California.
 * All rights reserved.
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
 *
 */

#ifndef lint
char copyright[] =
"@(#) Copyright (c) 1989 The Regents of the University of California.\n\
 All rights reserved.\n";
#endif /* not lint */

#ifndef lint
static char rcsid[] = "$Id: bing.c,v 1.17 1997/01/23 21:00:03 pb Exp $";
#endif /* not lint */

/* Usual includes/declarations */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <math.h>

/* More specific includes/declarations */
#include <limits.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>

#ifdef WIN32

/* This variable is expected by getopt.c */
char* __progname;

#else

/* #include <unistd.h> */
#include <time.h>

#include <sys/param.h>
/* #include <sys/file.h> */
#include <sys/time.h>
#include <signal.h>
#include <math.h>

#endif /* WIN32 */

/* Network includes/definitions */

#ifdef WIN32

#define MAXHOSTNAMELEN	64

#include "win32/win32.h"
#include <winsock.h>
#include "win32/types.h"

#else

#include <netinet/in_systm.h>
#include <netinet/in.h>

#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#endif /* WIN32 */

/* These come either from the compatibility library or from the
 * standard libraries.
 */
#include <netinet/ip.h>
#include <netinet/ip_var.h>
#include <netinet/ip_icmp.h>

#include "mod_icmp.h"

/* System dependent apsects */
#ifdef NO_RANDOM
#define random		rand
#define srandom		srand
#endif

#ifdef NO_STRERROR
int sys_nerr;
char *sys_errlist[];
char *sys_unk = "Unknown error";
#define strerror(e)	(((e)>=sys_nerr||(e)<0)?sys_unk:sys_errlist[(e)])
#endif

#ifdef NO_SNPRINTF
#define snprintf sprintf
#define snfargs(str,size,format) str,format
#else
#ifdef WIN32
#define snprintf _snprintf
#endif
#define snfargs(str,size,format) str,size,format
#endif



#define	ICMP_TO_DATA(icp)	((u_char *)((icp)->icmp_data))

/*
 * The default small packet size should be big enough that no padding
 * needs to be done at the physical level (ethernet typically requires this).
 *
 * The initial value was chosen to be 8 bytes, just enough to
 * contain a struct timeval, but it proved too small. The current value is
 * chosen to be around 40 bytes. If you add the IP and ICMP headers, that
 * should be more than the minimal ethernet packet size.
 *
 * 44 is nice because that's 64 bytes less than the other value, which
 * has not been changed.
 *
 * The default big packet size is not too big so as not to waste resources
 * unless the user explicitly chooses to.
 */

#define	DEFDATALEN_SMALL	44	/* default small data len */
#define	DEFDATALEN_BIG		108	/* default big data len */

#define	MAXIPLEN	60
#define	MAXICMPLEN	76
#define	MAXPACKET	(65536 - 60 - 8)/* max packet size */
#define	MAXWAIT		10		/* max seconds to wait for response */
#define	NROUTES		9		/* number of record route slots */

#define	A(bit,tbl)	(tbl)[(unsigned)(bit)>>3] /* identify byte in array */
#define	B(bit)		(1 << ((bit) & 0x07))	/* identify bit in byte */
#define	SET(bit,tbl)	(A(bit,(tbl)) |= B(bit))
#define	CLR(bit,tbl)	(A(bit,(tbl)) &= (~B(bit)))
#define	TST(bit,tbl)	(A(bit,(tbl)) & B(bit))

/* various options */
int options;
#define	F_NODELTA	0x001
#define	F_INTERVAL	0x002
#define	F_NUMERIC	0x004
#define	F_PINGFILLED	0x008
#define	F_VVERBOSE	0x010
#define	F_RROUTE	0x020
#define	F_SO_DEBUG	0x040
#define	F_SO_DONTROUTE	0x080
#define	F_VERBOSE	0x100
#define	F_RANDOMFILL	0x200
#define	F_PEDANTIC	0x400
#define	F_WARN		0x800

/* multicast options */
int moptions;
#define MULTICAST_NOLOOP	0x001
#define MULTICAST_TTL		0x002
#define MULTICAST_IF		0x004

/*
 * MAX_DUP_CHK is the number of bits in received table, i.e. the maximum
 * number of received sequence numbers we can keep track of.  Change 128
 * to 8192 for complete accuracy...
 */
#define	MAX_DUP_CHK	(8 * 128)
unsigned short mx_dup_ck = MAX_DUP_CHK;
typedef char duptable[MAX_DUP_CHK / 8];

unsigned short icmpseq = 0;	/* Sequence number of last packet we sent */

int datalen_small = DEFDATALEN_SMALL;
int datalen_big = DEFDATALEN_BIG;
int datalen_step;
int bits;

/* From packet len, compute the index for the entry */

#define	datalen_to_index(len)	((len) == datalen_big	\
					? nts-1		\
					: ((len)-datalen_small)/datalen_step)

#define	datalen_check(len) ((len) >= datalen_small	\
			    && (len) <= datalen_big	\
			    && (((len) == datalen_big	\
				|| ((len)-datalen_small) % datalen_step == 0)))

icmp_handle my_icmp;		/* ICMP module handle */

u_char outpack[MAXPACKET];

/* counters */
long npackets = 1;		/* max sampling loops */
long nsamples;			/* max samples to take in a loop */
int maxwait = 4;		/* max wait for reply packet (seconds) */

FILE *samplefile = NULL;

/* timing */

struct dst {
	/* RTT statistics in ms */
	double tmin;			/* minimum */
	double tmax;			/* maximum */
	double tsum;			/* sum */
	double tsum2;			/* sum of squares */
	long nsamples;			/* number of samples */
};

#define	dst_newsample(dst,s) { \
	if ((s) < (dst)->tmin) (dst)->tmin = (s); \
	if ((s) > (dst)->tmax) (dst)->tmax = (s); \
	(dst)->tsum += (s); \
	(dst)->tsum2 += (s)*(s); \
	(dst)->nsamples++; \
}

#define dst_init(dst) { \
	(dst)->tmin = (double)LONG_MAX; \
	(dst)->tmax = 0.0; \
	(dst)->tsum = 0.0; \
	(dst)->tsum2 = 0.0; \
	(dst)->nsamples = 0; \
}

#define dst_min(dst)	((dst)->tmin)
#define dst_max(dst)	((dst)->tmax)
#define dst_avg(dst)	((dst)->nsamples ? (dst)->tsum/(dst)->nsamples : 0.0)

struct timestats {
	/* Time stats */
	struct dst rttstats;		/* round trip time stats */
					/* including # of packets we got back */
#define	nreceived rttstats.nsamples
	long nrepeats;			/* number of duplicates */
	long ntransmitted;		/* number of packets sent */
};

#define ts_init(ts)	\
	dst_init(&(ts)->rttstats);	\
	(ts)->nrepeats = (ts)->ntransmitted = 0;

struct hoststats {
	/* Host info */
	char hnamebuf[MAXHOSTNAMELEN];
	char *hostname;
	struct sockaddr_in whereto;
	struct sockaddr_in *to;
	struct timestats *ts;
};

duptable rcvd_tbl;		/* bit array for duplicate replies detection */

struct hoststats *phs;
int nhosts;

struct timestats *pts;
int nts = 2;

/* volatile */ char exit_flag = 0;

/* Compute variance */

double dst_var(dst)
	struct dst *dst;
{
    if (dst->nsamples > 1)
	return (dst->tsum2 - (dst->tsum * dst->tsum / dst->nsamples))
		/ (dst->nsamples-1);
    else
	return 0.0;
}

/* Compute standard deviation */

double dst_stddev(dst)
	struct dst *dst;
{
    double v = dst_var(dst);
    if (dst->nsamples > 1 && v > 0)
	return (double) sqrt(v);
    else
	return 0.0;
}

void set_ip(hs, target)
	struct hoststats *hs;
	char *target;
{
	struct hostent *hp;

	hs->to = &hs->whereto;

	memset((char *)hs->to, 0, sizeof(struct sockaddr_in));
	hs->to->sin_family = AF_INET;
	hs->to->sin_addr.s_addr = inet_addr(target);
	if (hs->to->sin_addr.s_addr != (u_int)-1)
		hs->hostname = target;
	else {
		hp = gethostbyname(target);
		if (!hp) {
			(void)fprintf(stderr,
			    "bing: unknown host %s\n", target);
			exit(1);
		}
		hs->to->sin_family = hp->h_addrtype;
		memcpy((caddr_t)&hs->to->sin_addr, hp->h_addr, hp->h_length);
		strncpy(hs->hnamebuf, hp->h_name, sizeof(hs->hnamebuf) - 1);
		hs->hnamebuf[sizeof(hs->hnamebuf)-1] = '\0';
		hs->hostname = hs->hnamebuf;
	}
}

void randomfill(bp, len, seed)
	char *bp;
	int len;
	long seed;
{
	/* Initialise the packet payload with random data.
	 * Note that on some platforms (e.g. Win32) RAND_MAX is less
	 * than INT_MAX. Thus we only use the lower byte of the returned
	 * int which in turn relies on the assumption that RAND_MAX+1
	 * is a power of 2. Fortunately this seems to always be the 
	 * case.
	 */
	srandom((unsigned)seed);
	while (len > 0) {
		*bp++ = (char)(random() & 0xff);
		len--;
	}
}

static long lastrand;
static char nrand;

void randominit(seed)
	long seed;
{
	srandom((unsigned)seed);
	nrand = 0;
}

u_char randomnext()
{
	u_char r;
	if (nrand-- == 0) {
		lastrand = random();
		nrand = 3;
	}
	r = lastrand >> 24;
	lastrand <<= 8;
	return r;
}

/*
 * pinger --
 * 	Compose and transmit an ICMP ECHO REQUEST packet.  The IP packet
 * will be added on by the kernel.  The ID field is our UNIX process ID,
 * and the sequence number is an ascending integer.
 */
void pinger(hs, datalen)
	struct hoststats *hs;
	int datalen;
{
	struct timestats *ts;
	register struct icmp *icp;
	register int cc;
	int i;

	ts = hs->ts + datalen_to_index(datalen);

	icp = (struct icmp *)outpack;
	icp->icmp_type = ICMP_ECHO;
	icp->icmp_code = 0;
	icp->icmp_seq = ++icmpseq;

	/* icmp_id and icmp_cksum will be filled-in by icmp_send() */

	ts->ntransmitted++;

	CLR(icp->icmp_seq % mx_dup_ck, rcvd_tbl);

	if (options & F_RANDOMFILL)
		randomfill((long *)(outpack + 8), datalen,
			   icp->icmp_seq);

	cc = datalen + 8;			/* skips ICMP portion */

	i = icmp_send(my_icmp,
		(char *)outpack, cc, 
		(struct sockaddr *)hs->to, sizeof(struct sockaddr));

	if (i < 0 || i != cc)  {
		if (i < 0)
			perror("icmp_send");
		(void)printf("bing: wrote %s %d chars, ret=%d\n",
		    hs->hostname, cc, i);
	}
}

/*
 * pr_iph --
 *	Print an IP header with options.
 */
void pr_iph(ip)
	struct ip *ip;
{
	int hlen;
	u_char *cp;

	hlen = ip->ip_hl << 2;
	cp = (u_char *)ip + 20;		/* point to options */

	(void)printf("Vr HL TOS  Len   ID Flg  off TTL Pro  cks      Src      Dst Data\n");
	(void)printf(" %1x  %1x  %02x %04x %04x",
	    ip->ip_v, ip->ip_hl, ip->ip_tos, ip->ip_len, ip->ip_id);
	(void)printf("   %1x %04x", ((ip->ip_off) & 0xe000) >> 13,
	    (ip->ip_off) & 0x1fff);
	(void)printf("  %02x  %02x %04x", ip->ip_ttl, ip->ip_p, ip->ip_sum);
#ifndef linux
	(void)printf(" %s ", inet_ntoa(*(struct in_addr *)&ip->ip_src.s_addr));
	(void)printf(" %s ", inet_ntoa(*(struct in_addr *)&ip->ip_dst.s_addr));
#else
	(void)printf(" %s ", inet_ntoa(*(struct in_addr *)&ip->ip_src));
	(void)printf(" %s ", inet_ntoa(*(struct in_addr *)&ip->ip_dst));
#endif
	/* dump any option bytes */
	while (hlen-- > 20) {
		(void)printf("%02x", *cp++);
	}
	(void)putchar('\n');
}

/*
 * pr_retip --
 *	Dump some info on a returned (via ICMP) IP packet.
 */
void pr_retip(ip)
	struct ip *ip;
{
	int hlen;
	u_char *cp;

	pr_iph(ip);
	hlen = ip->ip_hl << 2;
	cp = (u_char *)ip + hlen;

	if (ip->ip_p == 6)
		(void)printf("TCP: from port %u, to port %u (decimal)\n",
		    (*cp * 256 + *(cp + 1)), (*(cp + 2) * 256 + *(cp + 3)));
	else if (ip->ip_p == 17)
		(void)printf("UDP: from port %u, to port %u (decimal)\n",
			(*cp * 256 + *(cp + 1)), (*(cp + 2) * 256 + *(cp + 3)));
}

#ifdef notdef
static char *ttab[] = {
	"Echo Reply",		/* ip + seq + udata */
	"Dest Unreachable",	/* net, host, proto, port, frag, sr + IP */
	"Source Quench",	/* IP */
	"Redirect",		/* redirect type, gateway, + IP  */
	"Echo",
	"Time Exceeded",	/* transit, frag reassem + IP */
	"Parameter Problem",	/* pointer + IP */
	"Timestamp",		/* id + seq + three timestamps */
	"Timestamp Reply",	/* " */
	"Info Request",		/* id + sq */
	"Info Reply"		/* " */
};
#endif

/*
 * pr_icmph --
 *	Print a descriptive string about an ICMP header.
 */
void pr_icmph(icp)
	struct icmp *icp;
{
	switch(icp->icmp_type) {
	case ICMP_ECHOREPLY:
		(void)printf("Echo Reply\n");
		/* XXX ID + Seq + Data */
		break;
	case ICMP_UNREACH:
		switch(icp->icmp_code) {
		case ICMP_UNREACH_NET:
			(void)printf("Destination Net Unreachable\n");
			break;
		case ICMP_UNREACH_HOST:
			(void)printf("Destination Host Unreachable\n");
			break;
		case ICMP_UNREACH_PROTOCOL:
			(void)printf("Destination Protocol Unreachable\n");
			break;
		case ICMP_UNREACH_PORT:
			(void)printf("Destination Port Unreachable\n");
			break;
		case ICMP_UNREACH_NEEDFRAG:
			(void)printf("frag needed and DF set\n");
			break;
		case ICMP_UNREACH_SRCFAIL:
			(void)printf("Source Route Failed\n");
			break;
		default:
			(void)printf("Dest Unreachable, Bad Code: %d\n",
			    icp->icmp_code);
			break;
		}
		/* Print returned IP header information */
		pr_retip((struct ip *)ICMP_TO_DATA(icp));
		break;
	case ICMP_SOURCEQUENCH:
		(void)printf("Source Quench\n");
		pr_retip((struct ip *)ICMP_TO_DATA(icp));
		break;
	case ICMP_REDIRECT:
		switch(icp->icmp_code) {
		case ICMP_REDIRECT_NET:
			(void)printf("Redirect Network");
			break;
		case ICMP_REDIRECT_HOST:
			(void)printf("Redirect Host");
			break;
		case ICMP_REDIRECT_TOSNET:
			(void)printf("Redirect Type of Service and Network");
			break;
		case ICMP_REDIRECT_TOSHOST:
			(void)printf("Redirect Type of Service and Host");
			break;
		default:
			(void)printf("Redirect, Bad Code: %d", icp->icmp_code);
			break;
		}
		(void)printf("(New addr: 0x%08lx)\n",
			(unsigned long)icp->icmp_gwaddr.s_addr);
		pr_retip((struct ip *)ICMP_TO_DATA(icp));
		break;
	case ICMP_ECHO:
		(void)printf("Echo Request\n");
		/* XXX ID + Seq + Data */
		break;
	case ICMP_TIMXCEED:
		switch(icp->icmp_code) {
		case ICMP_TIMXCEED_INTRANS:
			(void)printf("Time to live exceeded\n");
			break;
		case ICMP_TIMXCEED_REASS:
			(void)printf("Frag reassembly time exceeded\n");
			break;
		default:
			(void)printf("Time exceeded, Bad Code: %d\n",
			    icp->icmp_code);
			break;
		}
		pr_retip((struct ip *)ICMP_TO_DATA(icp));
		break;
	case ICMP_PARAMPROB:
		(void)printf("Parameter problem: pointer = 0x%02x\n",
		    icp->icmp_hun.ih_pptr);
		pr_retip((struct ip *)ICMP_TO_DATA(icp));
		break;
	case ICMP_TSTAMP:
		(void)printf("Timestamp\n");
		/* XXX ID + Seq + 3 timestamps */
		break;
	case ICMP_TSTAMPREPLY:
		(void)printf("Timestamp Reply\n");
		/* XXX ID + Seq + 3 timestamps */
		break;
	case ICMP_IREQ:
		(void)printf("Information Request\n");
		/* XXX ID + Seq */
		break;
	case ICMP_IREQREPLY:
		(void)printf("Information Reply\n");
		/* XXX ID + Seq */
		break;
#ifdef ICMP_MASKREQ
	case ICMP_MASKREQ:
		(void)printf("Address Mask Request\n");
		break;
#endif
#ifdef ICMP_MASKREPLY
	case ICMP_MASKREPLY:
		(void)printf("Address Mask Reply\n");
		break;
#endif
	default:
		(void)printf("Bad ICMP type: %d\n", icp->icmp_type);
	}
}

/*
 * pr_addr --
 *	Return an ascii host address as a dotted quad and optionally with
 *      a hostname.
 */
char *
pr_addr(l)
	u_long l;
{
	struct hostent *hp;
	static char buf[80];

	if ((options & F_NUMERIC) ||
	    !(hp = gethostbyaddr((char *)&l, 4, AF_INET)))
	    (void)snprintf(snfargs(buf, sizeof(buf), "%s"), 
			   inet_ntoa(*(struct in_addr *)&l));
	else
	    (void)snprintf(snfargs(buf, sizeof(buf), "%s (%s)"),
			   hp->h_name,
			   inet_ntoa(*(struct in_addr *)&l));
	return(buf);
}

/*
 * pr_pack --
 *	Print out the packet, if it came from us.  This logic is necessary
 * because ALL readers of the ICMP socket get a copy of ALL ICMP packets
 * which arrive ('tis only fair).  This permits multiple copies of this
 * program to be run without having intermingled output (or statistics!).
 */
int pr_pack(buf, cc, from, elapsed)
	char *buf;
	int cc;
	struct sockaddr_in *from;
	double elapsed;
{
	struct timestats *ts;
	struct hoststats *hs;

	register struct icmp *icp;
	register u_long l;
	register int hn, i, j;
	register u_char *cp,*dp;
	u_char d;
	static int old_rrlen;
	static char old_rr[MAX_IPOPTLEN];
	struct ip *ip;
	int hlen, dupflag;
	int bcc = cc;

	/* ip header */
	ip = (struct ip *)buf;
	hlen = ip->ip_hl << 2;
	/* icmp header */
	bcc -= hlen;
	icp = (struct icmp *)(buf + hlen);

        /* Look for the source host in our list */
	hs = NULL;

	for (hn = 0; hn < nhosts; hn++) {
	    if (from->sin_addr.s_addr == phs[hn].to->sin_addr.s_addr) {
		hs = phs+hn;
		break;
	    }
	}

	if (hs == NULL) {
	    /*
	     * Never heard about this host...
	     * Can either be an unexpected reply to one of our packets,
	     * or a reply to somebody else (another ping/bing running on
	     * the same host as we do, for example).
	     * The best is to ignore it.
	     */
	    return -1;
	}
	if (!datalen_check(cc - 28)) {
	    if (!(options & F_VERBOSE))
		return -1;
	    (void)fprintf(stderr,
		  "bing: unexpected packet size (%d bytes) from %s\n", cc,
		  inet_ntoa(*(struct in_addr *)&from->sin_addr.s_addr));
	    pr_icmph(icp);
	} else {
		ts = &hs->ts[datalen_to_index(cc - 28)];
	}

	/* Check the IP header */
	if (bcc < ICMP_MINLEN) {
		if (!(options & F_VERBOSE))
		    return -1;
		(void)fprintf(stderr,
		  "bing: packet too short (%d bytes) from %s\n", cc,
		  inet_ntoa(*(struct in_addr *)&from->sin_addr.s_addr));
	}

	/* Now the ICMP part */
	if (icp->icmp_type == ICMP_ECHOREPLY) {
		if (icp->icmp_id != icmp_get_id(my_icmp))
			return -1;			/* 'Twas not our ECHO */
		if (icp->icmp_seq == icmpseq) {
		   /*
		    * This is the last packet we sent,
		    * 'elapsed' is the rtt.
		    */
		   dst_newsample(&ts->rttstats, elapsed);

		   if (samplefile) {
		      fprintf(samplefile, "%d\t%d\t%.3f\n",
			      hn, cc, elapsed);
		   }
		}

		if (TST(icp->icmp_seq % mx_dup_ck, rcvd_tbl)) {
			++(ts->nrepeats);
			dupflag = 1;
		} else {
			SET(icp->icmp_seq % mx_dup_ck, rcvd_tbl);
			dupflag = 0;
		}

		if (!(options & F_VVERBOSE))
			return 0;

		(void)printf("%d bytes from %s: icmp_seq=%u", cc,
		   inet_ntoa(*(struct in_addr *)&from->sin_addr.s_addr),
		   icp->icmp_seq);
		(void)printf(" ttl=%d", ip->ip_ttl);
		(void)printf(" time=%.3f ms", elapsed);
		if (dupflag)
			(void)printf(" (DUP!)");
		/* check the data */
		cp = ICMP_TO_DATA(icp);
		if (options & F_RANDOMFILL) {
			randominit(icp->icmp_seq);
		} else {
			dp = &outpack[8];
		}
		for (i = 8; i < cc; ++i, ++cp, ++dp) {
			if (options & F_RANDOMFILL) {
				d = randomnext();
			} else {
				d = *dp;
			}
			if (*cp != d) {
	(void)printf("\nwrong data byte #%d should be 0x%x but was 0x%x",
		    i, d, *cp);
				cp = ICMP_TO_DATA(icp);
				for (i = 8; i < cc; ++i, ++cp) {
					if ((i % 32) == 8)
						(void)printf("\n\t");
					(void)printf("%x ", *cp);
				}
				break;
			}
		}
	} else {
		/* We've got something other than an ECHOREPLY */
		if (!(options & F_VERBOSE))
		    return -1;
		(void)printf("%d bytes from %s: ", cc,
			pr_addr(from->sin_addr.s_addr));
			pr_icmph(icp);
	}

	/* Display any IP options */
	cp = (u_char *)buf + sizeof(struct ip);

	for (; hlen > (int)sizeof(struct ip); --hlen, ++cp)
		switch (*cp) {
		case IPOPT_EOL:
			hlen = 0;
			break;
		case IPOPT_LSRR:
			(void)printf("\nLSRR: ");
			hlen -= 2;
			j = *++cp;
			++cp;
			if (j > IPOPT_MINOFF)
				for (;;) {
					l = *++cp;
					l = (l<<8) + *++cp;
					l = (l<<8) + *++cp;
					l = (l<<8) + *++cp;
					if (l == 0)
						(void)printf("\t0.0.0.0");
				else
					(void)printf("\t%s", pr_addr(ntohl(l)));
				hlen -= 4;
				j -= 4;
				if (j <= IPOPT_MINOFF)
					break;
				(void)putchar('\n');
			}
			break;
		case IPOPT_RR:
			j = *++cp;		/* get length */
			i = *++cp;		/* and pointer */
			hlen -= 2;
			if (i > j)
				i = j;
			i -= IPOPT_MINOFF;
			if (i <= 0)
				continue;
			if (i == old_rrlen
			    && cp == (u_char *)buf + sizeof(struct ip) + 2
			    && !memcmp((char *)cp, old_rr, i)) {
				(void)printf("\t(same route)");
				i = ((i + 3) / 4) * 4;
				hlen -= i;
				cp += i;
				break;
			}
			old_rrlen = i;
			memcpy(old_rr, (char *)cp, i);
			(void)printf("\nRR: ");
			for (;;) {
				l = *++cp;
				l = (l<<8) + *++cp;
				l = (l<<8) + *++cp;
				l = (l<<8) + *++cp;
				if (l == 0)
					(void)printf("\t0.0.0.0");
				else
					(void)printf("\t%s", pr_addr(ntohl(l)));
				hlen -= 4;
				i -= 4;
				if (i <= 0)
					break;
				(void)putchar('\n');
			}
			break;
		case IPOPT_NOP:
			(void)printf("\nNOP");
			break;
		default:
			(void)printf("\nunknown option %x", *cp);
			break;
		}
	(void)putchar('\n');
	(void)fflush(stdout);
	return 0;
}

void ping_and_wait(hs, datalen, buf, buflen)
	struct hoststats *hs;
	int datalen;
	char *buf;
	int buflen;
{
	struct sockaddr_in from;
	int fromlen;
	int cc;
	struct timestats *ts;
	double elapsed;

	ts = hs->ts + datalen_to_index(datalen);
	fromlen = sizeof(from);

	pinger(hs, datalen);

	for (;;) {

	    /* Now read the reply packet */
	    cc = icmp_recv(my_icmp, buf, buflen,
			     (struct sockaddr *)&from, &fromlen,
			     &elapsed);

	    if (cc > 0) {
	       /* Print and exit if OK */
	       if (pr_pack((char *)buf, cc, &from, elapsed) == 0) {
		  break;
	       }
	    } else if (cc == 0) {
		/* Time out */
		break;
	    } else if (exit_flag) {
		ts->ntransmitted--;
		break;
	    }
	}
}

void warn_rtt(h1, h2, min1s, min1b, min2s, min2b)
	char *h1, *h2;
	double min1s, min1b, min2s, min2b;
{
	double deltab, deltas;
	char *pmsg = (options & F_PEDANTIC) ? " (ignored)" : "";

	/* Small packet rtts should be < big packet rtts */
	if (min1b < min1s)
		fprintf(stderr,
			"warning: rtt big %s %.3fms < rtt small %s %.3fms%s\n",
			h1, min1b, h1, min1s, pmsg);
	if (min2b < min2s)
		fprintf(stderr,
			"warning: rtt big %s %.3fms < rtt small %s %.3fms%s\n",
			h2, min2b, h2, min2s, pmsg);

	/* rtts to host1 should be < rtts to host2 */
	if (min1s > min2s)
		fprintf(stderr,
			"warning: rtt small %s %.3fms > rtt small %s %.3fms%s\n",
			h1, min1s, h2, min2s, pmsg);
	if (min1b > min2b)
		fprintf(stderr,
			"warning: rtt big %s %.3fms > rtt big %s %.3fms%s\n",
			h1, min1b, h2, min2b, pmsg);

	/* Delta on small packets should be < delta on big packets */
	deltab = min2b - min1b;
	deltas = min2s - min1s;
	if (deltab < deltas)
		fprintf(stderr,
			"warning: %s to %s delta big rtts %.3fms < delta small rtts %.3fms%s\n",
			h1, h2, deltab, deltas, pmsg);
}

/* Sanity checks and corrections for rtts */

void adapt_rtt(min1s, min1b, min2s, min2b)
	double *min1s, *min1b, *min2s, *min2b;
{
	double deltab, deltas;

	/* Don't correct anything if pedantic mode */
	if (options & F_PEDANTIC)
		return;

	/* Small packet rtts should be < big packet rtts */
	if (*min1b < *min1s) *min1s = *min1b;
	if (*min2b < *min2s) *min2s = *min2b;

	/* rtts to host1 should be < rtts to host2 */
	if (*min1s > *min2s) *min2s = *min1s;
	if (*min1b > *min2b) *min2b = *min1b;

	/* Delta on small packets should be < delta on big packets */
	deltab = *min2b - *min1b;
	deltas = *min2s - *min1s;
	if (deltab < deltas) {
		*min2s = *min2b;
		*min1s = *min1b;
	}
}

void
finishpa(ntransmitted, received, nrepeats, vmin, vavg, vmax, vsd)
	long ntransmitted, received, nrepeats;
	double vmin, vavg, vmax, vsd;
{
	/* XXX: float a; */

	(void)printf("%6ld%6ld", ntransmitted, received - nrepeats);
	if (nrepeats)
		(void)printf("%6ld", nrepeats);
	else
		(void)printf("      ");
	if (ntransmitted)
		if (received - nrepeats > ntransmitted)
			(void)printf("  ****\t");
		else
			(void)printf("%5d%%\t",
			    (int) (((ntransmitted - received + nrepeats)
				* 100) /
			    ntransmitted));
	else
		(void)printf("      \t");
	if (received - nrepeats)
		(void)printf("    %9.3f %9.3f %9.3f %9.3f\n",
			vmin,
			vavg,
			vmax,
			vsd);
	else
		(void)putchar('\n');
}

#define finishp(ts) finishpa((ts)->ntransmitted,		\
			     (ts)->nreceived,			\
			     (ts)->nrepeats,			\
			     dst_min(&(ts)->rttstats),		\
			     dst_avg(&(ts)->rttstats),		\
			     dst_max(&(ts)->rttstats),		\
			     dst_stddev(&(ts)->rttstats))

/*
 * finish --
 *	Print out ping statistics for one host
 */

void finish(hs)
	struct hoststats *hs;
{
	int j;

	(void)putchar('\n');
	(void)printf("--- %s statistics ---\n", hs->hostname);
	(void)printf(
"bytes   out    in   dup  loss\trtt (ms): min       avg       max   std dev\n");

	for (j = 0; j < nts; j++) {
	    (void)printf("%5d", j+1 == nts ? datalen_big
					   : datalen_small + j*datalen_step);
	    finishp(&hs->ts[j]);
	}
}

void finishit()
{
	double secs;
	double maxthru;
	double mindel;
	double rtt1s, rtt1b, rtt2s, rtt2b;
	struct hoststats *hs1, *hs2;

	int i;

	for (i = 0; i < nhosts; i++) {
	    hs2 = phs+i;
	    finish(hs2);
	}

	printf("\n--- estimated link characteristics ---\n");
	printf("host\t\t\t          bandwidth       ms\n");

	for (i = 1; i < nhosts; i++) {
	    hs1 = phs+i-1;
	    hs2 = phs+i;

	    if (hs1->ts[nts-1].nreceived == 0
		|| hs1->ts[0].nreceived == 0
		|| hs2->ts[nts-1].nreceived == 0
		|| hs2->ts[0].nreceived == 0) {

		(void)printf("%s: not enough received packets\n",
			     hs2->hostname);
		continue;
	    }

	    rtt1s = dst_min(&hs1->ts[0].rttstats);
	    rtt1b = dst_min(&hs1->ts[nts-1].rttstats);
	    rtt2s = dst_min(&hs2->ts[0].rttstats);
	    rtt2b = dst_min(&hs2->ts[nts-1].rttstats);
	    warn_rtt(hs1->hostname, hs2->hostname,
		     rtt1s, rtt1b, rtt2s, rtt2b);
	    adapt_rtt(&rtt1s, &rtt1b, &rtt2s, &rtt2b);
	    secs = (rtt2b - rtt1b) - (rtt2s - rtt1s);

	    if (secs == 0) {
		(void)printf(
"%s: minimum delay difference is zero, can't estimate link throughput.\n",
			hs2->hostname);
		continue;
	    }

	    maxthru = bits / secs * 1e3;
	    mindel = (dst_min(&hs2->ts[0].rttstats)
		      - dst_min(&hs1->ts[0].rttstats))
		- (datalen_small * (8*2)) / maxthru;
	    if (maxthru<1e3)
		    printf("%-32s    %6.3fbps    %9.3f\n",
			hs2->hostname, maxthru, mindel);
	    else if (maxthru>1e6)
		    printf("%-32s    %6.3fMbps   %9.3f\n",
			hs2->hostname, maxthru/1e6, mindel);
	    else
		    printf("%-32s    %6.3fKbps   %9.3f\n",
			hs2->hostname, maxthru/1e3, mindel);

	}
	return;
}

/* Flag for exit as soon as possible */
void finishit_exit()
{
	exit_flag = 1;
}

/* Fill the packet with the provided pattern */
void fill(bp, patp)
	char *bp, *patp;
{
	register int ii, jj, kk;
	int pat[16];
	char *cp;

	for (cp = patp; *cp; cp++)
		if (!isxdigit(*cp)) {
			(void)fprintf(stderr,
			    "bing: patterns must be specified as hex digits.\n");
			exit(1);
		}
	ii = sscanf(patp,
	    "%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x%2x",
	    &pat[0], &pat[1], &pat[2], &pat[3], &pat[4], &pat[5], &pat[6],
	    &pat[7], &pat[8], &pat[9], &pat[10], &pat[11], &pat[12],
	    &pat[13], &pat[14], &pat[15]);

	if (ii > 0)
		for (kk = 0; kk <= MAXPACKET - (8 + ii); kk += ii)
			for (jj = 0; jj < ii; ++jj)
				bp[jj + kk] = pat[jj];
	if (options & F_VVERBOSE) {
		(void)printf("PATTERN: 0x");
		for (jj = 0; jj < ii; ++jj)
			(void)printf("%02x", bp[jj] & 0xFF);
		(void)printf("\n");
	}
}

void usage()
{
	(void)fprintf(stderr,
	    "usage: bing [-dDnrRPvVwz] [-c count] [-e samples] [-i wait]\n\t[-p pattern] [-s small packetsize] [-S big packetsize]\n\t[-u size increment] [-t ttl] [-I interface address]\n\t[-f sample file] host1 host2...\n");
	exit(1);
}

#ifdef WIN32
BOOL PASCAL ConsoleCtrlHandler(DWORD dwCtrlType)
{
	if (dwCtrlType==CTRL_C_EVENT) {
		finishit_exit();
		return TRUE;
	} else
		return FALSE;
}
#endif

int main(argc, argv)
	int argc;
	char **argv;
{
	extern int optind;
	extern char *optarg;
	struct in_addr ifaddr;
	int ntrans, nloops;
	int i, j;
	int ch, hold, recv_packlen;
	u_char *datap, *recv_packet;
	u_char ttl, loop;
#ifdef IP_OPTIONS
	char rspace[3 + 4 * NROUTES + 1];	/* record route space */
#endif

#ifdef WIN32
	{
		WSADATA wsaData;
		WORD wsaVersionRequested;
		int err;

		/* Initialise the winsock */
		wsaVersionRequested = MAKEWORD( 1, 1 );
		err = WSAStartup( wsaVersionRequested, &wsaData );
		if (err!=0) {
			fprintf(stderr,"bing: Could not initialise the winsock\n");
			exit(1);
		}

		/* Install the ^C handler */
		SetConsoleCtrlHandler(ConsoleCtrlHandler,TRUE);

		__progname=argv[0];
	}
#endif

	/*
	 * Open our raw socket at once, then setuid() back to
	 * the real uid as soon as possible (we have to, in
	 * case the -f option is used, and it's better anyway for
	 * obvious security reasons).
	 */
	my_icmp = icmp_open();
	if (my_icmp == NULL) {
	   fprintf(stderr, "cannot open ICMP module\n");
	   exit(1);
	}

#ifndef WIN32
	setgid(getgid());
	setuid(getuid());
#endif

	datap = &outpack[8];
	while ((ch = getopt(argc, argv, "c:dDe:f:I:i:LnPp:RrS:s:t:u:vVwz")) != EOF)
		switch(ch) {
		case 'f':
			samplefile = fopen(optarg, "a");
			if (samplefile == NULL) {
				(void)fprintf(stderr,
				    "bing: unable to open %s: ", optarg);
				perror("");
				exit(1);
			}
			break;
		case 'c':
			npackets = atoi(optarg);
			if (npackets <= 0) {
				(void)fprintf(stderr,
				    "bing: bad number of packets to transmit.\n");
				exit(1);
			}
			break;
		case 'D':
			options |= F_NODELTA;
			break;
		case 'P':
			options |= F_PEDANTIC;
			break;
		case 'w':
			options |= F_WARN;
			break;
		case 'd':
			options |= F_SO_DEBUG;
			break;
		case 'e':
			nsamples = atoi(optarg);
			if (nsamples <= 0) {
				(void)fprintf(stderr,
				    "bing: bad number of samples.\n");
				exit(1);
			}
			break;
		case 'i':		/* wait between sending packets */
			maxwait = atoi(optarg);
			if (maxwait <= 0) {
				(void)fprintf(stderr,
				    "bing: bad maximum wait.\n");
				exit(1);
			}
			options |= F_INTERVAL;
			break;
		case 'u':		/* packet size increment */
			datalen_step = atoi(optarg);
			if (datalen_step <= 0) {
				(void)fprintf(stderr,
				    "bing: bad packet size increment.\n");
				exit(1);
			}
			break;
		case 'n':
			options |= F_NUMERIC;
			break;
		case 'p':		/* fill buffer with user pattern */
			options |= F_PINGFILLED;
			fill((char *)datap, optarg);
			break;
		case 'V':
			options |= F_VVERBOSE;
			break;
		case 'R':
			options |= F_RROUTE;
			break;
		case 'r':
			options |= F_SO_DONTROUTE;
			break;
		case 'S':		/* size of big packet to send */
			datalen_big = atoi(optarg);
			if (datalen_big > MAXPACKET) {
				(void)fprintf(stderr,
				    "bing: big packet size too large.\n");
				exit(1);
			}
			if (datalen_big <= 0) {
				(void)fprintf(stderr,
				    "bing: illegal big packet size.\n");
				exit(1);
			}
			break;
		case 's':		/* size of small packet to send */
			datalen_small = atoi(optarg);
			if (datalen_small > MAXPACKET) {
				(void)fprintf(stderr,
				    "bing: small packet size too large.\n");
				exit(1);
			}
			if (datalen_small <= 0) {
				(void)fprintf(stderr,
				    "bing: illegal small packet size.\n");
				exit(1);
			}
			break;
		case 'v':
			options |= F_VERBOSE;
			break;
		case 'z':
			options |= F_RANDOMFILL;
			break;
		case 'L':
			moptions |= MULTICAST_NOLOOP;
			loop = 0;
			break;
		case 't':
			moptions |= MULTICAST_TTL;
			i = atoi(optarg);
			if (i < 0 || i > 255) {
				printf("ttl %u out of range\n", i);
				exit(1);
			}
			ttl = i;
			break;
		case 'I':
			moptions |= MULTICAST_IF;
			{
				int i1, i2, i3, i4;
				char dummy;

				if (sscanf(optarg, "%u.%u.%u.%u%c",
					   &i1, &i2, &i3, &i4, &dummy) != 4) {
					printf("bad interface address '%s'\n",
					       optarg);
					exit(1);
				}
				ifaddr.s_addr = (i1<<24)|(i2<<16)|(i3<<8)|i4;
				ifaddr.s_addr = htonl(ifaddr.s_addr);
			}
			break;
		default:
			usage();
		}

	if (datalen_small >= datalen_big) {
		(void)fprintf(stderr,
			"bing: small packet size >= big packet size\n");
		exit(1);
	}

	if (datalen_small < 0) {
		(void)fprintf(stderr,
			"bing: invalid packet size\n");
		exit(1);
	}

	bits = (datalen_big - datalen_small) * (8*2);
	if (datalen_step == 0 || datalen_small + datalen_step > datalen_big)
		datalen_step = datalen_big - datalen_small;
	nts = (datalen_big + datalen_step - 1 - datalen_small)/datalen_step + 1;

	argc -= optind;
	argv += optind;
	
	if (argc < 2)
		usage();

	icmp_set_timeout(my_icmp, maxwait*1000000);

	phs = (struct hoststats *)malloc(sizeof(struct hoststats) * argc);
	nhosts = argc;

	pts = (struct timestats *) malloc(sizeof(struct timestats)
					  * nts * nhosts);
	if (!phs || !pts) {
	    (void)fprintf(stderr, "bing: out of memory.\n");
	    exit(1);
	}

	for (i = 0; i < nhosts; i++) {
	    set_ip(phs + i, argv[i]);
	    phs[i].ts = pts + i*nts;
	}

	recv_packlen = datalen_big + MAXIPLEN + MAXICMPLEN;

	if (!(recv_packet = (u_char *)malloc((u_int)recv_packlen))) {
		(void)fprintf(stderr, "bing: out of memory.\n");
		exit(1);
	}
	if (!(options & F_PINGFILLED))
		for (i = 0; i < datalen_big; ++i)
			*datap++ = i;

	hold = 1;
	if (options & F_SO_DEBUG)
		icmp_set_option(my_icmp, SOL_SOCKET, SO_DEBUG, (char *)&hold,
		    sizeof(hold));
	if (options & F_SO_DONTROUTE)
		(void)icmp_set_option(my_icmp, SOL_SOCKET, SO_DONTROUTE, (char *)&hold,
		    sizeof(hold));

	/* record route option */
	if (options & F_RROUTE) {
#ifdef IP_OPTIONS
		rspace[IPOPT_OPTVAL] = IPOPT_RR;
		rspace[IPOPT_OLEN] = sizeof(rspace)-1;
		rspace[IPOPT_OFFSET] = IPOPT_MINOFF;
		if (icmp_set_option(my_icmp, IPPROTO_IP, IP_OPTIONS, rspace,
			sizeof(rspace)) < 0) {
			perror("bing: record route");
			exit(1);
		}
#else
		(void)fprintf(stderr,
		  "bing: record route not available in this implementation.\n");
		exit(1);
#endif /* IP_OPTIONS */
	}

	/*
	 * When pinging the broadcast address, you can get a lot of answers.
	 * Doing something so evil is useful if you are trying to stress the
	 * ethernet, or just want to fill the arp cache to get some stuff for
	 * /etc/ethers.
	 */
	hold = 48 * 1024;
	(void)icmp_set_option(my_icmp, SOL_SOCKET, SO_RCVBUF, (char *)&hold,
	    sizeof(hold));

#ifdef IP_MULTICAST_NOLOOP
	if (moptions & MULTICAST_NOLOOP) {
		if (icmp_set_option(my_icmp, IPPROTO_IP, IP_MULTICAST_LOOP,
					(char *)&loop, 1) == -1) {
			perror ("can't disable multicast loopback");
			exit(92);
		}
	}
#endif
#ifdef IP_MULTICAST_TTL
	if (moptions & MULTICAST_TTL) {
		if (icmp_set_option(my_icmp, IPPROTO_IP, IP_MULTICAST_TTL,
					(char *)&ttl, 1) == -1) {
			perror ("can't set multicast time-to-live");
			exit(93);
		}
	}
#endif
#ifdef IP_MULTICAST_IF
	if (moptions & MULTICAST_IF) {
		if (icmp_set_option(my_icmp, IPPROTO_IP, IP_MULTICAST_IF,
					(char *)&ifaddr, sizeof(ifaddr)) == -1) {
			perror ("can't set multicast source interface");
			exit(94);
		}
	}
#endif

	if (samplefile) {
	    char myname[MAXHOSTNAMELEN];
	    time_t t;
	    gethostname(myname, sizeof myname);
	    t = time(NULL);
	    fprintf(samplefile, "# From %s, %s", myname, ctime(&t));
	    for (i = 0; i < nhosts; i++) {
		if (phs[i].to->sin_family == AF_INET) {
		    fprintf(samplefile, "# %d\t%s (%s)\n",
			    i, phs[i].hostname,
			    inet_ntoa(*(struct in_addr *)&phs[i].to->sin_addr.s_addr));
		} else {
		    fprintf(samplefile, "# %d\t%s\n",
			    i, phs[i].hostname);
		}
	    }
	}

	if (nhosts == 2
	    && phs[0].to->sin_family == AF_INET
	    && phs[1].to->sin_family == AF_INET) {
		(void)printf("BING\t%s (%s) and ",
		    phs->hostname,
		    inet_ntoa(*(struct in_addr *)&phs->to->sin_addr.s_addr));
		(void)printf("%s (%s)\n\t%d and %d data bytes (%d bits)\n",
		    (phs+1)->hostname,
		    inet_ntoa(*(struct in_addr *)&(phs+1)->to->sin_addr.s_addr),
		    datalen_small, datalen_big, bits);
	} else if (nhosts == 2) {
		(void)printf("BING %s and %s:\n\t%d and %d data bytes (%d bits)\n",
		    phs->hostname, (phs+1)->hostname, datalen_small, datalen_big, bits);
	} else {
	    (void)printf("BING\t%d and %d data bytes (%d bits)\n",
			 datalen_small, datalen_big, bits);
	    for (i = 0; i < nhosts; i++) {
		if (phs[i].to->sin_family == AF_INET) {
		    (void)printf("%d:\t%s (%s)\n",
				 i, phs[i].hostname,
				 inet_ntoa(*(struct in_addr *)&phs[i].to->sin_addr.s_addr));
		} else {
		    (void)printf("%d:\t%s\n",
				 i, phs[i].hostname);
		}
	    }
	}

#ifndef WIN32
	{
		/* Set the interrupt handler for exit */
		struct sigaction sa;

		sa.sa_handler = finishit_exit;
		sa.sa_flags = 0;
		sigemptyset(&sa.sa_mask);
		sigaddset(&sa.sa_mask,SIGINT);

		sigaction(SIGINT, &sa, NULL);
	}
#endif

	for (nloops = 0; !nloops || nloops < npackets; nloops++) {
	    double oldsecs = -1;

	    if (nloops)
		fprintf(stderr,"resetting after %ld samples.\n", nsamples);

	    for (i = 0; i < nhosts; i++)
		for (j = 0; j < nts; j++) {
		    ts_init(&phs[i].ts[j]);
		}

	    for (ntrans = 0; !nsamples || ntrans < nsamples ; ntrans++) {
		double secs;
		double min1b, min1s, min2b, min2s;

		if (exit_flag) break;

		for (i = 0; i < nhosts; i++) {
		    struct hoststats *hs1, *hs2;
		    struct timestats *ts1s, *ts1b, *ts2s, *ts2b;

		    if (exit_flag) break;

		    hs2 = phs + i;

		    for (j = datalen_small;
			 j < datalen_big && !exit_flag;
			 j += datalen_step) {
			ping_and_wait(hs2, j,
				(char *)recv_packet, recv_packlen);
		    }
		    if (exit_flag) break;
		    ping_and_wait(hs2, datalen_big,
			(char *)recv_packet, recv_packlen);

		    if (i == 0)
		        /* Don't display stats on the first host */
			continue;

		    hs1 = phs + i-1;

		    ts1b = &hs1->ts[nts-1];
		    ts1s = &hs1->ts[0];
		    ts2b = &hs2->ts[nts-1];
		    ts2s = &hs2->ts[0];

		    if (ts1b->nreceived
			&& ts1s->nreceived == 0
			&& ts2b->nreceived == 0
			&& ts2s->nreceived == 0)
			continue;

		    min1s = dst_min(&(ts1s->rttstats));
		    min1b = dst_min(&(ts1b->rttstats));
		    min2s = dst_min(&(ts2s->rttstats));
		    min2b = dst_min(&(ts2b->rttstats));
		    adapt_rtt(&min1s, &min1b, &min2s, &min2b);
		    secs = (min2b - min1b) - (min2s - min1s);
		    if ((options & F_NODELTA) || (oldsecs != secs)) {
			oldsecs = secs;
			if (options & F_WARN)
				warn_rtt(hs1->hostname,
					 hs2->hostname,
					 dst_min(&(ts1s->rttstats)),
					 dst_min(&(ts1b->rttstats)),
					 dst_min(&(ts2s->rttstats)),
					 dst_min(&(ts2b->rttstats)));
			if (secs>0) {
				if (bits * 1e3 / secs<1e3)
					printf("%s: %6.3fbps  %.3fms %.6fus/bit\n",
						hs2->hostname,
						bits  * 1e3 / secs,
						secs,
						secs * 1e3  / bits);
				else if ((bits / secs) * 1e3>1e6)
					printf("%s: %6.3fMbps %.3fms %.6fus/bit\n",
						hs2->hostname,
						(bits * 1e3 / secs) / 1e6,
						secs,
						secs * 1e3  / bits);
				else
					printf("%s: %6.3fKbps %.3fms %.6fus/bit\n",
						hs2->hostname,
						(bits * 1e3 / secs) / 1e3,
						secs,
						secs * 1e3 / bits);
			} else {
				printf("%s: minimum delay difference is zero, can't estimate link throughput\n",
					hs2->hostname);
			}
			fflush(stdout);
		    }
		}
	    }

	    finishit();
	    if (exit_flag) break;

	}

	if (samplefile) {
	    fclose(samplefile);
	}
	icmp_close(my_icmp);
	return 0;
}
