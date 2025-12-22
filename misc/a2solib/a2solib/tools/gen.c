#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <time.h>

#ifndef linux		/*@@@ FIXME? */
#include <libgen.h>
#endif

/* Lame. Do a dynamic version */
char *functionlist[10000];
int num_functions = 0;

char *compiler_name;
char *archiver_name;
char *nm_name;
char *CFLAGS;
char *ARFLAGS;
char *LDFLAGS;
char *LIBS;
#ifndef NDEBUG
int verbose = 1;
#else	
int verbose = 0;
#endif

#ifdef linux		/*@@@ FIXME? */
extern char *basename(char *);
#endif


int compile_file(char *output_file_name, char *input_file_name, char *addflags)
{
	char compiler_line[2048];
	
	sprintf(compiler_line, "%s %s %s -O2 -o %s -c %s",
			compiler_name,
			CFLAGS,
			addflags,
			output_file_name,
			input_file_name);
		
	if (verbose)
		fprintf(stderr, "Executing %s\n", compiler_line);
	
	if (0 == system(compiler_line))
		return 1;

	if (verbose)
		fprintf(stderr, "Error compiling %s\n", input_file_name);

	return 0;
}

int link_solib(char *output_shared, char *input_symtab, char *input_rev, char *input_lib)
{
	char compiler_line[2048];

#if 0
	char lib[1024];
	char *dot;
	
	strcpy(lib, basename(input_lib)+3);
	dot = strchr(lib, '.');
	if (dot)
		*dot = 0;
#endif
	
	sprintf(compiler_line, "%s %s -o %s %s -Wl,-whole-archive %s -lsolibglue %s -Wl,-no-whole-archive %s -shared -mbaserel",
			compiler_name,
			LDFLAGS,
			output_shared,
			input_symtab,
			input_lib,
			input_rev,
			LIBS);

	if (verbose)
		fprintf(stderr, "Executing %s\n", compiler_line);
	
	if (0 == system(compiler_line))
		return 1;

	if (verbose)
		fprintf(stderr, "Error compiling shared library %s\n", output_shared);

	return 0;
}


int archive_stubs(char *internal, char *trampoline, char *imports, char *outname)
{
	char compiler_line[2048];
	
	if (outname)
	{
		sprintf(compiler_line, "%s %s %s %s %s\n",
			archiver_name,
			ARFLAGS,
			outname,
			trampoline,
			imports);
	}
	else
	{
			sprintf(compiler_line, "%s %s lib%s.a %s %s\n",
			archiver_name,
			ARFLAGS,
			internal,
			trampoline,
			imports);
	}
			
	if (verbose)
		fprintf(stderr, "Executing %s\n", compiler_line);
	
	if (0 == system(compiler_line))
		return 1;

	if (verbose)
		fprintf(stderr, "Error creating stubs library lib%s.a\n", internal);

	return 0;
}

int archive_stubs_brel(char *internal, char *trampoline, char *imports, char *outname)
{
	char compiler_line[2048];
	
	if (outname)
	{
		sprintf(compiler_line, "%s %s %s-brel %s %s\n",
			archiver_name,
			ARFLAGS,
			outname,
			trampoline,
			imports);

	}
	else
	{		
		sprintf(compiler_line, "%s %s lib%s.a-brel %s %s\n",
			archiver_name,
			ARFLAGS,
			internal,
			trampoline,
			imports);
	}
			
	if (verbose)
		fprintf(stderr, "Executing %s\n", compiler_line);
	
	if (0 == system(compiler_line))
		return 1;

	if (verbose)
		fprintf(stderr, "Error creating stubs library lib%s.a\n", internal);

	return 0;
}

char *get_function(FILE *fh)
{
	static char tokenbuffer[1024];
	char *buf = tokenbuffer;
	char *end;
	
	if (tokenbuffer != fgets(tokenbuffer, 1023, fh))
		return 0;
		
	while (*buf == ' ' || *buf == '\t')
		buf++;
	
	end = tokenbuffer + strlen(tokenbuffer) - 1;
	
	while (*end == '\n' || *end == '\r' || *end == '\t' || *end == ' ')
		end--;
		
	end++;
	*end = 0;
	
	return strdup(buf);
}

