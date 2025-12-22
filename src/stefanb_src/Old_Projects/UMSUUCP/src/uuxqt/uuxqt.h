/*
 * uuxqt.h  V0.8.01
 *
 * uuxqt include file
 *
 * (c) 1992-1994 Stefan Becker
 *
 */

#include "/AUUCPLib/auucplib.h"
#include "/ums_uucp.h"
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/ums_protos.h>
#include <clib/utility_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <dos/dostags.h>
#include <dos/exall.h>
#include <exec/memory.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#if 0
extern struct Library *SysBase,*DOSBase,*UMSBase,*UtilityBase;
#endif
extern char UMSMBName[];
extern UMSUserAccount Account;
extern char *PathName;
extern char *DomainName;
extern BOOL FilterCR;
extern BOOL KeepDupes;
extern UBYTE *MainBuffer;
extern UBYTE *Tmp1Buffer;
extern UBYTE *Tmp2Buffer;
extern UBYTE *Tmp3Buffer;
extern UBYTE *Tmp4Buffer;
extern UBYTE *Tmp5Buffer;
extern UBYTE *Tmp6Buffer;
extern UBYTE *Tmp7Buffer;
extern ULONG FileCounter;
extern ULONG FileBadCounter;

int   ScanInDir(BPTR);
int   ParseCommandFile(char *);
BOOL  ProcessRFCMail(char *);
int   ReceiveMailFile(char *, char *, char *);
int   ReceiveBSMTPFile(char *, char *);
int   LogUMSError(char *, char *, char *, char *, ULONG);
int   ReceiveNewsFile(char *, char *, ULONG);
BOOL  Login(char *);
void  FreeLogins(void);
char *GetDataFile(char *, ULONG *);
BOOL  ScanRFCMessage(char *, struct TagItem *, BOOL);
BOOL  DecodeRFC1341Message(char *, char *, char *);
void  DecodeRFC1342Line(char *);
void  GetConversionData(UMSUserAccount);
void  FreeConversionData(void);
void  GetAddress(char *input, char *name, char *address, char *buf);
void  SplitAddress(char *input, char *name, char *address, char *buf);
void  PrintProgress(BOOL);
void  FileGood(void);
void  FileBad(void);
void  MailGood(void);
void  MailBad(void);
void  NewsGood(void);
void  NewsBad(void);
void  CrossPostGood(void);
void  CrossPostBad(void);
void  ErrLog(char *, ...);
void  CloseErrLog(void);

/* Buffer sizes */
#define MAINBUFSIZE 65536 /* Mainly used by rfc822.c to store comments */
#define TMP1BUFSIZE 1024
#define TMP2BUFSIZE 1024
#define TMP3BUFSIZE 1024
#define TMP4BUFSIZE 1024
#define TMP5BUFSIZE 1024
#define TMP6BUFSIZE 1024
#define TMP7BUFSIZE 1024
#define BUFFERSIZE  (MAINBUFSIZE + TMP1BUFSIZE + TMP2BUFSIZE + TMP3BUFSIZE + \
                     TMP4BUFSIZE + TMP5BUFSIZE + TMP6BUFSIZE + TMP7BUFSIZE)

/* Action codes for ReceiveBSMTPFile()/UncompressFile() */
#define COMP_NONE     0
#define COMP_COMPRESS 1
#define COMP_FREEZE   2
#define COMP_GZIP     3

/* Offsets in message tag array for mail & news */
#define MSGTAGS_SUBJECT     0
#define MSGTAGS_FROMNAME    1
#define MSGTAGS_FROMADDR    2
#define MSGTAGS_REPLYNAME   3
#define MSGTAGS_REPLYADDR   4
#define MSGTAGS_DATE        5
#define MSGTAGS_CDATE       6
#define MSGTAGS_MSGID       7
#define MSGTAGS_REFERID     8
#define MSGTAGS_ORG         9
#define MSGTAGS_MSGREADER  10
#define MSGTAGS_TEXT       11
#define MSGTAGS_ATTRIBUTES 12
#define MSGTAGS_COMMENT    13
#define MSGTAGS_LINK       14

/* Offsets in message tag array for mail only */
#define MSGTAGS_TONAME     15
#define MSGTAGS_TOADDR     16

/* Offsets in message tag array for news only */
#define MSGTAGS_GROUP      15
#define MSGTAGS_FOLLOWUP   16
#define MSGTAGS_DIST       17
#define MSGTAGS_HIDE       18
