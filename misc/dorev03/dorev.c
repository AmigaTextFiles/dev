/** DoRev Header ** Do not edit! **
*
* Name             :  dorev.c
* Copyright        :  © Programmatori Amiga Ticino
* Creation date    :  19-Jun-92
* Translator       :  SAS-C 5.10
* Compiler opts.   :  -Li -v -O
*
* Date       Rev  Author               Comment
* ---------  ---  -------------------  ----------------------------------------
* 21-Jun-92    2  David Schweikert     Added Env-variables and bugfix.
* 20-Jun-92    1  David Schweikert     Fixed big bug.
* 19-Jun-92    0  David Schweikert     First version !
*
*** DoRev End **/

/* Priority :
 * 1) Command line.
 * 2) Env variables.
 * 3) Source file
 */

#include <dos/dos.h>
#include <dos/datetime.h>
#include <string.h>

#define TEMP "t:DoRev.temp"
#define TEMPLATE "FILE/A,COP=COPYRIGHT/K,CON=CONTENTS/K,TRA=TRANSLATOR/K,COMPILER_OPTS=OPTS/K,AUT=AUTHOR/K,COM=COMMENT/K,NOENV/S"
#define BUFSIZE 1024

const char *AISG_VERSION = { "$VER: DOREV by David Schweikert 37.03 (20.6.92)" };

struct DosBase *DosBase;

BPTR OutFileHandle,InFileHandle;

long Args[8];
char Line[81];

struct { 
	char Name[58];
	char Copyright[58];
	char CreationDate[10];
	char Contents[58];
	char Translator[58];
	char CompilerOpts[58];
} DoRevGeneric;

struct {
	char Date[10];
	char Rev[4];
	char Author[20];
	char Comment[41];
} DoRevHistory = {
	"",
	"  0",
	"- Unknown -",
	"None."
};

void ReadFile(void);
void ReadCli(void);
void WriteOld(void);
void WriteNew(void);
void WriteDoRev(void);
void ReadEnvs(void);
BOOL StrCmp(char *,char *);
void CloseAll(void);

BOOL DoRevHeader=FALSE;
struct RDArgs           *RArgs = 0L;

void _tinymain(void)
{
	struct DateTime datetime;
	char *filepart;
	char buffer[BUFSIZE];
	LONG tocopy;
	
	if(!(DosBase=(struct DosBase *)OpenLibrary("dos.library",37L))) exit(10);
	
	if(!(RArgs=(struct RDArgs *)ReadArgs(TEMPLATE,Args,0)))
	{
		PutStr("Bad args.\n");
		CloseAll();
		exit(5);
	}

	filepart=(char *)FilePart((char *)Args[0]);
	strcpy(DoRevGeneric.Name,filepart);

	DateStamp(&datetime.dat_Stamp);
	datetime.dat_Format  = FORMAT_DOS;
	datetime.dat_StrDate = DoRevHistory.Date;
	datetime.dat_Flags   = 0;
	datetime.dat_StrDay  = 0;
	datetime.dat_StrTime = 0;
	DateToStr(&datetime);
	
	if(!(OutFileHandle=Open(TEMP,MODE_NEWFILE)))
	{
		PutStr("Can't create temporary file.\n");
		CloseAll();
		exit(5);
	}

	if((InFileHandle=Open(Args[0],MODE_OLDFILE)))	ReadFile();
	
	if(!DoRevHeader)	strcpy(DoRevGeneric.CreationDate,DoRevHistory.Date);
	
	if(Args[7]==0) ReadEnvs();
	ReadCli();

	WriteDoRev();

	if(!DoRevHeader)	WriteNew();
	if(InFileHandle)	WriteOld();

	if(InFileHandle) Close(InFileHandle);

	if(!(InFileHandle=Open(Args[0],MODE_NEWFILE)))
	{
		PutStr("Can't rewrite source file.\n");
		CloseAll();
		exit(5);
	}

	Seek(OutFileHandle,0L,OFFSET_BEGINNING);
	do
	{
		tocopy=Read(OutFileHandle,buffer,BUFSIZE);
		Write(InFileHandle,buffer,tocopy);
	} while(tocopy==BUFSIZE);
	
	Close(OutFileHandle);
	OutFileHandle=0L;
	DeleteFile(TEMP);
	
	CloseAll();
}

void ReadCli(void)
{
	if(strlen((char *)Args[1])!=0) strcpy(DoRevGeneric.Copyright,   (char *)Args[1]);
	if(strlen((char *)Args[2])!=0) strcpy(DoRevGeneric.Contents,    (char *)Args[2]);
	if(strlen((char *)Args[3])!=0) strcpy(DoRevGeneric.Translator,  (char *)Args[3]);
	if(strlen((char *)Args[4])!=0) strcpy(DoRevGeneric.CompilerOpts,(char *)Args[4]);
	if(strlen((char *)Args[5])!=0) strcpy(DoRevHistory.Author,      (char *)Args[5]);
	if(strlen((char *)Args[6])!=0) strcpy(DoRevHistory.Comment,     (char *)Args[6]);
}

