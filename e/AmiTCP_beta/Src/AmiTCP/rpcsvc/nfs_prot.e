OPT MODULE, PREPROCESS
OPT EXPORT

CONST NFS_PORT=2049,
      NFS_MAXDATA=8192,
      NFS_MAXPATHLEN=1024,
      NFS_MAXNAMLEN=255,
      NFS_FHSIZE=32,
      NFS_COOKIESIZE=4,
      NFS_FIFO_DEV=-1,
      NFSMODE_FMT=$F000,
      NFSMODE_DIR=$4000,
      NFSMODE_CHR=$2000,
      NFSMODE_BLK=$6000,
      NFSMODE_REG=$8000,
      NFSMODE_LNK=$A000,
      NFSMODE_SOCK=$C000,
      NFSMODE_FIFO=$1000

CONST NFS_OK=0,
      NFSERR_PERM=1,
      NFSERR_NOENT=2,
      NFSERR_IO=5,
      NFSERR_NXIO=6,
      NFSERR_ACCES=13,
      NFSERR_EXIST=17,
      NFSERR_NODEV=19,
      NFSERR_NOTDIR=20,
      NFSERR_ISDIR=21,
      NFSERR_FBIG=27,
      NFSERR_NOSPC=28,
      NFSERR_ROFS=30,
      NFSERR_NAMETOOLONG=63,
      NFSERR_NOTEMPTY=66,
      NFSERR_DQUOT=69,
      NFSERR_STALE=70,
      NFSERR_WFLUSH=99

ENUM NFNON, NFREG, NFDIR, NFBLK, NFCHR, NFLNK, NFSOCK, NFBAD, NFFIFO

OBJECT nfs_fh
  data[NFS_FHSIZE]:ARRAY
ENDOBJECT

OBJECT nfstime
  seconds
  useconds
ENDOBJECT

OBJECT fattr
  type
  mode
  nlink
  uid
  gid
  size
  blocksize
  rdev
  blocks
  fsid
  fileid
  atime:nfstime
  mtime:nfstime
  ctime:nfstime
ENDOBJECT

OBJECT sattr
  mode
  uid
  gid
  size
  atime:nfstime
  mtime:nfstime
ENDOBJECT

#define filename_t PTR TO CHAR
#define nfspath_t PTR TO CHAR

OBJECT attrstat
  status
  attributes:fattr
ENDOBJECT

OBJECT sattrargs
  file:nfs_fh
  attributes:sattr
ENDOBJECT

OBJECT diropargs
  dir:nfs_fh
  name:filename_t
ENDOBJECT

OBJECT diropokres
  file:nfs_fh
  attributes:fattr
ENDOBJECT

OBJECT diropres
  status
  diropres:diropokres
ENDOBJECT

OBJECT readlinkres
  status
  data:nfspath_t
ENDOBJECT

OBJECT readargs
  file:nfs_fh
  offset
  count
  totalcount
ENDOBJECT

OBJECT data
  len
  val:PTR TO CHAR
ENDOBJECT

OBJECT readokres
  attributes:fattr
  data:data
ENDOBJECT

OBJECT readres
  status
  reply:readokres
ENDOBJECT

OBJECT writeargs
  file:nfs_fh
  beginoffset
  offset
  totalcount
  data:data
ENDOBJECT

OBJECT createargs
  where:diropargs
  attributes:sattr
ENDOBJECT

OBJECT renameargs
  from:diropargs
  to:diropargs
ENDOBJECT

OBJECT linkargs
  from:nfs_fh
  to:diropargs
ENDOBJECT

OBJECT symlinkargs
  from:diropargs
  to:nfspath_t
  attributes:sattr
ENDOBJECT

-> nfscookie seems to be an array passed by value

OBJECT readdirargs
  dir:nfs_fh
  cookie[NFS_COOKIESIZE]:ARRAY
  count
ENDOBJECT

OBJECT entry
  field
  name:filename_t
  cookie[NFS_COOKIESIZE]:ARRAY
  nextentry:PTR TO entry
ENDOBJECT

OBJECT dirlist
  entries:PTR TO entry
  eof
ENDOBJECT

OBJECT readdirres
  status
  reply:dirlist
ENDOBJECT

OBJECT statfsokres
  tsize
  bsize
  blocks
  bfree
  bavail
ENDOBJECT

OBJECT statfsres
  status
  reply:statfsokres
ENDOBJECT

CONST NFS_PROGRAM=100003,
      NFS_VERSION=2

ENUM NFSPROC_NULL, NFSPROC_GETATTR, NFSPROC_SETATTR, NFSPROC_ROOT,
     NFSPROC_LOOKUP, NFSPROC_READLINK, NFSPROC_READ, NFSPROC_WRITECACHE,
     NFSPROC_WRITE, NFSPROC_CREATE, NFSPROC_REMOVE, NFSPROC_RENAME,
     NFSPROC_LINK, NFSPROC_SYMLINK, NFSPROC_MKDIR, NFSPROC_RMDIR,
     NFSPROC_READDIR, NFSPROC_STATFS
