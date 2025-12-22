/* TMS320 Cross Assembler release 1.0 */

#include <libraries/dosextens.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* mnemonic table definition */

char	*mntable[]=	{
				"ABS", "ADD", "ADDH", "ADDS", "AND", "AORG","APAC",
				"B", "BANZ", "BGEZ", "BGZ", "BIOZ","BLEZ",
				"BLZ", "BNZ", "BV", "BZ", "CALA", "CALL", "DATA",
				"DINT", "DMOV", "EINT", "END", "EQU", "IN", "LAC",
				"LACK", "LAR", "LARK", "LARP", "LDP", "LDPK", "LST",
				"LT",  "LTA", "LTD", "MAR", "MPY", "MPYK",
				"NOP", "OR", "OUT", "PAC", "POP", "PUSH",
				"RET", "ROVM", "SACH", "SACL", "SAR", "SOVM",
				"SPAC", "SST", "SUB", "SUBC", "SUBH", "SUBS",
				"TBLR", "TBLW", "XOR", "ZAC", "ZALH", "ZALS"
			};

/* instruction type table definition */

unsigned char	tytable[]=	{
					0, 9, 5, 5, 5, 14, 0, 10, 10, 10, 10,
					10, 10, 10, 10, 10, 10, 0, 10, 11, 0, 5,
					0, 15, 13, 8, 9, 2, 6, 3, 1, 5, 1, 5,
					5, 5, 5, 5, 5, 4, 0, 5, 8, 0,
					0, 0, 0, 0, 7, 5, 6, 0, 0, 5,
					9, 5, 5, 5, 5, 5, 5, 0, 5, 5
				};

/* opcode table definition */

unsigned short	optable[]=	{
					0x7F88, 0x0000, 0x6000, 0x6100, 0x7900, 0, 0x7F8F,
					0xF900, 0xF400, 0xFD00, 0xFC00, 0xF600, 0xFB00,
					0xFA00, 0xFE00, 0xF500, 0xFF00, 0x7F8C, 0xF800, 0,
					0x7F81, 0x6900, 0x7F82, 0, 0, 0x4000, 0x2000, 0x7E00,
					0x3800, 0x7000, 0x6880, 0x6F00, 0x6E00, 0x7B00,
					0x6A00, 0x6C00, 0x6B00, 0x6800, 0x6D00, 0x8000,
					0x7F80, 0x7A00, 0x4800, 0x7F8E, 0x7F9D, 0x7F9C,
					0x7F8D, 0x7F8A, 0x5800, 0x5000, 0x3000, 0x7F8B,
					0x7F90, 0x7C00, 0x1000, 0x6400, 0x6200, 0x6300,
					0x6700, 0x7D00, 0x7800, 0x7F89, 0x6500, 0x6600
				};

/* Predefined labels definition */

char *pdlab[]= {
			"AR0", "AR1", "PA0", "PA1", "PA2", "PA3", "PA4", "PA5", "PA6", "PA7"
		};
		
unsigned long pdadd[]=	{
				0, 1, 0, 1, 2, 3, 4, 5, 6, 7
			};

/* opcode info structure definition */

struct	OpInfo	{
			unsigned char Type;
			unsigned short OpCode;
		};

/* label table structure definition */

struct	LabTab	{
			char Label[10];
			unsigned long Address;
		};

/* functions declaration */

void Copyright(void);
char *getword(char *);
void incpc(void);
long getnum(char *);
char *getop(char *);

/* constants declaration */

#define MAXBUF 128
#define LINEBUF 256
#define TABLEN 64
#define MAXLAB 256
#define PDLABS 10

/* variables declaration */

struct OpInfo *opinfo;
struct LabTab labtab[MAXLAB];
char filein[MAXBUF], fileout[MAXBUF], linebuf[LINEBUF], auxbuf[LINEBUF];
char *labptr[MAXLAB], *pointer;
unsigned short indx;
FILE *fi, *fo;
unsigned long PC;
long value;
int Ops;

main(argc, argv)

int argc;
char *argv[];

