/* ------------------------------------------------------------------
    ASMFILE.C -- main assembly file handler for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "conf.h"
#include "error.h"
#include "ustring.h"
#include "global.h"

/* Cope with non-ANSI stdio.h (THIS worries me!!!) */
#ifndef SEEK_SET
#define SEEK_SET (0)
#endif

/* Max no. of files */
#define MAX_FILES (64)

/* The big structure */
struct asmfile {
	char *filename;
	unsigned int line;
	struct asmfile *previous;
	long pos;
	FILE *infile;
};

struct asmfile *current=0;

long lastpos;

/* This is only used by af_getline and af_getcurrentline */
/* oh--and by almost every other file in the program ;-) */
static char currentline[256];


/* Persistent names -- ensure pointers are always unique (save memory) */
char *persistentnames[MAX_FILES];
int filesused=0;

int linehaschanged=1;


/* Allocate a persistent name for the file */
char *uniqueptr(char *s)
{
	int i=0, j=strlen(s);

	while(i<filesused) {
		if(strncmp(persistentnames[i],s,j)==0) {
			return(persistentnames[i]);
		}
		i++;
	}

	return((persistentnames[filesused++]=newstring(s)));
}

/* Do an actual stdio open of a file */
FILE *openf(char *name)
{
	char buffer[256];
	FILE *t;

	strcpy(buffer,name);
	t=fopen(buffer,"r");
	return t;
}

/* Open a file */
void af_open(char *fn,FILE *f)
{
	struct asmfile *af;

	/* If a file currently open, close it */
	if(current) {
		current->pos=ftell(current->infile);
		fclose(current->infile);
		current->infile=0;
	}

	/* Generate a new file */
	af=malloc(sizeof(struct asmfile));

	/* Set all the bits of the struct */
	af->filename=uniqueptr(fn);
	af->line=0;
	af->previous=current;
	af->pos=0;

	/* Check whether we need to open the file */
	if(f) {
		af->infile=f;
	} else {
		af->infile=openf(af->filename);

		if(af->infile==0) {
			fprintf(stderr, "error: can't open `%s'\n",af->filename);
			printf("fatal error: assembly stopped\n");
			exit(EXIT_FAILURE);
		}
	}

	current=af;

	return;
}

/* Close the current file: return -1 _if files left to close_ */
int af_close(void)
{
	struct asmfile *z;

	if(current==0) return(0);

	if(current->infile)
		fclose(current->infile);

	z=current;
	current=z->previous;
	free(z);

	return(current==0);
}

/* Get a line from the current file */
char *af_getline(void)
{
	if(!current) return(0);

	if(current->infile==0) {
		if(!(current->infile=openf(current->filename)))
			error("af_getline: fopen failed\n",ERR_FATAL);
		if(fseek(current->infile,current->pos,SEEK_SET))
			error("af_getline: fseek failed\n",ERR_FATAL);
	}

	lastpos=ftell(current->infile);

	if(!fgets((char *)currentline,256,current->infile)) {
		af_close();     /* Next file takes over next call */
		return("");
	}

	/* implicit `else' */
	current->line++;
	linehaschanged=1;

	/* list line if required -- the \n is included */
	if(g_pass && g_listflag)
		fprintf(g_listout,"%s",currentline);

	/* return the trimmed version */
	return(rtrim(currentline));
}

/* Return the name */
char *af_name(void)
{
	if(current)
		return(current->filename);
	else
		return(0);
}

/* Return the current line */
unsigned int af_line(void)
{
	if(current)
		return(current->line);
	else
		return(-1);
}

/* Print current line */
void af_printforerror(void)
{
	char buffer[256];

	if(linehaschanged)
		linehaschanged=0;
	else
		return;

	if(current==0) {
		printf("internal fatal error: no file open, please email trireme@powerfield.demon.co.uk\n");
		exit(EXIT_FAILURE);
	}

	if(fseek(current->infile,lastpos,SEEK_SET)) {
		printf("internal fatal error: fseek failed, please email trireme@powerfield.demon.co.uk\n");
		exit(EXIT_FAILURE);
	}

	fgets((char *)buffer,256,current->infile);

	printf("%s\n",buffer);
}

/* Clean up at end of program */
void af_cleanup(void)
{
	while(af_close());

	while(filesused) {
		free(persistentnames[--filesused]);
	}
}
