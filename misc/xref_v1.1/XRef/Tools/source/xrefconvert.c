;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC xrefconvert.c OPT IGNORE=73
slink lib:c.o xrefconvert.o //Goodies/extrdargs/extrdargs.o TO /c/xrefconvert SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: xrefconvert.c 1.16 (03.11.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 03.11.94 : 001.016 :  default icon filename now correct
** 11.09.94 : 001.015 :  now displays current processing in a status window,
**                       if started from workbench
** 03.09.94 : 001.014 :  now uses ENTRYA_NodeName for all entries
** 31.08.94 : 001.013 :  v40 smartwrap test code added
** 29.08.94 : 001.012 :  unix manpages support added
** 27.08.94 : 001.011 :  bumped to version 1, TOC uses now columns
** 27.08.94 : 000.010 :  main node title fixed, now uses XREFA_CategoryParsed
** 22.07.94 : 000.009 :  some enhancements,bug fixes and optimizations
** 17.07.94 : 000.008 :  amigaguide filetype added
** 13.07.94 : 000.007 :  set index added
** 11.06.94 : 000.006 :  fixed bug struct "Window" -> "Windwo"ToFront(),saveicon ...
** 29.05.94 : 000.005 :  normal doc support added
** 21.05.94 : 000.004 :  autodoc "table of contents" support
** 18.05.94 : 000.003 :  ctrl-c supported
** 16.05.94 : 000.002 :  autodoc support added
** 14.05.94 : 000.001 :  initial
**
*/

/* ------------------------------- includes ------------------------------- */

#include "Def.h"

#include <ctype.h>

#include <libraries/xref.h>
#include <proto/xref.h>

#include <debug.h>
#include <register.h>

#include "/lib/xrefsupport.h"

#include "xrefconvert_rev.h"

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/XRefConvert ***********************************************

$VER: XRefConvert.doc

NAME
    XRefConvert - converts autodoc or header files to AmigaGuide files

TEMPLATE
    FORM/M/A,TO/A,KEYWORDFILE/K,EXCEPTIONFILE/K,STDDELIMITERS/K,
    EXCLUDETYPES/K,INCLUDETYPES/K,INDENT/N/K,TOOLPRI/N/K,NOICON/S,
    NOAMIGAGUIDE/S,NOMAINPAGELINK/S,STATISTIC/S,V40/S,VERBOSE/S

FORMAT
    XRefConvert [FROM] file|dir [file2|dir2] [TO] dir [CATEGORY categories]
                [KEYWORDFILE keyworddef] [EXCEPTIONFILE exceptdef] 
                [STDDELIMITERS string] [EXCLUDETYPES types]
                [INCLUDETYPES types] [INDENT number] [TOOLPRI priority]
                [NOICON] [NOAMIGAGUIDE] [NOMAINPAGELINK] [STATISTIC] [V40]
                [VERBOSE]

FUNCTION
    Files:
    converts a C header file or a autodoc file in a AmigaGuide file.Which type
    a given file is, is determined by the suffix of the filename :
       - ".h" for a C header file
       - ".doc" or ".dok" for a doc file and
       - these suffix with the "TABLE OF CONTENTS" for an autodoc file
    If the switch NOAMIGAGUIDE is on, XRefConvert will generate the appropri-
    ate files with out the headers for an AmigaGuide file.If this is not
    turned on,it generates an AmigaGuide file. Thus you can use the keyword
    format feature also to convert to AmigaGuide or to convert in normal ASCII
    format.

    Delimiters:
    This tool separates words by using of a delimiter-string. The default
    string is " \t\n,<>=(){}\":.;*|!". Any of these charaters terminates a
    word. You can specify an other delimiter string by using of the
    STDDELIMITERS option for the command.

    Keyword file:
    To specify keywords you must pass a keyword file, which contains keyword
    definitions (see KEYWORDFILE option).XRefConvert loads first the
    "Sys:config/xref/keywords" file is it exists.After this it loads the
    specified keywordfile or it looks for a "keywords" file in the current
    directory.

    Icon:
    XRefConvert will use the ENV:sys/def_guide.info icon for each generated
    AmigaGuide database. If this icon doesn't exists it uses a internal icon.

INPUTS
    FROM (STRINGS) - specifies input files and/or directories

    TO (STRING) - specifies the output directory, in which the generated
        direcotries/files are placed.

    CATEGORY (STRING) - category pattern to use for convertion. Only
        xreffiles are parsed, which matches this category pattern.

    KEYWORDFILE (STRING) - file, which contains keyword definitions to substi-
        tute such keywords.
        The file must have the following format :
        - First the file format is ASCII-text, which is line orientated.
          Each line is parsed via ReadArgs() function of the dos.library with
          the following template :
          
          KEYWORD/K/A,SUBSTITUTE/K/A,DELIMITERS/K,NEXTWORD/S

          if a line matches these template it will be stored and used by the
          convertion.

          the format of line is (note in the file, it must be one line !!!) :

          KEYWORD keyword SUBSTITUTE substitute-string [DELIMITERS string] \
          [NEXTWORD]

          KEYWORD (STRING) - specifies the word to search for, if this is
              AUTODOC, the substitute string is used to substitute all words,
              which matches a AutoDoc description word (f.e. : "NAME",
              "SYNOPSIS",...). To detect such words it must match the
              following : first in the line there can be 
                          INDENT - 2 < n < INDENT + 2
              n spaces, then the word must follow in uppercase letters and 
              after this must be a newline !
          SUBSTITUTE (STRING) - specifies the string to replace the keyword
              in the generated file a "%s" in this string inserts the keyword
              itself (just one time for now).
          DELIMITERS (STRING) - specifies the delimiters for the next word.
              This string is only valid if the NEXTWORD switch is turned on.
          NEXTWORD (BOOLEAN) - indicates, that the next word should replaced,
              instead of the keyword. If you also specify the DELIMITERS, the
              end of the next word is defined by any character in this string.

          For the V40 option there exists a special keywordfile named
          keywords.v40 in the config directory. In this file you can specify,
          which text passages are wrapped and which not, using the new
          smartwrap function. If you want a text passage be wrapped define a
          KEYWORD with the description title like "FUNCTION" and use the
          "@{mtext %s}" macro as the SUBSTITUTE string. Thus this text passage
          should be smartwrapped (See also the default keywords.v40 file) !

    EXCEPTIONFILE (STRING) - file, which contain names that are only linked,
        if a "()" is at the end of the name, see AD2AG. Each line has only one
        name.The default is $XREFCONFIGDIR/exceptions .

    STDDELIMITERS (STRING) - string, which defines the delimiters characters
        the default is : " \t\n,<>=(){}\":.;*|!"

    EXCLUDETYPES (STRING) - string, which defines the entrytypes that aren't
        used during convertion. With this option you can subpress links to
        the specified types. Each type in this string is separated by an '|'
        character. For example you don't want links to typedef's and macro's.
        Then you have to specify this : EXCLUDETYPES "typedef|macro" !
        Types available for this option : "generic", "function", "command",
        "include", "macro", "struct", "field", "typedef", "define" !
        Default is "".

    INCLUDETYPES (STRING) - string , which defines the entrytypes that are
        only used during convertion. See EXCLUDETYPES for string format and
        available types.

    INDENT (NUMBER) - number of spaces, which are inserted before an AutoDoc
        description word (see KEYWORDFILE/KEYWORD above).

    PRI (NUMBER) - task priority to use during converting

    NOAMIGAGUIDE (BOOLEAN) - indicates, that shouldn't create AmigaGuide 
        headers for each file

    NOICON (BOOLEAN) - don't save an icon for the generated amigaguide file

    NOMAINPAGELINK (BOOLEAN) - don't generate a TABLE OF CONTENTS link to the
        xref.library dynamic node main page.

    STATISTIC (BOOLEAN) - outputs statistics about the generated links to each
        type of entries. Such as include's or functions.

    V40 (BOOLEAN) - generate amigaguide files for use with amigaguide.datatype
        V40 or higher. This generates databases, which uses the smartwrap
        option of the V40 version. This option works only with files in the
        autodoc format and perhaps not with all files of this fileformat. So
        convert and take a look at the generated files !
        If this option is specified XRefConvert tries to load also the file
        "Sys:config/xref/keywords.v40" , in which the keywords are defined to
        use smartwrap !

    VERBOSE (BOOLEAN) - output informations of the current convertion state

EXAMPLE
    XRefConvert include:amiga/ aguide:include/ KEYWORDFILE s:mykeywords \
                AMIGAGUIDE VERBOSE

SEE ALSO
    MakeXRef, LoadXRef, ParseXRef, AGuideXRefV37, AGuideXRefV39, StatXRef,
    XRefAttrs, MakeAGuideIndex

COPYRIGHT
    (C) by Stefan Ruppert 1994

