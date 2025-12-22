/************************************************/
/*** Strips Symbol_Hunks from AMIGALoadFiles  ***/
/*** Quick-and-dirty Version 1.0 010394 ST    ***/
/*** This may be copied, distributed, etc.    ***/
/*** You may alter this file anyway you want  ***/
/************************************************/
#include <dos/doshunks.h>
#include <stdio.h>


#define SL sizeof(long int)

int StripAHunk(FILE *fpin,FILE *fpout); /* Strips a Hunk, to be read from fp, returns*/
				  /* #of symbols stripped */

int main(argc,argv)
int argc;
char **argv;
{
FILE *fpin,*fpout;
long int s[10];
int n,i,num;

if ((argc!=2)&&(argc!=3))
	{
	fprintf(stderr,"Usage: %s filein [fileout]\n",argv[0]);
	exit(1);
	}

if ((fpin=fopen(argv[1],"r"))==NULL)
	{
	fprintf(stderr, "Can't open %s\n",argv[1]);
	exit(1);
	}

if (argc==2) /* Use stdout as output */
	fpout=stdout;
else
	{
	if ((fpout=fopen(argv[2],"w"))==NULL)
		{
		fclose(fpin);
		fprintf(stderr,"Can't open %s\n",argv[2]);
		exit(1);
		}
	}


if (fread(s,SL,1,fpin)!=1)
	{
inerr:	fprintf(stderr,"fread() error\n");
	fclose(fpin);
	fclose(fpout);
	exit(1);
	}

if (s[0]!=HUNK_HEADER) /* OOps, not AMIGA Exec */
	{
	fprintf(stderr,"%s doesn't seem to be AMIGA executable...\n",argv[1]);
	exit(1);
	}
if (fwrite(s,SL,1,fpout)!=1)
	{
outerr:	fprintf(stderr,"fwrite() failed\n");
	fclose(fpin);
	fclose(fpout);
	exit(1);
	}

/* Read over header */
do
	{
	if (fread(s,SL,1,fpin)!=1)
		goto inerr;
	if (fwrite(s,SL,1,fpout)!=1)
		goto outerr;
	}while (s[0]!=0);

/* Copy lengths */
if (fread(s,SL,3,fpin)!=3)
	goto inerr;
if (fwrite(s,SL,3,fpout)!=3)
	goto outerr;

n=num=s[2]-s[1]+1;

/* Copy lengths */
for (i=0;i<n;i++)
	{
	if (fread(s,SL,1,fpin)!=1)
		goto inerr;
	if (fwrite(s,SL,1,fpout)!=1)
		goto outerr;
	}

n=0;
for (i=0;i<num;i++)
	n+=StripAHunk(fpin,fpout);

if (argc==3)
	fclose(fpout);
fclose(fpin);
if (argc==3)
	printf("Stripped %d symbols\n",n);

}/* Of main */

