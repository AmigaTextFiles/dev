#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <exec/types.h>
#include <dos.h>
#include <proto/exec.h>
#include <proto/dos.h>

BPTR ZeFile,OutFile;
LONG LastErr,LastRead;
char FileName[80];
LONG HunkCount,FirstHunk,LastHunk;
char BufName[80];
struct HunkInfo {
	int pos_data;
	int size_data;
	LONG type;
	BOOL HaveReloc;
	};
struct HunkInfo *ExecInfo;
BOOL NoReloc;

LONG GetLong(BPTR);
BOOL ValidType(LONG);
void SkipHunk(BPTR);

LONG GetLong(fi)
BPTR fi;
{
	static LONG res;

	Read(fi,&res,sizeof(LONG));
	return(res);
}

BOOL ValidType(typ)
LONG typ;
{
	register BOOL res;
	register LONG inttyp;

	inttyp=typ & 0xfff;
	if ((inttyp==0x3e9)||(inttyp==0x3ea)||(inttyp==0x3eb))
		res=TRUE;
	else
		res=FALSE;
	return(res);
}

void SkipHunk(fi)
BPTR(fi);
{
	register int length;

	length=GetLong(fi);
	if (Seek(fi,(length*4),OFFSET_CURRENT)==-1)
	{
		printf("Unexpected end of file... terminating\n");
		exit(0);
	};
}

main(argc,argv)
int argc;
char *argv[];
{
	register int i,j;

	printf("\033[1;31;40\155HunkAnalyzer\033[0;31;40\155\n\
Analyze hunk structure of an executable\n\
Save out a stripped version of the executable if possible\n\
By TLC from CHRYSEIS in December '92\n");
	if (argc!=2)
	{
		printf("Usage: HunkAnalyze executable_file\n");
		exit(0);
	};

	strcpy(FileName,argv[1]);

	if ((ZeFile=(BPTR)Open(FileName,MODE_OLDFILE))==NULL)
	{
		LastErr=IoErr();
		printf("Unable to open %s : DOS error %ld\n",FileName,LastErr);
		exit(0);
	};

	if (GetLong(ZeFile)!=0x000003f3)
	{
		printf("%s is not an executable\n",FileName);
		Close(ZeFile);
		exit(0);
	};

	LastRead=GetLong(ZeFile);
	HunkCount=0;
	while (LastRead!=0)
	{
		Read(ZeFile,BufName,(LastRead*4));
		BufName[(LastRead*4)+1]=0;
		printf("Hunk %d : %s\n",HunkCount,BufName);
		LastRead=GetLong(ZeFile);
		HunkCount++;
	};

	HunkCount=GetLong(ZeFile);
	FirstHunk=GetLong(ZeFile);
	LastHunk=GetLong(ZeFile);
	printf("\nNombre de Hunks : %ld (%ld->%ld)\n"\
                         ,HunkCount,FirstHunk,LastHunk);

	ExecInfo=(struct HunkInfo *)calloc(HunkCount,sizeof(struct HunkInfo));

	for (i=0;i<HunkCount;i++)
		ExecInfo[i].size_data=GetLong(ZeFile);

	NoReloc=TRUE;

	j=GetLong(ZeFile);
	for (i=0;i<HunkCount;i++)
	{
		while (j==0x000003f1)
		{
			SkipHunk(ZeFile);
			j=GetLong(ZeFile);
		};
		if (ValidType(j)==FALSE)
		{
			printf("Error : hunk %d : hunk is not valid (should be CODE, DATA or BSS)\n",i);
			Close(ZeFile);
			exit(0);
		};
		ExecInfo[i].type=j;
		ExecInfo[i].size_data=GetLong(ZeFile);
		ExecInfo[i].pos_data=Seek(ZeFile,0,OFFSET_CURRENT);
		ExecInfo[i].HaveReloc=FALSE;
		if ((j & 0xfff)!=0x3eb)
			Seek(ZeFile,(ExecInfo[i].size_data)*4,OFFSET_CURRENT);
		j=GetLong(ZeFile);
		while (j!=0x000003f2)
		{
			if ((j==0x000003ec)||(j==0x000003ed)||(j==0x000003ee))
			{
				NoReloc=FALSE;
				ExecInfo[i].HaveReloc=TRUE;
			};
			SkipHunk(ZeFile);
			j=GetLong(ZeFile);
		};
		j=GetLong(ZeFile);
	};

	printf("Hunk # |  size  | position |   type   | position independant\n");
	printf("-------+--------+----------+----------+---------------------\n");
	for (i=0;i<HunkCount;i++)
		printf("  %3d  | %6d | %8d | %08X |       %s\n",\
			i,\
			ExecInfo[i].size_data*4,\
			ExecInfo[i].pos_data,\
			ExecInfo[i].type,\
			(ExecInfo[i].HaveReloc==TRUE?"No":"Yes"));

	if (NoReloc==FALSE)
		printf("Unable to create raw datas : some hunks are relocatable\n");

	if (HunkCount>1)
		printf("Unable to create raw datas : there is more than one hunk\n");

	if ((NoReloc==TRUE) && (HunkCount==1))
	{
		strcat(FileName,".RawCode");
		printf("Saving raw 68000 code as %s\n",FileName);
		if ((OutFile=Open(FileName,MODE_NEWFILE))!=NULL)
		{
			Seek(ZeFile,ExecInfo[0].pos_data,OFFSET_BEGINNING);
			for (i=0;i<ExecInfo[0].size_data;i++)
			{
				LastRead=GetLong(ZeFile);
				Write(OutFile,&LastRead,sizeof(LONG));
			};
			Close(OutFile);
		}
		else
			printf("Unable to open the output file\n");
	};

	Close(ZeFile);
	return(0);
}