HISTORY
    XRefConvert 1.14 (3.11.94) :
       - default icon name now correct "Env:Sys/def_guide"
       - time calculation now correct

    XRefConvert 1.13 (11.9.94) :
       - workbench support added
       - status window, if started from workbench added

    XRefConvert 1.12 (3.9.94) :
        - now gets the nodename from the entry with ENTRYA_NodeName

    XRefConvert 1.11 (31.8.94) :
        - added V40 option

    XRefConvert 1.10 (29.8.94) :
        - unix manpage support added

    XRefConvert 1.9 (27.8.94) :
        - main node title shows now the relative path instead of the first
          path part
        - uses now XREFA_CategoryParsed if a category is specified. This
          speeds up the convertion.
        - for AutoDoc TOC uses now the columns from the xref.library

    XRefConvert 1.8 (23.7.94) :
        - added EXCLUDETYPPES,INCLUDETYPES option

    XRefConvert 1.7 (22.7.94) :
        - some bug fixed.
        - now can handle <entry>/<entry> pairs
        - the InternXRef list wasn't free'd after convertion of a file
          (this slowed down the convertion of more than one file per call).
          This is fixed and some optimizations by stepping through the list.
        - New statistic display
        - PRI option added

    XRefConvert 1.6 (17.7.94) :
        - now it supports amigaguide files to convert ! It tries to link all
          internal @node titles in the text to the node. And links all found
          xref entries.
        - the point is now a special delimiter ! The following sequences are
          now interpreted as a delimiter ". ",".\0",".\t",".\n" !
        - category pattern added

    XRefConvert 1.5 (13.7.94) :
        - now tries to set the index array for each xreffile to get the best
          performance (then it uses a binary search algorithm)

    XRefConvert 1.4 (11.6.94) :
        - ':','-',';','*' added to STDDELIMITERS default string
        - now tries to load "Sys:config/xref/keywords" every time and then
          tries to load the specified keyword file. If no one is specified
          tries to load the "keywords" file in the current directory.
        - save icon bug fixed , if the source file had an unknown type the
          icon was saved even though. This is fixed.
        - All structures , which have equal autodoc beginnings like , Window
          struct "Window" * -> "Window"ToFront() aren't linked. This is fixed!

    XRefConvert 1.3 (29.5.94) :
        - INDENT option added

*****************************************************************************/
/*FE*/

/* ------------------------------- defines -------------------------------- */

/*FS*/ /*"Definitions"*/
#define PATH_LEN              512
#define BUFFER_LEN            1024
#define NAME_LEN              256

#define EOS                   '\0'

#define PUDDLE_SIZE           2048
#define THRESH_SIZE           PUDDLE_SIZE

#define MAX_VARRAY            10
#define LINE_UPDATE           20           /* verbose after n lines */

#define IXR(node)             ((struct InternXRef *) (node))

#define XREFCT_KEYWORDS       XREFT_MAXTYPES
#define XREFCT_INTERN         XREFT_MAXTYPES + 1

#define DISPLAY_TYPES         XREFT_MAXTYPES + 2

enum {
   STYLE_UNKNOWN,
   STYLE_UNDERLINED,
   STYLE_BOLD,
   STYLE_MAX,
   };

/*FE*/

/* ------------------------------ structures ------------------------------ */

/*FS*/ /*"Structures"*/
struct Convert
{
   ULONG Number;

   ULONG xr_Type;
   STRPTR xr_Name;
   STRPTR xr_File;
   ULONG xr_Line;
   STRPTR xr_NodeName;
   STRPTR xr_Path;
};

struct KeyWord
{
   struct Node kw_Node;                /* node to link in a list */
   STRPTR kw_Keyword;                  /* keyword to search for */
   STRPTR kw_Substitute;               /* string to substitute the keyword */
   STRPTR kw_Delimiters;               /* delimiters to use for the nextword */
   BOOL kw_NextWord;                   /* specifies to substitute the next WORD
                                          instead of the keyword */
};

struct Exceptions
{
   struct Node e_Node;
   ULONG e_Length;
};

struct Stat
{
   ULONG Number[DISPLAY_TYPES];        /* number of linked types */
};

struct InternXRef
{
   struct Node ixr_Node;               /* node to link intern xref entries */
   ULONG ixr_Length;                   /* length of the node */
   ULONG ixr_NameLen;                  /* length of the ln_Name string */
   STRPTR ixr_Link;                    /* if name != link , then here stands the link */
};

struct GlobalData
{
   STRPTR gd_Ptr;                      /* pointer to the next WORD */
   STRPTR gd_CurrentPtr;               /* pointer to the actual WORD */

   APTR gd_Pool;                       /* memory pool for Keyword and Exception lists */
   APTR gd_InternPool;                 /* memory pool for InternXRef list */
   ULONG *gd_Para;                     /* link to the arguments passed via command line */
   BOOL gd_Workbench;                  /* started from workbench ? */
   BOOL gd_Abort;                      /* set to TRUE if the user has canceled */

   BPTR gd_ReadFH;                     /* read filehandle */
   BPTR gd_WriteFH;                    /* write filehandle */
   BPTR gd_StartDir;                   /* current directory by program start */
   ULONG gd_FileSize;                  /* length of the actual file */
   ULONG gd_FileType;                  /* type of the file to scan e.g FTYPE_#? */
   STRPTR gd_FileName;                 /* actual filename (may be relative) */
   STRPTR gd_FullPath;                 /* full path for the current file */
   ULONG gd_OpenNodes;                 /* is there a @node without a closing @endnode ? */
   ULONG gd_Line;                      /* counting the lines */
   ULONG gd_ConvertedFiles;            /* number of converted files */


   UWORD gd_SeeAlso;                   /* SEE ALSO block follow's -> don't use the exceptions */
   ULONG gd_StyleType;                 /* STYLE_#? values */
   BOOL gd_LineBegin;                  /* just read a line */
   BOOL gd_SmartWrapped;               /* is the current paragraph smartwrapped ? */

   struct List gd_KeywordList;         /* list of keywords from the keyword file */
   struct List gd_InternXRef;          /* list of the table of contents from an autodoc */
   struct List gd_ExceptionList;       /* list of exceptionfiles */

   struct ScanWindow gd_SWin;
   struct ScanStat gd_SStat;
   struct TimeCalc gd_TimeCalc;

   struct FileInfoBlock *gd_Fib;       /* global FileInfoBlock */
   struct TagItem gd_Tags[8];          /* global tags for XRefParse() */
   struct Hook gd_Hook;                /* parse hook structure */
   struct Convert gd_Convert;          /* structure passed to the parse hook */

   struct Stat gd_GlobalStat;          /* global statistics */
   ULONG gd_Links;                     /* number of links generated */

   ULONG gd_ExcTypes[XREFT_MAXTYPES];  /* types to be not converted */
   ULONG gd_IncTypes[XREFT_MAXTYPES];  /* types to be converted */

   UBYTE gd_Dest[PATH_LEN];            /* buffer for the filename to write */
   UBYTE gd_LineBuffer[BUFFER_LEN];    /* buffer to hold a line from the file */
   UBYTE gd_WordBuffer[BUFFER_LEN];    /* buffer to hold the current WORD */
   UBYTE gd_TempBuffer[BUFFER_LEN];    /* tempory buffer to do something */
   UBYTE gd_NameBuffer[NAME_LEN];      /* buffer for the autodoc node name */
   UBYTE gd_AutoDocIntro[NAME_LEN];    /* autodoc intro statement substitute buffer */

   STRPTR gd_VArray[MAX_VARRAY];       /* buffer for number of %s in a substitute */
};
/*FE*/

/* -------------------------- temlate definition -------------------------- */

/*FS*/ /*"Templates"*/
#define template "FROM/M/A,TO/A,CATEGORY/K,KEYWORDFILE/K,EXCEPTIONFILE/K," \
                 "STDDELIMITERS/K,EXCLUDETYPES/K,INCLUDETYPES/K,INDENT/N/K," \
                 "TOOLPRI/N/K,NOICON/S,NOAMIGAGUIDE/S,NOMAINPAGELINK/S," \
                 "STATISTIC/S,V40/S,VERBOSE/S"

enum {
   ARG_FROM,
   ARG_TO,
   ARG_CATEGORY,
   ARG_KEYWORDFILE,
   ARG_EXCEPTIONFILE,
   ARG_STDDELIMITERS,
   ARG_EXCLUDETYPES,
   ARG_INCLUDETYPES,
   ARG_INDENT,
   ARG_TOOLPRI,
   ARG_NOICON,
   ARG_NOAMIGAGUIDE,
   ARG_NOMAINPAGELINK,
   ARG_STATISTIC,
   ARG_V40,
   ARG_VERBOSE,
   ARG_MAX};

#define keywordtemplate   "KEYWORD/K/A,SUBSTITUTE/K/A,DELIMITERS/K,NEXTWORD/S"

enum {
   ARG_KEYWORD,
   ARG_SUBSTITUTE,
   ARG_DELIMITERS,
   ARG_NEXTWORD,
   ARG_KEYWORDMAX};

/*FE*/

/* ------------------------------ prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/

void getkeywords(struct GlobalData *gd,STRPTR file);
void getexceptionwords(struct GlobalData *gd,STRPTR file);

void parse_typestring(STRPTR typestr,ULONG *typearray);

RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg);

void scan_amigaguide(struct GlobalData *gd);
void scan_header(struct GlobalData *gd);
void scan_autodoc(struct GlobalData *gd);
void scan_doc(struct GlobalData *gd);
void scan_man(struct GlobalData *gd);
void scan_info(struct GlobalData *gd);

BOOL check_exception(struct GlobalData *gd);
BOOL check_autodocintro(struct GlobalData *gd,STRPTR line);
BOOL check_keyword(struct GlobalData *gd);
BOOL check_internxref(struct GlobalData *gd);
void check_reference(struct GlobalData *gd);

void write_guide_header(struct GlobalData *gd);
void write_link(struct GlobalData *gd);
void write_word(struct GlobalData *gd);

STRPTR getword(struct GlobalData *gd,STRPTR delim);

void allocinternxref(struct GlobalData *gd,STRPTR name,STRPTR link);
ULONG getmanword(struct GlobalData *gd,STRPTR word,STRPTR buffer);

void output_statistic(struct GlobalData *gd,struct Stat *stat);

BOOL check_abort(struct GlobalData *gd);

void draw_state(struct GlobalData *gd);
void draw_keyword(struct GlobalData *gd);

/*FE*/

/* ------------------------------ Icon Data ------------------------------- */

