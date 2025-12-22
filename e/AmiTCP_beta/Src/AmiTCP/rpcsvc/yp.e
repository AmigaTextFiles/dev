OPT MODULE, PREPROCESS
OPT EXPORT

CONST YPMAXRECORD=1024,
      YPMAXDOMAIN=64,
      YPMAXMAP=64,
      YPMAXPEER=64

CONST YP_TRUE=1,
      YP_NOMORE=2,
      YP_FALSE=0,
      YP_NOMAP=-1,
      YP_NODOM=-2,
      YP_NOKEY=-3,
      YP_BADOP=-4,
      YP_BADDB=-5,
      YP_YPERR=-6,
      YP_BADARGS=-7,
      YP_VERS=-8

CONST YPXFR_SUCC=1,
      YPXFR_AGE=2,
      YPXFR_NOMAP=-1,
      YPXFR_NODOM=-2,
      YPXFR_RSRC=-3,
      YPXFR_RPC=-4,
      YPXFR_MADDR=-5,
      YPXFR_YPERR=-6,
      YPXFR_BADARGS=-7,
      YPXFR_DBM=-8,
      YPXFR_FILE=-9,
      YPXFR_SKEW=-10,
      YPXFR_CLEAR=-11,
      YPXFR_FORCE=-12,
      YPXFR_XFRERR=-13,
      YPXFR_REFUSED=-14

#define domainname_t PTR TO CHAR
#define mapname_t    PTR TO CHAR
#define peername_t   PTR TO CHAR

OBJECT keydat
  len
  val:PTR TO CHAR
ENDOBJECT

OBJECT valdat
  len
  val:PTR TO CHAR
ENDOBJECT

OBJECT ypmap_parms
  domain:domainname_t
  map:mapname_t
  ordernum
  peer:peername_t
ENDOBJECT

OBJECT ypreq_key
  domain:domainname_t
  map:mapname_t
  key:keydat
ENDOBJECT

OBJECT ypreq_nokey
  domain:domainname_t
  map:mapname_t
ENDOBJECT

OBJECT ypreq_xfr
  map_parms:ypmap_parms
  transid
  prog
  port
ENDOBJECT

OBJECT ypresp_val
  stat
  val:valdat
ENDOBJECT

OBJECT ypresp_key_val
  stat
  key:keydat
  val:valdat
ENDOBJECT

OBJECT ypresp_master
  stat
  peer:peername_t
ENDOBJECT

OBJECT ypresp_order
  stat
  ordernum
ENDOBJECT

OBJECT ypresp_all
  more
  val:ypresp_key_val
ENDOBJECT

OBJECT ypresp_xfr
  transid
  xfrstat
ENDOBJECT

OBJECT ypmaplist
  map:mapname_t
  next:PTR TO ypmaplist
ENDOBJECT

OBJECT ypresp_maplist
  stat
  maps:PTR TO ypmaplist
ENDOBJECT

CONST YPPUSH_SUCC=1,
      YPPUSH_AGE=2,
      YPPUSH_NOMAP=-1,
      YPPUSH_NODOM=-2,
      YPPUSH_RSRC=-3,
      YPPUSH_RPC=-4,
      YPPUSH_MADDR=-5,
      YPPUSH_YPERR=-6,
      YPPUSH_BADARGS=-7,
      YPPUSH_DBM=-8,
      YPPUSH_FILE=-9,
      YPPUSH_SKEW=-10,
      YPPUSH_CLEAR=-11,
      YPPUSH_FORCE=-12,
      YPPUSH_XFRERR=-13,
      YPPUSH_REFUSED=-14

OBJECT yppushresp_xfr
  transid
  status
ENDOBJECT

ENUM YPBIND_SUCC_VAL=1, YPBIND_FAIL_VAL

OBJECT ypbind_binding
  addr[4]:ARRAY
  port[2]:ARRAY
ENDOBJECT

OBJECT ypbind_resp
  status
  bindinfo:ypbind_binding  -> Unioned with error
ENDOBJECT

ENUM YPBIND_ERR_ERR=1, YPBIND_ERR_NOSERV, YPBIND_ERR_RESC

OBJECT ypbind_setdom
  domain:domainname_t
  binding:ypbind_binding
  vers
ENDOBJECT

CONST YPPROG=100004,
      YPVERS=2

ENUM YPPROC_NULL, YPPROC_DOMAIN, YPPROC_DOMAIN_NONACK, YPPROC_MATCH,
     YPPROC_FIRST, YPPROC_NEXT, YPPROC_XFR, YPPROC_CLEAR, YPPROC_ALL,
     YPPROC_MASTER, YPPROC_ORDER, YPPROC_MAPLIST

CONST YPPUSH_XFRRESPPROG=$40000000,
      YPPUSH_XFRRESPVERS=1

ENUM YPPUSHPROC_NULL, YPPUSHPROC_XFRRESP

CONST YPBINDPROG=100007,
      YPBINDVERS=2

ENUM YPBINDPROC_NULL, YPBINDPROC_DOMAIN, YPBINDPROC_SETDOM
