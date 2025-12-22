#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <exec/memory.h>
#include <string.h>
#include <stdlib.h>

#include "Tools.h"

struct MemNode
{
	struct MemNode *child;		/* Next block in list        */

	char	*File;				/* File that allocated us    */
	ULONG	Line;				/* Line we were allocated on */

	ULONG	size;				/* Size of memory block      */
};

struct FileNode
{
	struct FileNode *child;		/* Next block in list        */

	char	*File;				/* File that opened file     */
	ULONG	Line;				/* Line we were opened file  */

	BOOL	amigafile;			/* It is an amiga file       */
	char	*filename;			/* The filename of the file  */

	union
	{
		BPTR	afile;			/* amiga descriptor file     */
		FILE	*cfile;			/* c descriptor file         */
	} file_desc;
};

static struct MemNode	*memhead  = NULL;
static ULONG 			Total_RAM = 0;
static ULONG 			Max_RAM = 0;
static struct FileNode	*filehead = NULL;

static void 			*Data_f = NULL;
static TypeQuitFunction Quit_f = NULL;	/* Function called if an error occured	*/
									/* cf SetFunctionQuit and safe_Quit		*/

/****************************************************************************************************************/
/****																										 ****/
/**											DisplayMsg														   **/
/****																										 ****/
/****************************************************************************************************************/

void DisplayMsg(char *Msg)
{
	struct EasyStruct RequestMsg =
	{
		sizeof(struct EasyStruct),
		0,
		"GenCode C Error",
		"%s",
		"OK"
	};

	EasyRequest(NULL,&RequestMsg,NULL,(long)Msg);
}

/****************************************************************************************************************/
/****																										 ****/
/**											safe_Quit														   **/
/****																										 ****/
/****************************************************************************************************************/

