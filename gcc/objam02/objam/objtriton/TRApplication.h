/*
** ObjectiveAmiga: Interface to class TRApplication
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objc/Object.h>
#import <objam/Application.h>
#import <objam/FlatList.h>
#import <objam/objam.h>
#import <objtriton/TRWindow.h>

#include <libraries/triton.h>


@interface TRApplication: Object <ExecSignalProcessing>
{
  FlatList *windowList;
  unsigned int modalLevel;
}

// Create and delete instances

- initTriton:(unsigned int)trVer;
- init;

- free;

// Run the application

- runFromAppKit;
- quit;

// Add and remove windows

- add:window;
- addModal:window;
- remove:window;

// Provide information to the windows

- (unsigned int)modalLevel;

// Lock and unlock windows

- lockWindows;
- unlockWindows;

@end


extern TRApplication *TRApp;
