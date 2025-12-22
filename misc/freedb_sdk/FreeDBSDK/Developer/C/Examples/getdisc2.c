
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

/* This is called anytime the FreeDB process that handles the connection
   with a remote freedb server steps into another status.
   Note that is called from another process !!! */
SAVEDS ASM LONG
statusFun(REG(a0) struct Hook *hook,REG(a1) ULONG status,REG(a2) APTR handle)
{
    FPrintf((BPTR)hook->h_Data," Status: %ld [%s]\n",status,FreeDBGetString(status));

    return 0;
}

/***************************************************************************/

/* This is called when multi matches are found on the remote freedb server.
   Note that is called from another process !!! */
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
    /* simple way to avoid ctrl-c*/
    signal(SIGINT,SIG_IGN);

    /* open freedb.library */
    if (FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion))
    {
        register struct FREEDBS_DiscInfo  *di;
        LONG                            err;

        /* alloc both DiscInfo/TOC */
        if (di = FreeDBAllocObject(FREEDBV_AllocObject_DiscInfoTOC,TAG_DONE))
        {
            register struct FREEDBS_TOC *toc = FREEDBM_GETTOCFROMDI(di);

            /* read the TOC */
            if (!(err = FreeDBReadTOC(FREEDBA_TOC,toc,FREEDBA_DeviceName,"CD0",TAG_DONE)))
            {
                register APTR handle;

                /* create a handle for remote connection */
                if (handle = FreeDBHandleCreateA(NULL))
                {
                    struct Hook statusHook, multiHook;
                    struct TagItem attrs[] = {FREEDBA_TOC,        0,
                                              FREEDBA_DiscInfo,   0,
                                              FREEDBA_StatusHook, 0,
                                              FREEDBA_MultiHook,  0,
                                              TAG_DONE};

                    /* init the status hook */
                    statusHook.h_Entry = (APTR)statusFun;
                    statusHook.h_Data  = (APTR)Output();

                    /* init the multi matches hook */
                    multiHook.h_Entry = (APTR)multiFun;
                    multiHook.h_Data  = (APTR)Output();

                    /* init attributes */
                    attrs[0].ti_Data = (ULONG)toc;
                    attrs[1].ti_Data = (ULONG)di;
                    attrs[2].ti_Data = (ULONG)&statusHook;
                    attrs[3].ti_Data = (ULONG)&multiHook;

                    /* ask the handle to perform a Query/Read command*/
                    if (!(err = FreeDBHandleCommandA(handle,FREEDBV_Command_QueryRead,attrs)))
                    {/* success */
                        ULONG hsignal, signals;

	                    /* get the signal of the hook*/
                        hsignal = FreeDBHandleSignal(handle);
                        signals = hsignal|SIGBREAKF_CTRL_C;

                        while (1)
                        {
                            ULONG recv;

		                    /* wait for hook event or ctrl-c */
                            recv = Wait(signals);

		                    /* if we were broken */
                            if (recv & SIGBREAKF_CTRL_C)
                            {
			                    /* abort the handle*/
                                FreeDBHandleAbort(handle);
                                break;
                            }

		                    /* if we received the handle signal we check if
		                       something really happened on the handle */
                            if ((recv & hsignal) && FreeDBHandleCheck(handle)) break;
                        }

 	                    /* wait the handle to complete its operation */
                        err = FreeDBHandleWait(handle);

	                    /* free it */
                        FreeDBHandleFree(handle);

                        if (!err)
                        {/* success WE GOT A DISC */
                            register int i;

		                    /* print it*/
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
                        } /* errore from the handle */
                        else printf("Query failure: %s\n",FreeDBGetString(err));
                    }/* the command can't be performed */
                    else printf("Handle command failure: %s\n",FreeDBGetString(err));
                } /* no handle */
                else printf("Can't create handle\n");
            }/* no TOC */
            else printf("Can't read TOC: %s\n",FreeDBGetString(err));

            /* free the DiscInfo/TOC allocated */
            FreeDBFreeObject(di);
        }/* Do DiscInfo */
        else printf("No DiscInfo\n");

        /* close freedb.library */
        CloseLibrary(FreeDBBase);
    } /* no freedb.lirbary */
    else printf("No %s %ld+\n",FreeDBName,FreeDBVersion);
}

/***************************************************************************/
