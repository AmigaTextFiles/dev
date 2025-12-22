/* Info2Guide.REXX

; $VER: Info2Guide.REXX 1.1 ©1993 by Alessandro Ponzio (22.12.93)

 */

Parse Arg Nome .

Say 'RAM:Info2Guide.REXX 1.0 - by Alessandro Ponzio'||D2C(10)

If Nome='NOME'
   Then Exit

Open(STDERR,'*','Read')

FileIn='gcc:info/'||Nome||'.info'
/*FileIn='RAM:'||Nome||'.info'
*/Say 'Processing file '||FileIn||'...'||D2C(10)
Address Command 'List NOHEAD '||FileIn

If ~Open(In,FileIn,'Read')
   Then Do
          WriteLn(STDERR,'+++ Info2Guide.REXX : Can''t reach file')
          Exit
        End

FileOut='output:'||Nome||'.Guide'
/*FileOut='RAM:'||Nome||'.Guide'
*/If ~Open(Out,FileOut,'Write')
   Then CleanExit('Can''t reach file')

WriteLn(Out,'@DataBase '||Nome)
WriteLn(Out,'@Master '||Nome)
WriteLn(Out,'@(C) translation from Makeinfo by Info2Guide.REXX © 1993 A.Ponzio')
WriteLn(Out,'##')

BufIn=ReadLn(In)
Do While Pos(BufIn,'Indirect:')=0
   WriteCh(STDOUT,'.')
   BufIn=ReadLn(In)
   If EoF(In)
      Then CleanExit('Can''t identify file (wrong file?)')
End
WriteCh(STDOUT,D2C(10)||D2C(10)||'Files Index found : ')

n=1
BufIn=ReadLn(In)
Do While Pos(D2C(31),BufIn)=0
   n1=Pos('-',BufIn)
   If n=0
      Then CleanExit('Can''t identify file (wrong file?)')

   n2=Pos(':',BufIn)
   If n=0
      Then CleanExit('Can''t identify file (wrong file?)')

   n=SubStr(BufIn,n1+1,n2-n1-1)
   BufIn=ReadLn(In)
End
WriteLn(STDOUT,n||' items detected.')

BufIn=ReadLn(In)
If Pos('Tag Table:',BufIn)=0
   Then CleanExit('Can''t identify file (wrong file?)')

WriteLn(Out,'@Node Main '||D2C(34)||Nome||D2C(34)||D2C(10))

WriteLn(STDOUT,D2C(10)||'   Building Main Node')
BufIn=ReadLn(In)
Do While BufIn~=D2C(31)
   n1=Pos('Node: ',BufIn)
   If n1~=0
      Then Do
             If n1~=1
                Then WriteCh(Out,SubStr(BufIn,1,n1))
             BufIn=Strip(SubStr(BufIn,n1+5),'Leading')
             n2=Pos(D2C(127),BufIn)
             txt=SubStr(BufIn,1,n2-1)
             WriteCh(Out,' @{'||D2C(34)||' '||txt||' '||D2C(34)||' Link ')
             WriteLn(Out,D2C(34)||txt||D2C(34)||'}')
             WriteCh(STDOUT,'.')
           End
      Else WriteLn(Out,BufIn)
   BufIn=ReadLn(In)
End

WriteCh(STDOUT,D2C(10))
WriteLn(Out,'@EndNode '||D2C(34)||'Main'||D2C(34))

BufIn=ReadLn(In)
If BufIn~='End Tag Table'
   Then WriteLn(STDERR,'+++ Info2Guide.REXX : Minor problem in translation')

Close(In)

cnt=1
Do While cnt~=n+1
   FileIn='gcc:info/'||Nome||'.info-'||cnt
