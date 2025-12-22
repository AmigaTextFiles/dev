/*
** ObjectiveAmiga: Interface to class FlatList
** (compatible with NeXTSTEP's class List)
** See GNU:lib/libobjam/ReadMe for details
*/


// This general purpose list class is fully API compatible with NeXTSTEP's List
// class (it has been renamed to FlatList in order to avoid conflicts with
// Exec's 'struct List' in C++ mode). See the NeXTSTEP General Reference Manual,
// Volume 1, for detailed documentation.


#import <objc/Object.h>


#define NX_NOT_IN_LIST ((unsigned int)(-1))


@interface FlatList: Object
{
  id *dataPtr;
  unsigned int numElements;
  unsigned int maxElements;
}

// Initializing a new List object

- init;
- initCount:(unsigned int)numSlots;

// Copying and freeing a list

- copyFromZone:(NXZone *)zone;
- free;

// Manipulating objects by index

- insertObject:anObject at:(unsigned int)index;
- removeObjectAt:(unsigned int)index;
- removeLastObject;
- replaceObjectAt:(unsigned int)index with:newObject;
- lastObject;
- objectAt:(unsigned int)index;
- (unsigned int)count;

// Manipulating objects by id

- addObject:anObject;
- addObjectIfAbsent:anObject;
- removeObject:anObject;
- replaceObject:anObject with:newObject;
- (unsigned int)indexOf:anObject;

// Comparing and combining Lists

- (BOOL)isEqual:anObject;
- appendList:(FlatList*)otherList;

// Emptying a List

- empty;
- freeObjects;

// Sending messages to the objects

- makeObjectsPerform:(SEL)aSelector;
- makeObjectsPerform:(SEL)aSelector with:anObject;
- makeObjectsPerform:(SEL)aSelector with:anObject with:anotherObject; // ObjectiveAmiga only

// Managing the storage capacity

- (unsigned int)capacity;
- setAvailableCapacity:(unsigned int)numSlots;

// Archiving

- read:(NXTypedStream*)stream;
- write:(NXTypedStream*)stream;

@end
