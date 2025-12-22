#ifndef GENGTXSOURCE_LOCALE_H
#define GENGTXSOURCE_LOCALE_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif


/****************************************************************************/


#define MSG_OUT_OF_MEMORY 0
#define MSG_OUT_OF_MEMORY_STR "Error -: out of memory\n"

#define MSG_WRITE_ERROR 1
#define MSG_WRITE_ERROR_STR "Error -: write error\n"

#define MSG_READ_ERROR 2
#define MSG_READ_ERROR_STR "Error -: read error\n"

#define MSG_PREPEND_FILE_ERROR 3
#define MSG_PREPEND_FILE_ERROR_STR "Error -: unable to open user descriptor file\n"

#define MSG_SOURCE_FILE_ERROR 4
#define MSG_SOURCE_FILE_ERROR_STR "Error -: unable to open source files\n"

#define MSG_INTUITION_ERROR 5
#define MSG_INTUITION_ERROR_STR "Error -: unable to open the intuition.library\n"

#define MSG_GTX_ERROR 6
#define MSG_GTX_ERROR_STR "Error -: unable to open the gadtoolsbox.library\n"

#define MSG_ERROR 7
#define MSG_ERROR_STR "Error -"

#define MSG_OPEN_FILE_ERROR 8
#define MSG_OPEN_FILE_ERROR_STR "Error -: unable to open the GUI file\n"

#define MSG_PARSE_ERROR 9
#define MSG_PARSE_ERROR_STR "Error -: unable to parse the GUI file\n"

#define MSG_DECRUNCH_ERROR 10
#define MSG_DECRUNCH_ERROR_STR "Error -: unable to decrunch the GUI file\n"

#define MSG_PPLIB_ERROR 11
#define MSG_PPLIB_ERROR_STR "Error -: the file is crunched and the powerpacker.library could not be opened\n"

#define MSG_NOT_GUI_FILE_ERROR 12
#define MSG_NOT_GUI_FILE_ERROR_STR "Error -: this is not a GadToolsBox GUI file\n"

#define MSG_XREF_STRINGS 13
#define MSG_XREF_STRINGS_STR "Cross referencing strings...\n"

#define MSG_GENERATING_SOURCE 14
#define MSG_GENERATING_SOURCE_STR "Generating source...\n"

#define MSG_PREPENDING_CD 15
#define MSG_PREPENDING_CD_STR "Inserting user descriptor file...\n"

#define MSG_BY 16
#define MSG_BY_STR "Written by"

#define MSG_LOADING 17
#define MSG_LOADING_STR "Loading...\n"

#define MSG_DONE 18
#define MSG_DONE_STR "Done.\n"


/****************************************************************************/


#ifdef STRINGARRAY

struct AppString
{
    LONG   as_ID;
    STRPTR as_Str;
};

struct AppString AppStrings[] =
{
    {MSG_OUT_OF_MEMORY,MSG_OUT_OF_MEMORY_STR},
    {MSG_WRITE_ERROR,MSG_WRITE_ERROR_STR},
    {MSG_READ_ERROR,MSG_READ_ERROR_STR},
    {MSG_PREPEND_FILE_ERROR,MSG_PREPEND_FILE_ERROR_STR},
    {MSG_SOURCE_FILE_ERROR,MSG_SOURCE_FILE_ERROR_STR},
    {MSG_INTUITION_ERROR,MSG_INTUITION_ERROR_STR},
    {MSG_GTX_ERROR,MSG_GTX_ERROR_STR},
    {MSG_ERROR,MSG_ERROR_STR},
    {MSG_OPEN_FILE_ERROR,MSG_OPEN_FILE_ERROR_STR},
    {MSG_PARSE_ERROR,MSG_PARSE_ERROR_STR},
    {MSG_DECRUNCH_ERROR,MSG_DECRUNCH_ERROR_STR},
    {MSG_PPLIB_ERROR,MSG_PPLIB_ERROR_STR},
    {MSG_NOT_GUI_FILE_ERROR,MSG_NOT_GUI_FILE_ERROR_STR},
    {MSG_XREF_STRINGS,MSG_XREF_STRINGS_STR},
    {MSG_GENERATING_SOURCE,MSG_GENERATING_SOURCE_STR},
    {MSG_PREPENDING_CD,MSG_PREPENDING_CD_STR},
    {MSG_BY,MSG_BY_STR},
    {MSG_LOADING,MSG_LOADING_STR},
    {MSG_DONE,MSG_DONE_STR},
};


#endif /* STRINGARRAY */


/****************************************************************************/


#endif /* GENGTXSOURCE_LOCALE_H */
