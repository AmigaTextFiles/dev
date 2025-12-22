              SETS: relations Nb
   i=.i.8  [  p=. 2 3 5 7 11
   belongsto=. +./"1 @ (=/)
   i belongsto p
0 0 1 1 0 1 0 1
   e=. belongsto
   p e i
1 1 1 1 0
   c=. -.@v=. e&'aeiou'
   alph=.  'abcdefghijklmno'
   alph=. alph,'pqrstuvwxyz'
   (v alph)#alph
aeiou
   (#~ c) alph
bcdfghjklmnpqrstvwxyz
