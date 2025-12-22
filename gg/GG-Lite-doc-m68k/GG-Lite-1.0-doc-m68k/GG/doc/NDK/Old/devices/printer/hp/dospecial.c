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

#define LPI		7
#define CPI		15
#define QUALITY		17
#define INIT_LEN	30
#define LPP		7
#define FORM_LEN	11
#define LEFT_MARG	3
#define RIGHT_MARG	7
#define MARG_LEN	12

DoSpecial(command, outputBuffer, vline, currentVMI, crlfFlag, Parms)
char outputBuffer[];
UWORD *command;
BYTE *vline;
BYTE *currentVMI;
BYTE *crlfFlag;
UBYTE Parms[];
{
	extern struct PrinterData *PD;
	extern struct PrinterExtendedData *PED;

	UWORD textlength, topmargin;
	int x, y, j;
	static char initThisPrinter[INIT_LEN] =
	{0x1b,'&','d','@',0x1b,'&','l','6','D',0x1b,'(','s','0','b',
	'1','0','h','1','q','0','p','0','s','3','t','0','u','1','2','V'};

	static char initForm[FORM_LEN] = 
        {0x1b,'&','l','0','0','2','e','0','0','0','F'};

	static char initMarg[MARG_LEN] = 
        {0x1b,'&','a','0','0','0','l','0','0','0','M',0x0d};

	static char initTMarg[] = 
	{0x1b,'&','l','0','0','0','e','0','0','0','F'};
	x = y = j = 0;

	if (*command == aRIN) {
		while(x < INIT_LEN) {
			outputBuffer[x] = initThisPrinter[x];
			x++;
		}
		outputBuffer[x++] = '\015';

		if (PD->pd_Preferences.PrintSpacing == EIGHT_LPI) {
			outputBuffer[LPI] = '8';
		}

		if (PD->pd_Preferences.PrintPitch == ELITE) {
			outputBuffer[CPI] = '2';
		}
		else if (PD->pd_Preferences.PrintPitch == FINE) {
			outputBuffer[CPI] = '5';
		}

		if (PD->pd_Preferences.PrintQuality == LETTER) {
			outputBuffer[QUALITY] = '2';
		}

		j = x; /* set the formlength = textlength, top margin = 2 */
		textlength = PD->pd_Preferences.PaperLength;
		topmargin = 2;

		while (y < FORM_LEN) {
			outputBuffer[x++] = initForm[y++];
		}
		numberString(textlength, j + LPP, outputBuffer);

		Parms[0] = PD->pd_Preferences.PrintLeftMargin;
		Parms[1] = PD->pd_Preferences.PrintRightMargin;
		*command = aSLRM;
	}

	if (*command == aSLRM) {
		j = x;
		y = 0;
		while(y < MARG_LEN) {
			outputBuffer[x++] = initMarg[y++];
		}
		numberString(Parms[0] - 1, j + LEFT_MARG, outputBuffer);
		numberString(Parms[1] - 1, j + RIGHT_MARG, outputBuffer);
		return(x);
	}

	if ((*command == aSUS2) && (*vline == 0)) {
		*command = aPLU;
		*vline = 1;
		return(0);
	}

	if ((*command == aSUS2) && (*vline < 0)) {
		*command = aRI;
		*vline = 1;
		return(0);
	}

	if ((*command == aSUS1) && (*vline > 0)) {
		*command = aPLD;
		*vline = 0;
		return(0);
	}

	if ((*command == aSUS4) && (*vline == 0)) {
		*command = aPLD;
		*vline = -1;
		return(0);
	}

	if ((*command == aSUS4) && (*vline > 0)) {
		*command = aIND;
		*vline = -1;
		return(0);
	}

	if ((*command == aSUS3) && (*vline < 0)) {
		*command = aPLU;
		*vline = 0;
		return(0);
	}

	if(*command == aSUS0) {
		if (*vline > 0) {
			*command = aPLD;
		}
		if (*vline < 0) {
			*command = aPLU;
		}
		*vline = 0;
		return(0);
	}

	if (*command == aPLU) {
		(*vline)++;
		return(0);
	}

	if (*command == aPLD){
		(*vline)--;
		return(0);
	}

	if (*command == aSTBM) {
		if (Parms[0] == 0) {
			Parms[0] = topmargin;
		}
		else {
			topmargin = --Parms[0];
		}

		if (Parms[1] == 0) {
			Parms[1] = textlength;
		}
		else {
			textlength=Parms[1];
		}
		while (x < 11) {
			outputBuffer[x] = initTMarg[x];
			x++;
		}
		numberString(Parms[0], 3, outputBuffer);
		numberString(Parms[1] - Parms[0], 7, outputBuffer);
		return(x);
	}

	if (*command == aSLPP) {
		while(x < 11) {
			outputBuffer[x] = initForm[x];
			x++;
		}
		/*restore textlength, margin*/
		numberString(topmargin, 3, outputBuffer);
		numberString(textlength, 7, outputBuffer);
		return(x);	
	}

	if (*command == aRIS) {
		PD->pd_PWaitEnabled = 253;
	}

	return(0);
}

numberString(Param, x, outputBuffer)
UBYTE Param;
int x;
char outputBuffer[];
{
	if (Param > 199) {
		outputBuffer[x++] = '2';
		Param -= 200;
	}
	else if (Param > 99) {
		outputBuffer[x++] = '1';
		Param -= 100;
	}
	else {
		outputBuffer[x++] = '0'; /* always return 3 digits */
	}

	if (Param > 9) {
		outputBuffer[x++] = Param / 10 + '0';
	}
	else {
		outputBuffer[x++] = '0';
	}

	outputBuffer[x++] = Param % 10 + '0';
}

ConvFunc(buf, c, flag)
char *buf, c;
int flag; /* expand lf into lf/cr flag (0-yes, else no ) */
{
	if (c == '\014') { /* if formfeed (page eject) */
		PED->ped_PrintMode = 0; /* no data to print */
	}
	return(-1); /* pass all chars back to the printer device */
}

Close(ior)
struct printerIO *ior;
{
	if (PED->ped_PrintMode) { /* if data has been printed */
		(*(PD->pd_PWrite))("\014",1); /* eject page */
		(*(PD->pd_PBothReady))(); /* wait for it to finish */
		PED->ped_PrintMode = 0; /* no data to print */
	}
	return(0);
}
