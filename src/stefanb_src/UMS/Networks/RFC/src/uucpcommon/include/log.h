
/*
 *  LOG.H
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 */

extern int     LogToStdout;
extern int     LogLevel;
extern char    *LogProgram;
extern char    *LogHost;
extern char    *LogWho;
extern char    *LogFile;

#define DEBUG(level, msg, moremsg)  if (LogLevel > level) printf(msg, moremsg)

