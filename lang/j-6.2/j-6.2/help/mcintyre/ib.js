      iy=. 10    NB. Interest as per cent per year
      p=. 20000  NB. Principal
      pay=. 1000 NB. Monthly payment
      
      ]y=. iy,pay,p % 1200 1 1
      p%1200 1 1
      ]y=. (iy,pay,p) % 1200 1 1
      #y         NB. Tally:  Number of items
      
      0{y        NB. Select from y
      1{y
      2 0 1 0{y  NB. Select several items, repeat, or permute

      {.y        NB. Head
      {:y        NB. Tail

      2{.y       NB. Take
      2}.y       NB. Drop

NB.  Verbs       =. , % ] { {. {:
NB.  Nouns       1200  1  0.5
NB.  Pronouns    y iy pay p

      x=. 99
      x 1}y      NB. Amend y by replacing item 1 by x
      99 1} y    NB. 99 1 is a collective noun!
      (99) 1} y

      v=. 1}     NB. v <- n a    -- } (Amend) is an adverb
      99 v y     NB. v is a verb -- makes a noun from nouns

      }.y        NB. Behead
      }:y        NB. Curtail
      
      i=. {: * {.   NB. Interest paid is  Principal * Rate

      i y        NB. v <- v1 v2 v3   A TRAIN of 3 verbs is a FORK

NB. -----------------------------------------
NB.  x (u v w) y   <->   (x u y) v (x w y)    Dyadic

NB.    (u v w) y   <->     (u y) v   (w y)    Monadic

       u=. +/     NB. Sum of the items
       v=. *:     NB. Square
       w=. -/     NB. Differences of the items
       ]x=. 1 8 3,: 2 4 5
       #x

       ]z=. u v w x     NB. Successive applications of verbs
       z-: u (v (w x))  NB. Match
       g=. u@v@w        NB. Conjunctions of 3 verbs to form one verb
       z-: g x
       z-: u@v@w x
       f=. u v w        NB. A fork composed of three verbs
       f x              NB. Dyadic form of *: is Not-And

       v=. *            NB. Now a result (of sorts!) can be obtained
       ]t=. (u v w) x
       t-: (u x) v (w x)

NB. ------------------------------

      i=. {: * {.   NB. Interest paid is  Principal * Rate
      r=. 1&{ - i   NB. Reduction in Principal (after interest paid)
      b=. {: - r    NB. Balance remaining.  New Principal

      u=. b,r,i     NB. A train of 5 verbs
      i
      u
      u y

      f=. u@],<:@[ ib (2&{. , b)@]    NB. A train of 5 verbs
      f

      g=. 0 3&$@0:
      gerund=. f`g
      # gerund

      h=. =0:
      ib=. gerund @. h
      10.2": 12 ib y     NB. Format table for 12 monthly payments

   tree=. 5!:4 @<   NB. Tree 'exp'
   linear=. 5!:5@<  NB. Linear representation 

NB.     ib
NB.     tree 'ib'
NB.     ibf=. ib f.
NB.     ibf
NB.     tree 'ibf'
NB.     linear 'ibf'
