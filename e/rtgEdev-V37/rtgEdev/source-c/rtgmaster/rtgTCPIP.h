#ifndef RTGMASTER_RTGTCPIP_H
#define RTGMASTER_RTGTCPIP_H 1

#ifndef LARGE_BUFSIZE
#define LARGE_BUFSIZE (12 * 1024)
#endif

#ifndef GARBAGE_SPACE
#define GARBAGE_SPACE 32
#endif

#ifndef  NBBY
#define NBBY    8                       /* number of bits in a byte */
#endif

#ifndef FD_SETSIZE
#define FD_SETSIZE      64
#endif

#ifndef INVALID_SOCKET
#define INVALID_SOCKET -1
#endif

#ifndef SYS_TYPES_H
#ifndef fd_mask
typedef long    fd_mask;
#endif
#endif

#ifndef NFDBITS
#define NFDBITS (sizeof(fd_mask) * NBBY) /* bits per mask */
#endif

#ifndef howmany
#define howmany(x, y)   (((x)+((y)-1))/(y))
#endif

#ifndef SYS_TYPES_H
typedef struct fd_set {
        fd_mask fds_bits[howmany(FD_SETSIZE, NFDBITS)];
} fd_set;

typedef unsigned char   u_char;
typedef unsigned short  u_short;
typedef unsigned int    u_int;
typedef unsigned long   u_long;
typedef unsigned short  ushort;         /* Sys V compatibility */
typedef char*           caddr_t;        /* core address */
typedef unsigned long   dev_t;
typedef unsigned long   ino_t;
typedef long            off_t;

#define SYS_TYPES_H

// Sort of a hack (why i did this : See below...)
// (Sys/types.h differs, according to, if we have
// only SAS/C installed or SAS/C + AmiTCP includes.
// This code should not give an error, anyways, which
// version of sys/types.h we have installed. So i did
// all sys/types.h stuff from SAS/C + AmiTCP HERE and
// hindered sys/types.h to be included :) ...


#endif

#ifndef FD_SET
#define FD_SET(n, p)    ((p)->fds_bits[(n)/NFDBITS] |= (1 << ((n) % NFDBITS)))
#endif

#ifndef FD_CLR
#define FD_CLR(n, p)    ((p)->fds_bits[(n)/NFDBITS] &= ~(1 << ((n) % NFDBITS)))
#endif

#ifndef FD_ISSET
#define FD_ISSET(n, p)  ((p)->fds_bits[(n)/NFDBITS] & (1 << ((n) % NFDBITS)))
#endif

#ifndef FD_ZERO
#define FD_ZERO(p)      bzero((char *)(p), sizeof(*(p)))
#endif

#ifndef SOCK_STREAM
#define SOCK_STREAM     1               /* stream socket */
#endif

#ifndef SOCK_DGRAM
#define SOCK_DGRAM      2               /* datagram socket */
#endif

struct RTG_Buff
{
 char sock[12][1024];
 int num[12];
 int in_size;
 int out_size;
};

// Sort of a HACK that we do not get a collision
// with AmiTCP includes, if installed... :)
// (most of the stuff in this includefile is
// only needed to COMPILE rtgmaster.library itself,
// not for the USAGE of the library, so do not wonder,
// if it is missing in the ASM part... the TCP/IP
// part of rtgmaster is written in C, contrary to
// the rest of rtgmaster (which is written in ASM)

#ifndef NET_IN_H
#define NET_IN_H

#define IN_H XXX - compatibility

/*
 * Macros for network/external number representation conversion.
 */
#ifndef ntohl
#define ntohl(x)        (x)
#define ntohs(x)        (x)
#define htonl(x)        (x)
#define htons(x)        (x)

#define NTOHL(x)        (x)
#define NTOHS(x)        (x)
#define HTONL(x)        (x)
#define HTONS(x)        (x)
#endif

/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981.
 */

/*
 * Protocols
 */
