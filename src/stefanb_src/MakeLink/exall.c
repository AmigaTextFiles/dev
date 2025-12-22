/* an example of how to use ExAll */

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/exall.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <stdio.h>

/* normally you'ld include pragmas here */

#define BUFFSIZE 300

int
main(argc,argv)
        int argc;
        char *argv[];
{
        BPTR obj_lock;
        LONG res2,more;
        struct ExAllData *Buffer,*ead;
        struct ExAllControl *control;
        LONG rc = RETURN_ERROR;
        char pattern[256];

  /* ugly argument parsing */
  if( argc >= 2 && argc <= 3) {

        /* control MUST be allocated by AllocDosObject! */
        control=(struct ExAllControl *) AllocDosObject(DOS_EXALLCONTROL,NULL);
        Buffer=(struct ExAllData *) AllocMem(BUFFSIZE,MEMF_PUBLIC|MEMF_CLEAR);

        /* always check allocations! */
        if (!control || !Buffer)
                goto cleanup;

        if (argc == 3)
        {
                /* parse the pattern for eac_MatchString */
                if (ParsePatternNoCase(argv[2],pattern,sizeof(pattern)) == -1)
                {
                        printf("ParsePatternNoCase buffer overflow!\n");
                        goto cleanup;
                }
                control->eac_MatchString = pattern;
        }

        /* lock the directory */
        if (obj_lock = Lock(argv[1],SHARED_LOCK)) {

          control->eac_LastKey = 0;     /* paranoia */

          do { /* while more */

            more = ExAll(obj_lock,Buffer,BUFFSIZE,ED_TYPE,control);
            res2 = IoErr();
            if (!more && res2 != ERROR_NO_MORE_ENTRIES)
            {
                VPrintf("Abnormal exit, error = %ld\n",&res2);
                break;
            }

            /* remember, VPrintf wants a pointer to arguments! */
            VPrintf("Returned %ld entries:\n\n",&(control->eac_Entries));

            if (control->eac_Entries)
            {
                ead = Buffer;
                do {
                        VPrintf("%s",(LONG *) &(ead->ed_Name));
                        VPrintf(" Type %ld",&ead->ed_Type);
                        if (ead->ed_Type > 0)
                                PutStr(" (dir)\n");
                        else
                                PutStr(" (file)\n");

                        ead = ead->ed_Next;
                } while (ead);
            }

            rc = RETURN_OK;     /* success */

          } while (more);

          UnLock(obj_lock);

        } else VPrintf("Couldn't find %s\n",(LONG *) &(argv[1]));

cleanup:
        if (Buffer)  FreeMem(Buffer,BUFFSIZE);
        if (control) FreeDosObject(DOS_EXALLCONTROL,control);

        return(rc);

    } else {
      VPrintf("Usage: %s dirname [pattern]\n",(LONG *) &(argv[0]));
      return(rc);
    }
}

