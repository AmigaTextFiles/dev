/*
** ObjectiveAmiga: Interface to class String
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objc/Object.h>


@interface String: Object
{
  unsigned length;
  char *string;
}

+ str:(const char *)aStr;

- free;
- (const char *)str;
- str:(const char *)aStr;
- (int)asInt;
- (long)asLong;
- read:(TypedStream*)stream;
- write:(TypedStream*)stream;

@end


/* Unimplemented:

+ sprintf:(STR)fmt, STR firstArg...;

- (BOOL)isEqual:anObject;
- (BOOL)isEqualSTR:(STR)aStr;
- (char)charAt:(unsigned)anOffset put:(char)aChar;
- (char)charAt:(unsigned)anOffset;
- (double)asFloat;
- (int)compare:anObject;
- (int)compareSTR:(STR)aStr;
- (unsigned)hash;
- concat:anObject;
- concatSTR:(STR)aStr;
- sort
- (STR)strcat:(STR)aBuf;

*/


// String support functions:
//
// These are similar to their ANSI equivalents, but support
// nil pointers.

static unsigned slen(char *a);
static char *scopy(char *a, char *b);
static char *sncopy(char *a, char *b, unsigned n);
static char *scat(char *a, char *b);
static char *sncat(char *a, unsigned n, char *b, unsigned m);
static int scmp(char *a, char *b);
static void slower(char *a);
static void supper(char *a);
