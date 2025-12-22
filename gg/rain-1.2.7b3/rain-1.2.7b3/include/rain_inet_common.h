/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_inet_common.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_inet_common.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_inet_common.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/
#ifndef _RAIN_INET_COMMON_H
#define _RAIN_INET_COMMON_H


/* 
 * These should be defined, but just incase.. 
 */
#ifndef in_addr_t
  #define in_addr_t u_int32_t
#endif


#ifndef tcp_seq
  #define tcp_seq u_int32_t
#endif


/* 
 * Maximum allowed port number (16 bits) 
 */
#define MAXPORT 65535
 

/* 
 * packet types for storing in pkt->type 
 */
#define DEFAULT     0
#define TCP         (1<<1)
#define UDP         (1<<2)
#define SYN         (1<<3)
#define ICMP        (1<<4)
#define IGMP        (1<<5)
#define ICMP6       (1<<6)
#define TCPSTREAM   (1<<7)
#define TCPCONNECT  (1<<8)
#define USERDEFAULT TCPSTREAM



/* 
 * Type of Service - RFC 791 
 */
#define TOS_NORMAL_DELAY          0x04
#define TOS_LOW_DELAY             (1<<4)
#define TOS_NORMAL_THROUGHPUT     (0<<3)
#define TOS_HIGH_THROUGHPUT       (1<<3)
#define TOS_NORMAL_RELIABILITY    (0<<2)
#define TOS_HIGH_RELIABILITY      (1<<2)

/* 
 * Type of Service - Precedence 
 */
#define TOSP_NETWORK_CONTROL      (7<<5)
#define TOSP_INTERNETWORK_CONTROL (6<<5)
#define TOSP_CRITIC_ECP           (5<<5)
#define TOSP_FLASH_OVERRIDE       (4<<5)
#define TOSP_FLASH                (3<<5)
#define TOSP_IMMEDIATE            (2<<5)
#define TOSP_PRIORITY             (1<<5)
#define TOSP_ROUTINE              0x0F




/*-----------------------------------------------------------*
 * Internet headers taken from the GNU glibc library         *
 *-----------------------------------------------------------*/

/*
 * Structure of an internet header, naked of options.
 */
struct ip
  {
#if __BYTE_ORDER == __LITTLE_ENDIAN
    unsigned int ip_hl:4;               /* header length */
    unsigned int ip_v:4;                /* version */
#else
    unsigned int ip_v:4;                /* version */
    unsigned int ip_hl:4;               /* header length */
#endif
    u_int8_t ip_tos;                    /* type of service */
    u_short ip_len;                     /* total length */
    u_short ip_id;                      /* identification */
    u_short ip_off;                     /* fragment offset field */
#define IP_RF 0x8000                    /* reserved fragment flag */
#define IP_DF 0x4000                    /* dont fragment flag */
#define IP_MF 0x2000                    /* more fragments flag */
#define IP_OFFMASK 0x1fff               /* mask for fragmenting bits */
    u_int8_t ip_ttl;                    /* time to live */
    u_int8_t ip_p;                      /* protocol */
    u_short ip_sum;                     /* checksum */
    struct in_addr ip_src, ip_dst;      /* source and dest address */
  };


/*
 * Internal of an ICMP Router Advertisement
 */
struct icmp_ra_addr
{
  u_int32_t ira_addr;
  u_int32_t ira_preference;
};


struct icmp
{
  u_int8_t  icmp_type;  /* type of message, see below */
  u_int8_t  icmp_code;  /* type sub code */
  u_int16_t icmp_cksum; /* ones complement checksum of struct */
  union
  {
    u_char ih_pptr;             /* ICMP_PARAMPROB */
    struct in_addr ih_gwaddr;   /* gateway address */
    struct ih_idseq             /* echo datagram */
    {
      u_int16_t icd_id;
      u_int16_t icd_seq;
    } ih_idseq;
    u_int32_t ih_void;

    /* ICMP_UNREACH_NEEDFRAG -- Path MTU Discovery (RFC1191) */
    struct ih_pmtu
    {
      u_int16_t ipm_void;
      u_int16_t ipm_nextmtu;
    } ih_pmtu;

