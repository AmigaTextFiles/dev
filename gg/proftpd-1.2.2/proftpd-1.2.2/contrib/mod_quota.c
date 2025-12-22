/*
 * Quota module for ProFTPD
 *
 * $Id: mod_quota.c,v 1.7 2001/08/01 15:17:06 flood Exp $
 *
 * Copyright (C) 1999, 2000, 2001 Eric Estabrooks
 * Copyright (C) 1999, 2000 MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
 *
 * This module is free to redistribute and/or modify.  If you do modify it 
 * note the modifications before redistributing it.
 * 
 * This modules comes with no warranty either expressed or implied.  I am not
 * responsible for any damages that may result from the use of this module,
 * including but not limited to monetary loss, mental distress, or general
 * mayhem
 */

/* 
  This module provides very simple quota management.  It keeps track of uploads
  and deletions.  It works for Anonymous, Root, and Virtual sections.  It is
  really only for use with chrooted users as it references a file /.quota to
  store current quota information.  

  You'll need to add a PathDenyFilter "\.quota$" to your conf file to prevent users
  from altering their quota information. 


  Configuration Options:

  Quotas on             <- enables quotas
  DefaultQuota x        <- set the default quota to x number of bytes
                           if the /.quota file doesn't exist
  QuotaType soft/hard   <- soft is what it is currently, hard would remove the
                           file that violated the quota
  QuotaCalc on/off      <- on quotas are calculated on the fly if 1) no .quota
                           file exists or 2) the quota would go negative
  QuotaExempt uid,uid   <- list of users whose files don't count against a quota
                           the use of uids speeds up the whole process
  QuotaBlockSize x      <- size of each block in bytes (default 1)
  QuotaBlockName "byte" <- name of block type, used in user reporting (default bytes)
                        

  Future Options:
  
  QuotaTotalFiles x     <- set the total number of files a person is allowed
                           to store on the server
  UserQuota username x  <- set the quota for user username to x number of bytes
  GroupQuota group x    <- set the quota for a user based on group
  QuotaFile filename    <- set the name for the quota file to use instead of
                           /.quota

  Suggested Options to use in conjunction with this module:
  
  PathDenyFilter "\.quota$"
  HideNoAccess
  IgnoreHidden

  Thanks to Bruneton Beranger for the bug report/fix on the improper handling of
   spaces in filenames.
  
  Thanks to Daniel Sully for the bug report/fix on negative quota issues

  Thanks to Bruneton Beranger for the bug report/fix for quotas not properly handling
   renaming of files.

*/


#include "conf.h"
#include "privs.h"

#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

/* for locking quota file */
#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

static struct {
  int    quotas;                 /* are quotas on? */
  int    hard;                   /* hard or soft quotas */
  int    calc;                   /* auto calc quotas? */
  char*  block_name;             /* name of block (byte, kbyte, ...) */
  double block_size;             /* bytes / block_size = reported usage */
  double quota_bytes;            /* quota from quota file */
  double quota_start;            /* number of bytes at start of this operation */
  double current_bytes;          /* current number of bytes in use */
  double default_quota;          /* what to set the quota to if no quota file */
  double overwrite_bytes;        /* number of bytes in the file to be replaced */
  double last_delete_bytes;      /* number of bytes in last file deleted */
  int*   uid_list;               /* list of exempted uids */
} quota;


static int
quota_child_init() {
  memset((void *)&quota, 0, sizeof(quota));
  return 0;
}

