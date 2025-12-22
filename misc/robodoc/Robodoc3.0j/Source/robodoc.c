/****h* Autodoc/RoboDoc.c [3.0j]
 * NAME
 *   RoboDoc.c -- AutoDoc formatter
 * COPYRIGHT
 *   (c) 1994-1997  Maverick Software Development
 *   This software is public domain and can be freely redistributed as
 *   long as it is in its original state.
 * FUNCTION
 *   RoboDoc.c is intended to be a replacement for the original AutoDocs
 *   program.  RoboDoc.c will extract the procedure comment headers
 *   from a source file, and put them into a separate documentation file.
 *   There are five different file output formats:
 *       ASCII
 *       HTML (HyperText Markup Langauge) -- mainly used on the Internet;
 *           thus the files can be viewed with a normal HTML viewer/browser
 *       AmigaGuide -- this format can be viewed by AmigaGuide (Amiga only)
 *       LaTeX - as input to LaTeX to produce .dvi files
 *       RTF (Rich Text Format) -- as input to the Help compiler (Windows only)
 * AUTHOR
 *   Frans Slothouber:  <slothoub@xs4all.nl>.
 *     Source code and additional extensions
 *     from version 2.0 and up.
 *
 *   Jacco van Weert: <weertj@IAehv.nl>
 *     Original idea and program.
 *
 *   Bernd Koesling:  <KOESSI@CHESSY.aworld.de>
 *     Bug fixes, functional improvements, code cleanup.
 *
 *   Anthon Pang:  <apang@mindlink.net>
 *     RTF support, Bug fixes.
 *
 *   Thomas Aglassinger: <agi@sbox.tu-graz.ac.at>
 *     Fixes and cleanup of HTML-output
 *
 * CREATION DATE
 *   20-Dec-94
 * MODIFICATION HISTORY
 *   Modifications by Jacco van Weert.
 *     19-Jan-95     -  v0.8:   First test beta-version
 *     26-Jan-95     -  v0.92:  2nd test beta-version
 *     2-Feb-95      -  v0.93:  Mungwall hit, solved.
 *                              When item headers, are also available
 *                              in body then parts are duplicated solved.
 *     Mar-95        -  v1.0a:  Final version
 *     2-Apr-95      -  v1.0b:  Bug fixes
 *                              Procedure header search bug solved.
 *                              Print 'created procedure' text
 *     20-Apr-95     -  v1.1a:  INTERNALONLY option added.
 *                              Sort problem solved.
 *   Modifications by FNC Slothouber.
 *     10-May-1995 -  v2.0a  * Program completely rewritten
 *                           * added SOURCE item and LaTeX output.
 *                           * added TAB converter.
 *     11-May-1995 -  v2.0b  * Accepts headers that start with
 *                             any sequence of non-spaces.
 *                             RoboDoc should work with any
 *                             type of programming language now.
 *     12-May-1995 -  v2.0c  * Bug fixes.
 *     15-May-1995 -  v2.0d  * New Defaults file.
 *                           * Added Verbose option.
 *     24-May-1995 -  v2.0e  * Fixed a bug that cause the
 *                             CleanUp Routine to lock up.
 *                           * Improved the HTML output,
 *                             should work faster now.
 *   Modifications by Koessi
 *     01-Aug-1995  - v2.0?  * more robust parsing, less enforcer-hits
 *                           * removed self-referencing links !
 *                           * remarked most changes with *koessi*
 *                           * added GoldEd-foldmarks
 *                           * compiled successfully with SAS-C 6.3
 *     07-Aug-1995   -       * automated foldmarks "\***"
 *                           ! GoldEd's foldmarks == RoboDoc marker !
 *                           * quoted source parsing enhanced
 *     08-Aug-1995   -       * a lot of while instead of for
 *                           * a lot of switch() instead of ifelse
 *                           * version defined
 *                           * RB_Say, RB_Panic now useable like printf()
 *                             new formats for nearly all output-strings
 *                           * char *whoami is global copy of argv[0]
 *                           * BOLD <- MAKE_LARGE && AMIGAGUIDE
 *                           * succesfully compiled&tested on HPUX
 *                           (HP9000/800)
 *                           * optimized listfunctions
 *                           * encapsulated header- and link-
 *                             allocating and freeing
 *                           * RB_Find_Function_Name() replaced
 *                             with RB_FilePart()
 *  Modifications by FNC Slothouber.
 *    18-Aug-1995   -  v3.0  * New scanner that searches for
 *                             a set default markers that define
 *                             what is a comment or what is not
 *                             and that define what or what is not
 *                             a header/end marker.
 *                           * Added Beast Support
 *    27-Aug-1995   - v3.0b  * Fixed a bug with the defaults file
 *                           * Improved search algorithm
 *                             RoboDoc is now 5.8 times faster.
 *    06-Sep-1995   - v3.0c  * Bug fixes
 *    08-Oct-1995   - v3.0d  * Bug fixes
 *    04-Feb-1996   - v3.0e  * fixed the problem with the TOC
 *                             that included links to headers that
 *                             were not selected. (i.e internal)
 *    Modifications by apang
 *    08-Mar-1996   - v3.0f  * Cleaner build for Borland C++ 4.52
 *                           * Added more markers (C++, Pascal, Modula-2, COBOL)
 *                           * Added more item types/names
 *                           * Added #defines for the preamble (COMMENT_ROBODOC
 *                             and COMMENT_COPYRIGHT)
 *                           * BLANK_HEADER for detection of asterisk'd lines
 *                           * RB_Say() the GENERIC header warning instead of
 *                             using printf()
 *                           * Indents SOURCE body in output
 *                           * ASCII respects the TOC flag; removed extraneous
 *                             newline after formfeed (so it's more like AutoDoc)
 *                           * HTML output fixed to handle '<', '>', and '&'
 *                           * LaTeX attributes and '%' handling added;
 *                             fancied up the output a bit
 *                           * RTF support added
 *                           * Changed some fprintf()'s to fputc()'s for
 *                             potentially lower overhead
 *                           * Fixed line eater bug
 *                           * More general fix to the TOC problem of including
 *                             internal links when it wasn't selected
 *  Modifications by FNC Slothouber.
 *    01-April-1996  - v3.0h * Added ';' to &gt and &lt so lynx also recog. them
 *                           * Fancied up the HTML output.
 *    10-July-1996   - v3.0i * Bug Fix.  Both the options INTERNAL
 *                             and INTERNALONLY did not work correctly.
 *
 *  Modifications by agi
 *    15-Dec-1997    - v3.0j * cleaned the HTML-output, so it now conforms
 *                             to the DTD for HTML-3.2
 *                           * TOC now is an ordered list (<OL> and <LI>)
 *                           * added "<!DOCTYPE..>"
 *                           * added quotes to values of some HTML-attributes
 *                           * more compatible implementation of the
 *                             SGML-comment containing copyright-info
 *                           * replaced all occurrences of <B><PRE>.. by
 *                             <PRE><B>
 *                           * replaced <H2/3> by <H1/2>
 *                           * fixed two minor warnings reported by gcc -Wall
 *
 * NOTES
 *   Has been succesfully compiled:
 *     On an Amiga with SAS/C, DICE C and gcc (Amiga 1200)
 *     On a Sun Sparc Station with gcc   (under SunOS 4.1)
 *     On a Dec Alpha Station
 *     Under HP/UX on a HP9000/800
 *     On a Linux box with gcc.
 * BUGS
 *   - HTML output is not Lynx friendly -- attributes are applied
 *     to leading white space =P ... solution: fix Lynx  >=)
 *   - Can't get the escape character for @ to work in
 *     AmigaGuide format.
 *   Other bugs?
 *     Catch them in a jar and send them to slothoub@xs4all.nl.
 ****/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h> /* for RB_Say() */

#include "robodoc.h"

#define RB_VERSION "3.0j"

static char RB_VER[] = "$VER: robodoc "RB_VERSION" (" __DATE__ ")";

#define COMMENT_ROBODOC \
    "Generated with RoboDoc v" RB_VERSION " (" __DATE__ ")\n"
#define COMMENT_COPYRIGHT \
    "RoboDoc is copyright 1994-1997 by Maverick Software Development\n"

/****** RoboDoc.c/header_markers [3.0h]
 * NAME
 *   header_markers
 * FUNCTION
 *   These specify what robodoc will recognize as the beginning
 *   of a header.
 * SOURCE
 */

char *header_markers[] = {
    "/****",                    /* C, C++ */
    "//****",                   /* C++ */
    "(****",                    /* Pascal, Modula-2, B52 */
    "{****",                    /* Pascal */
    ";****",                    /* M68K assembler */
    "****",                     /* M68K assembler */
    "C     ****",               /* Fortran */
    "REM ****",                 /* BASIC */
    "%****",                    /* LaTeX, TeX, Postscript */
    "      ****",               /* COBOL */
    NULL } ;

/****/


/****** RoboDoc.c/remark_markers [3.0h]
 * NAME
 *   remark_markers
 * FUNCTION
 *   These specify what robodoc will recognize as a comment marker.
 * SOURCE
 */

char *remark_markers[] = {
    " *",                       /* C, C++, Pascal, Modula-2 */
    "//",                       /* C++ */
    "*",                        /* C, C++, M68K assembler, Pascal, Modula-2 */
    ";*",                       /* M68K assembler */
    ";",                        /* M68K assembler */
    "C    ",                    /* Fortran */
    "REM ",                     /* BASIC */
    "%",                        /* LaTeX, TeX, Postscript */
    "      *",                  /* COBOL */
    NULL } ;

/****/


/****** RoboDoc.c/end_markers [3.0h]
 * NAME
 *   end_markers
 * FUNCTION
 *   These specify what robodoc will recognize as the
 *   end of a documentation header.
 * SOURCE
 */

char *end_markers[] = {
    "/***",                     /* C, C++ */
    "//***",                    /* C++ */
    " ***",                     /* C, C++, Pascal, Modula-2 */
    "{***",                     /* Pascal */
    "(***",                     /* Pascal, Modula-2, B52 */
    ";***",                     /* M68K assembler */
    "***",                      /* M68K assembler */
    "C     ***",                /* Fortran */
    "REM ***",                  /* BASIC */
    "%***",                     /* LaTeX, TeX, Postscript */
    "      ***",                /* COBOL */
    NULL } ;

/****/


/* Header Types etc... */

enum { NO_HEADER = 0, MAIN_HEADER, GENERIC_HEADER, INTERNAL_HEADER, BLANK_HEADER } ;

/****** RoboDoc.c/output_mode [2.0]
 * NAME
 *   output_mode -- the mode of output
 * FUNCTION
 *   Controls which type of output will be generated.
 * SOURCE
 */

/* Output Modes */

enum { ASCII = 0, AMIGAGUIDE, HTML, LATEX, RTF, SIZE_MODES } ;

/* Reserved for Future Use */

enum { ANSI, GNUINFO, TROFF } ;


/* Global Variable that defines the output mode */

int output_mode = ASCII;

/****/


/****** RoboDoc.c/item_names [3.0g]
 * NAME
 *   item_names
 * SYNOPSIS
 *   char *item_names[]
 * FUNCTION
 *   used for strcmp() in RB_Get_Item_Type()
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Get_Item_Type(), item_attributes, item_attr_names
 * SOURCE
 */

char *item_names[] =
{
  NULL, "NAME", "COPYRIGHT", "SYNOPSIS",
  "FUNCTION", "DESCRIPTION", "AUTHOR",
  "CREATION DATE", "MODIFICATION HISTORY", "HISTORY",
  "INPUTS", "ARGUMENTS", "OPTIONS", "PARAMETERS", "SWITCHES",
  "OUTPUT", "SIDE EFFECTS", "RESULT", "RETURN VALUE",
  "EXAMPLE", "NOTES", "DIAGNOSTICS",
  "WARNINGS", "ERRORS", "BUGS", "TODO", "IDEAS",
  "PORTABILITY", "SEE ALSO", "SOURCE",
  "BEAST METHODS", "NEW METHODS",
  "BEAST ATTRIBUTES", "NEW ATTRIBUTES",
  NULL,
};

