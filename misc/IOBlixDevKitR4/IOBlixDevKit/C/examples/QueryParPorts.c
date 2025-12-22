/*
    This program is meant to demonstrate how to get all necessary information
    about a specific chip on an IOBlix board and how to program that chip in a
    system-friendly manner
*/

#include <exec/exec.h>
#include <resources/ioblix.h>
#include <ioblix/parport.h>
#include <stdio.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/ioblix.h>


UBYTE __aligned myname[]="QueryParPorts 37.2 "__AMIGADATE__;
UBYTE __aligned version[]="$VER: QueryParPorts 37.2 "__AMIGADATE__;
UBYTE __aligned copyright[]="(C)opyright 1998,1999 by Thore Böckelmann and RBM Computertechnik. All rights reserved";

struct IOBlixResource *IOBlixBase = NULL;

void main(void)
{
    struct IOBlixChipNode *chipNode;
    ULONG board;
    ULONG unit;
    UBYTE *prevOwner;
    struct ParPortRegisters *pp;
    BOOL foundSomething;

    IOBlixBase = (struct IOBlixResource *)OpenResource(IOBLIXRESNAME);
    if (IOBlixBase) {
        for (board = 0; board < IOBLIX_MAX_Z2_BOARDS; board++) {
            printf("board %ld\n", board);
            foundSomething = FALSE;
            for (unit = 0; unit < IOBLIX_Z2_NUM_PARUNITS; unit++) {
                /* first simply try to find each parallel port    */
                /* if it is available then print some information */
                chipNode = FindChip(ICT_Z2_PARALLEL_CHIP, board*10+unit);
                if (chipNode) {
                    foundSomething = TRUE;
                    printf("\tparallel port %ld is a \"%s\" with %ld bytes FIFO\n", unit, chipNode->icn_Description, chipNode->icnp_FIFOSize);
                    printf("\tcurrent user: %s\n", (chipNode->icn_Owner) ? chipNode->icn_Owner : (UBYTE *)"nobody");
                    printf("\tabilities: ");
                    if (chipNode->icnp_Abilities & PCPAF_SPP) printf("SPP ");
                    if (chipNode->icnp_Abilities & PCPAF_PPF) printf("PPF ");
                    if (chipNode->icnp_Abilities & PCPAF_PS2) printf("PS2 ");
                    if (chipNode->icnp_Abilities & PCPAF_EPP) printf("EPP ");
                    if (chipNode->icnp_Abilities & PCPAF_ECP) printf("ECP ");
                    printf("\n");

                    /* now try to obtain chip for exclusive use */
                    prevOwner = NULL;
                    chipNode = ObtainChip(ICT_Z2_PARALLEL_CHIP, board*10+unit, myname, &prevOwner);
                    if (chipNode) {
                        /* for this test we need SPP mode and the ability to switch to other modes with */
                        /* the ECR register */
                        if ((chipNode->icnp_Abilities & (PCPAF_SPP | PCPAF_ECR)) == (PCPAF_SPP | PCPAF_ECR)) {
                            UBYTE oecr;
                            UBYTE testString[] = "The quick brown fox jumps over the lazy dog";
                            UBYTE readBack[256];
                            ULONG cnt, writeCnt;

                            pp = (struct ParPortRegisters *)chipNode->icn_ChipRegisters;
                            /* now play a bit with the parport's test mode */
                            /* every value written to the FIFO should also be read back */
                            /* else something really bad has happened */

                            oecr = *pp->pr_econtrol;
                            /* first set port in SPP mode, else TST mode cannot be activated */
                            /* turn off parport interrupts */
                            *pp->pr_econtrol = PARPORT_ECONTROL_SPP | PARPORT_ECONTROL_INT;
                            *pp->pr_econtrol = PARPORT_ECONTROL_TST | PARPORT_ECONTROL_INT;

                            /* write some data to the FIFO */
                            cnt = 0;
                            do {
                                *pp->pr_tfifo = testString[cnt];
                                cnt++;
                            } while ((testString[cnt]) && !(*pp->pr_econtrol & PARPORT_ECONTROL_FIFO_F));
                            writeCnt = cnt;
                            printf("\t\twrote %ld bytes of \"%s\" to FIFO\n", writeCnt, testString);

                            /* and now read the data back */
                            cnt = 0;
                            do {
                                readBack[cnt] = *pp->pr_tfifo;
                                cnt++;
                            } while ((cnt < writeCnt));
                            readBack[cnt] = 0x00;
                            printf("\t\tread %ld bytes back from FIFO. \"%s\"\n", cnt, readBack);

                            /* restore old econtrol contents */
                            *pp->pr_econtrol = PARPORT_ECONTROL_SPP | PARPORT_ECONTROL_INT;
                            *pp->pr_econtrol = oecr;
                        } else {
                            printf("parallel port doesn't support anything else than SPP!\n");
                        }

                        /* now release the chip again */
                        ReleaseChip(chipNode);
                    } else {
                        /* ObtainChip() failed, so let's check for other owners */
                        if (prevOwner) printf("chip is already in use by \"%s\"\n", prevOwner);
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

