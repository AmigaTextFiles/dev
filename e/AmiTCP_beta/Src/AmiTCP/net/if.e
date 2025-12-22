OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/socket',
       'amitcp/sys/types'

CONST IFNAMSIZ=16

OBJECT ifreq
  name[IFNAMSIZ]:ARRAY
  addr:sockaddr  -> Unioned with dstaddr:sockaddr, broadaddr:sockaddr,
ENDOBJECT        -> flags:INT, metric, data:caddr_t (PTR TO CHAR)

OBJECT ifaliasreq
  name[IFNAMSIZ]:ARRAY
  addr:sockaddr
  broadaddr:sockaddr
  mask:sockaddr
ENDOBJECT

OBJECT ifconf
  len
  buf:caddr_t -> Unioned with req:PTR TO ifreq
ENDOBJECT

SET IFF_UP, IFF_BROADCAST, IFF_DEBUG, IFF_LOOPBACK, IFF_POINTTOPOINT,
    IFF_NOTRAILERS, IFF_RUNNING, IFF_NOARP, IFF_PROMISC, IFF_ALLMULTI,
    IFF_OACTIVE, IFF_SIMPLEX

CONST IFF_CANTCHANGE=IFF_BROADCAST OR IFF_POINTTOPOINT OR IFF_RUNNING OR
                     IFF_OACTIVE OR IFF_SIMPLEX
