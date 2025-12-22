
/* main.c
 *
 * Create man pages from autodocs
 * by Mark Papadakis, markp@palamida.math.uch.r
 * http://palamida.math.uch.gr/markp
 *
 * -- Changes --
 * 10.06.97  : Minor update, bug fixes
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>
#include <proto/dos.h>
#include <dos/dos.h>

#define VERSION "1.2"
const UBYTE Version[] = "$VER: makeman "VERSION" by MarkP (10.06.97)\n\n";
BOOL checkFileName(char *fn)
{
    // see if its good enough
    while(*fn)
    {
	if(*fn=='>' || *fn=='-' || *fn=='*' || *fn==0x27)
	    return(0);
	 fn++;
    }

    return(1);
}

int main(int argc, char *argv[])
{
    char buf[1024];
    LONG numOfPages = 0;
    LONG numOfDocs  = 0;
    BPTR srcFile = NULL;
    FILE *dstFile = NULL;
    BPTR fileLock = NULL;
    char ManPage[256];
    char fullFileName[256];
    struct FileInfoBlock *fileInfo = NULL;
    register char *pos = NULL;
    int InDoc = 0;
    BPTR tmpLock = NULL;

    char SDir[256]; // The source directory, where the autodocs files are held(default is ADocs: )
    char DDir[256]; // the destination dir for the man pages(default is ManDir: )

    if(argc==2)
    {
	if(argv[1][0]=='?')
	{
	    printf("manmake version "VERSION" by MarkP(Mark Papadakis)\n");
	    printf("Create manpages from autodoc entries.\n");
	    printf("Usage : manmake [adocs dir] [manpages dir].\n");
	    printf("Defaults  -  adocs dir=ADocs: manpages dir=ManDir:\n");
	    printf("Read the docs for more info.\n");
	    exit(0);
	}
    }

    if(argc>=2)
	strcpy(SDir,argv[1]);
    else
	strcpy(SDir, "ADocs:");
    if(argc>=3)
	strcpy(DDir, argv[2]);
    else
	strcpy(DDir, "ManDir:");

    // Append a '/' if necessary
    {
	int l = strlen(SDir);
	if(SDir[l-1]!=':' && SDir[l-1]!='/')
	    strcat(SDir,"/");
	l = strlen(DDir);
	if(DDir[l-1]!=':' && DDir[l-1]!='/')
	    strcat(DDir,"/");
    }


    fileLock = Lock(SDir,ACCESS_READ);
    if(!fileLock)
    {
	printf("Unable to access '%s'\n",SDir);
	exit(1L);
    }
    if(!(fileInfo = AllocDosObject(DOS_FIB, NULL)))
    {
	UnLock(fileLock);
	printf("Not enough mem(1)\n");
	exit(1L);
    }
    Examine(fileLock, fileInfo);
    while(ExNext(fileLock, fileInfo))
    {
	if(fileInfo -> fib_DirEntryType<=0) // file
	{
	    sprintf(fullFileName,"%s%s", SDir,fileInfo -> fib_FileName);
	    if(fileInfo->fib_Size<=80)
	    {
		printf("File \"%s\" is too small for an autodoc file.\n",fullFileName);
		continue; 
	    }
	    // Access it now
	    if(!(srcFile = Open(fullFileName, MODE_OLDFILE)))
	    {
		printf("Unable to access(read) file \"%s\".\n",fullFileName);
		FreeDosObject(DOS_FIB, fileInfo);
		UnLock(fileLock);
		exit(1L);
	    }
	    printf("Processing %s..\n", fullFileName);
	    numOfDocs++;
	    // read it
	    while(FGets(srcFile, buf, 1023))
	    {
		char fullName[256];
		pos = buf;
		if(!InDoc)
		{
		// we need something xxxx.library/function      xxxx.library/function
		if(sscanf(pos, "%s", fullName)==1) //  && pos[1]>32)
		{
		    pos+=strlen(fullName)+1;
		    if(strstr(pos,fullName) && strchr(fullName,'.')!=0 && strchr(fullName, '/')!=0 && checkFileName(fullName)==1)
		    {
			// we found one
			pos = fullName;
			while(*pos!='/')
			    pos++;
			pos++;
			sprintf(ManPage,"%s%s", DDir, pos);
			tmpLock = Lock(ManPage, ACCESS_READ);
			if(tmpLock)
			{
			    UnLock(tmpLock);
			    tmpLock = NULL;
			    continue;
			}
			InDoc = 1;
			if(!(dstFile = fopen(ManPage,"w")))
			{
			    printf("Unable to access(write) file %s.\n", ManPage);
			    Close(srcFile);
			    FreeDosObject(DOS_FIB, fileInfo);
			    UnLock(fileLock);
			    exit(1L);
			}
			numOfPages++;
			fprintf(dstFile, "From file : %s\n", fullFileName);  // write header
			FGets(srcFile, buf, 1023);
		    }
		}
		pos = buf;
		}// END (!InDoc)
		pos = buf;

		if(InDoc)
		{
		    // look for the special character
		    if(*pos==0x0C)
		    {
			InDoc = 0;
			fclose(dstFile);

		    }
	       }// END InDoc
	       if(InDoc)
		   fprintf(dstFile,"%s", buf);
	    }
	    Close(srcFile);
	}
    }
    FreeDosObject(DOS_FIB, fileInfo);
    UnLock(fileLock);
    printf("**ALL DONE**\n");
    printf("%d documents searched, %ld man pages created.\n", numOfDocs, numOfPages);
}
