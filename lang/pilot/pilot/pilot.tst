R:                          	TEST
R:
R: This is a test program that contains a number of specific function
R: tests for the Pilot interpreter.  It prompts the user for a particular
R: type of test and then performs the test accordingly.  At the end of
R: each test it returns to the main menu.
R:
R: (C) Copyright 1985, Dave Taylor

*menu
R: keep track of reprompts to redisplay menu every so often...
C: #attempts = 0

T:
 :
 :                          PILOT TEST PROGRAM
 :
 :  This program allows you to test and verify the functionality of the
 :   current pilot interpreter.  If any of the tests fail unexpectedly
 :      then there is some sort of defect in the actual interpreter!
 :
 :  Please select an area you'd like to test out by the associated number:
 : 
 :    1 = Numerical input/output
 :    2 = Mathematical calculations
 :    3 = Conditional expressions
 :    4 = String input/output
 :    5 = String alterations
 :    6 = Looping
 :    7 = Subroutine calls
 :    8 = Invalid and badly structured statements
 :    9 = A conglomeration of the above sections
 :   10 = Quit this program entirely.
*reprompt
 : 
 :  Please enter your choice;
A: $choice

R: sort of case statement...
M : 10
TY:
  : Bye!
EY:
M : 1
JY: *numerical_io
M : 2
JY: *numerical_calc
M : 3
JY: *conditionals
M : 4
JY: *string_io
M : 5
JY: *string_alt
M : 6
JY: *looping
M : 7
JY: *subroutines
M : 8
JY: *bad_statements
M : 9
JY: *conglomeration

