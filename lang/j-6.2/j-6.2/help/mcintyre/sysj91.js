NB.  This file can be used as a script input file to J Version 5.1a.
NB.  September 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

NB. "Language as an intellectual tool:  From hieroglyphics to APL"
NB. IBM Systems Journal, Vol.30, No. 4 (1991) p.554-581

NB. See also:  APL91.JS, DEV.JS, RANK.JS

NB. Set and Query Random Link
   setrl=. 9!:1
   qrl=. 9!:0
   rl=. 7^5
   setrl rl
   qrl 0

NB. p.560
NB. Squares of distances between the 5 items
   ]y=. ?5 3$100
   dsq=. +/"1@*:@((<1 3)&|:)@(-/~)
   ]z=. dsq y

   f=. (<1 3)&|:
   g=. -/~
   dsq=. +/"1@*:@f@g
   z-: dsq y

NB. p.561
   setrl rl
   ] y=. ? 8 4 $ 100

   mean=. +/%#
   dev=. -"1 mean
   NB.  This was formerly   dev=. -mean
   NB.  See "Agreement" Dictionary Version 5, p.6
   NB.  See also APL91.JS, DEV.JS, and RANK.JS
   ip=. +/ .*                 NB. Inner Product
   ss=. +/@*:@dev
   var=. ss % <:@#            NB. Fork
   sd=. %:@var
   sp=. ip~ |:@dev            NB. Hook
   cov=. sp % <:@#            NB. Fork
   cor=. cov % */~@sd         NB. Fork
   cor

   mean y           NB. Mean of the items
   dev y            NB. Deviations from the means
   ss y             NB. Sums of Squares
   var y            NB. Variances
   sd y             NB. Standard Deviations
   sp y             NB. Sums of Products
   cov y            NB. Covariances
   8.2 ": cor y     NB. Correlation of the columns
   8.2 ": cor |:y   NB. Correlation of the rows

