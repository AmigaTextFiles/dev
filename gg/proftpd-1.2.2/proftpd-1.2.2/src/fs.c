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

/* ProFTPD virtual/modular file-system support
 * $Id: fs.c,v 1.15 2001/06/18 17:35:06 flood Exp $
 */

#include "conf.h"

typedef struct opendir_struct opendir_t;

struct opendir_struct {
  opendir_t *next,*prev;

  DIR *dir;
  fsdir_t *fsdir;
};

static fsdir_t *fs = NULL;
static fsmatch_t *fs_match = NULL;
static fsdir_t *fs_cwd = NULL,*fs_std = NULL;

static xaset_t *opendir_list;
static void *fs_cache_dir = NULL;
static fsdir_t *fs_cache_fsdir = NULL;

/* virtual working directory */
static char vwd[MAXPATHLEN + 1] = "/";
static char cwd[MAXPATHLEN + 1] = "/";

/* the following static functions are simply wrappers for libc
 * (the fs_std)
 */

static int std_stat(fsdir_t *f, const char *path, struct stat *sbuf)
{ return stat(path,sbuf); }
static int std_lstat(fsdir_t *f, const char *path, struct stat *sbuf)
{ return lstat(path,sbuf); }
static int std_rename(fsdir_t *f, const char *ren_from, const char *ren_to)
{ return rename(ren_from,ren_to); }
static int std_unlink(fsdir_t *f, const char *path)
{ return unlink(path); }
static int std_open(fsdir_t *f, const char *path, int access)
{ return open(path,access,0666); }
static int std_creat(fsdir_t *f,const char *path, mode_t mode)
{ return creat(path,mode); }
static int std_close(fsdir_t *f, int fd)
{ return close(fd); }
static int std_read(fsdir_t *f, int fd, char *buf, size_t size)
{ return read(fd,buf,size); }
static int std_write(fsdir_t *f, int fd, const char *buf, size_t size)
{ return write(fd,buf,size); }
static off_t std_lseek(fsdir_t *f, int fd, off_t offset, int whence)
{ return lseek(fd,offset,whence); }
static int std_link(fsdir_t *f, const char *path1, const char *path2)
{ return link(path1,path2); }
static int std_symlink(fsdir_t *f, const char *path1, const char *path2)
{ return symlink(path1,path2); }
static int std_readlink(fsdir_t *f, const char *path, char *buf, size_t max)
{ return readlink(path,buf,max); }
static int std_chmod(fsdir_t *f, const char *path, mode_t mode)
{ return chmod(path,mode); }
static int std_chown(fsdir_t *f, const char *path, uid_t uid, gid_t gid)
{ return chown(path,uid,gid); }
static int std_chdir(fsdir_t *f, const char *path)
{ return chdir(path); }
static void *std_opendir(fsdir_t *f, const char *path)
{ return opendir(path); }
static int std_closedir(fsdir_t *f, void *dir)
{ return closedir((DIR*)dir); }
static struct dirent *std_readdir(fsdir_t *f, void *dir)
{ return readdir((DIR*)dir); }

fsmatch_t *fs_register_match(char *name, int opmask)
{
  fsmatch_t *newfs;

  if(!name)
    return NULL;

  newfs = calloc(1,sizeof(fsmatch_t));

  if(!newfs)
    return NULL;

  newfs->name = strdup(name);
  newfs->opmask = opmask;

  newfs->next = fs_match;
  fs_match = newfs;

  return newfs;
}

fsdir_t *fs_register(char *name)
{
  fsdir_t *parent = NULL,*f,*newfs;
  int best = 0,i;

  newfs = calloc(1,sizeof(fsdir_t));

  if(!newfs)
    return NULL;

  if(name)
    newfs->name = strdup(name);

  newfs->stat = std_stat;
  newfs->lstat = std_lstat;
  newfs->rename = std_rename;
  newfs->unlink = std_unlink;
  newfs->open = std_open;
  newfs->creat = std_creat;
  newfs->close = std_close;
  newfs->read = std_read;
  newfs->write = std_write;
  newfs->lseek = std_lseek;
  newfs->link = std_link;
  newfs->symlink = std_symlink;
  newfs->chmod = std_chmod;
  newfs->chown = std_chown;
  newfs->chdir = std_chdir;
  newfs->readlink = std_readlink;

  newfs->opendir = std_opendir;
  newfs->closedir = std_closedir;
  newfs->readdir = std_readdir;

  /* find proper parent */
  if(newfs->name) {
    for(f = fs; f; f=f->next) {
      if(f->name) {
        i = strlen(f->name);
        if(!strncmp(f->name,newfs->name,i) && i > best) {
          best = i; 
          parent = f;
        }
      }
    }

    if(parent)
      newfs->parent = parent;
    else
      newfs->parent = fs_std;
  }

  newfs->next = fs;
  fs = newfs;
  return newfs;
}