T : I can't understand your choice.  Please choose another!
C : #attempts = #attempts + 1
J(#attempts < 3): *reprompt
J : *menu

*numerical_io

T :
  : This routine tests the numerical input and output sections.
  :
  : Warning: if an invalid number is entered it will cause a FATAL
  : error and stop the entire program!!

*num_io_top
  :
  : Please enter a positive, non-zero integer value
A : #positive
T(#positive <= 0): A -> POSITIVE NON-ZERO <- value!!  Try again!
J(#positive <= 0): *num_io_top

*num_io_middle
T : 
  : Now enter the number zero, please...
A : #zero
T(#zero <> 0): -> The number ZERO <- please!!  Try again!
J(#zero <> 0): *num_io_middle

*num_io_bottom
T : 
  : Finally, please enter a negative number
A : #negative
T(#negative >= 0): A -> NEGATIVE <- number, thank you!  Try again!
J(#negative >= 0): *num_io_bottom

T : 
  : Okay, we've got all three numbers now.  Just to make sure I really
  :   did get them all, you entered #positive, #zero, then #negative, 
  :   right?
A : $answer
M : Y y yes YES yup indeed true correct right exactly uh huh
TY: I thought so.  
TN: You aren't telling the truth you silly person!  I'm a computer - I
TN: don't lie ever!! (besides I'd get in trouble if I did from Ma Bell!)
T :
  : Please press <return> when you're ready to go back to the main menu.
A : $answer
J : *menu

*numerical_calc

T :
  : This section tests the calculation ability of the Pilot interpreter.
  : 
  : I'll first ask you for a couple of numbers and then do some amazing
  : (relatively speaking) things with them!  Beware, however, if you 
  : type in an invalid number then I'll just give a FATAL error and stop!
  :
  : Please enter a number
A : #num1 
T :    and another one
A : #num2
T :
  : Okay!  Now let's see...
C : #sum = #num1 + #num2
C : #diff = #num1 - #num2
C : #diff2 = #num2 - #num1
T : #num1 + #num2 = #sum, #num1 - #num2 = #diff and #num2 - #num1 = #diff2
C : #product = #num1 * #num2
C : #value = (#num1+#num1)*(#num2+#num2)
T : #num1 * #num2 = #product, (#num1+#num1)*(#num2+#num2) = #value
C(#num2 <> 0): #div = #num1 / #num2
T(#num2 <> 0): Not only that, but #num1 / #num2 = #div!  Pretty good, eh?
T(#num2 = 0): (I was going to divide, but since the second number is zero it'd 
	    : fail so I'll just forget the division test.  You can still try 
	    : again by re-running this test if you really want to!!) 
T : 
  : Phew!  That's enough math for ANY computer to do at one time!!
  :
  : When you're ready to go back to the main menu press <return>!
A : $answer
J : *menu

*conditionals

T :
  : This section tests the conditional evaluation section of the Pilot
  : interpreter.  As always, if an improperly typed number is entered I
  : will fail with a FATAL error and stop.
  : 
  : You'll be entering three numbers before I start the test...
  : 
  : Enter the first number
A : #num1
T :  the second number
A : #num2
T :  and the third number
A : #num3
T :
  : Okay!  Now we can start some testing!!
  :
  : The following statements should all list valid conditions.  If not, 
  : then the interpreter is incorrectly solving conditionals!!
  : 
T(#num1 < 0) : The first number entered is less than zero
T(#num1 = 0) : The first number is equal to zero
T(#num1 > 0) : The first number is greater than zero
T(#num1 < #num2) : The first number is less than the second number
T(#num1 = #num2) : The first number is equal to the second number
T(#num1 > #num2) : The first number is greater than the second number
T(#num1 < #num2+#num3) : The first number is less than the second + third 
T(#num1 = #num2+#num3) : The first number is equal to the second + third 
T(#num1 > #num2+#num3) : The first number is greater than the second + third 
T(#num1*#num2 < #num3*10) : The first * second is less than the third * 10
T(#num1*#num2 = #num3*10) : The first * second is less than the third * 10
T(#num1*#num2 > #num3*10) : The first * second is less than the third * 10
T(#num1): The first number entered, #num1, is non-zero
T :
  : That's probably enough for now.  Hope it all worked out okay!!
  : 
  : Please press <return> when you're ready to return to the menu.
A : $answer
J : *menu

*string_io
T :
  : This section tests the string input and output routines.
  : 
  : Please enter your first name
A : $first_name
T : Your first name is $first_name?  I find that hard to believe!  Try
  : another name - maybe I'll like it better...
A : $first_name
T : Okay.  I guess $first_name is okay.  I'd rather be called Computer,
  : though.  I guess there's no accounting for tastes, eh?
  : 
  : Please press <return> when you're ready to return to the main menu
A : $answer
J : *menu

*string_alt

T :
  : This section tests the string computation statements.  It's real
  : easy - just enter a word
A : $word1
  : and now another word
A : $word2
C : $normal = $word1 $word2
C : $backwards = $word2 $word1
C : $squashed = $word1$word2
C : $filler = word $word1 is word one and word $word2 is word two.
T :
  : Okay:
  :   one after the other: $normal
  :       backwards order: $backwards
  :              squashed: $squashed
  : and: $filler
  :
  : Wasn't that easy?  Press <return> when you're ready to go back to the menu.
A : $answer
J : *menu

*looping

T :
  : This section tests the looping ability of the program.  What we'll do is
  : count up from one to ten looping each time...beware, though, if your disk
  : is slow this might be a bit tedious!  (see if you can count faster than 
  : me in the meantime!!)
  : 
  : Ready?  Here we go!
C : #value = 1

*counting_loop

T : --- #value ----
C : #value = #value + 1
J(#value<11): *counting_loop
T : 
  : Okay!  That was lots of fun!  Back to the menu now, though, once you 
  : press <return>
A : $answer
J : *menu

*subroutines

T :
  : This section tests the ability of the Pilot interpreter to call and
  : return from subroutines.  If it is working correctly it should output
  :    subroutine 1
  :       subroutine 2
  :    subroutine 1
  :       subroutine 3
  :          subroutine 4
  :    subroutine 1
  : and then be done.  Here we go.....
  :
U : *subroutine1
T :
  : If you got here it must have worked okay!  That's good.
  : When you're ready to continue, please press <return>
A : $answer
J : *menu

*subroutine1

T :   subroutine 1
U : *subroutine2
T :   subroutine 1
U : *subroutine3
T :   subroutine 1
E : 

*subroutine2

T :     subroutine 2
E :

*subroutine3

T :     subroutine 3
U : *subroutine4
E :
 
*subroutine4

T :       subroutine 4
E :

*conglomeration

T: 
 : Rather than a boring test like all the others, this test is 
 : actually a simple game for you to play...
 : 
 : First off, though, please enter a number between -10000 and 10000
A: #seed
T: 
 : Okay!
 : 
 :
 : This is a number guessing game.  The object is for you to guess the number 
 : between 1 and 100 that I've choosen in the minimum guesses.  I'll give you
 : an indication of total guesses + average number of guesses after each turn.
 : 
 : Ready?
 :

*top

U: *select_number
C: #guesses = 0
T: 
 : I've choosen a new number

*guess_loop

T:
T: Your guess?
A: #guess
C: #guesses = #guesses + 1
J(#guess = #number): *correct
T(#guess < #number):
		   : That's too low!  Try again!
T(#guess > #number): 
		   : That's too high!  Try again!
T(#guesses = 3):
	       : Having problems?
T(#guesses = 5):
	       : You getting confused?
T(#guesses = 7):
	       : You're lost, admit it!
T(#guesses = 9):
	       : Keep going - you'll be able to try every number between
               : 1 and 100 at this rate!!
T(#guesses >10):
	       : Why bother?  You're never going to get it at this rate!
J: *guess_loop

*correct

T(#guesses = 1): 
	       : Incredible!  You got it in one Guess!
T(#guesses > 1): 
               : You got it!  In #guesses guesses!
C: #total_guesses = #total_guesses + #guesses
C: #total_games = #total_games + 1
C: #average = #total_guesses / #total_games
T(#total_games > 1):
                   : That's given you an average of #average guesses per turn
T:
 : Would you like to play again?
A: $answer
M: y Y yes YES yup please
TN: 
  : Okay.  Back to the main menu with you!
JN: *menu

J: *top

*select_number

R: This subroutine does some magical stuff to a given seed and
R: generates a number between one and one-hundred, modifying 
R: the seed as it goes along.  It returns it's value in #number.

C(#seed < 0): #seed = #seed * -2
C(#seed = 0): #seed = 4324
C: #seed = #seed * 83 / 5
C: #seed = (#seed-2425)/3

*loop

C(#seed < 1): #seed = #seed*-3+516
C(#seed = 0): #seed = 9543
C(#seed > 100): #seed = #seed/43
J(#seed < 1): *loop
J(#seed > 100): *loop
C: #number = #seed
E:

*bad_statements

R : This is at the end of the program so we don't keep hitting the
R : duplicate label error on the deliberately duplicated label on
R : one of the lines below!

T :
  : This section is going to be a bit different from the others, so stay
  : calm.  We are going to try to generate as many non-fatal error messages
  : as possible...and see if they are dealt with correctly.
  : 
  : Ready or not here we go!
  :
  : The first error should be "Unknown statement"
? : total trash
T : The next error should be "Bad identifier: 'junk'"
A : junk
T : The next error should be "Badly formed instruction"
C
T : The next error should be "duplicate label 'bad_statements'"
*bad_statements
R: T : The next error should be "Name 'nametoolongforme' too long"
R: T : #nametoolongformetodealwithinareasonablefashion
T : The next error should be "Undefined Variable: 'wierd_var'"
T : #wierd_var
T :
  : Ready for some more?  Press <return> when you're ready!
A : $answer
T :
T : The next error should be "Badly formed expression: parenthesis"
C : #num1 = ((4+5
T : The next error should be "Badly formed expression"
C : #num1 = 4+
T : The next error should be "Bad left-hand-side of expression"
C : junk = 2
T : The next error should be "Missing or misplaced '=' in expression"
C : #num1 * 3
T : The next error should be "String variable in numerical expression"
C : #num1= $answer + 3
T : The next error should be "Bad relational expression"
T(#num1:
T :
  : That's all of them!  I hope that wasn't too bewildering!!
  : 
  : When you've recovered enough to want to go back to the main menu
  : please press <return>
A : $answer
J : *menu
