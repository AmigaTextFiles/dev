#include "WriteGUIFiles.h"
#include "MB_protos.h"
#include "MB_pragmas.h"
#include "MB.h"
#include "MB_MUI_Strings.h"
#include "Tools.h"

#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <string.h>
#include <stdlib.h>

/* variable types */
static char	*STR_type[] =
{
	"BOOL",
	"int",
	"char *",
	"char *",
	"APTR",
	"",
	"",
	"",
	"APTR",
	"APTR"
};

/****************************************************************************************************************/
/*****																										*****/
/**												WriteParameters 											   **/
/*****																										*****/
/****************************************************************************************************************/

static void WriteParameters(FILE *file,ULONG varnb,BOOL Notifications)
{
	int   i;
	char  *varname, *typename;
	ULONG type,size;
	BOOL  comma = FALSE;

	typename = STR_type[ TYPEVAR_EXTERNAL_PTR - 1 ];
	if (Notifications)
	{
		for(i=0;i<varnb;i++)
		{
			MB_GetVarInfo (i,
						   MUIB_VarType, &type,
						   MUIB_VarName, &varname,
						   MUIB_VarSize, &size,
						   TAG_END
						  );

			if (type == TYPEVAR_EXTERNAL_PTR)
			{
				if (comma)
			 		fprintf(file, ", ");

				comma = TRUE;
				fprintf(file, "%s %s", typename, varname);
			}
		}
	}
	if (!comma)
		fprintf(file, "void");
}

/****************************************************************************************************************/
/*****																										*****/
/**												WriteDeclarations 											   **/
/*****																										*****/
/****************************************************************************************************************/

static void WriteDeclarations(FILE *file,ULONG varnb,int vartype)
{
	int		i;
	char	*varname;
	ULONG	type, size;
	char	*typename;
	int		nb_ident = 1;
	char	*buffer = NULL;
	char	*buffer2 = NULL;

	typename = STR_type[ vartype - 1 ];		/* find the name 'BOOL ...'	*/
	for(i=0;i<varnb;i++)
	{
		MB_GetVarInfo (i,
					   MUIB_VarType, &type,
					   MUIB_VarName, &varname,
					   MUIB_VarSize, &size,
					   TAG_END
			     	  );

		if (type == vartype)
		{
			switch(type)
			{
				case TYPEVAR_TABSTRING:
					fprintf(file, "\t%s\t%s[%d];\n",
					 		typename,
					 		varname,
					 		size+1
						   );
					break;

				case TYPEVAR_IDENT:
					fprintf(file,"#define %s %d\n", varname, nb_ident++);
					break;

				case TYPEVAR_LOCAL_PTR:
					if (!buffer)
					{
						buffer = AllocMemory(strlen(typename)+strlen(varname)+3,TRUE);
						sprintf(buffer, "\t%s\t%s", typename, varname);
					}
					else
					{
						buffer2 = buffer;
						buffer = AllocMemory(strlen(buffer)+strlen(varname)+3,TRUE);
						sprintf(buffer,"%s, %s",buffer2,varname);
						FreeMemory(buffer2);
					}
					if (strlen(buffer)>=70)
					{
						fprintf(file, "%s;\n", buffer);
						FreeMemory(buffer);
						buffer = NULL;
					}
					break;

				case TYPEVAR_HOOK:
					fprintf(file, "\tstatic struct Hook %sHook;\n", varname);
					break;

				default:
					fprintf(file, "\t%s\t%s;\n",typename, varname);
					break;
			}
		}
	}

	if (buffer && strlen(buffer)>0)
		fprintf(file, "%s;\n", buffer);

	FreeMemory(buffer);
}

/****************************************************************************************************************/
/*****																										*****/
/**											WriteInitialisations											   **/
/*****																										*****/
/****************************************************************************************************************/

