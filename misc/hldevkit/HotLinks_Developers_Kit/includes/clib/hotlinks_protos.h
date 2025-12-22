/*
 * hotlink_protos.h - hotlinks.library function prototypes
 *
 */
 
#ifndef HOTLINKS_HOTLINKS_PROTOS_H
#define HOTLINKS_HOTLINKS_PROTOS_H 1

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* hotlinks function prototypes */
int GetPub(struct PubBlock *, int (*)());
int PutPub(struct PubBlock *, int (*)());
int PubInfo(struct PubBlock *);
int HLSysInfo(ULONG, int *);
ULONG HLRegister(int, struct MsgPort *, struct Screen *);
int UnRegister(ULONG);
struct PubBlock *AllocPBlock(ULONG);
int FreePBlock(struct PubBlock *);
int SetUser(ULONG, char *, char *);
int ChgPassword(ULONG, char *, char *, char *);
int FirstPub(struct PubBlock *);
int NextPub(struct PubBlock *);
int RemovePub(struct PubBlock *);
int Notify(struct PubBlock *, int, int, void *);
int PubStatus(struct PubBlock *);
int GetInfo(struct PubBlock *);
int SetInfo(struct PubBlock *);
int LockPub(struct PubBlock *, int);
int OpenPub(struct PubBlock *, int);
int ReadPub(struct PubBlock *, char *, int);
int WritePub(struct PubBock *, char *, int);
int SeekPub(struct PubBlock *, int, int);
int ClosePub(struct PubBlock *);
int Publish(struct PubBlock *);
int Subscribe(struct PubBlock *);
int NewPassword(ULONG);
int UnSubscribe(struct PubBlock *);

#endif ;HOTLINKS_HOTLINKS_PROTOS_H