/*FS*/ /*"Icon Data"*/
static UWORD icon_infoIData[176] = {
/*------ plane # 0: --------*/
        0x0000, 0x0000, 0x0000, 0x0400, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x07FF, 0xFFFF, 0xFFE0, 0x0C00, 
        0x0400, 0x0000, 0x0030, 0x0C00, 
        0x04AB, 0xFA00, 0x0028, 0x0C00, 
        0x0400, 0x0000, 0x0024, 0x0C00, 
        0x04BF, 0xEAAA, 0xAAA2, 0x0C00, 
        0x0400, 0x0000, 0x003F, 0x0C00, 
        0x04AA, 0xAAAA, 0xAAA8, 0x8C00, 
        0x0400, 0x0000, 0x0000, 0x8C00, 
        0x04AA, 0xABFE, 0xAAA8, 0x8C00, 
        0x0400, 0x0000, 0x0000, 0x8C00, 
        0x04AA, 0xAAAA, 0xAAA8, 0x8C00, 
        0x0400, 0x0000, 0x0000, 0x8C00, 
        0x04BF, 0xEAAA, 0xFEA8, 0x8C00, 
        0x0400, 0x0000, 0x0000, 0x8C00, 
        0x0400, 0x0000, 0x0000, 0x8C00, 
        0x07FF, 0xFFFF, 0xFFFF, 0x8C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x7FFF, 0xFFFF, 0xFFFF, 0xFC00, 
/*------ plane # 1: --------*/
        0xFFFF, 0xFFFF, 0xFFFF, 0xF800, 
        0xD555, 0x5555, 0x5555, 0x5000, 
        0xD555, 0x5555, 0x5555, 0x5000, 
        0xD000, 0x0000, 0x0015, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFC5, 0x5000, 
        0xD355, 0xF5FF, 0xFFD5, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFD9, 0x5000, 
        0xD35F, 0xD555, 0x555D, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFC0, 0x5000, 
        0xD355, 0x5555, 0x5557, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFFF, 0x5000, 
        0xD355, 0x55FD, 0x5557, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFFF, 0x5000, 
        0xD355, 0x5555, 0x5557, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFFF, 0x5000, 
        0xD35F, 0xD555, 0x7D57, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFFF, 0x5000, 
        0xD3FF, 0xFFFF, 0xFFFF, 0x5000, 
        0xD000, 0x0000, 0x0000, 0x5000, 
        0xD555, 0x5555, 0x5555, 0x5000, 
        0xD555, 0x5555, 0x5555, 0x5000, 
        0x8000, 0x0000, 0x0000, 0x0000, 
};

static struct Image icon_infoImg =
{
        0, 0,               /* LeftEdge, TopEdge */
        54, 22, 2,          /* Width, Height, Depth */
        &icon_infoIData[0], /* ImageData */
        0x03, 0x00,         /* PlanePick, PlaneOnOff */
        0L                  /* NextImage */
};

struct SaveDefIcon icondef = {
   "Env:Sys/def_guide",
   "Multiview",
   NULL,
   &icon_infoImg};

/*FE*/

/* ---------------------------- library bases ----------------------------- */

extern struct Library *SysBase;
struct Library *XRefBase;

/* --------------------------- static constants --------------------------- */

/*FS*/ /*"Constants"*/
static const STRPTR version       = VERSTAG;
static const STRPTR prgname       = "XRefConvert";
static const STRPTR toc           = "TABLE OF CONTENTS";
static const STRPTR endnode       = "\n@endnode\n";
static const STRPTR database      = "@database";

static const STRPTR xreftype_names[DISPLAY_TYPES] = {
   "generic",
   "function",
   "command",
   "include",
   "macro",
   "struct",
   "field",
   "typedef",
   "define",
   /* xrefconvert display types */
   "keywords",
   "intern"};

static const STRPTR style_strings[STYLE_MAX] = {
   "%s",
   "@{u}%s@{uu}",
   "@{b}%s@{ub}"};

static const STRPTR displaytexts[] = {
   "Files",
   "Dirs",
   "Source",
   "Dest",
   "Links",
   "Keywords",
   NULL};

enum {
   NUM_FILES,
   NUM_DIRS,
   NUM_SOURCE,
   NUM_DEST,
   NUM_LINKS,
   NUM_KEYWORDS,
   NUM_MAX};

/*FE*/

/* ---------------------------- parsexref hook ---------------------------- */

/*FS*//*"ULONG converthook(struct Hook *hook,struct XRefFileNode *xref,struct xrmXRef *msg)"*/
RegCall GetA4 ULONG converthook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg)
{
   struct Convert *myconv = (struct Convert *) hook->h_Data;

   if(msg->Msg == XRM_XREF)
   {
      struct TagItem *tstate = msg->xref_Attrs;
      struct TagItem *tag;

      ULONG tidata;

      myconv->Number++;
      myconv->xr_Line = ~0;

      while((tag = NextTagItem(&tstate)))
      {
         tidata = tag->ti_Data;
      
         switch(tag->ti_Tag)
         {
         case ENTRYA_Type:
            myconv->xr_Type = tidata;
            break;
         case ENTRYA_File:
            myconv->xr_File = (STRPTR) tidata;
            break;
         case ENTRYA_Name:
            myconv->xr_Name = (STRPTR) tidata;
            break;
         case ENTRYA_Line:
            myconv->xr_Line = tidata;
            break;
         case ENTRYA_NodeName:
            myconv->xr_NodeName = (STRPTR) tidata;
            break;
         case XREFA_Path:
            myconv->xr_Path = (STRPTR) tidata;
            break;
         }
      }
   } else
      Printf ("Not supported hook message : %ld\n",msg->Msg);

   return(0);
}
/*FE*/

/* --------------------------- main entry point --------------------------- */

