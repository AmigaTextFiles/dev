/*
** ObjectiveAmiga: Implementation of class IDArray
** See GNU:lib/libobjam/ReadMe for details
*/


#import "IdArray.h"


@implementation IdArray

+ (unsigned)ndxVarSize { return sizeof(id); }

- add:anObject
{
  unsigned i;
  for(i=0;i<capacity;i++)
  {
    if(((id*)elements)[i]==nil)
    {
      ((id*)elements)[i]=anObject;
      return self;
    }
  }
  return [self boundsViolation:capacity];
}

- at:(unsigned)anOffset
{
  if(anOffset>=capacity) return [self boundsViolation:anOffset];
  return ((id*)elements)[anOffset];
}

- at:(unsigned)anOffset put:anObject
{
  id oldObject;

  if(anOffset>=capacity) return [self boundsViolation:anOffset];
  oldObject=[self at:anOffset];
  ((id*)elements)[anOffset]=anObject;
  return oldObject;
}

- (STR)describe { return "@"; }

- eachElementPerform:(SEL)aSelector
{
  unsigned i;
  for(i=0;i<capacity;i++) [(((id*)elements)[i]) perform:aSelector];
  return self;
}

- eachElementPerform:(SEL)aSelector with:anArg
{
  unsigned i;
  for(i=0;i<capacity;i++) [(((id*)elements)[i]) perform:aSelector with:anArg];
  return self;
}

- eachElementPerform:(SEL)aSelector with:anArg with:anotherArg
{
  unsigned i;
  for(i=0;i<capacity;i++) [(((id*)elements)[i]) perform:aSelector with:anArg with:anotherArg];
  return self;
}

- freeContents
{
  unsigned i;
  for(i=0;i<capacity;i++)
  {
    [(((id*)elements)[i]) free];
    ((id*)elements)[i]=nil;
  }
  return self;
}

@end
