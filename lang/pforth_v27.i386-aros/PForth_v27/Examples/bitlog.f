\ Bitlog(x) = ~ 8 * ( log2(x) - 1 )
\ Translated by Adam Bricker from C++ into Forth sometime in 2005

: makelog   ( threebits highbit -- bitlog )
    1- 3 lshift + ;
\ Decrement & shift highbits, add threebits

: smallnumber?   dup 8 <= ;
: highbit?       dup 2 >  ;
: threebits?     dup 0 >  ;

: continue?   ( threebits highbit -- threebits highbit flag )
    highbit? >R swap threebits? >R swap R> R> and ;
\ Do not factor out >R and R> or really bad things will happen.

: fixthreebits   ( threebits highbit -- threebits highbit )
    swap  [ hex ]  70000000  [ decimal ]  and 28 rshift swap ;
\  threebits                                  shrink and make highbit TOS

: numbercrunch ( threebits highbit -- threebits highbit )
    1- swap 2* swap ;
\ dec highbit lshift threebits

: cheat   if 2* R> drop then ;
\ take a shortcut for small numbers

: sethighbit   31 ;
: otherwise ;


: bitlog ( n -- n ) smallnumber? cheat otherwise sethighbit
    begin continue? while numbercrunch repeat fixthreebits makelog ;
    
\ for testing purposes
: test [ hex ] ffffffff [ decimal ] 0 do i dup bitlog swap . . cr loop ;

\ these work for gforth but not pforth
\ : test page 175 0 do i dup bitlog at-xy ." *" loop key drop ;
\ : time cr time&date . . . . . . ;
\ : test2 time hex 73FFFF decimal 0 do i bitlog drop loop time ;
