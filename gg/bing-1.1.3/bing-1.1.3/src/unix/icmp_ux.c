/* $Id$ */

/* Usual includes/declarations */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>

/* More specific includes/declarations */
#include <sys/time.h>

/* Network includes/definitions */

#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in_systm.h>
#include <netinet/in.h>

#ifdef linux
/* Needed for IP structures */
#include <endian.h>
#endif

/* These come either from the compatibility library or from the
 * standard libraries.
 */
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>

#include "mod_icmp.h"

typedef struct {
    int s;			/* Raw socket fd */
    short id;			/* 16 bit id to be put in the echo request */
    struct timeval last_send;	/* date of last send */
    struct timeval timeout;	/* timeout for replies */
    fd_set fds;			/* Precomputed fd_set for select() */
} mod_icmp_i;

#define to_mod_icmp(h)	((mod_icmp_i*)(h))

/*
 * tvsub --
 *	Subtract 2 timeval structs:  out = out - in.
 *	Out is assumed to be >= in.
 */
void tvsub(out, in)
    register struct timeval *out, *in;
{
    if ((out->tv_usec -= in->tv_usec) < 0) {
	--out->tv_sec;
	out->tv_usec += 1000000;
    }
    out->tv_sec -= in->tv_sec;
}

/*
 * in_cksum --
 *	Checksum routine for Internet Protocol family headers (C Version)
 */
static int in_cksum(addr, len)
    u_short *addr;
    int len;
{
    register int nleft = len;
    register u_short *w = addr;
    register int sum = 0;
    u_short answer = 0;
    
    /*
     * Our algorithm is simple, using a 32 bit accumulator (sum), we add
     * sequential 16 bit words to it, and at the end, fold back all the
     * carry bits from the top 16 bits into the lower 16 bits.
     */
    while (nleft > 1)  {
	sum += *w++;
	nleft -= 2;
    }
    
    /* mop up an odd byte, if necessary */
    if (nleft == 1) {
	*(u_char *)(&answer) = *(u_char *)w ;
	sum += answer;
    }
    
    /* add back carry outs from top 16 bits to low 16 bits */
    sum = (sum >> 16) + (sum & 0xffff);	/* add hi 16 to low 16 */
    sum += (sum >> 16);			/* add carry */
    answer = ~sum;				/* truncate to 16 bits */
    return(answer);
}

icmp_handle icmp_open()
{
    struct protoent *proto;
    int s;
    mod_icmp_i *new;
    
    if (!(proto = getprotobyname("icmp"))) {
	fprintf(stderr, "unknown protocol icmp.\n");
	return NULL;
    }
    
    /*
     * Open a raw socket
     */
    if ((s = socket(AF_INET, SOCK_RAW, proto->p_proto)) < 0) {
	perror("socket");
	return NULL;
    }
    
    /*
     * Everything ok, alloc our private state
     */
    new = (mod_icmp_i *)malloc(sizeof(mod_icmp_i));
    if (new == NULL) {
	close(s);
	fprintf(stderr, "out of memory!\n");
	return NULL;
    }
    new->s = s;
    new->id = getpid() & 0xFFFF;
    
    FD_ZERO(&new->fds);
    FD_SET(new->s, &new->fds);
    
    return (icmp_handle)new;
}

int icmp_set_option(handle,level,optname,optval,optlen)
    icmp_handle handle;
    int level;
    int optname;
    void *optval;
    int optlen;
{
    return setsockopt(to_mod_icmp(handle)->s, level, optname,
		      optval, optlen);
}

void icmp_set_timeout(handle,timeout)
    icmp_handle handle;
    unsigned long timeout;
{
    mod_icmp_i *h = to_mod_icmp(handle);
    
    h->timeout.tv_sec = timeout / 1000000;
    h->timeout.tv_usec = timeout % 1000000;
}

unsigned short icmp_get_id(handle)
    icmp_handle handle;
{
    mod_icmp_i *h = to_mod_icmp(handle);
    
    return h->id;
}

int icmp_send(handle,msg,msg_size,to_addr,to_addr_size)
    icmp_handle handle;
    void *msg;
    int msg_size;
    struct sockaddr *to_addr;
    int to_addr_size;
{
    mod_icmp_i *h = to_mod_icmp(handle);
    
    struct icmp *icmp_header;
    
    /* Fill-in the last bits in the icmp message */
    icmp_header = (struct icmp *)msg;
    icmp_header->icmp_id = h->id;
    
    /* Compute the checksum */
    icmp_header->icmp_cksum = 0;
    icmp_header->icmp_cksum = in_cksum((u_short *)msg, msg_size);
    
    /* Get the send date as late as possible */
    gettimeofday(&h->last_send, (struct timezone *)NULL);
    
    /* Send packet and return to caller */
    return sendto(h->s, 
		  (char *)msg, msg_size, 
		  0, 
		  (struct sockaddr *)to_addr, to_addr_size);
}

int icmp_recv(handle,buf,buflen,from_addr,from_addr_size,elapsed)
    icmp_handle handle;
    char *buf;
    int buflen;
    struct sockaddr *from_addr;
    int *from_addr_size;
    double *elapsed;
{
    mod_icmp_i *h = to_mod_icmp(handle);
    
    int cc;
    int rsel;
    struct timeval tv, selw;
    
    /*
     * Note that we can spare rebuilding the FD mask each time,
     * since it will only be altered if select() times out, in which
     * case we exit anyway...
     */
    FD_SET(h->s, &h->fds);
    
    /* Set timeout */
    selw = h->timeout;
    
    /* Wait */
    rsel = select(h->s+1, &h->fds,
		  (fd_set *)0, (fd_set *)0, &selw);
    
    /* Get date as soon as possible */
    gettimeofday(&tv, (struct timezone *)NULL);
    
    /* Compute the elapsed time since last icmp_send */
    tvsub(&tv, &h->last_send);
    *elapsed = ((double)tv.tv_sec * 1e3) + ((double)tv.tv_usec / 1e3);
    
    if (rsel > 0) {
	/* Got a reply packet, read it and return it */
	cc = recvfrom(h->s, buf, buflen, 0, from_addr, from_addr_size);
	return cc;
    } else if (rsel == 0) {
	/* Time out */
	return 0;
    } else if (errno == EINTR) {
	return -1;
    } else {
	perror("select");
	exit(1);
    }
}

int icmp_close(handle)
    icmp_handle handle;
{
    mod_icmp_i *h = to_mod_icmp(handle);
    close(h->s);
    free(h);
    return 0;
}
