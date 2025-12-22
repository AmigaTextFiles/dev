
#include <proto/exec.h>
#include <proto/freedb.h>
#include <proto/dos.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>

/***********************************************************************/

#ifndef SAVEDS
#define SAVEDS __saveds
#endif

#ifndef ASM
#define ASM __asm
#endif

#ifndef REG
#define REG(x) register __ ## x
#endif

/***************************************************************************/

struct Library *FreeDBBase;

/***************************************************************************/

/* This is called if multi matches are found in the local cache
   Note that this is called from the same process */

SAVEDS ASM LONG
multiFun(REG(a0) struct Hook *hook,REG(a1) struct FREEDBS_MultiHookMessage *msg,REG(a2) APTR handle)
{
    FPrintf((BPTR)hook->h_Data,"\\
 Categ: %s\n\\
DiscID: %08lx\n\\
Artist: %s\n\\
 Title: %s\n\n",
msg->categ,
msg->discID,
msg->artist,
msg->title);

    FreeDBFreeMessage(msg);
    return 0;
}

/***************************************************************************/

void main(int argc,char **argv)
{
    /* simple way to avoid ctrl-c */
    signal(SIGINT,SIG_IGN);

    /* open freedb.library */
    if (FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion))
    {
        register struct FREEDBS_DiscInfo  *di;
        LONG                            err;

        /* alloc both DiscInfo and TOC */
        if (di = FreeDBAllocObject(FREEDBV_AllocObject_DiscInfoTOC,TAG_DONE))
        {
            register struct FREEDBS_TOC *toc = FREEDBM_GETTOCFROMDI(di);

            /* read the TOC */
            if (!(err = FreeDBReadTOC(FREEDBA_TOC,toc,FREEDBA_DeviceName,argv[1],TAG_DONE)))
            {
                struct Hook multiHook;

                 /* set multi hook */
                multiHook.h_Entry = (APTR)multiFun;
                multiHook.h_Data  = (APTR)Output();

                /* serch for the disc in the local cache */
                if (!(err = FreeDBGetLocalDisc(FREEDBA_TOC,toc,FREEDBA_DiscInfo,di,FREEDBA_MultiHook,&multiHook,TAG_DONE)))
                {
                    register int i;

                    /* print it */
                    if (di->header) printf("%s\n",di->header);
                    printf("  DiscID: %lx\n",di->discID);
                    printf("Revision: %ld\n",di->revision);
                    printf("  Artist: %s\n",di->artist);
                    printf("   Title: %s\n",di->title);
                    printf("    Year: %ld\n",di->year);
                    printf("   Categ: %s\n",di->categ);
                    printf("   Genre: %s\n",di->genre);
                    printf("    Extd: %s\n",di->extd ? di->extd : "");
                    printf("  Tracks: %ld\n",di->numTracks);
                    printf("   Flags: %lx\n",di->flags);

                    for (i = 0; i<di->numTracks; i++)
                    {
                        printf("Title %ld: %s\n",i,di->tracks[i]->title);
                        if (di->tracks[i]->extd) printf(" Extd %ld: %s\n",i,di->tracks[i]->extd);
                    }
                }
                else printf("FreeDBGetLocalDisc failure: %s\n",FreeDBGetString(err));
            }
            else printf("Can't read TOC: %s\n",FreeDBGetString(err));

            /* free the DiscInfo/TOC allocated */
            FreeDBFreeObject(di);
        }
        else printf("No DiscInfo\n");

        CloseLibrary(FreeDBBase);
    }
    else printf("No %s %ld+\n",FreeDBName,FreeDBVersion);
}

/***************************************************************************/
