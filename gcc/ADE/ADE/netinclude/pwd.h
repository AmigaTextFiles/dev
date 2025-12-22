#ifndef PWD_H
#define PWD_H

#ifndef SYS_TYPES_H
#include <sys/types.h>
#endif

/* The passwd structure */
struct passwd
{
  char  *pw_name;               /* Username */
  char  *pw_passwd;             /* Encrypted password */
  uid_t  pw_uid;                /* User ID */
  gid_t  pw_gid;                /* Group ID */
  char  *pw_gecos;		/* Real name etc */
  char  *pw_dir;                /* Home directory */
  char  *pw_shell;              /* Shell */
};


#ifndef PROTO_USERGROUP_H
struct passwd *getpwuid(uid_t uid);
struct passwd *getpwnam(const char *name);

void setpwent(void);
struct passwd *getpwent(void);
void endpwent(void);
#endif

#endif /* PWD_H */
