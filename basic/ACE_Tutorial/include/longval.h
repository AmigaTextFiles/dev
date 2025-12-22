{ This include file is provided as a
  means of overcoming limitations
  inherent in DATA/READ and VAL.

  In the former case, all numeric DATA 
  values are currently stored as single
  precision values by ACE. 

  In the latter case, VAL always
  returns a single-precision result
  since it is not known at compile time
  which numeric type will be represented 
  by a given string. 

  The result in both cases is that when
  a LONG integer value exceeds 8 digits,
  information is lost when the number is
  converted into the single-precision
  format.

  longval&(num$) - Takes a string argument and returns the long integer
		   value represented by the argument. 	

  Author: David J Benn
    Date: 1st,2nd January 1993
}   

SUB spacestripped$(x$)
shortint l,i,s

 '..strip ALL whitespace from x$ 
 '..(VAL does this too).

 y$=""
 i=1
 l=len(x$)

 while i<=l
   s$=mid$(x$,i,1)
   if s$ > " " then y$=y$+s$
   ++i
 wend

 spacestripped$ = y$
END SUB

SUB longval&(num$)
longint l,i,s,sign,num

 '..return the long integer value
 '..represented by num$.

 num$ = spacestripped$(num$)

 '..leading + or - ?
 first$=mid$(num$,1,1) 
 if first$="-" or first$="+" then
   case 
     first$="-" : sign = -1
     first$="+" : sign =  1
   end case
   num$=right$(num$,len(num$)-1)
 else
   sign=1
 end if

 '..get value
 i=1
 l=len(num$)

 repeat 
   s=asc(mid$(num$,i,1))
   num = num*10& + s-asc("0")    
   ++i
 until i>l or s<asc("0") or s>asc("9")
 
 longval& = num*sign
END SUB
  
