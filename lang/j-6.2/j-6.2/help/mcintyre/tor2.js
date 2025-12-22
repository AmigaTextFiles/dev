      qrl=. 9!:0    NB. Query random link
      setrl=. 9!:1  NB. Set random link
      setrl=. 7^5
      qrl 0
      t=. ?4 10$100
      max=. >./
      min=. <./
      (max t) - (min t)
      range=. max - min
      ]r=. range t
      NB. ----------------------------------------
      NB. Column with largest range
      r i. max r
      f=. ] i. max      NB. Fork
      f r
      f@range t

     NB. (g h) y   <->  y g (h y)

      h=. i. max        NB. Hook
      h r
      h@range t
      maxr=. h@range
      maxr t
      cmr=. {~"1 maxr        NB. Hook:   {~"1  dyadic;   maxr monadic
      cmr t
      NB. -----------------------------------

      NB. combining two verbs into one

      u=. -
      v=. %

      NB. Dyadic
      2 u@v 4      NB. Atop
      u (2 v 4)

      2 (u v) 4    NB. Hook
      2 u (v 4)

      2 (u&v) 4    NB. Compose
      (v 2) u (v 4)

NB. Compare:   script=. 0!:2&<      

      NB. Monadic
      (u v) 4
      4 u (v 4)

      (u@v) 4
      u (v 4)

      (u&v) 4   NB. Same as u@v