{

char c;
int i=1, j, lineno;
struct LabTab auxlab;
long word;
BOOL xref=FALSE, link=FALSE;

	Copyright();
	if(argc==1) {
badusage:	printf("Usage: %s [-xL] filename [filename]\n",argv[0]);
		puts("\tx: generates cross reference listing to stdout.");
		puts("\tL: calls L320 after assembly, linking to hex.");
		exit(1);
	}
	if(*argv[i]=='-') {
		for(j=0;j<strlen(argv[i]++);j++)
			switch(*argv[i]) {
				case 'L':
					link=TRUE;
					break;
				case 'x':
					xref=TRUE;
					break;
				default:
					goto badusage;
			}
		i++;
		argc--;
	}
	if(!(--argc))
		goto badusage;
	strcpy(filein,argv[i]);
	strcpy(fileout,filein);
	if(--argc)
		strcpy(fileout,argv[++i]);
	strcat(fileout,".obj");
	if(!(fi=fopen(filein,"r"))) {
		printf("Can't open file %s for input\n",filein);
		exit(1);
	}
	if(!(fo=fopen(fileout,"w"))) {
		printf("Can't open file %s for output\n",fileout);
		fclose(fi);
		exit(1);
	}
	
/* Predefined labels storage */
	
	for(indx=0;indx<PDLABS;indx++) {
		strcpy(labtab[indx].Label,pdlab[indx]);
		labtab[indx].Address=pdadd[indx];
	}

/* Start first pass */

	PC=0;
	lineno=0;
	while(fgets(linebuf,sizeof(linebuf),fi)) {
		pointer=linebuf;
		lineno++;
		auxbuf[0]=0;
		strtok(linebuf,";");		/* strip out comments */
		if(!(isseppp(linebuf[0]))) {		/* label found */
			strcpy(auxbuf,linebuf);
			for(i=0;(i<(LINEBUF-1))&&(!(issep(linebuf[i])));i++,pointer++);
			auxbuf[i]=0;
			if(!(i=stlabel(auxbuf))) {
				printf("*** LABEL ALREADY DEFINED *** at line %d :%s\nLabel: %s\n",lineno,linebuf,auxbuf);
				goto error;
			}
			if(i==-1) {
				printf("*** OUT OF SYMBOL SPACE *** at line %d :%s\nLabel: %s\n",lineno,linebuf,auxbuf);
				goto error;
			}
		}
		if(pointer=getword(pointer)) {
			if((i=findopc(pointer))==-1) {  /* not an opcode */
synterr:			printf("*** SYNTAX ERROR *** at line %d :%s\nUnknown mnemonic: %s\n",lineno,linebuf,pointer);
				goto error;
			}
			switch(opinfo->Type) { 
				case 14:		/* handle AORG directive */
					if(Ops!=1)
						goto synterr2;
					if(!(eval(pointer,NULL)))
						goto synterr2;
					PC=(unsigned long) value;
					break;
				case 13:		/* resolve EQU directive */
				        if(Ops!=1)
						goto synterr2;
				        if(!eval(pointer,NULL))
				        	printf("*** UNKNOWN LABEL *** at line %d :%s\nLabel: %s\n",lineno,linebuf,pointer);
				        labtab[indx-1].Address=value;
				        break;
				case 11:		/* handle multioperand DATA directive */
					if(!Ops)
						goto synterr2;
					PC+=Ops;	/* increment PC */
					break;
			}
			incpc();
		}
	}
	if(xref) {
		puts("\nCross Reference Listing:");
		puts("-----------------------\n");
		for(i=0;i<indx;i++)
			printf("\tLabel: %s, address: 0x%04X\n",labtab[i].Label,labtab[i].Address);
		puts("");	
        }
        
/* Start second pass */

	rewind(fi);
	PC=0;
	lineno=0;
	while(fgets(linebuf,sizeof(linebuf),fi)) {
		pointer=linebuf;
		lineno++;
		strtok(linebuf,";");			/* strip out comments */
		if(!(isseppp(linebuf[0])))		/* skip labels */
			for(i=0;(i<(LINEBUF-1))&&(!(issep(linebuf[i])));i++,pointer++);
		if(pointer=getword(pointer)) {
			if((i=findopc(pointer))==-1) {  /* not an opcode */
				goto synterr;
			}
			switch(opinfo->Type) {
				
				case 14: 
					if(Ops!=1)
						goto synterr2;
					if(!(eval(pointer,NULL))) {
synterr2:					printf("*** SYNTAX ERROR *** at line %d :%s\nBad operand: %s\n",lineno,linebuf,pointer);
						goto error;
					}
					PC=(unsigned long) value;
					break;
				case 0:
					if(Ops)
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode);
					break;
				case 1:
					if(Ops!=1)
						goto synterr2;
					if(!eval(pointer,NULL))
						goto synterr2;
					if((value>1)||(value<0))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|value);
					break;
				case 2:
					if(Ops!=1)
						goto synterr2;
					if(!eval(pointer,NULL))
						goto synterr2;
					if((value>255)||(value<-127))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|value);
					break;
				case 3:
					if(Ops!=2)
						goto synterr2;
					if(!evalops(pointer,NULL))	/* 1st operand */
						goto synterr2;
					if((value>1)||(value<0))
						goto synterr2;
					word=opinfo->OpCode|(value<<8);
					if(!evalops(NULL,NULL))	/* 2nd operand */
						goto synterr2;
					if((value>255)||(value<-127))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC,word|value);
					break;
				case 4:
					if(Ops!=1)
						goto synterr2;
					if(!eval(pointer,NULL))
						goto synterr2;
					if((value>8191)||(value<-4095))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|value);
					break;
				case 5: 
					if((!Ops)||(Ops>2))
						goto synterr2;
					if((i=evalops(pointer,TRUE))==-1) {	/* get first operand and */
						word=value;			/* check for indirect addressing */
						if(Ops==2) {		/* check for new AR */
							if(!evalops(NULL,NULL)) 
								goto synterr2;
							if((value>1)||(value<0))
								goto synterr2;
							word=word&0xfff7|value;
						}
					}
					else {				/* first operand is direct addressing */
						if (Ops!=1) 
							goto synterr2;
						if(!i) 
							goto synterr2;
						if((value>127)||(value<0))
							goto synterr2;
						word=value;
					}
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|word);
					break;
				case 6:
					if((Ops<2)||(Ops>3))
						goto synterr2;
					if(!evalops(pointer,NULL))
						goto synterr2;
					if((value>1)||(value<0))
						goto synterr2;
					word=value<<8;
					if((i=evalops(NULL,TRUE))==-1) {
						word=word|value;
						if(Ops==3) {
							if(!evalops(NULL,NULL)) 
								goto synterr2;
							if((value>1)||(value<0))
								goto synterr2;
							word=word&0xfff7|value;
						}
					}
					else {
						if (Ops!=2)
							goto synterr2;
						if(!i)
							goto synterr2;
						if((value>127)||(value<0))
							goto synterr2;
						word=word|value;
					}
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|word);
					break;
				case 7:
					if((!Ops)||(Ops>3))
						goto synterr2;
					if((i=evalops(pointer,TRUE))==-1) {
						word=value;
						if(Ops>1) {
							if(!evalops(NULL,NULL)) 
								goto synterr2;
							if((value)&&(value!=1)&&(value!=4))
								goto synterr2;
							word=word|(value<<8);
							if(Ops==3) {
								if(!evalops(NULL,NULL)) 
									goto synterr2;
								if((value>1)||(value<0))
									goto synterr2;
								word=word&0xfff7|value;
							}
						}
					}
					else {
						if (Ops!=2)
							goto synterr2;
						if(!i)
							goto synterr2;
						if((value>127)||(value<0))
							goto synterr2;
						word=value;
						if(!evalops(NULL,NULL)) 
							goto synterr2;
						if((value)&&(value!=1)&&(value!=4))
							goto synterr2;
						word=word|(value<<8);
					}
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|word);
					break;
				case 8:
					if((!Ops)||(Ops>3))
						goto synterr2;
					if((i=evalops(pointer,TRUE))==-1) {
						word=value;
						if(Ops>1) {
							if(!evalops(NULL,NULL)) 
								goto synterr2;
							if((value<0)||(value>7))
								goto synterr2;
							word=word|(value<<8);
							if(Ops==3) {
								if(!evalops(NULL,NULL)) 
									goto synterr2;
								if((value>1)||(value<0))
									goto synterr2;
								word=word&0xfff7|value;
							}
						}
					}
					else {
						if (Ops!=2)
							goto synterr2;
						if(!i)
							goto synterr2;
						if((value>127)||(value<0))
							goto synterr2;
						word=value;
						if(!evalops(NULL,NULL)) 
							goto synterr2;
						if((value<0)||(value>7))
							goto synterr2;
						word=word|(value<<8);
					}
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|word);
					break;
				case 9:
					if((!Ops)||(Ops>3))
						goto synterr2;
					if((i=evalops(pointer,TRUE))==-1) {
						word=value;
						if(Ops>1) {
							if(!evalops(NULL,NULL)) 
								goto synterr2;
							if((value<0)||(value>15))
								goto synterr2;
							word=word|(value<<8);
							if(Ops==3) {
								if(!evalops(NULL,NULL)) 
									goto synterr2;
								if((value>1)||(value<0))
									goto synterr2;
								word=word&0xfff7|value;
							}
						}
					}
					else {
						if (Ops!=2)
							goto synterr2;
						if(!i)
							goto synterr2;
						if((value>127)||(value<0))
							goto synterr2;
						word=value;
						if(!evalops(NULL,NULL)) 
							goto synterr2;
						if((value<0)||(value>15))
							goto synterr2;
						word=word|(value<<8);
					}
					fprintf(fo,"%04X\n%04X\n",PC,opinfo->OpCode|word);
					break;
				case 10:
					if(Ops!=1)
						goto synterr2;
					if(!eval(pointer,NULL))
						goto synterr2;
					if((value>4095)||(value<0))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n%04X\n%04X\n",PC,opinfo->OpCode,PC+1,value);
					break;
				case 11:
					if(!Ops)
						goto synterr2;
					if(!evalops(pointer,NULL))
						goto synterr2;
					if((value>65535)||(value<-32767))
						goto synterr2;
					fprintf(fo,"%04X\n%04X\n",PC++,value);
					while (--Ops) {				/* handle multiple operands */
						if(!evalops(NULL,NULL))
							goto synterr2;
						if((value>65535)||(value<-32767))
							goto synterr2;
						fprintf(fo,"%04X\n%04X\n",PC++,value);
					}
					break;
				case 13:
					break;
				case 15:
					goto end;
					break;
				default:
					puts("*** Oh, Oh, the soft is dead...");
					goto error;
			}
			incpc();
		}
	}