void ReadFile(void)
{
	int FillN,ReadN;
	int Rev=0;
	
	FGets(InFileHandle,Line,80);
	if(StrCmp(Line,"/** DoRev Header"))
	{
		DoRevHeader=TRUE;
		FGets(InFileHandle,Line,80);
		do
		{
			FGets(InFileHandle,Line,80);
			
			if(StrCmp(Line,"* Copyright        :"))
			{
				for(FillN=0,ReadN=22;Line[ReadN]!='\n';FillN++,ReadN++)
					DoRevGeneric.Copyright[FillN]=Line[ReadN];
			}
			else if(StrCmp(Line,"* Creation date    :"))
			{
				for(FillN=0,ReadN=22;Line[ReadN]!='\n';FillN++,ReadN++)
					DoRevGeneric.CreationDate[FillN]=Line[ReadN];
			}
			else if(StrCmp(Line,"* Contents         :"))
			{
				for(FillN=0,ReadN=22;Line[ReadN]!='\n';FillN++,ReadN++)
					DoRevGeneric.Contents[FillN]=Line[ReadN];
			}
			else if(StrCmp(Line,"* Translator       :"))
			{
				for(FillN=0,ReadN=22;Line[ReadN]!='\n';FillN++,ReadN++)
					DoRevGeneric.Translator[FillN]=Line[ReadN];
			}
			else if(StrCmp(Line,"* Compiler opts.   :"))
			{
				for(FillN=0,ReadN=22;Line[ReadN]!='\n';FillN++,ReadN++)
					DoRevGeneric.CompilerOpts[FillN]=Line[ReadN];
			}
		} while(Line[1]==' ' && isalpha(Line[2]));
		
		FGets(InFileHandle,Line,80); // "Date...Rev...Author...Comment"
		FGets(InFileHandle,Line,80); // "----   ---   ------   -------"
		FGets(InFileHandle,Line,80);
		
		for(ReadN=13;ReadN<16;ReadN++)
		{
			if(isdigit(Line[ReadN]))	Rev=Rev*10+Line[ReadN]-48;
		}
		sprintf(DoRevHistory.Rev,"%3ld",Rev+1);
		
		for(FillN=0,ReadN=18;FillN<19 ;FillN++,ReadN++)
			DoRevHistory.Author[FillN]=Line[ReadN];
		Seek(InFileHandle,-strlen(Line),OFFSET_CURRENT);
	}
	else	Seek(InFileHandle,0L,OFFSET_BEGINNING);
}

void WriteDoRev(void)
{
	FPuts(OutFileHandle,"/** DoRev Header ** Do not edit! **\n");
	FPuts(OutFileHandle,"*\n");
	FPrintf(OutFileHandle,"* Name             :  %s\n",DoRevGeneric.Name);
	if(strlen(DoRevGeneric.Copyright)!=0)
		FPrintf(OutFileHandle,"* Copyright        :  %s\n",DoRevGeneric.Copyright);
	FPrintf(OutFileHandle,"* Creation date    :  %s\n",DoRevGeneric.CreationDate);
	if(strlen(DoRevGeneric.Contents)!=0)
	FPrintf(OutFileHandle,"* Contents         :  %s\n",DoRevGeneric.Contents);
	if(strlen(DoRevGeneric.Translator)!=0)
	FPrintf(OutFileHandle,"* Translator       :  %s\n",DoRevGeneric.Translator);
	if(strlen(DoRevGeneric.CompilerOpts)!=0)
	FPrintf(OutFileHandle,"* Compiler opts.   :  %s\n",DoRevGeneric.CompilerOpts);
	FPuts(OutFileHandle,"*\n");
	FPuts(OutFileHandle,"* Date       Rev  Author               Comment\n");
	FPuts(OutFileHandle,"* ---------  ---  -------------------  ----------------------------------------\n");
	FPrintf(OutFileHandle,"* %9s  %3s  %-19s  %-.40s\n",DoRevHistory.Date,DoRevHistory.Rev,
		DoRevHistory.Author,DoRevHistory.Comment);
}

void WriteOld(void)
{
	char c;
	
	do
	{
		c=FGetC(InFileHandle);
		if(c!=-1)	FPutC(OutFileHandle,c);
	} while(c!=-1);
}

void WriteNew(void)
{
	FPuts(OutFileHandle,"*\n");
	FPuts(OutFileHandle,"*** DoRev End **/\n\n");
}

BOOL StrCmp(char *String1,char *String2)
{
	if(strncmp(String1,String2,strlen(String2))==0) return(TRUE);
	return(FALSE);
}

void ReadEnvs(void)	// New to revision 2.
{
	GetVar("Copyright" ,  DoRevGeneric.Copyright,58,NULL);
	GetVar("Translator",  DoRevGeneric.Translator,58,NULL);
	GetVar("CompilerOpts",DoRevGeneric.CompilerOpts,58,NULL);
	GetVar("Author",      DoRevHistory.Author,20,NULL);
}

void CloseAll(void)
{
	if(InFileHandle) Close(InFileHandle);
	if(OutFileHandle) Close(OutFileHandle);
	if(RArgs) FreeArgs(RArgs);
	CloseLibrary(DosBase);
}