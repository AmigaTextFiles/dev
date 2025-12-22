/*

    histogram.e                   Michael Zucchi 1993

    Donne un nombre de population pour chaque octets d'un fichier.

 */

MODULE 'tools/async', 'dos/dos'

DEF counts[300]:ARRAY OF LONG;

PROC main()

DEF in,args:PTR TO LONG,rdargs,start:PTR TO CHAR,size,i;

args:=[0];
IF rdargs:=ReadArgs('Name/A', args, 0)
    IF (in:=as_Open(args[0],MODE_OLDFILE,3,5120))
        REPEAT
            start,size := as_NextBuffer(in);
            IF start>0
                FOR i:=0 TO size-1
                    counts[start[i]]:=counts[start[i]]+1;
                ENDFOR
            ENDIF
        UNTIL start<=0
        as_Close(in)
        FOR i:=0 TO 255
            WriteF('$\h[02]: \d\n', i, counts[i]);
        ENDFOR
    ENDIF
    FreeArgs(rdargs)
ENDIF

ENDPROC
