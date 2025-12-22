   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk
   
   NB.  Transition matrix for Markov analysis

      s=. 'ABABCB'
      ~.s                NB. Nub
      s=/~.s             NB. Outer product
      (=/~.)s
      =s                 NB. Self classify
      f=. |:@=
      g=. 0&,@f
      g s                NB. Transpose and append zeros
      tm=. '(|:m) +/ .*. 1|.m=. g y.' : ''  NB. Explicit definition
      ]z=. tm s          NB. Transition matrix

      h=. (|: (+/ .*.) 1&|.)@g   NB. Inner parentheses not needed
      z-: h s
      h=. (|: +/ .*. 1&|.)@g
      z-: h s
      ip=. +/ .*         NB.  Inner product
      h=. |: ip 1&|.
      tm=. h@g
      z-: tm s

NB.   A ip B      is the same as    (|:B) ip (|:A)

      p=. 0&,"1@=
      q=. 1&|.@|:
      tm1=. (] ip q)@p    NB.  Fork
      tm1 s
      z-: tm1 s

      z-: (ip q) p s    NB. The Fork can be written as a Hook
      tm2=. (ip q)@p
      z-: tm2 s
      tm f.         NB.   Fork;  2 transpose;  No rank
      tm2 f.        NB.   Hook;  1 transpose;  1 rank
      tm1 f.        NB.   Fork;  1 transpose;  1 rank
