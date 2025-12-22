NB.  This file can be used as a script input file to J Version 5.1a.
NB.  August 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

NB.   "Mastering J"  APL91, APL Quote Quad 21#4 (Aug 91) p.264-273

NB.   p.265
   power=. ^
   rotate=. |.
   NB.   mean=. m.   Removed after Version 3.1
   gradeup=. /:
   ip=. +/ .*        NB. space required between / and .
   
NB.  A period (.) preceded by a space is a conjunction
NB.   1 2 3 4 .5 6 7     Gives Domain Error
NB.   3 + .5             Gives Domain Error
   x=. .5
   x
   i.5
   i=. i. 5
   
   x =. .*
   sum=. +/
   ip=. sum x
NB.   A verb was formerly "fixed" in terms of J primitives.
NB.   This is no longer the default;  adverb f. now fixes a verb
   ip
   ip=. ip f.
   ip
   1 2 3 ip 3 4 5
   
   |:5       NB.   This no longer gives a Length Error
NB.  (,5) + i. 4     Still gives a Length Error
   
   setrl=. 9!:1    NB. Set Random Link.   See p.271
   setrl 7^5
   qrl=. 9!:0      NB. Query Random Link.  See p.272
   qrl 0
   ]y=. ?10$100
NB. p.266
   /:y
   y/:y
   sort=. /:~
   sort y

   setrl 7^5
   qrl 0
   y=. 'abcde'{~?12$4
   qrl 0
NB.  The Random Link was set differently for APL QUOTE QUAD
   ]y=. 'abcde'{~?12$4
   sort y
   ~.y
   ~:y
   
   ]a=. i. 2 3 4
   $a
   #$a
   {.$a
   #a
   ]z=. |. a
   z-: |."3 a
   
   |."2 a
   |."1 a
NB. p.267
   x=. i. 5
   y=. i. 5 3
   ]z=. x, "0 1 y
   z-: x,"_1 y
   
   x=. i. 5 2
   ]z=. x,"1 1 y
   z-: x,"1 y
   z-: x,"_1 y
   
   f0=. ,&0"1
   a=. i. 3 2 4
   f0 a
   f0

   
   mean=. +/%#
   mean
NB.   (+/%#) y   is a fork:    (+/ y) % (# y)

   setrl 7^5
   ]y=. ?14$100

   y- (mean y)

NB.  p.268   Note the major change in default for "evoke"
   deviations=. - 'mean'~
   deviations
   
NB.   The default has been changed.  Adverb f. now fixes a verb.
   deviations=. - mean
   deviations
   deviations=. deviations f.
   deviations

   t=. i.5 3
   mean t           NB. mean of items

NB. With respect to rank-0 cells, the frames of t and (mean t)
NB. are 5 3 and 3.   Early Versions of J used SUFFIX "agreement";
NB. Version 5 uses PREFIX "agreement" (Dictionary p.6).
NB. In this example the ranks must therefore be specified:
NB. See also DEV.JS and RANK.JS
   t- mean t             NB. ranks of - are 0 0

   ]z=. t-"1 1 mean t
   dev=. -"1 mean        NB. For rank-2 argument
   z-: dev t
   dev i.2 3 4           NB. Not for rank other than 2
   dev=. -"_1 _ mean     NB. For argument of any rank
   z-: dev t
   dev i.2 3 4           NB. Deviations of ITEMS from ITEM means
   
NB.     (f g h i j k)  is   f (g h (i j k))
   4!:55 ;:'f g h i j k'
   (f g h i j k)

   squares=. *:
   sum=. +/
   ]z=. sum squares deviations y
   ss=. sum @ squares @ deviations
   z-: ss y
   ss=. ss f.
   ss
   z-: ss y
   ss=. 'sum'~ @ ('squares'~) @ ('deviations'~)
   z-: ss y
   ss2=. 'sum'~ @ ('squares'~ @ ('deviations'~))
   z-: ss2 y
   ss2
   
