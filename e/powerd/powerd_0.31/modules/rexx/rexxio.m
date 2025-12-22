MODULE	'rexx/storage',
			'exec/ports',
			'exec/lists'

CONST	RXBUFFSZ=204			// buffer length

OBJECT IoBuff
	Node:RexxRsrc,
	Rpt:APTR,
	Rct:LONG,
	DFH:LONG,
	Lock:APTR,
	Bct:LONG,
	Area[RXBUFFSZ]:BYTE

ENUM	RXIO_EXIST=-1,
		RXIO_STRF,
		RXIO_READ,
		RXIO_WRITE,
		RXIO_APPEND

ENUM	RXIO_BEGIN=-1,
		RXIO_CURR,
		RXIO_END

#define LLOFFSET(rrp) (rrp.Arg1)   /* "Query" offset		*/
#define LLVERS(rrp)   (rrp.Arg2)   /* library version		*/
#define CLVALUE(rrp)  (rrp.Arg1)

OBJECT RexxMsgPort
	Node:RexxRsrc,
	Port:MP,
	ReplyList:LH

ENUM	DT_DEV,
		DT_DIR,
		DT_VOL

CONST	ACTION_STACK=2002,
		ACTION_QUEUE=2003
