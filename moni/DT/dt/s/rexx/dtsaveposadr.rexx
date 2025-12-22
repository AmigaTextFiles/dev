/*** $VER DT_SavePos 1.2 (29.11.93) ***/

Signal ON Error

Options Results

Address DT.1

GETEX '?Which adress to save'

adr=X2D(Result)

Do t=0 to 100
    xx='SEG'||t
    xx2='END'||t
    Calc xx
    seg=X2D(Result)
    Calc xx2
    end=X2D(Result)
    If (adr>seg) Then If (adr<end) Then Leave
End

adr=adr-seg

LastName
LN=Result

offen=Open(dirfile,'EnvArc:DTSavePos','write')
Call WriteLN(dirfile,D2X(adr))
Call WriteLN(dirfile,D2X(seg))
Call WriteLN(dirfile,LN)
Call WriteLN(dirfile,xx)
call Close(dirfile)

Exit

Error:
    SAY 'Error: No Segment found !'
    Exit