#define IPPROTO_IP              0               /* dummy for IP */
#define IPPROTO_ICMP            1               /* control message protocol */
#define IPPROTO_GGP             3               /* gateway^2 (deprecated) */
#define IPPROTO_TCP             6               /* tcp */
#define IPPROTO_EGP             8               /* exterior gateway protocol */
#define IPPROTO_PUP             12              /* pup */
#define IPPROTO_UDP             17              /* user datagram protocol */
#define IPPROTO_IDP             22              /* xns idp */
#define IPPROTO_TP              29              /* tp-4 w/ class negotiation */
#define IPPROTO_EON             80              /* ISO cnlp */

#define IPPROTO_RAW             255             /* raw IP packet */
#define IPPROTO_MAX             256


/*
 * Local port number conventions:
 * Ports < IPPORT_RESERVED are reserved for
 * privileged processes (e.g. root).
 * Ports > IPPORT_USERRESERVED are reserved
 * for servers, not necessarily privileged.
 */
#define IPPORT_RESERVED         1024
#define IPPORT_USERRESERVED     5000

/*
 * Internet address (a structure for historical reasons)
 */
struct in_addr {
        u_long s_addr;
};

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 */
#define IN_CLASSA(i)            (((long)(i) & 0x80000000) == 0)
#define IN_CLASSA_NET           0xff000000
#define IN_CLASSA_NSHIFT        24
#define IN_CLASSA_HOST          0x00ffffff
#define IN_CLASSA_MAX           128

#define IN_CLASSB(i)            (((long)(i) & 0xc0000000) == 0x80000000)
#define IN_CLASSB_NET           0xffff0000
#define IN_CLASSB_NSHIFT        16
#define IN_CLASSB_HOST          0x0000ffff
#define IN_CLASSB_MAX           65536

#define IN_CLASSC(i)            (((long)(i) & 0xe0000000) == 0xc0000000)
#define IN_CLASSC_NET           0xffffff00
#define IN_CLASSC_NSHIFT        8
#define IN_CLASSC_HOST          0x000000ff

#define IN_CLASSD(i)            (((long)(i) & 0xf0000000) == 0xe0000000)
#define IN_MULTICAST(i)         IN_CLASSD(i)

#define IN_EXPERIMENTAL(i)      (((long)(i) & 0xe0000000) == 0xe0000000)
#define IN_BADCLASS(i)          (((long)(i) & 0xf0000000) == 0xf0000000)

#define INADDR_ANY              (u_long)0x00000000
#define INADDR_BROADCAST        (u_long)0xffffffff      /* must be masked */
#if !defined(KERNEL) || defined(AMITCP)
#define INADDR_NONE             0xffffffff              /* -1 return */
#endif

#define IN_LOOPBACKNET          127                     /* official! */

/*
 * Socket address, internet style.
 */
struct sockaddr_in {
        u_char  sin_len;
        u_char  sin_family;
        u_short sin_port;
        struct  in_addr sin_addr;
        char    sin_zero[8];
};

/*
 * Structure used to describe IP options.
 * Used to store options internally, to pass them to a process,
 * or to restore options retrieved earlier.
 * The ip_dst is used for the first-hop gateway when using a source route
 * (this gets put into the header proper).
 */
struct ip_opts {
        struct  in_addr ip_dst;         /* first hop, 0 w/o src rt */
        char    ip_opts[40];            /* actually variable in size */
};

/*
 * Options for use with [gs]etsockopt at the IP level.
 * First word of comment is data type; bool is stored in int.
 */
#define IP_OPTIONS      1       /* buf/ip_opts; set/get IP per-packet options */
#define IP_HDRINCL      2       /* int; header is included with data (raw) */
#define IP_TOS          3       /* int; IP type of service and precedence */
#define IP_TTL          4       /* int; IP time to live */
#define IP_RECVOPTS     5       /* bool; receive all IP options w/datagram */
#define IP_RECVRETOPTS  6       /* bool; receive IP options for response */
#define IP_RECVDSTADDR  7       /* bool; receive IP dst addr w/datagram */
#define IP_RETOPTS      8       /* ip_opts; set/get IP per-packet options */

#endif /* !IN_H */


struct RTG_Socket
{
    int s;   // The TCP/IP Socket
    int num; // number of open connections,
             // including the server itself
    struct RTG_Socket *list; // List of connections of a server
    fd_set input_set, output_set, exc_set; // The sets
    struct sockaddr_in peer;
    int mode;
    int server;
};

#endif
