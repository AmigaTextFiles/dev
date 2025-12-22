/*
** ObjectiveAmiga: Interface to class RexxHost
** See GNU:lib/libobjam/ReadMe for details
*/


// This class provides an easy way to add an ARexx host to any ObjectiveAmiga
// application. Simply create a descendant of RexxHost with the desired ARexx
// command methods (called '-rxc<UPPER_CASE_COMMAND_NAME>' and run it through
// your Application object (-runFromAppKit).


#include <exec/ports.h>
#include <exec/types.h>
#include <dos/rdargs.h>
#include <rexx/errors.h>

#import <objc/Object.h>
#import <objam/Application.h>


@interface RexxHost: Object <ExecSignalProcessing>
{
  @private
  struct RexxMsg *currentMsg;
  char *currentArgs;
  char *hostName;
  char *extensionName;
  struct MsgPort *msgPort;
  ULONG sigMask;
  BOOL doQuit;
  BOOL openedRexxSysBase;
  LONG messagesSent;
  BOOL refused;
  struct RDArgs *rdArgs;
  BOOL freeArgs;
  BOOL argsFailed;
  char *tmpArgs;
  BOOL runningFromAppKit;
}

// Create and delete instances

- initHost:(char *)newHost suffix:(char *)newExtension;
- initHost:(char *)newHost;
- free;

// Control methods

- run;
- runFromAppKit;
- quit;
- (ULONG)sigMask;
- handleRexxMsg;
- sendRexxCmd:(char *)cmd;
- (struct RexxMsg *)sendRexxMsg:(char *)s msg:(struct RexxMsg *)m flags:(LONG)flags;

// ARexx command support methods

- replyRexxCmd:(char *)s rc:(LONG)rc;
- refuseRexxCmd;
- readArgs:(LONG *)args tpl:(char *)template;

// Default ARexx commands

- (void)rxcQUIT;

@end