void fs_unregister(fsdir_t *fsd)
{
  /* not yet done */
}

static fsdir_t *_scan_fsdir(const char *path)
{
  fsdir_t *f,*found = NULL;
  register int i,best = 0;

  for(f = fs; f; f=f->next) {
    if(f->name) {
      i = strlen(f->name);
      if(!strncmp(f->name,path,i) && i > best) {
        best = i;
        found = f;
      }
    }
  }

  return found;
}

static fsmatch_t *_scan_fsmatch(const char *path, int op)
{
  fsmatch_t *fm;

  for(fm = fs_match; fm; fm=fm->next) {
    if((fm->opmask & op) && pr_fnmatch(fm->name, path, 0) == 0)
      return fm;
  }

  return NULL;
}

/* fs_lookup_dir() is called when we want to perform some sort of
 * directory operation on a directory or file.  A "closest" match
 * algorithm is used.  If the lookup fails or is not "close enough"
 * (i.e. the final target does not exactly match an existing fsdir_t,
 * we can for matchable targets and call dir_hit, then rescan
 * the fsdir_t list.  The rescan is performed in case any modules
 * registered fs handlers during the hit.
 */

fsdir_t *fs_lookup_dir(const char *path,int op)
{
  char buf[MAXPATHLEN + 1] = {'\0'};
  char tmpbuf[MAXPATHLEN + 1] = {'\0'};
  fsdir_t *f;
  fsmatch_t *fm = NULL;
  int exact = 0;

  sstrncpy(buf, path, sizeof(buf));

  if(buf[0] != '/')
    fs_dircat(tmpbuf,sizeof(tmpbuf),cwd,buf);
  else
    sstrncpy(tmpbuf,buf,sizeof(tmpbuf));
  
  f = _scan_fsdir(tmpbuf);

  /* we found a match, now see if it's close enough */
  if(f) {
    if(!strcmp(tmpbuf,f->name))
      exact = 1;
  }

  if(!f || !exact) {
    /* look for a fsmatch */
    fm = _scan_fsmatch(tmpbuf,op);

    if(op & FSOP_FILEMASK) {
      if(fm && fm->file_hit((f ? f : fs_std),tmpbuf,op) > 0)
        /* now rescan */
        f = _scan_fsdir(tmpbuf);
    } else {
      if(fm && fm->dir_hit((f ? f : fs_std),tmpbuf,op) > 0)
        f = _scan_fsdir(tmpbuf);
    }
  }

  return (f ? f : fs_std);
}

/* fs_lookup_file() performs the same function as fs_lookup_dir, however
 * because we are performing a file lookup, the target is the subdirectory
 * _containing_ the actual target.  A basic optimization is used here,
 * if the path contains no '/' characters, fs_cwd is returned.
 */

fsdir_t *fs_lookup_file(const char *path, char **deref, int op)
{
  if(!strchr(path,'/')) {
    fsmatch_t *fm;

    fm = _scan_fsmatch(path,op);
    if(!fm || fm->file_hit(fs_cwd,path,op) <= 0) {
      struct stat sbuf;

      if(fs_cwd->lstat(fs_cwd,path,&sbuf) == -1 || !S_ISLNK(sbuf.st_mode))
        return fs_cwd;
    } else {
      char linkbuf[MAXPATHLEN + 1];
      int i;

      if((i = fs_cwd->readlink(fs_cwd,path, &linkbuf[2],
			       MAXPATHLEN - 3)) != -1) {
        linkbuf[i] = '\0';
        if(!strchr(linkbuf, '/')) {
          if(i + 3 > MAXPATHLEN)
            i = MAXPATHLEN - 3;

          memmove(&linkbuf[2], linkbuf, i + 1);
	  
          linkbuf[i+2] = '\0';
          linkbuf[0] = '.';
          linkbuf[1] = '/';
          return fs_lookup_file_canon(linkbuf,deref,op);
        }
      }
      
      return fs_cwd;
    }
  }

#if 0
  target = rindex(workpath,'/');
  if(target == workpath) {
    if(*(target+1))
      *target = '\0';
  } else if(target)
    *target = '\0';
#endif

  return fs_lookup_dir(path,op);
}

fsdir_t *fs_lookup_file_canon(const char *path, char **deref, int op)
{
  static char workpath[MAXPATHLEN + 1];

  memset(workpath,'\0',sizeof(workpath));
  if(fs_resolve_partial(path, workpath, MAXPATHLEN, FSOP_OPEN) == -1) {
    if(*path == '/' || *path == '~') {
      if(fs_interpolate(path, workpath, MAXPATHLEN) != 1)
        sstrncpy(workpath, path, sizeof(workpath));
    } else
      fs_dircat(workpath, sizeof(workpath), cwd, path);
  }
  
  if(deref)
    *deref = workpath;

  return fs_lookup_file(workpath, deref, op);
}

