
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

SAVEDS ASM LONG
statusFun(REG(a0) struct Hook *hook,REG(a1) ULONG status,REG(a2) APTR handle)
{
    FPrintf((BPTR)hook->h_Data," Status: %ld [%s]\n",status,FreeDBGetString(status));

    return 0;
}

/***************************************************************************/

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
    signal(SIGINT,SIG_IGN);

    if (FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion))
    {
        register struct FREEDBS_DiscInfo  *di;
        LONG                            err;

        if (di = FreeDBAllocObject(FREEDBV_AllocObject_DiscInfoTOC,TAG_DONE))
        {
            register struct FREEDBS_TOC *toc = FREEDBM_GETTOCFROMDI(di);

            if (!(err = FreeDBReadTOC(FREEDBA_TOC,toc,FREEDBA_DeviceName,"CD0",TAG_DONE)))
            {
                register APTR handle;

                if (handle = FreeDBHandleCreateA(NULL))
                {
                    struct Hook statusHook, multiHook;

                    statusHook.h_Entry = (APTR)statusFun;
                    statusHook.h_Data  = (APTR)Output();

                    multiHook.h_Entry = (APTR)multiFun;
                    multiHook.h_Data  = (APTR)Output();

                    if (!(err = handleCommand(handle,FREEDBV_Command_Query,
                            FREEDBA_TOC,        toc,
                            FREEDBA_DiscInfo,   di,
                            FREEDBA_StatusHook, &statusHook,
                            FREEDBA_MultiHook,  &multiHook,
                            TAG_DONE)))

                    {
                        ULONG hsignal, signals;

                        hsignal = FreeDBHandleSignal(handle);
                        signals = hsignal|SIGBREAKF_CTRL_C;

                        while (1)
                        {
                            ULONG recv;

                            recv = Wait(signals);

                            if (recv & SIGBREAKF_CTRL_C)
                            {
                                FreeDBHandleAbort(handle);
                                break;
                            }

                            if ((recv & hsignal) && FreeDBHandleCheck(handle)) break;
                        }

                        err = FreeDBHandleWait(handle);
                        FreeDBHandleFree(handle);

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
                        else printf("Query failure: %s\n",FreeDBGetString(err));
                    }
                    else printf("Handle command failure: %s\n",FreeDBGetString(err));
                }
                else printf("Can't create handle\n");
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