/* Item Types */
enum
{
  NO_ITEM = 0,  NAME_ITEM,  COPYRIGHT_ITEM,  SYNOPSIS_ITEM,
  FUNCTION_ITEM,  DESCRIPTION_ITEM, AUTHOR_ITEM,
  CREATION_DATE_ITEM,  MODIFICATION_HISTORY_ITEM,  HISTORY_ITEM,
  INPUT_ITEM,  ARGUMENT_ITEM,  OPTION_ITEM,  PARAMETER_ITEM,  SWITCH_ITEM,
  OUTPUT_ITEM,  SIDE_EFFECTS_ITEM,  RESULT_ITEM,  RETURN_VALUE_ITEM,
  EXAMPLE_ITEM,  NOTE_ITEM,  DIAGNOSTICS_ITEM,
  WARNING_ITEM,  ERROR_ITEM,  BUGS_ITEM,  TODO_ITEM,  IDEAS_ITEM,
  PORTABILITY_ITEM,  SEE_ALSO_ITEM,  SOURCE_ITEM,
  BEAST_METHODS,  NEW_METHODS,
  BEAST_ATTRIBUTES,  NEW_ATTRIBUTES,  OTHER_ITEM,
  NUMBER_OF_ITEMS
};

/****/


/****** RoboDoc.c/item_attributes [3.0h]
 * NAME
 *   item_attributes -- attributes of the various items
 * FUNCTION
 *   links each item type with a text attribute.
 * SEE ALSO
 *   RB_Get_Item_Type(), item_names, item_attr_names
 * SOURCE
 */

enum
{
  MAKE_NORMAL = -1,  MAKE_LARGE, MAKE_ITALICS, MAKE_NON_PROP, MAKE_SMALL,
  MAKE_BOLD, MAKE_UNDERLINE, MAKE_SHINE, MAKE_HIGH, SIZE_ATTRIBUTES
};

#define ITEM_NAME_LARGE_FONT (1<<0)
#define TEXT_BODY_LARGE_FONT (1<<(MAKE_LARGE     + 1))
#define TEXT_BODY_ITALICS    (1<<(MAKE_ITALICS   + 1))
#define TEXT_BODY_NON_PROP   (1<<(MAKE_NON_PROP  + 1))
#define TEXT_BODY_SMALL_FONT (1<<(MAKE_SMALL     + 1))
#define TEXT_BODY_BOLD       (1<<(MAKE_BOLD      + 1))
#define TEXT_BODY_UNDERLINE  (1<<(MAKE_UNDERLINE + 1))
#define TEXT_BODY_SHINE      (1<<(MAKE_SHINE     + 1))
#define TEXT_BODY_HIGHLIGHT  (1<<(MAKE_HIGH      + 1))

long item_attributes[NUMBER_OF_ITEMS] =
{
  0                                    , /* NO_ITEM */
  ITEM_NAME_LARGE_FONT|TEXT_BODY_SHINE , /* NAME_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* COPYRIGHT_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* SYNOPSIS_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* FUNCTION_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* DESCRIPTION_ITEM */
  ITEM_NAME_LARGE_FONT|TEXT_BODY_BOLD  , /* AUTHOR_ITEM */
  ITEM_NAME_LARGE_FONT|TEXT_BODY_BOLD  , /* CREATION_DATE_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* MODIFICATION_HISTORY_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* HISTORY_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* INPUT_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* ARGUMENT_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* OPTION_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* PARAMETER_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* SWITCH_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* OUTPUT_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* SIDE_EFFECTS_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* RESULT_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* RETURN_VALUE_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* EXAMPLE_ITEM */
  ITEM_NAME_LARGE_FONT|TEXT_BODY_SHINE , /* NOTE_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* DIAGNOSTICS_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* WARNING_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* ERROR_ITEM */
  ITEM_NAME_LARGE_FONT|TEXT_BODY_SHINE , /* BUGS_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* TODO_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* IDEAS_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* PORTABILITY_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* SEE_ALSO_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* SOURCE_ITEM */
  ITEM_NAME_LARGE_FONT                 , /* BEAST METHODS */
  ITEM_NAME_LARGE_FONT                 , /* NEW METHODS */
  ITEM_NAME_LARGE_FONT                 , /* BEAST ATTRIBUTES */
  ITEM_NAME_LARGE_FONT                 , /* NEW ATTRIBUTES" */
  0                                      /* OTHER_ITEM */
};

/****/


/****** RoboDoc.c/item_attr_names [3.0j]
 * NAME
 *   item_attr_names
 * SYNOPSIS
 *   char *item_attr_names[]
 * FUNCTION
 *   used for strcmp() in RB_Get_Item_Attr()
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Get_Item_Attr(), item_attributes, item_names
 * SOURCE
 */

char *item_attr_names[] =
{
/*  "NORMAL", */
  "LARGE",  "ITALICS",  "NONPROP",  "SMALL",  "BOLD",
  "UNDERLINE",   "SHINE",  "HIGHLIGHT"
};

/* ASCII AMIGAGUIDE HTML LATEX RTF */

char *att_start_command[SIZE_ATTRIBUTES][SIZE_MODES] =
{
  {"", "@{b}"           , "<FONT SIZE=\"+1\">", "{\\large "   , "\\par\\fs28 "}, /* Large Font */
  {"", "@{i}"           , "<I>"               , "{\\it "      , "\\i1 "       }, /* Italics. */
  {"", ""               , ""                  , ""            , ""            }, /* NON-Proportional font. */
  {"", ""               , "<SMALL>"           , "{\\small "   , "\\fs16 "     }, /* Small Font. */
  {"", "@{b}"           , "<B>"               , "{\\bf "      , "\\b1 "       }, /* Bold. */
  {"", "@{u}"           , "<U>"               , "\\underline{", "\\ul1 "      }, /* Underline */
  {"", "@{fg shine}"    , "<EM>"              , "{\\em "      , ""            }, /* Shine */
  {"", "@{fg highlight}", "<EM>"              , "{\\em "      , ""            }  /* Highlight */
};

char *att_stop_command[SIZE_ATTRIBUTES][SIZE_MODES] =
{
  {"", "@{ub}"          , "</FONT>"           , "}"           , "\\fs20\\line "}, /* Large Font */
  {"", "@{ui}"          , "</I>"              , "}"           , "\\i0 "        }, /* Italics. */
  {"", ""               , ""                  , ""            , ""             }, /* NON-Proportional font. */
  {"", ""               , "</SMALL>"          , "}"           , "\\fs20 "      }, /* Small Font. */
  {"", "@{ub}"          , "</B>"              , "}"           , "\\b0 "        }, /* Bold. */
  {"", "@{uu}"          , "</U>"              , "}"           , "\\ul0 "       }, /* Underline */
  {"", "@{fg text}"     , "</EM>"             , "}"           , ""             }, /* Shine */
  {"", "@{fg text}"     , "</EM>"             , "}"           , ""             }  /* Highlight */
};

/****/


/****** RoboDoc.c/course_of_action [2.0]
 * NAME
 *   course_of_action
 * FUNCTION
 *   Global Variable that defines the course of action.
 * SOURCE
 */

#define DO_SORT             (1<<0)
#define DO_MAKE_XREFS       (1<<1)
#define DO_USE_XREFS        (1<<2)
#define DO_TOC              (1<<3)
#define DO_MAKE_DOCUMENT    (1<<4)
#define DO_INCLUDE_INTERNAL (1<<5)
#define DO_INTERNAL_ONLY    (1<<6)
#define DO_TELL             (1<<7)

int course_of_action = DO_MAKE_DOCUMENT;

/****/


/****** RoboDoc.c/line_buffer [2.0]
 * NAME
 *   line_buffer -- global line buffer
 * FUNCTION
 *   Temporary storage area for lines
 *   that are read from an input file.
 * SOURCE
 */

#define MAX_LINE_LEN 512
char line_buffer[MAX_LINE_LEN];

/****/


/****** RoboDoc.c/line_number [2.0]
 * NAME
 *   line_number -- global line counter
 * FUNCTION
 *   count the lines that are read from an input file.
 * AUTHOR
 *   Koessi
 * SOURCE
 */

int line_number = 0;

/****/


/****** RoboDoc.c/use [3.0h]
 * NAME
 *   use -- usage string
 * FUNCTION
 *   inform the user how to use me
 * AUTHOR
 *   Koessi
 * SOURCE
 */

char use[] =
  "\nRoboDoc v" RB_VERSION ", autodocs formatter\n\n"
  "(c) " __DATE__ ", Maverick Software Development\n"
  "Original idea and program:  Jacco van Weert   <weertj@iaehv.nl>\n"
  "Version 2.0 and up:         Frans Slothouber  <slothoub@xs4all.nl>\n"
  "RTF support:                Anthon Pang       <apang@mindlink.net>\n"
  "\nFORMAT\n"
  "  robodoc filename docfilename\n"
  "\nIn addition you can use one or more of the following options:\n"
  "  GENXREF <xref_filename>  - to generate an xref file.\n"
  "  XREF <xreflist_filename> - if you want to use xref files to create\n"
  "                             cross links\n"
  "  TABSIZE <nr_sp>          - convert each TAB to nr_sp of spaces.\n"
  "  TOC          - a table of contents will be generated.\n"
  "  SORT         - the headers will be sorted.\n"
  "  -v           - tell robodoc to tell you all about it.\n"
  "  INTERNAL     - headers marked internal will also be included.\n"
  "  INTERNALONLY - only headers marked internal will be included.\n"
  "\nThe type of output is selected with one of the following switches:\n"
  "  ASCII, GUIDE, HTML, LATEX, or RTF\n"
  "\nThe following abbreviations are also allowed:\n"
  "  TOC = -t  XREF = -x   SORT = -s  INTERNAL = -i \n"
  "  GENXREF = -g  INTERNALONLY = -io  TABSIZE = -ts\n";

/****/


/* Global variables & prototypes */

char *whoami = NULL; /* me,myself&i */
int tab_size = 8;

struct RB_header *first_header = NULL;
struct RB_header *last_header  = NULL;
struct RB_link   *first_link   = NULL;

int header_index_size = 0 ;
struct RB_header **header_index = NULL ;

int link_index_size = 0 ;
struct RB_link   **link_index   = NULL ;

FILE *document = NULL;
FILE *dest_doc = NULL;
FILE *xreffiles_file = NULL;
FILE *xref_file = NULL;

void RB_Analyse_Document  (FILE *);
void RB_Analyse_Xrefs     (FILE *);
void RB_Analyse_Arguments (int, char **, char **, char **);
void RB_Analyse_Defaults_File(void);

int RB_Find_Marker     (FILE *);
int RB_Find_End_Marker (FILE *, int *);
int RB_Find_Item       (char **, char **);
char *RB_Find_Header_Name(void);

void RB_Generate_xrefs         (FILE * dest_doc, char *, char *) ;
void RB_Generate_Documentation (FILE *, char *, char *) ;
void RB_Generate_Item_Doc      (FILE *, char *, char *, char *, char *, int) ;
void RB_Generate_Item_Body     (FILE *, char *, char *, char *, char *, int) ;
void RB_Generate_Header_Name   (FILE *, char *) ;
void RB_Generate_Item_Name     (FILE *, int) ;
void RB_Generate_Doc_Start     (FILE *, char *, char *) ;
void RB_Generate_Doc_End       (FILE *, char *) ;
void RB_Generate_Header_Start  (FILE *, struct RB_header *) ;
void RB_Generate_Header_End    (FILE *, struct RB_header *) ;
void RB_Close_The_Shop         (void);
void RB_Make_Index_Tables      (void) ;

void RB_Remove_From_List (struct RB_header **, struct RB_header *);
void RB_Insert_In_List   (struct RB_header **, struct RB_header *);
void RB_Slow_Sort        (void);
void RB_Add_Link         (void);
int  RB_Find_Link        (char *, char **, char **);

char *RB_FilePart      (char *);
int   RB_Get_Item_Type (char *);
int   RB_WordLen       (char *);
char *RB_StrDup        (char *);
char *RB_CookStr       (char *);

struct RB_header *RB_Alloc_Header(void);
void   RB_Free_Header(struct RB_header *);

struct RB_link *RB_Alloc_Link(char *, char *);
void   RB_Free_Link(struct RB_link *);

void   RB_Say   (char *, ...);
void   RB_Panic (char *, ...);

char *RB_Skip_Remark_Marker (char *line_buffer) ;

/********/


/****i* RoboDoc.c/_main [2.0d]
 * NAME
 *   _main -- Entry point of RoboDoc.c
 * SYNOPSIS
 *   main (int argc, char **argv)
 * FUNCTION
 *   Get and parse the arguments.
 *   Analyse document.
 * SOURCE
 */

