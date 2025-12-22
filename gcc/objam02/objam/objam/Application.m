/*
** ObjectiveAmiga: Implementation of class Application
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/Application.h>


id OAApp; // The global application


@implementation Application

// Creating and freeing instances

- init:(const char *)name
{
  if(![super init]) return nil;
  if(!(appName=NXCopyStringBufferFromZone(name,[self zone]))) return [self free];
  if(!(objectList=[FlatList new])) return [self free];
  return self;
}

- free
{
  [[objectList freeObjects] free];
  return [super free];
}

// Setting up an application

- add:(id <ExecSignalProcessing>)object
{
  if(!([objectList addObject:object])) return nil;
  sigMask|=[object execSignals];
  return self;
}

- remove:(id <ExecSignalProcessing>)object
{
  [objectList removeObject:object];
  return self;
}

- (const char *)appName
{
  return appName;
}

// Running the event loop

- run
{
  ULONG receivedMask;
  SEL execSigSel=@selector(execSignals:);
  int i;
  unsigned int numElements;

  keepRunning=YES;
  while(keepRunning)
  {
    receivedMask=Wait(sigMask);
    // We'll now do [objectList makeObjectsPerform:execSigSel with:(id)receivedMask],
    // but we have to take care not to leave out objects when an object has removed
    // itself from the list while we're parsing it.
    numElements=[objectList count];
    for(i=0;i<numElements;)
    {
      [[objectList objectAt:i] perform:execSigSel with:(id)receivedMask];
      if(numElements==[objectList count]) i++;
      else numElements--;
    }
  }
  if(!terminated) return self;
  [self free];
  exit(returnCode);
}

- stop:sender
{
  keepRunning=NO;
  return self;
}

- terminate:sender
{
  keepRunning=NO;
  terminated=YES;
  return self;
}

- terminate:sender return:(unsigned int)code
{
  returnCode=code;
  return [self terminate:sender];
}

@end
