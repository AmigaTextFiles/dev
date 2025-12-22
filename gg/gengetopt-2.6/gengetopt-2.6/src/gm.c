/**
 * Copyright (C) 1999, 2000, 2001  Free Software Foundation, Inc.
 *
 * This file is part of GNU gengetopt 
 *
 * GNU gengetopt is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 2, or (at your option) 
 * any later version. 
 *
 * GNU gengetopt is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License along 
 * with gengetopt; see the file COPYING. If not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "argsdef.h"
#include "ggos.h"
#include "gm.h"

#define TAB_LEN 2

extern struct gengetopt_option * gengetopt_options;
extern char * gengetopt_package;
extern char * gengetopt_version;
extern char * gengetopt_purpose;
extern int gengetopt_strdup_text_length;
extern char *gengetopt_strdup_text[];

static int tab_indentation ; /* tab indentation level */
static int handle_error; /* should I handle errors, by exit(1) */

static char *create_filename (char *name, char *ext);
static FILE *open_outputfile (char *filename);
static void indent() ;
static void inc_indent() ;
static void dec_indent() ;
static void check_option_given( char *var_arg,
                                char *long_opt, char short_opt ) ;
static void generate_error_handle();
static char *canonize_names(char * name);

#define ARGS_STRUCT "args_info"
#define ARGS_STRUCT_NAME PACKAGE "_" ARGS_STRUCT

static char *parser_function_name;

char *
create_filename (char *name, char *ext)
{
  char *filename ;

  filename = (char *) malloc (strlen (name) + strlen (ext) + 2);
  /* 2 = 1 for the . and one for the '\0' */
  if (! filename)
    {
      fprintf (stderr, "Error in memory allocation! %s %d\n",
               __FILE__, __LINE__);
      abort ();
    }

  sprintf (filename, "%s.%s", name, ext);

  return filename ;
}

FILE *
open_outputfile (char *filename)
{
  FILE *output_file ;
  
  output_file = freopen ( filename, "w", stdout ) ;
  if ( ! output_file )
    {
      fprintf( stderr, "Error creating %s\n", filename ) ;
      abort() ;
    }

  return output_file;
}

static void
do_check_option_given (struct gengetopt_option *opt)
{
	switch (opt->type) {
	case ARG_NO:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        break;
	case ARG_FLAG:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_flag = !(%s->%s_flag);\n",
                ARGS_STRUCT,
                opt->var_arg,
                ARGS_STRUCT,
				opt->var_arg);
        break;
	case ARG_STRING:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = strdup (optarg);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_INT:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = atoi (optarg);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_SHORT:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = (short)atoi (optarg);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_LONG:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = atol (optarg);\n", 
                ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_FLOAT:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = (float)strtod (optarg, NULL);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_DOUBLE:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = strtod (optarg, NULL);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_LONGDOUBLE:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = (long double) strtod (optarg, NULL);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	case ARG_LONGLONG:
        check_option_given (opt->var_arg, opt->long_opt, opt->short_opt);
        indent ();
        printf ("%s->%s_arg = (long long)atol (optarg);\n",
				ARGS_STRUCT, opt->var_arg);
        break;
	default:
        fprintf (stderr, "gengetopt: bug found in %s:%d\n", __FILE__,
                 __LINE__);
        abort ();
	}
}

