   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

      i.10              NB. Integers starting with 0
      integers=. i.     NB. Name the verb
      integers 10
      quarter=. %&4     NB. Conjunction:  verb WITH noun
      quarter integers 10
      j=. >:@i.         NB. Conjunction:  verb ATOP verb
      j 10
      10#1              NB. Copy
      +/10#1            NB. Adverb "insert"
      +/\10#1           NB. Adverb "prefix"
      6#2
      +/6#2
      6*2               NB. Multiplication as successive addition
      */6#2
      2^6               NB. Power as successive multiplication
      */2#6
      2#~6              NB. Adverb "cross"
      2^~6              NB. Power is not commutative

NB. Gauss method for sum of first n integers:
      ]i=. >:i.10       NB. Verb returning its right argument
      +/>:i.10          NB. Sum of integers
      i+|.i             NB. Constant values
      -:10*11           NB. 1- 
      1 2 3 + 100 99 98
      i + (|.i)
      (+|.) i           NB. Hook
      -:100*>:100
      -: 100 * (>:100)
      -: (*>:) 100      NB. Hook
      sumi=. -:@(*>:)   NB. Sum integers
      sumi 100
      sumi 1000
      +/>:i.1000

NB. Go from _2 to 5 by steps of 1:
      # _1 0 1 2 3 4 5
      | -/ _2 5
      n=. |@-/
      n _2 5
      n
      n=. |@(-/)
      n _2 5
      n

NB. Number of steps:
      into=. %~
      0.5 into (n _2 5)       NB. steps of 0.5 from _2 to 5
      nsteps=. into n         NB. Hook
      nsteps _2 5
      0.5 nsteps _2 5
      nsteps
      nsteps=. nsteps f.      NB. Fix the verb
      nsteps


NB. Scale list to the range 0-1:
      setrl 7^5               NB. Set random link
      qrl 0                   NB. Query random link
      from=. -~               NB. Adverb: "cross"
      list=. 20 from ?10#40
      list

      list ,: list - <./ list
      h=. - <./
      list ,; (h list)
      f=. ,: h                NB. Hook
      f list
      f

      g=. %>./                NB. Hook
      scale=. g@h
      scale list
      scale f.

NB. Mean:
      y=. 1 2 3 4
      total=. +/
      tally=. #
      (total y) % (tally y)
      mean=. total % tally    NB. Fork
      mean y
      mean f.
      mean=. +/%#
      mean y
      tree 'mean'

NB. clean:
      x=. 0.01
      ]y=. 1 10 100 _1000 10000 into 1.2345
      0.01 <: | y
NB.  x g (h y)   is the hook     x (g h) y
      h=. <:|                  NB. Hook

      y * (x h y)
      (x ] y) * (x h y)        NB. Fork
      clean=. ] * h
NB. Because both * and h are dyadic, clean cannot be made a hook
      x clean y
      clean f.


      nl=. i. - <.@-:           NB. Fork
      nl
      nl 11
      1 10 100 100 *"0 1 nl 11  NB. Conjunction:  "rank'

NB. Argument for nl should be odd:
      odd=. + -.@(2&|)          NB. Hook
      odd i.10
      odd 1 3 5 7 ,: 2 4 6 8
      nline=. nl@odd
      nline"0 ] 12 13
      nline"0 (12 13)

      g=. i.@>.@>:@nsteps
      0.5 g _2 5
      0.5 g _2 5.2
      0.5 g"0 1 ] _2 5,:_2 5.2        NB. Conjunction: "rank"

NB. Arithmetic Progression Vector
      apv=. {.@] + [*g    NB. Forks.  Both * and g are dyadic
      0.5 apv _2 5
      apv f.
      apv=. ({.@]) + ([ * ((i.@>.)@>:) @ ((%~)((|@-)/)))
      apv=. {.@] + [ * i.@>.@>:@(%~|@-/)
      0.5 apv _2 5
