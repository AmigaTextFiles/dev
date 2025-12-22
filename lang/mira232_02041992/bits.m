|| Musterloesung zu Aufgabenzettel 5 , Aufgabe 1 
|| Erstes Semester Informatik, Uni Bremen
||

bits ::=    Null bits | Eins bits | Stop 

to_bits     ::  num -> bits
to_bits 0   = Null Stop
to_bits x   = Null y , x mod 2 = 0
            = Eins y , x mod 2 = 1
              where y = to_bits (x div 2)

bits_num    ::  bits -> num
bits_num Stop       = 0
bits_num (Null x)   = 0 + 2 * (bits_num x)
bits_num (Eins x)   = 1 + 2 * (bits_num x)

myid = bits_num . to_bits

div2        :: bits -> bits
div2 Stop       = Stop
div2 (Null x)   = x
div2 (Eins x)   = x


add         :: bits -> bits -> bits
add Stop x  = x
add x Stop  = x
add (Null x) (Null y) = Null (add x y)
add (Null x) (Eins y) = Eins (add x y)
add (Eins x) (Null y) = Eins (add x y)
add (Eins x) (Eins y) = Null ( add (Eins Stop) (add x y))

mult        :: bits -> bits -> bits
mult Stop x = Stop
mult x Stop = Stop
mult (Null x) y = Null (mult x y )
mult x (Null y) = Null (mult x y )
mult (Eins x) (Eins y) = Eins (add (Null (mult x y)) (add x y))


ulam        :: bits -> bits
ulam (Eins Stop)    = Eins Stop
ulam (Null x)       = ulam x
ulam (Eins x)       = ulam (add (Eins Stop) (mult (Eins (Eins Stop)) (Eins x)))


multbits Stop x = Null Stop
multbits x Stop = Null Stop
multbits (Null Stop) x = Null Stop
multbits x (Eins y) = add ( multbits (Null x) y) x
multbits x (Null y) = multbits (Null x) y

swap [] = []
swap [a] = [a]
swap (x1:x2:xs) = x2:x1:swap xs

inccode x = decode ((code x + 1) mod 128)

deccode x = decode ((code x - 1) mod 128)

ver = map inccode.swap.reverse
ent = reverse.swap.map deccode

text = "u/isvffs!hiujd!omuuffuivtdhfs!cf!bj-josuNbo!fj"
jwe1 = ">*/!//shpf!Kfsgvf!pt!SofFj.!...(-....(..A~"
jwe2 = "o/ufubejbo!Ljf!evs!ooetjs!xje!vo-!j{Rvo!fju!jto!cfMff!o{hbt!Eb"
