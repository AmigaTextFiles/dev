t1$="Linear Regression Analysis"
t2$="=========================="

CLS
PRINT t1$
PRINT t2$
PRINT

INPUT "# of (x, y) data: ",n&

DIM x(n&),y(n&)

xavg = 0
yavg = 0

xsum = 0
ysum = 0

FOR t& = 1 TO n&
  CLS
  PRINT t1$
  PRINT t2$
  PRINT
  PRINT "Date";t&
  INPUT "  X: ",x
  x(t&) = x
  xsum = xsum + x
  INPUT "  Y: ",y
  y(t&) = y
  ysum = ysum + y
  PRINT
NEXT t&

xavg = xsum / n&
yavg = ysum / n&

xsum = 0
ysum = 0

FOR t& = 1 TO n&
  xsum = xsum + (y(t&) - yavg) * (x(t&) - xavg)
  ysum = ysum + (x(t&) - xavg)^2
NEXT t&

a = xsum / ysum

b = yavg - a * xavg

xsum = 0
ysum = 0

FOR t& = 1 TO n&
  xsum = xsum + (x(t&) - xavg)^2
  ysum = ysum + (y(t&) - yavg)^2
NEXT t&

r = a * SQR(xsum / ysum)
r2 = r * r

CLS
PRINT t1$
PRINT t2$
PRINT
PRINT "Equation: y  =";a;"x +";b
PRINT "          r  =";r
PRINT "          r2 =";r2

REM r should be close to 1.0