static void WriteInitialisations(FILE *file,ULONG varnb,int vartype,BOOL Locale,char *GetMBString)
{
	int		i, j;
	ULONG	type, size;
	char	*inits, *name;
	BOOL	enter = FALSE;

	for(i=0;i<varnb;i++)
	{
		MB_GetVarInfo(i,
				 	  MUIB_VarType	, &type,
				 	  MUIB_VarName	, &name,
				 	  MUIB_VarSize	, &size,
				 	  MUIB_VarInitPtr	, &inits,
			 		  TAG_END
			     	 );

		if (type == vartype)
		{
			enter = TRUE;
			switch(type)
			{
				case TYPEVAR_TABSTRING:
					for(j=0;j<size;j++)
					{
						if (!Locale)
						 	fprintf(file, "\tObjectApp->%s[%d] = \"%s\";\n", name, j, inits);
						else
						    fprintf(file, "\tObjectApp->%s[%d] = %s(%s);\n", name, j, GetMBString, inits);
						inits = inits + strlen(inits) + 1;
					}
					fprintf(file, "\tObjectApp->%s[%d] = NULL;\n", name, j);
					break;

				case TYPEVAR_STRING:
				 	if (*inits != 0)
					{
						if (!Locale)
 							fprintf(file, "\tObjectApp->%s = \"%s\";\n", name, inits);
						else
   						fprintf(file, "\tObjectApp->%s = %s(%s);\n", name, GetMBString, inits);
					}
					else
						fprintf(file, "\tObjectApp->%s = NULL;\n", name);
					break;

				case TYPEVAR_HOOK:
					fprintf(file, "\tInstallHook(&%sHook,%s,ObjectApp);\n", name, name);
					break;

				default:
					break;
			}
		}
	}

	if (enter)
		fprintf(file, "\n");
}

/****************************************************************************************************************/
/*****																										*****/
/**												WriteCode		 											   **/
/*****																										*****/
/****************************************************************************************************************/

