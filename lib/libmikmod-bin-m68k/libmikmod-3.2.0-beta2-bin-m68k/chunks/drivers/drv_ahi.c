/*	MikMod sound library
    (c) 2004, Raphael Assenat
	(c) 1998, 1999, 2000 Miodrag Vallat and others - see file AUTHORS for
	complete list.

	This library is free software; you can redistribute it and/or modify
	it under the terms of the GNU Library General Public License as
	published by the Free Software Foundation; either version 2 of
	the License, or (at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Library General Public License for more details.
 
	You should have received a copy of the GNU Library General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
	02111-1307, USA.
*/

/*==============================================================================

  $Id: drv_ahi.c,v 1.4 2007/06/07 22:27:33 raph Exp $

  Modified 'drv_aiff.c' to work with AHI's 'AUDIO:' by megacz@usa.com
  Driver output can be controlled via environment variables: 'MMAHI' & 'MMAHIBUF'.

  > set MMAHI /audio/buf=22050/unit=1
  > set MMAHIBUF 22050

==============================================================================*/

/*
        
	Written by Axel "awe" Wefers <awe@fruitz-of-dojo.de>
   
	
	Raphael Assenat: 19 Feb 2004: Command line options documented in the MDRIVER structure,
					 and I added #if 0 's around pragmas, since gcc complaines about them. 
					 Hopefully, the IDE which uses them wont care about that?
*/

/*_______________________________________________________________________________________________iNCLUDES
*/
#if 0
#pragma mark INCLUDES
#endif

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "mikmod_internals.h"

#ifdef DRV_AHI

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include <stdio.h>
#include <math.h>			/* required for IEEE extended conversion */
#if 0
#pragma mark -
#endif
/*________________________________________________________________________________________________dEFINES
*/
#if 0
#pragma mark DEFINES
#endif

/* Amiga - default output */
#define AHI_FILENAME			"/audio/buf=22050"

#if 0
#pragma mark -
#endif
/*_________________________________________________________________________________________________mACROS
*/
#if 0
#pragma mark MACROS
#endif

#define AHI_FLOAT_TO_UNSIGNED(f)    	((unsigned long)(((long)(f - 2147483648.0)) + 2147483647L + 1))
#if 0
#pragma mark -
#endif
/*___________________________________________________________________________________________________vARS
*/
#if 0 
#pragma mark VARIABLES
#endif
static	MWRITER	*gAhiOut = NULL;
static	FILE	*gAhiFile = NULL;
static	SBYTE	*gAhiAudioBuffer = NULL;
static	CHAR	*gAhiFileName = NULL;
static	ULONG	gAhiDumpSize = 0;

/* Amiga - default buffer size */
static  ULONG   gAhiBufferSize = 22050;

#if 0
#pragma mark -
#endif
/*____________________________________________________________________________________fUNCTION_pROTOTYPES
*/
#if 0
#pragma mark FUNCTION PROTOTYPES
#endif

#ifdef SUNOS
extern int fclose(FILE *);
#endif

static void	AHI_ConvertToIeeeExtended (double theValue, char *theBytes);
static void	AHI_PutHeader (void);
static void	AHI_CommandLine (CHAR *theCmdLine);
static BOOL	AHI_IsThere (void);
static BOOL	AHI_Init (void);
static void	AHI_Exit (void);
static void	AHI_Update (void);

/* Amiga - integer check function */
static int      AHI_getenv_num (char *);

#if 0
#pragma mark -
#endif
/*___________________________________________________________________________AHI_ConvertToIeeeExtended()
*/

