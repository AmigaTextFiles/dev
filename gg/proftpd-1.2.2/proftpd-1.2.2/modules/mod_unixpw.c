/*
 * ProFTPD - FTP server daemon
 * Copyright (c) 1997, 1998 Public Flood Software
 * Copyright (C) 1999, 2000 MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
 *  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * As a special exemption, Public Flood Software/MacGyver aka Habeeb J. Dihu
 * and other respective copyright holders give permission to link this program
 * with OpenSSL, and distribute the resulting executable, without including
 * the source code for OpenSSL in the source distribution.
 */

/*
 * unix password lookup module for ProFTPD
 * $Id: mod_unixpw.c,v 1.13 2001/06/18 17:12:45 flood Exp $
 */

#include "conf.h"

#ifdef HAVE_CRYPT_H
#include <crypt.h>
#endif

#ifdef USESHADOW
#include <shadow.h>
#endif

#ifdef HAVE_SYS_SECURITY_H
#include <sys/security.h>
#endif
#ifdef HAVE_KRB_H
#include <krb.h>
#endif
#ifdef HAVE_HPSECURITY_H
#include <hpsecurity.h>
#endif
#ifdef HAVE_PROT_H
#include <prot.h>
#endif

#include "privs.h"

const char *pwdfname="/etc/passwd";
const char *grpfname="/etc/group";

#ifdef HAVE__PW_STAYOPEN
extern int _pw_stayopen;
#endif

#define HASH_TABLE_SIZE		100

typedef union idauth {
  uid_t uid;
  gid_t gid;
} idauth_t;

typedef struct _idmap {
  struct _idmap *next,*prev;

  /* This is a union because different OSs may give different types to UIDs
   * and GIDs.  This presents a far more portable way to deal with this
   * reality.
   */
  idauth_t id;

  char *name;			/* user or group name */
} idmap_t;

static xaset_t *uid_table[HASH_TABLE_SIZE];
static xaset_t *gid_table[HASH_TABLE_SIZE];

static FILE *pwdf = NULL;
static FILE *grpf = NULL;

#ifdef NEED_PERSISTENT_PASSWD
int persistent = 1;
#else
int persistent = 0;
#endif

static int persistent_passwd = 0, persistent_group = 0;

#define PERSISTENT_PASSWD	(persistent || persistent_passwd)
#define PERSISTENT_GROUP	(persistent || persistent_group)

#undef PASSWD
#define PASSWD		pwdfname
#undef GROUP
#define	GROUP		grpfname

#ifdef USESHADOW

/* Shadow password entries are stored as number of days, not seconds
 * and are -1 if unused
 */

#define SP_CVT_DAYS(x)	((x) == (time_t)-1 ? (x) : ((x) * 86400))

#endif /* USESHADOW */

static void p_setpwent()
{
  if(pwdf)
    rewind(pwdf);
  else
    if ((pwdf = fopen(PASSWD,"r")) == NULL)
      log_pri(LOG_ERR, "Unable to open password file %s for reading: %s", PASSWD, strerror(errno));
}

static void p_endpwent()
{
  if(pwdf) {
    fclose(pwdf);
    pwdf = NULL;
  }
}

static void p_setgrent()
{
  if(grpf)
    rewind(grpf);
  else
    if ((grpf = fopen(GROUP,"r")) == NULL)
      log_pri(LOG_ERR, "Unable to open group file %s for reading: %s", GROUP, strerror(errno));
}

static void p_endgrent()
{   
  if(grpf) {
    fclose(grpf);
    grpf = NULL;
  }
}

static struct passwd *p_getpwent()
{  
  if(!pwdf)
    p_setpwent();

  if(!pwdf)
    return NULL;
  
  return fgetpwent(pwdf);
}

static struct group *p_getgrent()
{   
  struct group *gr;
   
  if(!grpf)
    p_setgrent();
  
  if(!grpf)
    return NULL;

  gr = fgetgrent(grpf);  
 
  return gr;
}

static struct passwd *p_getpwnam(const char *name)
{  
  struct passwd *pw;
    
  p_setpwent();
  while((pw = p_getpwent()) != NULL)
    if(!strcmp(name,pw->pw_name))
      break;
 
  return pw;
}

static struct passwd *p_getpwuid(uid_t uid)
{   
  struct passwd *pw;
  
  p_setpwent();
  while((pw = p_getpwent()) != NULL)
    if(pw->pw_uid == uid)
      break;
 
  return pw;
}