end:	fclose(fi);
	fclose(fo);
	if(link) {		
		sprintf(linebuf,"L320 %s\n",fileout);
		Execute(linebuf,0,0);
	}
	exit(0);
error:	fclose(fi);
	fclose(fo);
	exit(1);
}

void Copyright(void)
{
	puts("TMS32010 Cross Assembler (C)1994 by SRC");
}

issep(char c)
{
	return((c==' ')||(c=='\t'));
}

issepp(char c)
{
	return((c==' ')||(c=='\t')||(c==';'));
}

isseppp(char c)
{
	return((c==' ')||(c=='\t')||(c==';')||(c=='\n'));
}

char *getword(char *ptr)	/* get a word from a line */
{
char word[LINEBUF];
int i;
	for(;(*ptr!=0)&&(issep(*ptr));ptr++);		/* skip leading blanks */
	if((*ptr==0)||(isseppp(*ptr)))			/* handle EOL */
		return(0);
	strcpy(word,ptr);				/* get word */
	for(i=0;(*ptr!=0)&&(!(isseppp(*ptr)));i++,ptr++); /* find lenght */
	word[i]=0;
	return(word);
}

findword(word, tab, n)		/* find a word in an array, tab is an array */
				/* of vectors pointing to each entry in the table */
char *word, *tab[];		/* the array is sorted lower to higher */
int n;
{
int low,high,mid,cond;		/* (C) Kernighan & Ritchie */

	low=0;
	high=n-1;
	while(low<=high) {
		mid=(low+high)/2;
		if((cond=strcmp(word,tab[mid]))<0)
			high=mid-1;
		else if(cond>0)
			low=mid+1;
		else return(mid);
	}
	return(-1);
}

