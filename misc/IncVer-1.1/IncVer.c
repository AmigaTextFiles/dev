/*
    INCVER

    (C) Janne Jalkanen 1994

    Searches for version string and increases it.

    Exitstatus = 0, if all went OK, 5 if error
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef AMIGA
#include <exec/libraries.h>
#include <dos/datetime.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

struct DosBase *DosBase = NULL;
#endif

#define VERSION "1.1"
#define DEFAULT_STRING	"#define"" VERSION" /* Otherwise we can't use IncVer unto itself...*/
#define DEFAULT_FILE	"main.h"
#define DEFAULT_COMMENTS "HISTORY"
#define DEFAULT_FMTSTR	"\nVersion %v.%r (%D, %d %t)\n"
#define MAXLINELEN 1024
#define SHORTLINE 40

char filename[MAXLINELEN+1];
char outfilename[MAXLINELEN+1],commentfile[MAXLINELEN+1];
char fmtstring[MAXLINELEN+1];
char searchstring[80],comment[1024];
FILE *fp = NULL;
FILE *fpout = NULL;
int inc_v = 0, inc_r = 0, glob_ver, glob_rev;
int nocomment = 0; /* Set to 1 if you don't wish comments */

static char versionstring[] = "$VER: IncVer "VERSION" ("__DATE__").";

const char usage[] =
"IncVer v."VERSION" ("__DATE__"). (C) Janne Jalkanen 1994\n\n"
"Usage: IncVer [-n] [-h] [-r<rev>] [-v<ver>] [-s<searchstring>]\n"
"              [-c<commentfile>] [-H<hdrstr>] [prgfile]\n"
"\n"
"Currently, <searchstring> defaults to '"DEFAULT_STRING"',\n"
"<commentfile> to '"DEFAULT_COMMENTS"' and <prgfile> to '"DEFAULT_FILE"'.\n"
"There may be no spaces between options and arguments.\n"
"\n"
"This program is Freely Distributable.\n";

int die(const char *ermsg)
{
    if(fp)
	fclose(fp);
    if(fpout)
	fclose(fpout);

    fprintf(stderr,"IncVer: %s\n",ermsg);
#ifdef AMIGA
    if(DosBase)
	CloseLibrary(DosBase);
#endif
    if(ermsg[0]=='\0') /* On empty string, exit gracefully */
	exit(0);

    exit(5); /* Error otherwise */
}

void parseargs(int ac, char **av)
{
    int i,t;
    char *s;

    /* First, set defaults (first check for environment variable,
       then set builtin_defaults */

    if(getenv("INCVER_FILE"))
	strcpy(filename,getenv("INCVER_FILE"));
    else
	strcpy(filename,DEFAULT_FILE);

    if(getenv("INCVER_STRING"))
	strcpy(searchstring,getenv("INCVER_STRING"));
    else
	strcpy(searchstring,DEFAULT_STRING);

    if(getenv("INCVER_COMMENTS"))
	strcpy(commentfile,getenv("INCVER_COMMENTS"));
    else
	strcpy(commentfile,DEFAULT_COMMENTS);

    if(getenv("INCVER_FMTSTR"))
	strcpy(fmtstring,getenv("INCVER_FMTSTR"));
    else
	strcpy(fmtstring,DEFAULT_FMTSTR);

    /* Start parsing command line arguments */

    for(i = 1; i < ac; i++) {
	if(av[i][0] == '-') { /* Option */
	    switch(av[i][1]) {
		case 'r': /* Bump revision */
		    if( (t = atoi(&av[i][2])) != 0 )
			inc_r = t; /* Increase to this revision number */
		    else
			inc_r = -1;
		    break;
		case 'v': /* Bump version */
		    if( (t = atoi(&av[i][2])) != 0 )
			inc_v = t; /* Increase to this revision number */
		    else
			inc_v = -1;
		    break;
		case 's': /* New search string */
		    s = strtok(av[i]," ");
		    strncpy(searchstring,&s[2],SHORTLINE);
		    break;
		case 'c': /* New comment file */
		    s = strtok(av[i]," ");
		    strncpy(commentfile,&s[2],MAXLINELEN);
		    break;
		case 'H': /* New header string */
		    s = strtok(av[i]," ");
		    strncpy(fmtstring,&s[2],MAXLINELEN);
		    break;
		case 'n': /* No comments */
		    nocomment=1;
		    break;
		case 'h': /* Help */
		    puts(usage);
		    die("");
		    break;
		default:
		    puts(usage);
		    die("Unknown option!");
		    break;
	    } /* Switch */
	}
	else {
	   strncpy(filename,av[i],MAXLINELEN); /* Use this file */
	}
    } /* for */
    sprintf(outfilename,"%s.tmp",filename);
    if(inc_v == 0 && inc_r == 0)
	inc_r = -1; /* If no version specified, then set revision one upwards */

}

