
' Extended String functions lib for ACE
' (C) 2014  Lorence Lombardo.

' Date commenced:-   5-May-2014
' Last modified:-    7-May-2014

' Functions List:-

' Replace$
' StripLead$
' StripTrail$
' LSet$
' RSet$
' Center$
' Rrem$
' Lrem$
' nstr$
' flip$
' InstrNC
' srepNC$


' replaces occurrences of find$ with rep$ in src$

SUB Replace$(src$, find$, rep$) EXTERNAL
   p%=1
   flen%=Len(find$)
   rlen%=Len(rep$)
   REPEAT
      x%=Instr(p%,src$,find$)
      if x%>0 then
         src$=Left$(src$,x%-1)+rep$+Mid$(src$,x%+flen%)
         p%=x%+rlen%
      end if
   UNTIL x%=0
   Replace$ = src$
END SUB


' removes all leading occurrences of the ASCII char% number in a$ 

SUB StripLead$(a$, char%) EXTERNAL
   s$=CHR$(char%)
   WHILE LEFT$(a$,1)=s$
      a$=MID$(a$,2)
   WEND
   StripLead$ = a$
END SUB


' removes all trailing occurrences of the ASCII char% number in a$

SUB StripTrail$(a$, char%) EXTERNAL
   s$=CHR$(char%) 
   alen%=Len(a$)
   WHILE RIGHT$(a$,1)=s$
      alen%=alen%-1
      a$=Left$(a$, alen%)
   WEND
   StripTrail$ = a$
END SUB


' the right side of a$ is space padded or truncated to the length of chars%

SUB LSet$(a$, chars%) EXTERNAL
   alen%=Len(a$)
   if alen%>chars% then
      a$=Left$(a$, chars%)   
   else
      a$=a$+SPACE$(chars%-alen%)
   end if
   LSet$ = a$
END SUB


' the left side of a$ is space padded or truncated to the length of chars%

SUB RSet$(a$, chars%) EXTERNAL
   alen%=Len(a$)
   if alen%>chars% then
      a$=Right$(a$, chars%)   
   else
      a$=SPACE$(chars%-alen%)+a$
   end if
   RSet$ = a$
END SUB


' a$ is centrally space padded or truncated to the length of chars%

SUB Center$(a$, chars%) EXTERNAL
   alen%=Len(a$)
   if alen%>chars% then
      lt% = (alen% - chars%) / 2
      a$=mid$(a$,lt%+1,chars%)
   else
      sn% = chars%-alen%
      ls% = sn% / 2
      rs% = sn% - ls%
      a$=SPACE$(ls%)+a$+SPACE$(rs%)
   end if
   Center$ = a$
END SUB


' The specified number of characters are removed from the right of a$

SUB Rrem$(a$, chars%) EXTERNAL
   Rrem$ = Left$(a$, Len(a$)-chars%)   
END SUB


' The specified number of characters are removed from the left of a$

SUB Lrem$(a$, chars%) EXTERNAL
   Lrem$ = Right$(a$, Len(a$)-chars%)
END SUB


' Strings a number without a leading space

SUB nstr$(num&) EXTERNAL
   nstr$ = mid$(str$(num&), 2)
END SUB


' String flipper.

SUB flip$(a$) EXTERNAL
   v$="" 
   alen%=Len(a$)
   For x%=1 To alen%
      v$=Mid$(a$,x%,1)+v$
   Next x%
   flip$ = v$
END SUB


' Non case sensative version of Instr 

SUB SHORTINT instrNC(src$, find$, p%) EXTERNAL
   instrNC=Instr(p%, Ucase$(src$), Ucase$(find$))
END SUB


' Non case sensative version of Replace$

SUB srepNC$(src$, find$, rep$) EXTERNAL
   p%=1
   flen%=Len(find$)
   rlen%=Len(rep$)
   find$=Ucase$(find$)
   REPEAT
      x%=Instr(p%, Ucase$(src$), find$)
      if x%>0 then
         src$=Left$(src$,x%-1)+rep$+Mid$(src$,x%+flen%)
         p%=x%+rlen%
      end if
   UNTIL x%=0
   srepNC$ = src$
END SUB


' See "#include <ace/strings.h>" for an LCASE$()


