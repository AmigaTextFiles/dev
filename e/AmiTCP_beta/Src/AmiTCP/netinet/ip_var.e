OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/netinet/in',
       'amitcp/sys/types',
       'other/bitfield'

OBJECT ipovly
  next:caddr_t, prev:caddr_t
  x1:CHAR
  pr:CHAR
  len:INT
  src:in_addr
  dst:in_addr
ENDOBJECT

OBJECT ipasfrag
  v_hl:CHAR  -> Bitfield v:4, hl:4
  mff:CHAR
  len:INT
  id:INT
  off:INT
  ttl:CHAR
  p:CHAR
  sum:INT
  next:PTR TO ipasfrag
  prev:PTR TO ipasfrag
ENDOBJECT

PROC ipasfrag_v(i:PTR TO ipasfrag) IS GETNBITSATX(4, 4, i.v_hl)
PROC ipasfrag_hl(i:PTR TO ipasfrag) IS GETNBITSATX(4, 0, i.v_hl)

PROC set_ip_v(i:PTR TO ipasfrag, v)
  i.v_hl:=SETNBITSATX(4, 4, i.v_hl, v)
ENDPROC

PROC set_ip_hl(i:PTR TO ipasfrag, v)
  i.v_hl:=SETNBITSATX(4, 0, i.v_hl, v)
ENDPROC

OBJECT ipq
  next:PTR TO ipq, prev:PTR TO ipq
  ttl:CHAR
  p:CHAR
  id:INT
  next:PTR TO ipasfrag, prev:PTR TO ipasfrag
  src:in_addr, dst:in_addr
ENDOBJECT

CONST MAX_IPOPTLEN=40

OBJECT ipoption
  dst:in_addr
  list[MAX_IPOPTLEN]:ARRAY
ENDOBJECT

OBJECT ipstat
  total
  badsum
  tooshort
  toosmall
  badhlen
  badlen
  fragments
  fragdropped
  fragtimeout
  forward
  cantforward
  redirectsent
  noproto
  delivered
  localout
  odropped
  reassembled
  fragmented
  ofragments
  cantfrag
ENDOBJECT
