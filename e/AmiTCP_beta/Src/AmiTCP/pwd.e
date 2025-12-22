OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/amitcp/types'

OBJECT passwd
  name:PTR TO CHAR
  passwd:PTR TO CHAR
  uid:uid_t
  gid:gid_t
  gecos:PTR TO CHAR
  dir:PTR TO CHAR
  shell:PTR TO CHAR
ENDOBJECT
