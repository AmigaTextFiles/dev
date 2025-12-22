OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/netinet/in',
       'amitcp/netinet/ip',
       'amitcp/netinet/in_systm'

OBJECT ih_idseq
  id:INT
  seq:INT
ENDOBJECT

OBJECT id_ts
  otime:n_time
  rtime:n_time
  ttime:n_time
ENDOBJECT

OBJECT icmp
  type:CHAR
  code:CHAR
  cksum:INT
  idseq:ih_idseq  -> Unioned with pptr:CHAR, gwaddr:in_addr, void
  ip:ip  -> Unioned with ts:id_ts, mask, data[1]:ARRAY
ENDOBJECT

CONST ICMP_MINLEN=8,
      ICMP_TSLEN=3*4+8,
      ICMP_MASKLEN=12,
      ICMP_ADVLENMIN=8+20+8

PROC icmp_advlen(p:PTR TO icmp) IS 8+Shl(p.ip.v_hl AND $F, 2)+8

#define ICMP_ADVLEN(p) icmp_advlen(p)

ENUM ICMP_ECHOREPLY, ICMP_UNREACH=3, ICMP_SOURCEQUENCH, ICMP_REDIRECT,
     ICMP_ECHO=8, ICMP_TIMXCEED=11, ICMP_PARAMPROB, ICMP_TSTAMP,
     ICMP_TSTAMPREPLY, ICMP_IREQ, ICMP_IREQREPLY, ICMP_MASKREQ,
     ICMP_MASKREPLY, ICMP_MAXTYPE=18

ENUM ICMP_UNREACH_NET, ICMP_UNREACH_HOST, ICMP_UNREACH_PROTOCOL,
     ICMP_UNREACH_PORT, ICMP_UNREACH_NEEDFRAG, ICMP_UNREACH_SRCFAIL

ENUM ICMP_REDIRECT_NET, ICMP_REDIRECT_HOST, ICMP_REDIRECT_TOSNET,
     ICMP_REDIRECT_TOSHOST

ENUM ICMP_TIMXCEED_INTRANS, ICMP_TIMXCEED_REASS

#define ICMP_INFOTYPE(type) (((type)=ICMP_ECHOREPLY) OR ((type)=ICMP_ECHO) OR \
                             ((type)=ICMP_TSTAMP) OR ((type)=ICMP_TSTAMPREPLY) OR \
                             ((type)=ICMP_IREQ) OR ((type)=ICMP_IREQREPLY) OR \
                             ((type)=ICMP_MASKREQ) OR ((type)=ICMP_MASKREPLY))