static void
get_quota_params() {
  void* tmp_ptr;
  int   i; /* index for uid list */
  uid_t my_uid;
  
  quota.quotas = get_param_int(CURRENT_CONF, "Quotas", FALSE);
  if (quota.quotas == 1) {
    quota.calc = get_param_int(CURRENT_CONF, "QuotaCalc", FALSE);
    tmp_ptr = get_param_ptr(CURRENT_CONF, "DefaultQuota", FALSE);
    if (tmp_ptr != 0) {
      quota.default_quota = *((double *)(tmp_ptr));
    } else {
      quota.default_quota = 0;
    }
    tmp_ptr = get_param_ptr(CURRENT_CONF, "QuotaBlockSize", FALSE);
    if (tmp_ptr != 0) {
      quota.block_size = *((double *)(tmp_ptr));
    } else {
      quota.block_size = 1;
    }
    quota.default_quota *= quota.block_size; /* convert from blocks to bytes */
    tmp_ptr = get_param_ptr(CURRENT_CONF, "QuotaBlockName", FALSE);
    if (tmp_ptr != 0) {
      quota.block_name = (char *)tmp_ptr;
    } else {
      quota.block_name = "bytes";
    }
    quota.hard = get_param_int(CURRENT_CONF, "QuotaType", FALSE);
    quota.uid_list = (int *)get_param_ptr(CURRENT_CONF, "QuotaExempt", FALSE);
    if (quota.hard != 1) {
      quota.hard = 0;
    }
    my_uid = geteuid();

    if (quota.uid_list != 0) {
      for (i=1; i < quota.uid_list[0]; i++) {
        log_debug(DEBUG3, "checking uid [%d] =? [%d]", my_uid, quota.uid_list[i]);
        if (my_uid == quota.uid_list[i]) {
	  quota.quotas = 0;
	  break;
        }
      }
    }
  }
}

static int _join (char* buff, int buff_size, char* join_str, 
		  char* one, char* two) { /* make va_arg in future */
  int i,j;
  
  if ((join_str == (char *)0) || (one == (char *)0) ||
      (two == (char *)0)) {
    return -1;
  }
  for (i = 0; i < buff_size; i++) {
    if (one[i] != 0) {
      buff[i] = one[i];
    } else {
      break;
    }
  }
  if (i == buff_size) {
    buff[buff_size-1] = 0; /* for those who don't error check */
    return -1;
  }
  for (j=0; i < buff_size; i++, j++) {
    if (join_str[j] != 0) {
      buff[i] = join_str[j];
    } else {
      break;
    }
  }
  if (i == buff_size) {
    buff[buff_size-1] = 0; /* for those who don't error check */
    return -1;
  }
  for (j=0; i < buff_size; i++, j++) {
    if (two[j] != 0) {
      buff[i] = two[j];
    } else {
      break;
    }
  }
  if (i == buff_size) {
    buff[buff_size-1] = 0; /* for those who don't error check */
    return -1;
  } else {
    buff[i] = 0;
  }
  return i;
}

static double _calc_quota (int level, char* dir, double* t_size) {
  DIR*           dir_ptr;
  struct dirent* dir_entry_ptr;
  char           path[MAXPATHLEN+1] = {'\0'};
  struct stat    stat_buff;
  int            err;
  int            i;
  double         size = 0;

  log_debug(DEBUG5, "recursion level [%d]", level);
  if (level == 0) { /* too many levels of recursion */
    log_debug(DEBUG1,"too many recursion levels");
    return -1;
  }
  dir_ptr = opendir(dir);
  if (dir_ptr == (DIR*)0) {
    log_debug(DEBUG1,"Couldn't open directory %s",dir);
    return -1; /* error opening directory */
  }
  for (dir_entry_ptr = readdir(dir_ptr); dir_entry_ptr != 0;
       dir_entry_ptr = readdir(dir_ptr)) {
    if ((strcmp(".", dir_entry_ptr->d_name) == 0) ||
	(strcmp("..", dir_entry_ptr->d_name) == 0)) {
      continue;
    }
    err = _join(path, sizeof(path), "/", dir, dir_entry_ptr->d_name);
    if (err < 0) {
      /* skip this entry */
      log_debug(DEBUG2, "error joining [%s] and [%s]", dir, dir_entry_ptr->d_name);
    } else {
      log_debug(DEBUG5, "checking file [%s]: ", path);
      err = fs_lstat(path, &stat_buff);
      if(err < 0) {
	perror(path);
      } else {
	/* check for exemption */
	if (S_ISREG(stat_buff.st_mode)) {
	  if (quota.uid_list != 0) {
	    for (i = 1; i < quota.uid_list[0]; i++) {
	      if (stat_buff.st_uid == quota.uid_list[i]) {
		/* exempted */
		log_debug(DEBUG3, "Exempting %s, owned by %u", path, stat_buff.st_uid);
		break;
	      }
	    }
	    if (i >= quota.uid_list[0]) {
	      size += stat_buff.st_size;
	      log_debug(DEBUG3, "added %s [%u] totaling [%lf]", path,
			stat_buff.st_size, size);
	    }
	  } else {
	    size += stat_buff.st_size;
	    log_debug(DEBUG3, "added %s [%u] totaling [%lf]", path,
		      stat_buff.st_size, size);
	  }
	} else {
	  if (S_ISDIR(stat_buff.st_mode)) {
	    err = _calc_quota (level-1, path, t_size);
	    if (err < 0) {
	      closedir(dir_ptr);
	      return err;
	    }
	  }
	}
      }
      }
  }
  closedir(dir_ptr);
  *t_size += size;
  return 0;
}