void fs_setcwd(const char *dir)
{
  fs_resolve_path(dir, cwd, MAXPATHLEN, FSOP_CHDIR);
  sstrncpy(vwd, dir, sizeof(vwd));
  fs_cwd = fs_lookup_dir(cwd, FSOP_CHDIR);
  cwd[sizeof(cwd) - 1] = '\0';
}

const char *fs_getcwd()
{ return cwd; }

const char *fs_getvwd()
{ return vwd; }

void fs_dircat(char *buf, int len, const char *dir1, const char *dir2)
{
  /* make temporary copies so that memory areas can overlap */
  char *_dir1, *_dir2;
  int i;

  /* This is an experimental test to see if we've got reasonable
   * directories to concatenate.  If we don't, then we default to
   * the root directory.
   */
  if((strlen(dir1) + strlen(dir2) + 1) > MAXPATHLEN) {
    sstrncpy(buf, "/", len);
    return;
  }
  
  _dir1 = strdup(dir1);
  _dir2 = strdup(dir2);
  
  i = strlen(_dir1) - 1;
  
  if(*_dir2 == '/') {
    sstrncpy(buf, _dir2, len);
    free(_dir1);
    free(_dir2);
    return;
  }
  
  sstrncpy(buf, _dir1, len);
  if(i && *(_dir1 + i) != '/')
    sstrcat(buf, "/", MAXPATHLEN);

  sstrcat(buf, _dir2, MAXPATHLEN);
  
  if(!*buf) {
   *buf++ = '/';
   *buf = '\0';
  }
  
  free(_dir1);
  free(_dir2);
}

/* This function performs any tilde expansion needed and then returns the
 * resolved path, if any.
 *
 * Returns: -1 (errno = ENOENT) : User does not exist
 *          0 : No interpolation done (path exists)
 *          1 : Interpolation done
 */
int fs_interpolate(const char *path, char *buf, int maxlen) {
  pool *p;
  struct passwd *pw;
  struct stat sbuf;
  char *fname;
  char user[MAXPATHLEN + 1] = {'\0'};
  int len;
  
  if(!path)
    return -1;
  
  if(path[0] == '~') {
    fname = index(path, '/');
    
    /* Copy over the username.
     */
    if(fname) {
      len = fname - path;
      sstrncpy(user, path + 1, len > sizeof(user) ? sizeof(user) : len);
      
      /* Advance past the '/'.
       */
      fname++;
    } else if(fs_stat(path, &sbuf) == -1) {
      /* Otherwise, this might be something like "~foo" which could be a file
       * or it could be a user.  Lets find out...
       */
      
      /* Must be a user, if anything...otherwise it's probably a typo.
       */
      len = strlen(path);
      sstrncpy(user, path + 1, len > sizeof(user) ? sizeof(user) : len);
    } else {
      /* Otherwise, this *IS* the file in question, perform no interpolation.
       */
      return 0;
    }
    
    /* If the user hasn't been explicitly specified, set it here.  This
     * handles cases such as files beginning with "~", "~/foo" or simply "~".
     */
    if(!*user)
      sstrncpy(user, session.user, sizeof(user));
    
    p = make_sub_pool(permanent_pool);
    pw = auth_getpwnam(p,user);
    destroy_pool(p);
    
    if(!pw) {
      errno = ENOENT;
      return -1;
    }
    
    sstrncpy(buf, pw->pw_dir, maxlen);
    len = strlen(buf);
    
    if(fname && len < maxlen && buf[len - 1] != '/')
      buf[len++] = '/';
    
    if(fname)
      sstrncpy(&buf[len], fname, maxlen - len);
  } else {
    sstrncpy(buf, path, maxlen);
  }
  
  return 1;
}