NB. p.269
   ss=. '+/ *: (- (+/ % #)) y.' : ''    NB. Parentheses required
   z-: ss y
   ss=. +/ @ *: @ (- +/%#)
   z-:ss y
   
   ss=. '+/ *: - (+/ % #) y.' : '' NB. Two sets of parentheses required
   ss y
   ss=. '+/ *: - +/ % # y.' : ''
   ss y
   
NB.  Inherited rank has been changed
NB.  Scalar functions now have infinite rank
   setrl 7^5
   x=. ?12 5$100
   colgrade=. /: @ ({"1"_)
   3 colgrade x
   (3 colgrade x){x
   colgrade=. /: @ ({"1)
   3 colgrade x
   
NB.  Scalar verbs are now given infinite rank
   ss=. +/ @ squares
   squares=. ^&2
   ]z=. ss i.10
   squares=. ^&2"0 
   z-: ss i.10
   squares=. ^&2"_
   z-: ss i.10

NB.  power (^:)    cut (;.)   under (&.)  remain the same
NB.  fit (&:)  is now   !.

NB.  p.270
   v=. i. 15
   u=. 15$1 0
   u # v
   
   m=. i. 5 5
   u=. 5$ 1 0
   u#m
   u#"1 m
   
   x=.6 7 8
NB.  u.=1 0 1 0 0 1 0   should be:
   u=.1 0 1 0 0 1 0
   
   u*+/\u
   (u*+/\u){0,x
   
   expand=./:@\:@[{#@[{.]
   expand
   v=.1 0 1 0 1
   b=.6 7 8
   v expand b
   
   b=.i.3 4
   v expand b
   b=.i.3 4 5
   v expand b
   b=.3 4$'abcdef'
   v expand b
   b=.3 4 5$'abcdef'
   v expand b
   
   a=.'abcdefg'
   ]b=.u#a
   ]c=.(-.u)#a
   (/:\:u){b,c
   
   a=. 'sek'
   b=. 'ta'
   u=. 0 1 0 1 0
   (/:\:u){b,a
   
   m=. i. 6 6
   (<3 4){m
   
NB.   x i} m      Amend has been amended !
NB.  Illustrations from Jacobi's method, which requires substitutions
NB.  based on the "pivot" -- the largest absolute value off the diagonal.
   
   m=. i.6 6
   ]i=. 2 2; 2 4; 4 2; 4 4
   x=. 100 101 102 103
   f=. >@[ +/ .* ,&1@#@]
   i f m
   x (i f m)}m
   
   ut=. ,@(</~@i.)@#            NB.  Upper Triangle
   pt=. (, i. >./@(ut # ,))@|   NB.  Pivot in Triangle
   pm=. <.@(pt % #) , # | pt    NB.  Pivot in Matrix
   pa=. 0 0&{ ; ] ; |. ; 1 1&{  NB.  Permutations for amend
   ia=. pa@pm { i.@$            NB.  Indices for Amend
   amend=. ia@]}                NB.  Amend the right argument
   
   setrl 7^5
   ]y=. 50-~ ?6 6$100
   x amend y
   
   p=.  0 0&{ ; ] ; |. ; 1 1&{   NB.  permutations for amend
   ia=. p@pm { i.@$              NB.  indices for amend
   id=. =/~ i.6
   x (ia y)} id
   
NB.  p.271
NB.         b /: > a {"1 b
NB.  '' : 'y. /: > x. {"1 y.'
   
   
NB.  y. /: > x. {"1 y
NB.  (x f y) g (x h y)
   
NB.   > x. }"1 y      ] /: >@({"1) .
   
   SOCe=. '' : 'y. /: > x. {"1 y.'
   SOCt=. ] /: >@({"1)
   
   read=. (1!:1)&<
NB.   x=. read 'c:\s\j3\util.in'

NB.  p.272
NB.  Ravel Items, Raze, and Definition are changed, hence:
   
   x +/ x=. 3 4 5 6
   over=. ({. ; }.)@":@,
   a=. x over x+/x

   h=. ' '&; @ ,.            NB.  Monadic
   g=. ,~"_1                 NB.  Dyadic
   ]z=. a g (h x)
   z-: a (g h) x                 NB. Hook
   by=. (g h)~
   z-: x by a
   by=. (,~"_1 ' '&;@,.)~
   z-: x by x over x+/x
   table=.  '] by ] over ] x.f./ ]':1
   z-: + table x

   NB.  Alternative forms:
   over0=. ({. ; }.)@":@,
   over1=. ,.@({.;}.)@":@,
   by0=. (,~"_1 ' '&;@,.)~
   by1=. ' '&;@,.@[ ,. ]

   table=.  '] by0 ] over0 ] x.f./ ]':1
   z=. + table x
   table=.  '] by0 ] over1 ] x.f./ ]':1
   z-: + table x
   table=.  '] by1 ] over0 ] x.f./ ]':1
   z-: + table x
   table=.  '] by1 ] over1 ] x.f./ ]':1
   z-: + table x

   over0       NB. Contains a fork
   over1       NB. Ravel items changed from ; to ,. (But not needed)
   by0         NB. Hook
   by1         NB. Fork