static struct group *p_getgrnam(const char *name)
{ 
  struct group *gr;
  
  p_setgrent();
  while((gr = p_getgrent()) != NULL)
    if(!strcmp(name,gr->gr_name))
      break;
 
  return gr;
}

static struct group *p_getgrgid(gid_t gid)
{ 
  struct group *gr;
  
  p_setgrent();
  while((gr = p_getgrent()) != NULL)
    if(gr->gr_gid == gid)
      break;
 
  return gr;
}

inline static int _compare_uid(idmap_t *m1, idmap_t *m2)
{
  if(m1->id.uid < m2->id.uid)
    return -1;

  if(m1->id.uid > m2->id.uid)
    return 1;

  return 0;
}

inline static int _compare_gid(idmap_t *m1, idmap_t *m2)
{
  if(m1->id.gid < m2->id.gid)
    return -1;

  if(m1->id.gid > m2->id.gid)
    return 1;

  return 0;
}

inline static int _compare_id(xaset_t **table, idauth_t id, idauth_t idcomp)
{
  if(table == uid_table)
    return id.uid == idcomp.uid;
  else
    return id.gid == idcomp.gid;
}

static idmap_t *_auth_lookup_id(xaset_t **id_table, idauth_t id)
{
  int hash = ((id_table == uid_table) ? id.uid : id.gid) % HASH_TABLE_SIZE;
  idmap_t *m;
  
  if(!id_table[hash])
    id_table[hash] = xaset_create(permanent_pool, (id_table == uid_table) ?
				  (XASET_COMPARE)_compare_uid :
				  (XASET_COMPARE)_compare_gid);
  
  for(m = (idmap_t *) id_table[hash]->xas_list; m; m = m->next) {
    if(_compare_id(id_table, m->id, id))
      break;
  }
  
  if(!m || !_compare_id(id_table, m->id, id)) {
    /* Isn't in the table */
    m = (idmap_t *) pcalloc(id_table[hash]->mempool, sizeof(idmap_t));

    if(id_table == uid_table)
      m->id.uid = id.uid;
    else
      m->id.gid = id.gid;
    
    xaset_insert_sort(id_table[hash], (xasetmember_t *) m, FALSE);
  }
  
  return m;
}

MODRET pw_setpwent(cmd_rec *cmd)
{
  if(PERSISTENT_PASSWD)
    p_setpwent();
  else
    setpwent();

  return HANDLED(cmd);
}

MODRET pw_endpwent(cmd_rec *cmd)
{
  if(PERSISTENT_PASSWD)
    p_endpwent();
  else
    endpwent();

  return HANDLED(cmd);
}

MODRET pw_setgrent(cmd_rec *cmd)
{
  if(PERSISTENT_GROUP)
    p_setgrent();
  else
    setgrent();

  return HANDLED(cmd);
}

MODRET pw_endgrent(cmd_rec *cmd)
{
  if(PERSISTENT_GROUP)
    p_endgrent();
  else
    endgrent();

  return HANDLED(cmd);
}

MODRET pw_getgrent(cmd_rec *cmd)
{
  struct group *gr;

  if(PERSISTENT_GROUP)
    gr = p_getgrent();
  else
    gr = getgrent();

  if(gr)
    return mod_create_data(cmd,gr);
  else
    return ERROR(cmd);
}

MODRET pw_getpwent(cmd_rec *cmd)
{
  struct passwd *pw;

  if(PERSISTENT_PASSWD)
    pw = p_getpwent();
  else
    pw = getpwent();

  if(pw)
    return mod_create_data(cmd,pw);
  else
    return ERROR(cmd);
}

MODRET pw_getpwuid(cmd_rec *cmd)
{
  struct passwd *pw;
  uid_t uid;

  uid = (uid_t)cmd->argv[0];
  if(PERSISTENT_PASSWD)
    pw = p_getpwuid(uid);
  else
    pw = getpwuid(uid);

  if(pw)
    return mod_create_data(cmd,pw);
  else
    return ERROR(cmd);
}

MODRET pw_getpwnam(cmd_rec *cmd)
{
  struct passwd *pw;
  const char *name;

  name = cmd->argv[0];
  if(PERSISTENT_PASSWD)
    pw = p_getpwnam(name);
  else
    pw = getpwnam(name);

  if(pw)
    return mod_create_data(cmd,pw);
  else
    return ERROR(cmd);
}

