/*
** ObjectiveAmiga: Implementation of class FileList
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/FileList.h>
#include <proto/exec.h>


@implementation FileList

// Parse a directory and add its contents to the list

- addDirectory:(const char *)dirName
{
  struct FileInfoBlock *fib;
  BPTR lock;
  id retval=nil;

  if(lock=Lock(dirName,ACCESS_READ))
  {
    if(fib=(struct FileInfoBlock *)AllocDosObject(DOS_FIB,NULL))
    {
      if(Examine(lock,fib))
      {
	retval=self;
	while(ExNext(lock,fib)) if(![self addFile:(const char *)(fib->fib_FileName)]) retval=nil;
      }
      FreeDosObject(DOS_FIB,(void *)fib);
    }
    UnLock(lock);
  }

  return retval;
}

// Add a file

- addFile:(const char *)fileName
{
  return [self addNodeNamed:fileName] ? self : nil;
}

@end