int fs_resolve_partial(const char *path, char *buf, int maxlen, int op)
{
  char curpath[MAXPATHLEN + 1]  = {'\0'},
       workpath[MAXPATHLEN + 1] = {'\0'},
       namebuf[MAXPATHLEN + 1]  = {'\0'},
       linkpath[MAXPATHLEN + 1] = {'\0'},
       *where,*ptr,*last;

  fsdir_t *f;
  int len,fini = 1,link_cnt = 0;
  ino_t last_inode = 0;
  struct stat sbuf;

  if(!path)
    return -1;

  if(*path != '/') {
    if(*path == '~') {
      switch(fs_interpolate(path,curpath,sizeof(curpath))) {
      case -1: 
        return -1;
      case 0:
        sstrncpy(curpath, path, sizeof(curpath));
        sstrncpy(workpath, cwd, sizeof(workpath));
        break;
      }
    } else {
      sstrncpy(curpath, path, sizeof(curpath));
      sstrncpy(workpath, cwd, sizeof(workpath));
    }
  } else {
    sstrncpy(curpath, path, sizeof(curpath));
  }

  while(fini--) {
    where = curpath;
    while(*where != '\0') {
      if(!strcmp(where, ".")) {
        where++;
        continue;
      }
      
      /* handle ".." */
      if(!strcmp(where,"..")) {
        where += 2;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }

        *last = '\0';
        continue;
      }
      
      /* handle "./" */
      if(!strncmp(where, "./", 2)) {
        where += 2;
        continue;
      }
      
      /* handle "../" */
      if(!strncmp(where, "../", 3)) {
        where += 3;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }

        *last = '\0';
        continue;
      }
      
      ptr = strchr(where, '/');
      if(!ptr)
        ptr = where + strlen(where) - 1;
      else
        *ptr = '\0';

      sstrncpy(namebuf, workpath, sizeof(namebuf));
      if(*namebuf) {
        for(last = namebuf; *last; last++) ;
        if(*--last != '/')
          sstrcat(namebuf, "/", MAXPATHLEN);
      } else
        sstrcat(namebuf, "/", MAXPATHLEN);
      
      sstrcat(namebuf, where, MAXPATHLEN);
      
      where = ++ptr;

      f = fs_lookup_dir(namebuf,op);
      
      if(f->lstat(f, namebuf, &sbuf) == -1) {
        errno = ENOENT;
        return -1;
      }
      
      if(S_ISLNK(sbuf.st_mode)) {
        /* Detect an obvious recursive symlink */
        if(sbuf.st_ino && (ino_t)sbuf.st_ino == last_inode) {
          errno = ENOENT;
          return -1;
        }

        last_inode = (ino_t)sbuf.st_ino;
        if(++link_cnt > 32) {
          errno = ELOOP;
          return -1;
        }
	
        if((len = f->readlink(f,namebuf,linkpath,MAXPATHLEN)) <= 0) {
          errno = ENOENT;
          return -1;
        }

        *(linkpath+len) = '\0';
        if(*linkpath == '/')
          *workpath = '\0';
        if(*linkpath == '~') {
          char tmpbuf[MAXPATHLEN + 1] = {'\0'};

          *workpath = '\0';
          sstrncpy(tmpbuf, linkpath, sizeof(tmpbuf));
          if(fs_interpolate(tmpbuf,linkpath,sizeof(linkpath)) == -1)
	    return -1;
        }
        if(*where) {
          sstrcat(linkpath,"/",MAXPATHLEN);
          sstrcat(linkpath,where,MAXPATHLEN);
        }
        sstrncpy(curpath, linkpath, sizeof(curpath));
        fini++;
        break; /* continue main loop */
      }

      if(S_ISDIR(sbuf.st_mode)) {
        sstrncpy(workpath, namebuf, sizeof(workpath));
        continue;
      }

      if(*where) {
        errno = ENOENT;
        return -1;               /* path/notadir/morepath */
      } else {
        sstrncpy(workpath, namebuf, sizeof(workpath));
      }
    }
  }

  if(!workpath[0])
    sstrncpy(workpath, "/", sizeof(workpath));

  sstrncpy(buf, workpath, maxlen);
  return 0;
}
  
