/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero

*/

// ADX (headered CRI stream)
#include "../xmms_cube/windows.h"
#include "cube.h"
#include "wamain.h"

int adxonechan =0; // == 0 if not in onechan mode, otherwise is 1-based channel number

// inputfile == NULL means file is already opened, just reload
// return 1 if valid ADX not detected, 0 on success
int InitADXFILE(char * inputfile, CUBEFILE * adx) {
	unsigned char readbuffer[4096],*preadbuf;
	DWORD l;
	int offs;

	if (inputfile) {
		adx->ch[0].infile=adx->ch[1].infile=INVALID_HANDLE_VALUE;
		adx->ch[0].infile = CreateFile(inputfile,GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,
			OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);

		if (adx->ch[0].infile == INVALID_HANDLE_VALUE) // error opening file
		{
			return 1;
		}
	}

	SetFilePointer(adx->ch[0].infile,0,0,FILE_BEGIN);
	
	ReadFile(adx->ch[0].infile, readbuffer, 4096, &l, NULL);

	if(readbuffer[0] != 0x80) 
	{
		// check for valid ADX at 0x20 (Sonic Mega Collection)

		if (readbuffer[0x20] != 0x80) {

			// not ADX
			if (inputfile) {
				CloseHandle(adx->ch[0].infile);
				adx->ch[0].infile=INVALID_HANDLE_VALUE;
			}
			return 1;
		} else preadbuf=readbuffer+(offs=0x20);
	} else preadbuf=readbuffer+(offs=0);

	adx->ch[0].chanstart = get16bit(&preadbuf[2])+4;
	adx->ch[1].chanstart = get16bit(&preadbuf[2])ADD_FOUR_ADD_EIGHTEEN;

 	if(adx->ch[0].chanstart < 0 || adx->ch[0].chanstart > 4096 || memcmp(preadbuf+adx->ch[0].chanstart-6,"(c)CRI",6)) 
	{
		// not ADX
		if (inputfile) {
			CloseHandle(adx->ch[0].infile);
			adx->ch[0].infile=INVALID_HANDLE_VALUE;
		}
		return 1;
	}

	adx->ADXCH = adx->NCH = (int)preadbuf[7];

	if (adxonechan) adx->NCH=1;
	else if (adx->NCH>2) {
		if (inputfile) {
			CloseHandle(adx->ch[0].infile);
			adx->ch[0].infile=INVALID_HANDLE_VALUE;
		}
		return 1;
	}
	adx->ch[0].sample_rate = get32bit(&preadbuf[8]);
	adx->nrsamples = get32bit(&preadbuf[12]);
		
	// check version code, set up looping appropriately
	if (get32bit(&preadbuf[0x10])==0x01F40300) { // Soul Calibur 2
			if (adx->ch[0].chanstart-6 < 0x2c) adx->ch[0].loop_flag=0; // if header is too small for loop data...
			else {
				adx->ch[0].loop_flag = get32bit(&preadbuf[0x18]);
				adx->ch[0].ea = get32bit(&preadbuf[0x28]);
				adx->ch[0].sa = (int)(get32bit(&preadbuf[0x1c])*adx->NCH*EIGHTEEN_DIV_THIRTY_TWO+adx->ch[0].chanstart);
			}
			adx->ch[0].type = type_adx03;
	} else if (get32bit(&preadbuf[0x10])==0x01F40400) {
			if (adx->ch[0].chanstart-6 < 0x38) adx->ch[0].loop_flag=0; // if header is too small for loop data...
			else {
				adx->ch[0].loop_flag = get32bit(&preadbuf[0x24]);
				adx->ch[0].ea = get32bit(&preadbuf[0x34]);
				adx->ch[0].sa = (int)(get32bit(&preadbuf[0x28])*adx->NCH*EIGHTEEN_DIV_THIRTY_TWO+adx->ch[0].chanstart);
			}
			adx->ch[0].type = type_adx04;
	} else {
		if (inputfile) {
			CloseHandle(adx->ch[0].infile);
			adx->ch[0].infile=INVALID_HANDLE_VALUE;
		}
		return 1;
	}

	adx->ch[0].sa+=offs;
	adx->ch[0].ea+=offs;
	adx->ch[0].chanstart+=offs;
	adx->ch[1].chanstart+=offs;

	if (adx->ch[0].loop_flag) 
        adx->nrsamples=((adx->ch[0].sa-adx->ch[0].chanstart)+(adx->ch[0].ea-adx->ch[0].sa)*looptimes)*
                        32/adx->NCH/18+(fadelength+fadedelay)*adx->ch[0].sample_rate;

	SetFilePointer(adx->ch[0].infile, adx->ch[0].chanstart, NULL, FILE_BEGIN);
	
    adx->file_length=GetFileSize(adx->ch[0].infile,NULL);

	adx->ch[0].hist1 = 0;
    adx->ch[0].hist2 = 0;
    adx->ch[1].hist1 = 0;
    adx->ch[1].hist2 = 0;

	adx->ch[0].readloc=adx->ch[1].readloc=adx->ch[0].writeloc=adx->ch[1].writeloc=0;

	return 0;
}

void fillbufferADX(CUBEFILE * adx) {
	int i,j;
   DWORD l;
	short decodebuf[32];
	unsigned char ADPCMbuf[18];

	if ((signed long)SetFilePointer(adx->ch[0].infile,0,0,FILE_CURRENT) >= adx->file_length && !adx->ch[0].loop_flag) {
		adx->ch[0].readloc=adx->ch[1].readloc=adx->ch[0].writeloc-1;
		return;
	}

	do {
		if (adx->ch[0].loop_flag && SetFilePointer(adx->ch[0].infile,0,0,FILE_CURRENT) >= adx->ch[0].ea) {
			//DisplayError("loop");
			SetFilePointer(adx->ch[0].infile,adx->ch[0].sa,0,FILE_BEGIN);
		}

		l = 0;

		for (j=0;j<adx->ADXCH;j++) {
			if (adxonechan && j+1!=adxonechan) SetFilePointer(adx->ch[0].infile,18,0,FILE_CURRENT);
			else {
				ReadFile(adx->ch[0].infile, ADPCMbuf, 18, &l, NULL);
				if (l<18) return;

				if (adxonechan) {
					ADXdecodebuffer(ADPCMbuf,decodebuf, &adx->ch[0].hist1, &adx->ch[0].hist2);
					for(i = 0; i < 32; i++)
						adx->ch[0].chanbuf[adx->ch[0].writeloc+i] = decodebuf[i];
				} else {
					ADXdecodebuffer(ADPCMbuf,decodebuf, &adx->ch[j].hist1, &adx->ch[j].hist2);
					for(i = 0; i < 32; i++)
						adx->ch[j].chanbuf[adx->ch[j].writeloc+i] = decodebuf[i];
				}
			}
		}
		adx->ch[0].writeloc+=32;
		if (adx->ch[0].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) adx->ch[0].writeloc=0;
		
		if (adx->NCH==2) {
			adx->ch[1].writeloc+=32;
			if (adx->ch[1].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) adx->ch[1].writeloc=0;
		}
	} while (adx->ch[0].writeloc != adx->ch[0].readloc);
} 

