OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/rpc/auth',
       'amitcp/sys/types'

ENUM RPC_SUCCESS, RPC_CANTENCODEARGS, RPC_CANTDECODERES, RPC_CANTSEND,
     RPC_CANTRECV, RPC_TIMEDOUT, RPC_VERSMISMATCH, RPC_AUTHERROR,
     RPC_PROGUNAVAIL, RPC_PROGVERSMISMATCH, RPC_PROCUNAVAIL,
     RPC_CANTDECODEARGS, RPC_SYSTEMERROR, RPC_UNKNOWNHOST, RPC_PMAPFAILURE,
     RPC_PROGNOTREGISTERED, RPC_FAILED, RPC_UNKNOWNPROTO

OBJECT rpc_err
  status
  low   -> Unioned with errno, why, s1
  high  -> Unioned with s2
ENDOBJECT

OBJECT clnt_ops
  call
  abort
  geterr
  freeres
  destroy
  control
ENDOBJECT

OBJECT client
  auth:PTR TO auth
  ops:PTR TO clnt_ops
  private:caddr_t
ENDOBJECT

PROC clnt_call(rh:PTR TO client, proc, xargs, argsp, xres, resp, secs)
  DEF f
  f:=rh.ops.call
ENDPROC f(rh, proc, xargs, argsp, xres, resp, secs)

#define CLNT_CALL(rh,proc,xargs,argsp,xres,resp,secs) \
  clnt_call(rh,proc,xargs,argsp,xres,resp,secs)

PROC clnt_abort(rh:PTR TO client)
  DEF f
  f:=rh.ops.abort
ENDPROC f(rh)

#define CLNT_ABORT(rh) clnt_abort(rh)

PROC clnt_geterr(rh:PTR TO client, errp)
  DEF f
  f:=rh.ops.geterr
ENDPROC f(rh, errp)

#define CLNT_GETERR(rh,errp) clnt_geterr(rh,errp)

PROC clnt_freeres(rh:PTR TO client, xres, resp)
  DEF f
  f:=rh.ops.freeres
ENDPROC f(rh, xres, resp)

#define CLNT_FREERES(rh,xres,resp) clnt_freeres(rh,xres,resp)

PROC clnt_control(rh:PTR TO client, rq, in)
  DEF f
  f:=rh.ops.control
ENDPROC f(rh, rq, in)

#define CLNT_CONTROL(rh,rq,in) clnt_control(rh,rq,in)

ENUM CLSET_TIMEOUT=1, CLGET_TIMEOUT, CLGET_SERVER_ADDR,
     CLSET_RETRY_TIMEOUT, CLGET_RETRY_TIMEOUT

PROC clnt_destroy(rh:PTR TO client)
  DEF f
  f:=rh.ops.destroy
ENDPROC f(rh)

#define CLNT_DESTROY(rh) clnt_destroy(rh)

ENUM RPCTEST_PROGRAM=1, RPCTEST_VERSION=1, RPCTEST_NULL_PROC,
     RPCTEST_NULL_BATCH_PROC

CONST NULLPROC=0

OBJECT rpc_createerr
  stat
  error:rpc_err
ENDOBJECT

CONST UDPMSGSIZE=8800,
      RPCSMALLMSGSIZE=400
