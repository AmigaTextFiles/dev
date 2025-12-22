/**********************************************************************
Copyright (C) 1992 SunRize Industries
	Written by Todd Modjeski
**********************************************************************/
#include "exec/types.h"
#include "exec/exec.h"
#include "libraries/configvars.h"
#include "stdio.h"
/********************************************************************/
#define BUFFSIZE	(1024*512)	/* Size Of Sample Buffer */
/********************************************************************/
#define STATUS	0
#define DATA	1

#define RDOK68 0x0200
#define WROK68 0x0100

#define DataIn	0x3800
#define DataOut	0x3801
#define CHECK	0x3802

#define DPoke	0x0043
#define DPeek	0x0041

#define GanUp	0x0109
#define GanDown	0x010B
/********************************************************************/
struct ExpansionBase *ExpansionBase=NULL;
/********************************************************************/
USHORT *AllocAD1012();
void FreeAD1012();
void poke();
void SendW();
USHORT GetW();
int Hex2int();
void Monitor();
void Menu();
void Play();
void Record();
/********************************************************************/
USHORT *port,*mem;
/********************************************************************/
UBYTE *pa=(UBYTE *)0xBFE001;
/********************************************************************/

/********************************************************************/
/********************************************************************/
void main()
{
USHORT s;

if (!(mem=(USHORT *)AllocMem(BUFFSIZE,NULL)))
	{printf("Could Not Allocate Memory\n");exit(5);}

if (!(ExpansionBase = (struct ExpansionBase *)OpenLibrary("expansion.library",0)))
	{printf("Cant open Expansion Lib!\n");exit(10);}

port=AllocAD1012();
if (port)
	{
	SendW(DPeek);
	SendW(CHECK);
	s=GetW();
	if (s==0x1234) Menu();
	else printf("You must download the proper DSP code. Use the command:\nloadCode example.o\n");
	FreeAD1012(port);
	}

if (ExpansionBase)	CloseLibrary(ExpansionBase);
FreeMem(mem,BUFFSIZE);
}
/********************************************************************/
/********************************************************************/
void Menu()
{
char c=NULL;

while (c!='Q' && c!='q')
	{
	printf("%cSimple Sampler Program\n",12);
	printf("-----------------------------\n\n");
	printf("M)onitor\n");
	printf("P)lay\n");
	printf("R)ecord\n");
	printf("+)Gain Up\n");
	printf("-)Gain Down\n");
	printf("Q)uit\n");
	printf("\n\nYour Choice?");

	c=fgetchar();
	switch (c)
		{
		case 'm':
		case 'M':
			 Monitor();
		break;

		case 'p':
		case 'P':
			 Play();
		break;

		case 'r':
		case 'R':
			 Record();
		break;

		case '+':
		case '=':
			 SendW(GanUp);
		break;

		case '-':
		case '_':
			 SendW(GanDown);
		break;
		}
	}
}
/********************************************************************/
/********************************************************************/
void Monitor()
{
USHORT s;

printf("%cMonitoring... Press the left mouse button to stop",12);
Disable();
while((*pa&64))
	{
	SendW(DPeek);
	SendW(DataIn);
	s=GetW();
	SendW(DPoke);
	SendW(DataOut);
	SendW(s);
	}
Enable();
}

/********************************************************************/
/********************************************************************/
void Play()
{
int x;

printf("%cPlaying...",12);
Disable();
for(x=0;x<(BUFFSIZE/2);x++)
	{
	SendW(DPoke);
	SendW(DataOut);
	SendW(*(mem+x));
	}
Enable();
}
/********************************************************************/
/********************************************************************/
void Record()
{
int x;

printf("%cRecording...",12);
Disable();
for(x=0;x<(BUFFSIZE/2);x++)
	{
	SendW(DPeek);
	SendW(DataIn);
	*(mem+x)=GetW();
	}
Enable();
}

/********************************************************************/
/********************************************************************/
void SendW(z)
USHORT z;
{
short x=0;

while (*(port+STATUS)&WROK68 && x<300000) x++;
if (x>=300000) printf("Card Comunications Error #1 - Write Not Recognized\n");
*(port+DATA)=z;
}
/********************************************************************/
/********************************************************************/
USHORT GetW()
{
USHORT y;
ULONG x=0;
while(*(port+STATUS)&RDOK68 && x<300000) x++;
if (x>=300000) printf("Card Comunications Error #2 - Read Not Recognized\n");
y=*(port+DATA);

return(y);
}
/********************************************************************/
/********************************************************************/
USHORT *AllocAD1012()
{
USHORT *cport=NULL;
struct ConfigDev *ConfigDev=NULL;
struct ConfigDev *FindConfigDev();

Disable();
while ((ConfigDev = FindConfigDev( ConfigDev, 2127, 1 )) && cport==NULL)
	{
	if (ConfigDev->cd_Driver==NULL) /* Is card in use? */
		{
		ConfigDev->cd_Driver=(APTR)1; /* Gain Exclusive Access to card */
		cport=(USHORT *)ConfigDev->cd_BoardAddr;
		}
	}
Enable();

if (cport==NULL) {printf("Can't find free AD1012 Card\n");return(NULL);}
return(cport);
}
/********************************************************************/
/********************************************************************/
/********************************************************************/
/********************************************************************/
void FreeAD1012(fport)
USHORT *fport;
{
struct ConfigDev *ConfigDev=NULL;
struct ConfigDev *FindConfigDev();

while ((ConfigDev = FindConfigDev( ConfigDev, 2127, 1 ))) 
	{
	if (fport==(USHORT *)ConfigDev->cd_BoardAddr)
		ConfigDev->cd_Driver=NULL; /* Release Exclusive Access to card */
	}
}
/********************************************************************/
/********************************************************************/
