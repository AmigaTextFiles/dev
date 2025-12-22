#ifndef GRP_H
#define GRP_H

#ifndef SYS_TYPES_H
#include <sys/types.h>
#endif

/* The group structure */
struct group {
  char   *gr_name;              /* Group name.  */
  char   *gr_passwd;            /* Password.    */
  gid_t   gr_gid;               /* Group ID.    */
  char  **gr_mem;               /* Member list. */
};

#ifndef PROTO_USERGROUP_H
struct group *getgrgid(gid_t gid);
struct group *getgrnam(const char * name);

void setgrent(void);
struct group *getgrent(void);
void endgrent(void);
#endif

#endif /* GRP_H */
