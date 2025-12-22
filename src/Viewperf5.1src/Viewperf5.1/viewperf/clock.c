/*
// Permission to use, copy, modify, and distribute this software and its
// documentation for any purpose and without fee is hereby granted, provided
// that the above copyright notice appear in all copies and that both that
// copyright notice and this permission notice appear in supporting
// documentation, and that the name of I.B.M. not be used in advertising
// or publicity pertaining to distribution of the software without specific,
// written prior permission. I.B.M. makes no representations about the
// suitability of this software for any purpose.  It is provided "as is"
// without express or implied warranty.
//
// I.B.M. DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL I.B.M.
// BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
// OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
// CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//
// Author:  Marc Andreessen, Barry Minor, IBM AWS Graphics Systems (Austin)
// Special Thanks to the Men and Women of DEC ...
*/

#include <stdio.h>
#include <math.h>
#ifdef WIN32
#include <windows.h>
static DWORD gtime;
#elif defined(OS2)
#include <time.h>
#include <stdlib.h>
static int gtime;
#else
#include <sys/types.h>
#include <sys/times.h>
#include <sys/param.h>
#include <time.h>
static struct tms tbuf;
static int gtime;
#endif

#include <GL/gl.h>
#include "viewperf.h"

float roundit( float number )
{
    /* round number to 3 significant digits */
    char s[15];
    float rounded;
    sprintf(s,"%0.2e", number );
    rounded = (float) atof(s);
    return rounded;
}

void startclock (void) 
{
#ifdef WIN32
  gtime = GetTickCount();
#elif defined(OS2)
  gtime = clock();
#else
  gtime = times(&tbuf);
#endif
  
  return;
}

float stopclock (void)
{
  float period;
  
#ifdef WIN32
  period = (float)(GetTickCount() - gtime) / 1000.0;
#elif defined(OS2)
  period = (float)(clock() - gtime) / (float)CLK_TCK;
#else
  period = (float)(times(&tbuf) - gtime) / (float)CLK_TCK;
#endif
  return period;
}