int main(int argc, char **argv)
{
  char *file_with_xrefs, *output_file_for_xrefs ;

  whoami = argv[0] ;  /* global me,myself&i */
  if ((argc < 3) || (*argv[1] == '?'))
  {
    printf(use);
  }
  else
  {
    RB_Analyse_Arguments(argc, argv, &file_with_xrefs, &output_file_for_xrefs);

    RB_Say("Analysing Defaults File\n") ;
    RB_Analyse_Defaults_File () ;

    RB_Say("trying to open source file \"%s\"\n", argv[1]);
    if ((document = fopen(argv[1], "r")) != NULL)
    {
      RB_Say("analysing source file \"%s\"\n", argv[1]);
      RB_Analyse_Document(document);

      if (course_of_action & DO_SORT)
      {
        RB_Say("sorting headers\n");
        RB_Slow_Sort();
      }
      if ((course_of_action & DO_USE_XREFS) && file_with_xrefs)
      {
        if ((xreffiles_file = fopen(file_with_xrefs, "r")) != NULL)
        {
          RB_Analyse_Xrefs(xreffiles_file);
        }
        else
        {
          RB_Panic("can't open file with xref files \"%s\"\n", file_with_xrefs);
        }
      }
      if (course_of_action & DO_MAKE_DOCUMENT)
      {
        RB_Say("trying to open destination file \"%s\"\n", argv[2]);
        if ((dest_doc = fopen(argv[2], "w")) != NULL)
        {
          RB_Say("generating documentation\n");
          RB_Generate_Documentation(dest_doc, RB_FilePart(argv[1]), RB_FilePart(argv[2]));  /* additional function *koessi */
          fclose(dest_doc);
          dest_doc = NULL;
        }
        else RB_Panic("can't open destination file \"%s\"\n", argv[2]);
      }
      if ((course_of_action & DO_MAKE_XREFS) && output_file_for_xrefs)
      {
        RB_Say("trying to open xref destination file \"%s\"\n", output_file_for_xrefs);
        if ((dest_doc = fopen(output_file_for_xrefs, "w")) != NULL)
        {
          RB_Say("generating xref destination file \"%s\"\n", output_file_for_xrefs);
          RB_Generate_xrefs(dest_doc, argv[1], argv[2]);
          fclose(dest_doc);
          dest_doc = NULL;
        }
        else RB_Panic("can't open xref destination file \"%s\"\n", output_file_for_xrefs);
      }
    }
    else RB_Panic("can't open source file \"%s\"\n", argv[1]);
  }
  RB_Say("Ready\n");
  RB_Close_The_Shop();
  return (0);
}

/*** main ***/


/****** RoboDoc.c/RB_FilePart [2.0x]
 * NAME
 *   RB_FilePart
 * SYNOPSIS
 *   char *RB_FilePart(char *file_name)
 * FUNCTION
 *   return the basename (like Amiga/Dos/FilePart())
 * NOTES
 *   koessi
 * SEE ALSO
 * SOURCE
 */

char *RB_FilePart(char *file_name)
{
  char *cur_char;
  char c;

  if ((cur_char = file_name) != NULL)
  {
    for (; (c = *cur_char) != '\0'; ++cur_char)
    {
      if ((c == '/') || (c == ':'))
      {
        ++cur_char;
        while ('/' == *cur_char)
          ++cur_char;

        if (*cur_char)
          file_name = cur_char;
      }
    }
  }
  return (file_name);
}

/*** RB_File_Part ***/


/****** RoboDoc.c/RB_Get_Item_Type [3.0b]
 * NAME
 *   RB_Get_Item_Type -- shortcut
 * SYNOPSIS
 *   int RB_Get_Item_Type( char *cmp_name )
 * FUNCTION
 *   return the item_type represented by the given string
 * INPUTS
 *   char *cmp_name          -- item_name to evaluate
 * RESULT
 *   int                     -- the right item_type or NO_ITEM
 * NOTES
 *   uses global char *item_names[]
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Analyse_Defaults_File(), RB_Get_Item_Attr()
 * SOURCE
 */

int RB_Get_Item_Type(char *cmp_name)
{
  int  item_type;
  for (item_type = NAME_ITEM; item_type < OTHER_ITEM; ++item_type)
  {
    if (!strncmp(item_names[item_type], cmp_name, strlen(item_names[item_type])))
      return(item_type);
  }
  return(NO_ITEM);
}

/*** RB_Get_Item_Type ***/


/****** RoboDoc.c/RB_Get_Item_Attr [3.0b]
 *
 * NAME
 *   RB_Get_Item_Attr -- shortcut
 * SYNOPSIS
 *   int RB_Get_Item_Attr( char *cmp_name )
 * FUNCTION
 *   return the item_attr represented by the given string
 * INPUTS
 *   char *cmp_name  -- item_attr_name to evaluate
 * RESULT
 *   int             -- the right item_attr or NULL
 * NOTES
 *   uses global char *item_attr_names[]
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Analyse_Defaults_File(), RB_Get_Item_Type()
 * SOURCE
 */

int RB_Get_Item_Attr(char *cmp_name)
{
  int  item_attr;
  for (item_attr = MAKE_LARGE; item_attr < SIZE_ATTRIBUTES; ++item_attr)
    if (!strcmp(item_attr_names[item_attr], cmp_name))
      return(item_attr);
  if (strcmp("NORMAL", cmp_name))
  {
    printf ("%s: Warning unknown attribute [%s] in defaults file.\n",whoami, cmp_name) ;
  }
  return(MAKE_NORMAL);
}

/*** RB_Get_Item_Attr ***/


/****** RoboDoc.c/RB_Analyse_Defaults_File [3.0b]
 * NAME
 *   RB_Analyse_Defaults_file -- read default from defaults file
 * SYNOPSIS
 *   RB_Analyse_Defaults_file
 * FUNCTION
 *   Read the default vaules from the default file.
 * SEE ALSO
 * SOURCE
 */

void RB_Analyse_Defaults_File()
{
  FILE *defaults_file;

  if ((defaults_file = fopen("robodoc.defaults", "r")) != NULL)
  {
    while (!feof(defaults_file))
    {
      char *cur_char;
      *line_buffer = '\0';

      fgets(line_buffer, MAX_LINE_LEN, defaults_file);

      if (*line_buffer != '\n')
      {
        int   item_type;
        item_type = RB_Get_Item_Type(line_buffer);
        if (item_type != NO_ITEM)
        {
          char *values ;

          item_attributes[item_type] = ITEM_NAME_LARGE_FONT ;

          cur_char = line_buffer + strlen(item_names[item_type]) ;
          for (; *cur_char && isspace(*cur_char); cur_char++) ;

          while (*cur_char)
          {
            for (values = cur_char;
                 *cur_char && !isspace(*cur_char);
                 cur_char++) ;
            if (*cur_char)
            {
              int item_attr;
              *cur_char = '\0';
              item_attr = RB_Get_Item_Attr(values) ;
              if (item_attr != MAKE_NORMAL)
              {
                RB_Say ("Default: %s = %s\n", item_names[item_type],
                                              item_attr_names[item_attr]) ;
                item_attributes[item_type] |= (1<<(item_attr+1)) ;
              }
            }
            for (cur_char++; *cur_char && isspace(*cur_char); cur_char++) ;
          }
        }
      }
    }
    fclose(defaults_file);
  }
  else
  {
    printf("%s: WARNING, robodoc.defaults file was not found.\n", whoami);
    printf("\t\tyou should really use one.\n");
  }
}

/*** RB_Analyse_Defaults_File ***/


/****** RoboDoc.c/RB_Analyse_Arguments [3.0h]
 * NAME
 *   RB_Analyse_Arguments
 * SYNOPSIS
 *   RB_Analyse_Arguments (argc, argv, file_with_xrefs,
 *                         output_file_for_xrefs)
 *   RB_Analyse_Arguments (int, char **, char **, char **)
 * FUNCTION
 *   Get and parse the arguments.
 * SEE ALSO
 * SOURCE
 */

void RB_Analyse_Arguments(int argc, char **argv,
                          char **file_with_xrefs,
                          char **output_file_for_xrefs)
{
  char **parameter;
  int parameter_nr;

  for (parameter_nr = argc - 3, parameter = argv + 3;
       parameter_nr > 0;
       parameter++, parameter_nr--)
  {
    char *cur_char ;

    for (cur_char = *parameter ; *cur_char ; cur_char++)
        *cur_char = toupper(*cur_char) ;

    if      (!strcmp(*parameter, "HTML"))  output_mode = HTML;
    else if (!strcmp(*parameter, "GUIDE")) output_mode = AMIGAGUIDE;
    else if (!strcmp(*parameter, "LATEX")) output_mode = LATEX;
    else if (!strcmp(*parameter, "ASCII")) output_mode = ASCII;
    else if (!strcmp(*parameter, "RTF"))   output_mode = RTF;
    else if (!strcmp(*parameter, "SORT") ||  !strcmp(*parameter, "-S"))
      course_of_action |= DO_SORT;
    else if (!strcmp(*parameter, "INTERNAL") || !strcmp(*parameter, "-I"))
      course_of_action |= DO_INCLUDE_INTERNAL;
    else if (!strcmp(*parameter, "INTERNALONLY") || !strcmp(*parameter, "-IO"))
      course_of_action |= DO_INTERNAL_ONLY;
    else if (!strcmp(*parameter, "TOC") || !strcmp(*parameter, "-T"))
      course_of_action |= DO_TOC;
    else if (!strcmp(*parameter, "-V")) course_of_action |= DO_TELL;
    else if (!strcmp(*parameter, "XREF") || !strcmp(*parameter, "-X"))
    {
      if (--parameter_nr)
      {
        parameter++ ;
        *file_with_xrefs = *parameter ;
        RB_Say ("XREF=\"%s\"\n", *file_with_xrefs) ;
        course_of_action |= DO_USE_XREFS ;
      }
      else RB_Panic("you must specify a xref file with the XREF option\n");
    }
    else if (!strcmp(*parameter, "TABSIZE") || !strcmp(*parameter, "-TS"))
    {
      if (--parameter_nr)
      {
        parameter++ ;
        tab_size = atoi(*parameter);
      }
      else
      {
        RB_Panic("you must specify the number of spaces with the TABSIZE option\n");
      }
    }
    else if (!strcmp(*parameter, "GENXREF") || !strcmp(*parameter, "-G"))
    {
      if (--parameter_nr)
      {
        ++parameter;
        *output_file_for_xrefs = *parameter;
        RB_Say("GENXREF=\"%s\"\n", *output_file_for_xrefs);
        course_of_action |= DO_MAKE_XREFS;
        course_of_action &= ~DO_MAKE_DOCUMENT;
      }
      else RB_Panic("you must specify a xref file with the GENXREF option\n");
    }
    else RB_Panic("unknown option \"%s\"\n", *parameter);
  }

  if ((course_of_action & DO_USE_XREFS) && (output_mode == ASCII || output_mode == LATEX))
  {
    printf("%s: WARNING, you can not use xrefs when you generate\n"
           "\t\tdocumentation in ASCII or LaTeX [discarding switch]\n", argv[0]);
    course_of_action &= ~DO_USE_XREFS;
  }
}

/*** RB_Analyse_Arguments ***/


/****** RoboDoc.c/RB_Analyse_Xrefs [3.0b]
 * NAME
 *   RB_Analyse_Xrefs -- scan the xref files.
 * SYNOPSIS
 *   RB_Analyse_Xrefs (xreffiles_file)
 *   RB_Analyse_Xrefs (FILE *)
 * FUNCTION
 *   Scan the file xreffiles_file. This file contains the
 *   names of one or more xref files. All the references in the
 *   files are scaned and stored in a link list of the type
 *   RB_link.
 *   These xref files can be generated with robodoc.
 * INPUTS
 *   xreffiles_file - a file pointer to the file with xref file
 *   names.
 * RESULT
 *   none
 * BUGS
 *   Might fail if there are syntax errors in one of the xref
 *   files.
 * SEE ALSO
 *   RB_Generate_xrefs, RB_Add_Link
 * SOURCE
 */

