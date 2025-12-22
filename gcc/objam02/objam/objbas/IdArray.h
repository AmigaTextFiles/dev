/*
** ObjectiveAmiga: Interface to class IDArray
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objbas/Array.h>


@interface IdArray: Array

+ (unsigned)ndxVarSize;

- add:anObject;
- at:(unsigned)anOffset;
- at:(unsigned)anOffset put:anObject;
- (STR)describe;
- eachElementPerform:(SEL)aSelector;
- eachElementPerform:(SEL)aSelector with:anArg;
- eachElementPerform:(SEL)aSelector with:anArg with:anotherArg;
- freeContents;

@end


/* Unimplemented:

- (BOOL)contains:anObject;
- (BOOL)isEqual:anObject;
- (unsigned)hash;
- (unsigned)offsetMatching:anObject;
- (unsigned)offsetOf:anObject;
- (unsigned)offsetSTR:(STR)aStr;
- addContentsTo:aCollection;
- asIdArray;
- at:(unsigned)anOffset insert:anObject;
- addContentsOf:aCollection;
- packContents;
- eachElement;
- exchange:(unsigned)anOffset and:(unsigned)anotherOffset;
- find:anObject;
- findMatching:anObject;
- findSTR:(STR)aStr;
- remove:anObject;
- removeAt:(unsigned)anOffset;
- removeContentsFrom:aTbl;
- sort;

*/
