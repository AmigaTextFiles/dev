/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero


*/

// experimental AFC support
#include "../xmms_cube/windows.h"
#include "wamain.h"
#include "cube.h"

int InitAFCFILE(char * inputfile, CUBEFILE * afc) {
	unsigned char readbuf[0x50];
   char * ext;
	DWORD l;
	
	ext=strrchr(inputfile,'.')+1;
	if (ext==(char*)1 || strcmpi(ext,"afc")) return 1; // only check for .afcextension

	if (inputfile) {
		afc->ch[0].infile=afc->ch[1].infile=INVALID_HANDLE_VALUE;

		afc->ch[0].infile = CreateFile(inputfile,GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,
			OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);

		if (afc->ch[0].infile == INVALID_HANDLE_VALUE) // error opening file
			return 1;
	} else if (afc->ch[0].type!=type_afc) return 1; // we don't have the file name to recheck

	afc->ch[1].infile=afc->ch[0].infile;

	ReadFile(afc->ch[0].infile,readbuf,0x50,&l,NULL);

	afc->file_length=GetFileSize(afc->ch[0].infile,NULL);

	afc->NCH = 2;
	afc->ch[0].sample_rate = (unsigned short)get16bit(readbuf+8);
	if (!CheckSampleRate(afc->ch[0].sample_rate)) {
		CloseCUBEFILE(afc);
		return 1;
	}

	afc->ch[0].chanstart = 0x20;
	afc->ch[0].hist1=0;
	afc->ch[0].hist2=0;
	afc->ch[1].hist1=0;
	afc->ch[1].hist2=0;
	afc->ch[0].type = type_afc;

	afc->ch[0].offs=afc->ch[0].chanstart;
	afc->ch[0].num_samples = get32bit(readbuf+4); //(GetFileSize(afc->ch[0].infile,&l)-afc->ch[0].chanstart)*16/18;
	afc->ch[0].loop_flag = get32bit(readbuf+0x10);
	afc->ch[0].sa = get32bit(readbuf+0x14);
	afc->ch[0].ea = afc->ch[0].num_samples;

	if (!afc->ch[0].loop_flag) afc->nrsamples = afc->ch[0].num_samples;
	else afc->nrsamples=afc->ch[0].sa+looptimes*(afc->ch[0].ea-afc->ch[0].sa)+(fadelength+fadedelay)*afc->ch[0].sample_rate;
	
	afc->ch[0].readloc=afc->ch[1].readloc=afc->ch[0].writeloc=afc->ch[1].writeloc=0;

	return 0;
}

void fillbufferAFC(CUBEFILE * afc) {
	DWORD l;
   int i;
	unsigned char AFCbuf[18];
	short wavbuf[32];

	SetFilePointer(afc->ch[0].infile,afc->ch[0].offs,0,FILE_BEGIN);

	do {
		ReadFile(afc->ch[0].infile, AFCbuf, 18, &l, NULL);
		if (l<18) {
			// only seems to support loop from end
			if (afc->ch[0].loop_flag) {
				afc->ch[0].offs=afc->ch[0].chanstart+afc->ch[0].sa/SIXTEEN_MUL_EIGHTEEN;
				SetFilePointer(afc->ch[0].infile,afc->ch[0].offs,0,FILE_BEGIN);
				continue;
			}
			return;
		}
		afc->ch[0].offs+=18;

		AFCdecodebuffer(AFCbuf,wavbuf,afc->ch[0].coef,&afc->ch[0].hist1,&afc->ch[0].hist2);
		AFCdecodebuffer(AFCbuf+9,wavbuf+16,afc->ch[1].coef,&afc->ch[1].hist1,&afc->ch[1].hist2);

		for (i=0;i<16;i++) {
			afc->ch[0].chanbuf[afc->ch[0].writeloc++]=wavbuf[i];
			if (afc->ch[0].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) afc->ch[0].writeloc=0;
			afc->ch[1].chanbuf[afc->ch[1].writeloc++]=wavbuf[i+16];
			if (afc->ch[1].writeloc>=HEX_8000_DIV_EIGHT_MUL_FOURTEEN) afc->ch[1].writeloc=0;
		}
	} while (afc->ch[0].writeloc != afc->ch[0].readloc);

}
