            SETS: union, etc. Nc
   (even=. 0&=&(2&|))a=. i. 16
1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0
   prime=.'2=+/0=y.|~1+i.y.':''"0
   prime a
0 0 1 1 0 1 0 1 0 0 0 1 0 1 0 0
   (prime a) # a
2 3 5 7 11 13
   a#~(prime*.even)a
2
   a#~(prime>even)a
3 5 7 11 13
   triple=.0&=&(3&|)
   q=. even+.triple
   (q a) # a
0 2 3 4 6 8 9 10 12 14 15
   r=. prime +. even *. triple
   (r a) # a
0 2 3 5 6 7 11 12 13