int
generate_cmdline_parser (char *function_name, short unamed_options,
                         char *filename, char *header_ext, char *c_ext,
                         int long_help, int no_handle_help,
                         int no_handle_version,
                         int no_handle_error, char **comment)
{
  long max_long, max_short, w;
  struct gengetopt_option * opt;
  char *comment_string ;
  int i ;
  int first_time = 1;
  
  short generate_strdup = unamed_options;
  /* if unamed_options is specified gengetopt_strdup has to be generated;
     otherwise it will be only if a string option is specified */

  FILE *output_file ;

  char *filename_canonized = 0;

  char *header_filename ;
  char *c_filename ;
  parser_function_name = canonize_names (function_name); 
  /* initialize static data */

  header_filename = create_filename (filename, header_ext) ;
  c_filename = create_filename (filename, c_ext) ;

  /* global static fields */
  tab_indentation = 0;
  handle_error = (! no_handle_error);

# define foropt for (opt = gengetopt_options;             \
		     opt != (struct gengetopt_option *)0; \
		     opt=opt->next)

  if (gengetopt_options == (struct gengetopt_option *)0) {
	fprintf (stderr, "gengetopt: none option given\n");
	return 1;
  }

  /* ****************************************************** */
  /* HEADER FILE******************************************* */
  /* ****************************************************** */

  output_file = open_outputfile (header_filename);

  printf ("/* %s */\n\n", header_filename);
  printf ("/* File autogenerated by gengetopt version %s  */\n\n",
          VERSION) ;

  filename_canonized = canonize_names (filename);
  printf ("#ifndef _%s_%s\n", filename_canonized, header_ext);
  printf ("#define _%s_%s\n\n", filename_canonized, header_ext);

  printf ("#ifdef __cplusplus\n");
  printf ("extern \"C\" {\n");
  printf ("#endif /* __cplusplus */\n");

  printf ("\n/* Don't define PACKAGE and VERSION if we use automake.  */\n");

  if (gengetopt_package != NULL)
	printf (""
"#if defined PACKAGE\n"
"#  undef PACKAGE\n"
"#endif\n"
"#define PACKAGE \"%s\"\n", gengetopt_package);
  else
	printf (""
"#ifndef PACKAGE\n"
"/* ******* WRITE THE NAME OF YOUR PROGRAM HERE ******* */\n"
"#define PACKAGE \"\"\n"
"#endif\n");

  if (gengetopt_version != NULL)
	printf (""
"#if defined VERSION\n"
"#  undef VERSION\n"
"#endif\n"
"#define VERSION \"%s\"\n", gengetopt_version);
  else
	printf (""
"#ifndef VERSION\n"
"/* ******* WRITE THE VERSION OF YOUR PROGRAM HERE ******* */\n"
"#define VERSION \"\"\n"
"#endif\n");

  /* ****************************************************** */
  /* *********************************  HEADER   STRUCTURES */
  /* ****************************************************** */

  printf ("\nstruct %s {\n", ARGS_STRUCT_NAME ) ;
  inc_indent ();

  foropt
	if (opt->type != ARG_NO) {
		switch (opt->type) {
		case ARG_FLAG:
		case ARG_STRING:
		case ARG_INT:
		case ARG_SHORT:
		case ARG_LONG:
		case ARG_FLOAT:
		case ARG_DOUBLE:
		case ARG_LONGDOUBLE:
		case ARG_LONGLONG:
                  indent ();
                  printf ("%s ", arg_types[opt->type]);
                  break;
		default: fprintf (stderr, "gengetopt: bug found in %s:%d!!\n",
				  __FILE__, __LINE__);
			 abort ();
		}

                if (opt->type == ARG_FLAG)
 			printf ("%s_flag", opt->var_arg);
 		else
 			printf ("%s_arg", opt->var_arg);

		printf (";\t/* %s", opt->desc);
         
                if (opt->default_given)
                  {
                    if (opt->type == ARG_STRING)
                      printf (" (default='%s')", opt->default_string);
                    else
                      printf (" (default=%.0f)", opt->default_num);
                  }

		if (opt->type == ARG_FLAG)
                  {
                    if (opt->flagstat)
                      printf (" (default=on)");
                    else    
                      printf (" (default=off)");
                  }

		printf (".  */\n");
	}

  printf ("\n");

  foropt
    if (opt->type != ARG_NO) {
		switch (opt->type) {
		case ARG_FLAG:
		case ARG_STRING:
		case ARG_INT:
		case ARG_SHORT:
		case ARG_LONG:
		case ARG_FLOAT:
		case ARG_DOUBLE:
		case ARG_LONGDOUBLE:
		case ARG_LONGLONG: break;
		default:
                  fprintf (stderr, "gengetopt: bug found in %s:%d!!\n",
                           __FILE__, __LINE__);
                  abort ();
		}
                indent ();
		printf ("int %s_given ;\t/* Whether %s was given.  */\n",
			opt->var_arg, opt->long_opt);
    } else {
      /* for NO_ARG options we simply create a "given" */
      indent ();
      printf ("int %s_given ;\t/* Whether %s was given.  */\n",
              opt->var_arg, opt->long_opt);
    }

  /* now print unamed options */
  if ( unamed_options )
    {
      printf ("\n");
      indent ();
      printf ("char **inputs ; /* unamed options */\n") ;
      indent ();
      printf ("unsigned inputs_num ; /* unamed options number */\n") ;
    }

  printf ("} ;\n\n" ) ;

  printf ("int %s (int argc, char * const *argv, struct %s *%s);\n\n", 
          parser_function_name, ARGS_STRUCT_NAME, ARGS_STRUCT);

  printf ("void %s_print_help(void);\n", parser_function_name);
  printf ("void %s_print_version(void);\n\n", parser_function_name);

  printf ("#ifdef __cplusplus\n");
  printf ("}\n");
  printf ("#endif /* __cplusplus */\n");

  printf ("#endif /* _%s_%s */\n", filename_canonized, header_ext);

  free (filename_canonized); // it's no longer useful

  fclose (output_file) ;

  /* ****************************************************** */
  /* ********************************************** C FILE  */
  /* ****************************************************** */

  tab_indentation = 0 ;

  output_file = open_outputfile (c_filename);

  printf (""
"/*\n"
"  File autogenerated by gengetopt version %s  \n", VERSION) ; 

  if ( comment )
    {
      i = 0 ;
      for ( ; (comment_string = comment[i]) != NULL ; ++i ) 
        printf ("  %s\n", comment_string );
    }

  printf 
    ("\n"
     "  The developers of gengetopt consider the fixed text that goes in all\n"
     "  gengetopt output files to be in the public domain:\n"
     "  we make no copyright claims on it.\n");

  printf ("*/\n"
"\n"
"\n"
"#include <stdio.h>\n"
"#include <stdlib.h>\n"
"#include <string.h>\n"
"/* If we use autoconf.  */\n"
"#ifdef HAVE_CONFIG_H\n"
"#include \"config.h\"\n"
"#endif\n"
"/* Check for configure's getopt check result.  */\n"
"#ifndef HAVE_GETOPT_LONG\n"
"#include \"getopt.h\"\n"
"#else\n"
"#include <getopt.h>\n"
"#endif\n"
"\n"
"#ifndef HAVE_STRDUP\n"
"#define strdup gengetopt_strdup\n"
"#endif /* HAVE_STRDUP */\n\n"
"#include \"%s\"\n"
"\n",
header_filename);

  printf ("\n"
"void\n"
"%s_print_version (void)\n"
"{\n"
"  printf (\"%%s %%s\\n\", PACKAGE, VERSION);\n"
"}\n"
"\n"
"void\n"
"%s_print_help (void)\n"
"{\n"
"  %s_print_version ();\n", 
          parser_function_name, parser_function_name, parser_function_name);
  printf ("  printf(\"\\n\"\n");
  if (gengetopt_purpose != NULL) {
    char *ptr;
    ptr = gengetopt_purpose;
    printf (
"\"Purpose:\\n\"\n"
"\"  ");
    for (; *ptr!='\0'; ptr++) {
      if (*ptr == '\n') {
	printf("\\n\"\n\"  ");
      } else {
	printf("%c", *ptr);
      }
    }
    printf (""
"\\n\"\n"
"\"\\n\"\n");
  }
  printf ("\"Usage: %%s ");



  /* ****************************************************** */
  /* ********************************************** OPTIONS */
  /* ****************************************************** */

  if ( long_help )
    {
      foropt
	if (opt->required) /* required options */
		switch (opt->type) {
		case ARG_INT:
		case ARG_SHORT:
		case ARG_LONG:
		case ARG_FLOAT:
		case ARG_DOUBLE:
		case ARG_LONGDOUBLE:
		case ARG_LONGLONG:
		case ARG_STRING: 
        	if (opt->short_opt)
            {
                printf ("-%c%s|", opt->short_opt, arg_names[opt->type]);
            }
            printf ("--%s=%s ", opt->long_opt, arg_names[opt->type]);
		   break;
		default: fprintf (stderr, "gengetopt: bug found in %s:%d!!\n",
				  __FILE__, __LINE__);
		         abort ();
		}
  foropt
	if (!opt->required)
		switch (opt->type) {
		case ARG_NO:
		case ARG_FLAG: 
            printf ("[");
            if (opt->short_opt)
            {
              printf ("-%c|", opt->short_opt);
            }
            printf ("--%s] ", opt->long_opt);
            break;
		case ARG_INT:
		case ARG_SHORT:
		case ARG_LONG:
		case ARG_FLOAT:
		case ARG_DOUBLE:
		case ARG_LONGDOUBLE:
		case ARG_LONGLONG:
		case ARG_STRING: 
        	if (opt->short_opt)
            {
                printf ("-%c%s|", opt->short_opt, arg_names[opt->type]);
           }
           printf ("--%s=%s ", opt->long_opt, arg_names[opt->type]);
		   break;
		default: fprintf (stderr, "gengetopt: bug found in %s:%d!!\n",
				  __FILE__, __LINE__);
		         abort ();
		}
  } else { /* if not long help we generate it as GNU standards */
    printf ("[OPTIONS]...");    
  }

  if ( unamed_options )
      printf (" [FILES]...");

  printf ("\\n\", PACKAGE);\n");
  /* calculate columns */
  max_long = max_short = 0;
  foropt {
	w = 3 + strlen (opt->long_opt);
	if (opt->type == ARG_FLAG || opt->type == ARG_NO)
	{
		if (w > max_long) max_long = w;
		if (2 > max_short) max_short = 2;
	}
	else
	{
		w += strlen (arg_names[opt->type]);
		if (w > max_long) max_long = w;
		w = (3 + strlen (arg_names[opt->type]));
		if (w > max_short) max_short = w;
	}
  }
  /* print justified options */
  foropt
  {
    printf ("  printf(\"");
    if (opt->type == ARG_FLAG || opt->type == ARG_NO)
    {
      if (opt->short_opt) printf ("   -%c", opt->short_opt);
      else                printf ("     ");
      for (w = 2; w < max_short; w++) printf (" ");
      printf ("  --%s", opt->long_opt);
      for (w = 2+strlen(opt->long_opt); w < max_long; w++)
	printf (" ");
      printf ("  %s", opt->desc);
      if (opt->type == ARG_FLAG)
      {
	if (opt->flagstat)
	  printf (" (default=on)");
	else
	  printf (" (default=off)");
      }
      printf ("\\n\");\n");
    }
    else
    {
      if (opt->short_opt)
	printf ("   -%c%s", opt->short_opt, arg_names[opt->type]);
      else
      {
	int type_len = strlen(arg_names[opt->type]);

	printf ("      ");
	for (w = 1; w < type_len; w++) printf (" ");
      }
      for (w = 2+strlen(arg_names[opt->type]); w < max_short; w++)
	printf (" ");
      printf ("  --%s=%s", opt->long_opt, arg_names[opt->type]);
      for (w = 3+strlen(opt->long_opt)+
	     strlen(arg_names[opt->type]); w < max_long; w++)
	printf (" ");
      printf ("  %s", opt->desc);
      if (opt->default_given)
        {
          if (opt->type == ARG_STRING)
            printf (" (default='%s')", opt->default_string);
          else
            printf (" (default=%.0f)", opt->default_num);
        }
      printf ("\\n\");\n");
    }
  }
  printf ("}\n\n\n");

  if (! generate_strdup)
    {
      foropt
	if (opt->type == ARG_STRING) {
          generate_strdup = 1;
          break;
	}
    }

  if (generate_strdup) 
    {
      for (i = 1; i <= gengetopt_strdup_text_length; ++i)
        printf ("%s\n", gengetopt_strdup_text[i]);
      printf ("\n");
    }
  
  printf (
"int\n"
"%s (int argc, char * const *argv, struct %s *%s)\n"
"{\n"
"  int c;\t/* Character of the parsed option.  */\n"
"  int missing_required_options = 0;\t\n"
"\n", parser_function_name, ARGS_STRUCT_NAME, ARGS_STRUCT);

