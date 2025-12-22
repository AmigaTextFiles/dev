/***** =id.c
 *
 *  $VER: id.c 1.003 (22 Jun 1996)
 *
 *        © 1996 jasonb
 *
 *  PROGRAMNAME:
 *      id.c
 *
 ***** --background--
 *      These are the housekeeping functions that keep track of declared methods
 *      and attributes, and writes the public and private header files.
 *
 *      All data is currently stored in fixed size arrays, rather than dynamically.
 *      I did this because, as this is a preprocessor, I wanted to maximize speed
 *      (although perhaps with all the I/O going on it doesn't make much difference),
 *      and because the number of IDs in any given class should be quite limited anyway.
 *      I've set the limit to 256, but that could easily be raised if the need arose.
 *      All limits are #define'd below.
 *
 *      All strings are hardwired, also. If someone wishes to localize this program,
 *      feel free.
 *
 *****
 *
 *  $HISTORY:
 *
 *  22 Jun 1996 : 001.003 : Added ATT_TRAILER_SMALL.
 *  21 Jun 1996 : 001.002 : Added automatic data setup code back in, took care of extra special cases, added Method* keyword.
 *  20 Jun 1996 : 001.001 : Removed automatic data setup from all methods and superclass calls from OM_GET and OM_SET.
 *  19 Jun 1996 : 001.000 : Initial release.
 */



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "id.h"

#define NOOFIDS                 256
#define CLASSNAMELENGTH         64
#define SUPERCLASSNAMELENGTH    64
#define DATANAMELENGTH          64
#define NAMELENGTH              64

#define TRUE    1
#define FALSE   0

typedef struct {
	char    name[NAMELENGTH];
	char    type;
	long    value;
} ID;

ID      ids[NOOFIDS];
long    idcnt=0, mthcnt=0, attcnt=0;
char    clsname[CLASSNAMELENGTH];
char    superclsname[SUPERCLASSNAMELENGTH];
char    dataname[DATANAMELENGTH];
char    methodbase[CLASSNAMELENGTH+6];
char    attributebase[CLASSNAMELENGTH+6];

