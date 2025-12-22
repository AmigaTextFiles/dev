typedef union {
	int i;
	bpf_u_int32 h;
	u_char *e;
	char *s;
	struct stmt *stmt;
	struct arth *a;
	struct {
		struct qual q;
		struct block *b;
	} blk;
	struct block *rblk;
} YYSTYPE;
#define	DST	257
#define	SRC	258
#define	HOST	259
#define	GATEWAY	260
#define	NET	261
#define	MASK	262
#define	PORT	263
#define	LESS	264
#define	GREATER	265
#define	PROTO	266
#define	PROTOCHAIN	267
#define	BYTE	268
#define	ARP	269
#define	RARP	270
#define	IP	271
#define	TCP	272
#define	UDP	273
#define	ICMP	274
#define	IGMP	275
#define	IGRP	276
#define	PIM	277
#define	ATALK	278
#define	DECNET	279
#define	LAT	280
#define	SCA	281
#define	MOPRC	282
#define	MOPDL	283
#define	TK_BROADCAST	284
#define	TK_MULTICAST	285
#define	NUM	286
#define	INBOUND	287
#define	OUTBOUND	288
#define	LINK	289
#define	GEQ	290
#define	LEQ	291
#define	NEQ	292
#define	ID	293
#define	EID	294
#define	HID	295
#define	HID6	296
#define	LSH	297
#define	RSH	298
#define	LEN	299
#define	IPV6	300
#define	ICMPV6	301
#define	AH	302
#define	ESP	303
#define	OR	304
#define	AND	305
#define	UMINUS	306


extern YYSTYPE pcap_lval;
