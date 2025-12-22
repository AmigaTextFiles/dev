/*
** ObjectiveAmiga: Implementation of class String
** See GNU:lib/libobjam/ReadMe for details
*/


#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#import "String.h"


@implementation String

+ str:(const char *)aStr { return [[[self alloc] init] str:aStr]; }

- free { if(string) free(string); return self; }

- (const char *)str { return string; }

- str:(const char *)aStr
{
  if(!aStr) { free(string); length=0; string=0; return self; }
  if(string) free(string);
  length=strlen(aStr)+1;
  string=malloc(length);
  strcpy(string,aStr);
  return self;
}

- (int)asInt { return atoi(string); }

- (long)asLong { return atol(string); }

- read:(TypedStream*)stream
{
  [super read:stream];
  objc_read_types(stream,"I",&length);
  // if(length)
  // {
  //  string=malloc(length);
  objc_read_types(stream,"*",&string);
  // }
  return self;
}

- write:(TypedStream*)stream
{
  [super write:stream];
  objc_write_types(stream,"I",&length);
  if(length) objc_write_types(stream,"*",&string);
  return self;
}

@end


// String support functions:
//
// These are similar to their ANSI equivalents, but support
// nil pointers.

static unsigned slen(char *a) { return a? strlen(a):0; }
static char *scopy(char *a, char *b) { return (a&&b)? strcpy(a,b):0; }
static char *sncopy(char *a, char *b, unsigned n) { return (a&&b)? strncpy(a,b,n):0; }
static char *scat(char *a, char *b) { return (a&&b)? strcat(a,b):0; }
static char *sncat(char *a, unsigned n, char *b, unsigned m)  { return (a&&b)? strncat(a,b,n):0; }
static int scmp(char *a, char *b) { return (a&&b)? strcmp(a,b):0; }
static void slower(char *a) { int i; if(a) for(i=strlen(a);i--;) a[i]=tolower(a[i]); }
static void supper(char *a) { int i; if(a) for(i=strlen(a);i--;) a[i]=toupper(a[i]); }