MODRET pw_getgrnam(cmd_rec *cmd)
{
  struct group *gr;
  const char *name;

  name = cmd->argv[0];
  if(PERSISTENT_GROUP)
    gr = p_getgrnam(name);
  else
    gr = getgrnam(name);

  if(gr)
    return mod_create_data(cmd,gr);
  else
    return ERROR(cmd);
}

MODRET pw_getgrgid(cmd_rec *cmd)
{
  struct group *gr;
  gid_t gid;

  gid = (gid_t)cmd->argv[0];
  if(PERSISTENT_GROUP)
    gr = p_getgrgid(gid);
  else
    gr = getgrgid(gid);

  if(gr)
    return mod_create_data(cmd,gr);
  else
    return ERROR(cmd);
}

#ifdef USESHADOW
static char *_get_pw_info(pool *p, const char *u,
                          time_t *lstchg, time_t *min, time_t *max,
                          time_t *warn, time_t *inact, time_t *expire)
{
  struct spwd *sp;
  char *cpw = NULL;

  PRIVS_ROOT
  sp = getspnam(u);

  if(sp) {
    cpw = pstrdup(p,sp->sp_pwdp);
    if(lstchg) *lstchg = SP_CVT_DAYS(sp->sp_lstchg);
    if(min) *min = SP_CVT_DAYS(sp->sp_min);
    if(max) *max = SP_CVT_DAYS(sp->sp_max);
    if(warn) *warn = SP_CVT_DAYS(sp->sp_warn);
    if(inact) *inact = SP_CVT_DAYS(sp->sp_inact);
    if(expire) *expire = SP_CVT_DAYS(sp->sp_expire);
  }
#ifdef AUTOSHADOW
  else {
    struct passwd *pw;

    endspent();
    PRIVS_RELINQUISH

    if((pw = getpwnam(u)) != NULL) {
      cpw = pstrdup(p,pw->pw_passwd);
      if(lstchg) *lstchg = (time_t)-1;
      if(min) *min = (time_t)-1;
      if(max) *max = (time_t)-1;
      if(warn) *warn = (time_t)-1;
      if(inact) *inact = (time_t)-1;
      if(expire) *expire = (time_t)-1;
    }
  }
#else
  endspent();
  PRIVS_RELINQUISH
#endif /* AUTOSHADOW */
  return cpw;
}

#else /* USESHADOW */

static char *_get_pw_info(pool *p, const char *u,
                          time_t *lstchg, time_t *min, time_t *max,
                          time_t *warn, time_t *inact, time_t *expire)
{
  char *cpw = NULL;
#ifdef HAVE_GETPRPWENT
  struct pr_passwd *pw;
#else
  struct passwd *pw;
#endif

 /* some platforms (i.e. bsd) provide "transparent" shadowing, which
  * requires that we are root in order to have the password member
  * filled in.
  */

  PRIVS_ROOT
#ifndef HAVE_GETPRPWENT
  endpwent();
#if defined(BSDI3) || defined(BSDI4)
  /* endpwent() seems to be buggy on BSDI3.1 (is this true for 4.0?)
   * setpassent(0) _seems_ to do the same thing, however this conflicts
   * with the man page documented behavior.  Argh, why do all the bsds
   * have to be different in this area (except OpenBSD, grin).
   */
  setpassent(0);
#else /* BSDI3 || BSDI4 */
  setpwent();
#endif /* BSDI3 || BSDI4 */

  pw = getpwnam(u);

  if(pw) {
    cpw = pstrdup(p,pw->pw_passwd);
    if(lstchg) *lstchg = (time_t)-1;
    if(min) *min = (time_t)-1;
    if(max) *max = (time_t)-1;
    if(warn) *warn = (time_t)-1;
    if(inact) *inact = (time_t)-1;
    if(expire) *expire = (time_t)-1;
  }

  endpwent();

#else /* HAVE_GETPRPWENT */
  endprpwent();
  setprpwent();

  pw = getprpwnam(u);

  if(pw) {
    cpw = pstrdup(p,pw->ufld.fd_encrypt);
    if(lstchg) *lstchg = (time_t)-1;
    if(min) *min = pw->ufld.fd_min; 
    if(max) *max = (time_t)-1;
    if(warn) *warn = (time_t)-1;
    if(inact) *inact = (time_t)-1;
    if(expire) *expire = pw->ufld.fd_expire;
  }

  endprpwent();

#endif /* HAVE_GETPRPWENT */

  PRIVS_RELINQUISH
#if defined(BSDI3) || defined(BSDI4)
  setpassent(1);
#endif
  return cpw;
}

