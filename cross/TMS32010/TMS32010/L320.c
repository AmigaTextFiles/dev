/* TMS320 Intel hex linker release 1.0 */

#include <libraries/dosextens.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void Copyright(void);

/* constants declaration */

#define MAXBUF 128
#define MAXINBUF 6
#define MAXOUTBUF 128

/* variables declaration */

char filein[MAXBUF], filelow[MAXBUF], filehigh[MAXBUF], addbuf[MAXINBUF];
char databuf[MAXINBUF], lowbuf[MAXOUTBUF], highbuf[MAXOUTBUF], count[2];
char *pointer, *low, *high, auxbuf[10];
FILE *fi, *fl, *fh;
unsigned long PC;

main(argc, argv)

int argc;
char *argv[];

{

int i=1, lcheck, hcheck;
BOOL start=TRUE;
long data;

	Copyright();
	if(argc==1) {
badusage:	printf("Usage: %s filename [filename]\n",argv[0]);
		exit(1);
	}

/* insert options handling here */

	if(!(--argc))
		goto badusage;
	strcpy(filein,argv[i]);
	strcpy(filelow,filein);
	strtok(filelow,".obj");
	strcpy(filehigh,filelow);
	if(--argc)
		strcpy(filelow,argv[++i]);
	strcpy(filehigh,filelow);
	strcat(filelow,".low");
        strcat(filehigh,".high");
        if(!strstr(filein,".obj"))
        	strcat(filein,".obj");
	if(!(fi=fopen(filein,"r"))) {
		printf("Can't open file %s for input\n",filein);
		exit(1);
	}
	if(!(fl=fopen(filelow,"w"))) {
		printf("Can't open file %s for output\n",filelow);
		fclose(fi);
		exit(1);
	}
	if(!(fh=fopen(filehigh,"w"))) {
		printf("Can't open file %s for output\n",filehigh);
		fclose(fi);
		fclose(fl);
		exit(1);
	}
	
	i=0;
	
	while(1) {
		if(!fgets(addbuf,sizeof(addbuf),fi)) 
			break;
		if(!fgets(databuf,sizeof(databuf),fi))
			goto error;
restart:	pointer=databuf;
		data=strtol(addbuf,NULL,16);
		if(start) {
			PC=data;
			hcheck=lcheck=PC/256+PC%256;
			sprintf(lowbuf,":10%04X00",PC);
			strcpy(highbuf,lowbuf);
			low=lowbuf+9;
			high=highbuf+9;
			start=FALSE;
		}
		else if((PC!=data)||(i==16)) {
			lcheck+=i;
	        	hcheck+=i;
        		sprintf(count,"%02X",i);
        		lowbuf[1]=highbuf[1]=count[0];
	        	lowbuf[2]=highbuf[2]=count[1];
        		pointer=auxbuf;
        		sprintf(pointer,"%08X\n\0",-hcheck);
	        	sprintf(high,pointer+6);
        		sprintf(pointer,"%08X\n\0",-lcheck);
        		sprintf(low,pointer+6);
	        	i=lcheck=hcheck=0;
	        	start=TRUE;
        		if((fputs(lowbuf,fl)==-1)||(fputs(highbuf,fh)==-1))
        			goto error;
        		goto restart;
        	}
		data=strtol(databuf,NULL,16);
		hcheck+=data/256;
		lcheck+=data%256;
		*high++=*pointer++;
		*high++=*pointer++;
		*low++=*pointer++;
		*low++=*pointer++;
		i++;
		PC++;
	}
	fputs(":00000001FF\n",fl);
	fputs(":00000001FF\n",fh);
error:	fclose(fi);
	fclose(fl);
	fclose(fh);
}

void Copyright(void)
{
	puts("TMS32010 Intel Hex linker (C)1994 by SRC");
}