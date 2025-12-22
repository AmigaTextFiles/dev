#include "WriteCatalogFiles.h"
#include "Tools.h"

#include <stdio.h>
#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <stdlib.h>
#include <string.h>

/****************************************************************************************************************/
/*****																										*****/
/**											WriteCatalogConstants 											   **/
/*****																										*****/
/****************************************************************************************************************/

static BOOL WriteCatalogConstants(FILE *file,char *CatalogName)
{
	char	*file2;
	char	*index;
	char	*index2;
	char	*variable;

	if (file2 = LoadFileInRAM(CatalogName, FALSE))
	{
		index = file2;

		while(index)
		{
			/* Search a descrition line */
			/* Jump commands, comments lines */
			while(index &&
				  (*index=='#' || *index==';'))
			{
				index = strchr(index,'\n');
				if (index)
					index++;
			}

			/* Get description variable */ 
			if (index)
			{
				index2 = index;
				while(*index2 && *index2!=' ' && *index2!='\t' && *index2!='(') 
					index2++;
				if (*index2)
				{
					if (!(variable = AllocMemory(index2-index+1,FALSE)))
					{
						fcloseFile(file);
						FreeMemory(file2);
						return FALSE;
					}
					else
					{
						strncpy(variable,index,index2-index);
						variable[index2-index]='\0';
						fprintf(file,"extern const APTR _%s;\n",variable);
						fprintf(file,"#define %s ((APTR) &_%s)\n",variable,variable);
						FreeMemory(variable);
					}
					index2 = strchr(index2,'\n');

					/* Jump description string */
					do
					{
						index2++;
						index2 = strchr(index2,'\n');
					}while(index2 && *(index2-1)=='\\');
					if (index2)
						index = index2+1;
					else
						index = NULL;
				}
				else
					index = NULL;
			}
		}
		FreeMemory(file2);
		return TRUE;
	}
	else
	{
		DisplayMsg("Can't open catalog description file !!! \nPlease generate it with MUIBuilder !!! \n");
		return FALSE;
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**								 	WriteCatalogStringsInitialisation										   **/
/*****																										*****/
/****************************************************************************************************************/

static BOOL WriteCatalogStringsInitialisation(FILE *file,char *CatalogName)
{
	char	*file2;
	char	*index;
	char	*index2;
	char	*variable;
	ULONG	cpt = 0;

	if (file2 = LoadFileInRAM(CatalogName,FALSE))
	{
		index = file2;
		
		while(index)
		{
			/* Search a descrition line */
			/* Jump commands, comments lines */
			while(index &&
				  (*index=='#' || *index==';'))
			{
				index = strchr(index,'\n');
				if (index)
					index++;
			}

			/* Get description variable */ 
			if (index)
			{
				index2 = index;
				while(*index2 && *index2!=' ' && *index2!='\t' && *index2!='(') 
					index2++;
				if (*index2)
				{
					if (!(variable = AllocMemory(index2-index+1,FALSE)))
					{
						fcloseFile(file);
						FreeMemory(file2);
						return FALSE;
					}
					else
					{
						strncpy(variable,index,index2-index);
						variable[index2-index]='\0';
						fprintf(file,"const struct FC_Type _%s = { %d, \"",variable,cpt++);
						FreeMemory(variable);

						/* Get description string */
						index2 = strchr(index2,'\n');
						index = index2 + 1;
						do
						{
							index2++;
							index2 = strchr(index2,'\n');
						}while(index2 && *(index2-1)=='\\');

						if (index2==0)					/* no "\n" in the last line of the file */
							index2=file2+strlen(file2);	/* index2=end_of_file */

						if (!(variable = AllocMemory(index2-index+1,FALSE)))
						{
							fcloseFile(file);
							FreeMemory(file2);
							return FALSE;
						}
						else
						{
							strncpy(variable,index,index2-index);
							variable[index2-index]='\0';
							fprintf(file,"%s\" };\n",variable);
							FreeMemory(variable);
							if (index2)
								index = index2 + 1;
							else
							index = NULL;
						}				
					}
				}
				else
					index = NULL;
			}
		}
		FreeMemory(file2);
		return TRUE;
	}
	else
	{
		DisplayMsg("Can't open catalog description file !!! \nPlease generate it with MUIBuilder !!! \n");
		return FALSE;
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**							 			Write_Catalog_h_File												   **/
/*****																										*****/
/****************************************************************************************************************/

BOOL Write_Catalog_h_File(char *Catalog_h_File,char *CatalogName,char *GetString)
{
	char	*name;
	FILE	*file;

	if (file = fopenFile(Catalog_h_File,"w",FALSE))
	{
		if (!(name=AllocMemory(strlen(FilePart(CatalogName))+1,FALSE)))
		{
			fcloseFile(file);
			return FALSE;
		}
		strcpy(name,FilePart(CatalogName));
		remove_extend(name);

		fprintf(file,"#ifndef %s_CAT_H\n",name);
		fprintf(file,"#define %s_CAT_H\n\n",name);
		fprintf(file,"#include <exec/types.h>\n");
		fprintf(file,"#include <libraries/locale.h>\n\n");
		fprintf(file,"/* Prototypes */\n");
		fprintf(file,"extern void OpenAppCatalog(struct Locale *, STRPTR);\n");
		fprintf(file,"extern void CloseAppCatalog(void);\n");
		fprintf(file,"extern char *%s(APTR);\n\n",GetString);

		fprintf(file,"/* Definitions */\n");
		if (!WriteCatalogConstants(file,CatalogName))
		{
			FreeMemory(name);
			fcloseFile(file);
			return FALSE;
		}

		fprintf(file,"\n#endif /* !%s_CAT_H */\n",name);

		FreeMemory(name);
		fcloseFile(file);
		return TRUE;
	}
	else
	{
		DisplayMsg("Unable to create Catalog_h File !!! \n");
		return FALSE;
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**								 			Write_Catalog_c_File											   **/
/*****																										*****/
/****************************************************************************************************************/

BOOL Write_Catalog_c_File(char *Catalog_c_File,char *CatalogName,char *GetString)
{
	char	*name;
	FILE	*file;

	if (file = fopenFile(Catalog_c_File,"w",FALSE))
	{
		if (!(name=AllocMemory(strlen(FilePart(CatalogName))+1,FALSE)))
		{
			fcloseFile(file);
			return FALSE;
		}
		strcpy(name,FilePart(CatalogName));
		remove_extend(name);

		fprintf(file,"/* Prototypes */\n");
		fprintf(file,"#ifdef __GNUC__\n");
		fprintf(file,"#include <proto/locale.h>\n");
		fprintf(file,"#include <proto/dos.h>\n");
		fprintf(file,"#else\n");
		fprintf(file,"#include <proto/locale.h>\n");
		fprintf(file,"#include <clib/dos_protos.h>\n");
		fprintf(file,"\nextern struct Library *LocaleBase;\n\n");
		fprintf(file,"#endif /* __GNUC__ */\n\n");
		fprintf(file,"\n\n");
		fprintf(file,"static LONG %s_Version = 0;\n",name);
		fprintf(file,"static const STRPTR %s_BuiltInLanguage = (STRPTR) \"english\";\n\n",name);
		fprintf(file,"struct FC_Type\n");
		fprintf(file,"{   LONG   ID;\n");
		fprintf(file,"    char *Str;\n");
		fprintf(file,"};\n\n");

		fprintf(file,"/* Definitions */\n");
		if (!WriteCatalogStringsInitialisation(file,CatalogName))
		{
			FreeMemory(name);
			fcloseFile(file);
			return FALSE;
		}

		fprintf(file,"\nextern void CloseAppCatalog(void);\n\n");
		fprintf(file,"static struct Catalog *%s_Catalog = NULL;\n\n",name);
		fprintf(file,"void OpenAppCatalog(struct Locale *loc, STRPTR language)\n");
		fprintf(file,"{\n");
		fprintf(file,"\tLONG tag, tagarg;\n\n");
		fprintf(file,"\tCloseAppCatalog(); /* Not needed if the programmer pairs OpenAppCatalog\n");
		fprintf(file,"\t\t\tand CloseAppCatalog right, but does no harm.  */\n\n");
		fprintf(file,"\tif (%s_Catalog == NULL)\n",name);
		fprintf(file,"\t{\n");
		fprintf(file,"\t\tif (language == NULL)\n");
		fprintf(file,"\t\t\ttag = TAG_IGNORE;\n");
		fprintf(file,"\t\telse\n");
		fprintf(file,"\t\t{\n");
		fprintf(file,"\t\t\ttag = OC_Language;\n");
		fprintf(file,"\t\t\ttagarg = (LONG) language;\n");
		fprintf(file,"\t\t}\n");
		remove_extend(CatalogName);
		fprintf(file,"\t\t%s_Catalog = OpenCatalog(loc, (STRPTR) \"%s.catalog\",\n",name,FilePart(CatalogName));
		add_extend(CatalogName,".cd");
		fprintf(file,"\t\t\tOC_BuiltInLanguage,(LONG)%s_BuiltInLanguage,\n",name);
		fprintf(file,"\t\t\ttag, tagarg,\n");
		fprintf(file,"\t\t\tOC_Version, %s_Version,\n",name);
		fprintf(file,"\t\t\tTAG_DONE);\n");
		fprintf(file,"\t}\n");
		fprintf(file,"}\n\n");
		fprintf(file,"void CloseAppCatalog(void)\n");
		fprintf(file,"{\n");
		fprintf(file,"\tCloseCatalog(%s_Catalog);\n",name);
		fprintf(file,"\t%s_Catalog = NULL;\n",name);
		fprintf(file,"}\n\n");
		fprintf(file,"char * %s(APTR fcstr)\n",GetString);
		fprintf(file,"{\n");
		fprintf(file,"\tchar *defaultstr;\n");
		fprintf(file,"\tLONG strnum;\n\n");
		fprintf(file,"\tstrnum = ((struct FC_Type *) fcstr)->ID;\n");
		fprintf(file,"\tdefaultstr = ((struct FC_Type *) fcstr)->Str;\n\n");
		fprintf(file,"\treturn(%s_Catalog ? (char *)GetCatalogStr(%s_Catalog, strnum, defaultstr) :\n",name,name);
		fprintf(file,"\t\t\tdefaultstr);\n");
		fprintf(file,"}\n");

		FreeMemory(name);
		fcloseFile(file);
		return TRUE;
	}
	else
	{
		DisplayMsg("Unable to create Catalog_c File !!! \n");
		return FALSE;
	}
}
