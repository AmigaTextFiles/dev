OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/types'

ENUM XDR_ENCODE, XDR_DECODE, XDR_FREE

CONST BYTES_PER_XDR_UNIT=4

#define RNDUP(x) \
  Mul(Div((x)+BYTES_PER_XDR_UNIT-1,BYTES_PER_XDR_UNIT),BYTES_PER_XDR_UNIT)

OBJECT xdr_ops
  getlong
  putlong
  getbytes
  putbytes
  getpostn
  setpostn
  inline
  destroy
ENDOBJECT

OBJECT xdr
  op
  ops:PTR TO xdr_ops
  public:caddr_t
  private:caddr_t
  base:caddr_t
  handy
ENDOBJECT

PROC xdr_getlong(xdrs:PTR TO xdr, longp)
  DEF f
  f:=xdrs.ops.getlong
ENDPROC f(xdrs, longp)

#define XDR_GETLONG(xdrs,longp) xdr_getlong(xdrs,longp)

PROC xdr_putlong(xdrs:PTR TO xdr, longp)
  DEF f
  f:=xdrs.ops.putlong
ENDPROC f(xdrs, longp)

#define XDR_PUTLONG(xdrs,longp) xdr_putlong(xdrs,longp)

PROC xdr_getbytes(xdrs:PTR TO xdr, addr, len)
  DEF f
  f:=xdrs.ops.getbytes
ENDPROC f(xdrs, addr, len)

#define XDR_GETBYTES(xdrs,addr,len) xdr_getbytes(xdrs,addr,len)

PROC xdr_putbytes(xdrs:PTR TO xdr, addr, len)
  DEF f
  f:=xdrs.ops.putbytes
ENDPROC f(xdrs, addr, len)

#define XDR_PUTBYTES(xdrs,addr,len) xdr_putbytes(xdrs,addr,len)

PROC xdr_getpos(xdrs:PTR TO xdr)
  DEF f
  f:=xdrs.ops.getpostn
ENDPROC f(xdrs)

#define XDR_GETPOS(xdrs) xdr_getpos(xdrs)

PROC xdr_setpos(xdrs:PTR TO xdr, pos)
  DEF f
  f:=xdrs.ops.setpostn
ENDPROC f(xdrs, pos)

#define XDR_SETPOS(xdrs,pos) xdr_setpos(xdrs,pos)

PROC xdr_inline(xdrs:PTR TO xdr, len)
  DEF f
  f:=xdrs.ops.inline
ENDPROC f(xdrs, len)

#define XDR_INLINE(xdrs,len) xdr_inline(xdrs,len)

PROC xdr_destroy(xdrs:PTR TO xdr)
  DEF f
  f:=xdrs.ops.destroy
ENDPROC f(xdrs)

#define XDR_DESTROY(xdrs) xdr_destroy(xdrs)

#define xdrproc_t LONG

OBJECT xdr_discrim
  value
  proc:xdrproc_t
ENDOBJECT

-> To use these buf must be of type PTR TO LONG
-> ntohl(x) is x
#define IXDR_GET_LONG(buf)      (buf[]++)
#define IXDR_PUT_LONG(buf,v)    (buf[]++:=(v))

#define IXDR_GET_BOOL(buf)      IXDR_GET_LONG(buf)
#define IXDR_GET_ENUM(buf,t)    IXDR_GET_LONG(buf)
#define IXDR_GET_U_LONG(buf)    IXDR_GET_LONG(buf)
#define IXDR_GET_SHORT(buf)     IXDR_GET_LONG(buf)
#define IXDR_GET_U_SHORT(buf)   IXDR_GET_LONG(buf)

#define IXDR_PUT_BOOL(buf,v)    IXDR_PUT_LONG(buf,v)
#define IXDR_PUT_ENUM(buf,v)    IXDR_PUT_LONG(buf,v)
#define IXDR_PUT_U_LONG(buf,v)  IXDR_PUT_LONG(buf,v)
#define IXDR_PUT_SHORT(buf,v)   IXDR_PUT_LONG(buf,v)
#define IXDR_PUT_U_SHORT(buf,v) IXDR_PUT_LONG(buf,v)

CONST MAX_NETOBJ_SZ=1024

OBJECT netobj
  len
  bytes:PTR TO CHAR
ENDOBJECT