static void /* should be able to generate errors */
_write_quota() {
  int          err;
  int          fd; /* file descriptor from open */
  FILE*        fp; /* file pointer from fdopen */
#ifdef HAVE_FCNTL_H
  struct flock quota_lock;
#endif

  
  PRIVS_ROOT
  /* open it, create if doesn't exist, mode rw owner */
  fd = open("/.quota", O_RDWR | O_CREAT, 0600);
  if (fd < 0) { /* file wasn't opened */
    log_debug(DEBUG3, "couldn't write quota file : %s", strerror(errno));
  } else {
#ifdef HAVE_FCNTL_H
    err = fcntl(fd, F_GETLK, &quota_lock);
    if (err < 0) {
      log_debug(DEBUG1, "couldn't get locking information on quota file : %s",
		strerror(errno));
    } else {
      quota_lock.l_type = F_WRLCK;
      /* F_SETLKW waits until lock is available, this could be 
	 a blocking without recovery situtation.  This probably
	 should be a loop using F_SETLK instead and exiting with
	 an error after so many iterations (Don't forget to release 
         root privileges if you leave the function here)
      */
      err = fcntl(fd, F_SETLKW, &quota_lock);
      if (err < 0) {
	log_debug(DEBUG1, "couldn't set write lock for quota file : %s",
		  strerror(errno));
      }
      /* at this point it locked or totally failed */
    }
#endif
    fp = fdopen(fd, "r+"); /* should make fileaname a directive */
    if (fp == (FILE *)0) {
      /* generate error here */
      log_debug(DEBUG3, "couldn't write quota file : %s", strerror(errno));
      close(fd);
    } else {
      rewind(fp);
      quota.quota_bytes = 0;
      quota.quota_start = 0;
      err = fscanf(fp, "%lf %lf", &quota.quota_bytes, &quota.quota_start);
      quota.quota_start += quota.current_bytes;
      if (quota.quota_bytes == 0) {
	quota.quota_bytes = quota.default_quota;
      }
      rewind(fp);
      fprintf(fp, "%lf %lf                                            \n", 
	      quota.quota_bytes, quota.quota_start);
    }
#ifdef HAVE_FCNTL_H
    quota_lock.l_type = F_UNLCK;
    err = fcntl(fd, F_SETLK, &quota_lock);
    /* this is not necessarily fatal as we may not have gotten the lock earlier */
    if (err < 0) {
      log_debug(DEBUG1, "couldn't unlock quota file : %s", strerror(errno));
    }
#endif
    fclose(fp);
  }
  PRIVS_RELINQUISH
  quota.current_bytes = 0;
  return;
}

static int /* should be able to generate errors */
_read_quota() {
  FILE*  fp;
  int    err;
  double calcd_quota = 0;
  
  PRIVS_ROOT
  fp = fopen("/.quota", "r"); /* should make this a directive */
  if (fp == (FILE *)0) {
    quota.quota_bytes = quota.default_quota;
    if (quota.calc != 1) {
      quota.current_bytes = 0;
    } else {
      err = _calc_quota(32,"/", &calcd_quota);
      if (err < 0) {
	PRIVS_RELINQUISH
	return err;
      } else {
	log_debug(DEBUG2, "calculated quota [%lf]", calcd_quota);
	quota.current_bytes = calcd_quota;
	_write_quota(); /* necessary to prevent recalculation with every operation */
      }
    }
    log_debug(DEBUG3, "no quota file %s", strerror(errno));
  } else {
    err = fscanf(fp, "%lf %lf", &quota.quota_bytes, &quota.quota_start);
    fclose(fp);
  }
  PRIVS_RELINQUISH
  quota.current_bytes = 0;
  return 0;
}

