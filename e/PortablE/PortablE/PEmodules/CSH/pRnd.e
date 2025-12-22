/* pRnd.e 25-07-2016
	A random-number generator which is more random than Rnd() on many systems, and unlike Rnd() behaves the same on different systems.
	Copyright (c) 2010, 2011 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

->NOTE: This is an OK random number generator (not as good as rnd())
PROC rndQ(seed) RETURNS num IS rndLSFR1(rndLCG(seed) XOR $19283746)

->NOTE: This is the original rndQ(), which was UNBELIEVABLY TERRIBLE, but I keep here incase someone desperately needs the exact same behaviour...
PROC rndQ_orig(seed) RETURNS num IS rndLSFR1(seed) XOR rndLCG(seed)


->NOTE: This is as good as rnd(), but unlike RndQ(), do NOT pass the return value as the next parameter, instead ONLY pass a value once to initialise it
PROC rndQfull(seed=0) RETURNS num IS IF seed THEN (rndSeed := rndSeed2 := seed XOR $12345678) BUT 0 ELSE (rndSeed := rndLSFR1(rndSeed)) XOR (rndSeed2 := rndLSFR2(rndSeed2))

->NOTE: This seems like a pretty good random number generator
PROC rnd(max) RETURNS num IS IF max < 0 THEN (rndSeed := rndSeed2 := max XOR $12345678) BUT 0 ELSE FastMod(Abs((rndSeed := rndLSFR1(rndSeed)) XOR (rndSeed2 := rndLSFR2(rndSeed2))), max)
/*
PROC rnd(max) RETURNS num
	IF max < 0
		rndSeed  := max XOR $12345678
		rndSeed2 := rndSeed
		num := 0
	ELSE
		rndSeed  := rndLSFR1(rndSeed)
		rndSeed2 := rndLSFR2(rndSeed2)
		num := FastMod(Abs(rndSeed XOR rndSeed2), max)
	ENDIF
ENDPROC
*/

PRIVATE
DEF rndSeed=$12345678, rndSeed2=$12345678

->LCG (linear congruential generator)
PROC rndLCG(seed) RETURNS num IS 69069 * (seed AND $7FFFFFFF) + 362437

->LFSR (linear feedback shift register) using the polynomial x^32 + x^22 + x^2 + x^1 + 1
PROC rndLSFR1(seed) RETURNS num IS (seed SHR (32- 1)) XOR (seed SHR (22- 1)) XOR (seed SHR ( 2-1)) XOR (seed SHR ( 1-1)) AND %1 OR (seed SHL 1)
PROC rndLSFR2(seed) RETURNS num IS (seed SHL (32-32)) XOR (seed SHL (32-22)) XOR (seed SHL (32-2)) XOR (seed SHL (32-1)) AND $80000000 OR (seed SHR 1 AND NOT $80000000)
PUBLIC