void RB_Analyse_Xrefs(FILE * xreffiles_file)
{
  while(!feof(xreffiles_file))
  {
    fgets(line_buffer, MAX_LINE_LEN, xreffiles_file);
    if (!feof(xreffiles_file))
    {
      char *cur_char;
      cur_char = line_buffer; find_eol ;
      if (*cur_char == '\n') *cur_char = '\0';
      if ((xref_file = fopen(line_buffer, "r")) != NULL)
      {
        int xrefs_found  = FALSE;
        int end_of_xrefs = FALSE;

        while(!feof(xref_file) && !xrefs_found)
        {
          fgets(line_buffer, MAX_LINE_LEN, xref_file);
          if (!feof(xref_file) && !strncmp("XREF:", line_buffer, 5))
            xrefs_found = TRUE;
        }

        while(!feof(xref_file) && !end_of_xrefs)
        {
          fgets(line_buffer, MAX_LINE_LEN, xref_file);
          if (!feof(xref_file))
          {
            cur_char = line_buffer; find_quote ;
            if (*cur_char == '\"') RB_Add_Link();
            else end_of_xrefs = TRUE;
          }
        }
        fclose(xref_file);
        xref_file = NULL;
      }
      else RB_Panic("could not open xref file \"%s\"\n", line_buffer);
    }
  }
}

/*** RB_Analyse_Xrefs */


/****i* RoboDoc.c/RB_Add_Link [3.0b]
 * NAME
 *   RB_Add_Link -- add a reference link to the list
 * SYNOPSIS
 *   void RB_Add_Link ()
 * FUNCTION
 *   Adds a reference from a xref file to the linked list
 *   with references.
 * INPUTS
 *   Uses the global variable line_buffer and first_link.
 * NOTES
 *   Makes sneaky use of the function RB_Insert_In_List.
 * SEE ALSO
 *   RB_Analyse_Xrefs, RB_link.
 * SOURCE
 */

void RB_Add_Link()
{
  char *label_name, *file_name;
  struct RB_link *new_link;
  char *cur_char = line_buffer;
  find_quote ; label_name = ++cur_char; find_quote ; *cur_char++ = '\0';
  find_quote ; file_name  = ++cur_char; find_quote ; *cur_char = '\0';
  RB_Say("adding xref link \"%s\"->\"%s\"\n", label_name, file_name);

  new_link = RB_Alloc_Link(label_name, file_name);
  RB_Insert_In_List((struct RB_header **)&first_link,
                    (struct RB_header *)new_link);
}

/*** RB_Add_Link ***/


/****** RoboDoc.c/RB_Analyse_Document [3.0i]
 * NAME
 *   RB_Analyse_Document -- scan document for headers and store them
 * SYNOPSIS
 *   RB_Analyse_Document (document)
 *   RB_Analyse_Document (FILE *)
 * FUNCTION
 *   Searches the document for headers. Stores information about
 *   any headers that are found in a linked list. Information
 *   that is stored includes, the name of the header, its version
 *   number, and its contents.
 * INPUTS
 *   document - a pointer to a file with the document to be
 *              analysed
 *   the gobal buffer line_buffer.
 * RESULT
 *   1)   A linked list pointed to by the global variable
 *        first_header that contains information about each
 *        header.
 * NOTES
 *   Using fseek and ftell because gcc doesn't know fgetpos and fsetpos,
 *   on the sun unix system that I use
 * SEE ALSO
 *   RB_Find_Marker
 * SOURCE
 */

void RB_Analyse_Document (FILE * document)
{
  int header_type;
  int real_size;
  char *name ;

  for (;
       (header_type = RB_Find_Marker(document)) != NO_HEADER ;
      )
  {
    long cur_file_pos;
    struct RB_header *new_header;
    if (!
        (
         ((header_type == INTERNAL_HEADER) && !(course_of_action & (DO_INCLUDE_INTERNAL | DO_INTERNAL_ONLY)))
         ||
         ((header_type != INTERNAL_HEADER) && (course_of_action & DO_INTERNAL_ONLY))
         ||
         (header_type == BLANK_HEADER)
        )
       )
    {
      new_header = RB_Alloc_Header();
      RB_Insert_In_List(&first_header, new_header);
      new_header->type = header_type;
      if ((new_header->name = RB_Find_Header_Name()) != NULL)
      {
        RB_Say("found header [line %5d]: \"%s\"\n", line_number, new_header->name);
        new_header->function_name = RB_FilePart(new_header->name);
        cur_file_pos = (long)ftell(document);
        if ((real_size = RB_Find_End_Marker(document, &new_header->size)) != 0)
        {
          char *contents;

          fseek(document, cur_file_pos, 0);
          if ((contents = (char *)malloc((new_header->size + 2) * sizeof(char))) != NULL)
          {
            fread(contents, new_header->size, sizeof(char), document);
            contents[real_size]  = '\0';
            new_header->contents = contents;
            new_header->size     = real_size;
          } else RB_Panic("out of memory! [Alloc Header Contents]\n");
        }
        else
        {
          RB_Panic("found header with no end marker \"%s\"\n", new_header->name);
        }
      }
      else
      {
        RB_Panic("found header marker but no name [line %d]\n", line_number);
      }
    }
    else
    {
      if (header_type != BLANK_HEADER)
      {
        if ((name = RB_Find_Header_Name()) != NULL)
        {
          if ((real_size = RB_Find_End_Marker(document, &new_header->size)) == 0)
          {
            RB_Panic("found header with no end marker \"%s\"\n", name);
          }
        }
        else
        {
          RB_Panic("found header marker but no name [line %d]\n", line_number);
        }
      }
    }
  }
}

/*** RB_Analyse_Document ***/


/****** RoboDoc.c/RB_Find_Marker [3.0h]
 * NAME
 *   RB_Find_Marker -- Search for header marker in document.
 * SYNOPSIS
 *   header_type = RB_Find_Marker (document)
 *             int RB_Find_Marker (FILE *)
 * FUNCTION
 *   Read document file line by line, and search each line for the
 *   any of the headers defined in the array  header_markers
 * INPUTS
 *   document - pointer to the file to be searched.
 *   the gobal buffer line_buffer.
 * RESULT
 *   header type
 *   can be:
 *    (1) NO_HEADER - no header found, end of file reached
 *    (2) MAIN_HEADER
 *    (3) GENERIC_HEADER
 *    (4) INTERNAL_HEADER
 * SEE ALSO
 *   RB_Find_End_Marker
 * SOURCE
 */

int RB_Find_Marker(FILE * document)
{
  int found;
  int marker, marker_type ;
  char *cur_char, *cur_mchar ;

  found = FALSE ;
  while( !feof(document) && !found)
  {
    *line_buffer = '\0';
    fgets(line_buffer, MAX_LINE_LEN, document);
    if (!feof(document))
    {
      line_number++;
      for (marker=0 ;
           ((cur_mchar = header_markers[marker]) != NULL) && !found ;
           marker++)
      {
        for (found = TRUE, cur_char = line_buffer;
             *cur_mchar && *cur_char && found;
              cur_mchar++, cur_char++)
        {
          if (*cur_mchar != *cur_char) found = FALSE ;
        }
      }
      if (found)
      {
        switch (*cur_char)
        {
          case 'h': marker_type = MAIN_HEADER ;     break ;
          case '*': marker_type = GENERIC_HEADER ;  break ;
          case 'i': marker_type = INTERNAL_HEADER ; break ;
          default:
            RB_Say("%s: WARNING, [line %d] undefined headertype, using GENERIC\n",
                    whoami, line_number);
            marker_type = GENERIC_HEADER;
        }
      }
    }
  }
  if (!found || feof(document)) return (NO_HEADER) ;

  if (marker_type == GENERIC_HEADER)
  {
    skip_while (*cur_char == '*') ;
    if (*cur_char == '/')
      return BLANK_HEADER;
  }

  return marker_type;
}

/*** RB_Find_Marker ***/


/****** RoboDoc.c/RB_Find_End_Marker [3.0h]
 * NAME
 *   RB_Find_End_Marker -- Search for end marker in document.
 * SYNOPSIS
 *   result = RB_Find_End_Marker (document)
 *        int RB_Find_End_Marker (FILE *)
 * FUNCTION
 *   Searches line by line till any of the markers in the
 *   array: end_markers is found.
 * INPUTS
 *   document   - pointer to the file to be searched.
 *   int *total_size - external size
 *   the gobal buffer line_buffer.
 * RESULT
 *                real_size if end marker was found
 *   0          - no end marker was found
 * SEE ALSO
 *   RB_Find_Marker
 * SOURCE
 */

int RB_Find_End_Marker(FILE * document, int *total_size)
{
  int real_size = 0;
  int found = FALSE ;
  int marker ;
  int   line_len;
  char *cur_char, *cur_mchar ;

  while (!feof(document) && !found)
  {
    cur_char = line_buffer;
    *cur_char  = '\0';
    fgets(cur_char, MAX_LINE_LEN, document);
    ++line_number;                  /* global linecounter *koessi*/

    line_len   = strlen(cur_char);
    real_size += line_len;

    if (!feof(document))
    {
      for (marker=0 ;
           ((cur_mchar = end_markers[marker]) != NULL) && !found ;
           marker++)
      {
        for (found = TRUE, cur_char = line_buffer;
             *cur_mchar && *cur_char && found;
              cur_mchar++, cur_char++)
        {
          if (*cur_mchar != *cur_char) found = FALSE ;
        }
      }
    }
  }
  if (total_size)
      *total_size = real_size ;
  if (found) return (real_size - line_len) ;
  else return(0);
}

/*** RB_Find_End_Marker ***/


/****** RoboDoc.c/RB_Find_Header_Name   [3.0b]
 * NAME
 *   RB_Find_Header_Name -- search for header name
 * SYNOPSIS
 *   result = RB_Find_Header_Name ()
 *      char *RB_Find_Header_Name ()
 * FUNCTION
 *   Searches the line buffer for the header name.
 *   It assumes that the header name follows after the
 *   header marker, seperated by one or more spaces, and terminated
 *   by one or more spaces or a '\n'.
 *   It allocates an array of chars and copies the name to this array.
 * INPUTS
 *   the gobal buffer line_buffer.
 * RESULT
 *   pointer to the allocated array of chars that contains the name,
 *   terminated with a '\0'.
 *   NULL if no header name was found.
 * MODIFICATION HISTORY
 *   8. August 1995      --  optimized by koessi
 * SEE ALSO
 *   RB_Find_Function_Name(), RB_WordLen(), RB_StrDup()
 * SOURCE
 */

char *RB_Find_Header_Name(void)
{
  char *cur_char;

  cur_char = line_buffer;
  skip_while (*cur_char != '*') ;
  skip_while (!isspace(*cur_char)) ;
  skip_while (isspace(*cur_char)) ;
  if (*cur_char)
  {
    char *end_char, old_char ;
    end_char  = cur_char + RB_WordLen(cur_char);
    old_char  = *end_char;
    *end_char = '\0';
    cur_char  = RB_StrDup(cur_char);
    *end_char = old_char;
    return (cur_char);
  }
  return(NULL);
}

/*** RB_Find_Header_Name ***/


/****** RoboDoc.c/RB_Find_Item [3.0b]
 * NAME
 *   RB_Find_Item -- find item in header contents.
 * SYNOPSIS
 *   item_type = RB_Find_Item (next_line,item_line)
 *
 *           int RB_Find_Item (char **,  char **)
 * FUNCTION
 *   Searches the header contents line by line, looking
 *   for an item Indicator.
 * INPUTS
 *   next_line  - pointer to a pointer that points to line
 *                at which the search will start.
 * SIDE-EFFECTS
 *   next_line  - pointer to a pointer that points to begin of the line
 *                after the line the item was found on.
 *   item_line  - pointer to a pointer that points to the line the item
 *                was found on.
 * RESULT
 *   item_type  - one of possible items indicators.
 * SOURCE
 */

int RB_Find_Item (char **next_line,char **item_line)
{
  char *cur_char = *next_line ;
  int item_type ;

  for(item_type = NO_ITEM;
      *cur_char && (item_type == NO_ITEM);
     )
  {
    *item_line = cur_char ;
    cur_char = RB_Skip_Remark_Marker (cur_char) ;

    skip_while (isspace(*cur_char) && *cur_char != '\n') ;
    if (isupper(*cur_char))
    {
      char *item_begin = cur_char ;
      char *item_end ;

      skip_while (isupper(*cur_char)) ;
      item_end = cur_char ;
      if (isspace(*cur_char) && *cur_char)
      {
        skip_while (isspace(*cur_char) && *cur_char != '\n') ;

        /* Item consists of two words ? */
        if (isupper(*cur_char) && *cur_char)
        {
          skip_while (isupper(*cur_char)) ;
          item_end = cur_char ;
          skip_while (isspace(*cur_char) && *cur_char != '\n') ;
        }
        if (*cur_char == '\n')
        {
          char old_char = *item_end ;

          *item_end = '\0' ;
          item_type = RB_Get_Item_Type(item_begin);
          *item_end = old_char ;
          cur_char++ ;
        }
      }
    }
    if (item_type == NO_ITEM)
    {
      find_eol ; if (*cur_char) cur_char++ ;
    }
  }

  /* advance item_line to end of comment block when we have no more items */
  if (item_type == NO_ITEM) {
    *item_line = cur_char ;
  }

  *next_line = cur_char ;
  return item_type ;
}

