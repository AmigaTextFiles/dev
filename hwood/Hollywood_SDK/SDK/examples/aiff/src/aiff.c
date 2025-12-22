/*
** AIFF Hollywood plugin
** Copyright (C) 2015 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

#include <hollywood/plugin.h>

#include "aiff.h"
#include "version.h"

// container structure for the AIFF sound
struct aiffinfo
{
	APTR fh;
	ULONG stream_pos;
	ULONG samples;
	ULONG offset;
	int bits;
	int channels;
	int bpf;
	int pitch;
};

// pointer to the Hollywood plugin API
static hwPluginAPI *hwcl = NULL;

// information about our plugin for InitPlugin()
// (NB: we store the version string after the plugin's name; this is not required by Hollywood;
// it is just a trick to prevent the linker from optimizing our version string away)
static const char plugin_name[] = PLUGIN_NAME "\0$VER: " PLUGIN_MODULENAME ".hwp " PLUGIN_VER_STR " (" PLUGIN_DATE ") [" PLUGIN_PLAT "]";
static const char plugin_modulename[] = PLUGIN_MODULENAME;
static const char plugin_author[] = PLUGIN_AUTHOR;
static const char plugin_description[] = PLUGIN_DESCRIPTION;
static const char plugin_copyright[] = PLUGIN_COPYRIGHT;
static const char plugin_url[] = PLUGIN_URL;
static const char plugin_date[] = PLUGIN_DATE;

static double ConvertFromIeeeExtended(unsigned char *bytes);

/*
** WARNING: InitPlugin() will be called by *any* Hollywood version >= 5.0. Thus, you must
** check the Hollywood version that called your InitPlugin() implementation before calling
** functions from the hwPluginAPI pointer or accessing certain structure members. Your
** InitPlugin() implementation must be compatible with *any* Hollywood version >= 5.0. If
** you call Hollywood 6.0 functions here without checking first that Hollywood 6.0 or higher
** has called your InitPlugin() implementation, *all* programs compiled with Hollywood
** versions < 6.0 *will* crash when they try to open your plugin! 
*/
HW_EXPORT int InitPlugin(hwPluginBase *self, hwPluginAPI *cl, STRPTR path)
{
	// open Amiga libraries needed by this plugin	
#ifdef HW_AMIGA
	if(!initamigastuff()) return FALSE;
#endif

	// identify as a sound plugin to Hollywood
	self->CapsMask = HWPLUG_CAPS_SOUND;
	self->Version = PLUGIN_VER;
	self->Revision = PLUGIN_REV;

	// we want to be compatible with Hollywood 5.0
	// **WARNING**: when compiling with newer SDK versions you have to be very
	// careful which functions you call and which structure members you access
	// because not all of them are present in earlier versions. Thus, if you
	// target versions older than your SDK version you have to check the hollywood.h
	// header file very carefully to check whether the older version you want to
	// target has the respective feature or not
	self->hwVersion = 5;
	self->hwRevision = 0;
	
	// set plugin information; note that these string pointers need to stay
	// valid until Hollywood calls ClosePlugin()	
	self->Name = (STRPTR) plugin_name;
	self->ModuleName = (STRPTR) plugin_modulename;	
	self->Author = (STRPTR) plugin_author;
	self->Description = (STRPTR) plugin_description;
	self->Copyright = (STRPTR) plugin_copyright;
	self->URL = (STRPTR) plugin_url;
	self->Date = (STRPTR) plugin_date;
	self->Settings = NULL;
	self->HelpFile = NULL;

	// NB: "cl" can be NULL in case Hollywood or Designer just wants to obtain information
	// about our plugin
	if(cl) {
		
		hwcl = cl;
		
		// it is important to check that we have at least Hollywood 5.3 before calling
		// hw_RegisterFileType() because it isn't available in earlier versions
		if(hwcl->hwVersion > 5 || (hwcl->hwVersion == 5 && hwcl->hwRevision >= 3)) {			
			hwcl->SysBase->hw_RegisterFileType(self, HWFILETYPE_SOUND, "AIFF", NULL, "aiff|aif", 0, 0);	
		}		
	}
		
	return TRUE;
}

