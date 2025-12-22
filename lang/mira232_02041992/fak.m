fak 0       = 1 
fak n       = error "Nur positive Zahlen", n < 0
            = n * fak(n-1) , n > 0 


sums 0       = 0
sums (n+1)   = error "Nur positive Zahlen", (n+1) < 0
             = (n+1) + sums(n) , (n+1) > 0


bits ::= Stop | Null bits | Eins bits

to_bits :: num -> bits
to_bits 0   = Null Stop
to_bits x   = Null y , x mod 2 = 0
            = Eins y , x mod 2 = 1
                where y = to_bits(x div 2)


div2    :: bits -> bits
div2    Stop        = Stop
div2    (Null x)    = x
div2    (Eins x )   = x


add     :: bits -> bits -> bits
add     Stop x              = x
add     x Stop              = x
add     (Null x) (Null y)   = Null (add x y )
add     (Null x) (Eins y)   = Eins (add x y )
add     (Eins x) (Null y)   = Eins (add x y )
add     (Eins x) (Eins y)   = Null (add (Eins Stop)  (add x y) )
    

  