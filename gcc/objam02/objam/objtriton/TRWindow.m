/*
** ObjectiveAmiga: Implementation of class TRWindow
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objtriton/TRWindow.h>
#import <objam/Application.h>


@implementation TRWindow

// Create and delete instances

- open:(ULONG)tags,...
{
  if(!(project=TR_OpenProject(__Triton_Support_App,(struct TagItem *)&tags))) return [self free];
  modalLevel=[TRApp modalLevel];
  if(![TRApp add:self]) return [self free];
  return self;
}

- openModal:(ULONG)tags,...
{
  if(!(project=TR_OpenProject(__Triton_Support_App,(struct TagItem *)&tags))) return [self free];
  modalLevel=[TRApp modalLevel]+1;
  if(![TRApp addModal:self]) return [self free];
  return self;
}

- close
{
  [TRApp remove:self];
  TR_CloseProject(project);
  project=NULL;
  return self;
}

- free
{
  if(project) [self close];
  return [super free];
}

// Provide information to TRApp

- (struct TR_Project *)project
{
  return project;
}

- (unsigned int)modalLevel
{
  return modalLevel;
}

// Process Triton messages

- tritonMessage:(struct TR_Message *)trMsg
{
  if(trMsg->trm_Class==TRMS_CLOSEWINDOW) [self free];
  return self;
}

// Lock and unlock window

- lock
{
  TR_LockProject(project);
  return self;
}

- unlock
{
  TR_UnlockProject(project);
  return self;
}

// Reactivate window

- activate
{
  struct Window *win;

  if(!(win=TR_ObtainWindow(project))) return nil;
  ActivateWindow(win);
  TR_ReleaseWindow(win);
  return self;
}

- toFront
{
  struct Window *win;

  if(!(win=TR_ObtainWindow(project))) return nil;
  WindowToFront(win);
  TR_ReleaseWindow(win);
  return self;
}

@end
