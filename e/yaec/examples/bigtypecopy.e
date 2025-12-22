
/* yaec 2.4 -- demoing type-aware assignment */
/* may be dangerous to run :)  -  doesnt output anything anyway */


OBJECT x
   moo
   xxx[5]:ARRAY OF CHAR
   yyy
   zzz
ENDOBJECT


PROC main()
   DEF a[100]:ARRAY OF CHAR, b,
       c[50]:ARRAY OF CHAR, l[20]:LIST,
       x:x, s[10]:STRING, optr:PTR TO x

   a := b -> copy 100 bytes from adr "b" to array "a"

   b := a -> put adr of "a" into "b"

   a := c -> copy 100 bytes from array "c" to array "a"

   c := a -> copy 50 bytes from array "a" to array "c"

   l := b -> ListCopy(l, b, ALL)

   b := l -> put adr of "l" into "b"

   x := b -> copy SIZEOF x bytes from adr "b" into object "x"

   b := x -> put adr of object "x" into b

   s := b -> StrCopy(s, b, ALL)

   b := s -> put adr of string "s" into "b"


   a := [1,2,3,4,5]:CHAR -> copy 100 bytes from static list into array "a"
                         -> an array have a fixed size so we always copy hole size.

   l := [1,2,3,4,5]      -> ListCopy(l, [1,2,3,4,5], ALL)

   s := 'string'         -> StrCopy(s, 'string', ALL)

   b := 'string'         -> get the _adr_ of 'string' into "b"

   x.xxx := a            -> copy 5 bytes from array "a" into array "x.xxx"



   optr[] := optr -> MemCopy(optr, optr, SIZEOF optr) : pretty stupid :)

   x := optr -> copy SIZEOF x from "optr" into "x".

   b := [1,2,3,4,5]:CHAR  -> for below..

   optr[] := [10, b, 20, 30]:x -> figure this one out ! :)


   /* that was some examples */

   /* now You try some */

   /* put Your hand over the ->comments and tell what should happen */

ENDPROC




