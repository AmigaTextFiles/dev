#include "Tools.h"
#include "WriteCatalogFiles.h"
#include "WriteExternalFile.h"
#include "WriteGUIFiles.h"
#include "WriteMainFile.h"
#include "GenCodeCGUI.h"
#include <libraries/mui.h>

#include <ctype.h>

/* Prototypes */
#ifdef __GNUC__
#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#else
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#endif /* __GNUC__ */

#include <exec/memory.h>

/* ANSI */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Pragmas */
#include <pragmas/dos_pragmas.h>

/* MUIBuilder library */
#include "MB.h"
#include "MB_pragmas.h"
#include "MB_protos.h"

#ifdef __SASC
extern struct Library * DOSBase;
#endif /* __SASC */

/****************************************************************************************************************/
/*****																										*****/
/**												Global variables 											   **/
/*****																										*****/
/****************************************************************************************************************/

ULONG	varnb;					/* number of variables */

BOOL	Code, Env;				/* flags-options */
BOOL	Locale, Declarations;
BOOL	Notifications, Application;
BOOL	ExternalExist = FALSE;
char	*FileName, *CatalogName;/* Strings */
char	*GetString;
char	*GetMBString;

char	*HeaderFile;
char	*GUIFile;
char	*MBDir;
char	*Externals;
char	*MainFile;
char	*Catalog_h_File;
char	*Catalog_c_File;

extern void end(void *);

void Quit(void *);

/****************************************************************************************************************/
/*****																										*****/
/**								 				Init														   **/
/*****																										*****/
/****************************************************************************************************************/

BOOL Init(void)
{
	HeaderFile 		= NULL;
	GUIFile 		= NULL;
	MBDir			= NULL;
	Externals 		= NULL;
	MainFile		= NULL;
	Catalog_h_File	= NULL;
	Catalog_c_File	= NULL;

	/* Get all needed variables */
	MB_Get	(
			MUIB_VarNumber		, &varnb,
			MUIB_Code			, &Code,
			MUIB_Environment	, &Env,
			MUIB_Locale			, &Locale,
			MUIB_Notifications	, &Notifications,
			MUIB_Declarations	, &Declarations,
			MUIB_Application	, &Application,
			MUIB_FileName		, &FileName,
			MUIB_CatalogName	, &CatalogName,
			MUIB_GetStringName	, &GetString,
			TAG_END
		);

	/* Verify some varaiables*/
	if (*FileName=='\0')
	{
		DisplayMsg("Please give a name to your application in the field \"CODE\"\n");
		return FALSE;
	}
	if (Locale && *CatalogName=='\0')
	{
		DisplayMsg("Please give a catalog name in the field \"CATALOG\"\n");
		return FALSE;
	}
	if (Locale && *GetString=='\0')
	{
		DisplayMsg("Please give a \"GetString\" name in the field \"GetString\"\n");
		return FALSE;
	}

	/* Create 'GetMBString' name */
	if (strcmp(GetString, "GetMBString") == 0) 
		GetMBString  = "GetMBString2";
	else
		GetMBString = "GetMBString";

	/* Create File Names */
	remove_extend(FileName);

	GUIFile = AllocMemory(strlen(FileName)+6,TRUE);
	strcpy(GUIFile, FileName);
	add_extend(GUIFile, "GUI.c");

	HeaderFile = AllocMemory(strlen(FileName)+6,TRUE);
	strcpy(HeaderFile, FileName);
	add_extend(HeaderFile, "GUI.h");

	Externals = AllocMemory(strlen(FileName)+9,TRUE);
	strcpy(Externals, FileName);
	strcat(Externals, "Extern");
	add_extend(Externals, ".h");

	MainFile = AllocMemory(strlen(FileName)+7,TRUE);
	strcpy(MainFile, FileName);
	strcat(MainFile, "Main");
	add_extend(MainFile, ".c");

	Catalog_h_File = AllocMemory(strlen(FileName)+7,TRUE);
	strcpy(Catalog_h_File, FileName);
	strcat(Catalog_h_File, "_cat");
	add_extend(Catalog_h_File, ".h");

	Catalog_c_File = AllocMemory(strlen(FileName)+7,TRUE);
	strcpy(Catalog_c_File, FileName);
	strcat(Catalog_c_File, "_cat");
	add_extend(Catalog_c_File, ".c");

	/* Get Current Directory Name */
	MBDir = GetCurrentDirectory();

	return TRUE;
}


