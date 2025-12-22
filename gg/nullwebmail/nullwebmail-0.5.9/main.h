/*
    webmail -- simple pop3/smtp web e-mail cgi
    Copyright (C) 2000-2001 Dan Cahill

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>
#ifdef WIN32
	#pragma comment(lib, "wsock32.lib")
	#include <winsock.h>
	#include <io.h>
	#include <sys/timeb.h>
	#define snprintf _snprintf
	#define vsnprintf _vsnprintf
	#define strcasecmp stricmp
	#define strncasecmp strnicmp
#else
	#include <dirent.h>
	#include <netdb.h>
	#include <paths.h>
	#include <signal.h>
	#include <unistd.h>
	#include <netinet/in.h>
	#include <sys/resource.h>
	#include <sys/socket.h>
	#include <sys/time.h>
	#include <sys/types.h>
	#include <sys/wait.h>
#endif
#include "config.h"

typedef struct {
	char ClientIP[16];
	char Connection[128];
	int  ContentLength;
	char ContentType[128];
	char Cookie[1024];
	char Host[64];
	char PathInfo[128];
	char *PostData;
	char QueryString[1024];
	char Referer[128];
	char RequestMethod[8];
	char RequestURI[1024];
	char ScriptName[128];
	char UserAgent[128];
} request_struct;
request_struct request;
extern char **environ;
char wmusername[64];
char wmpassword[64];
char wmpop3server[64];
char wmsmtpserver[64];

/* main.c stuff */
void printheader(void);
void printfooter(void);
/* cgi-lib.c functions */
int IntFromHex(char *pChars);
void URLDecode(unsigned char *pEncoded);
char *str2html(char *instring);
void ReadPOSTData(void);
char *getgetenv(char *query);
char *getmimeenv(char *query);
char *getpostenv(char *query);
char *get_mime_type(char *name);
char *strcasestr(char *src, char *query);
void striprn(char *string);
/* webmail.c functions */
void wmcookieget(void);
int  wmcookieset(void);
void wmcookiekill(void);
void wmexit(void);
int  webmailconnect(void);
void webmaildisconnect(void);
void webmailread(void);
void webmailraw(void);
void webmailfiledl(void);
void webmailwrite(void);
void webmaillist(void);
void webmailsend(void);
void webmaildelete(void);
