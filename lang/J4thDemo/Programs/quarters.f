\ This is a simple little word that accepts some number of
\ quarters (25 cents) and tells you how many dollars and cents
\ they equate to.
\
\ It simply divides the number of quarters by 4, with remainder.
\
\ The number of times 4 goes into the number of quarters equals
\ the number of dollars.
\
\ The remainder times 25 equals the cents component.
\
\ Mike Haas, for the JForth Demo package.

anew task-Quarters.f

: Quarters  ( numQuarters -- , prints out answer )
 
  \ make sure numbers will be processed in base 10...
 
  decimal
 
  \ Print out how many quarters...
 
  >newline  ( -- numQuarters )
  dup       ( -- numQuarters numQuarters )
  .         ( -- numQuarters )
  
  ." quarters equals $"
 
  \ divide number by 4, with remainder
 
  4 /mod    ( -- numQuarters #dollars )
  
  \ print #dollars without trailing space that normal '.' has...
  
  0 .r      ( -- numQuarters )
  
  \ print the decimal point
  
  ." ."
  
  \ print remaining cents  (with a leading '0' if necessary)
  
  25 *        ( -- #cents )
  dup 10 <    ( -- #cents flag )   \ is it 9 or less?
  IF
     ." 0"
  THEN
  0 .r   cr
;


cr ." 'QUARTERS' compiled...   Try:   74326 quarters" cr cr
