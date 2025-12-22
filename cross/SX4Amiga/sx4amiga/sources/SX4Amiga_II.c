/* SX4Amiga */
/* SX programmer */


// rev 2.0
// Only bits 11-8 are restored after erase

#include <exec/types.h>
#include <devices/serial.h>
#include <proto/exec.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <proto/dos.h>
#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/devices.h>


#define DEVICE_NAME "serial.device"
#define UNIT_NUMBER 0


int  Decode(char *);
void Program(void);
void PatchHEX(void);
void Verify(void);
void EraseProgramMemory(void);
void RestoreFuseX(void);
int  SerRead(char *);
void SerWrite(char *);
int  GoDec(char);
char GoHex(int);



int StartISP();
int StopISP();
int Erase();
int ReadDeviceWord(char *);
int ReadFusexWord(char *);
int ProgramFusexWord();
int LoadData(char *);
int ProgramData();
int ReadData(char *);
int IncrementAdress();




int EraseTime,ProgramTime;
char NEWFUSEX[10],NEWFUSE[10];
char serialdevicename[30];
int  serialdevicenumber;
FILE *Hex;
char *data;
#define	BUFFERSIZE 10000
int lastadress;
struct MsgPort	*SerialMP;
struct IOExtSer	*SerialIO;
int SerialERROR;


void main(int argc, char **argv )
	{
	char name[30];
	char keuze[30];
	int flag,ms;

	printf("\n\f\n");

	if(argc<2)
		{
		strcpy(&serialdevicename[0],DEVICE_NAME);
		serialdevicenumber=UNIT_NUMBER;
		printf("Use SX4Amiga <serial device name> <serial device number> to use\n");
		printf("non standard serial ports\n\n");
		}
	else
		{
		if(argc!=3)
			{
			printf("Wrong number of arguments !\n");
			return;
			}
		else
			{
			strcpy((char *)&serialdevicename[0],(char const *)argv[1]);
			serialdevicenumber=(*argv[2])-48;
			}
		}


	printf("Starting with adapter connected to %s at unit %d\n",serialdevicename,serialdevicenumber);

	Delay(200);

	EraseTime=189;		//100ms
	ProgramTime=189;	//100ms


	flag=1;

	printf("\n\f\nSX4Amiga\n");
	printf("developed by Dennis van Weeren (d.vanweeren@wanadoo.nl)\n");
	printf("V0.96ß 02-12-2001 This Package is FREEWARE\n\n");


	strcpy(name,"<empty>");
	lastadress=0;
	strcpy(NEWFUSE,"fff");
	strcpy(NEWFUSEX,"fff");



	data=AllocMem(sizeof(char)*BUFFERSIZE,MEMF_PUBLIC);
	if(data==0)
		{
		printf("Not enough memory\n");
		exit(30);
		}


	do
	{
	printf("-------------------------------------------------------------\n");
	printf("Buffer:%s  fuse:0X%s  fuseX:0X%s  Timing=%dms\n",name,NEWFUSE,NEWFUSEX,(int)(ProgramTime*0.53));
	printf("-------------------------------------------------------------\n\n");
	printf("L= Load buffer from file\n");
	printf("F= Enter fuse and fuseX\n");
	printf("T= Enter Programming/Erase times\n");
	printf("E= Erase SX chip\n");
	printf("O= Overwrite FuseX bits 11:8\n");
	printf("V= DEBUGGEN INFO\n");
	printf("W= Write buffer to SX\n");
	//printf("R= Read SX into buffer\n");
	//printf("S= Show SX current fuses\n");
	printf("Q= Quit SX4Amiga\n");

	printf("\n>");fflush(stdout);
	gets(keuze);fflush(stdout);
	switch (toupper(keuze[0]))
		{
		case 'W':
							Program();
							break;

		case 'Q':
							flag=0;
							break;

		case 'V':
							Verify();
							break;


		case 'T':
							printf("Enter new Programming time in ms: (10-100)\n");fflush(stdout);
							scanf("%d",&ms);fflush(stdout);

							if(ms>100)
								ms=100;
							if(ms<10)
								ms=10;

							ProgramTime=((int)(ms/0.53))+1;
							EraseTime=ProgramTime;

							break;

		case 'O':
							printf("\n\nThis function will overwrite ALL bits in FuseX with the currently\n");
							printf("entered value. (0x%s), It also erases the program memory.\n");
							printf("Are you REALLY  SURE you want to continue ? (Y/N)\n",NEWFUSEX);
							gets(keuze);fflush(stdout);
							if(toupper(keuze[0])=='Y')
								{
								RestoreFuseX();
								break;
								}
							else
								break;

		case 'F':
						  printf("Please enter fuse value in HEX:\n");
						  gets(&NEWFUSE[0]);

						  printf("Please enter fuseX value in HEX:\n");
						  gets(&NEWFUSEX[0]);

							break;

		case 'L':
							printf("\nEnter path of hex-file:\n");fflush(stdout);

							gets(name);

							if(Decode(&name[0]))
								{
								printf("Error occurred during decoding of hex-file!\n");
								lastadress=0;
								strcpy(name,"<empty>");
								}
							PatchHEX();
							break;

		case 'E':
							EraseProgramMemory();
							break;
		}
	}
	while(flag==1);

  printf("Quit......\n");

  FreeMem(data,sizeof(char)*BUFFERSIZE);

	}


