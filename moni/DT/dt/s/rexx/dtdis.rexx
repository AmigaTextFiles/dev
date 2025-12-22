/*** $VER DT_Disassamble 0.1 (27.10.93) ***/

Options Results

Signal ON BREAK_C
Signal ON Error

IF ~open('console','con:0/0/640/100/DisAssemble/CLOSE/SCREENDTSCREEN.1','W') THEN EXIT 20

/*      Get Startadress, Endadress, Filename   */

Address DT.1
DTTOFRONT
GetEx '?From which Startadress ?'
SA=Result
GetEx '9To which Endadress ?'
EA=Result
FileReq 'Select a File to Save...'
filename=result
IF exists(FileName) then Address Command 'Delete 'filename' quiet'

Calc SA
StartAdr=X2D(Result)

Calc EA
EndAdr=X2D(Result)

/*      Welcome-Mesage     */

CALL WRITELN('console','DT-Disassembler               © 1993 by Stefan Guttmann')
CALL WriteLN('console','')
Call WriteCH('console','Pass 1  ')

/* Pass1:

    Disassemble to Temp-File
    Format:          0-9      'l' LineAdress ':        ' Disassembled Line     */

offen=Open(dirfile,'t:DT_Dis_Temp','write')

Curr=StartAdr
SetDisAdr StartAdr
GetDisAdr
CU=Result

x=0
Do Forever
DisAssemble
tx=Right('         l'||CU,9)||':'
text=tx||D2C(9)||Result
CALL WRITELN(dirfile,text)
GetDisAdr
CU=Result
Curr=X2D(CU)
IF Curr>EndAdr Then Leave
x=x+1
If x=100 Then Do
    x=0
    CALL WriteCH('console','.')
End
End
CALL WriteLN('console','')

/* Pass2:

    Search for Labels (adresses between Startadr & Endadr) */

call Close(dirfile)
Call WriteCH('console','Pass 2  ')
x=0
offen=Open(dirfile,'t:DT_Dis_Temp','read')
counte=0
Count2=0
Do Forever
    counte=counte+1
    line2=ReadLN(dirfile)
    If Length(line2)=0 Then Leave
    line=Right(line2,Length(line2)-10)
    ind=Index(line,'$')
    IF ind>0 Then Do
        aa=Right(line,Length(line)-ind)
        aa=Left(aa,8)
        bb=Index(aa,',')
        If bb>0 Then aa=Left(aa,bb-1)
        bb=Index(aa,'.')
        If bb>0 Then aa=Left(aa,bb-1)
        bb=Index(aa,'(')
        If bb>0 Then aa=Left(aa,bb-1)
        kwa=X2D(aa)
        If kwa>StartAdr-1 Then Do
            If kwa<EndAdr+1 Then Do
                Count2=Count2+1
                linenr.Count2=Counte
                Adr.Count2=kwa
            End
        End
    End
    x=x+1
    If x=100 Then Do
        x=0
        CALL WriteCH('console','.')
    End
End
Call Close(dirfile)
Countr=Count2

/* Pass3:

    Write to Destination File

    Insert Labels                                  */

Call WriteLN('console','')
Call WriteCH('console','Pass 3  ')

offen=Open(dirfile,'t:DT_Dis_Temp','read')
offen=Open(dirfile2,filename,'Write')

Do i=1 To Countr
    kkx=kkx||linenr.i||' '
    kka=kka||adr.i||' '
End
counte=0
Count2=0
        CALL WriteCH('console','.')
Do Forever
    counte=counte+1
    line2=ReadLN(dirfile)
    If Length(line2)=0 Then Leave
    line=Right(line2,Length(line2)-10)
    adrx=Left(line2,9)
    adrx=Right(adrx,8)

    adry=X2D(adrx)
    
    linex=line

    inx=Index(linex,'$')
    ina=Index(kkx,Counte)
    inb=Index(kka,adry)
    If ((ina>0)|(inb>0)) Then Do
        Do t=1 to Countr
            If Counte=linenr.t Then Do
                xx='$'||D2X(Adr.t)
                ind=Index(Upper(line),xx)
                linex=left(line,ind-1)||'l'||right(line,Length(line)-ind)
            End
            If adry=Adr.t Then Do
                If ~(left(linex,1)='l') Then do
                    ax='l'||D2X(adr.t)||':'
                    linex=ax||linex
                End
            End
        End
    End
    If ~(Left(linex,1)='l') Then Do
        linex=D2C(9)||linex
    End

    CALL WRITELN(dirfile2,linex)
    x=x+1
    If x=100 Then Do
        x=0
        CALL WriteCH('console','.')
    End
End


Call Close(dirfile)

Call WriteLN('console','Finished.')
Address Command 'Delete t:DT_Dis_Temp quiet'
Exit

Break_C:
    Call WriteLN('console','Error: Disassemble interrupted by User')
    Exit
Return

Error:
    Select
        When RC=9 Then Do 
            Call WriteLN('console','Error: Cancel selected')
	    ADDRESS COMMAND "WAIT 2";
	    Exit
        End
        Otherwise
            Call WriteLN('console','Error: Undefined Error: 'RC)
	    ADDRESS COMMAND "WAIT 2";
	    Exit

    End
Return
