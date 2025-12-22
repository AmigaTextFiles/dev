#include <dos/dostags.h>
#include <dos/dosextens.h>
#include <dos/notify.h>
#include <libraries/feelin.h>

#include <proto/feelin.h>
#include <proto/exec.h>
#include <proto/dos.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

struct FS_THREAD_DATA                   		{ struct Task *Owner; };

///Thread_Main
F_HOOKM(FThreadMsg *, Thread_Main, FS_Thread_Run)
{
	uint32 id_Pop = Msg->Public->id_Pop;
	uint32 id_Wait = Msg->Public->id_Wait;
	
	IFEELIN F_Log
	(
		0,
		"Thread_Main() Thread (0x%08lx) Public (0x%08lx) - Owner (0x%08lx)",
		Obj, Msg->Public, ((struct FS_THREAD_DATA *) Hook->h_Data)->Owner
	);
 
	for (;;)
	{
		FThreadMsg *msg = (FThreadMsg *) IFEELIN F_Do(Obj, id_Pop);
	  
		if (msg)
		{
			IFEELIN F_Log(0,"Msg 0x%08lx - Action 0x%08lx", msg, msg->Action);

			switch (msg->Action)
			{
				case FV_Thread_Hello:
				{
					msg->Return = TRUE;
				}
				break;

				case FV_Thread_Bye:
				{
					IFEELIN F_Log(0,"bye");

					msg->Return = TRUE;

					return msg;
				}
				break;
			}

			IEXEC ReplyMsg((struct Message *) msg);
		}
		else
		{
			IFEELIN F_Log(0,"waiting...");

			IFEELIN F_Do(Obj, id_Wait, 0);
		}
	}
}
//+

int main(void)
{
	struct Hook thread_hook;
	struct FS_THREAD_DATA thread_data;

	thread_data.Owner = IEXEC FindTask(NULL);

	thread_hook.h_Entry = (HOOKFUNC) Thread_Main;
	thread_hook.h_Data = &thread_data;

	if (F_FEELIN_OPEN)
	{
		FObject thread = ThreadObject,
			
			"FA_Thread_Hook",     	&thread_hook,
			"FA_Thread_Name",      "test.thread",
			"FA_Thread_Priority",  "Low",

			End;
		   
		if (thread)
		{
			IDOS_ Printf("Thread 0x%08lx - Priority %ld.\nUse Ctrl-C to terminate the demo.\n", (int32) thread, IFEELIN F_Get(thread, (uint32) "FA_Thread_Priority"));

			IEXEC Wait(SIGBREAKF_CTRL_C);

			IFEELIN F_DisposeObj(thread);
		}
		
		F_FEELIN_CLOSE;
	}
	return 0;
}

