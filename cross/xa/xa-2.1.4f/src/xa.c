
/*
    xa65 - 6502 cross assembler and utility suite
    Copyright (C) 1989-1998 André Fachat (a.fachat@physik.tu-chemnitz.de)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/


#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

/* structs and defs */

#include "xah.h"
#include "xah2.h"

/* exported functions are defined here */

#include "xar.h"
#include "xa.h"
#include "xam.h"
#include "xal.h"
#include "xap.h"
#include "xat.h"
#include "xao.h"

/* exported globals */

int ncmos,cmosfl;
int masm = 0;
int nolink = 0;
int romable = 0;
int romadr = 0;
int noglob = 0;
int showblk = 0;

/* local variables */

static const char *copyright={
"Cross-Assembler 65xx V2.1.4f 20apr1998 (c) 1989-98 by A.Fachat\n"};

static char out[MAXLINE];
static time_t tim1,tim2;
static FILE *fpout,*fperr,*fplab;
static int ner = 0;

static int align = 1;

static void printstat(void);
static void usage(void);
static int  setfext(char*,char*);
static int  x_init(void);
static int  pass1(void);
static int  pass2(void);
static int  puttmp(int);
static int  puttmps(signed char*,int);
static void chrput(int);
static int  getline(char*);
static void lineout(void);
static long ga_p1(void);
static long gm_p1(void);

/* text */
int segment;
int tlen=0, tbase=0x1000;
int dlen=0, dbase=0x0400;
int blen=0, bbase=0x4000;
int zlen=0, zbase=4;
int _fmode=0;
int relmode=0;

int pc[SEG_MAX];	/* segments */