char *gen_funclist(char *library_name, char *internal_name)
{
	/* Note: We generate a file rather than parsing nm output directly so user
	 * can use the output (via --keep-temps to build a customized version
	 */
	FILE *pf;
	FILE *outfile;
	char file_name[1024];
	char nm_line[1024];
	char line[1024];
	
	sprintf(file_name, "%s.def", internal_name);
	sprintf(nm_line, "%s %s\n", nm_name, library_name);
	
	pf = popen(nm_line, "r");
	if (!pf)
		return 0;
		
	outfile = fopen(file_name, "w+");
	if (!outfile)
	{
		fclose(pf);
		return 0;
	}
	
	while (!feof(pf))
	{
		line[9] = ' ';

		if (!fgets(line, 1023, pf))
			break;
		
		/* It's a library, so check if the current line is a "header" */
		if (strchr(line, ':'))
			continue;
			
		if (line[9] == 'T')
			fputs(&line[11], outfile);
	}
	
	fclose(outfile);
	pclose(pf);
	
	return strdup(file_name);
}

int read_funclist(char *infile_name)
{
	FILE *infile = 0;
	
	infile = fopen(infile_name, "rb");
	if (!infile)
	{
		perror("Can't open input file");
		return 0;
	}	
	
	while (!feof(infile))
		functionlist[num_functions++] = get_function(infile);
	
	num_functions--;
		
	fclose(infile);
	
	return 1;
}

int gen_trampolines(char *libname, char *trampoline, int brel)
{
	int i;
	FILE *outfile = fopen(trampoline, "wb");
	if (!outfile)
	{
		perror("Can't open trampoline output file");
		return 0;
	}

	fprintf(outfile, "\t.data\n");
	fprintf(outfile, "\t.globl\t\t__%s_pull_reference\n", libname);
	fprintf(outfile, "\t.long __%s_pull_reference\n", libname);
	
	for (i = 0; i < num_functions; i++)
	{
		fprintf(outfile, "\t.globl\t\t_t_%s\n", functionlist[i]);
		fprintf(outfile, "_t_%s:\n", functionlist[i]);
		fprintf(outfile, "\t.long 0\n\n");
	}
	
	fprintf(outfile, "\n\t.text\n");
	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "\t.globl\t\t%s\n", functionlist[i]);
		
	fprintf(outfile, "\n");
	
	/* Generate trampoline for each function */
	for (i = 0; i < num_functions; i++)
	{
		fprintf(outfile, "%s:\n", functionlist[i]);
		if (brel)
		{
			fprintf(outfile, "\taddis\t11, 2, _t_%s@brel@ha\n", functionlist[i]);
			fprintf(outfile, "\tlwz\t11, _t_%s@brel@l(11)\n", functionlist[i]);
		}
		else
		{
			fprintf(outfile, "\tlis\t11, _t_%s@ha\n", functionlist[i]);
			fprintf(outfile, "\tlwz\t11, _t_%s@l(11)\n", functionlist[i]);
		}
		fprintf(outfile, "\tmtctr\t11\n");
		fprintf(outfile, "\tbctr\n\n");
	}
	
	fclose(outfile);
	
	return 1;
}
			
int gen_symtab(char *libname, char *symtab)
{
	int i;
	
	FILE *outfile = fopen(symtab, "wb");
	if (!outfile)
	{
		perror("Can't open symtab output file");
		return 0;
	}

	/* Symbol table */
	/* Imports */
	fprintf(outfile, "\t.text\n");
	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "\t.globl\t\t%s\n", functionlist[i]);
		
	/* Function name strings */
	fprintf(outfile, "\n\n\t.data\n");
	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "%s_solib_string_name:\n\t.string \"%s\"\n",
			functionlist[i], functionlist[i]);
		
	fprintf(outfile, "\n\t.align\t\t2\n");

	/* Symbol table */
	fprintf(outfile, "\n\t.globl\t\tSymbolTable\nSymbolTable:\n");
	
	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "\t.long\t\t%s_solib_string_name\n\t.long\t\t%s\n",
			functionlist[i], functionlist[i]);
			
	/* Symbol table size */
	fprintf(outfile, "\n\t.globl\t\tSymbolTableSize\n");
	fprintf(outfile, "SymbolTableSize:\n\t.long\t\t%d\n", num_functions);
	
	fclose(outfile);	

	return 1;
}


