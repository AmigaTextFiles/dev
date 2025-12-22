OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/amitcp/types',
       'amitcp/sys/socket',
       'exec/tasks'

OBJECT rt_metrics
  locks
  mtu
  hopcount
  expire
  recvpipe
  sendpipe
  ssthresh
  rtt
  rttvar
ENDOBJECT

CONST RTM_RTTUNIT=1000000

-> PR_SLOWHZ is defined where?
#define RTTTOPRHZ(r) Div((r),Div(RTM_RTTUNIT,PR_SLOWHZ))

SET RTF_UP, RTF_GATEWAY, RTF_HOST, RTF_REJECT, RTF_DYNAMIC, RTF_MODIFIED,
    RTF_DONE, RTF_MASK, RTF_CLONING, RTF_XRESOLVE, RTF_LLINFO

CONST RTF_PROTO2=$4000, RTF_PROTO1=$8000

OBJECT rtstat
  badredirect:INT
  dynamic:INT
  newgateway:INT
  unreach:INT
  wildcard:INT
ENDOBJECT

OBJECT ortentry
  hash
  dst:sockaddr
  gateway:sockaddr
  flags:INT
  refcnt:INT
  use
  pad[4]:ARRAY
ENDOBJECT

OBJECT msghdr
  msglen:INT
  version:CHAR
  type:CHAR
  index:INT
  pid:pid_t
  addrs
  seq
  errno
  flags
  use
  inits
  rmx:rt_metrics
ENDOBJECT

OBJECT route_cb
  ip_count
  ns_count
  iso_count
  any_count
ENDOBJECT

CONST RTM_VERSION=2

ENUM RTM_ADD=1, RTM_DELETE, RTM_CHANGE, RTM_GET, RTM_LOSING, RTM_REDIRECT,
     RTM_MISS, RTM_LOCK, RTM_OLDADD, RTM_OLDDEL, RTM_RESOLVE

SET RTV_MTU, RTV_HOPCOUNT, RTV_EXPIRE, RTV_RPIPE, RTV_SPIPE, RTV_SSTHRESH,
    RTV_RTT, RTV_RTTVAR

SET RTA_DST, RTA_GATEWAY, RTA_NETMASK, RTA_GENMASK, RTA_IFP, RTA_IFA,
    RTA_AUTHOR