/*FS*/ /*"int main(int ac,char *av[])"*/
int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};

   struct GlobalData *gd;
   ULONG para[ARG_MAX];

   ULONG retval = RETURN_OK;
   STRPTR obj = prgname;
   LONG err;
   WORD i;

   for( i = 0 ; i < ARG_MAX ; i++ )
      para[i] = 0;

   /* default values */
   para[ARG_STDDELIMITERS] = (ULONG) " \t\n,<>=(){}\":.;*|!";

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FROM;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      obj = "xref.library";
      if(XRefBase = OpenLibrary(obj,0))
      {
         obj = prgname;
         if(gd = AllocVec(sizeof(struct GlobalData),MEMF_CLEAR))
         {
            BYTE oldpri;

            if(para[ARG_TOOLPRI])
               oldpri = SetTaskPri(FindTask(NULL),(BYTE) *((ULONG *) para[ARG_TOOLPRI]));

            if((gd->gd_Pool = LibCreatePool(MEMF_ANY | MEMF_CLEAR,PUDDLE_SIZE,THRESH_SIZE)))
            {
               BPTR dir;

               /* duplicate start directory */
               dir = CurrentDir(NULL);
               gd->gd_StartDir = DupLock(dir);
               CurrentDir(dir);
 
               NewList(&gd->gd_KeywordList);
               NewList(&gd->gd_ExceptionList);

               gd->gd_Para = para;

               if(para[ARG_INDENT])
                  para[ARG_INDENT] = *((LONG *) para[ARG_INDENT]);
               else
                  para[ARG_INDENT] = 4;

               gd->gd_Hook.h_Entry    = (HOOKFUNC) converthook;
               gd->gd_Hook.h_Data     = &gd->gd_Convert;

               gd->gd_Tags[0].ti_Tag  = XREFA_Matching;
               gd->gd_Tags[0].ti_Data = XREFMATCH_COMPARE_NUM_CASE;
               gd->gd_Tags[1].ti_Tag  = XREFA_Limit;
               gd->gd_Tags[1].ti_Data = 1;
               gd->gd_Tags[2].ti_Tag  = XREFA_XRefHook;
               gd->gd_Tags[2].ti_Data = (ULONG) &gd->gd_Hook;
               gd->gd_Tags[3].ti_Tag  = TAG_IGNORE;

               if(para[ARG_CATEGORY])
               {
                  ULONG length = strlen((STRPTR) para[ARG_CATEGORY]) << 1 + 3;

                  if((gd->gd_Tags[3].ti_Data = (ULONG) AllocPooled(gd->gd_Pool,length)))
                     if(ParsePatternNoCase((STRPTR) para[ARG_CATEGORY],(STRPTR) gd->gd_Tags[3].ti_Data,length) >=0)
                        gd->gd_Tags[3].ti_Tag  = XREFA_CategoryParsed;

                  if(gd->gd_Tags[3].ti_Tag == XREFA_Category)
                     gd->gd_Tags[3].ti_Data = para[ARG_CATEGORY];
               }

               gd->gd_Tags[4].ti_Tag  = TAG_IGNORE;
               gd->gd_Tags[5].ti_Tag  = TAG_IGNORE;
               gd->gd_Tags[6].ti_Tag  = XREFA_AutoLoad;
               gd->gd_Tags[6].ti_Data = FALSE;
               gd->gd_Tags[7].ti_Tag  = TAG_END;


               gd->gd_ExcTypes[0] = ~0;
               gd->gd_IncTypes[0] = ~0;
               
               if(para[ARG_EXCLUDETYPES])
               {
                  parse_typestring((STRPTR) para[ARG_EXCLUDETYPES],gd->gd_ExcTypes);
                  gd->gd_Tags[4].ti_Tag  = XREFA_RejectTypes;
                  gd->gd_Tags[4].ti_Data = (ULONG) gd->gd_ExcTypes;
               }

               if(para[ARG_INCLUDETYPES])
               {
                  parse_typestring((STRPTR) para[ARG_INCLUDETYPES],gd->gd_IncTypes);
                  gd->gd_Tags[5].ti_Tag  = XREFA_AcceptTypes;
                  gd->gd_Tags[5].ti_Data = (ULONG) gd->gd_IncTypes;
               }

               for(i = 0 ; i < MAX_VARRAY ; i++)
                  gd->gd_VArray[i] = gd->gd_WordBuffer;

               /* set default autodoc keyword substitute */
               strcpy(gd->gd_AutoDocIntro,"@{b}%s@{ub}");

               /* allocate a FileInfoBlock for global use */
               if(gd->gd_Fib = AllocDosObject(DOS_FIB,NULL))
               {
                  struct Hook scanfile_hook = {NULL};
                  struct List *list;
                  struct Node *node;
                  BPTR dir;
                  ULONG xrefkey;

                  /* try to set the index array for all xreffiles */
                  xrefkey = LockXRefBase(0);

                  if(GetXRefBaseAttrs(XREFBA_List,&list,TAG_DONE) == 1)
                     for(node = list->lh_Head ; node->ln_Succ ; node = node->ln_Succ)
                     {
                        DB(("try to set index for %s!\n",node->ln_Name));
                        SetXRefFileAttrs((struct XRefFileNode *) node,XREFA_Index,TRUE,TAG_DONE);
                     }

                  UnlockXRefBase(xrefkey);

                  DB(("try to get default keywords and exception words !\n"));

                  GetXRefConfigDir(gd->gd_TempBuffer,sizeof(gd->gd_TempBuffer));

                  DB(("configdir : %s\n",gd->gd_TempBuffer));

                  if((dir = Lock(gd->gd_TempBuffer,SHARED_LOCK)))
                  {
                     BPTR old;

                     old = CurrentDir(dir);
                     /* load default keywords */
                     getkeywords(gd,"keywords");
                     if(gd->gd_Para[ARG_V40])
                        getkeywords(gd,"keywords.v40");

                     getexceptionwords(gd,"exceptions");

                     CurrentDir(old);
                     UnLock(dir);
                  }

                  DB(("try to load user defined keywords and exception words !\n"));

                  /* load user defined keywords */
                  if(para[ARG_KEYWORDFILE])
                     getkeywords(gd,(STRPTR) para[ARG_KEYWORDFILE]);
                  else
                  {
                     /* try to load user defined keywords in the current dir */
                     getkeywords(gd,"keywords");
                     if(gd->gd_Para[ARG_V40])
                        getkeywords(gd,"keywords.v40");
                  }

                  /* load user defined exceptionfile */
                  if(para[ARG_EXCEPTIONFILE])
                     getexceptionwords(gd,(STRPTR) para[ARG_EXCEPTIONFILE]);
                  else
                     getexceptionwords(gd,"exceptions");

                  DB(("scan stat !\n"));

                  scanfile_hook.h_Entry = (HOOKFUNC) scan_file;

                  strcpy(gd->gd_Dest, (STRPTR) gd->gd_Para[ARG_TO]);

                  time_init(&gd->gd_TimeCalc,LINE_UPDATE);

                  if(ac == 0)
                  {
                     gd->gd_Workbench = TRUE;
                     open_scanwindow(&gd->gd_SWin,(STRPTR *) displaytexts,prgname,400);
                     draw_scanwindowstatus(&gd->gd_SWin,"reading filelist ...");
                  }

                  /* get total filesize */
                  getscanstat((STRPTR *) para[ARG_FROM],&gd->gd_SStat);

                  if(ac == 0)
                     draw_scanwindowstatus(&gd->gd_SWin,"converting ...");

                  /* scan and convert all files */
                  err = scan_patterns((STRPTR *) para[ARG_FROM],&scanfile_hook,gd);

                  time_calc(&gd->gd_TimeCalc,1,1);

                  gd->gd_Abort |= (err == ERROR_BREAK);

                  /* close all workbench stuff */
                  close_scanwindow(&gd->gd_SWin,gd->gd_Abort);

                  if(!gd->gd_Workbench)
                  {
                     /* display whole statistic */
                     if(para[ARG_STATISTIC])
                     {
                        ULONG i;

                        Printf ("\rGlobal Statistic for %ld Files , %ld Directories :\n",
                                gd->gd_SStat.ss_Files,gd->gd_SStat.ss_Directories);

                        for(i = 0 ; i < DISPLAY_TYPES ; i++)
                        {
                           Printf ("%-10s:%8ld ",xreftype_names[i],gd->gd_GlobalStat.Number[i]);
                           if((i % 4) == 3 || i == (DISPLAY_TYPES - 1))
                              PutStr("\n");
                        }
                     }

                     Printf ("\rFiles scanned %ld , converted %ld , Time used : %02ld:%02ld%-30s\n",
                             gd->gd_SStat.ss_ActFiles, gd->gd_ConvertedFiles,
                             gd->gd_TimeCalc.tc_Secs[TIME_USED] / 60,
                             gd->gd_TimeCalc.tc_Secs[TIME_USED] % 60,
                             "");
                  }

                  FreeDosObject(DOS_FIB,gd->gd_Fib);
               } else
                  err = ERROR_NO_FREE_STORE;

               UnLock(gd->gd_StartDir);

               DeletePool(gd->gd_Pool);
            }

            if(para[ARG_TOOLPRI])
               SetTaskPri(FindTask(NULL),oldpri);

            if(gd->gd_Abort)
            {
               err = ERROR_BREAK;
               obj = prgname;
               retval = RETURN_FAIL;
            }

            FreeVec(gd);
         }
         CloseLibrary(XRefBase);
      }
   }
   ExtFreeArgs(&eargs);

   if(!err)
      err = IoErr();

   if(err)
   {
      if(ac == 0)
         showerror(prgname,obj,err);
      else
         PrintFault(err,obj);

      if(retval == RETURN_OK)
         retval = RETURN_ERROR;
   }

   return(retval);
}
/*FE*/

/* ---------------- get the keywords from the config file ----------------- */

/*FS*//*"void getkeywords(struct GlobalData *gd,STRPTR file)"*/
void getkeywords(struct GlobalData *gd,STRPTR file)
{
   struct RDArgs *rdargs;
   struct RDArgs *args;

   BPTR fh;

   if(fh = Open(file,MODE_OLDFILE))
   {
      DB(("def file %s opened\n",file));

      while(FGets(fh,gd->gd_TempBuffer,sizeof(gd->gd_TempBuffer) - 1))
      {
         ULONG para[ARG_KEYWORDMAX];
         LONG i;

         DB(("line : %s",gd->gd_TempBuffer));

         if(rdargs = (struct RDArgs *) AllocDosObject(DOS_RDARGS,NULL))
         {
            rdargs->RDA_Source.CS_Buffer   = gd->gd_TempBuffer;
            rdargs->RDA_Source.CS_Length   = strlen(gd->gd_TempBuffer);

            for(i=0 ; i < (sizeof(para)/sizeof(LONG)) ; i++)
               para[i]=0;

            DB(("rdargs at : %lx\n",rdargs));
            
            if(args = ReadArgs(keywordtemplate,(LONG *) para,rdargs))
            {
               DB(("args at %lx\n",args));

               if(!Stricmp((STRPTR) para[ARG_KEYWORD],"AUTODOC"))
               {
                  strcpy(gd->gd_AutoDocIntro,(STRPTR) para[ARG_SUBSTITUTE]);
               } else
               {
                  struct KeyWord *kwnode;
                  LONG arglen = 1;

                  if(para[ARG_DELIMITERS])
                     arglen += strlen((STRPTR) para[ARG_DELIMITERS]);

                  if(kwnode = LibAllocPooled(gd->gd_Pool,
                                             sizeof(struct KeyWord) + arglen +
                                             strlen((STRPTR) para[ARG_KEYWORD])    + 1 +
                                             strlen((STRPTR) para[ARG_SUBSTITUTE]) + 1  ))
                  {
                     STRPTR ptr;
                     LONG i;

                     kwnode->kw_Keyword = (STRPTR) (kwnode + 1);
                     strcpy(kwnode->kw_Keyword,(STRPTR) para[ARG_KEYWORD]);
                     kwnode->kw_Node.ln_Name = kwnode->kw_Keyword;

                     kwnode->kw_Substitute = kwnode->kw_Keyword + strlen(kwnode->kw_Keyword) + 1;
                     strcpy(kwnode->kw_Substitute,(STRPTR) para[ARG_SUBSTITUTE]);

                     if(para[ARG_DELIMITERS])
                     {
                        kwnode->kw_Delimiters = kwnode->kw_Substitute + strlen(kwnode->kw_Substitute) + 1;
                        strcpy(kwnode->kw_Delimiters,(STRPTR) para[ARG_DELIMITERS]);
                     }

                     kwnode->kw_NextWord = (BOOL) para[ARG_NEXTWORD];

                     for(ptr = kwnode->kw_Substitute , i = 0 ; *ptr ; ptr++)
                        if(*ptr == '%' && ptr[1] == 's')
                           ptr++;

                     insertbyname(&gd->gd_KeywordList,(struct Node *) kwnode);

                     if(i > MAX_VARRAY - 1)
                        Printf ("warning: keyword %s, has more than %ld '%%s'",kwnode->kw_Keyword,
                                                                               MAX_VARRAY);
                  }
               }
               FreeArgs(args);
            }
            FreeDosObject(DOS_RDARGS , rdargs);
         }
      }
      Close(fh);
   }
}
/*FE*/

/* ------------- get the exception words from the config fle -------------- */

