#ifndef NUWEB_H
#define NUWEB_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif


/****************************************************************************/


#define MSG_WARNING_11B 0
#define MSG_WARNING_11B_STR "%s: I just ignored an unexpected argument.  "

#define MSG_USAGE_11B 1
#define MSG_USAGE_11B_STR "Usage is: %s [-cnotv] file-name ...\n"

#define MSG_ERROR_11C 2
#define MSG_ERROR_11C_STR "%s: I expected a file name.  "

#define MSG_VERBOSE_14B 3
#define MSG_VERBOSE_14B_STR "I'm reading file %s\n"

#define MSG_WARNING_15A 4
#define MSG_WARNING_15A_STR "%s: I just ignored an unexpected @ sequence (file %s, line %d)\n"

#define MSG_VERBOSE_17A 5
#define MSG_VERBOSE_17A_STR "I'm writing file %s\n"

#define MSG_WARNING_17A 6
#define MSG_WARNING_17A_STR "%s: I can't open file %s\n"

#define MSG_LATEX_20B 7
#define MSG_LATEX_20B_STR "\\item This file is defined by scraps "

#define MSG_LATEX_20C 8
#define MSG_LATEX_20C_STR "\\item This macro is defined by scraps "

#define MSG_LATEX_21A1 9
#define MSG_LATEX_21A1_STR "\\item This macro is referenced in scraps "

#define MSG_LATEX_21A2 10
#define MSG_LATEX_21A2_STR "\\item This macro is referenced in scrap "

#define MSG_LATEX_21A3 11
#define MSG_LATEX_21A3_STR "\\item This macro is never referenced.\n"

#define MSG_WARNING_21A 12
#define MSG_WARNING_21A_STR "%s: <%s> is never referenced.\n"

#define MSG_WARNING_23B 13
#define MSG_WARNING_23B_STR "%s: scrap <%s> is never defined\n"

#define MSG_LATEX_25A1 14
#define MSG_LATEX_25A1_STR "{\\footnotesize Defined by scraps "

#define MSG_LATEX_25A2 15
#define MSG_LATEX_25A2_STR "{\\footnotesize Defined by scrap "

#define MSG_LATEX_25C1 16
#define MSG_LATEX_25C1_STR "Referenced in scraps "

#define MSG_LATEX_25C2 17
#define MSG_LATEX_25C2_STR "Referenced in scrap "

#define MSG_LATEX_25C3 18
#define MSG_LATEX_25C3_STR "Not referenced."

#define MSG_HTML_31C 19
#define MSG_HTML_31C_STR "This file is defined by "

#define MSG_HTML_31D 20
#define MSG_HTML_31D_STR "This macro is defined by "

#define MSG_HTML_31E1 21
#define MSG_HTML_31E1_STR "This macro is referenced by "

#define MSG_HTML_31E2 22
#define MSG_HTML_31E2_STR "This macro is never referenced.\n"

#define MSG_HTML_32C1 23
#define MSG_HTML_32C1_STR "scraps"

#define MSG_HTML_32C2 24
#define MSG_HTML_32C2_STR "scrap"

#define MSG_HTML_35C 25
#define MSG_HTML_35C_STR "Defined by "

#define MSG_HTML_35E1 26
#define MSG_HTML_35E1_STR "Referenced in "

#define MSG_HTML_35E2 27
#define MSG_HTML_35E2_STR "Not referenced.\n"

#define MSG_ERROR_38 28
#define MSG_ERROR_38_STR "%s: I can't create %s for a temporary file\n"

#define MSG_ERROR_42A 29
#define MSG_ERROR_42A_STR "%s: bad @ sequence (file %s, line %d)\n"

#define MSG_ERROR_42B1 30
#define MSG_ERROR_42B1_STR "%s: include nesting too deep (file %s, line %d)\n"

#define MSG_ERROR_42B2 31
#define MSG_ERROR_42B2_STR "%s: I can't open include file %s\n"

#define MSG_ERROR_43A 32
#define MSG_ERROR_43A_STR "%s: unexpected characters after file name (file %s, line %d)\n"

#define MSG_ERROR_43C 33
#define MSG_ERROR_43C_STR "%s: I couldn't open file %s\n"

#define MSG_WARNING_45C 34
#define MSG_WARNING_45C_STR "%s: You'll need to rerun nuweb after running latex\n"

#define MSG_ERROR_47B 35
#define MSG_ERROR_47B_STR "%s: unexpected EOF in scrap (file %s, line %d)\n"

#define MSG_ERROR_47C 36
#define MSG_ERROR_47C_STR "%s: unexpected @%c in scrap (file %s, line %d)\n"

#define MSG_ERROR_50A 37
#define MSG_ERROR_50A_STR "%s: I found an internal problem (1)\n"

#define MSG_ERROR_52C1 38
#define MSG_ERROR_52C1_STR "%s: I discovered a recursive macro involving <%s>\n"

#define MSG_WARNING_52C2 39
#define MSG_WARNING_52C2_STR "%s: The macro was never defined <%s>\n"

#define MSG_WARNING_56B 40
#define MSG_WARNING_56B_STR "%s: ambiguous prefix @<%s...@> (file %s, line %d)\n"

#define MSG_ERROR_59A1 41
#define MSG_ERROR_59A1_STR "%s: I expected a file name (file %s, line %d)\n"