inc_indent ();

  /* now we initialize "given" fields */
  foropt
    {
      indent ();
      printf ("%s->%s_given = 0 ;\n",
	      ARGS_STRUCT, opt->var_arg);
    }

  printf ("#define clear_args() { \\\n");

	/* now we initialize fields */
  foropt
	if (opt->type == ARG_STRING)
          {
            indent ();
            if (opt->default_given)
              printf ("%s->%s_arg = strdup(\"%s\") ;\\\n",
                      ARGS_STRUCT, opt->var_arg, opt->default_string);
            else
              printf ("%s->%s_arg = NULL; \\\n",
                      ARGS_STRUCT, opt->var_arg);
          }
        else if (opt->type == ARG_FLAG)
          {
            indent ();
            printf ("%s->%s_flag", ARGS_STRUCT, opt->var_arg);
            printf (" = %d;\\\n", opt->flagstat);
          }
        else if (opt->type != ARG_NO && opt->default_given)
          {
            indent ();
            printf ("%s->%s_arg", ARGS_STRUCT, opt->var_arg);
            printf (" = %.0f;\\\n", opt->default_num);
          }

  printf ("}\n\n") ;

  indent ();
  printf ("clear_args();\n") ;

  /* now initialize unamed options */
  if ( unamed_options )
    {
      printf ("\n");
      indent ();
      printf ("%s->inputs = NULL;\n", ARGS_STRUCT) ;
      indent ();
      printf ("%s->inputs_num = 0;\n", ARGS_STRUCT) ;
    }

  printf ("\n");

  /* the following generated instructions are useful, when the
     parser is called more than once. 
     Suggested by Eric H Kinzie <ekinzie@cmf.nrl.navy.mil> */
  indent ();
  printf ("optarg = 0;\n");
  indent ();
  printf ("optind = 1;\n");
  indent ();
  printf ("opterr = 1;\n");
  indent ();
  printf ("optopt = '?';\n");

  printf ("\n");

  indent ();
  printf ("while (1)\n");
  inc_indent ();
  indent ();
  printf ("{\n");
  inc_indent ();
  indent ();
  printf ("int option_index = 0;\n");
  indent ();
  printf ("static struct option long_options[] = {\n");

  inc_indent ();

  foropt
    {
      indent ();
      printf ("{ \"%s\",\t%d, NULL, ", opt->long_opt,
		          (opt->type == ARG_NO || opt->type == ARG_FLAG ? 0 : 1));
      if (opt->short_opt) printf ("\'%c\'", opt->short_opt);
      else printf ("0");
      printf (" },\n");
    }

  indent ();
  printf ("{ NULL,\t0, NULL, 0 }\n");

  dec_indent ();
  indent ();
  printf ("};\n\n");

  indent ();
  printf ("c = getopt_long (argc, argv, \"");

  foropt
    if (opt->short_opt)
	    printf ("%c%s", opt->short_opt,
		        (opt->type == ARG_NO || opt->type == ARG_FLAG ? "" : ":"));

  printf ("\", long_options, &option_index);\n\n");

  indent ();
  printf ("if (c == -1) break;\t/* Exit from `while (1)' loop.  */\n\n");

  indent ();
  printf ("switch (c)\n");
  inc_indent ();
  indent ();
  printf ("{");

  if (! no_handle_help)
    {
      printf ("\n");
      indent ();
      printf ("case 'h':\t/* Print help and exit.  */\n");
      inc_indent ();
      indent ();
      
      printf ("clear_args ();\n");
      indent ();
      printf ("%s_print_help ();\n", parser_function_name);
      indent ();
      printf ("exit (EXIT_SUCCESS);\n");

      dec_indent ();
    }

  if (! no_handle_version)
    {
      printf ("\n");
      indent ();
      printf ("case 'V':\t/* Print version and exit.  */\n");
      inc_indent ();
      indent ();
      printf ("clear_args ();\n");
      indent ();
      printf ("%s_print_version ();\n", parser_function_name);
      indent ();
      printf ("exit (EXIT_SUCCESS);\n");
      dec_indent ();
    }

  /* ****************************************************** */
  /* ********************************************* GENERATE */
  /* ****************************************************** */


  foropt {
    if (
        (opt->short_opt == 'h' && ! no_handle_help) || 
        (opt->short_opt == 'V' && ! no_handle_version)
        ) 
      continue;

    printf ("\n");
    indent ();
    if (opt->short_opt)
    {
        printf ("case '%c':\t/* %s.  */\n", opt->short_opt,
                opt->desc);
        inc_indent ();
        do_check_option_given (opt);
        indent ();

        if (opt->short_opt == 'h' || opt->short_opt == 'V')
          printf ("return 0;\n");
        else
          printf ("break;\n");

        dec_indent ();
    }
  }

  printf ("\n");
  indent ();
  printf ("case 0:\t/* Long option with no short option */\n");
  inc_indent();
  foropt 
      if (!opt->short_opt)
      {
          indent();
          printf ("/* %s.  */\n", opt->desc);
          indent();
          printf ("%sif (strcmp (long_options[option_index].name, "
                  "\"%s\") == 0)\n",
                  ((first_time == 0) ? "else " : ""),
                  opt->long_opt);
          first_time = 0;
          indent();
          printf ("{\n");
          inc_indent();
          do_check_option_given (opt);
          indent ();
          printf ("break;\n");
          dec_indent();
          indent ();
          printf ("}\n");        
      }
  dec_indent ();

  printf ("\n");
  indent ();
  printf ("case '?':\t/* Invalid option.  */\n");
  inc_indent ();
  indent ();
  printf ("/* `getopt_long' already printed an error message.  */\n");
  indent ();
  generate_error_handle ();
  printf ("\n");
  
  dec_indent ();
  indent ();
  printf ("default:\t/* bug: option not considered.  */\n");
  inc_indent ();
  indent ();
  printf ("fprintf (stderr, \"%%s: option unknown: %%c\\n\", PACKAGE, c);\n");
  indent ();
  printf ("abort ();\n");
  dec_indent ();
  indent ();
  printf ("} /* switch */\n");
  dec_indent ();
  dec_indent ();

  indent ();
  printf ("} /* while */\n\n");
  dec_indent ();

  /* write test for required options */
  foropt
    if ( opt->required )
      {
        indent ();
        printf ("if (! %s->%s_given)\n", ARGS_STRUCT, opt->var_arg);
        inc_indent ();
        indent ();
        printf ("{\n"); 
        inc_indent ();
        indent ();
        if (opt->short_opt)
            printf ("fprintf (stderr, \"%%s: `--%s' (`-%c') option required\\n\", PACKAGE);\n", opt->long_opt, opt->short_opt);
        else
            printf ("fprintf (stderr, \"%%s: `--%s' option required\\n\", PACKAGE);\n", opt->long_opt);
        indent ();
        printf ("missing_required_options = 1;\n");
        dec_indent ();
        indent ();
        printf ("}\n\n");
        dec_indent (); 
      }

  /* let's see if everything went fine*/
  indent ();
  printf ("if ( missing_required_options )\n");
  inc_indent ();
  indent ();
  generate_error_handle ();
  printf ("\n");
  dec_indent ();

  /* now handle unamed options */
  if ( unamed_options )
    {
      indent (); 
      printf ("if (optind < argc)\n");
      inc_indent ();
      indent ();
      printf ("{\n");
      
      inc_indent ();
      indent ();
      printf ("int i = 0 ;\n\n");

      indent ();
      printf ("%s->inputs_num = argc - optind ;\n", ARGS_STRUCT);
      indent ();
      printf ("%s->inputs = \n", ARGS_STRUCT);
      indent ();
      printf ("  (char **)(malloc ((%s->inputs_num)*sizeof(char *))) ;\n", 
              ARGS_STRUCT);

      indent ();
      printf ("while (optind < argc)\n");

      inc_indent ();
      indent ();
      printf ("%s->inputs[ i++ ] = strdup (argv[optind++]) ; \n", 
              ARGS_STRUCT);

      dec_indent ();
      dec_indent ();
      indent ();
      printf ("}\n");
      dec_indent (); 
    }

  printf ("\n");
  indent ();
  printf ("return 0;\n");
  printf ("}\n");

  fclose (output_file) ;

  return 0;
}