int main(int argc,char *argv[])
{
     int er=1,i;
     signed char *s=NULL;

     int mifiles = 5;
     int nifiles = 0;
     int verbose = 0;
     int oldfile = 0;
     int no_link = 0;

     char **ifiles;
     char *ofile;
     char *efile;
     char *lfile;
     char *ifile;

     char old_e[MAXLINE];
     char old_l[MAXLINE];
     char old_o[MAXLINE];

     tim1=time(NULL);
     
     ncmos=0;
     cmosfl=1;

     ifiles = malloc(mifiles*sizeof(char*));

     afile = alloc_file();

     if(argc<=1)
     {
          usage();
          return(1);
     }
     
     ofile="a.o65";
     efile=NULL;
     lfile=NULL;

     if(pp_init()) {
       logout("fatal: pp: no memory!");
       return 1;
     }
     if(b_init()) {
       logout("fatal: b: no memory!");
       return 1;
     }
     if(l_init()) {
       logout("fatal: l: no memory!");
       return 1;
     }

 
     i=1;
     while(i<argc) {
	if(argv[i][0]=='-') {
	  switch(argv[i][1]) {
	  case 'M':
	   	masm = 1;	/* MASM compatibility mode */
		break;
	  case 'A':		/* make text segment start so that text relocation
				   is not necessary when _file_ starts at adr */
		romable = 2;
		if(argv[i][2]==0) romadr = atoi(argv[++i]);
		else romadr = atoi(argv[i]+2);
		break;
	  case 'G':
		noglob = 1;
		break;
	  case 'L':		/* define global label */
		if(argv[i][2]) lg_set(argv[i]+2);
		break;
	  case 'R':
		relmode = 1; 
		break;
	  case 'D':
		s = (signed char*)strstr(argv[i]+2,"=");
		if(s) *s = ' ';
		pp_define(argv[i]+2);
		break;
	  case 'c':
		no_link = 1;
		_fmode |= FM_OBJ;
		break;
	  case 'v':
		verbose = 1; 
		break;
	  case 'C':
		cmosfl = 0;
		break;
	  case 'B':
		showblk = 1;
		break;
	  case 'x':		/* old filename behaviour */
		oldfile = 1;
		break;
	  case 'I':
		if(argv[i][2]==0) {
		  reg_include(argv[++i]);
		} else {
		  reg_include(argv[i]+2);
		}
		break;
	  case 'o':
		if(argv[i][2]==0) {
		  ofile=argv[++i];
		} else {
		  ofile=argv[i]+2;
		}
		break;
	  case 'l':
		if(argv[i][2]==0) {
		  lfile=argv[++i];
		} else {
		  lfile=argv[i]+2;
		}
		break;
	  case 'e':
		if(argv[i][2]==0) {
		  efile=argv[++i];
		} else {
		  efile=argv[i]+2;
		}
		break;
	  case 'b':			/* set segment base addresses */
		switch(argv[i][2]) {	
		case 't':
			if(argv[i][3]==0) tbase = atoi(argv[++i]);
			else tbase = atoi(argv[i]+3);
			break;
		case 'd':
			if(argv[i][3]==0) dbase = atoi(argv[++i]);
			else dbase = atoi(argv[i]+3);
			break;
		case 'b':
			if(argv[i][3]==0) bbase = atoi(argv[++i]);
			else bbase = atoi(argv[i]+3);
			break;
		case 'z':
			if(argv[i][3]==0) zbase = atoi(argv[++i]);
			else zbase = atoi(argv[i]+3);
			break;
		default:
			fprintf(stderr,"unknow segment type '%c' - ignoring!\n",
								argv[i][2]);
			break;
		}
		break;
	  case 0:
		fprintf(stderr, "Single dash '-' on command line - ignoring!\n");
		break;
	  default:
		fprintf(stderr, "Unknown option '%c' - ignoring!\n",argv[i][1]);
		break;
	  }
	} else {		/* no option -> filename */
	  ifiles[nifiles++] = argv[i];
	  if(nifiles>=mifiles) {
	    mifiles += 5;
	    ifiles=realloc(ifiles, mifiles*sizeof(char*));
	    if(!ifiles) {
		fprintf(stderr, "Oops: couldn't alloc enough mem for filelist table..!\n");
		exit(1);
	    }
	  }
	}
	i++;
     }
     if(!nifiles) {
	fprintf(stderr, "No input files given!\n");
	exit(0);
     }

     if(oldfile) {
	strcpy(old_e, ifiles[0]);
	strcpy(old_o, ifiles[0]);
	strcpy(old_l, ifiles[0]);

	if(setfext(old_e,".err")==0) efile = old_e;
	if(setfext(old_o,".obj")==0) ofile = old_o;
	if(setfext(old_l,".lab")==0) lfile = old_l;
     }

     fplab= lfile ? xfopen(lfile,"w") : NULL;
     fperr= efile ? xfopen(efile,"w") : NULL;
     if(!strcmp(ofile,"-")) {
	ofile=NULL;
        fpout = stdout;
     } else {
        fpout= xfopen(ofile,"wb");
     }
     if(!fpout) {
	fprintf(stderr, "Couldn't open output file!\n");
	exit(1);
     }

     if(verbose) fprintf(stderr, "%s",copyright);

     if(1 /*!m_init()*/)
     {
       if(1 /*!b_init()*/)
       {
         if(1 /*!l_init()*/)
         {
           /*if(!pp_init())*/
           {
             if(!x_init())
             {
	       if(fperr) fprintf(fperr,"%s",copyright);
	       if(verbose) logout(ctime(&tim1));

	       /* Pass 1 */

               pc[SEG_ABS]= 0;		/* abs addressing */
	       seg_start(_fmode, tbase, dbase, bbase, zbase, 0, relmode);

	       if(relmode) {
		 r_mode(RMODE_RELOC);
		 segment = SEG_TEXT;
	       } else {
		 r_mode(RMODE_ABS);
	       }

	       nolink = no_link;

               for (i=0; i<nifiles; i++)
               {
		 ifile = ifiles[i];

                 sprintf(out,"xAss65: Pass 1: %s\n",ifile);
                 if(verbose) logout(out);

                 er=pp_open(ifile);
                 if(!er) {
                   er=pass1();
                   pp_close();
                 } else {
		   sprintf(out, "Couldn't open source file '%s'!\n", ifile);
		   logout(out);
                 }
               }           

	       if((er=b_depth())) {
		 sprintf(out,"Still %d blocks open at end of file!\n",er);
		 logout(out);
	       }

	       if(tbase & (align-1)) {
		   sprintf(out,"Warning: text segment ($%04x) start address doesn't align to %d!\n", tbase, align);
		   logout(out);
	       }
	       if(dbase & (align-1)) {
		   sprintf(out,"Warning: data segment ($%04x) start address doesn't align to %d!\n", dbase, align);
		   logout(out);
	       }
	       if(bbase & (align-1)) {
		   sprintf(out,"Warning: bss segment ($%04x) start address doesn't align to %d!\n", bbase, align);
		   logout(out);
	       }
	       if(zbase & (align-1)) {
		   sprintf(out,"Warning: zero segment ($%04x) start address doesn't align to %d!\n", zbase, align);
		   logout(out);
	       }
	       switch(align) {
		case 1: break;
		case 2: _fmode |= 1; break;
		case 4: _fmode |= 2; break;
		case 256: _fmode |=3; break;
	       }
	       
	       if((!er) && relmode) 
			h_write(fpout, _fmode, tlen, dlen, blen, zlen, 0);


               if(!er)
               {
                    if(verbose) logout("xAss65: Pass 2:\n");

		    seg_pass2();

	            if(!relmode) {
	              r_mode(RMODE_ABS);
	            } else {
	              r_mode(RMODE_RELOC);
		      segment = SEG_TEXT;
	            }
                    er=pass2();
               } 

               if(fplab) printllist(fplab);
               tim2=time(NULL);
	       if(verbose) printstat();

	       if((!er) && relmode) seg_end(fpout);	/* write reloc/label info */
			                              
               if(fperr) fclose(fperr);
               if(fplab) fclose(fplab);
               if(fpout) fclose(fpout);

             } else {
               logout("fatal: x: no memory!\n");
             }
             pp_end();
/*           } else {
             logout("fatal: pp: no memory!");*/
           }
         } else {
          logout("fatal: l: no memory!\n");
         }
       } else {
          logout("fatal: b: no memory!\n");
       }
       /*m_exit();*/
     } else { 
          logout("Not enough memory available!\n");
     }

     if(ner || er)
     {
          fprintf(stderr, "Break after %d error%c\n",ner,ner?'s':0);
	  /*unlink();*/
	  if(ofile) {
	    unlink(ofile);
	  }
     }

     free(ifiles);

     return( (er || ner) ? 1 : 0 );
}

