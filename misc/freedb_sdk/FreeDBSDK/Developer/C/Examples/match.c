
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/freedb.h>
#include <stdio.h>
#include <string.h>

/***********************************************************************/

#define PRG         "match"
#define TEMPLATE    "ID/K,C=CATEG/K,T=TITLE/K,A=ARTIST/K,TI=TITLES/K"

/***********************************************************************/

int main(void)
{
    struct Library *FreeDBBase;
    int            res;

    if (FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion))
    {
        register struct RDArgs  *ra;
        LONG                    arg[5] = {0};

        if (ra = ReadArgs(TEMPLATE,(LONG *)arg,NULL))
        {
            APTR                    match;
            struct FREEDBS_DiscInfo *mdi;

            if (match = FreeDBMatchStart(FREEDBA_DiscID, arg[0],
                                         FREEDBA_Categ,  arg[1],
                                         FREEDBA_Title,  arg[2],
                                         FREEDBA_Artist, arg[3],
                                         FREEDBA_Titles, arg[4],
                                         TAG_DONE))
            {
                while (mdi = FreeDBMatchNext(match))
                {
                    printf("DiscID:%08lx Categ:%s Title:%s Artist:%s\n",mdi->discID,mdi->categ,mdi->title,mdi->artist);
                }

                FreeDBMatchEnd(match);
                res = 0;
            }
            else
            {
                printf("Can't init match\n");
                res = 5;
            }

            FreeArgs(ra);
        }
        else
        {
            PrintFault(IoErr(),PRG);
            res = 10;
        }

        CloseLibrary(FreeDBBase);
    }
    else
    {
        printf("No %s %ld+\n",FreeDBName,FreeDBVersion);
        res = 20;
    }

    return res;
}

/***********************************************************************/
