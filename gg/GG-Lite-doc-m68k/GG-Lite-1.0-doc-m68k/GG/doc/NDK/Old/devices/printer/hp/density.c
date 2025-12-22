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

#include <exec/types.h>
#include <devices/printer.h>
#include <devices/prtbase.h>

SetDensity(density_code)
ULONG density_code;
{
	extern struct PrinterExtendedData *PED;
	extern char StartCmd[];

	/* SPECIAL_DENSITY     0   1   2    3    4    5    6    7 */
	static int XDPI[8] = {75, 75, 100, 150, 300, 300, 300, 300};
	static char codes[8][3] = {
	{'0','7','5'},{'0','7','5'},{'1','0','0'},{'1','5','0'},
        {'3','0','0'},{'3','0','0'},{'3','0','0'},{'3','0','0'}};

	density_code /= SPECIAL_DENSITY1;
	PED->ped_MaxXDots = XDPI[density_code] * 8; /* 8 inches */
	PED->ped_MaxYDots = XDPI[density_code] * 10; /* 10 inches */
	PED->ped_XDotsInch = PED->ped_YDotsInch = XDPI[density_code];
	StartCmd[8] = codes[density_code][0];
	StartCmd[9] = codes[density_code][1];
	StartCmd[10] = codes[density_code][2];
}