static void printstat(void)
{
	logout("Statistics:\n");
	sprintf(out," %8d of %8d label used\n",ga_lab(),gm_lab()); logout(out);
	sprintf(out," %8ld of %8ld byte label-memory used\n",ga_labm(),gm_labm()); logout(out);
	sprintf(out," %8d of %8d PP-defs used\n",ga_pp(),gm_pp()); logout(out);
	sprintf(out," %8ld of %8ld byte PP-memory used\n",ga_ppm(),gm_ppm()); logout(out);
	sprintf(out," %8ld of %8ld byte buffer memory used\n",ga_p1(),gm_p1()); logout(out);
	sprintf(out," %8d blocks used\n",ga_blk()); logout(out);
	sprintf(out," %8ld seconds used\n",(long)difftime(tim2,tim1)); logout(out);
}

#define	fputw(a,fp)	fputc((a)&255,fp);fputc((a>>8)&255,fp)

int h_length(void) {
	return 26+o_length();
}

#if 0
/* write header for relocatable output format */
int h_write(FILE *fp, int tbase, int tlen, int dbase, int dlen, 
				int bbase, int blen, int zbase, int zlen) {

	fputc(1, fp);			/* version byte */
	fputc(0, fp);			/* hi address 0 -> no C64 */
	fputc("o", fp);
	fputc("6", fp);
	fputc("5", fp);			
	fputc(0, fp);			/* format version */
	fputw(mode, fp);		/* file mode */
	fputw(tbase,fp);		/* text base */
	fputw(tlen,fp);			/* text length */
	fputw(dbase,fp);		/* data base */
	fputw(dlen,fp);			/* data length */
	fputw(bbase,fp);		/* bss base */
	fputw(blen,fp);			/* bss length */
	fputw(zbase,fp);		/* zerop base */
	fputw(zlen,fp);			/* zerop length */

	o_write(fp);

	return 0;
}
#endif

