#define __USE_SYSBASE
#include <stdio.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <proto/sndfile.h>
#include <proto/ahi.h>

#define AUDIOBUFFER 32768

struct Library    *SndFileBase = NULL;

struct MsgPort    *AHImp       = NULL;
struct AHIRequest *AHIio       = NULL;
struct AHIRequest *AHIio2      = NULL;
BYTE               AHIDevice   = -1;

struct RDArgs     *rdargs      = NULL;
STRPTR Template = "INPUT/A,BYTESWAP/S,FORCE8BIT/S,U=UNIT/K/N,F=FREQ/K/N,B=BITS/K/N,C=CHANS/K/N";
enum { TEM_INPUT, TEM_SWAP, TEM_8BIT, TEM_UNIT, TEM_FREQ, TEM_BITS, TEM_CHANS, TEM_NUMARGS };


void Fail(char *reason)
{
	fprintf(stderr,"%s\n",reason);
	fflush(stderr);
}

void main(void)
{
	ULONG unit=0,freq=44100,bits=16,chans=2;
	ULONG signals,ahist,AHIcount=0;
	BOOL terminated=FALSE,kludge8bit=FALSE;
	struct AHIRequest *link = NULL;
	LONG ArgArray[TEM_NUMARGS];
	signed short *outbuf=NULL,*dubbuf=NULL;
	void *tmp;
	SNDFILE *sfptr=NULL;
	SF_INFO sfinfo;
	int buflen,len,x,y;

	for(x=0;x<TEM_NUMARGS;ArgArray[x++]=NULL);
	if(!(rdargs = ReadArgs(Template,ArgArray,NULL))) { Fail("Unable to read arguments."); goto exit; }

	if(ArgArray[TEM_FREQ])	freq  = *((ULONG *)ArgArray[TEM_FREQ]);
	if(ArgArray[TEM_BITS])	bits  = *((ULONG *)ArgArray[TEM_BITS]);
	if(ArgArray[TEM_CHANS])	chans = *((ULONG *)ArgArray[TEM_CHANS]);
	if(ArgArray[TEM_UNIT])	unit  = *((ULONG *)ArgArray[TEM_UNIT]);
	if(unit>3) { Fail("Illegal unit number!"); goto exit; }

	if(!(SndFileBase=OpenLibrary("sndfile.library",0))) { Fail("Unable to open sndfile.library."); goto exit; }

	if(AHImp=CreateMsgPort())
		if(AHIio=(struct AHIRequest *)CreateIORequest(AHImp,sizeof(struct AHIRequest)))
		{
			AHIio->ahir_Version = 4;
			AHIDevice = OpenDevice(AHINAME,unit,(struct IORequest *)AHIio,NULL);
		}
	if(AHIDevice) { Fail("Unable to open ahi.device v4"); goto exit; }

	if(!(AHIio2 = AllocMem(sizeof(struct AHIRequest), MEMF_ANY))) { Fail("Unable to allocate needed memory."); goto exit; }
	CopyMem(AHIio, AHIio2, sizeof(struct AHIRequest));

	if(!(dubbuf = AllocMem(AUDIOBUFFER, MEMF_ANY))) { Fail("Unable to allocate needed memory."); goto exit; }
	if(!(outbuf = AllocMem(AUDIOBUFFER, MEMF_ANY))) { Fail("Unable to allocate needed memory."); goto exit; }

	sfinfo.seekable		= TRUE;
	sfinfo.samplerate	= freq;
	sfinfo.pcmbitwidth	= bits;
	sfinfo.channels		= chans;

	if(bits==8)					sfinfo.format = SF_FORMAT_RAW_S8;
	else if(ArgArray[TEM_SWAP])	sfinfo.format = SF_FORMAT_RAW_LE;
	else						sfinfo.format = SF_FORMAT_RAW_BE;

	if(!(sfptr = SF_OpenRead((STRPTR)ArgArray[TEM_INPUT],&sfinfo))) { Fail("Unable to open file."); goto exit; }

	if(sfinfo.channels==1)
	{
		if(ArgArray[TEM_8BIT])	ahist = AHIST_M8S;
		else					ahist = AHIST_M16S;
	}
	else if(sfinfo.channels==2)
	{
		if(ArgArray[TEM_8BIT])	ahist = AHIST_S8S;
		else					ahist = AHIST_S16S;
	}
	else { Fail("Unsupported number of channels."); goto exit; }

	if(ArgArray[TEM_8BIT]) buflen=AUDIOBUFFER/2;
	else buflen=AUDIOBUFFER;


	/* We could use SF_ReadRaw() here, thus being able to read 8bit samples as 8bit, */
	/* but it requires more work, and besides, not all files provide raw pcm data... */
	if (SndFileBase->lib_Version<2 && sfinfo.pcmbitwidth==8) kludge8bit = TRUE;

	while((len = SF_ReadShort(sfptr,outbuf,AUDIOBUFFER/sizeof(short)))>0)
	{
		if(ArgArray[TEM_8BIT])
		{
			if(kludge8bit) for(x=0,y=0;x<len;outbuf[y++]=(outbuf[x++]<<8)|(outbuf[x++]&0xFF));
			else for(x=0,y=0;x<len;outbuf[y++]=(outbuf[x++]&0xFF00)|((outbuf[x++]>>8)&0xFF));
		} else {
			if(kludge8bit) for(x=len;x>0;outbuf[--x]<<=8);	/* Kludge for 8bit samples */
			len*=sizeof(short);
		}

		AHIio->ahir_Std.io_Message.mn_Node.ln_Pri = 0;
		AHIio->ahir_Std.io_Command  = CMD_WRITE;
		AHIio->ahir_Std.io_Data     = outbuf;
		AHIio->ahir_Std.io_Length   = len;
		AHIio->ahir_Std.io_Offset   = 0;
		AHIio->ahir_Frequency       = sfinfo.samplerate;
		AHIio->ahir_Type            = ahist;
		AHIio->ahir_Volume          = 0x10000;
		AHIio->ahir_Position        = 0x8000;
		AHIio->ahir_Link            = link;
		SendIO((struct IORequest *) AHIio);
		AHIcount++;

		if(link)
		{
			signals=Wait(SIGBREAKF_CTRL_C | (1L << AHImp->mp_SigBit));
			if(signals & SIGBREAKF_CTRL_C)
			{
				terminated=TRUE;
				break;
			}
			if(WaitIO((struct IORequest *) link)) { Fail("I/O request failed."); goto exit; }
		}

		link   = AHIio;

		tmp    = outbuf;
		outbuf = dubbuf;
		dubbuf = tmp;

		tmp    = AHIio;
		AHIio  = AHIio2;
		AHIio2 = tmp;
	}

exit:
	if(AHIcount)
	{
		if(terminated)
		{
			AbortIO((struct IORequest *) AHIio);
			WaitIO((struct IORequest *) AHIio);

			if(AHIcount>1)
			{
				AbortIO((struct IORequest *) AHIio2);
				WaitIO((struct IORequest *) AHIio2);
			}
		}
		else WaitIO((struct IORequest *) AHIio2);
	}

	if(dubbuf)		FreeMem(dubbuf,AUDIOBUFFER);
	if(outbuf)		FreeMem(outbuf,AUDIOBUFFER);
	if(sfptr)		SF_Close(sfptr);
	if(SndFileBase)	CloseLibrary(SndFileBase);
	if(!AHIDevice)	CloseDevice((struct IORequest *)AHIio);
	if(AHIio)		DeleteIORequest((struct IORequest *)AHIio);
	if(AHIio2)		DeleteIORequest((struct IORequest *)AHIio2);
	if(AHImp)		DeleteMsgPort(AHImp);
	if(rdargs)		FreeArgs(rdargs);
}
