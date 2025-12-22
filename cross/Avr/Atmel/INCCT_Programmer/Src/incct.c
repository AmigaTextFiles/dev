/*************************************************************************/
/* ATMEL microcontroller, in circuit programmer.                         */
/* The input file should be a Motorola S19 Record.                       */
/*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>

#include "progress.h"
#include "globdefs.h"

unsigned char PORT=0;

#define  BUSY    1       /*Bit value of busy line*/
#define  DATA    1
#define  CLOCK   2
#define  RESET   4

#define  DATA_REG   ((BYTE*)0xBFE101L)
#define  STAT_REG   ((BYTE*)0xBFD000L)

#define  DATA_LINE_HIGH  PORT|=DATA;  Out(DATA_REG,PORT)
#define  DATA_LINE_LOW   PORT&=~DATA; Out(DATA_REG,PORT)
#define  DATAIN          (In(STAT_REG) & BUSY)

#define CLOCK_HIGH  PORT|=CLOCK; Out(DATA_REG,PORT)     /*clock high*/
#define CLOCK_LOW   PORT&=~CLOCK; Out(DATA_REG,PORT)    /*clock low*/
#define RESET_HIGH  PORT|=RESET; Out(DATA_REG,PORT)
#define RESET_LOW   PORT&=~RESET; Out(DATA_REG,PORT)

#define PROGRAM_ENABLE 0xAC530000UL
#define CHIP_ERASE     0xAC800000UL
#define LOCK_CHIP			 0xACE00000UL

#define LOCK		1
#define READ		2

#define MAX_SR_LINE 16      /*16 bytes max on one S Record line*/

struct SData {
							 BYTE *Buffer;
							 int  BufferSize;
							 UWORD Address;
							 int  LineType;
						 };

BYTE SRBuffer[MAX_SR_LINE];
BYTE SROffset;

void SendByte(ULONG Data, BYTE BitCount);
void Out(BYTE *Port, BYTE data);
BYTE In(BYTE *Port);
BYTE GetVal();
void Clock();
BYTE ReadProgramMemory(ULONG Address, BYTE High);
void WriteProgramMemory(ULONG Address, BYTE Data, BYTE High);
int ParseSLine(FILE *Infile, struct SData *Info);
BYTE HexToByte(char *Hex);
void Reset_High();
void Reset_Low();
void Data_Low();
void Data_High();
void Clock_Low();
void Clock_High();
ULONG GetDeviceCode();
void ReadFlash(FILE *Outfile,int Size);
void delay(int Milliseconds);
ULONG SRecordSize(FILE *Record);
int FinishSRecord(FILE *F,int PC);
int FlushSRBuffer(FILE *Outfile,int PC);
int PutSRBuffer(FILE *File, BYTE Data, int PC);
int StartSRecord(FILE *File, char *Name);

