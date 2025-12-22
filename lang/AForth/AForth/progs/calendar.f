( Calendar Vocabulary)
( based upon material in the book 'The Complete FORTH' by Alan Winfield)
( published by Sigma Technical Press ISBN: 0 905104 22 6)
( amended by Steve Martin for Stratagem4's AFORTH)

DECIMAL
FORTH DEFINITIONS
VOCABULARY calendar
calendar DEFINITIONS

( Zeller's congruence)
VARIABLE Y VARIABLE M VARIABLE D	( Year, Month, Day)

VARIABLE a VARIABLE b	( work variables for jan1st)
: jan1st		( return day of week as a number, 0-6)
	Y @ 1- 100 / a !
	Y @ 1- 100 a @ * - b !
	799 b @ + b @ 4 / + a @ 4 / + 2 a @ * -
	7 MOD ;	( -> n)

( string printing)
: "days"	( weekday string table)
	." Sunday   " ." Monday   " ." Tuesday  " ." Wednesday"
	." Thursday " ." Friday   " ." Saturday " ;

: printday	( print weekday 0-6)
	14 * S->D ' "days" D+ 5 S->D D+ 9 TYPE ;	( n-> )

: "months"	( month string table)
	." January  " ." February " ." March    " ." April    "
	." May      " ." June     " ." July     " ." August   "
	." September" ." October  " ." November " ." December " ;

: printmonth	( print month 0-11)
	14 * S->D ' "months" D+ 5 S->D D+ 9 TYPE ;	( n -> )

( date checking)
CREATE dpmtable		( table of days per month)
	31 C, 28 C, 31 C, 30 C, 31 C, 30 C,
	31 C, 31 C, 30 C, 31 C, 30 C, 31 C,

: leap?		( is year a leap year?)
	Y @ 4	MOD 0=
	Y @ 100 MOD 0= NOT AND
	Y @ 400 MOD 0= OR ;	( -> flag)

: dpm	( return number of days per month)
	DUP S->D dpmtable D+ C@
	SWAP 1 = leap? AND	( add 1 if February and leap year)
	IF 1+ THEN ;		( n1 -> n2)

( Check date within range, all return 'true' if not)
: Ycheck Y @ DUP 1582 < SWAP 4902 > OR ;	( -> flag)
: Mcheck M @ 12 U< NOT ;					( -> flag)
: Dcheck D @ 1- M @ dpm U< NOT ;			( -> flag)
: datecheck
	Ycheck Mcheck Dcheck OR OR
	IF ." Date error" ABORT THEN ;

( daynumber and day)
: C CONSTANT ;

0 C january   1 C february  2 C march     3 C april
4 C may       5 C june      6 C july      7 C august
8 C september 9 C october  10 C november 11 C december

: daynumber	( calculate days up to D/M/Y)
	0 12 0 DO
		M @ I = IF				( loop through months)
					D @ + LEAVE	( until M=I)
				ELSE
					I dpm +		( accumulate days)
				THEN
		LOOP ;					( -> n)

( calculate days of week of date D/M/Y, 0-6)
: D/M/Y jan1st daynumber + 1- 7 MOD ;	( -> n)
: day	( print day of date given)
	Y ! M ! D ! D/M/Y printday ;		( d m y -> )

( month and year)
VARIABLE chars		( character count)
: month	( print specified month)
	Y ! M ! 1 D ! datecheck
	CR M @ printmonth SPACE ." : " Y @ .	( heading)
	CR SPACE ." Sun Mon Tue Wed Thu Fri Sat" CR
	D/M/Y					( calculate 1st day of month)
	4 * DUP SPACES chars !	( go to day column)
	M @ dpm 1+ 1 DO			( step thru days in month)
		I 4 .R 4 chars +!
		chars @ 24 > IF CR 0 chars ! THEN
	LOOP CR CR ;	( m y -> )

: year	( print whole year calendar)
	12 0 DO		( loop thru months)
		I OVER month
	LOOP DROP ;		( y -> )

( yearend and daysleft)
VARIABLE Mend VARIABLE Dend		( current end of year)
: yearend		( initialise end of year)
	OVER OVER 1 = SWAP 29 = AND	( 29th of Feb?)
	IF ." You can't be serious!" ABORT THEN
	Mend ! Dend ! ;			( d m -> )

: daysinY	( how many days in year Y)
	leap? IF 366 ELSE 365 THEN ;	( -> n)

: daysleft	( number of days to year end)
	Y ! M ! D !				datecheck daynumber
	Mend @ M ! Dend @ D !	datecheck daynumber
	OVER OVER > NOT IF ( specified date BEFORE yearend?)
			SWAP - .
		ELSE daysinY SWAP -
			1 Y +! 			datecheck daynumber + .
		THEN ;	( d m y -> )
