   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk
   
   NB. Using J's Boxed Arrays
   NB. VECTOR  Vol. 9#1 (July 1992) 92-105

   NB. Basic Techniques Relating to Boxes.

   ]a=. i.2 3
   $a
   ]b=. <i.2 3
   $b
   ]c=. 'mary';'jones';a; 1 3 5
   $c
   3 1 2 0{c
   ;:s=. 'here we go gathering nuts in may'
   #&.> ;: s
   mean=. +/%#          NB.  Fork
   mean > #&.> ;: s
   mwl=. mean @ (>@(#&.> @ ;:))
   mwl s
   $> ;:s
   > ;:s
   /:~ > ;: s
   sort=. /:~@(>@;:) NB. This is not a Hook.  Parentheses required
   sort s
   v=. 2 3.4 5.67
   <"0 v
   $,. v
   ,. v
   ]m=. i.2 3 4
   <"2 m
   <"1 m

NB. Construct a Simple Database

   d=.,:'E.E.';'McDonnell';'Palo Alto';27;10000; 8 3 12 25 10
   d=.d,'Ken';'Iverson';'Toronto';55;15000; 4 19 32 1 15 10
   d=.d,'Donald';'McIntyre';'U.K.';61;12000;''
   d=.d,'Roger';'Hui';'Toronto';49;20000; 32 4
   d=.d,'Anthony';'Camacho';'U.K.';45;35000; 19 23 45 4 17 13 5
   d

   col=. >@{"1
   locality=. 2&col
   locality d

   name=. 1 [ age=. 3 [ salary=. 4

   sort=. ] /: col          NB.   Fork

   ]n=. name sort d
   ]s=. salary sort d

   name=. 1&col
   n-: (/: name) d          NB.   Hook
   s-: (/: 4&col) d         NB.   Hook

   mean=. +/%#
   mean age col d
   mean salary col d

   each=. &.>
   meanr=. mean each @ (5&{"1)
   meanr d
   sortr=. ] /: > @ meanr          NB.  Fork
   ]z=. sortr d,"1 0 meanr d

   sortr=. /: > @ meanr            NB.  Hook
   z-: sortr d,"1 0 meanr d

   d #~ >(<'Toronto') -: each 2{"1  d
   place=. '' : 'd #~ > (< x.) -: each 2{"1 y.'
   place=. ] #~ > @ (<@[ -: each 2&{"1@])
   place
   'U.K.' place d

NB. Replacement and Insertion

    ir=. ($@[ #. ])"2 1
    x=. 9 8 7 6,:5 4 3 2
    (<x) (d ir 2 5)} d

    i=. 2 5,:4 2
    (x;'London') (d ir i)} d
  
NB. Expansion in General, and a Digression on Reading J

   exp=. /:@\:@[{#@[{.]
   1 0 1 exp 7 8
   exp=. /: @ \: @ [ { # @ [ {. ]
   exp=. /:@\:@[ { #@[ {. ]

   p=. /:@\:@[
   q=. {
   r=. #@[
   s=. {.
   t=. ]
   1 0 1 (p q r s t) 7 8
   f=. p q r s t
   f
   tree=. 5!:4 @ <
   tree 'f'

   exp
   tree 'exp'

NB. Adding New Items to the Database

   ] e=. 1 0 1 1 0 1 1 exp d

   f=. 1&{@$
   g=. i.@f@[
   h=. f@[ * ]
   p=. g + h
   q=. p f.
   q
   row=. q"2 0
   e row 4
   e row 1 4

   x=. 'Bob';'Bernecky';'Toronto';35;22000; 4 5
   ]e=. x (e row 1)} e

   x=.'Graham';'Woyka';'U.K.';62;35000; 14 31 5 7
   ]e=. x (e row 4)} e

x=.('Graham';'Woyka';'U.K.';1;2;3),:'Vin';'Grannell';'Los Angeles';4;5;6 7 8
   
   e=. 1 0 1 1 0 1 1 exp d
   x (e row 1 4) } e

   ]z=. (1 0{x) (e row 1 4)} e
   z-: e (e row 1 4)}~ 1 0{x

   ]y=. 1 0{x
   i=. e row 1 4
   z-: y i} e
   z-: e i}~ 1 0{x
