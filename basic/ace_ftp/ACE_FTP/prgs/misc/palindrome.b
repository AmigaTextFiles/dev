{*
** Recursive palindrome program.
**
** Written as a "challenge" (to myself)
** after reading an article on functional
** programming with Scheme to demonstrate
** that one can easily write programs in
** the functional style with ACE. Gee, now
** all I have to do is implement list
** processing and higher order functions. :)
**
** Author: David J Benn
**   Date: 25th April 1995
*}

CONST true = -1&, false = 0&
 
SUB Palindrome(x$)
  IF LEN(x$) <= 1 THEN 
	Palindrome = true
  ELSE
	IF LEFT$(x$,1) = RIGHT$(x$,1) THEN
		Palindrome(MID$(x$,2,LEN(x$)-2))
	ELSE
		Palindrome = false
	END IF	
  END IF
END SUB

IF Palindrome(InputBox$("Enter a string","Palindrome")) THEN
  MsgBox "A palindrome.","OK"
ELSE
  MsgBox "Not a palindrome.","OK"
END IF
