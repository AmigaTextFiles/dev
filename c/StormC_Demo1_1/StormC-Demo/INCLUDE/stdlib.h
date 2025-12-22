#ifndef _INCLUDE_STDLIB_H
#define _INCLUDE_STDLIB_H

/*
**  $VER: stdlib.h 1.01 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned size_t;
typedef int wchar_t;

#ifndef NULL
#define NULL 0
#endif

#ifndef ERANGE
#define ERANGE 1000
#endif

#ifndef HUGE_VAL
#define HUGE_VAL 1.797693134862316E+308
#endif

typedef struct {
	int quot;
	int rem;
} div_t;

typedef struct {
	long quot;
	long rem;
} ldiv_t;

double atof(const char *);
int atoi(const char *);
long atol(const char *);
long long atoll(const char *);
double strtod(const char *, char **);
long strtol(const char *, char **, int);
unsigned long strtoul(const char *, char **, int);
long long strtoll(const char *, char **, int);
unsigned long long strtoull(const char *, char **, int);

#ifdef _INLINE_INCLUDES
__inline int abs(int i) { return i < 0 ? -i : i; };
__inline long int labs(long int i) { return i < 0 ? -i : i; };
__inline long long int llabs(long long int i) { return i < 0 ? -i : i; };
#else
int abs(int);
long int labs(long int);
long long int llabs(long long int);
#endif
div_t div(int, int);
ldiv_t ldiv(long, long);

#define RAND_MAX 0x7fff
int rand( void );
void srand(unsigned);

void *calloc(size_t , size_t);
void free(void *);
void *malloc(size_t);
void *realloc(void *, size_t);

void abort(void);
int atexit(void (*)(void));
void exit(int);

char *getenv(const char *);
int system(const char *);

void *bsearch(const void *, const void *, size_t, size_t, int (*)(const void *, const void *));
void qsort(void *, size_t, size_t, int (*)(const void *, const void *));

#ifdef __cplusplus
}
#endif

#endif
