
/* PIC12C508 Programmer */

#include <exec/types.h>
#include <devices/serial.h>
#include <proto/exec.h>
#include <stdio.h>
#include <string.h>
#include <dos/dos.h>

#define DEVICE_NAME "serial.device"
#define UNIT_NUMBER 0

int Decode(char *);
void Download(void);
int  Serread(char *);
void Program(void);
void Serwrite(char *);
void Blank(void);
int GoDec(char);
FILE *Hex;
char data[2060];
struct MsgPort	*SerialMP;
struct IOExtSer	*SerialIO;
int SerialERROR;




main()
	{
	char keuze;

	printf("\n\f\nPIC12C508 Programmer for the Amiga\n");
	printf("developed by Dennis van Weeren (d.vanweeren@worldonline.nl)\n");
	printf("V1.2 12-01-1999 This Package is CARDWARE\n");

	do
	{
	printf("\n\nD=Download File\nP=Start Programming\nB=Blanktest\nE=Exit\n");
	printf("\n>");fflush(stdout);
	scanf("%c\n",&keuze);fflush(stdout);
	switch (toupper(keuze))
		{
		case 'P':
							Program();
							break;
		case 'D':
							Download();
							break;
		case 'B':
							Blank();
							break;
		case 'E':
							return;
							break;
		}
	}
	while(1==1);


	}