    struct ih_rtradv
    {
      u_int8_t irt_num_addrs;
      u_int8_t irt_wpa;
      u_int16_t irt_lifetime;
    } ih_rtradv;
  } icmp_hun;
#define icmp_pptr       icmp_hun.ih_pptr
#define icmp_gwaddr     icmp_hun.ih_gwaddr
#define icmp_id         icmp_hun.ih_idseq.icd_id
#define icmp_seq        icmp_hun.ih_idseq.icd_seq
#define icmp_void       icmp_hun.ih_void
#define icmp_pmvoid     icmp_hun.ih_pmtu.ipm_void
#define icmp_nextmtu    icmp_hun.ih_pmtu.ipm_nextmtu
#define icmp_num_addrs  icmp_hun.ih_rtradv.irt_num_addrs
#define icmp_wpa        icmp_hun.ih_rtradv.irt_wpa
#define icmp_lifetime   icmp_hun.ih_rtradv.irt_lifetime
  union
  {
    struct
    {
      u_int32_t its_otime;
      u_int32_t its_rtime;
      u_int32_t its_ttime;
    } id_ts;
    struct
    {
      struct ip idi_ip;
      /* options and then 64 bits of data */
    } id_ip;
    struct icmp_ra_addr id_radv;
    u_int32_t   id_mask;
    u_int8_t    id_data[1];
  } icmp_dun;
#define icmp_otime      icmp_dun.id_ts.its_otime
#define icmp_rtime      icmp_dun.id_ts.its_rtime
#define icmp_ttime      icmp_dun.id_ts.its_ttime
#define icmp_ip         icmp_dun.id_ip.idi_ip
#define icmp_radv       icmp_dun.id_radv
#define icmp_mask       icmp_dun.id_mask
#define icmp_data       icmp_dun.id_data
};

struct udphdr {
         u_int16_t uh_sport;           /* source port */
         u_int16_t uh_dport;           /* destination port */
         u_int16_t uh_ulen;            /* udp length */
         u_int16_t uh_sum;             /* udp checksum */
};



/* 
 * TCP options, also taken from the GNU glibc library 
 */

/*
 * User-settable options (used with setsockopt).
 */
#define TCP_NODELAY      1      /* Don't delay send to coalesce packets  */
#define TCP_MAXSEG       2      /* Set maximum segment size  */
#define TCP_CORK         3      /* Control sending of partial frames  */
#define TCP_KEEPIDLE     4      /* Start keeplives after this period */
#define TCP_KEEPINTVL    5      /* Interval between keepalives */
#define TCP_KEEPCNT      6      /* Number of keepalives before death */
#define TCP_SYNCNT       7      /* Number of SYN retransmits */
#define TCP_LINGER2      8      /* Life time of orphaned FIN-WAIT-2 state */
#define TCP_DEFER_ACCEPT 9      /* Wake up listener only when data arrive */
#define TCP_WINDOW_CLAMP 10     /* Bound advertised window */
#define TCP_INFO         11     /* Information about this connection. */
#define TCP_QUICKACK     12     /* Bock/reenable quick ACKs.  */

#define TCP_MSS 512

/*
 * TCP header.
 * Per RFC 793, September, 1981.
 */
struct tcphdr
  {
    u_int16_t th_sport;         /* source port */
    u_int16_t th_dport;         /* destination port */
    tcp_seq th_seq;             /* sequence number */
    tcp_seq th_ack;             /* acknowledgement number */
#  if __BYTE_ORDER == __LITTLE_ENDIAN
    u_int8_t th_x2:4;           /* (unused) */
    u_int8_t th_off:4;          /* data offset */
#else
    u_int8_t th_off:4;          /* data offset */
    u_int8_t th_x2:4;           /* (unused) */
#  endif
    u_int8_t th_flags;
#  define TH_FIN        0x01
#  define TH_SYN        0x02
#  define TH_RST        0x04
#  define TH_PUSH       0x08
#  define TH_ACK        0x10
#  define TH_URG        0x20
    u_int16_t th_win;           /* window */
    u_int16_t th_sum;           /* checksum */
    u_int16_t th_urp;           /* urgent pointer */
};


struct igmp {
  u_int8_t igmp_type;             /* IGMP type */
  u_int8_t igmp_code;             /* routing code */
  u_int16_t igmp_cksum;           /* checksum */
  struct in_addr igmp_group;      /* group address */
};

/*
 * Message types, including version number.
 */