/*** RB_Find_Item ***/


/****** RoboDoc.c/RB_Generate_xrefs [2.0]
 * NAME
 *   RB_Generate_xrefs
 * SYNOPSIS
 *   RB_Generate_xrefs (dest_doc, source_name, dest_name)
 *
 *   RB_Generate_xrefs (FILE *, char *, char *)
 * FUNCTION
 *   Generates a xref file for the document that has been
 *   analysed by robodoc.
 * INPUTS
 *   dest_doc    - pointer to the file to which the xrefs will be
 *                 written.
 *   source_name - pointer to the name of the document that has
 *                 been analysed by robodoc
 *   dest_name   - pointer to the name of the document robodoc will
 *                 write the documentation to.
 *   first_header - global variable, the list with function
 *                 headers.
 * SEE ALSO
 * SOURCE
 */

void RB_Generate_xrefs(FILE * dest_doc, char *source_name, char *dest_name)
{
  struct RB_header *cur_header;

  fprintf(dest_doc, "/* XREF-File generated by RoboDoc v"RB_VERSION" */\n");
  fprintf(dest_doc, "\nXREF:\n");
  fprintf(dest_doc, " \"%s\" \"%s\" 0 0\n", source_name, dest_name);
  for (cur_header = first_header;
       cur_header;
       cur_header = cur_header->next_header
    )
  {
    if (cur_header->function_name)
      fprintf(dest_doc, " \"%s\" \"%s\" 0 0\n",
              cur_header->function_name, dest_name);
  }
  fprintf(dest_doc, "\n/* End of XREF-File */\n");
}

/*** RB_Generate_xrefs ***/


/****** RoboDoc.c/RB_Generate_Documentation [3.0h]
 * NAME
 *   RB_Generate_Documentation
 * SYNOPSIS
 *   RB_Generate_Documentation (dest_doc, name, name)
 *
 *   RB_Generate_Documentation (FILE *, char *, char *)
 * FUNCTION
 *   Generates the autodoc documentation from the list of
 *   function headers that has been created by
 *   RB_Analyse_Document.
 * INPUTS
 *   dest_doc   - Pointer to the file to which the output will be written.
 *   src_name   - The name of the source file.
 *   dest_name  - The name of this file.
 * BUGS
 *   There might be plenty.
 * SEE ALSO
 *   RB_Generate_Doc_Start,
 *   RB_Generate_Doc_End,
 *   RB_Generate_Header_Start,
 *   RB_Generate_Header_End,
 *   RB_Generate_Header_Name,
 *   RB_Generate_Item_Name,
 *   RB_Generate_Item_Doc,
 *   RB_Generate_Item_Body.
 * SOURCE
 */

void RB_Generate_Documentation(FILE * dest_doc, char *src_name, char *dest_name)
{
  struct RB_header *cur_header;

  RB_Make_Index_Tables () ;

  RB_Generate_Doc_Start(dest_doc, src_name, dest_name) ;

  for (cur_header = first_header; cur_header; cur_header = cur_header->next_header)
  {
    int   item_type;
    char *next_line, *item_line = NULL;

    RB_Say("generating documentation for \"%s\"\n", cur_header->name);

    RB_Generate_Header_Start(    dest_doc, cur_header);
/*  RB_Generate_Header_Name(dest_doc, cur_header->name); */

    next_line = cur_header->contents;
    item_type = RB_Find_Item(&next_line, &item_line);

    if (item_type != NO_ITEM)
    {
      int   old_item_type;
      char *old_next_line;

      do {
        if (course_of_action & DO_TELL)
          printf("[%s] ", item_names[item_type]);

        RB_Generate_Item_Name(dest_doc, item_type);

        old_next_line = next_line;
        old_item_type = item_type;

        item_type = RB_Find_Item(&next_line, &item_line);

        RB_Generate_Item_Doc(dest_doc, dest_name,
                             old_next_line, item_line,
                             cur_header->function_name, old_item_type);
      } while(item_type != NO_ITEM);
      if (course_of_action & DO_TELL) putchar('\n') ;
    }
    else
      printf("%s: WARNING, header \"%s\" has no items\n", whoami, cur_header->name);

    RB_Generate_Header_End(dest_doc, cur_header);
  }
  RB_Generate_Doc_End(dest_doc, dest_name);
}

/*** RB_Generate_Documentation ***/


/****** RoboDoc.c/RB_Generate_Doc_Start [3.0j]
 * NAME
 *   RB_Generate_Doc_Start -- Generate document header.
 * SYNOPSIS
 *   RB_Generate_Doc_Start (dest_doc, src_name, name)
 *
 *   RB_Generate_Doc_Start (FILE *, char *, char *)
 * FUNCTION
 *   Generates for depending on the output_mode the text that
 *   will be at the start of a document.
 *   Including the table of contents.
 * INPUTS
 *   dest_doc - pointer to the file to which the output will
 *              be written.
 *   src_name - the name of the source file.
 *   name     - the name of this file.
 *   output_mode - global variable that indicates the output
 *                 mode.
 * SEE ALSO
 *   RB_Generate_Doc_End
 * SOURCE
 */

void RB_Generate_Doc_Start(FILE * dest_doc, char *src_name, char *name)
{
  struct  RB_header *cur_header;
  int     cur_len, max_len, header_nr;

  switch(output_mode)
  {
    case  AMIGAGUIDE:
      if (strstr(name + 1, ".guide") == NULL)
        fprintf(dest_doc, "@database %s.guide\n", name);
      else
        fprintf(dest_doc, "@database %s\n", name);
      fprintf(dest_doc, "@rem Source: %s\n", src_name);
      fprintf(dest_doc, "@rem " COMMENT_ROBODOC);
      fprintf(dest_doc, "@rem " COMMENT_COPYRIGHT);
      fprintf(dest_doc, "@node Main %s\n", name);
      fprintf(dest_doc, "@{jcenter}\n");
      fprintf(dest_doc, "@{fg highlight}@{b}TABLE OF CONTENTS@{ub}@{fg text}\n\n");

      max_len = 0;
      for (cur_header = first_header;
           cur_header;
           cur_header = cur_header->next_header)
      {
        if (cur_header->name)
        {
          cur_len = strlen(cur_header->name);
          if (cur_len > max_len)  max_len = cur_len;
        }
      }

      for (cur_header = first_header;
           cur_header;
           cur_header = cur_header->next_header)
      {
        if (cur_header->name && cur_header->function_name)
        {
          fprintf(dest_doc, "@{\"%s", cur_header->name);

          for (cur_len = strlen(cur_header->name);
               cur_len < max_len;
               ++cur_len) fputc(' ', dest_doc);
            fprintf(dest_doc, "\" Link \"%s\"}\n", cur_header->function_name);
        }
      }

      fprintf(dest_doc, "@{jleft}\n");
      fprintf(dest_doc, "@endnode\n");
      break;

    case HTML:
      /* Append document type and title */
      fprintf(dest_doc, "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n");
      fprintf(dest_doc, "<HTML><HEAD>\n<TITLE>%s</TITLE>\n", name);

      /* append SGML-comment with document- and copyright-info. This code
       * ensures that every line has an own comment to avoid problems
       * with buggy browsers */
      fprintf(dest_doc, "<!-- Source: %s -->\n", src_name);
      {
        static const char copyright_text[] = COMMENT_ROBODOC COMMENT_COPYRIGHT;
        size_t i = 0;
        char previous_char = '\n';
        char current_char = copyright_text[i];

        while (current_char)
        {
            if (previous_char == '\n')
            {
                fprintf(dest_doc, "<!-- ");
            }

            if (current_char == '\n')
            {
              fprintf(dest_doc, " -->");
            }
            else if ((current_char == '-') && (previous_char == '-'))
            {
                /* avoid "--" inside SGML-comment, and use "-_" instead;
                 * this looks a bit strange, but one should still be
                 * able to figure out what is meant when reading the
                 * output */
                current_char = '_';
            }

            fputc(current_char, dest_doc);
            i += 1;
            previous_char = current_char;
            current_char = copyright_text[i];
        }
      }

      /* append heading and start list of links to functions */
      fprintf(dest_doc, "</HEAD><BODY>\n");
      fprintf(dest_doc, "<H1 ALIGN=\"center\">TABLE OF CONTENTS</H1>\n");
      fprintf(dest_doc, "<OL>\n");

      for (cur_header = first_header;
           cur_header;
           cur_header = cur_header->next_header)
      {
        if (cur_header->name && cur_header->function_name)
          fprintf(dest_doc, "<LI><A HREF=\"#%s\">%s</A>\n",
                  cur_header->function_name, cur_header->name);
      }
      fprintf(dest_doc, "</OL>\n");
      break;

    case LATEX:
      fprintf(dest_doc, "%% Document: %s\n", name);
      fprintf(dest_doc, "%% Source: %s\n", src_name);
      fprintf(dest_doc, "%% " COMMENT_ROBODOC);
      fprintf(dest_doc, "%% " COMMENT_COPYRIGHT);
      fprintf(dest_doc, "\\documentstyle{article}\n");
      fprintf(dest_doc, "\\setlength{\\topmargin}{0in}\n");
      fprintf(dest_doc, "\\setlength{\\textwidth}{6.5in}\n");
      fprintf(dest_doc, "\\setlength{\\parindent}{0in}\n");
      fprintf(dest_doc, "\\setlength{\\parskip}{.08in}\n\n");

      /* changed default header to use boldface (vs slant) */
      fprintf(dest_doc, "\\pagestyle{myheadings}\n");
      fprintf(dest_doc, "\\markright{\\bf \\protect\\thesection \\hskip 1em"
                        "\\relax API Reference}\n\n");

      fprintf(dest_doc, "\\begin{document}\n");
      fprintf(dest_doc, "\\section{API Reference}\n"
                        "This section is your complete reference to the "
                        "functions and concepts for this system.\n");

      /* autogenerate table of contents! */
      fprintf(dest_doc, "\\tableofcontents\n");
      fprintf(dest_doc, "\\newpage\n");

      /* trick to disable the autogenerated \newpage */
      fputc('%', dest_doc);
      break;

    case RTF:
      {
        char *cook_link;

        /* RTF header */
        fprintf(dest_doc, "{\\rtf1\\ansi \\deff0"
                              "{\\fonttbl;"
                                  "\\f0\\fswiss MS Sans Serif;"
                                  "\\f1\\fmodern Courier New;"
                                  "\\f2\\ftech Symbol;"
                              "}"
                              "{\\colortbl;"
                                  "\\red255\\green255\\blue255;"
                                  "\\red0\\green0\\blue0;"
                                  "\\red0\\green0\\blue255;"
                              "}");

        /* RTF document info */
        fprintf(dest_doc,     "{\\info"
                                  "{\\title %s}"
                                  "{\\comment\n"
                                  " Source: %s\n"
                                  " " COMMENT_ROBODOC
                                  " " COMMENT_COPYRIGHT
                                  "}"
                              "}", name, src_name);

        /* RTF document format */
        fprintf(dest_doc, "{\\margl1440\\margr1440}\n");

        /* RTF document section */
        fprintf(dest_doc, "\\f0\\cb1\\cf3\\fs28\\b1\\qc" 
                          "{\\super #{\\footnote{\\super #}%s_TOC}}"
                          "{\\super ${\\footnote{\\super $}Contents}}"
                          "{TABLE OF CONTENTS}\\ql\\b0\\fs20\\cf2\\par\n", src_name);
        for (cur_header = first_header;
             cur_header;
             cur_header = cur_header->next_header)
        {
          if (cur_header->name && cur_header->function_name) {
            cook_link = RB_CookStr(cur_header->function_name);
            fprintf(dest_doc, "{\\uldb %s}{\\v %s}\\line\n",
                   cur_header->name, cook_link);
            free(cook_link);
          }
        }
        fprintf(dest_doc, "\\par\n");
      }
      break;
    case ASCII:
      if (course_of_action & DO_TOC)
      {
        fprintf(dest_doc, "TABLE OF CONTENTS\n");
        for (cur_header = first_header, header_nr = 1;
             cur_header;
             cur_header = cur_header->next_header, header_nr++)
        {
          if (cur_header->name && cur_header->function_name)
          {
            fprintf(dest_doc, "%4.4d %s\n", header_nr, cur_header->name);
          }
        }
        fputc('\f', dest_doc);
      }

    default: break;
  }
}

