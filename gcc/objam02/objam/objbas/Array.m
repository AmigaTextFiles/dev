/*
** ObjectiveAmiga: Implementation of class Array
** See GNU:lib/libobjam/ReadMe for details
*/


#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#import "Array.h"


@implementation Array

+ (unsigned)ndxVarSize
{
  [self subclassResponsibility:@selector(ndxVarSize)];
  return 0;
}

+ new:(unsigned)nElements { return [[self alloc] init:nElements]; }

+ with:(unsigned)nArgs,...
{
  id newArray;
  unsigned i;
  va_list args;

  if(!(newArray=[self new:nArgs])) return nil;
  va_start(args,nArgs);
  for(i=0;i<nArgs;i++) [newArray add:va_arg(args,id)];
  va_end(args);

  return newArray;
}

- init { return [self init:1]; }

- init:(unsigned)nElements
{
  int size;

  if(!(self=[super init])) return nil;
  capacity=nElements;
  size=[[self class] ndxVarSize]*capacity;
  if(!(elements=malloc(size))) return [self free];
  bzero(elements,size);
  return self;
}

- free
{
  if(elements) free(elements);
  return [super free];
}

- add:dummy { return [self subclassResponsibility:@selector(ndxVarSize)]; }

- (unsigned)capacity { return capacity; }

- capacity:(unsigned)nSlots
{
  capacity=nSlots;
  if(elements=realloc(elements,[[self class] ndxVarSize]*capacity)) return self;
  else return [self free];
}

- (STR)describe
{
  [self subclassResponsibility:@selector(describe)];
  return 0;
}

- boundsViolation:(unsigned)anOffset
{
  return [self error: capacity>0 ?
    "bounds violation: %d outside range [0..%d]":
    "zero capacity array",
    anOffset, capacity-1];
}

- copy
{
  Array *newArray;
  void *newElements;
  unsigned int arraySize=[[self class] ndxVarSize]*capacity;

  if(newArray=[super copy])
  {
    if(newElements=malloc(arraySize))
    {
      memcpy(newElements,elements,arraySize);
      newArray->elements=newElements;
      return newArray;
    }
    [newArray free];
  }

  return nil;
}

- read:(TypedStream*)stream
{
  unsigned i, elementLength=[[self class] ndxVarSize];
  STR types=[self describe];

  [self init];
  [super read:stream];
  objc_read_types(stream,"I",&capacity);
  [self init:capacity];
  for(i=0;i<capacity;i++) objc_read_types(stream,types,(void *)(((unsigned)(elements))+i*elementLength));

  return self;
}

- write:(TypedStream*)stream
{
  unsigned i, elementLength=[[self class] ndxVarSize];
  STR types=[self describe];

  [super write:stream];
  objc_write_types(stream,"I",&capacity);
  for(i=0;i<capacity;i++) objc_write_types(stream,types,(void *)(((unsigned)(elements))+i*elementLength));

  return self;
}

@end