/*FS*//*"void getexceptionwords(struct GlobalData *gd,STRPTR file)"*/
void getexceptionwords(struct GlobalData *gd,STRPTR file)
{
   BPTR fh;

   if(fh = Open(file,MODE_OLDFILE))
   {
      DB(("def file %s opened\n",gd->gd_Para[ARG_EXCEPTIONFILE]));
      if(ExamineFH(fh,gd->gd_Fib))
      {
         struct Exceptions *except;

         if((except = LibAllocPooled(gd->gd_Pool,sizeof(struct Exceptions) + gd->gd_Fib->fib_Size)))
         {
            except->e_Node.ln_Name = (STRPTR) (except + 1);
            except->e_Length       = gd->gd_Fib->fib_Size;

            if(Read(fh,except->e_Node.ln_Name,except->e_Length) == except->e_Length)
            {
               STRPTR ptr = except->e_Node.ln_Name;
               STRPTR end = except->e_Node.ln_Name + except->e_Length;

               while(ptr < end)
               {
                  if(*ptr == '\n')
                     *ptr = EOS;
                  ptr++;
               }
               AddTail(&gd->gd_ExceptionList,&except->e_Node);
            } else
               LibFreePooled(gd->gd_Pool,except,sizeof(struct Exceptions) + gd->gd_Fib->fib_Size);
         }
      }
      Close(fh);
   }
}
/*FE*/

/* ------------------------- parse types strings -------------------------- */

/*FS*/ /*"void parse_typestring(STRPTR typestr,ULONG *typearray) "*/
void parse_typestring(STRPTR typestr,ULONG *typearray)
{
   STRPTR end = typestr;
   STRPTR ptr = typestr;
   ULONG types = 0;
   ULONG i;

   /* convert separator to EOS */
   while(*end != EOS)
   {
      if(*end == '|')
         *end = EOS;
      end++;
   }

   while(ptr < end)
   {
      for(i = 0 ; i < XREFT_MAXTYPES ; i++)
         if(!Stricmp(ptr,xreftype_names[i]))
         {
            DB(("type : %s found -> %ld\n",ptr,i));
            typearray[types] = i;
            types++;
            break;
         }

      ptr += strlen(ptr) + 1;
   }

   DB(("types : %ld\n",types));

   typearray[types] = ~0;
}
/*FE*/

/* ----------------- scan the file and determine the type ----------------- */

/*FS*/ /*"LONG scan_file(struct Hook *hook,struct GlobalData *gd,struct spMsg *msg)"*/
RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg)
{
   STRPTR path  = msg->Path;
   STRPTR gpath = msg->RealPath;
   ULONG filetype;
   LONG retval = 0;

   DB(("Msg   : %ld\n",msg->Msg));
   DB(("path  : %s\n",msg->Path));
   DB(("gpath : %s\n",msg->RealPath));

   switch(msg->Msg)
   {
   case SPM_DIR:
      {
         BPTR olddir;

         olddir = CurrentDir(gd->gd_StartDir);

         /* create destination directory */
         strcpy(gd->gd_Dest, (STRPTR) gd->gd_Para[ARG_TO]);
         if(AddPart(gd->gd_Dest,path,sizeof(gd->gd_Dest)))
         {
            ULONG len = strlen(gd->gd_Dest);
            BPTR lock;

            if(gd->gd_Dest[len-1] == '/')
               gd->gd_Dest[len-1] = EOS;

            DB(("try to create : %s\n",gd->gd_Dest));
            if(!(lock = Lock(gd->gd_Dest,SHARED_LOCK)))
               lock = CreateDir(gd->gd_Dest);

            UnLock(lock);
            DB(("%s created : %lx\n",gd->gd_Dest,lock));
         }

         /* update status window */
         gd->gd_SStat.ss_ActDirectories++;

         if(gd->gd_Workbench)
         {
            sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActDirectories,gd->gd_SStat.ss_Directories);
            draw_scanwindowtext(&gd->gd_SWin,NUM_DIRS,gd->gd_TempBuffer);

         } else if(gd->gd_Para[ARG_VERBOSE])
            Printf ("\rScanning dir (%3ld/%3ld) : %-40s\n",
                     gd->gd_SStat.ss_ActDirectories,
                     gd->gd_SStat.ss_Directories,
                     gpath);

         CurrentDir(olddir);
      }
      break;
   case SPM_FILE:
      gd->gd_SStat.ss_ActFiles++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActFiles,gd->gd_SStat.ss_Files);
         draw_scanwindowtext(&gd->gd_SWin,NUM_FILES    ,gd->gd_TempBuffer);
      } else if(gd->gd_Para[ARG_VERBOSE])
         Printf ("\rConverting file (%3ld/%3ld) : %s ",
                 gd->gd_SStat.ss_ActFiles,
                 gd->gd_SStat.ss_Files,
                 path);

      DB(("scanfile : %s\n",path));

      if((filetype = getfiletype(msg->FHandle,msg->RealPath)) != FTYPE_UNKNOWN)
      {
         gd->gd_ReadFH = msg->FHandle;

         strcpy(gd->gd_Dest, (STRPTR) gd->gd_Para[ARG_TO]);
         if(AddPart(gd->gd_Dest,path,sizeof(gd->gd_Dest)))
         {  
            convertsuffix(filetype,gd->gd_Dest);

            DB(("to : \"%s\"\n",gd->gd_Dest));

            if(gd->gd_Workbench)
            {
               /* output the current destination file */
               sprintf(gd->gd_TempBuffer,"%s (%s)",gpath,ftype[filetype]);
               draw_scanwindowtext(&gd->gd_SWin,NUM_SOURCE   ,gd->gd_TempBuffer);
               draw_scanwindowtext(&gd->gd_SWin,NUM_DEST     ,gd->gd_Dest);

               draw_gauge(&gd->gd_SWin.sw_Actual,0,0);
            } else if(gd->gd_Para[ARG_VERBOSE])
               Printf ("(%s)%-30s\n",ftype[filetype],"");

            if((gd->gd_InternPool = LibCreatePool(MEMF_ANY | MEMF_CLEAR,PUDDLE_SIZE,THRESH_SIZE)))
            {
               BOOL noamigaguide;
               BPTR olddir;

               /* init new intern xref list */
               NewList(&gd->gd_InternXRef);

               gd->gd_FullPath = gpath;
               gd->gd_FileName = path;
               gd->gd_FileSize = msg->Fib->fib_Size;
               gd->gd_FileType = filetype;

               noamigaguide = gd->gd_Para[ARG_NOAMIGAGUIDE];

               /* change to start directory to support relative directories */
               olddir = CurrentDir(gd->gd_StartDir);

               if((gd->gd_WriteFH = Open(gd->gd_Dest,MODE_NEWFILE)))
               {
                  DB(("file %s opened !\n",gd->gd_Dest));
                  write_guide_header(gd);

                  /* convert the suffix for filename checking (write_link()) */
                  convertsuffix(filetype,path);

                  switch(filetype)
                  {
                  case FTYPE_DOC:
                     scan_doc(gd);              /* convert a normal doc file */
                     break;
                  case FTYPE_AUTODOC:
                     scan_autodoc(gd);          /* convert an autodoc file */
                     break;
                  case FTYPE_HEADER:
                     scan_header(gd);           /* convert a C header file */
                     break;
                  case FTYPE_AMIGAGUIDE:
                     scan_amigaguide(gd);       /* convert a existing amigaguide file */
                     break;
                  case FTYPE_MAN:
                     scan_man(gd);              /* convert a unix manual page file */
                     break;
                  case FTYPE_INFO:
                     scan_info(gd);             /* convert a GNU infoview file */
                     break;
                  }

                  if(gd->gd_Workbench)
                     draw_gauge(&gd->gd_SWin.sw_Actual,1,1);

                  if(!gd->gd_Para[ARG_NOAMIGAGUIDE] && gd->gd_OpenNodes)
                     FPuts(gd->gd_WriteFH,endnode);

                  gd->gd_ConvertedFiles++;

                  Close(gd->gd_WriteFH);
               }

               /* if the user has abort , just delete the destination */
               if(gd->gd_Abort)           
                  DeleteFile(gd->gd_Dest);
               else if(!gd->gd_Para[ARG_NOICON])
                  saveicon(gd->gd_Dest,&icondef);

               CurrentDir(olddir);

               gd->gd_Para[ARG_NOAMIGAGUIDE] = noamigaguide;

               /* deletes all memory allocated by this pool (internal xrefs) */
               LibDeletePool(gd->gd_InternPool);
            } 
         }

         gd->gd_ReadFH = NULL;
      } else if(!gd->gd_Workbench && gd->gd_Para[ARG_VERBOSE])
         Printf ("(unknown)%-30s\n","");

      gd->gd_SStat.ss_ActTotalFileSize += msg->Fib->fib_Size;
      draw_state(gd);
      break;
   }

   if(check_abort(gd))
      return(ERROR_BREAK);

   return(retval);
}
/*FE*/

/* ----------- scan the determined file an write the amigaguide ----------- */

