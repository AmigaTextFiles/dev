#include "exec/types.h"
#include "exec/exec.h"
#include "prog:include/studio16.h"

/** do not use -b0 when compiling this module **/

struct StudioBase *StudioBase;

void main()

{
struct MinNode *node;
struct Node *bignode; 
struct Module *mod;
struct Disk_Samp *samp;
struct NotifyLink *link;
int i;
struct AudioHandler *ah;
struct StandardModState *s;

StudioBase=(struct StudioBase *)OpenLibrary("studio.library",0);
if (StudioBase==NULL) {
	exit(10);
	}

ObtainSharedSemaphore(&StudioBase->lockstudio);
for (node=StudioBase->modules.mlh_Head; node->mln_Succ; node = node->mln_Succ) {
   mod=(struct Module *)node;
	printf("mod %s %x\n",mod->name, mod);
	}

for (node=StudioBase->samps.mlh_Head; node->mln_Succ; node = node->mln_Succ) {
   samp=(struct Disk_Samp *)node;
	printf("samp %s %x\n",samp->name, samp);
	}

for (bignode=StudioBase->handlers.lh_Head; bignode->ln_Succ; bignode = bignode->ln_Succ) {
   ah=(struct AudioHandler *)bignode;
	printf("audio handler %s %x bits %d\n",ah->name, ah, ah->num_bits);
	}

for (i=0; i < StudioBase->max_registered_ids; i++) {
	node=StudioBase->notifyarray[i].mlh_Head;
	while(node->mln_Succ) {
		link=(struct NotifyLink *)node;
		printf("Notify mod %x on %s\n",link->notifyme,StudioBase->eventidarray[i]);
		node=node->mln_Succ;
		}
	}

for (bignode=StudioBase->module_states.lh_Head; bignode->ln_Succ; bignode = bignode->ln_Succ) {
   s=(struct StandardModState *)bignode;
	printf("StandardModState %-30s  0x%08x   %d\n",s->instance_name, s,s->lock);
	}


printf("----- EVENT LIST ------\n");

for (i=0; i < StudioBase->max_registered_ids; i++)
	printf("%s %d\n",StudioBase->eventidarray[i],i);

ReleaseSharedSemaphore(&StudioBase->lockstudio);


if (StudioBase)
	CloseLibrary(StudioBase);
}

