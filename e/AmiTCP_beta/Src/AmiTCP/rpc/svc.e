OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/netinet/in',
       'amitcp/rpc/auth',
       'amitcp/sys/types'

ENUM XPRT_DIED, XPRT_MOREREQS, XPRT_IDLE

OBJECT xp_ops
  recv
  stat
  getargs
  reply
  freeargs
  destroy
ENDOBJECT

OBJECT svcxprt
  sock
  port:INT
  ops:PTR TO xp_ops
  addrlen
  raddr:sockaddr_in
  verf:opaque_auth
  p1:caddr_t
  p2:caddr_t
ENDOBJECT

PROC svc_getcaller(x:PTR TO svcxprt) IS x+16

PROC svc_recv(xprt:PTR TO svcxprt, msg)
  DEF f
  f:=xprt.ops.recv
ENDPROC f(xprt, msg)

#define SVC_RECV(xprt,msg) svc_recv(xprt,msg)

PROC svc_stat(xprt:PTR TO svcxprt)
  DEF f
  f:=xprt.ops.stat
ENDPROC f(xprt)

#define SVC_STAT(xprt) svc_stat(xprt)

PROC svc_getargs(xprt:PTR TO svcxprt, xargs, argsp)
  DEF f
  f:=xprt.ops.getargs
ENDPROC f(xprt, xargs, argsp)

#define SVC_GETARGS(xprt,xargs,argsp) svc_getargs(xprt,xargs,argsp)

PROC svc_reply(xprt:PTR TO svcxprt, msg)
  DEF f
  f:=xprt.ops.reply
ENDPROC f(xprt, msg)

#define SVC_REPLY(xprt,msg) svc_reply(xprt,msg)

PROC svc_freeargs(xprt:PTR TO svcxprt, xargs, argsp)
  DEF f
  f:=xprt.ops.freeargs
ENDPROC f(xprt, xargs, argsp)

#define SVC_FREEARGS(xprt,xargs,argsp) svc_freeargs(xprt,xargs,argsp)

PROC svc_destroy(xprt:PTR TO svcxprt)
  DEF f
  f:=xprt.ops.destroy
ENDPROC f(xprt)

#define SVC_DESTROY(xprt) svc_destroy(xprt)

OBJECT svc_req
  prog
  vers
  proc
  cred:opaque_auth
  clntcred:caddr_t
  xprt:PTR TO svcxprt
ENDOBJECT

CONST RPC_ANYSOCK=-1
