/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_USERGROUP_H
#define _PPCINLINE_USERGROUP_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef USERGROUP_BASE_NAME
#define USERGROUP_BASE_NAME UserGroupBase
#endif /* !USERGROUP_BASE_NAME */

#define crypt(key, salt) \
	LP2(0xae, char *, crypt, const char *, key, a0, const char *, salt, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define endgrent() \
	LP0NR(0xa8, endgrent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define endpwent() \
	LP0NR(0x8a, endpwent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define endutent() \
	LP0NR(0xf0, endutent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getcredentials(task) \
	LP1(0x102, struct UserGroupCredentials *, getcredentials, struct Task *, task, a0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getegid() \
	LP0(0x4e, gid_t, getegid, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define geteuid() \
	LP0(0x36, uid_t, geteuid, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getgid() \
	LP0(0x48, gid_t, getgid, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getgrent() \
	LP0(0xa2, struct group *, getgrent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getgrgid(gid) \
	LP1(0x96, struct group *, getgrgid, gid_t, gid, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getgrnam(name) \
	LP1(0x90, struct group *, getgrnam, const char *, name, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getgroups(ngroups, groups) \
	LP2(0x60, int, getgroups, int, ngroups, d0, gid_t *, groups, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getlastlog(uid) \
	LP1(0xf6, struct lastlog *, getlastlog, uid_t, uid, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getlogin() \
	LP0(0xd8, char *, getlogin, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getpass(prompt) \
	LP1(0xba, char *, getpass, const char *, prompt, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getpgrp() \
	LP0(0xd2, pid_t, getpgrp, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getpwent() \
	LP0(0x84, struct passwd *, getpwent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getpwnam(name) \
	LP1(0x72, struct passwd *, getpwnam, const char *, name, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getpwuid(uid) \
	LP1(0x78, struct passwd *, getpwuid, uid_t, uid, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getuid() \
	LP0(0x30, uid_t, getuid, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getumask() \
	LP0(0xc6, mode_t, getumask, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define getutent() \
	LP0(0xea, struct utmp *, getutent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define initgroups(name, basegroup) \
	LP2(0x6c, int, initgroups, const char *, name, a1, gid_t, basegroup, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setgid(id) \
	LP1(0x5a, int, setgid, gid_t, id, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setgrent() \
	LP0NR(0x9c, setgrent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setgroups(ngroups, groups) \
	LP2(0x66, int, setgroups, int, ngroups, d0, const gid_t *, groups, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setlastlog(uid, name, host) \
	LP3(0xfc, int, setlastlog, uid_t, uid, d0, char *, name, a0, char *, host, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setlogin(buffer) \
	LP1(0xde, int, setlogin, const char *, buffer, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setpwent() \
	LP0NR(0x7e, setpwent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setregid(real, eff) \
	LP2(0x54, int, setregid, gid_t, real, d0, gid_t, eff, d1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setreuid(real, eff) \
	LP2(0x3c, int, setreuid, uid_t, real, d0, uid_t, eff, d1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setsid() \
	LP0(0xcc, pid_t, setsid, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setuid(id) \
	LP1(0x42, int, setuid, uid_t, id, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define setutent() \
	LP0NR(0xe4, setutent, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ug_GetErr() \
	LP0(0x24, int, ug_GetErr, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ug_GetSalt(user, buffer, size) \
	LP3(0xb4, char *, ug_GetSalt, const struct passwd *, user, a0, char *, buffer, a1, ULONG, size, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ug_SetupContextTagList(pname, taglist) \
	LP2(0x1e, int, ug_SetupContextTagList, const UBYTE*, pname, a0, struct TagItem *, taglist, a1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define ug_SetupContextTags(a0, tags...) \
	({ULONG _tags[] = { tags }; ug_SetupContextTagList((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ug_StrError(code) \
	LP1(0x2a, const char *, ug_StrError, LONG, code, d1, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define umask(mask) \
	LP1(0xc0, mode_t, umask, mode_t, mask, d0, \
	, USERGROUP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_USERGROUP_H */
