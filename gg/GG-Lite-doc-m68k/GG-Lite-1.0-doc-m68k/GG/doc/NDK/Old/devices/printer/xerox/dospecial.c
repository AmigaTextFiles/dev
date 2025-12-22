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

#define PITCH		4
#define	QUALITY		9
#define INITLEN		16

#define TABLEN		34

#define PITCHMARG	2
#define LMARG		5
#define RMARG		11
#define MARGLEN		15
/*
	00-02	\033F0		- assure correct pitch		PMARG
	03-08	\033l000\015	- set left margin to '000'	LMARG
	09-14	\033r000\015	- set right margin to '000'	RMARG
*/
UBYTE MargBuf[MARGLEN] = 
    {0x1b,'F','0',0x1b,'l','0','0','0',0x0d,0x1b,'r','0','0','0',0x0d};
UBYTE pitch;

DoSpecial(command, outputBuffer, vline, currentVMI, crlfFlag, Parms)
char outputBuffer[];
UWORD *command;
BYTE *vline;
UBYTE *currentVMI; /* used for color on this printer */
BYTE *crlfFlag;
UBYTE Parms[];
{
	extern struct PrinterData *PD;

	int x = 0, y= 0;
	static BYTE ISOcolorTable[10] =
		{49, 51, 53, 52, 55, 50, 54, 48, 49, 49};
	/*       K   R   G   Y   B   M   C   W   K   K */

	/*
		00-01	\033R	- underline off
		02-04	\033F0	- 10 cpi			PITCH
		05-06	\033&	- enlarge off
		07-09	\033wb	- nlq off			QUALITY
		10-11	\033s	- super/sub script off
		12-14	\033we	- standard graphics mode
		15-15	\015	- carriage return
	*/
	static char initThisPrinter[INITLEN] =
{0x1b,'R',0x1b,'F','0',0x1b,'&',0x1b,'w','b',0x1b,'s',0x1b,'w','e',0x0d};

	static unsigned char initTabs[TABLEN] =
{0x1b,'i','9',' ','1','7',' ','2','5',' ','3','3',' ','4','1',' ','4','9',
 ' ','5','7','6','5',' ','7','3',' ','8','1',' ','8','9',0x0d};


	if (*command == aRIN) {
		while(x < INITLEN) {
			outputBuffer[x] = initThisPrinter[x];
			x++;
		}
		while (y < TABLEN) {
			outputBuffer[x++] = initTabs[y++];
		}
		y = 0;

		*currentVMI = 0x70; /* white background, black text */

		if (PD->pd_Preferences.PrintQuality == LETTER) {
			outputBuffer[QUALITY] = 'a';
		}

		if (PD->pd_Preferences.PrintPitch == PICA) {
			pitch = 10;
			outputBuffer[PITCH] = '0';
		}
		else if (PD->pd_Preferences.PrintPitch == ELITE) {
			pitch = 12;
			outputBuffer[PITCH] = '2';
		}
		else { /* FINE */
			pitch = 17;
			outputBuffer[PITCH] = '4';
		}

		Parms[0] = PD->pd_Preferences.PrintLeftMargin;
		Parms[1] = PD->pd_Preferences.PrintRightMargin;
		*command = aSLRM;
	}

	if (*command == aCAM) {
		Parms[0] = 1;
		Parms[1] = (95 * 17 + 5) / 10; /* max is 9.5 inches @ 17 cpi */
		*command = aSLRM;
	}

	if (*command == aSLRM) {
		CalcMarg(Parms[0], Parms[1]);
		while (y < MARGLEN) {
			outputBuffer[x++] = MargBuf[y++];
		}
		return(x);
	}

	/* normal pitch, or elite off, or condensed off, or normal char set */
	if (*command == aSHORP0 || *command == aSHORP1 || *command == aSHORP3
		|| *command == aSGR0) {
		pitch = 10;
	}
	else if (*command == aSHORP2) { /* elite on */
		pitch = 12;
	}
	else if (*command == aSHORP4) { /* fine on */
		pitch = 17;
	}

	if (*command == aSFC) { /* set foreground/background color */
		if (Parms[0] == 39) {
			Parms[0] = 30; /* set defaults */
		}
		if (Parms[0] == 49) {
			Parms[0] = 47;
		}
		if (Parms[0] < 40) {
			*currentVMI = (*currentVMI & 240) + (Parms[0] - 30);
		}
		else {
			*currentVMI = (*currentVMI & 15) + (Parms[0] - 40) *
				16;
		}
		outputBuffer[x++] = '\033';
		outputBuffer[x++] = '@';
		outputBuffer[x++] = ISOcolorTable[*currentVMI & 15];
		outputBuffer[x++] = ISOcolorTable[(*currentVMI & 240) / 16];
		return(x);
	}

	if (*command == aPLU) {
		if (*vline == 0) {
			*vline = 1;
			*command = aSUS2;
			return(0);
		}
		if (*vline < 0) {
			*vline = 0;
			*command = aSUS3;
			return(0);
		}
		return(-1);
	}

	if (*command == aPLD) {
		if (*vline == 0) {
			*vline = -1;
			*command = aSUS4;
			return(0);
		}
		if (*vline > 0) {
			*vline = 0;
			*command = aSUS1;
			return(0);
		}
		return(-1);
	}

	if (*command == aSUS0) {
		*vline = 0;
	}
	if (*command == aSUS1) {
		*vline = 0;
	}
	if (*command == aSUS2) {
		*vline = 1;
	}
	if (*command == aSUS3) {
		*vline = 0;
	}
	if (*command == aSUS4) {
		*vline = -1;
	}

	if (*command == aRIS) {
		PD->pd_PWaitEnabled = 253;
		pitch = 10;
	}

	return(0);
}

CalcMarg(left, right)
int left, right;
{
	int i, offset, max;

	/*
		The minimum left margin on the Xerox_4020 is .5 inches.  Thus
		a left margin of 1 (ie. no left margin) is ...
		5/10 => .5, 6/12 => .5, 8.5/17 => .5
		The maximum print width is 9.5 inches.
	*/
	if (pitch == 10) { /* PICA */
		MargBuf[PITCHMARG] = '0';
		offset = 40;
		max = (95 * 10 + 5) / 10;
	}
	else if (pitch == 12) { /* ELITE */
		MargBuf[PITCHMARG] = '2';
		offset = 50;
		max = (95 * 12 + 5) / 10;
	}
	else { /* FINE */
		MargBuf[PITCHMARG] = '4';
		offset = 75;
		max = (95 * 17 + 5) / 10;
	}
	if ((i = (left * 10 + offset + 5) / 10) > max) {
		i = max;
	}
	MargBuf[LMARG] = ((i % 1000) / 100) + '0';
	MargBuf[LMARG + 1] = ((i % 100) / 10) + '0';
	MargBuf[LMARG + 2] = (i % 10) + '0';
	if ((i = (right * 10 + offset + 15) / 10) > max) {
		i = max;
	}
	MargBuf[RMARG] = ((i % 1000) / 100) + '0';
	MargBuf[RMARG + 1] = ((i % 100) / 10) + '0';
	MargBuf[RMARG + 2] = (i % 10) + '0';
	return(MARGLEN);
}
