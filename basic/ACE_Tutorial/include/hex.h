'..hexadecimal functions.

#include <stddef.h>

SUB hexdigit(x$)
  if (x$>="A" and x$<="F") or (x$>="0" and x$<="9") then 
    hexdigit=true 
  else 
    hexdigit=false
  end if
END SUB

SUB hex_to_dec&(x$)
longint n,i
longint length
longint legal.digit

  '..converts a hex string 
  '..to a long integer.

  i=1
  n=0
  length=len(x$)

  repeat
    s$=ucase$(mid$(x$,i,1))
    legal.digit=hexdigit(s$)

    if i<=length and legal.digit then 
      n=n*16
      if s$>="A" then 
        n=n+asc(s$)-asc("A")+10
      else
	n=n+asc(s$)-asc("0")
      end if
    end if    
    ++i
  until i>length or not legal.digit

  hex_to_dec& = n
END SUB
