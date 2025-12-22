;/* rbfhandler_c.c - Execute me to assemble/compile me with Lattice 5.04
Asm -iH:include/ -orbfhandler_a.o rbfhandler_a.asm
LC -b1 -cfistq -v -y -j73 rbfhandler_c.c
Blink FROM LIB:c.o,rbfhandler_c.o,rbfhandler_a.o TO rbfhandler LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* RBFHandler_c.c - C module of interrupt handler example
 *
 *  See also Serial Device chapter (most applications use the serial.device)
 *
 * To receive characters, this example requires ascii serial input 
 * at your Amiga's current serial hardware baud rate (ie. 9600 after 
 * reboot, else last baud rate used)
 *
 * Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <exec/interrupts.h>
#include <resources/misc.h>
#include <hardware/custom.h>
#include <hardware/intbits.h>
#include <libraries/dos.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL-C handling */
int chkabort(void) { return(0); }	/* really */
extern struct Custom far custom; /* defined in amiga.lib */
UBYTE *GetMiscResource(long,UBYTE *);
void FreeMiscResource(long);
#pragma libcall MiscBase GetMiscResource 6 9002
#pragma libcall MiscBase FreeMiscResource c 001
#else
extern struct Custom custom;
/* Without pragmas, you must provide C bindings for misc.resource calls.
 * See the Resources chapter.
 */
#endif

/* Our assembler interrupt handler code entry */
extern void RBFHandler();

/* Our C subroutines */
void tryRemSer(void);
void cleanup(void);
void cleanexit(UBYTE *,LONG);

#define BUFLEN 256
struct OurData {
    struct Task *maintask;
    ULONG mainsig;
    UWORD bufi;
    UBYTE chbuf[BUFLEN+2];
    UBYTE flbuf[BUFLEN+2];
    UBYTE ourname[32];
    };

struct OurData *ourdata = NULL;
struct Interrupt *RBFInterrupt = NULL;
struct Interrupt *PriorInterrupt = NULL;
struct MiscResource *MiscBase = NULL;
BOOL PriorEnable = FALSE;
BOOL Installed = FALSE;
BOOL GotPort = FALSE, GotBits = FALSE;
BYTE mainsignum = -1;
UBYTE *MyName = "RBF-Example";
extern struct ExecBase *SysBase;

void main(int argc,char **argv)
    {
    struct Device *dev;
    ULONG signals;
    UBYTE *user;

    /* Try to get the serial hardware resources */
    if (NULL == (MiscBase=(struct MiscResource *)OpenResource("misc.resource")))
        cleanexit("Can't open misc.resource\n",RETURN_FAIL);

    GotPort = ((user = GetMiscResource(MR_SERIALPORT,MyName)) == NULL);
    if (user)
        {
        printf("Serial hardware currently allocated by %s\n",user);
        if (!(strcmp(user,"serial.device")))
            {
            printf("Will try to remove serial device\n");
            Forbid();
            dev=(struct Device *)FindName(&SysBase->DeviceList,"serial.device");
            if(dev) RemDevice(dev);
            Permit();
            GotPort = ((GetMiscResource(MR_SERIALPORT,MyName)) == NULL);
            }
        }

    GotBits = ((GetMiscResource(MR_SERIALBITS,MyName)) == NULL);
    if (GotPort && GotBits) printf("Allocated the serial hardware\n"); 
    else cleanexit("Can't allocate the serial hardware\n",RETURN_FAIL);

    /* Allocate a signal so interrupts can signal main */
    if (-1 == (mainsignum = AllocSignal(-1)))
              cleanexit("Can't allocate signal\n",RETURN_FAIL);
 
    /* Allocate an Interrupt node structure: */
    if (NULL == (RBFInterrupt = (struct Interrupt *)
            AllocMem((LONG)sizeof(struct Interrupt), MEMF_PUBLIC|MEMF_CLEAR)))
              cleanexit("Can't allocate interrupt structure\n",RETURN_FAIL);

    /* Allocate our data structure which includes our input buffers */
    if (NULL == (ourdata = (struct OurData *)
            AllocMem((LONG)sizeof(struct OurData), MEMF_PUBLIC|MEMF_CLEAR)))
              cleanexit("Can't allocate data structure\n",RETURN_FAIL);

    /* Initialize ourdata structure */
    ourdata->maintask = FindTask(NULL);
    ourdata->mainsig = 1L << mainsignum;

    /* Initialize the Interrupt node */
    RBFInterrupt->is_Node.ln_Type = NT_INTERRUPT;
    RBFInterrupt->is_Node.ln_Pri  = 0;
    strcpy(ourdata->ourname,MyName);
    RBFInterrupt->is_Node.ln_Name = ourdata->ourname;

    RBFInterrupt->is_Data = (APTR)ourdata;
    RBFInterrupt->is_Code = RBFHandler;


    /* Save state of RBF interrupt and disable it */
    PriorEnable = custom.intenar & INTF_RBF ? TRUE : FALSE;
    custom.intena = INTF_RBF;

    /* Install the new interrupt handler */
    PriorInterrupt = SetIntVector(INTB_RBF, RBFInterrupt);
    Installed = TRUE;

    if (PriorInterrupt) printf("Replaced the %s RBF interrupt handler\n",
                  PriorInterrupt->is_Node.ln_Name);

    printf("Enabling RBF interrupt...\n");
    custom.intena = INTF_SETCLR | INTF_RBF;

    printf("Waiting for our handler to fill character buffer. CTRL-C to exit\n");
    signals = Wait(ourdata->mainsig | SIGBREAKF_CTRL_C);

    if(signals & SIGBREAKF_CTRL_C) printf("Break...\n");
    printf("Character buffer contains:\n");
    puts(ourdata->chbuf);

    printf("\nRestoring previous handler and exiting...\n");
    cleanup();
    exit(RETURN_OK);
    }

void cleanexit(s,e)
UBYTE *s;
LONG e;
    {
    if(*s) printf(s);
    cleanup();
    exit(e);
    }

void cleanup()
    {
    if(Installed)
        {
        /* Disable serial int, restore prior handler and prior state */
        custom.intena = INTF_RBF;
        SetIntVector(INTB_RBF, PriorInterrupt);
        if(PriorEnable) custom.intena = INTF_SETCLR|INTF_RBF;
        }
    if(ourdata) FreeMem(ourdata,(LONG)sizeof(struct OurData));
    if(RBFInterrupt) FreeMem(RBFInterrupt,(LONG)sizeof(struct Interrupt));    
    if(mainsignum != -1)  FreeSignal(mainsignum);
    if(GotBits) FreeMiscResource(MR_SERIALBITS);
    if(GotPort) FreeMiscResource(MR_SERIALPORT);
    }


