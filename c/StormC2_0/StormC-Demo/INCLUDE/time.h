#ifndef _INCLUDE_TIME_H
#define _INCLUDE_TIME_H

/*
**  $VER: time.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int time_t;
typedef unsigned int clock_t;

struct tm { 
	int tm_sec, tm_min, tm_hour;
	int tm_mday, tm_mon, tm_year;
	int tm_wday, tm_yday;
	int tm_idst;
};

time_t time(time_t *);
struct tm *gmtime(const time_t *);
struct tm *localtime(const time_t *);
time_t mktime(struct tm *);

#define CLOCKS_PER_SEC 50
clock_t clock(void);
double difftime(time_t, time_t);

int strftime(char *, unsigned int, const char *, const struct tm *);
char *asctime(const struct tm *);
char *ctime(const time_t *);

#ifdef __cplusplus
}
#endif

#endif