#endif /* USESHADOW */

static char *_get_ppw_info(pool *p, const char *u)
{
  struct passwd *pw;
  char *cpw = NULL;

  pw = p_getpwnam(u);
  if(pw)
    cpw = pstrdup(p,pw->pw_passwd);

  return cpw;
}

/* high-level auth handlers
 */

/* cmd->argv[0] : user name
 * cmd->argv[1] : cleartext password
 */

MODRET pw_auth(cmd_rec *cmd)
{
  time_t now;
  char *cpw;
  time_t lstchg = -1,max = -1,inact = -1,disable = -1;
  const char *name;

  name = cmd->argv[0];
  time(&now);

  if(persistent_passwd)
    cpw = _get_ppw_info(cmd->tmp_pool,name);
  else
    cpw = _get_pw_info(cmd->tmp_pool,name,&lstchg,NULL,&max,NULL,&inact,&disable);

  if(!cpw)
    return ERROR_INT(cmd,AUTH_NOPWD);

  if(auth_check(cmd->tmp_pool,cpw,cmd->argv[0],cmd->argv[1]))
    return ERROR_INT(cmd,AUTH_BADPWD);

  if(lstchg > (time_t)0 && max > (time_t)0 &&
     inact > (time_t)0)
    if(now > lstchg + max + inact)
      return ERROR_INT(cmd,AUTH_AGEPWD);

  if(disable > (time_t)0 && now > disable)
    return ERROR_INT(cmd,AUTH_DISABLEDPWD);

  return HANDLED(cmd);
}

/*
 * cmd->argv[0] = hashed password,
 * cmd->argv[1] = user,
 * cmd->argv[2] = cleartext
 */

MODRET pw_check(cmd_rec *cmd)
{
  static char *pw,*cpw;

  cpw = cmd->argv[0];
  pw = cmd->argv[2];

  if(strcmp(crypt(pw,cpw),cpw) != 0)
    return ERROR(cmd);

  return HANDLED(cmd);
}

MODRET pw_uid_name(cmd_rec *cmd)
{
  idmap_t *m;
  idauth_t id;
  struct passwd *pw;

  id.uid = (uid_t) cmd->argv[0];
  m = _auth_lookup_id(uid_table, id);

  if(!m->name) {
    /* wasn't cached, so perform a lookup */

    if(PERSISTENT_PASSWD)
      pw = p_getpwuid(id.uid);
    else
      pw = getpwuid(id.uid);

    if(pw) {
      m->name = pstrdup(permanent_pool, pw->pw_name);
    } else {
      char buf[10] = {'\0'};

      /* removed cast to unsigned long long here, as it presents a problem
       * passed to snprintf because there is no ansi standard for the format
       * string modifier used for long long (is it %llu or %Lu, etc?)
       * jss 2/21/01
       */
      snprintf(buf, sizeof(buf), "%lu", (ULONG)id.uid);
      m->name = pstrdup(permanent_pool, buf);
    }
  }
  
  return mod_create_data(cmd, m->name);
}

MODRET pw_gid_name(cmd_rec *cmd)
{
  idmap_t *m;
  idauth_t id;
  struct group *gr;

  id.gid = (gid_t) cmd->argv[0];

  m = _auth_lookup_id(gid_table, id);

  if(!m->name) {
    if(PERSISTENT_GROUP)
      gr = p_getgrgid(id.gid);
    else
      gr = getgrgid(id.gid);

    if(gr)
      m->name = pstrdup(permanent_pool, gr->gr_name);
    else {
      char buf[10] = {'\0'};
      
      /* removed cast to unsigned long long here, as it presents a problem
       * passed to snprintf because there is no ansi standard for the format
       * string modifier used for long long (is it %llu or %Lu, etc?)
       * jss 2/21/01
       */
      snprintf(buf, sizeof(buf), "%lu", (ULONG)id.gid);
      m->name = pstrdup(permanent_pool, buf);
    }
  }
  
  return mod_create_data(cmd, m->name);
}

MODRET pw_name_uid(cmd_rec *cmd)
{
  struct passwd *pw;
  const char *name;

  name = cmd->argv[0];
  
  if(PERSISTENT_PASSWD)
    pw = p_getpwnam(name);
  else
    pw = getpwnam(name);

  if(pw)
    return mod_create_data(cmd,(void*)pw->pw_uid);
  return ERROR(cmd);
}

