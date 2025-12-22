          PROGRAMS: recursive Ge
   a=.'$.=.1+0<n=.x.-1'
   b=.',:2{.y.'
   c=.'(n hanoi 0 2 1{y.),(1 hanoi y.),'
   hanoi =. '':(a;b;c,'n hanoi |.y.')
   2 hanoi 'ABC'
AC
AB
CB
   |: 4 hanoi 0 1 2
0 0 2 0 1 1 0 0 2 2 1 2 0 0 2
2 1 1 2 0 2 2 1 1 0 0 1 2 1 1
   
   |: 'ABC'{~ 4 hanoi 0 1 2
AACABBAACCBCAAC
CBBCACCBBAABCBB
   
   c=.'r=.0#$.=.y.#1+n=.0'
   d=.'r=.r,(n=.1+n),r'
   h=.(c;d) : ''
   h 4
1 2 1 3 1 2 1 4 1 2 1 3 1 2 1
   h 3
1 2 1 3 1 2 1
