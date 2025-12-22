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

/* ProFTPD virtual/modular filesystem support.
 * $Id: fs.h,v 1.4 2001/06/18 17:12:45 flood Exp $
 */

#ifndef _VIRTUAL_FS_H
#define _VIRTUAL_FS_H

/* Operation codes */
#define FSOP_STAT		(1 << 0)
#define FSOP_LSTAT		(1 << 1)
#define FSOP_RENAME		(1 << 2)
#define FSOP_UNLINK		(1 << 3)
#define FSOP_OPEN		(1 << 4)
#define FSOP_CREAT		(1 << 5)
#define FSOP_CLOSE		(1 << 6)
#define FSOP_READ		(1 << 7)
#define FSOP_WRITE		(1 << 8)
#define FSOP_LINK		(1 << 9)
#define FSOP_SYMLINK		(1 << 10)
#define FSOP_READLINK		(1 << 11)
#define FSOP_CHMOD		(1 << 12)
#define FSOP_CHOWN		(1 << 13)
#define FSOP_CHDIR		(1 << 14)
#define FSOP_OPENDIR		(1 << 15)
#define FSOP_CLOSEDIR		(1 << 16)
#define FSOP_READDIR		(1 << 17)

#define FSOP_FILEMASK		(FSOP_OPEN|FSOP_READ|FSOP_WRITE|FSOP_CLOSE|\
				FSOP_CREAT)

typedef struct fs_dir_handler fsdir_t;
typedef struct fs_dir_match fsmatch_t;

struct fs_dir_match {
  fsmatch_t *next;

  char *name;
  int opmask;

  int (*dir_hit)(fsdir_t*,const char*,int);
  int (*file_hit)(fsdir_t*,const char*,int);
};

struct fs_dir_handler {
  fsdir_t *next;

  char *name;
  fsdir_t *parent;			/* parent handlers */
  void *private;

  /* actual handler functions */
  int (*stat)(fsdir_t*,const char*,struct stat*);
  int (*lstat)(fsdir_t*,const char*,struct stat*);
  int (*rename)(fsdir_t*,const char*,const char*);
  int (*unlink)(fsdir_t*,const char*);
  int (*open)(fsdir_t*,const char*,int);
  int (*creat)(fsdir_t*,const char*,mode_t);
  int (*close)(fsdir_t*,int);
  int (*read)(fsdir_t*,int,char*,size_t);
  int (*write)(fsdir_t*,int,const char*,size_t);
  off_t (*lseek)(fsdir_t*,int,off_t,int);
  int (*link)(fsdir_t*,const char*,const char*);
  int (*symlink)(fsdir_t*,const char*,const char*);
  int (*readlink)(fsdir_t*,const char*,char*,size_t);
  int (*chmod)(fsdir_t*,const char*,mode_t);
  int (*chown)(fsdir_t*,const char*,uid_t,gid_t);

  /* for actual operations on the directory (or subdirs)
   * we cast the return from opendir to DIR* in src/fs.c, so
   * modules can use their own data type
   */

  int (*chdir)(fsdir_t*,const char*);
  void *(*opendir)(fsdir_t*,const char*);
  int (*closedir)(fsdir_t*,void*);
  struct dirent *(*readdir)(fsdir_t*,void*);
};

/* prototypes */
fsmatch_t *fs_register_match(char*,int);
fsdir_t *fs_register(char*);
void fs_unregister(fsdir_t*);
fsdir_t *fs_lookup_dir(const char *,int);
fsdir_t *fs_lookup_file(const char *,char **,int);
fsdir_t *fs_lookup_file_canon(const char *,char**,int);
void fs_setcwd(const char *);
const char *fs_getcwd();
const char *fs_getvwd();
void fs_dircat(char *,int,const char *, const char *);
int fs_interpolate(const char *,char *,int);
int fs_resolve_partial(const char *,char *,int,int);
int fs_resolve_path(const char *,char *,int,int);
void fs_virtual_path(const char *,char *,int);
void fs_clean_path(const char *,char *,int);
int fs_stat(const char *,struct stat *);
int fs_stat_canon(const char *,struct stat *);
int fs_lstat(const char *,struct stat *);
int fs_lstat_canon(const char *,struct stat *);
int fs_readlink(const char *, char *, int);
int fs_readlink_canon(const char *,char *,int);
int fs_chdir(const char *,int);
int fs_chdir_canon(const char *, int);
void *fs_opendir(const char *);
int fs_closedir(void*);
struct dirent *fs_readdir(void*);
int fs_glob(const char*,int,int (*errfunc)(const char *,int),glob_t*);
void fs_globfree(glob_t*);
int fs_rename(const char*,const char*);
int fs_rename_canon(const char*,const char*);
int fs_unlink(const char*);
int fs_unlink_canon(const char*);
fsdir_t *fs_open(const char*,int,int*);
fsdir_t *fs_open_canon(const char*,int,int*);
fsdir_t *fs_creat(const char*,mode_t,int*);
fsdir_t *fs_creat_canon(const char*,mode_t,int*);
int fs_close(fsdir_t*,int);
int fs_read(fsdir_t*,int,char*,size_t);
int fs_write(fsdir_t*,int,const char*,size_t);
int fs_link(const char*,const char*);
int fs_link_canon(const char*,const char*);
int fs_symlink(const char*,const char*);
int fs_symlink_canon(const char*,const char*);
int fs_chmod(const char*,mode_t);
int fs_chmod_canon(const char*,mode_t);
int fs_chown(const char*,uid_t,gid_t);
int fs_chown_canon(const char*,uid_t,gid_t);
off_t fs_lseek(fsdir_t *, int fd, off_t, int whence);
char *fs_gets(char *, size_t, fsdir_t*, int);
int init_fs();

#endif /* _VIRTUAL_FS_H */
