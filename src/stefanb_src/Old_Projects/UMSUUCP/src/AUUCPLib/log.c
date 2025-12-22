
/*
 *  LOG.C
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 *
 *  ulog(level, ctl, args...)
 *
 *  NOTE!! Requires OwnDevUnitBase to be setup before any call to ulog() !!
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <fcntl.h>
#include <time.h>

#include "log.h"
#include "config.h"

Prototype void ulog(int, const char *, ...);
Prototype void OpenLog();
Prototype void CLoseLog();

int     LogLevel = -1;
int     LogToStdout = 0;
char    *LogProgram = "-";
char    *LogHost = "-";
char    *LogWho = "-";
char    *LogFile;
char    LogBuf[512];
int     LogFd = -1;
short   OpenHold = 0;

void
OpenLog()
{
    ++OpenHold;
}

void
CloseLog()
{
    if (OpenHold && --OpenHold == 0 && LogFd >= 0) {
        close(LogFd);
        LogFd = -1;
    }
}

/*
 *  Note that OpenHold is a sticky issue -- we can get into lockout
 *  situations if it is enabled and the program then runs another
 *  program which attempts to log something.  Therefore, we release
 *  our lock on the logfile even if we haven't closed the file to
 *  prevent lockouts... messages may get lost, but too bad.
 */

void
ulog(int level, const char *ctl, ...)
{
    long clock;
    struct tm *ut;
    int len;
    char *logFile;
    va_list args;
    static int ReLog = 0;

    va_start(args, ctl);

    if (LogFile)
        logFile = LogFile;
    else
        logFile = MakeConfigPath(UUSPOOL, "LOGFILE");

    if (level > LogLevel)
        return;

    (void)time(&clock);
    ut = localtime(&clock);

    sprintf(LogBuf, "(%02d/%02d-%02d:%02d:%02d) %s,%s,%s ",
        ut->tm_mon+1, ut->tm_mday, ut->tm_hour, ut->tm_min, ut->tm_sec,
        LogProgram,
        LogHost,
        LogWho
    );
    vsprintf(LogBuf + strlen(LogBuf), ctl, args);

    va_end(args);

    len = strlen(LogBuf);
    LogBuf[len++] = '\n';
    LogBuf[len] = 0;

    DEBUG(0, "%s", LogBuf);

    if (LogToStdout) {
        write(1, LogBuf, len);
        return;
    }

    if (ReLog++ == 0) {
        LockFile("LOG-UPDATE");
        if (LogFd < 0)
            LogFd = open(logFile, O_CREAT|O_WRONLY|O_APPEND, 0644);
    }

    if (LogFd >= 0)
        write(LogFd, LogBuf, len);
    else
        fprintf(stderr, "Can't open %s\n", logFile);

    if (--ReLog == 0) {
        if (LogFd >= 0 && OpenHold == 0) {
            close(LogFd);
            LogFd = -1;
        }
        UnLockFile("LOG-UPDATE");
    }
}

