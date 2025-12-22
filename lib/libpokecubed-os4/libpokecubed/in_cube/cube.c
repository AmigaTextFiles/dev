/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero

*/

// not specific to formats
#include "../xmms_cube/windows.h"
#include "cube.h"

int get16bit(unsigned char* p)
{
	return (p[0] << 8) | p[1];
}

int get32bit(unsigned char* p)
{
	return (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3];
}

int get16bitL(unsigned char* p)
{
	return p[0] | (p[1] << 8);
}

int get32bitL(unsigned char* p)
{
	return p[0] | (p[1] << 8) | (p[2] << 16) | (p[3] << 24);
}

void fillbuffers(CUBEFILE * cf) {
	switch (cf->ch[0].type) {
	case type_adx03:
	case type_adx04:
		fillbufferADX(cf);
		break;
	case type_adp:
		fillbufferADP(cf);
		break;
	case type_rsdpcm:
		fillbufferPCM(cf);
		break;
	case type_astpcm:
		fillbufferASTPCM(cf);
		break;
	case type_afc:
		fillbufferAFC(cf);
		break;
	case type_halp:
		fillbufferHALP(cf);
		break;
	default:
		if (cf->ch[0].interleave) {
			fillbufferDSPinterleave(cf);
		} else {
			fillbufferDSP(&cf->ch[0]);
			if (cf->NCH==2)
				fillbufferDSP(&cf->ch[1]);
		}
	}
}

int InitCUBEFILE(char * fn, CUBEFILE * cf) {
	//if (!InitPCMFILE(fn,&cf) || !InitADPFILE(fn,&cf) || !InitADXFILE(fn,&cf) || !InitDSPFILE(fn,&cf)) return 0;
	return InitAFCFILE(fn,cf) && InitPCMFILE(fn,cf) && InitADPFILE(fn,cf) && InitADXFILE(fn,cf) && InitDSPFILE(fn,cf);
}

void CloseCUBEFILE(CUBEFILE * cf) {
	if (cf->ch[0].infile != INVALID_HANDLE_VALUE) CloseHandle(cf->ch[0].infile);
	if (cf->ch[1].infile != cf->ch[0].infile && cf->ch[1].infile != INVALID_HANDLE_VALUE) CloseHandle(cf->ch[1].infile);
	cf->ch[0].infile=cf->ch[1].infile=INVALID_HANDLE_VALUE;
}

// return true for good sample rate
int CheckSampleRate(int sr) {
	// I got a threshold for the abuse I'll take.
	// (sample rate outside of this range indicates a bad file)
	return !(sr<1000 || sr>96000);
}

