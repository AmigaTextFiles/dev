        PROGRAMS: conditional Gb
   p=. '$.=. 1+y.<0'
   q=. 'y. ^ %2'
   r=. '''DOMAIN ERROR'''
   
   conditional=. (p;q;r) : ''
   
   conditional -49
DOMAIN ERROR
   
   conditional 49
7
   
   tozero=.(p;'y.-1';'y.+1') : ''
   
   tozero 3
2
   tozero _3
_2
   tozero "0 (_2 _1 0 1 2 3)
_1 0 _1 0 1 2
