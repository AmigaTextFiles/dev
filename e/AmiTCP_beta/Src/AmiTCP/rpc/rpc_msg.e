OPT MODULE
OPT EXPORT

MODULE 'amitcp/rpc/auth'

CONST RPC_MSG_VERSION=2,
      RPC_SERVICE_PORT=2048

ENUM CALL, REPLY

ENUM MSG_ACCEPTED, MSG_DENIED

ENUM SUCCESS, PROG_UNAVAIL, PROG_MISMATCH, PROG_UNAVAIL, GARBAGE_ARGS,
     SYSTEM_ERR

ENUM RPC_MISMATCH, AUTH_ERROR

OBJECT accepted_reply
  verf:opaque_auth
  stat
  low  -> Unioned with where:caddr_t (PTR TO CHAR)
  high  -> Unioned with proc:xdrproc_t (LONG)
ENDOBJECT

OBJECT rejected_reply
  stat
  low  -> Unioned with why
  high
ENDOBJECT

OBJECT reply_body
  stat
  ar:accepted_reply  -> Unioned with dr:rejected_reply
ENDOBJECT

OBJECT call_body
  rpcvers
  prog
  vers
  proc
  cred:opaque_auth
  verf:opaque_auth
ENDOBJECT

OBJECT rpc_msg
  xid
  direction
  cmb:call_body  -> Unioned with rmb:reply_body
ENDOBJECT
