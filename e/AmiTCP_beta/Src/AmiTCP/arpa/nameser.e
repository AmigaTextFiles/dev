OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'other/bitfield'

CONST PACKETSZ=512,
      MAXDNAME=256,
      MAXCDNAME=255,
      MAXLABEL=63,
      QFIXEDSZ=4,
      RRFIXEDSZ=10,
      NAMESERVER_PORT=53

ENUM QUERY, IQUERY, STATUS,
     UPDATEA=9, UPDATED, UPDATEDA, UPDATEM, UPDATEMA, ZONEINIT, ZONEREF

ENUM NOERROR, FORMERR, SERVFAIL, NXDOMAIN, NOTIMP, REFUSED, NOCHANGE=$F

ENUM T_A=1, T_NS, T_MD, T_MF, T_CNAME, T_SOA, T_MB, T_MG, T_MR, T_NULL,
     T_WKS, T_PTR, T_HINFO, T_MINFO, T_MX, T_TXT

ENUM T_UINFO=100, T_UID, T_GID, T_UNSPEC,
     T_AXFR=252, T_MAILB, T_MAILA, T_ANY

ENUM C_IN=1, C_CHAOS=3, C_HS, C_ANY=255

CONST CONV_SUCCESS=0,
      CONV_OVERFLOW=-1,
      CONV_BADFMT=-2,
      CONV_BADCKSUM=-3,
      CONV_BADBUFLEN=-4

CONST LITTLE_ENDIAN=1234, BIG_ENDIAN=4321, PDP_ENDIAN=3412

CONST BYTE_ORDER=BIG_ENDIAN

OBJECT header
  id:INT
  qr_opcode_aa_tc_rd:CHAR  -> Bit-fields!
  ra_pr_unused_rcode:CHAR  -> Bit-fields!
  qdcount:INT
  ancount:INT
  nscount:INT
  arcount:INT
ENDOBJECT

PROC header_qr(h:PTR TO header) IS GETNBITSATX(1, 7, h.qr_opcode_aa_tc_rd)
PROC header_opcode(h:PTR TO header) IS GETNBITSATX(4, 3, h.qr_opcode_aa_tc_rd)
PROC header_aa(h:PTR TO header) IS GETNBITSATX(1, 2, h.qr_opcode_aa_tc_rd)
PROC header_tc(h:PTR TO header) IS GETNBITSATX(1, 1, h.qr_opcode_aa_tc_rd)
PROC header_rd(h:PTR TO header) IS GETNBITSATX(1, 0, h.qr_opcode_aa_tc_rd)

PROC set_header_qr(h:PTR TO header, v)
  h.qr_opcode_aa_tc_rd:=SETNBITSATX(1, 7, h.qr_opcode_aa_tc_rd, v)
ENDPROC

PROC set_header_opcode(h:PTR TO header, v)
  h.qr_opcode_aa_tc_rd:=SETNBITSATX(4, 3, h.qr_opcode_aa_tc_rd, v)
ENDPROC

PROC set_header_aa(h:PTR TO header, v)
  h.qr_opcode_aa_tc_rd:=SETNBITSATX(1, 2, h.qr_opcode_aa_tc_rd, v)
ENDPROC

PROC set_header_tc(h:PTR TO header, v)
  h.qr_opcode_aa_tc_rd:=SETNBITSATX(1, 1, h.qr_opcode_aa_tc_rd, v)
ENDPROC

PROC set_header_rd(h:PTR TO header, v)
  h.qr_opcode_aa_tc_rd:=SETNBITSATX(1, 0, h.qr_opcode_aa_tc_rd, v)
ENDPROC

PROC header_ra(h:PTR TO header) IS GETNBITSATX(1, 7, h.ra_pr_unused_rcode)
PROC header_pr(h:PTR TO header) IS GETNBITSATX(1, 6, h.ra_pr_unused_rcode)
PROC header_unused(h:PTR TO header) IS GETNBITSATX(2, 4, h.ra_pr_unused_rcode)
PROC header_rcode(h:PTR TO header) IS GETNBITSATX(4, 0, h.ra_pr_unused_rcode)

PROC set_header_ra(h:PTR TO header, v)
  h.ra_pr_unused_rcode:=SETNBITSATX(1, 7, h.ra_pr_unused_rcode, v)
ENDPROC

PROC set_header_pr(h:PTR TO header, v)
  h.ra_pr_unused_rcode:=SETNBITSATX(1, 6, h.ra_pr_unused_rcode, v)
ENDPROC

PROC set_header_unused(h:PTR TO header, v)
  h.ra_pr_unused_rcode:=SETNBITSATX(2, 4, h.ra_pr_unused_rcode, v)
ENDPROC

PROC set_header_rcode(h:PTR TO header, v)
  h.ra_pr_unused_rcode:=SETNBITSATX(4, 0, h.ra_pr_unused_rcode, v)
ENDPROC

CONST INDIR_MASK=$C0

OBJECT rrec
  zone:INT
  class:INT
  type:INT
  ttl
  size
  data:PTR TO CHAR
ENDOBJECT

#define GETSHORT(s,cp) ((s:=Shl(cp[]++, 8)) BUT ((s) OR cp[]++))

#define GETLONG(s,cp) ((s:=Shl(cp[]++, 8)) BUT ( \
                       (s:=Shl((s) OR cp[]++, 8)) BUT ( \
                       (s:=Shl((s) OR cp[]++, 8)) BUT ((s) OR cp[]++))))

#define PUTSHORT(s,cp) ((cp[]++:=Shr((s), 8)) BUT (cp[]++:=(s)))

#define PUTLONG(l,cp) ((cp[3]:=(l)) BUT ( \
                       (cp[2]:=(l:=Shr((l),8))) BUT ( \
                       (cp[1]:=(l:=Shr((l),8))) BUT ( \
                       (cp[]:=Shr((l),8)) BUT (cp:=(cp)+SIZEOF LONG)))))