/*FS*//*"void scan_amigaguide(struct GlobalData *gd)"*/
void scan_amigaguide(struct GlobalData *gd)
{
   STRPTR delim = (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];
   STRPTR ptr;
   STRPTR name;
   STRPTR link;

   gd->gd_Para[ARG_NOAMIGAGUIDE] = TRUE;

   while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
   {
      if(!Strnicmp(ptr,"@node",5))
      {
         link = ptr + 5;

         getamigaguidenode(&link,&name);

         allocinternxref(gd,name,link);
      }
   }

   if(!gd->gd_Abort)
   {
      Seek(gd->gd_ReadFH,0,OFFSET_BEGINNING);

      while((gd->gd_Ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
      {
         if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
            draw_state(gd);

         if(*gd->gd_Ptr == '@')
         {
            FPuts(gd->gd_WriteFH,gd->gd_Ptr);

            /* get actual node */
            if(!Strnicmp(gd->gd_Ptr,"@node",5))
            {
               link = gd->gd_Ptr + 5;
               getamigaguidenode(&link,&name);
               strcpy(gd->gd_NameBuffer,name);
            }
            continue;
         }

         while(getword(gd,delim))
         {
            /* don't link words, which are in the exception list */
            if(check_exception(gd))
               continue;

            if(!check_internxref(gd))      /* check intern xref for an amigaguide (all @node's) */
               if(!check_keyword(gd))
                  check_reference(gd);
         }
      }
   }
}
/*FE*/
/*FS*//*"void scan_header(struct GlobalData *gd)"*/
void scan_header(struct GlobalData *gd)
{
   STRPTR delim = (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];
   STRPTR ptr;

   while((gd->gd_Ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      while(ptr = getword(gd,delim))
      {
         /* don't link words, which are in the exception list */
         if(check_exception(gd))
            continue;

         if(!check_keyword(gd))
            check_reference(gd);
      }
   }
}
/*FE*/
/*FS*//*"void scan_autodoc(struct GlobalData *gd)"*/
void scan_autodoc(struct GlobalData *gd)
{
   BPTR wfh = gd->gd_WriteFH;

   STRPTR wordbuf = gd->gd_WordBuffer;
   STRPTR delim   = (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];
   STRPTR ptr;

   LONG table_of_contents = 0;

   STRPTR tmpptr;
   UWORD columns = 2;
   UWORD actcol  = 0;
   UWORD linelen = 80;
   UWORD tabwidth= 40;

   DB(("dest file : %s\n",gd->gd_Dest));
   
   /* try to get the defaults from the library */
   if(GetXRefBaseAttrs(XREFBA_Columns     ,&columns,
                       XREFBA_LineLength  ,&linelen,TAG_DONE) == 2)
   {

      tabwidth = linelen / columns;
   }

   /* amigaguide.datatype prior V40 cannot handle settabs command */
   if(SysBase->lib_Version < 40)
      columns = 1;

   /* set the tabs */
   if(columns > 1)
   {
      ULONG i;
      ULONG tabs = tabwidth;

      if(gd->gd_Para[ARG_V40])
         FPuts(wfh,"@smartwrap\n");

      FPuts(wfh,"@{settabs");
      for(i = columns ; i > 1 ; i--)
      {
         FPrintf(wfh," %2ld",tabs);
         tabs += tabwidth;
      }
      FPuts(wfh,"}");
   }

   gd->gd_SmartWrapped = TRUE;

   while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      gd->gd_Ptr = ptr;

      if(gd->gd_Para[ARG_V40])
      {
         /* if an empty line is found with the V40 option save to linefeed's */
         tmpptr = ptr;
         while(*tmpptr == ' ' || *tmpptr == '\t')
            tmpptr++;

         if(*tmpptr == '\n')
         {
            FPuts(gd->gd_WriteFH,"\n");
            continue;
         }
      }

      if(table_of_contents == 0)
      {
         if(!strncmp(ptr,toc,strlen(toc)))
            table_of_contents++;
         continue;
      } else if(table_of_contents == 1)
      {
         if(*ptr != '\f')
         {
            if(*ptr == '\n')
               continue;

            if(getword(gd," \n") && *wordbuf != EOS)
            {
               STRPTR addparent = NULL;
               STRPTR entryname = FilePart(wordbuf);

               if(checkentrytype(entryname) == XREFT_FUNCTION)
                  addparent = "()";

               FPrintf(wfh,"@{\" %s%s \" link \"%s%s\"}",entryname,addparent,
                                                         entryname,addparent);

               FPutC(wfh,'\t');
               if(++actcol == columns)
               {
                  actcol = 0;
                  FPutC(wfh,'\n');
               }

               sprintf(gd->gd_WordBuffer,"%s%s",entryname,addparent);
            }
            continue;
         } else
         {
            table_of_contents++;
            FPutC(wfh,'\n');
         }
      }


      /* the end of an autodoc entry detected by a formfeed */
      if(*ptr == '\f')
      {
         DB(("formfeed detected\n"));
         gd->gd_OpenNodes--;

         if(!gd->gd_Para[ARG_NOAMIGAGUIDE])
            FPuts(wfh,endnode);

         ptr++;

         while(*ptr == ' ' || *ptr == '\t')
            ptr++;

         while(ptr && *ptr == '\n')
            ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer));

         /* just the end of the file, thus terminate the loop */
         if(!ptr)
            break;

         gd->gd_Ptr = ptr;

         if(getword(gd," \t\n") && *wordbuf != EOS)
         {
            STRPTR addparent = NULL;
            STRPTR wordptr   = wordbuf;

            if(strlen(wordptr) > 40)
               wordptr += (strlen(wordbuf) >> 1);

            if(checkentrytype(FilePart(wordptr)) == XREFT_FUNCTION && 
               strcmp(&wordbuf[strlen(wordbuf)-2],"()"))
               addparent = "()";

            FPrintf(wfh,"@node \"%s%s\" \"%s%s\"\n",FilePart(wordptr),addparent,
                                                    wordptr,addparent);

            sprintf(gd->gd_NameBuffer,"%s%s\0",FilePart(wordptr),addparent);

            DB(("nodename %s\n",gd->gd_NameBuffer));

            gd->gd_SmartWrapped = TRUE;
            gd->gd_OpenNodes++;
            continue;
         }
      }

      gd->gd_Ptr = ptr;

      if(check_autodocintro(gd,ptr))
         continue;

      gd->gd_LineBegin = TRUE;

      /* get the next WORD according to the delimiters */
      while(getword(gd,delim))
      {
         /* don't link words, which are in the exception list */
         if(check_exception(gd))
            continue;

         if(!check_keyword(gd))      /* check for any given keyword */
            check_reference(gd);     /* check for any other reference */
      }
   }
}
/*FE*/
/*FS*//*"void scan_doc(struct GlobalData *gd)"*/
void scan_doc(struct GlobalData *gd)
{
   STRPTR delim = (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];

   UBYTE pagebuf[20];
   LONG pages = 1;

   strcpy(gd->gd_NameBuffer,FilePart(gd->gd_Dest));
   gd->gd_NameBuffer[strlen(gd->gd_NameBuffer) - 6] = EOS;

   while((gd->gd_Ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      if(*gd->gd_Ptr == '\f')
      {
         STRPTR ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer));
         STRPTR node;
         STRPTR name;

         if(ptr)
         {
            while(*ptr == ' ' || *ptr == '\t')
               ptr++;

            node = ptr;
            name = ptr;

            while(*ptr != EOS)
            {
               if(*ptr == ':')
               {
                  *ptr = '-';
                  name = ptr + 1;
               } else if(*ptr == '\n')
                  *ptr = EOS;

               ptr++;
            }

            while(*name == ' ' || *name == '\t')
               name++;

            ptr[strlen(ptr) - 1] = EOS;

            if(*node == EOS)
            {
               node = pagebuf;
               sprintf(pagebuf,"Page %ld",++pages);
            }

            if(*name == EOS)
               name = node;

            if(!gd->gd_Para[ARG_NOAMIGAGUIDE])
               FPrintf(gd->gd_WriteFH,"@endnode\n"
                                      "@node \"%s\" \"%s\"\n",node,name);
         }
         continue;
      }

      if(check_autodocintro(gd,gd->gd_Ptr))
         continue;

      while(getword(gd,delim))
      {
         /* don't link words, which are in the exception list */
         if(check_exception(gd))
            continue;
         
         if(!check_keyword(gd))
            check_reference(gd);
      }
   }
}
/*FE*/
/*FS*/ /*"void scan_man(struct GlobalData *gd) "*/
void scan_man(struct GlobalData *gd)
{
   STRPTR delim = (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];

   strcpy(gd->gd_NameBuffer,"main");

   while((gd->gd_Ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,sizeof(gd->gd_LineBuffer))) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      if(check_autodocintro(gd,gd->gd_TempBuffer))
         continue;

      while(getword(gd,delim))
      {
         /* don't link words, which are in the exception list */
         if(check_exception(gd))
            continue;
         
         if(!check_keyword(gd))
            check_reference(gd);
      }
   }
}
/*FE*/
/*FS*/ /*"void scan_info(struct GlobalData *gd) "*/
void scan_info(struct GlobalData *gd)
{
}
/*FE*/

