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
NB.  See APL91.JS and DEV.JS

NB.  "Language as an intellectual tool:  From hieroglyphics to APL"
NB.  IBM Systems Journal, Vol.30, No. 4 (1991) p.554-581

NB.  The rule for Agreement was changed in J Version 5.
NB.  Suffix agreement was changed to Prefix agreement (see
NB.  Dictionary of J, Version 5, p.6

NB.  "Agreement:  In the phrase p v q, the arguments of v must
NB.  agree in the sense that their frames (relative to the
NB.  ranks of v) must either match, or one must be the prefix
NB.  of the other."
      p=. i.3 4
      q=. 1 2 3
      ]z=. p%q
NB. Ranks of % are 0,0
NB. Frames of the rank-0 cells of p and q are 3 4 and 3.  Prefix 3.
      -#3
      z-:p%"1 0 q
      z-:p%"_1 q
      
      p=. i.2 3 4
      q=. 2 3
      ]z=. p*q
      z-:q*p    NB. multiplication is commutative
NB. Ranks of * are 0,0
NB. Frames of p and q are 2 3 4 and 2.  Prefix 2.
      z-:p*"2 0 q
      z-:p*"_1 q

      p=. i.2 3 4 5
      q=. i. 2 3
      ]z=. p*q
      z-:p*"2 0 q
      z-:p*"_2 q

      p=. i.2 3 4 5
      q=. i.2 3 4
      ]z=. p*q

NB. Frames of p and q are 2 3 4 5 and 2 3 4.  Prefix 2 3 4
      z-:p*"1 0 q
      z-:p*"_3 0 q
      z-:p*"_3 q

      v=. ,
      p=. i.2 3 4
      q=. -i.5
      ]z=.p v q
NB. Ranks of v are _ _
NB. Frames of p and q are empty

NB. The q is appended to p.   Both are padded for compatibility
      z-:p,"_ q

      q=. -i.2 3
      ]z=. p v q
      z-:p v"_ q

      v=. ,"2 1
      q=. -i.4
      ]z=. p v q

NB. The frames of p and q are 2 and empty
      z-:p v"_1 _ q

      q=. -i.2 5
      ]z=. p v q

NB. The frames of p and q are 2 and 1
      z-:p v"_1 q

      q=. -i.2 3 5
      ]z=. p,"1 q
      z-:p,"_2 q

      q=. -i.2 3
      ]z=. p,"1 0 q
      z-: p,"_2 0 q
      z-: p,"_2 _2 q
      z-: p,"_2 q

      q=. -i.2 3 2
      p,"_2 q
