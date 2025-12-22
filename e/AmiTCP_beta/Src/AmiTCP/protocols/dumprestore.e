OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/amitcp/types',
       'amitcp/sys/types'

CONST TP_BSIZE=1024,
      NTREC=10,
      HIGHDENSITYTREC=32

CONST TP_NINDIR=TP_BSIZE/2,
      LBLSIZE=16,
      NAMELEN=64

CONST OFS_MAGIC=60011,
      NFS_MAGIC=60012,
      CHECKSUM=84446

OBJECT s_spcl
  type
  date:time_t
  ddate:time_t
  volume
  tapea:daddr_t
  inumber
  magic
  checksum
  dinode:ino_t  -> Really :dinode, but what's dinode?
  count
  addr[TP_NINDIR]:ARRAY
  label[LBLSIZE]:ARRAY
  level
  filesys[NAMELEN]:ARRAY
  dev[NAMELEN]:ARRAY
  host[NAMELEN]:ARRAY
  flags
ENDOBJECT

OBJECT u_spcl
  dummy[TP_BSIZE]:ARRAY -> Unioned with spcl:s_spcl
ENDOBJECT

ENUM TS_TAPE=1, TS_INODE, TS_BITS, TS_ADDR, TS_END, TS_CLRI

CONST DR_NEWHEADER=1

#define DUMPOUTFMT '\l\s[16] \c \s'

-> There's no scanf in E
-> #define DUMPINFMT '%16s %c %[^\n]\n'