/*FS*/ /*"BOOL check_exception(struct GlobalData *gd) "*/
BOOL check_exception(struct GlobalData *gd)
{
   struct Exceptions *except;
   STRPTR ptr;
   STRPTR end;

   for(except = (struct Exceptions *) gd->gd_ExceptionList.lh_Head ;
       except->e_Node.ln_Succ ;
       except = (struct Exceptions *) except->e_Node.ln_Succ)
   {
      ptr = except->e_Node.ln_Name;
      end = except->e_Node.ln_Name + except->e_Length;

      /* check if this is a exception word */
      while(ptr < end && strcmp(ptr,gd->gd_WordBuffer))
         ptr += (strlen(ptr) + 1);

      if(ptr < end && !gd->gd_SeeAlso)
      {
         write_word(gd);
         return(TRUE);
      }
   }

   return(FALSE);
}
/*FE*/
/*FS*//*"BOOL check_autodocintro(struct GlobalData *gd,STRPTR line)"*/
BOOL check_autodocintro(struct GlobalData *gd,STRPTR line)
{
   STRPTR tmpptr = line;
   STRPTR name;

   BPTR wfh = gd->gd_WriteFH;
   LONG i = 0;

   if(!tmpptr)
      return(FALSE);

   while(*tmpptr++ == ' ')
      i++;

   name = tmpptr - 1;

   while(*tmpptr != '\n' && (*tmpptr == ' ' || isupper(*tmpptr)))
      tmpptr++;

   if(*tmpptr == '\n' && ((i >= (LONG) (gd->gd_Para[ARG_INDENT] - 2)) &&
                          (i <= (LONG) (gd->gd_Para[ARG_INDENT] + 2))))
   {
      *tmpptr = EOS;
      DB(("autodoc intro statement found\n",name));

      if(gd->gd_Para[ARG_V40])
      {
         strcpy(gd->gd_WordBuffer,name);
         /* if the last paragraph wasn't smartwrapped -> overwrite last newline */
         if(!gd->gd_SmartWrapped)
         {
            Flush(gd->gd_WriteFH);
            Seek(gd->gd_WriteFH,-1,OFFSET_CURRENT);
         }

         gd->gd_SmartWrapped = check_keyword(gd);
      } else
      {
         gd->gd_SmartWrapped = FALSE;
         for(i = gd->gd_Para[ARG_INDENT] ; i ; i--)
            FPutC(wfh,' ');
      }

      if(!gd->gd_SmartWrapped)
         FPrintf(wfh,gd->gd_AutoDocIntro,name);

      FPutC(wfh,'\n');

      draw_keyword(gd);

      /* see also block follow's , so don't use the exception words */
      if(!strcmp(name,"SEE ALSO"))
         gd->gd_SeeAlso = TRUE;
      else
         gd->gd_SeeAlso = FALSE;

      return(TRUE);
   }

   return(FALSE);
}
/*FE*/
/*FS*//*"BOOL check_keyword(struct GlobalData *gd)"*/
BOOL check_keyword(struct GlobalData *gd)
{
   struct KeyWord *keyword;

   BPTR wfh = gd->gd_WriteFH;

   STRPTR wordbuf = gd->gd_WordBuffer;
   STRPTR ptr;
   WORD comp = 1;

   for(keyword = (struct KeyWord *) gd->gd_KeywordList.lh_Head ; keyword->kw_Node.ln_Succ ;
       keyword = (struct KeyWord *) keyword->kw_Node.ln_Succ)
   {
      if(!(comp = strcmp(keyword->kw_Keyword,wordbuf)))
      {
         BOOL link = FALSE;
         DB(("keyword : %s,%s\n",keyword->kw_Keyword,gd->gd_NameBuffer));

         /* don't substitute any words, which are in the node itself */
         if(!Strnicmp(wordbuf,gd->gd_NameBuffer,strlen(wordbuf)))
         {
            write_word(gd);
            break;
         }

         if(keyword->kw_NextWord)
         {
            STRPTR delim = (keyword->kw_Delimiters) ? keyword->kw_Delimiters :
                                                      (STRPTR) gd->gd_Para[ARG_STDDELIMITERS];

            DB(("delim : \"%s\"\n",delim));
            write_word(gd);

            if(ptr = getword(gd,delim))
            {
               /* handle struct keyword separatly to make a link (reference)
               ** or a display (definintion)
               */

               DB(("word : \"%s\"\n",wordbuf));

               if(!strcmp(keyword->kw_Keyword,"struct"))
               {
                  STRPTR tmpptr = ptr;

                  while(*tmpptr == ' ' || *tmpptr == '\t')
                     tmpptr++;

                  /* don't link the declaration itself */
                  if(*tmpptr != '{' && *tmpptr != '\n')
                     link = TRUE;
               }

               if(!link)
               {
                  /* varray[i] is set to wordbuf, thus i can handle 10 %s */
                  VFPrintf(wfh,keyword->kw_Substitute,gd->gd_VArray);

                  draw_keyword(gd);
               } else
               {
                  DB(("check reference\n"));
                  check_reference(gd);
               }
            }
         } else
         {
            /* varray[i] is set to wordbuf, thus i can handle 10 %s */
            VFPrintf(wfh,keyword->kw_Substitute,gd->gd_VArray);

            draw_keyword(gd);
         }

         break;
      } else if(comp > 0)
         break;
   }

   return((BOOL) (comp == 0));
}
/*FE*/
/*FS*//*"BOOL check_internxref(struct GlobalData *gd)"*/
BOOL check_internxref(struct GlobalData *gd)
{
   struct Node *node;
   STRPTR wordbuf = gd->gd_WordBuffer;
   WORD cmp = 1;

   for(node = gd->gd_InternXRef.lh_Head ; node->ln_Succ ; node = node->ln_Succ)
       if((cmp = strcmp(node->ln_Name,wordbuf)) >= 0)
          break;

   if(cmp)
   {
      /* check if the current phrase matches any intern xref (including white spaces) ! */
      for(node = gd->gd_InternXRef.lh_Head ; node->ln_Succ ; node = node->ln_Succ)
      {
         if((cmp = strncmp(node->ln_Name,gd->gd_CurrentPtr,IXR(node)->ixr_NameLen)) >= 0)
         {
            if(cmp == 0)
            {
               gd->gd_Ptr = gd->gd_CurrentPtr + IXR(node)->ixr_NameLen;
               strcpy(wordbuf,gd->gd_CurrentPtr);
               wordbuf[IXR(node)->ixr_NameLen] = EOS;
            }
            break;
         }
      }

      if(cmp)
      {
         STRPTR filepart;
         ULONG len;

         /* check if the current phrase matches any intern xref (including white spaces) ! */
         for(node = gd->gd_InternXRef.lh_Head ; node->ln_Succ ; node = node->ln_Succ)
         {
            filepart = FilePart(node->ln_Name);
            len = strlen(filepart);

            if(strncmp(filepart,gd->gd_CurrentPtr,len) == 0)
            {
               gd->gd_Ptr = gd->gd_CurrentPtr + len;
               strcpy(wordbuf,filepart);
               cmp = 0;
               DB(("intern : \"%s\" -> \"%s\" !\n",filepart,gd->gd_CurrentPtr));
               break;
            }
         }

         /* check if the current WORD matches an intern xref ! */
         if(cmp)
         {
            ULONG len = strlen(wordbuf);

            for(node = gd->gd_InternXRef.lh_Head ; node->ln_Succ ; node = node->ln_Succ)
               if((cmp = strncmp(node->ln_Name,wordbuf,len)) >= 0)
               {
                  if(!(cmp == 0 && (!strcmp(&node->ln_Name[len],"()") || len == IXR(node)->ixr_NameLen)))
                     cmp = 1;
                  break;
               }
         }
      }
   }

   if(cmp == 0)
   {
      /* don't link any words, which are the same as the filename */
      if(strncmp(node->ln_Name,gd->gd_NameBuffer,IXR(node)->ixr_NameLen))
      {
         gd->gd_GlobalStat.Number[XREFCT_INTERN]++;
         gd->gd_Links++;

         if(gd->gd_Workbench)
         {
            sprintf(gd->gd_TempBuffer,"%ld",gd->gd_Links);
            draw_scanwindowtext(&gd->gd_SWin,NUM_LINKS,gd->gd_TempBuffer);
         }

         FPrintf(gd->gd_WriteFH,"@{\"%s\" link \"%s\"}",wordbuf,((struct InternXRef *) node)->ixr_Link);
      } else
         write_word(gd);

      return(TRUE);
   }

   return(FALSE);
}
/*FE*/
/*FS*//*"void check_reference(struct GlobalData *gd)"*/
void check_reference(struct GlobalData *gd)
{
   STRPTR wordbuf = gd->gd_WordBuffer;
   struct Convert *conv = &gd->gd_Convert;
   STRPTR slash;

   conv->Number = 0;

   gd->gd_Tags[0].ti_Data = XREFMATCH_COMPARE_CASE;

   if(ParseXRef(wordbuf,gd->gd_Tags))
   {
      if(conv->Number == 0)
      {
         if((slash = FilePart(wordbuf)) != wordbuf)
         {
            slash[-1] = EOS;

            /* try to link the PathPart */
            if(ParseXRef(wordbuf,gd->gd_Tags))
            {
               if(conv->Number == 0)
               {
                  slash[-1] = '/';

                  DB(("try to link : %s,%s\n",slash,wordbuf));
                  /* if no link is made to PathPart try to link th whole path */
                  if(!ParseXRef(slash,gd->gd_Tags))
                     conv->Number = 0;
                  DB(("found number : %ld\n",conv->Number));

               } else
               {
                  /* make link to PathPart */
                  write_link(gd);
                  /* write the slash */
                  FPutC(gd->gd_WriteFH,'/');

                  strcpy(wordbuf,slash);

                  /* try to link the FilePart */
                  if(!ParseXRef(wordbuf,gd->gd_Tags))
                     conv->Number = 0;
               }
            }
         }

         if(conv->Number == 0)
         {
            gd->gd_Tags[0].ti_Data = XREFMATCH_COMPARE_NUM_CASE;

            if(ParseXRef(wordbuf,gd->gd_Tags))
            {
               /* only use the three types below with COMPARE_NUM */
               if(conv->Number > 0)
                  switch(conv->xr_Type)
                  {
                  case XREFT_COMMAND:
                  case XREFT_FUNCTION:
                  case XREFT_GENERIC:
                     break;
                  default:
                     conv->Number = 0;
                  }
            }
         }
      }

      if(conv->Number > 0)
         write_link(gd);
      else
         write_word(gd);
   } else
      write_word(gd);
}
/*FE*/

/* ---------------------- amigaguide write functions ---------------------- */

