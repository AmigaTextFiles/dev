#include <stdio.h>
#include <stdlib.h>

unsigned char image[65536];
typedef struct
{
	unsigned char name[256];
	unsigned short	offs;
	unsigned int	sourceline;
} label_struct;
label_struct labels[65536];
unsigned short labelnum=0;

typedef struct 
{
	unsigned char name[4];
	unsigned char	hex[13];
	unsigned char	jump;
} opcode_struct;
#define ADDR_ACCU	0
#define	ADDR_IMPL	1
#define	ADDR_IMME	2
#define	ADDR_INDI	3
#define	ADDR_ABSO	4
#define	ADDR_ABSX	5
#define	ADDR_ABSY	6
#define	ADDR_INDX	7
#define	ADDR_INDY	8
#define	ADDR_ZP		9
#define	ADDR_ZPX	10
#define	ADDR_ZPY	11
#define	ADDR_RELA	12

const char opcodelen[]={1,1,2,3,3,3,3,2,2,2,2,2,2};
const opcode_struct opcodes[]=
{
	//name	accu,impl,imme,indi,abso,absX,absY,indX,indY,zp  ,zp x,zp y,rela,jump
	"ADC",	  -1,  -1,0x69,  -1,0x6d,0x7d,0x79,0x61,0x71,0x65,0x75,  -1,  -1,0,
	"AND",	  -1,  -1,0x29,  -1,0x2d,0x3d,0x39,0x21,0x31,0x25,0x35,  -1,  -1,0,
	"ASL",	0x0a,  -1,  -1,  -1,0x0e,0x1e,0x00,  -1,  -1,0x06,0x16,  -1,  -1,0,
	"BIT",	  -1,  -1,  -1,  -1,0x2c,  -1,  -1,  -1,  -1,0x24,  -1,  -1,  -1,0,
	"BPL",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0x10,1,
	"BMI",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0x30,1,
	"BVC",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0x50,1,
	"BVS",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0x70,1,
	"BCC",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0x90,1,
	"BCS",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0xb0,1,
	"BNE",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0xd0,1,
	"BEQ",	  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0xf0,1,
	"BRK",	  -1,0x00,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,1,
	"CMP",	  -1,  -1,0xc9,  -1,0xcd,0xdd,0xd9,0xc1,0xd1,0xc5,0xd5,  -1,  -1,0,
	"CPX",	  -1,  -1,0xe0,  -1,0xec,  -1,  -1,  -1,  -1,0xe4,  -1,  -1,  -1,0,
	"CPY",	  -1,  -1,0xc0,  -1,0xcc,  -1,  -1,  -1,  -1,0xc4,  -1,  -1,  -1,0,
	"DEC",	  -1,  -1,  -1,  -1,0xde,0xce,  -1,  -1,  -1,0xc6,0xd6,  -1,  -1,0,
	"EOR",	  -1,  -1,0x49,  -1,0x4d,0x5d,0x59,0x41,0x51,0x45,0x55,  -1,  -1,0,
	"CLC",	  -1,0x18,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"SEC",	  -1,0x38,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"CLI",	  -1,0x58,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"SEI",	  -1,0x78,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"CLV",	  -1,0xb8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"CLD",	  -1,0xd8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"SEC",	  -1,0xf8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"INC",	  -1,  -1,  -1,  -1,0xee,0xfe,  -1,  -1,  -1,0xe6,0xf6,  -1,  -1,0,
	"JMP",	  -1,  -1,  -1,0x6c,0x4c,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,1,
	"JSR",	  -1,  -1,  -1,  -1,0x20,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,1,
	"LDA",	  -1,  -1,0xa9,  -1,0xad,0xbd,0xb9,0xa1,0xb1,0xa5,0xb5,  -1,  -1,0,
	"LDX",	  -1,  -1,0xa2,  -1,0xae,  -1,0xbe,  -1,  -1,0xa6,  -1,0xb6,  -1,0,
	"LDY",	  -1,  -1,0xa0,  -1,0xac,0xbc,  -1,  -1,  -1,0xa4,0xb4,  -1,  -1,0,
	"LSR",	0x4a,  -1,  -1,  -1,0x4e,0x5e,  -1,  -1,  -1,0x46,0x56,  -1,  -1,0,
	"NOP",	  -1,0xea,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"ORA",	  -1,  -1,0x09,  -1,0x0d,0x1d,0x19,0x01,0x11,0x05,0x15,  -1,  -1,0,
	"TAX",	  -1,0xaa,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"TXA",	  -1,0xba,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"DEX",	  -1,0xca,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"INX",	  -1,0xe8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"TAY",	  -1,0xa8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"TYA",	  -1,0x98,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"DEY",	  -1,0x88,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"INY",	  -1,0xc8,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"ROL",	0x2a,  -1,  -1,  -1,0x2e,0x3e,  -1,  -1,  -1,0x26,0x36,  -1,  -1,0,
	"ROR",	0x6a,  -1,  -1,  -1,0x6e,0x7e,  -1,  -1,  -1,0x66,0x76,  -1,  -1,0,
	"RTI",	  -1,0x40,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"RTS",	  -1,0x60,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"SBC",	  -1,  -1,0xe9,  -1,0xed,0xfd,0xf9,0xe1,0xf1,0xe5,0xf5,  -1,  -1,0,
	"STA",	  -1,  -1,  -1,  -1,0x8d,0x9d,0x99,0x81,0x91,0x85,0x95,  -1,  -1,0,
	"TXS",	  -1,0x9a,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"TSX",	  -1,0xba,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"PHA",	  -1,0x48,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"PLA",	  -1,0x68,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"PHP",	  -1,0x08,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"PLP",	  -1,0x28,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,0,
	"STX",	  -1,  -1,  -1,  -1,0x8e,  -1,  -1,  -1,  -1,0x86,  -1,0x96,  -1,0,
	"STY",	  -1,  -1,  -1,  -1,0x8c,  -1,  -1,  -1,  -1,0x84,0x94,  -1,  -1,0
};
#define	OPCODENUM	56
#define	ADDRMODES	13
void getminline(unsigned char* line,unsigned char* minline,unsigned int linenum)
{
	int i;
	int j=0;
	int l;
	int quote=0;
	unsigned char c=0;
	unsigned char lc=32;
	unsigned char lc2=32;

	l=strlen(line);
	for (i=0;i<l;i++)
	{
		c=line[i];
		if (c==10) 
		{
			i=l;
			c=0;
		} else if (c=='"' && lc!='\\') 
		{
			quote=1-quote;
		}
		else 
		{
			if (!quote) {
				if (c==9) c=32;
				if (lc==32 && c==32) c=0;
				if ((c==';') || (c=='/')) {i=l;c=0;}
				if (c>='a' && c<='z') c^=0x20;
			} else {
				
			}
		}
		if (c!=0)
		{
			minline[j++]=c;
			if (lc=='\\' && c=='\\') lc=0; else lc=c;
		}
		if (!quote && c=='.') lc=32;
	}
	if (j!=0)
	{
		if (minline[j-1]==32) j--;
	}
	minline[j]=0;
	if (quote) 
	{
		printf("[\"] expected in line %i\n",linenum);
		exit(0);
	}
}
int findoperand(unsigned char* minline,unsigned int linenum)
{
	int i;
	int j=-1;
	int l=strlen(minline);
	if (l<3) return -1;
	if (minline[0]=='.') return OPCODENUM;
	if (minline[3]!=' ' && l!=3) 	
	{
		printf("unknwon opcode in line %i\n",linenum);
		exit(0);
	}
	for (i=0;(i<OPCODENUM) && (j==-1);i++)	
	{
		if (strncmp(opcodes[i].name,minline,3)==0) j=i;	
	}
	if (j==-1)
	{
		printf("unknwon opcode in line %i\n",linenum);
		exit(0);
	}
	return j;
}
int numlen(unsigned char* minline,int linenum)
{
	int i;
	int base=10;
	int num=0;
	int l=strlen(minline);
	unsigned char c;
	int x=0;
	int len=0;
	

	for (i=0;i<l;i++)
	{
		c=minline[i];
		if (c=='%') base=2;
		else if (c=='$') base=16;
		else if (c=='0' && minline[i+1]=='X') {base=16;i++;}
		else if (c==')') break;
		else if (c==',') break;
		else if (c==' ') break;
		else if (c=='_' && minline[i+1]=='H' && minline[i+2]=='I') return 8;
		else if (c=='_' && minline[i+1]=='L' && minline[i+2]=='O') return 8;
		else {
			if (base==2) 
			{
				if (c!='0' && c!='1') return 16;
				len++;
				x=x*base+(c-48);
			} else if (base==10) {
				if (c<'0' || c>'9') return 16;
				len++;
				x=x*base+(c-48);
			} else if (base==16) {
				if (c>='0' && c<='9')
				{
					len++;
					x=x*base+(c-48);
				} else if (c>='A' && c<='F')
				{
					len++;
					x=x*base+(c-65);
				} else return 16;
			}
		}
	}
	if (len<=8 && base==2) return 8;
	if (len<=2 && base==16) return 8;
	if (x<=0xff) return 8;

	if (x<=0xffff) return 16;
	if (x>0xffff) printf("warning: value in line %i is bigger than 16 bit\n",linenum);
	return 16;	
		
}
int findaddrmode(unsigned char* minline,unsigned int linenum,int opcode)
{
	int i;
	int l=strlen(minline);
	int parent0=-1;
	int parent1=-1;
	int hash=-1;
	int komma=-1;
	int dollar=-1;
	char mode;
	int len=0;
	int space=0;
	unsigned char	*modename[]={"accu","implied","immediate","indirect","absolute","absolute,x","absolute,y","indirect,x","indirect,y","zeropage","zeropage,x","zeropage,y","relative"};

	for (i=0;i<l;i++)
	{
		if (minline[i]=='(') parent0=i;
		if (minline[i]==')') parent1=i;
		if (minline[i]==',') komma=i;
		if (minline[i]=='#') hash=i;
		if (minline[i]=='$' || minline[i]=='%') dollar=i;
		if (minline[i]=='0' && minline[i+1]=='X') dollar=i;
		if (minline[i]==' ') space=i;
	}

	if (dollar!=-1) len=numlen(&minline[dollar],linenum);
	else if (hash!=-1) len=numlen(&minline[hash+1],linenum);
	else if (parent0!=-1) len=numlen(&minline[parent0+1],linenum);
	else len=numlen(&minline[space+1],linenum);

	if (opcodes[opcode].hex[12]!=0xff) mode=ADDR_RELA;
	else if (l==5 && minline[4]=='A') mode=ADDR_ACCU;	// accumulator 0
	else if (l==3) mode=ADDR_IMPL;	// implied 1
	else if (hash!=-1) mode=ADDR_IMME;	// immediate 2
	else if (parent0!=-1 && komma==-1) mode=ADDR_INDI;	// indirect 3
	else if (parent0==-1 && len==16) mode=ADDR_ABSO;	// absolute 4
	else if (parent0==-1 && len==16 && komma!=-1 && minline[komma+1]=='X') 	mode=ADDR_ABSX;	// absolut 5
	else if (parent0==-1 && len==16 && komma!=-1 && minline[komma+1]=='Y') 	mode=ADDR_ABSY;	// absolut 6
	else if (parent0!=-1 && parent1>komma && minline[komma+1]=='X') mode=ADDR_INDX; // indirect,x 7
	else if (parent0!=-1 && parent1<komma && minline[komma+1]=='Y') mode=ADDR_INDY;	// indirect,y 8
	else if (parent0==-1 && komma==-1 && len==8) mode=ADDR_ZP;	// zeropage 9
	else if (parent0==-1 && komma!=-1 && minline[komma+1]=='X' && len==8)	mode=ADDR_ZPX;	// zeropage,x 10
	else if (parent0==-1 && komma!=-1 && minline[komma+1]=='Y' && len==8)	mode=ADDR_ZPX;	// zeropage,x 11
	else mode=ADDR_RELA;	// relative 12

	if (opcodes[opcode].hex[mode]==0xff) 
	{
		printf("illegal addressing mode %s in line %i\n",modename[mode],linenum);
		exit(0);
	}
	return mode;	
	
}
int islabel(unsigned char* minline,unsigned int linenum,unsigned short addr,unsigned char new)
{
	int i;
	int j=-1;
	int l=strlen(minline);

	if (minline[0]=='.') return 0;

	for (i=0;(i<l) && (j==-1);i++)
	{
		if (minline[i]==':') j=i;
	}
	if (j==-1) return 0;
	if (j>255) j=255;	

	if (new)
	{	
		strncpy(labels[labelnum].name,minline,j);
		labels[labelnum].name[j]=0;
		labels[labelnum].offs=addr;
		labels[labelnum].sourceline=linenum;
		
		l=strlen(labels[labelnum].name);
		if (l>=3) 
		{
			if ((labels[labelnum].name[l-1]=='O' && labels[labelnum].name[l-2]=='L' && labels[labelnum].name[l-3]=='_') || (labels[labelnum].name[l-1]=='I' && labels[labelnum].name[l-2]=='H' && labels[labelnum].name[l-3]=='_'))
			{
				printf("I am terribly sorry, but you can not use a label that ends with _LO or _HI.\n");
				printf("Come up with something different than [%s] in line:%i\n",labels[labelnum].name,linenum);
				exit(0);
			}
		}
		for (i=0;i<labelnum;i++)
		{
			if (strncmp(labels[i].name,labels[labelnum].name,256)==0) 
			{
				printf("Predefined label [%s] in line %i. It has been defined as [%s] in line %i.\n",labels[labelnum].name,linenum,labels[i].name,labels[i].sourceline);
				exit(0);

			}
		}
		labelnum++;
	}
	return 1;	
}
int datalen(unsigned char* minline,int linenum)
{
	int i;
	int l=strlen(minline);
	int quote=0;
	unsigned char c;
	unsigned char lc=0;
	int len=0;

	for (i=1;i<l;i++)
	{
		c=minline[i];
		if (i==0 && c!='"') {len++;}
		if (c=='"' && lc!='\\') 
		{
			quote=1-quote;
		} else {
			if (quote) {
				if (c!='\\') len++;
				if (lc=='\\') {
					len++;
					c=0;
				}
			} else {
				if (c==',') len++;
			}
		}
		lc=c;
	}
	return len;
}
int getnum(unsigned char *line)
{
	unsigned int x=0;
	unsigned int base=10;
	int i;
	int j=0;
	unsigned char c;

	if (line[0]=='%') {base= 2;j=1;}
	if (line[0]=='$') {base=16;j=1;}
	if (line[0]=='0' && (line[1]=='x' || line[1]=='X')) {base=16;j=2;}

	for (i=j;i<strlen(line);i++)
	{
		c=line[i];
		if (base==2 && c!=0 && c!=1) return -1;
		if (base==10 && (c<'0' || c>'9')) return -1;
		if (base==16 && !((c>='0' && c<='9') || (c>='A' && c<='F') || (c>='a' && c<='f'))) return -1;

		if (c>='0' && c<='9') c=c-'0';
		else if (c>='a' && c<='f') c=c-'a'+10;
		else if (c>='A' && c<='F') c=c-'A'+10;
		x=x*base+c;
	}

	return x;	
	
}
int getvalue(unsigned char *minline,int linenum,int addr,int opcode,int addrmode)
{
	int val;
	
	unsigned char name[1024];
	unsigned int l=strlen(minline);
	int i;
	int j=0;
	int getit=0;
	unsigned char c;
	unsigned short mask=0xffff;
	unsigned char shift=0;
	int start;
	
	if (addrmode==-1) start=0; else start=4;
	name[0]=0;
	for (i=start;i<l;i++)
	{
		c=minline[i];
		if (c==',' || c==')') break;
		else if (c!='#' && c!='(') {name[j++]=c;name[j]=0;}
	}
	val=getnum(&name[0]);
	if (opcode!=-1) if (val!=-1 && opcodes[opcode].jump) printf("warning! line %i: jump to a fixed address.\n",linenum);
	if (val==-1)
	{
		l=strlen(name);
		if (l>3)
		{
			if (name[l-3]=='_' && name[l-2]=='H' && name[l-1]=='I') {mask=0xff;shift=8;name[l-3]=0;}	
			if (name[l-3]=='_' && name[l-2]=='L' && name[l-1]=='O') {mask=0xff;shift=0;name[l-3]=0;}
		}
		for (i=0;i<labelnum;i++)
		{
			if (strncmp(name,labels[i].name,256)==0) val=labels[i].offs;
		}
		if (val==-1)
		{
			printf("unknown label %s in line %i\n",name,linenum);
			exit(0);
		}
		if (addrmode==12)
		{
			if (addr<val) val=val-addr-1; else val=addr-val;
			if (val>=128 || val<=-127) 
			{
				printf("i can't jump to %s from line %i. There are %i bytes inbetween.\n",name,linenum,val);
				exit(0);
			}
			if (val<0) val+=256;
		}
		val=(val>>shift)&mask;
	}
	return val;
}
int main(int argc,char** argv)
{
	int i;
	int j;
	int k;
	int addr=0;
	FILE *f;
	unsigned char line[1024];
	unsigned char minline[1024];
	unsigned int linenum=1;
	int outputformat=2;
	const unsigned char *formats[3]={"hex","rom","ram"};
	int offs=0x200;
	unsigned char filename[1024];
	unsigned char c;
	unsigned char lc;
	unsigned char quote=0;

	strncpy(filename,"6502.img",9);

	printf("*** 6502asm Version 0.10\n");
	printf("*** Thomas Dettbarn, 2007\n");
	printf("*** http://www.dettus.net/6502\n");
	printf("******************************\n\n");
	if (argc<2)
	{
		printf("%s [-F fmt] [-O image.bin] [-A offsetaddr] filename.asm\n",argv[0]);
		exit(0);
	}
	for (i=1;i<argc;i++)
	{
		if ((strncmp(argv[i],"--help",6)==0) || (strncmp(argv[i],"-?",2)==0)) 
		{
			printf("%s [-F fmt] [-O image.bin] [-A offsetaddr] filename.asm\n",argv[0]);
			printf("  -F fmt: output format: hex,rom,ram (default)\n");
			printf("  -O: output file (default: 6502.img)\n");
			printf("  -A: offsetaddr. (default: 0x200). Can be negative to define the last addr.\n\n");
			printf("Examples:\n");
			printf("   %s -F rom -O bootloader.bin -A -0xffff bootloader.asm\n",argv[0]);  
			printf("   %s -F hex -O output.txt -A 0x0000 adder.asm\n",argv[0]);
			printf("   %s -F ram -O mygame.img -A 0x0200 mygame.asm\n",argv[0]);
			printf("   %s --license or %s --bsd\n",argv[0],argv[0]);
			printf("\n\n");
			printf("   rom-files are 64kbyte big. Unused memory is padded with 0.\n");
			printf("   ram-files are not. They contain only \"interesting\" data.\n");
			exit(1);	
		}
		if ((strncmp(argv[i],"--license",9)==0) || (strncmp(argv[i],"--bsd",5)==0))
		{
			printf("* Copyright (c) 2007, Thomas Dettbarn\n");
			printf("* All rights reserved.\n");
			printf("*\n");
			printf("* Redistribution and use in source and binary forms, with or without\n");
			printf("* modification, are permitted provided that the following conditions are met:\n");
			printf("*     * Redistributions of source code must retain the above copyright\n");
			printf("*       notice, this list of conditions and the following disclaimer.\n");
			printf("*     * Redistributions in binary form must reproduce the above copyright\n");
			printf("*       notice, this list of conditions and the following disclaimer in the\n");
			printf("*       documentation and/or other materials provided with the distribution.\n");
			printf("*     * Neither the name of Dettus nor the\n");
			printf("*       names of its contributors may be used to endorse or promote products\n");
			printf("*       derived from this software without specific prior written permission.\n");
			printf("*\n");
			printf("* THIS SOFTWARE IS PROVIDED BY DETTUS ``AS IS'' AND ANY\n");
			printf("* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED\n");
			printf("* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\n");
			printf("* DISCLAIMED. IN NO EVENT SHALL DETTUS BE LIABLE FOR ANY\n");
			printf("* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES\n");
			printf("* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;\n");
			printf("* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND\n");
			printf("* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n");
			printf("* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\n");
			printf("* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n");
			exit(1);
		}
		if (strncmp(argv[i],"-F",2)==0)
		{
			i++;
			if (argc>i) 
			{
				if (strncmp(argv[i],"hex",3)==0) outputformat=0;
				else if (strncmp(argv[i],"rom",3)==0) outputformat=1;
				else if (strncmp(argv[i],"ram",3)==0) outputformat=2;
				else 
				{
					printf("-F hex,rom,ram. not %s\n",argv[i]);
					exit(0);
				}
			} else {
				printf("-F hex,rom,ram.\n");
				exit(0);
			}
		} else if (strncmp(argv[i],"-A",2)==0)
		{
			i++;
			if (argc>i)
			{
				if (argv[i][0]=='-') 
				{
					j=getnum(&argv[i][1]);
					offs=-j;
				} else {
					j=getnum(&argv[i][0]);
					offs=j;
				}
				if (j==-1)
				{
					printf("-A offsetaddr or -A -lastaddr. Not %s\n",argv[i]);
				}
			} else {
				printf("-A offsetaddr.\n");
				exit(0);
			}
		} else if (strncmp(argv[i],"-O",2)==0)
		{
			i++;
			if (argc>i)
			{
				strncpy(filename,argv[i],1024);
			} else {
				printf("-O output.img\n");
				exit(0);
			}
		} else if(argv[i][0]=='-') {
			printf("-? for help\n");
			exit(0);
		}
	}
	printf("inputfile: %s\n",argv[argc-1]);
	printf("outputfile:%s\n",filename);
	if (offs>0) printf("offset:    0x%04X\n",offs); else printf("offset:    -0x%04X\n",-offs);
	printf("format:    %s\n",formats[outputformat]);
	printf("Pass 1- Finding labels\n");
	f=fopen(argv[argc-1],"rb");
	while (!feof(f))
	{
		fgets(line,sizeof(line),f);
		if (!feof(f))
		{
			getminline(&line[0],&minline[0],linenum);

			if (!islabel(&minline[0],linenum,addr,1))
			{
				i=findoperand(&minline[0],linenum);
				if (i>=0 && i<OPCODENUM) {
					j=findaddrmode(&minline[0],linenum,i);
					addr+=opcodelen[j];
				}
				else if (i==OPCODENUM) 
				{
					lc='.';
					quote=0;
					j=0;
					for (i=1;i<strlen(minline);i++)
					{
						c=minline[i];
						if (lc!='\\' && c=='"') quote=1-quote;
						else {
							if (quote)
							{
								if (lc=='\\' && c=='"') {addr++;c=0;}	
								if (lc=='\\' && c=='0') {addr++;c=0;}	
								if (lc=='\\' && c=='t') {addr++;c=0;}	
								if (lc=='\\' && c=='b') {addr++;c=0;}	
								if (lc=='\\' && c=='r') {addr++;c=0;}	
								if (lc=='\\' && c=='n') {addr++;c=0;}	
								if (lc=='\\' && c=='\\') {addr++;c=0;}	
								if (c!=0 && c!='\\') addr++;
								j=0;
								line[j]=0;
							} else {
								if (c!=32 && c!=',') {line[j++]=c;line[j]=0;}
								if (c==',' || minline[i+1]==0) 
								{
									addr++;
									j=0;
									line[j]=0;
								}
							}
							lc=c;
						}
					}
				}
			}

			linenum++;
		}
	}
	printf("%i lines, %i labels found, %i bytes code\n",linenum,labelnum,addr);
	addr--;
	if (offs<0) offs=-offs-addr;
	printf("Program will be stored at 0x%04X-0x%04X\n",offs,offs+addr);
	printf("\n\n");
	addr=offs;
	for (i=0;i<labelnum;i++)
	{
		labels[i].offs+=offs;
		printf("  label [%s], line %i 0x%04X\n",labels[i].name,labels[i].sourceline,labels[i].offs);
	}
	printf("Pass 2- Compiling\n");
	fseek(f,0,0);
	linenum=0;
	while (!feof(f))
	{
		fgets(line,sizeof(line),f);
		linenum++;
		if (!feof(f))
		{
			getminline(&line[0],&minline[0],linenum);
			if (!islabel(&minline[0],linenum,addr,0))
			{
				i=findoperand(&minline[0],linenum);
				if (i>=0 && i<OPCODENUM)
				{
					j=findaddrmode(&minline[0],linenum,i);
					image[addr++]=opcodes[i].hex[j];
					if (opcodelen[j]!=1) i=getvalue(&minline[0],linenum,addr,i,j);
					for (k=0;k<(opcodelen[j]-1);k++) 
					{
						image[addr++]=i&0xff;
						i>>=8;
					}
				} 
				else if (i==OPCODENUM)
				{
					lc='.';
					quote=0;
					j=0;
					for (i=1;i<strlen(minline);i++)
					{
						c=minline[i];
						if (lc!='\\' && c=='"') quote=1-quote;
						else {
							if (quote)
							{
								if (lc=='\\' && c=='"') {image[addr++]='"';c=0;}	
								if (lc=='\\' && c=='0') {image[addr++]=0;c=0;}	
								if (lc=='\\' && c=='t') {image[addr++]=9;c=0;}	
								if (lc=='\\' && c=='b') {image[addr++]=7;c=0;}	
								if (lc=='\\' && c=='r') {image[addr++]=13;c=0;}	
								if (lc=='\\' && c=='n') {image[addr++]=10;c=0;}	
								if (lc=='\\' && c=='\\') {image[addr++]='\\';c=0;}	
								if (c!=0 && c!='\\') image[addr++]=c;
								j=0;
								line[j]=0;
							} else {
								if (c!=32 && c!=',') {line[j++]=c;line[j]=0;}
								if (c==',' || minline[i+1]==0) 
								{
									j=getvalue(line,linenum,addr,-1,-1);
									if ((j==-1) || (j>=256) ) 
									{
										printf("illegal value or label [%s] in line %i\n",line,linenum);
										exit(0);
									}
									image[addr++]=j;
									j=0;
									line[j]=0;

								}
							}
							lc=c;
						}
					}
				}
			}
		}
	}
	fclose(f);
	f=fopen(filename,"wb");
	switch(outputformat)
	{
		case 0:	// hex
			for (i=0;i<65536;i+=16)
			{
				fprintf(f,"%08x: ",i);
				for (j=0;j<16;j++)
				{
					if (j==8) fprintf(f,"  ");
					fprintf(f,"%02X ",image[i+j]);
				}
				fprintf(f,"  ");
				for (j=0;j<16;j++)
				{
					if (image[i+j]>=32 && image[i+j]<127) fprintf(f,"%c",image[i+j]); else fprintf(f,".");
				}
				fprintf(f,"\n");
			}
			break;
		case 1:	// rom
			fwrite(image,sizeof(char),65536,f);
			break;
		case 2:	// ram
			fwrite(&image[offs],sizeof(char),(addr-offs),f);
			break;
	}
	fclose(f);
	printf("done \n");
	printf("\n\n");

}
