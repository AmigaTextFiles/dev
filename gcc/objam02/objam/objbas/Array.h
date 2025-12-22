/*
** ObjectiveAmiga: Interface to class Array
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objc/Object.h>


@interface Array: Object
{
  unsigned capacity;
  void *elements;
}

+ (unsigned)ndxVarSize;
+ new:(unsigned)nElements;
+ with:(unsigned)nArgs,...;

- init;
- init:(unsigned)nElements;
- free;
- add:dummy;
- (unsigned)capacity;
- capacity:(unsigned)nSlots;
- (STR)describe;
- boundsViolation:(unsigned)anOffset;
- copy;
- read:(TypedStream*)stream;
- write:(TypedStream*)stream;

@end


/* Unimplemented:

- (BOOL)isEqual:anObject;

*/