char    *messages[] = {
	// GET_HEADER -- header for an OM_GET method
	"static SAVEDS ULONG %s_OM_GET(struct IClass *cl, Object *obj, Msg msg)\n",

	// GET_VARS -- variable declarations for an OM_GET method
	"\tULONG *store = ((struct opGet *) msg)->opg_Storage;\n"
	"\tULONG tag = ((struct opGet *) msg)->opg_AttrID;\n",

	// SET_HEADER -- header for an OM_SET method
	"static SAVEDS ULONG %s_OM_SET(struct IClass *cl, Object *obj, Msg msg)\n",

	// SET_VARS -- variable declarations for an OM_SET method
	"\tstruct TagItem *tags, *tag;\n",

	// MTH_HEADER -- header for a general method
	"static SAVEDS ULONG %s_%s(struct IClass *cl, Object *obj, Msg msg)\n",

	// MTH_VARS -- variable declarations for a general method
	"{\n\t%s *data = INST_DATA(cl, obj);\n\n",

	// MTH_VARS_SMALL -- variable declarations for a special cutdown method
	"{\n",

	// MTH_VARS_SUPER_GET_OBJ -- variable declarations for OM_NEW method
	"{\n\t%s *data;\n\n"
	"\tif (!(obj = (Object *) DoSuperMethodA(cl, obj, msg)))\n"
	"\t\treturn (0);\n\n"
	"\tdata = INST_DATA(cl, obj);\n\t{ /* Begin user code */\n\n",

	// MTH_VARS_SUPER_CHECK -- variable declarations for MUIM_Setup method
	"{\n\t%s *data = INST_DATA(cl, obj);\n\n"
	"\tif (!DoSuperMethodA(cl,obj,msg))\n"
	"\t\treturn (FALSE);\n\t{ /* Begin user code */\n\n",

	// MTH_VARS_SUPER -- variable declarations including unchecked call to superclass
	"{\n\t%s *data = INST_DATA(cl, obj);\n\n"
	"\tDoSuperMethodA(cl, obj, msg);\n\t{ /* Begin user code */\n\n",

	// GET_DEFS_TRAILER -- end of attribute definitions for an OM_GET method
	"}\n",

	// GET_TRAILER -- end code for an OM_GET method
	"\treturn (DoSuperMethodA(cl, obj, msg));\n}\n",

	// SET_DEFS_TRAILER -- end of attribute definitions for an OM_SET method
	"  }\n\t}\n",

	// SET_TRAILER -- end code for an OM_SET method
	"\treturn (DoSuperMethodA(cl, obj, msg));\n}\n",

	// MTH_TRAILER -- end code for a general method
	"\n\treturn (DoSuperMethodA(cl, obj, msg));\n}\n",

	// MTH_TRAILER_SMALL -- end code for a special cutdown method
	"\n}\n",

	// MTH_TRAILER_RET_OBJ -- end code for returning an object
	"\n\t} /* End user code */\n\treturn ((ULONG) obj);\n}\n",

	// MTH_TRAILER_RET_ZERO -- end code for returning a zero
	"\n\t} /* End user code */\n\treturn (0);\n}\n",

	// MTH_TRAILER_RET_TRUE -- end code for returning a true
	"\n\t} /* End user code */\n\treturn (TRUE);\n}\n",

	// GET_ATT_TRAILER -- end code for an individual attribute defn in an OM_GET method
	"\n\t\t\treturn (TRUE);\n\t\t}\n",

	// SET_ATT_TRAILER -- end code for an individual attribute defn in an OM_SET method
	"\n\t\t\tbreak;\n\t\t}\n",

	// ATT_TRAILER_SMALL -- end code for an individual attribute defn without return or break
	"\n\t\t}\n",

	// INGETMETH -- beginning of attribute defns for an OM_GET method
	"\tswitch (tag) {\n",

	// INSETMETH -- beginning of attribute defns for an OM_SET method
	"\tfor (tags = ((struct opSet *) msg)->ops_AttrList; tag = NextTagItem(&tags);) {\n"
	"\t  switch (tag->ti_Tag) {\n",

	// CASE -- attribute definition code
	"case %s:",

	// DISPATCH_HEADER -- header for dispatcher
	"static SAVEDS ASM ULONG %s_Dispatcher(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)\n{\n"
	"\tswitch (msg->MethodID) {\n",

	// DISPATCH_CASE -- code for an individual method in the dispatcher
	"\t\tcase %s: return (%s_%s(cl, obj, (APTR) msg));\n",

	// DISPATCH_TRAILER -- end of dispatcher
	"\t}\n\n\treturn (DoSuperMethodA(cl, obj, msg));\n}\n\n",

	// CONSTRUCTOR_HEADER -- header for constructor function
	"struct MUI_CustomClass *%s_Create(void)%s",

	// CONSTRUCTOR_BODY -- code for constructure function
	"\treturn (MUI_CreateCustomClass(NULL, %s, NULL, sizeof(%s), %s_Dispatcher));\n}\n",

	// ERROPENR
	"Error: Couldn't open %s for reading.\n",

	// ERROPENW
	"Error: Couldn't open %s for writing.\n",

	// HEADER -- header for files
	"/*\n * %s file for class %s.\n"
	" * Automatically generated on %s"
	" *\n */\n\n",

	// DEFINES -- #defines for cross-compiler compatibility
	"#ifdef _DCC\n"
	"#define REG(x) __ ## x\n"
	"#define ASM\n"
	"#define SAVEDS __geta4\n"
	"#else\n"
	"#define REG(x) register __ ## x\n\n"
	"#if defined __MAXON__ || defined __GNUC__\n"
	"#define ASM\n"
	"#define SAVEDS\n"
	"#else\n"
	"#define ASM\t__asm\n"
	"#define SAVEDS __saveds\n"
	"#endif\n#endif\n\n"
	"#define Super() DoSuperMethodA(cl, obj, msg)\n"
	"#define GetData() INST_DATA(cl, obj)\n\n"
};

struct {
	char *msg;
	unsigned long vars, trailer;
} special_cases[] = {
	"OM_NEW", MTH_VARS_SUPER_GET_OBJ, MTH_TRAILER_RET_OBJ,
	"MUIM_AskMinMax", MTH_VARS_SUPER, MTH_TRAILER_RET_ZERO,
	"MUIM_Setup", MTH_VARS_SUPER_CHECK, MTH_TRAILER_RET_TRUE,
	"MUIM_Show", MTH_VARS_SUPER, MTH_TRAILER_RET_TRUE,
	"MUIM_Draw", MTH_VARS_SUPER, MTH_TRAILER_RET_ZERO,
	NULL, 0, 0
};

void CheckSpecialCases(char *name, unsigned long *vars, unsigned long *trailer)
{
	int i;

	for (i=0; special_cases[i].msg; i++)
		if (strcmp(name, special_cases[i].msg) == 0)
			break;

	if (special_cases[i].msg){
		*vars = special_cases[i].vars;
		*trailer = special_cases[i].trailer;
	} else {
		*vars = MTH_VARS;
		*trailer = MTH_TRAILER;
	}
}

void SetClassName(char *name)
{
	if (strlen(name) > CLASSNAMELENGTH){
		printf("Error: Name %s too long. Must be %d characters or less.\n", name, CLASSNAMELENGTH);
		exit(1);
	}

	strcpy(clsname, name);

	sprintf(methodbase,"MUIM_%s_",clsname);
	sprintf(attributebase,"MUIA_%s_",clsname);
}

void SetSuperClassName(char *name)
{
	if (strlen(name) > SUPERCLASSNAMELENGTH){
		printf("Error: Name %s too long. Must be %d characters or less.\n", name, SUPERCLASSNAMELENGTH);
		exit(1);
	}

	strcpy(superclsname, name);
}

