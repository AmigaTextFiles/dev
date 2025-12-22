/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero

*/

// 16-bit PCM
#include "../xmms_cube/windows.h"
#include "wamain.h"
#include "cube.h"

// inputfile == NULL means file is already opened, just reload
// return 1 if valid ADP not detected, 0 on success
int InitPCMFILE(char * inputfile, CUBEFILE * pcm) {
	unsigned char readbuf[0x50];
	DWORD l;


	if (inputfile) {
		pcm->ch[0].infile=pcm->ch[1].infile=INVALID_HANDLE_VALUE;

		pcm->ch[0].infile = CreateFile(inputfile,GENERIC_READ,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,
			OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);

		if (pcm->ch[0].infile == INVALID_HANDLE_VALUE) // error opening file
			return 1;
	} else if (pcm->ch[0].type!=type_rsdpcm) return 1; // we don't have the file name to recheck

	pcm->ch[1].infile=pcm->ch[0].infile;

	ReadFile(pcm->ch[0].infile,readbuf,0x50,&l,NULL);

	pcm->file_length=GetFileSize(pcm->ch[0].infile,NULL);

	if (!memcmp(readbuf,"RSD3PCMB",8) || !memcmp(readbuf,"RSD2PCMB",8)) {
		// RSD (PCM type(s))
		
		pcm->NCH = get32bitL(readbuf+8); // I think
		pcm->ch[0].sample_rate = get32bitL(readbuf+0x10);
		pcm->ch[0].chanstart = get32bitL(readbuf+0x18);
		pcm->ch[0].num_samples = (GetFileSize(pcm->ch[0].infile,&l)-pcm->ch[0].chanstart)/(2*pcm->NCH);
		pcm->ch[0].loop_flag=0;
		pcm->ch[0].type = type_rsdpcm;
	} else if (!memcmp(readbuf, "STRM",4) && pcm->file_length-0x40 == get32bit(readbuf+4) && !memcmp(readbuf+0x40,"BLCK",4) && !memcmp(readbuf+0x48,"\0\0\0\0\0\0\0\0",8)) {
		// AST (PCM with interleaved blocks)
		pcm->NCH = 2; // 'cause dat's all I gots
		pcm->ch[0].sample_rate = get32bit(readbuf+0x10);
		pcm->ch[0].chanstart = 0x40;
		pcm->ch[1].chanstart = 0x40;
		pcm->ch[0].num_samples = get32bit(readbuf+0x14);
		pcm->ch[0].loop_flag = get16bit(readbuf+0xe);
		pcm->ch[0].sa = get32bit(readbuf+0x18);
		pcm->ch[0].ea = get32bit(readbuf+0x1c);

		pcm->samplesdone = 0;

		// uses a very HALP-like mechanism, BLCK
		pcm->nexthalp=0x40;
		pcm->halpsize=0;
		
		// invalidate loop context so it'll be remembered when we hit the start
		pcm->loophalpsize=-1;
		
		pcm->ch[0].type = type_astpcm;
	} else {
		
		CloseHandle(pcm->ch[0].infile);
		pcm->ch[0].infile=INVALID_HANDLE_VALUE;
		return 1;
	}

	if (!pcm->ch[0].loop_flag) pcm->nrsamples = pcm->ch[0].num_samples;
	else pcm->nrsamples=pcm->ch[0].sa+looptimes*(pcm->ch[0].ea-pcm->ch[0].sa)+(fadelength+fadedelay)*pcm->ch[0].sample_rate;
	
	pcm->ch[0].readloc=pcm->ch[1].readloc=pcm->ch[0].writeloc=pcm->ch[1].writeloc=0;
	
	SetFilePointer(pcm->ch[0].infile,pcm->ch[0].chanstart,NULL,FILE_BEGIN);

	return 0;
}

// standard sample-level interleave