int gen_imports(char *libname, char *shared_name, char *imports)
{	
	int i;
	FILE *outfile = fopen(imports, "wb");
	
	if (!outfile)
	{
		perror("Can't open imports output file");
		return 0;
	}
	
	fprintf(outfile, "#include <proto/exec.h>\n");
	fprintf(outfile, "#include <interfaces/solib.h>\n");
	fprintf(outfile, "#include <stdlib.h>\n");
	fprintf(outfile, "#include <solib.h>\n\n");
	fprintf(outfile, "static struct Library *lib_%s = 0;\n", libname);
	fprintf(outfile, "static struct SolibSymIFace *ISolib_%s = 0;\n", libname);
	fprintf(outfile, "static struct SolibMainIFace *ISolib_main = 0;\n\n");
	fprintf(outfile, "void __import_%s(void) __attribute__((constructor));\n", libname);
	fprintf(outfile, "void __term_%s(void) __attribute__((destructor));\n\n", libname);
	fprintf(outfile, "int __%s_pull_reference;\n", libname);
	fprintf(outfile, "extern struct SolibContext ___solib_ctx;\n");
	fprintf(outfile, "extern struct SolibContext *___solib_currentContext;\n");
	
	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "extern void *_t_%s;\n", functionlist[i]);
		
	fprintf(outfile, "\n");
	fprintf(outfile, 
"void __import_%s(void)															\n\
{																				\n\
	struct SolibContext *ctx;													\n\
																				\n\
	if (___solib_currentContext != 0)											\n\
		ctx = ___solib_currentContext;											\n\
	else																		\n\
		ctx = &___solib_ctx;													\n\
																				\n\
	lib_%s = IExec->OpenLibrary(\"%s\", 0);										\n\
	if (!lib_%s)																\n\
		exit(0);																\n\
																				\n\
	ISolib_main = (struct SolibMainIFace *)IExec->GetInterface(lib_%s, \"main\", 1, NULL); \n\
	if (!ISolib_main)															\n\
		exit(0);																\n\
																				\n\
	ISolib_%s = (struct SolibSymIFace *)ISolib_main->GetInterface(ctx);			\n\
	if (!ISolib_%s)																\n\
		exit(0);																\n",
	libname, libname, basename(shared_name), libname, libname, libname, libname);

	for (i = 0; i < num_functions; i++)
		fprintf(outfile, "    _t_%s = ISolib_%s->GetSymbol(\"%s\", 0);\n",
			functionlist[i], libname, functionlist[i]);	
	
	fprintf(outfile,
"}																				\n\
																				\n\
void __term_%s(void)															\n\
{																				\n\
	if (ISolib_%s)	ISolib_main->DropInterface(ISolib_%s);						\n\
	if (ISolib_main)	IExec->DropInterface((struct Interface *)ISolib_main);	\n\
	if (lib_%s)		IExec->CloseLibrary(lib_%s);								\n\
																				\n\
	lib_%s = 0;																	\n\
	ISolib_%s = 0;																\n\
	ISolib_main = 0;															\n\
}																				\n",
	libname, libname, libname, libname, libname, libname, libname);
	
	fclose(outfile);
	
	return 1;
}


int gen_rev(char *revision_name, char *internal_name, char *shared_name, char *revision_str)
{
	int version;
	int revision;
	FILE *outfile;
	struct tm *timer;
	time_t current = time(NULL);
	
	if (revision_str)
	{
		if (2 != sscanf(revision_str, "%d.%d", &version, &revision))
			return 0;
	}
	else
	{
		revision_str = "1.1";
		version = 1;
		revision = 1;
	}
	
	timer = localtime(&current);

	outfile = fopen(revision_name, "wb");
	if (!outfile)
	{
		perror("Can't open revision output file");
		return 0;
	}
	
	fprintf(outfile, "\t.data\n");
	fprintf(outfile, "\t.globl libversion\n");
	fprintf(outfile, "libversion:\n");
	fprintf(outfile, "\t.long %d\n\n", version);
	
	fprintf(outfile, "\t.globl librevision\n");
	fprintf(outfile, "librevision:\n");
	fprintf(outfile, "\t.long %d\n\n", revision);

	fprintf(outfile, "\t.globl libname\n");
	fprintf(outfile, "libname:\n");
	fprintf(outfile, "\t.string \"%s\"\n\n", shared_name);

	fprintf(outfile, "\t.globl libvstring\n");
	fprintf(outfile, "libvstring:\n");
	fprintf(outfile, "\t.string \"%s %s (%d.%d.%d)\\r\\n\";\n", 	
			internal_name, revision_str, timer->tm_mday, timer->tm_mon, timer->tm_year+1900);


				
	fclose(outfile);

	return 1;
}

void make_name_c_compatible(char *name)
{
	while (*name)
	{
		if (*name == '-' || *name == '.')
			*name = '_';
		name++;
	}
}		