void AHI_ConvertToIeeeExtended (double theValue, char *theBytes)
{
    int			mySign;
    int			myExponent;
    double		myFMant, myFsMant;
    unsigned long	myHiMant, myLoMant;

    if (theValue < 0)
    {
        mySign = 0x8000;
        theValue *= -1;
    } else
    {
        mySign = 0;
    }

    if (theValue == 0)
    {
        myExponent = 0;
        myHiMant = 0;
        myLoMant = 0;
    }
    else
    {
        myFMant = frexp (theValue, &myExponent);
        if ((myExponent > 16384) || !(myFMant < 1))
        {
            myExponent = mySign | 0x7FFF;
            myHiMant = 0;
            myLoMant = 0;
        }
        else
        {
            myExponent += 16382;
            if (myExponent < 0)
            {
                myFMant = ldexp (myFMant, myExponent);
                myExponent = 0;
            }
            myExponent |= mySign;
            myFMant = ldexp (myFMant, 32);          
            myFsMant = floor (myFMant); 
            myHiMant = AHI_FLOAT_TO_UNSIGNED (myFsMant);
            myFMant = ldexp (myFMant - myFsMant, 32); 
            myFsMant = floor (myFMant); 
            myLoMant = AHI_FLOAT_TO_UNSIGNED (myFsMant);
        }
    }
    
    theBytes[0] = myExponent >> 8;
    theBytes[1] = myExponent;
    theBytes[2] = myHiMant >> 24;
    theBytes[3] = myHiMant >> 16;
    theBytes[4] = myHiMant >> 8;
    theBytes[5] = myHiMant;
    theBytes[6] = myLoMant >> 24;
    theBytes[7] = myLoMant >> 16;
    theBytes[8] = myLoMant >> 8;
    theBytes[9] = myLoMant;
}

/*_______________________________________________________________________________________AHI_PutHeader()
*/

static void	AHI_PutHeader(void)
{
    ULONG	myFrames;
    UBYTE	myIEEE[10];

    /* Amiga - we need to fool external player that the pseudo file is 2 gig long */
    gAhiDumpSize = 2147483644;
    
    myFrames = gAhiDumpSize / (((md_mode&DMODE_STEREO) ? 2 : 1) * ((md_mode & DMODE_16BITS) ? 2 : 1));
    AHI_ConvertToIeeeExtended ((double) md_mixfreq, myIEEE);

    /* Amiga - we cant use seeking with pipes! */
    /* _mm_fseek (gAhiOut, 0, SEEK_SET); */

    _mm_write_string  ("FORM", gAhiOut);				/* chunk 'FORM' */

    /* Amiga - addidtional 36 bytes needs to be removed */
    /* _mm_write_M_ULONG (gAhiDumpSize + 36, gAhiOut); */

    _mm_write_M_ULONG (gAhiDumpSize, gAhiOut);				/* length of the file */
    _mm_write_string  ("AIFFCOMM", gAhiOut);				/* chunk 'AHI', 'COMM' */
    _mm_write_M_ULONG (18, gAhiOut);					/* length of this AHI block */
    _mm_write_M_UWORD ((md_mode & DMODE_STEREO) ? 2 : 1, gAhiOut);	/* channels */
    _mm_write_M_ULONG (myFrames, gAhiOut);				/* frames = freq * secs */
    _mm_write_M_UWORD ((md_mode & DMODE_16BITS) ? 16 : 8, gAhiOut);	/* bits per sample */
    _mm_write_UBYTES  (myIEEE, 10, gAhiOut);				/* frequency [IEEE extended] */
    _mm_write_string  ("SSND", gAhiOut);				/* data chunk 'SSND' */
    _mm_write_M_ULONG (gAhiDumpSize, gAhiOut);				/* data length */
    _mm_write_M_ULONG (0, gAhiOut);					/* data offset, always zero */
    _mm_write_M_ULONG (0, gAhiOut);					/* data blocksize, always zero */
}

/*_____________________________________________________________________________________AHI_CommandLine()
*/

static void	AHI_CommandLine (CHAR *theCmdLine)
{
    CHAR	*myFileName = MD_GetAtom ("file", theCmdLine,0);

    if (myFileName != NULL)
    {
        _mm_free (gAhiFileName);
        gAhiFileName = myFileName;
    }
}

/*_________________________________________________________________________________________AHI_isThere()
*/

static BOOL	AHI_IsThere (void)
{
    return (1);
}

/*____________________________________________________________________________________________AHI_Init()
*/

