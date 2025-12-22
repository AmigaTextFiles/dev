
#include <proto/exec.h>
#include <proto/freedb.h>
#include <dos/dos.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/***********************************************************************/

int main(int argc,char **argv)
{
    struct Library      *FreeDBBase;
    struct FREEDBS_TOC    *toc;
    LONG                err;
    LONG                unit;

    /* simple way to avoid ctrl-c */
    signal(SIGINT,SIG_IGN);

    /* open freedb.library */
    if (!(FreeDBBase = OpenLibrary(FreeDBName,FreeDBVersion)))
    {
        printf("No %s %ld+\n",FreeDBName,FreeDBVersion);
        return 20;
    }

    /* get unit */
    unit = atoi(argv[2]);

    /* read the TOC */
    if (!(err = FreeDBReadTOC(FREEDBA_TOCPtr,&toc,FREEDBA_Device,argv[1],FREEDBA_Unit,unit,TAG_DONE)))
    {
        register int i;

        /* print it */
        printf("      DiscID: %08lx\n",toc->discID);
        printf("  NumTracks : %ld\n",toc->numTracks);
        printf(" FirstTrack : %ld\n",toc->firstTrack);
        printf("   LastTrack: %ld\n",toc->lastTrack);
        printf("StartAddress: %ld\n",toc->startAddress);
        printf("  EndAddress: %ld\n",toc->endAddress);
        printf("      Frames: %ld\n",toc->frames);
        printf("         Min: %ld\n",toc->min);
        printf("         Sec: %ld\n",toc->sec);
        printf("       Frame: %ld\n",toc->frame);
        printf("\n");

        for (i = 0; i<toc->numTracks; i++)
        {
            if (SetSignal(0,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
                break;

            printf("     Track: %ld\n",toc->tracks[i].track);
            printf("     Audio: %ld\n",toc->tracks[i].audio);
            printf(" StartAddr: %ld\n",toc->tracks[i].startAddr);
            printf("   EndAddr: %ld\n",toc->tracks[i].endAddr);
            printf("    Frames: %ld\n",toc->tracks[i].frames);
            printf("  StartMin: %ld\n",toc->tracks[i].startMin);
            printf("  StartSec: %ld\n",toc->tracks[i].startSec);
            printf("StartFrame: %ld\n",toc->tracks[i].startFrame);
            printf("    EndMin: %ld\n",toc->tracks[i].endMin);
            printf("    EndSec: %ld\n",toc->tracks[i].endSec);
            printf("  EndFrame: %ld\n",toc->tracks[i].endFrame);
            printf("       Min: %ld\n",toc->tracks[i].min);
            printf("       Sec: %ld\n",toc->tracks[i].sec);
            printf("     Frame: %ld\n",toc->tracks[i].frame);
            printf("       ADR: %ld\n",toc->tracks[i].ADR);
            printf("  CopyPerm: %ld\n",toc->tracks[i].copyPerm);
            printf("    PreEmp: %ld\n",toc->tracks[i].preEmp);
            printf(" 4Channels: %ld\n",toc->tracks[i].fourChannels);
            printf("\n");
        }

        /* free the TOC */
        FreeDBFreeObject(toc);

    }
    else printf("Can't read TOC: %s\n",FreeDBGetString(err));

    CloseLibrary(FreeDBBase);
}

/***********************************************************************/
