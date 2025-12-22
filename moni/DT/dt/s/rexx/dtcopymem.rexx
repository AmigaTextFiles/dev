/*** $VER DT_CopyMem 1.1 (6.12.93) ***/

Options Results

Address DT.1

GETEX '?From which Address'
Calc Result
fro=X2D(Result)
GETEX '0Length to copy'
Calc Result
leng=X2D(Result)
GETEX ';To which Address'
Calc Result
toad=X2D(Result)

xxy=Import(D2C(fro),leng)

CALL Export(D2C(toad),xxy,leng)

Exit
