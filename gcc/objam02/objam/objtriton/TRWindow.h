/*
** ObjectiveAmiga: Interface to class TRWindow
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objtriton/TRApplication.h>

#include <libraries/triton.h>
#include <inline/triton.h>


@interface TRWindow: Object
{
  struct TR_Project *project;
  unsigned int modalLevel;
}

// Initialize and delete instances

- open:(ULONG)tags,...;
- openModal:(ULONG)tags,...;
- close;
- free;

// Provide information to TRApp

- (struct TR_Project *)project;
- (unsigned int)modalLevel;

// Process Triton messages

- tritonMessage:(struct TR_Message *)trMsg;

// Lock and unlock window

- lock;
- unlock;

// Reactivate window

- activate;
- toFront;

@end
