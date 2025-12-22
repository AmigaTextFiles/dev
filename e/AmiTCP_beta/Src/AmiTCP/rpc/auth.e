OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/rpc/xdr',
       'amitcp/sys/types'

CONST MAX_AUTH_BYTES=400,
      MAXNETNAMELEN=255

ENUM AUTH_OK, AUTH_BADCRED, AUTH_REJECTEDCRED, AUTH_BADVERF,
     AUTH_REJECTEDVERF, AUTH_TOOWEAK, AUTH_INVALIDRESP, AUTH_FAILED

OBJECT des_block
  high  -> Unioned with c[8]:ARRAY
  low
ENDOBJECT

OBJECT opaque_auth
  flavor
  base:caddr_t
  length
ENDOBJECT

OBJECT auth_ops
  nextverf
  marshal
  validate
  refresh
  destroy
ENDOBJECT

OBJECT auth
  cred:opaque_auth
  verf:opaque_auth
  key:des_block
  ops:PTR TO auth_ops
  private:caddr_t
ENDOBJECT

PROC auth_nextverf(auth:PTR TO auth)
  DEF f
  f:=auth.ops.nextverf
ENDPROC f(auth)

#define AUTH_NEXTVERF(auth) auth_nextverf(auth)

PROC auth_marshall(auth:PTR TO auth, xdrs)
  DEF f
  f:=auth.ops.marshal
ENDPROC f(auth, xdrs)

#define AUTH_MARSHALL(auth,xdrs) auth_marshall(auth,xdrs)

PROC auth_validate(auth:PTR TO auth, verfp)
  DEF f
  f:=auth.ops.validate
ENDPROC f(auth, verfp)

#define AUTH_VALIDATE(auth,verfp) auth_validate(auth,verfp)

PROC auth_refresh(auth:PTR TO auth)
  DEF f
  f:=auth.ops.refresh
ENDPROC f(auth)

#define AUTH_REFRESH(auth) auth_refresh(auth)

PROC auth_destroy(auth:PTR TO auth)
  DEF f
  f:=auth.ops.destroy
ENDPROC f(auth)

#define AUTH_DESTROY(auth) auth_destroy(auth)

ENUM AUTH_NONE, AUTH_NULL=0, AUTH_UNIX, AUTH_SHORT, AUTH_DES
