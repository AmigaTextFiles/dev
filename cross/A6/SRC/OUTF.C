/* ------------------------------------------------------------------
    OUTF.C -- binary output formats for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <ctype.h>
#include <stdio.h>

#include "error.h"
#include "global.h"
#include "outf.h"
#include "ustring.h"

FILE *outfile;

unsigned int outf_pccount;

void outf_wbyte(unsigned int b)
{
        unsigned int c=(b+g_outf_add)^g_outf_eor;

#ifdef DEBUG
	printf("outf_wbyte: %u $%x\n",outf_pccount,b);
	fflush(stdout);
#endif

	if(g_pass) {    /* Only actual output on pass 2!!! */
		putc((unsigned char)(c & 0xff),outfile);
	}

	if(++outf_pccount == 0)
		error("pc register (*) has wrapped!!!",ERR_FATAL);
}

void outf_wword(unsigned int w) {
	outf_wbyte(w & 0xff);
	outf_wbyte(w >> 8);
}

void outf_open(char *filename)
{
	outfile=fopen(filename,"wb");

	if(outfile==0)
		errors("can't open output file '%s'",filename,ERR_FATAL);
}

void outf_close(void)
{
	if(fclose(outfile))
		error("can't close output file",ERR_FATAL);
}

void outf_header(void)
{
	char buffer[16];		/* For C64 formats */
	int i=0,mode=0;

	if(!g_pass) return;

	/* Generate (simple) C64-style filename */
	while(i<16) {
		if(mode)
			buffer[i++]='\0';
		else {
			if(g_outname[i]=='.' || g_outname[i]==0)
				mode++;
			else {
				buffer[i]=toupper(g_outname[i]);
				i++;
			}
		}
	}

	/* Output the header */
	switch(g_outf_format) {
		case OUTF_P00:
			fprintf(outfile,"C64file");	/* Header (7) */
			putc(0,outfile);	/* $0008 */
			for(i=0;i<16;i++)	/* Filename (16) */
				putc(buffer[i],outfile);
				putc(0,outfile);	/* $0018 */
				putc(0,outfile);	/* $0019 */
			/* Now data -- drop through for file start */
		case OUTF_PRG:
                        putc((outf_pccount & 0xff),outfile);
			putc((outf_pccount >> 8),outfile);
			break;
	}
}

void outf_setpc(unsigned int newpc)
{
	if(outf_pccount) {  /* Set before, no header needed */
		outf_pccount=newpc;
	} else {  /* First time set, write header */
		outf_pccount=newpc;
                #ifdef DEBUG
                printf("outf_setpc: newpc=%u,*=%u\n",newpc,outf_pccount);
                #endif
		outf_header();
	}
}

unsigned int outf_getpc(void)
{
	return(outf_pccount);
}
