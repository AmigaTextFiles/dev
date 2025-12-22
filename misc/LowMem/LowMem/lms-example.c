/* :ts=8 */

/*
; Programming Example Of Using The ASDG Low Memory Server
;
; Copyright 1987 By ASDG Incorporated
;
; For  non-commercial distribution  only. Commercial distribution
; or use is  strictly  forbidden  except under license from ASDG.
; 
; Author: Perry S. Kivolowitz
; 
; ASDG shall in no way be held responsible for any damage or loss
; of data which may result from the use or misuse of this program
; or data. ASDG makes no warranty with respect to the correct and
; proper functioning of this code or data. However, it is the be-
; lief of ASDG that this  program and  data is  correct and shall
; function properly with correct use.
;
; These modules were written for  use  with  Manx C.  Manx C is a
; product  of  the  Manx  Software Systems company whose language
; tools are used  exclusively by  ASDG  for all its software pro-
; ducts. Yes - this is an unsolicited plug for Manx - Perry K.
;
*/

#include <exec/ports.h>
#include "low-mem.h"

#define	MyPortName	"LowMemory Reception Port"

extern void *AllocMem();
extern void *CreatePort();
extern long OpenLibrary();

struct LowMemMsg LMM;
struct MsgPort *LowMemoryPort = NULL;
long   LowMemBase = NULL;
long   LowMemSig  = 0;

/*
** In this example, we will allocate a 16K space  just so we have something
** to give up when the Low Memory Server notifies us that there's no memory
** available. We should give up something (in this example anyway) since if
** memory is REALLY tight - the printf's after the Wait may not work.
*/

#define	RipCordSize	16384
char   *RipCord   = NULL;

CloseAll()
{
	if (LowMemoryPort) DeletePort(LowMemoryPort);
	if (LowMemBase) CloseLibrary(LowMemBase);
	if (RipCord) FreeMem(RipCord , RipCordSize);
	printf("ASDG Low Memory Server Example (exiting)\n");
	exit(0);
}

main(argc , argv)
char *argv[];
{
	int Result;

	if (!(RipCord = AllocMem(RipCordSize , 0L))) {
		printf("Was  unable  to allocate  a rip  cord. You\n");
		printf("must not have very  much memory  available\n");
		printf("right now. You should consume memory while\n");
		printf("this  example  is  running - NOT before it\n");
		printf("starts!\n");
		CloseAll();
	}
	printf("RipCord area has been allocated.\n");

	/* library base must be named LoeMemBase */
	if (!(LowMemBase = OpenLibrary(LMSName , 0L))) {
		printf("Was unable to open library: %s\n" , LMSName);
		printf("Are you sure it is in ``libs:''?\n");
		CloseAll();
	}
	printf("Successfully opened the ASDG Low Memory Server.\n");

	if (!(LowMemoryPort = CreatePort(MyPortName , 0L))) {
		printf("Was unable to create a message port for use with\n");
		printf("the ASDG Low Memory Server. Maybe you really are\n");
		printf("low on memory?\n");
		CloseAll();
	}
	LowMemSig = 1L << LowMemoryPort->mp_SigBit;
	printf("Successfully created port whose name is: %s\n" , MyPortName);

	/* Important! Initialize lm_flag to LM_CONDITION_ACKNOWLEDGED
	** or no messages will be sent  to  you! This is the only ini-
	** tialization you need do.
	*/
	LMM.lm_flag = LM_CONDITION_ACKNOWLEDGED;
	printf("Low Memory Server Message initialized.\n");

	printf("Calling RegLowMemReq Now...\n");

	Result = RegLowMemReq(MyPortName , &LMM);

	printf("Result is: %d\n" , Result);
	printf("This means: ");
	switch (Result) {

	case LM_NOMEM:
		printf("Not enough memory to store registration.\n");
		break;

	case LM_BADNAME:
		printf("Try another port name, that one is used already\n");
		break;

	case 0: printf("All went well. Registration Accepted\n");
		break;

	default:
		printf("A bogus return value has come back to you!\n");
		break;
	}
	if (Result < 0) CloseAll();

	printf("Waiting for you to run out of memory now.\n");
	printf("Run something which will cause that situation to arise.\n");
	(void) Wait(LowMemSig);

	FreeMem(RipCord , RipCordSize);
	RipCord = NULL; /* don't free twice */
	printf("Message received. Rip Cord Pulled\n");

	DeRegLowMemReq(MyPortName);
	printf("Low memory registration has been canceled\n");

	CloseAll();
}

