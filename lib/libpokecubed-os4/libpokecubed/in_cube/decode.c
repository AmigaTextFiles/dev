/*

  in_cube Gamecube Stream Player for Winamp
  by hcs

  includes work by Destop and bero

*/

// decode functions (kept seperate since I didn't write the DSP or ADX decoders)
#include "../xmms_cube/windows.h"
#include "cube.h"

//================ C R A Z Y N A T I O N ===================================
//==========================================================================
// ADPCM decoder for Nintendo GAMECUBE dsp format, w/ modifications by hcs
//==========================================================================
// decode 8 bytes of input (1 frame, 14 samples)
long DSPdecodebuffer
(
    u8			*input, // location of encoded source samples
    s16         *out,   // location of destination buffer (16 bits / sample)
    short		coef[16],   // location of adpcm info
	short * histp,
	short * hist2p
)
{
int sample;
short nibbles[14];
int index1;
int i,j;
unsigned char *src;
char *dst;
short delta;
short hist=*histp;
short hist2=*hist2p;

	dst = (char*)out;

	src=input;
    i = *src&0xFF;
    src++;
    delta = 1 << (i & 255 & 15);
    index1 = (i & 255) >> 4;
	
    for(i = 0; i < 14; i = i + 2) {
		j = ( *src & 255) >> 4;
		nibbles[i] = j;
		j = *src & 255 & 15;
		nibbles[i+1] = j;
		src++;
	}

     for(i = 0; i < 14; i = i + 1) {
		if(nibbles[i] >= 8) 
			nibbles[i] = nibbles[i] - 16;       
     }
     
	 for(i = 0; i<14 ; i = i + 1) {

		sample = (delta * nibbles[i])<<11;
		sample += coef[index1*2] * hist;
		sample += coef[index1*2+1] * hist2;
		sample = sample + 1024;
		sample = sample >> 11;
		if(sample > 32767) {
			sample = 32767;
		}
		if(sample < -32768) {
			sample = -32768;
		}

        *(short*)dst = (short)sample;
        dst = dst + 2;

		hist2 = hist;
        hist = (short)sample;
        
    }
	*histp=hist;
	*hist2p=hist2;

    return((long)src);
}

// AFC decoder (guesswork and bullshit by hcs)

long AFCdecodebuffer
(
    u8			*input, // location of encoded source samples
    s16         *out,   // location of destination buffer (16 bits / sample)
    short		coef[16],   // location of adpcm info
	short * histp,
	short * hist2p
)
{
int sample;
short nibbles[16];
int i,j;
unsigned char *src;
char *dst;
short delta;
short hist=*histp;
short hist2=*hist2p;

	dst = (char*)out;

	src=input;
    i = *src&0xFF;
    src++;
    delta = i;

    for(i = 0; i < 16; i = i + 2) {
		j = ( *src & 255) >> 4;
		nibbles[i] = j;
		j = *src & 255 & 15;
		nibbles[i+1] = j;
		src++;
	}

     for(i = 0; i < 16; i = i + 1) {
		if(nibbles[i] >= 8) 
			nibbles[i] = nibbles[i] - 16;
     }
     
	 for(i = 0; i<16 ; i = i + 1) {

		sample = (delta * nibbles[i])<<12;
		/*switch( (i&0xc0)>>6)
		{
		case 0:
			sample += 0;
			break;
		case 1:
			sample += (hist * 0x3c);
			break;
		case 2:
			sample += (hist * 0x73) - (hist2 * 0x34);
			break;
		case 3:
			sample += (hist * 0x62) - (hist2 * 0x37);
			break;
		}*/
		//sample += (hist * 0x1e00) - (hist2 * 0xe80);
		//sample += (hist * 0x1000 * 1.875) - (hist2 * 0x1000 * 0.95);
		sample += (DWORD)((hist * HEX_1000_MUL_ONE_POINT_SEVEN) - (hist2 * HEX_1000_MUL_ZERO_POINT_SEVEN_THREE));
		sample += 1 << 11;
		sample = sample >> 12;

		if(sample > 32767) {
			sample = 32767;
		}
		if(sample < -32768) {
			sample = -32768;
		}

        *(short*)dst = (short)sample;
        dst = dst + 2;

		hist2 = hist;
        hist = (short)sample;
        
    }
	*histp=hist;
	*hist2p=hist2;

    return((long)src);
}

