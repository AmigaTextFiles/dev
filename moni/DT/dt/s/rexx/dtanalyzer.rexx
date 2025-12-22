/*** $VER DT_Demo 0.2 (30.11.93) ***/

Signal ON Error

Options Results

Address DT.1

UnLoad

FileReq 'Select a File to analyze'

IF ~open('console','RAW:0/0/408/102/DTAnalyzer/CLOSE/SCREENDTSCREEN.1','W') THEN EXIT 20

LOAD Result

t=0

Do Forever
    xx='SEG'||t
    xx2='END'||t
    SAY xx
    SAY xx2
    Calc xx
    seg.t=X2D(Result)
    Calc xx2
    end.t=X2D(Result)
    t=t+1
End

Error:

If RC=9 Then Exit

leng=0

CALL WriteLN('console','Number of Segments: '||t)

Do x=0 to t-1
    CALL WriteLN('console','Start of Segment '||x||': $'||D2X(seg.x))
    CALL WriteLN('console','End   of Segment '||x||': $'||D2X(end.x))
    leng=leng+(end.x-seg.x)
End
    CALL WriteLN('console','')
    CALL WriteLN('console','Length of File: $'||D2X(leng))
    CALL WriteLN('console','>>Press key to continue<<')



CALL Readch('console')


Exit

