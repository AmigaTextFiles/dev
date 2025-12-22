#include <exec/types.h>
#include <exec/libraries.h>
#include <libraries/asl.h>
#include <clib/exec_protos.h>
#include <clib/asl_protos.h>
#include <clib/dos_protos.h>
#include <stdio.h>
#include <string.h>

#define MYLEFTEDGE 0
#define MYTOPEDGE  0
#define MYWIDTH    320
#define MYHEIGHT   400
#define MAXFILESIZE 256

int FileRequest(void);

struct Library *AslBase = NULL;

char FileName[MAXFILESIZE];     /*Global buffer where filename will go.*/

struct TagItem frtags[] =
{
    ASL_Hail,       (ULONG)"Select file.",
    ASL_Height,     MYHEIGHT,
    ASL_Width,      MYWIDTH,
    ASL_LeftEdge,   MYLEFTEDGE,
    ASL_TopEdge,    MYTOPEDGE,
    ASL_OKText,     (ULONG)"OK",
    ASL_CancelText, (ULONG)"Cancel",
    ASL_File,       (ULONG)"",
    ASL_Dir,        (ULONG)"",
    TAG_DONE
};

int FileRequest(void)
{
    struct FileRequester *fr;
    int Ret=0;

    if (AslBase = OpenLibrary("asl.library", 37L))
    {
        if (fr = (struct FileRequester *)
            AllocAslRequest(ASL_FileRequest, frtags))
        {
            if (AslRequest(fr, NULL))
            {
                strncpy(FileName,fr->rf_Dir,MAXFILESIZE);
                Ret=AddPart(FileName,fr->rf_File,MAXFILESIZE);
            }
            FreeAslRequest(fr);
        }
        CloseLibrary(AslBase);
    }
    return Ret;
}
