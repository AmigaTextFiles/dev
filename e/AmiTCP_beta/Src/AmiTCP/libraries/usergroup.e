OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'exec/tasks',
       'amitcp/amitcp/types'

#define USERGROUPNAME 'AmiTCP:libs/usergroup.library'

CONST PASSWORD_EFMT1="_",
      PASSWORD_LEN=128,
      NGROUPS=32,
      MAXLOGNAME=32

OBJECT usergroupcredentials
  ruid:uid_t
  rgid:gid_t
  umask:mode_t
  euid:uid_t
  ngroups:INT
  groups[NGROUPS]:ARRAY OF gid_t
  session:pid_t
  login[MAXLOGNAME]:ARRAY
ENDOBJECT

#define UG2MU(id) (IF (id)=0 THEN 65535 ELSE (IF (id)=-2 THEN 0 ELSE (id)))
#define MU2UG(id) (IF (id)=65535 THEN 0 ELSE (IF (id)=0 THEN -2 ELSE (id)))

CONST UGT_ERRNOBPTR=$80000001,
      UGT_ERRNOWPTR=$80000002,
      UGT_ERRNOLPTR=$80000004

#define UGT_ERRNOPTR(size) (IF (size)=4 THEN UGT_ERRNOLPTR ELSE \
                            IF (size)=2 THEN UGT_ERRNOWPTR ELSE \
                            IF (size)=1 THEN UGT_ERRNOBPTR ELSE 1)

CONST UGT_OWNER=$80000011,
      UGT_INTRMASK=$80000010
