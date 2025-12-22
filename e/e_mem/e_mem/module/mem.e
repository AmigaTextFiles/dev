/* 

 Extended Memory functions for E  (module version)
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

OPT MODULE


-> Signed byte peek

EXPORT PROC schar(ad)
   DEF ret
   ret:=Char(ad)
   IF ret>127 THEN ret:=ret-256
ENDPROC ret


-> Signed word peek for AmigaE mostly

EXPORT PROC sint(ad)
   DEF ret
   ret:=Int(ad)
   IF ret>32767 THEN ret:=ret-65536
ENDPROC ret


-> unsigned word peek for ECX mostly

EXPORT PROC uint(ad) IS Int(ad) AND $FFFF


-> signed 24bit peek

EXPORT PROC slng24(ad) IS Shl(sint(ad), 8) + Char(ad+2)


-> unsigned 24bit peek

EXPORT PROC ulng24(ad) IS Shl(uint(ad), 8) + Char(ad+2) 


-> peek a long with an endian flip

EXPORT PROC flong(ad) IS Shl(Char(ad+3),24)+Shl(Char(ad+2),16)+Shl(Char(ad+1),8)+Char(ad)


-> peek a signed word with an endian flip

EXPORT PROC fint(ad) IS Shl(schar(ad+1),8) + Char(ad)


-> sets memory with a specified byte  -> similar to the C version

EXPORT PROC memset(ad, chr, sz)
   DEF x
   FOR x:=0 TO sz-1
      PutChar(ad+x, chr)
   ENDFOR
ENDPROC 


-> signed 24bit peek with an endian flip

EXPORT PROC flng24(ad) IS Shl(schar(ad+2),16) + Shl(Char(ad+1),8) + Char(ad)


-> 24bit poke

EXPORT PROC putlng24(ad, num) IS CopyMem({num}+1, ad, 3)
 

-> Unsigned word peek with an endian flip

EXPORT PROC ufint(ad) IS Shl(Char(ad+1),8) + Char(ad)


-> unsigned 24bit peek with an endian flip

EXPORT PROC uflng24(ad) IS Shl(Char(ad+2),16) + Shl(Char(ad+1),8) + Char(ad)