/*** RB_Generate_Doc_Start ***/


/****** RoboDoc.c/RB_Generate_Doc_End [3.0h]
 * NAME
 *   RB_Generate_Doc_End -- generate document trailer.
 * SYNOPSIS
 *   RB_Generate_Doc_End (dest_doc, name)
 *
 *   RB_Generate_Doc_End (FILE *, char *)
 * FUNCTION
 *   Generates for depending on the output_mode the text that
 *   will be at the end of a document.
 * INPUTS
 *   dest_doc - pointer to the file to which the output will
 *              be written.
 *   name     - the name of this file.
 *   output_mode - global variable that indicates the output
 *                 mode.
 * NOTES
 *   Doesn't do anything with its arguments, but that might
 *   change in the future.
 * BUGS
 * SOURCE
 */

void RB_Generate_Doc_End(FILE * dest_doc, char *name)
{
  switch(output_mode)
  {
    case AMIGAGUIDE: fputc('\n', dest_doc); break;
    case HTML:  fprintf(dest_doc, "</BODY></HTML>\n"); break;
    case LATEX: fprintf(dest_doc, "\\end{document}\n"); break;
    case RTF:   fputc('}', dest_doc); break ;
    case ASCII: break ;
  }
}

/*** RB_Generate_Doc_End ***/


/****** RoboDoc.c/RB_Generate_Header_Start [3.0h]
 * NAME
 *   RB_Generate_Header_Start -- generate header start text.
 * SYNOPSIS
 *  void RB_Generate_Header_Start (dest_doc, cur_header)
 *
 *  void RB_Generate_Header_Start (FILE *, struct RB_header *)
 * FUNCTION
 *   Generates depending on the output_mode the text that
 *   will be at the end of each header.
 * INPUTS
 *   dest_doc - pointer to the file to which the output will
 *              be written.
 *   cur_header - pointer to a RB_header structure.
 * SEE ALSO
 *   RB_Generate_Header_End
 * SOURCE
 */

void RB_Generate_Header_Start (FILE * dest_doc, struct RB_header *cur_header)
{
  char *cook_link;

  switch(output_mode)        /* switch by *koessi*/
  {
    case AMIGAGUIDE:
      if (cur_header->name && cur_header->function_name)
      {
        fprintf(dest_doc, "@Node \"%s\" \"%s\"\n",
                cur_header->function_name,
                cur_header->name);
        fprintf(dest_doc, "%s", att_start_command[MAKE_SHINE][output_mode]);
        fprintf(dest_doc, "%s", cur_header->name);
        fprintf(dest_doc, "%s", att_stop_command[MAKE_SHINE][output_mode]);
        fprintf(dest_doc, "\n\n") ;
      }
      break;
    case HTML:
      if (cur_header->name && cur_header->function_name)
      {
        fprintf(dest_doc, "<HR>\n");
        fprintf(dest_doc, "\n<H2><A NAME=\"%s\">%s</A></H2>\n\n",
                cur_header->function_name,
                cur_header->name);
      }
      break;
    case LATEX:
      cook_link = RB_CookStr(cur_header->name);
      fprintf(dest_doc, "\\newpage\n");
      fprintf(dest_doc, "\\subsection{%s}\n", cook_link);
      free(cook_link);
      break;
    case RTF:
      if (cur_header->name && cur_header->function_name)
      {
        cook_link = RB_CookStr(cur_header->function_name);
        fprintf(dest_doc, "\\page"
                "{\\super #{\\footnote{\\super #}%s}}"
                "{\\super ${\\footnote{\\super $}%s}}"
                "\\cf3 %s\\cf2\\line\n",
                cur_header->function_name,
                cur_header->name,
                cur_header->name);
        free(cook_link);
      }
      break;
    case ASCII:
      {
        fprintf(dest_doc, "%s", att_start_command[MAKE_SHINE][output_mode]);
        fprintf(dest_doc, "%s", cur_header->name);
        fprintf(dest_doc, "%s", att_stop_command[MAKE_SHINE][output_mode]);
        fprintf(dest_doc, "\n\n") ;
      }
      break;
  }
}

/*** RB_Generate_Header_Start ***/


/****** RoboDoc.c/RB_Generate_Header_End [3.0h]
 * NAME
 *   RB_Generate_Header_End
 * SYNOPSIS
 *   void RB_Generate_Header_End (dest_doc, cur_header)
 *
 *   void RB_Generate_Header_End (FILE *, struct RB_header *)
 * FUNCTION
 *   Generates for depending on the output_mode the text that
 *   will be at the end of a header.
 * INPUTS
 *   dest_doc - pointer to the file to which the output will
 *              be written.
 *   cur_header - pointer to a RB_header structure.
 * SEE ALSO
 *   RB_Generate_Header_Start
 * SOURCE
 */

void RB_Generate_Header_End (FILE * dest_doc, struct RB_header *cur_header)
{
  switch(output_mode)        /* switch by *koessi*/
  {
    case AMIGAGUIDE:
      if (cur_header->name && cur_header->function_name)
        fprintf(dest_doc, "@endnode\n");
      break;
    case HTML:
    case LATEX: fputc('\n', dest_doc); break;
    case RTF:   fprintf(dest_doc, "\\par\n"); break;
    case ASCII: fputc('\f', dest_doc);
    default:  break;
  }
}

/*** RB_Generate_Header_End ***/


/****** RoboDoc.c/RB_Generate_Header_Name [3.0c]
 * NAME
 *   RB_Generate_Header_Name
 * SYNOPSIS
 *   RB_Generate_Header_Name (dest_doc, name)
 *
 *   RB_Generate_Header_Name (FILE *, char *)
 * INPUTS
 *  dest_doc - pointer to the file to which the output will
 *             be written.
 *  name - pointer to the header name.
 * SOURCE
 */

void RB_Generate_Header_Name(FILE * dest_doc, char *name)
{
  char format_str[] = "%s";
  fprintf(dest_doc, format_str, att_start_command[MAKE_SHINE][output_mode]);
  fprintf(dest_doc, format_str, name);
  fprintf(dest_doc, format_str, att_stop_command[MAKE_SHINE][output_mode]);
  fprintf(dest_doc, "\n\n");
}

/*** RB_Generate_Header_Name ***/


/****** RoboDoc.c/RB_Generate_Item_Name [2.01]
 * NAME
 *   RB_Generate_Item_Name -- fast&easy
 * SYNOPSIS
 *   void RB_Generate_Item_Name( FILE * dest_doc, int item_type )
 * FUNCTION
 *   write the items name to the doc
 * INPUTS
 *   FILE * dest_doc         -- document in progress
 *   int item_type           -- this leads to the name and makes colors
 * AUTHOR
 *   Koessi
 * NOTES
 *   uses globals: output_mode, item_names[]
 * SOURCE
 */

void RB_Generate_Item_Name(FILE * dest_doc, int item_type)
{
  char format_str[] = "%s";

  if (item_attributes[item_type] & ITEM_NAME_LARGE_FONT)
  {
    fprintf(dest_doc, format_str, att_start_command[MAKE_LARGE][output_mode]);
    fprintf(dest_doc, format_str, item_names[item_type]);
    fprintf(dest_doc, format_str, att_stop_command[ MAKE_LARGE][output_mode]);
  }
  else fprintf(dest_doc, format_str, item_names[item_type]);

  fputc('\n', dest_doc);
}

/*** RB_Generate_Item_Name *** Zitatende ***/


/****** RoboDoc.c/RB_Generate_Item_Doc [3.0j]
 * NAME
 *   RB_Generate_Item_Doc
 * SYNOPSIS
 *   void RB_Generate_Item_Doc(FILE * dest_doc, char *dest_name,
 *                             char *begin_of_item,
 *                             char *end_of_item,
 *                             char *function_name,
 *                             int item_type)
 * FUNCTION
 *   Generates the body text of an item, applying predefined attributes
 *   to the text.
 * NOTES
 *   Body text is always non-proportional for several reasons:
 *   1) text is rarely written with prop spacing and text wrapping
 *      in mind -- e.g., see SYNOPSIS above
 *   2) source code looks better
 *   3) it simplifies LaTeX handling
 * SOURCE
 */

void RB_Generate_Item_Doc(FILE * dest_doc, char *dest_name,
                          char *begin_of_item,
                          char *end_of_item,
                          char *function_name,
                          int item_type)
{
  char format_str[] = "%s";

  if (begin_of_item == end_of_item)
  {
    switch (output_mode)
    {
      case HTML:
        fprintf(dest_doc, "<BR>\n"); break;
      case LATEX:
        fprintf(dest_doc, "\\\\\n"); break;
      case RTF:
        fprintf(dest_doc, "\n"); break;
      default:
        break;
    }
    return;
  }

  /* For text body in HTML, change to non-prop _before_ changing font style.
   * To conform to DTD, this avoids <B><PRE> and instead uses <PRE><B> */
  if (output_mode == HTML)
  {
    fprintf(dest_doc, "<PRE>");
  }

  /* change font style */
  if (item_attributes[item_type] & TEXT_BODY_LARGE_FONT)
    fprintf(dest_doc, format_str, att_start_command[MAKE_LARGE][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_ITALICS)
    fprintf(dest_doc, format_str, att_start_command[MAKE_ITALICS][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_NON_PROP)
    fprintf(dest_doc, format_str, att_start_command[MAKE_NON_PROP][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_SMALL_FONT)
    fprintf(dest_doc, format_str, att_start_command[MAKE_SMALL][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_BOLD)
    fprintf(dest_doc, format_str, att_start_command[MAKE_BOLD][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_UNDERLINE)
    fprintf(dest_doc, format_str, att_start_command[MAKE_UNDERLINE][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_SHINE)
    fprintf(dest_doc, format_str, att_start_command[MAKE_SHINE][output_mode]);

  /*
   * For some modes, the text body is always non-prop
   */
  switch (output_mode) {
    case LATEX:
      fprintf(dest_doc, "\\begin{verbatim}\n"); break;
    case RTF:
      fprintf(dest_doc, "{\\f1{}"); break;
    default:
      break;
  }

  RB_Generate_Item_Body(dest_doc, dest_name, begin_of_item, end_of_item,
                          function_name, item_type);

  switch (output_mode) {
    case LATEX:
      /* split the text so LaTeX doesn't get confused ;) */
      fprintf(dest_doc, "\\" "end{verbatim}\n"); break;
    case RTF:
      fputc('}', dest_doc);
    default:
      break;
  }

  /* restore font style */
  if (item_attributes[item_type] & TEXT_BODY_SHINE)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_SHINE][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_UNDERLINE)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_UNDERLINE][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_BOLD)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_BOLD][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_SMALL_FONT)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_SMALL][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_NON_PROP)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_NON_PROP][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_ITALICS)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_ITALICS][output_mode]);
  if (item_attributes[item_type] & TEXT_BODY_LARGE_FONT)
    fprintf(dest_doc, format_str, att_stop_command[MAKE_LARGE][output_mode]);

  if (output_mode != HTML)
  {
    fputc('\n', dest_doc);
  }

  /* for HTML, switch back to prop-font after restoring font style */
  if (output_mode == HTML)
  {
    fprintf(dest_doc, "</PRE>");
  }

}

/*** RB_Generate_Item_Doc ***/


/****** RoboDoc.c/RB_Skip_Remark_Marker [2.0e]
 * NAME
 *    RB_Skip_Remark_Marker
 * SYNOPSIS
 *     text  = RB_Skip_Remark_Marker (line_buffer)
 *    char *                            char *
 * FUNCTION
 *    Scan and search for a recognized remark marker; skip past the
 *    marker to the body of the text
 ******/

char *RB_Skip_Remark_Marker (char *line_buffer)
{
  int marker, found ;
  char *cur_char, *cur_mchar ;

  found = FALSE ;
  for (marker=0 ;
       ((cur_mchar = remark_markers[marker]) != NULL) && !found ;
       marker++)
  {
    for (found = TRUE, cur_char = line_buffer;
         *cur_mchar && *cur_char && found;
          cur_mchar++, cur_char++)
    { if (*cur_mchar != *cur_char) found = FALSE ; }
  }
  return (cur_char) ;
}