MODRET pw_name_gid(cmd_rec *cmd)
{
  struct group *gr;

  const char *name;

  name = cmd->argv[0];
  
  if(PERSISTENT_GROUP)
    gr = p_getgrnam(name);
  else
    gr = getgrnam(name);

  if(gr)
    return mod_create_data(cmd,(void*)gr->gr_gid);
  return ERROR(cmd);
}

MODRET set_persistentpasswd(cmd_rec *cmd)
{
  int b;

  CHECK_ARGS(cmd,1);
  CHECK_CONF(cmd,CONF_ROOT);

  b = get_boolean(cmd,1);
  if(b != -1)
    persistent = b;
  else
    CONF_ERROR(cmd, "expected boolean argument.");

  return HANDLED(cmd);
}

MODRET set_authuserfile(cmd_rec *cmd)
{
  CHECK_ARGS(cmd,1);
  CHECK_CONF(cmd,CONF_ROOT|CONF_VIRTUAL|CONF_GLOBAL);

  if (*(cmd->argv[1]) != '/')
    CONF_ERROR(cmd, pstrcat(cmd->tmp_pool,
      "Unable to use relative path for ", cmd->argv[0], " '",
      cmd->argv[1], "'.", NULL));

  add_config_param_str("AuthUserFile",1,cmd->argv[1]);
  return HANDLED(cmd);
}

MODRET set_authgroupfile(cmd_rec *cmd)
{
  CHECK_ARGS(cmd,1);
  CHECK_CONF(cmd,CONF_ROOT|CONF_VIRTUAL|CONF_GLOBAL);

  if (*(cmd->argv[1]) != '/')
    CONF_ERROR(cmd, pstrcat(cmd->tmp_pool,
      "Unable to use relative path for ", cmd->argv[0], " '",
      cmd->argv[1], "'.", NULL));

  add_config_param_str("AuthGroupFile",1,cmd->argv[1]);
  return HANDLED(cmd);
}

static int unixpw_init()
{
  memset(uid_table,0,sizeof(uid_table));
  memset(gid_table,0,sizeof(gid_table));

#ifdef HAVE__PW_STAYOPEN
  _pw_stayopen = 1;
#endif

  return 0;
}

static int unixpw_child()
{
  const char *file;

  file = (const char*)get_param_ptr(main_server->conf,"AuthUserFile",FALSE);
  if(file) {
    endpwent(); 
    persistent_passwd = 1;		/* Force persistent mode */
    pwdfname = file;
    p_endpwent();
    p_setpwent();
  }

  file = (const char*)get_param_ptr(main_server->conf,"AuthGroupFile",FALSE);
  if(file) {
    endgrent();
    persistent_group = 1;
    grpfname = file;
    p_endgrent();
    p_setgrent();
  }
  
  return 0;
}

static conftable unixpw_config[] = {
  { "PersistentPasswd",		set_persistentpasswd,		NULL },
  { "AuthUserFile",		set_authuserfile,		NULL },
  { "AuthGroupFile",		set_authgroupfile,		NULL },
  { NULL,			NULL,				NULL }
};

static authtable unixpw_auth[] = {
  { 0,  "setpwent",	pw_setpwent	},
  { 0,  "endpwent",	pw_endpwent	},
  { 0,  "setgrent",     pw_setgrent	},
  { 0,  "endgrent",	pw_endgrent	},
  { 0,	"getpwent",	pw_getpwent	},
  { 0,  "getgrent",	pw_getgrent	},
  { 0,  "getpwnam",	pw_getpwnam	},
  { 0,	"getpwuid",	pw_getpwuid	},
  { 0,  "getgrnam",     pw_getgrnam     },
  { 0,  "getgrgid",     pw_getgrgid     },
  { 0,  "auth",         pw_auth		},
  { 0,  "check",	pw_check	},
  { 0,  "uid_name",	pw_uid_name	},
  { 0,  "gid_name",	pw_gid_name	},
  { 0,  "name_uid",	pw_name_uid	},
  { 0,  "name_gid",	pw_name_gid	},
  { 0,  NULL }
};

module unixpw_module = {
  NULL,NULL,			/* Always NULL */
  0x20,				/* API Version 2.0 */
  "unixpw",
  unixpw_config,		/* Configuration directive table */
  NULL,				/* No command handlers */
  unixpw_auth,			/* Authentication handlers */
  unixpw_init,unixpw_child	/* Initialization functions */
};