void Usage(char *name)
{
	fprintf(stderr, "Usage: %s <options> [input file.a]\n", basename(name));
	fprintf(stderr, "       Generate a shared library from a static library\n");
	fprintf(stderr, "       [input file.a] is the static library you want to convert\n");
	fprintf(stderr, "         to a shared library. The library must be compiled with the\n");
	fprintf(stderr, "         -mbaserel compiler option\n");
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "-n, --library-name=NAME   Assume \"NAME\" as the library name\n");
	fprintf(stderr, "                          All internal references use this name\n");
	fprintf(stderr, "-l, --archive-name=NAME   Use \"NAME\" as name for the linker stub\n");
	fprintf(stderr, "                          archive.\n");
	fprintf(stderr, "                          Example: --archive-name=lib/libSDL.a\n");
	fprintf(stderr, "-o, --output=NAME         Assume \"NAME\" as the library's file name\n");
	fprintf(stderr, "                          By default, the internal name is suffixed with \".so\"\n");
	fprintf(stderr, "                          Example: --output=SDL.library\n");
	fprintf(stderr, "-k, --keep-temps          Do not delete generated intermediate files\n");
	fprintf(stderr, "-c, --compiler=NAME       Use compiler \"NAME\" to generate output. Default is %s\n", compiler_name);
	fprintf(stderr, "-a, --archiver=NAME       Use archiver \"NAME\" to generate link library files. Default is %s.\n", archiver_name);
	fprintf(stderr, "-m, --nm=NAME             Use \"NAME\" to extract symbol information. Default is %s\n", nm_name);
	fprintf(stderr, "-r, --revision=x.x        Set the library's revision to x.x. Default is 1.1\n");
	fprintf(stderr, "-f, --function-list=NAME  Use the file \"NAME\" to read export list from\n");
	fprintf(stderr, "    --cflags=FLAGS        Override CFLAGS (see below, Environment Variables\n");
	fprintf(stderr, "    --ldflags=FLAGS       Override LDFLAGS\n");
	fprintf(stderr, "    --libs=LIBS           Override LIBS\n");
	fprintf(stderr, "    --arflags=flags       Override ARFLAGS\n");
	fprintf(stderr, "-v, --verbose             Output what's currently going on\n");
	fprintf(stderr, "-h, --help                This help\n");
	fprintf(stderr, "\n");
	fprintf(stderr, "Environment variables:\n");
	fprintf(stderr, "CFLAGS    If present, will be added to compiler calls\n");
	fprintf(stderr, "LDFLAGS   If present, will be added to linker calls\n");
	fprintf(stderr, "LIBS      If present, will be added to linker calls after input files\n");
	fprintf(stderr, "ARFLAGS   If present, will be used to create archives.\n");
	fprintf(stderr, "          Archiver is then called as follows:\n");
	fprintf(stderr, "          AR $(ARFLAGS) libNAME.a <objects>\n");
	fprintf(stderr, "          Defaults to \"rc\" if ARFLAGS isn't present\n");
}


#define NAME_SIZE 1024

#define GETVAR_DEF(cvar, EVAR, defval)		\
	cvar = getenv(EVAR);					\
	cvar = strdup(cvar ? cvar : defval);

