#include "WriteExternalFile.h"
#include "Tools.h"
#include "MB_protos.h"
#include "MB_pragmas.h"
#include "MB.h"

#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/****************************************************************************************************************/
/*****																										*****/
/**								 		WriteExternalFile													   **/
/*****																										*****/
/****************************************************************************************************************/

/* Create a file where are the external variables and functions declarations */
BOOL WriteExternalFile(char *Externals,ULONG varnb)
{
	int						i;
	BPTR					TMPlock;
	ULONG					length, type;
	char					*adr_file = NULL;
	struct FileInfoBlock	*Info;
	BOOL					bool_aux = FALSE;
	char					*varname;
	char					*tmp;
	BOOL					result = FALSE;
	FILE					*file;
	BOOL					ExternalExist=FALSE;

	/* If the file already exists, we load it in memory */
	adr_file = LoadFileInRAM(Externals,FALSE);

	for(i=0;!ExternalExist && i<varnb;i++)
	{
		MB_GetVarInfo(i,MUIB_VarType,&type,TAG_END);
		ExternalExist=(type==TYPEVAR_EXTERNAL || type==TYPEVAR_HOOK);
	}

	if (ExternalExist && (file = fopenFile(Externals, "a+", FALSE)))
	{
		if (!adr_file)
			fprintf(file,"#include <utility/hooks.h>\n\n");

		for(i=0;i<varnb;i++)
		{
			MB_GetVarInfo (i,
			 	  		   MUIB_VarType, &type,
			   			   MUIB_VarName, &varname,
						   TAG_END
			    	 	  );
			switch(type)	/* if the declaration does not exist, we generate it */
			{
				case TYPEVAR_EXTERNAL:
					tmp=AllocMemory(strlen(varname)+14,TRUE);
					strcpy(tmp,"extern int ");
					strcat(tmp,varname);
					strcat(tmp,";\n");
					if (adr_file)
						bool_aux = (strstr(adr_file,tmp)!=NULL);
					if (!bool_aux)
						fprintf(file,tmp);
					FreeMemory(tmp);
					break;

				case TYPEVAR_HOOK:
					tmp=AllocMemory(strlen(varname)+52,TRUE);
					strcpy(tmp,"APTR ");
					strcat(tmp,varname);
					strcat(tmp,"( struct Hook *a0, APTR a2, APTR a1 );\n");
					if (adr_file)
						bool_aux = (strstr(adr_file,tmp)!=NULL);
					if (!bool_aux)
						fprintf(file,tmp);
					FreeMemory(tmp);
					break;
			}
		}
		fcloseFile(file);
	}
	if (adr_file)
		FreeMemory(adr_file);

	if (TMPlock = Lock(Externals,ACCESS_READ))	/* if the file is 0 bytes long : we remove it */
	{
		Info = AllocMemory(sizeof(struct FileInfoBlock),TRUE);
		Examine(TMPlock, Info);
		UnLock(TMPlock);
		length = Info->fib_Size;
		FreeMemory(Info);
		if (length == 0)
			DeleteFile(Externals);
		else
			result = TRUE;
	}
	return(result);
}
