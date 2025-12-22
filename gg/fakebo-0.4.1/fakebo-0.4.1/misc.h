#ifndef MISC_H
#define MISC_H

extern char usage[];
extern char msg_about[];
extern volatile int stop;
extern FILE *fptolog;

extern char repeatbuf[MAXLOGRECSIZE];
extern int repeatcount;

void logprintf(BOOL dotime, char *fmt,...);
void syslogprintf(char *fmt,...);
void removeunprintable(char *s, int n);
void whatistime(char *timenow);
void dropprivileges(const char *user);

#endif
