/*
 * auucplib.h
 *
 * include file for AmigaUUCP link library
 *
 */

/* pragmas */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>

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
int FileIsLocked(const char *);

/* file name munging */
void mungecase_filename(char *, char *);

/* sequence numbers */
int GetSequence(int);
char *SeqToName(long);
