/*
    This program is meant to demonstrate how to work with ioblix.resource's
    functions to obtain and release chips in exclusive and shared mode
*/

#include <exec/exec.h>
#include <resources/ioblix.h>
#include <stdio.h>
#include <string.h>

#include <proto/exec.h>
#include <proto/ioblix.h>


UBYTE __aligned myname[]="TestResource 37.2 "__AMIGADATE__;
UBYTE __aligned version[]="$VER: TestResource 37.2 "__AMIGADATE__;
UBYTE __aligned copyright[]="(C)opyright 1998,1999 by Thore Böckelmann and RBM Computertechnik. All rights reserved";

struct IOBlixResource *IOBlixBase = NULL;

void FindChipTest( void )
{
    struct IOBlixChipNode *cn;

    printf("FindChip() test\n");

    // simply try to find one chip and say wether it was found or not
    if (cn = FindChip(ICT_Z2_SERIAL_CHIP, 0)) {
        printf("UART #0 on Z2 board is available\n");
    } else {
        printf("UART #0 on Z2 board is not available\n");
    }

    // this one can't exist
    if (cn = FindChip(ICT_Z2_SERIAL_CHIP, 142)) {
        printf("UART #142 on Z2 board is available\n");
    } else {
        printf("UART #142 on Z2 board is not available\n");
    }
    printf("\n");
}

void ObtainChipTest( void )
{
    struct IOBlixChipNode *cn1, *cn2;
    UBYTE *oldOwner1 = NULL, *oldOwner2 = NULL;

    printf("ObtainChip() test\n");

    // try to obtain one chip two times in exclusive mode
    // the first try should succeed, but the second must fail
    if (cn1 = ObtainChip(ICT_Z2_SERIAL_CHIP, 0, "TestResource", &oldOwner1)) {
        printf("locked UART #0 1st time\n");
        if (cn2 = ObtainChip(ICT_Z2_SERIAL_CHIP, 0, "TestResource", &oldOwner2)) {
            printf("locked UART #0 2nd time, this can't happen\n");
            ReleaseChip(cn2);
        } else {
            printf("failed to lock UART #0 a 2nd time");
            if (oldOwner2) {
                printf(", already locked by \"%s\"\n", oldOwner2);
            } else {
                printf(", chip is not available??\n");
            }
        }
        ReleaseChip(cn1);
    } else {
        printf("failed to lock UART #0 1st time");
        if (oldOwner1) {
            printf(", already locked by \"%s\"\n", oldOwner1);
        } else {
            printf(", chip is not available\n");
        }
    }
    printf("\n");
}

void ObtainChipSharedTest( void )
{
    struct IOBlixChipNode *cn, *cn2;
    UBYTE newOwner[32];
    UBYTE *oldOwner = NULL;
    struct Node *user;
    ULONG cnt;

    printf("ObtainChipShared() test\n");

    // try to obtain one chip several times in shared mode, print user list, release it again some times
    for (cnt = 1; cnt <= 9; cnt++) {
        sprintf(newOwner, "TestResource%02ld", cnt);
        ObtainChipShared(ICT_Z2_SERIAL_CHIP, 0, newOwner, NULL);
    }
    sprintf(newOwner, "TestResource%02ld", cnt);
    if (cn = ObtainChipShared(ICT_Z2_SERIAL_CHIP, 0, newOwner, &oldOwner)) {
        printf("UART #0 has been locked %ld times\n", cn->icn_SharedAccessorCount);
        printf("user list:\n");
        for (user = cn->icn_SharedAccessorList.lh_Head; user->ln_Succ; user = user->ln_Succ) {
            printf("\t%s\n", user->ln_Name);
        }
        printf("releasing chip for users \"TestResource03\" and \"TestResource07\"\n");
        ReleaseChipShared(cn, "TestResource03");
        ReleaseChipShared(cn, "TestResource07");
        printf("UART #0 has been locked %ld times\n", cn->icn_SharedAccessorCount);
        printf("user list:\n");
        for (user = cn->icn_SharedAccessorList.lh_Head; user->ln_Succ; user = user->ln_Succ) {
            printf("\t%s\n", user->ln_Name);
        }
        printf("trying to obtain chip in exclusive mode\n");
        if (cn2 = ObtainChip(ICT_Z2_SERIAL_CHIP, 0, "TestResourceExcl", &oldOwner)) {
            printf("this should never happen!\n");
            ReleaseChip(cn2);
        } else {
            printf("exclusive lock failed");
            if (oldOwner) {
                printf(", already locked by \"%s\"\n", oldOwner);
            } else {
                printf(" chip is not available??\n");
            }
        }
        printf("releasing all users\n");
        for (cnt = 1; cnt <= 10; cnt++) {
            sprintf(newOwner, "TestResource%02ld", cnt);
            ReleaseChipShared(cn, newOwner);
        }
        printf("UART #0 has been locked %ld times\n", cn->icn_SharedAccessorCount);
    } else {
        printf("failed to lock UART #0");
        if (oldOwner) {
            printf(", already locked by \"%s\"\n", oldOwner);
        } else {
            printf(", chip is not available\n");
        }
    }
    printf("\n");
}

void AllocChipListTest( void )
{
    struct List *list;
    struct IOBlixChipNode *node;
    struct Node *user;
    ULONG cnt;

    printf("AllocChipList() test\n");
    if (list = AllocChipList()) {
        for (node = (struct IOBlixChipNode *)list->lh_Head, cnt = 1; node->icn_Node.ln_Succ; node = (struct IOBlixChipNode *)node->icn_Node.ln_Succ, cnt++) {
            printf("chip #%ld is a ", cnt);
            switch(node->icn_Type) {
                case ICT_Z2_SERIAL_CHIP:
                    printf("UART on a Z2 board\n");
                    break;
                case ICT_Z2_PARALLEL_CHIP:
                    printf("ParPort on a Z2 board\n");
                    break;
                case ICT_Z2_EXTFIFO_CHIP:
                    printf("external FIFO on a Z2 board\n");
                    break;
                case ICT_CP_SERIAL_CHIP:
                    printf("UART on a ClockPort module\n");
                    break;
                case ICT_CP_PARALLEL_CHIP:
                    printf("ParPort on a ClockPort module\n");
                    break;
                default:
                    printf("some other kind of chip\n");
                    break;
            }
            printf("current user is \"%s\"\n", (node->icn_Owner) ? node->icn_Owner : (UBYTE *)"nobody");
            if (node->icn_Flags & ICFF_SHARED) {
                printf("chip is locked in shared mode by %ld users\n", node->icn_SharedAccessorCount);
                printf("user list:\n");
                for (user = node->icn_SharedAccessorList.lh_Head; user->ln_Succ; user = user->ln_Succ) {
                    printf("\t%s\n", user->ln_Name);
                }
            }
        }
        FreeChipList(list);
    }
    printf("\n");
}

void main(void)
{
    IOBlixBase = (struct IOBlixResource *)OpenResource(IOBLIXRESNAME);
    if (IOBlixBase) {
        FindChipTest();
        ObtainChipTest();
        ObtainChipSharedTest();
        AllocChipListTest();
    } else {
        printf("Can't find ioblix.resource. Please run SetupIOBlix\n");
    }
}

