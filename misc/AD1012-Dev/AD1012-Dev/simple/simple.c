#include "exec/types.h"
#include "exec/exec.h"
#include "/source/include/studio16.h"

/**** CBACK.o defines *****/

long _stack = 4000;						/* Amount of stack space our task needs   */
char *_procname = "STUDIO_SIMPLE";	/* The name of the task to create         */
long _priority = 0;						/* The priority to run us at              */
long _BackGroundIO = 0;					/* Flag to tell it we want to do I/O      */

struct StudioBase *StudioBase;

void _main()			/** Using "_main()" because we have no stdio **/

{
static struct NewModule mod_data ={"SimpleModule",0,sizeof(struct StandardModState),0};
struct Module *thismod;
struct StudioEvent *event;
short se_cmd_kill_module;

StudioBase=(struct StudioBase *)OpenLibrary("studio.library",0);
if (StudioBase==NULL) {
	exit(10);
	}

if ((thismod=(struct Module *)AddModule(&mod_data))==0) {
	CloseLibrary(StudioBase);
   exit(10);
   }

se_cmd_kill_module=GetEventID("SE_CMD_KILL_MODULE");
NotifyMeOnEvent(se_cmd_kill_module, thismod);

while (TRUE) {
	Wait(1<<thismod->notifyme->mp_SigBit);
	while ((event=(struct StudioEvent *)GetMsg(thismod->notifyme))!=0) {
		if (event->type==se_cmd_kill_module && (struct Module *)event->arg1==thismod) {
			ReplyMsg(event);
			DeleteModule(thismod);
			CloseLibrary(StudioBase);
			exit(0);
			}
		}
	}
}