#define MSG_ERROR_59A2 42
#define MSG_ERROR_59A2_STR "%s: I expected @{, @[, or @( after file name (file %s, line %d)\n"

#define MSG_WARNING_59B 43
#define MSG_WARNING_59B_STR "%s: unexpected per-file flag (file %s, line %d)\n"

#define MSG_ERROR_60A 44
#define MSG_ERROR_60A_STR "%s: I expected a macro name (file %s, line %d)\n"

#define MSG_ERROR_60B 45
#define MSG_ERROR_60B_STR "%s: unexpected @%c in macro name (file %s, line %d)\n"

#define MSG_ERROR_61A 46
#define MSG_ERROR_61A_STR "%s: empty scrap name (file %s, line %d)\n"

#define MSG_ERROR_61B 47
#define MSG_ERROR_61B_STR "%s: I expected @{, @[, or @( after macro name (file %s, line %d)\n"

#define MSG_ERROR_62A1 48
#define MSG_ERROR_62A1_STR "%s: unexpected characters in macro name (file %s, line %d)\n"

#define MSG_ERROR_62A2 49
#define MSG_ERROR_62A2_STR "%s: unexpected end of file (file %s, line %d)\n"


/****************************************************************************/


#ifdef STRINGARRAY

struct AppString
{
    LONG   as_ID;
    STRPTR as_Str;
};

struct AppString AppStrings[] =
{
    {MSG_WARNING_11B,MSG_WARNING_11B_STR},
    {MSG_USAGE_11B,MSG_USAGE_11B_STR},
    {MSG_ERROR_11C,MSG_ERROR_11C_STR},
    {MSG_VERBOSE_14B,MSG_VERBOSE_14B_STR},
    {MSG_WARNING_15A,MSG_WARNING_15A_STR},
    {MSG_VERBOSE_17A,MSG_VERBOSE_17A_STR},
    {MSG_WARNING_17A,MSG_WARNING_17A_STR},
    {MSG_LATEX_20B,MSG_LATEX_20B_STR},
    {MSG_LATEX_20C,MSG_LATEX_20C_STR},
    {MSG_LATEX_21A1,MSG_LATEX_21A1_STR},
    {MSG_LATEX_21A2,MSG_LATEX_21A2_STR},
    {MSG_LATEX_21A3,MSG_LATEX_21A3_STR},
    {MSG_WARNING_21A,MSG_WARNING_21A_STR},
    {MSG_WARNING_23B,MSG_WARNING_23B_STR},
    {MSG_LATEX_25A1,MSG_LATEX_25A1_STR},
    {MSG_LATEX_25A2,MSG_LATEX_25A2_STR},
    {MSG_LATEX_25C1,MSG_LATEX_25C1_STR},
    {MSG_LATEX_25C2,MSG_LATEX_25C2_STR},
    {MSG_LATEX_25C3,MSG_LATEX_25C3_STR},
    {MSG_HTML_31C,MSG_HTML_31C_STR},
    {MSG_HTML_31D,MSG_HTML_31D_STR},
    {MSG_HTML_31E1,MSG_HTML_31E1_STR},
    {MSG_HTML_31E2,MSG_HTML_31E2_STR},
    {MSG_HTML_32C1,MSG_HTML_32C1_STR},
    {MSG_HTML_32C2,MSG_HTML_32C2_STR},
    {MSG_HTML_35C,MSG_HTML_35C_STR},
    {MSG_HTML_35E1,MSG_HTML_35E1_STR},
    {MSG_HTML_35E2,MSG_HTML_35E2_STR},
    {MSG_ERROR_38,MSG_ERROR_38_STR},
    {MSG_ERROR_42A,MSG_ERROR_42A_STR},
    {MSG_ERROR_42B1,MSG_ERROR_42B1_STR},
    {MSG_ERROR_42B2,MSG_ERROR_42B2_STR},
    {MSG_ERROR_43A,MSG_ERROR_43A_STR},
    {MSG_ERROR_43C,MSG_ERROR_43C_STR},
    {MSG_WARNING_45C,MSG_WARNING_45C_STR},
    {MSG_ERROR_47B,MSG_ERROR_47B_STR},
    {MSG_ERROR_47C,MSG_ERROR_47C_STR},
    {MSG_ERROR_50A,MSG_ERROR_50A_STR},
    {MSG_ERROR_52C1,MSG_ERROR_52C1_STR},
    {MSG_WARNING_52C2,MSG_WARNING_52C2_STR},
    {MSG_WARNING_56B,MSG_WARNING_56B_STR},
    {MSG_ERROR_59A1,MSG_ERROR_59A1_STR},
    {MSG_ERROR_59A2,MSG_ERROR_59A2_STR},
    {MSG_WARNING_59B,MSG_WARNING_59B_STR},
    {MSG_ERROR_60A,MSG_ERROR_60A_STR},
    {MSG_ERROR_60B,MSG_ERROR_60B_STR},
    {MSG_ERROR_61A,MSG_ERROR_61A_STR},
    {MSG_ERROR_61B,MSG_ERROR_61B_STR},
    {MSG_ERROR_62A1,MSG_ERROR_62A1_STR},
    {MSG_ERROR_62A2,MSG_ERROR_62A2_STR},
};


#endif /* STRINGARRAY */


/****************************************************************************/


#endif /* NUWEB_H */
