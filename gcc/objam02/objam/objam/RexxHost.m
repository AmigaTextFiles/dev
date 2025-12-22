/*
** ObjectiveAmiga: Implementation of class RexxHost
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/RexxHost.h>

#include <objc/objc-api.h>

#include <exec/types.h>
#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include <rexx/rexxio.h>
#include <rexx/rxslib.h>
#include <rexx/errors.h>

#define __NOLIBBASE__
#include <proto/rexxsyslib.h>
#undef __NOLIBBASE__

#include <string.h>
#include <ctype.h>


static struct Library *RexxSysBase;


@implementation RexxHost

- initHost:(char *)newHost suffix:(char *)newExtension
{
  if(!([super init])) return [self free];

  if(!RexxSysBase)
  {
    RexxSysBase=OpenLibrary(RXSNAME,0);
    if(!RexxSysBase) return [self free];
    openedRexxSysBase=YES;
  }

  if(!(hostName=NXZoneMalloc([self zone],strlen(newHost)+1))) return [self free];
  strcpy(hostName,newHost);
  if(!(extensionName=NXZoneMalloc([self zone],strlen(newExtension)+1))) return [self free];
  strcpy(extensionName,newExtension);

  Forbid();
  if(FindPort(hostName))
  {
    Permit();
    return [self free];
  }
  msgPort=CreatePort(hostName,0L);
  Permit();
  if(!msgPort) return [self free];
  sigMask=1L<<msgPort->mp_SigBit;

  if(!(rdArgs=(struct RDArgs *)AllocDosObject(DOS_RDARGS,NULL))) return [self free];
  rdArgs->RDA_DAList=NULL;
  rdArgs->RDA_Flags=RDAF_NOPROMPT;

  return self;
}

- initHost:(char *)newHost
{
  return [self initHost:newHost suffix:"rexx"];
}

- free
{
  if(runningFromAppKit) [OAApp remove:self];
  if(rdArgs) FreeDosObject(DOS_RDARGS,(void *)rdArgs);
  if(msgPort) DeletePort(msgPort);
  if(extensionName) NXZoneFree([self zone],extensionName);
  if(hostName) NXZoneFree([self zone],hostName);
  if(RexxSysBase&&openedRexxSysBase)
  {
    CloseLibrary(RexxSysBase);
    RexxSysBase=NULL;
    openedRexxSysBase=NO;
  }

  return [super free];
}

// This message starts the ARexx host synchronously
- run
{
  while((!doQuit)||messagesSent)
  {
    Wait(sigMask);
    [self handleRexxMsg];
  }
  return self;
}

// This message starts the ARexx host asynchronously
- runFromAppKit
{
  if([OAApp add:self])
  {
    runningFromAppKit=YES;
    return self;
  }
  else return nil;
}

// Send this message in order to shut down the ARexx host as soon as possible
- quit
{
  doQuit=YES;
  if(runningFromAppKit)
  {
    [OAApp remove:self];
    runningFromAppKit=NO;
  }
  return self;
}

// This method returns the Exec signal mask for external
// activation of the ARexx message processing loop
- (ULONG)sigMask
{
  return sigMask;
}

// This method has to be called
// when a signal in sigMask is set.
- handleRexxMsg
{
  struct RexxMsg *rexxMsg;
  char *p;
  char cmdString[30];
  SEL cmdSel;
  int i,j;

  while(rexxMsg=(struct RexxMsg *)GetMsg(msgPort))
  {
    if(rexxMsg->rm_Node.mn_Node.ln_Type==NT_REPLYMSG)
    {
      if(rexxMsg->rm_Args[15]) ReplyMsg((struct Message *)rexxMsg->rm_Args[15]);
      DeleteArgstring(rexxMsg->rm_Args[0]);
      DeleteRexxMsg(rexxMsg);
      messagesSent--;
    }
    else
    {
      p=(char *)rexxMsg->rm_Args[0];
      while(*p>0 && *p<=' ') p++;
      rexxMsg->rm_Result1=0;
      rexxMsg->rm_Result2=0;

      strcpy(cmdString,"rxc");
      for(i=3,j=0;(p[j]!=' ')&&(p[j]!=0)&&(i<27);i++,j++) cmdString[i]=p[j];
      cmdString[i++]=0;
      cmdSel=sel_get_uid(cmdString);

      currentMsg=rexxMsg;
      currentArgs=&p[j];

      if([self respondsTo:cmdSel])
      {
	refused=NO;
	[self perform:cmdSel];
	if(!refused) ReplyMsg((struct Message *)rexxMsg);
      }
      else refused=YES;

      if(refused)
      {
	if(![self sendRexxMsg:rexxMsg->rm_Args[0] msg:rexxMsg flags:0])
	{
	  [self replyRexxCmd:NULL rc:RC_FATAL];
	  ReplyMsg((struct Message *)rexxMsg);
	}
      }
      else if(argsFailed)
      {
	[self replyRexxCmd:"Bad args." rc:RC_ERROR];
	argsFailed=NO;
      }

      if(freeArgs)
      {
	FreeArgs(rdArgs);
	freeArgs=NO;
      }
    }
  }

  return self;
}

// This method sends a command to ARexx
- sendRexxCmd:(char *)cmd
{
  if([self sendRexxMsg:cmd msg:NULL flags:0]) return self;
  else return nil;
}

- replyRexxCmd:(char *)s rc:(LONG)rc;
{
  currentMsg->rm_Result1=rc;
  if((currentMsg->rm_Action & (1L<<RXFB_RESULT)) && s)
    currentMsg->rm_Result2=(long)CreateArgstring(s,strlen(s));
  else currentMsg->rm_Result2=0L;

  return self;
}

- (struct RexxMsg *)sendRexxMsg:(char *)s msg:(struct RexxMsg *)m flags:(LONG)flags
{
  struct MsgPort *rexxPort;
  struct RexxMsg *localMsg=NULL;

  if(!(localMsg=CreateRexxMsg(msgPort,extensionName,msgPort->mp_Node.ln_Name))) return NULL;
  if(localMsg->rm_Args[0]=CreateArgstring(s,(LONG)strlen(s)))
  {
    localMsg->rm_Action=RXCOMM|flags;
    localMsg->rm_Args[15]=(STRPTR)m;
    Forbid();
    if(rexxPort=FindPort("REXX")) PutMsg(rexxPort,(struct Message *)localMsg);
    Permit();
    if(rexxPort) { messagesSent++; return localMsg; }
  }
  if(localMsg->rm_Args[0]) DeleteArgstring(localMsg->rm_Args[0]);
  DeleteRexxMsg(localMsg);
  return NULL;
}

// Send this message from within an ARexx command method in
// order to refuse the command as if it were not implemented.
- refuseRexxCmd
{
  refused=YES;
  return self;
}

// Parse command arguments with dos.library/ReadArgs().
- readArgs:(LONG *)args tpl:(char *)template
{
  int argLen=strlen(currentArgs);
  struct RDArgs *success;

  if(!(tmpArgs=(char *)NXZoneMalloc([self zone],argLen+2))) return nil;

  sprintf(tmpArgs,"%s\n",currentArgs);

  rdArgs->RDA_Source.CS_Buffer=tmpArgs;
  rdArgs->RDA_Source.CS_Length=argLen+1;
  rdArgs->RDA_Source.CS_CurChr=0;
  rdArgs->RDA_Buffer=NULL;

  success=ReadArgs(template,args,rdArgs);

  NXZoneFree([self zone],(void *)tmpArgs);

  if(success)
  {
    freeArgs=YES;
    return self;
  }
  else
  {
    argsFailed=YES;
    return nil;
  }
}

// Shut down the ARexx host ASAP.
- (void)rxcQUIT;
{
  [self quit];
}

// <ExecSignalProcessing>

- execSignals:(ULONG)mask
{
  if(!runningFromAppKit) return nil;
  if((!doQuit)||messagesSent) return [self handleRexxMsg];
  else
  {
    [OAApp remove:self];
    runningFromAppKit=NO;
    return self;
  }
}

- (ULONG)execSignals
{
  return sigMask;
}

@end
