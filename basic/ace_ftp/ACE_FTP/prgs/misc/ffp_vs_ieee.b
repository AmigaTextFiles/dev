{*
** A comparison of FFP and IEEE single-precision floating point math.
**
** Requires the presence of mathieeesingbas.library and 
** mathieeesingtrans.library and the appropriate FD files.
**
** Author: David J Benn
**   Date: 14th April 1995
*}

LIBRARY "mathtrans.library"
LIBRARY "mathieeesingbas.library"
LIBRARY "mathieeesingtrans.library"

DECLARE FUNCTION SPTieee LIBRARY mathtrans
DECLARE FUNCTION SPFieee LIBRARY mathtrans
DECLARE FUNCTION IEEESPSub LIBRARY mathieeesingbas
DECLARE FUNCTION IEEESPPow LIBRARY mathieeesingtrans

{*
** Motorola FFP single-precision variables.
*}
SINGLE x,y, a,b, c,d

if argcount <> 2 then
  '..Use Manolis' values.
  x = 1.00
  y = 1.01
else
  '..Use different values (eg. try x = 2, y = 3).
  x = val(arg$(1))
  y = val(arg$(2))
end if
 
{*
** Motorola FFP single-precision subtraction
** and exponentiation.
*}
a = x-y
c = x^y

{*
** IEEE single-precision subtraction and exponentiation.
** Converts x and y to IEEE, applies subtraction or
** exponentiation to them and converts the result to 
** Motorola FFP for printing. The latter may well 
** introduce an FFP-related inaccuracy, depending upon 
** the difference between the IEEE and FFP results.
*}
b = SPFieee(IEEESPSub(SPTieee(x),SPTieee(y)))
d = SPFieee(IEEESPPow(SPTieee(y),SPTieee(x)))

{*
** Display the results.
*}
print TAB(10);"x-y";TAB(30);"x^y"
print TAB(10);"===";TAB(30);"==="
print " FFP: ";TAB(10);a;TAB(30);c
print "IEEE: ";TAB(10);b;TAB(30);d

LIBRARY CLOSE
