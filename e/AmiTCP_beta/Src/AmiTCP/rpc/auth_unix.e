OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/rpc/auth',
       'amitcp/amitcp/types'

CONST MAX_MACHINE_NAME=255,
      NGRPS=16

OBJECT authunix_parms
  time
  machname:PTR TO CHAR
  uid:uid_t
  gid:gid_t
  len
  gids:PTR TO gid_t
ENDOBJECT

OBJECT short_hand_verf
  new_cred:opaque_auth
ENDOBJECT
