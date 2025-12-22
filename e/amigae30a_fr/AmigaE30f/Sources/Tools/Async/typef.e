/*

    typef.e                   Michael Zucchi 1993

    Une commande simple, rapide 'type' utilisant async.m

 */

MODULE 'tools/async', 'dos/dos'

PROC main()

DEF in,args:PTR TO LONG,rdargs,line[1024]:ARRAY OF CHAR

args:=[0];
IF rdargs:=ReadArgs('Name/A', args, 0)
    IF (in:=as_Open(args[0],MODE_OLDFILE,3,5120))
        WHILE (as_FGetS(in, line, 1024)) AND (CheckSignal(SIGBREAKF_CTRL_C)=0)
            PutStr(line)
        ENDWHILE
        as_Close(in)
    ENDIF
    FreeArgs(rdargs)
ENDIF

ENDPROC