int fs_resolve_path(const char *path, char *buf, int maxlen, int op)
{
  char curpath[MAXPATHLEN + 1]  = {'\0'},
       workpath[MAXPATHLEN + 1] = {'\0'},
       namebuf[MAXPATHLEN + 1]  = {'\0'},
       linkpath[MAXPATHLEN + 1] = {'\0'},
       *where,*ptr,*last;

  fsdir_t *f;

  int len,fini = 1,link_cnt = 0;
  ino_t last_inode = 0;
  struct stat sbuf;

  if(!path)
    return -1;

  if(fs_interpolate(path, curpath, MAXPATHLEN) != 1)
    sstrncpy(curpath, path, sizeof(curpath));


  if(curpath[0] != '/')
    sstrncpy(workpath, cwd, sizeof(workpath));
  else
    workpath[0] = '\0';

  while(fini--) {
    where = curpath;
    while(*where != '\0') {
      if(!strcmp(where,".")) {
        where++;
        continue;
      }

      /* handle "./" */
      if(!strncmp(where,"./",2)) {
        where+=2;
        continue;
      }

      /* handle "../" */
      if(!strncmp(where,"../",3)) {
        where+=3;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }

        *last = '\0';
        continue;
      }

      ptr = strchr(where,'/');
      if(!ptr)
        ptr = where + strlen(where) - 1;
      else
        *ptr = '\0';

      sstrncpy(namebuf, workpath, sizeof(namebuf));

      if(*namebuf) {
        for(last = namebuf; *last; last++) ;
        if(*--last != '/')
          sstrcat(namebuf,"/",MAXPATHLEN);
      } else
        sstrcat(namebuf,"/",MAXPATHLEN);

      sstrcat(namebuf,where,MAXPATHLEN);

      where = ++ptr;

      f = fs_lookup_dir(namebuf,op);

      if(f->lstat(f,namebuf,&sbuf) == -1) {
        errno = ENOENT;
        return -1;
      }
    
      if(S_ISLNK(sbuf.st_mode)) {
        /* Detect an obvious recursive symlink */
        if(sbuf.st_ino && (ino_t)sbuf.st_ino == last_inode) {
          errno = ENOENT;
          return -1;
        }

        last_inode = (ino_t)sbuf.st_ino;
        if(++link_cnt > 32) {
          errno = ELOOP;
          return -1;
        }

        if((len = f->readlink(f,namebuf,linkpath,MAXPATHLEN)) <= 0) {
          errno = ENOENT;
          return -1;
        }

        *(linkpath+len) = '\0';
        if(*linkpath == '/')
          *workpath = '\0';
        if(*linkpath == '~') {
          char tmpbuf[MAXPATHLEN + 1] = {'\0'};

          *workpath = '\0';
          sstrncpy(tmpbuf, linkpath, sizeof(tmpbuf));
          if(fs_interpolate(tmpbuf, linkpath, sizeof(linkpath)) == -1)
	    return -1;
        }
        if(*where) {
          sstrcat(linkpath,"/",MAXPATHLEN);
          sstrcat(linkpath,where,MAXPATHLEN);
        }
        sstrncpy(curpath, linkpath, sizeof(curpath));
        fini++;
        break; /* continue main loop */
      }

      if(S_ISDIR(sbuf.st_mode)) {
        sstrncpy(workpath, namebuf, sizeof(workpath));
        continue;
      }

      if(*where) {
        errno = ENOENT;
        return -1;               /* path/notadir/morepath */
      } else
        sstrncpy(workpath, namebuf, sizeof(workpath));
    }
  }

  if(!workpath[0])
    sstrncpy(workpath, "/", sizeof(workpath));

  sstrncpy(buf, workpath, maxlen);
  return 0;
}

void fs_clean_path(const char *path, char *buf, int maxlen)
{
  char workpath[MAXPATHLEN + 1] = {'\0'};
  char curpath[MAXPATHLEN + 1]  = {'\0'};
  char namebuf[MAXPATHLEN + 1]  = {'\0'};
  char *where,*ptr,*last;
  int fini = 1;

  if(!path)
    return;

  sstrncpy(curpath, path, sizeof(curpath));
  
  /* main loop */
  while(fini--) {
    where = curpath;
    while(*where != '\0') {
      if(!strcmp(where,".")) {
        where++;
        continue;
      }

      /* handle "./" */
      if(!strncmp(where,"./",2)) {
        where += 2;
        continue;
      }

      /* handle ".." */
      if(!strcmp(where,"..")) {
        where+=2;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }

        *last = '\0';
        continue;
      }

      /* handle "../" */
      if(!strncmp(where,"../",3)) {
        where += 3;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }
        *last = '\0';
        continue;
      }
      ptr = strchr(where,'/');
      if(!ptr)
        ptr = where + strlen(where) - 1;
      else
        *ptr = '\0';

      sstrncpy(namebuf, workpath, sizeof(namebuf));
      
      if(*namebuf) {
        for(last = namebuf; *last; last++) ;
        if(*--last != '/')
          sstrcat(namebuf,"/",MAXPATHLEN);
      } else
        sstrcat(namebuf,"/",MAXPATHLEN);

      sstrcat(namebuf,where,MAXPATHLEN);
      namebuf[MAXPATHLEN-1] = '\0';
      
      where = ++ptr;

      sstrncpy(workpath, namebuf, sizeof(workpath));
    }
  }

  if(!workpath[0])
    sstrncpy(workpath, "/", sizeof(workpath));

  sstrncpy(buf, workpath, maxlen);  
}

