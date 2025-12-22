/* For append/3 */
:-library(useful).


/* Convert/3 -- Convert all natural positive numbers in input list
                into hex, oct and binary */

convert([],[],[]).

convert([H|T],[HI|TI],Junk) :-
	integer(H),
	H >= 0,
	/* Valid positive integer */
	/* Convert... */
	changebase(2,H,Bin),
	changebase(8,H,Oct),
	changebase(16,H,Hex),
	/* list -> atom */
	name(Binn,Bin),
	name(Octn,Oct),
	name(Hexn,Hex),
	/* Insert into list */
	HI = value(decimal(H),binary(Binn),octal(Octn),hexadecimal(Hexn)),
	convert(T,TI,Junk).

convert([H|T],Ints,[HJ|TJ]) :-
	integer(H),
	H < 0,
	/* The integer is not positive... */
	H = HJ,
	convert(T,Ints,TJ).

convert([H|T],Ints,[HJ|TJ]) :-
	not(integer(H)),
	/* Not an integer */
	H = HJ,
	convert(T,Ints,TJ).


/* changebase/3 -- convert from decimal to base Base 
                   Base would be  2 for decimal -> binary
                                  8     decimal -> octal
                                 16     decimal -> hexadecimal */

changebase(_,0,[48]).

changebase(Base,N,NList) :-
	D is N mod Base,
	N1 is N div Base,
	/* Convert to ascii character */
	toascii(D,X),
	/* recurse */
	changebase(Base,N1,Ds),
	/* Append to list */
	append(Ds,[X],NList).


/* toascii/2 -- Convert the input number to ascii equivalent
                Handles all hex characters */

toascii(D,Output):-
	integer(D),
	D =< 9,
	/* Digit */
	Output is D + 48.

toascii(D,Output):-
	integer(D),
	D >= 10,
	D =< 15,
	/* Hex character */
	Output is D + 87.

