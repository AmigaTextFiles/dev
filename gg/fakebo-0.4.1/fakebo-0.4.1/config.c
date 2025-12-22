
#include "global.h"

/*
 * Configuration parameters and their default values. 
 *
 */
char boporttolisten[10] = "31337";
char bomessage[512] = "Your attempt of breaking into this system has been logged. You are now on the black list.";
char nbmessage[512] = "Your attempt of breaking into this system has been logged. You are now on the black list.";
char logfile[255] = "stdout";
char machinename[20] = "DEFAULT";
char bofakever[10] = "1.20";
char customrepliespath[255] = "fakebo.reply.";
char executescript[255] = "abusemail !";

int logconnection = 1;
int logreceivedpackets = 2;
int logsendingpackets = 0;
int logtosyslog = 0;
int lognotbopackets = 0;
int sendfakereply = 1;
int logtimeanddate = 1;
int silentmode = 0;
int bufferedlogging = 0;
int usecustomreplies = 0;
int toexecutescript = 0;

char nbfakever[10] = "1.60";
int nbport = 12345;
char executescriptshell[255] = "/bin/sh";
int startasdaemon = 0;
int tocrackpackets = 0;

int verboselog = 0;
int userealfakebo = 0;
int toignorehost = 0;
char ignorehost[512] = HOSTIGNORE_NONE;
char ignorehostip[36];

char user[20] = "nobody";

/*
 * This is for parsing the config file and printing debug information. 
 *
 */
char *keywords[NB_PARAMS]
=
{"boport", "bomessage", "nbmessage", "logfile", "logconnection"
 ,"logreceivedpackets", "logsendingpackets", "lognotbopackets"
 ,"sendfakereply", "machinename", "logtimeanddate", "silentmode"
 ,"bufferedlogging", "logtosyslog"
 ,"bofakever", "usecustomreplies", "customrepliespath"
 ,"toexecutescript", "executescript"
 ,"nbport", "executescriptshell", "nbfakever", "startasdaemon"
 ,"tocrackpackets", "ignorehost", "userealfakebo", "user"};

void *addresses[NB_PARAMS]
=
{boporttolisten, bomessage, nbmessage, logfile, &logconnection
 ,&logreceivedpackets, &logsendingpackets, &lognotbopackets
 ,&sendfakereply, machinename, &logtimeanddate, &silentmode
 ,&bufferedlogging, &logtosyslog
 ,bofakever, &usecustomreplies, customrepliespath
 ,&toexecutescript, executescript
 ,&nbport, executescriptshell, nbfakever, &startasdaemon
 ,&tocrackpackets, ignorehost, &userealfakebo, user};

char *in_formats[NB_PARAMS]
=
{"%s", "\"%[^\"]\"", "\"%[^\"]\"", "\"%[^\"]\"", "%d", "%d", "%d",
 "%d", "%d"
 ,"\"%[^\"]\"", "%d", "%d", "%d", "%d"
 ,"\"%[^\"]\"", "%d", "\"%[^\"]\"", "%d", "%[^\n]"
 ,"%d", "\"%[^\"]\"", "\"%[^\"]\"", "%d"
 ,"%d", "\"%[^\"]\"", "%d", "\"%[^\"]\""};

char *out_formats[NB_PARAMS]
=
{"%s", "\"%s\"", "\"%s\"", "%s", "%d", "%d", "%d", "%d", "%d", "%s", "%d"
 ,"%d", "%d", "%d"
 ,"%s", "%d", "%s", "%d", "%s"
 ,"%d", "%s", "%s", "%d"
 ,"%d", "%s", "%d", "%s"};
