   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB.  Sums of Squares and Inherited Rank
      ]t=. ?4 10$100
      #t

      max=. >./
      min=. <./
      (max t) - (min t)
      range=. max - min     NB. Fork
      range t

      y=. {.t
      e=. 100%~ 1{t
      s=. 50<3{t
      s=. s{1 _1
      e=. e*s
      yobs=. y+e
      ypred=. y

      #y
      #yobs,ypred         NB. Append items
      #yobs,.ypred        NB. Append
      #yobs,:ypred        NB. Laminate

      f=. +/
      g=. *:
      h=. -/
      f g h yobs,:ypred
      ss=. f@g@h

      ss yobs,:ypred
      f g yobs - ypred
      f@g yobs-ypred
      ss=. f@g@-              NB. ATOP    Inherited rank!
      yobs ss ypred
      +/ yobs ss ypred

      ss=. f@g@:-             NB. AT      Infinite rank
      yobs ss ypred