int incver(char *buf)
/* Will return 0, if everything was OK, otherwise non-zero */
{
    char *tmpbuf,*s, verstr[20];
    int v,e,dot;

    tmpbuf = (char *) malloc(MAXLINELEN+1);
    if(tmpbuf == NULL) die("Out of memory!");
    memset(tmpbuf,0,MAXLINELEN+1); /* Zero the memory */

    /* Start search at the end of the searchstring */
    s = (char *) ((unsigned long)strstr(buf,searchstring) + strlen(searchstring));

    /* Get some pointers to version data info... */

    v	= strcspn(s,"0123456789"); /* v = start of ver str */
    glob_ver = atoi(&s[v]);
    dot = strcspn(&s[v],".");
    glob_rev = atoi(&s[v+dot+1]);
    e	= strspn(&s[v+dot+1],"0123456789");

    /* Determine new version & revision numbers */

    if(inc_v > 0)
	{ glob_ver = inc_v; glob_rev = 0; }
    if(inc_v == -1) { glob_ver++; glob_rev = 0; } /* We must reset revision also */
    if(inc_r > 0)
	glob_rev = inc_r;
    if(inc_r == -1) glob_rev++;

    memset(tmpbuf,0, MAXLINELEN+1);

    /* All purists should skip the next line, as we will subtract pointers... */
    strncpy(tmpbuf,buf, v + (unsigned int)(s - buf));
    /* So there (You can return to watching the source :) */
    sprintf(verstr,"%d.%d",glob_ver,glob_rev);
    strcat(tmpbuf,verstr);
    strcat(tmpbuf,&s[dot+v+e+1]);

    /* copy everything up but not including the */
    strcpy(buf,tmpbuf);
    printf("Bumped version to %s.\n",verstr);
    free(tmpbuf); /* Note that we shouldn't die before this... */
    return 0;
}

void getcomment(void)
{
    char line[128];

    do {
	fgets(line,127,stdin);
	strcat(comment,line);
    } while(strlen(line) > 1);
}

void makeheader( char *buf )
/* Construct the header here */
{
    int i = 0,j = 0;
    char ch,t[10];
#ifdef AMIGA
    char day[LEN_DATSTRING], date[LEN_DATSTRING], time[LEN_DATSTRING];
    struct DateTime dt;
#else
    char day[20]="",date[20]="",time[20]="";
#endif

#ifdef AMIGA
    if( ((struct Library *)DosBase)->lib_Version >= 36) {
	dt.dat_Format = FORMAT_DOS; dt.dat_Flags = 0;
	dt.dat_StrDay = day; dt.dat_StrDate = date, dt.dat_StrTime = time;

	DateStamp(&dt.dat_Stamp); /* Get system time */
	DateToStr(&dt);           /* Convert to ASCII */
    }
#endif

    strcpy(buf,""); /* Empty string just in case */

    while(ch = fmtstring[i++]) {
	switch(ch) {
	    case '%':
		switch( ch = fmtstring[i++] ) {
		    case 'D': /* Weekday */
			strcat(buf,day);
			break;
		    case 'd': /* date */
			strcat(buf,date);
			break;
		    case 't': /* time */
			strcat(buf,time);
			break;
		    case 'v': /* version */
			sprintf(t,"%d",glob_ver);
			strcat(buf,t);
			break;
		    case 'r': /* revision */
			sprintf(t,"%d",glob_rev);
			strcat(buf,t);
			break;
		    case 'f': /* File name */
			strcat(buf,filename);
			break;
		    default:
			fprintf(stderr,"IncVer: Unknown format option '%c'\n",ch);
			break;
		} /* switch */
		break;
	    case '\\': /* Check for interesting stuff */
		switch(ch = fmtstring[i++]) {
		    case 'n':
			ch = '\n'; break;
		    case 't':
			ch = '\t';break;
		    case 'r':
			ch = '\r'; break;
		    default:
			break;
		}
		/* Fallthrough intended and necessary */
	    default:
		buf[j = strlen(buf)] = ch;
		buf[j+1] = '\0'; /* Terminate string */
		break;
	} /* switch */
    } /* While */
}

