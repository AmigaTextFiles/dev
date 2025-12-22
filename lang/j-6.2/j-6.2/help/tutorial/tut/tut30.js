SYMBOLICS: reduction and scan Ka
   o=.'('  [  c=.')'  [  s=.'-'
   minus=. '':'o,x.,c,s,y.'
   'a' minus 'b'
(a)-b
   list=.'defg'
   minus / list
(d)-(e)-(f)-g
   minus /\ list
d            
(d)-e        
(d)-(e)-f    
(d)-(e)-(f)-g
   d,e,f,g=.<:f=.<:e=.<:d=.4
4 3 2 1
   ". minus / list
2
   ". minus /\ list
4 1 3 2
   times=. '':'o,x.,c,''*'',y.'
   list times"0 |. list
(d)*g
(e)*f
(f)*e
(g)*d
