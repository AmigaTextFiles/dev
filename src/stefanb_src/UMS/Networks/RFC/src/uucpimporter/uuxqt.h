/*
 * uuxqt.h  V1.0.02
 *
 * uuxqt include file
 *
 * (c) 1992-1998 Stefan Becker
 *
 */

/* UUCP common include file */
#include <common.h>

/* OS function prototypes */
#include <clib/utility_protos.h>

/* OS function inline calls */
#include <pragmas/utility_pragmas.h>

/* ANSI C include files */
#include <sys/stat.h>
#include <fcntl.h>
#include <stdarg.h>

/* Buffer sizes */
#define TMP1BUFSIZE 1024
#define BUFFERSIZE  (TMP1BUFSIZE)

/* Action codes for ReceiveBSMTPFile()/UncompressFile() */
#define COMP_NONE     0
#define COMP_COMPRESS 1
#define COMP_FREEZE   2
#define COMP_GZIP     3

/* Global data */
extern struct Library *SysBase,*UMSBase,*UMSRFCBase,*UtilityBase;
extern struct DOSBase *DOSBase;
extern char  UMSMBName[];
extern char *UMSPassword;
extern struct UMSRFCData *URData;
extern struct UMSRFCData *DefaultLog;
extern UMSAccount         Account;
extern BOOL   KeepDupes;
extern BOOL   LogDupes;
extern UBYTE *TempBuffer1;
extern ULONG  FileCounter;
extern ULONG  FileBadCounter;

/* Function prototypes */
int    ScanInDir(BPTR, BPTR);
int    ParseCommandFile(BPTR, char *);
BOOL   ProcessRFCMail(char *);
int    ReceiveMailFile(char *, char *, char *);
int    ReceiveBSMTPFile(char *, char *);
ULONG  TranslateCRLF(char *);
int    LogUMSError(char *, char *, char *, char *, ULONG);
int    ReceiveNewsFile(char *, char *, ULONG);
BOOL   Login(char *);
void   FreeLogins(void);
char  *GetDataFile(char *, ULONG *);
void   PrintProgress(BOOL);
void   FileGood(void);
void   FileBad(void);
void   MailGood(void);
void   MailBad(void);
void   NewsGood(void);
void   NewsBad(void);
void   CrossPostGood(void);
void   CrossPostBad(void);
