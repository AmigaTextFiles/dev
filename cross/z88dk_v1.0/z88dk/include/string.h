#ifndef STRINGS_H
#define STRINGS_H


/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE

/* Prototyping..sigh! */

extern strlen(char *);
extern char *strcat(char *, char *);
extern strcmp(char *, char *);
extern char *strcpy(char *, char *);
extern char *strncat(char *, char *);
extern strncmp(char *, char *, int);
extern char *strncpy(char *, char *, int);
extern reverse(char *);

extern char *strchr(char *, int);
extern char *strrchr(char *, int);
extern char *strrstrip(char *, int);
extern char *strstrip(char *, int);
extern char *strstr(char *, char *);
extern char *strrstr(char *, char *);
extern char *strtok(char *, char *);
extern char *strpbrk(char *, char *);
extern strpos(char *, int);
extern strcspn(char *, char *);
extern strspn(char *, char *);
extern stricmp(char *, char *);
extern strnicmp(char *, char *,int);

extern char *strlwr(char *);
extern char *strupr(char *);



#pragma unproto HDRPRTYPE


#endif