static BOOL	AHI_Init (void)
{

    /* Amiga - allow user to specify options and internal buffer */
    char *ahienv;
    char *ahifilename;
    char *ahienvbuf;    
    int ahivalue;

    ahienv = getenv("MMAHI");
    if (ahienv != NULL) ahifilename = ahienv;
    else ahifilename = AHI_FILENAME;

    ahienvbuf = getenv("MMAHIBUF");
    ahivalue = AHI_getenv_num(ahienvbuf);
    if (ahivalue > 0) gAhiBufferSize = atoi(ahienvbuf);


#if defined unix || (defined __APPLE__ && defined __MACH__)
    if (!MD_Access (gAhiFileName ? gAhiFileName : ahifilename))
    {
        _mm_errno=MMERR_OPENING_FILE;
        return (1);
    }
#endif

    if (!(gAhiFile = fopen (gAhiFileName ? gAhiFileName : ahifilename, "wb")))
    {
        _mm_errno = MMERR_OPENING_FILE;
        return (1);
    }
    if (!(gAhiOut =_mm_new_file_writer (gAhiFile)))
    {
        fclose (gAhiFile);
        unlink(gAhiFileName ? gAhiFileName : ahifilename);
        gAhiFile = NULL;
        return (1);
    }

    if (!(gAhiAudioBuffer = (SBYTE*) _mm_malloc (gAhiBufferSize)))
    {
        _mm_delete_file_writer (gAhiOut);
        fclose (gAhiFile);
        unlink (gAhiFileName ? gAhiFileName : ahifilename);
        gAhiFile = NULL;
        gAhiOut = NULL;
        return 1;
    }

    md_mode|=DMODE_SOFT_MUSIC|DMODE_SOFT_SNDFX;

    if (VC_Init ())
    {
        _mm_delete_file_writer (gAhiOut);
        fclose (gAhiFile);
        unlink (gAhiFileName ? gAhiFileName : ahifilename);
        gAhiFile = NULL;
        gAhiOut = NULL;
        return 1;
    }
    
    gAhiDumpSize = 0;
    AHI_PutHeader ();

    return (0);
}

/*____________________________________________________________________________________________AHI_Exit()
*/

static void	AHI_Exit (void)
{
    VC_Exit ();

    /* write in the actual sizes now */
    if (gAhiOut != NULL)
    {

        /* Amiga - we dont want to put the header once again */
        /* AHI_PutHeader (); */

        _mm_delete_file_writer (gAhiOut);
        fclose (gAhiFile);
        gAhiFile = NULL;
        gAhiOut = NULL;
    }
    if (gAhiAudioBuffer != NULL)
    {
        free (gAhiAudioBuffer);
        gAhiAudioBuffer = NULL;
    }
}

/*__________________________________________________________________________________________AHI_Update()
*/

static void	AHI_Update (void)
{
    ULONG	myByteCount;

    myByteCount = VC_WriteBytes (gAhiAudioBuffer, gAhiBufferSize);
    if (md_mode & DMODE_16BITS)
    {
        _mm_write_M_UWORDS ((UWORD *) gAhiAudioBuffer, myByteCount >> 1, gAhiOut);
    }
    else
    {
        ULONG	i;
        
        for (i = 0; i < myByteCount; i++)
        {
            gAhiAudioBuffer[i] -= 0x80;				/* convert to signed PCM */
        }
        _mm_write_UBYTES (gAhiAudioBuffer, myByteCount, gAhiOut);
    }
    gAhiDumpSize += myByteCount;
}

/*_______________________________________________________________________________________AHI_getenv_num()
*/

int AHI_getenv_num(char *name)
{
    char *dst = 0;
    char *src = name;
    long value;

    if ((src == 0)
	|| (value = strtol(src, &dst, 0)) < 0
	|| (dst == src)
	|| (*dst != '\0')
	|| (int) value < value)
	value = -1;

    return (int) value;
}

/*________________________________________________________________________________________________drv_osx
*/

MIKMODAPI MDRIVER drv_ahi = {
    NULL,
    "AHI Driver (AUDIO:)",
    "AHI Driver (AUDIO:)",
    0,255,
    "ahi",
    "file:t:music.ahi:Output file name\n",
    AHI_CommandLine,
    AHI_IsThere,
    VC_SampleLoad,
    VC_SampleUnload,
    VC_SampleSpace,
    VC_SampleLength,
    AHI_Init,
    AHI_Exit,
    NULL,
    VC_SetNumVoices,
    VC_PlayStart,
    VC_PlayStop,
    AHI_Update,
    NULL,
    VC_VoiceSetVolume,
    VC_VoiceGetVolume,
    VC_VoiceSetFrequency,
    VC_VoiceGetFrequency,
    VC_VoiceSetPanning,
    VC_VoiceGetPanning,
    VC_VoicePlay,
    VC_VoiceStop,
    VC_VoiceStopped,
    VC_VoiceGetPosition,
    VC_VoiceRealVolume
};

#else

MISSING(drv_ahi);

#endif

/*____________________________________________________________________________________________________eOF
*/