static int setfext(char *s, char *ext)
{
     int j,i=(int)strlen(s);

     if(i>MAXLINE-5)
          return(-1);
          
     for(j=i-1;j>=0;j--)
     {
          if(s[j]==DIRCHAR)
          {
               strcpy(s+i,ext);
               break;
          }
          if(s[j]=='.')
          {
               strcpy(s+j,ext);
               break;
          }
     }
     if(!j)
          strcpy(s+i,ext);

     return(0);
}

/*
static char *tmp;
static unsigned long tmpz;
static unsigned long tmpe;
*/

static long ga_p1(void)
{
	return(afile->mn.tmpz);
}
static long gm_p1(void)
{
	return(TMPMEM);
}

#ifndef abs
#define abs(a) ((a)>=0 ? a : -a)
#endif

static int pass2(void)
{
     int c,er,l,ll,i,al;
     Datei datei;
     signed char *dataseg=NULL;
     signed char *datap=NULL;

     if((dataseg=malloc(dlen))) {
       if(!dataseg) {
	 fprintf(stderr, "Couldn't alloc dataseg memory...\n");
	 exit(1);
       }
       datap=dataseg;
     }
     filep=&datei;
     afile->mn.tmpe=0L;

     while(ner<20 && afile->mn.tmpe<afile->mn.tmpz)
     {
          l=afile->mn.tmp[afile->mn.tmpe++];
          ll=l;

          if(!l)
          {
               if(afile->mn.tmp[afile->mn.tmpe]==T_LINE)
               {
                    datei.fline=(afile->mn.tmp[afile->mn.tmpe+1]&255)+(afile->mn.tmp[afile->mn.tmpe+2]<<8);
                    afile->mn.tmpe+=3;
               } else
               if(afile->mn.tmp[afile->mn.tmpe]==T_FILE)
               {
                    datei.fline=(afile->mn.tmp[afile->mn.tmpe+1]&255)+(afile->mn.tmp[afile->mn.tmpe+2]<<8);
                    strcpy(datei.fname,(char*) afile->mn.tmp+afile->mn.tmpe+3);
                    afile->mn.tmpe+=3+strlen(datei.fname);
               }
          } else
          {
               er=t_p2(afile->mn.tmp+afile->mn.tmpe,&ll,0,&al);
          
               if(er==E_NOLINE)
               {
               } else
               if(er==E_OK)
               {
		  if(segment<SEG_DATA) { 
                    for(i=0;i<ll;i++)
                         chrput(afile->mn.tmp[afile->mn.tmpe+i]);
		  } else if (segment==SEG_DATA && datap) {
		    memcpy(datap,afile->mn.tmp+afile->mn.tmpe,ll);
		    datap+=ll;
		  }
               } else
               if(er==E_DSB)
               {
                  c=afile->mn.tmp[afile->mn.tmpe];
		  if(segment<SEG_DATA) {
                    /*printf("E_DSB, ll=%d, l=%d, c=%c\n",ll,l,afile->mn.tmp[afile->mn.tmpe]);*/
                    for(i=0;i<ll;i++)
                         chrput(c);
		  } else if (segment==SEG_DATA && datap) {
		    memset(datap, c, ll);
		    datap+=ll;
		  }
               } else
               {
                    errout(er);
               }
          }
          afile->mn.tmpe+=abs(l);
     }
     if(relmode) {
       if((ll=fwrite(dataseg, 1, dlen, fpout))<dlen) {
	fprintf(stderr, "Problems writing %d bytes, return gives %d\n",dlen,ll);
       }
     }

     return(ner);
}     
     

