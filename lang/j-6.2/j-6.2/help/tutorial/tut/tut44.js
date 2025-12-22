         INVERSES AND DUALITY Pa
   cFf=.   '(y.-32) * 5%9':''
   fFc=. '32 + (y. * 9%5)':''
   dc=. 40 -~ 20 * i. 8
   fFc dc
_40 _4 32 68 104 140 176 212
   cFf fFc dc
_40 _20 0 20 40 60 80 100
   % % 1 2 3
1 2 3
   log =.   '10 ^.y.':''
   invlog=. '10 ^ y.':''
   log y=. 24 4 75 7
1.38021 0.60206 1.87506 0.845098
   +/ log y
4.70243
   invlog +/ log y
50400
