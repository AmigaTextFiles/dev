OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/netinet/in',
       'other/bitfield'

CONST IPVERSION=4

CONST IP_DF=$4000,
      IP_MF=$2000

OBJECT ip
  v_hl:CHAR  -> Bitfield v:4, hl:4
  tos:CHAR
  len:INT
  id:INT
  off:INT
  ttl:CHAR
  p:CHAR
  sum:INT
  src:in_addr, dst:in_addr
ENDOBJECT

PROC ip_v(i:PTR TO ip) IS GETNBITSATX(4, 4, i.v_hl)
PROC ip_hl(i:PTR TO ip) IS GETNBITSATX(4, 0, i.v_hl)

PROC set_ip_v(i:PTR TO ip, v)
  i.v_hl:=SETNBITSATX(4, 4, i.v_hl, v)
ENDPROC

PROC set_ip_hl(i:PTR TO ip, v)
  i.v_hl:=SETNBITSATX(4, 0, i.v_hl, v)
ENDPROC

CONST IP_MAXPACKET=65535

CONST IPTOS_LOWDELAY=$10,
      IPTOS_THROUGHPUT=$08,
      IPTOS_RELIABILITY=$04

CONST IPTOS_PREC_NETCONTROL=$E0,
      IPTOS_PREC_INTERNETCONTROL=$C0,
      IPTOS_PREC_CRITIC_ECP=$A0,
      IPTOS_PREC_FLASHOVERRIDE=$80,
      IPTOS_PREC_FLASH=$60,
      IPTOS_PREC_IMMEDIATE=$40,
      IPTOS_PREC_PRIORITY=$20,
      IPTOS_PREC_ROUTINE=$10

#define IPOPT_COPIED(o) ((o) AND $80)
#define IPOPT_CLASS(o) ((o) AND $60)
#define IPOPT_NUMBER(o) ((o) AND $1F)

CONST IPOPT_CONTROL=$00,
      IPOPT_RESERVED1=$20,
      IPOPT_DEBMEAS=$40,
      IPOPT_RESERVED2=$60

CONST IPOPT_EOL=0,
      IPOPT_NOP=1

CONST IPOPT_RR=7,
      IPOPT_TS=68,
      IPOPT_SECURITY=130,
      IPOPT_LSRR=131,
      IPOPT_SATID=136,
      IPOPT_SSRR=137

CONST IPOPT_OPTVAL=0,
      IPOPT_OLEN=1,
      IPOPT_OFFSET=2,
      IPOPT_MINOFF=4

OBJECT ipt_ta
  addr:in_addr
  time
ENDOBJECT

OBJECT ip_timestamp
  code:CHAR
  len:CHAR
  ptr:CHAR
  oflw_flg:CHAR  -> Bitfield oflw:4, flg:4
  ta[1]:ARRAY OF ipt_ta  -> Unioned with time[1]:ARRAY OF LONG
ENDOBJECT

PROC ip_timestamp_oflw(i:PTR TO ip_timestamp) IS GETNBITSATX(4, 4, i.oflw_flg)
PROC ip_timestamp_flg(i:PTR TO ip_timestamp) IS GETNBITSATX(4, 0, i.oflw_flg)

PROC set_ip_timestamp_oflw(i:PTR TO ip_timestamp, v)
  i.oflw_flg:=SETNBITSATX(4, 4, i.oflw_flg, v)
ENDPROC

PROC set_ip_timestamp_flg(i:PTR TO ip_timestamp, v)
  i.oflw_flg:=SETNBITSATX(4, 0, i.oflw_flg, v)
ENDPROC

CONST IPOPT_TS_TSONLY=0,
      IPOPT_TS_TSANDADDR=1,
      IPOPT_TS_PRESPEC=3

CONST IPOPT_SECUR_UNCLASS=$0000,
      IPOPT_SECUR_CONFID=$F135,
      IPOPT_SECUR_EFTO=$789A,
      IPOPT_SECUR_MMMM=$BC4D,
      IPOPT_SECUR_RESTR=$AF13,
      IPOPT_SECUR_SECRET=$D788,
      IPOPT_SECUR_TOPSECRET=$6BC5

CONST MAXTTL=255,
      IPFRAGTTL=60,
      IPTTLDEC=1,
      IP_MSS=576