findopc(char *word)		/* find an opcode in the opcode table */
{
int pos=0;
char *opc;
	opc=strdup(word);
	if(!(isupper(opc[0])))			/* if lower case, get upper */
		for(pos=0;pos<strlen(opc);pos++) 
			opc[pos]=toupper(opc[pos]);                            
	if((pos=findword(opc,mntable,TABLEN))==-1)	/* search... */
		return(-1);
	opinfo->Type=tytable[pos];	/* if found, fill structure */
	opinfo->OpCode=optable[pos];
	pointer=getop(word);		/* advance pointer to point to ops */
	Ops=getopinf(pointer);
	return(pos);
}

void incpc(void)		/* increment PC according to instruction */
{
	if(opinfo->Type<11)	/* standard opcode */
		PC++;
	if(opinfo->Type==10)	/* Two word instruction */
		PC++;		
}

long getnum(char *ptr)
{
int base=0;			/* support C notation */
long add;
char **eptr;

	if(ptr[0]=='>') {	/* support Texas hex notation */
		base=16;
		ptr++;
	}
	add=strtol(ptr,eptr,base);
	if(*eptr==ptr)		/* syntax error (labels not supported) */
		return(-1);
	return(add);
}
	
char *getop(char *inst)
{
char *ptr;

	strcpy(auxbuf,linebuf);
	ptr=strstr(auxbuf,inst);		/* point to instruction */ 
	ptr+=(strlen(inst)+1);			/* point to operands */
	ptr[strlen(ptr)-1]=0;
	return(ptr);
}
	