#define IGMP_MEMBERSHIP_QUERY           0x11    /* membership query         */
#define IGMP_V1_MEMBERSHIP_REPORT       0x12    /* Ver. 1 membership report */
#define IGMP_V2_MEMBERSHIP_REPORT       0x16    /* Ver. 2 membership report */
#define IGMP_V2_LEAVE_GROUP             0x17    /* Leave-group message      */




/* Okay.. This is a detrimental structure that should not be tampered with. *
 * This structure is the foundation of rain as it stores information about  *
 * the packets which the user creates..                                     */
struct pkt_info {
  int   		num;   /* number of packets to send */
  u_int16_t           dport;   /* destination port */
  u_int16_t           sport;   /* source port */
  int               timeout;
  u_long              delay;   /* delay between packet sends */
  u_char         saddr[256];   /* source address */
  u_char         daddr[256];   /* destination address */
  u_char         gaddr[256];   /* gateway address used in ICMP */
  u_int16_t       type : 16;   /* TCP, SYN, UDP, ICMP or IGMP rev.1: TCPSTREAM, TCPCONNECT */
  u_int8_t          tos : 8;   /* type of service (IP header) */
  u_int8_t          ttl : 8;
  u_int16_t         tot_len;
  u_short          frag : 1;
  u_int16_t        frag_off;
  u_short      simulate : 1;
  u_int             simtype;
  u_int			 id;
  u_int           id_of : 1;
  u_short        randip : 1;
  u_char      payload[1024];
  u_short     rsport    : 1;  /* random source port specifier */
  u_short     rdport    : 1;  /* random dest port specifier */
  char               filler;
  u_char          dfrag : 1;  /* used for setting don't fragment bits */
  u_char        noblock : 1;  /* 0 for blocking, 1 for non-blocking I/O */
  int                rcvbuf;  /* Socket receive buffer size; Default is 0 */
  int                sndbuf;  /* Socket send buffer size; Default is 0 (let kernel decide) */
  u_char          bcast : 1;  /* Set to 1 if target host is a broadcast address */
};


/* 
 * For storing information about TCP packets 
 */
struct pkt_info_tcp {
  u_int16_t    window;
  u_int32_t       seq;
  u_short     urg : 1;
  u_short     ack : 1;
  u_int32_t   ack_seq;
  u_short     psh : 1;
  u_short     rst : 1;
  u_short     syn : 1;
  u_short     fin : 1;
  u_short beenset : 1;
};


/* 
 * For storing information about ICMP packets 
 */
struct pkt_info_icmp {
    u_short type : 8;
    u_short code : 8;
    u_int16_t     id;  /* id */
    u_int16_t    seq;  /* sequence */
    u_int16_t    mtu;  /* maximum transfer unit */
    u_int32_t     gw;  /* gateway address */
};


/* 
 * For storing information about IGMP packets 
 */
struct pkt_info_igmp {
  u_short type : 8;
  u_short code : 8;
};


/*
 * Pseudo structures used in the final send
 * We use this method for organization.     
 */
struct iptcp {
  struct ip      ip;
  struct tcphdr tcp;
};
struct ipudp {
  struct ip      ip;
  struct udphdr udp;
};
struct ipicmp {
  struct ip     ip;
  struct icmp icmp;
};
struct ipigmp {
  struct ip     ip;
  struct igmp igmp;
};



/* 
 * global variables 
 */
u_int16_t packetsize;
unsigned char      *buffer;   /* For holding packets. Declared globally to ensure it is freed when the program exits */
time_t          send_start;   /* for storing start and finish time of total packets sent */
time_t         send_finish;
unsigned long packets_sent;
u_short            verbose;
struct in_addr       group;  /* for ICMP gateway and IGMP group addresses */
/*---------------------------*/


/* 
 * function prototypes for ../source/rain_inet_common.c 
 */
extern unsigned short in_cksum(const u_int16_t *, register int, u_short);
extern void sethdrinclude(int);     /* sets IP_HDRINCL socket option */
extern void setttl(int, u_int8_t);  /* sets TTL for streamed sockets */
extern void settos(int, u_int8_t);  /* sets TOS for streamed sockets */
extern void setsndbuf(int, int);    /* Sets send buffer size */
extern void setrcvbuf(int, int);    /* Sets receive buffer size */
extern void setbcast(int);          /* Allows broadcast messages */


#undef RAIN_IPV6  /* IPv6 support is not ready yet */

#endif /* _RAIN_INET_COMMON_H */
