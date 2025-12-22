/*
**	My Startup File...
*/

#include <exec/exec.h>
#include <inline/exec.h>
#include <intuition/intuition.h>
#include <graphics/gfxbase.h>
#include <dos/dosextens.h>
#include <workbench/startup.h>
#include <exec/libraries.h>

#define SysBase *(struct ExecBase**)4L

struct Process *ThisTask;
struct WBStartup *WBMessage=NULL;

static void shutup(void);
static void closelibs(void);
static int openlibs(void);
extern int main(char *commandline);
extern void _exit(int err);

// This is just to call the program's main. Must do nothing.
void starter(char *commandline)	
{
  exit(main(commandline));
}

// This is to exit anytime from the program. Calls shutup and exits.
// No stack problems, entry.o handles it.
void exit(int err)			
{
  shutup(); 
  _exit(err);
}

// This is called by main() at start, is the startup init.Openlibs,WBMessage,...
int __main(void)
{
  struct MsgPort *taskport;
  if (!(openlibs()))
   exit(-1);
  ThisTask=(struct Process *)FindTask(NULL);
  if (!ThisTask->pr_CLI)
   {
   taskport=&ThisTask->pr_MsgPort;
   WaitPort(taskport);
   WBMessage=(struct WBStartup *)GetMsg(taskport);   
   } 
}

// This frees, closes everything opened or allocated in __main.
static void shutup(void)
{
  closelibs();
  if (WBMessage)
   ReplyMsg((struct Message *)WBMessage);
}

#define OpenLib(base,name,ver) \
 if (!(base=OpenLibrary(name,ver))) \
  {return(FALSE);} 

static int openlibs(void)
{
}

#define CloseLib(base) \
 if (base) \
  {CloseLibrary(base); \
   base=NULL;}
   
static void closelibs(void)
{
}