void fs_virtual_path(const char *path, char *buf, int maxlen)
{
  char curpath[MAXPATHLEN + 1]  = {'\0'},
       workpath[MAXPATHLEN + 1] = {'\0'},
       namebuf[MAXPATHLEN + 1]  = {'\0'},
       *where,*ptr,*last;

  int fini = 1;

  if(!path)
    return;

  if(fs_interpolate(path,curpath,MAXPATHLEN) != 1)
    sstrncpy(curpath, path, sizeof(curpath));

  if(curpath[0] != '/')
    sstrncpy(workpath, vwd, sizeof(workpath));
  else
    workpath[0] = '\0';

  /* curpath is path resolving */
  /* linkpath is path a symlink pointed to */
  /* workpath is the path we've resolved */

  /* main loop */
  while(fini--) {
    where = curpath;
    while(*where != '\0') {
      if(!strcmp(where,".")) {
        where++;
        continue;
      }

      /* handle "./" */
      if(!strncmp(where,"./",2)) {
        where += 2;
        continue;
      }

      /* handle ".." */
      if(!strcmp(where,"..")) {
        where+=2;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }

        *last = '\0';
        continue;
      }

      /* handle "../" */
      if(!strncmp(where,"../",3)) {
        where += 3;
        ptr = last = workpath;
        while(*ptr) {
          if(*ptr == '/')
            last = ptr;
          ptr++;
        }
        *last = '\0';
        continue;
      }
      ptr = strchr(where,'/');
      if(!ptr)
        ptr = where + strlen(where) - 1;
      else
        *ptr = '\0';

      sstrncpy(namebuf, workpath, sizeof(namebuf));
      if(*namebuf) {
        for(last = namebuf; *last; last++) ;
        if(*--last != '/')
          sstrcat(namebuf,"/",MAXPATHLEN);
      } else
        sstrcat(namebuf,"/",MAXPATHLEN);

      sstrcat(namebuf,where,MAXPATHLEN);

      where = ++ptr;

      sstrncpy(workpath, namebuf, sizeof(workpath));
    }
  }

  if(!workpath[0])
    sstrncpy(workpath, "/", sizeof(workpath));

  sstrncpy(buf, workpath, maxlen);  
}

int fs_chdir_canon(const char *path, int hidesymlink)
{
  char resbuf[MAXPATHLEN + 1] = {'\0'};
  fsdir_t *f;
  int ret;

  if(fs_resolve_partial(path,resbuf,MAXPATHLEN,FSOP_CHDIR) == -1) {
    errno = ENOENT;
    return -1;
  }

  f = fs_lookup_dir(resbuf,FSOP_CHDIR);
  ret = f->chdir(f,resbuf);

  if(ret != -1) {
    /* chdir succeeded, so we set fs_cwd for future references
     */
     fs_cwd = f;
     sstrncpy(cwd, resbuf, sizeof(cwd));
     if(hidesymlink)
       fs_virtual_path(path, vwd, MAXPATHLEN);
     else
       sstrncpy(vwd, resbuf, sizeof(vwd));
  }

  return ret;  
}

int fs_chdir(const char *path, int hidesymlink)
{
  char resbuf[MAXPATHLEN + 1] = {'\0'};
  fsdir_t *f;
  int ret;

  fs_clean_path(path,resbuf,MAXPATHLEN);
  
  f = fs_lookup_dir(path,FSOP_CHDIR);
  ret = f->chdir(f,resbuf);

  if(ret != -1) {
    /* chdir succeeded, so we set fs_cwd for future references
     */
     fs_cwd = f;
     sstrncpy(cwd, resbuf, sizeof(cwd));
     if(hidesymlink)
       fs_virtual_path(path, vwd, MAXPATHLEN);
     else
       sstrncpy(vwd, resbuf, sizeof(vwd));
  }

  return ret;  
}

/* fs_opendir, fs_closedir and fs_readdir all use a nifty 
 * optimization, caching the last-recently-used fsdir_t, and
 * avoid future fsdir_t lookups when iterating via readdir.
 */

void *fs_opendir(const char *path)
{
  fsdir_t *f;
  opendir_t *od;

  DIR *ret;

  if(!strchr(path,'/'))
    f = fs_cwd;
  else {
    char buf[MAXPATHLEN + 1] = {'\0'};

    if(fs_resolve_partial(path,buf,MAXPATHLEN,FSOP_OPENDIR) == -1) {
      errno = ENOENT;
      return NULL;
    }
    f = fs_lookup_dir(buf,FSOP_OPENDIR);
  }

  ret = f->opendir(f,path);
  if(!ret)
    return NULL;

  /* cache it here */
  fs_cache_dir = ret;
  fs_cache_fsdir = f;

  od = malloc(sizeof(opendir_t));
  if(!od) {
    f->closedir(f,ret);
    errno = ENOMEM;
    return NULL;
  }

  od->dir = ret;
  od->fsdir = f;
  xaset_insert(opendir_list,(xasetmember_t*)od);

  return ret;
}

static fsdir_t *find_opendir(void *d, int closing)
{
  fsdir_t *f = NULL;

  if(d == fs_cache_dir) {
    f = fs_cache_fsdir;
    if(closing) {
      fs_cache_dir = NULL;
      fs_cache_fsdir = NULL;
    }
  } else {
    opendir_t *od;

    for(od = (opendir_t*)opendir_list->xas_list; od; od=od->next)
      if(od->dir == d) {
        f = od->fsdir;
        break;
      }

    if(closing && od) {
      xaset_remove(opendir_list,(xasetmember_t*)od);
      free(od);
    }
  }

  return f;
}

