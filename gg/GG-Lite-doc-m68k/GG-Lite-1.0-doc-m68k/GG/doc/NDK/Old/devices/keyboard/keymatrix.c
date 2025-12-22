/* Copyright (c) 1990 Commodore-Amiga, Inc.
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
 */

/*
 * Keyboard device matrix example...
 */

#include <exec/types.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <devices/keyboard.h>

#include <proto/exec.h>

#include <stdio.h>

int CXBRK(VOID) { return(0); }

/*
 * There are keycodes from 0x00 to 0x7F, so the matrix needs to be
 * of 0x80 bits in size, or 0x80/8 which is 0x10 or 16 bytes...
 */
#define MATRIX_SIZE 16L

/*
 * This assembles the matrix for display that translates directly
 * to the RAW key value of the key that is up or down
 */
VOID Display_Matrix(UBYTE *keyMatrix)
{
SHORT  bitcount;
SHORT  bytecount;
SHORT  mask;
USHORT twobyte;

    printf("\n    0 1 2 3 4 5 6 7");
    printf("\n  +-----------------");
    for (bitcount=0;bitcount<16;bitcount++)
    {
        printf("\n%x |",bitcount);
        mask=1 << bitcount;
        for (bytecount=0;bytecount<16;bytecount+=2)
        {
            twobyte=keyMatrix[bytecount] | (keyMatrix[bytecount+1] << 8);
            if (twobyte & mask) printf(" *");
            else printf(" -");
        }
    }
    printf("\n\n");
}

VOID main(int argc, char *argv[])
{
struct IOStdReq *keyRequest;
struct MsgPort  *keyPort;
       UBYTE    *keyMatrix;

    if (keyPort=CreatePort(NULL,NULL))
    {
        if (keyRequest=(struct IOStdReq *)CreateExtIO(keyPort,
                                                  sizeof(struct IOStdReq)))
        {
            if (!OpenDevice("keyboard.device",NULL,
                             (struct IORequest *)keyRequest,NULL))
            {
                if (keyMatrix=AllocMem(MATRIX_SIZE,MEMF_PUBLIC|MEMF_CLEAR))
                {
                    keyRequest->io_Command=KBD_READMATRIX;
                    keyRequest->io_Data=(APTR)keyMatrix;
                    keyRequest->io_Length=13;  /* MUST for 1.2/1.3 */
                    DoIO((struct IORequest *)keyRequest);

                        /* Check for CLI startup... */
                    if (argc) Display_Matrix(keyMatrix);

                    FreeMem(keyMatrix,MATRIX_SIZE);
                }
                CloseDevice((struct IORequest *)keyRequest);
            }
            DeleteExtIO((struct IORequest *)keyRequest);
        }
        DeletePort(keyPort);
    }
}
