->By Ian Chapman
->Parses the toolsdaemon Menu File.
->I originally intended to write a replacement toolsdaemon prefs prog
->Note, this program opens a huge window in excess of 1000x760
->Either run in a larger screen mode or alter the window size.
->NB There is no checking to see whether all the text will fit on the window, so
->it may crash if it writes ourside of the window rastport

MODULE  'DOS/DOS',
        'intuition/intuition'


PROC main()
DEF fh,line[200]:STRING,cola,colb,colc,win,choppedline[200]:STRING,pos

cola:=30
colb:=30
colc:=30



IF (fh:=Open('S:toolsdaemon.menu',MODE_OLDFILE))<>NIL
    IF (win:=OpenW(0,0,1000,760,IDCMP_CLOSEWINDOW,WFLG_DRAGBAR,'ToolsDaemon Inserter',NIL,1,NIL))<>NIL
        Colour(1)
        TextF(30,cola,'MENU NAMES')
        TextF(260,colb,'PROGRAM NAMES')
        TextF(480,colc,'PROGRAM PATH')
        REPEAT
            Fgets(fh,line,ALL)
            StrCopy(line,line,(StrLen(line)-1))

            IF (pos:=InStr(line,'TITLE',0))>-1
                StrCopy(line,MidStr(line,line,pos+6,ALL),ALL)
                cola:=cola+10
                TextF(30,cola,line)
            ENDIF

            IF (pos:=InStr(line,'SUB',0))>-1
                StrCopy(line,MidStr(line,line,pos+4,ALL),ALL)
                colb:=colb+10
                TextF(260,colb,line)
            ENDIF

            IF (pos:=InStr(line,'(WB)',0))>-1
                StrCopy(line,MidStr(line,line,pos+5,ALL),ALL)
                colc:=colc+10
                TextF(480,colc,line)
            ENDIF

            IF (pos:=InStr(line,'(CLI)',0))>-1
                StrCopy(line,MidStr(line,line,pos+6,ALL),ALL)
                colc:=colc+10
                TextF(480,colc,line)
            ENDIF

        UNTIL InStr(line,'END',0)=0

        Delay(500)

        CloseW(win)

    ELSE
        PrintF('Unable to open window!\n')
    ENDIF

    Close(fh)

ELSE
    PrintF('Unable to open S:toolsdaemon.menu!\n')
ENDIF

ENDPROC


