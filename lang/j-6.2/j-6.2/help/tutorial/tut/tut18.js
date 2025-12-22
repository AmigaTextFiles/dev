          PROGRAMS: iterative Gc
   a=. 'r=. 1 [ $.=. y. # 1'
   b=. 'r=. r * 1+ # $.'
   factorial=. (a;b) : ''
   factorial 5
120
   factorial"0 i. 6
1 1 2 6 24 120
   > a;b
r=. 1 [ $.=. y. # 1
r=. r * 1+ # $.    
   c=. 'r=. (0,r) + (r,0)'
   binomials=. (a;c) : ''
   binomials 4
1 4 6 4 1
   fib=.(a;'r=.r,+/_2{.r') : ''
   fib 10
1 1 2 3 5 8 13 21 34 55 89
   d=. 'r=. 1 [ $.=. x. # 1'
   e=. 'r=. (r*1+y.=.y.-1)%1+#$.'
   outof=. '':(d;e)
   3 outof 5
10
