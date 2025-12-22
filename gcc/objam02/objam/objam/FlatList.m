/*
** ObjectiveAmiga: Implementation of class FlatList
** (compatible with NeXTSTEP's class List)
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/FlatList.h>


@implementation FlatList

// Initializing a new List object

- init
{
  return [self initCount:1];
}

- initCount:(unsigned int)numSlots
{
  if(!([super init])) return nil;
  if(!(dataPtr=NXZoneCalloc([self zone],numSlots,sizeof(id)))) return nil;
  maxElements=numSlots;
  return self;
}

// Copying and freeing a list

- copyFromZone:(NXZone *)zone
{
  FlatList *newList;
  if(!(newList=[super copyFromZone:zone])) return nil;
  if(!(newList->dataPtr=NXZoneCalloc(zone,maxElements,sizeof(id)))) return nil;
  CopyMem(dataPtr,newList->dataPtr,maxElements*sizeof(id));
  return newList;
}

- free
{
  if(dataPtr) free(dataPtr);
  return [super free];
}

// Manipulating objects by index

- insertObject:anObject at:(unsigned int)index
{
  if(index==numElements) return [self addObject:anObject];
  if(!anObject) return nil;
  if(index>numElements) return nil;
  if(numElements==maxElements) if(![self setAvailableCapacity:maxElements*2]) return nil;
  CopyMem(&dataPtr[index],&dataPtr[index+1],(numElements-index)*sizeof(id));
  dataPtr[index]=anObject;
  numElements++;
  return self;
}

- removeObjectAt:(unsigned int)index
{
  if(index==numElements-1) return [self removeLastObject];
  if(index>=numElements) return nil;
  CopyMem(&dataPtr[index+1],&dataPtr[index],(numElements-index)*sizeof(id));
  numElements--;
  return self;
}


- removeLastObject
{
  if(!numElements) return nil;
  return dataPtr[--numElements];
}

- replaceObjectAt:(unsigned int)index with:newObject
{
  id oldObject;
  if(index>=numElements) return nil;
  if(!newObject) return nil;
  oldObject=dataPtr[index];
  dataPtr[index]=newObject;
  return oldObject;
}

- lastObject
{
  if(!numElements) return nil;
  return dataPtr[numElements-1];
}

- objectAt:(unsigned int)index
{
  if(index>=numElements) return nil;
  return dataPtr[index];
}

- (unsigned int)count
{
  return numElements;
}

// Manipulating objects by id

- addObject:anObject
{
  if(!anObject) return nil;
  if(numElements==maxElements) if(![self setAvailableCapacity:maxElements*2]) return nil;
  dataPtr[numElements]=anObject;
  numElements++;
  return self;
}

- addObjectIfAbsent:anObject
{
  if(!anObject) return nil;
  if([self indexOf:anObject]!=NX_NOT_IN_LIST) return self;
  if([self addObject:anObject]) return self;
  return nil;
}

- removeObject:anObject
{
  unsigned int index;
  if((index=[self indexOf:anObject])==NX_NOT_IN_LIST) return nil;
  return [self removeObjectAt:index];
}

- replaceObject:anObject with:newObject
{
  unsigned int index;
  if(!newObject) return nil;
  if((index=[self indexOf:anObject])==NX_NOT_IN_LIST) return nil;
  return [self replaceObjectAt:index with:newObject];
}

- (unsigned int)indexOf:anObject
{
  int i;
  if(!numElements) return NX_NOT_IN_LIST;
  for(i=0;i<numElements;i++) if(dataPtr[i]==anObject) return i;
  return NX_NOT_IN_LIST;
}

// Comparing and combining Lists

- (BOOL)isEqual:anObject
{
  int i;
  if(anObject==self) return YES;
  if([anObject class]!=[self class]) return NO;
  if([anObject count]!=numElements) return NO;
  for(i=0;i<numElements;i++) if([anObject objectAt:i]!=dataPtr[i]) return NO;
  return YES;
}

- appendList:(FlatList*)otherList
{
  unsigned int i,otherNum,oldNum=numElements;
  if(!(otherNum=[otherList count])) return self;
  for(i=0;i<otherNum;i++) if(![self addObject:[otherList objectAt:i]])
  {
    numElements=oldNum;
    return nil;
  }
  return self;
}

// Emptying a List

- empty
{
  numElements=0;
  return self;
}

- freeObjects
{
  unsigned int i, num;
  SEL aSelector=@selector(free);

  for(num=numElements,i=0;(i<num)&&num;)
  {
    [dataPtr[i] perform:aSelector];
    if(num==numElements) i++;
    else num--;
  }
  [self empty];
  return self;
}

// Sending messages to the objects

- makeObjectsPerform:(SEL)aSelector
{
  int i;
  for(i=0;i<numElements;i++) [dataPtr[i] perform:aSelector];
  return self;
}

- makeObjectsPerform:(SEL)aSelector with:anObject
{
  int i;
  for(i=0;i<numElements;i++) [dataPtr[i] perform:aSelector with:anObject];
  return self;
}

- makeObjectsPerform:(SEL)aSelector with:anObject with:anotherObject // ObjectiveAmiga only
{
  int i;
  for(i=0;i<numElements;i++) [dataPtr[i] perform:aSelector with:anObject with:anotherObject];
  return self;
}

// Managing the storage capacity

- (unsigned int)capacity
{
  return maxElements;
}

- setAvailableCapacity:(unsigned int)numSlots
{
  id *newPtr;
  if(numSlots<numElements) return nil;
  if(numSlots<=maxElements) return self;
  if(!(newPtr=NXZoneRealloc([self zone],dataPtr,numSlots*sizeof(id)))) return nil;
  dataPtr=newPtr;
  maxElements=numSlots;
  return self;
}

// Archiving

- read:(NXTypedStream*)stream
{
  unsigned int i, num;
  [self init];
  [super read:stream];
  NXReadTypes(stream,"I",&num);
  for(i=0;i<num;i++) [self addObject:NXReadObject(stream)];
  return self;
}

- write:(NXTypedStream*)stream
{
  unsigned int i;
  [super write:stream];
  NXWriteTypes(stream,"I",&numElements);
  for(i=0;i<numElements;i++) if(!(NXWriteObject(stream,dataPtr[i]))) return nil;
  return self;
}

@end