static int pass1(void)
{
     signed char o[MAXLINE];
     int l,er, al;

     tlen=0;
     ner=0;
     while(!(er=getline(s)))
     {         
          er=t_p1((signed char*)s,o,&l,&al);
	  switch(segment) {
	    case SEG_ABS:
	    case SEG_TEXT: tlen += al; break;
	    case SEG_DATA: dlen += al; break;
	    case SEG_BSS : blen += al; break;
	    case SEG_ZERO: zlen += al; break;
	  }

          /*printf(": er= %d, l=%d, tmpz=%d\n",er,l,tmpz);*/

          if(l)
          {
            if(er)
            {
               if(er==E_OKDEF)
               {
                    if(!(er=puttmp(l)))
                         er=puttmps(o,l);
               } else
               if(er==E_NOLINE)
                    er=E_OK;
            } else
            {
               if(!(er=puttmp(-l)))
                    er=puttmps(o,l);
            }
          }
          if(er)
          {
               lineout();
               errout(er);
          }

/*          printf("tmpz =%d\n",afile->mn.tmpz);
*/
     } 

     if(er!=E_EOF)
          errout(er);

          

     /*{ int i; printf("Pass 1 \n");
     for(i=0;i<afile->mn.tmpz;i++)
          fprintf(stderr, " %02x",afile->mn.tmp[i]);
     getchar();}*/

     return(ner);
}


static void usage(void)
{
     fprintf(stderr, "%s",copyright);
     fprintf(stderr, "usage : xa { option | sourcefile }\n"
	    "options:\n"
	    " -v          = verbose output\n"
	    " -x          = old filename behaviour (overrides -o, -e, -l)\n"
            " -C          = no CMOS-opcodes\n"
            " -B          = show lines with block open/close\n"
            " -c          = produce o65 object instead of executable files (i.e. do not link)\n"
	    " -o filename = sets output filename, default is 'a.o65'\n"
	    "               A filename of '-' sets stdout as output file\n"
	    " -e filename = sets errorlog filename, default is none\n"
	    " -l filename = sets labellist filename, default is none\n"
	    " -M          = allow \":\" to appear in comments, for MASM compatibility\n"
	    " -R          = start assembler in relocating mode\n"
	    " -Llabel     = defines 'label' as absolute, undefined label even when linking\n"
	    " -b? adr     = set segment base address to integer value adr. \n"
	    "               '?' stands for t(ext), d(ata), b(ss) and z(ero) segment\n"
            "               (address can be given more than once, latest is taken)\n"
	    " -A adr      = make text segment start at an address that when the _file_\n"
	    "               starts at adr, relocation is not necessary. Overrides -bt\n"
	    "               Other segments have to be take care of with -b?\n"
 	    " -G          = suppress list of exported globals\n"
	    " -DDEF=TEXT  = defines a preprocessor replacement\n"
	    " -Idir      = add directory 'dir' to include path (before XAINPUT)\n"
            "Environment:\n"
            " XAINPUT = include file path; components divided by ','\n"
            " XAOUTPUT= output file path\n"
	);
}

#define   ANZERR    30
#define   ANZWARN   6

/*
static char *ertxt[] = { "Syntax","Label definiert",
          "Label nicht definiert","Labeltabelle voll",
          "Label erwartet","Speicher voll","Illegaler Opcode",
          "Falsche Adressierungsart","Branch ausserhalb des Bereichs",
          "Ueberlauf","Division durch Null","Pseudo-Opcode erwartet",
          "Block-Stack-Ueberlauf","Datei nicht gefunden",
          "End of File","Block-Struktur nicht abgeschlossen",
          "NoBlk","NoKey","NoLine","OKDef","DSB","NewLine",
          "NewFile","CMOS-Befehl","pp:Falsche Anzahl Parameter" };
*/
static char *ertxt[] = { "Syntax","Label defined",
          "Label not defined","Labeltab full",
          "Label expected","no more memory","Illegal opcode",
          "Wrong addressing mode","Branch out of range",
          "Overflow","Division by zero","Pseudo-opcode expected",
          "Block stack overflow","file not found",
          "End of file","Too many block close",
          "NoBlk","NoKey","NoLine","OKDef","DSB","NewLine",
          "NewFile","CMOS-Befehl","pp:Wrong parameter count",
	  "Illegal pointer arithmetic", "Illegal segment",
	  "File header option too long",
	  "File Option not at file start (when ROM-able)",
	  "Illegal align value",
	  /* warnings start here */	
	  "Cutting word relocation in byte value",
	  "Byte relocation in word value",
	  "Illegal pointer arithmetic",
	  "Address access to low or high byte pointer",
	  "High byte access to low byte pointer",
	  "Low byte access to high byte pointer" };