/****** RoboDoc.c/RB_Generate_Item_Body [3.0h]
 * NAME
 *  RB_Generate_Item_Body
 * SYNOPSIS
 *  void RB_Generate_Item_Body(FILE * dest_doc, char *dest_name,
 *                             char *begin_of_item, char *end_of_item,
 *                             char *function_name,
 *                             int   item_type)
 *
 * FUNCTION
 *   Generates body of an item in output-specific form
 * INPUTS
 *   dest_doc      - pointer to the file to which
 *                   the output will be written.
 *   dest_name     - the name of this file.
 *   begin_of_item -
 *   end_of_item   -
 *   function_name -
 *   item_type     -
 * NOTES
 *   o almost completely rewritten by koessi
 *   o Almost completely Re-Rewritten by Slothouber :)
 * SOURCE
 */

void RB_Generate_Item_Body(FILE * dest_doc, char *dest_name,
                           char *begin_of_item, char *end_of_item,
                           char *function_name,
                           int   item_type)
{
  char *cur_char, old_char, c ;

  cur_char = begin_of_item;

  if (item_type == SOURCE_ITEM) {
    /* skip end_comment_marker */
    for (; *cur_char && *cur_char != '\n' ; cur_char++ )
      ;

    /* skip blank lines leading up to source code */
    while (*cur_char == '\n')
      cur_char++;

    /* trim blanks following source code */
    do {
      end_of_item--;
    } while (end_of_item > cur_char && isspace(*end_of_item));
    end_of_item++;  /* advance 1 for placement of the NUL */
  }

  old_char = *end_of_item;
  *end_of_item = '\0';

  for (; *cur_char; cur_char++)
  {
    int tb = tab_size;
    int do_search = TRUE ;
    int was_link  = FALSE;

    if (item_type != SOURCE_ITEM) {
      cur_char = RB_Skip_Remark_Marker(cur_char) ;
    } else {
      /* indent source */
      switch (output_mode) {
        case RTF:
          fprintf(dest_doc, "\\tab ");
          break;

        case AMIGAGUIDE:
        case HTML:
        case LATEX:
        default:
          fprintf(dest_doc, "    ");
      }
    }

    while (((c = *cur_char) != '\0') && (c != '\n'))
    {
      char *label_name, *file_name;
      int   tmp;

      if (!do_search)
      {
        if (!isalnum(c) && (c != '_'))
        {
          do_search = TRUE ;
        }
      }
      else
      {
        if (isalpha(c) || (c == '_'))
        {
          if ((was_link = RB_Find_Link(cur_char, &label_name, &file_name)) == FALSE)
          {
            do_search = FALSE ;
          }
        }
        else was_link = FALSE ;
      }

      if (!was_link)
      {
        switch(output_mode) {
          case AMIGAGUIDE:
            switch(c) {
              case '\n' : --cur_char; break;
              case '\t' : for (tb %= tab_size; tb < tab_size; ++tb)
                            fputc(' ', dest_doc) ;
                          break;
              case '@'  : fprintf(dest_doc, "\\@" );
                          tb++; break;
              case '\\' : fprintf(dest_doc, "\\\\") ;
                          tb++; break;
              default   : fputc(c, dest_doc); tb++;
            }
            break;

          case HTML:
            switch(c) {
              case '\n' : --cur_char; break;
              case '\t' : for (tb %= tab_size; tb < tab_size; ++tb)
                            fputc(' ', dest_doc) ;
                          break;
              case '<'  : fprintf(dest_doc, "&lt;");
                          tb++; break;
              case '>'  : fprintf(dest_doc, "&gt;");
                          tb++; break;
              case '&'  : fprintf(dest_doc, "&amp;");
                          tb++; break;
              default   : fputc(c, dest_doc); tb++;
            }
            break;

          case LATEX:
            switch(c) {
              case '\n' : --cur_char; break;
              case '\t' : for (tb %= tab_size; tb < tab_size; ++tb)
                            fputc(' ', dest_doc) ;
                          break;
#if 0
              /* not used in LaTeX's verbatim environment */
              case '$'  :
              case '&'  :
              case '%'  :
              case '#'  :
              case '_'  :
              case '{'  :
              case '}'  : fputc('\\', dest_doc); fputc(c, dest_doc);
                          tb++; break;
              case '\\' : fprintf(dest_doc, "$\\backslash$");
                          tb++; break;
              case '~'  : fprintf(dest_doc, "$\\tilde$");
                          tb++; break;
              case '^'  : fprintf(dest_doc, "$\\,\\!^{\\sim}$");
                          tb++; break;
#endif
              default   : fputc(c, dest_doc); tb++;
            }
            break;

          case RTF:
            switch(c) {
              case '\n' : --cur_char; break;
              case '\t' : for (tb %= tab_size; tb < tab_size; ++tb)
                            fputc(' ', dest_doc) ;
                          break;
              case '\\' :
              case '{'  :
              case '}'  : fputc('\\', dest_doc); fputc(c, dest_doc);
                          tb++; break;
              default   : fputc(c, dest_doc); tb++;
            }
            break;

          default:
            fputc(c, dest_doc); tb++;
        }
        cur_char++;
      }
      else
      {
        switch(output_mode)
        {
          case AMIGAGUIDE :
            if (file_name && strcmp(file_name, dest_name))
                fprintf(dest_doc,"@{\"%s\" Link \"%s/%s\"}",
                        label_name, file_name, label_name);
            else
            {
              if (strcmp(label_name, function_name))
                 fprintf(dest_doc,"@{\"%s\" Link \"%s\"}",
                         label_name, label_name) ;
              else
              {
                fprintf(dest_doc,"%s",
                        att_start_command[MAKE_BOLD][output_mode]);
                fprintf(dest_doc,"%s", label_name);
                fprintf(dest_doc,"%s",
                        att_stop_command[MAKE_BOLD][output_mode]);
              }
            }
            break;

          case HTML :
            if (file_name && strcmp(file_name, dest_name))
            fprintf(dest_doc,"<A HREF=\"%s#%s\">%s</A>",
                    file_name, label_name, label_name);
            else
            {
              if (strcmp(label_name, function_name))
                  fprintf(dest_doc,"<A HREF=\"#%s\">%s</A>",
                          label_name, label_name);
              else
              {
                fprintf(dest_doc,"%s",
                        att_start_command[MAKE_BOLD][output_mode]);
                fprintf(dest_doc,"%s", label_name);
                fprintf(dest_doc,"%s",
                        att_stop_command[MAKE_BOLD][output_mode]);
              }
            }
            break;

          case RTF :
            if (strcmp(label_name, function_name)) {
              char *cook_link;

              cook_link = RB_CookStr(label_name);
              fprintf(dest_doc, "{\\uldb %s}{\\v %s}",
                      label_name, cook_link);
              free(cook_link);
            } else {
              fprintf(dest_doc,"%s",
                      att_start_command[MAKE_BOLD][output_mode]);
              fprintf(dest_doc,"%s", label_name);
              fprintf(dest_doc,"%s",
                      att_stop_command[MAKE_BOLD][output_mode]);
            }
            break;
          default: fprintf(dest_doc,"%s", label_name) ;
        }
        tmp = strlen(label_name); cur_char += tmp; tb += tmp;
      } /* end if */
    }

    if (*cur_char) {
      if (output_mode == RTF)
        fprintf(dest_doc, "\\line");
      fputc('\n', dest_doc);
    }
  }
  *end_of_item = old_char;
}

/*** RB_Generate_Item_Body ***/


/****** RoboDoc.c/RB_Make_Index_Tables [3.0b]
 * NAME
 *    RB_Make_Index_Tables
 * SYNOPSIS
 *    void RB_Make_Index_Tables (void)
 * FUNCTION
 *    Creates sorted index tables of headers and links to speed up
 *    matching links later on.
 * INPUTS
 *    none
 * SIDE EFFECTS
 *    Modifies header_index & link_index
 * RESULT
 *    none
 ******/

void RB_Make_Index_Tables ()
{
  int nr_of_headers, header ;
  int nr_of_links, link ;
  struct RB_link    *cur_link;
  struct RB_header  *cur_header;

  for (cur_header = first_header, nr_of_headers = 0;
       cur_header;
       cur_header = cur_header->next_header) nr_of_headers++ ;

  for (cur_link = first_link, nr_of_links = 0;
       cur_link;
       cur_link = cur_link->next_link) nr_of_links++ ;

  if (nr_of_headers)
  {
    int sort1, sort2 ;

    RB_Say("Allocating Header Index Table\n");
    header_index = (struct RB_header **)malloc(nr_of_headers*sizeof(struct RB_header **)) ;
    header_index_size = nr_of_headers ;
    if (!header_index) RB_Panic ("out of memory! [Make Index Tables]\n") ;

    /* Fill Index Table */
    for (cur_header = first_header, header = 0;
          cur_header;
          cur_header = cur_header->next_header, header++)
        header_index[header] = cur_header ;

    /* Sort Index Table */
    RB_Say("Sorting Header Index Table\n");
    for (sort1 = 0; sort1 < nr_of_headers; sort1++)
    {
      struct RB_header *temp ;
      for (sort2 = sort1; sort2 < nr_of_headers; sort2++)
      {
        if (strcmp(header_index[sort1]->function_name,
                   header_index[sort2]->function_name) > 0)
        {
          temp = header_index[sort1] ;
          header_index[sort1] = header_index[sort2] ;
          header_index[sort2] = temp ;
        }
      }
    }
  }

  if (nr_of_links)
  {
    int sort1, sort2 ;

    RB_Say("Allocating Link Index Table\n");
    link_index   = (struct RB_link **)malloc(nr_of_links*sizeof(struct RB_link **)) ;
    link_index_size = nr_of_links ;
    if (!link_index) RB_Panic ("out of memory! [Make Index Tables]\n") ;

    /* Fill Index Table */
    for (cur_link = first_link, link = 0;
         cur_link;
         cur_link = cur_link->next_link, link++)
    {
      link_index[link] = cur_link ;
    }

    /* Sort Index Table */
    RB_Say("Sorting Link Index Table\n");
    for (sort1 = 0; sort1 < nr_of_links; sort1++)
    {
      struct RB_link *temp ;
      for (sort2 = sort1; sort2 < nr_of_links; sort2++)
      {
        if (strcmp(link_index[sort1]->label_name,
                   link_index[sort2]->label_name) > 0)
        {
          temp = link_index[sort1] ;
          link_index[sort1] = link_index[sort2] ;
          link_index[sort2] = temp ;
        }
      }
    }
  }
}


/****** RoboDoc.c/RB_Find_Link [3.0h]
 * NAME
 *   RB_Find_Link -- try to match word with a link
 * SYNOPSIS
 *   result = RB_Find_Link (word_begin, label_name, file_name)
 *   int      RB_Find_Link (char *,     char **,    char **)
 * FUNCTION
 *   Searches for the given word in the list of links.
 * INPUTS
 *   word_begin  - pointer to a word (a string).
 *   label_name  - pointer to a pointer to a string
 *   file_name   - pointer to a pointer to a string
 * SIDE EFFECTS
 *   label_name & file_name are modified
 * RESULT
 *   TRUE or FALSE.
 * NOTES
 *   re-rewritten by frans
 * BUGS
 * SOURCE
 */

int RB_Find_Link(char *word_begin, char **label_name, char **file_name)
{
  char  *cur_char, old_char ;
  int low_index, high_index, cur_index, state ;

  for (cur_char = word_begin ;
       isalnum(*cur_char) || (*cur_char == '_') || (*cur_char == '-')
       || (*cur_char == '.' && isalnum(*(cur_char+1))) ;
       cur_char++)
    ;
  old_char = *cur_char ;
  *cur_char = '\0' ;

  for (cur_index = 0, low_index = 0, high_index = header_index_size-1 ;
       high_index >= low_index ; )
  {
    cur_index = (high_index - low_index)/2 + low_index ;
    state = strcmp(word_begin, header_index[cur_index]->function_name) ;
    if (state < 0) high_index = cur_index-1 ;
    else if (state > 0) low_index = cur_index+1 ;
    else
    {
      *label_name = header_index[cur_index]->function_name ;
      *file_name  = NULL ;
      *cur_char   = old_char ;

      if (strlen(*label_name) > 60) RB_Panic ("Internal Error #1\n") ;
      return(TRUE) ;
    }
  }

  for (cur_index = 0, low_index = 0, high_index = link_index_size-1 ;
       high_index >= low_index ; )
  {
    cur_index = (high_index - low_index)/2 + low_index ;
    state = strcmp(word_begin, link_index[cur_index]->label_name) ;
    if (state < 0)
    {
      high_index = cur_index-1 ;
    }
    else if (state == 0)
    {
      *label_name = link_index[cur_index]->label_name ;
      *file_name  = link_index[cur_index]->file_name ;
      if (strlen(*label_name) > 60) RB_Panic ("Internal Error #2\n") ;
      if (strlen(*file_name) > 60)  RB_Panic ("Internal Error #3\n") ;
      *cur_char   = old_char ;
      return(TRUE) ;
    }
    else if (state > 0)
    {
      low_index = cur_index+1 ;
    }
  }
  *cur_char = old_char ;
  *file_name = NULL ;
  *label_name = NULL ;
  return(FALSE);
}