void SetDataName(char *name)
{
	if (strlen(name) > DATANAMELENGTH){
		printf("Error: Name %s too long. Must be %d characters or less.\n", name, DATANAMELENGTH);
		exit(1);
	}

	strcpy(dataname, name);
}

void Add(char *name, char type)
{
	long i,value=0;
	char done = FALSE;

	if (strlen(name) > NAMELENGTH){
		printf("Error: Name %s too long. Must be %d characters or less.\n", name, NAMELENGTH);
		exit(1);
	}

	if ((type & METHOD) && (type & ATTRIBUTE)){
		printf("Error: Name %s given as both METHOD and ATTRIBUTE.\n", name);
		exit(1);
	}

	if (type & METHOD)
		// Does this look like a local method?
		if (strncmp(methodbase, name, strlen(methodbase)) == 0)
			value = mthcnt++;
		else // No, must be inherited
			value = 0;
	else if (type & ATTRIBUTE)
		// Does this look like a local attribute?
		if (strncmp(attributebase, name, strlen(attributebase)) == 0)
			value = attcnt++;
		else // No, must be inherited
			value = 0;
	else {
		printf("Error: Name %s must be one of METHOD or ATTRIBUTE.\n", name);
		exit(1);
	}

	for (i=0; i<idcnt; i++)
		if (strcmp(ids[i].name, name) == 0)
			if ((type & METHOD) || done){
				printf("Error: Redefinition of %s.\n", name);
				exit(1);
			} else
				done = TRUE;

	if (!done){
		strcpy(ids[idcnt].name, name);
		ids[idcnt].type = type;
		ids[idcnt].value = value;

		if (++idcnt > NOOFIDS){
			printf("Error: Too many IDs. Maximum: %d.\n", NOOFIDS);
			exit(1);
		}
	}
}

void MakePublic(void)
{
	if (idcnt>0)
		ids[idcnt-1].type |= PUBLIC;
}

void OutputIDs(FILE *fp, FILE *fpp, char type, long base, char *basename)
{
	int i;

	for (i=0; i<idcnt; i++)
		if ((ids[i].type & type) && (strncmp(basename, ids[i].name, strlen(basename)) == 0))
			if (ids[i].type & PUBLIC)
				fprintf(fp, "#define %s\t\t0x%p\n", ids[i].name, ids[i].value + base);
			else
				fprintf(fpp, "#define %s\t\t0x%p\n", ids[i].name, ids[i].value + base);

}

void MakeMainHeader(FILE *fp, char *headerfilename, char *privheaderfilename)
{
	struct tm *tp;
	long t;

	time(&t);
	tp = localtime(&t);

	fprintf(fp,messages[HEADER],"Implementation",clsname,asctime(tp));
	fprintf(fp,"\n#include %c%s%c\n#include %c%s%c\n",'"',headerfilename,'"','"',privheaderfilename,'"');
}

void MakeHeaders(char *headerfilename, char *privheaderfilename, long base)
{
	FILE *fp, *fppriv;
	struct tm *tp;
	long t;

	if (!(fp = fopen(headerfilename, "w"))){
		printf(messages[ERROPENW], headerfilename);
		exit(1);
	}

	if (!(fppriv = fopen(privheaderfilename, "w"))){
		printf(messages[ERROPENW], privheaderfilename);
		exit(1);
	}

	time(&t);
	tp = localtime(&t);

	fprintf(fp,messages[HEADER],"Header",clsname,asctime(tp));
	fprintf(fp,messages[CONSTRUCTOR_HEADER],clsname,";");
	fprintf(fp,"\n\n/* PUBLIC METHODS */\n");

	fprintf(fppriv,messages[HEADER],"Private header",clsname,asctime(tp));
	fprintf(fppriv,"\n\n/* PRIVATE METHODS */\n");

	OutputIDs(fp, fppriv, METHOD, base, methodbase);

	fprintf(fp,"\n\n/* PUBLIC ATTRIBUTES */\n");

	fprintf(fppriv,"\n\n/* PRIVATE ATTRIBUTES */\n");

	OutputIDs(fp, fppriv, ATTRIBUTE, base + mthcnt, attributebase);

	fclose(fp);
	fclose(fppriv);
}

void MakeHousekeeping(FILE *fp)
{
	int i;

	fprintf(fp,messages[DISPATCH_HEADER],clsname);

	for (i=0; i<idcnt; i++)
		if (ids[i].type & METHOD)
			fprintf(fp,messages[DISPATCH_CASE],ids[i].name,clsname,ids[i].name);

	fprintf(fp,messages[DISPATCH_TRAILER]);

	fprintf(fp,messages[CONSTRUCTOR_HEADER],clsname,"\n{\n");
	fprintf(fp,messages[CONSTRUCTOR_BODY], superclsname, dataname, clsname);
}
