/*
** ObjectiveAmiga: Implementation of class TRApplication
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objtriton/TRApplication.h>

#include <exec/types.h>
#include <inline/triton.h>


@implementation TRApplication

// Create and delete instances

- initTriton:(unsigned int)trVer
{
  if(![super init]) return nil;
  if(!TR_OpenTriton(trVer,TRCA_Name,[OAApp appName])) return [self free];
  if(!(windowList=[FlatList new])) return [self free];
  return self;
}

- init
{
  return [self initTriton:0];
}

- free
{
  if(windowList) [[windowList freeObjects] free];
  TR_CloseTriton();
  return [super free];
}

// Run the application

- runFromAppKit
{
  return [OAApp add:self];
}

- quit
{
  return [OAApp remove:self];
}

// Protocol <ExecSignalProcessing>

- execSignals:(ULONG)sigMask
{
  struct TR_Message *trMsg;
  int i;
  id window;
  BOOL dispatched=NO;

  while(trMsg=TR_GetMsg(__Triton_Support_App))
  {
    for(i=0;(!dispatched) && (i<[windowList count]);i++)
    {
      if([(window=[windowList objectAt:i]) project]==trMsg->trm_Project)
      {
	[window tritonMessage:trMsg];
	dispatched=YES;
      }
    }
    TR_ReplyMsg(trMsg);
  }
  return self;
}

- (ULONG)execSignals
{
  return __Triton_Support_App->tra_BitMask;
}

// Add and remove windows

- add:window
{
  if(![windowList addObject:window]) return nil;
  return self;
}

- addModal:window
{
  int i;
  id win;

  if(![windowList addObject:window]) return nil;

  for(i=0;i<[windowList count];i++)
  {
    win=[windowList objectAt:i];
    if([win modalLevel]==modalLevel) [win lock];
  }
  modalLevel++;

  return self;
}

- remove:window
{
  int i;
  id win;
  unsigned int newModalLevel=0, winModalLevel;

  [windowList removeObject:window];

  for(i=0;i<[windowList count];i++)
  {
    winModalLevel=[[windowList objectAt:i] modalLevel];
    newModalLevel=max(winModalLevel,newModalLevel);
  }
  if(newModalLevel<modalLevel)
  {
    for(i=0;i<[windowList count];i++)
    {
      win=[windowList objectAt:i];
      if([win modalLevel]==newModalLevel) [win unlock];
    }
    modalLevel=newModalLevel;
  }

  return self;
}

// Provide information to the windows

- (unsigned int)modalLevel
{
  return modalLevel;
}

// Lock and unlock windows

- lockWindows
{
  [windowList makeObjectsPerform:@selector(lock)];
  return self;
}

- unlockWindows
{
  [windowList makeObjectsPerform:@selector(unlock)];
  return self;
}

@end


TRApplication *TRApp;
