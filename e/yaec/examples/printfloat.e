
/* Demoing the new formatcode : \f (YAEC1.9+) */
/* Rounding should work exactly as with EC.. */

/* should print :
default (one decimal) :  4.0 no decimals :  4 three decimals :  4.010
default (one decimal) :  2.8 no decimals :  3 three decimals :  2.775
default (one decimal) :  1.5 no decimals :  2 three decimals :  1.541
default (one decimal) :  0.3 no decimals :  0 three decimals :  0.306
default (one decimal) : -0.9 no decimals : -1 three decimals : -0.928
*/

-> hmm.. it works under WINUAE 8.8.8, but not with later ones..
-> please report if your system prints out the right output.

PROC main()
   DEF a=4.0100:FLOAT -> typeing it will tell operators what to do..
   WHILE a > -1.5
      PrintF('\rdefault (one decimal) : \f[4] '+
             'no decimals : \f.0[2] '+
             'three decimals : \f.3[6]\n',
             a, a, a)
      a := a - 1.23456
   ENDWHILE
ENDPROC

/* When where at it, yaec supports some more formatcodes :

\"   --   inserts a doublequote  (same as \q)
\'   --   inserts a singlequote  (same as \a)
\~   --   inserts NOTHING !      (only for formattingfunctions!)
          example :
          We want to print : <name>[<num>]
          PrintF('\s\~[\d]', name, num)
          Without it, the brackets would be seen as field-specifiers!

*/