// ADX decoder (from bero)
// decode 18 bytes of input (32 frames)

long BASE_VOL = 0x2000;
int ADXdecodebuffer(unsigned char *in, short *out, short *hist1, short *hist2)
{

  int scale = ( (in[0] << 8) | (in[1]) ) * BASE_VOL;
  int i;
  int s0, s1, s2, d;

  in += 2;


  s1 = *hist1;
  s2 = *hist2;

  for (i = 0; i < 16; i++)
  {
    d = in[i] >> 4;

    if (d & 8)
    {
      d -= 16;
    }

    s0 = (d*scale + 0x7298*s1 - 0x3350*s2) >> 14;
	
    if (s0 > 32767)
    {
      s0 = 32767;
    }
    else if (s0 < -32768)
    {
      s0 = -32768;
    }

	*out++ = s0;
  
    s2 = s1;
    s1 = s0;

    d = in[i] & 15;

    if (d & 8)
    {
      d -= 16;
    }

    s0 = (d*scale + 0x7298*s1 - 0x3350*s2) >> 14;

    if (s0 > 32767)
    {
      s0 = 32767;
    }
    else if (s0 < -32768)
    {
      s0 = -32768;
    }

  	*out++ = s0;
	
    s2 = s1;
    s1 = s0;

  }

  *hist1 = s1;
  *hist2 = s2;

  return 0;
   
}

// ADP decoder function by hcs, reversed from dtkmake (trkmake v1.4)
// this is pretty much XA, isn't it?

#define ONE_BLOCK_SIZE		32
#define SAMPLES_PER_BLOCK	28

short ADPDecodeSample( int bits, int q, long * hist1p, long * hist2p) {
	long hist,cur;
	long hist1=*hist1p,hist2=*hist2p;
	
	switch( q >> 4 )
	{
	case 0:
		hist = 0;
		break;
	case 1:
		hist = (hist1 * 0x3c);
		break;
	case 2:
		hist = (hist1 * 0x73) - (hist2 * 0x34);
		break;
	case 3:
		hist = (hist1 * 0x62) - (hist2 * 0x37);
		break;
	//default:
	//	hist = (q>>4)*hist1+(q>>4)*hist2; // a bit weird but it's in the code, never used
	}
	hist=(hist+0x20)>>6;
	if (hist >  0x1fffff) hist= 0x1fffff;
	if (hist < -0x200000) hist=-0x200000;

	cur = ( ( (short)(bits << 12) >> (q & 0xf)) << 6) + hist;
	
	*hist2p = *hist1p;
	*hist1p = cur;

	cur>>=6;

	if ( cur < -0x8000 ) return -0x8000;
	if ( cur >  0x7fff ) return  0x7fff;

	return (short)cur;
}

// decode 32 bytes of input (28 samples), assume stereo
int ADPdecodebuffer(unsigned char *input, short *outl, short * outr, long *histl1, long *histl2, long *histr1, long *histr2) {
	int i;
	for( i = 0; i < SAMPLES_PER_BLOCK; i++ )
	{
		outl[i] = ADPDecodeSample( input[i + (ONE_BLOCK_SIZE - SAMPLES_PER_BLOCK)] & 0xf, input[0], histl1, histl2 );
		outr[i] = ADPDecodeSample( input[i + (ONE_BLOCK_SIZE - SAMPLES_PER_BLOCK)] >> 4, input[1], histr1, histr2 );
	}
	return 0;
}