static int gl;
static int gf;  

static int x_init(void)
{
	return 0;
#if 0
     int er=0;
     /*er=m_alloc(TMPMEM,&tmp);*/
     afile->mn.tmp=malloc(TMPMEM);
     if(!afile->mn.tmp) er=E_NOMEM;
     afile->mn.tmpz=0L;
     return(er);
#endif
}

static int puttmp(int c)
{
     int er=E_NOMEM;
/*printf("puttmp: afile=%p, tmp=%p, tmpz=%d\n",afile, afile?afile->mn.tmp:0, afile?afile->mn.tmpz:0);*/
     if(afile->mn.tmpz<TMPMEM)
     {
          afile->mn.tmp[afile->mn.tmpz++]=c;
          er=E_OK;
     }
     return(er);
}

static int puttmps(signed char *s, int l)
{
     int i=0,er=E_NOMEM;
     
     if(afile->mn.tmpz+l<TMPMEM)
     {
          while(i<l)
               afile->mn.tmp[afile->mn.tmpz++]=s[i++];

          er=E_OK;
     }
     return(er);
}

static char l[MAXLINE];

static int getline(char *s)
{
     static int ec;
     static int i,c;
     int hkfl,j;

     j=hkfl=0;
     ec=E_OK;

     if(!gl)
     {
          do
          {
               ec=pgetline(l);
               i=0;
               while(l[i]==' ')
                    i++;
               while(l[i]!='\0' && isdigit(l[i]))
                    i++;
               gf=1;

               if(ec==E_NEWLINE)
               {
                    puttmp(0);
                    puttmp(T_LINE);
                    puttmp((filep->fline)&255);
                    puttmp(((filep->fline)>>8)&255);
                    ec=E_OK;
               } else
               if(ec==E_NEWFILE)
               {
                    puttmp(0);
                    puttmp(T_FILE);
                    puttmp((filep->fline)&255);
                    puttmp(((filep->fline)>>8)&255);
                    puttmps((signed char*)filep->fname,
					1+(int)strlen(filep->fname));
                    ec=E_OK;
               }
          } while(!ec && l[i]=='\0');
     }

     gl=0;
     if(!ec)
     {
          do {
               c=s[j]=l[i++];

               if (c=='\"')
                    hkfl^=1;
               if (c=='\0')
                    break;
               if ((!masm) && c==':' && !hkfl)
               {
                    gl=1;
                    break;
               }
               j++;
          } while (c!='\0' && j<MAXLINE-1 && i<MAXLINE-1);
     
          s[j]='\0';
     } else
          s[0]='\0';

     return(ec);
}

void set_align(int a) {
	align = (a>align)?a:align;
}

static void lineout(void)
{
     if(gf)
     {
          logout(filep->flinep);
          logout("\n");
          gf=0;
     }
}

void errout(int er)
{
     if (er<-ANZERR || er>-1) {
	if(er>=-(ANZERR+ANZWARN) && er < -ANZERR) {
	  sprintf(out,"%s:line %d: %04x: Warning - %s\n",
		filep->fname, filep->fline, pc[segment], ertxt[-er-1]);
	} else {
          /* sprintf(out,"%s:Zeile %d: %04x:Unbekannter Fehler Nr.: %d\n",*/
          sprintf(out,"%s:line %d: %04x: Unknown error # %d\n",
               filep->fname,filep->fline,pc[segment],er);
	  ner++;
	}
     } else {
       if (er==E_NODEF)
          sprintf(out,"%s:line %d: %04x:Label '%s' not defined\n",
               filep->fname,filep->fline,pc[segment],lz);
       else  
          sprintf(out,"%s:line %d: %04x:%s error\n",
               filep->fname,filep->fline,pc[segment],ertxt[-er-1]);

       ner++;
     }
     logout(out);
}

static void chrput(int c)
{
     /*     printf(" %02x",c&255);*/

     putc( c&0x00ff,fpout);
}

void logout(char *s)
{
     fprintf(stderr, "%s",s);
     if(fperr)
          fprintf(fperr,"%s",s);
}

