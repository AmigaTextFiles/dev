          PROGRAMS: recursive Gf
   [ a=.3 3$'abcdefghi'
abc
def
ghi
   (f=.i.&# -."1 0 i.&#) a
1 2
0 2
0 1
   <"2 (minors=.f { 1&}."1) a
+--+--+--+
|ef|bc|bc|
|hi|hi|ef|
+--+--+--+
   p=.'$.=. 1+1=#y.'
   q=.'(0{"1 y.)-/ . * det "2 minors y.'
   r=.'0{,y.'
   [ b=.?3 3$9
1 6 4
4 1 0
6 6 8
   (det=.(p;q;r) : '') b
_112
   s=.'(0{"1 y.)+/ . * permanent "2 minors y.'
   (permanent=.(p;s;r) : '') b
320
