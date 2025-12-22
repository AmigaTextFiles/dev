/* 

   A test of the "mem.m" extended memory functions.
   (C) 2015  Lorence Lombardo.
 
   NB:  sint and uint will give you the same results on AmigaE & ECX
   
*/


MODULE 'mem'


PROC main()
   DEF num, buf[256]:STRING
   buf[0]:=255 ; buf[1]:=255 ; buf[2]:=255
   num:=Char(buf)
   WriteF('\d\n',num)
   num:=schar(buf)
   WriteF('\d\n',num)
   num:=uint(buf)
   WriteF('\d\n',num)
   num:=sint(buf)
   WriteF('\d\n',num)
   num:=ulng24(buf)
   WriteF('\d\n',num)
   num:=slng24(buf)
   WriteF('\d\n',num)
   StrCopy(buf,'ABCD')
   WriteF('\s\n',buf)
   num:=flong(buf)
   PutLong(buf,num)
   WriteF('\s\n',buf)
   num:=fint(buf)
   PutInt(buf,num)
   WriteF('\s\n',buf)
   StrCopy(buf,'123456789012')
   memset(buf, Char('I'), StrLen(buf) )
   WriteF('\s\n',buf)
   StrCopy(buf,'123')
   num:=flng24(buf)
   CopyMem({num}+1, buf, 3)
   WriteF('\s\n',buf)
   putlng24(buf, 16777215)
   WriteF('\s\n',buf)
   num:=40000                      -> that would be too much for a signed word
   WriteF('\d\n', sint({num}+2) )  -> +2 coz we r in a 32 bit long
   num:=fint({num}+2)              -> here make it intel
   WriteF('\d\n', ufint({num}+2) ) -> here we retrieve it as a motorola unsigned word 
   ->
   num:=9388607                      -> that would be too much for a signed 24 bit
   WriteF('\d\n', slng24({num}+1) )  -> +1 coz we r in a 32 bit long
   num:=flng24({num}+1)              -> here make it intel
   WriteF('\d\n', uflng24({num}+1) ) -> here we retrieve it as a motorola unsigned 24 bit
ENDPROC



