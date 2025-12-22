   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

   linear=. 5!:5@<           NB. Linear representation 
   tree=. 5!:4 @<   NB. Tree 'exp'

   mean=. +/%#
   dev=. -"_1 _ mean
   ss=. +/@*:
   ssdm=. ss@dev
   var=. ssdm % <:@#
   sd=. %:@var

      w=. 12&,
      v=. $&1e9
      u=. +/@?@v@w
      u
      h=. -&6@%&1e9
      g=. h@u
      g=. g f.
      g
      tree 'g'

      f=. {.@] + ({:@] * g@[)
      f
      f=. {.@] + {:@] * g@[
      f
      f g h u v           NB.  Train of 5 verbs
      f=. f f.
      linear 'f'

      gauss=. {.@] + {:@] * -&6@%&1e9@(+/@?@($&1e9)@(12&,))@[

      z=. 100 gauss 10 5
      mean z
      sd z
      