   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB.  VECTOR: The Journal of the British APL Association
NB.  vol. 8, No. 3 (January 1991) p.101-123
NB. p.102-103
      add=. +
      behead=. }.
      copy=. #
      divided_by=. %
      double =. +:
      floor=. <.
      format=. ":
      halve=. -:
      head=. {.
      increm=. >:
      laminate=. .:
      laminate=. ,:
      larger_of=. >.
      left=. [
      lesser_of=. <.
      less_or_equal=. <:
      magnitude=. |
      match=. -:
      minus=. -
      not=. -.
      off=. 0!:55
      one_minus=. -.
      plus=. +
      power=. ^
      reciprocal=. %
      residue=. |
      reverse=. |.
      right=. ]
      show=. ]
      shape=. $
      signum=. *
      tally=. #
      times=. *
      times_pi=. o.
      transpose=. |:
      tree=. 5!:4@<
      wholes=. i.

      cross=. ~
      fix=. f.
      insert=. /
      scan=. \

      atop=. after=. @
      rank=. "
      with=. &

NB. p.104
      quarter=. % with 4
      quarter wholes 12
      f=. >:@i.
      f 6
      1 plus 1 plus 1 plus 1 plus 1
      total=. plus insert
      total 5 copy 1
      total scan 10 copy 1
      2 plus 2 plus 2 plus 2 plus 2 plus 2
      total 6 copy 2
      6 times 2
      2 times 2 times 2 times 2 times 2 times 2
      times insert 6 copy 2

NB. p.105
      2 power 6
      times insert 2 copy 6
      6 power 2
      2 copy cross 6
      2 power~ 6
      show i=. increm wholes 10
      total increm wholes 10
      i plus reverse i
      halve 10 times 11
      total increm wholes 100
      1 2 3+100 99 98
      halve 100 times increm 100
      total increm wholes 1000
      halve 1000 times increm 1000
      halve (times increm) 1000

NB. p.106
      i plus reverse i
      (plus reverse) i
      halve 100 times increm 100
      halve (times increm) 100
      spwn=. halve after (times increm)
      spwn 1000
      # _1 0 1 2 3 4 5

NB. p.107
      (magnitude atop (minus insert)) _2 5
      n=. |@(-/)
      n _2 5
      into=. %~
      nsteps=. into n
      0.5 nsteps _2 5
      nsteps
      nsteps=. nsteps fix
      nsteps
      nsteps=. (( %~ )(| @ ( -/ )))
      0.5 nsteps _2 5

NB. p.108
      nsteps=. %~ |@(-/)
      0.5 nsteps _2 5
     
      list=. 9 3 4 _2 12 1 _4 15 7
      list-<./list
      q=. minus lesser_of insert
      q list
      q=. -<./
      q list
      p=. %>./
      scale=. p@q
      0.3 format scale list

NB. p.109
      y=. 1 2 3 4
      (total y) divided_by (tally y)
      mean=. total divided_by tally
      mean
      tree 'mean'
      mean=. mean fix
      mean
      mean 1 2 3 4
      show y=. 1 10 100 1000 10000 into 1.2345

NB. p.110
      0.01 (less_or_equal magnitude) y
      clean=. right times (less_or_equal magnitude)
      clean
      tree 'clean'
      x=. 0.01
      y=. 1 10 100 1000 10000 into 1.2345
      x clean y
      x clean -y
      f=. right times less_or_equal magnitude
      f
      f=. f fix
      f

NB. p.111
      g=. ]
      h=. *<:|
      x (g h) y
      x g (h y)
      h y
      
      p=. *
      q=. <:
      r=. |
      (p q r) y
      (p y) q (r y)
      r y
      p y
      (* y) <: (|y)
      f=. right times less_or_equal magnitude
      x f y

NB. p.112
      x=. 9 0.5 0 _0.5 _9
      y=. _9 _1.5 _1 _0.5 0 1e_3 0.3 0.4 0.999 1 2 10 100

      over=.({.,.@;}.)@":@,
      by=. ' '&;@,.@[,.]

      x by y over x f"0 1 y

      clean=. ] * (<:|)
      clean

      show i=. wholes 10
      10 plus i

NB. p.113
      nl=. wholes minus floor atop halve
      nl
      nl=. i. - <.@-:
      nl 11
      1 10 100 1000 times"0 1 nl 11

      odd=. plus one_minus@(2&residue)
      odd
      odd=. + -.@(2&|)
      odd
      odd 2 4 6 8 laminate 1 3 5 7

NB. p.114
      nline=. nl@odd
      nline"0 right 12 13
      nline"0 (12 13)
      g=. i.@>.@>:@nsteps
      0.5 g _2 5
      0.5 g _2 5.2

      apv=. {.@] + [*g
      0.5 apv _2 5
      apv=. {.@] + [ * i.@>.@>:@(%~ |@-/)
      0.5 apv _2 5

NB. p.115
      times insert scan 10 10 10 10 10 10
      10 power 1 2 3 4 5 6
      10 power 0 1 2 3 4 5 6
      10 power _4 _3 _2 _1 0 1 2 3 4 5 6
      reciprocal 10 power _4 _3 _2 _1 0 1 2 3 4 5 6
      place=. 10 with power
      place 3
      reverse place wholes 7
      |. 10^ 1 apv _4 4

NB. p.116
      100 *<.0.5+438%100
      10 *<.0.5+26%10
      0.1 *<.0.5+12.345%0.1
      0.2 *<.0.5+12.345%0.2
      round=. '' : 'x. * <. 0.5+ y.%x.'

      0.2 round 12.345
      'x. * <. 0.5+ y.%x.' : 11
      round=. [ * <.@(0.5&+@(%~))
      round
      0.2 round 12.345

NB. p.117
      10 100 1000 round 146464
      y=. 2 4 6 8
      show x=. y round 146463
      x%y
      y=. 3 7 11 15 25 33 125
      show x=. y round 146464
      x%y

      (10^2) * <.0.5+438%10^2
      rdp=. '' : '(10^x.) %~ <. 0.5+ y. * 10^x.'
      0 1 2 3 4 5 rdp o.1
      rdp=. 10&^@[ %~ <.@(0.5&+@((* 10&^)~))
      0 1 2 3 4 5 rdp o.1

NB. p.118
      (10^-i.6) round o.1

      h=. (]*<.@(0.5&+@%)) 10&^
      rnd=. h~
      0 _1 _2 _3 _4 _5 rnd o.1
      x=. i.6
      y=. 146464 14646 1464 146
      table=. (10^x) round"0 1 y
      y by x over transpose table

      table match x rnd"0 1 y
      f=. ] * <.@(0.5&+@%)
      h=. (f 10&^)~
      table -: x h"0 1 y

      n,: 10 round n=. 12 26 165 14 38 43 56 65 97 145 235
      n,: 100 round n=. 170 438 650 160 250 463 729 607 896 717 91 332 548
      10 100 1000 round 8478

NB. p.119
      n=. 8217 4096 7358 6105 8654 5583 7950 6008
      p=. 10 100 1000
      table=. |: p round"0 1 n
      n by p over table
