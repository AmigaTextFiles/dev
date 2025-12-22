NB.  This file can be used as a script input file to J Version 5.1a.
NB.  August 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

NB.  This is intended as further explanation of the reason why
NB.  in Version 5 the verb "dev" (deviations from the mean) is changed
NB.  from the form given in the following:

NB.  "Mastering J"  APL91, APL Quote Quad 21#4 (Aug 91) p.264-273

NB.  "Language as an intellectual tool:  From hieroglyphics to APL"
NB.  IBM Systems Journal, Vol.30, No. 4 (1991) p.554-581

NB.  See also APL91.JS and RANK.JS

NB.  The rule for Agreement was changed in J Version 5.
NB.  Suffix agreement was changed to Prefix agreement (see
NB.  Dictionary of J, Version 5, p.6

NB.  "Agreement:  In the phrase p v q, the arguments of v must
NB.  agree in the sense that their frames (relative to the
NB.  ranks of v) must either match, or one must be the prefix
NB.  of the other."
      p=. i.3 4
      q=. 1 2 3

      p%q
      q%p
NB.  In J Version 4 these required explicit control of rank:
      p%"1 0 q
      q%"0 1 p

NB.  4 5 6 7 is a rank-1 cell of p;  2 is a rank-0 cell of q.
NB.  The ranks of % are 0,0

NB.  Relative to the ranks of %, the frame (the rest of the
NB.  shape vector) of p is 3 4, and the frame of q is 3.
NB.  The frame of q is the _prefix_ of the frame of the p.

      -#3
      (p%q) -: p%"(-#3) q
      (q%p) -: q%"(-#3) p

NB.  In the next example, the frames of p and q (with respect
NB.  to the ranks of *) are 2 3 4 and 2 respectively;  and 2 is
NB.  a prefix of 2 3 4
      p=. i.2 3 4
      q=. 2 3
      ]z=. p*q
      z-: q*p
      z-: p*"2 0 q
      z-: p*"_1 0 q
      z-: p*"_1 _1 q
      z-: p*"_1 q

NB.  In the next example, the frames of p and q (with respect to
NB.  the ranks of *) are 2 3 4 5 and 2 3 respectively;  and 2 3
NB.  is a prefix of 2 3 4 5
      p=. i.2 3 4 5
      q=. i.2 3
      ]z=. p*q
      z-: q*p
      z-: p*"_1 q

NB. mean:  the sum over the items divided by the number of items
      mean=. +/%#
      y=. i.5           NB.  Rank 1
      y - mean y        NB.  Deviations from the mean
      dev=. - mean      NB.  Hook
      dev y

      y=. i.4 5         NB.  Rank 2
      dev y             NB.  Length error
NB.   The reason for the Length Error:
      y - mean y
      $y                NB.  4 items of length 5
      $mean y           NB.  5 items
NB.  The frames of y and mean y (with respect to the ranks of -)
NB.  are 4 5 and 5 respectively;  and 5 is not a PREFIX of 4 5

NB.  When the argument is rank-2, then
     dev=. -"1 mean
     dev y
NB.  For an argument of arbitrary rank:
     dev=. -"_1 _ mean
     dev y

NB.  In Version 4 the frame of the mean of y was a SUFFIX of the
NB.  frame of y

NB.  If we want the deviations from the row means, then:
      dev"1 y           NB.  Apply to the rows of y by explicit rank
      #y                NB.  Number of items
      $y                NB.  Shape
      #$y               NB.  Rank
      mean y
      ]z=. y -"1 1 mean y   NB.  Left rank is (the rank of y)-1
      z-: y -"1 9 mean y    NB.  Right rank is not to exceed stated rank
      z-: y -"1 _ mean y    NB.  _ is infinity
      z-: y -"_1 _ mean y   NB.  frame of right argument is 1 (take items)

      y=. i.3 4 5       NB.  Rank 3
      z=. y -"2 2 mean y
      z-: y -"2 _ mean y
      z-: y -"_1 _ mean y

      y=. i. 2 3 4 5     NB.  Rank 4
      z=. y -"3 mean y
      z-: y -"_1 _ mean y

      dev=. -"_1 _ mean   NB. Generalize for tables of any rank
      dev i.5
      dev i.4 5
      dev i.3 4 5
      dev i.2 3 4 5

      y=. (i.5);(i.4 5);(i.3 4 5);(i.2 3 4 5)
      each=. &.>            NB. c v  is  a
      dev each y            NB. v n  is  n