int Program_It(int argc, char *argv[])
{
	FILE *Infile;
  ULONG Size, ByteCounter=0;
	WORD Address;
	BYTE Data, Check, OldPort, OldStatus;
	struct SData SLine;
	int Os, High, Try, RRes;
	BYTE Flags=0;
	ULONG DeviceCode;
	char *Sizes[]={"1K","2K","4K","8K","?"};
	int MemBytes[]={1024,2048,4096,8192};

  printf("\nINCCT "VERSION" ©1999 LJS By Lee Atkins.\nATMEL in circuit programmer.\n");

  if(strchr(argv[1],'?'))
	{
		printf("\nINCCT <filename> [options]");
		printf("\noptions:\n-l  Lock device.\n");
		printf("-r  Read Flash to <filename>\n");
    printf("-ee Write <filename> to EEPROM.\n");
    printf(" No arguments starts GUI.\n\n");
		return 0;
	}

	for(Try=1; Try<argc; Try++)
	{
		if(strcmp(argv[Try],"-l")==0) Flags|=LOCK;
		if(strcmp(argv[Try],"-r")==0) Flags|=READ;
    if(strcmp(argv[Try],"-ee")==0)
    {
      printf("Not done!\n");
      return 0;
    }
	}

	if(Flags&READ)
	{
		Infile=fopen(argv[1],"wb");
	}
	else
	{
		Infile=fopen(argv[1],"r");      /*Only text (Motorola S record)*/
	}

	if (Infile==NULL)
	{
		printf("Can't open %s\n",argv[1]);
		return 0;;
	}

  OldPort=*((BYTE*)0xBFE301L);    /*Save old port state*/
  OldStatus=*((BYTE*)0xBFD200L);
  *((BYTE*)0xBFE301L)=0xFF;      /*Set new port state*/

  *((BYTE*)0xBFD200L)=OldStatus&(~BUSY); 
  
	Out(DATA_REG,0);
	delay(1);
	Reset_High();
	delay(100);
	Reset_Low();
	delay(100);
	if(!(Flags&READ))
	{
    Size=SRecordSize(Infile);    
		SendByte(PROGRAM_ENABLE,32);
		SendByte(CHIP_ERASE,32);
		delay(100);												/*wait for processor to finish whatever.*/

		Reset_High();
		Reset_Low();
		delay(40);
	}
	SendByte(PROGRAM_ENABLE,32);

	DeviceCode=GetDeviceCode();
	printf("Device code : 0x%08lX\n",DeviceCode);
	printf("Manufacturer:");
	if((DeviceCode&0xFF000000UL)==0x1E000000UL)
	{
	 printf("ATMEL\n");
	}
	else
	{
		printf("Unknown\n");
	}
	printf("Flash size:");
	printf("%s\n",Sizes[((DeviceCode&0x000F0000)>>16)<4 ? (DeviceCode&0x000F0000)>>16:4]);

	if(Flags&READ)
	{
    if( ((DeviceCode&0x000F0000)>>16) <4)
    {
		  ReadFlash(Infile,MemBytes[(DeviceCode&0x000F0000)>>16]);
		  fclose(Infile);
		  Reset_High();
      *((BYTE*)0xBFE301L)=OldPort;
      *((BYTE*)0xBFD200L)=OldStatus;
  
		  return 1;
    }
    else
    {
      printf("Can't read device.\n");
    }
	}

	while( (RRes=ParseSLine(Infile,&SLine)) == 1 )
	{
		if (SLine.LineType==0)
		{
			printf("S record name : ");
			printf("%s\nProgramming....",SLine.Buffer);
		}
		else if(SLine.LineType==1)
		{
			Os=0;
			while(SLine.BufferSize)
			{
				Try=5;
				do
				{
					WriteProgramMemory(SLine.Address>>1,*(SLine.Buffer+Os),SLine.Address&1);
					delay(4);
					Check=ReadProgramMemory(SLine.Address>>1,SLine.Address&1);
					Try--;
				}while((Check!=*(SLine.Buffer+Os)) && (Try));
				if(Try==0)
				{
					printf(" **** Device failed ****\n");

          FinishProgress();
					free(SLine.Buffer);
					fclose(Infile);
					Reset_High();
          *((BYTE*)0xBFE301L)=OldPort;
          *((BYTE*)0xBFD200L)=OldStatus;
					return 0;
				}

				SLine.Address++;
				Os++;
        ByteCounter++;
				SLine.BufferSize--;
        Progress(ByteCounter,Size);   /*Display progress bar*/
			}
		}
		free(SLine.Buffer);
	}

  FinishProgress();       /*Close progress bar*/

  if(RRes==2)
  {
    free(SLine.Buffer);
	  fclose(Infile);
	  if(Flags&LOCK)
	  {
		  SendByte(LOCK_CHIP,32);
		  printf("Device locked.\n");
	  }

	  printf("\nFinished.\n");
	  Reset_High();
    *((BYTE*)0xBFE301L)=OldPort;
    *((BYTE*)0xBFD200L)=OldStatus;
    return 1;
  }
  else
  {
    printf("S Record error!\n");
  }
  fclose(Infile);
  *((BYTE*)0xBFE301L)=OldPort;
  *((BYTE*)0xBFD200L)=OldStatus;
  
  return 0;
}/*end*/

