/*
    This program is meant to demonstrate how to get all necessary information
    about a specific chip on an IOBlix board and how to program that chip in a
    system-friendly manner
*/

#include <exec/exec.h>
#include <resources/ioblix.h>
#include <ioblix/uart.h>
#include <stdio.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/ioblix.h>


UBYTE __aligned myname[]="QueryUARTs 37.2 "__AMIGADATE__;
UBYTE __aligned version[]="$VER: QueryUARTs 37.2 "__AMIGADATE__;
UBYTE __aligned copyright[]="(C)opyright 1998,1999 by Thore Böckelmann and RBM Computertechnik. All rights reserved";

struct IOBlixResource *IOBlixBase = NULL;

void main(void)
{
    struct IOBlixChipNode *chipNode;
    ULONG board;
    ULONG unit;
    UBYTE *prevOwner;
    struct UARTRegisters *uart;
    BOOL foundSomething;

    IOBlixBase = (struct IOBlixResource *)OpenResource(IOBLIXRESNAME);
    if (IOBlixBase) {
        for (board = 0; board < IOBLIX_MAX_Z2_BOARDS; board++) {
            printf("board %ld\n", board);
            foundSomething = FALSE;
            for (unit = 0; unit < IOBLIX_Z2_NUM_SERUNITS; unit++) {
                /* first simply try to find each serial UART      */
                /* if it is available then print some information */
                chipNode = FindChip(ICT_Z2_SERIAL_CHIP, board*10+unit);
                if (chipNode) {
                    foundSomething = TRUE;
                    printf("\tUART %ld is a \"%s\" with %ld bytes FIFO\n", unit, chipNode->icn_Description, chipNode->icns_FIFOSize);
                    printf("\tcurrent user: %s\n", (chipNode->icn_Owner) ? chipNode->icn_Owner : (UBYTE *)"nobody");

                    /* now try to obtain chip for exclusive use */
                    prevOwner = NULL;
                    chipNode = ObtainChipShared(ICT_Z2_SERIAL_CHIP, board*10+unit, myname, &prevOwner);
                    if (chipNode) {
                        if (chipNode->icns_UARTType == SCPT_16654) {
                            uart = (struct UARTRegisters *)chipNode->icn_ChipRegisters;

                            /* as we obtain the chip in shared mode we need to obtain the semaphore */
                            /* included in IOBlixChipNode to gain exclusive access for a short time */
                            ObtainSemaphore(&chipNode->icn_SharedAccessSema);

                            /* now play a bit with the UART's scratch register */
                            /* every value written to this register should also be read back */
                            /* else something really bad has happened */
                            *uart->ur_scr = 0x55;
                            if (*uart->ur_scr != 0x55) printf("\t\tread failure\n");
                            *uart->ur_scr = 0xaa;
                            if (*uart->ur_scr != 0xaa) printf("\t\tread failure\n");

                            /* access is finished now, so release the chip again */
                            ReleaseSemaphore(&chipNode->icn_SharedAccessSema);
                            printf("\t\tfinished test\n");
                        } else {
                            printf("\tUART is not a 16C654!?!\n");
                        }

                        /* now release the chip again */
                        ReleaseChipShared(chipNode, myname);
                    } else {
                        /* ObtainChip() failed, so let's check for other owners */
                        if (prevOwner) printf("\t\tchip is already in use by \"%s\"\n", prevOwner);
                    }
                }
            }
            if (!foundSomething) {
                printf("\tnothing found for this board\n");
            }
            printf("\n");
        }
    } else {
        printf("Can't find ioblix.resource. Please run SetupIOBlix\n");
    }
}