/****************************************************************************************************************/
/*****																										*****/
/**								 			FreeFileNameMemory												   **/
/*****																										*****/
/****************************************************************************************************************/

void FreeFileNameMemory(void)
{
	FreeMemory(HeaderFile);
	FreeMemory(GUIFile);
	FreeMemory(Externals);
	FreeMemory(MainFile);
	FreeMemory(MBDir);
	FreeMemory(Catalog_h_File);
	FreeMemory(Catalog_c_File);
}

/****************************************************************************************************************/
/*****																										*****/
/**								 				Quit														   **/
/*****																										*****/
/****************************************************************************************************************/

void Quit(void *App)
{
	FreeFileNameMemory();
	end(App);
}

/****************************************************************************************************************/
/*****																										*****/
/**											PrintInfo														   **/
/*****																										*****/
/****************************************************************************************************************/
void PrintInfo(struct ObjApp *App,char *str)
{
	char *msg;

	if ((msg = (char *)AllocMemory(9+strlen(str)+4+1,FALSE)))
	{
		sprintf(msg,"Generate %s ...",str);
		set(App->TX_Prg_Name,MUIA_Text_Contents,msg);
		FreeMemory(msg);
	}
}

/****************************************************************************************************************/
/*****																										*****/
/**								 			GenerateCode												       **/
/*****																										*****/
/****************************************************************************************************************/

void GenerateCode(struct ObjApp *App,char *H_Header_Text,char *C_Header_Text,char *Main_Header_Text)
{
	ULONG				Main;
	BPTR				lock;
	TypeQuitFunction	quit_f;
	void				*data;

	data   = SetDataQuit((void *)App);
	quit_f = SetFunctionQuit(Quit);

	if (!Init())
		Quit((void *)App);

	/* test catalog description file if locale */
	if (Locale)
	{
		if (!(lock=Lock(CatalogName,ACCESS_READ)))
		{
			DisplayMsg("The catalog description file doesn't exist !!\nPlease generate it with MUIBuilder");
			Quit((void *)App);
		}
		UnLock(lock);
	}

	if (Declarations)
	{
		PrintInfo(App,FilePart(HeaderFile));
		WriteHeaderFile(HeaderFile,H_Header_Text,FileName,varnb,Env,Notifications,Locale);
	}

	if (Env)
	{
		PrintInfo(App,FilePart(Externals));
		ExternalExist = WriteExternalFile(Externals,varnb);
	}

	PrintInfo(App,FilePart(GUIFile));
	WriteGUIFile(MBDir,HeaderFile,GUIFile,C_Header_Text,Externals,GetString,GetMBString,varnb,
				 ExternalExist,Env,Locale,Declarations,Code,Notifications);

	get(App->CH_Generate_Main_File,MUIA_Selected,&Main);
	if (Main)
	{
		PrintInfo(App,FilePart(MainFile));
		WriteMainFile(HeaderFile,MainFile,Main_Header_Text,varnb,Locale);
	}

	if (Locale)
	{
		ULONG	Catalog;

		get(App->CH_Add_new_entries_in_Catalog_Description_File,
			MUIA_Selected,&Catalog);
		if (Catalog)
		{
			char	*command;

			command=AllocMemory(strlen(MBDir)+1+25+15+strlen(CatalogName)+6+strlen(GetString)+1,TRUE);

			strcpy(command,MBDir);
			AddPart(command,"WriteCatalog/WriteCatalog",strlen(MBDir)+1+25+1);
			if (lock = Lock(command, ACCESS_READ))
			{
				UnLock(lock);
				strcat(command," Reserved CDN \"");
				strcat(command,CatalogName);
				strcat(command,"\" GSN ");
				strcat(command,GetString);
				if (!Execute(command,NULL,NULL))
					DisplayMsg("Can't launch WriteCatalog !!!");
			}
			else
				DisplayMsg("Can't find WriteCatalog !!!");

			FreeMemory(command);
		}

		PrintInfo(App,FilePart(Catalog_h_File));
		if (!Write_Catalog_h_File(Catalog_h_File,CatalogName,GetString))
			DisplayMsg("Can't Create H Catalog File");

		PrintInfo(App,FilePart(Catalog_c_File));
		if (!Write_Catalog_c_File(Catalog_c_File,CatalogName,GetString))
			DisplayMsg("Can't Create C Catalog File");
	}

	set(App->TX_Prg_Name,MUIA_Text_Contents,"");

	FreeFileNameMemory();
	
	SetDataQuit(data);
	SetFunctionQuit(quit_f);
}