void SendByte(ULONG Data, BYTE BitCount)
{
	 /*Sends data to the processor, serialy*/
 /* 'BitCount' bits from 'Data' will be sent , MSB first*/
 while(BitCount)
 {
	 Clock_Low();
	 if (Data & 0x80000000UL)
	 {
		 Data_High();
	 }
	 else
	 {
		 Data_Low();
	 }
	 Clock_High();
   Data<<=1;
	 BitCount--;
 }
 Clock_Low();
}

BYTE GetByte()
{
 BYTE Weight=0x80;
 BYTE Result=0, Count=8;

 /*gets data from the processor, serialy*/
 /* MSB first*/

 while(Count)
 {
	 Clock_Low();
	 if (DATAIN)
	 {
		 Result|=Weight;
	 }
	 else
	 {
	 }
	 Weight>>=1;
   Weight&=127;
	 Count--;
	 Clock_High();
 }
 Clock_Low();

 return Result;
}

void Out(BYTE *Port, BYTE data)
{
  *Port=data;
}

BYTE In(BYTE *Port)
{
  return (*Port);
}

void Data_Low()
{
	DATA_LINE_LOW;
}

void Data_High()
{
	DATA_LINE_HIGH;
}

void Clock_Low()
{
	CLOCK_LOW;
  CLOCK_LOW;
}

void Clock_High()
{
 CLOCK_HIGH;
 CLOCK_HIGH;
 CLOCK_HIGH;
}

void Reset_Low()
{
	RESET_LOW;
}

void Reset_High()
{
	RESET_HIGH;
}

BYTE ReadProgramMemory(ULONG Address, BYTE High)
{
	/*reads either the high (High=1) byte or low byte (High=0) from an address.*/

	ULONG Command;

	if (High)
	{
		Command=0x28;
	}
	else
	{
		Command=0x20;
	}
	Command<<=24;
			/* Command = 0x28000000 or 0x20000000*/
	Address<<=8;
	Address&=0x0007ff00UL;
	Command|=Address;
	SendByte(Command,24);        /*move the command and address to the chip.*/
	return GetByte();
}

void WriteProgramMemory(ULONG Address, BYTE Data, BYTE High)
{
	/*reads either the high (High=1) byte or low byte (High=0) from an address.*/

	ULONG Command;

	if (High)
	{
		Command=0x48000000;
	}
	else
	{
		Command=0x40000000;
	}
			/* Command = 0x48000000 or 0x40000000*/
	Address<<=8;
	Address&=0x0007ff00UL;
	Command|=Address;
	Command|=(Data&0xFF);

	SendByte(Command,32);  /*move the command, address and data to the chip.*/
}

BYTE HexToByte(char *Hex)
{
	/*assumes valid hex*/
	int Result=0;
	Result=(*Hex<'A' ? *Hex-'0':10+(*Hex-'A'));
	Result*=16;
	Hex++;
	Result+=(*Hex<'A' ? *Hex-'0':10+(*Hex-'A'));
	return Result;
}