int fs_closedir(void *d)
{
  fsdir_t *f;

  f = find_opendir(d,1);

  if(!f)
    return -1;

  return f->closedir(f,d);
}

struct dirent *fs_readdir(void *d)
{
  fsdir_t *f;

  f = find_opendir(d,0);

  if(!f)
    return NULL;

  return f->readdir(f,d);
}

/*******************************/
/* all other fs functions here */
/*******************************/

int fs_stat_canon(const char *path, struct stat *sbuf)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(path,NULL,FSOP_STAT);
  return f->stat(f,path,sbuf);
}

int fs_stat(const char *path, struct stat *sbuf)
{
  fsdir_t *f;

  f = fs_lookup_file(path,NULL,FSOP_STAT);
  return f->stat(f,path,sbuf);
}

int fs_lstat_canon(const char *path, struct stat *sbuf)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(path,NULL,FSOP_LSTAT);
  return f->lstat(f,path,sbuf);
}

int fs_lstat(const char *path, struct stat *sbuf)
{
  fsdir_t *f;

  f = fs_lookup_file(path,NULL,FSOP_LSTAT);
  return f->lstat(f,path,sbuf);
}

int fs_readlink_canon(const char *path, char *buf, int maxlen)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(path,NULL,FSOP_READLINK);
  return f->readlink(f,path,buf,maxlen);
}

int fs_readlink(const char *path, char *buf, int maxlen)
{
  fsdir_t *f;

  f = fs_lookup_file(path,NULL,FSOP_READLINK);
  return f->readlink(f,path,buf,maxlen);
}

/* fs_glob() is just a wrapper for glob, setting the various gl_
 * callbacks to our fs functions.
 */

int fs_glob(const char *pattern, int flags,
            int (*errfunc)(const char *, int),
            glob_t *pglob)
{
  if(pglob) {
    flags |= GLOB_ALTDIRFUNC;
    
    pglob->gl_closedir = (void (*)(void*))fs_closedir;
    pglob->gl_readdir = (void*(*)(void*))fs_readdir;
    pglob->gl_opendir = fs_opendir;
    pglob->gl_lstat = (int (*)(const char *,void*))fs_lstat;
    pglob->gl_stat = (int (*)(const char *,void*))fs_stat;
  }

  return glob(pattern,flags,errfunc,pglob);
}

void fs_globfree(glob_t *pglob)
{ globfree(pglob); }

int fs_rename_canon(const char *rfrom, const char *rto)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(rfrom,NULL,FSOP_RENAME);

  if(f != fs_lookup_file_canon(rto,NULL,FSOP_RENAME)) {
    errno = EXDEV;
    return -1;
  }

  return f->rename(f,rfrom,rto);
}

int fs_rename(const char *rfrom, const char *rto)
{
  fsdir_t *f;

  f = fs_lookup_file(rfrom,NULL,FSOP_RENAME);

  if(f != fs_lookup_file(rto,NULL,FSOP_RENAME)) {
    errno = EXDEV;
    return -1;
  }

  return f->rename(f,rfrom,rto);
}

int fs_unlink_canon(const char *name)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(name,NULL,FSOP_UNLINK);

  return f->unlink(f,name);
}
	
int fs_unlink(const char *name)
{
  fsdir_t *f;

  f = fs_lookup_file(name,NULL,FSOP_UNLINK);

  return f->unlink(f,name);
}

fsdir_t *fs_open_canon(const char *name, int flags, int *fd)
{
  char *deref;
  fsdir_t *f;
  int ret;

  f = fs_lookup_file_canon(name,&deref,FSOP_OPEN);

  ret = f->open(f,deref,flags);
  if(ret == -1)
    return NULL;

  if(fd)
    *fd = ret;

  return f;  
}

fsdir_t *fs_open(const char *name, int flags, int *fd)
{
  fsdir_t *f;
  int ret;

  f = fs_lookup_file(name,NULL,FSOP_OPEN);

  ret = f->open(f,name,flags);
  if(ret == -1)
    return NULL;

  if(fd)
    *fd = ret;

  return f;  
}

fsdir_t *fs_creat_canon(const char *name, mode_t mode, int *fd)
{
  char *deref;
  fsdir_t *f;
  int ret;

  f = fs_lookup_file_canon(name,&deref,FSOP_CREAT);
  ret = f->creat(f,deref,mode);

  if(ret == -1)
    return NULL;

  if(fd)
    *fd = ret;

  return f;
}

