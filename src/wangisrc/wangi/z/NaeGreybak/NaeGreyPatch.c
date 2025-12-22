// PatchBlack.c -- Patches the PubScreenStatus() function of Intuition
//
// ** includes **************************************************************

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <dos/dostags.h>
#include <dos/notify.h>

#include "NaeGreyPatch_rev.h"

// ** defines & types *******************************************************

#define FUNCOFFSET 0xFFFFFDD8
#define REG(x) register __ ## x
#define DELAY_SECS 5
#define TASK_NAME "NaeGrey Patch"

typedef UWORD __asm (*MYFUNC)(REG(a0) struct Screen *, REG(d0) UWORD );

// ** globals ***************************************************************

const STRPTR version = VERSTAG;
MYFUNC OldPubScreenStatus;

// ** CBACK declerations ****************************************************

long __stack = 1000;                // Amount of stack space our task needs 
char *__procname = TASK_NAME;       // The name of the task to create
long __priority = 0;                // The priority to run the task a

// **************************************************************************
void DoCommand(void)
{	
	BPTR fileh;
	if (fileh = Open("NIL:", MODE_OLDFILE)) {
		if (SystemTags("NaeGrey ALL ON QUIET", SYS_Input,  fileh,
		                                       SYS_Output, 0,
		                                       SYS_Asynch, TRUE,
		                                       TAG_END) != 0) {
			Close(fileh);
		}
	}
}

// **************************************************************************
UWORD __saveds __asm NewPubScreenStatus(REG(a0) struct Screen *screen, REG(d0) UWORD StatusFlags)

{
	UWORD result;
	result = OldPubScreenStatus(screen, StatusFlags);
	if (StatusFlags == 0)
		DoCommand(); 
	return(result);
}


// **************************************************************************
main()
{
	if (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 36)) {
		struct MsgPort *port;
		BOOL patch = TRUE;
		
		Forbid();
		if (port = FindPort(TASK_NAME)) {
			struct Message *msg;
			
			// We are already running... tell other occurance to quit
			patch = FALSE;
			if (msg = (struct Message *)AllocVec(sizeof(struct Message), MEMF_CLEAR)) {
				struct MsgPort *rp;
				
				if (rp = CreateMsgPort()) {
					msg->mn_Node.ln_Type = NT_MESSAGE;
					msg->mn_ReplyPort = rp;
					msg->mn_Length = sizeof(struct Message);
					PutMsg(port, msg);
					WaitPort(rp);
					GetMsg(rp);
					FreeVec(msg);
					DeleteMsgPort(rp);
				}
			}
		}
		Permit();
			
		if (patch == TRUE) {
			if (port = CreateMsgPort()) {
				BYTE sig;
				
				port->mp_Node.ln_Name = TASK_NAME;
				AddPort(port);
				if ((sig = AllocSignal(-1)) != -1)  {
					ULONG ret, sigm, portm;
					BOOL cont = TRUE;
					struct NotifyRequest nr;
					
					sigm = 1L<<sig;
					portm = 1L<<port->mp_SigBit;
					nr.nr_Name = "ENV:Sys";
					nr.nr_FullName = NULL;
					nr.nr_Flags = NRF_SEND_SIGNAL;
					nr.nr_stuff.nr_Signal.nr_Task = FindTask(NULL);
					nr.nr_stuff.nr_Signal.nr_SignalNum = sig;
					nr.nr_Reserved[0] = 0;
					nr.nr_Reserved[1] = 0;
					nr.nr_Reserved[2] = 0;
					nr.nr_Reserved[3] = 0;
					StartNotify(&nr);
				
					OldPubScreenStatus = (MYFUNC)SetFunction((struct Library *)IntuitionBase, FUNCOFFSET, (ULONG (* )())&NewPubScreenStatus);
				
					while (cont == TRUE) {
						ret = Wait(SIGBREAKF_CTRL_C | sigm | portm);
						if (ret & sigm) {           // system preferences have been changed... 
							Delay(DELAY_SECS*50);
							DoCommand();
						}
						if (ret & SIGBREAKF_CTRL_C) // Control-C
							cont = FALSE;
						if (ret & portm) {          // user has run us again... quit;
							struct Message *msg;
							if (msg = GetMsg(port))
								ReplyMsg(msg);
							cont = FALSE;
						}
					}
					SetFunction((struct Library *)IntuitionBase, FUNCOFFSET, (ULONG (* )())OldPubScreenStatus);
					EndNotify(&nr);
					FreeSignal(sig);
				}
				RemPort(port);
				DeleteMsgPort(port);
			}
		}	
		CloseLibrary((struct Library *)IntuitionBase);
	}
}