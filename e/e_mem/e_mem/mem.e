/* 

 Extended Memory functions for E
 (C) 2015  Lorence Lombardo.

 Date commenced:-   25-Oct-2015
 Last modified:-    28-Oct-2015

 Functions List:-

 schar
 sint
 uint
 slng24
 flong
 fint
 memset
 flng24
 putlng24
 ulng24
 ufint
 uflng24

 NB:  sint and uint will give you the same results on AmigaE & ECX
   

*/


-> Signed byte peek

PROC schar(ad)
   DEF ret
   ret:=Char(ad)
   IF ret>127 THEN ret:=ret-256
ENDPROC ret


-> Signed word peek for AmigaE mostly

PROC sint(ad)
   DEF ret
   ret:=Int(ad)
   IF ret>32767 THEN ret:=ret-65536
ENDPROC ret


-> unsigned word peek for ECX mostly

PROC uint(ad) IS Int(ad) AND $FFFF


-> signed 24bit peek

PROC slng24(ad) IS Shl(sint(ad), 8) + Char(ad+2)


-> unsigned 24bit peek

PROC ulng24(ad) IS Shl(uint(ad), 8) + Char(ad+2) 


-> peek a long with an endian flip

PROC flong(ad) IS Shl(Char(ad+3),24)+Shl(Char(ad+2),16)+Shl(Char(ad+1),8)+Char(ad)


-> peek a signed word with an endian flip

PROC fint(ad) IS Shl(schar(ad+1),8) + Char(ad)


-> sets memory with a specified byte  -> similar to the C version

PROC memset(ad, chr, sz)
   DEF x
   FOR x:=0 TO sz-1
      PutChar(ad+x, chr)
   ENDFOR
ENDPROC 


-> signed 24bit peek with an endian flip

PROC flng24(ad) IS Shl(schar(ad+2),16) + Shl(Char(ad+1),8) + Char(ad)


-> 24bit poke

PROC putlng24(ad, num) IS CopyMem({num}+1, ad, 3)
 

-> Unsigned word peek with an endian flip

PROC ufint(ad) IS Shl(Char(ad+1),8) + Char(ad)


-> unsigned 24bit peek with an endian flip

PROC uflng24(ad) IS Shl(Char(ad+2),16) + Shl(Char(ad+1),8) + Char(ad)


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



