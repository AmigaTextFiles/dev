
' Extended Memory functions for ACE
' (C) 2014  Lorence Lombardo.

' Date commenced:-   11-Apr-2014

' Functions List:-

' SPEEK
' UPEEKW
' PEEK24
' FPEEKL
' FPEEKW
' CopyMemB
' memset
' FPEEK24
' POKE24
' UPEEK24
' UFPEEKW
' UFPEEK24



' Signed byte peek

SUB SHORTINT SPEEK(ADDRESS addy) EXTERNAL
   byt% = PEEK(addy)
   if byt%>127 then byt%=byt%-256
   SPEEK=byt%
END SUB


' Unsigned word peek

SUB LONGINT UPEEKW(ADDRESS addy) EXTERNAL
   UPEEKW = PEEKW(addy) AND &HFFFF 
END SUB


' signed 24bit peek

SUB LONGINT PEEK24(ADDRESS addy) EXTERNAL
   PEEK24 = (PEEKW(addy) * 256) + PEEK(addy+2)
END SUB


' peek a long with an endian flip

SUB LONGINT FPEEKL(ADDRESS addy) EXTERNAL
   SHORTINT b1,b2,b3,b4
   ADDRESS bfady
   buf&=0
   b1=PEEK(addy)
   b2=PEEK(addy+1)
   b3=PEEK(addy+2)
   b4=PEEK(addy+3)
   bfady = @buf&
   POKE bfady, b4
   POKE bfady+1, b3
   POKE bfady+2, b2
   POKE bfady+3, b1
   FPEEKL = buf& 
END SUB


' peek a signed word with an endian flip

SUB SHORTINT FPEEKW(ADDRESS addy) EXTERNAL
   FPEEKW = (SPEEK(addy+1) * 256) + PEEK(addy)
END SUB


' CopyMem byte aligned

SUB CopyMemB(ADDRESS ad1, ADDRESS ad2, LONGINT sz) EXTERNAL
   for x&=0 to sz-1
      b%=PEEK(ad1+x&)
      POKE ad2+x&,b%
   next x&
END SUB


' sets memory with a specified byte  ' similar to the C version

SUB memset(ADDRESS ady, char%, LONGINT sz) EXTERNAL
   for x&=0 to sz-1
      POKE ady+x&, char%
   next x&
END SUB


' signed 24bit peek with an endian flip

SUB LONGINT FPEEK24(ADDRESS addy) EXTERNAL
   SHORTINT b1,b2
   b1=PEEK(addy)
   b2=PEEK(addy+1)
   buf&=SPEEK(addy+2) * 256 * 256
   POKE @buf&+2, b2
   POKE @buf&+3, b1
   FPEEK24 = buf& 
END SUB


' 24bit poke

SUB POKE24(ADDRESS ady, LONGINT num) EXTERNAL
   CopyMemB(@num+1, ady, 3)
END SUB


' unsigned 24bit peek

SUB LONGINT UPEEK24(ADDRESS addy) EXTERNAL
   num&=0
   CopyMemB(addy, @num&+1, 3)
   UPEEK24 = num&
END SUB


' Unsigned word peek with an endian flip

SUB LONGINT UFPEEKW(ADDRESS addy) EXTERNAL
   SHORTINT b1,b2 
   ADDRESS bfady
   buf&=0
   b1=PEEK(addy)
   b2=PEEK(addy+1)
   bfady = @buf&
   POKE bfady+2, b2
   POKE bfady+3, b1
   UFPEEKW = buf& 
END SUB


' unsigned 24bit peek with an endian flip

SUB LONGINT UFPEEK24(ADDRESS addy) EXTERNAL
   SHORTINT b1,b2,b3
   b1=PEEK(addy)
   b2=PEEK(addy+1)
   b3=PEEK(addy+2)
   buf&=0
   POKE @buf&+1, b3
   POKE @buf&+2, b2
   POKE @buf&+3, b1
   UFPEEK24 = buf&
END SUB


