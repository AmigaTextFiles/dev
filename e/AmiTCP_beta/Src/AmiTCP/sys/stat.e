OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/types',
       'amitcp/amitcp/types'

OBJECT __stat
  dev:dev_t
  ino:ino_t
  mode:mode_t
  nlink:INT
  uid:uid_t
  gid:gid_t
  rdev:dev_t
  size:off_t
  atime:time_t
  mtime:time_t
  ctime:time_t
  blksize
  blocks
  dosmode
  type:INT
  comment:PTR TO CHAR
ENDOBJECT

SET S_IXOTH, S_IWOTH, S_IROTH, S_IXGRP, S_IWGRP, S_IRGRP, S_IXUSR, S_IWUSR,
    S_IRUSR, S_ISVTX, S_ISGID, S_ISUID

CONST S_IREAD=S_IRUSR,
      S_IWRITE=S_IWUSR,
      S_IEXEC=S_IXUSR

CONST S_IRWXU=S_IRUSR OR S_IWUSR OR S_IXUSR,
      S_IRWXG=S_IRGRP OR S_IWGRP OR S_IXGRP,
      S_IRWXO=S_IROTH OR S_IWOTH OR S_IXOTH

CONST S_IFMT=  $F000,
      S_IFCHR= $2000,
      S_IFDIR= $4000,
      S_IFBLK= $6000,
      S_IFREG= $8000,
      S_IFLNK= $A000,
      S_IFSOCK=$C000,
      S_IFIFO= $1000

#define S_ISDIR(m)  (((m) AND S_IFMT) = S_IFDIR)
#define S_ISCHR(m)  (((m) AND S_IFMT) = S_IFCHR)
#define S_ISBLK(m)  (((m) AND S_IFMT) = S_IFBLK)
#define S_ISREG(m)  (((m) AND S_IFMT) = S_IFREG)
#define S_ISLNK(m)  (((m) AND S_IFMT) = S_IFLNK)
#define S_ISFIFO(m) (((m) AND S_IFMT) = S_IFIFO)
#define S_ISSOCK(m) (((m) AND S_IFMT) = S_IFSOCK)