/*
** WARNING: ClosePlugin() will be called by *any* Hollywood version >= 5.0.
** --> see the note above in InitPlugin() for information on how to implement this function
*/
HW_EXPORT void ClosePlugin(void)
{
#ifdef HW_AMIGA
	freeamigastuff();
#endif
}

/*
** read a 32-bit long in an endian-neutral way
*/
static ULONG FReadL(APTR fh)
{
	int one, two, three, four;

	one = hw_FGetC(fh);
	two = hw_FGetC(fh);
	three = hw_FGetC(fh);
	four = hw_FGetC(fh);

	return (ULONG) (one<<24)|(two<<16)|(three<<8)|four;
}

/*
** read a 16-bit word in an endian-neutral way
*/
static short FReadW(APTR fh)
{
	int one, two;

	one = hw_FGetC(fh);
	two = hw_FGetC(fh);

	return (short) ((one<<8)|two);   // return signed short
}

/*
** version of hw_FOpen() that supports Hollywood's "Adapter" tag (introduced in 6.0)
** but is also compatible with Hollywood 5
*/
static APTR hw_FOpen(STRPTR name, int mode, STRPTR adapter)
{
	if(hwcl->hwVersion >= 6 && adapter) {
		
		struct hwTagList tags[16];
		
		tags[0].Tag = HWFOPENTAG_ADAPTER;
		tags[0].Data.pData = adapter;
		tags[1].Tag = 0;
		
		return hwcl->DOSBase->hw_FOpenExt(name, mode, tags);

	} else {		

		return hwcl->DOSBase->hw_FOpen(name, mode);
	}	
} 

#if defined(HW_WIN32) || defined(HW_LINUX) || defined(HW_ANDROID)
/* unsign PCM data */	
static void unsignsamples(UBYTE *data, int count)
{
	UBYTE *dst;
	int k;
	
	for(dst = data, k = 0; k < count; k++) {
		*dst = ((unsigned char) (*dst + 128));	
		dst++;
	}
}
#endif

#if defined(HW_WIN32) || (defined(HW_AROS) && defined(HW_LITTLE_ENDIAN)) || defined(HW_ANDROID)	
/* convert 16-bit big endian PCM to little endian */
static void swapbytes(UWORD *data, int count)
{
	int k;
	UWORD *p = data;
				
	for(k = 0; k < count; k++) {
		*p = ((*p & 0xff)<<8)|((*p>>8) & 0xff);								
		p++;
	}
}
#endif

/* return format name of this codec */		
HW_EXPORT STRPTR GetFormatName(APTR handle)
{
	// must use a static string here
	static const char codecname[] = "AIFF";
	
	return (STRPTR) codecname;
}

/* seek to a new sample position */
HW_EXPORT void SeekStream(APTR handle, ULONG seekpos)
{
	struct aiffinfo *ai = (struct aiffinfo *) handle;

	hw_FSeek(ai->fh, ai->offset + seekpos * ai->bpf, HWFSEEKMODE_BEGINNING);
	ai->stream_pos = seekpos;
}