void fillbufferPCM(CUBEFILE * pcm) {
	DWORD l;
   int i;
	unsigned char PCMbuf[8];

	if ((signed long)SetFilePointer(pcm->ch[0].infile,0,0,FILE_CURRENT) >= pcm->file_length) {
		pcm->ch[0].readloc=pcm->ch[1].readloc=pcm->ch[0].writeloc-1;
		return;
	}

	do {
		ReadFile(pcm->ch[0].infile, PCMbuf, pcm->NCH*2, &l, NULL);
		if (l<pcm->NCH*2) return;

		for (i=0;i<pcm->NCH;i++) {
			pcm->ch[i].chanbuf[pcm->ch[i].writeloc]=get16bit(PCMbuf+i*2);
			pcm->ch[i].writeloc++;
			if (pcm->ch[i].writeloc>=0x8000/8*14) pcm->ch[i].writeloc=0;
		}
	} while (pcm->ch[0].writeloc != pcm->ch[0].readloc);

}

// AST blocked interleave (adapted from HALPST decoder)


// faster (but inaccurarate upon looping) 4-samples-at-a-time version
/*void fillbufferASTPCM(CUBEFILE * pcm) {
	int l,i,c;
	char PCMbuf1[8],PCMbuf2[8];

	if (pcm->halpsize==0 && (long)pcm->nexthalp == 0) pcm->ch[0].readloc=pcm->ch[1].readloc=pcm->ch[0].writeloc-1;

	i=0;
	
	do {
		if (i==0) {
			// handle BLCK headers
			if (pcm->halpsize==0) {
				if ((long)pcm->nexthalp == 0) return;
				pcm->ch[0].offs=pcm->nexthalp+0x20;
				SetFilePointer(pcm->ch[0].infile, pcm->nexthalp,0,FILE_BEGIN);
				ReadFile(pcm->ch[0].infile, PCMbuf1, 8, &l, NULL);
				if (l<8) return;
				pcm->halpsize=get32bit(PCMbuf1+4)*2; // interleave amount (this whole BLCK is 2x)
								
				pcm->ch[1].offs=pcm->nexthalp+0x20+get32bit(PCMbuf1+4);
				pcm->nexthalp+=get32bit(PCMbuf1+4)*2+0x20;
			}

			SetFilePointer(pcm->ch[0].infile, pcm->ch[0].offs,0,FILE_BEGIN);
			ReadFile(pcm->ch[0].infile, PCMbuf1, 8, &l, NULL);

			SetFilePointer(pcm->ch[0].infile, pcm->ch[1].offs,0,FILE_BEGIN);
			ReadFile(pcm->ch[0].infile, PCMbuf2, 8, &l, NULL);			

			pcm->ch[0].offs+=8;
			pcm->ch[1].offs+=8;
			
			pcm->halpsize-=0x10;
			if (pcm->halpsize<0x10) pcm->halpsize=0;

			
			c=0;
			i=4;
		}

		pcm->ch[0].chanbuf[pcm->ch[0].writeloc++]=get16bit(PCMbuf1+c);
		pcm->ch[1].chanbuf[pcm->ch[1].writeloc++]=get16bit(PCMbuf2+c);

		pcm->samplesdone++;
		if (pcm->ch[0].loop_flag && pcm->loophalpsize < 0 && pcm->samplesdone >= (int)pcm->ch[0].sa) {
			// a lot of these values could probably just be recalculated, but it's easy to save them
			pcm->loophalpsize = pcm->halpsize-2*c;
			pcm->loopnexthalp = pcm->nexthalp;
			pcm->ch[0].loopoffs = pcm->ch[0].offs-8+c;
			pcm->ch[1].loopoffs = pcm->ch[1].offs-8+c;
		} else if (pcm->ch[0].loop_flag && pcm->samplesdone >= (int)pcm->ch[0].ea) {
			pcm->halpsize = pcm->loophalpsize;
			pcm->nexthalp = pcm->loopnexthalp;
			pcm->ch[0].offs = pcm->ch[0].loopoffs;
			pcm->ch[1].offs = pcm->ch[1].loopoffs;
			pcm->samplesdone = pcm->ch[0].sa;
			i=0;
		} else {
			i--;
			c+=2;
		}
			
		if (pcm->ch[0].writeloc>=0x8000/8*14) pcm->ch[0].writeloc=0;
		if (pcm->ch[1].writeloc>=0x8000/8*14) pcm->ch[1].writeloc=0;
	} while (pcm->ch[0].writeloc != pcm->ch[0].readloc);
}*/

