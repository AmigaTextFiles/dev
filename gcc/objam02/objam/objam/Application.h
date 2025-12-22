/*
** ObjectiveAmiga: Interface to class Application
** See GNU:lib/libobjam/ReadMe for details
*/


// This class serves the same purpose as the similiarly named NeXTSTEP class.
// It does this in a completely different way though, because this is the only
// way that makes sense under AmigaOS. The clients of an ObjectiveAmiga
// Application will have more work to do themselves. Application simply
// notifies them when the Exec Signals they requested are set.
//
// All clients have to conform to the <ExecSignalProcessing> protocol. They
// will be asked for the signal bits they accept with -execSignals. Whenever
// one or more of these bits is set, they will receive an -execSignals:
// message with the currently set bits as an argument.
//
// Each ObjectiveAmiga application may have only *one* Application object.
// This object is called OAApp and it is defined in libobjam.a.


#import <objc/Object.h>
#import <objam/FlatList.h>


@protocol ExecSignalProcessing
- execSignals:(ULONG)sigMask;
- (ULONG)execSignals;
@end


@interface Application: Object
{
  char *appName;
  FlatList *objectList;
  ULONG sigMask;
  BOOL keepRunning;
  BOOL terminated;
  unsigned int returnCode;
}

// Creating and freeing instances

- init:(const char *)name;
- free;

// Setting up an application

- add:(id <ExecSignalProcessing>)object;
- remove:(id <ExecSignalProcessing>)object;
- (const char *)appName;

// Running the event loop

- run;
- stop:sender;
- terminate:sender;
- terminate:sender return:(unsigned int)code;

@end


extern Application *OAApp; // The global application
