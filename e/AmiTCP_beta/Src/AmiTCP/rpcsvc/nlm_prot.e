OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/rpc/xdr'

CONST LM_MAXSTRLEN=1024
CONST MAXNAMELEN=LM_MAXSTRLEN+1

ENUM NLM_GRANTED_, NLM_DENIED, NLM_DENIED_NOLOCKS, NLM_BLOCKED,
     NLM_DENIED_GRACE_PERIOD

OBJECT nlm_holder
  exclusive
  svid
  oh:netobj
  l_offset
  l_len
ENDOBJECT

OBJECT nlm_testrply
  stat
  holder:nlm_holder
ENDOBJECT

OBJECT nlm_stat
  stat
ENDOBJECT

OBJECT nlm_res
  cookie:netobj
  stat:nlm_stat
ENDOBJECT

OBJECT nlm_testres
  cookie:netobj
  stat:nlm_testrply
ENDOBJECT

OBJECT nlm_lock
  caller_name:PTR TO CHAR
  fh:netobj
  oh:netobj
  svid
  l_offset
  l_len
ENDOBJECT

OBJECT nlm_lockargs
  cookie:netobj
  block
  exclusive
  alock:nlm_lock
  reclaim
  state
ENDOBJECT

OBJECT nlm_cancargs
  cookie:netobj
  block
  exclusive
  alock:nlm_lock
ENDOBJECT

OBJECT nlm_testargs
  cookie:netobj
  exclusive
  alock:nlm_lock
ENDOBJECT

OBJECT nlm_unlockargs
  cookie:netobj
  alock:nlm_lock
ENDOBJECT

ENUM FSM_DN, FSM_DR, FSM_DW, FSM_DRW

ENUM FSA_NONE, FSA_R, FSA_W, FSA_RW

OBJECT nlm_share
  caller_name:PTR TO CHAR
  fh:netobj
  oh:netobj
  mode
  access
ENDOBJECT

OBJECT nlm_shareargs
  cookie:netobj
  share:nlm_share
  reclaim
ENDOBJECT

OBJECT nlm_shareres
  cookie:netobj
  stat
  sequence
ENDOBJECT

OBJECT nlm_notify
  name:PTR TO CHAR
  state
ENDOBJECT

CONST NLM_PROG=100021,
      NLM_VERS=1

ENUM NLM_TEST=1, NLM_LOCK, NLM_CANCEL, NLM_UNLOCK, NLM_GRANTED, NLM_TEST_MSG,
     NLM_LOCK_MSG, NLM_CANCEL_MSG, NLM_UNLOCK_MSG, NLM_GRANTED_MSG,
     NLM_TEST_RES, NLM_LOCK_RES, NLM_LOCK_RES, NLM_CANCEL_RES,
     NLM_UNLOCK_RES, NLM_GRANTED_RES

CONST NLM_VERSX=3

ENUM NLM_SHARE=20, NLM_UNSHARE, NLM_NM_LOCK, NLM_FREE_ALL