MODRET pre_cmd_stor(cmd_rec* cmd) {
  struct stat stat_buf;
  int         err;

  get_quota_params();
  if (quota.quotas != TRUE) {
    log_debug(DEBUG3, "quotas off");
    return DECLINED(cmd);
  }
  err = _read_quota();
  if (err < 0) {
    add_response_err(R_550, "%s: Error calculating quotas: check directory structure",
		     cmd->argv[0]);
    return ERROR(cmd);
  }
  log_debug(DEBUG3, "quotas on [%lf] of [%lf]", quota.quota_start, quota.quota_bytes);

  err = fs_lstat(cmd->arg, &stat_buf);
  if(err == -1) { /* file doesn't exist or other system problem */
    quota.overwrite_bytes = 0;
  } else {
    quota.overwrite_bytes = stat_buf.st_size;
  }
  if (quota.quota_start >= quota.quota_bytes) {
    add_response_err(R_550, "%s: Quota exceeded: using %lf of %lf bytes",
		     cmd->argv[0], quota.quota_start, quota.quota_bytes);
    return ERROR(cmd);
  }

  return DECLINED(cmd);
}

MODRET post_cmd_stor(cmd_rec* cmd) {
  struct stat stat_buf;
  int         err;

  CHECK_ARGS(cmd, 1);
  if (quota.quotas != TRUE) {
    return DECLINED(cmd);
  }
  
  err = fs_lstat(cmd->arg, &stat_buf);
  if(err == -1) {
    add_response_err(R_550, "%s: Couldn't get file status for %s",
		     cmd->argv[0], cmd->arg);
    return ERROR(cmd);
  }
  quota.current_bytes += (stat_buf.st_size - quota.overwrite_bytes);
  _write_quota();
  log_debug(DEBUG3, "Quota hard=[%d], quota=[%lf], start=[%lf], change=[%lf]",
	    quota.hard, quota.quota_bytes, quota.quota_start, quota.current_bytes);
  if ((quota.hard == 1) && ((quota.quota_start + quota.current_bytes) > quota.quota_bytes)) {
    err = fs_unlink(cmd->arg);
    log_debug(DEBUG3, "Quota exceeded, %s unlinked [%d]", cmd->arg, err);
    if (err == 0) {
      quota.current_bytes -= stat_buf.st_size;
      add_response(R_DUP, "Quota exceeded, %s not stored", cmd->arg);
    }
    _write_quota();
  }

  
  return DECLINED(cmd);
}

MODRET pre_cmd_dele(cmd_rec* cmd) {
  struct stat stat_buf;
  int         err;

  CHECK_ARGS(cmd, 1);
  get_quota_params();
  if (quota.quotas != TRUE) {
    log_debug(DEBUG3, "quotas off");
    return DECLINED(cmd);
  }

  err = _read_quota();
  if (err < 0) {
    add_response_err(R_550, "%s: Error calculating quotas: check directory structure",
		     cmd->argv[0]);
    return ERROR(cmd);
  }

  /* fs_lstat file(s) to delete to get size */
  err = fs_lstat(cmd->arg, &stat_buf);
  if (err == -1) {
    add_response_err(R_550, "%s: Couldn't get file status for %s",
		     cmd->argv[0], cmd->arg);
    return ERROR(cmd);
  }
  quota.last_delete_bytes = stat_buf.st_size;

  return DECLINED(cmd);
}

MODRET post_cmd_dele(cmd_rec* cmd) {
  int    err;
  double calcd_quota = 0;

  if (quota.quotas != TRUE) {
    return DECLINED(cmd);
  }
  if (quota.last_delete_bytes > quota.quota_start) {
    if (quota.calc != 1) {
      quota.quota_start = 0;
    } else {
      err = _calc_quota(32, "/", &calcd_quota);
      if (err < 0) {
	quota.quota_start = 0;
	log_pri(LOG_ERR, "Quota calculation failed, zeroing quota");
	add_response(R_DUP, "Quota calculation failed");
      } else {
	quota.quota_start = calcd_quota;
      }
    }
  } else {
    quota.current_bytes -= quota.last_delete_bytes;
  }
  _write_quota();

  return DECLINED(cmd);
}