void inc_indent()
{
  tab_indentation += TAB_LEN ;
}
 
void dec_indent()
{
  tab_indentation -= TAB_LEN ;
}
 
void indent()
{
  register int i ;
  
  for ( i = 1 ; i <= tab_indentation ; ++i )
    printf (" ");
}

void
check_option_given( char *var_arg, char *long_opt, char short_opt )
{
  indent ();
  printf ("if (%s->%s_given)\n", ARGS_STRUCT, var_arg);
  inc_indent ();
  indent ();
  printf ("{\n");
  inc_indent ();
  indent ();
  if (short_opt)
      printf ("fprintf (stderr, \"%%s: `--%s' (`-%c') option given more than once\\n\", PACKAGE);\n", long_opt, short_opt);
  else 
      printf ("fprintf (stderr, \"%%s: `--%s' option given more than once\\n\", PACKAGE);\n", long_opt);
  indent ();
  printf ("clear_args ();\n");
  indent ();
  generate_error_handle ();
  dec_indent ();
  indent ();
  printf ("}\n");
  dec_indent ();
  indent ();
  printf ("%s->%s_given = 1;\n", ARGS_STRUCT, var_arg);
}

void
generate_error_handle()
{
  if (handle_error)
    printf ("exit (EXIT_FAILURE);\n");
  else
    printf ("return (EXIT_FAILURE);\n");
}

/*
  return a copy of the string passed after canonizing it (i.e. '-' and
  '.' are transformed in '_'.
*/
char *
canonize_names (char *name)
{
  char *pvar;
  char *p;

  pvar = strdup (name);

  for (p = pvar; *p; ++p)
    if (*p == '.' || *p == '-') *p = '_';

  return pvar;
}
