

#ifndef GLOBAL_H
#define GLOBAL_H

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <stdarg.h>
#include <ctype.h>

#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif
#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#include <sys/types.h>
#include <sys/socket.h>
#ifdef HAVE_SYS_SELECT_H
#include <sys/select.h>
#endif
#ifdef TIME_WITH_SYS_TIME
#include <sys/time.h>
#include <time.h>
#else
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#else
#include <time.h>
#endif
#endif

#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif

#include <netinet/in.h>
#include <netdb.h>

#ifdef HAVE_NETINET_TCP_H
#include <netinet/tcp.h>
#endif
#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#ifdef HAVE_SYSLOG_H
#include <syslog.h>
#endif

#ifdef HAVE_GETOPT_H
#include <getopt.h>
#endif

#ifdef MEMWATCH
#include "memwatch.h"
#endif

#define BOOL int
#define TRUE 1
#define FALSE 0

#define NB_PARAMS 27		/* number of parameters */
#define LINE_SIZE 1024		/* in the config file */
#define MAXLOGRECSIZE 2048	/* maximum log record size */

#define HOSTIGNORE_NONE      "NONE"


/*
 * we use some GCC magic so that structures doesn't align...
 */
#ifdef HAVE_ATTRIB_PACKED
#define attpack __attribute__((packed))
#else
#define attpack
#endif


typedef unsigned char byte;

/*
 * Configuration parameters and their default values. 
 *
 */
extern char boporttolisten[10];
extern char bomessage[512];
extern char nbmessage[512];
extern char logfile[255];
extern char machinename[20];
extern char bofakever[10];
extern char customrepliespath[255];
extern char executescript[255];

extern int logconnection;
extern int logreceivedpackets;
extern int logsendingpackets;
extern int logtosyslog;
extern int lognotbopackets;
extern int sendfakereply;
extern int logtimeanddate;
extern int silentmode;
extern int bufferedlogging;
extern int usecustomreplies;
extern int toexecutescript;

extern char nbfakever[10];
extern int nbport;
extern char executescriptshell[255];
extern int startasdaemon;
extern int tocrackpackets;

extern int verboselog;
extern int userealfakebo;
extern int toignorehost;
extern char ignorehost[512];
extern char ignorehostip[36];
extern char user[20];

/*
 * This is for parsing the config file and printing debug information. 
 *
 */
extern char *keywords[NB_PARAMS];
extern void *addresses[NB_PARAMS];
extern char *in_formats[NB_PARAMS];

#endif
