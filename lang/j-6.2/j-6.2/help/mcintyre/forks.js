   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

      vol=. */"1
      ]boxes=. 2 3 4,5 6 7,:8 9 10
      v=. 0 1&|."1
      v boxes
      u=. */
      u v boxes
      u@v boxes      NB. Inherited rank needed!
      area=. +/@+:@u@v
      area=. area f.
      area
      va=. vol,area
      va boxes

      ]t=. ?4 10$100
      mean=. +/ % #
      mean boxes
      mean t
      $t

      max=. >./
      min=. <./
      range=. max-min
      range boxes
      range t          NB. Which column is maximum range?

      r i. max r=. range t
      f=. ] i. max            NB. Fork
      f r

      (i. max) range t        NB. Hook
      maxr=. (i. max)@range   NB. Maximum range
      maxr t

      (maxr t) {"1 t          NB. Column with Maximum Range
      cmr=. {"1~ maxr         NB. Hook
      cmr t
      cmr
      cmr f.
