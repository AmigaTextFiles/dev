DEF i,j,k,l,c=0

PROC main()
FOR l:=1 TO 5
 FOR i:=1 TO 6
    FOR j:=1 TO 5
          FOR k:=1 TO 20
           draw()
          ENDFOR
    ENDFOR
 ENDFOR
ENDFOR
ENDPROC


PROC draw()
   SELECT l
    CASE 1;   WriteF('{')
    CASE 2;   WriteF('}')
    CASE 3;   WriteF('8')
    CASE 4;   WriteF('(')
    CASE 5;   WriteF('')
   ENDSELECT

   SELECT i
    CASE 1;   WriteF(':')
    CASE 2;   WriteF('8')
    CASE 3;   WriteF(';')
    CASE 4;   WriteF('|')
    CASE 5;   WriteF('ß')
    CASE 6;   WriteF('%')

   ENDSELECT
   SELECT j
    CASE 1;   WriteF('-')
    CASE 2;   WriteF('')
    CASE 3;   WriteF('^')
    CASE 4;   WriteF('~')
    CASE 5;   WriteF('*')   

   ENDSELECT
   SELECT k
    CASE 1;   WriteF(')  ')
    CASE 2;   WriteF('(  ')
    CASE 3;   WriteF('|  ')
    CASE 4;   WriteF('>  ')
    CASE 5;   WriteF('<  ')
    CASE 6;   WriteF('}  ')
    CASE 7;   WriteF('{  ')
    CASE 8;   WriteF(']  ')
    CASE 9;   WriteF('[  ')
    CASE 10;  WriteF('+  ')
    CASE 11;  WriteF('*  ')
    CASE 12;  WriteF('X  ')
    CASE 13;  WriteF('C  ')
    CASE 14;  WriteF('7  ')
    CASE 15;  WriteF('O  ')
    CASE 16;  WriteF('X  ')
    CASE 17;  WriteF('w  ')
    CASE 18;  WriteF('W  ')
    CASE 19;  WriteF('E  ')
    CASE 20;  WriteF('F  ')

ENDSELECT
 IF c++>10
    WriteF('\n\n')
    c:=0
 ENDIF
ENDPROC

