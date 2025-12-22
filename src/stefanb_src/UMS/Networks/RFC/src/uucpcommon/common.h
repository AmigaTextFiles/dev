/*
 * common.h V1.0.03
 *
 * UMS UUCP common include file
 *
 * (c) 1992-1998 Stefan Becker
 */

/* Include global files */
#include "/global.h"
#include "/revision.h"

/* OS include files */
#include <dos/dostags.h>
#include <dos/exall.h>

/* Global defines */
/* UMS UUCP configuration variables */
/* Prefix */
#define UMSUUCP_PRE        "uucp."
/* Global */
#define UMSUUCP_DEFAULT    "default"
#define UMSUUCP_NODENAME   UMSUUCP_PRE "nodename"
/* Exporter (ums2uucp) */
#define UMSUUCP_ENVELOPE   UMSUUCP_PRE "envelope"
#define UMSUUCP_MAILEXPORT UMSUUCP_PRE "mailexport"
#define UMSUUCP_MAILROUTE  UMSUUCP_PRE "mailroute"
#define UMSUUCP_NEWSEXPORT UMSUUCP_PRE "newsexport"
#define UMSUUCP_RECIPIENTS UMSUUCP_PRE "recipients"
/* Importer (uuxqt) */
#define UMSUUCP_KEEPDUPES  UMSUUCP_PRE "keepdupes"
#define UMSUUCP_LOGDUPES   UMSUUCP_PRE "logdupes"

/* UMS UUCP environment variables */
#define UMSUUCP_MBASE "UMSUUCP.mb"

/* Function prototypes */
/* config */
#define UUSPOOL "UUSpool\0UUSPOOL:"
char *GetConfigDir(char *);

/* logging */
extern char *LogProgram;
extern int LogLevel;
extern int LogToStdout;

void ulog(int, const char *, ...);

/* file locking */
#define ODU_NAME "OwnDevUnit.library"
void LockFile(const char *);
void UnLockFile(const char *);
void UnLockFiles(void);
int  FileIsLocked(const char *);

/* file name munging */
void mungecase_filename(char *, char *);

/* sequence numbers */
int   GetSequence(int);
char *SeqToName(long);
