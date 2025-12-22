/* cwpcm.c - text to International Morse Code converter 
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
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "morse.h"
#include "pcm.h"

/* 1666 msec * 8 samples per msec */
#define tbase 13328
#define csegment (tbase/cwpm)
#define wsegment (tbase/wwpm)
/* 900 Hz */
#define PITCH 900

/* rates (character, word) for various speeds (slow|med|fast|extra) */
#define CSLOW 12
#define WSLOW 5
#define CMED 18
#define WMED 12
#define CFAST 18
#define WFAST 18
#define CEXTRA 20
#define WEXTRA 20

/* program settings */
int pcm = 1;
int hvox = 0;
/* audio character rate */
int cwpm = CFAST;
/* audio word rate */
int wwpm = WFAST;

/* morse-speak: */
void dit(FILE *out) {
 mark(hvox, csegment, out);
 space(hvox, csegment, out);
}
void dah(FILE *out) {
 mark(hvox, csegment * 3, out);
 space(hvox, csegment, out);
}
void err(FILE *out) {
}

void cspace(FILE *out) {
 space(hvox, wsegment, out);
}
void wspace(FILE *out) {
 space(hvox, wsegment, out);
 fflush(out);
}

void setupVoice(int hz, int amp) {
 hvox = voiceFactory(hz, amp, 128, 8000);
}

int main(int argc, char **argv) {
 int ch, x;
 FILE *out = stdout;
 /* decode startup options */
 for (x = 0; x < argc; x++) {
  if (strcmp(argv[x], "-ss")==0) {
   cwpm = CSLOW;
   wwpm = WSLOW;
  }
  if (strcmp(argv[x], "-sm")==0) {
   cwpm = CMED;
   wwpm = WMED;
  }
  if (strcmp(argv[x], "-sf")==0) {
   cwpm = CFAST;
   wwpm = WFAST;
  }
  if (strcmp(argv[x], "-sx")==0) {
   cwpm = CEXTRA;
   wwpm = WEXTRA;
  }
 }
 setupVoice(PITCH, 90);

 while ((ch = fgetc(stdin)) != EOF) {
  if (isspace(ch)) wspace(out);
  else genMorse(tolower(ch), out);
 }
 return 0;
}