/*** RB_Find_Link ***/


/****** RoboDoc.c/RB_Slow_Sort [2.0]
 * NAME
 *   RB_Slow_Sort -- sort list of headers alphabetically
 * SYNOPSIS
 *   RB_Slow_Sort ()
 * FUNCTION
 *   Sorts the list of headers according to the header name
 *   in alphabetically fashion.
 * NOTES
 *   This isn't a particularly speedy way of sorting.
 * SOURCE
 */

void RB_Slow_Sort()
{
  struct RB_header *cur_header, *unsorted_headers, *bigger_header ;

  if ((unsorted_headers = first_header) != NULL)  /* additional check *koessi */
  {
    for (first_header = NULL;
         unsorted_headers->next_header; )
    {
      for (bigger_header = unsorted_headers,
           cur_header = bigger_header->next_header;
           cur_header;
           cur_header = cur_header->next_header)
      {
        if (strcmp(cur_header->name, bigger_header->name) > 0)
          bigger_header = cur_header;
      }
      RB_Remove_From_List(&unsorted_headers, bigger_header);
      RB_Insert_In_List(&first_header, bigger_header);
    }
    RB_Insert_In_List(&first_header, unsorted_headers);
  }
}

/*** RB_Slow_Sort ***/


/****** RoboDoc.c/RB_Insert_In_List [2.0]
 * NAME
 *   RB_Insert_In_List -- Insert a header in a list.
 * SYNOPSIS
 *   RB_Insert_In_List (anchor,new_header)
 *
 *   RB_Insert_In_List (struct RB_header **, struct RB_header *)
 * FUNCTION
 *   Insert a node in a doubly linked list.
 * INPUTS
 *   anchor     - pointer to the first node in the list.
 *   new_header - node to be inserted.
 * MODIFICATION HISTORY
 *   8. August 1995      --  optimized by koessi
 * SOURCE
 */

void RB_Insert_In_List(struct RB_header **anchor,
                       struct RB_header *new_header)
{
  struct RB_header *old_header;

  if ((old_header = *anchor) != NULL)  old_header->prev_header = new_header;
  new_header->next_header = old_header;
  new_header->prev_header = NULL;
  *anchor = new_header;
}

/*** RB_Insert_In_List ***/


/****** RoboDoc.c/RB_Remove_From_List [2.0]
 * NAME
 *   RB_Remove_From_List -- remove a header from a list.
 * SYNOPSIS
 *   RB_Remove_From_List (anchor, old_header)
 *   RB_Remove_From_List (struct RB_header **, struct RB_header *)
 * MODIFICATION HISTORY
 *   8. August 1995      --  optimized by koessi
 * SOURCE
 */

void RB_Remove_From_List(struct RB_header **anchor,
                         struct RB_header *old_header)
{
  struct RB_header *next_header = old_header->next_header;
  struct RB_header *prev_header = old_header->prev_header;

  if (next_header) next_header->prev_header = prev_header;
  if (prev_header) prev_header->next_header = next_header;
  else  *anchor = next_header;
}

/*** RB_Remove_From_List ***/


/****i* RoboDoc.c/RB_Alloc_Header [2.01]
 * NAME
 *   RB_Alloc_Header            -- oop
 * SYNOPSIS
 *   struct RB_header *RB_Alloc_Header( void )
 * FUNCTION
 *   allocate the struct RB_header
 * RESULT
 *   struct RB_header *      -- all attributes/pointers set to zero
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Free_Header()
 * SOURCE
 */

struct RB_header *RB_Alloc_Header(void)
{
  struct RB_header *new_header;

  if ((new_header = (struct RB_header *)malloc(sizeof(struct RB_header))) != NULL)
    memset(new_header, 0, sizeof(struct RB_header));
  else RB_Panic("out of memory! [Alloc Header]\n");
  return(new_header);
}

/*** RB_Alloc_Header ***/


/****i* RoboDoc.c/RB_Free_Header [2.01]
 * NAME
 *   RB_Free_Header             -- oop
 * SYNOPSIS
 *   void RB_Free_Header( struct RB_header *header )
 * FUNCTION
 *   free struct RB_header and associated strings
 * INPUTS
 *   struct RB_header *header -- this one
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Alloc_Header(), RB_Close_The_Shop()
 * SOURCE
 */

void RB_Free_Header(struct RB_header *header)
{
  if (header)
  {
    if (header->version)  free(header->version);
    if (header->name)     free(header->name);
    if (header->contents) free(header->contents);
    free(header);
  }
}

/*** RB_Free_Header ***/


/****i* RoboDoc.c/RB_Alloc_Link [2.01]
 * NAME
 *   RB_Alloc_Link              -- oop
 * SYNOPSIS
 *   struct RB_link *RB_Alloc_Link( char *label_name, char *file_name )
 * FUNCTION
 *   allocate struct + strings
 * INPUTS
 *   char *label_name -- strings to copy into the link
 *   char *file_name
 * RESULT
 *   struct RB_link *  -- ready-to-use
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_StrDup(), RB_Free_Link()
 * SOURCE
 */

struct RB_link *RB_Alloc_Link(char *label_name, char *file_name)
{
  struct RB_link *new_link;
  if ((new_link = (struct RB_link *)malloc(sizeof(struct RB_link))) != NULL)
  {
    memset(new_link, 0, sizeof(struct RB_link));

    if (file_name) new_link->file_name = RB_StrDup(file_name);
    if (label_name) new_link->label_name = RB_StrDup(label_name);
  }
  else RB_Panic("out of memory! [Alloc Link]\n");

  return(new_link);
}

/*** RB_Alloc_Link ***/


/****i* RoboDoc.c/RB_Free_Link [2.01]
 * NAME
 *   RB_Free_Link               -- oop
 * SYNOPSIS
 *   void RB_Free_Link( struct RB_link *link )
 * FUNCTION
 *   free struct + strings
 * INPUTS
 *   struct RB_link *link
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Alloc_Link(), RB_Close_The_Shop()
 * SOURCE
 */

void RB_Free_Link(struct RB_link *link)
{
  if (link)
  {
    if (link->label_name) free(link->label_name);
    if (link->file_name)  free(link->file_name);
    free(link);
  }
}

/*** RB_Free_Link ***/


/****i* RoboDoc.c/RB_WordLen [2.01]
 * NAME
 *   RB_WordLen -- like strlen
 * SYNOPSIS
 *   int RB_WordLen( char *str )
 * FUNCTION
 *   get the amount of bytes until next space
 * INPUTS
 *   char *str -- the word
 * RESULT
 *   int -- length of the next word or 0
 * AUTHOR
 *   Koessi
 * SEE ALSO
 *   RB_Find_Header_Name()
 * SOURCE
 */

int RB_WordLen(char *str)
{
  int   len;
  char  c;
  for (len = 0; ((c = *str) != '\0') && !isspace(c) && (c != '\n'); ++str, ++len)
    ;
  return(len);
}

/*** RB_WordLen ***/


/****i* RoboDoc.c/RB_StrDup [2.01]
 * NAME
 *   RB_StrDup
 * SYNOPSIS
 *   char *RB_StrDup( char *str )
 * FUNCTION
 *   duplicate the given string
 * INPUTS
 *   char *str               -- source
 * RESULT
 *   char *                  -- destination
 * AUTHOR
 *   Koessi
 * SOURCE
 */

char *RB_StrDup(char *str)
{
  char *dupstr;
  if ((dupstr = (char *)malloc((strlen(str) + 1) * sizeof(char))) != NULL)
      strcpy(dupstr, str);
  else RB_Panic("out of memory! [StrDup]\n");
  return(dupstr);
}

/*** RB_StrDup ***/


/****i* RoboDoc.c/RB_CookStr [3.0h]
 * NAME
 *   RB_CookStr
 * SYNOPSIS
 *   char *RB_CookStr( char *str )
 * FUNCTION
 *   duplicate the given string, massaging it for the current output_mode
 * INPUTS
 *   char *str               -- source
 * RESULT
 *   char *                  -- destination
 * AUTHOR
 *   apang
 * NOTES
 *   Doesn't try/need to be as aggressive as RB_Generate_Item_Body()
 ****/

char *RB_CookStr(char *str)
{
  static char work_buf[MAX_LINE_LEN];
  char *cptr, c;
  int i;

  cptr = work_buf;
  switch (output_mode) {
    case LATEX:
      for (i = 0; ((c = *str++) != '\0') && (i < (MAX_LINE_LEN - 1)); ) {
        i++;
        if (c == '_') {
          if (i < (MAX_LINE_LEN - 1)) {
            *cptr++ = '\\'; *cptr++ = '_';
            i++;
          } else {
            break;
          }
        } else {
          *cptr++ = c;
        }
      }
      break;

    case RTF:
      for (; (c = *str++) != '\0'; ) {
        if (isalnum(c) || c == '.' || c == '_') {
          *cptr++ = c;
        }
      }
      break;

    default:
      return RB_StrDup(str);
  }

  *cptr = '\0';
  return RB_StrDup(work_buf);
}

/*** RB_CookStr ***/


/****i* RoboDoc.c/RB_Say [2.01]
 * NAME
 *   RB_Say                     -- varargs
 * SYNOPSIS
 *   void RB_Say( char *what, char *why, ... )
 * FUNCTION
 *   say what's going on
 * INPUTS
 *   char *format            -- formatstring
 *    ...                    -- parameters
 * AUTHOR
 *   Koessi
 * SOURCE
 */

void RB_Say(char *format, ...)
{
  va_list  ap;
  if (course_of_action & DO_TELL)
  {
    va_start(ap, format);
    printf("%s: ", whoami);
    vprintf(format, ap);
    va_end(ap);
  }
}

/*** RB_Say ***/


/****i* RoboDoc.c/RB_Panic [2.01]
 * NAME
 *   RB_Panic -- free resources and shut down
 * SYNOPSIS
 *   void RB_Panic( char *format, char *why, ... )
 * FUNCTION
 *   Print error message.
 *   Frees all resources used by robodoc.
 *   Terminates program
 * INPUTS
 *   char *format            -- formatstring
 *   ...                     -- parameters
 * AUTHOR
 *   Koessi
 * SOURCE
 */

void RB_Panic(char *format, ...)
{
  va_list  ap;
  va_start(ap, format);
  printf("%s: FATAL ERROR - ", whoami);
  vprintf(format, ap);
  printf("%s: closing down...\n", whoami);
  va_end(ap);
  RB_Close_The_Shop();
  exit(RB_RETURN_PANIC);  /* 20..100 */
}

/*** RB_Panic ***/


/****i* RoboDoc.c/RB_Close_The_Shop [3.0b]
 * NAME
 *   RB_Close_The_Shop -- free resources.
 * SYNOPSIS
 *   void RB_Close_The_Shop ()
 * FUNCTION
 *   Frees all resources used by robodoc.
 * BUGS
 *   Did free cur_header after advancing (zzzzz)
 * SEE ALSO
 *   RB_Free_Header(), RB_Free_Link()
 * SOURCE
 */

void RB_Close_The_Shop()
{
  struct RB_header  *cur_header, *tmp_header;
  struct RB_link    *cur_link,   *tmp_link;

  if (document)        fclose(document);
  if (dest_doc)        fclose(dest_doc);
  if (xreffiles_file)  fclose(xreffiles_file);
  if (xref_file)       fclose(xref_file);

  for (cur_header = first_header; cur_header; )
  {
    tmp_header = cur_header->next_header;
    RB_Free_Header(cur_header);
    cur_header = tmp_header;
  }

  for (cur_link = first_link; cur_link; )
  {
    tmp_link = cur_link->next_link;
    RB_Free_Link(cur_link);
    cur_link = tmp_link;
  }

  if (header_index)  free(header_index) ;
  if (link_index)    free(link_index) ;
}

/*** RB_Close_The_Shop ***/
