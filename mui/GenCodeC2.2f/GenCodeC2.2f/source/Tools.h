#include <exec/types.h>
#include <dos/dos.h>
#include <stdio.h>

#define AllocMemory(s,q)	safe_AllocMemory((s),(q), __FILE__, __LINE__)
#define FreeMemory(p)		safe_FreeMemory((p), __FILE__, __LINE__)
#define ShowMemory() 		safe_ShowMemory(__FILE__, __LINE__)
#define ClearMemory(q) 		safe_ClearMemory((q),__FILE__, __LINE__)
void *safe_AllocMemory(ULONG byteSize,BOOL quit,char *File,ULONG Line);
void safe_FreeMemory(void* ptr,char *File,ULONG Line);
void safe_ShowMemory(char *File,ULONG Line);
void safe_ClearMemory(BOOL Quiet,char *File,ULONG Line);

typedef void (*TypeQuitFunction)(void *);
TypeQuitFunction SetFunctionQuit(TypeQuitFunction Quit_function);
void *SetDataQuit( void *Data);
void DisplayMsg(char *Msg);
char *CopyBlock(FILE *file,char *adr_file, char *String,
				char *begin,char *end,
				char *MsgErrorBegin,char *MsgErrorEnd,
				char *MainFile);
void Indent(FILE *file,int nb);
void extract_dir( char *filename );
void extract_file( char *path ,char *filename );
void add_extend( char *filename, char *extend );
void remove_extend( char *filename );
void change_extend( char *filename, char *extend );

#define OpenFile(f,m,q) 	safe_OpenFile((f),(m),(q),__FILE__, __LINE__)
#define CloseFile(f) 		safe_CloseFile((f),__FILE__, __LINE__)
#define fopenFile(f,m,q)	safe_fopenFile((f),(m),(q),__FILE__, __LINE__)
#define fcloseFile(f) 		safe_fcloseFile((f),__FILE__, __LINE__)
#define ShowAllFiles() 		safe_ShowAllFiles(__FILE__, __LINE__)
#define CloseAllFiles(q)	safe_CloseAllFiles((q),__FILE__, __LINE__)
BPTR safe_OpenFile(char *filename, LONG mode,BOOL quit,char *File,ULONG Line);
BOOL safe_CloseFile(BPTR file,char *File,ULONG Line);
FILE *safe_fopenFile(char *filename, char *mode,BOOL quit,char *File,ULONG Line);
int  safe_fcloseFile(FILE *file,char *File,ULONG Line);
void safe_ShowAllFiles(char *File,ULONG Line);
void safe_CloseAllFiles(BOOL Quiet,char *File,ULONG Line);

char * LoadFileInRAM(char *file,BOOL quit);
BOOL CopyFile(char *FromFile,char *ToFile);
char *GetCurrentDirectory(void);