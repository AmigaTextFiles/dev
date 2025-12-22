   t=. >;:'NA NA noun verb adverb conjunction other'
   type=. {&t@(4!:0@<)
   type=. type f.

      sin:=.1&o.
      cos=: 2&o.
      tan:=. 3&o.
      sinh:=. 5&o.
      cosh:=. 6&o.
      tanh:=. 7&o.
      SIN:=. sin:@rfd:
      COS:=: cos:@rfd:
      rfd:=. %&180@o.

NB. Iverson's Calculus

      mp:=. +/ .*
      p=. +/@([ * ] ^ i.@#@[) "1 0
      d=. }.@(] * i.@#)
      p:=. (] #. |.@[)"1 0
      VM:=. [ ^/ i.@#@]
      FIT:=. '(<./y.)&{.@(x.f. %. ^/&(i.>./y.))':2

NB. Secant slope and derivatives

      aug=. +&         NB. a <- v c    Augment
      type 'aug'
      upfour=. 4 aug   NB. v <- n a
      type 'upfour'
      upfour i.4

      cube:=. ^&3      NB. v <- v c n

      run=. -~         NB. v <- v a
      1 run 3
      rise=. -~&       NB. a <- v c
      1 *: rise 3      NB. v <- v a

      slope=. SS=. 'x. rise % run':1    NB. Adverb
      type 'slope'
      f=. *: slope     NB. v <- v a
      type 'f'
      1 *: slope 3     NB. v <- v a


   h=. 1
   f=. *:
   x=. i.5
   type 'x'

   AUG=. [. aug      NB. c <- c a
   type 'AUG'
   f2=. h AUG f      NB. v <- n c v
   f2 x

   E=. (]. @ AUG) - ].   NB. c <- c c c   Also c <- c v c
   f3=. 0.01 E *:    NB. v <- n c v
   f3 3              NB. Rise at x 3 for given run 0.01

   S=. ([.(%&))@E    NB. Slope of secant.  Conjunction
   f4=. 0.01 S f     NB. v <- n c v
   0.01 S f x
   type 'S'
   'S' f.
   S=. ([.(%&))@((].@([.(+&)))-].)
   f4 f.

   1e_8 S f x        NB. Approximates derivative
   D=. 1e_8 S        NB. a <- n c    Derivative adverb
    *: D 0 1 2 3 4
   ^&3 D 0 1 2 3 4

NB. Reading (dissecting) S
   S=. ([.(%&))@((].@([.(+&)))-].)
   a1=. +&
   a2=. %&
   S=. ([.a2)@((].@([.a1))-].)   NB. a <- v c
   c1=. [.a1
   c2=. [.a2
   S=. c2@((].@c1)-].)   NB. a <- v c
   c3=. ].@c1
   S=. c2@(c3-].)        NB. c <- c c c
   c4=. c3-].
   S=. c2@c4             NB. c <- c v c    and    v <- c c c
   0.01 S f x            NB. Approximates derivative

NB. Writing S
   S=. ([.(%&))@((].@([.(+&)))-].)
NB. Augment the function argument by the left argument of the conjunction
   0.01 ([.(+&))*: 3
NB. Pass the augmented argument to the function - on the conjunction's right
   0.01 (].@ ([.(+&))) *: 3
NB. Subtract the result of applying the function to its argument
   0.01 ((].@([.(+&)))-].) *: 3
NB. Divide the result by the value of the increment (to the conjunction's left
   z=.([.(%&)) @ ((].@([.(+&)))-].)
   type 'z'
   f=. 0.01 z *:
   type 'f'
   f x

NB. Volumes and Surface Areas of Boxes

   vol=. */
   d=. 2 3 4
   vol d
   ]t=. 2 3 4, 5 6 7,: 8 9 10
   vol=. */"1
   vol t
   h=. 0 1&|.
   g=. */@h
   area=. +/@+:@g"1
   area t
   va=. vol,area
   va t

   r=. %~/"1         NB.  Ratio of Surface Area to Volume
   r@va t
   var=. va,"1 0 r@va
   var t

   v=. ,"1 0
   var=. (va v r@va)
   var t

   var=.(v r)@va
   var t




NB. Identity Matrix
   im=. =@i.
   im 4

NB.  Frequency of characters
   +/"1@= 'three blind mice'

NB. ---------------------------------
