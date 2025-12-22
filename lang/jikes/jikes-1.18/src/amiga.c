#ifdef stat
#undef stat
#endif
#ifdef fopen
#undef fopen
#endif
#ifdef opendir
#undef opendir
#endif
#ifdef mkdir
#undef mkdir
#endif

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>

__BEGIN_DECLS
/**
 * Provide wrappers for the stat, fopen, and opendir functions that massage
 * the file names given to them as arguments so that UNIX "." and ".."
 * path names are translated to their AmigaOS equivalents. This is done so
 * that no intervention is done in terms of file semantics to the jikes
 * source.
 */
static char buf[MAXPATHLEN+1];
static char cwd[MAXPATHLEN+1];
static char pathComponent[MAXPATHLEN+1];

static void ix_out(char *s)
{
  int ptr;

  if (strcmp(s, ".") == 0) {
    if (buf[0] == '\0') {
      strcat(buf, cwd);
    }else{
      ptr = strlen(buf)-1;
      if (buf[ptr] == '/') {
        buf[ptr] = '\0';
      }
    }
  }else{
    if (strcmp(s, "..") == 0) {
      strcat(buf, "/");
    }else{
      strcat(buf, s);
    }
  }
}

static char *
ix_path(const char *path)
{
  int len;
  char sep[2];
  int appendSep, skipNext = 0;
  int i, j;

  buf[0] = '\0';
  cwd[0] = '\0';
  pathComponent[0] = '\0';
  sep[1] = '\0';
  getcwd(cwd, sizeof(cwd));
  len = strlen(path);

  for (i=0, j=0; i<len; i++) {
    if (path[i] == '/' || path[i] == ':') {
      pathComponent[j] = '\0';
      if (j != 0) {
        ix_out(pathComponent);
        if (buf[0] != '\0' &&
	    ((strcmp(pathComponent, ".") == 0 && buf[strlen(buf)-1] == ':') ||
	     (strcmp(pathComponent, "..") == 0 && buf[strlen(buf)-1] == '/'))){
	  appendSep = 0;
	}else{
	  appendSep = 1;
	}
        j = 0;
        pathComponent[0] = '\0';
      }
      sep[0] = path[i];
      if (appendSep && !skipNext) {
        strcat(buf, sep);
      }
      /* Constructs of the type FOO:/bar are *probably* caused by appending
       * UNIX-style a path to a directory, so we skip the bogus "/".
       */
      if (path[i] == ':' && path[i+1] == '/') {
        skipNext = 1;
      }else{
        skipNext = 0;
      }
    }else{
      pathComponent[j++] = path[i];
    }
  }
  if (j > 0) {
    pathComponent[j] = '\0';
    ix_out(pathComponent);
  }
  return buf;
}

int
mystat(const char *path, struct stat *sb)
{
  return stat(ix_path(path), sb);
}

FILE *
myfopen(char *path, char *mode)
{
  return fopen(ix_path(path), mode);
}

DIR
*myopendir(const char *path)
{
  return opendir(ix_path(path));
}

int
mymkdir(const char *path, mode_t mode)
{
  return mkdir(ix_path(path), mode);
}
__END_DECLS
