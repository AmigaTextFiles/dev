OPT MODULE, PREPROCESS
OPT EXPORT

CONST RQ_PATHLEN=1024

OBJECT getquota_args
  pathp:PTR TO CHAR
  uid
ENDOBJECT

OBJECT rquota
  bsize
  active
  bhardlimit
  bsoftlimit
  curblocks
  fhardlimit
  fsoftlimit
  curfiles
  btimeleft
  ftimeleft
ENDOBJECT

ENUM Q_OK=1, Q_NOQUOTA, Q_EPERM

OBJECT getquota_rslt
  status
  rquota:rquota
ENDOBJECT

CONST RQUOTAPROG=100011,
      RQUOTAVERS=1

ENUM RQUOTAPROC_GETQUOTA=1, RQUOTAPROC_GETACTIVEQUOTA
