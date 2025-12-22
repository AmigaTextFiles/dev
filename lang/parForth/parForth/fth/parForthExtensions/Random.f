include? time&date.f parForthExtensions/time&date.f

ANEW Random.f
 
\ some additions to pForth CHOOSE ******************************************************
10 CELL ARRAY Seeds[]			\ holds good seed numbers to use for repeatable streams
3311 0 Seeds[] ! 2557 1 Seeds[] ! 3575 2 Seeds[] ! 6833 3 Seeds[] ! 3455 4 Seeds[] !
1451 5 Seeds[] ! 6577 6 Seeds[] ! 1397 7 Seeds[] ! 5771 8 Seeds[] ! 4337 9 Seeds[] !

: SEED ( -- n )	\ generate a seed based upon the number of ticks since the start of the day
	MyDateTime _DateStamp
	MyDateTime S@ ds_Minute 60 * 50 *
	MyDateTime S@ ds_Tick + 4337 + 55798 * 237 / ;
	
: RANDOMIZE ( n -- ) \ [-1,-10] is specific stream, 0 is random, [<-10,>0] use n as seed
	1 ? ?DUP 0= IF SEED ELSE DUP -10 0 WITHIN IF 1+ ABS Seeds[] @ THEN THEN Rand-Seed ! ;

: FRANDOM ( -- ) ( F: -- r ) 10000 CHOOSE S>F 10000e0 F/ ; \ floating point random 0<=r<1

