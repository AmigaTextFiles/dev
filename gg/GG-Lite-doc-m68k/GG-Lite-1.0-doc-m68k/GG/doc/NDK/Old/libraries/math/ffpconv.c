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

/* FFPConv.c
 * Compiled with Lattice C 5.04: LC -b1 -cfist -ffs -v -y
 * Linkage: c.o+FFPConv.o TO FFPConv Library lib:lcmffp.lib+lib:lc.lib+lib:amiga.lib
 */

#include <exec/types.h>
#include <libraries/mathffp.h>
#ifdef LATTICE
#include <stdio.h>
#include <proto/all.h>
#endif

struct Library *MathBase;

UBYTE st1[80] = "3.1415926535897";
UBYTE st2[80] = "2.718281828459045";
UBYTE st3[80], st4[80];

VOID main() {
    
    FLOAT num1, num2;
    FLOAT n1, n2, n3, n4;
    LONG  exp1, exp2, exp3, exp4;
    LONG  mant1, mant2, mant3, mant4;
    LONG  place1, place2;

    if((MathBase = OpenLibrary("mathffp.library", 0)) == 0) {
        printf("Can't open mathffp.library\n");
        exit(20);
    }


    n1 = afp(st1);            /* Call afp entry */
    n2 = afp(st2);            /* Call afp entry */
    printf("\n\nASCII %s converts to floating point %f",
        st1, n1);
    printf("\nASCII %s converts to floating point %f",
        st2, n2);

    num1 = 3.1415926535897;
    num2 = 2.718281828459045;

    exp1 = fpa(num1, st3);    /* Call fpa entry */
    exp2 = fpa(num2, st4);    /* Call fpa entry */
    printf("\n\nfloating point %f converts to ASCII %s", num1, st3);
    printf("\nfloating point %f converts to ASCII %s",
        num2, st4);

    place1 = -2;
    place2 = -1;
    arnd(place1, exp1, st3);    /* Call arnd entry */
    arnd(place2, exp2, st4);    /* Call arnd entry */
    printf("\nASCII round of %f to %d places yields %s",
        num1, place1, st3);
    printf("\nASCII round of %f to %d places yields %s",
        num2, place2, st4);

    exp1  = -3;   exp2  = 3;    exp3  = -3;   exp4  = 3;
    mant1 = 12345;  mant2 = -54321;  mant3 = -12345; mant4 = 54321;

    n1 = dbf(exp1, mant1);        /* Call dbf entry */
    n2 = dbf(exp2, mant2);        /* Call dbf entry */
    n3 = dbf(exp3, mant3);        /* Call dbf entry */
    n4 = dbf(exp4, mant4);        /* Call dbf entry */
    printf("\n\ndbf of exp = %d and mant = %d yields FFP number of %f",
           exp1, mant1, n1);
    printf("\ndbf of exp = %d and mant = %d yields FFP number of %f",
           exp2, mant2, n2);
    printf("\ndbf of exp = %d and mant = %d yields FFP number of %f",
           exp3, mant3, n3);
    printf("\ndbf of exp = %d and mant = %d yields FFP number of %f",
           exp4, mant4, n4);

    CloseLibrary(MathBase);
}
