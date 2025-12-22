/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero

*/

// DLS (a.k.a. DTK, TRK, ADP)
// uses same algorithm as XA, apparently
#include "../xmms_cube/windows.h"
#include "wamain.h"
#include "cube.h"

// inputfile == NULL means file is already opened, just reload
// return 1 if valid ADP not detected, 0 on success
int InitADPFILE(char * inputfile, CUBEFILE * adp) {
	DWORD l;
	char readbuf[4];
	if (inputfile) {
		adp->ch[0].infile=adp->ch[1].infile=INVALID_HANDLE_VALUE;

		if (strcmpi(inputfile+strlen(inputfile)-4,".adp")) return 1;

		adp->ch[0].infile = CreateFile(inputfile,GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,
			OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);

		if (adp->ch[0].infile == INVALID_HANDLE_VALUE) // error opening file
			return 1;

		// check for valid first frame
		ReadFile(adp->ch[0].infile,readbuf,4,&l,NULL);
		if (readbuf[0]!=readbuf[2] || readbuf[1]!=readbuf[3]) {
			CloseHandle(adp->ch[0].infile);
			adp->ch[0].infile=INVALID_HANDLE_VALUE;
			return 1;
		}
	} else if (adp->ch[0].type!=type_adp) return 1; // we don't have the file name to recheck

	adp->ch[0].type=type_adp;

	
	adp->NCH = 2;
	adp->ch[0].sample_rate = 48000;
	adp->nrsamples = (int)(GetFileSize(adp->ch[0].infile,&l)*SEVEN_DIV_EIGHT);
	adp->ch[0].loop_flag=0;

	SetFilePointer(adp->ch[0].infile, adp->ch[0].chanstart, NULL, FILE_BEGIN);
	
    adp->file_length=GetFileSize(adp->ch[0].infile,NULL);

	adp->ch[0].lhist1 = 0;
    adp->ch[0].lhist2 = 0;
    adp->ch[1].lhist1 = 0;
    adp->ch[1].lhist2 = 0;

	adp->ch[0].readloc=adp->ch[1].readloc=adp->ch[0].writeloc=adp->ch[1].writeloc=0;

	SetFilePointer(adp->ch[0].infile,0,0,FILE_BEGIN);

	return 0;
}

void fillbufferADP(CUBEFILE * adp) {
	DWORD l;
	unsigned char ADPCMbuf[32];

	if ((signed long)SetFilePointer(adp->ch[0].infile,0,0,FILE_CURRENT) >= adp->file_length) {
		adp->ch[0].readloc=adp->ch[1].readloc=adp->ch[0].writeloc-1;
		return;
	}

	do {
		ReadFile(adp->ch[0].infile, ADPCMbuf, 32, &l, NULL);
		if (l<32) return;
		ADPdecodebuffer(ADPCMbuf,adp->ch[0].chanbuf+adp->ch[0].writeloc,
								 adp->ch[1].chanbuf+adp->ch[1].writeloc,
					&adp->ch[0].lhist1, &adp->ch[0].lhist2, &adp->ch[1].lhist1, &adp->ch[1].lhist2);

		adp->ch[0].writeloc+=28;
		adp->ch[1].writeloc+=28;

		if (adp->ch[0].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) adp->ch[0].writeloc=0;
		if (adp->ch[1].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) adp->ch[1].writeloc=0;
	} while (adp->ch[0].writeloc != adp->ch[0].readloc);
}

