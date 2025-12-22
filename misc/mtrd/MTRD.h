void WriteData(struct MFile *File, struct MUser *User, char *Data);
struct MFile *OpenMFile(struct MsgPort *Port, struct FileID *FID, unsigned short Flags);
void CloseMFile(struct MFile *File, struct MUser *User);
unsigned long CountFiles(unsigned short Type, unsigned short Sub);
unsigned long GetFileList(struct FileList *Buffer, unsigned long Max, unsigned short Type, unsigned short Sub);
struct MUser *AddUser(struct MFile *File, struct MsgPort *Port, char *Buffer, unsigned short Flags);
void RemUser(struct MUser *User);
void InitData(char *ptr);
void AddBytes(char *ptr, unsigned long offset, unsigned short size, char *byteP);
void AddWords(char *ptr, unsigned long offset, unsigned short size, unsigned short *wordP);
void AddLongs(char *ptr, unsigned long offset, unsigned short size, unsigned long *longP);
void AddFill(char *ptr, unsigned long offset, unsigned short size, unsigned short fill);
/* These are Private */
unsigned short AddHeader(char *ptr, unsigned long offset, unsigned short size);
void DoWrite(struct MUser *User, char *Data);
struct MUpdate *GetUpdateMsg(struct MtrdBase *MtrdBase, struct MFile *File);

#include <exec/types.h>
#include <exec/lists.h>
#include <exec/ports.h>

struct FileID {
	UWORD Type,SubType;
	ULONG Size;
	char *Data;
	char *Name;
	ULONG Defs[4];
};

struct MUser {
	struct Node node;
	struct MsgPort *MsgPort;
	char *Buffer;
	UWORD Flags;
};
#define MUSB_LOCKED 0
#define MUSF_LOCKED 1<<0
#define MUSB_BUFFER 1
#define MUSF_BUFFER 1<<1
#define MUSB_NOTIFY 2
#define MUSF_NOTIFY 1<<2
#define MUSB_MASTER 3
#define MUSF_MASTER 1<<3
#define MUSB_LOCKWRITE 4
#define MUSF_LOCKWRITE 1<<4

struct MFile {
	struct Node node;
	struct List UserList;
	struct FileID FID;
	struct MUser *MasterUser;
	UWORD Flags;
};
#define MTFB_PUBLIC 0
#define MTFF_PUBLIC 1<<0

struct MUpdate {
	struct Message Message;
	ULONG Type;
	struct MFile *File;
};
#define MTUP_UPDATE 1
#define MTUP_CLOSE 2

struct FileList {
	struct MFile *File;
	UWORD flags;
	struct FileID FID;
};

struct MtrdBase {
	struct Library Lib;
	ULONG SegList;
	struct List FileList;
	struct MsgPort *MsgPort;
	ULONG Flags;
};


#define GETMUSER(file,user) user=file->MasterUser
#define GETFID(file,fid) fid=file->FID
#define GETBUFFER(file,buffer) buffer=file->FID.Data
#define CUSERFLAGS(user,flags) user->Flags=flags
#define UNLOCK(user) user->Flags&=~MUSF_LOCKED

#pragma amicall(MtrdBase, 0x1e, OpenMFile(a0,a1,d0))
#pragma amicall(MtrdBase, 0x24, CloseMFile(d0,a0))
#pragma amicall(MtrdBase, 0x2a, WriteData(d0,a0,a1))
#pragma amicall(MtrdBase, 0x30, CountFiles(d0,d1))
#pragma amicall(MtrdBase, 0x36, GetFileList(a0,d0,d1,d2))
#pragma amicall(MtrdBase, 0x3c, AddUser(d0,a0,a1,d1))
#pragma amicall(MtrdBase, 0x42, RemUser(a0))
#pragma amicall(MtrdBase, 0x48, InitData(a0))
#pragma amicall(MtrdBase, 0x4e, AddBytes(a0,d0,d1,a1))
#pragma amicall(MtrdBase, 0x54, AddWords(a0,d0,d1,a1))
#pragma amicall(MtrdBase, 0x5a, AddLongs(a0,d0,d1,a1))
#pragma amicall(MtrdBase, 0x60, AddFill(a0,d0,d1,d2))