/*FS*//*"void write_guide_header(struct GlobalData *gd)"*/
void write_guide_header(struct GlobalData *gd)
{
   if(!gd->gd_Para[ARG_NOAMIGAGUIDE])
   {
      FPrintf(gd->gd_WriteFH,"@database %s\n"
                             "@master %s\n",
                              gd->gd_FileName,gd->gd_FullPath);

      if(gd->gd_Para[ARG_V40])
         FPuts(gd->gd_WriteFH,"@macro mtext \"@{lindent 8}@{pari -4}@{par}@{b}$1@{ub}@{body}@{line}\"\n"
                              "@macro mcode \"@{lindent 8}@{pari -4}@{par}@{code}@{b}$1@{ub}\"\n"
                              "@smartwrap\n");
      FPrintf(gd->gd_WriteFH,"@node main \"%s\"\n",gd->gd_FileName);

      if(!gd->gd_Para[ARG_NOMAINPAGELINK])
         FPuts(gd->gd_WriteFH,"@toc xref.library_xreffile@main\n");

      gd->gd_OpenNodes = 1;
   }
}
/*FE*/
/*FS*/ /*"void write_link(struct GlobalData *gd) "*/
void write_link(struct GlobalData *gd)
{     
   struct Convert *conv = &gd->gd_Convert;
   BPTR wfh             = gd->gd_WriteFH;
   ULONG len;

   if(conv->xr_Type != XREFT_INCLUDE)
      len = strlen(FilePart(gd->gd_WordBuffer));
   else
      len = strlen(gd->gd_WordBuffer);

   DB(("word node : %s/%s\n",gd->gd_FileName,gd->gd_NameBuffer));
   DB(("link node : %s/%s\n",conv->xr_File,conv->xr_NodeName));

   if((strcmp(conv->xr_NodeName,gd->gd_NameBuffer) || strcmp(conv->xr_File,gd->gd_FileName)) &&
      (len == strlen(conv->xr_Name)                  || !strcmp(&conv->xr_Name[len],"()")))
   {
      /* generate extern link, if the filename are nor equal, otherwise it is an internal */
      if(strcmp(conv->xr_File,gd->gd_FileName))
         FPrintf(wfh,"@{\"%s\" link \"%s%s/%s\"",
                     gd->gd_WordBuffer,
                     conv->xr_Path,
                     conv->xr_File,
                     conv->xr_NodeName);
      else
         FPrintf(wfh,"@{\"%s\" link \"%s\"",
                     gd->gd_WordBuffer,
                     conv->xr_NodeName);

      if(conv->xr_Line != ~0)
         FPrintf(wfh," %ld",conv->xr_Line);

      FPutC(wfh,'}');

      gd->gd_GlobalStat.Number[conv->xr_Type]++;
      gd->gd_Links++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"%ld",gd->gd_Links);
         draw_scanwindowtext(&gd->gd_SWin,NUM_LINKS,gd->gd_TempBuffer);
      }
   } else
      write_word(gd);
}
/*FE*/
/*FS*/ /*"void write_word(struct GlobalData *gd) "*/
void write_word(struct GlobalData *gd)
{
   if(*gd->gd_WordBuffer)
      FPrintf(gd->gd_WriteFH,style_strings[gd->gd_StyleType],gd->gd_WordBuffer);
   gd->gd_StyleType = STYLE_UNKNOWN;
}
/*FE*/

/* ------------------------ separate the next WORD ------------------------ */

/*FS*//*"STRPTR getword(struct GlobalData *gd,STRPTR delim)"*/
STRPTR getword(struct GlobalData *gd,STRPTR delim)
{
   STRPTR line = gd->gd_Ptr;
   STRPTR buf  = gd->gd_WordBuffer;
   BOOL skipdelim = gd->gd_Para[ARG_V40] && gd->gd_LineBegin;
   UWORD indent = 0;
   UWORD skipindent = 2 * gd->gd_Para[ARG_INDENT] - 1;

   gd->gd_StyleType = STYLE_UNKNOWN;

   /* skip all delimiters */

   while(*line && strchr(delim,*line))
   {
      if(gd->gd_FileType == FTYPE_MAN)
         if(line[1] == '\010')
            line +=2;

      if(!skipdelim)
         FPutC(gd->gd_WriteFH,*line);
      else if(indent == skipindent)
      {
         skipdelim = FALSE;
         if(line[1] && strchr(delim,line[1]) && gd->gd_SmartWrapped)
            FPuts(gd->gd_WriteFH,"@{line}");
      } else
         indent++;

      line++;
   }

   gd->gd_CurrentPtr = line;

   /* skip all links of an amigaguide file */
   if(gd->gd_FileType == FTYPE_AMIGAGUIDE)
      if(*line == '@' && *(line + 1) == '{')
      {
         line += 2;
         while(*line != '}' && *line != EOS)
            line++;

         FWrite(gd->gd_WriteFH,gd->gd_CurrentPtr,(line - gd->gd_CurrentPtr),1);
         gd->gd_CurrentPtr = line;
      }


   while(*line)
   {
      /* backspace from a manpage ? */
      if(line[1] == '\010')
      {
         if(gd->gd_StyleType == STYLE_UNKNOWN)
         {
            if(*line == '_')
               gd->gd_StyleType = STYLE_UNDERLINED;
            if(*line == line[2])
               gd->gd_StyleType = STYLE_BOLD;
         }
         line += 2;
      }

      /* skip "()" pairs, which normally indicates a system function */
      if(*line == '(' && line[1] == ')')
      {
         *buf++ = *line++;
         *buf++ = *line++;
      } else if(*line == '.' && line[1] != ' ' && line[1] != EOS && line[1] != '\t' && line[1] != '\n')
      {
         *buf++ = *line++;
         if(line[1] == '\010')
            line +=2;
         *buf++ = *line++;
      }

      if(strchr(delim,*line))
         break;

      *buf++ = *line++;
   }

   *buf   = EOS;
   gd->gd_Ptr = line;
   gd->gd_LineBegin = FALSE;

   if(*line)
      return(line);

   return(NULL);
}
/*FE*/

/* -------------------------- support functions --------------------------- */

/*FS*/ /*"BOOL check_abort(struct GlobalData *gd)"*/
BOOL check_abort(struct GlobalData *gd)
{
   if(gd->gd_SWin.sw_Window)
   {
      struct IntuiMessage *msg;

      while((msg = (struct IntuiMessage *) GetMsg(gd->gd_SWin.sw_Window->UserPort)))
      {
         switch(msg->Class)
         {
         case IDCMP_CLOSEWINDOW:
            gd->gd_Abort = TRUE;
            break;
         case IDCMP_VANILLAKEY:
            /* check if ctrl-c or ecs was pressed ? */
            if(msg->Code == 3 || msg->Code == 27)
               gd->gd_Abort = TRUE;
            break;
         }
         ReplyMsg((struct Message *) msg);
      }

      if(gd->gd_Abort)
         draw_scanwindowstatus(&gd->gd_SWin,"aborted !");

   }

   gd->gd_Abort |= (SetSignal(0L,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C);

   return(gd->gd_Abort);
}
/*FE*/

/*FS*//*"void allocinternxref(struct GlobalData *gd,STRPTR name,STRPTR link)"*/
void allocinternxref(struct GlobalData *gd,STRPTR name,STRPTR link)
{
   struct InternXRef *ixrnode;
   ULONG size = sizeof(struct InternXRef) + strlen(name) + 3;

   if(name != link)
      size += strlen(link) + 1;

   if(ixrnode = LibAllocPooled(gd->gd_InternPool,size))
   {
      DB(("intern xref : %s\n",name));

      ixrnode->ixr_Length  = size;
      ixrnode->ixr_NameLen = strlen(name);

      ixrnode->ixr_Node.ln_Name = (STRPTR) (ixrnode + 1);

      strcpy(ixrnode->ixr_Node.ln_Name,name);
      if(name == link)
         ixrnode->ixr_Link = ixrnode->ixr_Node.ln_Name;
      else
      {
         ixrnode->ixr_Link = ixrnode->ixr_Node.ln_Name + ixrnode->ixr_NameLen + 1;
         strcpy(ixrnode->ixr_Link,link);
      }

      insertbyname(&gd->gd_InternXRef,(struct Node *) ixrnode);
   }
}
/*FE*/

/* ---------------------------- draw functions ---------------------------- */

/*FS*/ /*"void draw_state(struct GlobalData *gd)"*/
void draw_state(struct GlobalData *gd)
{
   if(gd->gd_Workbench || gd->gd_Para[ARG_VERBOSE])
   {
      ULONG current; 
      ULONG acttotal;

      if(gd->gd_ReadFH)
         current = Seek(gd->gd_ReadFH,0,OFFSET_CURRENT);
      else 
         current = 0;
      
      acttotal = gd->gd_SStat.ss_ActTotalFileSize + current;

      time_calc(&gd->gd_TimeCalc,acttotal,gd->gd_SStat.ss_TotalFileSize);

      if(gd->gd_Workbench)
      {
         draw_gauge(&gd->gd_SWin.sw_Actual,current,gd->gd_FileSize);
         draw_gauge(&gd->gd_SWin.sw_Total ,acttotal,
                                           gd->gd_SStat.ss_TotalFileSize);

         draw_scanwindowtime(&gd->gd_SWin,gd->gd_TimeCalc.tc_Secs);
      } else
      {
         Printf ("\rConverting (%6ld/%6ld) , Time Exp. : %02ld:%02ld , Left : %02ld:%02ld",
                 current,gd->gd_FileSize,
                 gd->gd_TimeCalc.tc_Secs[TIME_EXPECTED] / 60,gd->gd_TimeCalc.tc_Secs[TIME_EXPECTED] % 60,
                 gd->gd_TimeCalc.tc_Secs[TIME_LEFT]     / 60,gd->gd_TimeCalc.tc_Secs[TIME_LEFT]     % 60);
      }
   }
}
/*FE*/
/*FS*/ /*"void draw_keyword(struct GlobalData *gd)"*/
void draw_keyword(struct GlobalData *gd)
{
   gd->gd_GlobalStat.Number[XREFCT_KEYWORDS]++;

   if(gd->gd_Workbench)
   {
      sprintf(gd->gd_TempBuffer,"%ld",gd->gd_GlobalStat.Number[XREFCT_KEYWORDS]);
      draw_scanwindowtext(&gd->gd_SWin,NUM_KEYWORDS,gd->gd_TempBuffer);
   }
}
/*FE*/

