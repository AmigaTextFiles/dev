/*
            Side-Faces
            ----------

    Zeigt Dir die wunderbare Welt der kleinen Gesichtern in unseren Texten.

    (1993) Daniel van Gerpen

*/

DEF i,j,k,c=0

PROC main()
 FOR i:=1 TO 5
    FOR j:=1 TO 3
          FOR k:=1 TO 14
           draw()
          ENDFOR
    ENDFOR
 ENDFOR
ENDPROC


PROC draw()
   SELECT i
    CASE 1;   WriteF(':')
    CASE 2;   WriteF('8')
    CASE 3;   WriteF(';')
    CASE 4;   WriteF('|')
    CASE 5;   WriteF('ß')

   ENDSELECT
   SELECT j
    CASE 1;   WriteF('-')
    CASE 2;   WriteF('')
    CASE 3;   WriteF('^')
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
   ENDSELECT
 IF c++>3
    WriteF('\n\n')
    c:=0
 ENDIF
ENDPROC

