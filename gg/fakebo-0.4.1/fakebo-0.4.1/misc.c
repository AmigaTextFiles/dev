
#include "global.h"
#include "misc.h"

/*
 * Help the user.
 *
 */
char usage[]
= "Usage: %s [options]\n"
"\t-c\tspecify the config file. By default, FakeBO will search for its\n"
"\t\tconfig file in various places; see below the help\n"
"\t-d\tprint debugging information.\n"
"\t-i\tdebug BO packet numbers.\n"
"\t-b\tstart FakeBO as a daemon.\n"
"\t-v\tverbose mode.\n"
"\t-a\tprint info about program.\n"
"\t-h\tprint this help message.\n"
"\t-V\tprint version and exit.\n"
"\n";

/*  
   * the GNU licence
 */
char msg_about[]
= "This program is free software; you can redistribute it and/or modify\n"
"it under the terms of the GNU General Public License as published by\n"
"the Free Software Foundation; either version 2 of the License, or\n"
"(at your option) any later version.\n"
"\n"
"This program is distributed in the hope that it will be useful,\n"
"but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
"GNU General Public License for more details.\n"
"\n"
"You should have received a copy of the GNU General Public License\n"
"along with this program; if not, write to the Free Software\n"
"Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n"
"\n";

volatile int stop = FALSE;	/* for signal handling */
FILE *fptolog;

void removeunprintable(char *s, int n)
{
	int i;

	for (i = 0; i < strlen(s); i++) {
		if (isprint((int) s[i]))
			break;
		if (isspace((int) s[i]))
			break;
		if (s[i] != 0)
			break;
		s[i] = '.';
	}
}

/*
 * log contents from fmt to log file
 *
 */
char repeatbuf[MAXLOGRECSIZE];	/* buffer to compare */
int repeatcount = 0;		/* Counter for 'message repeated x times' */
void logprintf(BOOL dotime, char *fmt,...)
{
	va_list va;
	char buf[MAXLOGRECSIZE], buf2[MAXLOGRECSIZE];

	va_start(va, fmt);
	vsprintf(buf, fmt, va);
	va_end(va);

	if (strcmp(buf, repeatbuf) == 0) {
		repeatcount++;
		return;
	}
	removeunprintable(buf, sizeof(buf));

	if (repeatcount > 0) {
		if (logtimeanddate > 0) {
			whatistime(buf2);
			fprintf(fptolog, "%s Last message repeated %d time(s)\n", buf2, repeatcount);
		} else
			fprintf(fptolog, "Last message repeated %d time(s)\n", repeatcount);
		repeatcount = 0;
		memset(repeatbuf, 0, sizeof(repeatbuf));
	}
	memcpy(repeatbuf, buf, sizeof(buf));

	if (dotime && logtimeanddate > 0) {
		whatistime(buf2);
		fprintf(fptolog, "%s %s", buf2, buf);
	} else
		fprintf(fptolog, "%s", buf);
}

void syslogprintf(char *fmt,...)
{
	va_list va;
	char buf[MAXLOGRECSIZE];

	if (logtosyslog != 0) {
		va_start(va, fmt);
		vsprintf(buf, fmt, va);
		va_end(va);

#ifdef HAVE_OPENLOG
		openlog("FakeBO", LOG_CONS, LOG_USER);
		syslog(LOG_WARNING, buf);
		closelog();
#else
#warning "Can't find usable syslog, disabled!"
#endif

	}
}

/*
 * Returns the current local date and time in timenow. 
 * Here you can modify the output format
 * (default is yyyy-mm-dd hh:mm:ss)
 *   
 */
void whatistime(char *timenow)
{
	struct tm *curtime;
	time_t cartime;

	time(&cartime);
	curtime = localtime(&cartime);
	switch (logtimeanddate) {
	case 1:
		sprintf(timenow, "%02d-%02d-%04d %02d:%02d:%02d", curtime->tm_mon + 1
			,curtime->tm_mday, curtime->tm_year + 1900, curtime->tm_hour
			,curtime->tm_min, curtime->tm_sec);
		break;
	case 2:
		sprintf(timenow, "%02d.%02d.%04d %02d:%02d:%02d", curtime->tm_mday
			,curtime->tm_mon + 1, curtime->tm_year + 1900, curtime->tm_hour
			,curtime->tm_min, curtime->tm_sec);
		break;
	case 3:
		sprintf(timenow, "%04d-%02d-%02d %02d:%02d:%02d", curtime->tm_year + 1900
		 ,curtime->tm_mon + 1, curtime->tm_mday, curtime->tm_hour
			,curtime->tm_min, curtime->tm_sec);
		break;
	default:
		sprintf(timenow, "Config error (`logtimeanddate' != [0-3])!");
		break;
	}

}

/*
 * If we are running as root (EUID = 0),
 * drop root privileges and become USER.
 */
void dropprivileges(const char *user)
{
#ifdef HAVE_PWD_H
	struct passwd *entry;
	static int done = 0;

	/* Nothing to do if we are not root */
	if (done || geteuid() != 0) {
		done = 1;
		return;
	}
	/* Become user */
	entry = getpwnam(user);
	if (entry == NULL) {
		fprintf(stderr, "Warning: user %s not found, "
			"running as root!!\n", user);
		return;
	}
	if (setgid(entry->pw_gid) == -1)
		perror("setgid()");
	if (setuid(entry->pw_uid) == -1)
		perror("setuid()");
	done = 1;
#else
#warning Ignoring drop priviledges!
#endif
}