fsdir_t *fs_creat(const char *name, mode_t mode, int *fd)
{
  fsdir_t *f;
  int ret;

  f = fs_lookup_file(name,NULL,FSOP_CREAT);
  ret = f->creat(f,name,mode);

  if(ret == -1)
    return NULL;

  if(fd)
    *fd = ret;

  return f;
}

int fs_close(fsdir_t *f, int fd)
{ return f->close(f,fd); }

int fs_read(fsdir_t *f, int fd, char *buf, size_t size)
{ return f->read(f,fd,buf,size); }

int fs_write(fsdir_t *f, int fd, const char *buf, size_t size)
{ return f->write(f,fd,buf,size); }

off_t fs_lseek(fsdir_t *f, int fd, off_t offset, int whence)
{ return f->lseek(f,fd,offset,whence); }

int fs_link_canon(const char *lfrom, const char *lto)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(lfrom,NULL,FSOP_LINK);
  if(f != fs_lookup_file_canon(lto,NULL,FSOP_LINK)) {
    errno = EXDEV;
    return -1;
  }

  return f->link(f,lfrom,lto);
}

int fs_link(const char *lfrom, const char *lto)
{
  fsdir_t *f;

  f = fs_lookup_file(lfrom,NULL,FSOP_LINK);
  if(f != fs_lookup_file(lto,NULL,FSOP_LINK)) {
    errno = EXDEV;
    return -1;
  }

  return f->link(f,lfrom,lto);
}

int fs_symlink_canon(const char *lfrom, const char *lto)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(lto,NULL,FSOP_SYMLINK);
  return f->symlink(f,lfrom,lto);
}

int fs_symlink(const char *lfrom, const char *lto)
{
  fsdir_t *f;

  f = fs_lookup_file(lto,NULL,FSOP_SYMLINK);
  return f->symlink(f,lfrom,lto);
}

int fs_chmod_canon(const char *name, mode_t mode)
{
  char *deref;
  fsdir_t *f;

  f = fs_lookup_file_canon(name,&deref,FSOP_CHMOD);
  return f->chmod(f,deref,mode);
}

int fs_chmod(const char *name, mode_t mode)
{
  fsdir_t *f;

  f = fs_lookup_file(name,NULL,FSOP_CHMOD);
  return f->chmod(f,name,mode);
}

int fs_chown_canon(const char *name, uid_t uid, gid_t gid)
{
  fsdir_t *f;

  f = fs_lookup_file_canon(name,NULL,FSOP_CHOWN);
  return f->chown(f,name,uid,gid);
}

int fs_chown(const char *name, uid_t uid, gid_t gid)
{
  fsdir_t *f;

  f = fs_lookup_file(name,NULL,FSOP_CHOWN);
  return f->chown(f,name,uid,gid);
}

/* fs_gets is not truely a vfs function, however it's included here
 * for simplicity.
 */

char *fs_gets(char *buf, size_t size, fsdir_t *f, int fd)
{
  char *bp;
  int toread;
  static IOBUF *iobuf = NULL;

  if(!f) {
    errno = EBADF;
    return NULL;
  }

  
  if(!iobuf) {
    iobuf = (IOBUF*)pcalloc(permanent_pool,sizeof(IOBUF));
    iobuf->buf = iobuf->cp = palloc(permanent_pool,TUNABLE_BUFFER_SIZE);
    iobuf->left = iobuf->bufsize = TUNABLE_BUFFER_SIZE;
  }

  bp = buf;

  while(size) {
    if(!iobuf->cp || iobuf->left == TUNABLE_BUFFER_SIZE) { /* empty buffer */
      toread = fs_read(f,fd,iobuf->buf,
	       (size < TUNABLE_BUFFER_SIZE ? size : TUNABLE_BUFFER_SIZE));
      if(toread <= 0) {
        if(bp != buf) {
          *bp = '\0';
          return buf;
        } else
          return NULL;
      }

      iobuf->left = TUNABLE_BUFFER_SIZE - toread;
      iobuf->cp = iobuf->buf;
    } else
      toread = TUNABLE_BUFFER_SIZE - iobuf->left;

    while(size && *iobuf->cp != '\n' && toread--) {
      *bp++ = *iobuf->cp++;
      size--;
      iobuf->left++;
    }

    if(size && toread && *iobuf->cp == '\n') {
      size--; toread--;
      *bp++ = *iobuf->cp++;
      iobuf->left++;
      break;
    }

    if(!toread)
      iobuf->cp = NULL;
  }

  *bp = '\0';
  return buf;
}

int init_fs()
{
  char cwdbuf[MAXPATHLEN + 1] = {'\0'};

  opendir_list = xaset_create(permanent_pool,NULL);
  fs_std = fs_register(NULL);

  if(getcwd(cwdbuf,MAXPATHLEN))
    fs_setcwd(cwdbuf);
  else {
    chdir("/");
    fs_setcwd("/");
  }
  
  return 0;
}