static void WriteCode(FILE *file,char *GetString,char *GetMBString)
{
	ULONG	type;
	char*	code;
	BOOL	InFunction     = FALSE;
	BOOL	IndentFunction = TRUE ;
	BOOL	obj_function   = FALSE;
	BOOL	InObj          = FALSE;
	int		nb_indent      = 1;
	int		nb_function    = 0;
	int		name;

	MB_GetNextCode(&type, &code);
	while(type != -1)
	{
		switch(type)
		{
			case TC_CREATEOBJ:
				name = atoi(code);
				fprintf(file, "%s,\n",MUIStrings[name]);
				nb_indent++;
				IndentFunction = TRUE;
				MB_GetNextCode(&type, &code);
				InObj = TRUE;
				break;

			case TC_ATTRIBUT:
				Indent(file,nb_indent);
				name = atoi(code);
				fprintf(file, "%s, ",MUIStrings[name]);
				IndentFunction = FALSE;
				MB_GetNextCode(&type, &code);
				break;

			case TC_END:
				nb_indent--;
				InObj = FALSE;
				Indent(file,nb_indent);
				name = atoi(code);
				fprintf(file, "%s",MUIStrings[name]);
				IndentFunction = TRUE;
				MB_GetNextCode(&type, &code);
				fprintf(file, ";\n\n");
				break;

			case TC_MUIARG_OBJFUNCTION:
				if (IndentFunction)
					Indent(file,nb_indent);
				nb_function++;
				name = atoi(code);
				fprintf(file, "%s(",MUIStrings[name]);
				IndentFunction = FALSE;
				MB_GetNextCode(&type, &code);
				obj_function = TRUE;
				InFunction = TRUE;
				break;

			case TC_MUIARG_FUNCTION:
			case TC_FUNCTION:
				if (IndentFunction)
					Indent(file,nb_indent);
				nb_function++;
				name = atoi(code);
				fprintf(file, "%s(",MUIStrings[name]);
				IndentFunction = FALSE;
				InFunction     = TRUE;
				MB_GetNextCode(&type, &code);
				obj_function = FALSE;
				break;

			case TC_OBJFUNCTION:
				if (IndentFunction)
					Indent(file,nb_indent);
				nb_function++;
				name = atoi(code);
				fprintf(file, "%s(",MUIStrings[name]);
				InFunction     = TRUE;
				IndentFunction = FALSE;
				MB_GetNextCode(&type,&code);
				obj_function = TRUE;
				break;

			case TC_STRING:
				fprintf(file, "\"%s\"",code);
				MB_GetNextCode(&type, &code);
				IndentFunction = TRUE;
				if (InFunction)
				{
					if (type  != TC_END_FUNCTION)
						fprintf(file, ", ");
					IndentFunction = FALSE;
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_LOCALESTRING:
				fprintf(file, "%s(%s)",GetMBString, code);
				MB_GetNextCode(&type, &code);
				IndentFunction = TRUE;
				if (InFunction)
				{
					if (type  != TC_END_FUNCTION)
						fprintf(file, ", ");
					IndentFunction = FALSE;
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_LOCALECHAR:
				fprintf(file, "%s(%s)[0]",GetString, code);
				MB_GetNextCode(&type, &code);
				IndentFunction = TRUE;
				if (InFunction)
				{
					if (type  != TC_END_FUNCTION)
						fprintf(file, ", ");
					IndentFunction = FALSE;
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_INTEGER:
				fprintf(file, "%s", code);
				MB_GetNextCode(&type, &code);
				IndentFunction = TRUE;
				if (InFunction)
				{
					if (type  != TC_END_FUNCTION)
						fprintf(file, ", ");
					IndentFunction = FALSE;
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_CHAR:
				fprintf(file, "'%s'",code);
				MB_GetNextCode(&type, &code);
				IndentFunction = TRUE;
				if (InFunction)
				{
					if (type  != TC_END_FUNCTION)
						fprintf(file, ", ");
					IndentFunction = FALSE;
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_VAR_AFFECT:
				name = atoi(code);
				MB_GetVarInfo(name, MUIB_VarName, &code, MUIB_VarType, &type, TAG_END);
				if (type == TYPEVAR_LOCAL_PTR)
					fprintf( file, "\t%s = ", code);
				else
					fprintf(file, "\tObjectApp->%s = ", code);
				IndentFunction = FALSE;
				MB_GetNextCode(&type, &code);
				break;

			case TC_OBJ_ARG:
			case TC_VAR_ARG:
				name = atoi(code);
				MB_GetVarInfo(name, MUIB_VarName, &code, MUIB_VarType, &type, TAG_END);
				if (type == TYPEVAR_LOCAL_PTR)
					fprintf(file, "%s", code);
				else
					fprintf(file, "ObjectApp->%s", code);
				MB_GetNextCode(&type, &code);
				if ((InFunction)&&(type != TC_END_FUNCTION))
					fprintf(file, ", ");
				if (!InFunction)
				{
					fprintf(file, ",\n");
					IndentFunction = TRUE;
				}
				break;

			case TC_END_FUNCTION:
				MB_GetNextCode(&type, &code);
				if (nb_function>1)
				{
					if (type != TC_END_FUNCTION)
						fprintf(file, "),");
					else
						fprintf(file, ")");
				}
				else
				{
					if (obj_function)
						fprintf(file, ");\n\n");
					else
						fprintf(file, "),\n");
					IndentFunction = TRUE;
					InFunction     = FALSE;
					obj_function   = FALSE;
				}
				nb_function--;
				break;

			case TC_BOOL:
				if (*code == '0')
					fprintf(file, "FALSE");
				else
					fprintf(file, "TRUE" );
				MB_GetNextCode(&type, &code);
				if (InFunction)
				{
					if (type != TC_END_FUNCTION)
					{
						fprintf(file, ", ");
						IndentFunction = FALSE;
					}
				}
				else
					fprintf(file, ",\n");
				break;

			case TC_MUIARG:
				if (IndentFunction)
					Indent(file,nb_indent);
				name = atoi(code);
				fprintf(file, "%s", MUIStrings[name]);
				MB_GetNextCode(&type, &code);
				if (InFunction)
				{
					if (type != TC_END_FUNCTION)
					{
						fprintf(file, ", ");
						IndentFunction = FALSE;
					}
				}
				else
				{
					fprintf(file, ",\n");
					IndentFunction = TRUE;
				}
				break;

			case TC_MUIARG_ATTRIBUT:
				if (IndentFunction)
					Indent(file,nb_indent);
				name = atoi(code);
				MB_GetNextCode(&type, &code);
				if (InObj)
					fprintf(file, "%s,\n", MUIStrings[name]);
				else
				{
					if (InFunction)
					{
						if (type != TC_END_FUNCTION)
							fprintf(file, "%s,", MUIStrings[name]);
						else
							fprintf(file, "%s", MUIStrings[name]);
					}
					else
						fprintf(file, "%s;\n\n", MUIStrings[name]);
				}
				break;

			case TC_MUIARG_OBJ:
				if (IndentFunction)
					Indent(file,nb_indent);
				name = atoi(code);
				MB_GetNextCode(&type, &code);
				fprintf(file, "%s;\n\n", MUIStrings[name]);
				break;

			case TC_EXTERNAL_FUNCTION:
				fprintf(file, "&%sHook", code);
				MB_GetNextCode(&type, &code);
				if (InFunction)
				{
					if (type != TC_END_FUNCTION)
					{
						fprintf(file, ", ");
						IndentFunction = FALSE;
					}
				}
				else
				{
					fprintf(file, ",\n");
					IndentFunction = TRUE;
				}
				break;

			default:
			{
				char	msg[80];

				sprintf(msg,"Type = %d\nERROR !!!!! THERE IS A PROBLEM WITH THIS FILE !!!\n", type);
				DisplayMsg(msg);
			}
			break;
		}
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**												WriteNotify		 											   **/
/*****																										*****/
/****************************************************************************************************************/

static void WriteNotify(FILE *file,char *GetString,char *GetMBString)
{
	ULONG	type;
	char*	code;
	int		name;
	BOOL	indent = FALSE;

	fprintf(file, "\n");
	MB_GetNextNotify(&type, &code);
	while(type != -1)
	{
		if (indent)
			fprintf(file, "\t\t");
		indent = TRUE;
		switch(type)
		{
			case TC_END_FUNCTION:
			case TC_END_NOTIFICATION:
				fprintf(file, ");\n\n");
				MB_GetNextNotify(&type, &code);
				indent = FALSE;
				break;

			case TC_BEGIN_NOTIFICATION:
				name = atoi(code);
				MB_GetVarInfo(name, MUIB_VarName, &code, MUIB_VarType, &type, TAG_END);
				if (type == TYPEVAR_LOCAL_PTR)
					fprintf(file, "\tDoMethod(%s,\n", code);
				else
					fprintf(file, "\tDoMethod(ObjectApp->%s,\n", code);
				MB_GetNextNotify(&type, &code);
				break;

			case TC_FUNCTION:
				name = atoi(code);
				fprintf(file, "\t%s(", MUIStrings[name]);
				MB_GetNextNotify(&type, &code);
				indent = FALSE;
				break;

			case TC_STRING:
				fprintf(file, "\"%s\"",code);
				MB_GetNextNotify(&type, &code);
				if ((type  != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_LOCALESTRING:
				fprintf(file, "%s(%s)",GetMBString, code);
				MB_GetNextNotify(&type, &code);
				if ((type  != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_LOCALECHAR:
				fprintf(file, "%s(%s)[0]",GetString, code);
				MB_GetNextNotify(&type, &code);
				if ((type  != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_INTEGER:
				fprintf(file, "%s", code);
				MB_GetNextNotify(&type, &code);
				if ((type  != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_CHAR:
				fprintf(file, "'%s'",code);
				MB_GetNextNotify(&type, &code);
				if ((type  != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_VAR_ARG:
				name = atoi(code);
				MB_GetVarInfo(name, MUIB_VarName, &code, MUIB_VarType, &type, TAG_END);
				if ((type==TYPEVAR_LOCAL_PTR)||(type==TYPEVAR_EXTERNAL_PTR))
					fprintf(file, "%s", code);
				else
					fprintf(file, "ObjectApp->%s", code);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_BOOL:
				if (*code == '0')
					fprintf(file, "FALSE");
				else
					fprintf(file, "TRUE" );
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_MUIARG:
			case TC_MUIARG_OBJ:
				name = atoi(code);
				fprintf(file, "%s", MUIStrings[name]);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ", ");
				indent = FALSE;
				break;

			case TC_MUIARG_ATTRIBUT:
				name = atoi(code);
				fprintf(file, "%s", MUIStrings[name]);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_EXTERNAL_CONSTANT:
				fprintf(file, "%s", code);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_EXTERNAL_FUNCTION:
				fprintf(file, "&%sHook", code);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			case TC_EXTERNAL_VARIABLE:
				fprintf(file, "%s", code);
				MB_GetNextNotify(&type, &code);
				if ((type != TC_END_NOTIFICATION)&&(type != TC_END_FUNCTION))
					fprintf(file, ",\n");
				else
					fprintf(file, "\n");
				break;

			default:
			{
				char msg[80];

				sprintf(msg,"Type = %d\nERROR !!!!! THERE IS A PROBLEM WITH THIS FILE !!!\n", type);
				DisplayMsg(msg);
			}
			break;
		}
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**								 				WriteHeaderFile												   **/
/*****																										*****/
/****************************************************************************************************************/

void WriteHeaderFile(char *HeaderFile,char *HHeaderText,char *FileName,ULONG varnb,
					 BOOL Env,BOOL Notifications,BOOL Locale)
{
	char	*name;
	FILE	*file;

	file = fopenFile(HeaderFile, "w+", FALSE);
	if (file)
	{
		fprintf(file,"#ifndef GUI_FILE_H\n");
		fprintf(file,"#define GUI_FILE_H\n\n");
		if (Env)
			fprintf(file,"%s",HHeaderText);
		if (Locale)
	    	fprintf(file, "#include \"%s_cat.h\"\n\n",FilePart(FileName));
		MB_GetVarInfo(0, MUIB_VarName, &name, TAG_END);
		fprintf(file, "struct Obj%s\n{\n", name);
		WriteDeclarations(file,varnb,TYPEVAR_PTR);
		WriteDeclarations(file,varnb,TYPEVAR_BOOL);
		WriteDeclarations(file,varnb,TYPEVAR_INT);
		WriteDeclarations(file,varnb,TYPEVAR_STRING);
		WriteDeclarations(file,varnb,TYPEVAR_TABSTRING);
		fprintf(file,"};\n\n");
		if (Notifications)
		{
			WriteDeclarations(file,varnb,TYPEVAR_IDENT);
			fprintf(file, "\n");
		}
		if (Env)
		{
			fprintf(file,"extern struct Obj%s * Create%s(",name,name);
			WriteParameters(file,varnb,Notifications);
			fprintf(file,");\n");
			fprintf(file,"extern void Dispose%s(struct Obj%s *);\n", name, name);
		}
		fprintf(file,"\n#endif\n");
		fcloseFile(file);
	}
	else
	{
		DisplayMsg("Unable to create GUI Header file !!! \n");
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**								 			WriteGUIFile													   **/
/*****																										*****/
/****************************************************************************************************************/

void WriteGUIFile(char *MBDir,char *HeaderFile,char *GUIFile,char *CHeaderText,
				  char *Externals,char *GetString,char *GetMBString,
				  ULONG varnb,
				  BOOL ExternalExist,BOOL Env,BOOL Locale,BOOL Declarations,BOOL Code,BOOL Notifications)
{
	char	*name;
	FILE	*file;
	char	*FromHookfile;
	char	*ToHookfile;
	int		i;
	ULONG	type,length;
	BOOL	HookExist;

	if (file = fopenFile(GUIFile, "w+",FALSE))
	{
		if (Env)
		{
			fprintf(file,"%s",CHeaderText);
			MB_GetVarInfo(0, MUIB_VarName, &name, TAG_END);
			fprintf(file, "\n#include \"%s\"\n", FilePart(HeaderFile));
			if (ExternalExist)
				fprintf(file, "#include \"%s\"\n", FilePart(Externals));
			for(i = 0, HookExist = FALSE; !HookExist && i<varnb;i++)
			{
				MB_GetVarInfo (i,MUIB_VarType, &type, TAG_END);
				HookExist = (type == TYPEVAR_HOOK);
			}
			if (HookExist)
			{
				fprintf(file, "#include \"Hook_utility.h\"");

				/* Copy Utility_Hook.h in current directory */
				FromHookfile=AllocMemory(strlen(MBDir)+14+2,TRUE);
				strcpy(FromHookfile,MBDir);
				AddPart(FromHookfile,"Hook_utility.h",strlen(MBDir)+14+2);

				length = (long)FilePart(GUIFile)-(long)GUIFile;
				ToHookfile=AllocMemory(length+14+2,TRUE);
				strncpy(ToHookfile,GUIFile,length);
				ToHookfile[length]='\0';
				AddPart(ToHookfile,"Hook_utility.h",length+14+2);

				if (!(CopyFile(FromHookfile,ToHookfile)))
				{
					DisplayMsg("Can't copy Hook_utility.h in your source directory !!!");
				}

				/* Copy Hook_utility.o in current directory */
				strcpy(FromHookfile,MBDir);
				AddPart(FromHookfile,"Hook_utility.o",strlen(MBDir)+14+2);

				strncpy(ToHookfile,GUIFile,length);
				ToHookfile[length]='\0';
				AddPart(ToHookfile,"Hook_utility.o",length+14+2);

				if (!(CopyFile(FromHookfile,ToHookfile)))
				{
					DisplayMsg("Can't copy Hook_utility.o in your source directory !!!");
				}

				FreeMemory(FromHookfile);
				FreeMemory(ToHookfile);
			}
			if (Locale)
		  	{
		    	fprintf(file, "\nstatic char *%s(APTR ref)\n{\n", GetMBString);
		    	fprintf(file, "\tchar *aux;\n\n");
		    	fprintf(file, "\taux = %s(ref);\n", GetString);
		    	fprintf(file, "\tif (aux[1] == '\\0') return(&aux[2]);\n");
		    	fprintf(file, "\telse                return(aux);\n}\n");
		  	}
			fprintf(file, "\nstruct Obj%s * Create%s(", name, name);
			WriteParameters(file,varnb,Notifications);
			fprintf(file, ")\n");
			fprintf(file, "{\n\tstruct Obj%s * ObjectApp;\n\n", name);
		}
	    if (Declarations)
	    {
			WriteDeclarations(file,varnb,TYPEVAR_LOCAL_PTR);
			if (HookExist)
				WriteDeclarations(file,varnb,TYPEVAR_HOOK);
	    }
	    if (Env)
			fprintf(file, "\n\tif (!(ObjectApp = AllocVec(sizeof(struct Obj%s),MEMF_CLEAR)))\n\t\treturn(NULL);\n\n", name);
	    if (Declarations)
	    {
			WriteInitialisations(file,varnb,TYPEVAR_STRING,Locale,GetMBString);
			WriteInitialisations(file,varnb,TYPEVAR_TABSTRING,Locale,GetMBString);
			if (HookExist)
				WriteInitialisations(file,varnb,TYPEVAR_HOOK,Locale,GetMBString);
	    }
	    if (Code)
			WriteCode(file,GetString,GetMBString);
	    if (Env)
	    {
			fprintf(file, "\n\tif (!ObjectApp->%s)\n\t{\n\t\tFreeVec(ObjectApp);", name);
			fprintf(file, "\n\t\treturn(NULL);\n\t}\n");
	    }
	    if (Notifications)
			WriteNotify(file,GetString,GetMBString);
	    if (Env)
	    {
			fprintf(file, "\n\treturn(ObjectApp);\n}\n");
			fprintf(file, "\nvoid Dispose%s(struct Obj%s * ObjectApp)\n{\n", name, name);
			fprintf(file, "\tMUI_DisposeObject(ObjectApp->%s);\n", name);
			fprintf(file, "\tFreeVec(ObjectApp);\n}\n");
	    }
	    fcloseFile(file);
	}
	else
	{
		DisplayMsg("Unable to create GUI file !!!\n");
	}
}
