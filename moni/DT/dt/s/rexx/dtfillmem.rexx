/*** $VER DT_FillMem 1.1 (6.12.93) ***/

Options Results

Address DT.1

GETEX '?From which Address'
Calc Result
fro=X2D(Result)
GETEX '0To which Address'
Calc Result
toad=X2D(Result)
GETEX ';Contents'
Calc Result
cont=X2C(Result)

leng=toad-fro
x=leng/4
x=x+1
stri=Copies(cont,x)

SAY C2X(stri)

CALL Export(D2C(fro),stri,leng)

Exit
