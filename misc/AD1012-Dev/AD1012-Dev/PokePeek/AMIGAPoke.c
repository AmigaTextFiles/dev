/**********************************************************************
Copyright (C) 1992 SunRize Industries
	Written by Todd Modjeski/Anthony Wood
**********************************************************************/
#include "exec/types.h"
#include "exec/exec.h"
#include "libraries/configvars.h"

#define STATUS	0
#define DATA	1

#define RDOK68 0x0200
#define WROK68 0x0100
/********************************************************************/
struct ExpansionBase *ExpansionBase=NULL;
/********************************************************************/
USHORT *AllocAD1012();
void FreeAD1012();
void poke();
int Hex2int();
/********************************************************************/
USHORT *port;  /* This will point to the AD1012 */
/********************************************************************/


/********************************************************************/
/********************************************************************/
void main(argc,argv)
int argc;
char *argv[];
{
if (argc!=3) {printf("USAGE:%s address value\n",argv[0]);exit();}

if (!(ExpansionBase = (struct ExpansionBase *)OpenLibrary("expansion.library",0)))
	{printf("Cant open Expansion Lib!");exit(10);}

port=AllocAD1012();

if (port) poke(argv[1],argv[2]);

if (port) FreeAD1012(port);

if (ExpansionBase)	CloseLibrary(ExpansionBase);
}
/********************************************************************/
/********************************************************************/
void poke(AddrStr,ValuStr)
char *AddrStr,*ValuStr;
{
int address=Hex2int(AddrStr);
int value=Hex2int(ValuStr);

if (address==-1 || value==-1) return; /* Error in Conversion */

*(port+address/2)=value;
printf("APoke 0x%0x , 0x%0x\n",(USHORT)address,(USHORT)value);
}
/********************************************************************/
/********************************************************************/
int Hex2int(string)
char *string;
{
int x;
int y=0;

for (x=0;x<stclen(string);x++)
	{
	y=y*16;
	switch (string[x])
		{
		case '0': 
		case '1': 
		case '2': 
		case '3': 
		case '4': 
		case '5': 
		case '6': 
		case '7': 
		case '8': 
		case '9': 
			y=y+(string[x]-'0');
			break;
		case 'a':
		case 'b':
		case 'c':
		case 'd':
		case 'e':
		case 'f':
			y=y+(string[x]-'a')+10;
			break;
	
		case 'A':
		case 'B':
		case 'C':
		case 'D':
		case 'E':
		case 'F':
			y=y+(string[x]-'A')+10;
			break;
		default:
			printf("Invalid Parameter Error.\n");
			return(-1); /* INVALID VALUE */
			break;
		}
	}

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
