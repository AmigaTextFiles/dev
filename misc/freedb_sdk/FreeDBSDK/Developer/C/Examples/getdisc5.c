
#include <proto/exec.h>
#include <proto/freedb.h>
#include <proto/dos.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>

/***************************************************************************/

#ifndef SAVEDS
#define SAVEDS  __saveds
#endif

#ifndef ASM
#define ASM     __asm
#endif

#ifndef REG
#define REG(x)  register __ ## x
#endif

/***************************************************************************/

struct Library *FreeDBBase;

/***************************************************************************/
/* This function is called anytime the process that handles remote connections
   steps into a different status. NOTE THAT THIS IS CALLED FROM ANOTHER TASK */
SAVEDS ASM LONG
statusFun(REG(a0) struct Hook *hook,REG(a1) ULONG status,REG(a2) APTR handle)
{
    FPrintf((BPTR)hook->h_Data," Status: %ld [%s]\n",status,FreeDBGetString(status));

    return 0;
}

/***************************************************************************/
/* This function is called anytime the process that handles remote connections
   finds multi matches on the remote server.
   NOTE THAT THIS IS CALLED FROM ANOTHER TASK */
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

void main(void)
{
	/* simple way to avoid ctrl-c */
    signal(SIGINT,SIG_IGN);

    /* open freedb.lirbary */
    if (FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion))
    {
        register struct FREEDBS_DiscInfo  *di;
        LONG                            err;

		/* alloc DiscInfo/TOC */
        if (di = FreeDBAllocObject(FREEDBV_AllocObject_DiscInfoTOC,TAG_DONE))
        {
            register struct FREEDBS_TOC *toc = FREEDBM_GETTOCFROMDI(di);

            /*/ read the TOC */
            if (!(err = FreeDBReadTOC(FREEDBA_TOC,toc,FREEDBA_DeviceName,"CD0",TAG_DONE)))
            {
                APTR            handle;
                struct Hook     statusHook, multiHook;
                register LONG   res;

                 /* init the status hook */
                statusHook.h_Entry = (APTR)statusFun;
                statusHook.h_Data  = (APTR)Output();

				/* init the multi hook */
                multiHook.h_Entry = (APTR)multiFun;
                multiHook.h_Data  = (APTR)Output();

				/* Try to get the disc from the lcoal cache or
				   the remote freedb server */
                res = FreeDBGetDisc(FREEDBA_HandlePtr, &handle,
                                  FREEDBA_TOC,         toc,
                                  FREEDBA_DiscInfo,    di,
                                  FREEDBA_StatusHook,  &statusHook,
                                  FREEDBA_MultiHook,   &multiHook,
                                  FREEDBA_ErrorPtr,    &err,
                                  TAG_DONE);

				/* switches the result */
                switch (res)
                {
					/* an unique match in the local cache */
                    case FREEDBV_GetDisc_LocalFound:
                        break;

					/* multi matches in the local cache */
                    case FREEDBV_GetDisc_LocalMulti:
                        break;

					/* no local match, asking to the freedb server */
                    case FREEDBV_GetDisc_Remote:
                        err = FreeDBHandleWait(handle);
                        FreeDBHandleFree(handle);
                        break;

					/* failure */
                    case FREEDBV_GetDisc_Error:
                        break;
                }

				/* if we have hope found the disc ...*/
                if (!err)
                {
                    register int i;

                    printf("DiscID: %lx\n",di->discID);
                    printf("Artist: %s\n",di->artist);
                    printf(" Title: %s\n",di->title);
                    printf("  Year: %ld\n",di->year);
                    printf(" Categ: %s\n",di->categ);
                    printf(" Genre: %s\n",di->genre);
                    printf("  Extd: %s\n",di->extd ? di->extd : "");
                    printf(" Flags: %lx\n",di->flags);

                    for (i = 0; i<di->numTracks; i++)
                    {
                        printf("Title %ld: %s\n",i,di->tracks[i]->title);
                        if (di->tracks[i]->extd)  printf(" Extd %ld: %s\n",i,di->tracks[i]->extd);
                    }
                }
                else printf("GetDisc error: %s\n",FreeDBGetString(err));
            }
            else printf("Can't read TOC: %s\n",FreeDBGetString(err));

            FreeDBFreeObject(di);
        }
        else printf("No DiscInfo\n");

        CloseLibrary(FreeDBBase);
    }
    else printf("No %s %ld+\n",FreeDBName,FreeDBVersion);
}

/***************************************************************************/