/* read n number of PCM frames from file */
HW_EXPORT int StreamSamples(APTR handle, struct StreamSamplesCtrl *ctrl)
{
	struct aiffinfo *ai = (struct aiffinfo *) handle;
	ULONG numsmp = ctrl->Request;

	ctrl->Done = FALSE;

	// have we reached the end?
	if(numsmp > ai->samples - ai->stream_pos) {
		numsmp = ai->samples - ai->stream_pos;
		ctrl->Done = TRUE;
	}

	numsmp = (numsmp) ? hw_FRead(ai->fh, ctrl->Buffer, numsmp * ai->bpf) / ai->bpf : 0;

#if defined(HW_WIN32) || defined(HW_LINUX) || defined(HW_ANDROID)	
	// must use unsigned 8-bit PCM on these platforms
	if(ai->bits == 8) unsignsamples(ctrl->Buffer, numsmp * ai->bpf);
#endif	

#if defined(HW_WIN32) || (defined(HW_AROS) && defined(HW_LITTLE_ENDIAN)) || defined(HW_ANDROID)		
	// must use little-endian PCM data on these platforms
	if(ai->bits == 16) swapbytes(ctrl->Buffer, numsmp * ai->bpf / 2);
#endif
		
	// update cursors	
	ai->stream_pos += numsmp;
	ctrl->Written = numsmp;

	return 0;
}

/* open AIFF file */
HW_EXPORT APTR OpenStream(STRPTR filename, struct LoadSoundCtrl *ctrl)
{
	struct aiffinfo *ai = my_calloc(sizeof(struct aiffinfo), 1);
	STRPTR adapter = NULL;
	UBYTE id[12];
	ULONG len = 0;
	
	if(!ai) return NULL;

	// we must check for Hollywood 6.0 before trying to access the "Adapter" structure
	// member because it isn't there in earlier versions
	if(hwcl->hwVersion >= 6) adapter = ctrl->Adapter;
			
      	// open file                               	
	if(!(ai->fh = hw_FOpen(filename, HWFOPENMODE_READ_LEGACY, adapter))) goto error_openstream;
	
	if(hw_FRead(ai->fh, id, 12) != 12) goto error_openstream;
		
	// do we have FORM AIFF file?	
	if(strncmp(id, "FORM", 4) || strncmp(id + 8, "AIFF", 4)) goto error_openstream;
		
        do {
   
	        if(!strncmp(id, "COMM", 4)) {

			// parse COMM chunk	        	
	        	if(len != 18) goto error_openstream;
	        		
	        	ai->channels = FReadW(ai->fh);
	        	ai->samples = FReadL(ai->fh);
	        	ai->bits = FReadW(ai->fh);
	        	
	        	if(!(ai->channels == 1 || ai->channels == 2) || !(ai->bits == 8 || ai->bits == 16)) goto error_openstream;
	        	
	        	if(hw_FRead(ai->fh, id, 10) != 10) goto error_openstream;
	        		
	        	ai->pitch = (int) ConvertFromIeeeExtended(id);		
	        	
	        	switch(ai->bits) {
	        	case 8:
	        		ai->bpf = ai->channels;
	        		break;
	        	case 16:
	        		ai->bpf = ai->channels * 2;
	        		break;
	        	}
	        						
		} else {
			
                        hw_FSeek(ai->fh, len, HWFSEEKMODE_CURRENT);
		}

                if(hw_FRead(ai->fh, id, 4) != 4) goto error_openstream;
                len = FReadL(ai->fh);

	} while(strncmp(id, "SSND", 4));
	
	// memorize start of raw audio data	
	ai->offset = hw_FSeek(ai->fh, 0, HWFSEEKMODE_CURRENT);
				
	// return information about sound stream to Hollywood				
	ctrl->Frequency = ai->pitch;
	ctrl->Channels = ai->channels;
	ctrl->Bits = ai->bits;
 	ctrl->Samples = ai->samples;
	ctrl->Flags = HWSNDFLAGS_CANSEEK;
	
	if(ai->bits == 16) ctrl->Flags |= HWSNDFLAGS_SIGNEDINT;
#if !defined(HW_WIN32) && !defined(HW_LINUX) && !defined(HW_ANDROID)	
	else ctrl->Flags |= HWSNDFLAGS_SIGNEDINT;
#endif	
	
#if !defined(HW_WIN32) && !(defined(HW_AROS) && defined(HW_LITTLE_ENDIAN)) && !defined(HW_ANDROID)	
	ctrl->Flags |= HWSNDFLAGS_BIGENDIAN;
#endif

	return ai;

error_openstream:
	if(ai->fh) hw_FClose(ai->fh);
	my_free(ai);
	
	return NULL;
}