int StripAHunk(fin,fout)
FILE *fin;
FILE *fout;
{
int n,i,s[10],num,num2;

if (fread(s,SL,1,fin)!=1)
	{
errin: fprintf(stderr,"fread() failed\n");
	exit(1);
	}

switch(s[0])
	{
	case HUNK_NAME: /* Skip them */
	if (fread(s,SL,1,fin)!=1)
		goto errin;
	for (n=s[0],i=0;i<n;i++)
		{
		if (fread(s,SL,1,fin)!=1)
			goto errin;
		}
	return(StripAHunk(fin,fout));
	break;

	case HUNK_CODE: /* Code HUNKS */
	case HUNK_DATA: /* Data HUNKS */
	if (fwrite(s,SL,1,fout)!=1)
		goto errout;
	if (fread(s,SL,1,fin)!=1)
		goto errin;
	if (fwrite(s,SL,1,fout)!=1)
		{
errout:    fprintf(stderr,"fwrite() failed\n");
		exit(1);
		}

	/* Copy that hunk */
	for (n=s[0],i=0;i<n;i++)
		{
		if (fread(s,SL,1,fin)!=1)
			goto errin;
		if (fwrite(s,SL,1,fout)!=1)
			goto errout;
		}

	break;

	case HUNK_BSS: /* BSS HUNKS */
		if (fwrite(s,SL,1,fout)!=1)
			goto errout;
		if (fread(s,SL,1,fin)!=1)
			goto errin;
		
		if (fwrite(s,SL,1,fout)!=1)
		    goto errout;
		break;
	case HUNK_DEBUG: /* Strip */
   		if (fread(s,SL,1,fin)!=1)
   			goto errin;
    		for (n=s[0],i=0;i<n;i++)
   			{
    			if (fread(s,SL,1,fin)!=1)
       			  goto errin;
    			}
		
		break;
					    

	default:
		fprintf(stderr,"Unknown hunk type %d\n",s[0]);
		exit(1);
		break;
	}/* Of switch */


	/* So, now there may be HUNK_END, HUNK_RELOC*,HUNK_SYMBOL,HUNK_DEBUG*/
num=0; /* # symbols stripped */
if (fread(s,SL,1,fin)!=1)
	goto errin;

while (1)
	{
	switch(s[0])
	{
	case HUNK_END: /* Done */
		if (fwrite(s,SL,1,fout)!=1)
        	  goto errout;
		return num;
		break;

	case HUNK_DEBUG: /* Strip */
		if (fread(s,SL,1,fin)!=1)
			goto errin;
		for (n=s[0];i<n;i++)
			{
			if (fread(s,SL,1,fin)!=1)
    			  goto errin;
			}
		if (fread(s,SL,1,fin)!=1)
		  goto errin;
		continue;
		break;

	case HUNK_SYMBOL: /* STRIP */
		while (1) /* read symnames and value */
		{
		if (fread(s,SL,1,fin)!=1)
		goto errin;
		n=s[0]&0xffffff; /* mask top byte */
		if (n==0)
		  break;
		num++; /* One symbol stripped */
		for (i=0;i<n;i++)
 		  if (fread(s,SL,1,fin)!=1)
		    goto errin;
		if (fread(s,SL,1,fin)!=1) /* Value */
    		  goto errin;
		}/* Of while */
		if (fread(s,SL,1,fin)!=1)
    		  goto errin;
    		continue;
		break;

	case HUNK_RELOC32: /* rel32, copy it */
		if (fwrite(s,SL,1,fout)!=1)
			goto errout;
		while (1)
		{
		if (fread(s,SL,1,fin)!=1)
		 goto errin;
		if (fwrite(s,SL,1,fout)!=1)
			goto errout;
		n=s[0];
		if (n==0) /* End reached */
			{
			break;
			}

		if (fread(s,SL,1,fin)!=1) /* Hunk num */
		  goto errin;
		if (fwrite(s,SL,1,fout)!=1)
		  goto errout;

		for (i=0;i<n;i++)
			{
			if (fread(s,SL,1,fin)!=1)
    			 goto errin;
    			if (fwrite(s,SL,1,fout)!=1)
	 		 goto errout;			
			}
		}/* of while */
		if (fread(s,SL,1,fin)!=1)
    		  goto errin;
    		continue;
		break;

		case HUNK_RELOC32SHORT: /* Short one */
		num2=0; /* Length */
		while (1)
    		{
    		if (fread(s,SL,1,fin)!=1)
    		 goto errin;
    		if (fwrite(s,SL,1,fout)!=1)
		goto errout;
    		n=s[0];
    		if (n==0) /* End reached */
   			break;
		if (fread(s,SL,1,fin)!=1) /* HUNK NUM*/
      		 goto errin;
      		if (fwrite(s,SL,1,fout)!=1)
    		goto errout;

		num2+=n;
    		for (i=0;i<n;i++)
   			{
    			if (fread(s,sizeof(short int),1,fin)!=1)
       			 goto errin;
       			if (fwrite(s,sizeof(short int),1,fout)!=1)
    	 		 goto errout;			
    			}
    		}/* of while */
		if (num2&1==1) /* odd # of words , adjust */
		 {
		 if (fread(s,sizeof(short int),1,fin)!=1)
 	 	  goto errin;
		  if (fwrite(s,sizeof(short int),1,fout)!=1)
		   goto errout;
		  }
		if (fread(s,SL,1,fin)!=1)
     		  goto errin;
     		continue;
    		break;
		
		default:
			fprintf(stderr,"Unknown HUNK Type %d\n",s[0]);
			exit(1);
		}/* Of switch */
	}/* Of while */
}/* Of StripAHunk */
