#ifndef STDLIB_H
#define STDLIB_H

#ifndef _SIZE_T_
#define _SIZE_T_
typedef unsigned long size_t;
#endif

void *malloc(size_t size);
void *calloc(size_t nmemb,size_t size);
void *realloc(void *ptr,size_t size);
void free(void *ptr);
void exit(int status);

#endif
