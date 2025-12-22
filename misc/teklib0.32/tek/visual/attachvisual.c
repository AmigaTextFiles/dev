
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVISUAL *TAttachVisual(TAPTR task, TAPTR visual, TTAGITEM *tags)
**
**	attach to a visual object
**
**	tags
**		TTask_MMU, user mmu
**
*/



static TINT destroyattvisual(TVISUAL *visual);

TVISUAL *TAttachVisual(TAPTR parenttask, TAPTR parentvisual, TTAGITEM *tags)
{
	if (parentvisual)
	{
		TAPTR mmu = TGetTagValue(TTask_MMU, &((TTASK *) parenttask)->heapmmu, tags);
		TVISUAL *visual = TMMUAllocHandle(mmu, (TDESTROYFUNC) destroyattvisual, sizeof(TVISUAL));
		if (visual)
		{
			visual->parentvisual = (TVISUAL *) parentvisual;
			visual->asyncport = TCreatePort(parenttask, TNULL);
			/*visual->syncport = TCreatePort(parenttask, TNULL);*/

			if (visual->asyncport /*&& visual->syncport*/)
			{
				TINT i;
				TAPTR msg;
				TBOOL success = TTRUE;
				
				for (i = 0; i < TVISUAL_NUMDRMSG && success; ++i)
				{
					/*msg = TTaskAllocMsg(parenttask, sizeof(TDRAWMSG));*/
					msg = TMMUAlloc(((TTASK *) parenttask)->msgmmu, sizeof(TDRAWMSG));
					if (msg)
					{
						(((TMSG *) msg) - 1)->status = TMSG_STATUS_UNDEFINED | TMSG_STATUS_PENDING;		/* not important, keeps away TGetMsg() warnings */
						TAddTail(&visual->asyncport->msglist, (TNODE *)(((TMSG *) msg) - 1));
					}
					else
					{
						success = TFALSE;
						break;
					}
				}

				if (success)
				{
					visual->parenttask = parenttask;
					visual->main = TFALSE;
					visual->task = visual->parentvisual->task;

					kn_lock(&visual->parentvisual->lock);
					visual->parentvisual->refcount++;
					kn_unlock(&visual->parentvisual->lock);

					return visual;
				}
				
				while ((msg = TRemHead(&visual->asyncport->msglist)))
				{
					TFreeMsg(((TMSG *) msg) + 1);
				}
			}
			
			/*TDestroy(visual->syncport);*/
			TDestroy(visual->asyncport);
			TMMUFreeHandle(visual);
		}
	}

	return TNULL;
}



static TINT destroyattvisual(TVISUAL *visual)
{
	TAPTR msg;
	TUINT numfreed = 0;

	TVSync(visual);

	/* 
	**	wait for and free all drawmessages
	*/

	while (numfreed < TVISUAL_NUMDRMSG)
	{
		if ((msg = TGetMsg(visual->asyncport)))
		{
			TMMUFree(((TTASK *) (visual->parenttask))->msgmmu, msg);
			/*	TFreeMsg(msg);		??!?!? */

			numfreed++;
			continue;
		}
		TWaitPort(visual->asyncport);
	}
	
	/*TDestroy(visual->syncport);*/
	TDestroy(visual->asyncport);

	kn_lock(&visual->parentvisual->lock);
	visual->parentvisual->refcount--;
	kn_unlock(&visual->parentvisual->lock);

	TMMUFreeHandle(visual);
	
	return 0;
}
