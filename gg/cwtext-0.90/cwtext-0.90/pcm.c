/*
cwpcm - pcm audio generator for cwtext
Copyright (C) 2001 Randall S. Bohn

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  
*/

#include <math.h>
#include <stdio.h>

#include "pcm.h"

#define voxref(n) (vox[n-1])
#define TWOPI 6.28

typedef struct voice {
 int wavelen;
 int amplitude;
 int ZERO;
} tVoice;

// allocate three voices
tVoice vox[MAXVOX];
int voxmap[MAXVOX] = {0,0,0};

int valid(int hvox) {
 if (hvox > MAXVOX) return 0;
 if (hvox < 1) return 0;
 if (voxmap[hvox-1] == 0) return 0;
 return 1;
}
 
char wavepoint(int hvox, int pos) {
 char rv = voxref(hvox).ZERO;
 rv += voxref(hvox).amplitude * sin(pos*TWOPI/voxref(hvox).wavelen);
 return rv;
}

char zeropoint(int hvox) {
 return voxref(hvox).ZERO;
}

void mark(int hvox, int duration, FILE *out) {
 int x;
 if (!valid(hvox)) return;
 for (x = 0; x < duration; x++) {
  fputc(wavepoint(hvox, x), out);
 }
}
void space(int hvox, int duration, FILE *out) {
 int x;
 if (!valid(hvox)) return;
 for (x = 0; x < duration; x++) {
  fputc(zeropoint(hvox), out);
 }
}

int setAmplitude(int hvox, int amp) {
 if (!valid(hvox)) return 0;
 voxref(hvox).amplitude = amp;
 return hvox;
}
int setFrequency(int hvox, int hz, int rate) {
 if (!valid(hvox)) return 0;
 if (hz > rate) hz = rate/16;
 voxref(hvox).wavelen = rate/hz;
 return hvox;
}

int nextFreeVoice() {
 int x;
 for (x = 0; x < MAXVOX; x++) {
  if (voxmap[x] == 0) {
   voxmap[x] = 1;
   return x+1;
  }
 }
 return 0;
}

void freeVoice(int hvox) {
 if (valid(hvox)) {
  voxmap[hvox-1] = 0;
 }
}
int voiceFactory(int freq, int amplitude, int zero, int samplerate) {
 int hvox = nextFreeVoice();
 if (hvox == 0) return 0;
 voxref(hvox).amplitude = amplitude;
 voxref(hvox).ZERO = zero;
 setFrequency(hvox, freq, samplerate);
 return hvox;
}