int main(int argc, char **argv)
{
	int ret = 0;
	int keep_temps = 0;
	int func_list_generated = 1;
	int c;
	char *library_static_name;
	char *output_override = 0;
	char *libname_override = 0;
	char *revision = 0;
	char *file_name_funclist = 0;
	char *archive_name_override = 0;

	static char library_internal_name[NAME_SIZE];
	static char library_shared_name[NAME_SIZE];
	static char file_name_trampoline[NAME_SIZE];
	static char file_name_symtab[NAME_SIZE];
	static char file_name_imports[NAME_SIZE];
	static char file_name_trampoline_o[NAME_SIZE];
	static char file_name_symtab_o[NAME_SIZE];
	static char file_name_imports_o[NAME_SIZE];
	static char file_name_revision[NAME_SIZE];
	static char file_name_revision_o[NAME_SIZE];	
	static char file_name_trampoline_brel_o[NAME_SIZE];
	static char file_name_trampoline_brel[NAME_SIZE];
	static char file_name_imports_brel_o[NAME_SIZE];

	
	static struct option options[] =
	{
		{"library-name", required_argument, 0, 'n'},
		{"archive-name", required_argument, 0, 'l'},
		{"output", required_argument, 0, 'o'},
		{"keep-temps", no_argument, 0, 'k'},
		{"help", no_argument, 0, 'h'},
		{"verbose", no_argument, 0, 'v'},
		{"compiler", required_argument, 0, 'c'},
		{"archiver", required_argument, 0, 'a'},
		{"nm", required_argument, 0, 'm'},
		{"revision", required_argument, 0, 'r'},
		{"function-list", required_argument, 0, 'f'},
		{"cflags", required_argument, 0, 1},
		{"ldflags", required_argument, 0, 2},
		{"libs", required_argument, 0, 3},
		{"arflags", required_argument, 0, 4},
		{0, 0, 0, 0}
	};
	
#ifdef __amigaos4__
	/* Use native compiler when running on OS4 */
	compiler_name = strdup("gcc");
	archiver_name = strdup("ar");
	nm_name = strdup("nm");
#else
	/* Otherwise, use cross compiler */
	compiler_name = strdup("ppc-amigaos-gcc");
	archiver_name = strdup("ppc-amigaos-ar");
	nm_name = strdup("ppc-amigaos-nm");
#endif

	GETVAR_DEF(CFLAGS, "CFLAGS", "");
	GETVAR_DEF(LDFLAGS, "LDFLAGS", "");
	GETVAR_DEF(LIBS,"LIBS", "");
	GETVAR_DEF(ARFLAGS, "ARFLAGS", "rc");
	
	/* Parse command line */
	while (1)
	{
		int option_index = 0;
		
		c = getopt_long(argc, argv, "n:o:hkvc:a:f:", options, &option_index);
		if (c == -1)
			break;
			
		switch (c)
		{
			case 'h':
				Usage(argv[0]);				
				return 0;
			case 'v':
				verbose = 1;
				break;
			case 'k':
				keep_temps = 1;
				break;
			case 'n':
				libname_override = strdup(optarg);
				break;
			case 'l':
				archive_name_override = strdup(optarg);
				break;
			case 'o':
				output_override = strdup(optarg);
				break;
			case 'c':
				compiler_name = strdup(optarg);
				break;
			case 'a':
				archiver_name = strdup(optarg);
				break;
			case 'm':
				nm_name = strdup(optarg);
				break;
			case 'r':
				revision = strdup(optarg);
				break;
			case 'f':
				file_name_funclist = strdup(optarg);
				break;
			case 1:
				free(CFLAGS);
				CFLAGS = strdup(optarg);
				break;
			case 2:
				free(LDFLAGS);
				LDFLAGS = strdup(optarg);
				break;
			case 3:
				free(LIBS);
				LIBS = strdup(optarg);
				break;
			case 4:
				free(ARFLAGS);
				ARFLAGS = strdup(optarg);
				break;
				
		}
	}
		
	if (optind >= argc)
	{
		fprintf(stderr, "Required arguments are missing\n");
		Usage(argv[0]);
		return 20;
	}
	else
	{
		library_static_name = strdup(argv[optind]);
	}


	/* Determine the library's internal name */
	if (libname_override)
	{
		char *base = basename(libname_override);
		if (base[0] == 'l' && base[1] == 'i' && base[2] == 'b' && base[strlen(base)-2] == '.')
		{
			base[strlen(base)-2] = 0;
			strcpy(library_internal_name, base+3);
		}
		else
		{
			strcpy(library_internal_name, base);
		}
		free(libname_override);
	}
	else
	{
		/* Extract internal library name from static library name */
		char *dot;
		
		strcpy(library_internal_name, basename(library_static_name)+3);
		dot = strchr(library_internal_name, '.');
		if (dot)
			*dot = 0;
	}
	
	make_name_c_compatible(library_internal_name);
	
	if (verbose)
		fprintf(stderr, "Using %s as library internal name\n", library_internal_name);
	
	/* Determine the shared libraries name */
	if (output_override)
	{
		strcpy(library_shared_name, output_override);
		free(output_override);
	}
	else
	{
		strcpy(library_shared_name, library_internal_name);
		strcat(library_shared_name, ".so");
	}
	
	if (verbose)
	{
		fprintf(stderr, "Converting static library %s to shared library %s\n", 
			library_static_name, library_shared_name);
		if (file_name_funclist)
			fprintf(stderr, "Reading symbols from %s\n", file_name_funclist);
		else
			fprintf(stderr, "Exporting all global text symbols\n");
	}
	
	/* Determine names of intermediate files */
	sprintf(file_name_symtab, "%s_symtab.S", library_internal_name);
	sprintf(file_name_symtab_o, "%s_symtab.o", library_internal_name);

	sprintf(file_name_trampoline, "%s_trampoline.S", library_internal_name);
	sprintf(file_name_trampoline_o, "%s_trampoline.o", library_internal_name);
	
	sprintf(file_name_imports, "%s_imports.c", library_internal_name);
	sprintf(file_name_imports_o, "%s_imports.o", library_internal_name);

	sprintf(file_name_revision, "%s_revision.S", library_internal_name);
	sprintf(file_name_revision_o, "%s_revision.o", library_internal_name);

	sprintf(file_name_trampoline_brel, "%s_trampoline_brel.S", library_internal_name);
	sprintf(file_name_trampoline_brel_o, "%s_trampoline_brel.o", library_internal_name);
	sprintf(file_name_imports_brel_o, "%s_imports_brel.o", library_internal_name);



	/* Generate intermediate files */
	if (verbose)
		fprintf(stderr, "Generating intermediate files %s, %s and %s\n",
			file_name_symtab, file_name_trampoline, file_name_imports);
	
	if (!file_name_funclist)
		file_name_funclist = gen_funclist(library_static_name, library_internal_name);
	else
		func_list_generated = 0;
	
	if (!read_funclist(file_name_funclist))
	{
		fprintf(stderr, "Error: Couldn't read function list\n");
		goto error;
	}
	
	if (!gen_symtab(library_internal_name, file_name_symtab))
	{
		fprintf(stderr, "Error: Couldn't generate symbol table\n");
		goto error;
	}
	
	if (!gen_imports(library_internal_name, library_shared_name, file_name_imports))
	{
		fprintf(stderr, "Error: Couldn't generate imports\n");
		goto error;
	}
	
	if (!gen_trampolines(library_internal_name, file_name_trampoline, 0))
	{
		fprintf(stderr, "Error: Couldn't generate trampolines\n");
		goto error;
	}
	
	if (!gen_trampolines(library_internal_name, file_name_trampoline_brel, 1))
	{
		fprintf(stderr, "Error: Couldn't generate trampolines (brel)\n");
		goto error;
	}
	
	if (!gen_rev(file_name_revision, library_internal_name, library_shared_name, revision))
	{
		fprintf(stderr, "Error: Couldn't generate intermediate files\n");
		goto error;
	}
	
	/* Compile the files for the shared library*/
	if (!compile_file(file_name_symtab_o, file_name_symtab, ""))
		goto error;
				
	if (!compile_file(file_name_revision_o, file_name_revision, ""))
		goto error;
		
	if (!link_solib(library_shared_name, file_name_symtab_o, file_name_revision_o, 
				library_static_name))
		goto error;

	/* Compile the stub library */
	if (!compile_file(file_name_trampoline_o, file_name_trampoline, ""))
		goto error;
		
	if (!compile_file(file_name_imports_o, file_name_imports, ""))
		goto error;

	if (!archive_stubs(library_internal_name, file_name_trampoline_o, file_name_imports_o, 
			archive_name_override))
		goto error;

	if (!compile_file(file_name_trampoline_brel_o, file_name_trampoline_brel, "-mbaserel"))
		goto error;
		
	if (!compile_file(file_name_imports_brel_o, file_name_imports, "-mbaserel"))
		goto error;

	if (!archive_stubs_brel(library_internal_name, file_name_trampoline_brel_o, 
			file_name_imports_brel_o, archive_name_override))
		goto error;

		
cleanup:
	if (!keep_temps)
	{
		unlink(file_name_symtab);
		unlink(file_name_trampoline);
		unlink(file_name_imports);
		unlink(file_name_revision);
		unlink(file_name_symtab_o);
		unlink(file_name_trampoline_o);
		unlink(file_name_imports_o);
		unlink(file_name_revision_o);
		if (func_list_generated)
			unlink(file_name_funclist);
		unlink(file_name_trampoline_brel);
		unlink(file_name_trampoline_brel_o);
		unlink(file_name_imports_brel_o);
	}

	free(archiver_name);
	free(compiler_name);
	free(nm_name);
	
	if (file_name_funclist)
		free(file_name_funclist);
	
	free(CFLAGS);
	free(LDFLAGS);
	free(LIBS);
	free(ARFLAGS);
	
	return ret;
	
error:
	/* In case of an error, keep even incomplete result files if wanted by user */
	if (!keep_temps)
	{
		unlink(library_shared_name);
	}
	
	/* Flag an error */
	ret = 20;
	goto cleanup;
}