MODRET pre_cmd_list(cmd_rec* cmd) {
  get_quota_params();
  if (quota.quotas == TRUE) {
    _read_quota();
  }

  return DECLINED(cmd);
}

MODRET post_cmd_list(cmd_rec* cmd) {
  if (quota.quotas == TRUE) {
    add_response(R_DUP, "Quotas on: using %.2lf of %.2lf %s",
		 quota.quota_start/quota.block_size, 
		 quota.quota_bytes/quota.block_size, quota.block_name);
  } else {
    add_response(R_DUP, "Quotas off");
  }

  return DECLINED(cmd);
}

/* rename code contributed by Bruneton Beranger */

MODRET pre_cmd_rnto(cmd_rec *cmd) {
  struct stat stat_buf;
  int         err;

  get_quota_params(); 
  if (quota.quotas != TRUE) { 
    log_debug(DEBUG3, "quotas off");
    return DECLINED(cmd);
  } 
  _read_quota();
  err = fs_lstat(cmd->arg, &stat_buf);
  if (err == -1) { /* file doesn't exist or other system problem */
    quota.overwrite_bytes = 0;
  } else {
    quota.overwrite_bytes = stat_buf.st_size;
  }
  return DECLINED(cmd);
}


MODRET post_cmd_rnto(cmd_rec *cmd) {
  struct stat stat_buf;
  int         err;
  
  CHECK_ARGS(cmd, 1);
  if (quota.quotas != TRUE) {
    return DECLINED(cmd);
  }
  err = fs_lstat(cmd->arg, &stat_buf);
  if (err == -1) {
    add_response(R_DUP, "%s: Couldn't get file status for %s",
		 cmd->argv[0], cmd->arg);
    return ERROR(cmd);
  }
  _read_quota();
  quota.current_bytes -= quota.overwrite_bytes;
  _write_quota();
  return DECLINED(cmd);
} 





/*
  configuration routines
*/