// one sample (pair) at a time, quite slow on the reading but makes accuracy easier
void fillbufferASTPCM(CUBEFILE * pcm) {
	DWORD l;
	unsigned char PCMbuf1[8],PCMbuf2[8];

	if (pcm->halpsize==0 && (long)pcm->nexthalp == 0) pcm->ch[0].readloc=pcm->ch[1].readloc=pcm->ch[0].writeloc-1;
	
	do {
			// handle BLCK headers
			if (pcm->halpsize==0) {
				if ((long)pcm->nexthalp == 0) return;
				pcm->ch[0].offs=pcm->nexthalp+0x20;
				SetFilePointer(pcm->ch[0].infile, pcm->nexthalp,0,FILE_BEGIN);
				ReadFile(pcm->ch[0].infile, PCMbuf1, 8, &l, NULL);
				if (l<8) return;
				pcm->halpsize=get32bit(PCMbuf1+4)*2; // interleave amount (this whole BLCK is 2x)
								
				pcm->ch[1].offs=pcm->nexthalp+0x20+get32bit(PCMbuf1+4);
				pcm->nexthalp+=get32bit(PCMbuf1+4)*2+0x20;
			}

			SetFilePointer(pcm->ch[0].infile, pcm->ch[0].offs,0,FILE_BEGIN);
			ReadFile(pcm->ch[0].infile, PCMbuf1, 2, &l, NULL);

			SetFilePointer(pcm->ch[0].infile, pcm->ch[1].offs,0,FILE_BEGIN);
			ReadFile(pcm->ch[0].infile, PCMbuf2, 2, &l, NULL);			

			pcm->ch[0].offs+=2;
			pcm->ch[1].offs+=2;
			
			pcm->halpsize-=4;
			if (pcm->halpsize<4) pcm->halpsize=0;

			pcm->samplesdone++;
			if (pcm->loophalpsize < 0 && pcm->samplesdone >= (int)pcm->ch[0].sa) {
				// a lot of these values could probably just be recalculated, but it's easy to save them
				pcm->loophalpsize = pcm->halpsize;
				pcm->loopnexthalp = pcm->nexthalp;
				pcm->ch[0].loopoffs = pcm->ch[0].offs;
				pcm->ch[1].loopoffs = pcm->ch[1].offs;
			}
			if (pcm->samplesdone >= (int)pcm->ch[0].ea) {
				pcm->halpsize = pcm->loophalpsize;
				pcm->nexthalp = pcm->loopnexthalp;
				pcm->ch[0].offs = pcm->ch[0].loopoffs;
				pcm->ch[1].offs = pcm->ch[1].loopoffs;
				pcm->samplesdone = pcm->ch[0].sa;
			}
		
			pcm->ch[0].chanbuf[pcm->ch[0].writeloc++]=get16bit(PCMbuf1);
			pcm->ch[1].chanbuf[pcm->ch[1].writeloc++]=get16bit(PCMbuf2);
			
			if (pcm->ch[0].writeloc>=0x8000/8*14) pcm->ch[0].writeloc=0;
			if (pcm->ch[1].writeloc>=0x8000/8*14) pcm->ch[1].writeloc=0;
	} while (pcm->ch[0].writeloc != pcm->ch[0].readloc);
}

