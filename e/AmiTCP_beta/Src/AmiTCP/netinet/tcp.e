OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'other/bitfield'

#define tcp_seq LONG

SET TH_FIN, TH_SYN, TH_RST, TH_PUSH, TH_ACK, TH_URG

OBJECT tcphdr
  sport:INT
  dport:INT
  seq:tcp_seq
  ack:tcp_seq
  off_x2:CHAR  -> Bitfield off:4, x2:4
  flags:CHAR
  win:INT
  sum:INT
  urp:INT
ENDOBJECT

PROC tcphdr_off(t:PTR TO tcphdr) IS GETNBITSATX(4, 4, t.off_x2)
PROC tcphdr_x2(t:PTR TO tcphdr) IS GETNBITSATX(4, 0, t.off_x2)

PROC set_tcphdr_off(t:PTR TO tcphdr, v)
  t.off_x2:=SETNBITSATX(4, 4, t.off_x2, v)
ENDPROC

PROC set_tcphdr_x2(t:PTR TO tcphdr, v)
  t.off_x2:=SETNBITSATX(4, 0, t.off_x2, v)
ENDPROC

ENUM TCPOPT_EOL, TCPOPT_NOP, TCPOPT_MAXSEG

CONST TCP_MSS=512,
      TCP_MAXWIN=65535,
      TCP_NODELAY=1,
      TCP_MAXSEG=2