NB. p.563
      z=. >.@%@]
      w=. ] - %@z
      f=. i.@0: ` (z , [ f w) @. <:
      1e_16 f 335%336

      w=. ] - >.&.%@]
      f=. i.@0: ` (z , [ f w) @. <:
      1e_16 f 335%336

      f=. i.@0: ` (>.@% @ ] , [f ]->.&.%@]) @.<:
      1e_16 f 335%336
      +/% 1e_8 f o.1

      ch=. %:@-:@-.@%:@-.@*:
      ch 0.5
NB. Using "Under":
      ch=. -:@(%:&.-.)&.*:
      ch 0.5

      6*(2^8)*ch ch ch ch ch ch ch ch 0.5
      6*(2^8)*(ch^:8) 0.5

NB. Explicit definition:
       pi=. '6*(2^y.)*(ch^:y.) 0.5' : ''
       pi 8
       pi"0 n=. 1+i.8

NB. Commentary on Syntax -------------------------------
NB. When a verb is defined with an explicit right argument,
NB. this new verb is monadic and its argument is to the right.
      f=. %&2
      f 6

NB.  noun + adverb gives a verb
      or=. 7 b.
      0 0 1 1 or 0 1 0 1

NB.   verb + (defined) adverb gives a verb
      f=. +:
      a=. 'x. f. ^:' :1
      f a
      3 f a 2

      f=. +:
      c=. ^:
NB.  verb + conjunction gives an adverb
NB.  adverb + noun gives a verb
NB.  In this case it is the inverse verb: halve from double
      f c
      f c _1
      
      x=. 1 2 3
      f c _1 x

NB.  conjunction + noun gives an adverb.  In this case:  inverse
      i=. c _1
      i

NB.  verb + adverb gives a verb;  verb + noun gives a noun
      f i x

NB.  verb + conjunction gives an adverb
NB.  noun + adverb gives a verb
NB.  verb + noun gives a noun

     (+: ^:)
   3 (+: ^:)
   3 (+: ^:) 2
NB. (+:^:) is an adverb -- NOT a hook.
NB. The argument (3) of the adverb is to its left
NB. The argument (2) of the resulting verb is to the right

NB. Returning to Pi ------------------------

      ch^:8 (0.5)
      8 (ch^:) 0.5
      a=. ch^:
      8 a
      8 a 0.5
      (8 a) 0.5
      f=. 8 a
      f
      f 0.5
      chr=. '' : 'x. (ch^:) y.'
      8 chr 0.5
      chr=. '(y. (ch^:)) 0.5' : ''
      chr 8

      pi=. 6&*@(2&^ * chr)     NB.  fork
      pi 8

   test=. [ > >@{.@]             NB.  fork
   body=. (>:@>@{. ; ch@>@{:)@]  NB.  fork
   c=. >@{:@(body^:test&(0;0.5)) NB.  controlled iteration
   c
   pi=. 6&*@(2&^ * c)      NB.  fork
   pi"0 i.9
   
   NB.  Using a gerund with agenda:
   c=. ]`(<:@[ c ch@]) @. ([>0:)
   8 c 0.5
   6*(2^8)*8 c 0.5
   pi=. 6&*@(2&^ * c&0.5)
   pi"0 i.9

NB.  A fuller discussion of this algorithm in J is being completed

NB. p.565
      y=. 10 1000 20000%1200 1 1
      i=. {: * {.
      r=. 1&{ - i
      b=. {: - r
      u=. b,r,i
      f=. u@] , <:@[ ib }: , b @ ]
      g=. 0 3&$@0:
      h=. =0:
      ib=. f`g @. h
      f=. u@],<:@[ ib (}: , b)@]
      ib=. f ` g @. h

      7 8.1 9.2": 12 ib y

      ]m=. i.3 3
      ip=. +/ .*
      ]z=. m ip m ip m
      z-: ip^:3~ m

NB. p.566
      f=. 0&=@(2&|)
      g=. 0&=@(3&|)
      h=. 0&=@(6&|)
      p=. (f *. g) <: h
      *./ p i.30

NB. p.567
      u=. ?5 4 3 $2
      v=. ?3 6 7 $2
      (u~:/ .*.v) -: -.(-.u)=/ .+.(-.v)

      A=. 1 3 2 0, 2 1 0 1,: 4 0 0 2
      B=. 4 1, 0 3, 0 2,: 2 0
      f=. ~:&0
      h=. +/ @ #"0
      (f A) +/ .h B

NB. p.570
      i=. %:_1
      p=. +/ .*
      square=. p~
      
      I=. 1 0,: 0 1
      L=. (i,0),: 0, -i
      M=. 0 _1,: 1 0
      N=. (0,-i),: -i,0
      
      (<-I)-:&.> (square &.> L;M;N), <L p M p N

      p=. +/ .*
      i=. %:_1
      
NB. p.571
      I=. 1 0,:0 1
      s1=. 0 1,: 1 0
      s2=. (0,-i),:(i,0)
      s3=. 1 0,: 0 _1
      z=. 0 1 2|.y=. s1;s2;s3
      
      I -:"2 p~"2 >y
      f=. p-p~
      g=. ({. f 1&{) -: (2*i)&* @ (2&{)
      1 -:"0 g"3 > z
      g"3 > z
      
      f=. p ; - @ p~
      g=. {. (>@f) 1&{
      h=. g -:"2 i&* @ (2&{)
      
      1 1 -:"1 h"3 >z
      f=. p+p~
      g=. {. f (1&{)
      (0 0,: 0 0) -:"2 g"3 >z

      g=. {. f 1&{
      (2 2$0) -:"2 g"3 >z

NB. p.572
      x=. 50 100 %. 10 _7 ,: 7 10
      n=. (1 _1 * x),: |.x
      n +/ .* 10 7
      ]y=. %: +/ *: x
      (180 % o.1)* _2 _1 o. x%y

      rfd=. %&180@o.         NB. Radians From Degrees
      dfr=. rfd^:_1          NB. Degrees From Radians
      f=. 2 2&$ @ (1 _1 1 1&*@ (2 1 1 2&o. @ rfd))
      4":(9.16 * f 28.44) +/ .* 10 7
