/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1990 by MXM
 *
 *	Name .....: DoRevision.c
 *	Created ..: Saturday 27-Jan-90 19:18
 *	Revision .: 0
 *
 *	Date            Author          Comment
 *	=========       ========        ====================
 *	27-Jan-90       Olsen           Created this file!
 *
 * $Revision Header ********************************************************/
 #define REVISION 0

#include <libraries/dosextens.h>
#include <exec/memory.h>
#include <stdio.h>

#define TEMPNAME "T:Revision.temp"

extern struct FileLock	*Lock();
extern void		*AllocMem();

LONG
CmpStr(s,t)
char *s,*t;
{
	register LONG i;

	for(i = 0 ; i < strlen(s) ; i++)
		if(s[i] != t[i])
			return(s[i] - t[i]);

	return(0);
}

char *
GetRealName(s,Protect)
char *s;
long *Protect;
{
	struct FileInfoBlock	*FileInfo;
	struct FileLock		*FileLock;

	static char		 FileName[108];

	if(!(FileLock = (struct FileLock *)Lock(s,ACCESS_READ)))
		return(NULL);

	if(!(FileInfo = (struct FileInfoBlock *)AllocMem((long)sizeof(struct FileInfoBlock),MEMF_PUBLIC)))
	{
		UnLock(FileLock);
		return(NULL);
	}

	if(!Examine(FileLock,FileInfo))
	{
		FreeMem(FileInfo,(long)sizeof(struct FileInfoBlock));
		UnLock(FileLock);
		return(NULL);
	}

	strcpy(FileName,FileInfo -> fib_FileName);

	*Protect = FileInfo -> fib_Protection;

	FreeMem(FileInfo,(long)sizeof(struct FileInfoBlock));
	UnLock(FileLock);

	return(FileName);
}

LONG
Revise(Name,LogMessage)
char *Name,*LogMessage;
{
	char *LineBuff,*FileName;
	long InLine = 0,Revision = 0,SkipNext = FALSE,i,Protect;
	FILE *Rev,*Temp;
	char Year[10],Author[20],Day[20],Time[10],Company[40];
	BOOL Create = TRUE;

	if(!LogMessage)
		LogMessage = "- Empty log message -";

	if(getenv("DATE"))
		strcpy(Year,getenv("DATE"));
	else
		strcpy(Year,"01-01-90");

	if(getenv("DAY"))
		strcpy(Day,getenv("DAY"));

	if(getenv("TIME"))
		strcpy(Time,getenv("TIME"));

	if(getenv("AUTHOR"))
		strcpy(Author,getenv("AUTHOR"));
	else
		strcpy(Author,"- Unknown -");

	if(getenv("COMPANY"))
		strcpy(Company,getenv("COMPANY"));
	else
		strcpy(Company,"???");

	if(!(LineBuff = (char *)AllocMem(256L,MEMF_PUBLIC | MEMF_CLEAR)))
		return;

	if(!(FileName = GetRealName(Name,&Protect)))
	{
		FreeMem(LineBuff,256L);
		return;
	}

	if(!(Temp = fopen(TEMPNAME,"w")))
	{
		FreeMem(LineBuff,256L);
		return;
	}

	if(!(Rev = fopen(Name,"r")))
	{
		fclose(Temp);
		FreeMem(LineBuff,256L);
		return;
	}

	if(!fgets(LineBuff,256,Rev))
	{
		fclose(Temp);
		fclose(Rev);
		FreeMem(LineBuff,256L);
		return;
	}

	fclose(Rev);

	if(!CmpStr("/* $Revision Header *",LineBuff))
		Create = FALSE;

	if(Create)
	{
		fprintf(Temp,"/* $Revision Header *** Header built automatically - do not edit! ***********\n");
		fprintf(Temp," *\n *\t(C) Copyright 19%s by %s\n *\n",Year + 7,Company);

		fprintf(Temp," *\tName .....: %s\n",FileName);
		fprintf(Temp," *\tCreated ..: %s %s %s\n",Day,Year,Time);
		fprintf(Temp," *\tRevision .: 0\n");
		fprintf(Temp," *\n");

		fprintf(Temp," *\tDate            Author          Comment\n");
		fprintf(Temp," *\t=========       ========        ====================\n");

		fprintf(Temp," *\t%s       %-15.15s %s\n",Year,Author,"Created this file!");

		fprintf(Temp," *\n");
		fprintf(Temp," * $Revision Header ********************************************************/\n");
		fprintf(Temp," #define REVISION 0\n\n");
	}

	if(!(Rev = fopen(Name,"r")))
	{
		fclose(Temp);
		FreeMem(LineBuff,256L);
		return;
	}

	for(;;)
	{
		if(!fgets(LineBuff,256,Rev))
			break;

		if(InLine == 6 && !Create)
		{
			Revision = atoi(LineBuff + 15) + 1;
			sprintf(LineBuff," *\tRevision .: %d\n",Revision);
		}

		if(InLine == 10 && !Create)
		{
			char TempBuff[11];

			for(i = 0 ; i < 10 ; i++)
				TempBuff[i] = LineBuff[3 + i];

			TempBuff[9] = 0;

			if(!CmpStr(TempBuff,Year) && (Protect & FIBF_ARCHIVE))
			{
				fclose(Rev);
				fclose(Temp);
				FreeMem(LineBuff,256L);
				DeleteFile(TEMPNAME);

				return;
			}

			fprintf(Temp," *\t%s       %-15.15s %s\n",Year,Author,LogMessage);
		}

		if(SkipNext)
		{
			sprintf(LineBuff," #define REVISION %d\n",Revision);
			SkipNext = FALSE;
		}

		if(!CmpStr(" * $Revision Header *",LineBuff) && InLine)
			SkipNext = TRUE;

		fwrite(LineBuff,strlen(LineBuff),1,Temp);
		InLine++;
	}

	fclose(Temp);
	fclose(Rev);

	if(!(Temp = fopen(TEMPNAME,"r")))
	{
		FreeMem(LineBuff,256L);
		return;
	}

	if(!(Rev = fopen(Name,"w")))
	{
		fclose(Temp);
		DeleteFile(TEMPNAME);

		FreeMem(LineBuff,256L);
		return;
	}

	while((InLine = fgetc(Temp)) != EOF)
		fputc(InLine,Rev);

	fclose(Temp);
	fclose(Rev);

	SetProtection(Name,Protect | FIBF_ARCHIVE);

	DeleteFile(TEMPNAME);

	FreeMem(LineBuff,256L);
}

void
main(argc,argv)
int argc;
char *argv[];
{
	Revise(argv[1],argv[2]);
}
