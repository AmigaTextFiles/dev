/*
**		$VER: easyFFTtest.c 2.0 (13.7.97)
**    Release 2.0
**
**		easyFFT.library test example
**
**    Copyright (c) 1997 Alexander Marx
**		All rights reserved.
**
**
** ------------------------------------------
**
** This example is provided "as-is" and is subject to change; no
** warranties are made.  All use is at your own risk. No liability or
** responsibility is assumed.
**
** (The compiled example file takes use of the
**  mathieeedoubbas.library and the mathieeedoubtrans.library;
**  however, the math used for FFT still depends on the
**  version of easyFFT you have installed!)
**
** ------------------------------------------ */


/* 
** Delete the following line to compile without
** the timer.device stuff in the example
*/
#define DO_TIMING



/* ------------- Include files follow ------- */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifdef _M68881
#include <m68881.h>
#endif

#ifdef _MIEEE
#include <mieeedou.h>
#endif

#include <proto/exec.h>


/* 
** those are now the include files
** for our little library
*/
#include <libraries/easyFFT.h>
#include <proto/easyFFT.h>




/* 
** the following is only for 
** the timing stuff.
*/
#ifdef DO_TIMING
#include <devices/timer.h>
#include <proto/timer.h>

/* ---------------------------- */

struct EClockVal *time1, *time2;
ULONG E_Freq;
long error;
struct timerequest *TimerIO;
struct Library *TimerBase;

void starttime(void);
void stoptime(void);
void prttime(void);
#endif




/* ----------- Global vriables -------------- */

struct Library *eFFTbase=NULL;	/* this will become our library base */
double smpldat[256], FFTamp[256], FFTpha[256], syndat[256];


/* ----------- Main function ---------------- */