stlabel(char *label)			/* store label in label table */
{
	if(findlabel(label)!=-1)	/* check if already defined */
		return(0);
	if(indx==MAXLAB)  		/* check for room */
		return(-1);
	strcpy(labtab[indx].Label,label);
	labtab[indx++].Address=PC;
	return(1);
}

findlabel(char *label)
{
int i;
	for(i=0;i<indx;i++)
		if(!strcmp(labtab[i].Label,label))	/* label found */
			return(i);
	return(-1);
}

eval (char *ptr,BOOL type)
{
int i=0;
	ptr=getword(ptr);
	if((strlen(ptr)==1)&&(*ptr=='$')) {	/* allow "?" label */
		value=PC;
		return(1);
	}
	if (type &&((*ptr)=='*')) {				/* handle indirect addressing */
		i=strlen(ptr++);
		if(i==1) {
			value=0x88;
			return(-1);
		}
		if(i==2) {
			if(*ptr=='+') {	/* handle postincrement */
				value=0xa8;
				return(-1);
			}
			else if(*ptr=='-') {	/* handle postdecrement */
				value=0x98;
				return(-1);
			}
			else	return(0);
		}
	}
	if((value=findlabel(ptr))!=-1) {	/* is it a label ? */
		value=labtab[value].Address;
		return(1);
	}
	if((value=getnum(ptr))!=-1) 	/* evaluate operand */
		return(1);
	return(0);
}

evalops(char *ptr,BOOL type)
{
	if(ptr) 
		strtok(ptr,",");		/* get first operand */
	else 
		pointer=strtok(NULL,",");			/* get next operand */
	return(eval(pointer,type));
}

getopinf(char *ptr)
{
int n=1;
	for(;(*ptr!=0)&&(issep(*ptr));ptr++);	/* skip blanks */
	if(!strlen(ptr))
		return(0);
	for(;*ptr!=0;ptr++)
		if(*ptr==',')
			n++;
	return(n);
}