void Verify()
	{
	char fusex[8],programword[8];
	int x;

	if(SerialMP=(struct MsgPort *)CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(serialdevicename,serialdevicenumber,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=19200;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);



						if(StartISP())
							{
							printf("Reading out SX chip, please wait\n");

							ReadData(&fusex[0]);
							IncrementAdress();
							for(x=0;x<8;x++)
								{
								if(!ReadData(&programword[0]))
									break;
								IncrementAdress();
								printf("%d --> 0X%c%c%c\n",x,programword[3],programword[0],programword[1]);
								}

							printf("Fuse=0X%c%c%c\n\n",fusex[3],fusex[0],fusex[1]);



							ReadDeviceWord(&fusex[0]);
							printf("Device=0X%c%c%c\n\n",fusex[3],fusex[0],fusex[1]);

							ReadFusexWord(&fusex[0]);
							printf("FuseX=0X%c%c%c\n\n",fusex[3],fusex[0],fusex[1]);



							}
						else
							{
							printf("Could not start ISP mode !\n");
							}

						StopISP();

						WaitIO((struct IORequest *)SerialIO);
						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}


void EraseProgramMemory()
	{
	char fusex[8];
	int x;

	if(SerialMP=(struct MsgPort *)CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(serialdevicename,serialdevicenumber,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=19200;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);



						if(StartISP())
							{


							ReadFusexWord(&fusex[0]);

							printf("\nOld FuseX value=0X%c%c%c\n\n",fusex[3],fusex[0],fusex[1]);

							printf("Erasing SX chip.\n");

							Erase();

							//x=GoDec(fusex[0]);

							//if(x>7)
							//	fusex[0]='f';
							//else
							//	fusex[0]='7';


							fusex[1]='f';
							fusex[0]='f';


							//fusex[3]='b';
							//fusex[0]='7';
							//fusex[1]='f';


							printf("Restoring 4 highest order bits of FuseX.\n");
							printf("New FuseX value=0X%c%c%c\n\n",fusex[3],fusex[0],fusex[1]);


							LoadData(&fusex[0]);

							ProgramFusexWord();

							printf("Done!\n\n");


							}
						else
							{
							printf("Could not start ISP mode !\n");
							}

						StopISP();

						WaitIO((struct IORequest *)SerialIO);
						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}


void RestoreFuseX (void)
	{
	char programword[8];

	if(SerialMP=(struct MsgPort *)CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(serialdevicename,serialdevicenumber,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=19200;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);



						if(StartISP())
							{

							programword[3]=NEWFUSEX[0];
							programword[0]=NEWFUSEX[1];
							programword[1]=NEWFUSEX[2];

							printf("Overwriting FuseX....\n");

							printf("\n\nNew FuseX value=0X%c%c%c\n\n",programword[3],programword[0],programword[1]);

							Erase();

							LoadData(&programword[0]);

							ProgramFusexWord();

							ReadFusexWord(&programword[0]);

							if(NEWFUSEX[0]!=programword[3] || NEWFUSEX[1]!=programword[0] || NEWFUSEX[2]!=programword[1])
								{
								printf("FuseX verify error!\n");
								}
							else
								printf("New FuseX OK!\n");


							}
						else
							{
							printf("Could not start ISP mode !\n");
							}

						StopISP();

						WaitIO((struct IORequest *)SerialIO);
						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}


void Program (void)
	{
	int x,error;
	char programword[8];

	error=0;
	if(lastadress==0)
		{
		printf("No Hex file loaded !!!!\n");
		return;
		}


	if(SerialMP=(struct MsgPort *)CreatePort(0,0))
		{
		if (SerialIO=(struct IOExtSer *)CreateExtIO(SerialMP,sizeof(struct IOExtSer)))
				{

				if (OpenDevice(serialdevicename,serialdevicenumber,(struct IORequest *)SerialIO,0) )
						printf("Serial device did not open\n");
				else
						{
						SerialIO->io_Baud=19200;
						SerialIO->io_StopBits=1;
						SerialIO->io_SerFlags=NULL;
						SerialIO->io_WriteLen=8;
						SerialIO->io_ReadLen=8;
						SerialIO->IOSer.io_Command=SDCMD_SETPARAMS;
						DoIO((struct IORequest *)SerialIO);


						if(StartISP())
							{

							printf("\nWriting program memory....\n");

							//DEBUGGEN!!!!
							//if(lastadress>28)
							//	lastadress=28;

							for(x=0;x<lastadress;x=x+4)
								{
								IncrementAdress();

								if(data[x+3]!='f' || data[x+0]!='f' || data[x+1]!='f')
									{
									LoadData(&data[x]);

									ProgramData();
									}

									ReadData(&programword[0]);

								if(data[x+3]!=programword[3] || data[x+0]!=programword[0] || data[x+1]!=programword[1])
									{
									printf("Verify error at adress %d\n",x/4);
									error=1;
									break;
									}


								}

							printf("Program memory programmed\n\n");
							printf("Writing fuse......");fflush(stdout);

							StopISP();

							Delay(100);	//wait approx 2 secs before restarting SX ISP mode

							StartISP();

							programword[3]=NEWFUSE[0];
							programword[0]=NEWFUSE[1];
							programword[1]=NEWFUSE[2];

							LoadData(&programword[0]);

							ProgramData();

							ReadData(&programword[0]);

							if(NEWFUSE[0]!=programword[3] || NEWFUSE[1]!=programword[0] || NEWFUSE[2]!=programword[1])
								{
								printf("Fuse verify error!\n");
								error=1;
								}
							else
								printf("Fuse OK!\n");


							printf("Writing fuseX.....");fflush(stdout);


							ReadFusexWord(&programword[0]);

							programword[1]=NEWFUSEX[2];
							programword[0]=NEWFUSEX[1];


/*							if(GoDec(programword[0])>7)
								{
								if(GoDec(NEWFUSEX[1])>7)
									programword[0]=NEWFUSEX[1];
								else
									programword[0]=GoHex(GoDec(NEWFUSEX[1])+8);
								}
							else
								{
								if(GoDec(NEWFUSEX[1])>7)
									programword[0]=GoHex(GoDec(NEWFUSEX[1])-8);
								else
									programword[0]=NEWFUSEX[1];
							 	}
*/

							LoadData(&programword[0]);

							ProgramFusexWord();

							ReadFusexWord(&programword[4]);

							if(programword[7]!=programword[3] || programword[4]!=programword[0] || programword[5]!=programword[1])
								{
								printf("FuseX verify error!\n");
								error=1;
								}
							else
								printf("Fusex OK!\n");



							if(error==0)
								{
								printf("\nReady and OK.\n");
								}
							else
								{
								printf("\nProgramming NOT succesfull !\n");
								}



							}
						else
							{
							printf("Could not start ISP mode !\n");
							}
						StopISP();






						WaitIO((struct IORequest *)SerialIO);
						CloseDevice((struct IORequest *)SerialIO);
						}
				DeleteExtIO((struct IORequest *)SerialIO);
				}
		DeletePort(SerialMP);
		}
	}




int StartISP()
	{
	char result;

	SerWrite("s");

	SerRead(&result);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}

int StopISP()
	{
	char result;

	SerWrite("q");

	SerRead(&result);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}


int Erase()
	{
	char hi,lo,result,more;

	hi=GoHex(160/16);
	lo=GoHex(160%16);
	printf("EraseTime =%c%c\n",hi,lo);

	{
		SerWrite("c");
		SerWrite(&hi);
		SerWrite(&lo);

  	SerWrite("0");
  	SerWrite("f");
  	SerWrite("f");
  	SerWrite("f");

		SerRead(&result);

  	SerRead(&more);
		SerRead(&more);
		SerRead(&more);
		SerRead(&more);
	}
	{
		SerWrite("c");
		SerWrite(&hi);
		SerWrite(&lo);

  	SerWrite("0");
  	SerWrite("f");
  	SerWrite("f");
  	SerWrite("f");

		SerRead(&result);

  	SerRead(&more);
		SerRead(&more);
		SerRead(&more);
		SerRead(&more);
	}
	{
		SerWrite("c");
		SerWrite(&hi);
		SerWrite(&lo);

  	SerWrite("0");
  	SerWrite("f");
  	SerWrite("f");
  	SerWrite("f");

		SerRead(&result);

  	SerRead(&more);
		SerRead(&more);
		SerRead(&more);
		SerRead(&more);
	}
	{
		SerWrite("c");
		SerWrite(&hi);
		SerWrite(&lo);

  	SerWrite("0");
  	SerWrite("f");
  	SerWrite("f");
  	SerWrite("f");

		SerRead(&result);

  	SerRead(&more);
		SerRead(&more);
		SerRead(&more);
		SerRead(&more);
	}
	{
		SerWrite("c");
		SerWrite(&hi);
		SerWrite(&lo);

  	SerWrite("0");
  	SerWrite("f");
  	SerWrite("f");
  	SerWrite("f");

		SerRead(&result);

  	SerRead(&more);
		SerRead(&more);
		SerRead(&more);
		SerRead(&more);
	}

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int ReadDeviceWord(char *dataword)
	{
	char result,more;

	SerWrite("c");
	SerWrite("0");
	SerWrite("1");

  SerWrite("1");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

	SerRead(&more);
	SerRead(&dataword[3]);
	SerRead(&dataword[0]);
	SerRead(&dataword[1]);
	dataword[2]='0';

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int ReadFusexWord(char *dataword)
	{
	char result,more;

	SerWrite("c");
	SerWrite("0");
	SerWrite("1");

  SerWrite("2");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

	SerRead(&more);
	SerRead(&dataword[3]);
	SerRead(&dataword[0]);
	SerRead(&dataword[1]);
	dataword[2]='0';


	//printf("FUSEX:%c%c%c%c\n",dataword[0],dataword[1],dataword[2],dataword[3]);


	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int ProgramFusexWord()
	{
	char hi,lo,result,more;

	hi=GoHex(95/16);
	lo=GoHex(95%16);

	printf("Program FuseX Time =%c%c\n",hi,lo);

	SerWrite("c");
	SerWrite(&hi);
	SerWrite(&lo);

  SerWrite("3");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

  SerRead(&more);
	SerRead(&more);
	SerRead(&more);
	SerRead(&more);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}




int LoadData(char *dataword)
	{
	char result,more;

	//printf("data:%c%c%c%c\n",dataword[0],dataword[1],dataword[2],dataword[3]);

	SerWrite("c");
	SerWrite("0");
	SerWrite("1");

  SerWrite("4");
  SerWrite(&dataword[3]);
  SerWrite(&dataword[0]);
  SerWrite(&dataword[1]);

	SerRead(&result);

  SerRead(&more);
	SerRead(&more);
	SerRead(&more);
	SerRead(&more);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int ProgramData()
	{
	char hi,lo,result,more;

	hi=GoHex(EraseTime/16);
	lo=GoHex(EraseTime%16);
	//printf("Program Data Time =%c%c\n",hi,lo);

	SerWrite("c");
	SerWrite(&hi);
	SerWrite(&lo);

  SerWrite("5");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

  SerRead(&more);
	SerRead(&more);
	SerRead(&more);
	SerRead(&more);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int ReadData(char *dataword)
	{
	char result,more;

	SerWrite("c");
	SerWrite("0");
	SerWrite("1");

  SerWrite("6");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

	SerRead(&more);
	SerRead(&dataword[3]);
	SerRead(&dataword[0]);
	SerRead(&dataword[1]);
	dataword[2]='0';

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}



int IncrementAdress()
	{
	char result,more;

	SerWrite("c");
	SerWrite("0");
	SerWrite("1");

  SerWrite("7");
  SerWrite("f");
  SerWrite("f");
  SerWrite("f");

	SerRead(&result);

  SerRead(&more);
	SerRead(&more);
	SerRead(&more);
	SerRead(&more);

	if(result=='o')
		return TRUE;
	else
		return FALSE;
	}





void SerWrite (char *D)
	{
	SerialIO->IOSer.io_Command=CMD_WRITE;
	SerialIO->IOSer.io_Length=1;
	SerialIO->IOSer.io_Data=(APTR)D;
	DoIO((struct IORequest *)SerialIO);
	}

int SerRead (char *D)
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
	int check,sum,teller,aantal,D,total,L;


	Hex=fopen(Filename,"r");
	if(Hex)
		{
		printf("File %s opened !\n",Filename);
		total=0;
		flag='0';
		lastadress=0;

		for (teller=0;teller<BUFFERSIZE;teller++)
			data[teller]='f';

		do
			{
			do
				{
				B=getc(Hex);
			  if (B==EOF)
					{
					printf("File Not a INHX8M File!\n");
					printf("(EOF reached before startmarker was found)\n");
					fclose(Hex);
					return(1);
					}
				}
			while(B!=':');

			aantal=0;

			B=getc(Hex);
			D=GoDec(B);
			aantal=D*16;
			B=getc(Hex);
			D=GoDec(B);
			aantal=aantal+D;

			check=aantal;

			B=getc(Hex);
			D=GoDec(B);
			teller=D*4096;
			check=check+(GoDec(B)*16);


			B=getc(Hex);
			D=GoDec(B);
			teller=teller+(D*256);
			check=check+GoDec(B);




			B=getc(Hex);
			D=GoDec(B);
			teller=teller+(D*16);
			check=check+(GoDec(B)*16);

			B=getc(Hex);
			D=GoDec(B);
			teller=teller+D;
			check=check+GoDec(B);

			teller=teller*2;


			B=getc(Hex);
			check=check+(GoDec(B)*16);
			B=getc(Hex);
			flag=B;
			check=check+GoDec(B);

			if (teller>8192)
				{
				teller=8200;
				}

			for (L=0;L<aantal;L++)
				{
				D=0;
				B=getc(Hex);
				data[teller]=tolower(B);
				teller=teller+1;
				check=check+(GoDec(B)*16);
				total=total+1;

				B=getc(Hex);
				data[teller]=tolower(B);
				teller=teller+1;
				check=check+GoDec(B);
				total=total+1;
				}

			if(teller>lastadress)
				lastadress=teller;

			check=check%256;
			check=(256-check)%256;

			B=getc(Hex);
			sum=GoDec(B)*16;
			B=getc(Hex);
			sum=sum+GoDec(B);

			if(getc(Hex)!=13)
				printf("OOPS!!, No CR at end of line!, but continue anyway\n");
			if(check!=sum)
				{
				printf("OOPS!!, Checksum error in file, but continue anyway \n");
				}
			}
		while(flag=='0');
		fclose(Hex);

		teller=total;

		if ((total%4)==0)
			{
			printf("%d Words decoded\n",total/4);
			printf("last adress=%d\n",lastadress/4);
			}
		else
			{
			printf("Error, non-16bits words found in file %s\n",Filename);
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


void PatchHEX(void)	//PathchHEX patches the SX specific opcodes
	{
	int x;

	printf("\nSearching for SX opcode macro's....\n");

	for(x=0;x<lastadress;x=x+4)
		{

		if(	data[x]=='2' 		&&
				data[x+1]=='2' 	&&
				data[x+2]=='0'	&&
				data[x+3]=='4')
			{
			data[x]='4';
			data[x+1]='3';
			data[x+2]='0';
			data[x+3]='0';
			printf("Found 'mode' opcode macro.\n");
			}

		if(	data[x]=='4' 		&&
				data[x+1]=='2' 	&&
				data[x+2]=='0'	&&
				data[x+3]=='4')
			{
			data[x]='0';
			data[x+1]='c';
			data[x+2]='0';
			data[x+3]='0';
			printf("Found 'ret' opcode macro.\n");
			}

		if(	data[x]=='6' 		&&
				data[x+1]=='2' 	&&
				data[x+2]=='0'	&&
				data[x+3]=='4')
			{
			data[x]='0';
			data[x+1]='e';
			data[x+2]='0';
			data[x+3]='0';
			printf("Found 'reti' opcode macro.\n");
			}

		}

	printf("\n\n");
	}



int GoDec(char in)
	{
	int out;
	switch(toupper(in))
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

		default:
			out=0;
			break;

		}
	return(out);
	}

char GoHex(int in)
	{
	char out;


	if(in>15)
		in=15;
	if(in<0)
		in=0;

	switch(in)
		{
		case 0:
			out='0';
			break;
		case 1:
			out='1';
			break;
		case 2:
			out='2';
			break;
		case 3:
			out='3';
			break;
		case 4:
			out='4';
			break;
		case 5:
			out='5';
			break;
		case 6:
			out='6';
			break;
		case 7:
			out='7';
			break;
		case 8:
			out='8';
			break;
		case 9:
			out='9';
			break;
		case 10:
			out='a';
			break;
		case 11:
			out='b';
			break;
		case 12:
			out='c';
			break;
		case 13:
			out='d';
			break;
		case 14:
			out='e';
			break;
		case 15:
			out='f';
			break;

		default:
			out='0';
			break;
		}

	return out;
	}