int main(int argc, char *argv[])
{
   int i, rc=0;
	double *dptr;
   APTR  myhl=NULL;	/* and this will become our handle */
   
   printf("easyFFT.library test example\n\n");
   printf("Copyright (c) 1997 Alexander Marx\nAll rights reserved.\n\n");

/*
** and again, timing stuff follows
*/
#ifdef DO_TIMING
	if(NULL==(TimerIO=(struct timerequest *)calloc(1, sizeof(struct timerequest))))
	{
		puts("ERROR: Failed to setup timer.device!");
		rc=20;
	}
	else
	{
		if(NULL==(time1=(struct EClockVal *)calloc(1, sizeof(struct EClockVal))))
		{
			puts("ERROR: Failed to setup timer device!");
			rc=20;
		}
		else
		{
			if(NULL==(time2=(struct EClockVal *)calloc(1, sizeof(struct EClockVal))))
			{
				puts("ERROR: Failed to setup timer device!");
				rc=20;
			}
			else
			{
				if((error=OpenDevice(TIMERNAME, UNIT_ECLOCK, (struct IORequest *)TimerIO, 0L)))
				{
					puts("ERROR: Failed to open timer device!");
					rc=20;
				}
				else
				{
					puts("STAT.: Timer device properly initialized now.");
					TimerBase=(struct Library *)TimerIO->tr_node.io_Device;
#endif

/*
** now the actual adventure into
** FFT begins;
** -> first open the library
*/

               if(NULL==(eFFTbase=OpenLibrary("easyFFT.library", 2)))
               {
	               puts("ERROR: Failed to open easyFFT.library V2.0!");
                  rc=20;
               }
               else
               {
       	      	puts("STAT.: Opened easyFFT.library V2.0.");

/* 
** now get a handle
** to show you, how the library
** handles a val not equal to 2^k
** we try to set num to 150;
*/
                	if(NULL==(myhl=eFFTnew(150)))
                	{
         	      	puts("ERROR: Failed to get handle!");
                  	rc=20;
                	}
               	else
               	{

/*
** so we got the handle;
** let's see the value of num;
** we use the function eFFTgetdat to
** look a that parameter, and ... ah -> num=128;
**
** BTW num and the sampling are the only parameters
** from type ULONG, everything else is stored
** internally as double !!
*/             	 		
							puts("STAT.: Got handle from easyFFT.library. (150 samples)");
               		printf("---> : Ah, library's set samples to %d\n", (*(ULONG *)eFFTgetdat(myhl, eFFT_NUM)));
               		
/*
** to show you the *new* features
** of V2.0, we set now num to 256 (althought 256 > 128 !!!)
** using the function eFFTsetdat;
*/
							if(FALSE==(eFFTsetdat(myhl, eFFT_NUM, 256)))
               		{
               			puts("ERROR: Failed to set samples to 256.");
               			rc=20;
               		}
               		else
               		{
/*
** ok, now let's have a look at
** the num value;
*/
								puts("ACT. : Set Samples to 256.");
               			printf("---> : Ok, library's set samples to %d\n", (*(ULONG *)eFFTgetdat(myhl, eFFT_NUM)));
               			
               			
/* --------- Do Analizing now ------------ */             			
								
								
/*
** it's now neccessary but set
** the sampling rate here because
** need it later anyway for
** the synthesizing stuff
*/
								puts("ACT. : Set sampling rate to 6400 S/s.");
								eFFTsetdat(myhl, eFFT_SRATE, 6400);
								printf("---> : Ok, library's set sampling rate to %d\n", (*(ULONG *)eFFTgetdat(myhl, eFFT_SRATE)));
								printf("---> : Ok, library's set FFT resolution to %f\n", (*(double *)eFFTgetdat(myhl, eFFT_RESOL)));
								
/*
** here we 'sample' a sin wave
** at 8 bit resolution, 50 Hz and 6400 S/s
** to add a quantizing error
** we round the double values to
** type integer, like a
** *perfect* 8 bit sampler
** -> this will produce
** harmonics at higher freqs;
** but you will see it anyway in the printed spectrum...
*/

								puts("ACT. : 'Sample' sin with 50Hz and 8 bit resolution.");
#ifdef DO_TIMING
								starttime();
#endif
								for(i=0;i<256;i++)
									smpldat[i]=(double)((int)(128.0*sin(2*PI*50*(1/(double)6400)*i)));
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif

/*
** tell the library where your
** signal is stored
*/
								eFFTsetdat(myhl, eFFT_SIG, (ULONG)smpldat);
/* *new*
** and as we would like to
** get the whole spectrum
** including the phacedisplacements
** we set DOPD to TRUE; default=FALSE!
*/
								eFFTsetdat(myhl, eFFT_DOPD, TRUE);
								puts("ACT. : Do spectrum analizing; with settings -> TRASH-FALSE, DOPD-TRUE).");
								
/* 
** we start the actual
** calculation
*/
#ifdef DO_TIMING
								starttime();
#endif
								eFFTcalc(myhl);
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif

/*
** and print
** the results
*/								
								dptr=eFFTgetdat(myhl, eFFT_ASP);
								printf("---> :Printing now first 10 Entries.\n");
								printf("      Index Frequency Amplitude(= *128)\n      ----- --------- -----------------\n");
								for(i=0;i<10;i++) printf("      %5d %8d %9d\n", i, i*25, (int)dptr[i]);
								
/*
** to compare the times
**	used to calculate things
** we change a few parameters;
** and calculate again...
*/
								puts("ACT. : Do spectrum analizing; with settings -> TRASH-FALSE, DOPD-FALSE).");
								eFFTsetdat(myhl, eFFT_DOPD, FALSE);
#ifdef DO_TIMING
								starttime();
#endif
								eFFTcalc(myhl);
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif

/*
** ... and again...
*/
								puts("ACT. : Do spectrum analizing; with settings -> TRASH-TRUE, DOPD-FALSE).");
								eFFTsetdat(myhl, eFFT_TRASH, TRUE);
								eFFTsetdat(myhl, eFFT_DOPD, FALSE);
#ifdef DO_TIMING
								starttime();
#endif
								eFFTcalc(myhl);
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif								
								
/* 
** ... and agai..., oops; 
** 
** Ok, then we'll show you now the synthesizing stuff
*/
/* -*new*--- Do Synthesizing now ---*new*- */
               			
/*
** as we destroyed our 'sampled' signal with
** the last calculation (TRASH=TRUE !!)
** we have to go back in time and...
** ...beam it into the present time :)
** no ofcourse not, we just have to 'resample' it 
*/
								puts("ACT. : 'Sample' sin with 50Hz and 8 bit resolution. (again! because we trashed it!)");
#ifdef DO_TIMING
								starttime();
#endif
								for(i=0;i<256;i++)
									smpldat[i]=(double)((int)(128.0*sin(2*PI*50*(1/(double)6400)*i)));
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif

/*
** and calculate the whole spectrum
** including the phasedisplacements
** again; now we forbid the library to trash
** our signal, because we want to compare
** it with the synthesized one
*/
								eFFTsetdat(myhl, eFFT_TRASH, FALSE);
								eFFTsetdat(myhl, eFFT_DOPD, TRUE);
								eFFTcalc(myhl);

/*
** here we store the spectrum
** amplitudes and phase..blaba
** into safe arrays; because as the autodocs say
** analizing an synthesizing can not be done in
** parallel those values would get lost
** in the following calculations
*/
								dptr=(double *)eFFTgetdat(myhl, eFFT_ASP);
								for(i=0;i<256;i++)
									FFTamp[i]=dptr[i];
								dptr=(double *)eFFTgetdat(myhl, eFFT_PSP);
								for(i=0;i<256;i++)
									FFTpha[i]=dptr[i];

								puts("ACT. : Synthesize signal now.");
/* 
** ok, now do the setup
** for synthesizing;
** first tell the library that you want
** tho synthesize a signal
*/
								eFFTsetdat(myhl, eFFT_SYN, TRUE);
/*
** and now tell the library
** where the spectrum is
*/
								eFFTsetdat(myhl, eFFT_ASP, (ULONG)FFTamp);
/*
** phase..blabla are fully optional
** you may or may not provide phase..blabla
** however, if you don't want to include them into
** the synthesizing process, you must set DOPD to FALSE;
** but if you set eFFT_PSP -> DOPD is automatically set to TRUE!;
*/
								eFFTsetdat(myhl, eFFT_PSP, (ULONG)FFTpha);

/*
** and start the calculation
*/
#ifdef DO_TIMING
								starttime();
#endif
								eFFTcalc(myhl);
#ifdef DO_TIMING
								stoptime();
								prttime();
#endif
								
/*
** her ewe print the
** 'sampled' & 'synthesized' signal
** to compare them
*/
								dptr=eFFTgetdat(myhl, eFFT_SYN);
								for(i=0;i<256;i++)
									syndat[i]=dptr[i];
								
								puts("       Orig.Dat.   Synth.Dat");
								puts("       ---------------------");
								for(i=0; i<11; i++)
								{
									printf("       %9f  %9f\n", smpldat[i], (syndat[i]/128));
								}
							}
/*
** if everything is done
** don't forget to free the handle!
*/
                     eFFTfree(myhl);
                     puts("STAT.: Free'ed handle from easyFFT.library.");
                  }
/*
** ...close the library!
*/
                  CloseLibrary(eFFTbase);
                  puts("STAT.: Closed easyFFT.library.");
					}


#ifdef DO_TIMING
/*
** ..cleanup timing stuff
*/
					CloseDevice((struct IORequest *)TimerIO);
					puts("STAT.: Closed timer device.");
				}
				free(time2);
			}
			free(time1);
		}
		free(TimerIO);
	}		
#endif	

/*
** ... and say,
** good ...
*/
   puts("Bye.");
   return rc;
}




/*
** just the timing stuff
** down there :)
*/
#ifdef DO_TIMING
void starttime(void)
{
	E_Freq=ReadEClock((struct EClockVal *)time1);
}

void stoptime(void)
{
	E_Freq=ReadEClock((struct EClockVal *)time2);
}

void prttime(void)
{
	double secs;
	long thi, tlo;
	
	thi=(time2->ev_hi)-(time1->ev_hi);
	if((time2->ev_lo) > (time1->ev_lo))
		tlo=time2->ev_lo-time1->ev_lo;
	else
		tlo=time1->ev_lo-time2->ev_lo;
	secs=(double)(((((double)thi)*(pow2((double)32)))+(double)tlo)/(double)E_Freq);
	printf("STAT.: Operation took %f seconds.\n", secs);
}
#endif