SUB SHORTINT ValBin(a$)
{Converts a  binary number to decimal. The function Trim() is required.}
  a$ = Trim(a$)
  x% = 0
  FOR t% = 1 TO LEN(a$) 
    x% = x% + val(MID$(a$,t%,1)) * 2^(t% - 1)
  NEXT t%
  ValBin = x%
END SUB
