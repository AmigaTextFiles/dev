       FUNCTIONAL PROGRAMMING Ma
   bc=. 0&, + ,&0
   bc 1
1 1
   bc bc 1
1 2 1
   bc bc bc 1
1 3 3 1
   q=. '$.=.1,y.#2'
   r=. 'f=. ]' ; 'f=. x.&f f.'
   power=. (q;r) : 2
   bc power 3 (1)
1 3 3 1
   bc ^: 3 (1)
1 3 3 1
   c3=. (0&,+,&0) ^: 3
   c3 1
1 3 3 1
   2&* ^: 3"0 i. 5
0 8 16 24 32
   2&+ ^: 3"0 i. 5
6 7 8 9 10
   g=. *~ : -
   5 g g 4
_11
