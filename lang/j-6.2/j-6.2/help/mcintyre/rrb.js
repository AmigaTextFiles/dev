NB.  This file can be used as a script input file to J Version 5.1a.
NB.  August 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

NB. Remove Redundant Blanks and Word Counts.

   s=. 'now is  the  time   for all  good  men '
   u=. s~:' '
NB. Remove all blanks
   u#s
   0 1 2 3#'abcd'    NB. Copy
   1|.u              NB. Rotate
   u +. 1|.u         NB. Or
   (u +. 1|.u)#s

   h=. ~:&' '
   h s
   g=. 1&|.
   g h s
   (h s)+.(g h s)
   ((h s)+.(g h s))#s
   f=. h +.(g@h)     NB. Fork
   (f s)#s
   f=. h +.g@h       NB. Parentheses not needed
   (f s)# s
   f                 NB. Fork

   NB.  (p q) y    <->   y p (q y)    Hook
   NB.  p is dyadic;  q is monadic
   v=. ?10#100
   v- (<./ v)
   (- <./) v

   s #~ (f s)     NB. # is dyadic; f is monadic
   s #~ f s
   p=. #~
   q=. f
   (p q) s        NB. Hook

   rrb=. p q      NB. Name the hook
   rrb s
   rrb=. rrb f.   NB. Fix
   rrb

   rrbx=. #~ ~:&' ' +. 1&|.@~:&' '
   rrbx
   rrbx=. #~ ~:&' ' +. 1&|.@(~:&' ')   NB. Parentheses necessary
   rrbx
   (rrb s) -: rrbx s

   h=. 1&|.@(~:&' ')

   g=. =&' '
   f=. g *: h           NB. Fork
   f s

   h1=. 1&|.@(=&' ')
   g1=. ~:&' '
   f1=. g1 +: h1        NB. Fork
   f1 s
   +/ f1 s
   wc=. +/@f1           NB. Word Count
   wc f.
   wcount=. +/@(~:&' ' +: 1&|.@(=&' '))
   wcount s
   wcount
   #;:s                 NB. Tally after Word Formation  