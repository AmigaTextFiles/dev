#ifndef IFF_IFF_H
#define IFF_IFF_H
#ifndef COMPILER_H
#include        <iff/compiler.h>
#endif
#ifndef LIBRARIES_DOS_H
#include        <libraries/dos.h>
#endif
#ifndef OFFSET_BEGINNING
#define OFFSET_BEGINNING        OFFSET_BEGINING
#endif
typedef LONG    IFFP;
#define IFF_OKAY        0L
#define END_MARK        -1L
#define IFF_DONE        -2L
#define DOS_ERROR       -3L
#define NOT_IFF -4L
#define NO_FILE -5L
#define CLIENT_ERROR    -6L
#define BAD_FORM        -7L
#define SHORT_CHUNK     -8L
#define BAD_IFF -9L
#define LAST_ERROR      BAD_IFF
#define CheckIFFP()     { if (iffp != IFF_OKAY)  return(iffp); }
typedef LONG    ID;
#define MakeID(a,b,c,d) ((LONG)(a)<<24L | (LONG)(b) << 16L | (c) << 8 | (d))
#define FORM    MakeID('F','O','R','M')
#define PROP    MakeID('P','R','O','P')
#define LIST    MakeID('L','I','S','T')
#define CAT     MakeID('C','A','T',' ')
#define FILLER  MakeID(' ',' ',' ',' ')
#define NULL_CHUNK      0L
typedef struct  {
ID      ckID;
LONG    ckSize;
}       ChunkHeader;
typedef struct  {
ID      ckID;
LONG    ckSize;
UBYTE   ckData[ 1       ];
}       Chunk;
#define szNotYetKnown   0x80000001L
#define IS_ODD(a) ((a) & 1)
#define WordAlign(size) ((size+1)&~1)
#define ChunkPSize(dataSize) (WordAlign(dataSize) + sizeof(ChunkHeader))
typedef struct  {
ID      ckID;
LONG    ckSize;
ID      grpSubID;
}       GroupHeader;
typedef struct  {
ID      ckID;
LONG    ckSize;
ID      grpSubID;
UBYTE   grpData[        1       ];
}       GroupChunk;
typedef IFFP    ClientProc();
typedef struct  _ClientFrame    {
ClientProc      *getList, *getProp, *getForm, *getCat;
}       ClientFrame;
typedef struct  _GroupContext   {
struct  _GroupContext   *parent;
ClientFrame     *clientFrame;
BPTR    file;
LONG    position;
LONG    bound;
ChunkHeader     ckHdr;
ID      subtype;
LONG    bytesSoFar;
}       GroupContext;
#define ChunkMoreBytes(gc) ((gc)->ckHdr.ckSize - (gc)->bytesSoFar)
extern  IFFP    OpenRIFF();
extern  IFFP    OpenRGroup();
extern  IFFP    CloseRGroup();
extern  ID      GetChunkHdr();
extern  IFFP    IFFReadBytes();
extern  IFFP    SkipGroup();
extern  IFFP    ReadIFF();
extern  IFFP    ReadIList();
extern  IFFP    ReadICat();
extern  ID      GetFChunkHdr();
extern  ID      GetF1ChunkHdr();
extern  ID      GetPChunkHdr();
extern  IFFP    OpenWIFF();
extern  IFFP    StartWGroup();
extern  IFFP    EndWGroup();
extern  IFFP    OpenWGroup();
extern  IFFP    CloseWGroup();
extern  IFFP    PutCk();
extern  IFFP    PutCkHdr();
extern  IFFP    IFFWriteBytes();
extern  IFFP    PutCkEnd();
#endif  IFF_H