static void safe_Quit(void)
{
	if (Quit_f)
	{
		(*Quit_f)(Data_f);
	}
	else
	{
		DisplayMsg("Oups!!! There is no Quit function.\nReport this bug to the authors");
		/* Try to quit properly */
		CloseAllFiles(TRUE);
		ClearMemory(TRUE);
		exit(20);
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											SetFunctionQuit													   **/
/****																										 ****/
/****************************************************************************************************************/

TypeQuitFunction SetFunctionQuit(TypeQuitFunction Quit_function)
{
	TypeQuitFunction	quit_f = Quit_f;

	Quit_f = Quit_function;

	return quit_f;
}

/****************************************************************************************************************/
/****																										 ****/
/**											SetDataQuit														   **/
/****																										 ****/
/****************************************************************************************************************/

void *SetDataQuit(void *Data)
{
	void	*data_f = Data_f;

	Data_f = Data;

	return data_f;
}

/****************************************************************************************************************/
/****																										 ****/
/**											safe_AllocMemory												   **/
/****																										 ****/
/****************************************************************************************************************/

void *safe_AllocMemory(ULONG byteSize,BOOL quit,char *File,ULONG Line)
{
	static char msg[150];
	struct MemNode *t;

    if (memhead)
		t = memhead;
	else
		t = NULL;

	if (!(memhead = AllocMem(byteSize + sizeof(struct MemNode),MEMF_CLEAR)))
	{
		sprintf(msg,"ERROR !!!!! NOT ENOUGH MEMORY !!!\nCan't allocate %ld bytes\nFile %s Line %ld",byteSize,File,Line);
		DisplayMsg(msg);
		memhead = t;
		if (!quit)
			return NULL;
		else
			safe_Quit();
	}

	memhead->child = t;
	memhead->File = File;
	memhead->Line = Line;
	memhead->size = byteSize;
	Total_RAM += byteSize+sizeof(struct MemNode);
	Max_RAM = (Max_RAM>Total_RAM) ? Max_RAM : Total_RAM;

	return ((void *)((ULONG)memhead + sizeof(struct MemNode)));
}

/****************************************************************************************************************/
/****																										 ****/
/**											safe_FreeMemory													   **/
/****																										 ****/
/****************************************************************************************************************/

void safe_FreeMemory(void *ptr,char* File,ULONG Line)
{
	static char msg[100];
	struct MemNode *t1,*t2;

	if (ptr == NULL)
		return;

	t1 = memhead;
	t2 = NULL;

	while(t1)
	{
		if((ULONG)ptr == (ULONG)t1 + sizeof(struct MemNode))
		{
			if(t2)
				t2->child = t1->child; /* Remove block from the list */
			else
				memhead = t1->child;

			Total_RAM -= t1->size+sizeof(struct MemNode);
			FreeMem(t1,t1->size+sizeof(struct MemNode));
			return;
		}
		t2 = t1;
		t1 = t1->child;
  	}

	sprintf(msg,"%s %ld: Free twice (?) FreeMem($%lx)",File,Line,(ULONG)ptr - sizeof(struct MemNode));
	DisplayMsg(msg);
	safe_ShowMemory(File,Line);
}

/****************************************************************************************************************/
/****																										 ****/
/**											safe_ShowMemory													   **/
/****																										 ****/
/****************************************************************************************************************/

void safe_ShowMemory(char* File,ULONG Line)
{
	struct MemNode *t;
	BPTR con;

	if(memhead)
	{
		if (!(con = Open("CON:0/10/400/100/ShowMemory .../AUTO/CLOSE/WAIT/INACTIVE",MODE_NEWFILE)))
		{
			DisplayMsg("Can't open ShowMemory Window !!!");
			return;
		}

		t = memhead;
		FPrintf(con, "%s %ld: Memory List\n", (long)File, Line);

		FPrintf(con,"    %-12s %-12s %-16s %-4s\n",(long)"Address", (long)"Size", (long)"File", (long)"Line");
		FPrintf(con,"    %-12s %-12s %-16s %-4s\n",(long)"-------", (long)"----", (long)"----", (long)"----");

		while(t)
		{
			FPrintf(con,"    $%-11lx %-12ld %-16s %-4ld\n",(long)t,t->size,(long)t->File,t->Line);
			t = t->child;
    	}
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											safe_ClearMemory												   **/
/****																										 ****/
/****************************************************************************************************************/

void safe_ClearMemory(BOOL Quiet,char* File,ULONG Line)
{
	static char msg[210];
	struct MemNode *t1, *t2;
	#ifdef DEBUG
	static char ram[100];
	#endif

	#ifdef DEBUG
	sprintf(ram,"Total Ram used : %ld\nTotal RAM max used : %ld",Total_RAM,Max_RAM);
	DisplayMsg(ram);
	#endif

	if(memhead)
	{
		t1 = memhead;
		if (!Quiet)
		{
			safe_ShowMemory(File,Line);
			sprintf(msg, "Oups !! there is a BUG (a memory allocation problem)\nPlease report this bug to GenCode's Authors\nwith the next parameters (in ShowMemory Window)\n%s %ld: Freeing Memory List", File, Line);
			DisplayMsg(msg);
		}

		while(t1)
		{
			t2 = t1->child;
			FreeMem(t1,t1->size+sizeof(struct MemNode));
			t1 = t2;
		}
	}

	memhead = NULL;
}

/****************************************************************************************************************/
/****																										 ****/
/**											OpenFile														   **/
/****																										 ****/
/****************************************************************************************************************/

BPTR safe_OpenFile( char *filename, LONG mode, BOOL quit, char *File, ULONG Line)
{
	struct	FileNode *t;
	BPTR	file;

    if (filehead)
		t = filehead;
	else
		t = NULL;

	if (!(file = Open(filename,mode)))
	{
		if (quit)
		{
			char	*msg;
		
			msg = AllocMemory(12+strlen(filename)+1,TRUE);
			sprintf(msg,"Can't open %s\n",filename);
			DisplayMsg(msg);
			FreeMemory(msg);
			safe_Quit();
		}
		else
			return NULL;
	}

	if (!(filehead = AllocMemory(sizeof(struct FileNode),FALSE)))
	{
		filehead = t;
		Close(file);

		if (quit)
			safe_Quit();
		else
			return NULL;
	}
	
	filehead->child = t;
	filehead->File = File;
	filehead->Line = Line;
	filehead->amigafile = TRUE;
	if (!(filehead->filename = AllocMemory(strlen(filename)+1,FALSE)))
	{
		FreeMemory(filehead);
		filehead = t;		
		Close(file);

		if (quit)
			safe_Quit();
		else
			return NULL;
	}
	strcpy(filehead->filename,filename);
	filehead->file_desc.afile = file;

	return file;
}

/****************************************************************************************************************/
/****																										 ****/
/**											CloseFile														   **/
/****																										 ****/
/****************************************************************************************************************/

BOOL safe_CloseFile(BPTR file, char *File, ULONG Line)
{
	static char			msg[150];
	struct FileNode	*t1,*t2;

	if (file == NULL)
		return TRUE;

	t1 = filehead;
	t2 = NULL;

	while(t1)
	{
		if (file == t1->file_desc.afile)
		{
			if(t2)
				t2->child = t1->child; /* Remove block from the list */
			else
				filehead = t1->child;
				
			if (!Close(file))
			{
				char	*msg;
		
				if (!(msg=AllocMemory(13+strlen(t1->filename)+1,FALSE)))
				{
					FreeMemory(t1->filename);
					FreeMemory(t1);
					return FALSE;
				}

				sprintf(msg,"Can't close %s\n",t1->filename);
				DisplayMsg(msg);
				FreeMemory(msg);
				FreeMemory(t1->filename);
				FreeMemory(t1);
				return FALSE;
			}

			FreeMemory(t1->filename);
			FreeMemory(t1);
			return TRUE;
		}

		t2 = t1;
		t1 = t1->child;
  	}

	sprintf(msg,"The file that you want to close\nin file %s line %ld\nwas not opened or is already closed",File,Line);
	DisplayMsg(msg);
	
	return FALSE;
}

/****************************************************************************************************************/
/****																										 ****/
/**											fopenFile														   **/
/****																										 ****/
/****************************************************************************************************************/

FILE *safe_fopenFile(char *filename, char *mode, BOOL quit, char *File, ULONG Line)
{
	struct	FileNode *t;
	FILE	*file;

    if (filehead)
		t = filehead;
	else
		t = NULL;

	if (!(file = fopen(filename,mode)))
	{
		if (quit)
		{
			char	*msg;
		
			msg = AllocMemory(12+strlen(filename)+1,TRUE);
			sprintf(msg,"Can't open %s\n",filename);
			DisplayMsg(msg);
			FreeMemory(msg);
			safe_Quit();
		}
		else
			return NULL;
	}

	if (!(filehead = AllocMemory(sizeof(struct FileNode),FALSE)))
	{
		filehead = t;
		fclose(file);

		if (quit)
			safe_Quit();
		else
			return NULL;
	}
	
	filehead->child = t;
	filehead->File = File;
	filehead->Line = Line;
	filehead->amigafile = TRUE;
	if (!(filehead->filename = AllocMemory(strlen(filename)+1,FALSE)))
	{
		FreeMemory(filehead);
		filehead = t;		
		fclose(file);

		if (quit)
			safe_Quit();
		else
			return NULL;
	}	
	strcpy(filehead->filename,filename);
	filehead->file_desc.cfile = file;

	return file;
}

/****************************************************************************************************************/
/****																										 ****/
/**											fcloseFile														   **/
/****																										 ****/
/****************************************************************************************************************/

int safe_fcloseFile(FILE *file, char *File, ULONG Line)
{
	static char			msg[150];
	struct FileNode	*t1,*t2;

	if (file == NULL)
		return 0;

	t1 = filehead;
	t2 = NULL;

	while(t1)
	{
		if (file == t1->file_desc.cfile)
		{
			int	ret;
			
			if(t2)
				t2->child = t1->child; /* Remove block from the list */
			else
				filehead = t1->child;

			if (ret = fclose(file))
			{
				char	*msg;

				if (!(msg = AllocMemory(13+strlen(t1->filename)+1,FALSE)))
				{
					FreeMemory(t1->filename);
					FreeMemory(t1);
					return ret;
				}

				sprintf(msg,"Can't close %s\n",file);
				DisplayMsg(msg);
				FreeMemory(msg);
				FreeMemory(t1->filename);
				FreeMemory(t1);
				return ret;
			}
			FreeMemory(t1->filename);
			FreeMemory(t1);
			return 0;
		}

		t2 = t1;
		t1 = t1->child;
  	}

	sprintf(msg,"The file that you want to close\nin file %s line %ld\nwas not opened or is already closed",File,Line);
	DisplayMsg(msg);
	
	return 1;
}

/****************************************************************************************************************/
/****																										 ****/
/**											ShowAllFiles													   **/
/****																										 ****/
/****************************************************************************************************************/

void safe_ShowAllFiles(char *File, ULONG Line)
{
	struct FileNode *t;
	BPTR con;

	if(filehead)
	{
		if (!(con = Open("CON:0/10/400/100/ShowAllFiles .../AUTO/CLOSE/WAIT/INACTIVE",MODE_NEWFILE)))
		{
			DisplayMsg("Can't open ShowAllFiles Window !!!");
			return;
		}

		t = filehead;
		FPrintf(con, "%s %ld: Files List\n", (long)File, Line);

		FPrintf(con,"    %-16s %-4s %-16s\n", (long)"File", (long)"Line", (long)"Filename");
		FPrintf(con,"    %-16s %-4s %-16s\n", (long)"----", (long)"----", (long)"--------");

		while(t)
		{
			FPrintf(con,"    %-16s %-4ld %-16s\n",(long)t->File,t->Line,(long)t->filename);
			t = t->child;
    	}
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											CloseAllFiles													   **/
/****																										 ****/
/****************************************************************************************************************/

void safe_CloseAllFiles(BOOL Quiet,char *File, ULONG Line)
{
	static char msg[210];
	struct FileNode *t1, *t2;

	if(filehead)
	{
		t1 = filehead;
		if (!Quiet)
		{
			sprintf(msg, "Oups !! there is a BUG (a file problem)\nPlease report this bug to GenCode's Authors\nwith the next parameters (in ShowAllFiles Window)\n%s %ld: Closing Files List", File, Line);
			DisplayMsg(msg);
			safe_ShowAllFiles(File,Line);
		}

		while(t1)
		{
			t2 = t1->child;
			(t1->amigafile) ? Close(t1->file_desc.afile) : fclose(t1->file_desc.cfile);
			FreeMemory(t1->filename);
			FreeMemory(t1);
			t1 = t2;
		}
	}

	filehead = NULL;
}

/****************************************************************************************************************/
/****																										 ****/
/**											CopyBlock														   **/
/****																										 ****/
/****************************************************************************************************************/

char *CopyBlock(FILE *file,char *Filechar,char *String,
				char *begin,char *end,
				char *MsgErrorBegin,char *MsgErrorEnd,
				char *MainFile)
{
	char ctmp;
	char *str,*str1;

	if (!(str = strstr(String,begin)))
	{
		char *msg;

		msg = (char *)AllocMemory(80+strlen(MsgErrorBegin)+strlen(MainFile),TRUE);
		sprintf(msg,"Can't find the next line in old file %s !!! :\n \"%s\"",MainFile,MsgErrorBegin);
		DisplayMsg(msg);
		FreeMemory(msg);
		fcloseFile(file);
		FreeMemory(Filechar);
		safe_Quit();
	}
	if (end)
	{
		if (!(str1 = strstr(str,end)))
		{
			char *msg;

			msg = (char *)AllocMemory(80+strlen(MsgErrorEnd)+strlen(MainFile),TRUE);
			sprintf(msg,"Can't find the next line in old file %s !!! :\n \"%s\"",MainFile,MsgErrorEnd);
			DisplayMsg(msg);
			FreeMemory(msg);
			fcloseFile(file);
			FreeMemory(Filechar);
			safe_Quit();
		}
		ctmp=*str1;
		*str1='\0';
		fprintf(file,"%s",str+strlen(begin));
		*str1=ctmp;
		return str1;
	}
	else
	{
		fprintf(file,"%s",str+strlen(begin));
		return NULL;
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											Indent															   **/
/****																										 ****/
/****************************************************************************************************************/

void Indent(FILE *file,int nb)
{
	int     i;

	for(i=0;i<nb;i++)
		fprintf(file, "\t");
}

/****************************************************************************************************************/
/****																										 ****/
/**											extract_dir														   **/
/****																										 ****/
/****************************************************************************************************************/

void extract_dir( char *filename )
{
	if (*filename)
	{
		filename=PathPart(filename);
		*filename='\0';
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											extract_file													   **/
/****																										 ****/
/****************************************************************************************************************/

void extract_file( char * path, char * filename )
{
	strcpy(filename,FilePart(path));
}

/****************************************************************************************************************/
/****																										 ****/
/**											add_extend														   **/
/****																										 ****/
/****************************************************************************************************************/

void add_extend( char *filename, char * extend )
{
	strcat(filename,extend);
}

/****************************************************************************************************************/
/****																										 ****/
/**											remove_extend													   **/
/****																										 ****/
/****************************************************************************************************************/

void remove_extend( char *filename )
{
	char *aux;

	aux = strrchr(FilePart(filename),'.');
	if (aux) *aux='\0';
}

/****************************************************************************************************************/
/****																										 ****/
/**											change_extend													   **/
/****																										 ****/
/****************************************************************************************************************/

void change_extend( char *filename, char * extend )
{
	remove_extend(filename);
	add_extend(filename,extend);
}

/****************************************************************************************************************/
/****																										 ****/
/**											LoadFileInRam													   **/
/****																										 ****/
/****************************************************************************************************************/

/* Read a file and load it in memory */
char * LoadFileInRAM(char *file,BOOL quit)
{
	BPTR					TMPfile;
	struct FileInfoBlock	*Info;
	char					*adr_file = NULL;
	int						size;

	if (TMPfile = OpenFile(file, MODE_OLDFILE, quit))
	{
		Info = AllocMemory(sizeof(struct FileInfoBlock),TRUE);
		ExamineFH(TMPfile, Info);
		size = Info->fib_Size; 
		FreeMemory(Info);
		if (!(adr_file = AllocMemory(size+1,quit)))
		{
			CloseFile(TMPfile);
			return NULL;
		}
		FRead( TMPfile, adr_file, size, 1);
		adr_file[size] = '\0';
		CloseFile(TMPfile);
		return adr_file;
	}
	else
	{
		return NULL;
	}
}

/****************************************************************************************************************/
/****																										 ****/
/**											GetCurrentDirectory												   **/
/****																										 ****/
/****************************************************************************************************************/

char *GetCurrentDirectory(void)
{
	BPTR 	lock;
	UWORD 	len 				= 512;
	char 	*CurrentDirectory 	= NULL;

	if (!(lock = Lock("PROGDIR:",ACCESS_READ)))
	{
		DisplayMsg("ERROR !!!!! CAN'T OBTAIN A LOCK TO THE CURRENT DIRECTORY !!!\n");
		safe_Quit();
	}
	do
	{
		if (CurrentDirectory)
			FreeMemory(CurrentDirectory);
		if (!(CurrentDirectory = AllocMemory(len+1,FALSE)))
		{
			UnLock(lock);
			safe_Quit();
		}
		NameFromLock(lock,CurrentDirectory,len);
		len*=2;
	}while(IoErr()==ERROR_LINE_TOO_LONG);
	UnLock(lock);
	return CurrentDirectory;
}

/****************************************************************************************************************/
/****																										 ****/
/**											CopyFile														   **/
/****																										 ****/
/****************************************************************************************************************/
BOOL CopyFile(char *FromFile,char *ToFile)
{
	char					*buff;
	char					*msg;
	BPTR					File;
	struct FileInfoBlock	*Info;
	int						size;

	if (!(File = OpenFile(FromFile,MODE_OLDFILE, FALSE)))
	{
		return FALSE;
	}
	Info = AllocMemory(sizeof(struct FileInfoBlock),TRUE);
	ExamineFH(File, Info);
	size = Info->fib_Size; 
	FreeMemory(Info);
	if (!(buff = AllocMemory(size,FALSE)))
	{
		CloseFile(File);
		return FALSE;
	}
	FRead(File,buff,size,1);
	CloseFile(File);

	if (!(File = OpenFile(ToFile,MODE_NEWFILE,FALSE)))
	{
		if (!(msg = AllocMemory(strlen(ToFile)+1+13,FALSE)))
		{
			return FALSE;
		}
		sprintf(msg,"Can't write \"%s\"",ToFile);
		DisplayMsg(msg);
		FreeMemory(msg);
		return FALSE;
	}
	FWrite(File,buff,size,1);
	FreeMemory(buff);
	CloseFile(File);
	return TRUE;
}