void Blank (void)
	{
	char Res;
	if(SerialMP=CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(DEVICE_NAME,UNIT_NUMBER,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=2400;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);
						do
							{
							Serwrite((APTR)"b");
							printf("\n\f-------------------------------------------------\n");
							printf("Testing, please Wait\n\n");
							if(Serread(&Res))
								{
								printf("User Aborted\n");
								break;
								}
							if (Res=='R')
								printf("Device is Blank (Empty)\n");
							else
								printf("Device NOT properly Erased!\n");
							}
						while(0);
						printf("-------------------------------------------------\n\n");

						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}


void Program (void)
	{
	char Res;
	int resultflag,tel;
	if(SerialMP=CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(DEVICE_NAME,UNIT_NUMBER,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=2400;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);
						resultflag=0;
						Res='a';
						do
							{
							Serwrite((APTR)"p");

							printf("\n\f-------------------------------------------------\n");
							printf("Programming, Please Wait\n\n");

							if(Serread(&Res))
								break;

							if (Res=='B')
								printf("Blanktest Passed\n\n");
							else
								{
								printf("Blanktest Failed\n");
								resultflag=1;
								break;
								}
							tel=0;
							do
								{
								if(Serread(&Res))
									break;
								if (Res=='z')
									{
									tel=tel+1;
									}
								}
							while (Res!='I' && Res!='i');

							if (Res=='I')
								printf("Programming Phase Passed\n\n");
							else
								{
								printf("Programming Phase Failed at word %d\n",tel-1);
								resultflag=1;
								break;
								}
							if(Serread(&Res))
								break;

							if (Res=='M')
								printf("Vdd Min Verify Passed\n\n");
							else
								{
								printf("Vdd Min Verify Failed\n");
								resultflag=1;
								break;
								}
							if(Serread(&Res))
								break;

							if (Res=='X')
								printf("Vdd Max Verify Passed\n\n");
							else
								{
								printf("Vdd Max Verify Failed\n");
								resultflag=1;
								break;
								}
							if(Serread(&Res))
								break;

							if (Res=='C')
								printf("Configuration Word Programmed\n");
							else
								{
								printf("Configuration Word Failed\n");
								resultflag=1;
								break;
								}


							}
						while(0);

						printf("-------------------------------------------------\n");

						if (resultflag==0 && Res=='C')
							printf("Device PASSED !\n");
						else
							{
							if (resultflag==0)
								printf("User Aborted\n");
							else
								printf("Device FAILED !\n");
							}

						printf("-------------------------------------------------\n");

						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}



void Download(void)
	{
	char backup[8],Config[4],Response[4],Name[80],C,OK;
	int teller;
	printf("\n\f\n---------------------------------------------------\n");
	printf("\nFilename (full path):");fflush(stdout);
	scanf("%s\n",&Name);fflush(stdout);
	if (Decode((APTR)&Name))
		return;
	printf("\nPlease Enter the configuration:\n");
	do
		{
		Config[0]=97;
		Config[1]=97;

		printf("\n\nDo you want Code Protection? (y/n)");fflush(stdout);
		do
			{
			scanf("%c\n",&C);fflush(stdout);
			}
		while(toupper(C)!='Y' && toupper(C)!='N');
		if(toupper(C)=='N')
			{
			Config[1]=Config[1]+8;
			printf("Code Protection disabled (bit set)\n");
			}
		else
			printf("Code Protection enabled (bit cleared)\n");

		printf("\nDo you want the Master Clear Pin Enable Bit Set? (y/n)");fflush(stdout);
		do
			{
			scanf("%c\n",&C);fflush(stdout);
			}
		while(toupper(C)!='Y' && toupper(C)!='N');
		if(toupper(C)=='Y')
			{
			Config[0]=Config[0]+1;
			printf("Master Clear Pin enabled\n");
			}
		else
			printf("Master Clear Pin disabled\n");


		printf("\nDo you want the Watchdogtimer Enable Bit Set? (y/n)");fflush(stdout);
		do
			{
			scanf("%c\n",&C);fflush(stdout);
		  }
		while(toupper(C)!='Y' && toupper(C)!='N');
		if(toupper(C)=='Y')
			{
			Config[1]=Config[1]+4;
			printf("Watchdogtimer enabled\n");
			}
		else
			printf("Watchdogtimer disabled\n");

		printf("\nWhich Oscillator Type do you want?\n\n");fflush(stdout);
		printf("a=External RC\n");fflush(stdout);
		printf("b=Internal RC\n");fflush(stdout);
		printf("c=XT (External Cristal)\n");fflush(stdout);
		printf("d=LP (Low Power)\n");fflush(stdout);
		do
			{
			scanf("%c\n",&C);fflush(stdout);
			}
		while(toupper(C)!='A' && toupper(C)!='B' && toupper(C)!='C' && toupper(C)!='D');
		switch (toupper(C))
			{
			case 'A':
								printf("External RC Selected\n");
								Config[1]=Config[1]+3;
								break;
			case 'B':
								printf("Internal RC Selected\n");
								Config[1]=Config[1]+2;
								break;
			case 'C':
								printf("XT Selected\n");
								Config[1]=Config[1]+1;
								break;
			case 'D':
								printf("LP Selected\n");
								break;
			}
		printf("\nIs this Right? (y/n)");fflush(stdout);
		do
			{
			scanf("%c\n",&OK);fflush(stdout);
			}
		while(toupper(OK)!='Y' && toupper(OK)!='N');
		}
	while(toupper(OK)!='Y');



	if(SerialMP=CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{
				if (OpenDevice(DEVICE_NAME,UNIT_NUMBER,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{

						SerialIO->io_Baud=2400;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;

						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;

						DoIO((struct IORequest *)SerialIO);


						do
						{
						Serwrite((APTR)"d");
						Serwrite((APTR)"a");
						Serwrite((APTR)"a");

						if (Serread(&Response[0]))
							break;
						if (Serread(&Response[1]))
							break;


						printf("\n\nContact made\n");
						printf("Downloading, Please Wait\n");


						if (Serread(&Response[0]))
							break;

						if (Response[0]=='f')
							break;


						Serwrite((APTR)"n");
						Serwrite(&Config[0]);
						Serwrite(&Config[1]);
						if (Serread(&Response[0]))
							break;
						if (Serread(&Response[1]))
							break;


						if (Serread(&Response[0]))
							break;

						if (Response[0]=='f')
							printf("ERROR occurred while downloading Config\n");

						Serwrite((APTR)"n");


						teller=0;
						do
								{
								backup[2]=data[teller];
								teller=teller+1;
								backup[3]=data[teller];
								teller=teller+1;

								backup[0]=data[teller];
								teller=teller+1;
								backup[1]=data[teller];
								teller=teller+1;

								Serwrite(&backup[0]);
								Serwrite(&backup[1]);

								if (Serread(&Response[0]))
									break;
								if (Serread(&Response[1]))
									break;

								if ((char)Response[0]!=(char)backup[0]||(char)Response[1]!=(char)backup[1])
									printf("Serial Verify error!\n");


								if (Serread(&Response[2]))
									break;


								if (Response[2]=='f')
									printf("ERROR occurred while downloading Data\n");


								Serwrite((APTR)"n");

								Serwrite(&backup[2]);
								Serwrite(&backup[3]);


								if (Serread(&Response[0]))
									break;
								if (Serread(&Response[1]))
									break;

								if ((char)Response[0]!=(char)backup[2]||(char)Response[1]!=(char)backup[3])
									printf("Serial Verify error!\n");


								if (Serread(&Response[2]))
									break;

								if (Response[2]=='f')
									printf("ERROR occurred while downloading Data\n");

								SerialIO->IOSer.io_Command=CMD_WRITE;
								SerialIO->IOSer.io_Length=1;
								if (teller==2048)
									{
									printf("Last byte Programmed\n");
									SerialIO->IOSer.io_Data=(APTR)"e";
									}
								else
									{
									SerialIO->IOSer.io_Data=(APTR)"n";
									}
								DoIO((struct IORequest *)SerialIO);
								}
						while(teller<2048);

						if(Serread(&Response[0]))
							break;
						if (Response[0]!='p')
							printf("OOPS! Checksum Failed!\nDownloading Failed\n");
						else
							printf("Downloading Succesfully Completed!\n\n");
						}
						while(0);

						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}


void Serwrite (char *D)
	{
	SerialIO->IOSer.io_Command=CMD_WRITE;
	SerialIO->IOSer.io_Length=1;
	SerialIO->IOSer.io_Data=(APTR)D;
	DoIO((struct IORequest *)SerialIO);
	}

int Serread (char *D)
	{
	ULONG Mask,Temp;
	int R;
	SerialIO->IOSer.io_Command=CMD_READ;
	SerialIO->IOSer.io_Length=1;
	SerialIO->IOSer.io_Data=(APTR)D;
	SendIO((struct IORequest *)SerialIO);

	Mask=SIGBREAKF_CTRL_C|1L << SerialMP->mp_SigBit;
	R=0;
	while(1)
		{
		Temp=Wait(Mask);
		if (SIGBREAKF_CTRL_C & Temp)
			{
			R=1;
			AbortIO((struct IORequest *)SerialIO);
			WaitIO((struct IORequest *)SerialIO);
			break;
			}

		if (CheckIO((struct IORequest *)SerialIO))
			{
			WaitIO((struct IORequest *)SerialIO);
			break;
			}


		}

	return(R);
	}



int Decode(char *Filename)
	{
	char B,flag;
	int teller,aantal,D,total;
	Hex=fopen(Filename,"r");
	if(Hex)
		{
		printf("File %s opened !\n",Filename);
		total=0;
		flag='0';
		do
			{
			do
				{
				B=getc(Hex);
				if (B==EOF)
					{
					printf("File Not a INHX8M File!\n");
					fclose(Hex);
					return(1);
					}
				}
			while (B!=':');

			aantal=0;
			B=getc(Hex);
			D=GoDec(B);
			aantal=D*16;
			B=getc(Hex);
			D=GoDec(B);
			aantal=aantal+D;
			for(teller=0;teller<5;teller++)
				B=getc(Hex);
			flag=getc(Hex);
			for (teller=0;teller<aantal;teller++)
				{
				if (aantal>=2048)
					{
					printf("Hex File to long!\n");
					fclose(Hex);
					return(1);
					}
				B=getc(Hex);
				data[total]=97+GoDec(B);
				total=total+1;

				B=getc(Hex);
				data[total]=97+GoDec(B);
				total=total+1;
				}
			}
		while(flag=='0');
		fclose(Hex);
		teller=total;
		while(teller<2048)
			{
			data[teller]='p';
			teller=teller+1;
			}

		if ((total%4)==0)
			{
			printf("%d Bytes decoded\n",total/4);
			}
		else
			{
			printf("Error, half words in File!\n");
			return(1);
			}
		}
	else
		{
		printf("File %s Could not be opened\n",Filename);
		return(1);
		}
	return(0);
	}



int GoDec(char in)
	{
	int out;
	switch(in)
		{
		case '0':
			out=0;
			break;
		case '1':
			out=1;
			break;
		case '2':
			out=2;
			break;
		case '3':
			out=3;
			break;
		case '4':
			out=4;
			break;
		case '5':
			out=5;
			break;
		case '6':
			out=6;
			break;
		case '7':
			out=7;
			break;
		case '8':
			out=8;
			break;
		case '9':
			out=9;
			break;
		case 'A':
			out=10;
			break;
		case 'B':
			out=11;
			break;
		case 'C':
			out=12;
			break;
		case 'D':
			out=13;
			break;
		case 'E':
			out=14;
			break;
		case 'F':
			out=15;
			break;
		}
	return(out);
	}





