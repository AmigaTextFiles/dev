NB.  This file can be used as a script input file to J Version 5.1a.
NB.  August 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

NB.  Examples of Least Squares curve fitting:

      setrl=. 9!:1              NB. Set Random Link:  setrl 7^5
      qrl=. 9!:0                NB. Query Random Link:  qrl 0

      NB.  y = a + bx + cx^2 + dx^3      Cubic regression

      c=. 4 3 2 1               NB. Coefficients a b c d
      x=. i.10
      ]t=. x ^/ i.4
      ip=. +/ .*
      ]y=. t ip c

      t=. x ^/ i. #c
      y-: t ip c
      y%.t

      t-: x^/ i. 4

      g=. ^/
      h=. i.
      t-: x g (h 4)              NB. Parentheses not required

      NB.  x (p q) y   <->   x p (q y)    Dyadic Hook
      t-: x (g h) 4
      (g h) f.

      f=. ^/ i.
      y %. (x f 4)            NB.  3 arguments.

      ]d=. x,:y               NB.  combine x and y

      NB. x (p q r) y  <->   (x p y) q (x r y)   Dyadic Fork

      ({:d) %. (({.d) f 4)    NB.  Fork
      q=. {.@[ f ]            NB.  Fork
      t-: d q 4
      ({:d) %. (d q 4)
      p=. {:@[ %. q           NB.  Fork
      d p 4                   NB.  Cubic
      d p 3                   NB.  Quadratic
      d p 2                   NB.  Linear
      d p"2 0 ]1 2 3 4 5      NB.  Left rank 2;  Right rank 0

      setrl 7^5
      qrl 0
      e=. y%10                NB. Simulate an error
      s=. (?10#2){1 _1
      ]yobs=. y+s*e           NB. "Observed" y
      ]cobs=. yobs%.t         NB. "Observed" coefficients
      ss=. +/@*:              NB. Sums of Squares
      ss yobs-ypred=. t ip cobs
      ss yobs-ypred=. t ip _14.5729 52.218 _15.1207 2.39503
      ss yobs-ypred=. t ip _14.5729 52.218 _15.1207 2.39
      ss yobs-ypred=. t ip _14.5729 52.218 _15.1207 2.4

      NB.   Multiple regression
      NB.   y = a + bx + cx^2 + dz

      setrl 7^5
      qrl 0
      z=. ?10#100
      t=. x ^/ 0 1 2
      t=. t,"1 0 z
      c=. 4 3 2 5 
      ]y=. t ip c
      y %. t
      e=. y%10                NB. Simulate an error
      s=. (?10#2){1 _1
      ]yobs=. y+s*e           NB. "Observed" y
      ]cobs=. yobs%.t         NB. "Observed" coefficients
      ss yobs-ypred=. t ip c
      ss yobs-ypred=. t ip cobs
      ss yobs-ypred=. t ip _24.2381 8.93109 2.07749 5.35063
      ss yobs-ypred=. t ip _24.2381 8.93109 2.07749 5.35
      ss yobs-ypred=. t ip _24.2381 8.93109 2.07749 5.3
      ss yobs-ypred=. t ip _24.2381 8.93109 2.07749 5.4
