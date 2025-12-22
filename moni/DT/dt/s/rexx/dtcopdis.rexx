/** $VER: CopperDisassembler 1.0 (29.11.93) **/

If ~show('l','rexxsupport.library') Then
    rexxlib=Addlib('rexxsupport.library',0,-30,0)

Address DT.1

If ~show('l','rexxsupport.library') Then Do
    Message 'You need the rexxsupport.library'
    Exit 20
End

rl=1

Options Results
Lines=10

IF ~open('console','RAW:0/100/408/'||(Lines*10)+2||'/Copper-DisAssembler/CLOSE/SCREENDTSCREEN.1','W') THEN EXIT 20

ADDRESS DT.1

DTToFRONT

CursUp=d2c(27)||'M'
CursDown=d2c(27)||'D'

counter=0
CALL WriteLN('console','***************************************')
CALL WriteLN('console','*****     COPPER-DISASSEMBLER     *****')
CALL WriteLN('console','***** (C) 1993 by Stefan Guttmann *****')
CALL WritelN('console','***************************************')
CALL WriteLN('console','*****         Please wait         *****')
CALL WriteLN('console','*****      Reading Registers      *****')
CALL WriteLN('console','***************************************')

offen=Open(dirfile,'env:DT/CopDis.regfile','read')

If offen=1 Then Do
    li=ReadLN(dirfile)                               
    IF ~(li='**REGISTERS**') Then Exit               
                                                     
    Do Forever                                       
        Register.counter=ReadLN(dirfile)             
        If Length(Register.counter)=0 Then Leave     
        counter=counter+1                            
    End                                              
    CALL Close(dirfile)                              
End                                                  

CALL WriteCH('console',d2c(27)||'c')

StartAdr='04'x

IF (rl=1) Then Do
    gfxbase=ShowList(l,'graphics.library',,a)
    Call FORBID()
    aaj=next(gfxbase,50)
    SysCL=Import(aaj,4)
    Call PERMIT()
    StartAdr=SysCL
    DeleteLabel 'SysCL'
    CreateLabel 'SysCL' C2D(aaj)
    Refresh
End

StartAdr=aaj

Call DisAs

CALL WriteCH('console',CursUp)

Do Forever
    x2=''
    xx=ReadCH('console')
    xy=c2d(xx)
    If xy=155 Then x2=ReadCH('console')
    If xy=9 Then TAB                            

    IF c2d(x2)=65 Then                          
    Do
        CALL WriteCH('console',CursUp)
        StartAdr=D2C(C2D(StartAdr)-4)
        CALL DisAsLine
    End
    IF c2d(x2)=84 Then                          
    Do
        CALL WriteCH('console',CursUp)
        StartAdr=C2D(StartAdr)-(Lines*4)
        IF (StartAdr<0) Then StartAdr=0
        StartAdr=D2C(StartAdr)
        CALL DisAs
    End

    IF c2d(x2)=83 Then                          
    Do
        CALL WriteCH('console',CursDown)
        StartAdr=D2C(C2D(StartAdr)+(Lines*4))
        CALL DisAs
    End

    IF c2d(x2)=66 Then                          
    Do
        CALL WriteCH('console',CursDown)
        StartAdr=D2C(C2D(StartAdr)+4)
        Call DisAsLine
    End

    IF xx='a' Then                              
    Do
        ADDRESS DT.1
        GetEx '?From which Startadress ?'
        sa=Result
        CALC sa
        StartAdr=X2C(Result)
        CALL DisAs
    End

    IF xx='q' Then Leave                        

    IF xx='c' THEN Do                           
        GetEx '?Enter Calcstring'
        Info Result
    End

End
DeleteLabel 'SysCL'
Refresh
Exit

DisAs:
    SA=StartAdr
    Do Forever
        IF Length(SA)>=4 Then Leave
        SA=D2C(0)||SA
    End
    Do x=1 to Lines
        xfg=Import(SA,4)
        Call MakeCommand
        SA=D2C(C2D(SA)+4)
        Do Forever
            IF Length(SA)=4 Then Leave
            SA=D2C(0)||SA
        End
        CALL WriteLN('console',tx)
    End
Return

DisAsLine:
    SA=StartAdr
    Do Forever
        IF Length(SA)>=4 Then Leave
        SA=D2C(0)||SA
    End
    xfg=IMPORT(SA,4)
    CALL MakeCommand
    SA=D2C(C2D(SA)+4)
    CALL WriteLN('console',tx)
    CALL WriteCH('console',CursUp)
Return


MakeCommand:
    lili=Left(xfg,2)
    rere=Right(xfg,2)
    bi=C2B(lili)
    b2=C2B(rere)
    tx='$'||right('00000000'||C2x(SA),8)||'- '

    /*           WAIT          */

    IF (Right(bi,1)='1'&Right(b2,1)='0') Then Do
        tx=tx||'WAIT $'
        va2=Left(lili,1)                 
        tx=tx||C2X(va2)||',$'
        va2=RIGHT(lili,1)                
        tx=tx||C2X(va2)||'             MASK: $'
        tx=tx||C2X(rere)
    End

    /*           SKIP          */

    IF (Right(bi,1)='1'&Right(b2,1)='1') Then Do
        tx=tx||'SKIP $'
        va2=LEFT(lili,1)                 
        tx=tx||C2X(va2)||',$'
        va2=Right(lili,1)                
        tx=tx||C2X(va2)
        tx=tx||C2X(va2)||'           MASK: $'
        tx=tx||C2X(rere)
    End

    /*           MOVE         */

    IF Right(bi,1)='0' Then Do
        tx=tx||'MOVE $'
        val=C2D(lili)
        xxy=val/2                        
        If (xxy<counter+1) Then tx=tx||C2X(rere)||','||Register.xxy
        Else tx=tx||C2X(rere)||',$'||C2X(lili)
    END
Return