void askcomment( char *data )
/* If you want something else added, set data */
{
    FILE *cfp;
    char line[128];
    int i,j,n;
    /* First check if the commentfile already exists. */

    cfp = fopen(commentfile,"r");
    if(!cfp) {
	fclose(cfp);
	puts("Please enter a description for this program (end with empty line):");
	getcomment();
	cfp = fopen(commentfile,"w");
	if(!cfp)
	    die("Can't open commentfile second first time... Wierd!");
	else
	    fprintf(cfp,"\n%s\nVERSION HISTORY:\n================\n",
			 comment);
    }
    fclose(cfp);
    strcpy(comment,"");

    /* Now get the real comment */

    puts("Please enter comment line for this version (end with empty line):");
    getcomment();
    makeheader( line );
    cfp = fopen(commentfile,"a");
    if(cfp == NULL)
	die("Unable to open comment file for append!");

    fputs(line,cfp);

    for(i=0;line[i] != '\0';i++) { /* Underline. */
	if(isprint((unsigned char)line[i]) )
	    { fputc('-',cfp); j++; }
	if(line[i] == '\t') { /* Compensate for tabs */
	    for(n = 0; n < (8 - ( (j-1) % 8)); n++)
		fputc('-',cfp);
	    j+=n;
	}
    }

    fprintf(cfp,"\n%s",comment);
    fclose(cfp);
}

int main(int argc, char **argv)
{
    int quit = 0;
    char *buf;

#ifdef AMIGA
    if((DosBase = (struct DosBase *)OpenLibrary("dos.library",33)) == NULL)
	die("This program needs at least AmigaOS 1.2!");
#endif

    parseargs(argc,argv);

    /* Open file for reading */

    fp = fopen(filename,"rt");
    if(fp == NULL)
	die("Unable to open input file!");

    fpout = fopen(outfilename,"wt");
    if(fpout == NULL)
	die("Unable to open output file!");

    buf = (char *) malloc(MAXLINELEN+1);
    if(buf == NULL) die("Out of memory!");
    memset(buf,0, MAXLINELEN+1);

    while(!quit) {
	if(fgets(buf,MAXLINELEN,fp) != NULL) {
	    if(strstr(buf,searchstring) != NULL) {
		/* Match found */
		incver(buf);
	    }
	    if(fputs(buf,fpout) < 0) {
		free(buf);
		die("Error writing output file!");
	    }
	}
	else {
	    if(feof(fp)) /* End of file */
		quit = 1;
	    else {
		free(buf);
		die("Error reading input file!");
	    }
	}
    }

    free(buf);
    fclose(fp);
    fclose(fpout);
    if(!nocomment)
	askcomment(NULL);

    /* Delete & rename files happily */

#ifdef AMIGA
    if(DeleteFile( filename ) == -1 ) {
	if(Rename(outfilename,filename) == 0L)
	    die("Unable to Rename() new file");
	else {
	    DeleteFile(outfilename);
	}
    }
    else {
	die("Unable to Delete old file!");
    }
    CloseLibrary(DosBase);
#else
    printf("copying not working yet\n");
#endif
    return 0; /* Return_OK */
}
