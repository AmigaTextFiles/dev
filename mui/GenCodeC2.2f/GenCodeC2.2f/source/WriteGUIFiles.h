#include <stdio.h>
#include <dos/dos.h>

void WriteHeaderFile(char *HeaderFile,char *HHeaderText,char *FileName,ULONG varnb,
					 BOOL Env,BOOL Notifications,BOOL Locale);
void WriteGUIFile(char *MBDir,char *HeaderFile,char *GUIFile,char *CHeaderText,
				  char *Externals,char *GetString,char *GetMBString,
				  ULONG varnb,
				  BOOL ExternalExist,BOOL Env,BOOL Locale,BOOL Declarations,BOOL Code,BOOL Notifications);