int ParseSLine(FILE *Infile, struct SData *Info)
{
	BYTE Temp[80], Hex[2], Result, *Buffer=NULL,Ret=1;
	int Offset, ByteCount, ResultOs=0;

	if (fgets(Temp,80,Infile))
	{
    if(Temp[0]!='S')
    {
      return 0;
    }
		Info->LineType=Temp[1]-0x30;
    if(Info->LineType==9)
    {
      Ret=2;
    }
		Offset=2;
		Hex[0]=Temp[Offset++];
		Hex[1]=Temp[Offset++];
		ByteCount=HexToByte(Hex);
		ByteCount-=3;								/*2 bytes address, 1 check.*/
		Buffer=(BYTE*)malloc(ByteCount+1);
		if (Buffer==NULL)
		{
			return 0;
		}
		Info->BufferSize=ByteCount;
		Hex[0]=Temp[Offset++];        /*Get address.*/
		Hex[1]=Temp[Offset++];
		Result=HexToByte(Hex);
		Info->Address=Result;
		Info->Address<<=8;

		Hex[0]=Temp[Offset++];
		Hex[1]=Temp[Offset++];
		Info->Address|=HexToByte(Hex)&0xFF;
		while(ByteCount)
		{
			Hex[0]=Temp[Offset++];
			Hex[1]=Temp[Offset++];
			Result=HexToByte(Hex);
			*(Buffer+ResultOs)=Result;
			ResultOs++;
			ByteCount--;
		}
		*(Buffer+ResultOs)=0;
		Info->Buffer=Buffer;
		return Ret;
	}
	return 0;
}

ULONG GetDeviceCode()
{
	int Address=0;
	ULONG Command=0x30000000UL, Result=0;
	int Count;

	for(Count=0; Count<3; Count++)
	{
		SendByte(Command|(Address<<8),24);
		Result|=(GetByte()&0xFF);
		Result<<=8;
    Address++;
	}
	return Result;
}

void ReadFlash(FILE *Outfile,int Size)
{
	int Address;
	BYTE Check;

  StartSRecord(Outfile,"FLASH");

	for(Address=0; Address<Size; Address++)
	{
  	Check=ReadProgramMemory(Address>>1,Address&1);
    PutSRBuffer(Outfile,Check,Address);
	}
  FinishSRecord(Outfile,Address);
}

ULONG SRecordSize(FILE *Record)
{
  ULONG Result=0;
  struct SData SLine;

  while(ParseSLine(Record,&SLine))
  {
    if(SLine.LineType==1)
    {
      Result+=SLine.BufferSize;
    }
    free(SLine.Buffer);
  }
  fseek(Record, 0, SEEK_SET);
  return Result;
}

int StartSRecord(FILE *File, char *Name)
{
	int Checksum, Temp;
	char *Orig;

	Orig=Name;
	fprintf(File,"S0");
	Temp=0;
	while( (*Name) && (*Name!='.') )
	{
		Temp++;
		Name++;
	}
	Name=Orig;
	Temp+=3;      /*+address +checksum*/
	Checksum=Temp;
	fprintf(File,"%02X",Temp);
	fprintf(File,"0000");
	while( (*Name) && (*Name!='.') )
	{
		fprintf(File,"%02X",*Name);
		Checksum+=*Name;
		Name++;
	}
	Checksum=~Checksum;
	fprintf(File,"%02X\n",(Checksum&255));
	SROffset=0;
	return 1;
}

int PutSRBuffer(FILE *File, BYTE Data, int PC)
{
	SRBuffer[SROffset]=Data;
	SROffset++;
	if(SROffset==MAX_SR_LINE)
	{
		FlushSRBuffer(File,PC);
	}
	return 1;
}

int FlushSRBuffer(FILE *Outfile,int PC)
{
	int C,Count;
	int Checksum;

	Count=SROffset;
	if(Count==0)
	{
		return 1;
	}
	fprintf(Outfile,"S1");
	fprintf(Outfile,"%02X",(Count+3)&255);  /*+3 for checksum and address*/
	Checksum=Count+3;
	fprintf(Outfile,"%04X",PC-Count+1);
	Checksum+=((PC-Count+1)>>8);
	Checksum+=((PC-Count+1)&255);
	for(C=0; C<Count; C++)
	{
		fprintf(Outfile,"%02X",SRBuffer[C]&255);
		Checksum+=SRBuffer[C];
	}
	Checksum=~Checksum;
	fprintf(Outfile,"%02X\n",(Checksum&255));
	SROffset=0;
	return 1;
}

int FinishSRecord(FILE *F,int PC)
{
	 FlushSRBuffer(F,PC);
	 fprintf(F,"S9030000FC\n");
	 return 1;
}