/* close AIFF handle */
HW_EXPORT void CloseStream(APTR handle)
{
	struct aiffinfo *ai = (struct aiffinfo *) handle;

	hw_FClose(ai->fh);
	my_free(ai);
}
 
/*
* C O N V E R T   F R O M   I E E E   E X T E N D E D
*/
 
/*
 * Copyright (C) 1988-1991 Apple Computer, Inc.
 *
 * All rights reserved.
 *
 * Warranty Information
 *  Even though Apple has reviewed this software, Apple makes no warranty
 *  or representation, either express or implied, with respect to this
 *  software, its quality, accuracy, merchantability, or fitness for a
 *  particular purpose.  As a result, this software is provided "as is,"
 *  and you, its user, are assuming the entire risk as to its quality
 *  and accuracy.
 *
 * This code may be used and freely distributed as long as it includes
 * this copyright notice and the above warranty information.
 *
 * Machine-independent I/O routines for IEEE floating-point numbers.
 *
 * NaN's and infinities are converted to HUGE_VAL, which
 * happens to be infinity on IEEE machines.  Unfortunately, it is
 * impossible to preserve NaN's in a machine-independent way.
 * Infinities are, however, preserved on IEEE machines.
 *
 * These routines have been tested on the following machines:
 *    Apple Macintosh, MPW 3.1 C compiler
 *    Apple Macintosh, THINK C compiler
 *    Silicon Graphics IRIS, MIPS compiler
 *    Cray X/MP and Y/MP
 *    Digital Equipment VAX
 *
 *
 * Implemented by Malcolm Slaney and Ken Turkowski.
 *
 * Malcolm Slaney contributions during 1988-1990 include big- and little-
 * endian file I/O, conversion to and from Motorola's extended 80-bit
 * floating-point format, and conversions to and from IEEE single-
 * precision floating-point format.
 *
 * In 1991, Ken Turkowski implemented the conversions to and from
 * IEEE double-precision format, added more precision to the extended
 * conversions, and accommodated conversions involving +/- infinity,
 * NaN's, and denormalized numbers.
 */
 
#define UnsignedToFloat(u)         (((double)((int)(u - 2147483647 - 1))) + 2147483648.0)
  
/****************************************************************
 * Extended precision IEEE floating-point conversion routine.
 ****************************************************************/
  
static double ConvertFromIeeeExtended(unsigned char *bytes)
{
     double    f;
     int    expon;
     ULONG hiMant, loMant;
  
     expon = ((bytes[0] & 0x7F) << 8) | (bytes[1] & 0xFF);
     hiMant    =    ((ULONG)(bytes[2] & 0xFF) << 24)
             |    ((ULONG)(bytes[3] & 0xFF) << 16)
             |    ((ULONG)(bytes[4] & 0xFF) << 8)
             |    ((ULONG)(bytes[5] & 0xFF));
     loMant    =    ((ULONG)(bytes[6] & 0xFF) << 24)
             |    ((ULONG)(bytes[7] & 0xFF) << 16)
             |    ((ULONG)(bytes[8] & 0xFF) << 8)
             |    ((ULONG)(bytes[9] & 0xFF));
  
     if (expon == 0 && hiMant == 0 && loMant == 0) {
         f = 0;
     }
     else {
         if (expon == 0x7FFF) {    /* Infinity or NaN */
             f = HUGE_VAL;
         }
         else {
             expon -= 16383;
             f  = ldexp(UnsignedToFloat(hiMant), expon-=31);
             f += ldexp(UnsignedToFloat(loMant), expon-=32);
         }
     }
  
     if (bytes[0] & 0x80)
         return -f;
     else
         return f;
}  