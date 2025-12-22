/*
   stcc.h

   bf 12-8-96
*/

#if defined (__GNUC__)
extern char *stpcpy (char *str, char *add);
#endif

typedef struct Node Node;
typedef struct List List;

#define LBUFSIZE   1024
#define MAXPATHLEN 1024
