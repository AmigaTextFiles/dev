/**********************************************************************
Copyright (C) 1992 SunRize Industries
	Written by Todd Modjeski
**********************************************************************/
#include "exec/types.h"
#include "exec/exec.h"
#include "libraries/configvars.h"
#include <libraries/dosextens.h>
/********************************************************************/
#define STATUS	0
#define DATA	1

#define RDOK68 0x0200
#define WROK68 0x0100
/********************************************************************/
struct ExpansionBase *ExpansionBase=NULL;
/********************************************************************/
void SendW();
USHORT GetW();
int SendCode();
USHORT *AllocAD1012();
void FreeAD1012();
/********************************************************************/
USHORT *port;
/********************************************************************/

/********************************************************************/
/********************************************************************/
void main(argc,argv)
int argc;
char *argv[];

{
if (argc!=2) {printf("USAGE:%s FileName\n",argv[0]);exit();}

if ((ExpansionBase = (struct ExpansionBase *)OpenLibrary("expansion.library",0))==0)
	{printf("Cant open Expansion Lib!");exit(10);}

port=AllocAD1012();

if (port) SendCode(argv[1]);

if (port) FreeAD1012(port);

if (ExpansionBase)	CloseLibrary(ExpansionBase);
}
/********************************************************************/
/********************************************************************/
int SendCode(s)
char *s;
{
struct FileHandle *fp2;
extern struct FileHandle *Open();
USHORT *x,*x1;
int z,c;

for(z=0;z<1024;z++) {c=*(port+DATA);SendW(0x003B);}

if(!(x=(USHORT *)AllocMem(0x03f4<<2,NULL)))
	{
	printf("Could Not Allocate Memory");
	return(1);
	}
x1=x;

if ((fp2=Open(s,MODE_OLDFILE))==0)
	{
	printf("Could Not Open File\n");
	FreeMem(x,0x03f4<<2);
	return(2);
	}

if(Read(fp2,x,(0x03f3<<2))!=(0x03f3<<2))
	{
	printf("File is not long enough\n");
	FreeMem(x,0x03f4<<2);
	Close(fp2);
	return(3);
	}

printf("Sending Dsp Object:%s\n",s);

SendW(0x003F);
SendW(0x0000);
SendW(0x03F1);

SendPgm(port,x1); /* Asm Routine */

FreeMem(x,0x03f4<<2);
Close(fp2);

return(0);
}
/********************************************************************/
/********************************************************************/



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