/*   FileIn='RAM:'||Nome||'.info-'||cnt
*/   WriteLn(STDOUT,D2C(10)||'Processing file '||FileIn||'...'||D2C(10))
   Address Command 'List NOHEAD '||FileIn
   If ~Open(In,FileIn,'Read')
      Then CleanExit('Can''t reach file number '||cnt)

   BufIn=ReadLn(In)
   Do While Pos(BufIn,D2C(31))=0
      WriteCh(STDOUT,'.')
      BufIn=ReadLn(In)
      If EoF(In)
         Then CleanExit('Can''t identify file (wrong file?)')
   End

   WriteLn(STDOUT,D2C(10))

   BufIn=ReadLn(In)

   Do While ~Eof(In)

      n1=Pos('Node:',BufIn)
      If n1=0
         Then CleanExit('Parser Fatal Error : Can''t identify file (wrong file?)')
      BufIn=SubStr(BufIn,n1+5)
      txt=D2C(34)||Strip(SubStr(BufIn,1,Pos(',',BufIn)-1),'Leading')||D2C(34)
      WriteCh(STDOUT,'   Node '||txt||' detected : processing ...')
      WriteLn(Out,D2C(10)||'@Node '||txt||' '||txt)

      n1=Pos('Next:',BufIn)
      If n1~=0
         Then Do
                BufIn=SubStr(BufIn,n1+5)
                txt=Strip(SubStr(BufIn,1,Pos(',',BufIn)-1),'Leading')
                If txt='(DIR)'
                   Then txt='Main'
                WriteLn(Out,'@Next '||D2C(34)||txt||D2C(34)||' '||D2C(34)||txt||D2C(34))
              End
      n1=Pos('Prev:',BufIn)
      If n1~=0
         Then Do
                BufIn=SubStr(BufIn,n1+5)
                txt=Strip(SubStr(BufIn,1,Pos(',',BufIn)-1),'Leading')
                If txt='(DIR)'
                   Then txt='Main'
                WriteLn(Out,'@Prev '||D2C(34)||txt||D2C(34)||' '||D2C(34)||txt||D2C(34))
              End
      n1=Pos('Up:',BufIn)
      If n1~=0
         Then Do
                txt=Strip(SubStr(BufIn,n1+3),'Leading')
                If txt='(DIR)'
                   Then txt='Main'
                WriteLn(Out,'@Toc '||D2C(34)||txt||D2C(34)||' '||D2C(34)||txt||D2C(34))
              End
         Else WriteLn(Out,'@Toc Main')
      BufIn=ReadLn(In)
      If EoF(In)
         Then BufIn=D2C(31)
      If BufIn=''
         Then BufIn=D2C(31)

      While Pos(D2C(31),BufIn)~=0
            BufIn=ReadLn(In)

      Do While Pos(D2C(31),BufIn)=0
         If Pos('* Menu:',BufIn)
            Then Md='Menu'
         If Pos('::',BufIn)~=0
            Then Do
                   txt=SubStr(BufIn,1,Pos('::',BufIn)-1)
                   n1=Pos('* ',txt)
                   If n1=0
                      Then n1=WordIndex(txt,1)-1
                      Else n1=n1+1
                   WriteCh(Out,SubStr(txt,1,n1))
                   txt=SubStr(txt,n1+1)
                   n2=Pos('*note ',txt)
                   If n2~=0
                      Then Do
                             WriteCh(Out,SubStr(BufIn,1,n2-1))
                             txt=SubStr(txt,n2+6)
                           End
                   txt=D2C(34)||txt||D2C(34)
                   WriteCh(Out,'@{'||txt||' Link '||txt||'} ')
                   BufIn=SubStr(BufIn,Pos('::',BufIn)+2)
                   WriteLn(Out,BufIn)
                 End
            Else WriteLn(Out,BufIn)
         BufIn=ReadLn(In)
         If Pos(D2C(31),BufIn)~=0
            Then Do
                   BufIn=ReadLn(In)
                   If Pos('Node:',BufIn)~=0
                      Then BufIn=D2C(31)||BufIn
                 End
         If EoF(In)
            Then BufIn=D2C(31)
      End
      WriteLn(Out,'@EndNode'||D2C(10))
      WriteLn(STDOUT,' done.')
   End
   Close(In)
   cnt=cnt+1
End
Close(Out)

Say D2C(10)||'Info2Guide.REXX : successfully done.'

Return 0

CleanExit: Procedure
  Parse Arg Mess
  WriteCh(STDERR,'+++ Info2Guide.REXX : ')
  If Mess~='MESS'
     Then WriteLn(STDERR,Mess)
     Else WriteLn(STDERR,' error has occurred')
  Close(In)
  Close(Out)
  Exit
Return 0
