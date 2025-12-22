          PROGRAMS: recursive Gd
   a=. '$.=. 2-0=y.' ; '1'
   b=. 'y. * factorial y.-1'
   factorial=. (a,<b) : ''
   factorial 5
120
   
   d=. '(r,0)+0,r=. binomial y.-1'
   binomial=. (a,<d) : ''
   binomial 4
1 4 6 4 1
   
   f=. 'r,+/_2{.r=. fibonacci y.-1'
   fibonacci=. (a,<f) : ''
   fibonacci 10
1 1 2 3 5 8 13 21 34 55 89
   
   g=. '$.=. 2-0=x.' ; '1'
   h=. 'y.*x. %~x. outof &<:y.'
   outof=. '':(g,<h)
   outof"0/~i. 4
1 1 1 1
0 1 2 3
0 0 1 3
0 0 0 1