MODRET add_quota(cmd_rec* cmd) {
  int         value;
  config_rec* config_ptr;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
  
  value = get_boolean(cmd, 1);
  if (value == -1) {
    CONF_ERROR(cmd, "requires a boolean value");
  }
  log_debug(DEBUG3, "quota = %d", value);
  config_ptr = add_config_param("Quotas", 1, (void *)value);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_quota_calc(cmd_rec* cmd) {
  int         value;
  config_rec* config_ptr;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
  
  value = get_boolean(cmd, 1);
  if (value == -1) {
    CONF_ERROR(cmd, "requires a boolean value");
  }
  log_debug(DEBUG3, "quotacalc = %d", value);
  config_ptr = add_config_param("QuotaCalc", 1, (void *)value);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_default_quota(cmd_rec* cmd) {
  config_rec* config_ptr;
  double*     value = 0;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
  
  value = (double *)malloc(sizeof(double)*1);

  sscanf(cmd->argv[1], "%lf", value);
  if (value < 0) {
    CONF_ERROR(cmd, "default quota must be a positive number");
  }
  log_debug(DEBUG3, "default quota = %s", cmd->argv[1]);
  config_ptr = add_config_param("DefaultQuota", 1, (void *)value);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_quota_type(cmd_rec* cmd) {
  config_rec*  config_ptr;
  unsigned int value;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
 
  if ((strcasecmp(cmd->argv[1], "soft") != 0)  && 
      (strcasecmp(cmd->argv[1], "hard") != 0)) {
	CONF_ERROR(cmd, "QuotaType must be 'soft' or 'hard'");
  }
  if (strcmp(cmd->argv[1], "soft") == 0) {
    value = 0;
  } else {
    value = 1;
  }
  log_debug(DEBUG3, "QuotaType = %s", cmd->argv[1]);
  config_ptr = add_config_param("QuotaType", 1, (void *)value);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_quota_exempt(cmd_rec *cmd) {
  config_rec   *config_ptr;
  char*        s_ptr = 0;
  char         uid_buff[1024] = {'\0'};
  int*         tmp;
  int*         uid_list = 0;
  int          uid_count = 1;
  int          uid_max = 10;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
  
  memset((void *)uid_buff, 0, sizeof(uid_buff));
  strncpy(uid_buff,cmd->argv[1],sizeof(uid_buff)-1);
  uid_list = (int *)malloc(sizeof(int)*10);
  s_ptr = strtok(uid_buff, ", \t\n\r");
  while (s_ptr != 0) {
    uid_list[uid_count++] = atoi(s_ptr);
    if (uid_count == uid_max) {
      tmp = (int *)realloc(uid_list, sizeof(int)*(uid_max+10));
      if (tmp == 0) {
	free(uid_list);
	CONF_ERROR(cmd, "QuotaExempt couldn't realloc pointer (out of memory)");
      } else {
	uid_max += 10;
	uid_list = tmp;
      }
    }
    s_ptr = strtok(0, ", \t\n\r");
  }
  uid_list[0] = uid_count;
  log_debug(DEBUG3, "Exempting: [%d] %s", uid_count, cmd->argv[1]);
  config_ptr = add_config_param("QuotaExempt", 1, (void *)uid_list);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_block_size(cmd_rec* cmd) {
  config_rec* config_ptr;
  double*     value = 0;

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
  
  value = (double *)malloc(sizeof(double)*1);

  sscanf(cmd->argv[1], "%lf", value);
  if (value < 0) {
    CONF_ERROR(cmd, "default quota must be a positive number");
  }
  log_debug(DEBUG3, "QuotaBlockSize = %s", cmd->argv[1]);
  config_ptr = add_config_param("QuotaBlockSize", 1, (void *)value);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

MODRET add_block_name(cmd_rec* cmd) {
  config_rec* config_ptr;
  char*       str_ptr; 

  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT|CONF_ANON|CONF_VIRTUAL);
 
  str_ptr = (char *)malloc(strlen(cmd->argv[1])+1);
  strcpy(str_ptr, cmd->argv[1]);
  log_debug(DEBUG3, "QuotaBlockName = %s", cmd->argv[1]);
  config_ptr = add_config_param("QuotaBlockName", 1, (void *)str_ptr);
  config_ptr->flags |= CF_MERGEDOWN;

  return HANDLED(cmd);
}

static conftable quota_conftable[] = {
  { "Quotas",       add_quota,         NULL },  /* turn quotas on and off */
  { "QuotaType",    add_quota_type,    NULL },  /* set quota type to soft/hard */
  { "DefaultQuota", add_default_quota, NULL },  /* quota if quota file doesn't exist */
  { "QuotaCalc",    add_quota_calc,    NULL },  /* calc quota initial and on neg */
  { "QuotaExempt",  add_quota_exempt,  NULL },  /* whom to exempt */
  { "QuotaBlockSize", add_block_size,  NULL },  /* block instead of byte */
  { "QuotaBlockName", add_block_name,  NULL },  /* name/type of block */
  { NULL }
};

static cmdtable quota_commands[] = {
  { PRE_CMD,  C_STOR, G_NONE, pre_cmd_stor,  TRUE, FALSE },
  { PRE_CMD,  C_DELE, G_NONE, pre_cmd_dele,  TRUE, FALSE },
  { PRE_CMD,  C_NLST, G_NONE, pre_cmd_list,  TRUE, FALSE },
  { PRE_CMD,  C_LIST, G_NONE, pre_cmd_list,  TRUE, FALSE },
  { POST_CMD, C_STOR, G_NONE, post_cmd_stor, TRUE, FALSE },
  { POST_CMD, C_DELE, G_NONE, post_cmd_dele, TRUE, FALSE },
  { POST_CMD, C_NLST, G_NONE, post_cmd_list, TRUE, FALSE },
  { POST_CMD, C_LIST, G_NONE, post_cmd_list, TRUE, FALSE },
  { PRE_CMD,  C_RNTO, G_NONE, pre_cmd_rnto,  TRUE, FALSE },
  { POST_CMD, C_RNTO, G_NONE, post_cmd_rnto, TRUE, FALSE }, 
  { 0,        NULL }
};

module quota_module = {
  NULL,NULL,                    /* Always NULL */
  0x20,                         /* API Version 2.0 */
  "quota",
  quota_conftable,              /* quota configuration handler table */
  quota_commands,               /* quota command handler table */
  NULL,                         /* No authentication handler table */
  NULL,                         /* Initialization function */
  quota_child_init              /* Post-fork "child mode" init */
};
