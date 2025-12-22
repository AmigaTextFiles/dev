/*
    This program is meant to demonstrate how to get all necessary information
    about all available chips on an IOBlix board in a system-friendly manner
*/

#include <exec/exec.h>
#include <resources/ioblix.h>
#include <stdio.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/ioblix.h>


UBYTE __aligned myname[]="QueryChipList 37.2 "__AMIGADATE__;
UBYTE __aligned version[]="$VER: QueryChipList 37.2 "__AMIGADATE__;
UBYTE __aligned copyright[]="(C)opyright 1998,1999 by Thore Böckelmann and RBM Computertechnik. All rights reserved";

struct IOBlixResource *IOBlixBase = NULL;

void main(void)
{
    struct List *chipList;
    struct IOBlixChipNode *chipNode;
    ULONG uartCnt, ppCnt, fifoCnt, otherCnt;

    IOBlixBase = (struct IOBlixResource *)OpenResource(IOBLIXRESNAME);
    if (IOBlixBase) {
        /* try to get a copy of the global chip list */
        chipList = AllocChipList();
        if (chipList) {
            uartCnt = ppCnt = fifoCnt = otherCnt = 0;
            /* let's count all the available chips in the system */
            for (chipNode = (struct IOBlixChipNode *)chipList->lh_Head; chipNode->icn_Node.ln_Succ; chipNode = (struct IOBlixChipNode *)chipNode->icn_Node.ln_Succ) {
                switch (chipNode->icn_Type) {
                    case ICT_Z2_SERIAL_CHIP:
                    case ICT_CP_SERIAL_CHIP:
                        uartCnt++;
                        break;
                    case ICT_Z2_PARALLEL_CHIP:
                    case ICT_CP_PARALLEL_CHIP:
                        ppCnt++;
                        break;
                    case ICT_Z2_EXTFIFO_CHIP:
                        fifoCnt++;
                        break;
                    default:
                        otherCnt++;
                        break;
                }
            }
            printf("There are\n" \
                   "\t%2ld UARTs\n" \
                   "\t%2ld parallel ports\n" \
                   "\t%2ld external FIFOs\n" \
                   "\t%2ld other chips\n" \
                   "in your system.\n", uartCnt, ppCnt, fifoCnt, otherCnt);
            /* free the list again */
            FreeChipList(chipList);
        } else {
            printf("Can't get a copy of the chip list!\n");
        }
    } else {
        printf("Can't find ioblix.resource. Please run SetupIOBlix\n");
    }
}

